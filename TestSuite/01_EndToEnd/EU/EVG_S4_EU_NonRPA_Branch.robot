*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1
${SCENARIO}    4

*** Test Cases ***
Deal Setup - CRED01
    [Tags]    01 Deal Setup - CRED01
    Mx Execute Template With Multiple Data    Setup RPA Internal Deal    ${ExcelPath}    ${rowid}    CRED01_DealSetup
    Mx Execute Template With Multiple Data    Setup Deal Upfront Fees    ${ExcelPath}    ${rowid}    CRED07_UpfrontFeeSetup
    Mx Execute Template With Multiple Data    Create Facility for RPA Deal    ${ExcelPath}    ${rowid}    CRED02_FacilitySetup
    Mx Execute Template With Multiple Data    Ongoing Fee Setup     ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup
    
Primary Allocation - SYND02
    [Tags]    02 Primary Allocation - SYND02
    Mx Execute Template With Multiple Data    Setup 2 Host Bank Primaries for RPA Deal    ${ExcelPath}    ${rowid}    SYND02_PrimaryAllocation
    Mx Execute Template With Multiple Data    RPA Deal Approval and Close    ${ExcelPath}    ${rowid}    SYND02_PrimaryAllocation

Charge Upfront Fee - CRED07
    [Tags]    03 Charge Upfront Fee - CRED07
    Mx Execute Template With Multiple Data    Initiate Upfront Fee Payment    ${ExcelPath}    ${rowid}    CRED07_UpfrontFee_Payment

Complete Portfolio Settled Discount - TRPO12
    [Tags]    04    Portfolio Settled Discount - TRPO12 
    Mx Execute Template With Multiple Data    Complete Portfolio Settled Discount    ${ExcelPath}    ${rowid}    TRPO12_PortfolioSettledDisc

Create Initial Loan Drawdown - SERV01
    [Tags]    05    Loan Drawdown - SERV01 
    Mx Execute Template With Multiple Data    Create Initial Loan Drawdown for RPA Deal    ${ExcelPath}    ${rowid}    SERV01_LoanDrawdown

Complete Comprehensive Repricing, Principal Payment and Interest Payment - SERV08
    [Tags]    06    Loan Repricing - SERV08 
    Log to Console    Pause Execution - 1 Month EOD
    Pause Execution
    Mx Execute Template With Multiple Data    Complete Comprehensive Repricing, Principal Payment and Interest Payment    ${ExcelPath}    ${rowid}    SERV08_ComprehensiveRepricing

Ongoing Fee Payment - SERV29
    [Tags]    07    Ongoing Fee Payment - SERV29
    Mx Execute Template With Multiple Data    Pay Usage Fee for RPA Deal    ${ExcelPath}    ${rowid}    SERV29_PaymentFees