*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    7

*** Test Cases ***
Get Dataset for CH EDU Bilateral Deal
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    CH_EDU_BILAT    UAT_Deal_Scenarios

Create Drawdown (2/19/2020)
    Mx Execute Template With Multiple Data    Create Loan Drawdown for CH EDU Bilateral Deal - Outstanding E    ${ExcelPath}    ${rowid}    SERV01_LoanDrawdown
