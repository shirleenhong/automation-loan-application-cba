*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Go to Specific Report from Team Content Menu CBA Reports
    [Documentation]    This keyword is used to go to Team Content menu > CBA Reports folder and select specific sReport_Name.
    ...    @author: clanding    16NOV2020    - initial create
    [Arguments]    ${sReport_Name}

    Click Element    ${DNR_TeamContent_Menu_Button_Locator}
    Wait Until Keyword Succeeds    50x    5s    Wait Until Element Is Visible    ${DNR_TeamContent_RootFolder_Locator}
    ${IsVisible}    Run Keyword And Return Status    Element Should Be Visible    ${DNR_TeamContent_RootFolder_Locator}
    Run Keyword If    ${IsVisible}==${True}    Log    Root Folder '${TEAM_CONTENT_TEXT}' is displayed.
    ...    ELSE    FAIL    Root Folder '${TEAM_CONTENT_TEXT}' is NOT displayed.    
    Capture Page Screenshot    ${screenshot_path}/Screenshots/DNR/CBAReports_RootFolderIsDisplayed-{index}.png
    
    Wait Until Keyword Succeeds    20x    5s    Wait Until Element Is Visible    ${DNR_TeamContent_CBAReports_FolderLink_Locator}
    Click Element    ${DNR_TeamContent_CBAReports_FolderLink_Locator}
    Verify if Root Folder is Displayed in Cognos    ${CBA_REPORTS}
    
    ${sReport_Name}    Replace Variables    ${sReport_Name}
    ${DNR_ReportFolder_Link_Locator}    Replace Variables    ${DNR_ReportFolder_Link_Locator}
    Click Element    ${DNR_ReportFolder_Link_Locator}
    Verify if Root Folder is Displayed in Cognos    ${sReport_Name}

Run As Report Type
    [Documentation]    This keyword is used to set filter for report and download excel file report.
    ...    @author: clanding    16NOV2020    - initial create
    [Arguments]    ${sReport_FileName}    ${sReportType}
    
    ### Click More Button ###
    ${sReport_FileName}    Replace Variables    ${sReport_FileName}
    ${DNR_TeamContent_CBAReports_MoreButton_Locator}    Replace Variables    ${DNR_TeamContent_CBAReports_MoreButton_Locator}
    Mx Hover And Click Element    ${DNR_TeamContent_CBAReports_MoreButton_Locator}
    Wait Until Keyword Succeeds    50x    5s    Wait Until Element Is Visible    ${DNR_TeamContent_CBAReports_RunAs_Button_Locator}
    
    ### Click Run As ###
    Click Element    ${DNR_TeamContent_CBAReports_RunAs_Button_Locator}
    
    ### Select Report Type ###
    ${sReportType}    Replace Variables    ${sReportType}
    ${DNR_TeamContent_CBAReports_ReportType_RadioButton_Locator}    Replace Variables    ${DNR_TeamContent_CBAReports_ReportType_RadioButton_Locator}
    Wait Until Keyword Succeeds    50x    5s    Wait Until Element Is Visible    ${DNR_TeamContent_CBAReports_ReportType_RadioButton_Locator}
    Click Element    ${DNR_TeamContent_CBAReports_ReportType_RadioButton_Locator}
    
    ### Click Run Button ###
    Click Element    ${DNR_TeamContent_CBAReports_Run_Button_Locator}
    Wait Until Browser Ready State
    Capture Page Screenshot    ${screenshot_path}/Screenshots/DNR/AfterRun-{index}.png

