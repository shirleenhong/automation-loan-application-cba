*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_BASE_45
    [Documentation]    Send valid Golden Source File to SFTP that contains empty middle row and verify if reflected in LoanIQ.
    ...    @author: cfrancis    05SEP2019    - initial create
    
    Set Global Variable    ${rowid}    45    ### For Group 1
    Mx Execute Template With Multiple Data    Send GS File with Empty Middle Row    ${ExcelPath}    ${rowid}    BaseRate_Fields
