*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    6

*** Test Cases ***
Get Dataset for CH EDU Bilateral Deal
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    CH_EDU_BILAT    UAT_Deal_Scenarios

Create Drawdown (back date to 4/12/2019)
    Mx Execute Template With Multiple Data    Create Loan Drawdown for CH EDU Bilateral Deal - Outstanding D    ${ExcelPath}    ${rowid}    SERV01_LoanDrawdown