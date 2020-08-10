*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot
#Test Teardown    Test Suite Tear Down

*** Variables ***
${rowid}    1
${SCENARIO}    4

*** Test Cases ***
###___Start of Day 1
Create Quick Party Onboarding - PTY001
    [Tags]    01 Create Party within Essence - PTY001
    Mx Execute Template With Multiple Data    Create Party in Quick Party Onboarding    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding

# Create Customer within Loan IQ - ORIG03
    # [Documentation]    This keyword creates Customer within LoanIQ
    # [Tags]    01 Create Customer within Loan IQ - ORIG03
    # Mx Execute Template With Multiple Data    Create Customer within Loan IQ    ${ExcelPath}    ${rowid}    ORIG03_Customer

Search Customer and Complete its Borrower Profile Creation - ORIG03         
    [Documentation]    This keyword searches a customer and complete its Borrower Profile creation
    [Tags]    02 Complete Borrower's Profile - 0RIG03
    Mx Execute Template With Multiple Data    Search Customer and Complete its Borrower Profile Creation with default values    ${ExcelPath}    ${rowid}    ORIG03_Customer

Create Non Agend and Host Bank Syndicated Deal - CRED01
    [Tags]    03 Non-Agent And Host Bank Syndicated Deal - CRED01
    Mx Execute Template With Multiple Data    Setup Syndicated Deal for Non-Agent and Host Bank    ${ExcelPath}    ${rowid}    CRED01_DealSetup
    Mx Execute Template With Multiple Data    NonAgent-HostBank Syndicated Deal - Setup Upfront Fees, Bank Role and Ratio    ${ExcelPath}    ${rowid}    CRED01_DealSetup  
    Mx Execute Template With Multiple Data    Setup Deal Event Fees    ${ExcelPath}    ${rowid}    CRED10_EventFee
    Mx Execute Template With Multiple Data    Create Revolver Facility    ${ExcelPath}    ${rowid}    CRED02_FacilitySetup
    Mx Execute Template With Multiple Data    NonAgent-HostBank Syndicated Deal - Setup Revolver Facility Fees and Interest    ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup
    Mx Execute Template With Multiple Data    Set up a Non-Host and Host Bank Primaries for Syndicated Deal    ${ExcelPath}    ${rowid}    SYND02_Primary_Allocation
    Mx Execute Template With Multiple Data    Syndicated Deal Approval and Close    ${ExcelPath}    ${rowid}    CRED01_DealSetup
   
Add Facility in Amendment Notebook - AMCH11
    [Documentation]    Add a New Facility via Amendment Notebook.
    [Tags]    04 Add Facility - AMCH11
    Mx Execute Template With Multiple Data    Add New Facility via Amendment Notebook    ${ExcelPath}    ${rowid}    AMCH11_AddFacility   

Setup Admin Fee - CRED09
    [Documentation]    Setup the Admin Fee to Deal
    [Tags]    05 Setup Admin Fee
    Mx Execute Template With Multiple Data    Setup Deal Administrative Fees    ${ExcelPath}	${rowid}    CRED09_AdminFee

Initiate Upfront Fee Payment - SYND05
    [Documentation]    Initiate Upfront Fee Payment.
    [Tags]    06 Upfront Fee Payment - SYND05
    Mx Execute Template With Multiple Data    Initiate Upfront Fee Payment    ${ExcelPath}    ${rowid}    SYND05_UpfrontFee_Payment

Initiate Admin Fee Payment - SERV30
    [Documentation]    Initiate Admin Fee Payment
    [Tags]    09 Initiate Admin Fee Payment
    Mx Execute Template With Multiple Data    Admin Fee Payment    ${ExcelPath}    ${rowid}    SERV30_AdminFeePayment  

Create Initial Loan Drawdown - SERV01
    [Documentation]    Creation of Initial Loan Drawdown
    [Tags]    07 Create Initial Loan Drawdown - SERV01A
    Mx Execute Template With Multiple Data    Create Initial Loan Drawdown with Repayment Schedule for Non Agent Syndication    ${ExcelPath}   ${rowid}    SERV01_LoanDrawdown

Create Pricing Change Transaction - AMCH06
    [Documentation]    Change Interest Pricing Matrix from Debt Service Cover Ratio (DSCR) into Loan to Value Ratio (LVR).
    [Tags]    08 Create Interest Pricing Change via Facility Notebook - AMCH11
    Mx Execute Template With Multiple Data    Create Interest Pricing Change via Facility Notebook    ${ExcelPath}    ${rowid}    AMCH06_PricingChangeTransaction
