*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot


*** Variables ***
${rowid}    2

*** Test Cases ***

Get API Fee Response for ComSee 
    [Documentation]   This ComSee test case is used to create a Syndicated Deal with Admin Fee.
    ...    This will also validate that when the Admin Fee is included on the GET API Fee Details response payload, the scripts fail.
    ...    This will also validate the Deal Details.
    ...    author: rtarayao    21AUG2019    - Initial Create
    ...    @author: srcuisia    19SEPT2020    - Add Version- for version 2
    
    Mx Execute Template With Multiple Data    Get Response for Deal Single Facility - Scenario2    ${ComSeeDataSet}    ${rowid}    ComSee_SC2_Deal
    Mx Execute Template With Multiple Data    Get and Validate API Fee Response    ${ComSeeDataSet}    ${rowid}    ComSee_SC2_Deal

Get API Outstanding Response for ComSee
    [Documentation]   This ComSee test case creates loan for a Syndicated deal. 
    ...    This also validates that the GET API Response payload for the Outstanding details is correct.
    ...    author: rtarayao    21AUG2019    - Initial Create
    
    Mx Execute Template with Multiple Data    Get and Validate API Outstanding Response    ${ComSeeDataSet}    ${rowid}    ComSee_SC2_Loan