*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    3

*** Test Cases ***

Get Fee Details for Facility with Manual Adjustment Tansaction
    [Documentation]   This CommSee test case is used to get the Customer's Ongoing Fee details that has Bilateral Deal with One Borrower and One Facility in it.
    ...    Pre-requisite test case is COMMSEE_V2_FEE015
    ...    @author: cfrancis    01OCT2020    - Initial Create
    Mx Execute Template With Multiple Data    Update Line Fee Cycle - Scenario 7 ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_OngoingFeePayment 
    Mx Execute Template With Multiple Data    Create Payment Reversal - Scenario 7 ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_OngoingFeePayment
    Mx Execute Template With Multiple Data    Write Facility Ongoing Fee Details - Scenario 7 ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_FacFeeSetup 
    Mx Execute Template With Multiple Data    Get and Validate API Fee Response    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_FacFeeSetup