Set User Range Filter Using From and To and Branch and Download Report
    [Documentation]    This keyword is used to set filter for report and download excel file report.
    ...    @author: clanding    16NOV2020    - initial create
    ...    @update: clanding    05DEC2020    - added condition when Month and Date are empty
    [Arguments]    ${sFromMonth}    ${sToMonth}    ${sFromDay}    ${sToDay}    ${sBranchCode}    ${sReport_Name}    ${sReport_Path}

    Delete File If Exist    ${sReport_Path}${sReport_Name}.xlsx

    ### Select User Range ###
    Wait Until Browser Ready State
    Wait Until Keyword Succeeds    10x    5s    Wait Until Element Is Visible    ${DNR_TeamContent_CBAReports_ReportType_Frame_Locator}
    Select Frame    ${DNR_TeamContent_CBAReports_ReportType_Frame_Locator}
    Repeat Keyword    10 times    Wait Until Browser Ready State
    Wait Until Keyword Succeeds    10x    5s    Wait Until Element Is Visible    ${DNR_TeamContent_CBAReports_UserRange_RadioButton_Locator}
    Click Element    ${DNR_TeamContent_CBAReports_UserRange_RadioButton_Locator}
    
    ### Select From Date ###
    Run Keyword If    '${sFromMonth}'!=''    Click Element    ${DNR_TeamContent_CBAReports_FromMonthYear_Calendar_Locator}
    ${sFromMonth}    Replace Variables    ${sFromMonth}
    ${DNR_TeamContent_CBAReports_FromMonth_Calendar_Locator}    Replace Variables    ${DNR_TeamContent_CBAReports_FromMonth_Calendar_Locator}
    Run Keyword If    '${sFromMonth}'!=''    Click Element    ${DNR_TeamContent_CBAReports_FromMonth_Calendar_Locator}
    ${sFromDay}    Replace Variables    ${sFromDay}
    ${DNR_TeamContent_CBAReports_FromDate_Calendar_Locator}    Replace Variables    ${DNR_TeamContent_CBAReports_FromDate_Calendar_Locator}
    Run Keyword If    '${sFromDay}'!=''    Click Element    ${DNR_TeamContent_CBAReports_FromDate_Calendar_Locator}
    
    ### Select To Date ###
    Run Keyword If    '${sToMonth}'!=''    Click Element    ${DNR_TeamContent_CBAReports_ToMonthYear_Calendar_Locator}
    ${sToMonth}    Replace Variables    ${sToMonth}
    ${DNR_TeamContent_CBAReports_ToMonth_Calendar_Locator}    Replace Variables    ${DNR_TeamContent_CBAReports_ToMonth_Calendar_Locator}
    Run Keyword If    '${sToMonth}'!=''    Click Element    ${DNR_TeamContent_CBAReports_ToMonth_Calendar_Locator}
    ${sToDay}    Replace Variables    ${sToDay}
    ${DNR_TeamContent_CBAReports_ToDate_Calendar_Locator}    Replace Variables    ${DNR_TeamContent_CBAReports_ToDate_Calendar_Locator}
    Run Keyword If    '${sToDay}'!=''    Click Element    ${DNR_TeamContent_CBAReports_ToDate_Calendar_Locator}
    
    ### Select Branch ###
    ${sBranchCode}    Replace Variables    ${sBranchCode}
    ${DNR_TeamContent_CBAReports_Branch_Row_Locator}    Replace Variables    ${DNR_TeamContent_CBAReports_Branch_Row_Locator}
    Click Element    ${DNR_TeamContent_CBAReports_Branch_Row_Locator}

    Capture Page Screenshot    ${screenshot_path}/Screenshots/DNR/Download-{index}.png
    Click Element    ${DNR_TeamContent_CBAReports_Finish_Button_Locator}
        
    UnSelect Frame
    Capture Page Screenshot    ${screenshot_path}/Screenshots/DNR/Download-{index}.png

Set Branch and Download Report
    [Documentation]    This keyword is used to set filter for report and download excel file report.
    ...    @author: clanding    25NOV2020    - initial create
    [Arguments]    ${sBranchCode}    ${sReport_Name}    ${sReport_Path}
    
    Delete File If Exist    ${sReport_Path}${sReport_Name}.xlsx

    ### Select User Range ###
    Wait Until Browser Ready State
    Wait Until Keyword Succeeds    10x    5s    Wait Until Element Is Visible    ${DNR_TeamContent_CBAReports_ReportType_Frame_Locator}
    Select Frame    ${DNR_TeamContent_CBAReports_ReportType_Frame_Locator}
    Repeat Keyword    10 times    Wait Until Browser Ready State
        
    ### Select Branch ###
    ${sBranchCode}    Replace Variables    ${sBranchCode}
    ${DNR_TeamContent_CBAReports_Branch_Row_Locator}    Replace Variables    ${DNR_TeamContent_CBAReports_Branch_Row_Locator}
    Wait Until Keyword Succeeds    10x    5s    Wait Until Element Is Visible    ${DNR_TeamContent_CBAReports_Branch_Row_Locator}
    Click Element    ${DNR_TeamContent_CBAReports_Branch_Row_Locator}

    Capture Page Screenshot    ${screenshot_path}/Screenshots/DNR/Download-{index}.png
    Click Element    ${DNR_TeamContent_CBAReports_Finish_Button_Locator}
    UnSelect Frame
    
    Capture Page Screenshot    ${screenshot_path}/Screenshots/DNR/Download-{index}.png

