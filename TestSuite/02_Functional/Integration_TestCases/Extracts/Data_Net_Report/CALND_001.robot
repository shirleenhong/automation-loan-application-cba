*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Test Cases ***
CALND_001
    [Documentation]    This Keyword is for Scenario 1 of DNR - Validate Calendar Report based on the Filters of Branch, Proc Area and Financial Center - CLAND_001
    ...    NOTE: Calendar Report should be available in the report path.
    ...    @author: fluberio    18NOV2020    - initial create
    Set Global Variable    ${TestCase_Name}    CALND_001
    MX Execute Template With Specific Test Case Name    Validate Branch and Process Area and Deal Calendar of Calendar Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    CALND