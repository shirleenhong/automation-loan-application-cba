*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
  
Send Golden Source File with Invalid File Format
    [Documentation]    Used to send Golden Source file with invalid file format to SFTP site. 
    ...    Then validate if GS file is processed unsuccessfully and moved to Error/File Validation folder.
    ...    Then validate FFC if file is sent to CustomCBAPush. 
    ...    No LoanIQ Validation since file format is a non-csv and cannot get data.
    ...    @author: clanding    12MAR2019    - initial create
    ...    @author: jloretiz    15JAN2020    - updated the arguments passed
    [Arguments]    ${ExcelPath}
    
    Run Keyword And Continue On Failure    Send Single File to SFTP and Validate If File is Processed    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputGSFile]    ${TL_Base_Folder}
    Run Keyword And Continue On Failure    Validate File If Moved to File Validation Failed Folder    ${TL_BASEERR_FILEVAL_FOLDER}    &{ExcelPath}[InputGSFile]    ${TXT}    ${INVALIDFILEFORMAT}
    Run Keyword And Continue On Failure    Validate FFC for TL Base Rate Failed    &{ExcelPath}[OutputFilePath]    &{ExcelPath}[OutputFFCResponse]    ${file}${GSFILENAME_COMPLETE}${INVALIDFILEFORMAT_DESC}
