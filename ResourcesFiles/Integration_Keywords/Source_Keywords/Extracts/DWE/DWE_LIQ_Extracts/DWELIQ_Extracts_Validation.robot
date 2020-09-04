*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Validate Execution Journal for DWE LIQ Extract
    [Documentation]    This keyword is used to go to Actions > Batch Administration and validate TEST_DE Batch Nets if data are correct.
    ...    sZone value format must be ZONE2 or ZONE3.
    ...    @author: clanding    09JUL2020    - initial create
    ...    @update: clanding    01SEP2020    - added screenshot; replaced ${DWE_BATCH_NET} to ${sBatch_Net} to make it dynamic
    [Arguments]    ${sZone}    ${sJobName}    ${sBPR_Name}    ${sBatch_Net}

    Select Actions    [Actions];Batch Administration
    Mx LoanIQ Select List    ${LIQ_Batch_Admin_Master_ComboBox}    ${sBatch_Net}
    Mx LoanIQ Click    ${LIQ_Batch_Admin_Execution_Journal_Button}
    Mx LoanIQ Select List    ${LIQ_Execution_Scheduled_Location_ComboBox}    ${sZone}
    ${Job_RC_UI}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Execution_Scheduled_JavaTree}    ${sJobName}%Job RC%Job_RC_UI
    ${BPR_Name_UI}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Execution_Scheduled_JavaTree}    ${sJobName}%BPR Name%BPR_Name_UI
    ${Location_UI}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Execution_Scheduled_JavaTree}    ${sJobName}%Location%Location_UI
    Take Screenshot    ExecutionJournal_${sJobName}_${sZone}
    Close All Windows on LIQ

    Compare Two Strings    0    ${Job_RC_UI}
    Compare Two Strings    ${sBPR_Name}    ${BPR_Name_UI}
    Compare Two Strings    ${sZone}    ${Location_UI}

Get Business Date by Batch Net for DWE
    [Documentation]    This keyword is used to go to Actions > Batch Administration and if sBatch_Net is 'Master', get Previous Date for sZone.
    ...    If sBatch_Net is 'TEST_DE', get Current Date for sZone.
    ...    @author: clanding    15JUL2020    - initial create
    ...    @update: clanding    01SEP2020    - added screenshot
    [Arguments]    ${sZone}    ${sBatch_Net}

    Select Actions    [Actions];Batch Administration
    ${BusDate}    Run Keyword If    '${sBatch_Net}'=='MASTER'    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Batch_Admin_TimeZone_JavaTree}    ${sZone}%Previous%BusDate
    ...    ELSE IF    '${sBatch_Net}'=='TEST_DE'    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Batch_Admin_TimeZone_JavaTree}    ${sZone}%Current%BusDate
    Take Screenshot    ExecutionJournal_${sBatch_Net}_${sZone}
    Close All Windows on LIQ
    [Return]    ${BusDate}

