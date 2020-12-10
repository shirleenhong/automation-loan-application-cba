*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
CALND_004
    [Documentation]    This test case is used to validate that the Calendar Report is generated for a RELEASED Outstanding based on the dates filter applied.
    ...    NOTE: Calendar Report should be available in the report path.
    ...    PREREQUISITE: Run completed for CALND_003.robot
    ...    @author: clanding    07DEC2020    - initial create

    ### Generate Calendar Report for Equal Fee Date ###
    Set Global Variable    ${TestCase_Name}    CALND_004
    Mx Execute Template With Specific Test Case Name    Get Different Due and Ajdusted Due Date and Write in Filter for Calendar Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    Mx Execute Template With Specific Test Case Name    Generate DNR Report for Calendar    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    Mx Execute Template With Specific Test Case Name    Write Details for Calendar Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
	Mx Execute Template With Specific Test Case Name    Validate Different Fee Cycle and Adjusted Due Date if Correct    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    CALND