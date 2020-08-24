*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

TL_BASE_07
    [Documentation]    Send Golden Source File to SFTP with invalid file name (No Finastra).
    ...    @author: clanding    11MAR2019    - initial create
    
    ###NOTE: Remove first all files in the Error File Validation Folder###
    Set Global Variable    ${rowid}    7
    Mx Execute Template With Multiple Data    Send Golden Source File with Invalid File Name    ${ExcelPath}    ${rowid}    BaseRate_Fields
