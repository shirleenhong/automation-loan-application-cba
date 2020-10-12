*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot


*** Variables ***
${rowid}    5

*** Test Cases ***

Get Deal Details for Bilateral Deal with One Borrower and One Facility
    [Documentation]   This CommSee test case is used to get the Customer's Ongoing Fee details that has Bilateral Deal with One Borrower and One Facility in it.
    ...    @author: cfrancis    18SEP2020    - Initial Create
    Mx Execute Template With Multiple Data    Setup Bilateral Deal - Scenario 7 ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_Deal
    Mx Execute Template With Multiple Data    Setup Facility - Scenario 7 ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_FacSetup
    Mx Execute Template With Multiple Data    Setup Facility Fee - Scenario 7 ComSee     ${ComSeeDataSet}    ${rowid}    ComSee_SC7_FacFeeSetup
    Mx Execute Template With Multiple Data    Setup a Primary Notebook for Bilateral Deal - Scenario 7 ComSee   ${ComSeeDataSet}    ${rowid}    ComSee_SC7_Deal
    Mx Execute Template With Multiple Data    Write Post Deal Details for Scenario 7 ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_Deal
    Mx Execute Template With Multiple Data    Write Facility Ongoing Fee Details - Scenario 7 ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_FacFeeSetup

Create Initial Loan Drawdown with no Repayment Schedule and Update Commitment Fee Cycle
    [Documentation]   This test case creates a Fixed Rate Loan Drawdown. 
    ...    @author: cfrancis    07OCT2020    - Initial Create
    Mx Execute Template With Multiple Data    Create Initial Loan Drawdown with no Repayment Schedule - Scenario 7 ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_Loan
    Mx Execute Template With Multiple Data    Update Line Fee Cycle - Scenario 7 ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_OngoingFeePayment 
    Mx Execute Template With Multiple Data    Write Post Deal Details after Loan Creation for Scenario 7 ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_Deal  
    Mx Execute Template With Multiple Data    Write Loan Details for ComSee - Scenario 7    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_Loan
    Mx Execute Template With Multiple Data    Get and Validate API Outstanding Response    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_Loan
    