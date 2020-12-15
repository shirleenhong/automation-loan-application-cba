*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***

Initiate Line Fee Payment - AHBCO_005
    [Documentation]    This test case will pay the Line Fee for Agency DE after 1 day EOD
    ...    NOTE: Execute the deal creation test case "Expanded_Scenario2_ToBorrower" first and 1 day EOD before executing these test cases.
    ...    @author: shirhong    10DEC2020    - initial create   
    Mx Execute Template With Multiple Data    Update Line Fee Cycle for DNR    ${DNR_DATASET}    ${rowid}    SC2_PaymentFees
    Mx Execute Template With Multiple Data    Pay Line Fee Amount - Syndicated for DNR    ${DNR_DATASET}    ${rowid}    SC2_PaymentFees
    Mx Execute Template With Multiple Data    Create Cycle Share Adjustment for Fee Accrual- Payment Reversal for DNR    ${DNR_DATASET}    ${rowid}    SC2_CycleShareAdjustment
    Mx Execute Template With Multiple Data    Write Cashflow ID for Agency Cashout Report from Cycle Share Adjustment - Payment Reversal    ${DNR_DATASET}    ${rowid}    SC2_CycleShareAdjustment
    
Write Filter Details for Agency Host Bank Cashout Report in DNR Data Set
    [Documentation]   This DNR test case is used to get the value of the Loan Drawdown's processing date and to generate the Agency Host Bank Cashout Report
    ...    @author: shirhong    07DEC2020    - initial create    
    Set Global Variable    ${TestCase_Name}    AHBCO_005
    Mx Execute Template With Specific Test Case Name    Write Filter Details for Agency Host Bank Cashout Report in DNR Data Set from Cycle Share Adjustment - Payment Reversal    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR 
    Mx Execute Template With Specific Test Case Name    Generate DNR Report for Payment    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR     

Report Validation for AHBCO_005
    [Documentation]    This test case is for Scenario 1- Verify that Report is displaying a freshly done Drawdown Cashflow on the report when Processing Date & Effective dates are same
    ...    NOTE: Agency Host Bank Cashout Report should be available already in the report path.
    ...    @author: shirhong    15DEC2020    - Initial create   
    Set Global Variable    ${TestCase_Name}    AHBCO_005
    Mx Execute Template With Specific Test Case Name    Validation of Report and Dataset Value for Agency Host Bank Cash Out for Currency    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    AHBCO
    Mx Execute Template With Specific Test Case Name    Validation of Report and Dataset Value for Agency Host Bank Cash Out for Cashflow Direction    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    AHBCO
    Mx Execute Template With Specific Test Case Name    Validation of Report and Dataset Value for Agency Host Bank Cash Out for Payment Processing Date    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    AHBCO
    Mx Execute Template With Specific Test Case Name    Validation of Report and Dataset Value for Agency Host Bank Cash Out for Payment Effective Date    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    AHBCO
    Mx Execute Template With Specific Test Case Name    Validation of Report and Dataset Value for Agency Host Bank Cash Out for Transaction Description    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    AHBCO
    
