*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
# Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_BASE_41
    [Documentation]    Send Golden Source File with Inactive Rate Tenor to SFTP and verify if reflected in LoanIQ.
    ...    @author: cfrancis    06SEP2019    - initial create
    
    Set Global Variable    ${rowid}    41    ### For Group 1
    Mx Execute Template With Multiple Data    Send GS File with Inactive Rate Tenor    ${ExcelPath}    ${rowid}    BaseRate_Fields
