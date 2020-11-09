*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Test Cases ***
PTY_013
    [Documentation]    This test case is used to validate field length of the following fields in Quick Party Onboarding: Enterprise Name,
	...	   Short Name, Post Code, Address Line 1, Address Line 2, Address Line 3, Address Line 4, Address City
    ...    @author: javinzon    06NOV2020    - initial create
    
    Set Global Variable    ${TestCase_Name}    PTY013_FieldLengthValidation
    Mx Execute Template With Specific Test Case Name    Validate Field Length in Quick Party Onboarding    ${PTY_DATASET}    Test_Case    ${TestCase_Name}    QuickPartyOnboarding