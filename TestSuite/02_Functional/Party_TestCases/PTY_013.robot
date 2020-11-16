*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Test Cases ***
PTY_013
    [Documentation]    This test case is used to populate and validate field length of the following fields in Quick Enterprise Party:
    ...    Enterprise Name, Post Code, Address Line 1, Address Line 2, Address Line 3, Address Line 4, Address City, Short Name.
    ...    @author: javinzon    06NOV2020    - initial create
    
    Set Global Variable    ${TestCase_Name}    PTY013_QuickEnterpriseParty_FieldLengthValidation
    Mx Execute Template With Specific Test Case Name    Validate Length of Fields in Quick Enterprise Party    ${PTY_DATASET}    Test_Case    ${TestCase_Name}    QuickPartyOnboarding
 
