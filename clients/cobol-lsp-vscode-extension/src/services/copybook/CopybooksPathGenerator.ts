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

import * as path from "path";
import * as vscode from "vscode";
import { C4Z_FOLDER, COPYBOOKS_FOLDER } from "../../constants";
import { SettingsService } from "../Settings";

export class CopybooksPathGenerator {

    public async listUris(): Promise<vscode.Uri[]> {
        const result: vscode.Uri[] = [];
        const profile: string = SettingsService.getProfileName();
        if (profile) {
            for (const dataset of await this.listDatasets()) {
                const uri: vscode.Uri = vscode.Uri.file(createDatasetPath(profile, dataset));
                result.push(uri);
            }
        }
        return result;
    }

    public async listDatasets(): Promise<string[]> {
        return SettingsService.getDsnPath();
    }

    public async listUSSPaths(): Promise<string[]> {
        return SettingsService.getUssPath();
    }
}

export function createCopybookPath(profileName: string, dataset: string, copybook: string): string {
    const rootPath = vscode.workspace.workspaceFolders[0].uri.fsPath;
    const copybookDirPath = path.join(rootPath, C4Z_FOLDER, COPYBOOKS_FOLDER, profileName, dataset);
    return path.join(copybookDirPath, copybook + ".cpy");
}

export function createDatasetPath(profileName: string, dataset: string): string {
    const rootPath = vscode.workspace.workspaceFolders[0].uri.fsPath;
    return path.join(rootPath, C4Z_FOLDER, COPYBOOKS_FOLDER, profileName, dataset);
}

export function checkWorkspace(): boolean {
    if (vscode.workspace.workspaceFolders.length === 0) {
        vscode.window.showErrorMessage("No workspace folder opened.");
        return false;
    }
    return true;
}
