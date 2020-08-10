*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
Upfront Fee From Drawdown for Bilateral - BUPR03
    [Tags]    Upfront Fee From Drawdown for Bilateral - BUPR03

    Mx Execute Template With Multiple Data    Upfront Fee From Drawdown for Bilateral    ${ExcelPath}    ${rowid}    BUPR03_UpfrontFeeDrawdown