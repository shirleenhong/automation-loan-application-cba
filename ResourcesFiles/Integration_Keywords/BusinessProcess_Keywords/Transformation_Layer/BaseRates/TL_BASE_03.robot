*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
  
Send Multiple Golden Source Files
    [Documentation]    Used to send multiple Golden Source file with same base rate code, tenor and effective date to SFTP site. 
    ...    Then validate if GS file is processed sequentially and moved to Archive folder.
    ...    Then validate FFC if file is sent to CCB OpenAPI, distributor and CustomCBAInterface. 
    ...    Then validate in LoanIQ if Base Rate Code is updated correctly.
    ...    @author: clanding    04MAR2019    - initial create
    ...    @update: clanding    11APR2019    - added Login to Loan IQ
    ...    @update: clanding    31MAY2019    - added new argument for Validate FFC for TL Base Rate Success with Multiple Files
    [Arguments]    ${ExcelPath}
    
    ###PREREQUISITE###
    # Login to Loan IQ    ${TL_USERNAME}    ${TL_PASSWORD}
    ${TransformedDataFile_BaseRate}    Set Variable    &{ExcelPath}[InputFilePath]${TL_Transformed_Data_BaseRate}
    ${TransformedDataFile_Template_BaseRate}    Set Variable    &{ExcelPath}[InputFilePath]${TL_Transformed_Data_template_BaseRate}
    
    Create Prerequisite for Multiple GS Files Scenario    &{ExcelPath}[InputFilePath]    ${TL_Transformed_Data_BaseRate}    ${TransformedDataFile_Template_BaseRate}
    ...    &{ExcelPath}[InputGSFile]    &{ExcelPath}[InputJson]     &{ExcelPath}[Expected_wsFinalLIQDestination]
    ###END OF PREREQUISITE###
    
    Send Multiple Files to SFTP and Validate If Files are Processed    &{ExcelPath}[InputFilePath]    ${TL_Base_Folder}    &{ExcelPath}[InputGSFile]
    ...    ${TL_BASE_ARCHIVE_FOLDER}
    Run Keyword And Continue On Failure    Validate FFC for TL Base Rate Success with Multiple Files    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputJson]    &{ExcelPath}[Expected_wsFinalLIQDestination]    
    ...    &{ExcelPath}[OutputFilePath]    &{ExcelPath}[OutputFFCResponse]    &{ExcelPath}[Actual_wsFinalLIQDestination]    &{ExcelPath}[Actual_CustomCBAPush_Response]    &{ExcelPath}[Actual_ResponseMechanism]
    Run Keyword And Continue On Failure    Validate Base Rate Code in LoanIQ for TL Base Success for Multiple Files 
