*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
Get Dataset for LBT BILAT
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    LBT_BILAT    UAT_Deal_Scenarios

Combine ABCDEF & G, Partial Repayment $357.540M and Rollover
    Set Test Variable    ${rowid}    5
    Mx Execute Template With Multiple Data    Combine Drawdown ABCDEFG and Make Partial Repayment for LBT Bilateral Deal    ${ExcelPath}    ${rowid}    SERV11_LoanMerge