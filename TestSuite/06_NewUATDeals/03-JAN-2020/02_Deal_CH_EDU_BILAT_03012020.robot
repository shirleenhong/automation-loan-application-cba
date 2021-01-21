*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
Get Dataset for CH EDU Bilateral Deal
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    CH_EDU_BILAT    UAT_Deal_Scenarios

Combine Outstanding A & B and Rollover
    Mx Execute Template With Multiple Data    Create Loan Merge for Outstanding A and B for CH EDU Bilateral Deal   ${ExcelPath}   ${rowid}    SERV11_LoanMerge

Generate and Send Repricing Intent Notice - Combine Outstanding A & B and Rollover
    Set Test Variable    ${rowid}    3
    Mx Execute Template With Multiple Data    Send Repricing Intent Notice for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    Correspondence