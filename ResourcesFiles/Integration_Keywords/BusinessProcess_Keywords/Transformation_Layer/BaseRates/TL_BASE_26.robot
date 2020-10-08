*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Send GS File Where All Publish Date are Greater Than LIQ Business Date
    [Documentation]    This keyword is used to send a valid Golden Source files all with GS_VENDOR_PUBLISH_DATE greater than LIQ business date.
    ...    Then verify if the processed GS file is present in holding table and rate is not updated in LIQ. 
    ...    @author: jdelacru    14AUG2019    - initial create
    ...    @update: jdelacru    29SEP2020    - used TemplateFilePath as location of template files
    [Arguments]    ${ExcelPath}
    
    ###PREREQUISITE###
    Login to Loan IQ    ${TL_USERNAME}    ${TL_PASSWORD}
    ${TransformedDataFile_BaseRate}    Set Variable    &{ExcelPath}[InputFilePath]${TL_Transformed_Data_BaseRate}
    ${TransformedDataFile_Template_BaseRate}    Set Variable    &{ExcelPath}[TemplateFilePath]${TL_Transformed_Data_template_BaseRate}
    Create Prerequisite for Multiple GS Files Scenario    &{ExcelPath}[InputFilePath]    ${TL_Transformed_Data_BaseRate}    ${TransformedDataFile_Template_BaseRate}
    ...    &{ExcelPath}[InputGSFile]    &{ExcelPath}[InputJson]     &{ExcelPath}[Expected_wsFinalLIQDestination]    sTemplateFilePath=&{ExcelPath}[TemplateFilePath]
    ###END OF PREREQUISITE###
    
    Send Multiple Files to SFTP and Validate If Files are Processed    &{ExcelPath}[InputFilePath]    ${TL_Base_Folder}    &{ExcelPath}[InputGSFile]    ${TL_BASE_ARCHIVE_FOLDER}    iDelayTime=5s
    ${QueryList}    Get Future Date Record in Holding Table for Multiple Files for TL Base Rate    ${ARCHIVE_GSFILENAME_LIST}
    Run Keyword And Continue On Failure    Validate Future Date Record in Holding Table for TL Base Rate for Multiple Files    ${QueryList}
    Run Keyword And Continue On Failure    Validate Base Rate Code in LoanIQ for TL Base Success on Future Date for Multiple Files
