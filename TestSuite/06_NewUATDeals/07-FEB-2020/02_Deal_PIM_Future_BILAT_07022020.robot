*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    2

*** Test Cases ***
Get Dataset for PIM Future BILAT
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    PIM_Future_BILAT    UAT_Deal_Scenarios

Early Prepayment $157,000 for Loan 1
    [Tags]  01 Paper Clip Payment
    Mx Execute Template With Multiple Data    Collect Prepayment for PIM Future BILAT    ${ExcelPath}    ${rowid}    SERV23_LoanPaperClip

Breakcost for Prepayment $157,000 for Loan 1
    [Tags]  02 Breakfunding
    Mx Execute Template With Multiple Data    Break Cost for Early Prepayment for PIM Future BILAT    ${ExcelPath}    ${rowid}    SERV40_BreakFunding
    Set Test Variable    ${rowid}    10
    Mx Execute Template With Multiple Data    Send Event Fee Payment Notice without FFC Validation    ${ExcelPath}    ${rowid}    Correspondence

Collect Interest for Prepaid Portion after Increase for Loan 1
    [Tags]  04 Collect Interest
    Set Test Variable    ${rowid}    2
    Mx Execute Template With Multiple Data    Collect Interest for Prepaid Portion after Increase    ${ExcelPath}    ${rowid}    SERV40_BreakFunding