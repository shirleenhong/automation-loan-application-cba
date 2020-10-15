*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Test Cases ***
PTY_014
    [Documentation]    This test case is used to validate mandatory fields in Quick Party Onboarding
    
    Set Global Variable    ${TestCase_Name}    PTY014_QuickEnterpriseParty_Validation_Mandatory_Fields
    Mx Execute Template With Specific Test Case Name    Navigate to Quick Party Onboarding and Validate Mandatory Fields in Quick Enterprise Party Page     ${PTY_DATASET}    Test_Case    ${TestCase_Name}    QuickPartyOnboarding