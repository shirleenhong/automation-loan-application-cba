*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***

Get Dataset for LLA Syndicated Deal
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    LLA_SYND    UAT_Deal_Scenarios

Facility Extension
    Mx Execute Template With Multiple Data    Update Facility Expiry and Maturity Date Through FCT    ${ExcelPath}    ${rowid}    CRED02_FacilitySetup
    Mx Execute Template With Multiple Data    Update Borrowers External Credit Rating History    ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup
    Mx Execute Template With Multiple Data    Create PCT for Pricing Matrix    ${ExcelPath}    ${rowid}    AMCH06_PricingChangeTransaction

Charge facility extension fee
    Mx Execute Template With Multiple Data    Charge Upfront Fee for LLA Syndicated Deal    ${ExcelPath}    ${rowid}    CRED07_UpfrontFee_Payment
    Set Test Variable    ${rowid}    11
    Mx Execute Template With Multiple Data    Send Notice by Notice Application    ${ExcelPath}    ${rowid}    Correspondence

Rollover and Additional Drawdown
    Mx Execute Template With Multiple Data    Create Comprehensive Repricing for LLA Syndicated Deal    ${ExcelPath}    ${rowid}    SERV08_ComprehensiveRepricing
    Set Test Variable    ${rowid}    7
    Mx Execute Template With Multiple Data    Send Notice for Loan Repricing    ${ExcelPath}    ${rowid}    Correspondence
    Set Test Variable    ${rowid}    8
    Mx Execute Template With Multiple Data    Send Notice for Loan Repricing    ${ExcelPath}    ${rowid}    Correspondence
    Set Test Variable    ${rowid}    9
    Mx Execute Template With Multiple Data    Send Notice for Loan Repricing    ${ExcelPath}    ${rowid}    Correspondence
    Set Test Variable    ${rowid}    10
    Mx Execute Template With Multiple Data    Send Notice for Loan Repricing    ${ExcelPath}    ${rowid}    Correspondence

Early Partial Prepayment $50M for Outstanding B
    Mx Execute Template With Multiple Data    Collect Early Prepayment via Paper Clip For LLA Syndicated Deal    ${ExcelPath}    ${rowid}    SERV23_LoanPaperClip
    Set Test Variable    ${rowid}    12
    Mx Execute Template With Multiple Data    Send Notice by Notice Application    ${ExcelPath}    ${rowid}    Correspondence
    Set Test Variable    ${rowid}    13
    Mx Execute Template With Multiple Data    Send Notice by Notice Application    ${ExcelPath}    ${rowid}    Correspondence
    Mx Execute Template With Multiple Data    Process Incoming Cash Movements Outside of Transaction Notebooks    ${ExcelPath}    ${rowid}    MTAM13_ManualCashflow_Incoming
    Mx Execute Template With Multiple Data    Process Outgoing Cash Movements Outside of Transaction Notebooks    ${ExcelPath}    ${rowid}    MTAM14_ManualCashflow_Outgoing
    