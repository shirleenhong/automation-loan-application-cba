*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Send Copp Clark Files with 1 File Missing
    [Documentation]    This keyword is used to send valid Copp Clark files to SFTP site with 1 missing file.
    ...    Then validate if Copp Clark files are not processed and moved to Error folder.
    ...    Then validate FFC if file is sent to CustomCBAPush.
    ...    @author: dahijara    3FEB2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Send Multiple Files to SFTP and Validate If Files are Not Processed for Holiday With Missing File    &{ExcelPath}[InputFilePath]    ${TL_CALENDAR_FOLDER}    &{ExcelPath}[InputCoppClarkFiles]    
    ...    ${TL_CALENDAR_ARCHIVE_FOLDER}

    Get File Name From Archive List    ${ARCHIVE_GSFILENAME_LIST}    ${File_2}
    
    Run Keyword And Continue On Failure    Validate No Result in FFC for CustomCBAPush for TL Calendar
    
