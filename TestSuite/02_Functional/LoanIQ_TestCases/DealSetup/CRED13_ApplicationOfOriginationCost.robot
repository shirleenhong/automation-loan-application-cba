*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1    
${ExcelPath}    C:\\fms_scotia\\DataSet\\StandAlone_DataSet\\CRED13_ApplicationOfOriginationCost.xlsx

*** Test Cases ***

Application of Origination Cost - CRED13
    [Tags]    Application of Origination Cost in LIQ   
    Mx Execute Template With Multiple Data    Application of Origination Cost    ${ExcelPath}    ${rowid}    CRED13_ApplnOfOriginationCost