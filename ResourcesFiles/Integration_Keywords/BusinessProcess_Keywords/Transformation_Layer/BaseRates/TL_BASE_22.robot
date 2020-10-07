*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Send GS File with Future Date and Existing Base Rate Record in Holding Table
    [Documentation]    Used to send a valid Golden Source file with same base rate code but different price from an existing GS File on hold. 
    ...    Then validate if GS file is processed and moved to Archive folder. Then validate FFC if file is sent to CCB OpenAPI, 
    ...    distributor and CustomCBAPush. After one day EOD in LIQ, validate if Base Rate Code is updated correctly.
    ...    @author: jdelacru    07AUG2019    - initial create
    ...    @update: jdelacru    07OCT2020    - changed the location of templates items for Base Rate by adding variable TemplateFilePath
    [Arguments]    ${ExcelPath}
    
    ##PREREQUISITE###
    # Login to Loan IQ    ${TL_USERNAME}    ${TL_PASSWORD}
    ${TransformedDataFile_BaseRate}    Set Variable    &{ExcelPath}[InputFilePath]${TL_Transformed_Data_BaseRate}
    ${TransformedDataFile_Template_BaseRate}    Set Variable    &{ExcelPath}[TemplateFilePath]${TL_Transformed_Data_template_BaseRate}
    Create Prerequisite for Multiple GS Files Scenario    &{ExcelPath}[InputFilePath]    ${TL_Transformed_Data_BaseRate}    ${TransformedDataFile_Template_BaseRate}
    ...    &{ExcelPath}[InputGSFile]    &{ExcelPath}[InputJson]     &{ExcelPath}[Expected_wsFinalLIQDestination]    sTemplateFilePath=&{ExcelPath}[TemplateFilePath]
    ###END OF PREREQUISITE###
    
    Send Multiple Files to SFTP and Validate If Files are Processed    &{ExcelPath}[InputFilePath]    ${TL_Base_Folder}    &{ExcelPath}[InputGSFile]    ${TL_BASE_ARCHIVE_FOLDER}    iDelayTime=5s
    ${QueryList}    Get Future Date Record in Holding Table for Multiple Files for TL Base Rate    ${ARCHIVE_GSFILENAME_LIST}
    Run Keyword And Continue On Failure    Validate Future Date Record in Holding Table for TL Base Rate for Multiple Files    ${QueryList}

    Pause Execution
    # Run Keyword and Continue on Failure    Execute EOD - Daily
    
    ### SAMPLE TEST DATA ###
    ### Don't remove not until automated EOD has been plugged in to this script ###
    # ${ARCHIVE_GSFILENAME_LIST}    Create LisT    FINASTRA_CCB_BASERATE_LN_GROUP5_B22_02_1565751389925_1.csv    FINASTRA_CCB_BASERATE_LN_GROUP5_B22_01_1565751385845_1.csv
    # ${TRANSFORMEDDATA_LIST}    Create List    \\DataSet\\TL_DataSet\\BaseRates_GSFile\\TL_Transformed_Data_BaseRate.xls_1.xls    \\DataSet\\TL_DataSet\\BaseRates_GSFile\\TL_Transformed_Data_BaseRate.xls_0.xls
    # Set Global Variable    ${ARCHIVE_GSFILENAME_LIST}
    # Set Global Variable    ${TRANSFORMEDDATA_LIST}   
    
    Run Keyword And Continue On Failure    Validate FFC for TL Base Rate Success with Multiple Files    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputJson]    &{ExcelPath}[Expected_wsFinalLIQDestination]
    ...    &{ExcelPath}[OutputFilePath]    &{ExcelPath}[OutputFFCResponse]    &{ExcelPath}[Actual_wsFinalLIQDestination]    &{ExcelPath}[Actual_CustomCBAPush_Response]    &{ExcelPath}[Actual_ResponseMechanism]
    Run Keyword And Continue On Failure    Validate Base Rate Code in LoanIQ for TL Base Success for Last Index
