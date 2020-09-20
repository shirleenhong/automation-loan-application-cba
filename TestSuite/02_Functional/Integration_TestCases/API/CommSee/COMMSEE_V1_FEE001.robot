*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

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
    Mx Execute Template With Multiple Data    Get and Validate API Fee Response    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_FacFeeSetup 
    
# Create Initial Loan Drawdown with no Repayment Schedule and Update Commitment Fee Cycle
    # [Documentation]   This test case creates a Fixed Rate Loan Drawdown. 
    # ...    author: rtarayao    12AUG2019    - Initial Create
    # Mx Execute Template With Multiple Data    Create Initial Loan Drawdown with no Repayment Schedule - Scenario 7 ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_Loan
    # Mx Execute Template With Multiple Data    Update Commitment Fee Cycle - Scenario 7 ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_OngoingFeePayment 

# Write and Validate New Deal Facility and Fee Details
    # [Documentation]   This test case writes the new Deal Facility details as well as the Fee Details.
    # ...    This also compares the written values from Deal Facility and Fee to the GET API Response payload.
    # ...    author: rtarayao    12AUG2019    - Initial Create
    # Mx Execute Template With Multiple Data    Write Post Deal Details after Loan Creation for Scenario 7 ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_Deal  
    # Mx Execute Template With Multiple Data    Write Facility Ongoing Fee Details - Scenario 7 ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_FacFeeSetup 
    # Mx Execute Template With Multiple Data    Get Response for Deal Single Facility - Scenario7    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_Deal
    # Mx Execute Template With Multiple Data    Get and Validate API Fee Response    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_FacFeeSetup 
    # ###Run EOD###
    # Pause Execution

# Pay Updated Commitment Fee
    # [Documentation]   This ComSee test case pays the Facility Ongoing Fee - Commitment Fee. 
    # ...    author: rtarayao    13SEP2019    - Initial Create
    # Mx Execute Template With Multiple Data    Pay Commitment Fee Amount - Scenario 7 ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_OngoingFeePayment    
    
# Pay Loan Unscheduled Principal and Interest
    # [Documentation]   This ComSee test case pays the Loan Principal and Interest.
    # ...    author: rtarayao    13SEP2019    - Initial Create
    # Mx Execute Template With Multiple Data    Initiate Interest Payment - Scenario 7 ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_LoanInterestPayment 
    # Mx Execute Template With Multiple Data    Unscheduled Principal Payment for Loan with No Repayment Schedule - Scenario 7 ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_PrincipalLoanPayment

# Get Deal Facility Details After Loan And Fee Payment
    # [Documentation]   This ComSee test case is used to get and validate Customer's Deal Facility and Fee Details. 
    # ...    author: rtarayao    11SEP2019    - Initial Create
    # Mx Execute Template With Multiple Data    Write Facility Details for Scenario 7 After Loan And Fee Payment - ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_Deal
    # Mx Execute Template With Multiple Data    Write Facility Ongoing Fee Details - Scenario 7 ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_FacFeeSetup 
    # Mx Execute Template With Multiple Data    Get Response for Deal Single Facility - Scenario7    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_Deal 
    # Mx Execute Template With Multiple Data    Get and Validate API Fee Response    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_FacFeeSetup 