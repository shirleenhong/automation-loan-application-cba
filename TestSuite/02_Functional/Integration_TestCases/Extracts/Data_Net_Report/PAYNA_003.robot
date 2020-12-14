*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    4

*** Test Cases ***
PAYNA_003
    [Documentation]    This Keyword is for Scenario 1 of DNR - Validate that the Cash Out Report is generated for all transactions in Released status - PAYNA_003
    ...    NOTE: Payment Non Agency Cash Out Report Approved Status should be available in the report path.
    ...    @author: fluberio    11DEC2020    - initial create
    Set Global Variable    ${TestCase_Name}    PAYNA_003
    MX Execute Template With Specific Test Case Name    Validate Cash Out Report for Payment Non Agency is Generated for All Transactions in Released Status    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    PAYNA