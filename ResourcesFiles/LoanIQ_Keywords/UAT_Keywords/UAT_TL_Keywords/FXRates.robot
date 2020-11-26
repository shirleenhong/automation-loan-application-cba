*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${row}    1

*** Keywords ***
Load FX Rates To Funding Desks
    [Documentation]    Load FX Rates to Funding Desk for New UAT Deals
    ...    @author:    mcastro    26NOV2020    - Initial Create
    [Arguments]    ${ExcelPath}

    Login to Loan IQ    ${TL_USERNAME}    ${TL_PASSWORD}
    ${TransformedDataFile_FXRates}    Set Variable    &{ExcelPath}[InputFilePath]${TL_Transformed_Data_FXRates}
    ${TransformedDataFileXML_FXRates}    Set Variable    &{ExcelPath}[InputFilePath]${TL_Transformed_Data_XMLFXRates}
    ${row}    Generate Single Random Number and Return    1    19
    ${From_Currency}    Read Data From Excel    Transformed_FXRates    fromCurrency    ${row}   ${dataset_path}${TransformedDataFileXML_FXRates}
    ${To_Currency}    Read Data From Excel    Transformed_FXRates    toCurrency    ${row}   ${dataset_path}${TransformedDataFileXML_FXRates}
    ${subEntity}    Read Data From Excel    Transformed_FXRates    subEntity    ${row}   ${dataset_path}${TransformedDataFileXML_FXRates}
    ${Mid_Rate}    Read Data From Excel    Transformed_FXRates    midRate    ${row}    ${dataset_path}${TransformedDataFileXML_FXRates}
    ${Effective_Date}    Read Data From Excel    Transformed_FXRates    effectiveDate    ${row}    ${dataset_path}${TransformedDataFileXML_FXRates}      
    
    Send Single File to SFTP and Validate If File is Processed    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputGSFile]    ${TL_FX_FOLDER}
    Validate File If Moved to Archive Folder    ${TL_FX_ARCHIVE_FOLDER}    &{ExcelPath}[InputGSFile]
    Run Keyword And Continue On Failure    Validate FXRate in LoanIQ     ${From_Currency}    ${To_Currency}    ${subEntity}    ${Mid_Rate}    ${Effective_Date}