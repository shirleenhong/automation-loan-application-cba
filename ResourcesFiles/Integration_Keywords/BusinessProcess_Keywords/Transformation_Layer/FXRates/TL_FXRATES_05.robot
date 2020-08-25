*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Send FXRates GS Group Multiple Files for FIFO
    [Documentation]    Used to send multiple Golden Source files to SFTP site. Processing date for files should be T+1 business day in LIQ. Perform End of Day and 
    ...    then validate FFC if file is sent to CCB OpenAPI, distributor and CustomCBAInterface. Then validate in LoanIQ if FX Rate Code is updated correctly.
    ...    @author: mnanquil    20MAR2019    - initial create
    ...    @update: mnanquil    11APR2019    - added Login to LoanIQ keyword.
    ...    @update: cfrancis    08AUG2019    - modified keywords to fit scenario and documentation
    [Arguments]    ${ExcelPath}
    ###START OF PREREQUISITE###
    Login to Loan IQ    ${TL_USERNAME}    ${TL_PASSWORD}
    ${fundingDeskStatus}    Get Funding Desk Status from Table Maintenance    &{ExcelPath}[FundingDesk_1]
    ${CSVFile}    Set Variable    &{ExcelPath}[InputGSFile]
    ${TransformedDataFile_FXRates}    Set Variable    &{ExcelPath}[InputFilePath]${TL_Transformed_Data_FXRates}
    ${TransformedDataFileXML_FXRates}    Set Variable    &{ExcelPath}[InputFilePath]${TL_Transformed_Data_XMLFXRates}
    ${TransformedDataFile_Template_FXRates}    Set Variable    &{ExcelPath}[InputFilePath]${TL_Transformed_Data_template_FXRates}
    ${fundingDesk}    Set Variable    &{ExcelPath}[FundingDesk_1]
    ${InputJSON}    Set Variable    &{ExcelPath}[InputFilePath]&{ExcelPath}[InputJson]
    ${InputFilePath}    Set Variable    &{ExcelPath}[InputFilePath]
    ${FinalLIQDestination}    Set Variable    &{ExcelPath}[Expected_wsFinalLIQDestination]
    ${row}    Generate Single Random Number and Return    1    19
    Create Prerequisite for Multiple FX Files Scenario    ${CSVFile}    ${TransformedDataFile_FXRates}    ${TransformedDataFileXML_FXRates}    ${TransformedDataFile_Template_FXRates}    ${fundingDesk}
    ...    ${InputJSON}    ${InputFilePath}    ${FinalLIQDestination}
    ###END OF PREREQUISITE###
    
    Run Keyword And Continue On Failure    Send Multiple Files to SFTP and Validate If Files are Processed    &{ExcelPath}[InputFilePath]    ${TL_FX_FOLDER}    &{ExcelPath}[InputGSFile]    ${TL_FX_ARCHIVE_FOLDER}    iDelayTime=5s
    ${QueryList}    Get Future Date Record in Holding Table for TL FXRates of Multiple Files    ${ARCHIVE_GSFILENAME_LIST}    ${TransformedDataFile_FXRates}
    # ${a}    Set Variable    FINASTRA_CCB_FX_NY_FX05A_1_1565254836840_1.csv
    # ${b}    Set Variable    FINASTRA_CCB_FX_NY_FX05A_2_1565254842954_1.csv
    # ${GSFilename_ArchiveList}    Create List
    # Append To List    ${GSFilename_ArchiveList}    ${a}
    # Append To List    ${GSFilename_ArchiveList}    ${b}
    # Log    ${GSFilename_ArchiveList}
    # ${QueryList}    Get Future Date Record in Holding Table for TL FXRates of Multiple Files    ${GSFilename_ArchiveList}    ${TransformedDataFile_FXRates}
    
    ###PERFORM EOD###
    # Run Keyword and Continue on Failure    Execute EOD - Daily
    ###END OF EOD###
    
    Run Keyword And Continue On Failure    Validate Multiple Files for Success on TL FX Rates in FFC    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputJson]    &{ExcelPath}[Expected_wsFinalLIQDestination]    &{ExcelPath}[OutputFilePath]    &{ExcelPath}[OutputFFCResponse]    &{ExcelPath}[Actual_wsFinalLIQDestination]
    ...    ${dataset_path}&{ExcelPath}[InputFilePath]${TL_Transformed_Data_XMLFXRates}    ${fundingDeskStatus}    &{ExcelPath}[Actual_CustomCBAPush_Response]    &{ExcelPath}[Actual_ResponseMechanism]    &{ExcelPath}[InputGSFile]    &{ExcelPath}[FundingDesk_1]
    ${From_Currency}    Read Data From Excel    Transformed_FXRates    fromCurrency    ${row}   ${dataset_path}&{ExcelPath}[InputFilePath]TL_Transformed_Data_XMLFXRates${COUNTER}.${XLSX}
    ${To_Currency}    Read Data From Excel    Transformed_FXRates    toCurrency    ${row}   ${dataset_path}&{ExcelPath}[InputFilePath]TL_Transformed_Data_XMLFXRates${COUNTER}.${XLSX}
    ${subEntity}    Read Data From Excel    Transformed_FXRates    subEntity    ${row}   ${dataset_path}&{ExcelPath}[InputFilePath]TL_Transformed_Data_XMLFXRates${COUNTER}.${XLSX}
    ${Mid_Rate}    Read Data From Excel    Transformed_FXRates    midRate    ${row}    ${dataset_path}&{ExcelPath}[InputFilePath]TL_Transformed_Data_XMLFXRates${COUNTER}.${XLSX}
    ${Effective_Date}    Read Data From Excel    Transformed_FXRates    effectiveDate    ${row}    ${dataset_path}&{ExcelPath}[InputFilePath]TL_Transformed_Data_XMLFXRates${COUNTER}.${XLSX}
    Validate FXRate in LoanIQ     ${From_Currency}    ${To_Currency}    ${subEntity}    ${Mid_Rate}    ${Effective_Date}
