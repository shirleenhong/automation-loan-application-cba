*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***

Create Quick Party Onboarding for LLA Syndicated Deal - PTY001
    Mx Execute Template With Multiple Data    Create Deal Borrower Initial Details in Quick Party Onboarding for LLA Syndicated Deal    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding
    Mx Execute Template With Multiple Data    Search Customer and Complete Borrower Profile Creation with Default Values for LLA Syndicated Deal    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding
    
Create Syndicated Deal for LLA Syndicated Deal - CRED01
    Mx Execute Template With Multiple Data    Setup Syndicated Deal for LLA Syndicated    ${ExcelPath}    ${rowid}    CRED01_DealSetup

Establish Facility for LLA Syndicated Deal - CRED02
    Mx Execute Template With Multiple Data    Create Revolver Facility for LLA Syndicated Deal    ${ExcelPath}    ${rowid}    CRED02_FacilitySetup
    Mx Execute Template With Multiple Data    Setup Pricing for LLA Syndicated Deal    ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup
    
Establish Primaries for LLA Syndicated Deal - SYND02
    Mx Execute Template With Multiple Data    Setup Primaries for LLA Syndicated Deal    ${ExcelPath}    ${rowid}    SYND02_PrimaryAllocation
    Mx Execute Template With Multiple Data    Update Ongoing Fee for LLA Syndicated Deal    ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup
    Mx Execute Template With Multiple Data    LLA Syndicated Deal Approval and Close    ${ExcelPath}    ${rowid}    SYND02_PrimaryAllocation
    Mx Execute Template With Multiple Data    Update Party Details in Maintain Party Details Module for LLA Syndicated Deal    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding
    
Establish and collect Line Fee for LLA Syndicated Deal
    Mx Execute Template With Multiple Data    Setup Line Fee in Arrears for LLA Syndicated Deal    ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup
    Mx Execute Template With Multiple Data    Send Notice for Line Fee    ${ExcelPath}    1    Correspondence
    Mx Execute Template With Multiple Data    Send Notice for Line Fee    ${ExcelPath}    2    Correspondence
    
