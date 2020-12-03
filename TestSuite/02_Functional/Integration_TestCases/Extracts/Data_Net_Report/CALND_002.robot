*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
CALND_002
    [Documentation]    This Keyword is for Scenario 1 of DNR - Validate that the Calendar Report is generated for Outstanding with RELEASED status - CLAND_002
    ...    NOTE: Calendar Report should be available in the report path.
    ...    @author: fluberio    03DEC2020    - initial create
    ### Generate Calendar report after drawdown
    Set Global Variable    ${TestCase_Name}    CALND_002
    Mx Execute Template With Specific Test Case Name    Validate that the Calendar Report is Generated for Outstanding with RELEASED status    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    CALND