*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1
${SCENARIO}    1    

*** Test Cases ***
MTAM13_Manual Cashflow - Incoming - Using a New/Existing WIP Item
    [Tags]    MTAM13_Manual Cashflow - Incoming - Using a New/Existing WIP Item
    Mx Execute Template With Multiple Data    Process Incoming Cash Movements Outside of Transaction Notebooks Using a New or Existing WIP    ${ExcelPath}    ${rowid}    MTAM13_ManualCashflow_Incoming