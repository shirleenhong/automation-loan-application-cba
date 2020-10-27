*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_BASE_03
    [Documentation]    Send Multiple Golden Source Files to SFTP and verify if reflected in LoanIQ.
    ...    @author: clanding    04MAR2019    - initial create
    
    Set Global Variable    ${rowid}    3
    Mx Execute Template With Multiple Data    Send Multiple Golden Source Files    ${ExcelPath}    ${rowid}    BaseRate_Fields