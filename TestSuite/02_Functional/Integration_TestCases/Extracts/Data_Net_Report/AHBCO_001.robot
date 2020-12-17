*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

AHBCO_001
    [Documentation]    This test case is for Scenario 1- Verify that Cashflow Amount Field will be replaced by Host Bank Share Amount in the Report
    ...    NOTE: Agency Host Bank Cashout Report should be available already in the report path. Execute this testcase after running AHBCO_003 or AHBCO_004.
    ...    @author: shirhong    17NOV2020    - Initial create
    
    Set Global Variable    ${TestCase_Name}    AHBCO_001
    
    Mx Execute Template With Specific Test Case Name    Validation of Report and Dataset Value for Agency Host Bank Cash Out for Host Bank Share Amount    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    AHBCO
