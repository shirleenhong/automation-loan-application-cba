*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***

Get Dataset for LLA Syndicated Deal
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    LLA_SYND    UAT_Deal_Scenarios

Combine B1&C and Rollover
    Set Test Variable    ${rowid}    2
    Mx Execute Template With Multiple Data    Create Loan Merge for Outstanding B1 and C for LLA Syndicated Deal    ${ExcelPath}    ${rowid}    SERV08_ComprehensiveRepricing
    Set Test Variable    ${rowid}    14
    Mx Execute Template With Multiple Data    Send Notice for Loan Repricing    ${ExcelPath}    ${rowid}    Correspondence
    Set Test Variable    ${rowid}    15
    Mx Execute Template With Multiple Data    Send Notice for Loan Repricing    ${ExcelPath}    ${rowid}    Correspondence
    Set Test Variable    ${rowid}    16
    Mx Execute Template With Multiple Data    Send Notice for Loan Repricing    ${ExcelPath}    ${rowid}    Correspondence
    Set Test Variable    ${rowid}    17
    Mx Execute Template With Multiple Data    Send Notice for Loan Repricing    ${ExcelPath}    ${rowid}    Correspondence

Fee Period 1/1/2020 - 1/4/2020
    Set Test Variable    ${rowid}    2
    Mx Execute Template With Multiple Data    Manual Adjustment of Line Fee for LLA Syndicated Deal    ${ExcelPath}    ${rowid}    SERV29_PaymentFees
    Mx Execute Template With Multiple Data    Update Facility Fee Expiry Date for LLA Syndicated Deal    ${ExcelPath}    ${rowid}    SERV29_PaymentFees
    