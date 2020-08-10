*** Settings ***
Resource    ../../Configurations/LoanIQ_Import_File.robot
#Test Teardown    Test Suite Tear Down

*** Variables ***
${rowid}    1
${SCENARIO}    2

*** Test Cases ***
Create Customer within Loan IQ - ORIG03
    [Tags]    01 Create Customer within Loan IQ - ORIG03
    Mx Execute Template With Multiple Data    Create Customer within Loan IQ    ${ExcelPath}    ${rowid}    ORIG03_Customer
    
Search Customer and Complete its Borrower Profile Creation - ORIG03                                
    [Tags]    02 Complete Borrower's Profile - 0RIG03
    Mx Execute Template With Multiple Data    Search Customer and Complete its Borrower Profile Creation with default values    ${ExcelPath}    ${rowid}    ORIG03_Customer
    
Create Syndicated Deal - CRED01
    [Tags]    03 Deal Setup (Syndicated)
    Mx Execute Template With Multiple Data    Setup Syndicated Deal    ${ExcelPath}    ${rowid}    CRED01_DealSetup

Setup Admin Fee - CRED09
    Mx Execute Template With Multiple Data    Setup Deal Administrative Fees    ${ExcelPath}	${rowid}    CRED09_AdminFee

Setup Event Fee - CRED10
    Mx Execute Template With Multiple Data    Setup Deal Event Fees    ${ExcelPath}    ${rowid}    CRED10_EventFee
    Mx Execute Template With Multiple Data    Setup Term Facility for Syndicated Deal    ${ExcelPath}    ${rowid}    CRED02_FacilitySetup

Ongoing Fee Setup - CRED08    
    Mx Execute Template With Multiple Data    Setup Fees for Term Facility    ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup
    
Primary Allocation - SYND02
    Mx Execute Template With Multiple Data    Setup Primaries for Syndicated Deal    ${ExcelPath}    ${rowid}    SYND02_PrimaryAllocation
    Mx Execute Template With Multiple Data    Syndicated Deal Approval and Close    ${ExcelPath}    ${rowid}    SYND02_PrimaryAllocation
    
Change Agency Fee Transaction - AMHC10
    [Tags]    04 User is able to change AGENCY FEE transaction -     AMCH10
    Mx Execute Template With Multiple Data    Change Agency Fee    ${ExcelPath}    ${rowid}    AMCH10_ChangeAgencyFee
    
Create Term and SBLC Loan Drawdown for Syndicated Deal - SERV01A
    [Tags]    05 User is able to create TERM and SBLC Loan Drawdown for SYNDICATED deal - SERV01A
    Mx Execute Template With Multiple Data    Create Loan Drawdown TERM and SBLC for Syndicated Deal    ${ExcelPath}    ${rowid}    SERV01A_LoanDrawdown

Verify Facility Share Adjustments - MTAM07
    [Tags]    06 User is able to do Adjustments in the Facility Shares - MTAM07
    Mx Execute Template With Multiple Data    Adjust Facility Lender Shares For Syndicated Deal    ${ExcelPath}    ${rowid}    MTAM07_FacilityShareAdjustment
    
Initiate Ongoing Fee Payment - SERV29
    [Tags]    09 perform Ongoing Fee Payment on Syndicated Dea (SERV29)
    Mx Execute Template With Multiple Data    Update Commitment Fee Cycle    ${ExcelPath}    ${rowid}    SERV29_PaymentFees
    Mx Execute Template With Multiple Data    Update Indemnity Fee Cycle    ${ExcelPath}    ${rowid}    SERV29_PaymentFees
    Log to Console    Pause Execution - Run Daily EOD
    Pause Execution
    Mx Execute Template With Multiple Data    Pay Commitment Fee Amount - Syndicated    ${ExcelPath}    ${rowid}    SERV29_PaymentFees
    Mx Execute Template With Multiple Data    Pay Indemnity Fee Amount - Syndicated    ${ExcelPath}    ${rowid}    SERV29_PaymentFees 
    Log to Console    Pause Execution - Run Monthly EOD
    Pause Execution
    
Create Comprehensive Repricing - SERV08C
    [Tags]    07 - User is able to create a Comprehensive Reprcing for SYNDICATED deal using PRINCIPAL - SERV08C                                                                                                                                                                                                                                                                            
    Mx Execute Template With Multiple Data    Create Comprehensive Repricing for Syndicated Deal   ${ExcelPath}    ${rowid}    SERV08_ComprehensiveRepricing
    Log to Console    Pause Execution - Run Daily EOD
    Pause Execution
    
Initiate Repayment Paper Clip with Three Lenders - SERV21
    [Tags]    08 initiate Repayment Paper Clip with Three Lenders - Interest and Principal (SERV21)
    Mx Execute Template With Multiple Data    Initiate Repayment Paper Clip with Three Lenders - Interest and Principal    ${ExcelPath}   ${rowid}    SERV21_InterestPayments 
    
Initiate Agency Fee Payment - SERV30
    [Tags]    10 User is able to initiate AGENCY FEE payment (SERV30)
    Mx Execute Template With Multiple Data    Admin Fee Payment    ${ExcelPath}    ${rowid}    SERV30_AdminFeePayment  
    
Create Recurring Fee Payment - SERV33
    [Tags]    11 User is able to initiate RECURRING FEE Payment - SERV33
    Mx Execute Template With Multiple Data    Setup Recurring Event Fee    ${ExcelPath}    ${rowid}    CRED11_EventDrivenFeeAdvanced
    Mx Execute Template With Multiple Data    Initiate Recurring Fee Payment    ${ExcelPath}    ${rowid}    SERV33_RecurringFee
    
Initiate Unscheduled Principal Payment - SERV20
    [Tags]    12 User is able to initiate UNSCHEDULED Principal Payment - SERV20 
    Mx Execute Template With Multiple Data    Initiate Unscheduled Principal Payment    ${Excelpath}    ${rowid}    SERV20_UnschedPrincipalPayments
    
Create Break Funding for Early Full Repayment - SERV40
    [Tags]    13 User is able to initiate BREAKFUNDING Early Full Repayment - SERV40
    Mx Execute Template With Multiple Data    Initiate Break Funding Early Full Repayment    ${ExcelPath}   ${rowid}    SERV40_BreakFunding

Create SBLC Guarantee Issuance - SERV05
    [Tags]    14 Create and Release of Standard Bank Letter of Credit - SERV05
    Mx Execute Template With Multiple Data    SBLC Guarantee Issuance    ${ExcelPath}    ${rowid}    	SERV05_SBLCIssuance
    Log to Console    Pause Execution - Run Daily EOD
    Pause Execution

Create Paperclip Transaction including SBLC and Facing Fee - SERV23
    [Tags]    15 Create Paperclip Transaction including SBLC and Facing Fee - CRE01
    Mx Execute Template With Multiple Data    Create Paperclip Transaction including SBLC and Facing Fee    ${ExcelPath}    ${rowid}    SERV23_PaperclipTransaction
