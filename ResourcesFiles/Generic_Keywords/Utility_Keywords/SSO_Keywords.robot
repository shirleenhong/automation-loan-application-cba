*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${INDEX}    1
${INDEX_0}    0

*** Keywords ***
Launch SSO Page
    [Documentation]    This keyword is used to open browser and launch SSO main page.
    ...    @author: clanding
    ...    @update: clanding    08APR2019    - removed arguments, browser and SSO_URL should be declared on environment variables
    ...    @update: rtrayao    11NOV2019    - removed login of credentials

    Open Browser    ${SSO_URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Element Is Visible     ${SSO_Process_Textfield}
    

Search User ID in Enquire User Page
    [Documentation]    This keyword is used to search User ID on SSO main page.
    ...    @author: clanding
    ...    @update: clanding    08APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...    @update: dahijara    18JUL2019    - added \ on index for element, this is an update for robot to consider it as a string not an index of
    [Arguments]    ${sUserID}    ${sUserType}    ${sCountryCode}
    Wait Until Element Is Visible     ${SSO_Process_Textfield}    timeout=20s
    Input Text    ${SSO_Process_Textfield}    Enquire User
    Press key    ${SSO_Process_Textfield}   ${Keyboard_Enter}
    Wait Until Element Is Visible     ${SSO_UserID_textfield}    timeout=20s
    Mx Input Text    ${SSO_UserID_textfield}    ${sUserID}
    Click Element    ${SSO_Search_button}
    Wait Until Element Is Visible    ${SSO_SearchUser_UserID_textfield}    timeout=20s
    ${UserType}    Run Keyword If    '${sUserType}'==''    Set Variable    N
    ...    ELSE    Set Variable    ${sUserType}
    ${Count}    SeleniumLibraryExtended.Get Element Count    ${SSO_UserID_Row_table}
    ${Count+1}    Evaluate    ${Count}+1
    @{CountList}    Create List
    :FOR    ${INDEX}    IN RANGE    1    ${Count+1}
    \    ${User_Table}    Get Text    ${SSO_Results_table}\[${INDEX}]${SSO_UserID_Col}
    \    ${USER_MATCH}    Run Keyword And Return Status    Should Be Equal    ${sUserID}    ${User_Table}
    \    Run Keyword If    ${USER_MATCH}==True    Run Keywords    Log    Users Matched! ${sUserID} = ${User_Table}
         ...    AND    Click Element    ${SSO_Results_table}\[${INDEX}]${SSO_RadioButton_Col}
    \    ${UserType_Table}    Run Keyword If    ${USER_MATCH}==True    Get Text    ${SSO_Results_table}\[${INDEX}]${SSO_UserType}
    \    ${UserType}    Run Keyword If    '${UserType}'=='no tag' or '${UserType}'=='' or '${UserType}'=='null'    Set Variable    N
         ...    ELSE    Set Variable    ${UserType}
    \    Run Keyword If    ${USER_MATCH}==True    Run Keyword And Continue On Failure    Should Be Equal    ${UserType}    ${UserType_Table}
    \    ${UserType_stat}    Run Keyword If    ${USER_MATCH}==True    Run Keyword And Return Status    Should Be Equal    ${UserType}    ${UserType_Table}
    \    Run Keyword If    ${UserType_stat}==True    Log    Matched! User Type is correct. '${UserType}' = '${UserType_Table}'
         ...    ELSE IF    ${UserType_stat}==False    Fail    Not Matched! Expected value: '${UserType}'. Actual value: '${UserType_Table}'.
    \    ${CountryCode_Table}    Run Keyword If    ${USER_MATCH}==True    Get Text    ${SSO_Results_table}\[${INDEX}]${SSO_CountryCode}
    \    Run Keyword If    ${USER_MATCH}==True    Run Keyword And Continue On Failure    Should Be Equal    ${sCountryCode}    ${CountryCode_Table}
    \    ${CountryCode_stat}    Run Keyword If    ${USER_MATCH}==True    Run Keyword And Return Status    Should Be Equal    ${sCountryCode}    ${CountryCode_Table}
    \    Run Keyword If    ${CountryCode_stat}==True    Log    Matched! Country Code is correct. '${sCountryCode}' = '${CountryCode_Table}'
         ...    ELSE IF      ${CountryCode_stat}==False    Fail    Not Matched! Expected value: '${sCountryCode}'. Actual value: '${CountryCode_Table}'.
    \    Run Keyword If    ${INDEX}>${Count+1} and ${USER_MATCH}==False    Log    No Users Matched on the table!!
    \    Exit For Loop If    ${USER_MATCH}==True
    Click Element    ${SSO_SearchUser_Next_button}
    Wait Until Element Is Visible    ${SSO_GivenName_textfield}

Validate Enquire User Page Mandatory Fields
    [Documentation]    This keyword is used to validate Enquire User Page fields if correct.
    ...    @author: clanding
    ...    @update: clanding    08APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sFName}    ${sLName}    ${input_businesstitle}    ${sCountryCode}    ${sCountryCodeDesc}

    ${Actual_GivenName}    Get Value    ${SSO_GivenName_textfield}
    Run Keyword And Continue On Failure    Textfield Value Should Be    ${SSO_GivenName_textfield}    ${sFName}
    ${IsMatched_GivenName}    Run Keyword And Return Status    Textfield Value Should Be    ${SSO_GivenName_textfield}    ${sFName}
    Run Keyword If    ${IsMatched_GivenName}==True    Log    Correct!! Given Name is '${sFName}'.
    ...    ELSE    Log    Incorrect!! Expected value: '${sFName}'. Actual value: '${Actual_GivenName}'.    level=ERROR

    ${Actual_Surname}    Get Value    ${SSO_Surname_textfield}
    Run Keyword And Continue On Failure    Textfield Value Should Be    ${SSO_Surname_textfield}    ${sLName}
    ${IsMatched_Surname}    Run Keyword And Return Status    Textfield Value Should Be    ${SSO_Surname_textfield}    ${sLName}
    Run Keyword If    ${IsMatched_Surname}==True    Log    Correct!! Surname is '${sLName}'.
    ...    ELSE    Log    Incorrect!! Expected value: '${sLName}'. Actual value: '${Actual_Surname}'.    level=ERROR

    ## to be confirmed if mandatory
    ${Actual_BusinessTitle}    Get Value    ${SSO_BusinessTitle_textfield}
    Run Keyword And Continue On Failure    Textfield Value Should Be    ${SSO_BusinessTitle_textfield}    ${input_businesstitle}
    ${IsMatched_BusinessTitle}    Run Keyword And Return Status    Textfield Value Should Be    ${SSO_BusinessTitle_textfield}    ${input_businesstitle}
    Run Keyword If    ${IsMatched_BusinessTitle}==True    Log    Correct!! Business Title is '${input_businesstitle}'.
    ...    ELSE    Log    Incorrect!! Expected value: '${input_businesstitle}'. Actual value: '${Actual_BusinessTitle}'.    level=ERROR

    ${Actual_CountryCode}    Get Value    ${SSO_UserCountryCode_dropdown}
    Run Keyword And Continue On Failure    Textfield Value Should Be    ${SSO_UserCountryCode_dropdown}    ${sCountryCodeDesc}-${sCountryCode}
    ${IsMatched_CC}    Run Keyword And Return Status    Textfield Value Should Be    ${SSO_UserCountryCode_dropdown}    ${sCountryCodeDesc}-${sCountryCode}
    Run Keyword If    ${IsMatched_CC}==True    Log    Correct!! User's Country Code is '${sCountryCodeDesc}-${sCountryCode}'.
    ...    ELSE    Log    Incorrect!! Expected value: '${sCountryCodeDesc}-${sCountryCode}'. Actual value: '${Actual_CountryCode}'.    level=ERROR

