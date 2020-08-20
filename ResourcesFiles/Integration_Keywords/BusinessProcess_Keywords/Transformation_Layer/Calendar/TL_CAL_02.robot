*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Send Copp Clark Files with Invalid File Name for XLS File
    [Documentation]    Used to send an invalid Copp Clark files to SFTP site. Then validate if Copp Clark files are processed and moved to Error folder.
    ...    Then validate FFC if file is sent to CustomCBAPush.
    ...    @author: dahijara    17DEC2019    - initial create
    [Arguments]    ${ExcelPath}
    
    Send Multiple Files to SFTP and Validate If Files are Not Processed for Holiday    &{ExcelPath}[InputFilePath]    ${TL_CALENDAR_FOLDER}    &{ExcelPath}[InputCoppClarkFiles]    
    ...    ${TL_CALENDARERR_FILEVAL_FOLDER}
    Log    ${ARCHIVE_GSFILENAME_LIST}
    Get File Name From Error List    ${ARCHIVE_GSFILENAME_LIST}    ${File_1}
    
    Create Expected Response for File Validation Error    &{ExcelPath}[InputFilePath]    &{ExcelPath}[Expected_CustomCBAPush_Response]

    Run Keyword And Continue On Failure    Validate FFC for CustomCBAPush Failure Response for TL Calendar    &{ExcelPath}[InputFilePath]    &{ExcelPath}[Expected_CustomCBAPush_Response]
    ...    &{ExcelPath}[OutputFilePath]    &{ExcelPath}[Actual_CustomCBAPush_Response]    ${FILE_VALIDATION_RESPONSE}    ${FILE_VALIDATION_MSG_ID}    bInvalidFileName=${True}