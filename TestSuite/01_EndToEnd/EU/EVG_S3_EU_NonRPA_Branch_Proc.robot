*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1
${SCENARIO}    3

*** Test Cases ***
Deal Setup and Facilities - CRED01
    [Tags]    01 Deal Setup and Facilities - CRED01
    Mx Execute Template With Multiple Data    Setup RPA Internal Deal    ${ExcelPath}    ${rowid}    CRED01_DealSetup
    Mx Execute Template With Multiple Data    Setup Deal Upfront Fees    ${ExcelPath}    ${rowid}    CRED07_UpfrontFeeSetup
    Mx Execute Template With Multiple Data    Create Facility for RPA Deal    ${ExcelPath}    ${rowid}    CRED02_FacilitySetup
    Mx Execute Template With Multiple Data    Ongoing Fee Setup     ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup

Primary Allocation - CRED01
    [Tags]    02 Primary Allocation - CRED01
    Mx Execute Template With Multiple Data    Setup 2 Host Bank Primaries for RPA Deal    ${ExcelPath}    ${rowid}    SYND02_PrimaryAllocation

Close Deal - CRED01
    [Tags]    03 Close Deal - CRED01
    Mx Execute Template With Multiple Data    RPA Deal Approval and Close    ${ExcelPath}    ${rowid}    SYND02_PrimaryAllocation

Charge Upfront Fee - CRED07
    [Tags]    04 Charge Upfront Fee - CRED07
    Mx Execute Template With Multiple Data    Initiate Upfront Fee Payment    ${ExcelPath}    ${rowid}    CRED07_UpfrontFee_Payment

Complete Portfolio Settled Discount - TRPO12
    [Tags]    05 Portfolio Settled Discount - TRPO12 
    Mx Execute Template With Multiple Data    Complete Portfolio Settled Discount    ${ExcelPath}    ${rowid}    TRPO12_PortfolioSettledDisc

Create Initial Loan Drawdown - SERV01
    [Tags]    06 Loan Drawdown - SERV01 
    Mx Execute Template With Multiple Data    Create Initial Loan Drawdown for RPA Deal    ${ExcelPath}    ${rowid}    SERV01_LoanDrawdown
    Set Test Variable    ${rowid}    2
    Mx Execute Template With Multiple Data    Create Initial Loan Drawdown for RPA Deal    ${ExcelPath}    ${rowid}    SERV01_LoanDrawdown
    Mx Execute Template With Multiple Data    Update Usage Fee Cycle for RPA Deal    ${ExcelPath}    ${rowid}    SERV29_PaymentFees
    Log to Console    Pause Execution - Run Monthly EOD
    Pause Execution

Comprehensive Repricing - SERV08
    [Tags]    07 Comprehensive Repricing - SERV08
    Mx Execute Template With Multiple Data    Create Comprehensive Repricing for RPA Deal    ${ExcelPath}    ${rowid}    SERV08_ComprehensiveRepricing
    Set Test Variable    ${rowid}    2
    Mx Execute Template With Multiple Data    Create Comprehensive Repricing for RPA Deal    ${ExcelPath}    ${rowid}    SERV08_ComprehensiveRepricing

Complete Ongoing Fee Payment - SERV29
    [Tags]    08 Initiate Ongoing Fee Payment - SERV29
    Mx Execute Template With Multiple Data    Pay Usage Fee for RPA Deal    ${ExcelPath}    ${rowid}    SERV29_PaymentFees 