Set Filter Using Branch Description and Processing Area and Financial Centre and From and To Date and Download Report
    [Documentation]    This keyword is used to set filter for report and download excel file report.
    ...    @author: clanding    27NOV2020    - initial create
    ...    @update: fluberio    03DEC2020    - added filters for sFromMonth sToMonth sFromYear and sToYear
    [Arguments]    ${sFromDay}    ${sToDay}    ${sBranchDescription}    ${sProcessingArea}    ${sReport_Name}    ${sReport_Path}    ${sFinancialCentre}=SELECT ALL    ${sFromMonth}=None
    ...    ${sToMonth}=None    ${sFromYear}=None    ${sToYear}=None
 
    Delete File If Exist    ${sReport_Path}${sReport_Name}.xlsx
 
    ### Select Branch Description ###
    Wait Until Browser Ready State
    Wait Until Keyword Succeeds    10x    5s    Wait Until Element Is Visible    ${DNR_TeamContent_CBAReports_ReportType_Frame_Locator}
    Select Frame    ${DNR_TeamContent_CBAReports_ReportType_Frame_Locator}
    Repeat Keyword    10 times    Wait Until Browser Ready State
    ${sBranchDescription}    Replace Variables    ${sBranchDescription}
    ${DNR_TeamContent_CBAReports_BranchDescription_Row_Locator}    Replace Variables    ${DNR_TeamContent_CBAReports_BranchDescription_Row_Locator}
    Wait Until Keyword Succeeds    10x    5s    Wait Until Element Is Visible    ${DNR_TeamContent_CBAReports_BranchDescription_Row_Locator}
    Click Element    ${DNR_TeamContent_CBAReports_BranchDescription_Row_Locator}
 
    ### Select Processing Area ###
    ${sProcessingArea}    Replace Variables    ${sProcessingArea}
    ${DNR_TeamContent_CBAReports_ProcessingArea_Row_Locator}    Replace Variables    ${DNR_TeamContent_CBAReports_ProcessingArea_Row_Locator}
    Click Element    ${DNR_TeamContent_CBAReports_ProcessingArea_Row_Locator}
 
    ### Select Financial Centre ###
    ${sFinancialCentre}    Replace Variables    ${sFinancialCentre}
    ${DNR_TeamContent_CBAReports_FinancialCentre_Row_Locator}    Replace Variables    ${DNR_TeamContent_CBAReports_FinancialCentre_Row_Locator}
    Run Keyword If    '${sFinancialCentre.upper()}'=='SELECT ALL'    Click Element    ${DNR_TeamContent_CBAReports_FinancialCentre_SelectAll_Button_Locator}
    ...    ELSE    Click Element    ${DNR_TeamContent_CBAReports_FinancialCentre_Row_Locator}
 
    ### Select From Date ###
    Run Keyword If    '${sFromYear}'!='None'    Run Keywords    Click Element    ${DNR_TeamContent_CBAReports_FromMonthYear_Calendar_Locator}
    ...    AND    Setup Year for From and To Filter    ${DNR_TeamContent_CBAReports_FromMonthYear_Calendar_Locator}    ${sFromYear}
    ...    AND    Click Element    ${DNR_TeamContent_CBAReports_FromMonthYear_Calendar_Locator}
    ${sFromMonth}    Replace Variables    ${sFromMonth}
    ${DNR_TeamContent_CBAReports_FromMonth_Calendar_Locator}    Replace Variables    ${DNR_TeamContent_CBAReports_FromMonth_Calendar_Locator}
    Run Keyword If    '${sFromMonth}'!='None'    Click Element    ${DNR_TeamContent_CBAReports_FromMonth_Calendar_Locator}
    ${sFromDay}    Replace Variables    ${sFromDay}
    ${DNR_TeamContent_CBAReports_FromDate_Calendar_Locator}    Replace Variables    ${DNR_TeamContent_CBAReports_FromDate_Calendar_Locator}
    Click Element    ${DNR_TeamContent_CBAReports_FromDate_Calendar_Locator}
    
    ### Select To Date ###
    Run Keyword If    '${sToYear}'!='None'    Run Keywords    Click Element    ${DNR_TeamContent_CBAReports_ToMonthYear_Calendar_Locator}
    ...    AND    Setup Year for From and To Filter    ${DNR_TeamContent_CBAReports_ToMonthYear_Calendar_Locator}    ${sToYear}
    ...    AND    Click Element    ${DNR_TeamContent_CBAReports_ToMonthYear_Calendar_Locator}
    ${sToMonth}    Replace Variables    ${sToMonth}
    ${DNR_TeamContent_CBAReports_ToMonth_Calendar_Locator}    Replace Variables    ${DNR_TeamContent_CBAReports_ToMonth_Calendar_Locator}
    Run Keyword If    '${sToMonth}'!='None'    Click Element    ${DNR_TeamContent_CBAReports_ToMonth_Calendar_Locator}
    ${sToDay}    Replace Variables    ${sToDay}
    ${DNR_TeamContent_CBAReports_ToDate_Calendar_Locator}    Replace Variables    ${DNR_TeamContent_CBAReports_ToDate_Calendar_Locator}
    Click Element    ${DNR_TeamContent_CBAReports_ToDate_Calendar_Locator}
    
    Capture Page Screenshot    ${screenshot_path}/Screenshots/DNR/Download-{index}.png
    Click Element    ${DNR_TeamContent_CBAReports_Finish_Button_Locator}
 
    UnSelect Frame
    Capture Page Screenshot    ${screenshot_path}/Screenshots/DNR/Download-{index}.png

