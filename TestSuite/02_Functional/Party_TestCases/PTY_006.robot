*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Test Cases ***
PTY_006
    [Documentation]    This test case is used to check for duplicate short name entered in Quick Party Onboarding for a single entity (AU). 
    ...    @author: nbautist    03NOV2020    - initial create

    Set Global Variable    ${TestCase_Name}    PTY006_BulkPartyUpload
    Mx Execute Template With Specific Test Case Name    Perform Bulk Party Upload and Verify If Successful    ${PTY_DATASET}    Test_Case    ${TestCase_Name}    QuickPartyOnboarding