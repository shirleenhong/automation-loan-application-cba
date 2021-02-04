*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1
${rowid_2}    2    

*** Test Cases ***
Get Dataset for PT Health Syndicated Deal
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    PT_Health_SYND    UAT_Deal_Scenarios
    
Create Quick Party Onboarding for PT Health Syndicated Deal - PTY001
    Mx Execute Template With Multiple Data    Create Deal Borrower Initial Details in Quick Party Onboarding for PT Health Syndicated Deal    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding
    Mx Execute Template With Multiple Data    Search Customer and Complete Borrower Profile Creation with Default Values for PT Health Syndicated Deal    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding
    
Create Syndicated Deal for PT Health Syndicated Deal - CRED01
    Mx Execute Template With Multiple Data    Setup Syndicated Deal for PT Health Syndicated    ${ExcelPath}    ${rowid}    CRED01_DealSetup
    
Establish Facility for PT Health Syndicated Deal - CRED02
    Mx Execute Template With Multiple Data    Create Facility for PT Health    ${ExcelPath}    ${rowid}    CRED02_FacilitySetup
    Mx Execute Template With Multiple Data    Setup Pricing for PT Health Syndicated Deal    ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup
    Mx Execute Template With Multiple Data    Setup Primaries for PT Health Syndicated Deal    ${ExcelPath}    ${rowid}    SYND02_PrimaryAllocation
    Mx Execute Template With Multiple Data    Update Line Fee for PT Health Syndicated    ${ExcelPath}    ${rowid}    SERV29_CommitmentFeePayment
    Mx Execute Template With Multiple Data    Update Facility Fee Expiry Date for PT Health Syndicated    ${ExcelPath}    ${rowid}    SERV29_CommitmentFeePayment
    Mx Execute Template With Multiple Data    PT Health Syndicated Deal Approval and Close    ${ExcelPath}    ${rowid}    SYND02_PrimaryAllocation
    Mx Execute Template With Multiple Data    Release Line Fee for PT Health Syndicated    ${ExcelPath}    ${rowid}    SERV29_CommitmentFeePayment
    
Create Initial Loan Drawdown - SERV01
    Mx Execute Template With Multiple Data    Create Initial Loan Drawdown for PT Health    ${ExcelPath}    ${rowid}    SERV01_LoanDrawdown
    
Establish and Collection of Line Fee for PT Health Syndicated Deal
    Mx Execute Template With Multiple Data    Pay Line Fee with Online Accrual for PT Health Syndicated Deal    ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup
    Mx Execute Template With Multiple Data    Pay Line Fee without Online Accrual for PT Health Syndicated Deal    ${ExcelPath}    ${rowid_2}    CRED08_OngoingFeeSetup