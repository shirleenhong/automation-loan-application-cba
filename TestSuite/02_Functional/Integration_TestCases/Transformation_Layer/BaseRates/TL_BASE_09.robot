*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_BASE_09
    [Documentation]    Send Golden Source File to SFTP with inactive Funding Desk.
    ...    @author: clanding    19MAR2019    - initial create
    
    Set Global Variable    ${rowid}    9
    Mx Execute Template With Multiple Data    Send Golden Source File with Inactive Funding Desk    ${ExcelPath}    ${rowid}    BaseRate_Fields
    