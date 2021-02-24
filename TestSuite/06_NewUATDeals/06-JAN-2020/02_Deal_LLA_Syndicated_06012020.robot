*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
Combine B1&C and Rollover
    Set Test Variable    ${rowid}    2
    Mx Execute Template With Multiple Data    Create Loan Merge for Outstanding B1 and C for LLA Syndicated Deal    ${ExcelPath}    ${rowid}    SERV08_ComprehensiveRepricing