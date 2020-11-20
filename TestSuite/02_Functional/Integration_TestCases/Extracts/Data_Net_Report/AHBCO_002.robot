*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***
 
AHBCO_002
    [Documentation]    This test case is for Scenario 1- Verify that all the cashflows on the Cash Out Report are the ones with Unreleased or Released Status
    ...    NOTE: Agency Host Bank Cashout Report should be available already in the report path.
    ...    @author: shirhong    19NOV2020    - Initial create
    
    Set Global Variable    ${TestCase_Name}    AHBCO_002
    
    Mx Execute Template With Specific Test Case Name    Validation of Report and Dataset Value for Agency Host Bank Cash Out for Cashflow Status    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    AHBCO
    