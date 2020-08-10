*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1    
${ExcelPath}    C:\\fms_scotia\\DataSet\\StandAlone_DataSet\\SERV07_GuaranteeDrawdown.xlsx

*** Test Cases ***

SBLC_GuaranteeDrawdown
    [Tags]    02 Pending Deal amendment in LIQ   
    Mx Execute Template With Multiple Data    SBLC Guarantee Drawdown    ${ExcelPath}    ${rowid}    SERV07_GuaranteeDrawdown