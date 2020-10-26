*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Send GS File where Processing Date is Greater than LIQ Date and verify if Publish Date is still Processed
    [Documentation]    Used to send a Golden Source file to SFTP site where Processing Date is Greater than Publish Date, validate if the GS file is processed and moved to Archive folder.
    ...    then validate FFC if file is sent to CCB OpenAPI, distributor, CustomCBAPush and response mechanism. Lastly, validate in LoanIQ if Base Rate Code is updated correctly.
    ...    @author: jdelacru    23AUG2019    - initial create
    ...    @update: jdelacru    07OCT2020    - changed the location of templates items for Base Rate by adding variable TemplateFilePath
    [Arguments]    ${ExcelPath}
    
    ###PREREQUISITE###
    Login to Loan IQ    ${TL_USERNAME}    ${TL_PASSWORD}
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
    
    
    
