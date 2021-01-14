*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot
Resource    ../../../../Configurations/Party_Import_File.robot

*** Keywords ***

Load Base Rate for UAT Deal
    [Documentation]    Used to send a valid Golden Source file to SFTP site. Then validate if GS file is processed and moved to Archive folder.
    ...    Then validate in LoanIQ if Base Rate Code is updated correctly.
    ...    @author: dahijara    26NOV2020    - initial create
    ...    @update: mcastro     10DEC2020    - Updated keyword name from Load Base Rate for UAT Deal 27DEC2019 to Load Base Rate for UAT Deal
    [Arguments]    ${ExcelPath}
    
    # Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    ${CSVFile}    Set Variable    &{ExcelPath}[InputFilePath]&{ExcelPath}[InputGSFile]
    ${TransformedDataFile_BaseRate}    Set Variable    &{ExcelPath}[InputFilePath]${TL_Transformed_Data_BaseRate}
    ${TransformedDataFile_Template_BaseRate}    Set Variable    &{ExcelPath}[TemplateFilePath]${TL_Transformed_Data_template_BaseRate}
    
    Transform Base Rate CSV Data to XLS File Readable for JSON Creation    ${CSVFile}    ${TransformedDataFile_BaseRate}    ${TransformedDataFile_Template_BaseRate}
    
    Run Keyword And Continue On Failure    Send Single File to SFTP and Validate If File is Processed    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputGSFile]    ${TL_Base_Folder}
    Run Keyword And Continue On Failure    Validate File If Moved to Archive Folder    ${TL_BASE_ARCHIVE_FOLDER}    &{ExcelPath}[InputGSFile]
    Run Keyword And Continue On Failure    Validate Base Rate Code in LoanIQ for TL Base Success    ${TransformedDataFile_BaseRate}

    Close All Windows on LIQ
    # Logout from Loan IQ