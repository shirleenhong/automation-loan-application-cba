*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot


*** Variables ***
${rowid}    4

*** Test Cases ***
Get Dataset for New Life BILAT
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    New_Life_BILAT    UAT_Deal_Scenarios

Collect Commitment Fee - $50,088.93
    Mx Execute Template With Multiple Data    Collect Commitment Fee Payment For New Life BILAT    ${ExcelPath}    ${rowid}    SERV29_CommitmentFeePayment

Amend Commitment Fee
    Set Test Variable    ${rowid}    5
    Mx Execute Template With Multiple Data    Update Commitment Fee for New Life BILAT    ${ExcelPath}    ${rowid}    SERV29_CommitmentFeePayment

Loan Combine and Rollover for New Life BILAT - $195,819,254.72
    Set Test Variable    ${rowid}    2
    Mx Execute Template With Multiple Data    Loan Combine and Rollover    ${ExcelPath}    ${rowid}    SERV08_ComprehensiveRepricing
