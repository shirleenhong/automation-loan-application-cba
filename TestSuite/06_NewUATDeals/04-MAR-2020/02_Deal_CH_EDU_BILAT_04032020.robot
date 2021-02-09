*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    3

*** Test Cases ***
Get Dataset for CH EDU Bilateral Deal
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    CH_EDU_BILAT    UAT_Deal_Scenarios

Combine Outstanding D, E and F and Rollover
    Mx Execute Template With Multiple Data    Create Loan Merge for Outstanding D, E and F for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    SERV11_LoanMerge

Rollover Outstanding ABC
    Set Test Variable    ${rowid}    4
    Mx Execute Template With Multiple Data    Rollover Outstanding ABC for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    SERV11_LoanMerge

Generate and Send Repricing Intent Notice for Rollover Outstanding ABC
    Set Test Variable    ${rowid}    5
    Mx Execute Template With Multiple Data    Send Repricing Intent Notice for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    Correspondence

Generate and Send Repricing Rate Setting Notice for Rollover Outstanding ABC
    Set Test Variable    ${rowid}    6
    Mx Execute Template With Multiple Data    Send Repricing Rate Setting Notice for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    Correspondence