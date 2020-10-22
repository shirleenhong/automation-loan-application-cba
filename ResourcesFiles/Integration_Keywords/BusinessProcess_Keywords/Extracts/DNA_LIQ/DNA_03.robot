*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Verify Data Net Assurance File
    [Documentation]    This keyword is used to login to server and validate Data Net Assurance DAT file is extracted.
    ...    @author: clanding    15OCT2020    - initial create
    ...    @update: clanding    16OCT2020    - added writing of ${DAT_File} to other rows in the dataset
    [Arguments]    ${ExcelPath}
    
    Open Connection and Login    ${DNA_SERVER}    ${DNA_PORT}    ${DNA_SERVER_USER}    ${DNA_SERVER_PASSWORD}
    ${DAT_File}    Validate Extracted Data Assurance File is Generated and Return    &{ExcelPath}[Zone]    &{ExcelPath}[Extract_Files_Path]    &{ExcelPath}[Business_Date]
    Write Data to Excel    DNA    DAT_File    ${TestCase_Name}    ${DAT_File}    ${DNA_DATASET}    bTestCaseColumn=True
    Set To Dictionary    ${ExcelPath}    DAT_File=${DAT_File}
    Validate DAT File Contents if Correct    &{ExcelPath}[Zone]    &{ExcelPath}[Extract_Files_Path]    &{ExcelPath}[DAT_File]

    Write Data to Excel    DNA    DAT_File    DNA_04    ${DAT_File}    ${DNA_DATASET}    bTestCaseColumn=True
    Write Data to Excel    DNA    DAT_File    DNA_06    ${DAT_File}    ${DNA_DATASET}    bTestCaseColumn=True