Validate Enquire User Page Other Fields
    [Documentation]    This keyword is used to validate Enquire User Page other fields.
    ...    @author: clanding
    ...    @update: clanding    08APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...    @update: clanding    25APR2019    - add screenshot
    ...    @update: xmiranda    22JUL2019    - Added codes and condition for SSO_AssocApps_tablegrid. If count is equal to 0, then it won't scroll down the the SSO_AssocApps_tablegrid element. 
    ...    @update: xmiranda    23JUL2019    - Changed the Deprecated Keyword "Get Matching Xpath Count" to "Get Element Count"
    ...    @update: jloretiz    24JUL2019    - add additional condition to validate created user without centralUserType and userType
    ...    @update: jloretiz    29JUL2019    - add additional condition to validate created user without contactNumber and email
    [Arguments]    ${sUserTypeDesc}    ${sLanguage}    ${sLocale}    ${iContactNum1}    ${sEmail}    ${sOSUserID}

    ${sOSUserID}    Run Keyword If    '${sOSUserID}'=='no tag' or '${sOSUserID}'=='null'    Set Variable
    ...    ELSE    Set Variable    ${sOSUserID}
    ${Actual_OSUserID}    Get Value    ${SSO_OSUserID_textfield}
    Run Keyword And Continue On Failure    Textfield Should Contain    ${SSO_OSUserID_textfield}    ${sOSUserID}
    ${IsMatched_OSUserID}    Run Keyword And Return Status    Textfield Should Contain    ${SSO_OSUserID_textfield}    ${sOSUserID}
    Run Keyword If    ${IsMatched_OSUserID}==True    Log    Matched!! SO User ID is correct: '${sOSUserID}' = '${Actual_OSUserID}'
    ...    ELSE    Log    Not Matched!! SO User ID is INCORRECT. Expected value: '${sOSUserID}'. Actual value: '${Actual_OSUserID}'.    level=ERROR

    ${sLocale}    Run Keyword If    '${sLocale}'=='no tag' or '${sLocale}'=='null'    Set Variable    en
    ...    ELSE    Set Variable    ${sLocale}
    ${Actual_Language}    Get Value    ${SSO_UserLanguageCode_dropdown}
    Run Keyword And Continue On Failure    Textfield Should Contain    ${SSO_UserLanguageCode_dropdown}    ${sLanguage}-${sLocale}
    ${IsMatched_Language}    Run Keyword And Return Status    Textfield Should Contain    ${SSO_UserLanguageCode_dropdown}    ${sLanguage}-${sLocale}
    Run Keyword If    ${IsMatched_Language}==True    Log    Matched!! Language is correct: '${sLanguage}-${sLocale}' = '${Actual_Language}'
    ...    ELSE    Log    Not Matched!! Language is INCORRECT. Expected value: '${sLanguage}-${sLocale}'. Actual value: '${Actual_Language}'.    level=ERROR
    
    ${iContactNum1}    Run Keyword If    '${iContactNum1}'=='no tag' or '${iContactNum1}'=='null' or '${iContactNum1}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${iContactNum1}
    ${Actual_Phone}    Get Value    ${SSO_Phone_textfield}
    Run Keyword And Continue On Failure    Textfield Should Contain    ${SSO_Phone_textfield}    ${iContactNum1}
    ${IsMatched_Phone}    Run Keyword And Return Status    Textfield Should Contain    ${SSO_Phone_textfield}    ${iContactNum1}
    Run Keyword If    ${IsMatched_Phone}==True    Log    Matched!! Phone is correct: '${iContactNum1}' = '${Actual_Phone}'
    ...    ELSE    Log    Not Matched!! Phone is INCORRECT. Expected value: '${iContactNum1}'. Actual value: '${Actual_Phone}'.    level=ERROR
    
    ${sEmail}    Run Keyword If    '${sEmail}'=='no tag' or '${sEmail}'=='null' or '${sEmail}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sEmail}
    ${Actual_Email}    Get Value    ${SSO_Email_textfield}
    Run Keyword And Continue On Failure    Textfield Should Contain    ${SSO_Email_textfield}    ${sEmail}
    ${IsMatched_Email}    Run Keyword And Return Status    Textfield Should Contain    ${SSO_Email_textfield}    ${sEmail}
    Run Keyword If    ${IsMatched_Email}==True    Log    Matched!! Email is correct: '${sEmail}' = '${Actual_Email}'
    ...    ELSE    Log    Not Matched!! Email is INCORRECT. Expected value: '${sEmail}'. Actual value: '${Actual_Email}'.    level=ERROR

    ${Actual_UserType}    Get Value    ${SSO_UserType_dropdown}
    ${sUserTypeDesc}    Run Keyword If    '${sUserTypeDesc}'=='None'    Set Variable    Normal
    ...    ELSE    Set Variable    ${sUserTypeDesc}
    Run Keyword And Continue On Failure    Textfield Value Should Be    ${SSO_UserType_dropdown}    ${sUserTypeDesc}
    ${IsMatched_UserType}    Run Keyword And Return Status    Textfield Value Should Be    ${SSO_UserType_dropdown}    ${sUserTypeDesc}
    Run Keyword If    ${IsMatched_UserType}==True    Log    Correct!! Branch Sort Code is '${sUserTypeDesc}'.
    ...    ELSE    Log    Incorrect!! Expected value: '${sUserTypeDesc}'. Actual value: '${Actual_UserType}'.    level=ERROR
    
    Take Screenshot    SSO_EnquireUserPage_Fields
    ${Count}    SeleniumLibraryExtended.Get Element Count     ${SSO_AssocApps_tablegrid}
    Run Keyword If    ${Count} == 0    Log    No Data Found in the Table
    ...    ELSE    Mx Scroll Element Into View    ${SSO_AssocApps_tablegrid}
    Take Screenshot    SSO_EnquireUserPage_Table
    
Validate Enquire User Page Associated Tables
    [Documentation]    This keyword is used to validate Enquire User Page associated tables.
    ...    @author: clanding
    ...    @update: clanding    21DEC2019    - Removing validation of Role, refer to GDE-1902 - Role will no longer be mapped in SSO
    ...    @update: clanding    08APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...    @update: dahijara    18JUL2019    - added \ on index for element, this is an update for robot to consider it as a string not an index of
    [Arguments]    ${aRoleList}    ${aApplicationList}

    ${Config_ALL_Null}    OperatingSystem.Get File    ${Valid_LOB}
    ${Not_A_List}    Run Keyword And Return Status    Should Be String    ${aApplicationList}
    @{aApplicationList}    Run Keyword If    ${Not_A_List}==True    Split String    ${aApplicationList}    ,
    ...    ELSE    Set Variable    ${aApplicationList}
    ${JSON_App_Count}    Get Length    ${aApplicationList}
    ${Table_App_Count}    SeleniumLibraryExtended.Get Element Count    ${SSO_AssocApps_tablegrid}
    Run Keyword And Continue On Failure    Should Be Equal    '${JSON_App_Count}'    '${Table_App_Count}'
    ${App_Count}    Run Keyword And Return Status    Should Be Equal    '${JSON_App_Count}'    '${Table_App_Count}'
    Run Keyword If    ${App_Count}==True    Log    Application count from input json and Enquire User table are EQUAL: ${JSON_App_Count} = ${Table_App_Count}
    ...    ELSE    Log    Application count from input json and Enquire User table are UNEQUAL: ${JSON_App_Count} != ${Table_App_Count}    level=ERROR

    
    ${Count+1}    Evaluate    ${Table_App_Count}+1
    :FOR    ${INDEX}    IN RANGE    1    ${Count+1}
    \    ${AssocApp_Table}    Get Text    ${SSO_AssocApps_tablegrid}\[${INDEX}]${SSO_AssocApps_tablegrid_values}
    \    Run Keyword And Continue On Failure    Should Contain    ${aApplicationList}    ${AssocApp_Table}
    \    ${IsMatched_AssociatedApplication}    Run Keyword And Return Status    Should Contain    ${aApplicationList}    ${AssocApp_Table}
    \    Run Keyword If    ${IsMatched_AssociatedApplication}==True    Log    '${AssocApp_Table}' is in the List: ${aApplicationList}.
         ...    ELSE    Log    '${AssocApp_Table}' is NOT in the List: ${aApplicationList}.    level=ERROR
    \    Exit For Loop If    ${INDEX}>${Count+1}

    ## Zone is defaulted to BF for SSO --- this is configured in mdm.config.properties
    ${Input_ZoneList}    OperatingSystem.Get File    ${Zone_Config}
    @{Input_ZoneList}    Split String    ${Input_ZoneList}    ,
    ${JSON_Zone_Count}    Get Length    ${Input_ZoneList}
    ${Input_BranchCode}    Get From List    ${Input_ZoneList}    0

    ${TableZone_Count}    SeleniumLibraryExtended.Get Element Count    ${SSO_AssocZones_tablegrid}
    Run Keyword And Continue On Failure    Should Be Equal    '${JSON_Zone_Count}'    '${TableZone_Count}'
    ${ZoneCount}    Run Keyword And Return Status    Should Be Equal    '${JSON_Zone_Count}'    '${TableZone_Count}'
    Run Keyword If    ${ZoneCount}==True    Log    Zone count from input json and Enquire User table are EQUAL: ${JSON_Zone_Count} = ${TableZone_Count}
    ...    ELSE    Log    Zone count from input json and Enquire User table are UNEQUAL: ${JSON_Zone_Count} != ${TableZone_Count}    level=ERROR
    ${Count+1}    Evaluate    ${TableZone_Count}+1
    :FOR    ${INDEX}    IN RANGE    1    ${Count+1}
    \    ${AssocZone_Table}    Get Text    ${SSO_AssocZones_tablegrid}\[${INDEX}]${SSO_AssocZones_tablegrid_values}
    \    Run Keyword And Continue On Failure    Should Contain    ${Input_ZoneList}    ${AssocZone_Table}
    \    ${assoczone_match}    Run Keyword And Return Status    Should Contain    ${Input_ZoneList}    ${AssocZone_Table}
    \    Run Keyword If    ${assoczone_match}==True    Log    '${AssocZone_Table}' is in the List: ${Input_ZoneList}.
         ...    ELSE    Log    '${AssocZone_Table}' is NOT in the List: ${Input_ZoneList}.    level=ERROR
    \    Exit For Loop If    ${INDEX}>${Count+1}