Validate Facility Name Value if Existing
    [Documentation]    This keyword is used to validate facility performance report files where the Facility Name value does not exists.
    ...    @author: ccarriedo    04DEC2020    - initial create
    [Arguments]    ${LIQPerformance_Report}    ${Sheet_Name}    ${Facility_Name}

    ### Open report excel file ###
    CustomExcelLibrary.Open Excel    ${LIQPerformance_Report}
    
    ### Get all sheet values ###
    ${Report_Sheet_Values_List}    CustomExcelLibrary.Get Sheet Values    ${Sheet_Name}
    ${Report_Sheet_Values_List_String}    Convert To String    ${Report_Sheet_Values_List}
    
    ### Search the facility name value in the string ###
    ${Status_Contains_Column_Header}    Run Keyword and Return Status    Should Contain    ${Report_Sheet_Values_List_String}    ${Facility_Name}
    Run Keyword If    '${Status_Contains_Column_Header}'=='${False}'    Log    Expected: Facility Name ${Facility_Name} is not present in report file ${LIQPerformance_Report}.
    ...    ELSE    FAIL    Facility Name ${Facility_Name} is present in report file ${LIQPerformance_Report}.
 
Go to Payment Report from Team Content Menu CBA Reports
    [Documentation]    This keyword is used to go to Team Content menu > CBA Reports folder and select specific Payment Report based on specified Payment Report Type.
    ...    @author: clanding    05DEC2020    - initial create
    [Arguments]    ${sPayment_Report_Type}
 
    Click Element    ${DNR_TeamContent_Menu_Button_Locator}
    Wait Until Keyword Succeeds    50x    5s    Wait Until Element Is Visible    ${DNR_TeamContent_RootFolder_Locator}
    ${IsVisible}    Run Keyword And Return Status    Element Should Be Visible    ${DNR_TeamContent_RootFolder_Locator}
    Run Keyword If    ${IsVisible}==${True}    Log    Root Folder '${TEAM_CONTENT_TEXT}' is displayed.
    ...    ELSE    FAIL    Root Folder '${TEAM_CONTENT_TEXT}' is NOT displayed.    
    Capture Page Screenshot    ${screenshot_path}/Screenshots/DNR/CBAReports_RootFolderIsDisplayed-{index}.png
    
    Wait Until Keyword Succeeds    20x    5s    Wait Until Element Is Visible    ${DNR_TeamContent_CBAReports_FolderLink_Locator}
    Click Element    ${DNR_TeamContent_CBAReports_FolderLink_Locator}
    Verify if Root Folder is Displayed in Cognos    ${CBA_REPORTS}
    
    ${sReport_Name}    Replace Variables    ${PAYMENT_REPORTS}
    ${DNR_ReportFolder_Link_Locator}    Replace Variables    ${DNR_ReportFolder_Link_Locator}
    Click Element    ${DNR_ReportFolder_Link_Locator}
    Verify if Root Folder is Displayed in Cognos    ${sReport_Name}
 
    Run Keyword If   '${sPayment_Report_Type}'=='AHBCO'    Set Global Variable    ${CBA_PAYMENT_REPORTFILE}    ${CBA_PAYMENT_AHBCO_REPORTFILE}   
    ...    ELSE IF   '${sPayment_Report_Type}'=='AHBDE'    Set Global Variable    ${CBA_PAYMENT_REPORTFILE}    ${CBA_PAYMENT_AHBDE_REPORTFILE}
    ...    ELSE IF   '${sPayment_Report_Type}'=='CIR'    Set Global Variable    ${CBA_PAYMENT_REPORTFILE}    ${CBA_PAYMENT_CIR_REPORTFILE}
    ...    ELSE IF   '${sPayment_Report_Type}'=='CORAS'    Set Global Variable    ${CBA_PAYMENT_REPORTFILE}    ${CBA_PAYMENT_CORAS_REPORTFILE}
    ...    ELSE IF   '${sPayment_Report_Type}'=='CORRS'    Set Global Variable    ${CBA_PAYMENT_REPORTFILE}    ${CBA_PAYMENT_CORRS_REPORTFILE}
    ...    ELSE IF   '${sPayment_Report_Type}'=='DE'    Set Global Variable    ${CBA_PAYMENT_REPORTFILE}    ${CBA_PAYMENT_DE_REPORTFILE}
 
    ${sPayment_Type}    Run Keyword If    '${sPayment_Report_Type}'=='AHBCO' or '${sPayment_Report_Type}'=='AHBDE'    Set Variable    Agency
    ...    ELSE    Set Variable    Non Agency
 
    ${sPayment_Type}    Replace Variables    ${sPayment_Type}
    ${DNR_PaymentReportFolder_Link_Locator}    Replace Variables    ${DNR_PaymentReportFolder_Link_Locator}
    Click Element    ${DNR_PaymentReportFolder_Link_Locator}
    Verify if Root Folder is Displayed in Cognos    ${sPayment_Type}

