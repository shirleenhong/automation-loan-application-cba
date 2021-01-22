*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot


*** Variables ***
${rowid}    1

*** Test Cases ***
Get Dataset for PIM Future BILAT
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    PIM_Future_BILAT    UAT_Deal_Scenarios

Collect Commitment Fee - SERV29
    [Tags]  01 Collect Commitment Fee - SERV29
    Mx Execute Template With Multiple Data    Collect Commitment Fee Payment For PIM Future BILAT    ${ExcelPath}    ${rowid}    SERV29_CommitmentFeePayment
    Set Test Variable    ${rowid}    3
    Mx Execute Template With Multiple Data    Send a SENT Callback for Payment Notice without FFC Validation        ${ExcelPath}    ${rowid}    Correspondence