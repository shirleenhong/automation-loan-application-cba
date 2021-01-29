*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot


*** Variables ***
${rowid}    6

*** Test Cases ***
Get Dataset for New Life BILAT
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    New_Life_BILAT    UAT_Deal_Scenarios

Rollover and Auto Generate Interest Payment - $204,308,828.54 
    Mx Execute Template With Multiple Data    Rollover and Auto Generate Interest Payment    ${ExcelPath}    ${rowid}    SERV08_ComprehensiveRepricing

Collect Commitment Fee - $52,102.83
    Set Test Variable    ${rowid}    12
    Mx Execute Template With Multiple Data    Collect Commitment Fee Payment For New Life BILAT    ${ExcelPath}    ${rowid}    SERV29_CommitmentFeePayment
