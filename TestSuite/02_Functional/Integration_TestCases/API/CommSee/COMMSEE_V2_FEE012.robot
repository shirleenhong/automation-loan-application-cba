*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    2

*** Test Cases ***

Get Fee Details After Payment for SBLC Guarantee
    [Documentation]   This CommSee test case is used to get and validate Customer's Outstanding Fee Details after Issuance payment is made so that cycle due is zero.  
    ...    author: rtarayao    21AUG2019    - Initial Create
    Mx Execute Template With Multiple Data    Pay SBLC Issuance - ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC3_IssuanceFeePayment
    Mx Execute Template With Multiple Data    Get and Validate API Fee Response    ${ComSeeDataSet}    ${rowid}    ComSee_SC3_IssuanceFeePayment