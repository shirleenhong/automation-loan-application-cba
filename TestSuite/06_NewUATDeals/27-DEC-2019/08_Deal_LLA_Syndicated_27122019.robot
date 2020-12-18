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