Get Defined Description for Other Code Values
    [Documentation]    This keyword is used to get User Type description based from 'centralUserType' in the payload.
    ...    @author: clanding
    ...    @update: clanding    08APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...                                      - updated according to GDE-1566
    [Arguments]    ${sCentralUserType}

    ${SSO_UserTypeDesc}    Run Keyword If    '${sCentralUserType}'=='N'    Set Variable    Normal
    ...    ELSE IF    '${sCentralUserType}'=='S'    Set Variable    Supervisor
    ...    ELSE IF    '${sCentralUserType}'=='T'    Set Variable    Teller
    ...    ELSE IF    '${sCentralUserType}'=='I'    Set Variable    Interface User
    ...    ELSE IF    '${sCentralUserType}'=='C'    Set Variable    Call Center User
    ...    ELSE IF    '${sCentralUserType}'=='A'    Set Variable    Central Administrator

    ###Get Language, per Sriharsha - language in SSO is defaulted to English
    ${SSO_Language_Desc}    Set Variable    English

    [Return]    ${SSO_UserTypeDesc}    ${SSO_Language_Desc}

Search User ID only
    [Documentation]    This keyword is used to search User ID on SSO main page.
    ...    @author: clanding
    ...    @update: clanding    08APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sUserID}
    Wait Until Element Is Visible     ${SSO_Process_Textfield}    timeout=20s
    Input Text    ${SSO_Process_Textfield}    Enquire User
    Press key    ${SSO_Process_Textfield}   ${Keyboard_Enter}
    Wait Until Element Is Visible     ${SSO_UserID_textfield}    timeout=20s
    Mx Input Text    ${SSO_UserID_textfield}    ${sUserID}
    Click Element    ${SSO_Search_button}
    Wait Until Element Is Visible    ${SSO_SearchUser_UserID_textfield}    timeout=20s
    ${Count}    Get Matching Xpath Count    ${SSO_UserID_Row_table}
    ${Count+1}    Evaluate    ${Count}+1
    @{CountList}    Create List
    :FOR    ${INDEX}    IN RANGE    1    ${Count+1}
    \    ${User_Table}    Get Text    ${SSO_Results_table}\[${INDEX}]${SSO_UserID_Col}
    \    ${USER_MATCH}    Run Keyword And Return Status    Should Be Equal    ${sUserID}    ${User_Table}
    \    Run Keyword If    ${USER_MATCH}==True    Run Keywords    Log    Users Matched! ${sUserID} = ${User_Table}
         ...    AND    Click Element    ${SSO_Results_table}\[${INDEX}]${SSO_RadioButton_Col}
    \    Exit For Loop If    ${USER_MATCH}==True
    Click Element    ${SSO_SearchUser_Next_button}
    Wait Until Element Is Visible    ${SSO_GivenName_textfield}
    [Return]    ${USER_MATCH}

Search User ID in Enquire User Page for Successful Delete
    [Documentation]    This keyword is used to search User ID on SSO main page and validate that User is deleted from SSO.
    ...    @author: clanding    20DEC2018    - initial create
    ...    @update: amansuet    15AUG2019    - removed index in Element Should Not Be Visible as it is a string
    [Arguments]    ${sUserID}

    Wait Until Element Is Visible     ${SSO_Process_Textfield}    timeout=20s
    Input Text    ${SSO_Process_Textfield}    Enquire User
    Press key    ${SSO_Process_Textfield}   ${Keyboard_Enter}
    Wait Until Element Is Visible     ${SSO_UserID_textfield}    timeout=20s
    Mx Input Text    ${SSO_UserID_textfield}    ${sUserID}
    Click Element    ${SSO_Search_button}
    Wait Until Element Is Visible    ${SSO_SearchUser_UserID_textfield}    timeout=20s
    Mx Input Text    ${SSO_SearchUser_UserID_textfield}    ${sUserID}
    Click Element    ${SSO_SearchUser_Search_button}
    ${SSO_User_Not_Found_Label_Status}    Run Keyword And Return Status    Element Should Be Visible    ${SSO_User_Not_Found_Label}
    Run Keyword If    ${SSO_User_Not_Found_Label_Status}==True    Log    Correct!!! User(s) not found
    ...    ELSE    Log    Incorrect!!! User still exist.    level=ERROR
    Element Should Not Be Visible    ${SSO_Results_table}${SSO_UserID_Col}
    Take Screenshot    SSO_Search_UserNotFound
    Click Element    ${SSO_Close_Dialog}
    Wait Until Element Is Visible    ${SSO_GivenName_textfield}
    ${Given_Name_Empty}    Run Keyword And Return Status    SeleniumLibraryExtended.Element Text Should Be    ${SSO_GivenName_textfield}    ${EMPTY}
    Run Keyword If    ${Given_Name_Empty}==True    Log    Correct!! Given Name is blank.
    ...    ELSE    Log    Incorrect!! Given Name is populated.    level=ERROR
    Take Screenshot    SSO_Search_GivenNameEmpty

Search User ID in Enquire User Page for unsuccessful Delete
    [Documentation]    This keyword is used to search User ID on SSO main page and validate that User is not deleted from SSO.
    ...    @author: clanding
    ...    @update: clanding    08APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sUserID}    ${sUserType}    ${sCountryCode}    ${sGivenName}
    Wait Until Element Is Visible     ${SSO_Process_Textfield}    timeout=20s
    Input Text    ${SSO_Process_Textfield}    Enquire User
    Press key    ${SSO_Process_Textfield}   ${Keyboard_Enter}
    Wait Until Element Is Visible     ${SSO_UserID_textfield}    timeout=20s
    Mx Input Text    ${SSO_UserID_textfield}    ${sUserID}
    Click Element    ${SSO_Search_button}
    Wait Until Element Is Visible    ${SSO_SearchUser_UserID_textfield}    timeout=20s
    ${Count}    Get Matching Xpath Count    ${SSO_UserID_Row_table}
    ${Count+1}    Evaluate    ${Count}+1
    @{CountList}    Create List
    :FOR    ${INDEX}    IN RANGE    1    ${Count+1}
    \    ${User_Table}    Get Text    ${SSO_Results_table}\[${INDEX}]${SSO_UserID_Col}
    \    ${USER_MATCH}    Run Keyword And Return Status    Should Be Equal    ${sUserID}    ${User_Table}
    \    Run Keyword If    ${USER_MATCH}==True    Run Keywords    Log    Users Matched! ${sUserID} = ${User_Table}
         ...    AND    Click Element    ${SSO_Results_table}\[${INDEX}]${SSO_RadioButton_Col}
    \    ${UserType_Table}    Run Keyword If    ${USER_MATCH}==True    Get Text    ${SSO_Results_table}\[${INDEX}]${SSO_UserType}
    \    Run Keyword If    ${USER_MATCH}==True    Run Keyword And Continue On Failure    Should Be Equal    ${sUserType}    ${UserType_Table}
    \    ${UserType_stat}    Run Keyword If    ${USER_MATCH}==True    Run Keyword And Return Status    Should Be Equal    ${sUserType}    ${UserType_Table}
    \    Run Keyword If    ${UserType_stat}==True    Log    Matched! User Type is correct. '${sUserType}' = '${UserType_Table}'
         ...    ELSE IF    ${UserType_stat}==False    Fail    Not Matched! Expected value: '${sUserType}'. Actual value: '${UserType_Table}'.
    \    ${CountryCode_Table}    Run Keyword If    ${USER_MATCH}==True    Get Text    ${SSO_Results_table}\[${INDEX}]${SSO_CountryCode}
    \    Run Keyword If    ${USER_MATCH}==True    Run Keyword And Continue On Failure    Should Be Equal    ${sCountryCode}    ${CountryCode_Table}
    \    ${CountryCode_stat}    Run Keyword If    ${USER_MATCH}==True    Run Keyword And Return Status    Should Be Equal    ${sCountryCode}    ${CountryCode_Table}
    \    Run Keyword If    ${CountryCode_stat}==True    Log    Matched! Country Code is correct. '${sCountryCode}' = '${CountryCode_Table}'
         ...    ELSE IF      ${CountryCode_stat}==False    Fail    Not Matched! Expected value: '${sCountryCode}'. Actual value: '${CountryCode_Table}'.
    \    Run Keyword If    ${INDEX}>${Count+1} and ${USER_MATCH}==False    Log    No Users Matched on the table!!
    \    Exit For Loop If    ${USER_MATCH}==True
    Click Element    ${SSO_SearchUser_Next_button}
    Wait Until Element Is Visible    ${SSO_GivenName_textfield}
    ${Actual_GivenName}    Get Value    ${SSO_GivenName_textfield}
    Run Keyword And Continue On Failure    Textfield Value Should Be    ${SSO_GivenName_textfield}    ${sGivenName}
    ${GivenName_Stat}    Run Keyword And Return Status    Textfield Value Should Be    ${SSO_GivenName_textfield}    ${sGivenName}
    Run Keyword If    ${GivenName_Stat}==True    Log    Correct!! Given Name is '${sGivenName}'.
    ...    ELSE    Log    Incorrect!! Expected value: '${sGivenName}'. Actual value: '${Actual_GivenName}'.    level=ERROR

