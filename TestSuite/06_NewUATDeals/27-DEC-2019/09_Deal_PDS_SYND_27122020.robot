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
