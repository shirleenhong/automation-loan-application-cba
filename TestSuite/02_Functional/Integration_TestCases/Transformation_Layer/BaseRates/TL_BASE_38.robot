*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

TL_BASE_38
    [Documentation]    Send Golden Source File to SFTP with invalid file name, invalid Group name.
    ...    @author: jloretiz    16JAN2020    - initial create
    ...    @update: jdelacru    24SEP2020    - updated to correct rowid
    
    ###NOTE: Remove first all files in the Error File Validation Folder###
    Set Global Variable    ${rowid}    38
    Mx Execute Template With Multiple Data    Send Golden Source File with Invalid Group Name    ${ExcelPath}    ${rowid}    BaseRate_Fields
