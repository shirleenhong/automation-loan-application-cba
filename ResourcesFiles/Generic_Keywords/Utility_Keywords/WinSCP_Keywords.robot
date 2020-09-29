*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Send Single File to SFTP and Validate If File is Processed
    [Documentation]    This keyword is used to send sGSFileName from sFilePathSource to sFilePathDestinaton and validates 
    ...    if file is removed from sFilePathDestinaton for processing.
    ...    @author: clanding    26FEB2019    - initial create
    ...    @update: mnanquil    06MAR2019    - updated for loop condition to use hard wait instead of continous loop.
    [Arguments]    ${sFilePathSource}    ${sGSFileName}    ${sFilePathDestinaton}
    
    Open Connection and Login    ${SFTP_HOST}    ${SFTP_PORT}    ${SFTP_USER}    ${SFTP_PASSWORD}
    Put File    ${dataset_path}${sFilePathSource}${sGSFileName}    ${sFilePathDestinaton}
    Log    Waiting for 2 mins 30 secs to finished to wait until file is consume in ${sFilePathDestinaton} folder.
    Sleep    150s
    :FOR    ${INDEX}    IN RANGE    5
    \    ${FileIsProcessed}    Run Keyword And Return Status    SSHLibrary.File Should Not Exist    ${sFilePathDestinaton}/${sGSFileName}  
    \    Run Keyword If    ${FileIsProcessed}==${True}    Log    ${sGSFileName} was picked up by the batch for processing.
         ...    ELSE    Log    Either waiting time is not enough or ${sGSFileName} was not picked up by the batch for processing.    level=ERROR
    \    Run Keyword And Continue On Failure    SSHLibrary.File Should Not Exist    ${sFilePathDestinaton}/${sGSFileName}
    \    Exit For Loop If    ${FileIsProcessed}==${True}
    @{Files}    SSHLibrary.List Files In Directory    ${sFilePathDestinaton}
    ${FileIsRemoved}    Run Keyword And Return Status    Should Not Contain    ${Files}    ${sGSFileName}
    Run Keyword And Continue On Failure    Should Not Contain    ${Files}    ${sGSFileName}    
    Run Keyword If    ${FileIsRemoved}==${True}    Log    ${sGSFileName} is removed from ${sFilePathDestinaton}.
    ...    ELSE    Log    ${sGSFileName} is NOT removed from ${sFilePathDestinaton}.    level=ERROR

Validate File If Moved to Archive Folder
    [Documentation]    This keyword is used to verify if GS File is successfully processed and moved to Archive Folder.
    ...    @author: clanding    26FEB2019    - initial create
    ...    @update: clanding    31MAY2019    - added variable file extension
    ...    @update: dahijara    20NOV2019    - added condition to set 'FileTimestamp_curr' to 0 if the value is 'None'
    [Arguments]    ${sArchiveFolder}    ${sGSFileName}    ${sFileExtension}=None
    
    @{Files}    SSHLibrary.List Directory    ${sArchiveFolder}
    ${FileCount}    Get Length    ${Files}
    ${MatchedFile_Count}    Set Variable    0
    ${MatchedFile_List}    Create List    
    ${FileTimestamp_prev}    Set Variable    0
    ${FileTimestamp_additional_prev}    Set Variable    ${ADDITIONAL_FILESTAMP}
    ${FileExtension}    Run Keyword If    '${sFileExtension}'=='None'    Set Variable    .csv
    ...    ELSE    Set Variable    ${sFileExtension}
    ${sGSFileName_NoCSV}    Remove String    ${sGSFileName}    ${FileExtension}
    
    :FOR    ${File}    IN    @{Files}
    \    ${Stat}    Run Keyword And Return Status    Should Contain    ${File}    ${sGSFileName_NoCSV}
    \    ${FileTimestamp}    Run Keyword If    ${Stat}==${True}    Remove String    ${File}    ${sGSFileName_NoCSV}_    ${FileExtension}
    \    ${FileTimestamp_List}    Run Keyword If    ${Stat}==${True}    Split String    ${FileTimestamp}    _
    \    ${FileTimestamp_0}    Run Keyword If    ${Stat}==${True}    Get From List    ${FileTimestamp_List}    0
    \    ${FileTimestamp_1}    Run Keyword If    ${Stat}==${True}    Get From List    ${FileTimestamp_List}    1
    \    ${FileTimestamp_curr}    Run Keyword If    ${Stat}==${True}    Remove String    ${File}    ${sGSFileName_NoCSV}_    ${FileExtension}    _${FileTimestamp_1}
    \    Run Keyword If    ${Stat}==${True}    Append To List    ${MatchedFile_List}    ${FileTimestamp_curr}    
         ...    ELSE    Append To List    ${MatchedFile_List}
    \    ${FileTimestamp_curr}    Run Keyword If    ${FileTimestamp_curr} == ${None}    Set Variable    0
    	 ...    ELSE    Set Variable    ${FileTimestamp_curr}
    \    ${FileTimestamp_prev}    Run Keyword If    ${FileTimestamp_curr}>${FileTimestamp_prev} or ${Stat}==${True}    Set Variable    ${FileTimestamp_0}
         ...    ELSE    Set Variable    ${FileTimestamp_prev}       
    \    ${FileTimestamp_additional_prev}    Run Keyword If    ${FileTimestamp_curr}>${FileTimestamp_prev} or ${Stat}==${True}    Set Variable    ${FileTimestamp_1}
         ...    ELSE    Set Variable    ${FileTimestamp_additional_prev}
    \    Log    ${File}
    \    Log    ${MatchedFile_List}
    
    Run Keyword And Continue On Failure    Should Not Be Equal    ${FileTimestamp_prev}    0
    ${NoTimestamp}    Run Keyword And Return Status    Should Be Equal    ${FileTimestamp_prev}    0         
    Run Keyword If    ${NoTimestamp}==${True}    Log    ${sGSFileName} is not existing in ${sArchiveFolder}.    level=ERROR
    ...    ELSE    Log    ${sGSFileName} is existing in ${sArchiveFolder}.
            
    ${FileTimestamp_latest}    Set Variable    ${FileTimestamp_prev}
    ${ADDITIONAL_FILESTAMP}    Run Keyword If    '${FileTimestamp_additional_prev}'!='${EMPTY}'    Set Variable    ${FileTimestamp_additional_prev}
    ...    ELSE    Set Variable    ${ADDITIONAL_FILESTAMP}
    Set Global Variable    ${GSFILENAME_WITHTIMESTAMP}    ${sGSFileName_NoCSV}_${FileTimestamp_latest}_${ADDITIONAL_FILESTAMP}${FileExtension}
    

