*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1
${SCENARIO}    1    

*** Test Cases ***
Manual GL - Using a New/Existing WIP Item - MTAM12
    [Tags]    Manual GL - Using a New/Existing WIP Item - MTAM12
    Mx Execute Template With Multiple Data    Process Manual GL of Transaction Notebooks Using a New or Existing WIP    ${ExcelPath}    ${rowid}    MTAM12_ManualGL