*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot


*** Test Cases ***
PTY_007
    [Documentation]    This test case is used to check and reject a Duplicate Enterprise Name
    ...    @author: javinzon    28SEP2020    - initial create
    
    Set Global Variable    ${TestCase_Name}    PTY007_DuplicateEnterpriseName
    Mx Execute Template With Specific Test Case Name    Check and Reject a Duplicate Enterprise Name     ${PTY_DATASET}    Test_Case    ${TestCase_Name}    QuickPartyOnboarding
    
PTY_007_EU
    [Documentation]    This test case is used to check and reject a Duplicate Enterprise Name for Europe Zone
    ...    @author: javinzon    02OCT2020    - initial create
    
    Set Global Variable    ${TestCase_Name}    PTY007_DuplicateEnterpriseName
    Mx Execute Template With Specific Test Case Name    Check and Reject a Duplicate Enterprise Name     ${PTY_DATASET}    Test_Case    ${TestCase_Name}    QuickPartyOnboarding
    