Validate Alphanumeric Folder from Landing Area
    [Documentation]    This keyword is used to go to Landing Area and validate the alphanumeric folder if existing and contents are correct.
    ...    sZone value format must be ZONE2 or ZONE3.
    ...    @author: clanding    09JUL2020    - initial create
    ...    @update: clanding    26AUG2020    - added ELSE in the validation of LandingArea_FileCount; added Log to report
    [Arguments]    ${sZone}    ${sExtract_Path}

    @{LandingArea_Files}    SSHLibrary.List Directory    ${DWE_LANDING_AREA_PATH}${sZone}
    ${LandingArea_FileCount}    Get Length    ${LandingArea_Files}
    Run Keyword If    ${LandingArea_FileCount}>1    FAIL    There are more than 1 alphanumeric folder in the landing area. Please check. Actual count is ${LandingArea_FileCount}.
    ...    ELSE IF    ${LandingArea_FileCount}==0    FAIL    There are no alphanumeric folder in the landing area. Please check. Actual count is ${LandingArea_FileCount}.
    ...    ELSE    Log    There is only 1 alphanumeric folder in the landing area.
    
    ### Validate alphanumeric folder length is 23 ###
    ${AlphanumericFolder_Name}    Set Variable    @{LandingArea_Files}[0]
    ${AlphanumericFolder_Length}    Get Length    @{LandingArea_Files}[0]
    Run Keyword If    ${AlphanumericFolder_Length}==23    Run Keywords    Log To Console    Alphanumeric folder '${AlphanumericFolder_Name}' length in Landing Area '${DWE_LANDING_AREA_PATH}${sZone}' is 23.
    ...    AND    Log    Alphanumeric folder '${AlphanumericFolder_Name}' length in Landing Area '${DWE_LANDING_AREA_PATH}${sZone}' is 23.
    ...    ELSE    Run Keyword and Continue On Failure    FAIL    Alphanumeric folder '${AlphanumericFolder_Name}' length in Landing Area '${DWE_LANDING_AREA_PATH}${sZone}' is ${AlphanumericFolder_Length} and NOT EQUAL to 23.

    ### Validate alphanumeric folder contents ###
    @{AlphanumericFolder_Files}    SSHLibrary.List Directory    ${DWE_LANDING_AREA_PATH}${sZone}/${AlphanumericFolder_Name}

    :FOR    ${File}    IN    @{AlphanumericFolder_Files}
    \    Run Keyword If    '${File}'=='manifest.properties'    Run Keywords    Log To Console    'manifest.properties' is EXISTING in ${AlphanumericFolder_Name} folder.
         ...    AND    Log    'manifest.properties' is EXISTING in ${AlphanumericFolder_Name} folder.
         ...    ELSE IF    '${File}'=='dwh'    Run Keywords    Log To Console    'dwh' is EXISTING in ${AlphanumericFolder_Name} folder.
         ...    AND    Log    'dwh' is EXISTING in ${AlphanumericFolder_Name} folder.
         ...    ELSE    Run Keyword and Continue On Failure    FAIL    '${File}' should NOT BE EXISTING in ${AlphanumericFolder_Name} folder.

    [Return]    ${AlphanumericFolder_Name}

