*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot


*** Variables ***
${rowid}    6

*** Test Cases ***

Pay Loan Unscheduled Principal and Interest and Get Outstanding Details
    [Documentation]   This CommSee test case pays the Loan Principal and Interest
    ...    @ author: cfrancis    13SEP2019    - Initial Create

    Mx Execute Template With Multiple Data    Initiate Interest Payment - Scenario 7 ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_LoanInterestPayment 
    Mx Execute Template With Multiple Data    Write Loan Details for ComSee - Scenario 7    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_Loan
    Mx Execute Template With Multiple Data    Get and Validate API Outstanding Response    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_Loan