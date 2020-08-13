*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_BASE_02
    [Documentation]    Send valid Golden Source File to SFTP and verify if reflected in LoanIQ.
    ...    @author: clanding    01MAR2019    - initial create
    
    Set Global Variable    ${rowid}    2
    Mx Execute Template With Multiple Data    Send GS File with Same Base Rate, Tenor and Effective Date for Grouping    ${ExcelPath}    ${rowid}    BaseRate_Fields
    
