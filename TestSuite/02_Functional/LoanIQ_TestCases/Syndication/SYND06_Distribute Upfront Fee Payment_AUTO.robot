*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
Distribute Upfront Fee Payment - SYND06
    [Tags]    Distribute upfront fee payment auto - SYND06
    Mx Execute Template With Multiple Data    Distribute Upfront Fee Payment - Auto    ${ExcelPath}    ${rowid}    SYND06_Dist_UpfrontFee_Payment