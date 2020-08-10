*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1    
${ExcelPath}    C:\\fms_scotia\\DataSet\\StandAlone_DataSet\\MTAM03_ManualFundFlow.xlsx

*** Test Cases ***

Manual Funds Flow - MTAM03
    [Tags]    01 Creation of Manual Fund Flow in LIQ.   
    Mx Execute Template With Multiple Data    Manual Funds Flow    ${ExcelPath}    ${rowid}    MTAM03_ManualFundFlow