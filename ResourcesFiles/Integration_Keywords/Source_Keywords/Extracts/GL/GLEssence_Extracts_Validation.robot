*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Download Compressed File from GL Extraction Area
    [Documentation]    This keyword is used to go to Extraction Area and download compressed file (GPG) and return gpg and csv file names.
    ...    @author: clanding    07SEP2020    - initial create
    ...    @update: clanding    08SEP2020    - added exit for loop; updated global variables; added validation if file is downloaded
    [Arguments]    ${sExtract_Path}    ${sZoneAndCode}    ${sBus_Date}

    @{ExtractionArea_Files}    SSHLibrary.List Directory    ${GL_EXTRACT_PATH}
    ${Bus_Date_Converted}    Remove String    ${sBus_Date}    -
    ${Zone}    Run Keyword If    '${sZoneAndCode}'=='${LIQ_ZONEANDCODE_AU}'    Set Variable    ${GL_THREE_CHAR_ENTITY_CODE_SYD}
    ...    ELSE IF    '${sZoneAndCode}'=='${LIQ_ZONEANDCODE_EU}'    Set Variable    ${GL_THREE_CHAR_ENTITY_CODE_EUR}
    ...    ELSE    Log    '${sZoneAndCode}' is NOT yet configured.    level=WARN
    
    ### Validate GPG File is existing in SFTP Extract Path ###
    ${GPG_File_Exist}    Run Keyword And Return Status    Should Contain    ${ExtractionArea_Files}    ${CCB_ESS_GL_FILENAME}${Zone}${GL_FILENAME_TRANSACTION}${Bus_Date_Converted}${GL_CSV_GPG_FILEEXTENSION}
    Run Keyword If    ${GPG_File_Exist}==${True}    Run Keywords    Log To Console    '${CCB_ESS_GL_FILENAME}${Zone}${GL_FILENAME_TRANSACTION}${Bus_Date_Converted}${GL_CSV_GPG_FILEEXTENSION}' is EXISTING in Extraction Area '${GL_EXTRACT_PATH}'.
    ...    AND    Log    '${CCB_ESS_GL_FILENAME}${Zone}${GL_FILENAME_TRANSACTION}${Bus_Date_Converted}${GL_CSV_GPG_FILEEXTENSION}' is EXISTING in Extraction Area '${GL_EXTRACT_PATH}'.
    ...    ELSE    FAIL    '${CCB_ESS_GL_FILENAME}${Zone}${GL_FILENAME_TRANSACTION}${Bus_Date_Converted}${GL_CSV_GPG_FILEEXTENSION}' is NOT EXISTING in Extraction Area '${GL_EXTRACT_PATH}':${\n}${ExtractionArea_Files}

    ### Download GPG File ###
    :FOR    ${File}    IN    @{ExtractionArea_Files}
    \    ${File_To_Download_GPG}    Run Keyword And Return Status    Should Be Equal    ${File}    ${CCB_ESS_GL_FILENAME}${Zone}${GL_FILENAME_TRANSACTION}${Bus_Date_Converted}${GL_CSV_GPG_FILEEXTENSION}
    \    Run Keyword If    ${File_To_Download_GPG}==${True}    Run Keywords    Delete File If Exist    ${sExtract_Path}/${File}
         ...    AND    SSHLibrary.Get File    ${GL_EXTRACT_PATH}/${File}    ${sExtract_Path}
    \    Exit For Loop If    ${File_To_Download_GPG}==${True}

    ### Validate GPG file is downloaded successfully ###
    ${GPG_File_Exist}    Run Keyword And Return Status    OperatingSystem.File Should Exist    ${sExtract_Path}${CCB_ESS_GL_FILENAME}${Zone}${GL_FILENAME_TRANSACTION}${Bus_Date_Converted}${GL_CSV_GPG_FILEEXTENSION}
    Run Keyword If    ${GPG_File_Exist}==${True}    Run Keywords    Log To Console    '${CCB_ESS_GL_FILENAME}${Zone}${GL_FILENAME_TRANSACTION}${Bus_Date_Converted}${GL_CSV_GPG_FILEEXTENSION}' is downloaded successfully in '${sExtract_Path}'.
    ...    AND    Log    '${CCB_ESS_GL_FILENAME}${Zone}${GL_FILENAME_TRANSACTION}${Bus_Date_Converted}${GL_CSV_GPG_FILEEXTENSION}' is downloaded successfully in '${sExtract_Path}'.
    ...    ELSE    FAIL    '${CCB_ESS_GL_FILENAME}${Zone}${GL_FILENAME_TRANSACTION}${Bus_Date_Converted}${GL_CSV_GPG_FILEEXTENSION}' is NOT downloaded successfully in '${sExtract_Path}'.

    [Return]    ${CCB_ESS_GL_FILENAME}${Zone}${GL_FILENAME_TRANSACTION}${Bus_Date_Converted}${GL_CSV_GPG_FILEEXTENSION}    ${CCB_ESS_GL_FILENAME}${Zone}${GL_FILENAME_TRANSACTION}${Bus_Date_Converted}.${CSV}

