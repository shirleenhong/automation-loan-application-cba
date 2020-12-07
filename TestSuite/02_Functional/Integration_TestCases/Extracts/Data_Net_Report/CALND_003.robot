*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
CALND_003_EqualDate
    [Documentation]    This test case is used to validate that the Calendar Report is generated for Fee with RELEASED status.
    ...    NOTE: Calendar Report should be available in the report path.
    ...    @author: clanding    07DEC2020    - initial create

    Set Global Variable    ${TestCase_Name}    CALND_003_EqualFeeDate
    Mx Execute Template With Specific Test Case Name    Validate Equal Fee Cycle and Adjusted Due Date if Correct    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    CALND

CALND_003_DifferentDate
    [Documentation]    This test case is used to validate that the Calendar Report is generated for Fee with RELEASED status.
    ...    NOTE: Calendar Report should be available in the report path.
    ...    @author: clanding    07DEC2020    - initial create

    Set Global Variable    ${TestCase_Name}    CALND_003_UpdateFeeDate
    Mx Execute Template With Specific Test Case Name    Validate Different Fee Cycle and Adjusted Due Date if Correct    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    CALND