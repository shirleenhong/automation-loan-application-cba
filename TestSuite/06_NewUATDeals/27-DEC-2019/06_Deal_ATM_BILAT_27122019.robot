*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Test Cases ***
Get Dataset for ATM BILAT
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    ATM_BILAT    UAT_Deal_Scenarios

Establish Party and Enrich Customers Data
    Set Global Variable    ${rowid}    1
    Mx Execute Template With Multiple Data    Create Deal Borrower in Quick Party Onboarding for ATM BILAT    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding
    Mx Execute Template With Multiple Data    Search Customer and Complete Borrower Profile Creation with Default Values for ATM Bilateral Deal    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding
    
    Set Global Variable    ${rowid}    2
    Mx Execute Template With Multiple Data    Create Deal Borrower in Quick Party Onboarding for ATM BILAT    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding
    Mx Execute Template With Multiple Data    Search Customer and Complete Borrower Profile Creation with Default Values for ATM Bilateral Deal    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding
        
Establish Deal for ATM BILAT
    Set Global Variable    ${rowid}    1
    Mx Execute Template With Multiple Data    Setup Deal for ATM BILAT    ${ExcelPath}    ${rowid}    CRED01_DealSetup