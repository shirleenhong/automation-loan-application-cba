*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Test Cases ***
PTY_017
    [Documentation]    This test case is used to validate available SIC (Business Activity) in Quick Party Onboarding.
    ...    @author: javinzon    05OCT2020    - initial create
    
    Set Global Variable    ${TestCase_Name}    PTY017_QuickPartyOnboarding_FieldsValidationForSIC
    Mx Execute Template With Specific Test Case Name    Validate Business Activity Options in Quick Party Onboarding     ${PTY_DATASET}    Test_Case    ${TestCase_Name}    QuickPartyOnboarding