*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Test Cases ***
PTY_002
    [Documentation]    This test case is used to update customer details through the Maintain Party Details, Accepts the newly updated customer 
    ...    and validates the successfully updated customer in the LoanIQ Application
    ...    @author: javinzon    21SEP2020    - initial create
    
    Set Global Variable    ${TestCase_Name}    PTY002_CreatePartyID_MaintainPartyDetails
    Mx Execute Template With Specific Test Case Name    Create Party ID Successfully in Quick Party Onboarding    ${PTY_DATASET}    Test_Case    ${TestCase_Name}    QuickPartyOnboarding
    Mx Execute Template With Specific Test Case Name    Validate Party Details in Maintain Party Details Module    ${PTY_DATASET}    Test_Case    ${TestCase_Name}    QuickPartyOnboarding
    
    Set Global Variable    ${TestCase_Name}    PTY002_MaintainPartyDetails
    Mx Execute Template With Specific Test Case Name    Update Party Details in Maintain Party Details Module    ${PTY_DATASET}    Test_Case    ${TestCase_Name}    QuickPartyOnboarding
    