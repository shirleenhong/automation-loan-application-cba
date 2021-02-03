*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot


*** Variables ***
${rowid}    5

*** Test Cases ***
Get Dataset for New Life BILAT
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    New_Life_BILAT    UAT_Deal_Scenarios

Rollover and Principle Repayment for New Life BILAT - $2,860,426.18 
    Mx Execute Template With Multiple Data    Rollover and Principle Repayment    ${ExcelPath}    ${rowid}    SERV08_ComprehensiveRepricing

Collect Commitment Fee - $44,823.17
    Set Test Variable    ${rowid}    10
    Mx Execute Template With Multiple Data    Collect Commitment Fee Payment For New Life BILAT    ${ExcelPath}    ${rowid}    SERV29_CommitmentFeePayment

Amend Commitment Fee
    Set Test Variable    ${rowid}    11
    Mx Execute Template With Multiple Data    Update Commitment Fee for New Life BILAT    ${ExcelPath}    ${rowid}    SERV29_CommitmentFeePayment