*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    3

*** Test Cases ***
Create Initial Loan Drawdown - $6,300,000.00
    Mx Execute Template With Multiple Data    Create Initial Loan Drawdown for New Life BILAT    ${CBAUAT_ExcelPath}    ${rowid}    SERV01_LoanDrawdown