Search User ID in Enquire User Page and Validate User Does Not Exist
    [Documentation]    This keyword is used to search User ID on SSO Enquire User page and verify that user is not existing.
    ...    @author: jaquitan/chanario
    ...    @update: clanding    08APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...    @update: clanding    23APR2019    - updated keyword name and documentation, updated handling for failed condition, added screenshot
    [Arguments]    ${sUserID}
    Wait Until Element Is Visible     ${SSO_Process_Textfield}    timeout=20s
    Input Text    ${SSO_Process_Textfield}    Enquire User
    Press key    ${SSO_Process_Textfield}   ${Keyboard_Enter}
    Wait Until Element Is Visible     ${SSO_UserID_textfield}    timeout=20s
    Mx Input Text    ${SSO_UserID_textfield}    ${sUserID}
    Click Element    ${SSO_Search_button}
    Wait Until Element Is Visible    ${SSO_SearchUser_UserID_textfield}
    Mx Input Text    ${SSO_SearchUser_UserID_textfield}    ${sUserID}
    Click Element    ${SSO_SearchUser_Search_button}
    ${User_Found}    Run Keyword And Return Status    Click Element    ${SSO_Results_table}[1]${SSO_UserID_Col}
    Run Keyword If    ${User_Found}==${False}    Log    User '${sUserID}' does not exist.
    ...    ELSE    Log    User '${sUserID}' exist.    level=ERROR
    Take Screenshot    SSO_SearchUser
    
Get SSO User Values in Enquire User Page
    [Documentation]    This keyword is used to get values from sso
    ...    @author: jaquitan/clanding
    ...    @update: clanding    08APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...    @update: clanding    25APR2019    - add handling when Login ID is not found
    ...    @update: clanding    26APR2019    - add scroll to element and screenshot
    ...    @update: dahijara    18JUL2019    - added \ on index for element, this is an update for robot to consider it as a string not an index of
    ...    @update: xmiranda    27AUG2019    - added a global variable for User Type Code
    [Arguments]    ${sUserID}    ${aRoleList}    ${input_lobslist}

    Wait Until Element Is Visible     ${SSO_Process_Textfield}    timeout=20s
    Input Text    ${SSO_Process_Textfield}    Enquire User
    Press key    ${SSO_Process_Textfield}   ${Keyboard_Enter}
    Wait Until Element Is Visible     ${SSO_UserID_textfield}    timeout=20s
    Mx Input Text    ${SSO_UserID_textfield}    ${sUserID}
    Click Element    ${SSO_Search_button}
    Wait Until Element Is Visible    ${SSO_SearchUser_UserID_textfield}    timeout=20s
    Mx Input Text    ${SSO_SearchUser_UserID_textfield}    ${sUserID}
    Click Element    ${SSO_SearchUser_Search_button}
    ${Count}    SeleniumLibraryExtended.Get Element Count    ${SSO_Results_table}${SSO_UserID_Col}
    Run Keyword If    ${Count}==0    Fail    User '${sUserID}' not found.
    ...    ELSE    Log    User '${sUserID}' found.
    Take Screenshot    Essence_SearchUser
    ${SSO_UserID}    Get Text    ${SSO_Results_table}\[1]${SSO_UserID_Col}
    ${UserType_Table}    Get Text    ${SSO_Results_table}\[1]${SSO_UserType}
    ${CountryCode_Table}    Get Text    ${SSO_Results_table}\[1]${SSO_CountryCode}
    Click Element    ${SSO_SearchUser_Next_button}
    ${SSO_FirstName}    Get Value    ${SSO_GivenName_textfield}
    ${SSO_SurName}    Get Value    ${SSO_Surname_textfield}
    ${SSO_TitleCode}    Get Value    ${SSO_BusinessTitle_textfield}
    ${SSO_Email}    Get Value    ${SSO_Email_textfield}
    ${SSO_Phone}    Get Value    ${SSO_Phone_textfield}
    ${SSO_Locale}    Get Value    ${SSO_UserLanguageCode_dropdown}
    ${SSO_OSUserID}    Get Value    ${SSO_OSUserID_textfield}
    ${SSO_Country}    Get Value    ${SSO_UserCountryCode_dropdown}
    ${SSO_UserType}    Get Value    ${SSO_UserType_dropdown}
    
    Take Screenshot    SSO_Get_EnquireUserPage_Fields
    Mx Scroll Element Into View    ${SSO_AssocApps_tablegrid}
    Take Screenshot    SSO_Get_EnquireUserPage_Table
    ${JSON_Roles_Count}    Get Length    ${aRoleList}
    ${Table_Roles_Count}    SeleniumLibraryExtended.Get Element Count    ${SSO_AssocRoles_tablegrid}
    ${Tabel_Roles_List}    Create List
    ${Count+1}    Evaluate    ${Table_Roles_Count}+1
    :FOR    ${INDEX}    IN RANGE    1    ${Count+1}
    \    ${AssocRoles_Table}    Get Text    ${SSO_AssocRoles_tablegrid}\[${INDEX}]${SSO_AssocRoles_tablegrid_values}
    \    Append To List    ${Tabel_Roles_List}    ${AssocRoles_Table}
    \    Exit For Loop If    ${INDEX}>${Count+1}

    ### app count from json
    @{aApplicationList}    Split String    ${input_lobslist}    ,
    ${JSON_App_Count}    Get Length    ${aApplicationList}
    ### app count from the table
    ${Table_App_Count}    SeleniumLibraryExtended.Get Element Count    ${SSO_AssocApps_tablegrid}
    ${TableApp_List}    Create List
    ${Count+1}    Evaluate    ${Table_App_Count}+1
    :FOR    ${INDEX}    IN RANGE    1    ${Count+1}
    \    ${AssocApp_Table}    Get Text    ${SSO_AssocApps_tablegrid}\[${INDEX}]${SSO_AssocApps_tablegrid_values}
    \    Append To List    ${TableApp_List}    ${AssocApp_Table}
    \    Exit For Loop If    ${INDEX}>${Count+1}

    ${SSO_GLOBAL_USERID}    Set Variable    ${SSO_UserID}
    ${SSO_GLOBAL_USERTYPECODE}    Set Variable    ${UserType_Table}
    ${SSO_GLOBAL_COUNTRYCODE}    Set Variable    ${CountryCode_Table}
    ${SSO_GLOBAL_FIRSTNAME}    Set Variable    ${SSO_FirstName}
    ${SSO_GLOBAL_SURNAME}    Set Variable    ${SSO_SurName}
    ${SSO_GLOBAL_TITLECODE}    Set Variable    ${SSO_TitleCode}
    ${SSO_GLOBAL_EMAIL}    Set Variable    ${SSO_Email}
    ${SSO_GLOBAL_LOB}    Set Variable    ${TableApp_List}
    ${SSO_GLOBAL_ROLE}    Set Variable    ${Tabel_Roles_List}
    ${SSO_GLOBAL_PHONE}    Set Variable    ${SSO_Phone}
    ${SSO_GLOBAL_LOCALE}    Set Variable    ${SSO_Locale}
    ${SSO_GLOBAL_OSUSERID}    Set Variable    ${SSO_OSUserID}
    ${SSO_GLOBAL_COUNTRY}    Set Variable    ${SSO_Country}
    ${SSO_GLOBAL_USERTYPE}    Set Variable    ${SSO_UserType}

    Set Global Variable    ${SSO_GLOBAL_USERID}
    Set Global Variable    ${SSO_GLOBAL_USERTYPECODE}
    Set Global Variable    ${SSO_GLOBAL_COUNTRYCODE}
    Set Global Variable    ${SSO_GLOBAL_FIRSTNAME}
    Set Global Variable    ${SSO_GLOBAL_SURNAME}
    Set Global Variable    ${SSO_GLOBAL_TITLECODE}
    Set Global Variable    ${SSO_GLOBAL_EMAIL}
    Set Global Variable    ${SSO_GLOBAL_LOB}
    Set Global Variable    ${SSO_GLOBAL_ROLE}
    Set Global Variable    ${SSO_GLOBAL_PHONE}
    Set Global Variable    ${SSO_GLOBAL_LOCALE}
    Set Global Variable    ${SSO_GLOBAL_OSUSERID}
    Set Global Variable    ${SSO_GLOBAL_COUNTRY}
    Set Global Variable    ${SSO_GLOBAL_USERTYPE}

