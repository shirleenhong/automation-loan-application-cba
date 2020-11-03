*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot


*** Test Cases ***
PTY_018
    [Documentation]    This test case is used to check if user details can be edited successfully
    ...    @author:nbautist    23OCT2020    -initial create
   
    Set Global Variable    ${TestCase_Name}    PTY018_AU_Party_Navigation
    Mx Execute Template With Specific Test Case Name    Update Regions For User And Restore User Details    ${PTY_DATASET}    Test_Case    ${TestCase_Name}    QuickPartyOnboarding