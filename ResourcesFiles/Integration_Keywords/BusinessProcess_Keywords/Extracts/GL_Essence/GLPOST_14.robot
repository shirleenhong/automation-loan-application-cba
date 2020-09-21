*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Decrypt GL Extract File
    [Documentation]    This keyword is used to connect to server and decrypt GL extract file and validate if extract file is decrypted successfully.
    ...    @author: clanding    07SEP2020    - initial create
    [Arguments]    ${ExcelPath}
    
    ### Keyword for extracting FBE Zone Bus Date will come from CBA_Evergreen repo, waiting for the merge to fms_cba before executing this
    # ${Essence_Zone_BusDate}    Validate FBE Zone and Get Zone Business Date    &{ExcelPath}[ZoneAndCode]    &{ExcelPath}[Zone]    &{ExcelPath}[Branch]
    # Write Data to Excel    GL_Posting    FBE_SystemDate    ${TestCase_Name}    ${Essence_Zone_BusDate}    ${GLExcelPath}    bTestCaseColumn=True
    # Set To Dictionary    ${ExcelPath}    FBE_SystemDate=${Essence_Zone_BusDate}
    
    Open Connection and Login    ${SFTP_HOST_GL}    ${SFTP_PORT}    ${SFTP_USER}    ${SFTP_PASSWORD}
    ${GPG_File}    ${CSV_File}    Download Compressed File from GL Extraction Area    &{ExcelPath}[Extract_Files_Path]    &{ExcelPath}[ZoneAndCode]    &{ExcelPath}[FBE_SystemDate]
    Write Data to Excel    GL_Posting    GPG_File    ${TestCase_Name}    ${GPG_File}    ${GLExcelPath}    bTestCaseColumn=True
    Write Data to Excel    GL_Posting    CSV_File    ${TestCase_Name}    ${CSV_File}    ${GLExcelPath}    bTestCaseColumn=True
    Set To Dictionary    ${ExcelPath}    GPG_File=${GPG_File}
    Set To Dictionary    ${ExcelPath}    CSV_File=${CSV_File}

    Decrypt Compressed File for GL Extract    &{ExcelPath}[Extract_Files_Path]    &{ExcelPath}[GPG_File]    &{ExcelPath}[CSV_File]