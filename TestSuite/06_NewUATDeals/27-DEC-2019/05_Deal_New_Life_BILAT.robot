*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***

Create Deal Borrower Initial Details in Quick Party Onboarding for New Life Bilateral Deal
    Mx Execute Template With Multiple Data    Create Deal Borrower Initial Details in Quick Party Onboarding for New Life Bilateral Deal    ${ExcelPath}    ${rowid}   PTY001_QuickPartyOnboarding
    Mx Execute Template With Multiple Data    Search Customer and Complete Borrower Profile Creation with Default Values for New Life Bilateral Deal    ${CBAUAT_ExcelPath}    1    PTY001_QuickPartyOnboarding

