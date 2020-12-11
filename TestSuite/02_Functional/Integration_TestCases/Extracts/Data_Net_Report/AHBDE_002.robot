*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${row_id}    2

*** Test Cases ***

Initiate Line Fee Payment - AHBDE_002
    [Documentation]    This test case will pay the Line Fee for Agency DE after 1 day EOD
    ...    @author: songchan    02DEC2020    - initial create
    ...    NOTE: Pre-requisite to run DealCreation/Expanded_Scenario2_FromBorrower.robot for deal creation and 1 day EOD
    
    Mx Execute Template With Multiple Data    Update Line Fee Cycle for DNR    ${DNR_DATASET}    ${rowid}    SC2_PaymentFees
    Mx Execute Template With Multiple Data    Pay Line Fee Amount - Syndicated for DNR    ${DNR_DATASET}    ${rowid}    SC2_PaymentFees

Write Filter Details for Agency Host Bank DE Report in DNR Data Set
    [Documentation]   This DNR test case is used to get the value of the processing date and to generate the Agency Host Bank DE Report
    ...    @author: songchan    10DEC2020    - initial create
    
    Set Global Variable    ${TestCase_Name}    AHBDE_002
    Mx Execute Template With Specific Test Case Name    Write Filter Details for Agency Host Bank DE Report in DNR Data Set    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR 
    Mx Execute Template With Specific Test Case Name    Generate DNR Report for Payment    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    
Report Validation for AHBDE_002
    [Documentation]    This test case is for Scenario 1- Verify that Report is displaying a freshly done Drawdown Cashflow on the report when Processing Date & Effective dates are same
    ...    NOTE: Agency Host Bank Cashout Report should be available already in the report path.
    ...    @author: songchan    10DEC2020    - Initial create
    
    Set Global Variable    ${TestCase_Name}    AHBDE_002
    
    Mx Execute Template With Specific Test Case Name    Validation of Report and Dataset Value for Agency Host Bank DE    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    AHBDE    