*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Send FXRates GS Group 3 File
    [Documentation]    Used to send Group 3 Golden Source file to SFTP site. Then validate if GS file is processed and moved to Archive folder.
    ...    Then validate FFC if file is not sent to CCB OpenAPI, distributor and CustomCBAInterface. Then validate in LoanIQ if FXRate
    ...    Code is not updated.
    ...    @author: mnanquil    04MAR2019    - initial create
    ...    @update: mnanquil    11APR2019    - added Login to LoanIQ keyword
    [Arguments]    ${ExcelPath}
     ###PREREQUISITE###
    Login to Loan IQ    ${TL_USERNAME}    ${TL_PASSWORD}
    ${TransformedDataFile_FXRates}    Set Variable    &{ExcelPath}[InputFilePath]${TL_Transformed_Data_FXRates}
    ${TransformedDataFileXML_FXRates}    Set Variable    &{ExcelPath}[InputFilePath]${TL_Transformed_Data_XMLFXRates}
    ${row}    Set Variable    2
    ${From_Currency}    Read Data From Excel    Transformed_FXRates    fromCurrency    ${row}   ${dataset_path}${TransformedDataFileXML_FXRates}
    ${To_Currency}    Read Data From Excel    Transformed_FXRates    toCurrency    ${row}   ${dataset_path}${TransformedDataFileXML_FXRates}
    ${subEntity}    Read Data From Excel    Transformed_FXRates    subEntity    ${row}   ${dataset_path}${TransformedDataFileXML_FXRates}
    ${Mid_Rate}    Read Data From Excel    Transformed_FXRates    midRate    ${row}    ${dataset_path}${TransformedDataFileXML_FXRates}
    ${Effective_Date}    Read Data From Excel    Transformed_FXRates    effectiveDate    ${row}    ${dataset_path}${TransformedDataFileXML_FXRates}
    ###END OF PREREQUISITE###
    Validate FXRate in LoanIQ     ${From_Currency}    ${To_Currency}    ${subEntity}    ${Mid_Rate}    ${Effective_Date}  
    Send Single File to SFTP and Validate If File is Processed    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputGSFile]    ${TL_FX_FOLDER}
    Validate File If Moved to Archive Folder    ${TL_FX_ARCHIVE_FOLDER}    &{ExcelPath}[InputGSFile]
    ${QueryList}    Get Future Date Record in Holding Table for TL FXRates   ${GSFILENAME_WITHTIMESTAMP}    ${TransformedDataFile_FXRates} 
    Run Keyword And Continue On Failure    Validate Future Date Record in Holding Table for TL FXRates    ${QueryList}    ${TransformedDataFile_FXRates} 
    Validate FXRate in LoanIQ     ${From_Currency}    ${To_Currency}    ${subEntity}    ${Mid_Rate}    ${Effective_Date}  
    
    
    
