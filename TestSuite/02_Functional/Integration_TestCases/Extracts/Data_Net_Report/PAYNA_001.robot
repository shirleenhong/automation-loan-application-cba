*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    4

*** Test Cases ***
PAYNA_001
    [Documentation]    This Keyword is for Scenario 1 of DNR - Validate that the Cash In Report is generated for all payments coming in for CBA - PAYNA_001
    ...    NOTE: Payment Non Agency Cash In Report Released Status should be available in the report path.
    ...    @author: fluberio    14DEC2020    - initial create
    Set Global Variable    ${TestCase_Name}    PAYNA_001
    MX Execute Template With Specific Test Case Name    Validate Cash In Report for Payment Non Agency is Generated for All Payments Coming in for CBA    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    PAYNA