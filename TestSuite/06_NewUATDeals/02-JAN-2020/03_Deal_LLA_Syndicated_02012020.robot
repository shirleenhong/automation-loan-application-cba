*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***

Get Dataset for LLA Syndicated Deal
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    LLA_SYND    UAT_Deal_Scenarios

Collect Line Fee in Advance (01/01/2020-01/04/2020)
    Mx Execute Template With Multiple Data    Pay Line Fee for LLA Syndicated Deal    ${ExcelPath}    ${rowid}    SERV29_PaymentFees