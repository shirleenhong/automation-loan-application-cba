*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    3

*** Test Cases ***

Get Deal Details for Bilateral Deal with One Borrower and One Facility
    [Documentation]   This CommSee test case is used to get the Customer's Ongoing Fee details that has Bilateral Deal with One Borrower and One Facility in it.
    ...    @author: cfrancis    28SEP2020    - Initial Create
    Mx Execute Template With Multiple Data    Setup Bilateral Deal - Scenario 7 ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_Deal
    Mx Execute Template With Multiple Data    Setup Facility - Scenario 7 ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_FacSetup
    Mx Execute Template With Multiple Data    Setup Facility Fee - Scenario 7 ComSee     ${ComSeeDataSet}    ${rowid}    ComSee_SC7_FacFeeSetup
    Mx Execute Template With Multiple Data    Setup a Primary Notebook for Bilateral Deal - Scenario 7 ComSee   ${ComSeeDataSet}    ${rowid}    ComSee_SC7_Deal
    Mx Execute Template With Multiple Data    Write Post Deal Details for Scenario 7 ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_Deal
    Mx Execute Template With Multiple Data    Write Facility Ongoing Fee Details - Scenario 7 ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_FacFeeSetup 
    Mx Execute Template With Multiple Data    Get and Validate API Fee Response    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_FacFeeSetup
    Log to Console    Pause Execution - Run Daily EOD
    Pause Execution
    
Cycle Share Adustment and then Get Fee Details
    [Documentation]    This CommSee test case is used to Adjust the Cycle Share Amount
    ...    @author: cfrancis    28SEP2020    - Initial Create
    Mx Execute Template With Multiple Data    Create Cycle Share Adjustment for Fee Accrual - Scenario 7 ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_FacFeeSetup
    Mx Execute Template With Multiple Data    Write Facility Ongoing Fee Details - Scenario 7 ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_FacFeeSetup 
    Mx Execute Template With Multiple Data    Get and Validate API Fee Response    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_FacFeeSetup