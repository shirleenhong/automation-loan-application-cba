*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
Facility Extension
    Mx Execute Template With Multiple Data    Update Facility Expiry and Maturity Date Through FCT    ${ExcelPath}    ${rowid}    CRED02_FacilitySetup
    Mx Execute Template With Multiple Data    Update Borrowers External Credit Rating History    ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup
    Mx Execute Template With Multiple Data    Create PCT for Pricing Matrix    ${ExcelPath}    ${rowid}    AMCH06_PricingChangeTransaction
    
Rollover and Additional Drawdown
    Mx Execute Template With Multiple Data    Create Comprehensive Repricing for LLA Syndicated Deal    ${ExcelPath}    ${rowid}    SERV08_ComprehensiveRepricing
    Set Test Variable    ${rowid}    7
    Mx Execute Template With Multiple Data    Send Intent Notice for Loan Repricing    ${ExcelPath}    ${rowid}    Correspondence
    Set Test Variable    ${rowid}    8
    Mx Execute Template With Multiple Data    Send Intent Notice for Loan Drawdown    ${ExcelPath}    ${rowid}    Correspondence