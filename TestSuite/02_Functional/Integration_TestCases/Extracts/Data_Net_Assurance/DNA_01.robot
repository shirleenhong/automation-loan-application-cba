*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Test Setup    Test Setup for DNA
Test Teardown    Test Teardown for DNA

*** Test Cases ***

DNA_01
    [Documentation]    This test case is used to trigger Data Net Assurance job.
    ...    @author: clanding    13OCT2020    - initial create

    Set Global Variable    ${TestCase_Name}    DNA_01
    Mx Execute Template With Specific Test Case Name    Trigger Data Net Assurance Job    ${DNA_DATASET}    Test_Case    ${TestCase_Name}    DNA