Decrypt Compressed File for GL Extract
    [Documentation]    This keyword is used to perform decryption process for GL extract (.gpg) files.
    ...    @author: clanding    07SEP2020    - initial create
    ...    @update: clanding    30SEP2020    - added max loop in the for loop
    [Arguments]    ${sExtract_Path}    ${sGPG_File}    ${sCSV_File}

    Delete File If Exist    ${sExtract_Path}${sCSV_File}
    Run    ${GL_DECRYPTION_PART1} ${GL_DECRYPTOR_TOOL_PATH}
    Run    ${GL_DECRYPTION_PART2} ${GL_DECRYPTOR_JAR}
    Take Screenshot    ${screenshot_path}/Screenshots/GL/CMD_Decrytion
    Run    ${GL_DECRYPTION_PART3} ${sExtract_Path}${sGPG_File}
    Take Screenshot    ${screenshot_path}/Screenshots/GL/CMD_Decrytion
    Run    ${GL_DECRYPTION_PART3} ${GL_DECRYPTOR_TOOL_PATH}\\${GL_PGP_SECRET_KEY}
    Take Screenshot    ${screenshot_path}/Screenshots/GL/CMD_Decrytion
    Run    ${GL_DECRYPTION_PART3} ${GL_PASSPHRASE}
    Take Screenshot    ${screenshot_path}/Screenshots/GL/CMD_Decrytion
    Run    ${GL_DECRYPTION_PART3} ${sExtract_Path}${sCSV_File}
    Take Screenshot    ${screenshot_path}/Screenshots/GL/CMD_Decrytion
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
    :FOR    ${Index}    IN RANGE    25
    \    ${CSV_File_Size}    Get File Size    ${sExtract_Path}${sCSV_File}
    \    Exit For Loop If    ${CSV_File_Size}!=0
    Run Keyword If    ${CSV_File_Size}!=0    Run Keywords    Log To Console    '${sCSV_File}' is decrypted successfully'
    ...    AND    Log    '${sCSV_File}' is decrypted successfully'
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    '${sCSV_File}' is NOT decrypted successfully'

Run GL Validation Tool
    [Documentation]    This keyword is used to delete any existing output file and then run GL Validation Tool in command line.
    ...    @author: clanding    11SEP2020    - initial create
    [Arguments]    ${sExtract_Path}    ${sCSV_File}
    
    @{Output_Files}    OperatingSystem.List Directory    ${GL_VALIDATION_TOOL_PATH}
    :FOR    ${File}    IN    @{Output_Files}
    \    ${Contains_Output}    Run Keyword And Return Status    Should Contain    ${File}    output
    \    Run Keyword If    ${Contains_Output}==${True}    Remove File    ${GL_VALIDATION_TOOL_PATH}\\${File}
         ...    ELSE    Log    '${File}' is not an output file from the GL Validation Tool.
    ### Validate if no output files in the folder ###
    ${Contains_Output}    Run Keyword And Return Status    List Should Not Contain Value    ${Output_Files}    output
    Run Keyword If    ${Contains_Output}==${True}    Run Keywords    Log To Console    No more output files. Ready to validate.
    ...    AND    Log    No more output files. Ready to validate.
    ...    ELSE    FAIL    Not all output files are deleted. Please check. Files: '${Output_Files}'

    Run    ${GL_DECRYPTION_PART1} ${GL_VALIDATION_TOOL_PATH}
    Run    ${GL_DECRYPTION_PART2} ${GL_VALIDATION_TOOL_JAR}
    Take Screenshot    ${screenshot_path}/Screenshots/GL/CMD_Decrytion
    Run    ${GL_DECRYPTION_PART3} ${sExtract_Path}${sCSV_File}
    Take Screenshot    ${screenshot_path}/Screenshots/GL/CMD_Decrytion

    Log To Console    Waiting for the GL Validation Tool to finish running. Click OK on the dialog box once done and close command line.
    Log    Waiting for the GL Validation Tool to finish running.
    Pause Execution
    Take Screenshot    ${screenshot_path}/Screenshots/GL/CMD_Decrytion

    ### Validate if output file is generated ###
    @{Output_Files}    OperatingSystem.List Directory    ${GL_VALIDATION_TOOL_PATH}
    :FOR    ${File}    IN    @{Output_Files}
    \    ${Contains_Output}    Run Keyword And Return Status    Should Contain    ${File}    output
    \    Exit For Loop If    ${Contains_Output}==${True}
    Run Keyword If    ${Contains_Output}==${True}    Log    Output file is generated. Files: '${Output_Files}'
    ...    ELSE    FAIL    Output file is NOT generated. Files: '${Output_Files}'
    
    [Return]    ${File}

Validate Output File if Matched
    [Documentation]    This keyword is used to verify output file from GL Validation Tool if all are Matched and
    ...    report if there are Not Matched.
    [Arguments]    ${sOutput_File}
    
    ${Timestamp_List}    Split String    ${sOutput_File}    _
    ${Timestamp_List}    Split String    @{Timestamp_List}[1]    .
    Open Excel Document    ${GL_VALIDATION_TOOL_PATH}\\${sOutput_File}    0
    ${Columns}    OperatingSystem.Get File    ${GL_VALIDATION_TOOL_PATH}\\${GL_VALTOOL_COLUMNS}
    @{Column_List}    Split To Lines    ${Columns}
    :FOR    ${Column}    IN    @{Column_List}
    \    ${Column_Value_List}    Read Data From All Column Rows    Summary_@{Timestamp_List}[0]    ${Column}
    \    ${Contains_NotMatched}    Run Keyword And Return Status    List Should Contain Value    ${Column_Value_List}    Not Matched
    \    Run Keyword If    ${Contains_NotMatched}==${True}    Run Keyword And Continue On Failure    FAIL    'Not Matched' value is existing in the output file column '${Column}'. Please check.
	     ...    ELSE    Run Keywords    Log To Console    All values are 'Matched' in the output file column '${Column}'.
	     ...    AND    Log    All values are 'Matched' in the output file column '${Column}'.
    Close All Excel Documents
    

