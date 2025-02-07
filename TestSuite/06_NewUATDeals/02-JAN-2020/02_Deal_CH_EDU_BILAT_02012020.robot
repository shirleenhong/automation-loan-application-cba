*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
Get Dataset for CH EDU Bilateral Deal
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    CH_EDU_BILAT    UAT_Deal_Scenarios

Fee Capitalisation (7 Dec 19 - 1 Jan 20) and Send Fee Payment Notice
    Set Test Variable    ${rowid}    2
    Mx Execute Template With Multiple Data    Pay Commitment Fee for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    SERV29_PaymentFees
    Set Test Variable    ${rowid}    9
    Mx Execute Template With Multiple Data    Create Loan Drawdown for CH EDU Bilateral Deal - Outstanding W    ${ExcelPath}    ${rowid}    SERV01_LoanDrawdown
    Set Test Variable    ${rowid}    2
    Mx Execute Template With Multiple Data    Complete Commitment Fee Cashflow for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    SERV29_PaymentFees

Collect line fee in arrears (1/10/2019 -1/1/2020)
    Mx Execute Template With Multiple Data    Pay Line Fee for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    SERV29_PaymentFees

Generate and Send Line Fee in Arrears Payment Notice
    Set Test Variable    ${rowid}    2
    Mx Execute Template With Multiple Data    Send Ongoing Fee Payment Intent Notice for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    Correspondence