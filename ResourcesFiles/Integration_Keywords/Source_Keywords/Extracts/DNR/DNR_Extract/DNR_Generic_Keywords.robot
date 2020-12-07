*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Login to Cognos
    [Documentation]    This keyword is used to login to Cognos application.
    ...    @author: clanding    16NOV2020    - initial create
    [Arguments]    ${sReport_Path}    ${bHeadless}=${False}
    

    Run Keyword If    ${bHeadless}==${True}    Mx Create Chrome Webdriver And Enable Download Directory    ${BROWSER}    ${sReport_Path}    headless_mode=yes
    ...    ELSE    Mx Create Chrome Webdriver And Enable Download Directory    ${BROWSER}    ${sReport_Path}
    Go To    http://${COGNOS_SERVER}:${COGNOS_PORT}${COGNOS_URL}
    Wait Until Browser Ready State
    Maximize Browser Window
    Wait Until Browser Ready State
    Wait Until Keyword Succeeds    20x    5s    Wait Until Element Is Visible    ${DNR_Namespace_Dropdown_Locator}
    Select From List By Label    ${DNR_Namespace_Dropdown_Locator}    ${COGNOS_NAMESPACE}
    Wait Until Element Is Visible    ${DNR_UserID_Textbox_Locator}    
    Mx Input Text    ${DNR_UserID_Textbox_Locator}    ${COGNOS_USERNAME}
    Mx Input Text    ${DNR_UserID_Password_Locator}    ${COGNOS_PASSWORD}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/DNR/CognosLoginPage-{index}.png
    Mx Click Element    ${DNR_SignIn_Button_Locator}
    Verify if Page is Displayed in Cognos    ${COGNOS_WELCOME_PAGETITLE}

Logout from Cognos
    [Documentation]    This keyword is used to logout from Cognos application.
    ...    @author: clanding    16NOV2020    - initial create
    [Arguments]    ${bHeadless}=${False}

    Return From Keyword If    ${bHeadless}==${True}    Close Browser

    Repeat Keyword    10 times    Wait Until Browser Ready State
    Click Element    ${DNR_PersonalMenu_Button_Locator}
    Repeat Keyword    5 times    Wait Until Browser Ready State
    Mx Hover And Click Element    ${DNR_SignOut_Button_Locator}
    Wait Until Keyword Succeeds    20x    5s    Wait Until Element Is Visible    ${DNR_Namespace_Dropdown_Locator}
    Close Browser

Verify if Page is Displayed in Cognos
    [Documentation]    This keyword is used to validate if sPageName is displayed.
    ...    @author: clanding    16NOV2020    - initial create
    [Arguments]    ${sPageName}
    
    ${sPageName}    Replace Variables    ${sPageName}
    ${DNR_Page_Locator}    Replace Variables    ${DNR_Page_Locator}
    Wait Until Keyword Succeeds    20x    5s    Wait Until Element Is Visible    ${DNR_Page_Locator}
    ${IsVisible}    Run Keyword And Return Status    Element Should Be Visible    ${DNR_Page_Locator}
    Run Keyword If    ${IsVisible}==${True}    Log    '${sPageName}' is displayed.
    ...    ELSE    FAIL    '${sPageName}' is NOT displayed.    
    Capture Page Screenshot    ${screenshot_path}/Screenshots/DNR/PageIsDisplayed-{index}.png
    
Verify if Text is Displayed in Cognos
    [Documentation]    This keyword is used to validate if sText is displayed.
    ...    @author: clanding    16NOV2020    - initial create
    [Arguments]    ${sText}
    
    ${sText}    Replace Variables    ${sText}
    ${DNR_Text_Locator}    Replace Variables    ${DNR_Text_Locator}
    Wait Until Keyword Succeeds    20x    5s    Wait Until Element Is Visible    ${DNR_Text_Locator}
    ${IsVisible}    Run Keyword And Return Status    Element Should Be Visible    ${DNR_Text_Locator}
    Run Keyword If    ${IsVisible}==${True}    Log    Text '${sText}' is displayed.
    ...    ELSE    FAIL    Text '${sText}' is NOT displayed.    
    Capture Page Screenshot    ${screenshot_path}/Screenshots/DNR/TextIsDisplayed-{index}.png

