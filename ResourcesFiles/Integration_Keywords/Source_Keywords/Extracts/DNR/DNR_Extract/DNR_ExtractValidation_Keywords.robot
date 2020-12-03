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
    Click Element    ${DNR_TeamContent_CBAReports_FromMonthYear_Calendar_Locator}
    ${sFromMonth}    Replace Variables    ${sFromMonth}
    ${DNR_TeamContent_CBAReports_FromMonth_Calendar_Locator}    Replace Variables    ${DNR_TeamContent_CBAReports_FromMonth_Calendar_Locator}
    Click Element    ${DNR_TeamContent_CBAReports_FromMonth_Calendar_Locator}
    ${sFromDay}    Replace Variables    ${sFromDay}
    ${DNR_TeamContent_CBAReports_FromDate_Calendar_Locator}    Replace Variables    ${DNR_TeamContent_CBAReports_FromDate_Calendar_Locator}
    Click Element    ${DNR_TeamContent_CBAReports_FromDate_Calendar_Locator}
    
    ### Select To Date ###
    Click Element    ${DNR_TeamContent_CBAReports_ToMonthYear_Calendar_Locator}
    ${sToMonth}    Replace Variables    ${sToMonth}
    ${DNR_TeamContent_CBAReports_ToMonth_Calendar_Locator}    Replace Variables    ${DNR_TeamContent_CBAReports_ToMonth_Calendar_Locator}
    Click Element    ${DNR_TeamContent_CBAReports_ToMonth_Calendar_Locator}
    ${sToDay}    Replace Variables    ${sToDay}
    ${DNR_TeamContent_CBAReports_ToDate_Calendar_Locator}    Replace Variables    ${DNR_TeamContent_CBAReports_ToDate_Calendar_Locator}
    Click Element    ${DNR_TeamContent_CBAReports_ToDate_Calendar_Locator}
    
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

    
