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

Get the Row Count of Excel Sheet
    [Documentation]    This Keyword is used to get the row count of the specific sheet in the Excel
    ...    @author: fluberio    19NOV2020    - initial create
    [Arguments]    ${sFile_Path}    ${sSheet_Name}

    ${File_Path}    Acquire Argument Value    ${sFile_Path}
    ${Sheet_Name}    Acquire Argument Value    ${sSheet_Name}
    
    ### Get The Total Number of Row in the Given Excel Sheet ###
    Open Excel Document    ${sFile_Path}    0
    ${Row_Count}    Get Row Count    ${Sheet_Name}
    Close Current Excel Document

    [Return]    ${Row_Count}
