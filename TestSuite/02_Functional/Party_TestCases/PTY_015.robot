*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Test Cases ***
PTY_015
    [Documentation]    This test case is used to validate disabled fields in Quick Party Onboarding
    ...    @author: javinzon    08OCT2020    - initial create
    
    Set Global Variable    ${TestCase_Name}    PTY015_QuickPartyOnboarding_Validation_Disabled_Fields
    Mx Execute Template With Specific Test Case Name    Create Party ID and Validate Disabled Fields in Quick Enterprise Party Page     ${PTY_DATASET}    Test_Case    ${TestCase_Name}    QuickPartyOnboarding