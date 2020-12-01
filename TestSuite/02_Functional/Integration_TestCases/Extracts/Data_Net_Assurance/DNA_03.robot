*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

DNA_03
    [Documentation]    This test case is used to verify that the Data Net Assurance File is extracted once Data Net Assurance job is triggered.
    ...    @author: clanding    15OCT2020    - initial create

    Set Global Variable    ${TestCase_Name}    DNA_03
    Mx Execute Template With Specific Test Case Name    Verify Data Net Assurance File    ${DNA_DATASET}    Test_Case    ${TestCase_Name}    DNA