*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

TL_BASE_08
    [Documentation]    Send Golden Source File to SFTP with missing mandatory headers.
    ...    @author: clanding    15MAR2019    - initial create
    
    ###NOTE: Remove first all files in the Error File Validation Folder###
    Set Global Variable    ${rowid}    8
    Mx Execute Template With Multiple Data    Send Golden Source File with Missing Mandatory Headers    ${ExcelPath}    ${rowid}    BaseRate_Fields
