*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    4

*** Test Cases ***
PAYNA_002
    [Documentation]    This Keyword is for Scenario 1 of DNR - Validate that the Cash Out Report is generated for all transactions in Approval status - PAYNA_002
    ...    NOTE: Payment Non Agency Cash Out Report Approved Status should be available in the report path.
    ...    @author: fluberio    10DEC2020    - initial create
    Set Global Variable    ${TestCase_Name}    PAYNA_002
    MX Execute Template With Specific Test Case Name    Validate Cash Out Report for Payment Non Agency is Generated for All Transactions in Approval Status    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    PAYNA