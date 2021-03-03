*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
Get Dataset for CH EDU Bilateral Deal
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    CH_EDU_BILAT    UAT_Deal_Scenarios

Combine W + Interest and Fee Capitalisation (1 Jan 20 - 1 April 20) and Rollover
    Set Test Variable    ${rowid}    9
    Mx Execute Template With Multiple Data    Capitalize Interest for an Existing Outstanding for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    SERV01_LoanDrawdown
    Set Test Variable    ${rowid}    3
    Mx Execute Template With Multiple Data    Capitalize Interest for Commitment Fee for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    SERV29_PaymentFees
    Mx Execute Template With Multiple Data    Pay Commitment Fee without Cashflow for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    SERV29_PaymentFees
    Set Test Variable    ${rowid}    7
    Mx Execute Template With Multiple Data    Rollover Outstanding W and Interest for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    SERV11_LoanMerge

Generate and Send Repricing Intent Notice
    Set Test Variable    ${rowid}    14
    Mx Execute Template With Multiple Data    Send Repricing Intent Notice for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    Correspondence

Generate and Send Rate Setting Intent Notice
    Set Test Variable    ${rowid}    15
    Mx Execute Template With Multiple Data    Send Repricing Rate Setting Notice for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    Correspondence