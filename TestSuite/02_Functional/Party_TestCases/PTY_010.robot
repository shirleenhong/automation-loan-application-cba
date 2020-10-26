*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Test Cases ***
PTY_010
    [Documentation]    This test case is used to create Party in Quick Party Onboarding and validate duplicate shortname across entities
    ...    @author: javinzon    23OCT2020    - initial create
    
    Set Global Variable    ${TestCase_Name}    PTY010_CreatePartyID_DuplicateShortName_AcrossEntities
    Mx Execute Template With Specific Test Case Name    Create Party ID Successfully in Quick Party Onboarding    ${PTY_DATASET}    Test_Case    ${TestCase_Name}    QuickPartyOnboarding
    
    Set Global Variable    ${TestCase_Name}    PTY010_DuplicateShortName_AcrossEntities
    Mx Execute Template With Specific Test Case Name    Create Party in Quick Party Onboarding and Validate Duplicate Short Name Across Entities    ${PTY_DATASET}    Test_Case    ${TestCase_Name}    QuickPartyOnboarding