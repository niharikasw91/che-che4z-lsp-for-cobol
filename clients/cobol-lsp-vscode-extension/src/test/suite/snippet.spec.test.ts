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

import * as assert from 'assert';
import * as helper from './testHelper';
import * as vscode from "vscode";

suite('Integration Test Suite', () => {

    suiteSetup(async function () {
        this.timeout(30000);
        helper.updateConfig('idms.json');
        this.timeout(30000);
        await helper.activate();
    });
    let editor: vscode.TextEditor;
    test('Autocompletion with IDMS dialect', async () => {
        await helper.showDocument("SNIPPET.CBL");
        editor = helper.get_editor("SNIPPET.CBL");
        await helper.sleep(5000);
        await helper.insertString(editor, new vscode.Position(1, 0), "   COPY");
        await vscode.commands.executeCommand('editor.action.triggerSuggest', editor.document.uri);
        await helper.sleep(1000);
        await helper.executeCommandMultipleTimes('selectNextSuggestion', 1)
        await helper.sleep(1000);
        await vscode.commands.executeCommand('acceptSelectedSuggestion');
        await helper.sleep(1000);
        const text = editor.document.getText();
        const acceptedLine = text.split('\n')[4];
       assert.ok(text,"   COPY IDMS idms-entity.");
    }).timeout(10000).slow(4000);

    test('Autocompletion basic dialect', async () => {
        await helper.showDocument("IDMS.CBL");
        editor = helper.get_editor("IDMS.CBL");
        helper.updateConfig('basic.json');
        await helper.sleep(5000);
        await helper.insertString(editor, new vscode.Position(2, 0), "   COPY");
        await vscode.commands.executeCommand('editor.action.triggerSuggest', editor.document.uri);
        await helper.sleep(1000);
        await helper.executeCommandMultipleTimes('selectNextSuggestion', 1)
        await helper.sleep(1000);
        await vscode.commands.executeCommand('acceptSelectedSuggestion');
        await helper.sleep(1000);
        const text = editor.document.getText();
        const acceptedLine = text.split('\n')[4];
       assert.strictEqual(text,"   COPY");
    }).timeout(10000).slow(4000);

    test('TC152058 Autocompletion basic dialect', async () => {
        await helper.showDocument("BASIC.cbl");
        editor = helper.get_editor("BASIC.cbl");
        helper.updateConfig('basic.json');
        await helper.sleep(5000);
        await helper.insertString(editor, new vscode.Position(40, 0), "           A");
        await vscode.commands.executeCommand('editor.action.triggerSuggest', editor.document.uri);
        await helper.sleep(1000);
        await helper.executeCommandMultipleTimes('selectNextSuggestion', 5)
        await vscode.commands.executeCommand('acceptSelectedSuggestion');
        await editor.edit(edit => edit.replace(editor.selection, "1"));
        await helper.sleep(1000);
        await vscode.commands.executeCommand("jumpToNextSnippetPlaceholder");
        await editor.edit(edit => edit.replace(editor.selection, "str"));
        await helper.sleep(1000);
        const text = editor.document.getText();
        const acceptedLine = text.split('\n')[40];
        assert.ok(acceptedLine.includes("ADD 1 TO str"),
            "Checks auto complete functionality, also with navigation by snippets");
    }).timeout(10000).slow(4000);

})
