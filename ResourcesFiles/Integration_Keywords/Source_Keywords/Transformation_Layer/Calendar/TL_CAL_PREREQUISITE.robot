*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Verify if Copp Clark Files Have No Missing File
    [Documentation]    This keyword is used to check if there are no missing file from Copp Clark files.
    ...    @author: clanding    18JUN2019    - initial create
    ...    @update: jloretiz    26NOV2019    - change the processing of keyword from XLS to XLSX
    [Arguments]    ${sFileName}
    
    ${FileList}    Split String    ${sFileName}    ,
    ${FileCount}    Get Length    ${FileList}
    ${XLSX_FileCount}    Set Variable    0
    ${CSV_FileCount}    Set Variable    0
    :FOR    ${File}    IN    @{FileList}
    \    ${Contains_XLSX}    Run Keyword And Return Status    Should Contain    ${File}    .xlsx
    \    ${Contains_CSV}    Run Keyword And Return Status    Should Contain    ${File}    .csv
    \    
    \    ${XLSX_FileCount}    Run Keyword If    ${Contains_XLSX}==${True}    Evaluate    ${XLSX_FileCount}+1
         ...    ELSE     Set Variable    ${XLSX_FileCount}
    \    ${CSV_FileCount}    Run Keyword If    ${Contains_CSV}==${True}    Evaluate    ${CSV_FileCount}+1
         ...    ELSE    Set Variable    ${CSV_FileCount}
    Log    ${XLSX_FileCount}
    Log    ${CSV_FileCount}
    
    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${XLSX_FileCount}    3
    ${XLSX_Count_Correct}    Run Keyword And Return Status    Should Be Equal As Strings    ${XLSX_FileCount}    3
    Run Keyword If    ${XLSX_Count_Correct}==${True}    Log    XLSX File count is 3.
    ...    ELSE    Log    XLSX File count is not ${XLSX_FileCount}. Expected value is 3.    level=ERROR
    
    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${CSV_FileCount}    2
    ${CSV_Count_Correct}    Run Keyword And Return Status    Should Be Equal As Strings    ${CSV_FileCount}    2
    Run Keyword If    ${CSV_Count_Correct}==${True}    Log    CSV File count is 2.
    ...    ELSE    Log    CSV File count is not ${CSV_FileCount}. Expected value is 2.    level=ERROR
    
    ### Execution will stop when there are missing files ###
    Run Keyword If    ${XLSX_Count_Correct}==${False}    Fail    There are missing files from the Copp Clark Files. Execution will stop!
    ...    ELSE IF    ${CSV_Count_Correct}==${False}    Fail    There are missing files from the Copp Clark Files. Execution will stop!
    ...    ELSE    Log    There are no missing files from the Copp Clark Files. Execution will continue.
    
Get Calendar ID from File 1 of Copp Clark Files and Return
    [Documentation]    This keyword is used to get Calendar ID from File 1 of Copp Clark Files using the input sFilePath/sFileName
    ...    and return calendar id.
    ...    @author: clanding    17JUN2019    - initial create
    [Arguments]    ${sFilePath}    ${sFileName}    ${sSheetName}
    
    ${FileList}    Split String    ${sFileName}    ,
    ${FileCount}    Get Length    ${FileList}
    :FOR    ${File}    IN    @{FileList}
    \    ${XLSX_File}    Run Keyword And Return Status    Should Contain    ${File}    _1.xlsx
    \    ${Holidays_Banks}    Run Keyword And Return Status    Should Contain    ${File}    Holidays_Banks_
    \    Exit For Loop If    ${XLSX_File}==${True} and ${Holidays_Banks}==${True}
    
    Run Keyword If    ${XLSX_File}==${True} and ${Holidays_Banks}==${True}    Log    XLSX File 1 exist with filename '${File}'.
    ...    ELSE    Fail    XLSX File 1 does not exist. List of files are ${FileList}.
    Open Excel    ${datasetpath}${sFilePath}${File}
    ${RowCount}    Get Row Count    ${sSheetName}
    Close Current Excel Document
    ${CalendarID_List}    Create List    
    :FOR    ${Rownum}    IN RANGE    1    ${RowCount}
    \    ${ISOCountryCode_Val}    Read Cell Data Using Reference Column Name and Row Number and Return    ${sSheetName}    ${COL_ISOCOUNTRYCODE}    ${Rownum}    ${datasetpath}${sFilePath}${File}
    \    ${CentreCode_Val}    Read Cell Data Using Reference Column Name and Row Number and Return    ${sSheetName}    ${COL_CENTRECODE}    ${Rownum}    ${datasetpath}${sFilePath}${File}
    \    ${CalendarID}    Catenate    SEPARATOR=    ${ISOCountryCode_Val}    ${CentreCode_Val}
    \    Append To List    ${CalendarID_List}    ${CalendarID}
    Log    ${CalendarID_List}
    ${CalendarID_List}    Remove Duplicates    ${CalendarID_List}
    Set Global Variable    ${CALENDARID_FILE1_LIST_NO_DUPLICATE}    ${CalendarID_List}
    [Return]    ${CalendarID_List}

Get Calendar ID from File 2 of Copp Clark Files and Return
    [Documentation]    This keyword is used to get Calendar ID from File 1 and File 2 of Copp Clark Files using the input sFilePath/sFileName
    ...    and return calendar id.
    ...    @author: clanding    17JUN2019    - initial create
    ...    @update: jloretiz    26NOV2019    - change the processing of keyword from XLS to XLSX
    [Arguments]    ${sFilePath}    ${sFileName}    ${sSheetName}
    
    ${FileList}    Split String    ${sFileName}    ,
    ${FileCount}    Get Length    ${FileList}
    :FOR    ${File}    IN    @{FileList}
    \    ${XLSX_File}    Run Keyword And Return Status    Should Contain    ${File}    _2.xlsx
    \    ${Holidays_Banks}    Run Keyword And Return Status    Should Contain    ${File}    Holidays_Banks_
    \    Exit For Loop If    ${XLSX_File}==${True} and ${Holidays_Banks}==${True}
    
    Run Keyword If    ${XLSX_File}==${True} and ${Holidays_Banks}==${True}    Log    XLSX File 1 exist with filename '${File}'.
    ...    ELSE    Fail    XLSX File 1 does not exist. List of files are ${FileList}.
    Open Excel    ${datasetpath}${sFilePath}${File}
    ${RowCount}    Get Row Count    ${sSheetName}
    ${CalendarID_List}    Create List    
    Close Current Excel Document
    :FOR    ${Rownum}    IN RANGE    1    ${RowCount}
    \    ${ISOCountryCode_Val}    Read Cell Data Using Reference Column Name and Row Number and Return    ${sSheetName}    ${COL_ISOCOUNTRYCODE}    ${Rownum}    ${datasetpath}${sFilePath}${File}
    \    ${CentreCode_Val}    Read Cell Data Using Reference Column Name and Row Number and Return    ${sSheetName}    ${COL_CENTRECODE}    ${Rownum}    ${datasetpath}${sFilePath}${File}
    \    ${CalendarID}    Catenate    SEPARATOR=    ${ISOCountryCode_Val}    ${CentreCode_Val}
    \    Append To List    ${CalendarID_List}    ${CalendarID}
    Log    ${CalendarID_List}
    ${CalendarID_List}    Remove Duplicates    ${CalendarID_List}
    Set Global Variable    ${CALENDARID_FILE2_LIST_NO_DUPLICATE}    ${CalendarID_List}
    [Return]    ${CalendarID_List}

Get Calendar ID from Misc File of Copp Clark Files and Return
    [Documentation]    This keyword is used to get Calendar ID from Misc file of Copp Clark Files using the input sFilePath/sFileName
    ...    and return calendar id.
    ...    @author: clanding    18JUN2019    - initial create
    ...    @update: jloretiz    26NOV2019    - change the processing of keyword from XLS to XLSX
    [Arguments]    ${sFilePath}    ${sFileName}    ${sSheetName}
    
    ${FileList}    Split String    ${sFileName}    ,
    ${FileCount}    Get Length    ${FileList}
    :FOR    ${File}    IN    @{FileList}
    \    ${XLSX_File}    Run Keyword And Return Status    Should Contain    ${File}    xlsx
    \    ${Misc_File}    Run Keyword And Return Status    Should Contain    ${File}    Holidays_Misc_
    \    Exit For Loop If    ${XLSX_File}==${True} and ${Misc_File}==${True}
    
    Run Keyword If    ${XLSX_File}==${True} and ${Misc_File}==${True}    Log    XLSX File 1 exist with filename '${File}'.
    ...    ELSE    Fail    XLSX File 1 does not exist. List of files are ${FileList}.
    Open Excel    ${datasetpath}${sFilePath}${File}
    ${RowCount}    Get Row Count    ${sSheetName}
    Close Current Excel Document
    ${CalendarID_List}    Create List    
    :FOR    ${Rownum}    IN RANGE    1    ${RowCount}
    \    ${ISOCountryCode_Val}    Read Cell Data Using Reference Column Name and Row Number and Return    ${sSheetName}    ${COL_ISOCOUNTRYCODE}    ${Rownum}    ${datasetpath}${sFilePath}${File}
    \    ${ISOMICCode_Val}    Read Cell Data Using Reference Column Name and Row Number and Return    ${sSheetName}    ${COL_ISOMICCODE}    ${Rownum}    ${datasetpath}${sFilePath}${File}
    \    ${ISOMICCode_Fin}    Get Substring    ${ISOMICCode_Val}    0    3
    \    ${CalendarID}    Catenate    SEPARATOR=    ${ISOCountryCode_Val}    ${ISOMICCode_Fin}
    \    Append To List    ${CalendarID_List}    ${CalendarID}
    Log    ${CalendarID_List}
    ${CalendarID_List}    Remove Duplicates    ${CalendarID_List}
    Set Global Variable    ${CALENDARID_MISC_LIST_NO_DUPLICATE}    ${CalendarID_List}
    [Return]    ${CalendarID_List}

Get File Name From Copp Clark Files and Return File Name
    [Documentation]    This keyword is used to get file name from Copp Clark Files using File_1, File_2 or Misc as sFileType.
    ...    @author: clanding    04JUL2019    - initial create
    ...    @update:.jloretiz....26NOV2019    - change the processing of keyword from XLS to XLSX
    [Arguments]    ${sInputFilePath}    ${sCoppClarkFiles}    ${sFileType}
    
    ###Get XLSX File 1 from Copp Clark Files###
    ${FileList}    Split String    ${sCoppClarkFiles}    ,
    ${FileCount}    Get Length    ${FileList}
    :FOR    ${File}    IN    @{FileList}
    \    
    \    ${File_Type}    Run Keyword If    '${sFileType}'=='File_1'    Set Variable    _1.xlsx
         ...    ELSE IF    '${sFileType}'=='File_2'    Set Variable    _2.xlsx
         ...    ELSE IF    '${sFileType}'=='Misc'    Set Variable    Misc
    \    
    \    ${File_Name}    Run Keyword If    '${sFileType}'=='File_1'    Set Variable    Holidays_Banks_
         ...    ELSE IF    '${sFileType}'=='File_2'    Set Variable    Holidays_Banks_
         ...    ELSE IF    '${sFileType}'=='Misc'    Set Variable    Holidays_Misc
    \    
    \    ${XLSX_File}    Run Keyword And Return Status    Should Contain    ${File}    ${File_Type}
    \    ${Holidays_Banks}    Run Keyword And Return Status    Should Contain    ${File}    ${File_Name}
    \    Exit For Loop If    ${XLSX_File}==${True} and ${Holidays_Banks}==${True}
    ${XLSXFile}    Set Variable    ${datasetpath}${sInputFilePath}${File}
    [Return]    ${XLSXFile}

