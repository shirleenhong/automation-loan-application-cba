*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Test Cases ***
PTY_016
    [Documentation]    This test case is used to validate Branch field in Party Onboarding Page
    ...    @author: javinzon    13OCT2020    - initial create

    Set Global Variable    ${TestCase_Name}    PTY020_PartyCrossReferenceDetails
    Mx Execute Template With Specific Test Case Name    Create Party ID Successfully in Quick Party Onboarding    ${PTY_DATASET}    Test_Case    ${TestCase_Name}    QuickPartyOnboarding
    Mx Execute Template With Specific Test Case Name    Create Party ID and Validate GLAPPLICATION column in Party Database     ${PTY_DATASET}    Test_Case    ${TestCase_Name}    QuickPartyOnboarding