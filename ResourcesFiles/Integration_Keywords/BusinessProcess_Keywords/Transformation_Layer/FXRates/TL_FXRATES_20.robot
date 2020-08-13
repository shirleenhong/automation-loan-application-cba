*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Send FXRates GS Group 1 File for Future Date
    [Documentation]    Used to send Group 1 Golden Source file to SFTP site. Then validate if GS file is processed and moved to Archive folder.
    ...    Then validate that rates have been moved to hold table and rates have not been updated in LIQ
    ...    @author: cfrancis    06AUG2019    - initial create
    [Arguments]    ${ExcelPath}
    ###PREREQUISITE###
    # Login to Loan IQ    ${TL_USERNAME}    ${TL_PASSWORD}
    ${fundingDeskStatus}    Get Funding Desk Status from Table Maintenance    &{ExcelPath}[FundingDesk_1]
    ${CSVFile}    Set Variable    &{ExcelPath}[InputFilePath]&{ExcelPath}[InputGSFile]
    ${TransformedDataFile_FXRates}    Set Variable    &{ExcelPath}[InputFilePath]${TL_Transformed_Data_FXRates}
    ${TransformedDataFileXML_FXRates}    Set Variable    &{ExcelPath}[InputFilePath]${TL_Transformed_Data_XMLFXRates}
    ${TransformedDataFile_Template_FXRates}    Set Variable    &{ExcelPath}[InputFilePath]${TL_Transformed_Data_template_FXRates}    
    ${row}    Generate Single Random Number and Return    1    19
    # Transform FXRates CSV Data to XLS File Readable for JSON Creation    ${CSVFile}    ${TransformedDataFile_FXRates}    ${TransformedDataFile_Template_FXRates}    ${TransformedDataFileXML_FXRates}    &{ExcelPath}[FundingDesk_1]
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
    ${QueryList}    Get Future Date Record in Holding Table for TL FXRates   ${GSFILENAME_WITHTIMESTAMP}    ${TransformedDataFile_FXRates} 
    Run Keyword And Continue On Failure    Validate Future Date Record in Holding Table for TL FXRates    ${QueryList}    ${TransformedDataFile_FXRates}   
    Run Keyword And Continue On Failure    Validate FXRate Not Updated in LoanIQ     ${From_Currency}    ${To_Currency}    ${subEntity}    ${Mid_Rate}    ${Effective_Date}
