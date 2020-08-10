*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1
${SCENARIO}    1    

*** Test Cases ***
CRED06_01 Ticking Fee Definition
    [Tags]    02 Ticking Fee set up in LIQ   
    Mx Execute Template With Multiple Data    Setup Ticking Fee    ${ExcelPath}    ${rowid}    CRED06_Ticking_Fee_Setup


  