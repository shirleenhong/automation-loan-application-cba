*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
Get Dataset for CH EDU Bilateral Deal
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    CH_EDU_BILAT    UAT_Deal_Scenarios

Combine YZ + Interest Capitalisation and Rollover
    Set Test Variable    ${rowid}    5
    Mx Execute Template With Multiple Data    Combine Loan Y and Z and Capitalized Interest    ${ExcelPath}    ${rowid}    SERV11_LoanMerge

Generate And Send Repricing Intent Notice - Interest and Fee Capitalisation
    Set Test Variable    ${rowid}    10
    Mx Execute Template With Multiple Data    Send Repricing Intent Notice for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    Correspondence