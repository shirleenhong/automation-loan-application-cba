*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Send GSFile for FX Rates with Invalid Date Format
    [Documentation]    Used to send Golden Source file with invalid Date Format in File.
    ...    Then validate if GS file is processed unsuccessfully and moved to Error/File Validation folder.
    ...    Then validate FFC if file is sent to CustomCBAPush.
    ...    @author: mnanquil    20MAR2019    - initial create
    ...    @update: mnanquil    11APR2019    - added Login to LoanIQ keyword.
    ...    @update: jloretiz    22JAN2020    - updated the highlevel keywords to check for the invalid date format in file
    [Arguments]    ${ExcelPath}
   
    Run Keyword And Continue On Failure    Send Single File to SFTP and Validate If File is Processed    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputGSFile]    ${TL_FX_FOLDER}
    Run Keyword And Continue On Failure    Validate File If Moved to File Validation Failed Folder    ${TL_FXERR_FILEVAL_FOLDER}    &{ExcelPath}[InputGSFile]    ${CSV}    ${INVALIDDATEFORMAT}
    Run Keyword And Continue On Failure    Validate FFC for TL FXRates Failed    &{ExcelPath}[OutputFilePath]    &{ExcelPath}[OutputFFCResponse]    ${INVALIDDATE_FORMAT}
    
    
    
    
