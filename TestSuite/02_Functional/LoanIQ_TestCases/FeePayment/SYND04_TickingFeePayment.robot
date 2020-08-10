*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1  
${ExcelPath}    C:\\fms_scotia\\DataSet\\StandAlone_DataSet\\SYND04_TickingFeePayment.xlsx

*** Test Cases ***

Tickler Fee Payment
    [Tags]    01 Create Tickler in LIQ    
    Mx Execute Template With Multiple Data    Create Payment For Ticking Fee    ${ExcelPath}    ${rowid}    SYND04_TickingFeePayment