Set Filter Using Payment Date and Download Report
    [Documentation]    This keyword is used to set filter for report and download excel file report.
    ...    @author: clanding    05DEC2020    - initial create
    [Arguments]    ${sPaymentMonth}    ${sPaymentDay}    ${sReport_Name}    ${sReport_Path}    ${sPaymentYear}=${EMPTY}
 
    Delete File If Exist    ${sReport_Path}${sReport_Name}.xlsx
    Wait Until Browser Ready State
 
    ${CashOutApproved}    Run Keyword And Return Status    Should Contain    ${sReport_Name}    ${PAYMENT_CASHOUTAPPROVED_REPORTS}
    Return From Keyword If    ${CashOutApproved}==${True}
 
    Wait Until Keyword Succeeds    10x    5s    Wait Until Element Is Visible    ${DNR_TeamContent_CBAReports_ReportType_Frame_Locator}
    Select Frame    ${DNR_TeamContent_CBAReports_ReportType_Frame_Locator}
    Repeat Keyword    10 times    Wait Until Browser Ready State
    Wait Until Keyword Succeeds    10x    5s    Wait Until Element Is Visible    ${DNR_TeamContent_CBAReports_PaymentMonthYear_Calendar_Locator}
    
    ### Select Payment Date ###
    Run Keyword If    '${sPaymentYear}'!='${EMPTY}'    Run Keywords    Click Element    ${DNR_TeamContent_CBAReports_PaymentMonthYear_Calendar_Locator}
    ...    AND    Setup Year for From and To Filter    ${DNR_TeamContent_CBAReports_PaymentMonthYear_Calendar_Locator}    ${sPaymentYear}
 
    ${sPaymentMonth}    Replace Variables    ${sPaymentMonth}
    ${DNR_TeamContent_CBAReports_PaymentMonth_Calendar_Locator}    Replace Variables    ${DNR_TeamContent_CBAReports_PaymentMonth_Calendar_Locator}
    Click Element    ${DNR_TeamContent_CBAReports_PaymentMonth_Calendar_Locator}
 
    ${sPaymentDay}    Replace Variables    ${sPaymentDay}
    ${DNR_TeamContent_CBAReports_PaymentDate_Calendar_Locator}    Replace Variables    ${DNR_TeamContent_CBAReports_PaymentDate_Calendar_Locator}
    Click Element    ${DNR_TeamContent_CBAReports_PaymentDate_Calendar_Locator}
 
    Capture Page Screenshot    ${screenshot_path}/Screenshots/DNR/Download-{index}.png
    Click Element    ${DNR_TeamContent_CBAReports_Finish_Button_Locator}
        
    UnSelect Frame
    Capture Page Screenshot    ${screenshot_path}/Screenshots/DNR/Download-{index}.png

