*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Validate Calendar ID if Existing in LIQ for Copp Clark Files
    [Documentation]    This keyword is used to verify if calendar ids of Holiday files are existing in Loan IQ Table Maintenance.
    ...    @author: clanding    17JUN2019    - initial create
    ...    @update: ehugo    10JUN2020    - used 'Open Holiday Calendars Table in Table Maintenance' keyword to open the table only once
    [Arguments]    ${aCalendarID_File1}    ${aCalendarID_File2}    ${aCalendarID_Misc}

    Open Holiday Calendars Table in Table Maintenance
    
    :FOR    ${CalendarID_File1}    IN    @{aCalendarID_File1}
    \    Run Keyword And Continue On Failure     Verify Calendar ID if Existing in Previously Opened Holiday Calendars Table    ${CalendarID_File1}    ${CALENDARID_CHECKBOX_STATUS_ON}

    :FOR    ${CalendarID_File2}    IN    @{aCalendarID_File2}
    \    Run Keyword And Continue On Failure     Verify Calendar ID if Existing in Previously Opened Holiday Calendars Table    ${CalendarID_File2}    ${CALENDARID_CHECKBOX_STATUS_ON}
    
    :FOR    ${CalendarID_Misc}    IN    @{aCalendarID_Misc}
    \    Run Keyword And Continue On Failure     Verify Calendar ID if Existing in Previously Opened Holiday Calendars Table    ${CalendarID_Misc}    ${CALENDARID_CHECKBOX_STATUS_ON}

    Close All Windows on LIQ

Run Activate Window for Multiple Retry
    [Documentation]    This keyword is used to run Mx Activate for iRetry times and exist if conditioned is passed.
    ...    @author: clanding    25JUL2019    - initial create
    [Arguments]    ${iRetry}
    
    :FOR    ${Index}    IN RANGE    1    ${iRetry}
    \    ${Status}    Run Keyword And Return Status    mx LoanIQ activate    ${LIQ_BrowseHolidayCalendarDates_Window}
    \    Exit For Loop If    ${Status}==${True}
    mx LoanIQ activate    ${LIQ_BrowseHolidayCalendarDates_Window}