Create Expected JSON for TL Calendar XLS File 1 and File 2
    [Documentation]    This keyword is used to create the expected json file for File 1 and File 2 of Copp Clark files.
    ...    @author: clanding    19JUN2019    - initial create
    ...    @update: clanding    15JUL2019    - added creation of json per unique calendar id
    ...    @update: jloretiz    15AUG2019    - added a condition to skip a for loop iteration if date is same
    ...    @update: jloretiz    26NOV2019    - add the keyword to close the current excel document
    [Arguments]    ${sInputFilePath}    ${sXLSFile}    ${sSheetName}    ${sInputJSON}    ${sFileType}
    
    Open Excel    ${sXLSFile}
    
    ### Set Variables ###
    ${RowCount}    Get Row Count    ${sSheetName}
    ${Prev_CalendarID}    Set Variable
    ${Prev_EventYear}    Set Variable
    ${CalendarID_List}    Create List
    ${CalendarID_Row_List}    Create List
    ${CalendarID_Unique_Dict}    Create Dictionary
    ${DateDetails_List}    Create List
    ${SubFieldList}    Create List
    ${SubFieldValueList}    Create List
    ${Year_List}    Create List
    ${Year_Dict}    Create Dictionary
    ${Year_CalID_NBD_Dict}    Create Dictionary
    ${nonBusinessDates_List}    Create List
    ${NoChange_Hol_List}    Create List
    ${NoChange_Hol_Dict}    Create Dictionary
    ${Existing_Dates}    Create List    
    Close Current Excel Document

    ### Get Calendar ID List ###
    :FOR    ${Rownum}    IN RANGE    1    ${RowCount}
    \    
    \    ### Get Copp Clark File values ###
    \    ${ISOCountryCode_Val}    Read Cell Data Using Reference Column Name and Row Number and Return    ${sSheetName}    ${COL_ISOCOUNTRYCODE}    ${Rownum}    ${sXLSFile}
    \    ${CentreCode_Val}    Read Cell Data Using Reference Column Name and Row Number and Return    ${sSheetName}    ${COL_CENTRECODE}    ${Rownum}    ${sXLSFile}
    \    ${EventYear_Val}    Read Cell Data Using Reference Column Name and Row Number and Return    ${sSheetName}    ${COL_EVENTYEAR}    ${Rownum}    ${sXLSFile}
    \    
    \    ### Convert Values ###
    \    ${CalendarID}    Catenate    SEPARATOR=    ${ISOCountryCode_Val}    ${CentreCode_Val}
    \    ${CalendarID_Status}    Get Calendar ID Status from Database    ${CalendarID}
    \    ${CalendarID_Status_Is_Not_Existing}    Run Keyword And Return Status    Should Be Equal As Strings    ${CalendarID_Status}    ${NONE}
    \    ${EventYear_Val}    Convert To String    ${EventYear_Val}
    \    ${EventYear}    Get Substring    ${EventYear_Val}    0    4
    \    
    \    Run Keyword If    ${CalendarID_Status_Is_Not_Existing}==${False} and '${CalendarID_Status}'!='N'    Run Keywords    Append To List    ${CalendarID_Row_List}    ${CalendarID}_${Rownum}
         ...    AND    Append To List    ${CalendarID_List}    ${CalendarID}
         ...    AND    Append To List    ${Year_List}    ${EventYear} 
         ...    ELSE IF    '${CalendarID_Status}'=='N'    Run Keywords    Append To List    ${CalendarID_List}
         ...    AND    Append To List    ${CalendarID_Row_List}
         ...    AND    Append To List    ${Year_List}   
         ...    AND    Log    Calendar ID '${CalendarID}' is exsting in LIQ database but status is INACTIVE.    level=WARN
         ...    ELSE    Run Keywords    Append To List    ${CalendarID_List}
         ...    AND    Append To List    ${CalendarID_Row_List}
         ...    AND    Append To List    ${Year_List}
         ...    AND    Log    Calendar ID '${CalendarID}' is NOT EXISTING in LIQ database.    level=WARN
    \    
    \    Log    ${CalendarID_List}
    \    Log    ${CalendarID_Row_List}
    \    Log    ${Year_List}
    
    ### Create Non-Business Date in the payload ###
    :FOR    ${CalendarID_Row}    IN    @{CalendarID_Row_List}
    \    ${CalendarID_Split_List}    Split String    ${CalendarID_Row}    _
    \    ${RowCount}    Get From List    ${CalendarID_Split_List}    1
    \    
    \    ### Get Copp Clark File values ###
    \    ${ISOCountryCode_Val}    Read Cell Data Using Reference Column Name and Row Number and Return    ${sSheetName}    ${COL_ISOCOUNTRYCODE}    ${RowCount}    ${sXLSFile}
    \    ${CentreCode_Val}    Read Cell Data Using Reference Column Name and Row Number and Return    ${sSheetName}    ${COL_CENTRECODE}    ${RowCount}    ${sXLSFile}
    \    ${EventYear_Val}    Read Cell Data Using Reference Column Name and Row Number and Return    ${sSheetName}    ${COL_EVENTYEAR}    ${RowCount}    ${sXLSFile}
    \    ${EventDate_Val}    Read Cell Data Using Reference Column Name and Row Number and Return    ${sSheetName}    ${COL_EVENTDATE}    ${RowCount}    ${sXLSFile}
    \    ${EventName_Val}    Read Cell Data Using Reference Column Name and Row Number and Return    ${sSheetName}    ${COL_EVENTNAME}    ${RowCount}    ${sXLSFile}
    \    
    \    ### Convert Values ###
    \    ${CalendarID}    Catenate    SEPARATOR=    ${ISOCountryCode_Val}    ${CentreCode_Val}
    \    ${EventYear_Val}    Convert To String    ${EventYear_Val}
    \    ${EventYear}    Get Substring    ${EventYear_Val}    0    4
    \    ${EventDate_Val}    Convert To String    ${EventDate_Val}
    \    ${EventYear_Val}    Convert To String    ${EventYear}
    \    ${EventYear}    Get Substring    ${EventYear_Val}    0    4
    \    ${EventDate_Year}    Get Substring    ${EventDate_Val}    0    4
    \    ${EventDate_Month}    Get Substring    ${EventDate_Val}    4    6
    \    ${EventDate_Day}    Get Substring    ${EventDate_Val}    6    8
    \    ${EventDate_PayloadFormat}    Catenate    SEPARATOR=-    ${EventDate_Year}    ${EventDate_Month}    ${EventDate_Day}   
    \    ${EventDate_LIQFormat}    Convert Date With Zero    ${EventDate_PayloadFormat}
    \    
    \    ${Same_CalendarID}    Run Keyword If    '${Prev_EventYear}'==''    Set Variable    True
         ...    ELSE IF    '${CalendarID}'!='${Prev_CalendarID}'    Set Variable    False
         ...    ELSE    Set Variable    True
    \    ${Same_EventYear}    Run Keyword If    '${Prev_EventYear}'==''    Set Variable    True
         ...    ELSE IF    '${EventYear}'!='${Prev_EventYear}'    Set Variable    False
         ...    ELSE    Set Variable    True
    \    ${Same_Date}    Run Keyword And Return Status    List Should Contain Value    ${Existing_Dates}    ${EventDate_PayloadFormat}    
    \    Run Keyword If    ${Same_Date}==${False}    Append To List    ${Existing_Dates}    ${EventDate_PayloadFormat}
    \    
    \    # Skip current iteration if event date already exists
    \    Continue For Loop If    ${Same_Date}==${True}
    \    
    \    ### Get LIQ Business Date and verify if Event Data is greater than LIQ Date ###
    \    ${LIQ_Business_Date_DBFormat}    Get LIQ Business Date from Database    ${ZONE3}
    \    ${LIQ_Business_Date}    Convert Date    ${LIQ_Business_Date_DBFormat}    result_format=%Y-%M-%d    date_format=%M-%d-%Y
    \    ${LIQ_EventDate_Diff}    Subtract Date From Date    ${EventDate_PayloadFormat}    ${LIQ_Business_Date}
    \    
    \    ${Hol_Date_Status_DB}    Get Status from Holiday Calendar Dates table in Database    ${CalendarID}    ${EventDate_LIQFormat}
    \    ${Query_Results_None}    Run Keyword And Return Status    Should Be Equal As Strings    ${Hol_Date_Status_DB}    None
    \    ${Hol_Date_Status}    Run Keyword If    ${Query_Results_None}==${False}    Get From List    ${Hol_Date_Status_DB}    0
         ...    ELSE    Set Variable    None
    \    ${Status_IsActive}    Run Keyword And Return Status    Should Be Equal As Strings    ${Hol_Date_Status}    Y
    \    ${Status_IsInactive}    Run Keyword And Return Status    Should Be Equal As Strings    ${Hol_Date_Status}    N
    \    ${Hol_Date_EventName_DB}    Get Event Name from Holiday Calendar Dates table in Database    ${CalendarID}    ${EventDate_LIQFormat}
    \    ${DB_None}    Run Keyword And Return Status    Should Be Equal As Strings    ${Hol_Date_EventName_DB}    None
    \    ${Hol_Date_EventName}    Run Keyword If    ${DB_None}==${False}    Get From List    ${Hol_Date_EventName_DB}    0
         ...    ELSE    Set Variable
    \    ${Same_EventName}    Run Keyword And Return Status    Should Be Equal As Strings    ${EventName_Val}    ${Hol_Date_EventName.strip()}
    \    
    \    ${nonBusinessDates_Dict}    Create Non Business Dates Dictionary in TL Calendar Payload and Return    ${EventDate_PayloadFormat}    ${EventName_Val}
    \    
    \    Log    ${Prev_EventYear}
    \    ${nonBusinessDates_List}    Run Keyword If    ${Same_EventYear}==${False}    Create List
         ...    ELSE IF    '${Prev_EventYear}'==''    Create List
         ...    ELSE    Set Variable    ${nonBusinessDates_List}
    \    Log    ${nonBusinessDates_List}
    \    
    \    Run Keyword If    ${LIQ_EventDate_Diff}<0.0    Run Keywords    Append To List    ${nonBusinessDates_List}
         ...    AND    Log    Event Date '${EventDate_PayloadFormat}' is less than LIQ Date '${LIQ_Business_Date}'.
         ...    ELSE IF    ${LIQ_EventDate_Diff}==0.0 and ${Same_EventName}==${False}    Run Keywords    Append To List    ${nonBusinessDates_List}    ${nonBusinessDates_Dict}
         ...    AND    Log    Event Date '${EventDate_PayloadFormat}' is equal to LIQ Date '${LIQ_Business_Date}'.
         ...    ELSE IF    ${LIQ_EventDate_Diff}==0.0 and ${Status_IsInactive}==${True}    Run Keywords    Append To List    ${nonBusinessDates_List}    ${nonBusinessDates_Dict}
         ...    AND    Log    Event Date '${EventDate_PayloadFormat}' is equal to LIQ Date '${LIQ_Business_Date}' and previous status is 'Inactive'.
         ...    ELSE IF    ${LIQ_EventDate_Diff}>0.0 and ${Same_EventName}==${False}    Run Keywords    Append To List    ${nonBusinessDates_List}    ${nonBusinessDates_Dict}
         ...    AND    Log    Event Date '${EventDate_PayloadFormat}' is greater than LIQ Date '${LIQ_Business_Date}'.
         ...    ELSE IF    ${LIQ_EventDate_Diff}>0.0 and ${Status_IsInactive}==${True}    Run Keywords    Append To List    ${nonBusinessDates_List}    ${nonBusinessDates_Dict}
         ...    AND    Log    Event Date '${EventDate_PayloadFormat}' is greater than LIQ Date '${LIQ_Business_Date}' and previous status is 'Inactive'.
    \    Log    ${nonBusinessDates_List}
    \    ${List_Empty}    Run Keyword And Return Status    Should Be Empty    ${nonBusinessDates_List}
    \    
    \    Run Keyword If    ${LIQ_EventDate_Diff}==0.0 and ${Same_EventYear}==${True} and ${List_Empty}==${False}    Set To Dictionary    ${Year_CalID_NBD_Dict}    ${EventYear}_${CalendarID}=${nonBusinessDates_List}
         ...    ELSE IF    ${LIQ_EventDate_Diff}>0.0 and ${Same_EventYear}==${True} and ${List_Empty}==${False}    Set To Dictionary    ${Year_CalID_NBD_Dict}    ${EventYear}_${CalendarID}=${nonBusinessDates_List}
         ...    ELSE IF    ${LIQ_EventDate_Diff}==0.0 and ${Same_EventYear}==${False} and ${List_Empty}==${False}    Set To Dictionary    ${Year_CalID_NBD_Dict}    ${EventYear}_${CalendarID}=${nonBusinessDates_List}
         ...    ELSE IF    ${LIQ_EventDate_Diff}>0.0 and ${Same_EventYear}==${False} and ${List_Empty}==${False}    Set To Dictionary    ${Year_CalID_NBD_Dict}    ${EventYear}_${CalendarID}=${nonBusinessDates_List}
    \    
    \    ### Handle No Change Holiday Dates ###
    \    Run Keyword If    ${Same_EventName}==${True}    Append To List    ${NoChange_Hol_List}    ${nonBusinessDates_Dict}
         ...    ELSE    Append To List    ${NoChange_Hol_List}
    \    
    \    ${Prev_CalendarID}    Run Keyword If    '${CalendarID}'!='${Prev_CalendarID}'    Set Variable    ${CalendarID}
         ...    ELSE    Set Variable    ${Prev_CalendarID}
    \    ${Prev_EventYear}    Run Keyword If    '${EventYear}'!='${Prev_EventYear}'    Set Variable    ${EventYear}
         ...    ELSE    Set Variable    ${Prev_EventYear}
    \    Log    ${Year_CalID_NBD_Dict}
    \    Log    ${NoChange_Hol_List}
    Log    ${Year_CalID_NBD_Dict}
    Log    ${NoChange_Hol_List}

    ${JSON_File}    Set Variable    ${datasetpath}${sInputFilePath}${sInputJSON}_${sFileType}.${JSON}
    Delete File If Exist    ${JSON_File}
    Create File    ${JSON_File}
    
    ###Get configured LOB from MCH DB###
    ${LOB}    Connect to MCH Oracle Database and Execute Query    ${Query_Get_LOB}
    ${SQL_LOB_Result_List}    Convert SQL Result to List and Return    ${LOB}
    
    ### Create Payload ###
    ${CalendarID_List_Unique}    Remove Duplicates    ${CalendarID_List}
    :FOR    ${CalendarID_Unique}    IN    @{CalendarID_List_Unique}
    \    ${Year_CalID_SBD_Dict}    Create Special Business Dates Dictionary in TL Calendar Payload and Return    ${CalendarID_Unique}    ${Year_CalID_NBD_Dict}    ${NoChange_Hol_List}
    \    Log    ${Year_CalID_SBD_Dict}
    \    
    \    ${SBD_IsEmpty}    Run Keyword And Return Status    Should Be Empty    ${Year_CalID_SBD_Dict}
    \    ${Year_CalID_SBD_Dict}    Run Keyword If    ${SBD_IsEmpty}==${True}    Set Variable
         ...    ELSE    Set Variable    ${Year_CalID_SBD_Dict}
    \    ${NBD_IsEmpty}    Run Keyword And Return Status    Should Be Empty    ${Year_CalID_NBD_Dict}
    \    
    \    ${DateDetails_List}    Run Keyword If    ${SBD_IsEmpty}==${False} and ${NBD_IsEmpty}==${False}    Create Date Details List in TL Calendar Payload and Return    ${CalendarID_Unique}    ${Year_CalID_NBD_Dict}    ${Year_CalID_SBD_Dict}
         ...    ELSE IF    ${SBD_IsEmpty}==${True} and ${NBD_IsEmpty}==${False}    Create Date Details List with no SBD    ${CalendarID_Unique}    ${Year_CalID_NBD_Dict}
         ...    ELSE IF    ${SBD_IsEmpty}==${False} and ${NBD_IsEmpty}==${True}    Create Date Details List with no NBD    ${CalendarID_Unique}    ${Year_CalID_SBD_Dict}
    \    
    \    ${File}    OperatingSystem.Get File    ${JSON_File}
    \    ${File_Empty}    Run Keyword And Return Status    Should Be Empty    ${File}
    \    ${weeklyHolidays_List}    Create List
    \    ${LOB_List}    Set LOB Section for TL Calendar Payload and Return    ${SQL_LOB_Result_List}
    \    
    \    ### Get Value from LIQ Database ###
    \    ${CalendarDesc}    Get Calendar ID Description from Database    ${CalendarID_Unique}
    \    
    \    ${JSON_Object}    Load JSON From File    ${TEMPLATE_JSON_CAL}
    \    ${New_JSON}    Set To Dictionary    ${JSON_Object}    calendarId=${CalendarID_Unique}
    \    ${New_JSON}    Set To Dictionary    ${New_JSON}    calendarType=${FINCENTRE}
    \    ${New_JSON}    Set To Dictionary    ${New_JSON}    description=${CalendarDesc}
    \    ${New_JSON}    Set To Dictionary    ${New_JSON}    lobs=${LOB_List}
    \    ${New_JSON}    Set To Dictionary    ${New_JSON}    weeklyHolidays=${weeklyHolidays_List}
    \    ${New_JSON}    Set To Dictionary    ${New_JSON}    dateDetails=${DateDetails_List}
    \    ${Converted_JSON}    Evaluate    json.dumps(${New_JSON})        json
    \    Log    ${Converted_JSON}
    \    
    \    ${dateDetails_Null}    Run Keyword And Return Status    Should Be Equal As Strings    ${DateDetails_List}    None
    \    
    \    Run Keyword If    ${dateDetails_Null}==${True}    Append To File    ${JSON_File}    ${EMPTY}
         ...    ELSE IF    ${File_Empty}==${True}    Append To File    ${JSON_File}    ${Converted_JSON}
         ...    ELSE    Append To File    ${JSON_File}    ,${Converted_JSON}
    \    Log    ${JSON_File}
    \    ${File}    OperatingSystem.Get File    ${JSON_File}
    \    
    \    ### Create Individual JSON per calendar id###
    \    Delete File If Exist    ${datasetpath}${sInputFilePath}${sInputJSON}_ID_${CalendarID_Unique}.${JSON}
    \    Run Keyword If    ${dateDetails_Null}!=${True}    Create File    ${datasetpath}${sInputFilePath}${sInputJSON}_ID_${CalendarID_Unique}.${JSON}    ${Converted_JSON}
    ${File}    OperatingSystem.Get File    ${JSON_File}
    Log    ${File}
    ${Converted_File}    Catenate    SEPARATOR=    [    ${File}    ]
    Delete File If Exist    ${JSON_File}
    Create File    ${JSON_File}    ${Converted_File}
    
Set LOB Section for TL Calendar Payload and Return
    [Documentation]    This keyword is used to create the LOB section of TL TL Calendar payload.
    ...    This will return LOB List that can be inserted in JSON file.
    ...    @author: clanding    19JUN2019    - initial create
    [Arguments]    ${aLOB}
    
    ${lineOfBusinessList}    Create List
    :FOR    ${LOB}    IN    @{aLOB}
    \    ${lineOfBusinessDictionary}    Create Dictionary    lineOfBusiness=${LOB}    businessEntityName=${NONE}
    \    Append To List    ${lineOfBusinessList}    ${lineOfBusinessDictionary}    
    [Return]    ${lineOfBusinessList}

Create Non Business Dates Dictionary in TL Calendar Payload and Return
    [Documentation]    This keyword is used to create the nonBusinessDates section of the Calendar payload and return dictionary.
    ...    i.e. {"dateValue": "2018-12-20","reason": "Christmas Day"}
    ...    @author: clanding    21JUN2019    - initial create
    [Arguments]    ${sDateValue}    ${sReason}
    
    ${nonBusinessDates_Dict}    Create Dictionary
    Set To Dictionary    ${nonBusinessDates_Dict}    dateValue=${sDateValue}
    Set To Dictionary    ${nonBusinessDates_Dict}    reason=${sReason}
    [Return]    ${nonBusinessDates_Dict}

Create Special Business Dates Dictionary in TL Calendar Payload and Return
    [Documentation]    This keyword is used to create the specialBusinessDates section of the Calendar payload and return dictionary.
    ...    i.e. {"dateValue": "2018-12-20","reason": "Christmas Day"}
    ...    @author: clanding    21JUN2019    - initial create
    ...    @update: clanding    26JUL2019    - updated flow for creation of special business date
    [Arguments]    ${sCalendarID}    ${dNonBusinessDates_Dict}    ${aNoChange_List}
    
    ${specialBusinessDates_Dict}    Create Dictionary
    ${specialBusinessDates_List}    Create List
    ${Year_Dict}    Create Dictionary    
    ${Year_List}    Create List
    ${Prev_EventYear}    Set Variable    
    ${SBD_List}    Create List    
    ${Prev_SBD}    Set Variable    
    ${DBResults_List}    Get Event Date and Name from Holiday Calendar Dates table in Database    ${sCalendarID}
    ${DBRecord_TotalCount}    Get Length    ${DBResults_List}
    ${DBRecord_TotalCount_Less1}    Evaluate    ${DBRecord_TotalCount}-1
    :FOR    ${DBRecordCount}    IN RANGE    ${DBRecord_TotalCount}
    \    
    \    ${DBRecordList}    Get From List    ${DBResults_List}    ${DBRecordCount}
    \    ${EventDate_DB}    Get From List    ${DBRecordList}    0
    \    ${EventName_DB}    Get From List    ${DBRecordList}    1
    \    ${Hol_Date_Status_DB}    Get From List    ${DBRecordList}    2
    \    
    \    ${Status_IsActive}    Run Keyword And Return Status    Should Be Equal As Strings    ${Hol_Date_Status_DB}    Y
    \    
    \    ###Convert Date to Payload Format ###
    \    ${EventDate_LIQFormat}    Convert Date With Zero    ${EventDate_DB}
    \    ${EventDate_PayloadFormat}    Convert Date    ${EventDate_DB}    result_format=%Y-%m-%d    date_format=%Y-%m-%d %H:%M
    \    ${EventYear}    Get Substring    ${EventDate_PayloadFormat}    0    4
    \    
    \    ### Get LIQ Business Date and verify if Event Data is greater than LIQ Date ###
    \    ${LIQ_Business_Date_DBFormat}    Get LIQ Business Date from Database    ${ZONE3}
    \    ${LIQ_Business_Date}    Convert Date    ${LIQ_Business_Date_DBFormat}    result_format=%Y-%M-%d    date_format=%M-%d-%Y
    \    ${LIQ_EventDate_Diff}    Subtract Date From Date    ${EventDate_PayloadFormat}    ${LIQ_Business_Date}
    \    ${LIQ_Business_Date_Year}    Get Substring    ${LIQ_Business_Date}    0    4
    \    
    \    ${Year_CalID_Exist}    Run Keyword And Return Status    Get From Dictionary    ${dNonBusinessDates_Dict}    ${EventYear}_${sCalendarID}
    \    ${NonBusinessDates_List}    Run Keyword If    ${Year_CalID_Exist}==${True}    Get From Dictionary    ${dNonBusinessDates_Dict}    ${EventYear}_${sCalendarID}
         ...    ELSE    Create List
    \    ${NBD_List_Empty}    Run Keyword And Return Status    Should Be Empty    ${NonBusinessDates_List}
    \    
    \    Run Keyword If    ${LIQ_EventDate_Diff}<0.0    Log    Event Date '${EventDate_PayloadFormat}' is less than LIQ Date '${LIQ_Business_Date}'.
         ...    ELSE IF    ${LIQ_EventDate_Diff}==0.0    Log    Event Date '${EventDate_PayloadFormat}' is equal to LIQ Date '${LIQ_Business_Date}'.
         ...    ELSE IF    ${LIQ_EventDate_Diff}>0.0    Log    Event Date '${EventDate_PayloadFormat}' is greater than LIQ Date '${LIQ_Business_Date}'.
    \    
    \    Log    ${Prev_SBD}
    \    ${specialBusinessDates_Dict}    Run Keyword If    ${LIQ_EventDate_Diff}<0.0    Set Variable    ${specialBusinessDates_Dict}
         ...    ELSE IF    ${NBD_List_Empty}==${True} and ${LIQ_EventDate_Diff}==0.0 and ${Status_IsActive}==${True}    Create Dictionary    dateValue=${EventDate_PayloadFormat}    reason=${EventName_DB.strip()}
         ...    ELSE IF    ${NBD_List_Empty}==${True} and ${LIQ_EventDate_Diff}>0.0 and ${Status_IsActive}==${True}    Create Dictionary    dateValue=${EventDate_PayloadFormat}    reason=${EventName_DB.strip()}
         ...    ELSE IF    ${NBD_List_Empty}==${False} and ${LIQ_EventDate_Diff}==0.0 and ${Status_IsActive}==${True}    Create Special Business Dates Dictionary    ${sCalendarID}    ${EventYear}    ${EventDate_PayloadFormat}    ${EventName_DB}    ${NonBusinessDates_List}
         ...    ELSE IF    ${NBD_List_Empty}==${False} and ${LIQ_EventDate_Diff}>0.0 and ${Status_IsActive}==${True}    Create Special Business Dates Dictionary    ${sCalendarID}    ${EventYear}    ${EventDate_PayloadFormat}    ${EventName_DB}    ${NonBusinessDates_List}
         ...    ELSE    Set Variable    ${specialBusinessDates_Dict}
    \    Log    ${specialBusinessDates_Dict}
    \    Log    ${Prev_SBD}
    \    Log    ${specialBusinessDates_List}
    \    
    \    ${specialBusinessDates_NotEmpty}    Run Keyword And Return Status    Should Not Be Empty    ${specialBusinessDates_Dict}
    \    ${specialBusinessDates_Dict}    Run Keyword If    ${specialBusinessDates_NotEmpty}==${True}    Check If Existing in No Change List    ${aNoChange_List}    ${specialBusinessDates_Dict}
         ...    ELSE    Set Variable    ${specialBusinessDates_Dict}
    \    
    \    ${Dict_Empty}    Run Keyword And Return Status    Should Be Empty    ${specialBusinessDates_Dict}
    \    ${Same_Dict}    Run Keyword And Return Status    Should Be Equal    ${Prev_SBD}    ${specialBusinessDates_Dict}    
    \    
    \    Run Keyword If    ${Dict_Empty}==${False} and ${Same_Dict}==${False}    Append To List    ${specialBusinessDates_List}    ${specialBusinessDates_Dict}
         ...    ELSE    Append To List    ${specialBusinessDates_List}
    \    Run Keyword If    ${Dict_Empty}==${False}    Append To List    ${specialBusinessDates_List}    ${specialBusinessDates_Dict}
    \    ${Prev_SBD}    Set Variable    ${specialBusinessDates_Dict}
    \    Log    ${specialBusinessDates_List}
    \    Log    ${specialBusinessDates_Dict}
    \    Exit For Loop If    ${DBRecordCount}==${DBRecord_TotalCount}
    Log    ${specialBusinessDates_List}
    Log    ${specialBusinessDates_Dict}
    Log    ${SBD_List}
    ${SBD_Dict}    Create Dictionary
    ${SBD_List}    Create List
    ${Prev_List}    Set Variable
    ${specialBusinessDates_List}    Remove Duplicates    ${specialBusinessDates_List}
    Remove Values From List    ${specialBusinessDates_List}    ${NONE}
    ${List_TotalCount}    Get Length    ${specialBusinessDates_List}
    ${specialBusinessDates_0}    Run Keyword If    '${List_TotalCount}'!='0'    Get From List    ${specialBusinessDates_List}    0
    ${specialBusinessDates_IsNone}    Run Keyword And Return Status    Should Be Equal As Strings    ${specialBusinessDates_0}    None    
    ${SBD_Dict}    Run Keyword If    ${specialBusinessDates_IsNone}==${False}    Assess Special Business Dates List and Return Dictionary    ${specialBusinessDates_List}
    ...    ELSE    Create Dictionary
    [Return]    ${SBD_Dict}

Create Special Business Dates Dictionary
    [Documentation]    This keyword is used to create the specialBusinessDates section of the Calendar payload and return dictionary.
    ...    @author: clanding    21JUN2019    - initial create
    ...    @update: clanding    19JUL2019    - added Exit For Loop if NBD and SBD dates are equal
    [Arguments]    ${sCalendarID}    ${iEventYear}    ${iEventDate}    ${sEventName}    ${aNonBusinessDates_List}

    :FOR    ${NBD_Dict_In_List}    IN    @{aNonBusinessDates_List}
    \    ${dateValue_NBD}    Get From Dictionary    ${NBD_Dict_In_List}    dateValue
    \    Log    ${iEventDate}
    \    ${NBD_SBD_Date_Equal}    Run Keyword And Return Status    Should Be Equal As Strings    ${dateValue_NBD}    ${iEventDate}
    \    ${specialBusinessDates_Dict}    Run Keyword If    '${dateValue_NBD}'!='${iEventDate}'    Create Dictionary    dateValue=${iEventDate}    reason=${sEventName.strip()}
    \    Exit For Loop If    ${NBD_SBD_Date_Equal}==${True}
    [Return]    ${specialBusinessDates_Dict}

Assess Special Business Dates List and Return Dictionary
    [Documentation]    This keyword is used to assess Special Business Dates List that contain SBD Dictionary and assess if records are valid and return SBD Dictionary.
    ...    @author: clanding    05JUL2019    - initial create
    ...    @update: clanding    26JUL2019    - added else if condition
    [Arguments]    ${aspecialBusinessDates_List}
    
    ${Prev_EventYear}    Set Variable
    ${Prev_List}    Create List
    ${SBD_List}    Create List    
    ${SBD_Dict}    Create Dictionary
    ${specialBusinessDates_List}    Remove Duplicates    ${aspecialBusinessDates_List}
    Remove Values From List    ${specialBusinessDates_List}    ${NONE}
    ${List_TotalCount}    Get Length    ${specialBusinessDates_List}
    ${List_TotalCount_Less1}    Evaluate    ${List_TotalCount}-1
    
    :FOR    ${ListCount}    IN RANGE    ${List_TotalCount}
    \    ${specialBusinessDates_Dict}    Get From List    ${specialBusinessDates_List}    ${ListCount}
    \    ${DateValue}    Get From Dictionary    ${specialBusinessDates_Dict}    dateValue
    \    ${EventYear}    Get Substring    ${DateValue}    0    4
    \    
    \    ${Same_EventYear}    Run Keyword If    '${Prev_EventYear}'==''    Set Variable    False
         ...    ELSE IF    '${EventYear}'=='${Prev_EventYear}'    Set Variable    True
         ...    ELSE IF    '${EventYear}'!='${Prev_EventYear}'    Set Variable    False
    \    
    \    ${SBD_List}    Run Keyword If    ${Same_EventYear}==${False}    Create List
         ...    ELSE    Set Variable    ${SBD_List}
    \    
    \    Run Keyword If    ${Same_EventYear}==${False} and '${ListCount}'=='0' and '${ListCount}'=='${List_TotalCount_Less1}'    Run Keywords    Append To List    ${SBD_List}    ${specialBusinessDates_Dict}
         ...    AND    Set To Dictionary    ${SBD_Dict}    ${EventYear}=${SBD_List}
         ...    ELSE IF    '${ListCount}'=='0'    Append To List    ${SBD_List}    ${specialBusinessDates_Dict}
         ...    ELSE IF    ${Same_EventYear}==${True} and '${ListCount}'!='${List_TotalCount_Less1}'    Append To List    ${SBD_List}    ${specialBusinessDates_Dict}
         ...    ELSE IF    ${Same_EventYear}==${False} and '${ListCount}'!='${List_TotalCount_Less1}'    Run Keywords    Set To Dictionary    ${SBD_Dict}    ${Prev_EventYear}=${Prev_List}
         ...    AND    Append To List    ${SBD_List}    ${specialBusinessDates_Dict}
         ...    ELSE IF    ${Same_EventYear}==${True} and '${ListCount}'=='${List_TotalCount_Less1}'    Run Keywords    Append To List    ${SBD_List}    ${specialBusinessDates_Dict}
         ...    AND    Set To Dictionary    ${SBD_Dict}    ${EventYear}=${SBD_List}
         ...    ELSE IF    ${Same_EventYear}==${False} and '${ListCount}'=='${List_TotalCount_Less1}'    Run Keywords    Set To Dictionary    ${SBD_Dict}    ${Prev_EventYear}=${Prev_List}
         ...    AND    Append To List    ${SBD_List}    ${specialBusinessDates_Dict}
         ...    AND    Set To Dictionary    ${SBD_Dict}    ${EventYear}=${SBD_List}
    \    
    \    ${Prev_List}    Set Variable    ${SBD_List}
    \    Log    ${SBD_Dict}
    \    Log    ${SBD_List}
    \    ${Prev_EventYear}    Run Keyword If    '${EventYear}'!='${Prev_EventYear}'    Set Variable    ${EventYear}
         ...    ELSE    Set Variable    ${Prev_EventYear}
    \    Exit For Loop If    ${ListCount}==${List_TotalCount}
     Log    ${SBD_Dict}
     [Return]    ${SBD_Dict}

Create Date Details List in TL Calendar Payload and Return
    [Documentation]    This keyword is used to create dateDetails section of the Calendar payload and return dictionary
    ...    @author: clanding    02JUL2019    - initial create
    [Arguments]    ${sCal_ID}    ${dYear_CalID_NBD_Dict}    ${dYear_CalID_SBD_Dict}
    
    ${prev_List}    Create List
    ${Final_List}    Create List
    ${Empty_List}     Create List
    ${Empty_Dict}    Create Dictionary
    ${dateDetails_Dict}    Create Dictionary
    ${dateDetails_List}    Create List
    ${Year_NBD_List}    Create List
    ${Calendar_Year_NBD_Dict}    Create Dictionary
    
    ### Get NBD record ###
    ${Year_CalID_NBD_KeyList}    Get Dictionary Keys    ${dYear_CalID_NBD_Dict}
    ${Year_CalID_NBD_ValList}    Get Dictionary Values    ${dYear_CalID_NBD_Dict}
    ${Year_CaldID_NBD_TotalCount}    Get Length    ${Year_CalID_NBD_KeyList}
    
    ### Get SBD record ###
    ${Year_CalID_SBD_KeyList}    Get Dictionary Keys    ${dYear_CalID_SBD_Dict}
    ${Year_CalID_SBD_ValList}    Get Dictionary Values    ${dYear_CalID_SBD_Dict}
    ${Year_CaldID_SBD_TotalCount}    Get Length    ${Year_CalID_SBD_KeyList}
    
    ${SBD_GreaterThan_NBD}    Evaluate    ${Year_CaldID_SBD_TotalCount}<${Year_CaldID_NBD_TotalCount}
    ${NBD_GreaterThan_SBD}    Evaluate    ${Year_CaldID_NBD_TotalCount}<${Year_CaldID_SBD_TotalCount}
    
    :FOR    ${Year_CaldID_NBD_Count}    IN RANGE    ${Year_CaldID_NBD_TotalCount}
    \    ${Year_CalID_NBD_Key}    Get From List    ${Year_CalID_NBD_KeyList}    ${Year_CaldID_NBD_Count}
    \    ${Year_CalID_NBD_Val}    Get From List    ${Year_CalID_NBD_ValList}    ${Year_CaldID_NBD_Count}
    \    
    \    ### Split Year and Calendar ID ###
    \    ${Year_CalID_NBD_Split_List}    Split String    ${Year_CalID_NBD_Key}    _
    \    ${Year_NBD}    Get From List    ${Year_CalID_NBD_Split_List}    0
    \    ${CalendarID_NBD}    Get From List    ${Year_CalID_NBD_Split_List}    1
    \    ${Temp_Dict}    Create Dictionary    ${Year_NBD}=${Year_CalID_NBD_Val}
    \    
    \    ${NBDYear_IsExistingIn_SBD}    Run Keyword And Return Status    Should Contain    ${Year_CalID_SBD_KeyList}    ${Year_NBD}
    \    ${dateDetails_Dict}    Run Keyword If    ${NBDYear_IsExistingIn_SBD}==${True}    Create Date Details Dictionary with NBD and SBD Records and Return    ${Year_CalID_NBD_Val}
         ...    ${Year_NBD}    ${dYear_CalID_SBD_Dict}
         ...    ELSE    Create Dictionary    year=${${Year_NBD}}    nonBusinessDates=${Year_CalID_NBD_Val}    specialBusinessDates=${Empty_List}
    \    Log    ${dYear_CalID_SBD_Dict}
    \    Remove From Dictionary    ${dYear_CalID_SBD_Dict}    ${Year_NBD}
    \    Log    ${dYear_CalID_SBD_Dict}
    \    Append To List    ${dateDetails_List}    ${dateDetails_Dict}
    \    Log    ${dateDetails_List}
    Log    ${dateDetails_List}
    
    ${New_SBD_Dict_Empty}    Run Keyword And Return Status    Should Not Be Empty    ${dYear_CalID_SBD_Dict}
    ${dateDetails_List}    Run Keyword If    ${New_SBD_Dict_Empty}==${True}    Process Special Business Date Dictionary and Return List    ${dYear_CalID_SBD_Dict}    ${dateDetails_List}
    ...    ELSE    Set Variable    ${dateDetails_List}
    Log    ${dateDetails_List}
    [Return]    ${dateDetails_List}

Process Special Business Date Dictionary and Return List
    [Documentation]    This keyword is used to process remaining special business dates dictionary without non business dates.
    ...    @author: clanding    26JUL2019    - initial create
    [Arguments]    ${dYear_CalID_SBD_Dict}    ${aDateDetails_List}
    
    ${Empty_List}     Create List
    ${Year_CalID_SBD_KeyList}    Get Dictionary Keys    ${dYear_CalID_SBD_Dict}
    ${Year_CaldID_SBD_TotalCount}    Get Length    ${Year_CalID_SBD_KeyList}
    :FOR    ${Year}    IN    @{Year_CalID_SBD_KeyList}
    \    ${SBD_List}    Get From Dictionary    ${dYear_CalID_SBD_Dict}    ${Year}
    \    ${dateDetails_Dict}    Create Dictionary    year=${${Year}}    nonBusinessDates=${Empty_List}    specialBusinessDates=${SBD_List}
    \    Append To List    ${aDateDetails_List}    ${dateDetails_Dict}
    \    Log    ${aDateDetails_List}
    Log    ${aDateDetails_List}
    [Return]    ${aDateDetails_List}
    
Create Date Details Dictionary with NBD and SBD Records and Return
    [Documentation]    This keyword is used to create date details dictionary with both non business dates and special business dates.
    ...    @author: clanding    26JUL2019    - initial create
    [Arguments]    ${dNBD}    ${sYear}    ${dYear_CalID_SBD_Dict}
    ${SBD_List}    Get From Dictionary    ${dYear_CalID_SBD_Dict}    ${sYear}
    ${dateDetails_Dict}    Create Dictionary    year=${${sYear}}    nonBusinessDates=${dNBD}    specialBusinessDates=${SBD_List}
    [Return]    ${dateDetails_Dict}

Create Final Date Details Dictionary with Base NBD
    [Documentation]    This keyword is used to create final dateDetails section including special business dates of the Calendar payload and return dictionary
    ...    @author: clanding    02JUL2019    - initial create
    [Arguments]    ${dYear_CalID_NBD_Dict}    ${sCal_ID}    ${dYear_CalID_SBD_Dict}    ${iYear_NBD}    ${aNBD_List}    ${aYear_NBD_List}
	
	### Get NBD record ###
    ${Year_CalID_NBD_KeyList}    Get Dictionary Keys    ${dYear_CalID_NBD_Dict}
    ${Year_CalID_NBD_ValList}    Get Dictionary Values    ${dYear_CalID_NBD_Dict}
    ${Year_CaldID_NBD_TotalCount}    Get Length    ${Year_CalID_NBD_KeyList}
	
	### Get SBD record ###
    ${Year_CalID_SBD_KeyList}    Get Dictionary Keys    ${dYear_CalID_SBD_Dict}
    ${Year_CalID_SBD_ValList}    Get Dictionary Values    ${dYear_CalID_SBD_Dict}
    ${Year_CaldID_SBD_TotalCount}    Get Length    ${Year_CalID_SBD_KeyList}
	
	${prev_List}    Set Variable
	${Year_NBD_List}    Create List
	${dateDetails_List}    Create List
	:FOR    ${Year_CaldID_NBD_Count}    IN RANGE    ${Year_CaldID_NBD_TotalCount}
    \    ${Year_CalID_NBD_Key}    Get From List    ${Year_CalID_NBD_KeyList}    ${Year_CaldID_NBD_Count}
    \    ${Year_CalID_NBD_Val}    Get From List    ${Year_CalID_NBD_ValList}    ${Year_CaldID_NBD_Count}
    \    
    \    ### Split Year and Calendar ID ###
    \    ${Year_CalID_NBD_Split_List}    Split String    ${Year_CalID_NBD_Key}    _
    \    ${Year_NBD}    Get From List    ${Year_CalID_NBD_Split_List}    0
    \    ${CalendarID_NBD}    Get From List    ${Year_CalID_NBD_Split_List}    1
    \    
    \    Append To List    ${Year_NBD_List}    ${Year_NBD}
    \    ${Calendar_Year_NBD_Dict}    Create Dictionary    ${CalendarID_NBD}=${Year_NBD_List}
    \    Log    ${Calendar_Year_NBD_Dict}
    \    
    \    ${SBDYear_Exist_In_NBDYear}    Run Keyword And Return Status    Should Contain    ${Year_CalID_SBD_KeyList}    ${Year_NBD}
    \    
    \    ${dateDetails_List}    Run Keyword If    '${sCal_ID}'=='${CalendarID_NBD}' and ${SBDYear_Exist_In_NBDYear}==${True}    Create Final Date Details Dictionary    ${dYear_CalID_SBD_Dict}    ${Year_NBD}    ${Year_CalID_NBD_Val}    ${Year_NBD_List}
         ...    ELSE    Set Variable    ${dateDetails_List}
    \    
    \    Remove Duplicates    ${dateDetails_List}
    \    Log    ${prev_List}
    \    ${Final_List}    Combine Lists    ${prev_List}    ${dateDetails_List}
    \    ${prev_List}    Set Variable    ${dateDetails_List}
    \    Log    ${prev_List}
    \    Log    ${Final_List}
	

Create Final Date Details Dictionary
    [Documentation]    This keyword is used to create final dateDetails section including special business dates of the Calendar payload and return dictionary
    ...    @author: clanding    02JUL2019    - initial create
    [Arguments]    ${dYear_CalID_SBD_Dict}    ${iYear_NBD}    ${aNBD_List}    ${aYear_NBD_List}
	
	${dateDetails_List}    Create List
	${dateDetails_Dict}    Create Dictionary
	${Empty_List}    Create List
	${Year_CalID_SBD_KeyList}    Get Dictionary Keys    ${dYear_CalID_SBD_Dict}
    ${Year_CalID_SBD_ValList}    Get Dictionary Values    ${dYear_CalID_SBD_Dict}
    ${Year_CaldID_TotalCount}    Get Length    ${Year_CalID_SBD_KeyList}
    Log    ${aNBD_List}
    Log    ${aYear_NBD_List}
    Log    ${iYear_NBD}
    ${NBD_ListCount}    Get Length    ${aNBD_List}
    :FOR    ${Year_CaldID_Count}    IN RANGE    ${Year_CaldID_TotalCount}
    \    ${Year_CalID_Key}    Get From List    ${Year_CalID_SBD_KeyList}    ${Year_CaldID_Count}
    \    ${Year_CalID_Val}    Get From List    ${Year_CalID_SBD_ValList}    ${Year_CaldID_Count}
    \    
    \    ${SBDYear_Exist_In_NBDYear}    Run Keyword And Return Status    Should Contain    ${aYear_NBD_List}    ${Year_CalID_Key}
    \    
    \    Run Keyword If    '${iYear_NBD}'=='${Year_CalID_Key}'    Set To Dictionary    ${dateDetails_Dict}    year=${${iYear_NBD}}    nonBusinessDates=${aNBD_List}    specialBusinessDates=${Year_CalID_Val}
    \    ${dateDetails_Dict}    Run Keyword If    '${iYear_NBD}'!='${Year_CalID_Key}' and ${SBDYear_Exist_In_NBDYear}==${True}    Create Dictionary    year=${${iYear_NBD}}    nonBusinessDates=${aNBD_List}    specialBusinessDates=${Empty_List}
         ...    ELSE IF    '${iYear_NBD}'!='${Year_CalID_Key}' and ${SBDYear_Exist_In_NBDYear}==${False}    Create Dictionary    year=${${Year_CalID_Key}}    nonBusinessDates=${Empty_List}    specialBusinessDates=${Year_CalID_Val}
         ...    ELSE    Set Variable    ${dateDetails_Dict}
    \    
    \    Append To List    ${dateDetails_List}    ${dateDetails_Dict}
    \    Log    ${dateDetails_List}
    Log    ${dateDetails_List}
    [Return]    ${dateDetails_List}

Create Date Details List with no SBD
    [Documentation]    This keyword is used to create dateDetails section WITHOUT special business dates of the Calendar payload and return dictionary
    ...    @author: clanding    02JUL2019    - initial create
    [Arguments]    ${sCalendarID}    ${dYear_CalID_NBD_Dict}
	
	${dateDetails_List}    Create List
	${Empty_List}    Create List
	${Year_CalID_NBD_KeyList}    Get Dictionary Keys    ${dYear_CalID_NBD_Dict}
    ${Year_CalID_NBD_ValList}    Get Dictionary Values    ${dYear_CalID_NBD_Dict}
    ${Year_CaldID_TotalCount}    Get Length    ${Year_CalID_NBD_KeyList}
	:FOR    ${Year_CaldID_Count}    IN RANGE    ${Year_CaldID_TotalCount}
    \    ${Year_CalID_NBD_Key}    Get From List    ${Year_CalID_NBD_KeyList}    ${Year_CaldID_Count}
    \    ${Year_CalID_NBD_Val}    Get From List    ${Year_CalID_NBD_ValList}    ${Year_CaldID_Count}
    \    
    \    ### Split Year and Calendar ID ###
    \    ${Year_CalID_NBD_Split_List}    Split String    ${Year_CalID_NBD_Key}    _
    \    ${Year_NBD}    Get From List    ${Year_CalID_NBD_Split_List}    0
    \    ${CalendarID_NBD}    Get From List    ${Year_CalID_NBD_Split_List}    1
    \    
    \    ${dateDetails_Dict}    Run Keyword If    '${sCalendarID}'=='${CalendarID_NBD}'    Create Dictionary    year=${${Year_NBD}}    nonBusinessDates=${Year_CalID_NBD_Val}    specialBusinessDates=${Empty_List}
    \    Append To List    ${dateDetails_List}    ${dateDetails_Dict}
    \    Log    ${dateDetails_Dict}
    \    Log    ${dateDetails_List}
    [Return]    ${dateDetails_List}

Create Date Details List with no NBD
    [Documentation]    This keyword is used to create dateDetails section WITHOUT non business dates of the Calendar payload and return dictionary
    ...    @author: clanding    02JUL2019    - initial create
    ...    @update: clanding    06AUG2019    - removed the checking for same calendar id
    [Arguments]    ${sCalendarID}    ${dYear_CalID_SBD_Dict}
	
	${dateDetails_List}    Create List
	${Empty_List}    Create List
	${Year_CalID_SBD_KeyList}    Get Dictionary Keys    ${dYear_CalID_SBD_Dict}
    ${Year_CalID_SBD_ValList}    Get Dictionary Values    ${dYear_CalID_SBD_Dict}
    ${Year_CaldID_TotalCount}    Get Length    ${Year_CalID_SBD_KeyList}
    :FOR    ${Year_CaldID_Count}    IN RANGE    ${Year_CaldID_TotalCount}
    \    ${Year_CalID_SBD_Key}    Get From List    ${Year_CalID_SBD_KeyList}    ${Year_CaldID_Count}
    \    ${Year_CalID_SBD_Val}    Get From List    ${Year_CalID_SBD_ValList}    ${Year_CaldID_Count}
    \    
    \    ${dateDetails_Dict}    Create Dictionary    year=${${Year_CalID_SBD_Key}}    nonBusinessDates=${Empty_List}    specialBusinessDates=${Year_CalID_SBD_Val}
    \    Append To List    ${dateDetails_List}    ${dateDetails_Dict}
    \    Log    ${dateDetails_Dict}
    \    Log    ${dateDetails_List}
    [Return]    ${dateDetails_List}

Check If Existing in No Change List
    [Documentation]    This keyword is used to check if dictionary is exiting in the No Change List.
    ...    @author: clanding    04JUL2019    - initial create
    [Arguments]    ${aNoChange_List}    ${dSBD_Dict}
    
    :FOR    ${NoChange_Dict}    IN    @{aNoChange_List}
    \    ${Same_Dict}    Run Keyword And Return Status    Should Be Equal    ${NoChange_Dict}    ${dSBD_Dict}
    \    
    \    ${dSBD_Dict}    Run Keyword If    ${Same_Dict}==${True}    Create Dictionary
         ...    ELSE    Set Variable    ${dSBD_Dict}
    \    Exit For Loop If    ${Same_Dict}==${True}
    [Return]    ${dSBD_Dict}

Create Expected JSON for TL Calendar XLS Misc File
    [Documentation]    This keyword is used to create the expected json file for Misc File of Copp Clark files.
    ...    @author: clanding    19JUN2019    - initial create
    ...    @update: clanding    15JUL2019    - added creation of json per unique calendar id
    ...    @update: jloretiz    15AUG2019    - added a condition to skip a for loop iteration if date is same
    ...    @update: jloretiz    26NOV2019    - add the keyword to close the current excel document
    [Arguments]    ${sInputFilePath}    ${sXLSFile}    ${sSheetName}    ${sInputJSON}    ${sFileType}
    
    Open Excel    ${sXLSFile}
    
    ### Set Variables ###
    ${RowCount}    Get Row Count    ${sSheetName}
    ${Prev_CalendarID}    Set Variable
    ${Prev_EventYear}    Set Variable
    ${CalendarID_List}    Create List
    ${CalendarID_Row_List}    Create List
    ${CalendarID_Unique_Dict}    Create Dictionary
    ${DateDetails_List}    Create List
    ${SubFieldList}    Create List
    ${SubFieldValueList}    Create List
    ${Year_List}    Create List
    ${Year_Dict}    Create Dictionary
    ${Year_CalID_NBD_Dict}    Create Dictionary
    ${nonBusinessDates_List}    Create List
    ${NoChange_Hol_List}    Create List
    ${NoChange_Hol_Dict}    Create Dictionary
    ${Existing_Dates}    Create List
    Close Current Excel Document

    ### Get Calendar ID List ###
    :FOR    ${Rownum}    IN RANGE    1    ${RowCount}
    \    
    \    ### Get Copp Clark File values ###
    \    ${ISOCountryCode_Val}    Read Cell Data Using Reference Column Name and Row Number and Return    ${sSheetName}    ${COL_ISOCOUNTRYCODE}    ${Rownum}    ${sXLSFile}
    \    ${ISO_MIC_Code_Val}    Read Cell Data Using Reference Column Name and Row Number and Return    ${sSheetName}    ${COL_ISOMICCODE}    ${Rownum}    ${sXLSFile}
    \    ${EventYear_Val}    Read Cell Data Using Reference Column Name and Row Number and Return    ${sSheetName}    ${COL_EVENTYEAR}    ${Rownum}    ${sXLSFile}
    \    
    \    ### Convert Values ###
    \    ${ISO_MIC_Code}    Get Substring    ${ISO_MIC_Code_Val}    0    3
    \    ${CalendarID}    Catenate    SEPARATOR=    ${ISOCountryCode_Val}    ${ISO_MIC_Code}
    \    ${CalendarID_Status}    Get Calendar ID Status from Database    ${CalendarID}
    \    ${CalendarID_Status_Is_Not_Existing}    Run Keyword And Return Status    Should Be Equal As Strings    ${CalendarID_Status}    ${NONE}
    \    ${EventYear_Val}    Convert To String    ${EventYear_Val}
    \    ${EventYear}    Get Substring    ${EventYear_Val}    0    4
    \    
    \    Run Keyword If    ${CalendarID_Status_Is_Not_Existing}==${False} and '${CalendarID_Status}'!='N'    Run Keywords    Append To List    ${CalendarID_Row_List}    ${CalendarID}_${Rownum}
         ...    AND    Append To List    ${CalendarID_List}    ${CalendarID}
         ...    AND    Append To List    ${Year_List}    ${EventYear} 
         ...    ELSE IF    '${CalendarID_Status}'=='N'    Run Keywords    Append To List    ${CalendarID_List}
         ...    AND    Append To List    ${CalendarID_Row_List}
         ...    AND    Append To List    ${Year_List}   
         ...    AND    Log    Calendar ID '${CalendarID}' is exsting in LIQ database but status is INACTIVE.    level=WARN
         ...    ELSE    Run Keywords    Append To List    ${CalendarID_List}
         ...    AND    Append To List    ${CalendarID_Row_List}
         ...    AND    Append To List    ${Year_List}
         ...    AND    Log    Calendar ID '${CalendarID}' is NOT EXISTING in LIQ database.    level=WARN
    \    
    \    Log    ${CalendarID_List}
    \    Log    ${CalendarID_Row_List}
    \    Log    ${Year_List}
    
    ### Create Non-Business Date in the payload ###
    :FOR    ${CalendarID_Row}    IN    @{CalendarID_Row_List}
    \    ${CalendarID_Split_List}    Split String    ${CalendarID_Row}    _
    \    ${RowCount}    Get From List    ${CalendarID_Split_List}    1
    \    
    \    ### Get Copp Clark File values ###
    \    ${ISOCountryCode_Val}    Read Cell Data Using Reference Column Name and Row Number and Return    ${sSheetName}    ${COL_ISOCOUNTRYCODE}    ${RowCount}    ${sXLSFile}
    \    ${ISO_MIC_Code_Val}    Read Cell Data Using Reference Column Name and Row Number and Return    ${sSheetName}    ${COL_ISOMICCODE}    ${Rownum}    ${sXLSFile}
    \    ${EventYear_Val}    Read Cell Data Using Reference Column Name and Row Number and Return    ${sSheetName}    ${COL_EVENTYEAR}    ${RowCount}    ${sXLSFile}
    \    ${EventDate_Val}    Read Cell Data Using Reference Column Name and Row Number and Return    ${sSheetName}    ${COL_EVENTDATE}    ${RowCount}    ${sXLSFile}
    \    ${EventName_Val}    Read Cell Data Using Reference Column Name and Row Number and Return    ${sSheetName}    ${COL_EVENTNAME}    ${RowCount}    ${sXLSFile}
    \    
    \    ### Convert Values ###
    \    ${ISO_MIC_Code}    Get Substring    ${ISO_MIC_Code_Val}    0    3
    \    ${CalendarID}    Catenate    SEPARATOR=    ${ISOCountryCode_Val}    ${ISO_MIC_Code}
    \    ${EventYear_Val}    Convert To String    ${EventYear_Val}
    \    ${EventYear}    Get Substring    ${EventYear_Val}    0    4
    \    ${EventDate_Val}    Convert To String    ${EventDate_Val}
    \    ${EventYear_Val}    Convert To String    ${EventYear}
    \    ${EventYear}    Get Substring    ${EventYear_Val}    0    4
    \    ${EventDate_Year}    Get Substring    ${EventDate_Val}    0    4
    \    ${EventDate_Month}    Get Substring    ${EventDate_Val}    4    6
    \    ${EventDate_Day}    Get Substring    ${EventDate_Val}    6    8
    \    ${EventDate_PayloadFormat}    Catenate    SEPARATOR=-    ${EventDate_Year}    ${EventDate_Month}    ${EventDate_Day}   
    \    ${EventDate_LIQFormat}    Convert Date With Zero    ${EventDate_PayloadFormat}
    \    
    \    ${Same_CalendarID}    Run Keyword If    '${Prev_EventYear}'==''    Set Variable    True
         ...    ELSE IF    '${CalendarID}'!='${Prev_CalendarID}'    Set Variable    False
         ...    ELSE    Set Variable    True
    \    ${Same_EventYear}    Run Keyword If    '${Prev_EventYear}'==''    Set Variable    True
         ...    ELSE IF    '${EventYear}'!='${Prev_EventYear}'    Set Variable    False
         ...    ELSE    Set Variable    True
    \    ${Same_Date}    Run Keyword And Return Status    List Should Contain Value    ${Existing_Dates}    ${EventDate_PayloadFormat}    
    \    Run Keyword If    ${Same_Date}==${False}    Append To List    ${Existing_Dates}    ${EventDate_PayloadFormat}
    \    
    \    # Skip current iteration if event date already exists
    \    Continue For Loop If    ${Same_Date}==${True}
    \    
    \    ### Get LIQ Business Date and verify if Event Data is greater than LIQ Date ###
    \    ${LIQ_Business_Date_DBFormat}    Get LIQ Business Date from Database    ${ZONE3}
    \    ${LIQ_Business_Date}    Convert Date    ${LIQ_Business_Date_DBFormat}    result_format=%Y-%M-%d    date_format=%M-%d-%Y
    \    ${LIQ_EventDate_Diff}    Subtract Date From Date    ${EventDate_PayloadFormat}    ${LIQ_Business_Date}
    \    
    \    ${Hol_Date_Status_DB}    Get Status from Holiday Calendar Dates table in Database    ${CalendarID}    ${EventDate_LIQFormat}
    \    ${Query_Results_None}    Run Keyword And Return Status    Should Be Equal As Strings    ${Hol_Date_Status_DB}    None
    \    ${Hol_Date_Status}    Run Keyword If    ${Query_Results_None}==${False}    Get From List    ${Hol_Date_Status_DB}    0
         ...    ELSE    Set Variable
    \    ${Status_IsActive}    Run Keyword And Return Status    Should Be Equal As Strings    ${Hol_Date_Status}    Y
    \    ${Status_IsInactive}    Run Keyword And Return Status    Should Be Equal As Strings    ${Hol_Date_Status}    N
    \    ${Hol_Date_EventName_DB}    Get Event Name from Holiday Calendar Dates table in Database    ${CalendarID}    ${EventDate_LIQFormat}
    \    ${DB_None}    Run Keyword And Return Status    Should Be Equal As Strings    ${Hol_Date_EventName_DB}    None
    \    ${Hol_Date_EventName}    Run Keyword If    ${DB_None}==${False}    Get From List    ${Hol_Date_EventName_DB}    0
         ...    ELSE    Set Variable
    \    ${Same_EventName}    Run Keyword And Return Status    Should Be Equal As Strings    ${EventName_Val}    ${Hol_Date_EventName.strip()}
    \    
    \    ${nonBusinessDates_Dict}    Create Non Business Dates Dictionary in TL Calendar Payload and Return    ${EventDate_PayloadFormat}    ${EventName_Val}
    \    
    \    Log    ${Prev_EventYear}
    \    ${nonBusinessDates_List}    Run Keyword If    ${Same_EventYear}==${False}    Create List
         ...    ELSE IF    '${Prev_EventYear}'==''    Create List
         ...    ELSE    Set Variable    ${nonBusinessDates_List}
    \    Log    ${nonBusinessDates_List}
    \    
    \    Run Keyword If    ${LIQ_EventDate_Diff}<0.0    Run Keywords    Append To List    ${nonBusinessDates_List}
         ...    AND    Log    Event Date '${EventDate_PayloadFormat}' is less than LIQ Date '${LIQ_Business_Date}'.
         ...    ELSE IF    ${LIQ_EventDate_Diff}==0.0 and ${Same_EventName}==${False}    Run Keywords    Append To List    ${nonBusinessDates_List}    ${nonBusinessDates_Dict}
         ...    AND    Log    Event Date '${EventDate_PayloadFormat}' is equal to LIQ Date '${LIQ_Business_Date}'.
         ...    ELSE IF    ${LIQ_EventDate_Diff}==0.0 and ${Status_IsInactive}==${True}    Run Keywords    Append To List    ${nonBusinessDates_List}    ${nonBusinessDates_Dict}
         ...    AND    Log    Event Date '${EventDate_PayloadFormat}' is equal to LIQ Date '${LIQ_Business_Date}' and previous status is 'Inactive'.
         ...    ELSE IF    ${LIQ_EventDate_Diff}>0.0 and ${Same_EventName}==${False}    Run Keywords    Append To List    ${nonBusinessDates_List}    ${nonBusinessDates_Dict}
         ...    AND    Log    Event Date '${EventDate_PayloadFormat}' is greater than LIQ Date '${LIQ_Business_Date}'.
         ...    ELSE IF    ${LIQ_EventDate_Diff}>0.0 and ${Status_IsInactive}==${True}    Run Keywords    Append To List    ${nonBusinessDates_List}    ${nonBusinessDates_Dict}
         ...    AND    Log    Event Date '${EventDate_PayloadFormat}' is greater than LIQ Date '${LIQ_Business_Date}' and previous status is 'Inactive'.
    \    Log    ${nonBusinessDates_List}
    \    ${List_Empty}    Run Keyword And Return Status    Should Be Empty    ${nonBusinessDates_List}
    \    
    \    Run Keyword If    ${LIQ_EventDate_Diff}==0.0 and ${Same_EventYear}==${True} and ${List_Empty}==${False}    Set To Dictionary    ${Year_CalID_NBD_Dict}    ${EventYear}_${CalendarID}=${nonBusinessDates_List}
         ...    ELSE IF    ${LIQ_EventDate_Diff}>0.0 and ${Same_EventYear}==${True} and ${List_Empty}==${False}    Set To Dictionary    ${Year_CalID_NBD_Dict}    ${EventYear}_${CalendarID}=${nonBusinessDates_List}
         ...    ELSE IF    ${LIQ_EventDate_Diff}==0.0 and ${Same_EventYear}==${False} and ${List_Empty}==${False}    Set To Dictionary    ${Year_CalID_NBD_Dict}    ${EventYear}_${CalendarID}=${nonBusinessDates_List}
         ...    ELSE IF    ${LIQ_EventDate_Diff}>0.0 and ${Same_EventYear}==${False} and ${List_Empty}==${False}    Set To Dictionary    ${Year_CalID_NBD_Dict}    ${EventYear}_${CalendarID}=${nonBusinessDates_List}
    \    
    \    ### Handle No Change Holiday Dates ###
    \    Run Keyword If    ${Same_EventName}==${True}    Append To List    ${NoChange_Hol_List}    ${nonBusinessDates_Dict}
         ...    ELSE    Append To List    ${NoChange_Hol_List}
    \    
    \    ${Prev_CalendarID}    Run Keyword If    '${CalendarID}'!='${Prev_CalendarID}'    Set Variable    ${CalendarID}
         ...    ELSE    Set Variable    ${Prev_CalendarID}
    \    ${Prev_EventYear}    Run Keyword If    '${EventYear}'!='${Prev_EventYear}'    Set Variable    ${EventYear}
         ...    ELSE    Set Variable    ${Prev_EventYear}
    \    Log    ${Year_CalID_NBD_Dict}
    \    Log    ${NoChange_Hol_List}
    Log    ${Year_CalID_NBD_Dict}
    Log    ${NoChange_Hol_List}

    ${JSON_File}    Set Variable    ${datasetpath}${sInputFilePath}${sInputJSON}_${sFileType}.${JSON}
    Delete File If Exist    ${JSON_File}
    Create File    ${JSON_File}
    
    ###Get configured LOB from MCH DB###
    ${LOB}    Connect to MCH Oracle Database and Execute Query    ${Query_Get_LOB}
    ${SQL_LOB_Result_List}    Convert SQL Result to List and Return    ${LOB}
    
    ### Create Payload ###
    ${CalendarID_List_Unique}    Remove Duplicates    ${CalendarID_List}
    :FOR    ${CalendarID_Unique}    IN    @{CalendarID_List_Unique}
    \    ${Year_CalID_SBD_Dict}    Create Special Business Dates Dictionary in TL Calendar Payload and Return    ${CalendarID_Unique}    ${Year_CalID_NBD_Dict}    ${NoChange_Hol_List}
    \    Log    ${Year_CalID_SBD_Dict}
    \    
    \    ${SBD_IsEmpty}    Run Keyword And Return Status    Should Be Empty    ${Year_CalID_SBD_Dict}
    \    ${Year_CalID_SBD_Dict}    Run Keyword If    ${SBD_IsEmpty}==${True}    Set Variable
         ...    ELSE    Set Variable    ${Year_CalID_SBD_Dict}
    \    ${NBD_IsEmpty}    Run Keyword And Return Status    Should Be Empty    ${Year_CalID_NBD_Dict}
    \    
    \    ${DateDetails_List}    Run Keyword If    ${SBD_IsEmpty}==${False} and ${NBD_IsEmpty}==${False}    Create Date Details List in TL Calendar Payload and Return    ${CalendarID_Unique}    ${Year_CalID_NBD_Dict}    ${Year_CalID_SBD_Dict}
         ...    ELSE IF    ${SBD_IsEmpty}==${True} and ${NBD_IsEmpty}==${False}    Create Date Details List with no SBD    ${CalendarID_Unique}    ${Year_CalID_NBD_Dict}
         ...    ELSE IF    ${SBD_IsEmpty}==${False} and ${NBD_IsEmpty}==${True}    Create Date Details List with no NBD    ${CalendarID_Unique}    ${Year_CalID_SBD_Dict}
    \    
    \    ${File}    OperatingSystem.Get File    ${JSON_File}
    \    ${File_Empty}    Run Keyword And Return Status    Should Be Empty    ${File}
    \    ${weeklyHolidays_List}    Create List
    \    ${LOB_List}    Set LOB Section for TL Calendar Payload and Return    ${SQL_LOB_Result_List}
    \    
    \    ### Get Value from LIQ Database ###
    \    ${CalendarDesc}    Get Calendar ID Description from Database    ${CalendarID_Unique}
    \    
    \    ${JSON_Object}    Load JSON From File    ${TEMPLATE_JSON_CAL}
    \    ${New_JSON}    Set To Dictionary    ${JSON_Object}    calendarId=${CalendarID_Unique}
    \    ${New_JSON}    Set To Dictionary    ${New_JSON}    calendarType=${FINCENTRE}
    \    ${New_JSON}    Set To Dictionary    ${New_JSON}    description=${CalendarDesc}
    \    ${New_JSON}    Set To Dictionary    ${New_JSON}    lobs=${LOB_List}
    \    ${New_JSON}    Set To Dictionary    ${New_JSON}    weeklyHolidays=${weeklyHolidays_List}
    \    ${New_JSON}    Set To Dictionary    ${New_JSON}    dateDetails=${DateDetails_List}
    \    ${Converted_JSON}    Evaluate    json.dumps(${New_JSON})        json
    \    Log    ${Converted_JSON}
    \    
    \    ${dateDetails_Null}    Run Keyword And Return Status    Should Be Equal As Strings    ${DateDetails_List}    None
    \    
    \    Run Keyword If    ${dateDetails_Null}==${True}    Append To File    ${JSON_File}    ${EMPTY}
         ...    ELSE IF    ${File_Empty}==${True}    Append To File    ${JSON_File}    ${Converted_JSON}
         ...    ELSE    Append To File    ${JSON_File}    ,${Converted_JSON}
    \    Log    ${JSON_File}
    \    ${File}    OperatingSystem.Get File    ${JSON_File}
    \    
    \    ### Create Individual JSON per calendar id###
    \    Delete File If Exist    ${datasetpath}${sInputFilePath}${sInputJSON}_ID_${CalendarID_Unique}.${JSON}
    \    Run Keyword If    ${dateDetails_Null}!=${True}    Create File    ${datasetpath}${sInputFilePath}${sInputJSON}_ID_${CalendarID_Unique}.${JSON}    ${Converted_JSON}
    ${File}    OperatingSystem.Get File    ${JSON_File}
    Log    ${File}
    ${Converted_File}    Catenate    SEPARATOR=    [    ${File}    ]
    Delete File If Exist    ${JSON_File}
    Create File    ${JSON_File}    ${Converted_File}

Get File Name From Archive List
    [Documentation]    This keyword is used to get file name from Archive List using File_1, File_2 or Misc as sFileType.
    ...    @author: clanding    15JUL2019    - initial create
    [Arguments]    ${aArchiveList}    ${sFileType}
    
    :FOR    ${File}    IN    @{aArchiveList}
    \    
    \    ${File_Type}    Run Keyword If    '${sFileType}'=='File_1'    Set Variable    _1_
         ...    ELSE IF    '${sFileType}'=='File_2'    Set Variable    _2_
         ...    ELSE IF    '${sFileType}'=='Misc'    Set Variable    _Misc_
    \    
    \    ${File_Name}    Run Keyword If    '${sFileType}'=='File_1'    Set Variable    Holidays_Banks_
         ...    ELSE IF    '${sFileType}'=='File_2'    Set Variable    Holidays_Banks_
         ...    ELSE IF    '${sFileType}'=='Misc'    Set Variable    Holidays_Misc
    \    
    \    ${XLS_File}    Run Keyword And Return Status    Should Contain    ${File}    ${File_Type}
    \    ${Holidays_Banks}    Run Keyword And Return Status    Should Contain    ${File}    ${File_Name}
    \    Exit For Loop If    ${XLS_File}==${True} and ${Holidays_Banks}==${True}
    Set Global Variable    ${FILE1_ARCHIVE_NAME}    ${File}

Consolidate JSON for 3 XLS Files
    [Documentation]    This keyword is used to consolidate json files for 3 XLS files and create 1 json file.
    ...    @author: clanding    15JUL2019    - initial create
    ...    @update: clanding    25JUL2019    - added condition wherein all files are not empty
    [Arguments]    ${sInputFilePath}    ${sInputJSON}
    
    ${JSONFile1}    OperatingSystem.Get File    ${datasetpath}${sInputFilePath}${sInputJSON}_${File_1}.${JSON}
    ${JSONFile1}    Strip String    ${JSONFile1}    mode=left    characters=[
    ${JSONFile1}    Strip String    ${JSONFile1}    mode=right    characters=]
    
    ${JSONFile2}    OperatingSystem.Get File    ${datasetpath}${sInputFilePath}${sInputJSON}_${File_2}.${JSON}
    ${JSONFile2}    Strip String    ${JSONFile2}    mode=left    characters=[
    ${JSONFile2}    Strip String    ${JSONFile2}    mode=right    characters=]
    
    ${JSONFileMisc}    OperatingSystem.Get File    ${datasetpath}${sInputFilePath}${sInputJSON}_${Misc_File}.${JSON}
    ${JSONFileMisc}    Strip String    ${JSONFileMisc}    mode=left    characters=[
    ${JSONFileMisc}    Strip String    ${JSONFileMisc}    mode=right    characters=]
    
    ${JSONFile1_Empty}    Run Keyword And Return Status    Should Be Empty    ${JSONFile1}
    ${JSONFile2_Empty}    Run Keyword And Return Status    Should Be Empty    ${JSONFile2}
    ${JSONFileMisc_Empty}    Run Keyword And Return Status    Should Be Empty    ${JSONFileMisc}
    
    ${Consolidated_JSON}    Run Keyword If    ${JSONFile1_Empty}==${True} and ${JSONFile2_Empty}==${False} and ${JSONFileMisc_Empty}==${False}    Catenate    SEPARATOR=,    ${JSONFile2}    ${JSONFileMisc}
    ...    ELSE IF    ${JSONFile1_Empty}==${False} and ${JSONFile2_Empty}==${True} and ${JSONFileMisc_Empty}==${False}    Catenate    SEPARATOR=,    ${JSONFile1}    ${JSONFileMisc}
    ...    ELSE IF    ${JSONFile1_Empty}==${False} and ${JSONFile2_Empty}==${False} and ${JSONFileMisc_Empty}==${True}    Catenate    SEPARATOR=,    ${JSONFile1}   ${JSONFile2}
    ...    ELSE IF    ${JSONFile1_Empty}==${True} and ${JSONFile2_Empty}==${True} and ${JSONFileMisc_Empty}==${False}    Set Variable    ${JSONFileMisc}
    ...    ELSE IF    ${JSONFile1_Empty}==${False} and ${JSONFile2_Empty}==${True} and ${JSONFileMisc_Empty}==${True}    Set Variable    ${JSONFile1}
    ...    ELSE IF    ${JSONFile1_Empty}==${True} and ${JSONFile2_Empty}==${False} and ${JSONFileMisc_Empty}==${True}    Set Variable    ${JSONFile2}
    ...    ELSE IF    ${JSONFile1_Empty}==${False} and ${JSONFile2_Empty}==${False} and ${JSONFileMisc_Empty}==${False}    Catenate    SEPARATOR=,    ${JSONFile1}    ${JSONFile2}    ${JSONFileMisc}
    ...    ELSE    Set Variable    ${EMPTY}
    
    ${Consolidated_JSON_Empty}    Run Keyword And Return Status    Should Be Empty    ${Consolidated_JSON}
    ${Consolidated_JSON}    Run Keyword If    ${Consolidated_JSON_Empty}==${True}    Set Variable    ${EMPTY}
    ...    ELSE    Catenate    [    ${Consolidated_JSON}    ]
    Create File    ${datasetpath}${sInputFilePath}${sInputJSON}.${JSON}    ${Consolidated_JSON}        

Create XML Using Expected JSON File
    [Documentation]    This keyword is used to create Expected XML for TL Calendar Using JSON file.
    ...    @author: clanding    16JUL2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sInputJSON}    ${sExpectedXML}
    
    ### Get All JSON with Calendar ID ###
    ${CalendarID_FileList}    Create List
    ${File_List}    OperatingSystem.List Files In Directory    ${datasetpath}${sInputFilePath}
    ${File_List_Count}    Get Length    ${File_List}
    :FOR    ${File}    IN    @{File_List}
    \    ${FileName_with_CalendarID}    Run Keyword And Return Status    Should Contain    ${File}    ${sInputJSON}_ID_
    \    Run Keyword If    ${FileName_with_CalendarID}==${True}    Append To List    ${CalendarID_FileList}    ${File}
         ...    ELSE    Append To List    ${CalendarID_FileList}
    \    Log    ${CalendarID_FileList}
    Log    ${CalendarID_FileList}
    
    :FOR    ${File_with_CalendarID}    IN    @{CalendarID_FileList}
    \    ${JSON}    Load JSON From File    ${datasetpath}${sInputFilePath}${File_with_CalendarID}
    \    ${dateDetails}    Get Value From Json    ${JSON}    $..dateDetails
    \    Log    ${dateDetails}
    \    Create XML for Date Details Section    ${sInputFilePath}    ${sExpectedXML}    ${JSON}    ${dateDetails}

Create XML for Date Details Section
    [Documentation]    This keyword is used to create Expected XML for dateDetails section of the payload.
    ...    @author: clanding    16JUL2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sExpectedXML}    ${oJSON}    ${aDateDetails}
    
    ${CalendarID_List}    Get Value From Json    ${oJSON}    $..calendarId
    ${CalendarID}    Get From List    ${CalendarID_List}    0
    ${Year_List}    Get Value From Json    ${aDateDetails}    $..year
    ${NBD_Year_List}    Get Value From Json    ${aDateDetails}    $..nonBusinessDates
    ${SBD_Year_List}    Get Value From Json    ${aDateDetails}    $..specialBusinessDates
    
    Log    ${Year_List}
    ${Year_List_Count}    Get Length    ${Year_List}
    :FOR    ${Year_Index}    IN RANGE    ${Year_List_Count}
    \    ${Year}    Get From List    ${Year_List}    ${Year_Index}
    \    ${NBD_List}    Get From List    ${NBD_Year_List}    ${Year_Index}
    \    Create XML for Non Business Dates Section    ${sInputFilePath}    ${sExpectedXML}    ${CalendarID}    ${NBD_List}
    \    ${SBD_List}    Get From List    ${SBD_Year_List}    ${Year_Index}
    \    Create XML for Special Business Dates Section    ${sInputFilePath}    ${sExpectedXML}    ${CalendarID}    ${SBD_List}

Create XML for Non Business Dates Section
    [Documentation]    This keyword is used to create Expected XML for nonBusinessDates section of the payload.
    ...    @author: clanding    16JUL2019    - initial create
    ...    @update: clanding    30JUL2019    - updated XML template path to a single variable name '${TEMPLATE_UPDATE_XML_CAL}'
    ...    @update: clanding    31JUL2019    - added handling for CreateHolidayCalendarDate
    [Arguments]    ${sInputFilePath}    ${sExpectedXML}    ${sCalendarID}    ${aNonBusinessDates}
    
    :FOR    ${NBD_Dict}    IN    @{aNonBusinessDates}
    \    ${NBD_dateValue}    Get From Dictionary    ${NBD_Dict}    dateValue
    \    ${NBD_reason}    Get From Dictionary    ${NBD_Dict}    reason
    \    
    \    ${DB_Row_Count}    Verify NBD List if Existing in LIQ DB and Return Row Count    ${sCalendarID}    ${NBD_dateValue}
    \    
    \    ${Expected_wsFinalLIQDestination}    Set Variable    ${dataset_path}${sInputFilePath}${sExpectedXML}_${sCalendarID}_${NBD_dateValue}.xml
    \    Delete File If Exist    ${Expected_wsFinalLIQDestination}
    \    ${Template}    Run Keyword If    ${DB_Row_Count}==1    Set Variable    ${TEMPLATE_UPDATE_XML_CAL}
         ...    ELSE    Set Variable    ${TEMPLATE_CREATE_XML_CAL}
    \    ${XPath}    Run Keyword If    ${DB_Row_Count}==1    Set Variable    UpdateHolidayCalendarDate
         ...    ELSE    Set Variable    CreateHolidayCalendarDate
    \    ${Updated_Template}    Set Element Attribute    ${Template}    cHolidayCode    ${sCalendarID}    xpath=${XPath}
    \    ${Updated_Template}    Set Element Attribute    ${Updated_Template}    description    ${NBD_reason}    xpath=${XPath}
    \    ${Updated_Template}    Set Element Attribute    ${Updated_Template}    cHolidayDate    ${NBD_dateValue}    xpath=${XPath}
    \    ${Updated_Template}    Set Element Attribute    ${Updated_Template}    activeIndicator    Y    xpath=${XPath}
    \    Save Xml    ${Updated_Template}    ${Expected_wsFinalLIQDestination}

Create XML for Special Business Dates Section
    [Documentation]    This keyword is used to create Expected XML for specialBusinessDates section of the payload.
    ...    @author: clanding    16JUL2019    - initial create
    ...    @update: clanding    30JUL2019    - updated XML template path to a single variable name '${TEMPLATE_UPDATE_XML_CAL}'
    [Arguments]    ${sInputFilePath}    ${sExpectedXML}    ${sCalendarID}    ${aSpecialBusinessDates}
    
    :FOR    ${SBD_Dict}    IN    @{aSpecialBusinessDates}
    \    ${SBD_dateValue}    Get From Dictionary    ${SBD_Dict}    dateValue
    \    ${SBD_reason}    Get From Dictionary    ${SBD_Dict}    reason
    \    
    \    ${Expected_wsFinalLIQDestination}    Set Variable    ${dataset_path}${sInputFilePath}${sExpectedXML}_${sCalendarID}_${SBD_dateValue}.xml
    \    Delete File If Exist    ${Expected_wsFinalLIQDestination}
    \    ${Template}    Set Variable    ${TEMPLATE_UPDATE_XML_CAL}
    \    ${XPath}    Set Variable    UpdateHolidayCalendarDate
    \    ${Updated_Template}    Set Element Attribute    ${Template}    cHolidayCode    ${sCalendarID}    xpath=${XPath}
    \    ${Updated_Template}    Set Element Attribute    ${Updated_Template}    description    ${SBD_reason}    xpath=${XPath}
    \    ${Updated_Template}    Set Element Attribute    ${Updated_Template}    cHolidayDate    ${SBD_dateValue}    xpath=${XPath}
    \    ${Updated_Template}    Set Element Attribute    ${Updated_Template}    activeIndicator    N    xpath=${XPath}
    \    Save Xml    ${Updated_Template}    ${Expected_wsFinalLIQDestination}

Get Date Details Values in Input and Verify if Existing in Output File
    [Documentation]    This keyword is used to get dateDetails values from input file and verify if existing in output file.
    ...    @author: clanding    24JUL2019    - initial create
    [Arguments]    ${oInputJSON}    ${oOutputJSON}
    
    ${dateDetails_List_Input}    Get From Dictionary    ${oInputJSON}    dateDetails
    ${dateDetails_List_Output}    Get From Dictionary    ${oOutputJSON}    dateDetails
    ${dateDetails_Count}    Get Length    ${dateDetails_List_Input}
    
    ${Year_NBD_Dict_Input}    Create Dictionary
    ${Year_NBD_Dict_Output}    Create Dictionary
    ${Year_SBD_Dict_Input}    Create Dictionary
    ${Year_SBD_Dict_Output}    Create Dictionary
    ${Year_List}    Create List
    :FOR    ${Index}    IN RANGE    ${dateDetails_Count}
    \    ${dateDetails_Input}    Get From List    ${dateDetails_List_Input}    ${Index}
    \    ${dateDetails_Output}    Get From List    ${dateDetails_List_Output}    ${Index}
    \    ${nonBusinessDates_List_Input}    Get From Dictionary    ${dateDetails_Input}    nonBusinessDates
    \    ${nonBusinessDates_List_Output}    Get From Dictionary    ${dateDetails_Output}    nonBusinessDates
    \    ${specialBusinessDates_List_Input}    Get From Dictionary    ${dateDetails_Input}    specialBusinessDates
    \    ${specialBusinessDates_List_Output}    Get From Dictionary    ${dateDetails_Output}    specialBusinessDates
    \    ${year_Input}    Get From Dictionary    ${dateDetails_Input}    year
    \    ${year_Output}    Get From Dictionary    ${dateDetails_Output}    year
    \    ${year_Input}    Convert To String    ${year_Input}
    \    ${year_Output}    Convert To String    ${year_Output}
    \    Set To Dictionary    ${Year_NBD_Dict_Input}    ${year_Input}=${nonBusinessDates_List_Input}
    \    Set To Dictionary    ${Year_NBD_Dict_Output}    ${year_Output}=${nonBusinessDates_List_Output}
    \    Set To Dictionary    ${Year_SBD_Dict_Input}    ${year_Input}=${specialBusinessDates_List_Input}
    \    Set To Dictionary    ${Year_SBD_Dict_Output}    ${year_Output}=${specialBusinessDates_List_Output}
    \    Append To List    ${Year_List}    ${year_Output}
    Log    ${Year_NBD_Dict_Input}
    Log    ${Year_NBD_Dict_Output}
    
    :FOR    ${Year}    IN    @{Year_List}
    \    ${nonBusinessDates_List_Input}    Get From Dictionary    ${Year_NBD_Dict_Input}    ${Year}
    \    ${nonBusinessDates_List_Output}    Get From Dictionary    ${Year_NBD_Dict_Output}    ${Year}
    \    Get Business Date Values and Compare to Output    ${nonBusinessDates_List_Input}    ${nonBusinessDates_List_Output}
    \    
    \    ${specialBusinessDates_List_Input}    Get From Dictionary    ${Year_SBD_Dict_Input}    ${Year}
    \    ${specialBusinessDates_List_Output}    Get From Dictionary    ${Year_SBD_Dict_Output}    ${Year}
    \    Get Business Date Values and Compare to Output    ${specialBusinessDates_List_Input}    ${specialBusinessDates_List_Output}

Get Business Date Values and Compare to Output
    [Documentation]    This keyword is used to get nonBusinessDates values from input file and verify if existing in output file.
    ...    @author: clanding    24JUL2019    - initial create
    [Arguments]    ${aBusinessDates_List}    ${oJSON_Output}
    
    :FOR    ${BusinessDates}    IN    @{aBusinessDates_List}
    \    Run Keyword And Continue On Failure    Should Contain    ${oJSON_Output}    ${BusinessDates}
    \    ${Status}    Run Keyword And Return Status    Should Contain    ${oJSON_Output}    ${BusinessDates}
    \    Run Keyword If    ${Status}==${True}    Log    '${BusinessDates}' is existing in output json '${oJSON_Output}'.
         ...    ELSE    Log    '${BusinessDates}' is NOT existing in output json '${oJSON_Output}'.    level=ERROR

Verify NBD List if Existing in LIQ DB and Return Row Count
    [Documentation]    This keyword is used to validate if Non Business Date List is existing in Loan IQ database and return row count.
    ...    @author: clanding    31JUL2019    - initial create
    ...    @update: clanding    08AUG2019    - removing HCD_IND_ACTIVE in the query
    [Arguments]    ${sCalendarID}    ${sDateValue}
    
    ${dateValue_LIQ_Format}    Convert Date With Zero    ${sDateValue}
    ${Query_NBD}    Catenate    SELECT * FROM ${LIQ7474_USER}.${TLS_HOL_CAL_DATES_TABLE} WHERE ${HCD_CDE_HOL_CAL}='${sCalendarID}' 
    ...    AND ${HCD_DTE_HOL_CAL}='${dateValue_LIQ_Format}'
    ${Query_NBD_RowCount}    Connect to LIQ Database and Return Row Count    ${Query_NBD}
    [Return]    ${Query_NBD_RowCount}

Create Expected Response for Empty Payload
    [Documentation]    This keyword is used to create expected response when json payload is empty.
    ...    @author: clanding    05AUG2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sFileName}
    
    ###Manually split file name###
    Log    ${FILE1_ARCHIVE_NAME}
    ${Request_ID}    Remove String    ${FILE1_ARCHIVE_NAME}    Holidays_    .${XLS}
    
    ${Json_Object}    Load JSON From File    ${TEMPLATE_JSON_CAL}
    Set To Dictionary    ${Json_Object}    apiName=${CALENDAR_APINAME}
    Set To Dictionary    ${Json_Object}    requestId=${Request_ID}
    Set To Dictionary    ${Json_Object}    consolidationStatus=${OPEARATIONSTATUS_SUCCESS}
    
    ${responseDetails_Dict}    Create Dictionary    responseDescription=${EMPTY_PAYLOAD_RESPONSE}    messageId=${EMPTY_PAYLOAD_MSG_ID}
    ...    responseStatus=${OPEARATIONSTATUS_SUCCESS}
    
    ${responseDetails_List}    Create List    ${responseDetails_Dict}
    ${responses_Dict}    Create Dictionary    responseDetails=${responseDetails_List}
    ${responses_List}    Create List    ${responses_Dict}
    Set To Dictionary    ${Json_Object}    responses=${responses_List}
    ${Converted_Json}    Evaluate    json.dumps(${Json_Object})    json
    Delete File If Exist    ${datasetpath}${sInputFilePath}${sFileName}.${JSON}
    Create File    ${datasetpath}${sInputFilePath}${sFileName}.${JSON}    ${Converted_Json}

Generate Random Calendar ID and Return
    [Documentation]    This keyword is used to generate new Calendar ID and Add into Loan IQ.
    ...    @author: jloretiz    16AUG2019    - initial create
    ...    @Update: dahijara    04OCT2019    - Updated code for getting value for 2-code country and description as the Get Row Values no longer returns the cell ID
    ...    @update: jloretiz    26NOV2019    - add the keyword to close the current excel document
    [Arguments]    ${sFileType}
    
    Open Excel    ${Countries_Codes}
    ${RowCount}    Get Row Count    countries_codes
    
	###Loop Continuously until Adding of Calendar ID is successful###
    :FOR    ${Index}    IN RANGE    99
    \    ${ThreeString}    Generate Random String    3    [UPPER]
    \    @{RandomNumber}    Evaluate    random.sample(range(2, ${RowCount}), 1)    random
    \    ${RowValue}    Get Row Values    countries_codes    @{RandomNumber}[0]
    # \    ${TwoCode}    Get From List    ${RowValue}    1
    # \    ${FinalTwoCode}    Get From List    ${TwoCode}     1
    \    ${FinalTwoCode}    Get From List    ${RowValue}    1
    \    ${FinalTwoCode}    Strip String    ${FinalTwoCode}    mode=both    characters=${SPACE}
    \    ${Calendar_ID}=    Catenate    SEPARATOR=    ${FinalTwoCode}    ${ThreeString}
    # \    ${Country}    Get From List    ${RowValue}    2
    # \    ${FinalCountry}    Get From List    ${Country}     1
    \    ${FinalCountry}    Get From List    ${RowValue}    2
    \    ${FinalCountry}    Strip String    ${FinalCountry}    mode=both    characters=${SPACE}
    \    ${Row_Count}    Add New Calendar ID    ${Calendar_ID}    GDE ${FinalCountry}    New Calendar ID    sFriBusDay=Y
    \    Exit For Loop If    ${Row_Count}==0
    
    ###Adds Additional one Character if MISC File###
    ${AdditionalString}    Run Keyword If    '${sFileType}'=='Misc'    Generate Random String    1    [UPPER]
    ${Calendar_ID}         Run Keyword If    '${sFileType}'=='Misc'    Catenate    SEPARATOR=    ${Calendar_ID}    ${AdditionalString}
    ...    ELSE    Set Variable    ${Calendar_ID}
    Close Current Excel Document        

    [Return]    ${Calendar_ID}

Write Data To Excel for New Calendar ID
    [Documentation]    This keyword will dynamically store data for ISOCountryCode and CentreCode or ISOMicCode in Excel file.
    ...    @author: jloretiz    19AUG2019     - initial create
    ...    @update:.jloretiz    26NOV2019     - add the keyword to close the current excel document
    [Arguments]    ${sSheetName}    ${sColumn_ISOCountryCode}    ${sColumn_CentreCode}    ${sColumn_ISOMicCode}    ${sCalendar_ID}    ${sFile1_XLSXFile}    ${sFile2_XLSXFile}    ${sMisc_XLSXFile}    ${sFileType}
    
    ${XlsxFile}    Run Keyword If    '${sFileType}'=='${File_1}'    Set Variable    ${sFile1_XLSXFile}
    ...    ELSE IF    '${sFileType}'=='${File_2}'       Set Variable    ${sFile2_XLSXFile}
    ...    ELSE IF    '${sFileType}'=='${Misc_File}'    Set Variable    ${sMisc_XLSXFile}
    
    Open Excel    ${XlsxFile}
    ${ColumnCount}    Get Column Count    ${sSheetName}
    ${RowCount}    Get Row Count    ${sSheetName}
    
    ###Returns the column index for the columns to be modified###
    ${Col_ISO}    ${Col_CentreMic}    Loop Over Column and Return    ${ColumnCount}    ${sSheetName}    ${sColumn_ISOCountryCode}    ${sColumn_CentreCode}    ${sColumn_ISOMicCode}    ${sFileType} 
    
    ###Separate ISOCountryCode and CentreCode or ISOMicCode from new Calendar ID###
    ${ISOCountryCode}    Get Substring   ${sCalendar_ID}    0    2
    ${CentreMicCode}     Run Keyword If    '${sFileType}'=='Misc'    Get Substring   ${sCalendar_ID}    2    6
    ...    ELSE    Get Substring   ${sCalendar_ID}    2    5
    
    :FOR    ${Row}    IN RANGE    1    ${RowCount}
    \    Put String To Cell    ${sSheetName}    ${Col_ISO}          ${Row}    ${ISOCountryCode}
    \    Put String To Cell    ${sSheetName}    ${Col_CentreMic}    ${Row}    ${CentreMicCode}
    
    Save Excel    ${XlsxFile}
    Close Current Excel Document
    
Loop Over Column and Return
    [Documentation]    This keyword will loop and locate the column/s that will be updated for File 1, File 2 and Misc File.
    ...    @author: jloretizo    19AUG2019     - initial create
    [Arguments]    ${iColumnCount}    ${sSheetName}    ${sColumn_ISOCountryCode}    ${sColumn_CentreCode}    ${sColumn_ISOMicCode}    ${sFileType}
    
    ###Get ISOCountryCode Column###
    :FOR    ${Col_Index}    IN RANGE    0    ${iColumnCount}
    \    ${header}    Read Cell Data By Coordinates    ${sSheetName}    ${Col_Index}    0
    \    ${Col_ISO}    Run Keyword If    "${header}"=="${sColumn_ISOCountryCode}"    Set Variable    ${Col_Index}
    \    Exit For Loop If    "${header}"=="${sColumn_ISOCountryCode}"
    
    ###Check if File is File 1, File 2 or Misc###
    ${Col_CentreMic}    Run Keyword If    '${sFileType}'=='Misc'    Loop Over ISOMicCode Column For Misc File and Return    ${iColumnCount}    ${sSheetName}    ${sColumn_ISOMicCode}
    ...    ELSE    Loop Over CentreCode Column For File 1 and File 2 and Return    ${iColumnCount}    ${sSheetName}    ${sColumn_CentreCode}

    [Return]     ${Col_ISO}    ${Col_CentreMic}
    
Loop Over CentreCode Column For File 1 and File 2 and Return
    [Documentation]    This keyword will loop and locate the column/s that will be updated for File 1 and File 2.
    ...    @author: jloretizo    19AUG2019     - initial create
    [Arguments]    ${iColumnCount}    ${sSheetName}    ${sColumn_CentreCode}
    
    :FOR    ${Col_Index}    IN RANGE    0    ${iColumnCount}
    \    ${header}    Read Cell Data By Coordinates    ${sSheetName}    ${Col_Index}    0
    \    ${Col_Centre}    Run Keyword If    "${header}"=="${sColumn_CentreCode}"    Set Variable    ${Col_Index}
    \    Exit For Loop If    "${header}"=="${sColumn_CentreCode}"

    [Return]    ${Col_Centre}
    
Loop Over ISOMicCode Column For Misc File and Return
    [Documentation]    This keyword will loop and locate the column/s that will be updated for Misc File.
    ...    @author: jloretizo    19AUG2019     - initial create
    [Arguments]    ${iColumnCount}    ${sSheetName}    ${sColumn_MicCode}
    
    :FOR    ${Col_Index}    IN RANGE    0    ${iColumnCount}
    \    ${header}    Read Cell Data By Coordinates    ${sSheetName}    ${Col_Index}    0
    \    ${Col_Mic}    Run Keyword If    "${header}"=="${sColumn_MicCode}"    Set Variable    ${Col_Index}
    \    Exit For Loop If    "${header}"=="${sColumn_MicCode}"

    [Return]    ${Col_Mic}
    
Get Random File and Return
    [Documentation]    This keyword will randomize what file will be used to add the newly created calendar ID
    ...    @author: jloretizo    21AUG2019     - initial create
    
    ${Files}    Create List    ${File_1}    ${File_2}    ${Misc_File}
    ${Random_File}  Evaluate  random.choice($Files)  random
    Log  [Random File]: ${Random_File}
    
    [Return]    ${Random_File}

Create Expected Response for File Validation Error
    [Documentation]    This keyword is used to create expected response when json payload is empty.
    ...    @author: dahijara    17DEC2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sFileName}
    
    ###Manually split file name###
    Log    ${FILE1_ARCHIVE_NAME}
    ${Request_ID}    Remove String    ${FILE1_ARCHIVE_NAME}    Holidays_    .${XLS}
    
    ${Json_Object}    Load JSON From File    ${TEMPLATE_JSON_CAL}
    Set To Dictionary    ${Json_Object}    apiName=${CALENDAR_APINAME}
    Set To Dictionary    ${Json_Object}    requestId=${Request_ID}
    Set To Dictionary    ${Json_Object}    consolidationStatus=${MESSAGESTATUS_FAILURE}
    
    ${responseDetails_Dict}    Create Dictionary    responseDescription=${FILE_VALIDATION_RESPONSE}    messageId=${FILE_VALIDATION_MSG_ID}
    ...    responseStatus=${MESSAGESTATUS_FAILURE}
    
    ${responseDetails_List}    Create List    ${responseDetails_Dict}
    ${responses_Dict}    Create Dictionary    responseDetails=${responseDetails_List}
    ${responses_List}    Create List    ${responses_Dict}
    Set To Dictionary    ${Json_Object}    responses=${responses_List}
    ${Converted_Json}    Evaluate    json.dumps(${Json_Object})    json
    Delete File If Exist    ${datasetpath}${sInputFilePath}${sFileName}.${JSON}
    Create File    ${datasetpath}${sInputFilePath}${sFileName}.${JSON}    ${Converted_Json}

Get File Name From Error List
    [Documentation]    This keyword is used to get file name from Archive List using File_1, File_2 or Misc as sFileType.
    ...    @author: dahijara    17JAN2020    - initial create
    [Arguments]    ${aArchiveList}    ${sFileType}
    
    :FOR    ${File}    IN    @{aArchiveList}
    \    
    \    ${File_Type}    Run Keyword If    '${sFileType}'=='File_1'    Set Variable    _1_
         ...    ELSE IF    '${sFileType}'=='File_2'    Set Variable    _2_
         ...    ELSE IF    '${sFileType}'=='Misc'    Set Variable    _Misc_    
    \    ${XLS_File}    Run Keyword And Return Status    Should Contain    ${File}    ${File_Type}
    \    Exit For Loop If    ${XLS_File}==${True}    
    
    Set Global Variable    ${FILE1_ARCHIVE_NAME}    ${File}
    