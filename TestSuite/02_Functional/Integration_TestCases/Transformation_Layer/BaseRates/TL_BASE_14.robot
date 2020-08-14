*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_BASE_14
    [Documentation]    Send valid Golden Source File for Group 6 to SFTP and verify if reflected in LoanIQ.
    ...    @author: jdelacru    19JUL2019    - initial create
    
    Set Global Variable    ${rowid}    14    ### For Group 6
    Mx Execute Template With Multiple Data    Send GS Group 6 File    ${ExcelPath}    ${rowid}    BaseRate_Fields