Validate Facility Performance Report File with Active Status
    [Documentation]    This keyword is used to validate facility name row values in the facility performance report file with active status.
    ...    Columns to Validate: Facility Name, FCN, Total Utilization Amount, Facility Status
    ...    @author: ccarriedo    07DEC2020    - initial create
    [Arguments]    ${sLIQPerformance_Report}    ${sSheet_Name}    ${sFacility_Name}    ${sColumns_To_Validate}    ${sDelimiter}    
    ...    ${Column_Headers_RowID}    ${sFacility_Status}    ${sFacility_Outstandings}    ${sFacility_FCN}

    ### Open report excel file ###
    CustomExcelLibrary.Open Excel    ${sLIQPerformance_Report}
    
    ### Create and store facility name row values in a dictionary ###
    ${Expected_Row_Values_Dictionary}    Create Facility Name Row Values Dictionary    ${sLIQPerformance_Report}    ${sSheet_Name}    ${sFacility_Name}    ${sColumns_To_Validate}    
    ...    ${sDelimiter}    ${Column_Headers_RowID}    ${sFacility_Outstandings}    ${sFacility_FCN}

    ### Validate Facility FCN using the Dictionary key FCN ###
    ${Report_File_Facility_FCN}    Get From Dictionary    ${Expected_Row_Values_Dictionary}    FCN
    Log    Report File Facility FCN: '${Report_File_Facility_FCN}'            
    Compare Two Strings    ${sFacility_FCN}    ${Report_File_Facility_FCN}
    
    ### Validate Facility Status using the Dictionary key Facility Status ###
    ${Report_File_Facility_Status}    Get From Dictionary    ${Expected_Row_Values_Dictionary}    Facility Status
    Log    Report File Facility Status: '${Report_File_Facility_Status}'
    ${sFacility_Status_Uppercase}    Convert To Uppercase    ${sFacility_Status}         
    Compare Two Strings    ${sFacility_Status_Uppercase}    ${Report_File_Facility_Status}
    
    ### Validate Facility Outstandings using the Dictionary key Total Utilization Amount ###
    ${Report_File_Facility_Outstandings}    Get From Dictionary    ${Expected_Row_Values_Dictionary}    Total Utilization Amount        
    Log    Report File Facility Outstandings: '${Report_File_Facility_Outstandings}'
    Compare Two Strings    ${sFacility_Outstandings}    ${Report_File_Facility_Outstandings}

Create Facility Name Row Values Dictionary
    [Documentation]    This keyword is used to validate facility name row values in the facility performance report file.
    ...    @author: ccarriedo    07DEC2020    - initial create
    [Arguments]    ${sLIQPerformance_Report}    ${sSheet_Name}    ${sFacility_Name}    ${sColumns_To_Validate}    ${sDelimiter}    ${Column_Headers_RowID}    
    ...    ${sFacility_Outstandings}    ${sFacility_FCN}

    ### Get the columns to validate from dataset and split delimeter to string ###
    ${Column_Headers_List}    Split String    ${sColumns_To_Validate}    ${sDelimiter}
    ${Column_Headers_List_Count}    Get Length    ${Column_Headers_List}
    
    ### Create dictionary for the container of the fetched row values to be validated ###
    ${Report_File_Row_Values_Dictionary}    Create Dictionary
    
    ### This is to fetch all the values of the row and store it in list and dictionary which will be used for validating the excel values using the dictionary key-value pairs and to LIQ values ###
    :FOR    ${Index}    IN RANGE    ${Column_Headers_List_Count}
    \    ${Column_Headers_Value}    Get From List    ${Column_Headers_List}    ${Index}
    \    ${Report_File_Row_Values}    Get Facility Name Row Values    ${sLIQPerformance_Report}    ${sSheet_Name}    ${sFacility_Name}    ${Column_Headers_Value}    ${Column_Headers_RowID}
    \    Log    The value of '${Column_Headers_Value}': '${Report_File_Row_Values}'
    \    Set To Dictionary    ${Report_File_Row_Values_Dictionary}    ${Column_Headers_Value}=${Report_File_Row_Values}
    Log    ${Report_File_Row_Values_Dictionary}
    
    [Return]    ${Report_File_Row_Values_Dictionary}

