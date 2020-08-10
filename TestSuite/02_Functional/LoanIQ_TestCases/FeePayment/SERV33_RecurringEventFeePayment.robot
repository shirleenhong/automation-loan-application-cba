*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1  
${ExcelPath}    C:\\fms_scotia\\DataSet\\LoanIQ_DataSet\\Miscellaneous\\SERV33_RecurringEventFeePayment_SYNDeal.xlsx

*** Test Cases ***

Create Recurring Fee Payment for Syndicated Deal - SERV33
    [Tags]    11 User is able to initiate RECURRING FEE Payment - SERV33
    Mx Execute Template With Multiple Data    Setup Recurring Event Fee    ${ExcelPath}    ${rowid}    CRED10_EventFee
    Mx Execute Template With Multiple Data    Initiate Recurring Fee Payment    ${ExcelPath}    ${rowid}    SERV33_RecurringEventFeePayment
   
Create Recurring Fee Payment for Bilateral Deal - SERV33
    [Tags]    11 User is able to initiate RECURRING FEE Payment - SERV33 
    Mx Execute Template With Multiple Data    Initiate Recurring Fee Payment for Bilateral Deal    ${ExcelPath}    ${rowid}    SERV33_RecurringEventFeePayment   