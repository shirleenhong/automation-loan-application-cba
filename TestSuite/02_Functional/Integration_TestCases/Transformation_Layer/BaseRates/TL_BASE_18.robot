*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

TL_BASE_18
    [Documentation]    Send Golden Source File to SFTP with invalid data and format type.
    ...    @author: dahijara    10FEB2020    - initial create
    
    Set Global Variable    ${rowid}    18
    Mx Execute Template With Multiple Data    Send Golden Source File with Invalid Data and Format Type    ${ExcelPath}    ${rowid}    BaseRate_Fields