Send Multiple Files to SFTP and Validate If Files are Processed
    [Documentation]    This keyword is used to send multiple files within 2 seconds interval then validate if files are processed and moved to Archive folder.
    ...    @author: clanding    04MAR2019    - initial create
    ...    @update: clanding    31MAY2019    - added optional waiting time for the files to be consumed
    ...    @update: clanding    17JUL2019    - added handling for files for TL Calendar
    ...    @update: cfrancis    01AUG2019    - added delay in put file loop
    ...    @update: clanding    05AUG2019    - removed handling for TL Calendar files
    ...    ...    @update: cfrancis    01AUG2019    - added delay in put file loop
    [Arguments]    ${sInputFilePath}    ${sFilePathDestinaton}    ${sInputGSFile}    ${sArchiveFolder}    ${sDelimiter}=None    ${iPollingTime}=None    ${iDelayTime}=None
    
    @{InputGSFile_List}    Run Keyword If    '${sDelimiter}'=='None'    Split String    ${sInputGSFile}    ,
    ...    ELSE    Split String    ${sInputGSFile}    ${sDelimiter}
    ${InputGSFile_Count}    Get Length    ${InputGSFile_List}
    
    Open Connection and Login    ${SFTP_HOST}    ${SFTP_PORT}    ${SFTP_USER}    ${SFTP_PASSWORD}    
    :FOR    ${GSFileName}    IN    @{InputGSFile_List}
    \    Put File    ${dataset_path}${sInputFilePath}${GSFileName}    ${sFilePathDestinaton}
    \    Run Keyword If    '${iDelayTime}'!='None'    Sleep    ${iDelayTime}

    Run Keyword If    '${iPollingTime}'=='None'    Sleep    2.5m    ###The processing time for GS File for Base Rate and FX Rate is every 2 minutes
    ...    ELSE    Sleep    ${iPollingTime}
    
    @{GSFilename_ArchiveList}    Create List
    :FOR    ${GSFileName}    IN    @{InputGSFile_List}
    \    ${FileIsProcessed}    Run Keyword And Return Status    SSHLibrary.File Should Not Exist    ${sFilePathDestinaton}/${GSFileName}
    \    Run Keyword And Continue On Failure    SSHLibrary.File Should Not Exist    ${sFilePathDestinaton}/${GSFileName}
    \    Run Keyword If    ${FileIsProcessed}==${True}    Log    ${GSFileName} was picked up by the batch for processing.
         ...    ELSE    Log    Either waiting time is not enough or ${GSFileName} was not picked up by the batch for processing.    level=ERROR
    \    @{Files}    SSHLibrary.List Files In Directory    ${sFilePathDestinaton}
    \    ${FileIsRemoved}    Run Keyword And Return Status    Should Not Contain    ${Files}    ${GSFileName}
    \    Run Keyword And Continue On Failure    Should Not Contain    ${Files}    ${GSFileName}    
    \    Run Keyword If    ${FileIsRemoved}==${True}	Log    ${GSFileName} is removed from ${sFilePathDestinaton}.
         ...    ELSE    Log    ${GSFileName} is NOT removed from ${sFilePathDestinaton}.    level=ERROR
    \    Validate File If Moved to Archive Folder    ${sArchiveFolder}    ${GSFileName}
    \    Log    ${GSFILENAME_WITHTIMESTAMP}
    \    Append To List    ${GSFilename_ArchiveList}    ${GSFILENAME_WITHTIMESTAMP}
    Set Global Variable    ${ARCHIVE_GSFILENAME_LIST}    ${GSFilename_ArchiveList}
    Log    ${ARCHIVE_GSFILENAME_LIST}
    Log to Console    ${ARCHIVE_GSFILENAME_LIST}
    
