*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1    
${ExcelPath}    C:\\fms_scotia\\DataSet\\StandAlone_DataSet\\AMCH07_OutstandingChangeTransaction.xlsx

*** Test Cases ***

Outstanding Change Transaction - AMCH07
    [Tags]    Outstanding Change Transaction in LIQ   
    Mx Execute Template With Multiple Data    Outstanding Change Transaction    ${ExcelPath}    ${rowid}    AMCH07_OutstandingChangeTxn