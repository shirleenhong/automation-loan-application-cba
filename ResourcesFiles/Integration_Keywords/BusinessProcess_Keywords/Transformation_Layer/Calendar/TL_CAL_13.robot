*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Send Copp Clark Files with Invalid Field Values
    [Documentation]    This keyword is used to send valid Copp Clark files to SFTP site with invalid field values in XLS Files.
    ...    Then validate if Copp Clark files are not processed and moved to Error folder.
    ...    Then validate FFC if file is sent to CustomCBAPush.
    ...    @author: dahijara    30JAN2019    - initial create
    [Arguments]    ${ExcelPath}
    
    Send Multiple Files to SFTP and Validate If Files are Not Processed for Holiday    &{ExcelPath}[InputFilePath]    ${TL_CALENDAR_FOLDER}    &{ExcelPath}[InputCoppClarkFiles]    
    ...    ${TL_CALENDARERR_FILEVAL_FOLDER}
    Log    ${ARCHIVE_GSFILENAME_LIST}

    Get File Name From Archive List    ${ARCHIVE_GSFILENAME_LIST}    ${File_1}
    Log    ${FILE1_ARCHIVE_NAME}

    ${ExpectedResponseDesc}    Set Variable    ${ROW_2}${SPACE}${Invalid_CentreCode_Length}${SPACE}${FILE1_ARCHIVE_NAME}${||}${SPACE}${ROW_3}${SPACE}${Invalid_EventDate_Value}${SPACE}${FILE1_ARCHIVE_NAME}${||}

    Create Expected Response for File Validation Error    &{ExcelPath}[InputFilePath]    &{ExcelPath}[Expected_CustomCBAPush_Response]
    
    Log    ${ExpectedResponseDesc}
    
    Run Keyword And Continue On Failure    Validate FFC for CustomCBAPush Failure Response for TL Calendar    &{ExcelPath}[InputFilePath]    &{ExcelPath}[Expected_CustomCBAPush_Response]
    ...    &{ExcelPath}[OutputFilePath]    &{ExcelPath}[Actual_CustomCBAPush_Response]    ${ExpectedResponseDesc}    ${FILE_VALIDATION_MSG_ID}
    
