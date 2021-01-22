*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    3

*** Test Cases ***
Get Dataset for PIM Future BILAT
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    PIM_Future_BILAT    UAT_Deal_Scenarios

Early Prepayment $230,000 for Loan 1
    [Tags]  01 Paper Clip Payment
    Mx Execute Template With Multiple Data    Collect Prepayment for PIM Future BILAT    ${ExcelPath}    ${rowid}    SERV23_LoanPaperClip
