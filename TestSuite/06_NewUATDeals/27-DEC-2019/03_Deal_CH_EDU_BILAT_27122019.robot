*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***

Create Quick Party Onboarding for CH EDU Bilateral Deal - PTY001 
    Mx Execute Template With Multiple Data    Create Deal Borrower Initial Details in Quick Party Onboarding for CH EDU Bilateral Deal    ${CBAUAT_ExcelPath}    1    PTY001_QuickPartyOnboarding
    Mx Execute Template With Multiple Data    Search Customer and Complete Borrower Profile Creation with Default Values for CH EDU Bilateral Deal    ${CBAUAT_ExcelPath}    1    PTY001_QuickPartyOnboarding