*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    2

*** Test Cases ***
Get Dataset for LBT BILAT
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    PIM_Future_BILAT    UAT_Deal_Scenarios

Early Prepayment $157,000
    [Tags]  01 Paper Clip Payment
    Mx Execute Template With Multiple Data    Collect Prepayment for PIM Future BILAT    ${ExcelPath}    ${rowid}    SERV23_LoanPaperClip

Breakcost for Prepayment $157,000
    [Tags]  02 Breakfunding
    Mx Execute Template With Multiple Data    Break Cost for Early Prepayment for PIM Future BILAT    ${ExcelPath}    ${rowid}    SERV40_BreakFunding
    Set Test Variable    ${rowid}    10
    Mx Execute Template With Multiple Data    Send Event Fee Payment Notice without FFC Validation    ${ExcelPath}    ${rowid}    Correspondence