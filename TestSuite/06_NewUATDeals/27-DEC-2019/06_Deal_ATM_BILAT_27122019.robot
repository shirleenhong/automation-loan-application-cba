*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
Get Dataset for ATM BILAT
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    ATM_BILAT    UAT_Deal_Scenarios

# Establish Party and Enrich Customers Data
    # Mx Execute Template With Multiple Data    Create Deal Borrower in Quick Party Onboarding for ATM BILAT    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding
    # Mx Execute Template With Multiple Data    Search Customer and Complete Borrower Profile Creation with Default Values for ATM Bilateral Deal    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding
    
    # Set Test Variable    ${rowid}    2
    # Mx Execute Template With Multiple Data    Create Deal Borrower in Quick Party Onboarding for ATM BILAT    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding
    # Mx Execute Template With Multiple Data    Search Customer and Complete Borrower Profile Creation with Default Values for ATM Bilateral Deal    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding
        
# Establish Deal for ATM BILAT
    # Mx Execute Template With Multiple Data    Setup Deal for ATM BILAT    ${ExcelPath}    ${rowid}    CRED01_DealSetup

Establish Facility for ATM BILAT
    Mx Execute Template With Multiple Data    Create Facility for ATM BILAT    ${ExcelPath}     ${rowid}    CRED02_FacilitySetup
    Mx Execute Template With Multiple Data    Setup Interest Pricing for ATM Bilateral Deal    ${ExcelPath}     ${rowid}    CRED02_FacilitySetup
    Mx Execute Template With Multiple Data    Set Multiple Amortization Schedule for Facility    ${ExcelPath}     ${rowid}    SERV15_SchComittmentDecrease