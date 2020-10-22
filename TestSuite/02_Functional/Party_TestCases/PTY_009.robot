*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Test Cases ***
PTY_009
    [Documentation]    This test case is used to create Party in Quick Party Onboarding and validate duplicate shortname
    ...    @author: javinzon    20OCT2020    - initial create
       
    Set Global Variable    ${TestCase_Name}    PTY009_DuplicateShortName
    Mx Execute Template With Specific Test Case Name    Create Party in Quick Party Onboarding and Validate Duplicate Short Name    ${PTY_DATASET}    Test_Case    ${TestCase_Name}    QuickPartyOnboarding