*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1    
${ExcelPath}    C:\\fms_scotia\\DataSet\\StandAlone_DataSet\\AMCH08_RemittanceInstructionChangeTransaction.xlsx

*** Test Cases ***

Remittance Instructions Change Transaction - AMCH08
    [Tags]    Remittance Instructions Change Transaction in LIQ   
    Mx Execute Template With Multiple Data    Remittance Instructions Change Transaction    ${ExcelPath}    ${rowid}    AMCH08_RemittanceInstructionCT