*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1
${SCENARIO}    5

*** Test Cases ***
Deal Setup - CRED01
    [Tags]    01 Deal Setup - CRED01
    Mx Execute Template With Multiple Data    Setup RPA Internal Deal    ${ExcelPath}    ${rowid}    CRED01_DealSetup
    Mx Execute Template With Multiple Data    Setup Deal Upfront Fees    ${ExcelPath}    ${rowid}    CRED07_UpfrontFeeSetup
    Mx Execute Template With Multiple Data    Create Facility for RPA Deal    ${ExcelPath}    ${rowid}    CRED02_FacilitySetup
    Mx Execute Template With Multiple Data    Ongoing Fee Setup     ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup
    
Primary Allocation - SYND02
    [Tags]    02 Primary Allocation - SYND02
    Mx Execute Template With Multiple Data    Setup Primary for RPA Deal    ${ExcelPath}    ${rowid}    SYND02_PrimaryAllocation
    Mx Execute Template With Multiple Data    RPA Deal Approval and Close    ${ExcelPath}    ${rowid}    SYND02_PrimaryAllocation

Charge Upfront Fee - CRED07
    [Tags]    03 Charge Upfront Fee - CRED07
    Mx Execute Template With Multiple Data    Initiate Upfront Fee Payment    ${ExcelPath}    ${rowid}    CRED07_UpfrontFee_Payment

Complete Portfolio Settled Discount - TRPO12
    [Tags]    04    Portfolio Settled Discount - TRPO12 
    Mx Execute Template With Multiple Data    Complete Portfolio Settled Discount    ${ExcelPath}    ${rowid}    TRPO12_PortfolioSettledDisc

Complete External Participation without Premiun/Discount - TRPO06
    [Tags]    05    Complete External Participation without Premiun/Discount - TRPO06
    Mx Execute Template With Multiple Data    Complete External Participation without Premiun/Discount    ${ExcelPath}    ${rowid}    TRPO06_ExternalParticipation    Mx Execute Template With Multiple Data    Complete Portfolio Settled Discount    ${ExcelPath}    ${rowid}    TRPO12_PortfolioSettledDisc

Create Initial Loan Drawdown - SERV01
    [Tags]    06    Loan Drawdown - SERV01 
    Mx Execute Template With Multiple Data    Create Initial Loan Drawdown for RPA Deal    ${ExcelPath}    ${rowid}    SERV01_LoanDrawdown
    Log to Console    Pause Execution - 5 Days EOD
    Pause Execution

Complete Participation Buyback - TRPO05
    [Tags]    07    Participation Buyback - TRPO05
    Mx Execute Template With Multiple Data    Complete External Participation Buyback without Premiun/Discount    ${ExcelPath}    ${rowid}    TRPO05_ExtParticipationBuyBack

Complete Internal Participation - TRPO06
    [Tags]    08    Participation Internal - TRPO06
    Mx Execute Template With Multiple Data    Complete Internal Participation without Premiun/Discount    ${ExcelPath}    ${rowid}    TRPO06_InternalParticipation

Complete Comprehensive Repricing, Principal Payment and Interest Payment - SERV08
    [Tags]    09    Loan Repricing - SERV08 
    Log to Console    Pause Execution - 1 month EOD or EOD until repricing date
    Pause Execution
    Mx Execute Template With Multiple Data    Complete Comprehensive Repricing, Principal Payment and Interest Payment    ${ExcelPath}    ${rowid}    SERV08_ComprehensiveRepricing

Ongoing Fee Payment - SERV29
    [Tags]    10    Ongoing Fee Payment - SERV29
    Mx Execute Template With Multiple Data    Pay Usage Fee for RPA Deal    ${ExcelPath}    ${rowid}    SERV29_PaymentFees