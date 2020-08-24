*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Send GSFile for FX Rates with Invalid Data Type
    [Documentation]    Used to send Golden Source file with invalid data type.
    ...    Then validate if GS file is processed unsuccessfully and moved to Error/File Validation folder.
    ...    Then validate FFC if file is sent to CustomCBAPush.
    ...    @author: dahijara    5FEB2020    - initial create
    [Arguments]    ${ExcelPath}
   
    Run Keyword And Continue On Failure    Send Single File to SFTP and Validate If File is Processed    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputGSFile]    ${TL_FX_FOLDER}
    
    Run Keyword And Continue On Failure    Validate File If Moved to File Validation Failed Folder    ${TL_FXERR_FILEVAL_FOLDER}    &{ExcelPath}[InputGSFile]    ${CSV}    ${INVALIDFILEFORMAT}

    ${invalidDataTypeResponseList}    Create List    ${INVALID_GS_INSTR_TYPE}    ${INVALID_GS_SNAP}    ${INVALIDGS_BASE_CCY}    ${INVALID_GS_TRGT_CCY}    ${INVALID_GS_INSTR_PRC_TYPE}    ${INVALID_GS_INSTR_PRICE}    ${INVALID_GS_PROCESSING_DATE}

    Run Keyword And Continue On Failure    Validate FFC for TL FXRates Failed    &{ExcelPath}[OutputFilePath]    &{ExcelPath}[OutputFFCResponse]    ${invalidDataTypeResponseList}    isMultipleExpectedResponse=${True}
