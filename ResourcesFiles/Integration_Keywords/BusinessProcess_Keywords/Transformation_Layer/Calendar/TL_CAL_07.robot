*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Send Copp Clark Files with Invalid File Format
    [Documentation]    Used to send an invalid Copp Clark file format to SFTP site. Then validate if Copp Clark files are not processed and not moved to Archive folder.
    ...    @author: dahijara    17DEC2019    - initial create
    [Arguments]    ${ExcelPath}
    
    Send Multiple Files to SFTP and Validate If Files are Not Processed for Holiday    &{ExcelPath}[InputFilePath]    ${TL_CALENDAR_FOLDER}    &{ExcelPath}[InputCoppClarkFiles]    
    ...    ${TL_CALENDAR_ARCHIVE_FOLDER}

    