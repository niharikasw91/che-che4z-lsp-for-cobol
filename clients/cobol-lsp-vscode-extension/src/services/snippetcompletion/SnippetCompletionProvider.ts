/*
 * Copyright (c) 2022 Broadcom.
 * The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.
 *
 * This program and the accompanying materials are made
 * available under the terms of the Eclipse Public License 2.0
 * which is available at https://www.eclipse.org/legal/epl-2.0/
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 *   Broadcom, Inc. - initial API and implementation
 */
import * as vscode from "vscode";
import { LANGUAGE_ID } from "../../constants";
import { SettingsService } from "../Settings";
export class SnippetCompletionProvider implements vscode.CompletionItemProvider {
    private matchingWordsList: vscode.CompletionItem[] = new Array();
    private freshList: vscode.CompletionItem[] = new Array();

    public async provideCompletionItems(document: vscode.TextDocument,
                                        position: vscode.Position,
                                        token: vscode.CancellationToken,
                                        context: vscode.CompletionContext):
        Promise<vscode.CompletionItem[]> {
            this.resetList();
            var textUptoCursor = getCurrentLineText(document, position);
            const firstWord = fetchFirstWord(textUptoCursor);
            if(textUptoCursor.length == 0){
                return fullList(position);
            }
            getSnippetsMapForUserDialect().forEach((value,key) => {
                const prefix: string = value.prefix;
                        const sequenceLength = hasSubsequence(prefix.trimLeft(), textUptoCursor.trim());
                       if(sequenceLength > 0 && prefix.toUpperCase().startsWith(firstWord.toUpperCase())){
                            this.matchingWordsList.push(createCompletionItem(value,key, position));
                        }
                        else
                            this.freshList.push(createCompletionItem(value, key, position));
                });
            return this.matchingWordsList.length > 0 ? this.matchingWordsList:this.freshList;
        }
    resetList() {
        this.matchingWordsList = [];
        this.freshList = [];
    }
}
function createCompletionItem(value: any, key:string, position: vscode.Position): vscode.CompletionItem {
    const bodyDescription: string = value.description;
    const itemLabel: vscode.CompletionItemLabel = {label: value.prefix, description: key};
    const completionItem = new vscode.CompletionItem(itemLabel);
    completionItem.detail = bodyDescription;
    completionItem.insertText = new vscode.SnippetString(value.body.join("\n"));
    completionItem.documentation = new vscode.MarkdownString().appendCodeblock(value.body.join("\n"),LANGUAGE_ID);
    completionItem.kind = vscode.CompletionItemKind.Snippet;
    completionItem.filterText = value.prefix;
    completionItem.sortText = value.prefix;
    // const insertingRange = new vscode.Position(position.line, 7);
    // const replaceRange = new vscode.Position(position.line, position.character);
    // completionItem.range = new vscode.Range(insertingRange,replaceRange);
        return completionItem;
}
function getSnippetsMapForUserDialect() {
    const snippetType =  SettingsService.getSnippetsForUserDialect();
    return new Map(Object.entries(snippetType));
}

function hasSubsequence(prefix: string, text: string) {
    const matrix = Array(prefix.length + 1).fill(0).map(() => Array(text.length + 1).fill(0));
    for(let i = 1; i < prefix.length + 1; i++) {
        for(let j = 1; j < text.length + 1; j++) {
            if(prefix[i-1] === text[j-1]) {
                matrix[i][j] = 1 + matrix[i-1][j-1];
            } else {
                matrix[i][j] = Math.max(matrix[i-1][j], matrix[i][j-1]);
            }
        }
    }
    return matrix[prefix.length][text.length];
}

function fetchFirstWord(text: string) {
    const wordsList =  text.split(/(\s+)/).filter( function(e) { return e.trim().length > 0; } );
   return  wordsList[0];
}

function getCurrentLineText(document: vscode.TextDocument, position: vscode.Position) {
    return document.lineAt(position).text.slice(0,position.character).trim();
}

function fullList(position): vscode.CompletionItem[] | PromiseLike<vscode.CompletionItem[]> {
    const list: vscode.CompletionItem[] = new Array();
    getSnippetsMapForUserDialect().forEach((value,key) => {
        list.push(createCompletionItem(value,key,position));
    });
    return list;
}

