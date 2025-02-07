*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
Get Dataset for ATM BILAT
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    ATM_BILAT    UAT_Deal_Scenarios

Rollover with Increase for Facility ATM (Net Increase and Interest Cashflow to Borrower)
    Set Test Variable    ${rowid}    2 
    Mx Execute Template With Multiple Data    Create Rollover and Generate Interest Payment for ATM BILAT    ${ExcelPath}    ${rowid}    SERV08_ComprehensiveRepricing