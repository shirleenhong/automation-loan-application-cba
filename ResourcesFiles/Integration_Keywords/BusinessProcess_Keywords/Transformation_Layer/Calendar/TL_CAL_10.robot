*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Send Copp Clark Files with Holiday for Next Business Day
    [Documentation]    Used to send Copp Clark Files that with holiday for next business day (T+1) to SFTP site. Then validate if Copp Clark files are not processed and moved to Archive folder.
    ...    Then validate FFC CustomCBAPush.
    ...    @author: dahijara    20DEC2019    - initial create
    ...    @update: jdelacru    26OCT2020    - changed the validation of FFC to ResponseMechanism instead of customcbapush
    [Arguments]    ${ExcelPath}

    Send Multiple Files to SFTP and Validate If Files are Processed for Holiday    &{ExcelPath}[InputFilePath]    ${TL_CALENDAR_FOLDER}    &{ExcelPath}[InputCoppClarkFiles]    
    ...    ${TL_CALENDAR_ARCHIVE_FOLDER}
    Log    ${ARCHIVE_GSFILENAME_LIST}
    Get File Name From Archive List    ${ARCHIVE_GSFILENAME_LIST}    ${File_1}
    
    Run Keyword And Continue On Failure    Validate Response Mechanism for Failure Response on TL Calendar    &{ExcelPath}[OutputFilePath]    &{ExcelPath}[Actual_ResponseMechanism]
    
    Run Keyword And Continue On Failure    Validate Holiday Calendar Dates is Not Reflected in Loan IQ Database    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputCoppClarkFiles]