/*
 * Copyright (c) 2020 Broadcom.
 * The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.
 *
 * This program and the accompanying materials are made
 * available under the terms of the Eclipse Public License 2.0
 * which is available at https://www.eclipse.org/legal/epl-2.0/
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 *    Broadcom, Inc. - initial API and implementation
 *
 */
package org.eclipse.lsp.cobol.core.engine;

import com.google.inject.Inject;
import com.google.inject.Singleton;
import lombok.NonNull;
import lombok.extern.slf4j.Slf4j;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.tree.ParseTreeListener;
import org.antlr.v4.runtime.tree.ParseTreeWalker;
import org.eclipse.lsp.cobol.core.CobolLexer;
import org.eclipse.lsp.cobol.core.CobolParser;
import org.eclipse.lsp.cobol.core.engine.dialects.DialectOutcome;
import org.eclipse.lsp.cobol.core.engine.dialects.DialectProcessingContext;
import org.eclipse.lsp.cobol.core.engine.dialects.DialectService;
import org.eclipse.lsp.cobol.core.engine.mapping.ExtendedSource;
import org.eclipse.lsp.cobol.core.engine.mapping.TextTransformations;
import org.eclipse.lsp.cobol.core.messages.MessageService;
import org.eclipse.lsp.cobol.core.model.*;
import org.eclipse.lsp.cobol.core.model.tree.CopyNode;
import org.eclipse.lsp.cobol.core.model.tree.EmbeddedCodeNode;
import org.eclipse.lsp.cobol.core.model.tree.Node;
import org.eclipse.lsp.cobol.core.model.tree.NodeType;
import org.eclipse.lsp.cobol.core.model.tree.variables.VariableDefinitionNameNode;
import org.eclipse.lsp.cobol.core.preprocessor.CopybookHierarchy;
import org.eclipse.lsp.cobol.core.preprocessor.TextPreprocessor;
import org.eclipse.lsp.cobol.core.preprocessor.delegates.injector.InjectService;
import org.eclipse.lsp.cobol.core.preprocessor.delegates.util.LocalityMappingUtils;
import org.eclipse.lsp.cobol.core.preprocessor.delegates.util.LocalityUtils;
import org.eclipse.lsp.cobol.core.semantics.CopybooksRepository;
import org.eclipse.lsp.cobol.core.strategy.CobolErrorStrategy;
import org.eclipse.lsp.cobol.core.visitor.CobolVisitor;
import org.eclipse.lsp.cobol.core.visitor.EmbeddedLanguagesListener;
import org.eclipse.lsp.cobol.core.visitor.ParserListener;
import org.eclipse.lsp.cobol.service.AnalysisConfig;
import org.eclipse.lsp.cobol.service.CachingConfigurationService;
import org.eclipse.lsp.cobol.service.SubroutineService;
import org.eclipse.lsp4j.Location;

import java.util.*;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static java.util.Optional.ofNullable;
import static java.util.stream.Collectors.toList;
import static org.eclipse.lsp.cobol.core.model.tree.Node.hasType;
import static org.eclipse.lsp.cobol.core.model.tree.NodeType.EMBEDDED_CODE;


/**
 * This class is responsible for run the syntax and semantic analysis of an input cobol document.
 * Its run method used by the service facade layer CobolLanguageEngineFacade.
 */
@Slf4j
@Singleton
@SuppressWarnings("WeakerAccess")
public class CobolLanguageEngine {

    private static final int PROCESS_CALLS_THRESHOLD = 10;
    private static final String DUPLICATED_DEFINITION_ERROR = "semantics.duplicated";
    private final TextPreprocessor preprocessor;
    private final MessageService messageService;
    private final ParseTreeListener treeListener;
    private final SubroutineService subroutineService;
    private final CachingConfigurationService cachingConfigurationService;
    private final DialectService dialectService;
    private final InjectService injectService;

    @Inject
    public CobolLanguageEngine(
            TextPreprocessor preprocessor,
            MessageService messageService,
            ParseTreeListener treeListener,
            SubroutineService subroutineService,
            CachingConfigurationService cachingConfigurationService,
            DialectService dialectService,
            InjectService injectService) {
        this.preprocessor = preprocessor;
        this.messageService = messageService;
        this.treeListener = treeListener;
        this.subroutineService = subroutineService;
        this.cachingConfigurationService = cachingConfigurationService;
        this.dialectService = dialectService;
        this.injectService = injectService;
    }

