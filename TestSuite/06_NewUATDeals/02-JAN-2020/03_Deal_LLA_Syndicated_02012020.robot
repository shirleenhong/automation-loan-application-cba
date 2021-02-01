*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
Collect Line Fee in Advance (01/01/2020-01/04/2020)
    Mx Execute Template With Multiple Data    Pay Line Fee for LLA Syndicated Deal    ${ExcelPath}    ${rowid}    SERV29_PaymentFees