Validate Manifest File from Landing Area
    [Documentation]    This keyword is used to download manifest.properties from Landing Area and validate contents are correct.
    ...    sZone value format must be ZONE2 or ZONE3.
    ...    Manifest properties content sample per line: Status=SUCCESS
    ...    @author: clanding    09JUL2020    - initial create
    [Arguments]    ${sZone}    ${sExtract_Path}    ${sAlphanumeric_Folder_Name}    ${sStatus}    ${sBusiness_Date}    ${sLoad_Type}

    ### Download manifest.properties from Landing Area ###
    Delete File If Exist    ${sExtract_Path}/manifest.properties
    SSHLibrary.Get File    ${DWE_LANDING_AREA_PATH}${sZone}/${sAlphanumeric_Folder_Name}/manifest.properties    ${sExtract_Path}

    ### Validate manifest.properties content ###
    ${Manifest_File_Contents}    OperatingSystem.Get File    ${sExtract_Path}/manifest.properties
    ${Manifest_File_Length}    Get Line Count    ${Manifest_File_Contents}

    ### Get Manifest_File_Index after comment (#) ###
    Log    Get Manifest_File_Index after comment (#)
    :FOR    ${Manifest_File_Index}    IN RANGE    ${Manifest_File_Length}
    \    ${Manifest_Properties_Line_Content}    Get Line    ${Manifest_File_Contents}    ${Manifest_File_Index}
    \    ${Contains_EqualSign}    Run Keyword And Return Status    Should Contain    ${Manifest_Properties_Line_Content}    =
    \    Exit For Loop If    ${Contains_EqualSign}==${True}

    ### Validate Field Sequence ###
    Log    Validate Field Sequence
    ${Manifest_FieldList}    OperatingSystem.Get File    ${DWE_MANIFEST_FILE_FIELDLIST}
    ${Manifest_FieldList_Count}    Get Line Count    ${Manifest_FieldList}
    :FOR    ${LineCount}    IN RANGE    ${Manifest_FieldList_Count}
    \    ${Manifest_Properties_Line_Content}    Get Line    ${Manifest_File_Contents}    ${Manifest_File_Index}
    \    ${Manifest_Field_Line}    Get Line    ${Manifest_FieldList}    ${LineCount}
    \    ${Manifest_Properties_Line_Content_Value}    Split String    ${Manifest_Properties_Line_Content}    =
    \    Compare Two Strings    ${Manifest_Field_Line}    @{Manifest_Properties_Line_Content_Value}[0]
    \    ${Manifest_File_Index}    Evaluate    ${Manifest_File_Index}+1

    ### Validate Specific Field Value ###
    Log    Validate Specific Field Value
    :FOR    ${LineCount}    IN RANGE    ${Manifest_File_Length}
    \    ${Manifest_Properties_Line_Content}    Get Line    ${Manifest_File_Contents}    ${LineCount}
    \    ${Contains_Status}    Run Keyword And Return Status    Should Contain    ${Manifest_Properties_Line_Content}    Status
    \    ${Contains_BusDate}    Run Keyword And Return Status    Should Contain    ${Manifest_Properties_Line_Content}    businessDate
    \    ${Contains_LoadType}    Run Keyword And Return Status    Should Contain    ${Manifest_Properties_Line_Content}    LoadType
    \    ${Contains_TimeRegion}    Run Keyword And Return Status    Should Contain    ${Manifest_Properties_Line_Content}    TimeRegion
    \    ${Manifest_Properties_Line_Content_Value}    Split String    ${Manifest_Properties_Line_Content}    =
    \    Run Keyword If    ${Contains_Status}==${True}    Compare Two Strings    ${sStatus}    @{Manifest_Properties_Line_Content_Value}[1]
         ...    ELSE IF    ${Contains_BusDate}==${True}    Compare Two Strings    ${sBusiness_Date}    @{Manifest_Properties_Line_Content_Value}[1]
         ...    ELSE IF    ${Contains_LoadType}==${True}    Compare Two Strings    ${sLoad_Type}    @{Manifest_Properties_Line_Content_Value}[1]
         ...    ELSE IF    ${Contains_TimeRegion}==${True}    Compare Two Strings    ${sZone}    @{Manifest_Properties_Line_Content_Value}[1]

Validate DWH Folder from Landing Area
    [Documentation]    This keyword is used to download contents of dwh folder from Landing Area and validate csv files are correct.
    ...    sZone value format must be ZONE2 or ZONE3.
    ...    @author: clanding    09JUL2020    - initial create
    ...    @update: clanding    27AUG2020    - added Log for Log To Console
    [Arguments]    ${sZone}    ${sExtract_Path}    ${sAlphanumeric_Folder_Name}

    ### Download dwh from Landing Area ###
    Run Keyword And Ignore Error    Empty Directory    ${sExtract_Path}dwh
    SSHLibrary.Get Directory    ${DWE_LANDING_AREA_PATH}${sZone}/${sAlphanumeric_Folder_Name}/dwh    ${sExtract_Path}

    ### Validate csv count in dwh folder ###
    @{DWH_Files}    SSHLibrary.List Directory    ${DWE_LANDING_AREA_PATH}${sZone}/${sAlphanumeric_Folder_Name}/dwh
    ${DWH_Files_Count}    Get Length    ${DWH_Files}
    Run Keyword If    ${DWH_Files_Count}==${DWE_CSV_FILES_COUNT}    Run Keywords    Log To Console    dwh folder contains ${DWE_CSV_FILES_COUNT} csv files.
    ...    AND    Log    dwh folder contains ${DWE_CSV_FILES_COUNT} csv files.
    ...    ELSE    Run Keyword and Continue On Failure    FAIL    dwh folder DOES NOT contain ${DWE_CSV_FILES_COUNT} csv files. Actual count is ${DWH_Files_Count}.

    ### Validate table name count in DWE List ###
    ${DWE_Table_List_Content}    OperatingSystem.Get File    ${DWE_TABLE_LIST}
    ${DWE_Table_List_Count}    Get Line Count    ${DWE_Table_List_Content}
    Run Keyword If    ${DWE_Table_List_Count}==${DWE_CSV_FILES_COUNT}     Run Keywords    Log To Console    ${DWE_TABLE_LIST} contains ${DWE_CSV_FILES_COUNT} table names.
    ...    AND    Log    ${DWE_TABLE_LIST} contains ${DWE_CSV_FILES_COUNT} table names.
    ...    ELSE    Run Keyword and Continue On Failure    FAIL    ${DWE_TABLE_LIST} DOES NOT contain ${DWE_CSV_FILES_COUNT} table names. Actual count is ${DWE_Table_List_Count}.
    
    :FOR    ${LineCount}    IN RANGE    ${DWE_Table_List_Count}
    \    ### Validate if table name in the list matched csv filename in dwh folder
    \    ${DWE_Table_List_Line_Content}    Get Line    ${DWE_Table_List_Content}    ${LineCount}
    \    Run Keyword And Continue On Failure    Should Contain    ${DWH_Files}    ${DWE_Table_List_Line_Content.strip()}.csv
    \    ${Contains_Table_Name}    Run Keyword And Return Status    Should Contain    ${DWH_Files}    ${DWE_Table_List_Line_Content.strip()}.csv
    \    Run Keyword If    ${Contains_Table_Name}==${True}    Log    Table Name '${DWE_Table_List_Line_Content.strip()}' is existing in dwh folder with contents:${\n}${DWH_Files}.
         ...    ELSE    Log    Table Name '${DWE_Table_List_Line_Content.strip()}' is NOT existing in dwh folder with contents:${\n}${DWH_Files}.    level=ERROR
    \    Verify CSV File Contains Delimiter    ${sExtract_Path}dwh/${DWE_Table_List_Line_Content.strip()}.csv    ,

Download Compressed and JSON File from Extraction Area
    [Documentation]    This keyword is used to go to Extraction Area and download compressed file (GPG) and json file.
    ...    @author: clanding    10JUL2020    - initial create
    [Arguments]    ${sZone}    ${sExtract_Path}    ${sBus_Date}

    @{ExtractionArea_Files}    SSHLibrary.List Directory    ${DWE_EXTRACTION_AREA_PATH}${sZone}
    ${Bus_Date_Converted}    Remove String    ${sBus_Date}    -
    :FOR    ${File}    IN    @{ExtractionArea_Files}
    \    ${File_To_Download_GPG}    Run Keyword And Return Status    Should Be Equal    ${File}    ${DWE_CCB_LIQ_ZONE_FILENAME}${Bus_Date_Converted}${DWE_TAR_GZ_GPG_EXT}
    \    ${File_To_Download_JSON}    Run Keyword And Return Status    Should Be Equal    ${File}    ${DWE_CCB_LIQ_ZONE_FILENAME}${Bus_Date_Converted}.json
    \    Run Keyword If    ${File_To_Download_GPG}==${True} or ${File_To_Download_JSON}==${True}    Run Keywords    Delete File If Exist    ${sExtract_Path}/${File}
         ...    AND    SSHLibrary.Get File    ${DWE_EXTRACTION_AREA_PATH}${sZone}/${File}    ${sExtract_Path}

    ### Validate JSON File is existing ###
    ${JSON_File_Exist}    Run Keyword And Return Status    Should Contain    ${ExtractionArea_Files}    ${DWE_CCB_LIQ_ZONE_FILENAME}${Bus_Date_Converted}.json
    Run Keyword If    ${JSON_File_Exist}==${True}    Log    ${DWE_CCB_LIQ_ZONE_FILENAME}${Bus_Date_Converted}.json is EXISTING in Extraction Area.
    ...    ELSE    Run Keyword and Continue On Failure    FAIL    ${DWE_CCB_LIQ_ZONE_FILENAME}${Bus_Date_Converted}.json is NOT EXISTING in Extraction Area:${\n}${ExtractionArea_Files}

    ### Validate GPG File is existing ###
    ${GPG_File_Exist}    Run Keyword And Return Status    Should Contain    ${ExtractionArea_Files}    ${DWE_CCB_LIQ_ZONE_FILENAME}${Bus_Date_Converted}${DWE_TAR_GZ_GPG_EXT}
    Run Keyword If    ${GPG_File_Exist}==${True}    Log    ${DWE_CCB_LIQ_ZONE_FILENAME}${Bus_Date_Converted}${DWE_TAR_GZ_GPG_EXT} is EXISTING in Extraction Area.
    ...    ELSE    Run Keyword and Continue On Failure    FAIL    ${DWE_CCB_LIQ_ZONE_FILENAME}${Bus_Date_Converted}${DWE_TAR_GZ_GPG_EXT} is NOT EXISTING in Extraction Area:${\n}${ExtractionArea_Files}

    [Return]    ${DWE_CCB_LIQ_ZONE_FILENAME}${Bus_Date_Converted}${DWE_TAR_GZ_GPG_EXT}    ${DWE_CCB_LIQ_ZONE_FILENAME}${Bus_Date_Converted}${DWE_TAR_GZ_EXT}    ${DWE_CCB_LIQ_ZONE_FILENAME}${Bus_Date_Converted}.json

Validate JSON File from Extraction Area
    [Documentation]    This keyword is used to validate json file from extraction area.
    ...    @author: clanding    14JUL2020    - initial create
    [Arguments]    ${sJSON_File_Name}    ${sExtract_Path}    ${sProduct_Name}    ${sProduct_Version}    ${sGPG_File_Name}    ${sElement_Value}
    ...    ${sEncryption_Type}    ${sHashing_Algorithm}    ${sCompression_Type}

    ${JSON_Dict}    Load JSON From File    ${sExtract_Path}${sJSON_File_Name}
    ${Name}    Get Value From Json    ${JSON_Dict}    $.product.name
    ${Version}    Get Value From Json    ${JSON_Dict}    $.product.version

    ${FileName}    Get Value From Json    ${JSON_Dict}    $.controlInfo.fileName
    ${ElementValue}    Get Value From Json    ${JSON_Dict}    $.controlInfo.loadAssurance..elementValue
    ${EncryptionType}    Get Value From Json    ${JSON_Dict}    $.controlInfo.encryptionType
    ${HashingAlgorithm}    Get Value From Json    ${JSON_Dict}    $.controlInfo.hashingAlgorithm
    ${CompressionType}    Get Value From Json    ${JSON_Dict}    $.compressionType

    Compare Two Strings    ${sProduct_Name}    @{Name}[0]
    Compare Two Strings    ${sProduct_Version}    @{Version}[0]
    Compare Two Strings    ${sGPG_File_Name}    @{FileName}[0]
    Compare Two Strings    ${sElement_Value}    @{ElementValue}[0]
    Compare Two Strings    ${sEncryption_Type}    @{EncryptionType}[0]
    Compare Two Strings    ${sHashing_Algorithm}    @{HashingAlgorithm}[0]
    Compare Two Strings    ${sCompression_Type}    @{CompressionType}[0]

Decrypt Compressed File for DWE Extract
    [Documentation]    This keyword is used to perform decryption process for DWE extract compressed (.tar.gz) files.
    ...    @author: clanding    10JUL2020    - initial create
    [Arguments]    ${sExtract_Path}    ${sGPG_File}    ${sGZ_File}

    Run    ${DWE_DECRYPTION_PART1} ${DWE_DECRYPT_TOOL_PATH}
    Run    ${DWE_DECRYPTION_PART2} ${DWE_DECRYPTOR_JAR}
    Run    ${DWE_DECRYPTION_PART3} ${sExtract_Path}${sGPG_File}
    Run    ${DWE_DECRYPTION_PART3} ${DWE_DECRYPT_TOOL_PATH}/${DWE_PGP_SECRET_KEY}
    Run    ${DWE_DECRYPTION_PART3} ${DWE_PASSPHRASE}
    Run    ${DWE_DECRYPTION_PART3} ${sExtract_Path}${sGZ_File}
    Run    ${DWE_DECRYPTION_PART3} exit
    
    ### Check if GZ File is existing in Extract Path ###
    :FOR    ${Index}    IN RANGE    10
    \    ${GZ_File_Exist}    Run Keyword And Return Status    OperatingSystem.File Should Exist    ${sExtract_Path}${sGZ_File}
    \    Exit For Loop If    ${GZ_File_Exist}==${True}

    ### Check if GZ File is fully downloaded in Extract Path ###
    ${GPG_File_Size}    Get File Size    ${sExtract_Path}${sGPG_File}
    ${GPG_File_Size}    Evaluate    ${GPG_File_Size}-596
    :FOR    ${Index}    IN RANGE    1000
    \    ${GZ_File_Size}    Get File Size    ${sExtract_Path}${sGZ_File}
    \    Exit For Loop If    ${GZ_File_Size}==${GPG_File_Size}
    
    ${GZ_TAR_FolderName}    Remove String    ${sGZ_File}    ${DWE_TAR_GZ_EXT}
    Mx Extract File    ${sExtract_Path}${sGZ_File}    ${sExtract_Path}${GZ_TAR_FolderName}

Validate Compressed File from Extraction Area
    [Documentation]    This keyword is used to validate json file from extraction area.
    ...    @author: clanding    14JUL2020    - initial create
    [Arguments]    ${sExtract_Path}    ${sGZ_File}    ${sElement_Value}

    ${Decompressed_Folder}    Remove String    ${sGZ_File}    ${DWE_TAR_GZ_EXT}
    @{Decompressed_Folder_Files}    OperatingSystem.List Directory    ${sExtract_Path}${Decompressed_Folder}
    ${Decompressed_Folder_FileCount}    Get Length    ${Decompressed_Folder_Files}
    Compare Two Strings    ${sElement_Value}    ${Decompressed_Folder_FileCount}

    ${Element_Value_Per_FileType}    Evaluate    "%.0f" % (${sElement_Value}/2)

    @{Decompressed_Folder_Files}    OperatingSystem.List Directory    ${sExtract_Path}${Decompressed_Folder}    *.json
    ${JSON_Count}    Get Length    ${Decompressed_Folder_Files}
    Compare Two Strings    ${Element_Value_Per_FileType}    ${JSON_Count}

    @{Decompressed_Folder_Files}    OperatingSystem.List Directory    ${sExtract_Path}${Decompressed_Folder}    *.csv
    ${CSV_Count}    Get Length    ${Decompressed_Folder_Files}
    Compare Two Strings    ${Element_Value_Per_FileType}    ${CSV_Count}

Test Teardown for DWE Extract
    [Documentation]    This keyword is consists of Test Teardown keywords for DWE execution.
    ...    @author: clanding    28AUG2020    - initial create
    
    Close All Connections
    Run Keyword And Ignore Error    Close All Windows on LIQ
    Run Keyword And Ignore Error    Logout from Loan IQ

Test Setup for DWE Extract
    [Documentation]    This keyword is consists of Test Setup keywords for DWE execution.
    ...    @author: clanding    28AUG2020    - initial create
    
    # Mx Launch UFT    Visibility=True    UFTAddins=Java
    Login to Loan IQ    ${DWE_LIQ_USER}    ${DWE_LIQ_PASSWORD}