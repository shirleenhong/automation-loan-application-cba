*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
  

*** Test Cases ***

Get Deal Details for Bilateral Deal with One Borrower and One Facility
    [Documentation]   This ComSee test case is used to get the Customer's account details that has Bilateral Deal with One Borrower and One Facility in it. 
    ...    author: rtarayao    12AUG2019    - Initial Create
    
    Set Test variable    ${rowid}    1
    Mx Execute Template With Multiple Data    Setup Bilateral Deal - ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC1_Deal
    Mx Execute Template With Multiple Data    Set Up Facility - ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC1_FacSetup
    Mx Execute Template With Multiple Data    Facility Fee Setup - ComSee     ${ComSeeDataSet}    ${rowid}    ComSee_SC1_FacFeeSetup
    Mx Execute Template With Multiple Data    Verify the Response 404 CBA not Lender    ${ComSeeDataSet}    ${rowid}    ComSee_SC1_Deal    
    Mx Execute Template With Multiple Data    Setup a Primary Notebook - Comsee   ${ComSeeDataSet}    ${rowid}    ComSee_SC1_Deal
    Mx Execute Template With Multiple Data    Write Post Deal Details for ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC1_Deal    
    Mx Execute Template With Multiple Data    Get Response for Deal Single Facility - Scenario1    ${ComSeeDataSet}    ${rowid}    ComSee_SC1_Deal