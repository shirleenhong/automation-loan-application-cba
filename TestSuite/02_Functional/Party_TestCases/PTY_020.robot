*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Test Cases ***
PTY_020
    [Documentation]    This test case is used to validate if only COMRLENDING and PARTY are available in GL Application Column of Party Database.
    ...    @author: javinzon    29OCT2020    - initial create

    Set Global Variable    ${TestCase_Name}    PTY020_PartyCrossReferenceDetails
    Mx Execute Template With Specific Test Case Name    Create Party ID Successfully in Quick Party Onboarding    ${PTY_DATASET}    Test_Case    ${TestCase_Name}    QuickPartyOnboarding
    Mx Execute Template With Specific Test Case Name    Validate GL Application Column in Party Database     ${PTY_DATASET}    Test_Case    ${TestCase_Name}    QuickPartyOnboarding