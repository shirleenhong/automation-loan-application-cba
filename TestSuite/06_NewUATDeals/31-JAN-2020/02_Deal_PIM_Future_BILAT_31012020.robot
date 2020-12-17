*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
Get Dataset for LBT BILAT
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    PIM_Future_BILAT    UAT_Deal_Scenarios

Early Partial Prepayment $140,000 -SERV23
    [Tags]  01 Paper Clip Payment - SERV23
    Mx Execute Template With Multiple Data    Collect Early Prepayment via Paper Clip For PIM Future BILAT    ${ExcelPath}    ${rowid}    SERV23_LoanPaperClip
