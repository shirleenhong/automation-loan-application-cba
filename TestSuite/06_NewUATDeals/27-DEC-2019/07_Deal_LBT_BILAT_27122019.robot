*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
Create Quick Party Onboarding for LBT Bilateral Deal - PTY001 
    Mx Execute Template With Multiple Data    Create Deal Borrower Initial Details in Quick Party Onboarding for LBT Bilateral Deal    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding
    Mx Execute Template With Multiple Data    Search Customer and Complete Borrower Profile Creation with Default Values for LBT Bilateral Deal    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding

Establish Facility for LBT Bilateral Deal
    Mx Execute Template With Multiple Data    Create Class A Note Facility for LBT Bilateral Deal    ${ExcelPath}    ${rowid}    CRED01_FacilitySetup
    
