*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot


*** Variables ***
${rowid}    1

*** Test Cases ***
Create Borrower in Quick Party Onboarding - PTY001
    [Tags]    01 Create Borrower - PTY001
    Mx Execute Template With Multiple Data    Create Deal Borrower in Quick Party Onboarding for PIM Future BILAT    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding
    Mx Execute Template With Multiple Data    Search Customer and Complete its Borrower Profile in LIQ for PIM Future BILAT    ${ExcelPath}    ${rowid}    ORIG03_Customer

Establish Deal
    [Tags]  02 Deal Setup - CRED01
    Mx Execute Template With Multiple Data    Setup Deal for PIM Future BILAT    ${ExcelPath}    ${rowid}    CRED01_DealSetup