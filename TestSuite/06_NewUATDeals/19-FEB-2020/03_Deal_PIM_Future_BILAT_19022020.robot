*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    3

*** Test Cases ***
Get Dataset for PIM Future BILAT
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    PIM_Future_BILAT    UAT_Deal_Scenarios

Create New Loan $100,000 - Loan 3
    [Tags]  03 Create New Loan
    Mx Execute Template With Multiple Data    Create Initial Loan Drawdown for PIM Future BILAT    ${ExcelPath}    ${rowid}    SERV01_LoanDrawdown
    Set Test Variable    ${rowid}    11
    Mx Execute Template With Multiple Data    Send a Drawdown Intent Notice via Notice Application without FFC Validation    ${ExcelPath}    ${rowid}    Correspondence
    Set Test Variable    ${rowid}    12
    Mx Execute Template With Multiple Data    Send Notice via Notice Application without FFC Validation        ${ExcelPath}    ${rowid}    Correspondence