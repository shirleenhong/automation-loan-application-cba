*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

GLPOST_15
    [Documentation]    This test case is used to execute GL Validation Tool and validate output file if all Matched.
    ...    Prerequisite: Successful run of GLPOST_14.
    ...    @author: clanding    11SEP2020    - initial create
    
    Set Global Variable    ${TestCase_Name}    GLPOST_14    ### Descryption Process
    Set Global Variable    ${TestCase_Name_ValTool}    GLPOST_15
    Mx Execute Template With Specific Test Case Name    Get CSV File from Decryption    ${GLExcelPath}    Test_Case    ${TestCase_Name}    GL_Posting
    
    Set Global Variable    ${TestCase_Name}    GLPOST_15
    Mx Execute Template With Specific Test Case Name    Execute GL Validation Tool    ${GLExcelPath}    Test_Case    ${TestCase_Name}    GL_Posting