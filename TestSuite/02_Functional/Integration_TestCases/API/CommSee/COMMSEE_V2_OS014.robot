*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot


*** Variables ***
${rowid}    7

*** Test Case ***
    
Reverse Loan Advanced Interest Payment and Get Outstanding Details
    [Documentation]   This CommSee test case Reverses the Payment for Advanced Interest
    ...    pre-requisite test case is COMMSEE_V2_OS013
    ...    @ author: cfrancis    16OCT2020    - Initial Create
    Mx Execute Template With Multiple Data    Create Loan Interest Payment Reversal - Scenario 7 ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_LoanInterestPayment 
    Mx Execute Template With Multiple Data    Write Loan Details for ComSee - Scenario 7    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_Loan
    Mx Execute Template With Multiple Data    Get and Validate API Outstanding Response    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_Loan