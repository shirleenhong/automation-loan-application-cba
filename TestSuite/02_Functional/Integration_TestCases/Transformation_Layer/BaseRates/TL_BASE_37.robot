*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

TL_BASE_37
    [Documentation]    Send Golden Source File to SFTP with invalid file name no _BASERATE.
    ...    @author: jloretiz    16JAN2020    - initial create
    
    ###NOTE: Remove first all files in the Error File Validation Folder###
    Set Global Variable    ${rowid}    37
    Mx Execute Template With Multiple Data    Send Golden Source File with No BASERATE in Filename    ${ExcelPath}    ${rowid}    BaseRate_Fields
