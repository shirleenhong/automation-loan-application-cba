*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    2

*** Test Cases ***
Create Initial Loan Drawdown - SERV01
    Mx Execute Template With Multiple Data    Create Initial Loan Drawdown for New Life BILAT    ${CBAUAT_ExcelPath}    ${rowid}    SERV01_LoanDrawdown