Validate File If Moved to File Validation Failed Folder
    [Documentation]    This keyword is used to verify if GS File is unsuccessfully processed and moved to Error/File Validation Failed Folder.
    ...    @author: clanding    12MAR2019    - initial create
    ...    @update: cfrancis    03SEP2019    - updated ${GSFileName_RequestID} from Substring 16 to 22 and added removal of ROUP from filename GROUP to G
    ...    @update: jloretiz    15JAN2020    - added additional validation for different types of expected error.
    ...    @update: jloretiz    22JAN2020    - added additional validation for invalid date format
    ...    @update: dahijara    04FEB2020    - added ELSE condition for getting ${FileTimestamp} & ${FileTimestamp_curr} to set 0 value when if condition is not met.
    ...    @update: dahijara    07FEB2020    - added else condition for getting ${GSFileName_RequestID} (invalid date format)
    ...    @udpate: jdelacru    25SEP2020    - deleted the condition in naming file with invalid file format
    [Arguments]    ${sFileValFailedFolder}    ${sGSFileName}    ${sFileExtension}=None    ${sErrorDesc}=None
    
    @{Files}    SSHLibrary.List Directory    ${sFileValFailedFolder}
    ${FileCount}    Get Length    ${Files}
    ${MatchedFile_Count}    Set Variable    0
    ${MatchedFile_List}    Create List    
    ${FileTimestamp_prev}    Set Variable    0
    ${FileTimestamp_additional_prev}    Set Variable    ${ADDITIONAL_FILESTAMP}
    ${FileExtension}    Run Keyword If    '${sFileExtension}'=='None'    Set Variable    csv
    ...    ELSE    Set Variable    ${sFileExtension}
    ${sGSFileName_NoCSV}    Remove String    ${sGSFileName}    .${FileExtension}
    
    :FOR    ${File}    IN    @{Files}
    \    ${Stat}    Run Keyword And Return Status    Should Contain    ${File}    ${sGSFileName_NoCSV}
    \    ${FileTimestamp}    Run Keyword If    ${Stat}==${True}    Remove String    ${File}    ${sGSFileName_NoCSV}_    .${FileExtension}
         ...    ELSE    Set Variable    0
    \    ${FileTimestamp_List}    Run Keyword If    ${Stat}==${True}    Split String    ${FileTimestamp}    _
    \    ${FileTimestamp_0}    Run Keyword If    ${Stat}==${True}    Get From List    ${FileTimestamp_List}    0
    \    ${FileTimestamp_1}    Run Keyword If    ${Stat}==${True}    Get From List    ${FileTimestamp_List}    1
    \    ${FileTimestamp_curr}    Run Keyword If    ${Stat}==${True}    Remove String    ${File}    ${sGSFileName_NoCSV}_    .${FileExtension}    _${FileTimestamp_1}
         ...    ELSE    Set Variable    0
    \    Run Keyword If    ${Stat}==${True}    Append To List    ${MatchedFile_List}    ${FileTimestamp_curr}    
         ...    ELSE    Append To List    ${MatchedFile_List}
    \    ${FileTimestamp_prev}    Run Keyword If    ${FileTimestamp_curr}>${FileTimestamp_prev} or ${Stat}==${True}    Set Variable    ${FileTimestamp_0}
         ...    ELSE    Set Variable    ${FileTimestamp_prev}       
    \    ${FileTimestamp_additional_prev}    Run Keyword If    ${FileTimestamp_curr}>${FileTimestamp_prev} or ${Stat}==${True}    Set Variable    ${FileTimestamp_1}
         ...    ELSE    Set Variable    ${FileTimestamp_additional_prev}
    \    Log    ${File}
    \    Log    ${MatchedFile_List}
    
    Run Keyword And Continue On Failure    Should Not Be Equal    ${FileTimestamp_prev}    0
    ${NoTimestamp}    Run Keyword And Return Status    Should Be Equal    ${FileTimestamp_prev}    0         
    Run Keyword If    ${NoTimestamp}==${True}    Log    ${sGSFileName} is not existing in ${sFileValFailedFolder}.    level=ERROR
    ...    ELSE    Log    ${sGSFileName} is existing in ${sFileValFailedFolder}.
            
    ${FileTimestamp_latest}    Set Variable    ${FileTimestamp_prev}
    ${ADDITIONAL_FILESTAMP}    Run Keyword If    '${FileTimestamp_additional_prev}'!='${EMPTY}'    Set Variable    ${FileTimestamp_additional_prev}
    ...    ELSE    Set Variable    ${ADDITIONAL_FILESTAMP}
    ${GSFileName_RequestID}    Get Substring    ${sGSFileName_NoCSV}_${FileTimestamp_latest}_${ADDITIONAL_FILESTAMP}   22
    ${GSFileName_RequestID}    Remove String    ${GSFileName_RequestID}    ROUP

    ###INVALID DATE FORMAT###
    ${GSFileName_RequestID}    Run Keyword If    '${sErrorDesc}'=='${INVALIDDATEFORMAT}'    Get Substring    ${sGSFileName_NoCSV}_${FileTimestamp_latest}_${ADDITIONAL_FILESTAMP}   16
    ...    ELSE    Set Variable    ${GSFileName_RequestID}     

    ###INVALID FILE NAME###
    ${SubstringFileName}    Run Keyword If    '${sErrorDesc}'=='${INVALIDFILENAME}' or '${sErrorDesc}'=='${SMALLCASESFILENAME}'    Get Substring    ${sGSFileName_NoCSV}    0    16
    ${GSFileName_RequestID}    Run Keyword If    '${sErrorDesc}'=='${INVALIDFILENAME}' or '${sErrorDesc}'=='${SMALLCASESFILENAME}'    Set Variable    ${SubstringFileName}_${FileTimestamp_latest}_${ADDITIONAL_FILESTAMP}
    ...    ELSE    Set Variable    ${GSFileName_RequestID}
    ${GSFileName_RequestID}    Run Keyword If    '${sErrorDesc}'=='${SMALLCASESFILENAME}'    Convert to Lowercase    ${GSFileName_RequestID}
    ...    ELSE    Set Variable    ${GSFileName_RequestID}

    Set Global Variable    ${GSFILENAME_COMPLETE}    ${sGSFileName_NoCSV}_${FileTimestamp_latest}_${ADDITIONAL_FILESTAMP}.${FileExtension}
    Set Global Variable    ${GSFILENAME_WITHTIMESTAMP}    ${GSFileName_RequestID}

