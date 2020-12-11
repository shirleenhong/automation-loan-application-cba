*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot


*** Variables ***
${rowid}    1

*** Test Cases ***
Collect Commitment Fee
    [Tags]  01 Collect Commitment Fee
    Mx Execute Template With Multiple Data    Collect Commitment Fee Payment For PIM Future BILAT    ${ExcelPath}    ${rowid}    SERV29_CommitmentFeePayment
    Set Test Variable    ${rowid}    3
    Mx Execute Template With Multiple Data    Send a SENT Callback for Payment Notice without FFC Validation        ${ExcelPath}    ${rowid}    Correspondence