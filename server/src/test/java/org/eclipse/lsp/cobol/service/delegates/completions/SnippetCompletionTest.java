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
package org.eclipse.lsp.cobol.service.delegates.completions;

import com.google.common.collect.ImmutableList;
import com.google.gson.JsonArray;
import org.eclipse.lsp.cobol.core.engine.dialects.daco.DaCoDialect;
import org.eclipse.lsp.cobol.core.engine.dialects.idms.IdmsDialect;
import org.eclipse.lsp.cobol.service.CobolDocumentModel;
import org.eclipse.lsp.cobol.service.SettingsService;
import org.eclipse.lsp.cobol.service.delegates.validations.AnalysisResult;
import org.eclipse.lsp4j.*;
import org.junit.jupiter.api.Test;

import java.util.Arrays;
import java.util.List;

import static java.util.concurrent.CompletableFuture.supplyAsync;
import static org.eclipse.lsp.cobol.service.utils.SettingsParametersEnum.DIALECTS;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.is;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

/** Test to check SnippetCompletion */
class SnippetCompletionTest {
  private static final String INSERT_TEXT = "WRITE ${1:item}";
  private static final String DOCUMENTATION_TEXT = "WRITE item";
  private static final String LABEL = "WRITE";

  private static final String IDMS_INSERT_TEXT =
      "IDMS-CONTROL SECTION.\nPROTOCOL. MODE IS ${1:operating-mode}.";
  private static final String IDMS_DOCUMENTATION_TEXT =
      "IDMS-CONTROL SECTION.\nPROTOCOL. MODE IS operating-mode.";
  private static final String IDMS_DESCRIPTION = "[IDMS] idms-control section";
  private static final String IDMS_LABEL = "IDMS-CONTROL-SECTION";

  private static SettingsService settingsService = mock(SettingsService.class);

  @Test
  void testCompletionEmptyResult() {
    assertThat(
        new SnippetCompletion(new Snippets(settingsService))
            .getCompletionItems("Wr", new CobolDocumentModel("", AnalysisResult.builder().build())),
        is(createExpected()));
  }

  @Test
  void testCompletionNull() {

    SnippetCompletion completion = new SnippetCompletion(new Snippets(settingsService));
    assertThat(completion.getCompletionItems("WR", null), is(createExpected()));
  }

  @Test
  void testCompletionMock() {

    Snippets snippets = new Snippets(settingsService);
    SnippetCompletion completion = new SnippetCompletion(snippets);

    when(settingsService.getConfiguration(DIALECTS.label))
        .thenReturn(supplyAsync(() -> ImmutableList.of()));

    snippets.updateStorage();

    assertEquals(createExpected(), completion.getCompletionItems("wr", MockCompletionModel.MODEL));
    assertEquals(0, completion.getCompletionItems("IDMS", MockCompletionModel.MODEL).size());
    assertEquals(6, completion.getCompletionItems("EXEC", MockCompletionModel.MODEL).size());
    assertEquals(
        ImmutableList.of(), completion.getCompletionItems("GET JOB", MockCompletionModel.MODEL));
  }

  @Test
  void testCompletionIDMSMock() {

    Snippets snippets = new Snippets(settingsService);
    SnippetCompletion completion = new SnippetCompletion(snippets);

    JsonArray dialectSettings = new JsonArray();
    dialectSettings.add(IdmsDialect.NAME);
    List<Object> clientConfig = Arrays.asList(dialectSettings);
    when(settingsService.getConfiguration(DIALECTS.label))
        .thenReturn(supplyAsync(() -> clientConfig));
    snippets.updateStorage();

    assertEquals(createExpected(), completion.getCompletionItems("wr", MockCompletionModel.MODEL));
    assertEquals(1, completion.getCompletionItems("WRITE", MockCompletionModel.MODEL).size());
    assertEquals(
        0, completion.getCompletionItems("WRITE TRANSACTION", MockCompletionModel.MODEL).size());
    assertEquals(
        ImmutableList.of(createIDMSItem()),
        completion.getCompletionItems("IDMS", MockCompletionModel.MODEL));
  }

  @Test
  void testCompletionDaCoMock() {

    Snippets snippets = new Snippets(settingsService);
    SnippetCompletion completion = new SnippetCompletion(snippets);

    JsonArray dialectSettings = new JsonArray();
    dialectSettings.add(DaCoDialect.NAME);
    List<Object> clientConfig = Arrays.asList(dialectSettings);
    when(settingsService.getConfiguration(DIALECTS.label))
        .thenReturn(supplyAsync(() -> clientConfig));
    snippets.updateStorage();
    assertEquals(
        ImmutableList.of(createIDMSItem()),
        completion.getCompletionItems("IDMS", MockCompletionModel.MODEL));
    assertEquals(7, completion.getCompletionItems("EXEC", MockCompletionModel.MODEL).size());
    assertEquals(11, completion.getCompletionItems("GET", MockCompletionModel.MODEL).size());
    assertEquals(1, completion.getCompletionItems("GET JOB", MockCompletionModel.MODEL).size());
  }

  private List<CompletionItem> createExpected() {
    return ImmutableList.of(createItem());
  }

  private CompletionItem createItem() {
    MarkupContent doc = new MarkupContent();
    doc.setValue("```COBOL\n" + DOCUMENTATION_TEXT + "\n```");
    doc.setKind("markdown");
    CompletionItem item = new CompletionItem(LABEL);
    item.setLabel(DOCUMENTATION_TEXT);
    item.setInsertText(INSERT_TEXT);
    item.setInsertTextFormat(InsertTextFormat.Snippet);
    item.setDocumentation(doc);
    item.setDetail(DOCUMENTATION_TEXT);
    item.setKind(CompletionItemKind.Snippet);
    item.setInsertTextMode(InsertTextMode.AdjustIndentation);
    item.setSortText("6" + DOCUMENTATION_TEXT);
    return item;
  }

  private CompletionItem createIDMSItem() {
    MarkupContent doc = new MarkupContent();
    doc.setValue("```COBOL\n" + IDMS_DOCUMENTATION_TEXT + "\n```");
    doc.setKind("markdown");
    CompletionItem item = new CompletionItem(IDMS_LABEL);
    item.setLabel(IDMS_LABEL);
    item.setInsertText(IDMS_INSERT_TEXT);
    item.setInsertTextFormat(InsertTextFormat.Snippet);
    item.setDocumentation(doc);
    item.setDetail(IDMS_DESCRIPTION);
    item.setKind(CompletionItemKind.Snippet);
    item.setInsertTextMode(InsertTextMode.AdjustIndentation);
    item.setSortText("6" + IDMS_LABEL);
    return item;
  }
}
