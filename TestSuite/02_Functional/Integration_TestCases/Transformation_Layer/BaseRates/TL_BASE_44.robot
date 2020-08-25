*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_BASE_44
    [Documentation]    Send valid Golden Source File to SFTP that contains empty first row and verify if reflected in LoanIQ.
    ...    @author: cfrancis    04SEP2019    - initial create
    
    Set Global Variable    ${rowid}    44    ### For Group 1
    Mx Execute Template With Multiple Data    Send GS File with Empty First Row    ${ExcelPath}    ${rowid}    BaseRate_Fields