    /**
     * Perform syntax and semantic analysis for the given text document
     *
     * @param documentUri    unique resource identifier of the processed document
     * @param text           the content of the document that should be processed
     * @param analysisConfig contains analysis processing features info and copybook config with
     *                       following information: target backend sql server, copybook processing mode which reflect
     *                       the sync status of the document (DID_OPEN|DID_CHANGE)
     * @return Semantic information wrapper object and list of syntax error that might send back to
     * the client
     */
    @NonNull
    public ResultWithErrors<Node> run(
            @NonNull String documentUri, @NonNull String text, @NonNull AnalysisConfig analysisConfig) {
        ThreadInterruptionUtil.checkThreadInterrupted();
        Timing.Builder timingBuilder = Timing.builder();

        timingBuilder.getDialectsTimer().start();
        List<SyntaxError> accumulatedErrors = new ArrayList<>();
        TextTransformations cleanText =
                preprocessor.cleanUpCode(documentUri, text).unwrap(accumulatedErrors::addAll);

        DialectProcessingContext dialectProcessingContext =
                DialectProcessingContext.builder()
                        .copybookConfig(analysisConfig.getCopybookConfig())
                        .programDocumentUri(documentUri)
                        .extendedSource(new ExtendedSource(cleanText))
                        .build();
        dialectProcessingContext.getExtendedSource().commitTransformations();

        DialectOutcome dialectOutcome =
                dialectService
                        .process(analysisConfig.getDialects(), dialectProcessingContext)
                        .unwrap(accumulatedErrors::addAll);

        accumulatedErrors = accumulatedErrors.stream().distinct().collect(toList());
        timingBuilder.getDialectsTimer().stop();

        timingBuilder.getPreprocessorTimer().start();
        injectService.setImplicitCode(dialectOutcome.getImplicitCode());

        List<SyntaxError> preprocessorErrors = new ArrayList<>();
        ExtendedDocument extendedDocument =
                preprocessor
                        .processCleanCode(
                                documentUri,
                                dialectOutcome.getContext().getExtendedSource().extendedText(),
                                analysisConfig.getCopybookConfig(),
                                new CopybookHierarchy())
                        .unwrap(preprocessorErrors::addAll);
        timingBuilder.getPreprocessorTimer().stop();

        // Update copybook usages with proper positions
        extendedDocument
                .getCopybooks()
                .getUsages()
                .forEach(
                        (k, v) -> v.setRange(dialectOutcome.getContext().getExtendedSource().mapLocation(v.getRange()).getRange()));

        // Update copybook definition statements with proper positions
        extendedDocument
                .getCopybooks()
                .getDefinitionStatements()
                .forEach(
                        (k, v) -> v.setRange(dialectOutcome.getContext().getExtendedSource().mapLocation(v.getRange()).getRange()));

        preprocessorErrors.forEach(
                e ->
                        e.getLocality()
                                .setRange(
                                        dialectOutcome
                                                .getContext()
                                                .getExtendedSource()
                                                .mapLocation(e.getLocality().getRange())
                                                .getRange()));
        accumulatedErrors.addAll(preprocessorErrors);

        timingBuilder.getParserTimer().start();
        CobolLexer lexer = new CobolLexer(CharStreams.fromString(extendedDocument.getText()));
        lexer.removeErrorListeners();

        CommonTokenStream tokens = new CommonTokenStream(lexer);
        ParserListener listener = new ParserListener();
        lexer.addErrorListener(listener);

        CobolParser parser = getCobolParser(tokens);
        parser.removeErrorListeners();
        parser.addErrorListener(listener);
        parser.setErrorHandler(new CobolErrorStrategy(messageService));
        parser.addParseListener(treeListener);

        CobolParser.StartRuleContext tree = parser.startRule();
        timingBuilder.getParserTimer().stop();

        timingBuilder.getSplittingLanguageTimer().start();
        Map<Token, EmbeddedCode> embeddedCodeParts = extractEmbeddedCode(listener, tree);
        timingBuilder.getSplittingLanguageTimer().stop();

        timingBuilder.getMappingTimer().start();
        Map<Token, Locality> positionMapping =
                getPositionMapping(
                        documentUri, extendedDocument, tokens, embeddedCodeParts, dialectProcessingContext.getExtendedSource());
        timingBuilder.getMappingTimer().stop();

        timingBuilder.getVisitorTimer().start();
        CobolVisitor visitor =
                new CobolVisitor(
                        applyDialectCopybooks(extendedDocument.getCopybooks(), dialectOutcome),
                        tokens,
                        positionMapping,
                        analysisConfig,
                        embeddedCodeParts,
                        messageService,
                        subroutineService,
                        dialectOutcome.getDialectNodes(),
                        cachingConfigurationService);
        List<Node> syntaxTree = visitor.visit(tree);
        accumulatedErrors.addAll(visitor.getErrors());
        timingBuilder.getVisitorTimer().stop();

        timingBuilder.getSyntaxTreeTimer().start();
        analyzeEmbeddedCode(syntaxTree, positionMapping);

        Node rootNode = syntaxTree.get(0);
        accumulatedErrors.addAll(processSyntaxTree(rootNode));
        accumulatedErrors.addAll(processDuplicates(rootNode));
        timingBuilder.getSyntaxTreeTimer().stop();
        timingBuilder.getLateErrorProcessingTimer().start();
        accumulatedErrors.addAll(finalizeErrors(listener.getErrors(), positionMapping));
        accumulatedErrors.addAll(
                collectErrorsForCopybooks(
                        accumulatedErrors, extendedDocument.getCopybooks().getDefinitionStatements()));
        timingBuilder.getLateErrorProcessingTimer().stop();

        if (LOG.isDebugEnabled()) {
            Timing timing = timingBuilder.build();
            LOG.debug(
                    "Timing for parsing {}. Dialects: {}, preprocessor: {}, parser: {}, mapping: {}, visitor: {}, syntaxTree: {}, "
                            + "late error processing: {}",
                    documentUri,
                    timing.getDialectsTime(),
                    timing.getPreprocessorTime(),
                    timing.getParserTime(),
                    timing.getMappingTime(),
                    timing.getVisitorTime(),
                    timing.getSyntaxTreeTime(),
                    timing.getLateErrorProcessingTime());
        }

        return new ResultWithErrors<>(
                rootNode, accumulatedErrors.stream().map(this::constructErrorMessage).collect(toList()));
    }

    private List<SyntaxError> processDuplicates(Node rootNode) {
        List<SyntaxError> errors = new ArrayList<>();
        Set<String> items = new HashSet<>();
        List<VariableDefinitionNameNode> nodeList = rootNode.getChildren().stream().flatMap(Node::getDepthFirstStream).filter(hasType(NodeType.VARIABLE_DEFINITION_NAME)).map(VariableDefinitionNameNode.class::cast).collect(Collectors.toList());
        nodeList.forEach(item -> {
            if (item.getName() != null) {
                if (items.contains(item.getName())) {
                    SyntaxError error =
                            SyntaxError.syntaxError()
                                    .errorSource(ErrorSource.PARSING)
                                    .suggestion(
                                            messageService.getMessage("semantics.duplicated", item.getName()))
                                    .severity(ErrorSeverity.ERROR)
                                    .locality(item.getLocality())
                                    .build();
                    System.out.println("Error added");
                    errors.add(error);
                } else
                    items.add(item.getName());
            }
        });
        return errors;
    }

    private CopybooksRepository applyDialectCopybooks(
            CopybooksRepository copybooks, DialectOutcome dialectOutcome) {
        dialectOutcome.getDialectNodes().stream()
                .flatMap(Node::getDepthFirstStream)
                .filter(n -> n.getNodeType().equals(NodeType.COPY))
                .map(CopyNode.class::cast)
                .filter(n -> n.getDefinition() != null)
                .forEach(
                        n -> copybooks.define(n.getName(), n.getDialect(), n.getDefinition().getLocation()));
        return copybooks;
    }

    private List<SyntaxError> processSyntaxTree(Node rootNode) {
        List<SyntaxError> errors = new ArrayList<>();
        int processCalls = 0;
        do {
            errors.addAll(rootNode.process());
            processCalls++;
            if (processCalls > PROCESS_CALLS_THRESHOLD)
                throw new IllegalStateException("Infinity loop in tree processing");
        } while (!rootNode.isProcessed());
        return errors;
    }

    private Map<Token, EmbeddedCode> extractEmbeddedCode(
            ParserListener listener, CobolParser.StartRuleContext tree) {
        EmbeddedLanguagesListener embeddedLanguagesListener =
                new EmbeddedLanguagesListener(messageService, treeListener, listener);
        new ParseTreeWalker().walk(embeddedLanguagesListener, tree);
        return embeddedLanguagesListener.getEmbeddedCodeParts();
    }

    CobolParser getCobolParser(CommonTokenStream tokens) {

        ThreadInterruptionUtil.checkThreadInterrupted();
        return new CobolParser(tokens);
    }

    Map<Token, Locality> getPositionMapping(
            String documentUri,
            ExtendedDocument extendedDocument,
            CommonTokenStream tokens,
            Map<Token, EmbeddedCode> embeddedCodeParts,
            ExtendedSource extendedSource) {
        ThreadInterruptionUtil.checkThreadInterrupted();
        Map<Token, Locality> mapping =
                LocalityMappingUtils.createPositionMapping(
                        tokens.getTokens(),
                        extendedDocument.getDocumentMapping(),
                        documentUri,
                        embeddedCodeParts);
        return updateMapping(documentUri, mapping, extendedSource);
    }

    private Map<Token, Locality> updateMapping(
            String documentUri, Map<Token, Locality> mapping, ExtendedSource extendedSource) {
        mapping.forEach(
                (k, v) -> {
                    if (v.getUri().equals(documentUri)) {
                        Location l = extendedSource.mapLocation(v.getRange());

                        v.getRange().setStart(l.getRange().getStart());
                        v.getRange().setEnd(l.getRange().getEnd());
                        v.setUri(l.getUri());
                    }
                });
        return mapping;
    }

    private void analyzeEmbeddedCode(List<Node> syntaxTree, Map<Token, Locality> mapping) {
        syntaxTree.stream()
                .flatMap(Node::getDepthFirstStream)
                .filter(hasType(EMBEDDED_CODE))
                .map(EmbeddedCodeNode.class::cast)
                .collect(toList())
                .forEach(it -> it.analyzeTree(mapping));
    }

    @NonNull
    private List<SyntaxError> finalizeErrors(
            @NonNull List<SyntaxError> errors, @NonNull Map<Token, Locality> mapping) {
        return errors.stream()
                .filter(c -> c.getOffendedToken() != null)
                .map(convertError(mapping))
                .filter(it -> it.getLocality() != null)
                .collect(toList());
    }

    @NonNull
    private Function<SyntaxError, SyntaxError> convertError(@NonNull Map<Token, Locality> mapping) {
        return err ->
                err.toBuilder()
                        .locality(LocalityUtils.findPreviousVisibleLocality(err.getOffendedToken(), mapping))
                        .suggestion(messageService.getMessage(err.getSuggestion()))
                        .errorSource(ErrorSource.PARSING)
                        .build();
    }

    private List<SyntaxError> collectErrorsForCopybooks(
            List<SyntaxError> errors, Map<String, Locality> copyStatements) {
        return errors.stream()
                .filter(shouldRaise())
                .map(err -> raiseError(err, copyStatements))
                .flatMap(List::stream)
                .collect(toList());
    }

    private List<SyntaxError> raiseError(SyntaxError error, Map<String, Locality> copyStatements) {
        return Stream.of(error)
                .filter(shouldRaise())
                .map(
                        err ->
                                err.toBuilder()
                                        .locality(copyStatements.get(err.getLocality().getCopybookId()))
                                        .errorSource(ErrorSource.COPYBOOK))
                .map(SyntaxError.SyntaxErrorBuilder::build)
                .flatMap(err -> Stream.concat(raiseError(err, copyStatements).stream(), Stream.of(err)))
                .collect(toList());
    }

    private Predicate<SyntaxError> shouldRaise() {
        return err -> (err.getLocality() != null && err.getLocality().getCopybookId() != null);
    }

    private SyntaxError constructErrorMessage(SyntaxError syntaxError) {
        return ofNullable(syntaxError.getMessageTemplate())
                .map(messageService::localizeTemplate)
                .map(message -> syntaxError.toBuilder().messageTemplate(null).suggestion(message).build())
                .orElse(syntaxError);
    }
}
