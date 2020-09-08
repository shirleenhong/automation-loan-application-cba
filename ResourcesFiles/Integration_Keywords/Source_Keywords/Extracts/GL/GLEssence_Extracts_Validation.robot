*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Download Compressed File from GL Extraction Area
    [Documentation]    This keyword is used to go to Extraction Area and download compressed file (GPG) and return gpg and csv file names.
    ...    @author: clanding    07SEP2020    - initial create
    [Arguments]    ${sExtract_Path}    ${sZoneAndCode}    ${sBus_Date}

    @{ExtractionArea_Files}    SSHLibrary.List Directory    ${GL_EXTRACT_PATH}
    ${Bus_Date_Converted}    Remove String    ${sBus_Date}    -
    ${Zone}    Run Keyword If    '${sZoneAndCode}'=='Australia(AU)'    Set Variable    SYD
    ...    ELSE IF    '${sZoneAndCode}'=='Europe(EU)'    Set Variable    EUR
    ...    ELSE    Log    '${sZoneAndCode}' is NOT yet configured.    level=WARN
    :FOR    ${File}    IN    @{ExtractionArea_Files}
    \    ${File_To_Download_GPG}    Run Keyword And Return Status    Should Be Equal    ${File}    ${CCB_ESS_GL_FILENAME}${Zone}${GL_FILENAME_TRANSACTION}${Bus_Date_Converted}${GL_CSV_GPG_FILEEXTENSION}
    \    Run Keyword If    ${File_To_Download_GPG}==${True}    Run Keywords    Delete File If Exist    ${sExtract_Path}/${File}
         ...    AND    SSHLibrary.Get File    ${GL_EXTRACT_PATH}/${File}    ${sExtract_Path}

    ### Validate GPG File is existing ###
    ${GPG_File_Exist}    Run Keyword And Return Status    Should Contain    ${ExtractionArea_Files}    ${CCB_ESS_GL_FILENAME}${Zone}${GL_FILENAME_TRANSACTION}${Bus_Date_Converted}${GL_CSV_GPG_FILEEXTENSION}
    Run Keyword If    ${GPG_File_Exist}==${True}    Run Keywords    Log To Console    '${CCB_ESS_GL_FILENAME}${Zone}${GL_FILENAME_TRANSACTION}${Bus_Date_Converted}${GL_CSV_GPG_FILEEXTENSION}' is EXISTING in Extraction Area '${GL_EXTRACT_PATH}'.
    ...    AND    Log    '${CCB_ESS_GL_FILENAME}${Zone}${GL_FILENAME_TRANSACTION}${Bus_Date_Converted}${GL_CSV_GPG_FILEEXTENSION}' is EXISTING in Extraction Area '${GL_EXTRACT_PATH}'.
    ...    ELSE    Run Keyword and Continue On Failure    FAIL    '${CCB_ESS_GL_FILENAME}${Zone}${GL_FILENAME_TRANSACTION}${Bus_Date_Converted}${GL_CSV_GPG_FILEEXTENSION}' is NOT EXISTING in Extraction Area '${GL_EXTRACT_PATH}':${\n}${ExtractionArea_Files}

    [Return]    ${CCB_ESS_GL_FILENAME}${Zone}${GL_FILENAME_TRANSACTION}${Bus_Date_Converted}${GL_CSV_GPG_FILEEXTENSION}    ${CCB_ESS_GL_FILENAME}${Zone}${GL_FILENAME_TRANSACTION}${Bus_Date_Converted}.${CSV}

Decrypt Compressed File for GL Extract
    [Documentation]    This keyword is used to perform decryption process for GL extract (.gpg) files.
    ...    @author: clanding    07SEP2020    - initial create
    [Arguments]    ${sExtract_Path}    ${sGPG_File}    ${sCSV_File}

    Delete File If Exist    ${sExtract_Path}${sCSV_File}
    Run    ${GL_DECRYPTION_PART1} ${GL_DECRYPTOR_TOOL_PATH}
    Run    ${GL_DECRYPTION_PART2} ${GL_DECRYPTOR_JAR}
    Take Screenshot    CMD_Decrytion
    Run    ${GL_DECRYPTION_PART3} ${sExtract_Path}${sGPG_File}
    Take Screenshot    CMD_Decrytion
    Run    ${GL_DECRYPTION_PART3} ${GL_DECRYPTOR_TOOL_PATH}\\${GL_PGP_SECRET_KEY}
    Take Screenshot    CMD_Decrytion
    Run    ${GL_DECRYPTION_PART3} ${GL_PASSPHRASE}
    Take Screenshot    CMD_Decrytion
    Run    ${GL_DECRYPTION_PART3} ${sExtract_Path}${sCSV_File}
    Take Screenshot    CMD_Decrytion
    Run    ${GL_DECRYPTION_PART3} exit
    
    ### Check if CSV File is existing in Extract Path ###
    :FOR    ${Index}    IN RANGE    10
    \    ${CSV_File_Exist}    Run Keyword And Return Status    OperatingSystem.File Should Exist    ${sExtract_Path}${sCSV_File}
    \    Exit For Loop If    ${CSV_File_Exist}==${True}
    Run Keyword If    ${CSV_File_Exist}==${True}    Run Keywords    Log To Console    '${sCSV_File}' is existing in '${sExtract_Path}'
    ...    AND    Log    '${sCSV_File}' is existing in '${sExtract_Path}'
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    '${sCSV_File}' is NOT existing in '${sExtract_Path}'. Decryption process failed!

    ### Check if CSV File is fully downloaded in Extract Path ###
    ${CSV_File_Size}    Get File Size    ${sExtract_Path}${sCSV_File}
    :FOR    ${Index}    IN RANGE    5
    \    ${CSV_File_Size}    Get File Size    ${sExtract_Path}${sCSV_File}
    \    Exit For Loop If    ${CSV_File_Size}!=0
    Run Keyword If    ${CSV_File_Size}!=0    Run Keywords    Log To Console    '${sCSV_File}' is decrypted successfully'
    ...    AND    Log    '${sCSV_File}' is decrypted successfully'
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    '${sCSV_File}' is NOT decrypted successfully'