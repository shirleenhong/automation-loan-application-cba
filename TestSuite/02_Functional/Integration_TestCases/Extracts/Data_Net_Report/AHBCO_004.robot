*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***

Create Term and SBLC Loan Drawdown for Syndicated Deal - AHBCO_004
    [Documentation]   This DNR test case is used to create a TERM and SBLC Loan Drawdown wherein Cashflow is To Borrower.
    ...    and Loan Effective Date from dataset is backdated from LIQ System Date
    ...    NOTE: Execute the deal creation test case "Expanded_Scenario2_ToBorrower" first before executing this test case.
    ...    @author: shirhong    04DEC2020    - initial create
    Mx Execute Template With Multiple Data    Create Loan Drawdown TERM and SBLC for Syndicated Deal With Backdated Effective Date for DNR    ${DNR_DATASET}    ${rowid}    SC2_LoanDrawdown
    Mx Execute Template With Multiple Data    Write Cashflow ID for Agency Cashout Report    ${DNR_DATASET}    ${rowid}    SC2_LoanDrawdown

AHBCO_004
    [Documentation]    This test case is for Scenario 1- Verify that Report is displaying a freshly done Drawdown Cashflow on the report when Processing Date & Effective dates are different
    ...    NOTE: Agency Host Bank Cashout Report should be available already in the report path.
    ...    @author: shirhong    20NOV2020    - Initial create
    
    Set Global Variable    ${TestCase_Name}    AHBCO_004
    
    Mx Execute Template With Specific Test Case Name    Validation of Report and Dataset Value for Agency Host Bank Cash Out for Processing Date    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    AHBCO
    Mx Execute Template With Specific Test Case Name    Validation of Report and Dataset Value for Agency Host Bank Cash Out for Effective Date    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    AHBCO
    