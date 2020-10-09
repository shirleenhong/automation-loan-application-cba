*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Send GS File with Max File Name Length
    [Documentation]    Used to send a valid Golden Source file to SFTP site and verify the max file name length is 40.
    ...    Then validate if GS file is processed and moved to Archive folder.
    ...    Then validate FFC if file is sent to CCB OpenAPI, distributor and CustomCBAPush.
    ...    Then validate in LoanIQ if Base Rate Code is updated correctly.
    ...    @author: cfrancis    02SEP2019    - initial create
    ...    @update: mcastro     08OCT2020    - added missing argument variable for Create expected TextJMS XML
    ...                                      - updated [InputFilePath] to [TemplateFilePath] of TransformedDataFile_Template_BaseRate
    [Arguments]    ${ExcelPath}
    
    ###START OF PREREQUISITE###
    ${CSVFile}    Set Variable    &{ExcelPath}[InputFilePath]&{ExcelPath}[InputGSFile]
    ${TransformedDataFile_BaseRate}    Set Variable    &{ExcelPath}[InputFilePath]${TL_Transformed_Data_BaseRate}
    ${TransformedDataFile_Template_BaseRate}    Set Variable    &{ExcelPath}[TemplateFilePath]${TL_Transformed_Data_template_BaseRate}
    
    Transform Base Rate CSV Data to XLS File Readable for JSON Creation    ${CSVFile}    ${TransformedDataFile_BaseRate}    ${TransformedDataFile_Template_BaseRate}
    Create Expected JSON for Base Rate TL    ${TransformedDataFile_BaseRate}    &{ExcelPath}[InputFilePath]&{ExcelPath}[InputJson]
    Create Individual Expected JSON for Base Rate TL    ${TransformedDataFile_BaseRate}    &{ExcelPath}[InputFilePath]&{ExcelPath}[InputJson]
    Create Expected TextJMS XML for Base Rate TL    ${TransformedDataFile_BaseRate}    &{ExcelPath}[InputFilePath]    &{ExcelPath}[Expected_wsFinalLIQDestination]    &{ExcelPath}[TemplateFilePath]
    ###END OF PREREQUISITE###

    Run Keyword And Continue On Failure    Send Single File to SFTP and Validate If File is Processed    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputGSFile]    ${TL_Base_Folder}
    Run Keyword And Continue On Failure    Validate File If Moved to Archive Folder    ${TL_BASE_ARCHIVE_FOLDER}    &{ExcelPath}[InputGSFile]
    Run Keyword And Continue On Failure    Validate FFC for TL Base Rate Success    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputJson]    &{ExcelPath}[Expected_wsFinalLIQDestination]
    ...    &{ExcelPath}[OutputFilePath]    &{ExcelPath}[OutputFFCResponse]    &{ExcelPath}[Actual_wsFinalLIQDestination]    &{ExcelPath}[Actual_CustomCBAPush_Response]    &{ExcelPath}[Actual_ResponseMechanism]
    Run Keyword And Continue On Failure    Validate Base Rate Code in LoanIQ for TL Base Success    ${TransformedDataFile_BaseRate}
    
    
Send GS File Exceeding Max File Name Length
    [Documentation]    Used to send a valid Golden Source file to SFTP site with file name length exceeding 40.
    ...    Then validate if GS file is processed and moved to Error folder.
    ...    Then validate FFC if processing has an error on CustomCBAPush.
    ...    Then validate in LoanIQ if Base Rate Code is not updated.
    ...    @author: cfrancis    03SEP2019    - initial create
    ...    @update: mcastro     08OCT2020    - updated [InputFilePath] to [TemplateFilePath] of TransformedDataFile_Template_BaseRate
    ...                                      - Updated TL_Transformed_Data_BaseRate_2.xlsx to variable ${TL_Transformed_Data_BaseRate_2}
    [Arguments]    ${ExcelPath}
    
    ###START OF PREREQUISITE###
    ${CSVFile}    Set Variable    &{ExcelPath}[InputFilePath]&{ExcelPath}[InputGSFile]
    ${TransformedDataFile_BaseRate}    Set Variable    &{ExcelPath}[InputFilePath]${TL_Transformed_Data_BaseRate_2}
    ${TransformedDataFile_Template_BaseRate}    Set Variable    &{ExcelPath}[TemplateFilePath]${TL_Transformed_Data_template_BaseRate}
    
    Transform Base Rate CSV Data to XLS File Readable for JSON Creation    ${CSVFile}    ${TransformedDataFile_BaseRate}    ${TransformedDataFile_Template_BaseRate}
    ###END OF PREREQUISITE###
    
    Run Keyword And Continue On Failure    Send Single File to SFTP and Validate If File is Processed    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputGSFile]    ${TL_Base_Folder}
    Run Keyword And Continue On Failure    Validate File If Moved to File Validation Failed Folder    ${TL_BASEERR_FILEVAL_FOLDER}    &{ExcelPath}[InputGSFile]
    Run Keyword And Continue On Failure    Validate FFC for TL Base Rate Failed    &{ExcelPath}[OutputFilePath]    &{ExcelPath}[Actual_CustomCBAPush_Response]    ${BASE_MAX_ERROR}
    Run Keyword And Continue On Failure    Validate Base Rate Code in LoanIQ for TL Base Failed    ${TransformedDataFile_BaseRate}
