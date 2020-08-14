*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Send Copp Clark Files with Not Existing Calendar ID
    [Documentation]    Used to send a Copp Clark Files that with calendar ID that is not existing. Then validate if Copp Clark files are not processed and moved to Archive folder.
    ...    Then validate FFC CustomCBAPush.
    ...    @author: dahijara    17JAN2020    - initial create
    [Arguments]    ${ExcelPath}
    
    ${File1_XLSXFile}    Get File Name From Copp Clark Files and Return File Name    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputCoppClarkFiles]    ${File_1}
    ${File2_XLSXFile}    Get File Name From Copp Clark Files and Return File Name    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputCoppClarkFiles]    ${File_2}
    ${Misc_XLSXFile}    Get File Name From Copp Clark Files and Return File Name    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputCoppClarkFiles]    ${Misc_File}
    Create Expected JSON for TL Calendar XLS File 1 and File 2    &{ExcelPath}[InputFilePath]    ${File1_XLSXFile}    Holidays    &{ExcelPath}[InputJson]    ${File_1}
    Create Expected JSON for TL Calendar XLS File 1 and File 2    &{ExcelPath}[InputFilePath]    ${File2_XLSXFile}    Holidays    &{ExcelPath}[InputJson]    ${File_2}
    Create Expected JSON for TL Calendar XLS Misc File    &{ExcelPath}[InputFilePath]    ${Misc_XLSXFile}    Holidays    &{ExcelPath}[InputJson]    ${Misc_File}
    Consolidate JSON for 3 XLS Files    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputJson]
    Create XML Using Expected JSON File    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputJson]    &{ExcelPath}[Expected_wsFinalLIQDestination]
    ###END OF PREREQUISITE###
    
    Send Multiple Files to SFTP and Validate If Files are Processed for Holiday    &{ExcelPath}[InputFilePath]    ${TL_CALENDAR_FOLDER}    &{ExcelPath}[InputCoppClarkFiles]    
    ...    ${TL_CALENDAR_ARCHIVE_FOLDER}
    Log    ${ARCHIVE_GSFILENAME_LIST}
    Get File Name From Archive List    ${ARCHIVE_GSFILENAME_LIST}    ${File_1}
    
    Create Expected Response for Empty Payload    &{ExcelPath}[InputFilePath]    &{ExcelPath}[Expected_CustomCBAPush_Response]
    Run Keyword And Continue On Failure    Validate FFC with Empty Payload for TL Calendar    &{ExcelPath}[InputFilePath]    &{ExcelPath}[Expected_CustomCBAPush_Response]
    ...    &{ExcelPath}[OutputFilePath]    &{ExcelPath}[Actual_CustomCBAPush_Response]
    
    Run Keyword And Continue On Failure    Validate Holiday Calendar Dates is Not Reflected in Loan IQ Database    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputCoppClarkFiles]
    





