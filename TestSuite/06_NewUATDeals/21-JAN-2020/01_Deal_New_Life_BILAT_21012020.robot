*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot


*** Variables ***
${rowid}    1

*** Test Cases ***
Collect Commitment Fee - $90,978.70
    Mx Execute Template With Multiple Data    Collect Commitment Fee Payment For New Life BILAT    ${ExcelPath}    ${rowid}    SERV29_CommitmentFeePayment

Amend Commitment Fee
    Mx Execute Template With Multiple Data    Update Commitment Fee for New Life BILAT    ${ExcelPath}    2    SERV29_CommitmentFeePayment

Comprehensive Repricing - SERV08
    Mx Execute Template With Multiple Data    Create Comprehensive Repricing for New Life BILAT    ${ExcelPath}    ${rowid}    SERV08_ComprehensiveRepricing