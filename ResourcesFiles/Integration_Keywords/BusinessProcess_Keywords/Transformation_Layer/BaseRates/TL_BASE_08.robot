*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
  
Send Golden Source File with Missing Mandatory Headers
    [Documentation]    Used to send Golden Source file with missing madatory headers to SFTP site. 
    ...    Then validate if GS file is processed unsuccessfully and moved to Error/File Validation folder.
    ...    Then validate FFC if file is sent to CustomCBAPush.
    ...    No LoanIQ Validation since GS file have no header and no way to determine the corresponding key field of the json.
    ...    @author: clanding    15MAR2019    - initial create
    ...    @author: jloretiz    15JAN2020    - updated the arguments passed
    [Arguments]    ${ExcelPath}
    
    Run Keyword And Continue On Failure    Send Single File to SFTP and Validate If File is Processed    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputGSFile]    ${TL_Base_Folder}
    Run Keyword And Continue On Failure    Validate File If Moved to File Validation Failed Folder    ${TL_BASEERR_FILEVAL_FOLDER}    &{ExcelPath}[InputGSFile]    ${CSV}    ${MISSINGHEADERS}
    Run Keyword And Continue On Failure    Validate FFC for TL Base Rate Failed    &{ExcelPath}[OutputFilePath]    &{ExcelPath}[OutputFFCResponse]    ${MISSINGHEADERS_DESC}
