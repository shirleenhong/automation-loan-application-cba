*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_BASE_42
    [Documentation]    Send Golden Source File with Inactive Base Rate Code to SFTP and verify if reflected in LoanIQ.
    ...    @author: cfrancis    11SEP2019    - initial create
    
    Set Global Variable    ${rowid}    42    ### For Group 1
    Mx Execute Template With Multiple Data    Send GS File with Inactive Base Rate Code    ${ExcelPath}    ${rowid}    BaseRate_Fields
