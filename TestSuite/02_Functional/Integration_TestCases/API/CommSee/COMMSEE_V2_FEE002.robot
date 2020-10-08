*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    4

*** Test Cases ***

Get Fee Details for Bilateral Deal with One Borrower and One Expired Facility
    [Documentation]   This CommSee test case is used to get the Customer's Ongoing Fee details that has Bilateral Deal with One Borrower and One Facility in it.
    ...    Data Setup for facility to expire after EOD
    ...    @author: cfrancis    05OCT2020    - Initial Create
    Mx Execute Template With Multiple Data    Setup Bilateral Deal - Scenario 7 ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_Deal
    Mx Execute Template With Multiple Data    Setup Expired Facility - Scenario 7 ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_FacSetup
    Mx Execute Template With Multiple Data    Setup Facility Fee - Scenario 7 ComSee     ${ComSeeDataSet}    ${rowid}    ComSee_SC7_FacFeeSetup
    Mx Execute Template With Multiple Data    Setup a Primary Notebook for Bilateral Deal - Scenario 7 ComSee   ${ComSeeDataSet}    ${rowid}    ComSee_SC7_Deal
    Mx Execute Template With Multiple Data    Update Facility Fee Expiry Date - Scenario 7 ComSee     ${ComSeeDataSet}    ${rowid}    ComSee_SC7_FacFeeSetup
    Mx Execute Template With Multiple Data    Write Post Deal Details for Scenario 7 ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_Deal
    Mx Execute Template With Multiple Data    Write Facility Ongoing Fee Details - Scenario 7 ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_FacFeeSetup 
    Mx Execute Template With Multiple Data    Get and Validate API Fee Response    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_FacFeeSetup
    Log to Console    Pause Execution - Run Daily EOD
    Pause Execution
    
Get Fee Details for Bilateral Deal with One Borrower and One Expired Facility
    [Documentation]   This CommSee test case is used to get the Customer's Ongoing Fee details that has Bilateral Deal with One Borrower and One Facility in it.
    ...    Needs to run 2 EODs for facility fee to expire
    ...    @author: cfrancis    05OCT2020    - Initial Create
    Mx Execute Template With Multiple Data    Write Facility Ongoing Fee Details - Scenario 7 ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_FacFeeSetup 
    Mx Execute Template With Multiple Data    Get and Validate API Fee Response    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_FacFeeSetup