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
 *   Broadcom, Inc. - initial API and implementation
 */
import * as vscode from "vscode";
import {QUICKFIX_GOTOSETTINGS} from "../constants";

export class CopybooksCodeActionProvider implements vscode.CodeActionProvider {

    public async provideCodeActions(doc: vscode.TextDocument,
                                    range: vscode.Range | vscode.Selection,
                                    context: vscode.CodeActionContext,
                                    token: vscode.CancellationToken,
    ): Promise<Array<vscode.Command | vscode.CodeAction>> {
        // TODO: From context we could get the number of diagnostic probl.
        // TODO: Add telemetry when user click on quickfix (without select any other option)
        if (!this.shouldHaveCodeAction(context)) {
            return [];
        }

        // TODO: Add quickfix action for a command.. (wrap in custom command?)
        const goToSettings = new vscode.CodeAction(QUICKFIX_GOTOSETTINGS, vscode.CodeActionKind.QuickFix);
        goToSettings.command = {
            command: "workbench.action.openSettings",
            title: QUICKFIX_GOTOSETTINGS,
            arguments: ["broadcom-cobol-lsp"],
        };
        return [goToSettings];
    }

    private shouldHaveCodeAction(context: vscode.CodeActionContext): boolean {
        if (!context.diagnostics || context.diagnostics.length < 1) {
            return false;
        }

        for (const d of context.diagnostics) {
            if (d.code === "MISSING_COPYBOOK") {
                return true;
            }
        }
        return false;
    }
}
