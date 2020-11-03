*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
    
Send GS File with Duplicate Record Having Different Rate Value
    [Documentation]    Used to send a valid Golden Source file to SFTP site containing duplicate record of different rates.
    ...    Then validate if GS file is processed and moved to Error folder.
    ...    Then validate FFC if processing has an error on CustomCBAPush.
    ...    Then validate in LoanIQ if Base Rate Code is not updated.
    ...    @author: cfrancis    04SEP2019    - initial create
    ...    @update: jdelacru    01NOV2020    - changed the location of templates items for Base Rate by adding variable TemplateFilePath
    [Arguments]    ${ExcelPath}
    
    ###START OF PREREQUISITE###
    Login to Loan IQ    ${TL_USERNAME}    ${TL_PASSWORD}
    ${CSVFile}    Set Variable    &{ExcelPath}[InputFilePath]&{ExcelPath}[InputGSFile]
    ${TransformedDataFile_BaseRate}    Set Variable    &{ExcelPath}[InputFilePath]${TL_Transformed_Data_BaseRate}
    ${TransformedDataFile_Template_BaseRate}    Set Variable    &{ExcelPath}[TemplateFilePath]${TL_Transformed_Data_template_BaseRate}
    
    Transform Base Rate CSV Data to XLS File Readable for JSON Creation    ${CSVFile}    ${TransformedDataFile_BaseRate}    ${TransformedDataFile_Template_BaseRate}
    ###END OF PREREQUISITE###
    
    Run Keyword And Continue On Failure    Send Single File to SFTP and Validate If File is Processed    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputGSFile]    ${TL_Base_Folder}
    Run Keyword And Continue On Failure    Validate File If Moved to File Validation Failed Folder    ${TL_BASEERR_FILEVAL_FOLDER}    &{ExcelPath}[InputGSFile]
    Run Keyword And Continue On Failure    Validate FFC for TL Base Rate Failed    &{ExcelPath}[OutputFilePath]    &{ExcelPath}[Actual_CustomCBAPush_Response]    ${DUPLICATE_RECORD}
    Run Keyword And Continue On Failure    Validate Base Rate Code in LoanIQ for TL Base Failed    ${TransformedDataFile_BaseRate}
