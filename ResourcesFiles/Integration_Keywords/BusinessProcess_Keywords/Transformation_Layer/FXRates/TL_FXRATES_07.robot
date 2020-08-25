*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Send GSFile for FX Rates with Invalid Funding Desk
    [Documentation]    Used to send Golden Source file with invalid Funding Desk in File name.
    ...    Then validate if GS file is processed unsuccessfully and moved to Error/File Validation folder.
    ...    Then validate FFC if file is sent to CustomCBAPush.
    ...    @author: jloretiz    21JAN2020    - initial create
    [Arguments]    ${ExcelPath}

    Run Keyword And Continue On Failure    Send Single File to SFTP and Validate If File is Processed    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputGSFile]    ${TL_FX_FOLDER}
    Run Keyword And Continue On Failure    Validate File If Moved to File Validation Failed Folder    ${TL_FXERR_FILEVAL_FOLDER}    &{ExcelPath}[InputGSFile]    ${CSV}    ${INVALIDFILENAME}
    Run Keyword And Continue On Failure    Validate FFC for TL FXRates Failed    &{ExcelPath}[OutputFilePath]    &{ExcelPath}[OutputFFCResponse]    ${filename}${GSFILENAME_COMPLETE}${INVALIDFILENAME_DESC} 