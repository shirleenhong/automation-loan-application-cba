*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Validate Calendar ID if Existing in LIQ for Copp Clark Files
    [Documentation]    This keyword is used to verify if calendar ids of Holiday files are existing in Loan IQ Table Maintenance.
    ...    @author: clanding    17JUN2019    - initial create
    [Arguments]    ${aCalendarID_File1}    ${aCalendarID_File2}    ${aCalendarID_Misc}
    
    :FOR    ${CalendarID_File1}    IN    @{aCalendarID_File1}
    \    Run Keyword And Continue On Failure     Verify Calendar ID if Existing in Holiday Calendars Table    ${CalendarID_File1}    ${CALENDARID_CHECKBOX_STATUS_ON}

    :FOR    ${CalendarID_File2}    IN    @{aCalendarID_File2}
    \    Run Keyword And Continue On Failure     Verify Calendar ID if Existing in Holiday Calendars Table    ${CalendarID_File2}    ${CALENDARID_CHECKBOX_STATUS_ON}
    
    :FOR    ${CalendarID_Misc}    IN    @{aCalendarID_Misc}
    \    Run Keyword And Continue On Failure     Verify Calendar ID if Existing in Holiday Calendars Table    ${CalendarID_Misc}    ${CALENDARID_CHECKBOX_STATUS_ON}

Validate Holiday Calendar in LoanIQ
    [Documentation]    This keyword is used to validate nonBusinessDates and specialBusinessDates in Table Maintenance > Holiday Calendar Dates.
    ...    GDE-2364 is opened for slowness of screen to load.
    ...    @author: clanding    24JUL2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sInputJSONFile}
    
    ${OutputJSONFile}    OperatingSystem.Get File    ${dataset_path}${sInputFilePath}${sInputJSONFile}.json    
    ${OutputJSONFile}    Strip String    ${OutputJSONFile}    mode=left    characters=[
    ${OutputJSONFile}    Strip String    ${OutputJSONFile}    mode=right    characters=]
    Log    ${OutputJSONFile}
    
    ${OutputJSONFile_List}    Split String    ${OutputJSONFile}    },{"lobs":
    Log    ${OutputJSONFile_List}
    ${JsonCount}    Get Length    ${OutputJSONFile_List}
    :FOR    ${Index}    IN RANGE    ${JsonCount}
    \    ${LastIndex}    Evaluate    ${JsonCount}-1    
    \    ${JSON_Value}    Get From List    ${OutputJSONFile_List}    ${Index}
    \    ${IsEvenOrOdd}    Evaluate    int('${Index}')%2
    \    ${JSON_Value}    Run Keyword If    ${IsEvenOrOdd}==0 and ${Index}==0 and ${LastIndex}!=0    Catenate    SEPARATOR=    ${JSON_Value}    }
         ...    ELSE IF    ${IsEvenOrOdd}==0 and ${Index}==0 and ${LastIndex}==0    Set Variable    ${JSON_Value}
         ...    ELSE IF    ${IsEvenOrOdd}==0 and ${Index}==${LastIndex}    Catenate    SEPARATOR=    {"lobs":    ${JSON_Value}
         ...    ELSE IF    ${IsEvenOrOdd}==1 and ${Index}==${LastIndex}    Catenate    SEPARATOR=    {"lobs":    ${JSON_Value}
         ...    ELSE    Catenate    SEPARATOR=    {"lobs":    ${JSON_Value}    }
    \    Log    ${JSON_Value}
    \    Create File    ${dataset_path}${sInputFilePath}tempfile.json    ${JSON_Value}
    \    ${OutputJSON}    Load JSON From File    ${dataset_path}${sInputFilePath}tempfile.json
    \    ${Val_calendarId}    Get From Dictionary    ${OutputJSON}    calendarId
    \    ${InputJSON}    Load JSON From File    ${dataset_path}${sInputFilePath}${sInputJSONFile}_ID_${Val_calendarId}.json
    \    Get Date Details Values in Input and Verify if Existing in LoanIQ    ${InputJSON}    ${Val_calendarId}
    \    Delete File If Exist    ${dataset_path}${sInputFilePath}tempfile.json

Get Date Details Values in Input and Verify if Existing in LoanIQ
    [Documentation]    This keyword is used to get dateDetails values from input file and verify if existing in Loan IQ.
    ...    @author: clanding    25JUL2019    - initial create
    [Arguments]    ${oInputJSON}    ${sCalendarId}
    
    ${dateDetails_List}    Get From Dictionary    ${oInputJSON}    dateDetails
    ${dateDetails_Count}    Get Length    ${dateDetails_List}
    
    :FOR    ${dateDetails}    IN    @{dateDetails_List}
    \    ${nonBusinessDates_List}    Get From Dictionary    ${dateDetails}    nonBusinessDates
    \    ${specialBusinessDates_List}    Get From Dictionary    ${dateDetails}    specialBusinessDates
    \    mx LoanIQ activate window    ${LIQ_Window}    
    \    mx LoanIQ select    ${LIQ_Options_RefreshAllCodeTables}
    \    mx LoanIQ click    ${LIQ_Warning_Yes_Button}
    \    mx LoanIQ click    ${LIQ_TableMaintenance_Button}
    \    Search in Table Maintenance    Holiday Calendar Dates
    \    mx LoanIQ click    ${LIQ_BrowseHolidayCalendarDates_ShowALL_RadioBtn}
    \    Validate Added Non Business Dates    ${nonBusinessDates_List}    ${sCalendarId}
    \    Validate Special Business Dates    ${specialBusinessDates_List}    ${sCalendarId}

Run Activate Window for Multiple Retry
    [Documentation]    This keyword is used to run Mx Activate for iRetry times and exist if conditioned is passed.
    ...    @author: clanding    25JUL2019    - initial create
    [Arguments]    ${iRetry}
    
    :FOR    ${Index}    IN RANGE    1    ${iRetry}
    \    ${Status}    Run Keyword And Return Status    mx LoanIQ activate    ${LIQ_BrowseHolidayCalendarDates_Window}
    \    Exit For Loop If    ${Status}==${True}
    mx LoanIQ activate    ${LIQ_BrowseHolidayCalendarDates_Window}
