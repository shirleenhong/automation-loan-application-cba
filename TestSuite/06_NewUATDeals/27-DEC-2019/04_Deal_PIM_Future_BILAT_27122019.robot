*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot


*** Variables ***
${rowid}    1

*** Test Cases ***
Get Dataset for LBT BILAT
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    PIM_Future_BILAT    UAT_Deal_Scenarios

Create Borrower in Quick Party Onboarding - PTY001
    [Tags]    01 Create Borrower - PTY001
    Mx Execute Template With Multiple Data    Create Deal Borrower in Quick Party Onboarding for PIM Future BILAT    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding
    Mx Execute Template With Multiple Data    Search Customer and Complete its Borrower Profile in LIQ for PIM Future BILAT    ${ExcelPath}    ${rowid}    ORIG03_Customer

Establish Deal - CRED01
    [Tags]  02 Deal Setup - CRED01
    Mx Execute Template With Multiple Data    Setup Deal for PIM Future BILAT    ${ExcelPath}    ${rowid}    CRED01_DealSetup

Establish Facility - CRED01
	[Tags]  03 Create Facility - CRED01
    Mx Execute Template With Multiple Data    Create Facility for PIM Future BILAT    ${ExcelPath}    ${rowid}    CRED02_FacilitySetup
	Mx Execute Template With Multiple Data    Setup Facility Ongoing Fee for PIM Future BILAT    ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup
    Mx Execute Template With Multiple Data    Update Commitment for PIM Future BILAT    ${ExcelPath}    ${rowid}    SERV29_CommitmentFeePayment
	Mx Execute Template With Multiple Data    Setup Primary for PIM Future BILAT    ${ExcelPath}    ${rowid}    SYND02_PrimaryAllocation
    Mx Execute Template With Multiple Data    Approve and Close Deal    ${ExcelPath}    ${rowid}    SYND02_PrimaryAllocation
    Mx Execute Template With Multiple Data    Release Commitment Fee For PIM Future BILAT    ${ExcelPath}    ${rowid}    SERV29_CommitmentFeePayment

Create Initial Loan Drawdown - SERV01
    [Tags]  03 Create Initial Loan Drawdown - SERV01
    Mx Execute Template With Multiple Data    Create Initial Loan Drawdown for PIM Future BILAT    ${ExcelPath}    ${rowid}    SERV01_LoanDrawdown
    Mx Execute Template With Multiple Data    Send a Drawdown Intent Notice via Notice Application without FFC Validation    ${ExcelPath}    ${rowid}    Correspondence
    Set Test Variable    ${rowid}    2
    Mx Execute Template With Multiple Data    Send Notice via Notice Application without FFC Validation        ${ExcelPath}    ${rowid}    Correspondence