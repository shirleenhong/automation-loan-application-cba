*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${row_id}    5

*** Test Cases ***

Initiate Agency Fee Payment - AHBDE_004
    [Documentation]    This test case will pay the Admin Fee Payment for Agency DE after 1 day EOD
    ...    @author: songchan    - Initial Create
    ...    NOTE: Pre-requisite to run DealCreation/Expanded_Scenario2_FromBorrower.robot for deal creation and 1 day EOD
    
    Mx Execute Template With Multiple Data    Admin Fee Payment for DNR    ${DNR_DATASET}    ${rowid}    SC2_AdminFeePayment
    
Write Filter Details for Agency Host Bank DE Report in DNR Data Set
    [Documentation]   This DNR test case is used to get the value of the processing date and to generate the Agency Host Bank DE Report
    ...    @author: songchan    14DEC2020    - initial create
    
    Set Global Variable    ${TestCase_Name}    AHBDE_004
    Mx Execute Template With Specific Test Case Name    Write Filter Details for Agency Host Bank DE Report in DNR Data Set    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR 
    Mx Execute Template With Specific Test Case Name    Generate DNR Report for Payment    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    
Report Validation for AHBDE_004
    [Documentation]    This test case is for Scenario 2 - Verify details after Admin Fee Payment
    ...    @author: songchan    14DEC2020    - Initial create
    
    Set Global Variable    ${TestCase_Name}    AHBDE_004
    
    Mx Execute Template With Specific Test Case Name    Validation of Report and Dataset Value for Agency Host Bank DE - AHBDE_004    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    AHBDE  