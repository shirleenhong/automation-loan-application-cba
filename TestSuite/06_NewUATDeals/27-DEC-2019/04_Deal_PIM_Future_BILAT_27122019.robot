*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot


*** Variables ***
${rowid}    1

*** Test Cases ***
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