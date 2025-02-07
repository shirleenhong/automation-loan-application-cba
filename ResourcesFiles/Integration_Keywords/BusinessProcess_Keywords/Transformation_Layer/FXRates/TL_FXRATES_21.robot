*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Send FXRates GS Group 1 File with more than 8 decimal places
    [Documentation]    Used to send Group 1 Golden Source file to SFTP site. Then validate if GS file is processed and moved to Archive folder.
    ...    Then validate FFC if file is sent to CCB OpenAPI, distributor and CustomCBAInterface. Then validate in LoanIQ if Base Rate
    ...    Code is updated correctly. Only difference is the rates in the file should contain more than 8 decimal places
    ...    @author: cfrancis    06AUG2019    - intial create
    ...    @update: clanding    06OCT2020    - updated InputFilePath for templates to TemplateFilePath; added TemplateFilePath to Create Expected TextJMS XML for FXRates TL
    ...                                      - added 8m wait in sending of files since data is not reflected immediately in FFC. Please change accordingly if waiting time is not needed anymore
    [Arguments]    ${ExcelPath}
    ###PREREQUISITE###
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
    
    Send Single File to SFTP and Validate If File is Processed    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputGSFile]    ${TL_FX_FOLDER}    8m
    Validate File If Moved to Archive Folder    ${TL_FX_ARCHIVE_FOLDER}    &{ExcelPath}[InputGSFile]
    Run Keyword And Continue On Failure    FXRates FFC Validation for TL Success    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputJson]    &{ExcelPath}[Expected_wsFinalLIQDestination]    &{ExcelPath}[OutputFilePath]    &{ExcelPath}[OutputFFCResponse]    &{ExcelPath}[Actual_wsFinalLIQDestination]
    ...    ${dataset_path}${TransformedDataFileXML_FXRates}    ${fundingDeskStatus}    &{ExcelPath}[Actual_CustomCBAPush_Response]    &{ExcelPath}[Actual_ResponseMechanism]    &{ExcelPath}[FundingDesk_1]    
    Run Keyword And Continue On Failure    Validate FXRate in LoanIQ     ${From_Currency}    ${To_Currency}    ${subEntity}    ${Mid_Rate}    ${Effective_Date}
