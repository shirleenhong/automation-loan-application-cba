*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_BASE_13
    [Documentation]    Send valid Golden Source File for Group 5 to SFTP and verify if reflected in LoanIQ.
    ...    @author: jdelacru    19JUL2019    - initial create
    
    Set Global Variable    ${rowid}    13    ### For Group 5
    Mx Execute Template With Multiple Data    Send GS Group 5 File    ${ExcelPath}    ${rowid}    BaseRate_Fields