Validate SSO Data
    [Documentation]    This keyword is used to validate
    # [Arguments]    ${SSO_GLOBAL_USERID}    ${SSO_GLOBAL_EMAIL}    ${SSO_GLOBAL_ROLE}    ${SSO_GLOBAL_COUNTRYCODE}    ${SSO_GLOBAL_LOB}
    # ...    ${SSO_GLOBAL_COUNTRYCODE}    ${SSO_GLOBAL_TITLECODE}    ${SSO_GLOBAL_FIRSTNAME}    ${SSO_GLOBAL_SURNAME}    ${SSO_GLOBAL_OSUSERID}    ${SSO_GLOBAL_USERTYPE}
    Wait Until Element Is Visible     ${SSO_Process_Textfield}    timeout=20s
    Input Text    ${SSO_Process_Textfield}    Enquire User
    Press key    ${SSO_Process_Textfield}   ${Keyboard_Enter}
    Wait Until Element Is Visible     ${SSO_UserID_textfield}    timeout=20s
    Mx Input Text    ${SSO_UserID_textfield}    ${SSO_GLOBAL_USERID}
    Click Element    ${SSO_Search_button}
    Wait Until Element Is Visible    ${SSO_SearchUser_UserID_textfield}    timeout=20s
    Mx Input Text    ${SSO_SearchUser_UserID_textfield}    ${SSO_GLOBAL_USERID}
    Click Element    ${SSO_SearchUser_Search_button}

    ${User_Table}    Get Text    ${SSO_Results_table}[1]${SSO_UserID_Col}
    ${CountryCode_Table}    Get Text    ${SSO_Results_table}[1]${SSO_CountryCode}
    ${UserType_Table}    Get Text    ${SSO_Results_table}[1]${SSO_UserType}
    Run Keyword And Continue On Failure    Should Match   ${User_Table}    ${SSO_GLOBAL_USERID}
    Run Keyword And Continue On Failure    Should Match   ${CountryCode_Table}    ${SSO_GLOBAL_COUNTRYCODE}
    Run Keyword And Continue On Failure    Should Match   ${UserType_Table}    ${SSO_GLOBAL_USERTYPE}

    Click Element    ${SSO_SearchUser_Next_button}

    ${email}    Get Value    ${SSO_Email_textfield}
    ${lob}    Get Text    ${SSO_AssocApps_tablegrid}[1]${SSO_AssocApps_tablegrid_values}
    ${role}    Get Text    ${SSO_AssocRoles_tablegrid}[1]${SSO_AssocRoles_tablegrid_values}
    Run Keyword And Continue On Failure    Should Match   ${email}    ${SSO_GLOBAL_EMAIL}
    Run Keyword And Continue On Failure    Should Contain   ${SSO_GLOBAL_LOB}    ${lob}
    Run Keyword And Continue On Failure    Should Contain   ${SSO_GLOBAL_ROLE}    ${role}

Compare SSO Data from Input Data
    [Documentation]    This keyword is used to compare SSO data from Input data if update is done for the specific element.
    ...    @author: clanding
    ...    @update: clanding    22APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...    @update: jdelacru    07NOV2019    - added Return From Keyword If to handle if SSO is enabled/disabled
    [Arguments]    ${sCountryCode_2Code}    ${sCountryDesc}    ${sCentralUserType}    ${sCentralRoles}    ${sLoginID}    ${sJobTitle}
    ...    ${sFName}    ${sLName}    ${sEmail}    ${iContactNum1}    ${sLocale}    ${sOSUserID}    ${sLOBs_from_Excel}

    Return From Keyword If    '${SSO_ENABLED}'=='NO'
    
    ${SSO_UserType_Desc}    ${SSO_Language_Desc}    Get Defined Description for Other Code Values    ${sCentralUserType}
    ${SSO_Role_List}    Get Role Value from Config Setup    ${sCentralRoles}

    ${NOCHANGE_SSO_USERID}    Run Keyword And Return Status    Should Be Equal As Strings    ${sLoginID}    ${SSO_GLOBAL_USERID}
    ${NOCHANGE_SSO_JOBTITLE}    Run Keyword And Return Status    Should Be Equal As Strings    ${sJobTitle}    ${SSO_GLOBAL_TITLECODE}
    ${NOCHANGE_SSO_FIRSTNAME}    Run Keyword And Return Status    Should Be Equal As Strings    ${sFName}    ${SSO_GLOBAL_FIRSTNAME}
    ${NOCHANGE_SSO_SURNAME}    Run Keyword And Return Status    Should Be Equal As Strings    ${sLName}    ${SSO_GLOBAL_SURNAME}
    ${NOCHANGE_SSO_COUNTRYCODE}    Run Keyword And Return Status    Should Be Equal As Strings    ${sCountryCode_2Code}    ${SSO_GLOBAL_COUNTRYCODE}
    ${NOCHANGE_SSO_COUNTRY}    Run Keyword And Return Status    Should Be Equal As Strings    ${sCountryDesc}-${sCountryCode_2Code}    ${SSO_GLOBAL_COUNTRY}
    ${NOCHANGE_SSO_EMAIL}    Run Keyword And Return Status    Should Be Equal As Strings    ${sEmail}    ${SSO_GLOBAL_EMAIL}
    ${NOCHANGE_SSO_CONTACTNUMBER1}    Run Keyword And Return Status    Should Be Equal As Strings    ${iContactNum1}    ${SSO_GLOBAL_PHONE}
    ${sLocale}    Run Keyword If    '${sLocale}'=='no tag' or '${sLocale}'=='null' or '${sLocale}'==''    Set Variable    en
    ...    ELSE    Set Variable    ${sLocale}
    ${NOCHANGE_SSO_LANGUAGE}    Run Keyword And Return Status    Should Be Equal As Strings    ${SSO_Language_Desc}-${sLocale}    ${SSO_GLOBAL_LOCALE}
    ${sOSUserID}    Run Keyword If    '${sOSUserID}'=='no tag' or '${sOSUserID}'=='null' or '${sOSUserID}'==''    Set Variable
    ...    ELSE    Set Variable    ${sOSUserID}
    ${NOCHANGE_SSO_OSUSERID}    Run Keyword And Return Status    Should Be Equal As Strings    ${sOSUserID}    ${SSO_GLOBAL_OSUSERID}
    ${NOCHANGE_SSO_USERTYPE}    Run Keyword And Return Status    Should Be Equal As Strings    ${sCentralUserType}    ${SSO_GLOBAL_USERTYPE}
    ${NOCHANGE_SSO_USERTYPE_DROPDOWN}    Run Keyword And Return Status    Should Be Equal As Strings    ${SSO_UserType_Desc}    ${SSO_GLOBAL_USERTYPE}

    @{aApplicationList}    Split String    ${sLOBs_from_Excel}    ,
    ${JSON_App_Count}    Get Length    ${aApplicationList}

    :FOR    ${INDEX_0}    IN RANGE    ${INDEX_0}    ${JSON_App_Count}
    \    Exit For Loop If    '${INDEX_0}'=='${JSON_App_Count}'
    \    ${App}    Get From List    ${SSO_GLOBAL_LOB}    ${INDEX_0}
    \    ${NOCHANGE_SSO_APP}    Run Keyword And Return Status    Should Contain    ${aApplicationList}    ${App}

    Set Global Variable    ${NOCHANGE_SSO_USERID}
    Set Global Variable    ${NOCHANGE_SSO_JOBTITLE}
    Set Global Variable    ${NOCHANGE_SSO_FIRSTNAME}
    Set Global Variable    ${NOCHANGE_SSO_SURNAME}
    Set Global Variable    ${NOCHANGE_SSO_COUNTRYCODE}
    Set Global Variable    ${NOCHANGE_SSO_EMAIL}
    Set Global Variable    ${NOCHANGE_SSO_CONTACTNUMBER1}
    Set Global Variable    ${NOCHANGE_SSO_LANGUAGE}
    Set Global Variable    ${NOCHANGE_SSO_OSUSERID}
    Set Global Variable    ${NOCHANGE_SSO_COUNTRY}
    Set Global Variable    ${NOCHANGE_SSO_USERTYPE}
    Set Global Variable    ${NOCHANGE_SSO_APP}
    Set Global Variable    ${NOCHANGE_SSO_USERTYPE_DROPDOWN}

