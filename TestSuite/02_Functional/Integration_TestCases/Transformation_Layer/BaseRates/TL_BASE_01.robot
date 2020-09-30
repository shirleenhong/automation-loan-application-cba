*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_BASE_01
    [Documentation]    Send valid Golden Source File to SFTP and verify if reflected in LoanIQ.
    ...    @author: clanding    19FEB2019    - initial create
    
    Set Global Variable    ${rowid}    1    ### For Group 1
    Mx Execute Template With Multiple Data    Send a Valid GS File    ${ExcelPath}    ${rowid}    BaseRate_Fields
    