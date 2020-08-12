*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

TL_BASE_06
    [Documentation]    Send Golden Source File to SFTP with invalid file format.
    ...    @author: clanding    11MAR2019    - initial create
    
    ###NOTE: Remove first all files in the Error File Validation Folder###
    Set Global Variable    ${rowid}    6
    Mx Execute Template With Multiple Data    Send Golden Source File with Invalid File Format    ${ExcelPath}    ${rowid}    BaseRate_Fields
