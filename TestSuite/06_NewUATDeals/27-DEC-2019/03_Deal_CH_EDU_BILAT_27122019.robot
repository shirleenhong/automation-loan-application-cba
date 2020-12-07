*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***

Create Quick Party Onboarding for CH EDU Bilateral Deal - PTY001 
    Mx Execute Template With Multiple Data    Create Deal Borrower Initial Details in Quick Party Onboarding for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding
    Mx Execute Template With Multiple Data    Search Customer and Complete Borrower Profile Creation with Default Values for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding

Establish Deal with LVR Effective 30/6/2019
    Mx Execute Template With Multiple Data    Setup Deal for CH EDU BILAT Deal    ${ExcelPath}    ${rowid}    CRED01_DealSetup

Establish Capitalisation Facility
    Mx Execute Template With Multiple Data    Create Capitalisation Facility for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    CRED02_FacilitySetup_A

Establish Commitment Fee
    Mx Execute Template With Multiple Data    Setup Commitment Fee for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup_A