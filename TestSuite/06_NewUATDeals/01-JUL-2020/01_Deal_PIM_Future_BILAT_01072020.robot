*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot


*** Variables ***
${rowid}    3

*** Test Cases ***
Get Dataset for PIM Future BILAT
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    PIM_Future_BILAT    UAT_Deal_Scenarios

Collect Commitment Fee Effective 30/06/2020
    [Tags]  01 Collect Commitment Fee
    Mx Execute Template With Multiple Data    Collect Commitment Fee Payment For PIM Future BILAT    ${ExcelPath}    ${rowid}    SERV29_CommitmentFeePayment