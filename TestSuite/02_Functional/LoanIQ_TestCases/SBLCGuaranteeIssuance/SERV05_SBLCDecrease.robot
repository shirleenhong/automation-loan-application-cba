*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1  
${ExcelPath}    C:\\fms_scotia\\DataSet\\LoanIQ_DataSet\\Miscellaneous\\SERV05_SBLCDecrease.xlsx

*** Test Cases ***

 Set Up SBLC Decrease - SERV05
    [Tags]    09 SBLC Decrease
    Mx Execute Template With Multiple Data    Set Up SLBC Decrease    ${ExcelPath}    ${rowid}    SERV05_SBLCDecrease   