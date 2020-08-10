*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
Set Up Automated Transactions - AUTO01
    [Documentation]    Prerequisite: Existing Deal Notebook, Existing Facility
    [Tags]    Set Up Automated Transactions - AUTO01
    
    Mx Execute Template With Multiple Data    Set Up Automated Transactions    ${ExcelPath}    ${rowid}    AUTO01_Automated_Transactions