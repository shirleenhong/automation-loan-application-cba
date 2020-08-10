*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1
${SCENARIO}    1    

*** Test Cases ***
MTAM14_Manual Cashflow - Outgoing - Using a New/Existing WIP Item
    [Tags]    MTAM14_Manual Cashflow - Outgoing - Using a New/Existing WIP Item
    Mx Execute Template With Multiple Data    Process Outgoing Cash Movements Outside of Transaction Notebooks Using a New or Existing WIP    ${ExcelPath}    ${rowid}    MTAM14_ManualCashflow_Outgoing