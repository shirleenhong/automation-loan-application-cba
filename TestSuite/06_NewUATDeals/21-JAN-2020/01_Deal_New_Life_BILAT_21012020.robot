*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
Collect Commitment Fee - $90,978.70
    Set Test Variable    ${rowid}    2
    Mx Execute Template With Multiple Data    Collect Commitment Fee Payment For New Life BILAT    ${ExcelPath}    ${rowid}    SERV29_CommitmentFeePayment

Amend Commitment Fee
    Set Test Variable    ${rowid}    3
    Mx Execute Template With Multiple Data    Update Commitment Fee for New Life BILAT    ${ExcelPath}    ${rowid}    SERV29_CommitmentFeePayment

Comprehensive Repricing - $191,569,254.72
    Set Test Variable    ${rowid}    1
    Mx Execute Template With Multiple Data    Create Comprehensive Repricing for New Life BILAT    ${ExcelPath}    ${rowid}    SERV08_ComprehensiveRepricing

