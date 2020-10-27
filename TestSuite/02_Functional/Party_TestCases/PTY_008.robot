*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Test Cases ***
PTY_008
    [Documentation]    This test case is used to create Party in Quick Party Onboarding and validate duplicate Enterprise name across entities
    ...    @author: javinzon    27OCT2020    - initial create
    
    Set Global Variable    ${TestCase_Name}    PTY008_CreatePartyID_DuplicateEnterpriseName_AcrossEntities
    Mx Execute Template With Specific Test Case Name    Create Party in Quick Party Onboarding    ${PTY_DATASET}    Test_Case    ${TestCase_Name}    QuickPartyOnboarding
    
    Set Global Variable    ${TestCase_Name}    PTY008_DuplicateEnterpriseName_AcrossEntities
    Mx Execute Template With Specific Test Case Name    Check and Reject a Duplicate Enterprise Name     ${PTY_DATASET}    Test_Case    ${TestCase_Name}    QuickPartyOnboarding
    