*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1
${SCENARIO}    1

*** Test Cases ***

Create Temporary Payment Plan - SERV45
    [Tags]    Create Temporary Payment Plan - SERV45
    Mx Execute Template With Multiple Data    Create Temporary Payment Plan    ${ExcelPath}    ${rowid}    SERV45_CreateTempPaymentPlan