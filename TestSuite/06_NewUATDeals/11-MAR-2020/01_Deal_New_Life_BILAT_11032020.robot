*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    3

*** Test Cases ***
Get Dataset for New Life BILAT
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    New_Life_BILAT    UAT_Deal_Scenarios

Create Initial Loan Drawdown - $6,300,000.00
    Mx Execute Template With Multiple Data    Create Initial Loan Drawdown for New Life BILAT    ${ExcelPath}    ${rowid}    SERV01_LoanDrawdown