Search User ID in Enquire User Page for Put
    [Documentation]    This keyword is used to search User ID on SSO main page.
    ...    @author: clanding
    ...    @update: clanding    08APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...    @update: clanding    24APR2019    - added arguments ${sLoginID} and ${sCentralUserType}
    ...    @update: clanding    26APR2019    - added hanlding when sCentralUserType have different codes
    ...    @update: dahijara    15AUG2019    - Get Matching Xpath Count' is deprecated. Updated keyword with `Get Element Count` instead.
    ...    @update: xmiranda    27AUG2019    - Updated the set variable for UserType
    [Arguments]    ${sCountryCode}    ${sLoginID}    ${sCentralUserType}
    Wait Until Element Is Visible     ${SSO_Process_Textfield}    timeout=20s
    Input Text    ${SSO_Process_Textfield}    Enquire User
    Press key    ${SSO_Process_Textfield}   ${Keyboard_Enter}
    Wait Until Element Is Visible     ${SSO_UserID_textfield}    timeout=20s

    ${UserID}    Run Keyword If    ${NOCHANGE_SSO_USERID}==${True}    Set Variable    ${SSO_GLOBAL_USERID}
    ...    ELSE    Set Variable    ${sLoginID}

    ${UserType}    Run Keyword If    ${NOCHANGE_SSO_USERTYPE}==${True}    Set Variable    ${SSO_GLOBAL_USERTYPECODE}
    ...    ELSE    Set Variable    ${sCentralUserType}

    ${UserTypeDesc}    Run Keyword If    '${sCentralUserType}'=='NR'    Set Variable    N
    ...    ELSE IF    '${sCentralUserType}'=='IU'   Set Variable    I
    ...    ELSE IF    '${sCentralUserType}'=='AC'    Set Variable    A

    ${CountryCode}    Run Keyword If    ${NOCHANGE_SSO_COUNTRYCODE}==${True}    Set Variable    ${SSO_GLOBAL_COUNTRYCODE}
    ...    ELSE    Set Variable    ${sCountryCode}

    Mx Input Text    ${SSO_UserID_textfield}    ${UserID}
    Click Element    ${SSO_Search_button}
    Wait Until Element Is Visible    ${SSO_SearchUser_UserID_textfield}    timeout=20s
    ${Count}    SeleniumLibraryExtended.Get Element Count    ${SSO_UserID_Row_table}
    ${Count+1}    Evaluate    ${Count}+1
    @{CountList}    Create List
    :FOR    ${INDEX}    IN RANGE    1    ${Count+1}
    \    ${User_Table}    Get Text    ${SSO_Results_table}\[${INDEX}]${SSO_UserID_Col}
    \    ${USER_MATCH}    Run Keyword And Return Status    Should Be Equal    ${UserID}    ${User_Table}
    \    Run Keyword If    ${USER_MATCH}==${True}    Run Keywords    Log    Users Matched! ${UserID} = ${User_Table}
         ...    AND    Click Element    ${SSO_Results_table}\[${INDEX}]${SSO_RadioButton_Col}
    \
    \    ${UserType_Table}    Run Keyword If    ${USER_MATCH}==True    Get Text    ${SSO_Results_table}\[${INDEX}]${SSO_UserType}
    \    Run Keyword If    ${USER_MATCH}==${True}    Run Keyword And Continue On Failure    Should Be Equal    ${UserType}    ${UserType_Table}
    \    ${UserType_stat}    Run Keyword If    ${USER_MATCH}==True    Run Keyword And Return Status    Should Be Equal    ${UserType}    ${UserType_Table}
    \    Run Keyword If    ${UserType_stat}==True    Log    Matched! User Type is correct. '${UserType}' = '${UserType_Table}'
         ...    ELSE IF    ${UserType_stat}==${True}    Fail    Not Matched! Expected value: '${UserType}'. Actual value: '${UserType_Table}'.
    \
    \    ${CountryCode_Table}    Run Keyword If    ${USER_MATCH}==True    Get Text    ${SSO_Results_table}\[${INDEX}]${SSO_CountryCode}
    \    Run Keyword If    ${USER_MATCH}==True    Run Keyword And Continue On Failure    Should Be Equal    ${CountryCode}    ${CountryCode_Table}
    \    ${CountryCode_stat}    Run Keyword If    ${USER_MATCH}==True    Run Keyword And Return Status    Should Be Equal    ${CountryCode}    ${CountryCode_Table}
    \    Run Keyword If    ${CountryCode_stat}==True    Log    Matched! Country Code is correct. '${CountryCode}' = '${CountryCode_Table}'
         ...    ELSE IF      ${CountryCode_stat}==False    Fail    Not Matched! Expected value: '${CountryCode}'. Actual value: '${CountryCode_Table}'.
    \    Run Keyword If    ${INDEX}>${Count+1} and ${USER_MATCH}==False    Log    No Users Matched on the table!!
    \    Exit For Loop If    ${USER_MATCH}==True

    Take Screenshot    SSO_EnquireUserSearchPage_Table
    Click Element    ${SSO_SearchUser_Next_button}
    Wait Until Element Is Visible    ${SSO_GivenName_textfield}

Validate Enquire User Mandatory Fields for Put
    [Documentation]    This keyword is used to validate Enquire User Page fields if correct, if no change is made on the textfield,
    ...    it will validate that previous value is still existing. If change is made, it will validate that new value is displayed.
    ...    @author: clanding
    ...    @update: clanding    22APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...    @update: dahijara    23AUG2019    - update hardcoded boolean to variable.
    [Arguments]    ${sCountryCode_2Code}    ${sCountryDesc}    ${sFName}    ${sLName}    ${sJobTitle}

    ${sGivenName}    Run Keyword If    ${NOCHANGE_SSO_FIRSTNAME}==${True}    Set Variable    ${SSO_GLOBAL_FIRSTNAME}
    ...    ELSE    Set Variable    ${sFName}

    ${Actual_GivenName}    Get Value    ${SSO_GivenName_textfield}
    Run Keyword And Continue On Failure    Textfield Value Should Be    ${SSO_GivenName_textfield}    ${sGivenName}
    ${GivenName_Stat}    Run Keyword And Return Status    Textfield Value Should Be    ${SSO_GivenName_textfield}    ${sGivenName}
    Run Keyword If    ${GivenName_Stat}==${True}    Log    Correct!! Given Name is '${sGivenName}'.
    ...    ELSE    Log    Incorrect!! Expected value: '${sGivenName}'. Actual value: '${Actual_GivenName}'.    level=ERROR

    ${input_surname}    Run Keyword If    ${NOCHANGE_SSO_SURNAME}==${True}    Set Variable    ${SSO_GLOBAL_SURNAME}
    ...    ELSE    Set Variable    ${sLName}

    ${actual_surname}    Get Value    ${SSO_Surname_textfield}
    Run Keyword And Continue On Failure    Textfield Value Should Be    ${SSO_Surname_textfield}    ${input_surname}
    ${surnmae_stat}    Run Keyword And Return Status    Textfield Value Should Be    ${SSO_Surname_textfield}    ${input_surname}
    Run Keyword If    ${surnmae_stat}==${True}    Log    Correct!! Surname is '${input_surname}'.
    ...    ELSE    Log    Incorrect!! Expected value: '${input_surname}'. Actual value: '${actual_surname}'.    level=ERROR

    ${input_businesstitle}    Run Keyword If    ${NOCHANGE_SSO_JOBTITLE}==${True}    Set Variable    ${SSO_GLOBAL_TITLECODE}
    ...    ELSE    Set Variable    ${sJobTitle}

    ## to be confirmed if mandatory
    ${actual_businesstitle}    Get Value    ${SSO_BusinessTitle_textfield}
    Run Keyword And Continue On Failure    Textfield Value Should Be    ${SSO_BusinessTitle_textfield}    ${input_businesstitle}
    ${bustitle_stat}    Run Keyword And Return Status    Textfield Value Should Be    ${SSO_BusinessTitle_textfield}    ${input_businesstitle}
    Run Keyword If    ${bustitle_stat}==${True}    Log    Correct!! Business Title is '${input_businesstitle}'.
    ...    ELSE    Log    Incorrect!! Expected value: '${input_businesstitle}'. Actual value: '${actual_businesstitle}'.    level=ERROR

    ${input_country}    Run Keyword If    ${NOCHANGE_SSO_COUNTRY}==${True}    Set Variable    ${SSO_GLOBAL_COUNTRY}
    ...    ELSE    Set Variable    ${sCountryDesc}-${sCountryCode_2Code}

    ${actual_countrycode}    Get Value    ${SSO_UserCountryCode_dropdown}
    Run Keyword And Continue On Failure    Textfield Value Should Be    ${SSO_UserCountryCode_dropdown}    ${input_country}
    ${cc_stat}    Run Keyword And Return Status    Textfield Value Should Be    ${SSO_UserCountryCode_dropdown}    ${input_country}
    Run Keyword If    ${cc_stat}==${True}    Log    Correct!! User's Country Code is '${input_country}'.
    ...    ELSE    Log    Incorrect!! Expected value: '${input_country}'. Actual value: '${actual_countrycode}'.    level=ERROR

