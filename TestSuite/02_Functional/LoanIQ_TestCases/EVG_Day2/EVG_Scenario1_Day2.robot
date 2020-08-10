*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1
${SCENARIO}    1

*** Test Cases ***
Initiate Ongoing Fee Payment - SERV29
    [Tags]    05 Initiate Ongoing Fee Payment - SERV29
    Mx Execute Template With Multiple Data    Pay Commitment Fee Amount    ${ExcelPath}    ${rowid}    SERV29_PaymentFees 
    
Create Pricing Change Transaction - AMCH06
    [Tags]    06 Create Pricing Change Transaction - AMCH06
    Mx Execute Template With Multiple Data    Create Pricing Change Transaction    ${ExcelPath}    ${rowid}    AMCH06_PricingChangeTransaction
    
Initiate Loan Interest Payment - SERV21
    [Tags]    07 Initiate Loan Interest Payment - SERV21
    Mx Execute Template With Multiple Data    Initiate Interest Payment    ${ExcelPath}    ${rowid}    SERV21_InterestPayments
    
Manual Scheduled Principal Payment - SERV18
    [Tags]    08 Manual Scheduled Principal Payment - SERV18
    Mx Execute Template With Multiple Data    Manual Schedule Principal Payment    ${ExcelPath}    ${rowid}    SERV18_Payments
    
Deal Change Transaction - DLCH01
    [Tags]    09 Deal Change Transaction - DLCH01
    Mx Execute Template With Multiple Data    Deal Change Transaction on Financial Ratio    ${ExcelPath}    ${rowid}    DLCH01_DealChangeTransaction       