Send Multiple Files to SFTP and Validate If Files are Processed for Holiday
    [Documentation]    This keyword is used to send 5 Copp Clark files then validate if files are processed and moved to Archive folder.
    ...    @author: clanding    17JUL2019    - initial create
    ...    @update: jloretiz    26NOV2019    - add the convertion of file from XLSX to XLS before dropping in TL server
    [Arguments]    ${sInputFilePath}    ${sFilePathDestinaton}    ${sInputGSFile}    ${sArchiveFolder}    ${sDelimiter}=None    ${iPollingTime}=None
    
    ###Convert to XLS the XLSX###
    Convert Excel XLSX to XLS    ${sInputFilePath}    ${sInputGSFile}    ${File_1}
    Convert Excel XLSX to XLS    ${sInputFilePath}    ${sInputGSFile}    ${File_2}
    Convert Excel XLSX to XLS    ${sInputFilePath}    ${sInputGSFile}    ${Misc_File}  

    @{InputGSFile_List}    Run Keyword If    '${sDelimiter}'=='None'    Split String    ${sInputGSFile}    ,
    ...    ELSE    Split String    ${sInputGSFile}    ${sDelimiter}
    
    ### Get XLS Files###
    ${InputGSFile_XLSList}    Create List
    :FOR    ${XLSFile}    IN    @{InputGSFile_List}
    \    ${Contains_XLS}    Run Keyword And Return Status    Should Contain    ${XLSFile}    ${XLS}
    \    ${ConvertedString}    Run Keyword If    ${Contains_XLS}==${True}    Replace String    ${XLSFile}    .xlsx    .xls
         ...    ELSE    Set Variable    ${XLSFile}
    \    Run Keyword If    ${Contains_XLS}==${True}    Append To List    ${InputGSFile_XLSList}    ${ConvertedString}
         ...    ELSE    Append To List    ${InputGSFile_XLSList}

    ### Get CSV Files ###
    ${InputGSFile_CSVList}    Create List
    :FOR    ${CSVFile}    IN    @{InputGSFile_List}
    \    ${Contains_CSV}    Run Keyword And Return Status    Should Contain    ${CSVFile}    ${CSV}
    \    Run Keyword If    ${Contains_CSV}==${True}    Append To List    ${InputGSFile_CSVList}    ${CSVFile}
         ...    ELSE    Append To List    ${InputGSFile_CSVList}
    
    Stop TL Service
    Open Connection and Login    ${SFTP_HOST}    ${SFTP_PORT}    ${SFTP_USER}    ${SFTP_PASSWORD}
    :FOR    ${GSFileName_XLS}    IN    @{InputGSFile_XLSList}
    \    Put File    ${dataset_path}${sInputFilePath}${GSFileName_XLS}    ${sFilePathDestinaton}
    
    :FOR    ${GSFileName_CSV}    IN    @{InputGSFile_CSVList}
    \    Put File    ${dataset_path}${sInputFilePath}${GSFileName_CSV}    ${sFilePathDestinaton}

    Start TL Service
    Open Connection and Login    ${SFTP_HOST}    ${SFTP_PORT}    ${SFTP_USER}    ${SFTP_PASSWORD}
    Run Keyword If    '${iPollingTime}'=='None'    Sleep    2m    ###The processing time for GS File for Base Rate and FX Rate is every 2 minutes
    ...    ELSE    Sleep    ${iPollingTime}
    
    ### Validate CSV Files ###
    :FOR    ${GSFileName_CSV}    IN    @{InputGSFile_CSVList}
    \    ${FileIsProcessed}    Run Keyword And Return Status    SSHLibrary.File Should Not Exist    ${sFilePathDestinaton}/${GSFileName_CSV}
    \    Run Keyword And Continue On Failure    SSHLibrary.File Should Not Exist    ${sFilePathDestinaton}/${GSFileName_CSV}
    \    Run Keyword If    ${FileIsProcessed}==${True}    Log    ${GSFileName_CSV} was picked up by the batch for processing.
         ...    ELSE    Log    Either waiting time is not enough or ${GSFileName_CSV} was not picked up by the batch for processing.    level=ERROR
    \    @{Files}    SSHLibrary.List Files In Directory    ${sFilePathDestinaton}
    \    ${FileIsRemoved}    Run Keyword And Return Status    Should Not Contain    ${Files}    ${GSFileName_CSV}
    \    Run Keyword And Continue On Failure    Should Not Contain    ${Files}    ${GSFileName_CSV}    
    \    Run Keyword If    ${FileIsRemoved}==${True}	Log    ${GSFileName_CSV} is removed from ${sFilePathDestinaton}.
         ...    ELSE    Log    ${GSFileName_CSV} is NOT removed from ${sFilePathDestinaton}.    level=ERROR
    \    Validate File If Moved to Archive Folder For Holiday    ${sArchiveFolder}    ${GSFileName_CSV}    ${CSV}    

    ### Validate XLS Files ###
    @{GSFilename_ArchiveList}    Create List
    :FOR    ${GSFileName_XLS}    IN    @{InputGSFile_XLSList}
    \    ${FileIsProcessed}    Run Keyword And Return Status    SSHLibrary.File Should Not Exist    ${sFilePathDestinaton}/${GSFileName_XLS}
    \    Run Keyword And Continue On Failure    SSHLibrary.File Should Not Exist    ${sFilePathDestinaton}/${GSFileName_XLS}
    \    Run Keyword If    ${FileIsProcessed}==${True}    Log    ${GSFileName_XLS} was picked up by the batch for processing.
         ...    ELSE    Log    Either waiting time is not enough or ${GSFileName_XLS} was not picked up by the batch for processing.    level=ERROR
    \    @{Files}    SSHLibrary.List Files In Directory    ${sFilePathDestinaton}
    \    ${FileIsRemoved}    Run Keyword And Return Status    Should Not Contain    ${Files}    ${GSFileName_XLS}
    \    Run Keyword And Continue On Failure    Should Not Contain    ${Files}    ${GSFileName_XLS}    
    \    Run Keyword If    ${FileIsRemoved}==${True}	Log    ${GSFileName_XLS} is removed from ${sFilePathDestinaton}.
         ...    ELSE    Log    ${GSFileName_XLS} is NOT removed from ${sFilePathDestinaton}.    level=ERROR
    \    Validate File If Moved to Archive Folder For Holiday    ${sArchiveFolder}    ${GSFileName_XLS}    ${XLS}    
    \    Log    ${GSFILENAME_WITHTIMESTAMP}
    \    Append To List    ${GSFilename_ArchiveList}    ${GSFILENAME_WITHTIMESTAMP}
    Set Global Variable    ${ARCHIVE_GSFILENAME_LIST}    ${GSFilename_ArchiveList}
    Log    ${ARCHIVE_GSFILENAME_LIST}
    Log to Console    ${ARCHIVE_GSFILENAME_LIST}