Validate Enquire User Page Other Fields for Put
    [Documentation]    This keyword is used to validate Enquire User Page other fields, if no change is made on the textfield,
    ...    it will validate that previous value is still existing. If change is made, it will validate that new value is displayed.
    ...    @author: clanding
    ...    @update: clanding    22APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...    @update: clanding    26APR2019    - add scroll to element and screenshot
    [Arguments]    ${sCentralUserType}    ${sOSUserID}    ${sLocale}    ${iContactNum1}    ${sEmail}

    ${SSO_UserType_Desc}    Get User Type Code and Return Description    ${sCentralUserType}
    ${SSO_Language_Desc}    Get Language Description from Code and Return Description    ${sLocale}

    ${sOSUserID}    Run Keyword If    ${NOCHANGE_SSO_OSUSERID}==${True}    Set Variable    ${SSO_GLOBAL_OSUSERID}
    ...    ELSE    Set Variable    ${sOSUserID}

    ${sOSUserID}    Run Keyword If    '${sOSUserID}'=='no tag' or '${sOSUserID}'=='null'    Set Variable
    ...    ELSE    Set Variable    ${sOSUserID}
    ${Actual_OSUserID}    Get Value    ${SSO_OSUserID_textfield}
    Run Keyword And Continue On Failure    Textfield Should Contain    ${SSO_OSUserID_textfield}    ${sOSUserID}
    ${IsMatched_OSUserID}    Run Keyword And Return Status    Textfield Should Contain    ${SSO_OSUserID_textfield}    ${sOSUserID}
    Run Keyword If    ${IsMatched_OSUserID}==${True}    Log    Matched!! SO User ID is correct: '${sOSUserID}' = '${Actual_OSUserID}'
    ...    ELSE    Log    Not Matched!! SO User ID is INCORRECT. Expected value: '${sOSUserID}'. Actual value: '${Actual_OSUserID}'.    level=ERROR

    ${sLanguage}    Run Keyword If    ${NOCHANGE_SSO_LANGUAGE}==${True}    Set Variable    ${SSO_GLOBAL_LOCALE}
    ...    ELSE    Set Variable    ${SSO_Language_Desc}-${sLocale}

    ${Actual_Language}    Get Value    ${SSO_UserLanguageCode_dropdown}
    Run Keyword And Continue On Failure    Textfield Should Contain    ${SSO_UserLanguageCode_dropdown}    ${sLanguage}
    ${IsMatched_Language}    Run Keyword And Return Status    Textfield Should Contain    ${SSO_UserLanguageCode_dropdown}    ${sLanguage}
    Run Keyword If    ${IsMatched_Language}==${True}    Log    Matched!! Language is correct: '${sLanguage}' = '${Actual_Language}'
    ...    ELSE    Log    Not Matched!! Language is INCORRECT. Expected value: '${sLanguage}'. Actual value: '${Actual_Language}'.    level=ERROR

    ${iContactNum1}    Run Keyword If    ${NOCHANGE_SSO_CONTACTNUMBER1}==${True}    Set Variable    ${SSO_GLOBAL_PHONE}
    ...    ELSE    Set Variable    ${iContactNum1}

    ${Actual_Phone}    Get Value    ${SSO_Phone_textfield}
    Run Keyword And Continue On Failure    Textfield Should Contain    ${SSO_Phone_textfield}    ${iContactNum1}
    ${IsMatched_Phone}    Run Keyword And Return Status    Textfield Should Contain    ${SSO_Phone_textfield}    ${iContactNum1}
    Run Keyword If    ${IsMatched_Phone}==${True}    Log    Matched!! Phone is correct: '${iContactNum1}' = '${Actual_Phone}'
    ...    ELSE    Log    Not Matched!! Phone is INCORRECT. Expected value: '${iContactNum1}'. Actual value: '${Actual_Phone}'.    level=ERROR

    ${sEmail}    Run Keyword If    ${NOCHANGE_SSO_EMAIL}==${True}    Set Variable    ${SSO_GLOBAL_EMAIL}
    ...    ELSE    Set Variable    ${sEmail}

    ${Actual_Email}    Get Value    ${SSO_Email_textfield}
    Run Keyword And Continue On Failure    Textfield Should Contain    ${SSO_Email_textfield}    ${sEmail}
    ${IsMatched_Email}    Run Keyword And Return Status    Textfield Should Contain    ${SSO_Email_textfield}    ${sEmail}
    Run Keyword If    ${IsMatched_Email}==${True}    Log    Matched!! Email is correct: '${sEmail}' = '${Actual_Email}'
    ...    ELSE    Log    Not Matched!! Email is INCORRECT. Expected value: '${sEmail}'. Actual value: '${Actual_Email}'.    level=ERROR

    ${sUserTypeDesc}    Run Keyword If    ${NOCHANGE_SSO_USERTYPE_DROPDOWN}==${True}    Set Variable    ${SSO_GLOBAL_USERTYPE}
    ...    ELSE    Set Variable    ${SSO_UserType_Desc}

    ${Actual_UserType}    Get Value    ${SSO_UserType_dropdown}
    Run Keyword And Continue On Failure    Textfield Value Should Be    ${SSO_UserType_dropdown}    ${sUserTypeDesc}
    ${IsMatched_UserType}    Run Keyword And Return Status    Textfield Value Should Be    ${SSO_UserType_dropdown}    ${sUserTypeDesc}
    Run Keyword If    ${IsMatched_UserType}==${True}    Log    Correct!! Branch Sort Code is '${sUserTypeDesc}'.
    ...    ELSE    Log    Incorrect!! Expected value: '${sUserTypeDesc}'. Actual value: '${Actual_UserType}'.    level=ERROR
    
    Take Screenshot    SSO_Get_EnquireUserPage_Fields
    Mx Scroll Element Into View    ${SSO_AssocApps_tablegrid}
    Take Screenshot    SSO_Get_EnquireUserPage_Table
    
Validate Enquire User Page Associated Tables for Put
    [Documentation]    This keyword is used to validate Enquire User Page associated tables.
    ...    @author: clanding
    ...    @update: dahijara    15AUG2019    - Get Matching Xpath Count' is deprecated. Updated keyword with `Get Element Count` instead.
    [Arguments]    ${aRoleList}    ${aApplicationList}

    ${Config_ALL_Null}    OperatingSystem.Get File    ${Valid_LOB}
    ${input_list_0}    Get From List    ${aApplicationList}    0
    ${aApplicationList}    Run Keyword If    '${input_list_0}'=='${EMPTY}' or '${input_list_0}'=='ALL'    Set Variable    ${Config_ALL_Null}
    ...    ELSE    Set Variable    ${aApplicationList}
    ${JSON_App_Count}    Get Length    ${aApplicationList}
    ${Table_App_Count}    SeleniumLibraryExtended.Get Element Count    ${SSO_AssocApps_tablegrid}
    Run Keyword And Continue On Failure    Should Be Equal    '${JSON_App_Count}'    '${Table_App_Count}'
    ${App_Count}    Run Keyword And Return Status    Should Be Equal    '${JSON_App_Count}'    '${Table_App_Count}'
    Run Keyword If    ${App_Count}==${True}    Log    Application count from input json and Enquire User table are EQUAL: ${JSON_App_Count} = ${Table_App_Count}
    ...    ELSE    Log    Application count from input json and Enquire User table are UNEQUAL: ${JSON_App_Count} != ${Table_App_Count}    level=ERROR
    ${Count+1}    Evaluate    ${Table_App_Count}+1
    :FOR    ${INDEX}    IN RANGE    1    ${Count+1}
    \    ${AssocApp_Table}    Get Text    ${SSO_AssocApps_tablegrid}\[${INDEX}]${SSO_AssocApps_tablegrid_values}
    \    Run Keyword And Continue On Failure    Should Contain    ${aApplicationList}    ${AssocApp_Table}
    \    ${IsMatched_AssociatedApplication}    Run Keyword And Return Status    Should Contain    ${aApplicationList}    ${AssocApp_Table}
    \    Run Keyword If    ${IsMatched_AssociatedApplication}==${True}    Log    '${AssocApp_Table}' is in the List: ${aApplicationList}.
         ...    ELSE    Log    '${AssocApp_Table}' is NOT in the List: ${aApplicationList}.    level=ERROR
    \    Exit For Loop If    ${INDEX}>${Count+1}

    ### Zone is defaulted to BF for SSO --- this is configured in mdm.config.properties ###
    ${Input_ZoneList}    OperatingSystem.Get File    ${Zone_Config}
    @{Input_ZoneList}    Split String    ${Input_ZoneList}    ,
    ${JSON_Zone_Count}    Get Length    ${Input_ZoneList}
    ${Input_BranchCode}    Get From List    ${Input_ZoneList}    0

    ${TableZone_Count}    SeleniumLibraryExtended.Get Element Count    ${SSO_AssocZones_tablegrid}
    Run Keyword And Continue On Failure    Should Be Equal    '${JSON_Zone_Count}'    '${TableZone_Count}'
    ${ZoneCount}    Run Keyword And Return Status    Should Be Equal    '${JSON_Zone_Count}'    '${TableZone_Count}'
    Run Keyword If    ${ZoneCount}==${True}    Log    Zone count from input json and Enquire User table are EQUAL: ${JSON_Zone_Count} = ${TableZone_Count}
    ...    ELSE    Log    Zone count from input json and Enquire User table are UNEQUAL: ${JSON_Zone_Count} != ${TableZone_Count}    level=ERROR
    ${Count+1}    Evaluate    ${TableZone_Count}+1
    :FOR    ${INDEX}    IN RANGE    1    ${Count+1}
    \    ${AssocZone_Table}    Get Text    ${SSO_AssocZones_tablegrid}\[${INDEX}]${SSO_AssocZones_tablegrid_values}
    \    Run Keyword And Continue On Failure    Should Contain    ${Input_ZoneList}    ${AssocZone_Table}
    \    ${assoczone_match}    Run Keyword And Return Status    Should Contain    ${Input_ZoneList}    ${AssocZone_Table}
    \    Run Keyword If    ${assoczone_match}==${True}    Log    '${AssocZone_Table}' is in the List: ${Input_ZoneList}.
         ...    ELSE    Log    '${AssocZone_Table}' is NOT in the List: ${Input_ZoneList}.    level=ERROR
    \    Exit For Loop If    ${INDEX}>${Count+1}

