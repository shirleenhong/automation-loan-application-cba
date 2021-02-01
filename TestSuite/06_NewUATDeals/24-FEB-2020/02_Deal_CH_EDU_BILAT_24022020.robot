*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    2

*** Test Cases ***
Get Dataset for CH EDU Bilateral Deal
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    CH_EDU_BILAT    UAT_Deal_Scenarios

LVR change to 41.35%
    Mx Execute Template With Multiple Data    Update Leverage Ratio for CH EDu Bilateral Deal    ${ExcelPath}    ${rowid}    AMCH04_DealChangeTransaction

Create Drawdown (2/24/2020)
    Set Test Variable    ${rowid}    8
    Mx Execute Template With Multiple Data    Create Loan Drawdown for CH EDU Bilateral Deal - Outstanding F    ${ExcelPath}    ${rowid}    SERV01_LoanDrawdown
