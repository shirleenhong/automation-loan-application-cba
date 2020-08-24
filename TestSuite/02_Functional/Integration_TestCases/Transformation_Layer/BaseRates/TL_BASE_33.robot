*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Setup    Login to Loan IQ    ${TL_USERNAME}    ${TL_PASSWORD}
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_BASE_33
    [Documentation]    Send valid Golden Source File with Max File Name Length to SFTP and verify if reflected in LoanIQ.
    ...    Then send another Golden Source File exceeding Max File Name Length to SFTP and verify that failure occurs.
    ...    @author: cfrancis    02SEP2019    - initial create
    
    Set Global Variable    ${rowid}    33    ### For Group 1
    Mx Execute Template With Multiple Data    Send GS File with Max File Name Length    ${ExcelPath}    ${rowid}    BaseRate_Fields
    
    Set Global Variable    ${rowid}    133
    Mx Execute Template With Multiple Data    Send GS File Exceeding Max File Name Length    ${ExcelPath}    ${rowid}    BaseRate_Fields
