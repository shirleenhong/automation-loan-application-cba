*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
Get Dataset for New Life BILAT
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    New_Life_BILAT    UAT_Deal_Scenarios

Create Deal Borrower Initial Details in Quick Party Onboarding for New Life Bilateral Deal
    Mx Execute Template With Multiple Data    Create Deal Borrower Initial Details in Quick Party Onboarding for New Life Bilateral Deal    ${ExcelPath}    ${rowid}   PTY001_QuickPartyOnboarding
    Mx Execute Template With Multiple Data    Search Customer and Complete Borrower Profile Creation with Default Values for New Life Bilateral Deal    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding

Establish Deal - CRED01
    Mx Execute Template With Multiple Data    Setup Deal for New Life BILAT    ${ExcelPath}    ${rowid}    CRED01_DealSetup

Establish Facility - CRED01
    Mx Execute Template With Multiple Data    Create Facility for New Life BILAT    ${ExcelPath}     ${rowid}    CRED02_FacilitySetup
	Mx Execute Template With Multiple Data    Setup Facility Ongoing Fee for New Life BILAT    ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup
	Mx Execute Template With Multiple Data    Setup Primary for New Life BILAT    ${ExcelPath}    ${rowid}    SYND02_PrimaryAllocation
    Mx Execute Template With Multiple Data    Update Commitment Fee for New Life BILAT    ${ExcelPath}    ${rowid}    SERV29_CommitmentFeePayment
    Mx Execute Template With Multiple Data    Approve and Close Deal for New Life Bilat    ${ExcelPath}    ${rowid}    SYND02_PrimaryAllocation
    Mx Execute Template With Multiple Data    Release Commitment Fee for New Life Bilat    ${ExcelPath}    ${rowid}    SERV29_CommitmentFeePayment

Create Initial Loan Drawdown - $191,569,254.72
    Mx Execute Template With Multiple Data    Create Initial Loan Drawdown for New Life BILAT    ${ExcelPath}    ${rowid}    SERV01_LoanDrawdown

