*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_BASE_40
    [Documentation]    Send valid Golden Source File to SFTP with duplicate record but different rate value 
    ...    and verify if processing would fail and not reflect in LIQ.
    ...    @author: cfrancis    04SEP2019    - initial create
    
    Set Global Variable    ${rowid}    40    ### For Group 1
    Mx Execute Template With Multiple Data    Send GS File with Duplicate Record Having Different Rate Value    ${ExcelPath}    ${rowid}    BaseRate_Fields
