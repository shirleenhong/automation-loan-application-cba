*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot


*** Test Cases ***
PTY_001_EU
    [Documentation]    This test case is used to create customer details through the Quick Party Onboarding module of the Fusion Party Application, 
    ...    Accepts the newly created customer and validates the successfully created customer in the LoanIQ Application
    ...    @author:javinzon    15SEP2020    -initial create
   
    Set Global Variable    ${TestCase_Name}    PTY001_QuickPartyOnboarding
    Set Global Variable    ${SCENARIO}    0
    Mx Execute Template With Specific Test Case Name    Create Party in Quick Party Onboarding    ${ExcelPath}    Test_Case    PTY001_QuickPartyOnboarding    QuickPartyOnboarding