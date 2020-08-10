*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1
${SCENARIO}    1    

*** Test Cases ***
CRED15_01 Review Fee Acitivity List
    [Tags]    02 Ticking Fee set up in LIQ   
    Mx Execute Template With Multiple Data    Review Fee Activity List    ${ExcelPath}    ${rowid}    CRED15_ReviewFeeActivityList


  