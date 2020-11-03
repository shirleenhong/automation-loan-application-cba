*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_BASE_35
    [Documentation]    Send Golden Source File to SFTP with invalid Fundind Desk Value.
    ...    @author: jloretiz    16JAN2020    - initial create
    
    ###NOTE: Remove first all files in the Error File Validation Folder###
    Set Global Variable    ${rowid}    35
    Mx Execute Template With Multiple Data    Send Golden Source File with Invalid Funding Desk    ${ExcelPath}    ${rowid}    BaseRate_Fields
