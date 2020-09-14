*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot
Resource    ../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Load Base Rate D00000476
    [Documentation]    Used to send a valid Golden Source file to SFTP site. Then validate if GS file is processed and moved to Archive folder.
    ...    Then validate FFC if file is sent to CCB OpenAPI, distributor and CustomCBAPush. Then validate in LoanIQ if Base Rate
    ...    @update: ritragel    18AUG2020    Updated the FFC Validation and upgraded xls to xlsx dataset
    [Arguments]    ${ExcelPath}
    
    ###PREREQUISITE###
    ${CSVFile}    Set Variable    &{ExcelPath}[InputFilePath]&{ExcelPath}[InputGSFile]
    ${TransformedDataFile_BaseRate}    Set Variable    &{ExcelPath}[InputFilePath]TL_Transformed_Data_BaseRate.xlsx
    ${TransformedDataFile_Template_BaseRate}    Set Variable    &{ExcelPath}[InputFilePath]TL_Transformed_Data_template_BaseRate.xlsx
    
    Transform Base Rate CSV Data to XLS File Readable for JSON Creation    ${CSVFile}    ${TransformedDataFile_BaseRate}    ${TransformedDataFile_Template_BaseRate}
    Create Expected JSON for Base Rate TL    ${TransformedDataFile_BaseRate}    &{ExcelPath}[InputFilePath]&{ExcelPath}[InputJson]
    Create Individual Expected JSON for Base Rate TL    ${TransformedDataFile_BaseRate}    &{ExcelPath}[InputFilePath]&{ExcelPath}[InputJson]
    ###END OF PREREQUISITE###

    Run Keyword And Continue On Failure    Send Single File to SFTP and Validate If File is Processed    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputGSFile]    ${TL_Base_Folder}
    Run Keyword And Continue On Failure    Validate File If Moved to Archive Folder    ${TL_BASE_ARCHIVE_FOLDER}    &{ExcelPath}[InputGSFile]
    Run Keyword And Continue On Failure    Validate Base Rate Code in LoanIQ for TL Base Success    ${TransformedDataFile_BaseRate}

Load FX Rate D00000476
    [Documentation]    Used to send Group 1 Golden Source file to SFTP site. Then validate if GS file is processed and moved to Archive folder.
    ...    @update: ritragel    18AUG2020    Updated the FFC Validation and upgraded xls to xlsx dataset
    [Arguments]    ${ExcelPath}
    
    ###PREREQUISITE###
    ${fundingDeskStatus}    Get Funding Desk Status from Table Maintenance    &{ExcelPath}[FundingDesk_1]
    ${CSVFile}    Set Variable    &{ExcelPath}[InputFilePath]&{ExcelPath}[InputGSFile]
    ${TransformedDataFile_FXRates}    Set Variable    &{ExcelPath}[InputFilePath]TL_Transformed_Data_FXRates.xlsx
    ${TransformedDataFileXML_FXRates}    Set Variable    &{ExcelPath}[InputFilePath]TL_Transformed_Data_XMLFXRates.xlsx
    ${TransformedDataFile_Template_FXRates}    Set Variable    &{ExcelPath}[InputFilePath]TL_Transformed_Data_template_FXRates.xlsx
    ${row}    Set Variable    18
    Transform FXRates CSV Data to XLS File Readable for JSON Creation    ${CSVFile}    ${TransformedDataFile_FXRates}    ${TransformedDataFile_Template_FXRates}    ${TransformedDataFileXML_FXRates}        &{ExcelPath}[FundingDesk_1]
    Create Expected JSON for FXRates TL    ${TransformedDataFile_FXRates}    &{ExcelPath}[InputFilePath]&{ExcelPath}[InputJson]    ${dataset_path}${TransformedDataFile_FXRates}    ${dataset_path}${TransformedDataFileXML_FXRates}    
    Create Expected TextJMS XML for FXRates TL    ${TransformedDataFileXML_FXRates}    &{ExcelPath}[InputFilePath]    &{ExcelPath}[Expected_wsFinalLIQDestination]
    ${From_Currency}    Read Data From Excel    Transformed_FXRates    fromCurrency    ${row}   ${dataset_path}${TransformedDataFileXML_FXRates}
    ${To_Currency}    Read Data From Excel    Transformed_FXRates    toCurrency    ${row}   ${dataset_path}${TransformedDataFileXML_FXRates}
    ${subEntity}    Read Data From Excel    Transformed_FXRates    subEntity    ${row}   ${dataset_path}${TransformedDataFileXML_FXRates}
    ${Mid_Rate}    Read Data From Excel    Transformed_FXRates    midRate    ${row}    ${dataset_path}${TransformedDataFileXML_FXRates}
    ${Effective_Date}    Read Data From Excel    Transformed_FXRates    effectiveDate    ${row}    ${dataset_path}${TransformedDataFileXML_FXRates}
    ##END OF PREREQUISITE###        
    
    Send Single File to SFTP and Validate If File is Processed    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputGSFile]    ${TL_FX_FOLDER}
    Validate File If Moved to Archive Folder    ${TL_FX_ARCHIVE_FOLDER}    &{ExcelPath}[InputGSFile]
    Run Keyword And Continue On Failure    Validate FXRate in LoanIQ     ${From_Currency}    ${To_Currency}    ${subEntity}    ${Mid_Rate}    ${Effective_Date}
