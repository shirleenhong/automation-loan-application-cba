*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Test Cases ***
PTY_016
    [Documentation]    This test case is used to validate Branch field in Party Onboarding Page
    ...    @author: javinzon    13OCT2020    - initial create
    
    Set Global Variable    ${TestCase_Name}    PTY016_PartyOnboarding_Validation_Branch
    Mx Execute Template With Specific Test Case Name    Navigate to Quick Party Onboarding and Validate Branch in Party Onboarding Page     ${PTY_DATASET}    Test_Case    ${TestCase_Name}    QuickPartyOnboarding