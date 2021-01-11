*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
Get Dataset for LBT BILAT
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    LBT_BILAT    UAT_Deal_Scenarios
	
Create Quick Party Onboarding for LBT Bilateral Deal - PTY001 
    Mx Execute Template With Multiple Data    Create Deal Borrower Initial Details in Quick Party Onboarding for LBT Bilateral Deal    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding
    Mx Execute Template With Multiple Data    Search Customer and Complete Borrower Profile Creation with Default Values for LBT Bilateral Deal    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding

Establish Deal with Outside Condition
    Mx Execute Template With Multiple Data    Setup Deal for LBT BILAT Deal    ${ExcelPath}    ${rowid}    CRED01_DealSetup

Establish Facility for LBT Bilateral Deal
    Mx Execute Template With Multiple Data    Create Class A Note Facility for LBT Bilateral Deal    ${ExcelPath}    ${rowid}    CRED01_FacilitySetup

Establish Commitment Fee for LBT Bilateral Deal
    Mx Execute Template With Multiple Data    Setup Commitment Fee for LBT Bilateral Deal    ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup
    Mx Execute Template With Multiple Data    Setup Primary for LBT Bilateral Deal    ${ExcelPath}    ${rowid}    SYND02_PrimaryAllocation
    Mx Execute Template With Multiple Data    Approve and Close Deal    ${ExcelPath}    ${rowid}    SYND02_PrimaryAllocation
    Mx Execute Template With Multiple Data    Release Commitment Fee for LBT Bilateral Deal    ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup
    
Create Loan Drawdown for LBT Bilateral Deal 
    Mx Execute Template With Multiple Data    Create Loan Drawdown for LBT Bilateral Deal    ${ExcelPath}    ${rowid}    SERV01_LoanDrawdown
    Set Test Variable    ${rowid}    2
    Mx Execute Template With Multiple Data    Create Loan Drawdown for LBT Bilateral Deal    ${ExcelPath}    ${rowid}    SERV01_LoanDrawdown
    Set Test Variable    ${rowid}    3
    Mx Execute Template With Multiple Data    Create Loan Drawdown for LBT Bilateral Deal    ${ExcelPath}    ${rowid}    SERV01_LoanDrawdown   