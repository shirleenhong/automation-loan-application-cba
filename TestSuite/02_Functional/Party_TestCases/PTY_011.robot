*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Test Cases ***
PTY_011
    [Documentation]    This test case is used to check for duplicate short name entered in Quick Party Onboarding for a single entity (AU). 
    ...    @author: nbautist    19OCT2020    - initial create
    
    Set Global Variable    ${DUPLICATE_SHORT_NAME}    ${EMPTY}
    Set Global Variable    ${TESTCASE_NAME_PARTY}    PTY011_DuplicateShortNameEdit_Party1
    Mx Execute Template With Specific Test Case Name    Create Party For Duplicate Short Name Validation     ${PTY_DATASET}    Test_Case    ${TESTCASE_NAME_PARTY}    QuickPartyOnboarding
    Set Global Variable    ${TESTCASE_NAME_PARTY}    PTY011_DuplicateShortNameEdit_Party2
    Mx Execute Template With Specific Test Case Name    Create Party For Duplicate Short Name Validation     ${PTY_DATASET}    Test_Case    ${TESTCASE_NAME_PARTY}    QuickPartyOnboarding
    
    ### Duplicate shortname value should be value from party 2 at this point
    Set Global Variable    ${TESTCASE_NAME_PARTY}    PTY011_DuplicateShortNameEdit_Party1
    Mx Execute Template With Specific Test Case Name    Update Party For Duplicate Short Name Validation     ${PTY_DATASET}    Test_Case    ${TESTCASE_NAME_PARTY}    QuickPartyOnboarding