Add Current Value to JSON for User Comparison Report for SSO
    [Documentation]    This keyword is used to add current values from SSO Application for JSON and save in file.
    ...    @author: clanding
    ...    @update: clanding    22APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...    @update: jdelacru    07NOV2019    - added Return From Keyword If to handle if SSO is enabled/disabled
    [Arguments]    ${sInputFilePath}    ${sOutputFilePath}

    Return From Keyword If    '${SSO_ENABLED}'=='NO'
    
    ${File_Path}    Set Variable    ${sInputFilePath}${templateinput_SingleLOB}
    ${JSON_Object}    Load JSON From File    ${dataset_path}${File_Path}

    ${New_JSON}    Set To Dictionary    ${JSON_Object}    loginId=${SSO_GLOBAL_USERID}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    centralUserType=${SSO_GLOBAL_USERTYPE}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    countryCode=${SSO_GLOBAL_COUNTRYCODE}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    firstName=${SSO_GLOBAL_FIRSTNAME}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    surname=${SSO_GLOBAL_SURNAME}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    jobTitle=${SSO_GLOBAL_TITLECODE}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    email=${SSO_GLOBAL_EMAIL}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    contactNumber1=${SSO_GLOBAL_PHONE}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    locale=${SSO_GLOBAL_LOCALE}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    osUserId=${SSO_GLOBAL_OSUSERID}

    Log    ${New_JSON}
    ${Converted_JSON}    Evaluate    json.dumps(${New_JSON})        json
    Log    ${Converted_JSON}
    ${JSONFile}    Set Variable    ${sOutputFilePath}Current_SSOData.json
    Delete File If Exist    ${dataset_path}${JSONFile}
    Create File    ${dataset_path}${JSONFile}    ${Converted_JSON}
    ${File}    OperatingSystem.Get File    ${dataset_path}${JSONFile}

Add Input Value to JSON for User Comparison Report for SSO
    [Documentation]    This keyword is used to add input values from SSO Application for JSON and save in file.
    ...    @author: clanding
    ...    @update: clanding    08APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...    @update: dahijara    19AUG2019    - changed the value being passed to centralUserType field from ${sCentralUserType} to ${SSO_UserType_Desc}
    ...    @update: jdelacru    07NOV2019    - added Return From Keyword If to handle if SSO is enabled/disabled
    [Arguments]    ${sInputFilePath}    ${sCountryCode_2Code}    ${sLoginID}    ${sCentralUserType}    ${sLocale}    ${sFName}    ${sLName}
    ...    ${sJobTitle}    ${sEmail}    ${iContactNum1}    ${sOSUserID}

    Return From Keyword If    '${SSO_ENABLED}'=='NO'
    
    ${File_Path}    Set Variable    ${sInputFilePath}${templateinput_SingleLOB}
    ${JSON_Object}    Load JSON From File    ${dataset_path}${File_Path}

    ${SSO_UserType_Desc}    ${SSO_Language_Desc}    Get Defined Description for Other Code Values    ${sCentralUserType}
    ${Locale}    Run Keyword If    '${sLocale}'=='no tag' or '${sLocale}'=='null' or '${sLocale}'==''    Set Variable    en
    ...    ELSE    Set Variable    ${sLocale}

    ${New_JSON}    Set To Dictionary    ${JSON_Object}    loginId=${sLoginID}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    centralUserType=${SSO_UserType_Desc}    #centralUserType=${sCentralUserType}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    countryCode=${sCountryCode_2Code}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    firstName=${sFName}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    surname=${sLName}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    jobTitle=${sJobTitle}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    email=${sEmail}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    contactNumber1=${iContactNum1}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    locale=${SSO_Language_Desc}-${Locale}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    osUserId=${sOSUserID}

    Log    ${New_JSON}
    ${Converted_JSON}    Evaluate    json.dumps(${New_JSON})        json
    Log    ${Converted_JSON}
    ${JSONFile}    Set Variable    ${sInputFilePath}Input_SSOData.json
    Delete File If Exist    ${dataset_path}${JSONFile}
    Create File    ${dataset_path}${JSONFile}    ${Converted_JSON}
    ${File}    OperatingSystem.Get File    ${dataset_path}${JSONFile}

Compare Input and Actual SSO Data
    [Documentation]    This keyword is used to get input and actual SSO data and compare them.
    ...    @author: clanding    22APR2019    - initial create
    ...    @update: jdelacru    07NOV2019    - added Return From Keyword If to handle if SSO is enabled/disabled
    [Arguments]    ${sInputFilePath}    ${sOutputFilePath}
    
    Return From Keyword If    '${SSO_ENABLED}'=='NO'
    
    ${Current_SSOData}    OperatingSystem.Get File    ${dataset_path}${sOutputFilePath}Current_SSOData.json    
    ${Input_SSOData}    OperatingSystem.Get File    ${dataset_path}${sInputFilePath}Input_SSOData.json    
    ${IsMatched}    Run Keyword And Return Status    Mx Compare Json Data    ${Current_SSOData}    ${Input_SSOData}
    Run Keyword If    ${IsMatched}==${True}    Log    Input values and current values are equal and have no changes. ${Input_SSOData} == ${Current_SSOData}    level=WARN 
    ...    ELSE IF    ${IsMatched}==${False}    Log    Input values and current values have differences. ${Input_SSOData} != ${Current_SSOData}    level=WARN   
    
Search User ID for NULL
    [Documentation]    This keyword is used to search User ID on SSO main page when value is null.
    ...    @author: chanario
    ...    @update: clanding    08APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sLoginID}
    Wait Until Element Is Visible     ${SSO_Process_Textfield}    timeout=20s
    Input Text    ${SSO_Process_Textfield}    Enquire User
    Press key    ${SSO_Process_Textfield}   ${Keyboard_Enter}
    Wait Until Element Is Visible     ${SSO_UserID_textfield}    timeout=20s
    Mx Input Text    ${SSO_UserID_textfield}    ${sLoginID}
    Click Element    ${SSO_Search_button}
    Wait Until Element Is Visible    ${SSO_SearchUser_UserID_textfield}    timeout=20s
    ${Count}    Get Matching Xpath Count    ${SSO_UserID_Row_table}
    ${Count+1}    Evaluate    ${Count}+1
    @{CountList}    Create List
    : FOR    ${INDEX}    IN RANGE    1    ${Count+1}
    \    ${User_Table}    Get Text    ${SSO_Results_table}\[${INDEX}]${SSO_UserID_Col}
    \    ${USER_MATCH}    Run Keyword And Return Status    Should Be Equal    ${sLoginID}    ${User_Table}
    \    Run Keyword If    ${USER_MATCH}==False    Log    Users null not Matched! ${sLoginID} is not searched.
    \    Exit For Loop If    '${INDEX}'=='${Count+1}'
    Click Element    ${SSO_SearchUser_Next_button}
    [Return]    ${USER_MATCH}

Get User Type Code and Return Description
    [Documentation]    This keyword is used to get User Type description based from 'centralUserType' or 'userType' in the payload.
    ...    @author: clanding    16APR2019    - initial create
    ...    @update: clanding    07MAY2019    - added handling of usertype when value is more than 1
    [Arguments]    ${sUserType}    ${Index}=None
    
    ${UserType_List}    Split String    ${sUserType}    ,
    ${UserType_Val}    Run Keyword If    '${Index}'=='None'    Set Variable    ${sUserType}
    ...    ELSE    Get From List    ${UserType_List}    ${Index}
    
    ${UserTypeDesc}    Run Keyword If    '${UserType_Val}'=='N' or '${UserType_Val}'=='NR'    Set Variable    Normal
    ...    ELSE IF    '${UserType_Val}'=='S'    Set Variable    Supervisor
    ...    ELSE IF    '${UserType_Val}'=='T'    Set Variable    Teller
    ...    ELSE IF    '${UserType_Val}'=='I' or '${UserType_Val}'=='IU'   Set Variable    Interface User
    ...    ELSE IF    '${UserType_Val}'=='C'    Set Variable    Call Center User
    ...    ELSE IF    '${UserType_Val}'=='A' or '${UserType_Val}'=='AC'    Set Variable    Central Administrator
    
    [Return]    ${UserTypeDesc}
