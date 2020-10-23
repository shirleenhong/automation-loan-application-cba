*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Test Cases ***
PTY_009
    [Documentation]    This test case is used to create Party in Quick Party Onboarding and validate duplicate shortname
    ...    @author: javinzon    20OCT2020    - initial create
    ...    @update: javinzon    22OCT2020    - added keywords to create party ID first before validating Duplicate Short Name
    
    Set Global Variable    ${TestCase_Name}    PTY009_CreatePartyID_DuplicateShortName
    Mx Execute Template With Specific Test Case Name    Create Party ID Successfully in Quick Party Onboarding    ${PTY_DATASET}    Test_Case    ${TestCase_Name}    QuickPartyOnboarding
    
    Set Global Variable    ${TestCase_Name}    PTY009_DuplicateShortName
    Mx Execute Template With Specific Test Case Name    Create Party in Quick Party Onboarding and Validate Duplicate Short Name    ${PTY_DATASET}    Test_Case    ${TestCase_Name}    QuickPartyOnboarding