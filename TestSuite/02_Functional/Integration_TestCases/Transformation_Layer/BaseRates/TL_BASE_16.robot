*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

TL_BASE_16
    [Documentation]    Send Golden Source File to SFTP with missing value for mandatory headers.
    ...    @author: jloretiz    16JAN2020    - initial create
    
    ###NOTE: Remove first all files in the Error File Validation Folder###
    Set Global Variable    ${rowid}    16
    Mx Execute Template With Multiple Data    Send Golden Source File with Missing Value for Mandatory Headers    ${ExcelPath}    ${rowid}    BaseRate_Fields
