*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_BASE_10
    [Documentation]    Send valid Golden Source File for Group 2 to SFTP and verify if reflected in LoanIQ.
    ...    @author: clanding    19MAR2019    - initial create
    
    Set Global Variable    ${rowid}    10    ### For Group 2
    Mx Execute Template With Multiple Data    Send GS Group 2 File    ${ExcelPath}    ${rowid}    BaseRate_Fields
