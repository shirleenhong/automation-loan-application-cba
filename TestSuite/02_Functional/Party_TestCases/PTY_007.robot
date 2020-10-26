*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot


*** Test Cases ***
PTY_007
    [Documentation]    This test case is used to check and reject a Duplicate Enterprise Name
    ...    @author: javinzon    28SEP2020    - initial create
    ...    @update: javinzon    23OCT2020    - added keywords to create party ID first before validating Duplicate Enterprise Name
    
    Set Global Variable    ${TestCase_Name}    PTY007_CreatePartyID_DuplicateEnterpriseName
    Mx Execute Template With Specific Test Case Name    Create Party ID Successfully in Quick Party Onboarding    ${PTY_DATASET}    Test_Case    ${TestCase_Name}    QuickPartyOnboarding
    
    Set Global Variable    ${TestCase_Name}    PTY007_DuplicateEnterpriseName
    Mx Execute Template With Specific Test Case Name    Check and Reject a Duplicate Enterprise Name     ${PTY_DATASET}    Test_Case    ${TestCase_Name}    QuickPartyOnboarding

    