Get Facility Name Row Values
    [Documentation]    This keyword is used to validate Facility Name, FCN,  Total Utilization Amount and Facility Status Values in the facility performance report file.
    ...    @author: ccarriedo    07DEC2020    - initial create
    [Arguments]    ${sLIQPerformance_Report}    ${sSheet_Name}    ${sFacility_Name}    ${sColumns_To_Validate}    ${Column_Headers_RowID}

    ${Report_Column_Header_Index}    Get Specific Column Header Index in the Report File    ${sSheet_Name}    ${sColumns_To_Validate}    ${Column_Headers_RowID}        
    
    ### Get all report sheet values ###
    ${Report_Sheet_Values_List}    CustomExcelLibrary.Get Sheet Values    ${sSheet_Name}
    
    ### Convert the list to string and substring to determine the facility name row ###
    ${Report_Sheet_Values_List_String}    Convert To String    ${Report_Sheet_Values_List}
    ${Facility_Name_Left}    Fetch From Left    ${Report_Sheet_Values_List_String}    ${sFacility_Name}
    ${Facility_Name_Left_Count}    Get Length    ${Facility_Name_Left}
    ${Facility_Name_Left_Start}    Evaluate    ${Facility_Name_Left_Count}-30
    ${Facility_Name_Left_Substring}    Get Substring    ${Facility_Name_Left}    ${Facility_Name_Left_Start}
    ${Split_String}    Split String    ${Facility_Name_Left_Substring}    ,
    ${String_Right}    Get From List    ${Split_String}    1
    ${String_Right_Count}    Get Length    ${String_Right}
    ${String_Right_End}    Evaluate    ${String_Right_Count}-1
    ${Facility_Name_Row_String}    Get Substring    ${String_Right}    4    ${String_Right_End}

    ### Get all row values ###
    ${Expected_Row_Values_List}    CustomExcelLibrary.Get Row Values    ${sSheet_Name}    ${Facility_Name_Row_String}    ${True}
    Log    ${Expected_Row_Values_List}
    
    ### Get value using the column index ###
    ${Expected_Row_Values}    Get From List    ${Expected_Row_Values_List}    ${Report_Column_Header_Index}
    Log    ${Expected_Row_Values}
    
    ### Convert the value to string and split using the delimiter , ###
    ${Expected_Row_Values_String}    Convert To String    ${Expected_Row_Values}
    ${Expected_Value_Split}    Split String    ${Expected_Row_Values_String}	,
    
    ### Get the left value from the split string to determine the cell coordinate ###
    ${Expected_Value_String_Left}    Get From List    ${Expected_Value_Split}    0
    ${Expected_Value_String_Left_Count}    Get Length    ${Expected_Value_String_Left}
    ${Expected_Value_String_Left_End}    Evaluate    ${Expected_Value_String_Left_Count}-1
    ${Expected_Value_Key}    Get Substring    ${Expected_Value_String_Left}    2    ${Expected_Value_String_Left_End}
    
    ### Convert the row list to dictionary ###
    ${Get_From_List_Dictionary}    Convert To Dictionary    ${Expected_Row_Values_List}
    Log    ${Get_From_List_Dictionary}
    
    ### Get the value using the cell coordinate as the key to validate in Loan IQ Facility Outstandings value ###
    ${Report_File_Row_Values}    Get From Dictionary    ${Get_From_List_Dictionary}    ${Expected_Value_Key}
    
    [Return]    ${Report_File_Row_Values}
