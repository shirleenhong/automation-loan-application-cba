*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
Get Dataset for LBT BILAT
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    PIM_Future_BILAT    UAT_Deal_Scenarios

Early Partial Prepayment $140,000 - SERV23
    [Tags]  01 Paper Clip Payment - SERV23
    Mx Execute Template With Multiple Data    Collect Early Prepayment via Paper Clip For PIM Future BILAT    ${ExcelPath}    ${rowid}    SERV23_LoanPaperClip
    Set Test Variable    ${rowid}    6
    Mx Execute Template With Multiple Data    Send Notice via Notice Application without FFC Validation    ${ExcelPath}    ${rowid}    Correspondence

Break Cost for Early Prepayment $140,000 - SERV40
    [Tags]  02 Breafunding - SERV40
    Mx Execute Template With Multiple Data    Break Cost for Early Prepayment for PIM Future BILAT    ${ExcelPath}    ${rowid}    SERV40_BreakFunding
    Set Test Variable    ${rowid}    7
    Mx Execute Template With Multiple Data    Send Event Fee Payment Notice without FFC Validation    ${ExcelPath}    ${rowid}    Correspondence

Create New Loan $323.82 - SERV01
    [Tags]  03 Create New Loan $323.82 - SERV01
    Set Test Variable    ${rowid}    2
    Mx Execute Template With Multiple Data    Create New Loan Drawdown for PIM Future BILAT    ${ExcelPath}    ${rowid}    SERV01_LoanDrawdown
    Set Test Variable    ${rowid}    8
    Mx Execute Template With Multiple Data    Send a Drawdown Intent Notice via Notice Application without FFC Validation    ${ExcelPath}    ${rowid}    Correspondence
    Set Test Variable    ${rowid}    9
    Mx Execute Template With Multiple Data    Send Notice via Notice Application without FFC Validation        ${ExcelPath}    ${rowid}    Correspondence   