Validate File If Moved to Archive Folder For Holiday
    [Documentation]    This keyword is used to verify if GS File is successfully processed and moved to Archive Folder for Holidays.
    ...    @author: clanding    17JUL2019    - initial create
    [Arguments]    ${sArchiveFolder}    ${sGSFileName}    ${sFileExtension}=None
    
    @{Files}    SSHLibrary.List Directory    ${sArchiveFolder}
    ${FileCount}    Get Length    ${Files}
    ${MatchedFile_Count}    Set Variable    0
    ${MatchedFile_List}    Create List    
    ${FileTimestamp_prev}    Set Variable    0
    ${FileTimestamp_additional_prev}    Set Variable    ${ADDITIONAL_FILESTAMP}
    ${FileExtension}    Run Keyword If    '${sFileExtension}'=='None'    Set Variable    .csv
    ...    ELSE    Set Variable    ${sFileExtension}
    ${sGSFileName_NoExt}    Remove String    ${sGSFileName}    .${FileExtension}
    
    :FOR    ${File}    IN    @{Files}
    \    ${Stat}    Run Keyword And Return Status    Should Contain    ${File}    ${sGSFileName_NoExt}
    \    ${FileTimestamp}    Run Keyword If    ${Stat}==${True}    Remove String    ${File}    ${sGSFileName_NoExt}_    .${FileExtension}
         ...    ELSE    Set Variable    0
    \    ${FileTimestamp_Contains_FileExt}    Run Keyword And Return Status    Should Contain    ${FileTimestamp}    .
    \    ${FileTimestamp_curr}    Run Keyword If    ${Stat}==${True} and ${FileTimestamp_Contains_FileExt}==${False}    Set Variable    ${FileTimestamp}
         ...    ELSE    Set Variable    0
    \    Run Keyword If    ${Stat}==${True} and ${FileTimestamp_Contains_FileExt}==${False}    Append To List    ${MatchedFile_List}    ${FileTimestamp}    
         ...    ELSE    Append To List    ${MatchedFile_List}
    \    ${FileTimestamp_prev}    Run Keyword If    ${FileTimestamp_curr}>${FileTimestamp_prev} and ${FileTimestamp_Contains_FileExt}==${False}    Set Variable    ${FileTimestamp}
         ...    ELSE IF    ${Stat}==${True} and ${FileTimestamp_Contains_FileExt}==${False}    Set Variable    ${FileTimestamp}
         ...    ELSE    Set Variable    ${FileTimestamp_prev}       
    \    Log    ${File}
    \    Log    ${MatchedFile_List}
    
    Run Keyword And Continue On Failure    Should Not Be Equal    ${FileTimestamp_prev}    0
    ${NoTimestamp}    Run Keyword And Return Status    Should Be Equal    ${FileTimestamp_prev}    0         
    Run Keyword If    ${NoTimestamp}==${True}    Log    ${sGSFileName} is not existing in ${sArchiveFolder}.    level=ERROR
    ...    ELSE    Log    ${sGSFileName} is existing in ${sArchiveFolder}.
            
    ${FileTimestamp_latest}    Set Variable    ${FileTimestamp_prev}
    Set Global Variable    ${GSFILENAME_WITHTIMESTAMP}    ${sGSFileName_NoExt}_${FileTimestamp_latest}.${FileExtension}

Stop TL Service
    [Documentation]    This keyword is used to execute shutdown.sh from Transoformation folder.
    ...    @author: clanding    16JUL2019    - initial create
    
    Open Connection and Login    ${TL_SERVICE_HOST}    ${TL_SERVICE_PORT}    ${TL_SERVER_USER}    ${TL_SERVER_PASSWORD}
    Write    cd ${TL_SERVICE_DIR}
    ${ReturnCommand}    Read    delay=5s
    Write    ./shutdown.sh
    ${ReturnCommand}    Read    delay=5s
    Log    ${ReturnCommand}
    Close All Connections

Start TL Service
    [Documentation]    This keyword is used to execute startup.sh from Transoformation folder.
    ...    @author: clanding    18JUL2019    - initial create
    
    Open Connection and Login    ${TL_SERVICE_HOST}    ${TL_SERVICE_PORT}    ${TL_SERVER_USER}    ${TL_SERVER_PASSWORD}
    Write    cd ${TL_SERVICE_DIR}
    ${ReturnCommand}    Read    delay=5s
    Write    ./startup.sh
    ${ReturnCommand}    Read    delay=5s
    Log    ${ReturnCommand}
    Close All Connections
    
Send Multiple Files to SFTP and Validate If Files are Not Processed for Holiday
    [Documentation]    This keyword is used to send 5 Copp Clark files then validate if files are not processed and moved to Error folder.
    ...    @author: dahijara    17DEC2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sFilePathDestinaton}    ${sInputGSFile}    ${sFolderPath}    ${sDelimiter}=None    ${iPollingTime}=None

    @{InputGSFile_List}    Run Keyword If    '${sDelimiter}'=='None'    Split String    ${sInputGSFile}    ,
    ...    ELSE    Split String    ${sInputGSFile}    ${sDelimiter}
    
    ### Get XLS Files###
    ${InputGSFile_XLSList}    Create List
    :FOR    ${XLSFile}    IN    @{InputGSFile_List}
    \    ${Contains_XLS}    Run Keyword And Return Status    Should Contain    ${XLSFile}    ${XLS}
    \    Run Keyword If    ${Contains_XLS}==${True}    Append To List    ${InputGSFile_XLSList}    ${XLSFile}
         ...    ELSE    Append To List    ${InputGSFile_XLSList}

    ### Get CSV Files ###
    ${InputGSFile_CSVList}    Create List
    :FOR    ${CSVFile}    IN    @{InputGSFile_List}
    \    ${Contains_CSV}    Run Keyword And Return Status    Should Contain    ${CSVFile}    ${CSV}
    \    Run Keyword If    ${Contains_CSV}==${True}    Append To List    ${InputGSFile_CSVList}    ${CSVFile}
         ...    ELSE    Append To List    ${InputGSFile_CSVList}
    
    Stop TL Service
    Open Connection and Login    ${SFTP_HOST}    ${SFTP_PORT}    ${SFTP_USER}    ${SFTP_PASSWORD}
    :FOR    ${GSFileName_XLS}    IN    @{InputGSFile_XLSList}
    \    Put File    ${dataset_path}${sInputFilePath}${GSFileName_XLS}    ${sFilePathDestinaton}
    
    :FOR    ${GSFileName_CSV}    IN    @{InputGSFile_CSVList}
    \    Put File    ${dataset_path}${sInputFilePath}${GSFileName_CSV}    ${sFilePathDestinaton}

    Start TL Service
    Open Connection and Login    ${SFTP_HOST}    ${SFTP_PORT}    ${SFTP_USER}    ${SFTP_PASSWORD}
    Run Keyword If    '${iPollingTime}'=='None'    Sleep    2m    ###The processing time for GS File for Base Rate and FX Rate is every 2 minutes
    ...    ELSE    Sleep    ${iPollingTime}
    
    ### Validate CSV Files ###
    :FOR    ${GSFileName_CSV}    IN    @{InputGSFile_CSVList}
    \    ${FileIsProcessed}    Run Keyword And Return Status    SSHLibrary.File Should Not Exist    ${sFilePathDestinaton}/${GSFileName_CSV}
    \    Run Keyword And Continue On Failure    SSHLibrary.File Should Not Exist    ${sFilePathDestinaton}/${GSFileName_CSV}
    \    Run Keyword If    ${FileIsProcessed}==${True}    Log    ${GSFileName_CSV} was picked up by the batch for processing.
         ...    ELSE    Log    Either waiting time is not enough or ${GSFileName_CSV} was not picked up by the batch for processing.    level=ERROR
    \    @{Files}    SSHLibrary.List Files In Directory    ${sFilePathDestinaton}
    \    ${FileIsRemoved}    Run Keyword And Return Status    Should Not Contain    ${Files}    ${GSFileName_CSV}
    \    Run Keyword And Continue On Failure    Should Not Contain    ${Files}    ${GSFileName_CSV}    
    \    Run Keyword If    ${FileIsRemoved}==${True}	Log    ${GSFileName_CSV} is removed from ${sFilePathDestinaton}.
         ...    ELSE    Log    ${GSFileName_CSV} is NOT removed from ${sFilePathDestinaton}.    level=ERROR
    \    Validate File If Moved to Archive Folder For Holiday    ${TL_CALENDAR_ARCHIVE_FOLDER}    ${GSFileName_CSV}    ${CSV}    

    ### Validate XLS Files ###
    @{GSFilename_ArchiveList}    Create List
    :FOR    ${GSFileName_XLS}    IN    @{InputGSFile_XLSList}
    \    ${FileIsProcessed}    Run Keyword And Return Status    SSHLibrary.File Should Not Exist    ${sFilePathDestinaton}/${GSFileName_XLS}
    \    Run Keyword And Continue On Failure    SSHLibrary.File Should Not Exist    ${sFilePathDestinaton}/${GSFileName_XLS}
    \    Run Keyword If    ${FileIsProcessed}==${True}    Log    ${GSFileName_XLS} was picked up by the batch for processing.
         ...    ELSE    Log    Either waiting time is not enough or ${GSFileName_XLS} was not picked up by the batch for processing.    level=ERROR
    \    @{Files}    SSHLibrary.List Files In Directory    ${sFilePathDestinaton}
    \    ${FileIsRemoved}    Run Keyword And Return Status    Should Not Contain    ${Files}    ${GSFileName_XLS}
    \    Run Keyword And Continue On Failure    Should Not Contain    ${Files}    ${GSFileName_XLS}    
    \    Run Keyword If    ${FileIsRemoved}==${True}	Log    ${GSFileName_XLS} is removed from ${sFilePathDestinaton}.
         ...    ELSE    Log    ${GSFileName_XLS} is NOT removed from ${sFilePathDestinaton}.    level=ERROR
    \    Run Keyword If    '${sFolderPath}'=='${TL_CALENDAR_ARCHIVE_FOLDER}'    Validate File If Not Moved to Archive Folder For Holiday    ${sFolderPath}    ${GSFileName_XLS}    ${XLS}
         ...    ELSE    Validate File If Moved to Error For Holiday    ${sFolderPath}    ${GSFileName_XLS}    ${XLS}
    \    Log    ${GSFILENAME_WITHTIMESTAMP}
    \    Append To List    ${GSFilename_ArchiveList}    ${GSFILENAME_WITHTIMESTAMP}
    Set Global Variable    ${ARCHIVE_GSFILENAME_LIST}    ${GSFilename_ArchiveList}
    Log    ${ARCHIVE_GSFILENAME_LIST}
    Log to Console    ${ARCHIVE_GSFILENAME_LIST}

Validate File If Moved to Error For Holiday
    [Documentation]    This keyword is used to verify if GS File is successfully processed and moved to Archive Folder for Holidays.
    ...    @author: clanding    17JUL2019    - initial create
    [Arguments]    ${sErrorFolder}    ${sGSFileName}    ${sFileExtension}=None
    
    @{Files}    SSHLibrary.List Directory    ${sErrorFolder}
    ${FileCount}    Get Length    ${Files}
    ${MatchedFile_Count}    Set Variable    0
    ${MatchedFile_List}    Create List    
    ${FileTimestamp_prev}    Set Variable    0
    ${FileTimestamp_additional_prev}    Set Variable    ${ADDITIONAL_FILESTAMP}
    ${FileExtension}    Run Keyword If    '${sFileExtension}'=='None'    Set Variable    .csv
    ...    ELSE    Set Variable    ${sFileExtension}
    ${sGSFileName_NoExt}    Remove String    ${sGSFileName}    .${FileExtension}
    
    :FOR    ${File}    IN    @{Files}
    \    
    \    ${Stat}    Run Keyword And Return Status    Should Contain    ${File}    ${sGSFileName_NoExt}
    \    ${FileTimestamp}    Run Keyword If    ${Stat}==${True}    Remove String    ${File}    ${sGSFileName_NoExt}_    .${FileExtension}
         ...    ELSE    Set Variable    0
    \    ${FileTimestamp_Contains_FileExt}    Run Keyword And Return Status    Should Contain    ${FileTimestamp}    .
    \    ${FileTimestamp_curr}    Run Keyword If    ${Stat}==${True} and ${FileTimestamp_Contains_FileExt}==${False}    Set Variable    ${FileTimestamp}
         ...    ELSE    Set Variable    0
    \    Run Keyword If    ${Stat}==${True} and ${FileTimestamp_Contains_FileExt}==${False}    Append To List    ${MatchedFile_List}    ${FileTimestamp}    
         ...    ELSE    Append To List    ${MatchedFile_List}
    \    ${FileTimestamp_prev}    Run Keyword If    ${FileTimestamp_curr}>${FileTimestamp_prev} and ${FileTimestamp_Contains_FileExt}==${False}    Set Variable    ${FileTimestamp}
         ...    ELSE IF    ${Stat}==${True} and ${FileTimestamp_Contains_FileExt}==${False}    Set Variable    ${FileTimestamp}
         ...    ELSE    Set Variable    ${FileTimestamp_prev}       
    \    Log    ${File}
    \    Log    ${MatchedFile_List}
    
    Run Keyword And Continue On Failure    Should Not Be Equal    ${FileTimestamp_prev}    0
    ${NoTimestamp}    Run Keyword And Return Status    Should Be Equal    ${FileTimestamp_prev}    0         
    Run Keyword If    ${NoTimestamp}==${True}    Log    ${sGSFileName} is not existing in ${sErrorFolder}.    level=ERROR
    ...    ELSE    Log    ${sGSFileName} is existing in ${sErrorFolder}.
            
    ${FileTimestamp_latest}    Set Variable    ${FileTimestamp_prev}
    Set Global Variable    ${GSFILENAME_WITHTIMESTAMP}    ${sGSFileName_NoExt}_${FileTimestamp_latest}.${FileExtension}
    
Validate File If Not Moved to Archive Folder For Holiday
    [Documentation]    This keyword is used to verify if GS File is unsuccessfully processed and not moved to Archive Folder for Holidays.
    ...    @author: dahijara    18DEC2019    - initial create
    [Arguments]    ${sArchiveFolder}    ${sGSFileName}    ${sFileExtension}=None
    
    @{Files}    SSHLibrary.List Directory    ${sArchiveFolder}
    ${FileCount}    Get Length    ${Files}
    ${MatchedFile_Count}    Set Variable    0
    ${MatchedFile_List}    Create List    
    ${FileTimestamp_prev}    Set Variable    0
    ${FileTimestamp_additional_prev}    Set Variable    ${ADDITIONAL_FILESTAMP}
    ${FileExtension}    Run Keyword If    '${sFileExtension}'=='None'    Set Variable    .csv
    ...    ELSE    Set Variable    ${sFileExtension}
    ${sGSFileName_NoExt}    Remove String    ${sGSFileName}    .${FileExtension}
    
    :FOR    ${File}    IN    @{Files}
    \    ${Stat}    Run Keyword And Return Status    Should Contain    ${File}    ${sGSFileName_NoExt}
    \    ${FileTimestamp}    Run Keyword If    ${Stat}==${True}    Remove String    ${File}    ${sGSFileName_NoExt}_    .${FileExtension}
         ...    ELSE    Set Variable    0
    \    ${FileTimestamp_Contains_FileExt}    Run Keyword And Return Status    Should Contain    ${FileTimestamp}    .
    \    ${FileTimestamp_curr}    Run Keyword If    ${Stat}==${True} and ${FileTimestamp_Contains_FileExt}==${False}    Set Variable    ${FileTimestamp}
         ...    ELSE    Set Variable    0
    \    Run Keyword If    ${Stat}==${True} and ${FileTimestamp_Contains_FileExt}==${False}    Append To List    ${MatchedFile_List}    ${FileTimestamp}    
         ...    ELSE    Append To List    ${MatchedFile_List}
    \    ${FileTimestamp_prev}    Run Keyword If    ${FileTimestamp_curr}>${FileTimestamp_prev} and ${FileTimestamp_Contains_FileExt}==${False}    Set Variable    ${FileTimestamp}
         ...    ELSE IF    ${Stat}==${True} and ${FileTimestamp_Contains_FileExt}==${False}    Set Variable    ${FileTimestamp}
         ...    ELSE    Set Variable    ${FileTimestamp_prev}       
    \    Log    ${File}
    \    Log    ${MatchedFile_List}
    
    ${NoTimestamp}    Run Keyword And Return Status    Should Be Equal    ${FileTimestamp_prev}    0         
    Run Keyword If    ${NoTimestamp}==${True}    Log    ${sGSFileName} is not existing in ${sArchiveFolder}.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    ${sGSFileName} is existing in ${sArchiveFolder}.
            
    ${FileTimestamp_latest}    Set Variable    ${FileTimestamp_prev}
    Set Global Variable    ${GSFILENAME_WITHTIMESTAMP}    ${sGSFileName_NoExt}_${FileTimestamp_latest}.${FileExtension}

Send Multiple Files to SFTP and Validate If Files are Not Processed for Holiday With Missing File
    [Documentation]    This keyword is used to send Less than 5 Copp Clark files then validate if files are not processed and not moved to any folder.
    ...    @author: dahijara    2FEB2020    - initial create
    [Arguments]    ${sInputFilePath}    ${sFilePathDestinaton}    ${sInputGSFile}    ${sFolderPath}    ${sDelimiter}=None    ${iPollingTime}=None

    @{InputGSFile_List}    Run Keyword If    '${sDelimiter}'=='None'    Split String    ${sInputGSFile}    ,
    ...    ELSE    Split String    ${sInputGSFile}    ${sDelimiter}
    
    ### Get XLS Files###
    ${InputGSFile_XLSList}    Create List
    :FOR    ${XLSFile}    IN    @{InputGSFile_List}
    \    ${Contains_XLS}    Run Keyword And Return Status    Should Contain    ${XLSFile}    ${XLS}
    \    Run Keyword If    ${Contains_XLS}==${True}    Append To List    ${InputGSFile_XLSList}    ${XLSFile}
         ...    ELSE    Append To List    ${InputGSFile_XLSList}

    ### Get CSV Files ###
    ${InputGSFile_CSVList}    Create List
    :FOR    ${CSVFile}    IN    @{InputGSFile_List}
    \    ${Contains_CSV}    Run Keyword And Return Status    Should Contain    ${CSVFile}    ${CSV}
    \    Run Keyword If    ${Contains_CSV}==${True}    Append To List    ${InputGSFile_CSVList}    ${CSVFile}
         ...    ELSE    Append To List    ${InputGSFile_CSVList}
    
    Stop TL Service
    Open Connection and Login    ${SFTP_HOST}    ${SFTP_PORT}    ${SFTP_USER}    ${SFTP_PASSWORD}
    :FOR    ${GSFileName_XLS}    IN    @{InputGSFile_XLSList}
    \    Put File    ${dataset_path}${sInputFilePath}${GSFileName_XLS}    ${sFilePathDestinaton}
    
    :FOR    ${GSFileName_CSV}    IN    @{InputGSFile_CSVList}
    \    Put File    ${dataset_path}${sInputFilePath}${GSFileName_CSV}    ${sFilePathDestinaton}

    Start TL Service
    Open Connection and Login    ${SFTP_HOST}    ${SFTP_PORT}    ${SFTP_USER}    ${SFTP_PASSWORD}
    Run Keyword If    '${iPollingTime}'=='None'    Sleep    2m    ###The processing time for GS File for Base Rate and FX Rate is every 2 minutes
    ...    ELSE    Sleep    ${iPollingTime}
    
    ### Validate CSV Files ###
    :FOR    ${GSFileName_CSV}    IN    @{InputGSFile_CSVList}
    \    ${FileIsProcessed}    Run Keyword And Return Status    SSHLibrary.File Should Not Exist    ${sFilePathDestinaton}/${GSFileName_CSV}
    \    Run Keyword And Continue On Failure    SSHLibrary.File Should Not Exist    ${sFilePathDestinaton}/${GSFileName_CSV}
    \    Run Keyword If    ${FileIsProcessed}==${True}    Log    ${GSFileName_CSV} was picked up by the batch for processing.
         ...    ELSE    Log    Either waiting time is not enough or ${GSFileName_CSV} was not picked up by the batch for processing.    level=ERROR
    \    @{Files}    SSHLibrary.List Files In Directory    ${sFilePathDestinaton}
    \    ${FileIsRemoved}    Run Keyword And Return Status    Should Not Contain    ${Files}    ${GSFileName_CSV}
    \    Run Keyword And Continue On Failure    Should Not Contain    ${Files}    ${GSFileName_CSV}    
    \    Run Keyword If    ${FileIsRemoved}==${True}	Log    ${GSFileName_CSV} is removed from ${sFilePathDestinaton}.
         ...    ELSE    Log    ${GSFileName_CSV} is NOT removed from ${sFilePathDestinaton}.    level=ERROR
    \    Validate File If Moved to Archive Folder For Holiday    ${TL_CALENDAR_ARCHIVE_FOLDER}    ${GSFileName_CSV}    ${CSV}    

    ### Validate XLS Files ###
    @{GSFilename_ArchiveList}    Create List
    :FOR    ${GSFileName_XLS}    IN    @{InputGSFile_XLSList}
    \    ${FileIsNotProcessed}    Run Keyword And Return Status    SSHLibrary.File Should Exist    ${sFilePathDestinaton}/${GSFileName_XLS}
    \    Run Keyword And Continue On Failure    SSHLibrary.File Should Exist    ${sFilePathDestinaton}/${GSFileName_XLS}
    \    Run Keyword If    ${FileIsNotProcessed}==${True}    Log    ${GSFileName_XLS} was NOT picked up by the batch for processing.
         ...    ELSE    Log    Either waiting time is not enough or ${GSFileName_XLS} was picked up by the batch for processing.    level=ERROR
    \    @{Files}    SSHLibrary.List Files In Directory    ${sFilePathDestinaton}
    \    ${FileIsNotRemoved}    Run Keyword And Return Status    Should Contain    ${Files}    ${GSFileName_XLS}
    \    Run Keyword And Continue On Failure    Should Contain    ${Files}    ${GSFileName_XLS}    
    \    Run Keyword If    ${FileIsNotRemoved}==${True}	Log    ${GSFileName_XLS} is NOT removed from ${sFilePathDestinaton}.
         ...    ELSE    Log    ${GSFileName_XLS} is removed from ${sFilePathDestinaton}.    level=ERROR
    \    Log   ${sFolderPath}
    \    Run Keyword If    '${sFolderPath}'=='${TL_CALENDAR_ARCHIVE_FOLDER}'    Validate File If Not Moved to Archive Folder For Holiday    ${sFolderPath}    ${GSFileName_XLS}    ${XLS}
         ...    ELSE    Validate File If Moved to Error For Holiday    ${sFolderPath}    ${GSFileName_XLS}    ${XLS}
    \    Log    ${GSFILENAME_WITHTIMESTAMP}
    \    Append To List    ${GSFilename_ArchiveList}    ${GSFILENAME_WITHTIMESTAMP}
    Set Global Variable    ${ARCHIVE_GSFILENAME_LIST}    ${GSFilename_ArchiveList}
    Log    ${ARCHIVE_GSFILENAME_LIST}
    Log to Console    ${ARCHIVE_GSFILENAME_LIST}
    
Validate Future Date Polling Time For FX Rates
    [Documentation]    This keyword is used to validate future date polling time for FX rates.
    ...    @author: dahijara    19FEB2020    - initial create
    [Arguments]    ${sFilePath}    ${sFileName}

    Download Log File    ${TL_SERVICE_LOGS_DIR}    ${TL_FXRATE_LOGFILE}    ${sFilePath}    ${sFileName}
    ${FXRateLog_File}    Set Variable    ${sFilePath}${sFileName}
    ${FXRateLog_FileContents}    OperatingSystem.Get File    ${dataset_path}${FXRateLog_File}
    ${timeDifferenceList}    Create List    
    ${futureDatePollingLines}    Get Lines Containing String    ${FXRateLog_FileContents}    ${TL_FUTURE_DATE_POLLER}
    ${futureDatePollingList}    Split To Lines    ${futureDatePollingLines}
    ${futureDatePollingList_Count}    Get Length    ${futureDatePollingList}

    :FOR    ${INDEX}    IN RANGE    5
    \    Log    ${futureDatePollingList}[${INDEX}]
    \    ${futureDatePolling}    Split String    ${futureDatePollingList}[${INDEX}]    INFO
    \    ${index+1}    Evaluate    ${INDEX}+1
    \    ${nextFutureDatePolling}    Split String    ${futureDatePollingList}[${index+1}]    INFO
    \    ${difference}    Subtract Date From Date    ${nextFutureDatePolling}[0]    ${futureDatePolling}[0]    verbose
    \    ${status}    Run Keyword And Return Status    Should Contain    ${difference}    ${TL_FUTURE_DATE_POLLING_TIME}
    \    Run Keyword If    ${status}==${True}    Log    Polling time for Future Date FX Rates is ${TL_FUTURE_DATE_POLLING_TIME}
    	 ...    ELSE    Fail    Polling time for Future Date FX Rates is more or less than ${TL_FUTURE_DATE_POLLING_TIME}
    \    Append To List    ${timeDifferenceList}    ${difference}
    Log    ${timeDifferenceList}

Download Log File
    [Documentation]    This keyword is used to download log files for transforamtion layer.
    ...    @author: dahijara    19FEB2020    - initial create
    [Arguments]    ${sSourcePath}    ${sLogFileName}    ${sDestinationPath}    ${sFileName}

    Open Connection and Login    ${TL_SERVICE_HOST}    ${TL_SERVICE_PORT}    ${TL_SERVER_USER}    ${TL_SERVER_PASSWORD}
    SSHLibrary.Get File    ${sSourcePath}${sLogFileName}    ${dataset_path}${sDestinationPath}${sFileName}
    
