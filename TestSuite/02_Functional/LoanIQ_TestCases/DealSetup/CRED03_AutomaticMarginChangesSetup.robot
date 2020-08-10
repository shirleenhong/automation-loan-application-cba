*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1
${SCENARIO}    1    

*** Test Cases ***
CRED03 - Automatic Margin Changes Setup
    [Tags]    CRED03 - Automatic Margin Changes Setup  
    Mx Execute Template With Multiple Data    Set Up Automated Changes to Margin Based on Dates or External Factors    ${ExcelPath}    ${rowid}    CRED03_AutoMarginChangesSetup