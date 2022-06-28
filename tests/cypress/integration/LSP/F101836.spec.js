/**
 * Copyright (c) 2021 Broadcom.
 * The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

 * This program and the accompanying materials are made
 * available under the terms of the Eclipse Public License 2.0
 * which is available at https://www.eclipse.org/legal/epl-2.0/

 * SPDX-License-Identifier: EPL-2.0

 * Contributors:
 *  Broadcom, Inc. - initial API and implementation
 */

import { Theia, VSCODE } from '@eclipse/che-che4z/tests/dist/selectors';

/// <reference types="Cypress" />
//@ts-ignore
/// <reference types="../../support/" />

const env = Cypress.env('ide');
const IDE = env === 'theia' ? Theia : VSCODE;

//F101836 - COBOL LS: Improve user experience and reduce clashing errors by removing BitLang Dependency

function expandOutlineElement(name) {
  if (IDE === Theia) {
    cy.get(`[data-node-id="${name}_0"]`).click();
  } else {
    cy.wait(500).get('.monaco-highlighted-label').contains(name).click();
  }
}

context('This is F101836 spec', () => {
  describe('US683174 Support for Outline view #481', () => {
    it(['smoke'], 'TC250151 Support for Outline view', () => {
      cy.openFile('outline.cbl');
      cy.openOutlineView();
      cy.getOutlineViewTreeContainer().contains('PROGRAM: ABCDEF');

      expandOutlineElement('IDENTIFICATION DIVISION');
      cy.getOutlineViewTreeContainer().contains('PROGRAM-ID ABCDEF');

      expandOutlineElement('DATA DIVISION');

      if (IDE === Theia) {
        cy.get('[id="WORKING-STORAGE SECTION_0"]').click();
      }
      cy.getOutlineViewTreeContainer().contains('PARENT');
      cy.getOutlineViewTreeContainer().contains('COPY AST');

      expandOutlineElement('PROCEDURE DIVISION');
      cy.getOutlineViewTreeContainer().contains('MAINLINE');

      cy.goToLine(18);
      cy.getCurrentLine().type('{end}{leftArrow}{backspace}{backspace}BC', { delay: 200 });
      cy.getOutlineViewTreeContainer().contains('COPY ABC');
    });
  });
});
