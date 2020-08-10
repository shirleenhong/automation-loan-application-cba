*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1    
${ExcelPath}    C:\\fms_scotia\\DataSet\\StandAlone_DataSet\\AMCH09_ContactChangeTransaction.xlsx

*** Test Cases ***

Contact Change Transaction - AMCH09
    [Tags]    Contact change transaction of customer   
    Mx Execute Template With Multiple Data    Contact Change Transaction    ${ExcelPath}    ${rowid}    AMCH09_ContactChangeTransaction