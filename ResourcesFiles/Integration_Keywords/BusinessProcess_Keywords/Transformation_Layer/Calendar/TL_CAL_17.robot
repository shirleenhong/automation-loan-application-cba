*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Send Copp Clark Files with No Changes in Holiday
    [Documentation]    This keyword is used to send copp clark files with no changes in Holiday Dates to SFTP site.
    ...    Then validate if Copp Clark files are processed and moved to Archive folder.
    ...    Then validate FFC if file is sent to CustomCBAPush ONLY. Then validate in LoanIQ if Holiday Calendar Dates are reflected.
    ...    @author: clanding    05AUG2019    - initial create
    ...    @update: mcastro     30SEP2020    - added sXLS_Exists argument value
    [Arguments]    ${ExcelPath}
    
    Send Multiple Files to SFTP and Validate If Files are Processed for Holiday    &{ExcelPath}[InputFilePath]    ${TL_CALENDAR_FOLDER}    &{ExcelPath}[InputCoppClarkFiles]    
    ...    ${TL_CALENDAR_ARCHIVE_FOLDER}    sXLS_Exists=True
    Log    ${ARCHIVE_GSFILENAME_LIST}
    Get File Name From Archive List    ${ARCHIVE_GSFILENAME_LIST}    ${File_1}
    Create Expected Response for Empty Payload    &{ExcelPath}[InputFilePath]    &{ExcelPath}[Expected_CustomCBAPush_Response]
    Run Keyword And Continue On Failure    Validate FFC with Empty Payload for TL Calendar    &{ExcelPath}[InputFilePath]    &{ExcelPath}[Expected_CustomCBAPush_Response]
    ...    &{ExcelPath}[OutputFilePath]    &{ExcelPath}[Actual_CustomCBAPush_Response]
