*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Send Copp Clark Files with Holiday Less Than Current System Date
    [Documentation]    Used to send a Copp Clark Files that with holiday less than current system date to SFTP site. Then validate if Copp Clark files are not processed and moved to Archive folder.
    ...    Then validate FFC CustomCBAPush.
    ...    @author: dahijara    28NOV2019    - initial create
    [Arguments]    ${ExcelPath}

    Send Multiple Files to SFTP and Validate If Files are Processed for Holiday    &{ExcelPath}[InputFilePath]    ${TL_CALENDAR_FOLDER}    &{ExcelPath}[InputCoppClarkFiles]    
    ...    ${TL_CALENDAR_ARCHIVE_FOLDER}
    Log    ${ARCHIVE_GSFILENAME_LIST}
    Get File Name From Archive List    ${ARCHIVE_GSFILENAME_LIST}    ${File_1}
    
    Create Expected Response for Empty Payload    &{ExcelPath}[InputFilePath]    &{ExcelPath}[Expected_CustomCBAPush_Response]
    Run Keyword And Continue On Failure    Validate FFC with Empty Payload for TL Calendar    &{ExcelPath}[InputFilePath]    &{ExcelPath}[Expected_CustomCBAPush_Response]
    ...    &{ExcelPath}[OutputFilePath]    &{ExcelPath}[Actual_CustomCBAPush_Response]
    
    Run Keyword And Continue On Failure    Validate Holiday Calendar Dates is Not Reflected in Loan IQ Database    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputCoppClarkFiles]

