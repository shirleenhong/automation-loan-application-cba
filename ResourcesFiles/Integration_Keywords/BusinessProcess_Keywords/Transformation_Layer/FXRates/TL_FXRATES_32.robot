*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Send FXRates GS Group 1 File with Duplicate Records of Different Value
    [Documentation]    Used to send Group 1 Golden Source file with Duplicate Records to SFTP site. Then validate if GS file is processed and moved to Archive folder.
    ...    Then validate FFC if file is sent to CCB OpenAPI, distributor and CustomCBAInterface. Then validate in LoanIQ if FX Rate Code is updated correctly.
    ...    @author: cfrancis    21AUG2019    - initial create
    ...    @update: clanding    02OCT2020    - updated InputFilePath for templates to TemplateFilePath; added TemplateFilePath to Create Expected TextJMS XML for FXRates TL
    [Arguments]    ${ExcelPath}
    ###START OF PREREQUISITE###
    Login to Loan IQ    ${TL_USERNAME}    ${TL_PASSWORD}
    ${fundingDeskStatus}    Get Funding Desk Status from Table Maintenance    &{ExcelPath}[FundingDesk_1]
    ${CSVFile}    Set Variable    &{ExcelPath}[InputFilePath]&{ExcelPath}[InputGSFile]
    ${TransformedDataFile_FXRates}    Set Variable    &{ExcelPath}[InputFilePath]${TL_Transformed_Data_FXRates}
    ${TransformedDataFileXML_FXRates}    Set Variable    &{ExcelPath}[InputFilePath]${TL_Transformed_Data_XMLFXRates}
    ${TransformedDataFile_Template_FXRates}    Set Variable    &{ExcelPath}[TemplateFilePath]${TL_Transformed_Data_template_FXRates}
    ${row}    Generate Single Random Number and Return    1    19
    Transform FXRates CSV Data to XLS File Readable for JSON Creation    ${CSVFile}    ${TransformedDataFile_FXRates}    ${TransformedDataFile_Template_FXRates}    ${TransformedDataFileXML_FXRates}    &{ExcelPath}[FundingDesk_1]
    Create Expected JSON for FXRates TL    ${TransformedDataFile_FXRates}    &{ExcelPath}[InputFilePath]&{ExcelPath}[InputJson]    ${dataset_path}${TransformedDataFile_FXRates}    ${dataset_path}${TransformedDataFileXML_FXRates}    
    Create Expected TextJMS XML for FXRates TL    ${TransformedDataFileXML_FXRates}    &{ExcelPath}[InputFilePath]    &{ExcelPath}[Expected_wsFinalLIQDestination]    &{ExcelPath}[TemplateFilePath]
    ${From_Currency}    Read Data From Excel    Transformed_FXRates    fromCurrency    ${row}   ${dataset_path}${TransformedDataFileXML_FXRates}
    ${To_Currency}    Read Data From Excel    Transformed_FXRates    toCurrency    ${row}   ${dataset_path}${TransformedDataFileXML_FXRates}
    ${subEntity}    Read Data From Excel    Transformed_FXRates    subEntity    ${row}   ${dataset_path}${TransformedDataFileXML_FXRates}
    ${Mid_Rate}    Read Data From Excel    Transformed_FXRates    midRate    ${row}    ${dataset_path}${TransformedDataFileXML_FXRates}
    ${Effective_Date}    Read Data From Excel    Transformed_FXRates    effectiveDate    ${row}    ${dataset_path}${TransformedDataFileXML_FXRates}
    ##END OF PREREQUISITE###        
    
    Send Single File to SFTP and Validate If File is Processed    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputGSFile]    ${TL_FX_FOLDER}
    Validate File If Moved to File Validation Failed Folder    ${TL_FXERR_FILEVAL_FOLDER}    &{ExcelPath}[InputGSFile]
    Run Keyword And Continue On Failure    Validate FFC for TL FXRates Failed    &{ExcelPath}[OutputFilePath]    &{ExcelPath}[OutputFFCResponse]    ${DUPLICATE_ROW}
    Run Keyword And Continue On Failure    Validate FXRate Not Updated in LoanIQ     ${From_Currency}    ${To_Currency}    ${subEntity}    ${Mid_Rate}    ${Effective_Date}
