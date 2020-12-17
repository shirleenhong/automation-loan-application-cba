*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    4

*** Test Cases ***
PAYNA_004
    [Documentation]    This Keyword is for Scenario 1 of DNR - Validate that the DE Extract Report is generated for all payments coming in for CBA - PAYNA_004
    ...    NOTE: Payment Non Agency Cash In Report Released Status should be available in the report path.
    ...    @author: fluberio    15DEC2020    - initial create
    Set Global Variable    ${TestCase_Name}    PAYNA_004
    MX Execute Template With Specific Test Case Name    Validate DE Extract Report for Payment Non Agency is Generated for All Payments Coming in for CBA    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    PAYNA