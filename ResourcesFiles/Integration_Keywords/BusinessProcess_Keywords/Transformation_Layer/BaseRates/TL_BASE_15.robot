*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Send GS file with Duplicate Mandatory Header Columns
    [Documentation]    Used to send a Golden Source file with duplicate header column to SFTP site. Then validate if GS file is processed and moved to Error folder.
    ...    @author: jdelacru    01JUL2019    - initial create

    [Arguments]    ${ExcelPath}
    
    Run Keyword And Continue On Failure    Send Single File to SFTP and Validate If File is Processed    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputGSFile]    ${TL_Base_Folder}
    Run Keyword And Continue On Failure    Validate File If Moved to File Validation Failed Folder    ${TL_BASEERR_FILEVAL_FOLDER}    &{ExcelPath}[InputGSFile]    ${CSV}
    Run Keyword And Continue On Failure    Validate FFC for TL Base Rate Error    &{ExcelPath}[OutputFilePath]    &{ExcelPath}[OutputFFCResponse]    ${MISSINGHEADERS_DESC}

    
    
    
