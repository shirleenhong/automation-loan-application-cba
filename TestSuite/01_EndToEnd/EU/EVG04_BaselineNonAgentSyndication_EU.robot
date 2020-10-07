*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot
#Test Teardown    Test Suite Tear Down

*** Variables ***
${rowid}    1
${SCENARIO}    4

*** Test Cases ***
Create Quick Party Onboarding - PTY001
    [Tags]    01 Create Party within Essence - PTY001
    Mx Execute Template With Multiple Data    Create Party in Quick Party Onboarding    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding

Search Customer and Complete its Borrower Profile Creation - ORIG03         
    [Documentation]    This keyword searches a customer and complete its Borrower Profile creation
    [Tags]    02 Complete Borrower's Profile - 0RIG03
    Mx Execute Template With Multiple Data    Search Customer and Complete its Borrower Profile Creation with default values    ${ExcelPath}    ${rowid}    ORIG03_Customer
