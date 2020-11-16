*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Test Cases ***
PTY_019
    [Documentation]    This test case is used to create Party, and validate values of the following columns in GLTB_CROSSREFENCE Table 
    ...    of GLOBALCBS Schema: GLREFERNCEID, GLACTIVATED, GLSTATUS, GLENTITY
    ...    @author: javinzon    29OCT2020    - initial create

    Set Global Variable    ${TestCase_Name}    PTY019_GLTBCrossReference_ColumnsValidation
    Mx Execute Template With Specific Test Case Name    Create Party ID Successfully in Quick Party Onboarding    ${PTY_DATASET}    Test_Case    ${TestCase_Name}    QuickPartyOnboarding
    Mx Execute Template With Specific Test Case Name    Validate Columns of GLTB_CROSSREFERENCE Table in GLOBALCBS Schema     ${PTY_DATASET}    Test_Case    ${TestCase_Name}    QuickPartyOnboarding