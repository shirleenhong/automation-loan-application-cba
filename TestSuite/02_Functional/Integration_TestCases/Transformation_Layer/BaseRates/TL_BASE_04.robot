*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_BASE_04
    [Documentation]    Send Golden Source File to SFTP with some of the records have Effective Date (Publish Date) greater than LIQ business date.
    ...    @author: clanding    06MAR2019    - initial create
    
    Set Global Variable    ${rowid}    4
    Mx Execute Template With Multiple Data    Send Golden Source File with Future Date    ${ExcelPath}    ${rowid}    BaseRate_Fields