Verify if Root Folder is Displayed in Cognos
    [Documentation]    This keyword is used to validate if sText is displayed as the root folder.
    ...    @author: clanding    16NOV2020    - initial create
    [Arguments]    ${sText}
    
    ${sText}    Replace Variables    ${sText}
    ${DNR_RootFolder_Locator}    Replace Variables    ${DNR_RootFolder_Locator}

    Wait Until Keyword Succeeds    20x    5s    Wait Until Element Is Visible    ${DNR_RootFolder_Locator}
    ${IsVisible}    Run Keyword And Return Status    Element Should Be Visible    ${DNR_RootFolder_Locator}
    Run Keyword If    ${IsVisible}==${True}    Log    Root Folder '${sText}' is displayed.
    ...    ELSE    FAIL    Root Folder '${sText}' is NOT displayed.    
    Capture Page Screenshot    ${screenshot_path}/Screenshots/DNR/RootFolderIsDisplayed-{index}.png

Validate Value if Existing in Excel Sheet
    [Documentation]    This keyword is used validate sExpectedValue in sSheetName from sExcelFile.
    ...    NOTE: sExcelFile=includes file path and extension.
    ...    @author: clanding    18NOV2020    - initial create
    [Arguments]    ${sExcelFile}    ${sSheetName}    ${sExpectedValue}
    
    CustomExcelLibrary.Open Excel    ${sExcelFile}    0
    ${Sheet_ValueList}    Get Sheet Values    ${sSheetName}
    Log    ${Sheet_ValueList}
    :FOR    ${Value_List}    IN    @{Sheet_ValueList}
    \    ${Sheet_ColumnValue}    Get From List    ${Value_List}    1
    \    ${Sheet_Value}    Get From List    ${Value_List}    1
    \    Exit For Loop If    '${Sheet_Value}'=='${sExpectedValue}'
    Compare Two Strings    ${sExpectedValue}    ${Sheet_Value}

Validate Multiple Value if Existing in Excel Sheet
    [Documentation]    This keyword is used validate sExpectedValue in sSheetName from sExcelFile.
    ...    NOTE: sExcelFile=includes file path and extension.
    ...    @author: clanding    18NOV2020    - initial create
    [Arguments]    ${sExcelFile}    ${sSheetName}    ${sExpectedValue}    ${sDelimiter}
    
    ${Expected_ValueList}    Split String    ${sExpectedValue}    ${sDelimiter}

    :FOR    ${Expected_Value}    IN    @{Expected_ValueList}
    \    ${Sheet_ColumnValue}    Validate Value if Existing in Excel Sheet    ${sExcelFile}    ${sSheetName}    ${Expected_Value}

Get Total Row Count of Excel Sheet
    [Documentation]    This Keyword is used to get the row count of the specific sheet in the Excel
    ...    @author: fluberio    19NOV2020    - initial create
    [Arguments]    ${sFile_Path}    ${sSheet_Name}

    ### note that sFile_Path includes file path and extension ###
    ${File_Path}    Acquire Argument Value    ${sFile_Path}
    ${Sheet_Name}    Acquire Argument Value    ${sSheet_Name}
    
    ### Get The Total Number of Row in the Given Excel Sheet ###
    Open Excel Document    ${sFile_Path}    0
    ${Row_Count}    Get Row Count    ${Sheet_Name}
    Close Current Excel Document

    [Return]    ${Row_Count}

Validate Sequencing of Columns if Correct in Excel Sheet
    [Documentation]    This keyword is used validate sequencing of columns if correct in sSheetName in sExcelFile.
    ...    NOTE: sExcelFile=includes file path and extension.
    ...    @author: clanding    19NOV2020    - initial create
    [Arguments]    ${sExcelFile}    ${sSheetName}    ${sExpectedValue}    ${sDelimiter}
    
    CustomExcelLibrary.Open Excel    ${sExcelFile}    0
    
    ### Get Column Header Total Count ###
    ${Sheet_ValueList}    CustomExcelLibrary.Get Row Values    ${sSheetName}    0    ${False}
    ${Sheet_ValueList_Count}    Get Length    ${Sheet_ValueList}
    
    ### Get Expected Column Header Total Count ###
    ${Expected_ValueList}    Split String    ${sExpectedValue}    ${sDelimiter}
    ${Expected_ValueList_Count}    Get Length    ${Expected_ValueList}

    ### Validate if actual and expected column counts are equal ###
    Compare Two Strings    ${Expected_ValueList_Count}    ${Sheet_ValueList_Count}
    
    :FOR    ${Index}    IN RANGE    ${Expected_ValueList_Count}
    \    ${Expected_Value}    Get From List    ${Expected_ValueList}    ${Index}
    \    ${Sheet_ValueList_0}    Get From List    ${Sheet_ValueList}    ${Index}
    \    ${Sheet_Value}    Get From List    ${Sheet_ValueList_0}    1    ###Get Cell Value
    \    Compare Two Strings    ${Expected_Value}    ${Sheet_Value}

