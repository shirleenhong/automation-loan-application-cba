*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Test Setup    Login To Essence
Test Teardown    Logout from Essence

*** Test Cases ***

GLPOST_13
    [Documentation]    This test case is used to validate that the Essence EOD Control and System Date should reflect the correct Entity.
    ...    @author: clanding    10SEP2020    - initial create
    
    Set Global Variable    ${TestCase_Name}    GLPOST_13
    Mx Execute Template With Specific Test Case Name    Validate Essence EOD Control and System Date have Correct Entity    ${GLExcelPath}    Test_Case    ${TestCase_Name}    GL_Posting

GLPOST_13_MULTI_ENTITY
    [Documentation]    This test case is used to validate that the Essence EOD Control and System Date should reflect the correct Entity.
    ...    @author: clanding    16SEP2020    - initial create
    
    Set Global Variable    ${TestCase_Name}    GLPOST_13_AU|GLPOST_13_EU
    Mx Execute Template With Multiple Test Case Name    Validate Essence EOD Control and System Date have Correct Entity    ${GLExcelPath}    Test_Case    ${TestCase_Name}    GL_Posting