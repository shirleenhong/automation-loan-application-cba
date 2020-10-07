*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Send Update GS file (Any group)
    [Documentation]    Used to send a valid two Golden Source files with different price but the same code,type and publish date.
    ...    Then validate if GS file is processed and moved to Archive folder. Then validate FFC if file is sent to CCB OpenAPI, 
    ...    distributor and CustomCBAPush.  Then validate if Base Rate Code is updated correctly, latest GS file should be processed in LIQ.
    ...    @author: jdelacru    27AUG2019    - initial create
    ...    @update: jdelacru    07OCT2020    - changed the location of templates items for Base Rate by adding variable TemplateFilePath
    ...                                      - set the delay time to 10s
    [Arguments]    ${ExcelPath}
    
    ##PREREQUISITE###
    Login to Loan IQ    ${TL_USERNAME}    ${TL_PASSWORD}
    ${TransformedDataFile_BaseRate}    Set Variable    &{ExcelPath}[InputFilePath]${TL_Transformed_Data_BaseRate}
    ${TransformedDataFile_Template_BaseRate}    Set Variable    &{ExcelPath}[TemplateFilePath]${TL_Transformed_Data_template_BaseRate}
    Create Prerequisite for Multiple GS Files Scenario    &{ExcelPath}[InputFilePath]    ${TL_Transformed_Data_BaseRate}    ${TransformedDataFile_Template_BaseRate}
    ...    &{ExcelPath}[InputGSFile]    &{ExcelPath}[InputJson]     &{ExcelPath}[Expected_wsFinalLIQDestination]    sTemplateFilePath=&{ExcelPath}[TemplateFilePath]
    ###END OF PREREQUISITE###
    
    Send Multiple Files to SFTP and Validate If Files are Processed    &{ExcelPath}[InputFilePath]    ${TL_Base_Folder}    &{ExcelPath}[InputGSFile]    ${TL_BASE_ARCHIVE_FOLDER}    iDelayTime=10s
    Pause Execution
    Run Keyword And Continue On Failure    Validate FFC for TL Base Rate Success with Multiple Files    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputJson]    &{ExcelPath}[Expected_wsFinalLIQDestination]
    ...    &{ExcelPath}[OutputFilePath]    &{ExcelPath}[OutputFFCResponse]    &{ExcelPath}[Actual_wsFinalLIQDestination]    &{ExcelPath}[Actual_CustomCBAPush_Response]    &{ExcelPath}[Actual_ResponseMechanism]
    Run Keyword And Continue On Failure    Validate Base Rate Code in LoanIQ for TL Base Success for Last Index
