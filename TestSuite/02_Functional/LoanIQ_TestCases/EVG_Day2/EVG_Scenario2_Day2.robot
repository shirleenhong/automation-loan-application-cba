*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot
#Test Teardown    Test Suite Tear Down

*** Variables ***
${rowid}    1
${SCENARIO}    2

*** Test Cases ***
Initiate Ongoing Fee Payment - SERV29
    [Tags]    09 perform Ongoing Fee Payment on Syndicated Dea (SERV29)
    Mx Execute Template With Multiple Data    Pay Commitment Fee Amount - Syndicated    ${ExcelPath}    ${rowid}    SERV29_PaymentFees
    Mx Execute Template With Multiple Data    Pay Indemnity Fee Amount - Syndicated    ${ExcelPath}    ${rowid}    SERV29_PaymentFees 
    Log to Console    Pause Execution - Run Monthly EOD
