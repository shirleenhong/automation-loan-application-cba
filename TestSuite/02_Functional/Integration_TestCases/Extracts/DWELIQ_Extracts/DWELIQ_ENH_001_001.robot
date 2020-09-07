*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

DWELIQ_ENH_001_001
    [Documentation]    This test case is used to verify that the User is able to check the new columns based on the LIQ Upgrade in the extracted CSV files.
    ...    Prerequiste: Successful run of DWELIQ_Multi_EV_003.
    ...    @author: clanding    03SEP2020    - initial create
    
    Set Global Variable    ${rowid}    1-30
    Mx Execute Template With Multiple Data    Validate New Columns Based on LIQ Upgrade in Extracted CSV Files    ${DWE_DATASET}    ${rowid}    DWELIQ_ENH_001_001