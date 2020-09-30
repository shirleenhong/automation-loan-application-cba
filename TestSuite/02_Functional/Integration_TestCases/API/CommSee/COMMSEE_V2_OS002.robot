*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot


*** Variables ***
${rowid}    2

*** Test Case ***

Create Syndicated Deal And Get API Fee Response for ComSee
    [Documentation]   This ComSee test case is used to create a Syndicated Deal with Admin Fee.
    ...    This will also validate that when the Admin Fee is included on the GET API Fee Details response payload, the scripts fail.
    ...    This will also validate the Deal Details.
    ...    author: rtarayao    21AUG2019    - Initial Create

    Mx Execute Template With Multiple Data    Setup Syndicated Deal - ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC2_Deal
    Mx Execute Template With Multiple Data    Setup Deal Administrative Fees - ComSee    ${ComSeeDataSet}	${rowid}    ComSee_SC2_AdminFee
    Mx Execute Template With Multiple Data    Setup Term Facility for Syndicated Deal - ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC2_FacSetup
    Mx Execute Template With Multiple Data    Setup Fees for Term Facility - ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC2_FacFeeSetup
    Mx Execute Template With Multiple Data    Setup Primaries for Syndicated Deal - ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC2_Deal
    Mx Execute Template With Multiple Data    Approve and Close Syndicated Deal - ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC2_Deal
    Mx Execute Template With Multiple Data    Write Post Deal Details for Scenario 2 ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC2_Deal
    Mx Execute Template With Multiple Data    Write Facility Ongoing Fee Details for Syndicated Deal - ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC2_Deal
  
Get API Outstanding Response for ComSee
    [Documentation]   This ComSee test case creates loan for a Syndicated deal. 
    ...    This also validates that the GET API Response payload for the Outstanding details is correct.
    ...    author: rtarayao    21AUG2019    - Initial Create
    Mx Execute Template With Multiple Data    Create Loan Drawdown for Syndicated Deal - ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC2_Loan
    Mx Execute Template With Multiple Data    Write Loan Details for ComSee - Scenario 2    ${ComSeeDataSet}   ${rowid}    ComSee_SC2_Loan
    Mx Execute Template with Multiple Data    Get and Validate API Outstanding Response   ${ComSeeDataSet}    ${rowid}    ComSee_SC2_Loan