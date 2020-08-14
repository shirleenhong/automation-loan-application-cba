*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_BASE_12
    [Documentation]    Send valid Golden Source File for Group 4 to SFTP and verify if reflected in LoanIQ.
    ...    @author: jdelacru    19JUL2019    - initial create
    
    Set Global Variable    ${rowid}    12    ### For Group 4
    Mx Execute Template With Multiple Data    Send GS Group 4 File    ${ExcelPath}    ${rowid}    BaseRate_Fields
