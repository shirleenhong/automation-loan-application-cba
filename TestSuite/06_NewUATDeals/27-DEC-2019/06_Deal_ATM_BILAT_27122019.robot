*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
Get Dataset for ATM BILAT
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    ATM_BILAT    UAT_Deal_Scenarios

Establish Party and Enrich Customers Data
    Mx Execute Template With Multiple Data    Create Deal Borrower in Quick Party Onboarding for ATM BILAT    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding
    Mx Execute Template With Multiple Data    Search Customer and Complete Borrower Profile Creation with Default Values for ATM Bilateral Deal    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding
    
    Set Test Variable    ${rowid}    2
    Mx Execute Template With Multiple Data    Create Deal Borrower in Quick Party Onboarding for ATM BILAT    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding
    Mx Execute Template With Multiple Data    Search Customer and Complete Borrower Profile Creation with Default Values for ATM Bilateral Deal    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding
        
Establish Deal for ATM BILAT
    Mx Execute Template With Multiple Data    Setup Deal for ATM BILAT    ${ExcelPath}    ${rowid}    CRED01_DealSetup

Establish Facility for ATM BILAT
    Mx Execute Template With Multiple Data    Create Facility for ATM BILAT    ${ExcelPath}     ${rowid}    CRED02_FacilitySetup
    Mx Execute Template With Multiple Data    Set Multiple Amortization Schedule for Facility    ${ExcelPath}     ${rowid}    SERV15_SchComittmentDecrease
    Mx Execute Template With Multiple Data    Add Another Facility with Ongoing Fees for ATM BILAT    ${ExcelPath}     ${rowid}    CRED02_FacilitySetup

Establish Line Fee in Advance for ATM BILAT 
    Mx Execute Template With Multiple Data    Setup Line Fee in Advance for ATM BILAT    ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup
    
Setup Primaries and Close Deal
    Mx Execute Template With Multiple Data    Setup Primaries for ATM BILAT    ${ExcelPath}    ${rowid}    SYND02_PrimaryAllocation
    Mx Execute Template With Multiple Data    Approve and Close ATM BILAT    ${ExcelPath}    ${rowid}    SYND02_PrimaryAllocation
    Mx Execute Template With Multiple Data    Release Ongoing Fee for ATM BILAT    ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup
    
Create Drawdown and Back Date to 04/09/2019
    Set Test Variable    ${rowid}    2
    Mx Execute Template With Multiple Data    Create Loan Drawdown for ATM Bilateral Deal - Outstanding B    ${ExcelPath}    ${rowid}    SERV01_LoanDrawdown
    
Establish and Collection of Line Fee In Advance For Facility ATM (Period 1 and Period 2 (PaperClip))
    Set Test Variable    ${rowid}    2
    Mx Execute Template With Multiple Data    Pay Line Fee with Online Accrual for Facility ATM    ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup
    Set Test Variable    ${rowid}    1
    Mx Execute Template With Multiple Data    Collect Full Prepayment via Paper Clip for Facility ATM    ${ExcelPath}    ${rowid}    SERV23_LoanPaperClip
