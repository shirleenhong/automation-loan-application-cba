*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1
${SCENARIO}    1

*** Test Cases ***
Scenario 1 - Create Quick Party Onboarding
    [Tags]    01 Create Party within Essence - PTY001
    Mx Launch UFT    Visibility=True    UFTAddins=Java    Processtimeout=300
    Mx LoanIQ Launch    Processtimeout=300
    Mx Execute Template With Multiple Data    Create Party in Quick Party Onboarding    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding
    
Scenario 1 - Search Customer and Complete its Borrower Profile Creation
    [Tags]    02 Create Customer within Loan IQ - ORIG03
    Mx Execute Template With Multiple Data    Search Customer and Complete its Borrower Profile Creation with default values    ${ExcelPath}    ${rowid}    ORIG03_Customer
     
Scenario 1 - Deal Setup
    [Tags]    03 Deal Setup - CRED01
    Mx Execute Template With Multiple Data    Setup a Bilateral Deal    ${ExcelPath}    ${rowid}    CRED01_DealSetup
    Mx Execute Template With Multiple Data    Create Facility    ${ExcelPath}    ${rowid}    CRED02_FacilitySetup
	Mx Execute Template With Multiple Data    Ongoing Fee Setup     ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup
	Mx Execute Template With Multiple Data    Setup a Primary Notebook    ${ExcelPath}    ${rowid}    SYND02_PrimaryAllocation

Scenario 1 - Calendar Load
    [Tags]    04 Calendar Load - TL_CAL_01
    Mx Execute Template With Multiple Data    Send Valid Copp Clark Files    ${ExcelPath}    ${rowid}    Calendar_Fields

Scenario 1 - Create Initial Loan Drawdown
    [Tags]    05 Create Initial Loan Drawdown - SERV01
    Mx Execute Template With Multiple Data    Create Initial Loan Drawdown with Repayment Schedule    ${ExcelPath}    ${rowid}    SERV01_LoanDrawdown
    
Scenario 1 - Send Drawdown Notices
    [Tags]    06 Send Drawdown Notices - API_COR_TC01
    Set Test Variable    ${rowid}    1
    Mx Execute Template With Multiple Data    Send Notice via Notice Application    ${ExcelPath}    ${rowid}    Correspondence
    
Scenario 1 - Initiate Ongoing Fee Payment
    [Tags]    07 Initiate Ongoing Fee Payment - SERV29
    Mx Execute Template With Multiple Data    Update Commitment Fee Cycle    ${ExcelPath}    ${rowid}    SERV29_PaymentFees   
    Log to Console    Pause Execution - Run Daily EOD
    Pause Execution
    Mx Execute Template With Multiple Data    Pay Commitment Fee Amount    ${ExcelPath}    ${rowid}    SERV29_PaymentFees 
    
Scenario 1 - Create Pricing Change Transaction
    [Tags]    09 Create Pricing Change Transaction - AMCH06
    Mx Execute Template With Multiple Data    Create Pricing Change Transaction    ${ExcelPath}    ${rowid}    AMCH06_PricingChangeTransaction
    
Scenario 1 - Initiate Loan Interest Payment
    [Tags]    10 Initiate Loan Interest Payment - SERV21
    Mx Execute Template With Multiple Data    Initiate Interest Payment    ${ExcelPath}    ${rowid}    SERV21_InterestPayments
    
Scenario 1 - Manual Scheduled Principal Payment
    [Tags]    12 Manual Scheduled Principal Payment - SERV18
    Mx Execute Template With Multiple Data    Manual Schedule Principal Payment    ${ExcelPath}    ${rowid}    SERV18_Payments    
    
Scenario 1 - Deal Change Transaction
    [Tags]    14 Deal Change Transaction - AMCH04
    Mx Execute Template With Multiple Data    Deal Change Transaction on Financial Ratio    ${ExcelPath}    ${rowid}    AMCH04_DealChangeTransaction   