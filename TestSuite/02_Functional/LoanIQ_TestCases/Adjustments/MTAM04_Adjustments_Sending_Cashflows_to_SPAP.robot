*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1
${SCENARIO}    1

*** Test Cases ***
Adjustments - Sending Cashflows to SPAP - MTAM04
    [Tags]    01 Create Adjustments - Sending Cashflows to SPAP - MTAM04
    Mx Execute Template With Multiple Data    Create Adjustments - Cashflows to SPAP    ${ExcelPath}    ${rowid}    MTAM04_Adjustments