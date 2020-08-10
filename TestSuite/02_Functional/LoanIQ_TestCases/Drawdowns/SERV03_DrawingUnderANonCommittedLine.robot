*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1
${SCENARIO}    1    

*** Test Cases ***
SERV03 - Drawing Under a Non Committed Line
    [Tags]    SERV03 - Drawing Under a Non Committed Line
    Mx Execute Template With Multiple Data    Create Loan Drawdown Under a Non Committed Line    ${ExcelPath}    ${rowid}    SERV03_DrwUnderNonCommittedLine