*** Settings ***
Resource    ../../Configurations/LoanIQ_Import_File.robot


*** Variables ***
${rowid}    1

*** Test Cases ***
### Sample ###
Create Quick Party Onboarding for CBA UAT Deal 1 - PTY001 
    Mx Execute Template With Multiple Data    Create Deal Borrower initial details in Quick Party Onboarding for D00000454    ${CBAUAT_ExcelPath}    1    PTY001_QuickPartyOnboarding
    Mx Execute Template With Multiple Data    Populate Quick Enterprise Party with Approval    ${CBAUAT_ExcelPath}    1    PTY001_QuickPartyOnboarding