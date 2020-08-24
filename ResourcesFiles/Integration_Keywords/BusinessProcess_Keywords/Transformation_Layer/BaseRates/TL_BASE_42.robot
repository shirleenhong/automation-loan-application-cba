*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Send GS File with Inactive Base Rate Code
    [Documentation]    Used to send a valid Golden Source file to SFTP site with Inactive Base Rate Code.
    ...    Then validate if GS file is processed and moved to Archive folder.
    ...    Then validate FFC if file is sent to CCB OpenAPI, distributor and CustomCBAPush.
    ...    Then validate in LoanIQ if Base Rate Code is updated correctly.
    ...    Added config for inactive base rate code on liq.config.properties so that file would not error out due to config not being present
    ...    @author: cfrancis    11SEP2019    - initial create
    [Arguments]    ${ExcelPath}
    
    ###PREREQUISITE###
    # Login to Loan IQ    ${TL_USERNAME}    ${TL_PASSWORD}
    ${CSVFile}    Set Variable    &{ExcelPath}[InputFilePath]&{ExcelPath}[InputGSFile]
    ${TransformedDataFile_BaseRate}    Set Variable    &{ExcelPath}[InputFilePath]${TL_Transformed_Data_BaseRate}
    ${TransformedDataFile_Template_BaseRate}    Set Variable    &{ExcelPath}[InputFilePath]${TL_Transformed_Data_template_BaseRate}
    ${DealName}    Set Variable    &{ExcelPath}[DealName]
    
    Transform Base Rate CSV Data to XLS File Readable for JSON Creation    ${CSVFile}    ${TransformedDataFile_BaseRate}    ${TransformedDataFile_Template_BaseRate}
    Create Expected JSON for Base Rate TL    ${TransformedDataFile_BaseRate}    &{ExcelPath}[InputFilePath]&{ExcelPath}[InputJson]
    Create Individual Expected JSON for Base Rate TL    ${TransformedDataFile_BaseRate}    &{ExcelPath}[InputFilePath]&{ExcelPath}[InputJson]
    Create Expected TextJMS XML for Base Rate TL    ${TransformedDataFile_BaseRate}    &{ExcelPath}[InputFilePath]    &{ExcelPath}[Expected_wsFinalLIQDestination]
    ###END OF PREREQUISITE###

    Run Keyword And Continue On Failure    Send Single File to SFTP and Validate If File is Processed    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputGSFile]    ${TL_Base_Folder}
    Run Keyword And Continue On Failure    Validate File If Moved to Archive Folder    ${TL_BASE_ARCHIVE_FOLDER}    &{ExcelPath}[InputGSFile]
    Run Keyword And Continue On Failure    Convert GS Filename with Timestamp to Request ID
    Run Keyword And Continue On Failure    Validate FFC for TL Base Rate Failed    &{ExcelPath}[OutputFilePath]    &{ExcelPath}[Actual_CustomCBAPush_Response]    ${INACTIVE_BASERATECODE}
    Run Keyword And Continue On Failure    Validate Base Rate Code in LoanIQ for TL Base Failed    ${TransformedDataFile_BaseRate}
