*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
  
Send Golden Source File with Invalid Base Rate Code
    [Documentation]    Used to send Golden Source file with invalid data and format type. 
    ...    Then validate if GS file is processed unsuccessfully and moved to Archive folder.
    ...    Then validate FFC if file is sent to CustomCBAPush.
    ...    @author: dahijara    12FEB2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Run Keyword And Continue On Failure    Send Single File to SFTP and Validate If File is Processed    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputGSFile]    ${TL_Base_Folder}
    Run Keyword And Continue On Failure    Validate File If Moved to File Validation Failed Folder    ${TL_BASE_ARCHIVE_FOLDER}    &{ExcelPath}[InputGSFile]    ${CSV}
    Run Keyword And Continue On Failure    Validate FFC for TL Base Rate Failed    &{ExcelPath}[OutputFilePath]    &{ExcelPath}[OutputFFCResponse]    ${INVALID_BASERATECODE_CONFIG}