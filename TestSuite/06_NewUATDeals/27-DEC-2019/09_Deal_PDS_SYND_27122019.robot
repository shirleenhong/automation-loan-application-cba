*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
Get Dataset for PDS Syndicate Deal
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    PDS_SYND    UAT_Deal_Scenarios

Create Quick Party Onboarding for PDS Syndicate Deal - PTY001 
    Mx Execute Template With Multiple Data    Create Deal Borrower Initial Details in Quick Party Onboarding for PDS Syndicate Deal    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding
    Mx Execute Template With Multiple Data    Search Customer and Complete Borrower Profile Creation with Default Values for PDS Syndicate Deal    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding

Create Syndicated Deal for PDS Syndicated Deal - CRED01
    Mx Execute Template With Multiple Data    Setup Deal for PDS SYND Deal    ${ExcelPath}    ${rowid}    CRED01_DealSetup

Establish Facility A - CRED02
    Mx Execute Template With Multiple Data    Create Facility A for PDS Syndicate Deal    ${ExcelPath}    ${rowid}    CRED02_FacilitySetup_A

Establish Commitment Fee for Facility A - CRED08
    Mx Execute Template With Multiple Data    Setup Commitment Fee for PDS Syndicate Deal    ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup_A
    
Setup Repayment Schedule for Facility A
    Mx Execute Template With Multiple Data    Add Repayment Schedule for PDS Syndicate Deal - Facility A    ${ExcelPath}    ${rowid}    CRED02_FacilitySetup_A

Establish Facility B - CRED02
    Mx Execute Template With Multiple Data    Create Facility B for PDS Syndicate Deal    ${ExcelPath}    ${rowid}    CRED02_FacilitySetup_B

Establish Commitment Fee for Facility B - CRED08
    Mx Execute Template With Multiple Data    Setup Commitment Fee for PDS Syndicate Deal    ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup_B
    
Setup Repayment Schedule for Facility B
    Mx Execute Template With Multiple Data    Add Repayment Schedule for PDS Syndicate Deal - Facility B    ${ExcelPath}    ${rowid}    CRED02_FacilitySetup_B

Setup Primaries and Close Deal
    Mx Execute Template With Multiple Data    Setup Primaries for PDS Syndicate Deal    ${ExcelPath}    ${rowid}    SYND02_PrimaryAllocation
    Mx Execute Template With Multiple Data    PDS Syndicated Deal Approval and Close    ${ExcelPath}    ${rowid}    SYND02_PrimaryAllocation
    Mx Execute Template With Multiple Data    Release Ongoing Fee for PDS Syndicate Deal    ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup_A
    Mx Execute Template With Multiple Data    Release Ongoing Fee for PDS Syndicate Deal    ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup_B

Create Drawdown A and Back Date to 09/18/19
    Mx Execute Template With Multiple Data    Create Loan Drawdown for PDS Syndicate Deal - Outstanding A    ${ExcelPath}    ${rowid}    SERV01_LoanDrawdown

Create Drawdown B and Back Date to 09/18/19
	Set Test Variable    ${rowid}    2
    Mx Execute Template With Multiple Data    Create Loan Drawdown for PDS Syndicate Deal - Outstanding B    ${ExcelPath}    ${rowid}    SERV01_LoanDrawdown
	