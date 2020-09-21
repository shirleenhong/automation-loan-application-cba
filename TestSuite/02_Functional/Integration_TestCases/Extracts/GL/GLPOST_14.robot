*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Test Teardown    Close All Connections

*** Test Cases ***

GLPOST_14
    [Documentation]    This keyword is used to validate that GL Extract is successfully decrypted.
    ...    PREREQUISITE: Successful run of Batch Automation - LIQ and Essence.
    ...    @author: clanding    07SEP2020    - initial create
    
    Set Global Variable    ${TestCase_Name}    GLPOST_14
    Mx Execute Template With Specific Test Case Name    Decrypt GL Extract File    ${GLExcelPath}    Test_Case    ${TestCase_Name}    GL_Posting

GLPOST_14_MULTI_ENTITY
    [Documentation]    This keyword is used to validate that GL Extract is successfully decrypted.
    ...    PREREQUISITE: Successful run of Batch Automation - LIQ and Essence.
    ...    @author: clanding    09SEP2020    - initial create
    
    Set Global Variable    ${TestCase_Name}    GLPOST_14_AU|GLPOST_14_EU
    Mx Execute Template With Multiple Test Case Name    Decrypt GL Extract File    ${GLExcelPath}    Test_Case    ${TestCase_Name}    GL_Posting