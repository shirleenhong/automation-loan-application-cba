*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
  
Send Golden Source File with Future Date
    [Documentation]    Used to send Golden Source file with few records having future effective date or greater than LIQ business date to SFTP site. 
    ...    Then validate if GS file is processed successfully and moved to Archive folder.
    ...    Then validate in the holding table (DB) if future date records are displayed.
    ...    Then validate FFC if file is sent to CCB OpenAPI, distributor and CustomCBAInterface. 
    ...    Then validate in LoanIQ if Base Rate Code is updated correctly for non-future dates.
    ...    @author: clanding    06MAR2019    - initial create
    ...    @update: clanding    19MAR2019    - added Create Individual Expected JSON for Base Rate TL
    ...    @update: clanding    11APR2019    - added Login to Loan IQ
    ...    @update: jdelacru    01OCT2020    - changed the location of templates items for Base Rate by adding variable TemplateFilePath
    [Arguments]    ${ExcelPath}
    
    ###PREREQUISITE###
    # Login to Loan IQ    ${TL_USERNAME}    ${TL_PASSWORD}
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
    ${QueryList}    Get Future Date Record in Holding Table for TL Base Rate    ${GSFILENAME_WITHTIMESTAMP}    ${TransformedDataFile_BaseRate}
    Run Keyword And Continue On Failure    Validate Future Date Record in Holding Table for TL Base Rate    ${QueryList}    ${TransformedDataFile_BaseRate}
    Run Keyword And Continue On Failure    Validate FFC for TL Base Rate Success    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputJson]    &{ExcelPath}[Expected_wsFinalLIQDestination]
    ...    &{ExcelPath}[OutputFilePath]    &{ExcelPath}[OutputFFCResponse]    &{ExcelPath}[Actual_wsFinalLIQDestination]    &{ExcelPath}[Actual_CustomCBAPush_Response]    &{ExcelPath}[Actual_ResponseMechanism]
    Run Keyword And Continue On Failure    Validate Base Rate Code in LoanIQ for TL Base Success for Future Date    ${TransformedDataFile_BaseRate}
    
