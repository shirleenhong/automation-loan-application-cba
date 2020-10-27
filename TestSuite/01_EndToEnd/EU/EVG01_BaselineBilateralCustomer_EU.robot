*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1
${SCENARIO}    1

*** Test Cases ***
Create Quick Party Onboarding - PTY001
    [Documentation]    This test case creates customer details through Quick Party Onboarding module of Fusion Party Application, 
    ...    Accepts newly created customer and validates successfully created customer in LoanIQ Application
    ...    @author:mcampomanes    02OCT2020    -initial create
    [Tags]    01 Create Party within Essence - PTY001
    Mx Launch UFT    Visibility=True    UFTAddins=Java    Processtimeout=300
    Mx LoanIQ Launch    Processtimeout=300
    Mx Execute Template With Multiple Data    Create Party in Quick Party Onboarding    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding
    
Search Customer and Complete its Borrower Profile Creation - ORIG03
    [Documentation]    This keyword searches a customer and complete its Borrower Profile creation
    ...    @author: ghabal
    [Tags]    01 Create Customer within Loan IQ - ORIG03
    Mx Execute Template With Multiple Data    Search Customer and Complete its Borrower Profile Creation with default values    ${ExcelPath}    ${rowid}    ORIG03_Customer
     
Deal Setup - CRED01
    [Tags]    03 Deal Setup - CRED01
    Mx Execute Template With Multiple Data    Setup a Bilateral Deal    ${ExcelPath}    ${rowid}    CRED01_DealSetup
    Mx Execute Template With Multiple Data    Create Facility    ${ExcelPath}    ${rowid}    CRED02_FacilitySetup
	Mx Execute Template With Multiple Data    Ongoing Fee Setup     ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup
	Mx Execute Template With Multiple Data    Setup a Primary Notebook    ${ExcelPath}    ${rowid}    SYND02_PrimaryAllocation

Scenario 1 - Calendar Load
    Mx Execute Template With Multiple Data    Send Valid Copp Clark Files    ${ExcelPath}    ${rowid}    Calendar_Fields

Create Initial Loan Drawdown - SERV01
    [Tags]    04 Create Initial Loan Drawdown - SERV01
    Mx Execute Template With Multiple Data    Create Initial Loan Drawdown with Repayment Schedule    ${ExcelPath}    ${rowid}    SERV01_LoanDrawdown
    
Initiate Ongoing Fee Payment - SERV29
    [Tags]    05 Initiate Ongoing Fee Payment - SERV29
    Mx Execute Template With Multiple Data    Update Commitment Fee Cycle    ${ExcelPath}    ${rowid}    SERV29_PaymentFees   
    Log to Console    Pause Execution - Run Daily EOD
    Pause Execution
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
    
Deal Change Transaction - AMCH04
    [Tags]    09 Deal Change Transaction - AMCH04
    Mx Execute Template With Multiple Data    Deal Change Transaction on Financial Ratio    ${ExcelPath}    ${rowid}    AMCH04_DealChangeTransaction   