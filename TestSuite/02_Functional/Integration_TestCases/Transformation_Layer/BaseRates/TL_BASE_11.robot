*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_BASE_11
    [Documentation]    Send valid Golden Source File for Group 3 to SFTP and verify if reflected in LoanIQ.
    ...    @author: jdelacru    19JUL2019    - initial create
    
    Set Global Variable    ${rowid}    11    ### For Group 3
    Mx Execute Template With Multiple Data    Send GS Group 3 File    ${ExcelPath}    ${rowid}    BaseRate_Fields
