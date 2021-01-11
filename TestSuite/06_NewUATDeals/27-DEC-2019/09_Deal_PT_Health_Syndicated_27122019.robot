*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
Get Dataset for PT Health Syndicated Deal
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    PT_Health_SYND    UAT_Deal_Scenarios
    
Create Quick Party Onboarding for PT Health Syndicated Deal - PTY001
    Mx Execute Template With Multiple Data    Create Deal Borrower Initial Details in Quick Party Onboarding for PT Health Syndicated Deal    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding
    Mx Execute Template With Multiple Data    Search Customer and Complete Borrower Profile Creation with Default Values for PT Health Syndicated Deal    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding