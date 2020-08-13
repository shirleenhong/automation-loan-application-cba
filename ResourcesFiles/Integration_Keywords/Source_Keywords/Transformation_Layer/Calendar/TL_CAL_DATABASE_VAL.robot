*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Get All Holiday Calendar Dates Records for Calendar ID
    [Documentation]    This keyword is used to get all the active holiday records for the given Calendar ID.
    ...    @author: clanding    28JUN2019    - initial creae
    [Arguments]    ${sCal_ID}
    
    ${Query}    Catenate    SELECT * FROM ${LIQ7474_USER}.${TLS_HOL_CAL_DATES_TABLE} WHERE ${HCD_CDE_HOL_CAL} = '${sCal_ID}'
    ${Cal_ID_DBCount}    Connect to LIQ Database and Return Row Count    ${Query}
    [Return]    ${Cal_ID_DBCount}

Get LIQ Business Date from Database
    [Documentation]    This keyword is used to get Loan IQ current business date and return.
    ...    @author: clanding    28JUN2019    - initial create
    [Arguments]    ${sZone}
    
    ${Query}    Catenate    SELECT ${ENV_TXT_VAR_VALUE} FROM ${TLS_ENVIRONMENT_TABLE} WHERE ${ENV_NME_VAR_CLASS} = '${sZone}' AND ${ENV_NME_VAR_NAME} = 'Current Business Date'
    
    ${Query_Res_EnvDate}    Connect to LIQ Database and Return Results    ${Query}
    ${SQL_EnvDate_Result_List}    Convert SQL Result to List and Return    ${Query_Res_EnvDate}
    ${Zone_Business_Date}    Get From List    ${SQL_EnvDate_Result_List}    0
    [Return]    ${Zone_Business_Date}

Get Calendar ID Status from Database
    [Documentation]    This keyword is used to get calendar id status from TLS_FAM_GLOBAL2_TABLE table and return.
    ...    @author: clanding    28JUN2019    - initial create
    [Arguments]    ${sCal_ID}
    
    ${Query_GetStatus}    Catenate    SELECT ${GB2_IND_ACTIVE} from ${LIQ7474_USER}.${TLS_FAM_GLOBAL2_TABLE} WHERE ${GB2_TID_TABLE_ID} = 'HCL'
    ...    AND ${GB2_CDE_CODE} = '${sCal_ID}'
    ${Query_GetStatus_Res}    Connect to LIQ Database and Return Results    ${Query_GetStatus}
    ${Cal_ID_Stat_Res_List}    Convert SQL Result to List and Return    ${Query_GetStatus_Res}
    ${Cal_ID_Stat_Count}    Get Length    ${Cal_ID_Stat_Res_List}
    ${Cal_ID_Status}    Run Keyword If    '${Cal_ID_Stat_Count}'!='0'    Get From List    ${Cal_ID_Stat_Res_List}    0
    ...    ELSE    Set Variable    None
    [Return]    ${Cal_ID_Status}
    
Get Calendar ID Description from Database
    [Documentation]    This keyword is used to get calendar id description from TLS_FAM_GLOBAL2_TABLE table and return.
    ...    @author: clanding    28JUN2019    - initial create
    [Arguments]    ${sCal_ID}
    
    ${Query_GetDescription}    Catenate    SELECT ${GB2_DSC_CODE} FROM ${LIQ7474_USER}.${TLS_FAM_GLOBAL2_TABLE} WHERE ${GB2_TID_TABLE_ID} = 'HCL'
    ...    AND ${GB2_CDE_CODE} = '${sCal_ID}'
    ${Query_GetDescription_Res}    Connect to LIQ Database and Return Results    ${Query_GetDescription}
    ${Cal_ID_Desc_Res_List}    Convert SQL Result to List and Return    ${Query_GetDescription_Res}
    ${Cal_ID_Desc_Count}    Get Length    ${Cal_ID_Desc_Res_List}
    ${Cal_ID_Desc}    Run Keyword If    '${Cal_ID_Desc_Count}'!='0'    Get From List    ${Cal_ID_Desc_Res_List}    0
    ...    ELSE    Set Variable    None
    [Return]    ${Cal_ID_Desc}
    
Get Status from Holiday Calendar Dates table in Database
    [Documentation]    This keyword is used to get holiday calendar dates status from TLS_HOL_CAL_DATES table
    ...    sHol_Date format should be %d-%b-%Y (i.e. 01-JAN-18).
    ...    @author: clanding    28JUN2019    - initial create
    [Arguments]    ${sCal_ID}    ${sHol_Date}
    
    ${Query}    Catenate    SELECT ${HCD_IND_ACTIVE} FROM ${LIQ7474_USER}.${TLS_HOL_CAL_DATES_TABLE} 
    ...    WHERE ${HCD_CDE_HOL_CAL} = '${sCal_ID}' AND ${HCD_DTE_HOL_CAL}='${sHol_Date}'
    
    ${Query_Result}    Connect to LIQ Database and Return Results    ${Query}
    ${Count}    Get Length    ${Query_Result}
    ${Hol_Date_Status_DB}    Run Keyword If    '${Count}'!='0'    Get From List    ${Query_Result}    0
    [Return]    ${Hol_Date_Status_DB}

Get Event Name from Holiday Calendar Dates table in Database
    [Documentation]    This keyword is used to get holiday calendar dates event name from TLS_HOL_CAL_DATES table
    ...    sHol_Date format should be %d-%b-%Y (i.e. 01-JAN-18).
    ...    @author: clanding    28JUN2019    - initial create
    [Arguments]    ${sCal_ID}    ${sHol_Date}
    
    ${Query}    Catenate    SELECT ${HCD_DSC_HOL_CAL} FROM ${LIQ7474_USER}.${TLS_HOL_CAL_DATES_TABLE} 
    ...    WHERE ${HCD_CDE_HOL_CAL} = '${sCal_ID}' AND ${HCD_DTE_HOL_CAL}='${sHol_Date}'
    
    ${Query_Result}    Connect to LIQ Database and Return Results    ${Query}
    ${Count}    Get Length    ${Query_Result}
    ${Hol_Date_EventName_DB}    Run Keyword If    '${Count}'!='0'    Get From List    ${Query_Result}    0
    [Return]    ${Hol_Date_EventName_DB}

Get Event Date and Name from Holiday Calendar Dates table in Database
    [Documentation]    This keyword is used to get holiday calendar dates event date and name from TLS_HOL_CAL_DATES table
    ...    @author: clanding    28JUN2019    - initial create
    [Arguments]    ${sCal_ID}
    
    ${Query}    Catenate    SELECT ${HCD_DTE_HOL_CAL}, ${HCD_DSC_HOL_CAL}, ${HCD_IND_ACTIVE} FROM ${LIQ7474_USER}.${TLS_HOL_CAL_DATES_TABLE} 
    ...    WHERE ${HCD_CDE_HOL_CAL} = '${sCal_ID}'
    
    ${Query_ResultList}    Connect to LIQ Database and Return Results    ${Query}
    [Return]    ${Query_ResultList}

Validate Holiday Calendar Dates in Loan IQ Database
    [Documentation]    This keyword is used to validate added Non Business Dates (activated/newly added/updated) and Special Business Dates (inactivated) in LIQ Database.
    ...    @author: clanding    25JUL2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sInputJSONFile}
    
    ${InputJSONFile}    OperatingSystem.Get File    ${dataset_path}${sInputFilePath}${sInputJSONFile}.json    
    ${InputJSONFile}    Strip String    ${InputJSONFile}    mode=left    characters=[
    ${InputJSONFile}    Strip String    ${InputJSONFile}    mode=right    characters=]
    Log    ${InputJSONFile}
    
    ${InputJSONFile_List}    Split String    ${InputJSONFile}    },{
    Log    ${InputJSONFile_List}
    ${JsonCount}    Get Length    ${InputJSONFile_List}
    :FOR    ${Index}    IN RANGE    ${JsonCount}
    \    ${LastIndex}    Evaluate    ${JsonCount}-1    
    \    ${JSON_Value}    Get From List    ${InputJSONFile_List}    ${Index}
    \    ${IsEvenOrOdd}    Evaluate    int('${Index}')%2
    \    ${JSON_Value}    Run Keyword If    ${IsEvenOrOdd}==0 and ${Index}==0 and ${LastIndex}!=0    Catenate    SEPARATOR=    ${JSON_Value}    }
         ...    ELSE IF    ${IsEvenOrOdd}==0 and ${Index}==0 and ${LastIndex}==0    Set Variable    ${JSON_Value}
         ...    ELSE IF    ${IsEvenOrOdd}==0 and ${Index}==${LastIndex}    Catenate    SEPARATOR=    {    ${JSON_Value}
         ...    ELSE IF    ${IsEvenOrOdd}==1 and ${Index}==${LastIndex}    Catenate    SEPARATOR=    {    ${JSON_Value}
         ...    ELSE    Catenate    SEPARATOR=    {    ${JSON_Value}    }
    \    Log    ${JSON_Value}
    \    Create File    ${dataset_path}${sInputFilePath}tempfile.json    ${JSON_Value}
    \    ${OutputJSON}    Load JSON From File    ${dataset_path}${sInputFilePath}tempfile.json
    \    ${Val_calendarId}    Get From Dictionary    ${OutputJSON}    calendarId
    \    ${InputJSON}    Load JSON From File    ${dataset_path}${sInputFilePath}${sInputJSONFile}_ID_${Val_calendarId}.json
    \    ${CalendarID}    Get From Dictionary    ${InputJSON}    calendarId
    \    Get Date Details Values in Input and Verify if Existing in LoanIQ DB    ${InputJSON}    ${CalendarID}
    \    Delete File If Exist    ${dataset_path}${sInputFilePath}tempfile.json

Validate Empty JSON File For Holiday Calendar Dates
    [Documentation]    This keyword is used to validate that the created JSON File should be empty.
    ...    @author: jloretiz    23Aug2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sInputJSONFile}
    
    ${InputJSONFile}    OperatingSystem.Get File    ${dataset_path}${sInputFilePath}${sInputJSONFile}.json    
    ${InputJSONFile}    Strip String    ${InputJSONFile}    mode=left    characters=[
    ${InputJSONFile}    Strip String    ${InputJSONFile}    mode=right    characters=]
    Log    ${InputJSONFile}
    
    ${InputJSONFile_List}    Split String    ${InputJSONFile}    },{
    Log    ${InputJSONFile_List}
    ${JsonCount}    Get Length    ${InputJSONFile_List}
    :FOR    ${Index}    IN RANGE    ${JsonCount}
    \    ${LastIndex}    Evaluate    ${JsonCount}-1    
    \    ${JSON_Value}    Get From List    ${InputJSONFile_List}    ${Index}
    \    ${IsEvenOrOdd}    Evaluate    int('${Index}')%2
    \    ${JSON_Value}    Run Keyword If    ${IsEvenOrOdd}==0 and ${Index}==0 and ${LastIndex}!=0    Catenate    SEPARATOR=    ${JSON_Value}    }
         ...    ELSE IF    ${IsEvenOrOdd}==0 and ${Index}==0 and ${LastIndex}==0    Set Variable    ${JSON_Value}
         ...    ELSE IF    ${IsEvenOrOdd}==0 and ${Index}==${LastIndex}    Catenate    SEPARATOR=    {    ${JSON_Value}
         ...    ELSE IF    ${IsEvenOrOdd}==1 and ${Index}==${LastIndex}    Catenate    SEPARATOR=    {    ${JSON_Value}
         ...    ELSE    Catenate    SEPARATOR=    {    ${JSON_Value}    }
    \    Log    ${JSON_Value}
    \    Create File    ${dataset_path}${sInputFilePath}tempfile.json    ${JSON_Value}
    \    File Should Be Empty    ${dataset_path}${sInputFilePath}tempfile.json
    \    Delete File If Exist    ${dataset_path}${sInputFilePath}tempfile.json

Get Date Details Values in Input and Verify if Existing in LoanIQ DB
    [Documentation]    This keyword is used to get dateDetails values from input file and verify if existing in Loan IQ database.
    ...    @author: clanding    25JUL2019    - initial create
    [Arguments]    ${oInputJSON}    ${sCalendarId}
    
    ${dateDetails_List}    Get From Dictionary    ${oInputJSON}    dateDetails
    ${dateDetails_Count}    Get Length    ${dateDetails_List}
    
    :FOR    ${dateDetails}    IN    @{dateDetails_List}
    \    ${nonBusinessDates_List}    Get From Dictionary    ${dateDetails}    nonBusinessDates
    \    ${specialBusinessDates_List}    Get From Dictionary    ${dateDetails}    specialBusinessDates
    \    Validate Holiday Dates in LoanIQ DB    ${nonBusinessDates_List}    ${sCalendarId}    Y
    \    Validate Holiday Dates in LoanIQ DB    ${specialBusinessDates_List}    ${sCalendarId}    N

Validate Holiday Dates in LoanIQ DB
    [Documentation]    This keyword is used to check if nonBusinessDates/specialBusinessDates section of the payload is existing in LoanIQ DB.
    ...    @author: clanding    25JUL2019    - initial create
    [Arguments]    ${aNBD_SBD_List}    ${sCalendarID}    ${sStatus}
    
    :FOR    ${NBD_SBD_Dict}    IN    @{aNBD_SBD_List}
    \    ${dateValue}    Get From Dictionary    ${NBD_SBD_Dict}    dateValue
    \    ${dateValue}    Convert Date    ${dateValue}    result_format=%d-%b-%Y
    \    ${reason}    Get From Dictionary    ${NBD_SBD_Dict}    reason
    \    
    \    ${Contains_Apostrophe}    Run Keyword And Return Status    Should Contain    ${reason}    '
    \    ${reason}    Run Keyword If    ${Contains_Apostrophe}==${True}    Replace String    ${reason}    '    ''
         ...    ELSE    Set Variable    ${reason}
    \    
    \    ${Query}    Catenate    SELECT * FROM ${LIQ7474_USER}.${TLS_HOL_CAL_DATES_TABLE} WHERE ${HCD_CDE_HOL_CAL}='${sCalendarID}' AND ${HCD_DSC_HOL_CAL} LIKE '%${reason}%' 
         ...    AND HCD_DTE_HOL_CAL='${dateValue}' AND ${HCD_IND_ACTIVE}='${sStatus}'
    \    
    \    ${HolidayStatus}    Run Keyword If    '${sStatus}'=='Y'    Set Variable    Active
         ...    ELSE    Set Variable    Inactive
    \    ${Holiday_Count}    Connect to LIQ Database and Return Row Count    ${Query}
    \    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${Holiday_Count}    1        
    \    Run Keyword If    '${Holiday_Count}'=='1'    Log    Holiday Calendar '${sCalendarID}' with Holiday Date of '${dateValue}' and Description of '${reason}' with '${HolidayStatus}' status is existing in Loan IQ Database.
        ...    ELSE    Log    Holiday Calendar '${sCalendarID}' with Holiday Date of '${dateValue}' and Description of '${reason}' with '${HolidayStatus}' status is NOT existing in Loan IQ Database.    level=ERROR

Validate Holiday Calendar Dates is Not Reflected in Loan IQ Database
    [Documentation]    This keyword is used to validate that Non Business Dates (activated/newly added/updated) and 
    ...    Special Business Dates (inactivated) are not reflected in LIQ Database.
    ...    @author: dahijara    09DEC2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sInputGSFile}    ${sDelimiter}=None

    @{InputGSFile_List}    Run Keyword If    '${sDelimiter}'=='None'    Split String    ${sInputGSFile}    ,
    ...    ELSE    Split String    ${sInputGSFile}    ${sDelimiter}
    
    ### Get XLSX Files###
    ${InputGSFile_XLSXList}    Create List
    :FOR    ${XLSXFile}    IN    @{InputGSFile_List}
    \    ${Contains_XLSX}    Run Keyword And Return Status    Should Contain    ${XLSXFile}    ${XLSX}
    \    Run Keyword If    ${Contains_XLSX}==${True}    Append To List    ${InputGSFile_XLSXList}    ${XLSXFile}
         ...    ELSE    Append To List    ${InputGSFile_XLSXList}

    :FOR    ${GSFileName_XLSX}    IN    @{InputGSFile_XLSXList}
    \    Validate Holiday Date Does Not Exist in LoanIQ DB    ${sInputFilePath}    ${GSFileName_XLSX}    Holidays



Validate Holiday Date Does Not Exist in LoanIQ DB
    [Documentation]    This keyword is used to check if nonBusinessDates/specialBusinessDates in input excel file is NOT existing in LoanIQ DB.
    ...    @author: dahijara    09DEC2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sInputFileXLSX}    ${sSheetName}    #${sCalendarID}    ${sCalendarDate}    ${sStatus}

    Open Excel    ${datasetpath}${sInputFilePath}${sInputFileXLSX}
    ${RowCount}    Get Row Count    ${sSheetName}
    Close Current Excel Document
    :FOR    ${Row}    IN RANGE    1    ${RowCount}
    # ${Row}    Set Variable    1
    
    \    ${MiscFile_Status}    Run Keyword And Return Status    Should Contain    ${sInputFileXLSX}    Holidays_Misc_
    ### Get Copp Clark File values ###
    \	${ISOCountryCode_Val}    Read Cell Data Using Reference Column Name and Row Number and Return    ${sSheetName}    ${COL_ISOCOUNTRYCODE}    ${Row}    ${datasetpath}${sInputFilePath}${sInputFileXLSX}
    \	${Code_Val}    Run Keyword If    '${MiscFile_Status}'=='${False}'    Read Cell Data Using Reference Column Name and Row Number and Return    ${sSheetName}    ${COL_CENTRECODE}    ${Row}    ${datasetpath}${sInputFilePath}${sInputFileXLSX}
		...    ELSE    Read Cell Data Using Reference Column Name and Row Number and Return    ${sSheetName}    ${COL_ISOMICCODE}    ${Row}    ${datasetpath}${sInputFilePath}${sInputFileXLSX}
    \	${EventDate_Val}    Read Cell Data Using Reference Column Name and Row Number and Return    ${sSheetName}    ${COL_EVENTDATE}    ${Row}    ${datasetpath}${sInputFilePath}${sInputFileXLSX}
    
    ### Convert Values ###
    \	${Code_Val}    Get Substring    ${Code_Val}    0    3
    \	${CalendarID}    Catenate    SEPARATOR=    ${ISOCountryCode_Val}    ${Code_Val}
    \	${EventDate_Val}    Convert To String    ${EventDate_Val}
    \	${EventDate_Year}    Get Substring    ${EventDate_Val}    0    4
    \	${EventDate_Month}    Get Substring    ${EventDate_Val}    4    6
	\	${EventDate_Day}    Get Substring    ${EventDate_Val}    6    8
    \	${EventDate_PayloadFormat}    Catenate    SEPARATOR=-    ${EventDate_Year}    ${EventDate_Month}    ${EventDate_Day}
    \	${dateValue}    Convert Date    ${EventDate_PayloadFormat}    result_format=%d-%b-%Y

    \	${Query}    Catenate    SELECT * FROM ${LIQ7474_USER}.${TLS_HOL_CAL_DATES_TABLE} WHERE ${HCD_CDE_HOL_CAL}='${CalendarID}' 
		...    AND HCD_DTE_HOL_CAL='${dateValue}'
        
    \	${Holiday_Count}    Connect to LIQ Database and Return Row Count    ${Query}
    \	Run Keyword And Continue On Failure    Should Be Equal As Strings    ${Holiday_Count}    0
    \	Run Keyword If    '${Holiday_Count}'=='0'    Log    Holiday Calendar '${CalendarID}' with Holiday Date of '${dateValue}' is NOT existing in Loan IQ Database.
		...    ELSE    Log    Holiday Calendar '${CalendarID}' with Holiday Date of '${dateValue}' status is existing in Loan IQ Database.    level=ERROR

