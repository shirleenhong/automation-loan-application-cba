*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
Get Dataset for ATM BILAT
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Client    ATM_BILAT    Clients

Establish Party and Enrich Customers Data
    # Mx Execute Template With Multiple Data    Create Deal Borrower in Quick Party Onboarding for ATM BILAT    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding
    # Mx Execute Template With Multiple Data    Search Customer and Complete Borrower Profile Creation with Default Values for ATM Bilateral Deal    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding