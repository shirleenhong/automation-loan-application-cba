*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
Get Dataset for LBT BILAT
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    PIM_Future_BILAT    UAT_Deal_Scenarios

Comprehensive Repricing - SERV08
    [Tags]  01 Comprehensive Repricing - SERV08
    Mx Execute Template With Multiple Data    Create Comprehensive Repricing for PIM Future BILAT    ${ExcelPath}    ${rowid}    SERV08_ComprehensiveRepricing
    Set Test Variable    ${rowid}    4    
    Mx Execute Template With Multiple Data    Send Notice via Notice Application without FFC Validation    ${ExcelPath}    ${rowid}    Correspondence
    Set Test Variable    ${rowid}    5    
    Mx Execute Template With Multiple Data    Send a Drawdown Intent Notice via Notice Application without FFC Validation    ${ExcelPath}    ${rowid}    Correspondence