*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1
${SCENARIO}    1

*** Test Cases ***
#___Start of Day 1
Create Quick Party Onboarding - PTY001
    [Tags]    01 Create Party within Essence - PTY001
    Set Global Variable    ${SCENARIO}    1
    Mx Execute Template With Multiple Data    Create Party in Quick Party Onboarding    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding
    
#Create Customer within Loan IQ - ORIG03
    #[Documentation]    This keyword creates Customer within LoanIQ
    #...    when using this, the following keywords(validations) should be disabled in the succeeding keyword 'Search Customer and Complete its Borrower Profile Creation - ORIG03'
    #...    -> Read Excel Data and Validate Customer ID, Short Name and Legal Name fields
    #...    -> Check Legal Address Details Under Profiles Tab
    #...    @author: ghabal
    #[Tags]    01 Create Customer within Loan IQ - ORIG03
    #Mx Execute Template With Multiple Data    Create Customer within Loan IQ    ${ExcelPath}    ${rowid}    ORIG03_Customer
    
Search Customer and Complete its Borrower Profile Creation - ORIG03
    [Documentation]    This keyword searches a customer and complete its Borrower Profile creation
    ...    @author: ghabal
    [Tags]    02 Complete Borrower's Profile - 0RIG03
    Mx Execute Template With Multiple Data    Search Customer and Complete its Borrower Profile Creation with default values    ${ExcelPath}    ${rowid}    ORIG03_Customer
    
Deal Setup - CRED01
    [Tags]    03 Deal Setup - CRED01
    Mx Execute Template With Multiple Data    Setup a Bilateral Deal    ${ExcelPath}    ${rowid}    CRED01_DealSetup
    Mx Execute Template With Multiple Data    Create Facility    ${ExcelPath}    ${rowid}    CRED02_FacilitySetup
    Mx Execute Template With Multiple Data    Facility Fee Setup     ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup
    Mx Execute Template With Multiple Data    Setup a Primary Notebook    ${ExcelPath}    ${rowid}    CRED01_DealSetup

Create Initial Loan Drawdown - SERV01
    [Tags]    04 Create Initial Loan Drawdown - SERV01
    Mx Execute Template With Multiple Data    Create Initial Loan Drawdown with Repayment Schedule    ${ExcelPath}    ${rowid}    SERV01_LoanDrawdown
    
Initiate Ongoing Fee Payment - SERV29
    [Tags]    05 Initiate Ongoing Fee Payment - SERV29
    Mx Execute Template With Multiple Data    Update Commitment Fee Cycle    ${ExcelPath}    ${rowid}    SERV29_PaymentFees   
