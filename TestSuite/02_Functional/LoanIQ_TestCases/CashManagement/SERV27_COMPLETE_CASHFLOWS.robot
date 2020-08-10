*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1
${SCENARIO}    1

*** Test Cases ***
Complete Cashflows - SERV27
    [Tags]    04 Create Initial Loan Drawdown - SERV01
    Mx Execute Template With Multiple Data    Complete Cashflow - Drawdown    ${ExcelPath}    ${rowid}    SERV27_CompleteCashflow