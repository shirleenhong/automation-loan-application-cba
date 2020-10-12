*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
  
Send Golden Source File with Invalid Data and Format Type
    [Documentation]    Used to send Golden Source file with invalid data and format type. 
    ...    Then validate if GS file is processed unsuccessfully and moved to Error/File Validation folder.
    ...    Then validate FFC if file is sent to CustomCBAPush.
    ...    @author: dahijara    10FEB2020    - initial create
    ...    @update: clanding    09OCT2020    - updated global variable ${GS_INSTR_PRC_TYPE} to ${INVALIDBASE_GS_INSTR_PRC_TYPE}
    [Arguments]    ${ExcelPath}
    
    Run Keyword And Continue On Failure    Send Single File to SFTP and Validate If File is Processed    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputGSFile]    ${TL_Base_Folder}
    Run Keyword And Continue On Failure    Validate File If Moved to File Validation Failed Folder    ${TL_BASEERR_FILEVAL_FOLDER}    &{ExcelPath}[InputGSFile]    ${CSV}
    ${LIST_INVALID_DATA_FORMAT_RESPONSE}    Create List    ${INVALID_GS_VENDOR_PUBLISH_DATE}    ${INVALID_BASE_GS_INSTR_PRICE}    ${INVALIDBASE_GS_INSTR_PRC_TYPE}    ${GS_INSTR_TENOR}
    Run Keyword And Continue On Failure    Validate FFC for TL Base Rate Failed    &{ExcelPath}[OutputFilePath]    &{ExcelPath}[OutputFFCResponse]    ${LIST_INVALID_DATA_FORMAT_RESPONSE}    isMultipleExpectedResponse=${True}
