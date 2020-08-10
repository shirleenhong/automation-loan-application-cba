*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1    
${ExcelPath}    C:\\fms_scotia\\DataSet\\StandAlone_DataSet\\SERV42_CreateBorrowingBase.xlsx

*** Test Cases ***

Create BorrowingBase - SERV42
    [Tags]    01 Creation of borrowingbase in LIQ   
    Mx Execute Template With Multiple Data    Borrowing Base Creation    ${ExcelPath}    ${rowid}    SERV42_CreateBorrowingBase