Create Dictionary Using Report File and Validate Values if Existing
    [Documentation]    This keyword is used to create dictionary from the DNR report file columns and validate if the required columns exist.
    ...    NOTE: This is applicable for reports where the columns does not start at row 1 and reports with too many records
    ...    @author: ccarriedo    20NOV2020    - initial create
    [Arguments]    ${sExcelFile}    ${iColumn_RowID}    ${sExpectedValue}    ${sSheetName}    ${sDelimiter}
    
    Open Excel    ${sExcelFile}
    
    ### Create Dictionary and Get Column Header Total Count of the Report File ###
    ${RowData_Dictionary}    Create Dictionary 
    Set Variable    ${RowData_Dictionary}   
    ${ReportColumn_TotalCount}    Get Column Count    ${sSheetName}
    
    ${Expected_ValueList}    Split String    ${sExpectedValue}    ${sDelimiter}
    ${Expected_Values_TotalCount}    Get Length    ${Expected_ValueList}
    Append To List    ${Expected_ValueList}

    ### Store Values To Dictionary ###
    :FOR    ${Index_Column}    IN RANGE    ${ReportColumn_TotalCount}
    \    ${Column_Header}    Read Cell Data By Coordinates    ${sSheetName}    ${Index_Column}    ${iColumn_RowID}
    \    ${Column_Value}    Read Cell Data By Coordinates    ${sSheetName}    ${Index_Column}    ${iColumn_RowID}
    \    Set To Dictionary    ${RowData_Dictionary}    ${Column_Header}=${Column_Value}    
    \    Log    ${RowData_Dictionary}

    ### Checking if Columns To Validate Exists in The Report File  ###
    :FOR    ${INDEX}    IN RANGE    ${Expected_Values_TotalCount}
    \    ${Expected_Value}    Get From List    ${Expected_ValueList}    ${INDEX}
    \    ${Actual_Value}    Get From Dictionary    ${RowData_Dictionary}    ${Expected_Value}
    \    Log    ${Expected_Value}
    \    Log    ${Actual_Value}
    \    Compare Two Strings    ${Actual_Value}    ${Expected_Value}


Get Specific Detail in Given Date
    [Documentation]    This Keyword is used to get the specific detail in date having format of %d-%b-%Y
    ...    @author: fluberio    04DEC2020    - initial create
    [Arguments]    ${sDate}    ${sFormat}    ${sDelimiter}

    ### note that sDate mus be in %d-%b-%Y ###
    ${Date}    Acquire Argument Value    ${sDate}
    ${Date_DetailList}    Split String    ${Date}    ${sDelimiter}
    ${Date_Specific Detail}    Run keyword if    '${sFormat}'=='D'    Set Variable    @{Date_DetailList}[0]
    ...    ELSE IF    '${sFormat}'=='M'    Set Variable    @{Date_DetailList}[1]
    ...    ELSE IF    '${sFormat}'=='Y'    Set Variable    @{Date_DetailList}[2]    
 
    [Return]    ${Date_Specific Detail}

Get Date Value from Date Added or Amended Column
    [Documentation]    This keyword is used to get date only from Date Added or Amended Column colum.
    ...    Sample sFormat %d-%b-%Y = 30-Nov-2020
    ...    @author: clanding    02DEC2020    - initial create
    [Arguments]    ${sValue}    ${sFormat}=None
    
    ${Value}    Convert To String    ${sValue}
    ${Value_List}    Split String    ${Value}
    ${Date_Value}    Set Variable    @{Value_List}[0]
    
    ${Date_Value}    Run Keyword If    '${sFormat}'!='None'    Convert Date    ${Date_Value}    result_format=${sFormat}
    ...    ELSE    Set Variable    ${Date_Value}

    [Return]    ${Date_Value}
    
Setup Year for From and To Filter
    [Documentation]    This keyword is used to Input Year in From and To Filters.
    ...    @author: fluberio    03DEC2020    - initial create
    [Arguments]    ${slocator}    ${sText}
    
    Press Keys    ${slocator}    BACKSPACE
    Press Keys    ${slocator}    BACKSPACE
    Press Keys    ${slocator}    BACKSPACE
    Press Keys    ${slocator}    BACKSPACE
    Press Keys    ${slocator}    ${sText}
    Press Keys    ${slocator}    RETURN
    Wait Until Browser Ready State

Verify List Values if Correct
    [Documentation]    This keyword is used to verify if all list values are correct compared to sExpectedValue
    ...    @author: clanding    07DEC2020    - initial create
    [Arguments]    ${aList}    ${sExpectedValue}

    ${List_Count}    Get Length    ${aList}
    :FOR    ${Index}    IN RANGE    0    ${List_Count}
    \    Compare Two Strings    ${sExpectedValue}    @{aList}[${Index}]   
