*** Settings ***
Resource    ../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Search for a Valid User ID in Essence Enquire User Page
    [Documentation]    This keyword is used to search for a valid user id in Enquire User page in Essence.
    ...    @author: clanding    15APR2019    - initial create
    ...    @update: jloretiz    24JUL2019    - add additional condition to validate created user without centralUserType and userType
    ...    @update: dfajardo    19JUN2020    - updated Essence_SearchUser_Search_Button xpath
    [Arguments]    ${sLoginID}
    
    Mx Input Text    ${Essence_EnquireUser_UserID_TextBox}    ${sLoginID}
    Click Element    ${Essence_EnquireUser_Search_Button}
    Wait Until Element Is Visible    ${Essence_SearchUser_UserID_TextBox}    30s
    Mx Input Text    ${Essence_SearchUser_UserID_TextBox}    ${sLoginID}
    Click Element    ${Essence_SearchUser_Search_Button}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${Essence_SearchUser_TableRow}        
    ${Count}    SeleniumLibraryExtended.Get Element Count    ${Essence_SearchUser_TableRow}
    Run Keyword If    ${Count}==0    Fail    User '${sLoginID}' not found. Change Login ID to continue the Update scenario.
    ...    ELSE    Log    User '${sLoginID}' found.
    Take Screenshot    Essence_SearchUser

Search User ID in Essence Enquire User Page for Successful Delete
    [Documentation]    This keyword is used to search User ID on Enquire User main page and validate that User is deleted from Essence.
    ...    @author: xmiranda	15AUG2019	- initial create
    [Arguments]    ${sUserID}

    Wait Until Element Is Visible     ${Essence_SearchBox_Locator}    timeout=20s
    Input Text    ${Essence_SearchBox_Locator}    Enquire User
    Press key    ${Essence_SearchBox_Locator}   ${Keyboard_Enter}
    Wait Until Element Is Visible     ${Essence_EnquireUser_UserID_TextBox}    timeout=30s

    Mx Input Text    ${Essence_EnquireUser_UserID_TextBox}    ${sUserID}
    Click Element    ${Essence_EnquireUser_Search_Button}
    Wait Until Element Is Visible    ${Essence_SearchUser_UserID_TextBox}    timeout=40s
    Mx Input Text    ${Essence_SearchUser_UserID_TextBox}    ${sUserID}
    Click Element    ${Essence_SearchUser_Search_Button}
    ${Essence_User_Not_Found_Label_Status}    Run Keyword And Return Status    Element Should Be Visible    ${Essence_SearchUser_Error_TextMessage}
    Run Keyword If    ${Essence_User_Not_Found_Label_Status}==True    Log    Correct!!! User(s) not found
    ...    ELSE    Log    Incorrect!!! User still exist.    level=ERROR
    Element Should Not Be Visible    ${Essence_SearchUser_Table}\[1]${Essence_SearchUser_UserID_TableRow}
    Take Screenshot    Essence_Search_UserNotFound
    Click Element    ${Essence_SearchUser_Close_Dialog}
    Wait Until Element Is Visible    ${Essence_EnquireUser_GivenName_TextBox}
    ${Given_Name_Empty}    Run Keyword And Return Status    SeleniumLibraryExtended.Element Text Should Be    ${Essence_EnquireUser_GivenName_TextBox}    ${EMPTY}
    Run Keyword If    ${Given_Name_Empty}==True    Log    Correct!! Given Name is blank.
    ...    ELSE    Log    Incorrect!! Given Name is populated.    level=ERROR
    Take Screenshot    Essence_SearchGivenNameEmpty
    

Validate Details in Search User Dialog in Essence
    [Documentation]    This keyword is used to validate UserID, User Type and User Country if correct in Search User dialog.
    ...    @author: clanding    15APR2019    - initial create
    ...    @update: clanding    23APR2019    - added screenshot
    ...    @update: dahijara    18JUL2019    - added \ on index for element, this is an update for robot to consider it as a string not an index of
    [Arguments]    ${sLoginID}    ${sUserType}    ${sCountryCode}
    
    ${Count}    SeleniumLibraryExtended.Get Element Count    ${Essence_SearchUser_TableRow}
    @{CountList}    Create List
    :FOR    ${INDEX}    IN RANGE    1    ${Count}+1
    \    
    \    ${User_Table}    Get Text    ${Essence_SearchUser_Table}\[${INDEX}]${Essence_SearchUser_UserID_TableRow}
    \    Run Keyword And Continue On Failure    Should Be Equal    ${sLoginID}    ${User_Table}    
    \    ${USER_MATCH}    Run Keyword And Return Status    Should Be Equal    ${sLoginID}    ${User_Table}
    \    Run Keyword If    ${USER_MATCH}==${True}    Log    Users Matched! ${sLoginID} = ${User_Table}
         ...    ELSE    Log    Users are not Matched! ${sLoginID} != ${User_Table}
    \    Take Screenshot    Essence_SearchUserDialog
    \    
    \    ${UserType_Table}    Run Keyword If    ${USER_MATCH}==${True}    Get Text    ${Essence_SearchUser_Table}\[${INDEX}]${Essence_SearchUser_UserType_TableRow}
    \    ${sUserType}    Run Keyword If    '${sUserType}'=='no tag' or '${sUserType}'=='None' or '${sUserType}'=='null'    Set Variable    Normal
         ...    ELSE    Set Variable    ${sUserType}
    \    Run Keyword If    ${USER_MATCH}==${True}    Run Keyword And Continue On Failure    Should Be Equal    ${sUserType}    ${UserType_Table}
    \    ${UserType_stat}    Run Keyword If    ${USER_MATCH}==${True}    Run Keyword And Return Status    Should Be Equal    ${sUserType}    ${UserType_Table}
    \    Run Keyword If    ${UserType_stat}==${True}    Log    Matched! User Type is correct. '${sUserType}' = '${UserType_Table}'
         ...    ELSE IF    ${UserType_stat}==${False}    Log    Not Matched! Expected value: '${sUserType}'. Actual value: '${UserType_Table}'.    level=ERROR
    \    
    \    ${CountryCode_Table}    Run Keyword If    ${USER_MATCH}==${True}    Get Text    ${Essence_SearchUser_Table}\[${INDEX}]${Essence_SearchUser_UserCountry_TableRow}
    \    Run Keyword If    ${USER_MATCH}==${True}    Run Keyword And Continue On Failure    Should Be Equal    ${sCountryCode}    ${CountryCode_Table}
    \    
    \    ${CountryCode_stat}    Run Keyword If    ${USER_MATCH}==${True}    Run Keyword And Return Status    Should Be Equal    ${sCountryCode}    ${CountryCode_Table}
    \    Run Keyword If    ${CountryCode_stat}==${True}    Log    Matched! Country Code is correct. '${sCountryCode}' = '${CountryCode_Table}'
         ...    ELSE IF      ${CountryCode_stat}==${False}    Log    Not Matched! Expected value: '${sCountryCode}'. Actual value: '${CountryCode_Table}'.    level=ERROR
    \    
    \    Run Keyword If    ${INDEX}>${Count}+1 and ${USER_MATCH}==${False}    Log    No Users Matched on the table!!
    \    Exit For Loop If    ${INDEX}==${Count}+1
    Take Screenshot    Essence_SearchUserDialog
    Click Element    ${Essence_SearchUser_Next_Button}
    Wait Until Element Is Visible    ${Essence_EnquireUser_GivenName_TextBox}

Validate Essence Enquire User Fields Have Correct Values
    [Documentation]    This keyword is used to verify if Essence Enquire User fields have correct values as per input.
    ...    @author: clanding    15APR2019    - initial create
    ...    @update: dahijara    18JUL2019    - added \ on index for element, this is an update for robot to consider it as a string not an index of
    ...    @update: jloretiz    04SEP2019    - added additional condition for additional business entity
    [Arguments]    ${sFName}    ${sLName}    ${sTitle}    ${sOSUserID}    ${sCountry}    ${sUserType}    ${sLanguage}
    ...    ${sDefZone}    ${sDefBranch}    ${sPhone}    ${sEmail}    ${aAddZoneList}    ${aAddBranchList}    ${aRoleList}
    
    ${Actual_FName}    Get Value    ${Essence_EnquireUser_GivenName_TextBox}
    Run Keyword And Continue On Failure    Should Be Equal    ${sFName}    ${Actual_FName}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${sFName}    ${Actual_FName}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${sFName} = ${Actual_FName}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${sFName} != ${Actual_FName}
    
    ${Actual_LName}    Get Value    ${Essence_EnquireUser_Surname_TextBox}
    Run Keyword And Continue On Failure    Should Be Equal    ${sLName}    ${Actual_LName}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${sLName}    ${Actual_LName}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${sLName} = ${Actual_LName}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${sLName} != ${Actual_LName}
    
    ${Actual_Title}    Get Value    ${Essence_EnquireUser_Title_TextBox}
    
    Run Keyword And Continue On Failure    Should Be Equal    ${sTitle}    ${Actual_Title}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${sTitle}    ${Actual_Title}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${sTitle} = ${Actual_Title}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${sTitle} != ${Actual_Title}
    
    ${Actual_OSUserID}    Get Value    ${Essence_EnquireUser_OSUserID_TextBox}
    Run Keyword And Continue On Failure    Should Be Equal    ${sOSUserID}    ${Actual_OSUserID}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${sOSUserID}    ${Actual_OSUserID}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${sOSUserID} = ${Actual_OSUserID}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${sOSUserID} != ${Actual_OSUserID}
    
    ${Actual_Country}    Get Value    ${Essence_EnquireUser_Country_Dropdown}
    Run Keyword And Continue On Failure    Should Be Equal    ${sCountry}    ${Actual_Country}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${sCountry}    ${Actual_Country}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${sCountry} = ${Actual_Country}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${sCountry} != ${Actual_Country}
    
    ${Actual_UserType}    Get Value    ${Essence_EnquireUser_UserType_Dropdown}
    ${sUserType}   Run Keyword If    '${sUserType}'=='None'    Set Variable    Normal
    ...    ELSE    Set Variable    ${sUserType}
    Run Keyword And Continue On Failure    Should Be Equal    ${sUserType}    ${Actual_UserType}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${sUserType}    ${Actual_UserType}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${sUserType} = ${Actual_UserType}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${sUserType} != ${Actual_UserType}
    
    ${Actual_Language}    Get Value    ${Essence_EnquireUser_Language_Dropdown}
    Run Keyword And Continue On Failure    Should Be Equal    ${sLanguage}    ${Actual_Language}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${sLanguage}    ${Actual_Language}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${sLanguage} = ${Actual_Language}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${sLanguage} != ${Actual_Language}
    
    ${Actual_Zone}    Get Value    ${Essence_EnquireUser_DefaultZone_Dropdown}
    Run Keyword And Continue On Failure    Should Be Equal    ${sDefZone}    ${Actual_Zone}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${sDefZone}    ${Actual_Zone}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${sDefZone} = ${Actual_Zone}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${sDefZone} != ${Actual_Zone}
    
    ${Actual_Branch}    Get Value    ${Essence_EnquireUser_BranchName_Dropdown}
    Run Keyword And Continue On Failure    Should Be Equal    ${sDefBranch}    ${Actual_Branch}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${sDefBranch}    ${Actual_Branch}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${sDefBranch} = ${Actual_Branch}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${sDefBranch} != ${Actual_Branch}
    
    ${Actual_Phone}    Get Value    ${Essence_EnquireUser_Phone_Dropdown}
    Run Keyword And Continue On Failure    Should Be Equal    ${sPhone}    ${Actual_Phone}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${sPhone}    ${Actual_Phone}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${sPhone} = ${Actual_Phone}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${sPhone} != ${Actual_Phone}
    
    ${Actual_Email}    Get Value    ${Essence_EnquireUser_Email_Dropdown}
    Run Keyword And Continue On Failure    Should Be Equal    ${sEmail}    ${Actual_Email}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${sEmail}    ${Actual_Email}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${sEmail} = ${Actual_Email}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${sEmail} != ${Actual_Email}
    
    Take Screenshot    Essence_EnquireUser_Fields
    Mx Scroll Element Into View    ${Essence_EnquireUser_AssocZone_TableGrid_Row}
    Take Screenshot    Essence_EnquireUser_Tables
    ${ActualZoneValue}    Get Text    ${Essence_EnquireUser_AssocZone_TableGrid_Row}\[1]${TableGrid_RowValues_Zone}
    Run Keyword And Continue On Failure    Should Be Equal    ${sDefZone}    ${ActualZoneValue}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${sDefZone}    ${ActualZoneValue}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${sDefZone} = ${ActualZoneValue}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${sDefZone} != ${ActualZoneValue}
    
    ${ActualBranchValue}    Get Text    ${Essence_EnquireUser_AssocZone_TableGrid_Row}\[1]${TableGrid_RowValues_Branch}
    Run Keyword And Continue On Failure    Should Be Equal    ${sDefBranch}    ${ActualBranchValue}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${sDefBranch}    ${ActualBranchValue}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${sDefBranch} = ${ActualBranchValue}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${sDefBranch} != ${ActualBranchValue}
    
    ${AddZone_Value_0}    Get From List    ${aAddZoneList}    0
    ${AddBranch_Value_0}    Get From List    ${aAddBranchList}    0
    Run Keyword If    '${AddZone_Value_0}'=='None' or '${AddBranch_Value_0}'=='None' or '${AddZone_Value_0}'=='[]' or '${AddBranch_Value_0}'=='[]'    Log    No Additional Zone.
    ...    ELSE    Validate Associated Zones in Essence Enquire User Page    ${aAddZoneList}    ${aAddBranchList}
    
    Validate Associated Roles in Essence Enquire User Page    ${aRoleList}
        
Validate Associated Zones in Essence Enquire User Page
    [Documentation]    This keyword is used to verify Associated Zones - Zone Name and Branch Name for Additional Business Entity values.
    ...    @author: clanding    15APR2019    - initial create
    ...    @update: dahijara    18JUL2019    - added \ on index for element, this is an update for robot to consider it as a string not an index of
    [Arguments]    ${aAddZoneList}    ${aAddBranchList}
        
    ${ZoneCount}    Get Length    ${aAddZoneList}
    ${ZoneCount}    Evaluate    ${ZoneCount}+1    ###Add Default Zone Value
    :FOR    ${Index}    IN RANGE    ${ZoneCount}
    \    ${Index_AddZone}    Evaluate    ${Index}+2
    \    
    \    ${ZoneValue_From_List}    Get From List    ${aAddZoneList}    ${Index}
    \    ${ActualZoneValue}    Get Text    ${Essence_EnquireUser_AssocZone_TableGrid_Row}[${Index_AddZone}]${TableGrid_RowValues_Zone}
    \    Run Keyword And Continue On Failure    Should Be Equal    ${ZoneValue_From_List}    ${ActualZoneValue}
    \    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${ZoneValue_From_List}    ${ActualZoneValue}
    \    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${ZoneValue_From_List} = ${ActualZoneValue}
         ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${ZoneValue_From_List} != ${ActualZoneValue}
    \    
    \    Exit For Loop If    ${Index}>${ZoneCount}
    
    ${BranchCount}    Get Length    ${aAddBranchList}
    ${BranchCount}    Evaluate    ${BranchCount}+1    ###Add Default Branch Value
    :FOR    ${Index}    IN RANGE    ${BranchCount}
    \    ${Index_AddBranch}    Evaluate    ${Index}+2
    \    
    \    ${BranchValue_From_List}    Get From List    ${aAddBranchList}    ${Index}
    \    ${ActualBranchValue}    Get Text    ${Essence_EnquireUser_AssocZone_TableGrid_Row}\[${Index_AddBranch}]${TableGrid_RowValues_Branch}
    \    Run Keyword And Continue On Failure    Should Be Equal    ${BranchValue_From_List}    ${ActualBranchValue}
    \    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${BranchValue_From_List}    ${ActualBranchValue}
    \    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${BranchValue_From_List} = ${ActualBranchValue}
         ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${BranchValue_From_List} != ${ActualBranchValue}
    \    
    \    Exit For Loop If    ${Index}>${BranchCount}
    
Validate Associated Roles in Essence Enquire User Page
    [Documentation]    This keyword is used to verify Associated Roles for Additional Business Entity values.
    ...    @author: clanding    16APR2019    - initial create
    ...    @update: dahijara    18JUL2019    - added \ on index for element, this is an update for robot to consider it as a string not an index of
    [Arguments]    ${aRoleList}
    
    
        
    ${RoleCount}    Get Length    ${aRoleList}
    :FOR    ${Index}    IN RANGE    ${RoleCount}
    \    ${Index_AddRole}    Evaluate    ${Index}+1
    \    
    \    ${RoleValue_From_List}    Get From List    ${aRoleList}    ${Index}
    \    ${ActualRoleValue}    Get Text    ${Essence_EnquireUser_AssocRoles_TableGrid_Row}\[${Index_AddRole}]${TableGrid_RowValues_Role}
    \    Run Keyword And Continue On Failure    Should Be Equal    ${RoleValue_From_List}    ${ActualRoleValue}
    \    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${RoleValue_From_List}    ${ActualRoleValue}
    \    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${RoleValue_From_List} = ${ActualRoleValue}
         ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${RoleValue_From_List} != ${ActualRoleValue}
    \    
    \    Exit For Loop If    ${Index}>${RoleCount}

Search for User ID and Get User Details in Essence
    [Documentation]    This keyword is used to search for User ID and get field values from Enquire User Page in Essence.
    ...    @author: clanding    24APR2019    - initial create
    [Arguments]    ${sLoginID}
    
    ${Count}    SeleniumLibraryExtended.Get Element Count    ${Essence_SearchUser_TableRow}
    @{CountList}    Create List
    :FOR    ${INDEX}    IN RANGE    1    ${Count}+1
    \    
    \    ${User_Table}    Get Text    ${Essence_SearchUser_Table}\[${INDEX}]${Essence_SearchUser_UserID_TableRow}
    \    ${USER_MATCH}    Run Keyword And Return Status    Should Be Equal    ${sLoginID}    ${User_Table}
    \    Take Screenshot    Essence_SearchUserDialog
    \    ${ESS_GLOBAL_USERTYPE_TABLE}    Run Keyword If    ${USER_MATCH}==${True}    Get Text    ${Essence_SearchUser_Table}\[${INDEX}]${Essence_SearchUser_UserType_TableRow}
    \    ${ESS_GLOBAL_COUNTRY_TABLE}    Run Keyword If    ${USER_MATCH}==${True}    Get Text    ${Essence_SearchUser_Table}\[${INDEX}]${Essence_SearchUser_UserCountry_TableRow}
    \    Run Keyword If    ${INDEX}>${Count}+1 and ${USER_MATCH}==${False}    Log    No Users Matched on the table!!
    \    Exit For Loop If    ${INDEX}==${Count}+1
    Take Screenshot    Essence_SearchUserDialog
    Click Element    ${Essence_SearchUser_Next_Button}
    Run Keyword And Continue On Failure    Wait Until Element Is Visible    ${Essence_EnquireUser_GivenName_TextBox}
    
    ${ESS_GLOBAL_GIVENAME}    Get Value    ${Essence_EnquireUser_GivenName_TextBox}
    ${ESS_GLOBAL_SURNAME}    Get Value    ${Essence_EnquireUser_Surname_TextBox}
    ${ESS_GLOBAL_TITLE}    Get Value    ${Essence_EnquireUser_Title_TextBox}
    ${ESS_GLOBAL_OSUSERID}    Get Value    ${Essence_EnquireUser_OSUserID_TextBox}
    ${ESS_GLOBAL_COUNTRY}    Get Value    ${Essence_EnquireUser_Country_Dropdown}
    ${ESS_GLOBAL_USERTYPE_DD}    Get Value    ${Essence_EnquireUser_UserType_Dropdown}
    ${ESS_GLOBAL_LANGUAGE_DD}    Get Value    ${Essence_EnquireUser_Language_Dropdown}
    ${ESS_GLOBAL_DEFZONE_DD}    Get Value    ${Essence_EnquireUser_DefaultZone_Dropdown}
    ${ESS_GLOBAL_DEFBRANCH_DD}    Get Value    ${Essence_EnquireUser_BranchName_Dropdown}
    ${ESS_GLOBAL_PHONE}    Get Value    ${Essence_EnquireUser_Phone_Dropdown}
    ${ESS_GLOBAL_EMAIL}    Get Value    ${Essence_EnquireUser_Email_Dropdown}
    Take Screenshot    Essence_EnquireUser_Fields
    Mx Scroll Element Into View    ${Essence_EnquireUser_AssocZone_TableGrid_Row}
    Take Screenshot    Essence_EnquireUser_Tables
    ${ESS_GLOBAL_ZONELIST}    Create List    
    ${ZoneCount}    SeleniumLibraryExtended.Get Element Count    ${Essence_EnquireUser_AssocZone_TableGrid_Row}
    ${ZoneCount}    Evaluate    ${ZoneCount}+1
    :FOR    ${Index}    IN RANGE    1    ${ZoneCount}
    \    ${ActualZoneValue}    Get Text    ${Essence_EnquireUser_AssocZone_TableGrid_Row}\[${Index}]${TableGrid_RowValues_Zone}
    \    Append To List    ${ESS_GLOBAL_ZONELIST}    ${ActualZoneValue}
    \    Exit For Loop If    ${Index}==${ZoneCount}
    
    ${ESS_GLOBAL_BRANCHLIST}    Create List
    ${BranchCount}    SeleniumLibraryExtended.Get Element Count    ${Essence_EnquireUser_AssocZone_TableGrid_Row}
    ${BranchCount}    Evaluate    ${BranchCount}+1
    :FOR    ${Index}    IN RANGE    1    ${BranchCount}
    \    ${ActualBranchValue}    Get Text    ${Essence_EnquireUser_AssocZone_TableGrid_Row}\[${Index}]${TableGrid_RowValues_Branch}
    \    Append To List    ${ESS_GLOBAL_BRANCHLIST}    ${ActualBranchValue}
    \    Exit For Loop If    ${Index}==${BranchCount}
    
    ${ESS_GLOBAL_ROLELIST}    Create List
    ${RoleCount}    SeleniumLibraryExtended.Get Element Count    ${Essence_EnquireUser_AssocRoles_TableGrid_Row}
    ${RoleCount}    Evaluate    ${RoleCount}+1    
    :FOR    ${Index}    IN RANGE    1    ${RoleCount}
    \    ${ActualRoleValue}    Get Text    ${Essence_EnquireUser_AssocRoles_TableGrid_Row}\[${Index}]${TableGrid_RowValues_Role}
    \    Append To List    ${ESS_GLOBAL_ROLELIST}    ${ActualRoleValue}
    \    Exit For Loop If    ${Index}==${RoleCount}
    
    Set Global Variable    ${ESS_GLOBAL_GIVENAME}
    Set Global Variable    ${ESS_GLOBAL_SURNAME}
    Set Global Variable    ${ESS_GLOBAL_TITLE}
    Set Global Variable    ${ESS_GLOBAL_OSUSERID}
    Set Global Variable    ${ESS_GLOBAL_COUNTRY}
    Set Global Variable    ${ESS_GLOBAL_USERTYPE_DD}
    Set Global Variable    ${ESS_GLOBAL_LANGUAGE_DD}
    Set Global Variable    ${ESS_GLOBAL_DEFZONE_DD}
    Set Global Variable    ${ESS_GLOBAL_DEFBRANCH_DD}
    Set Global Variable    ${ESS_GLOBAL_PHONE}
    Set Global Variable    ${ESS_GLOBAL_EMAIL}
    Set Global Variable    ${ESS_GLOBAL_ZONELIST}
    Set Global Variable    ${ESS_GLOBAL_BRANCHLIST}
    Set Global Variable    ${ESS_GLOBAL_ROLELIST}
    Set Global Variable    ${ESS_GLOBAL_USERTYPE_TABLE}
    Set Global Variable    ${ESS_GLOBAL_COUNTRY_TABLE}

Compare Essence Data from Input Data
    [Documentation]    This keyword is used to compare Essence data from Input data if update is done for the specific element.
    ...    @author: clanding    24APR2019    - initial create
    ...    @update: clanding    26APR2019    - add global variables
    [Arguments]    ${sFName}    ${sLName}    ${sTitle}    ${sOSUserID}    ${sCountryCode_2Code}
    ...    ${sCountryDesc}    ${sUserType_Desc}    ${sLanguageCode}    ${sLanguageDesc}    ${sDefZoneCode}    ${sDefBranchCode}
    ...    ${iContactNum1}    ${sEmail}

    ${NOCHANGE_ESS_USERTYPE_TABLE}    Run Keyword And Return Status    Should Be Equal As Strings    ${sUserType_Desc}    ${ESS_GLOBAL_USERTYPE_TABLE}
    ${NOCHANGE_ESS_COUNTRY_TABLE}    Run Keyword And Return Status    Should Be Equal As Strings    ${sCountryCode_2Code}    ${ESS_GLOBAL_COUNTRY_TABLE}
    ${NOCHANGE_ESS_JOBTITLE}    Run Keyword And Return Status    Should Be Equal As Strings    ${sTitle}    ${ESS_GLOBAL_TITLE}
    ${NOCHANGE_ESS_FIRSTNAME}    Run Keyword And Return Status    Should Be Equal As Strings    ${sFName}    ${ESS_GLOBAL_GIVENAME}
    ${NOCHANGE_ESS_SURNAME}    Run Keyword And Return Status    Should Be Equal As Strings    ${sLName}    ${ESS_GLOBAL_SURNAME}
    ${NOCHANGE_ESS_COUNTRY}    Run Keyword And Return Status    Should Be Equal As Strings    ${sCountryDesc}-${sCountryCode_2Code}    ${ESS_GLOBAL_COUNTRY}
    ${NOCHANGE_ESS_USERTYPE_DROPDOWN}    Run Keyword And Return Status    Should Be Equal As Strings    ${sUserType_Desc}    ${ESS_GLOBAL_USERTYPE_DD}
    ${NOCHANGE_ESS_CONTACTNUMBER1}    Run Keyword And Return Status    Should Be Equal As Strings    ${iContactNum1}    ${ESS_GLOBAL_PHONE}
    ${NOCHANGE_ESS_EMAIL}    Run Keyword And Return Status    Should Be Equal As Strings    ${sEmail}    ${ESS_GLOBAL_EMAIL}
    ${NOCHANGE_ESS_DEFZONE}    Run Keyword And Return Status    Should Be Equal As Strings    ${sDefZoneCode}    ${ESS_GLOBAL_DEFZONE_DD}
    ${NOCHANGE_ESS_DEFBRANCH}    Run Keyword And Return Status    Should Be Equal As Strings    ${sDefBranchCode}    ${ESS_GLOBAL_DEFBRANCH_DD}
    ${sLanguageCode}    Run Keyword If    '${sLanguageCode}'=='no tag' or '${sLanguageCode}'=='null' or '${sLanguageCode}'==''    Set Variable    en
    ...    ELSE    Set Variable    ${sLanguageCode}
    ${NOCHANGE_ESS_LANGUAGE}    Run Keyword And Return Status    Should Be Equal As Strings    ${sLanguageDesc}-${sLanguageCode}    ${ESS_GLOBAL_LANGUAGE_DD}
    ${sOSUserID}    Run Keyword If    '${sOSUserID}'=='no tag' or '${sOSUserID}'=='null' or '${sOSUserID}'==''    Set Variable
    ...    ELSE    Set Variable    ${sOSUserID}
    ${NOCHANGE_ESS_OSUSERID}    Run Keyword And Return Status    Should Be Equal As Strings    ${sOSUserID}    ${ESS_GLOBAL_OSUSERID}
    
    Set Global Variable    ${NOCHANGE_ESS_JOBTITLE}
    Set Global Variable    ${NOCHANGE_ESS_FIRSTNAME}
    Set Global Variable    ${NOCHANGE_ESS_SURNAME}
    Set Global Variable    ${NOCHANGE_ESS_EMAIL}
    Set Global Variable    ${NOCHANGE_ESS_CONTACTNUMBER1}
    Set Global Variable    ${NOCHANGE_ESS_LANGUAGE}
    Set Global Variable    ${NOCHANGE_ESS_OSUSERID}
    Set Global Variable    ${NOCHANGE_ESS_COUNTRY}
    Set Global Variable    ${NOCHANGE_ESS_USERTYPE_DROPDOWN}
    Set Global Variable    ${NOCHANGE_ESS_USERTYPE_TABLE}
    Set Global Variable    ${NOCHANGE_ESS_COUNTRY_TABLE}
    Set Global Variable    ${NOCHANGE_ESS_DEFZONE}
    Set Global Variable    ${NOCHANGE_ESS_DEFBRANCH}

Add Current Value to JSON for User Comparison Report for Essence
    [Documentation]    This keyword is used to add current values from Essence Application for JSON and save in file.
    ...    @author: clanding    24APR2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sOutputFilePath}

    ${File_Path}    Set Variable    ${sInputFilePath}${templateinput_SingleLOB}
    ${JSON_Object}    Load JSON From File    ${dataset_path}${File_Path}

    ${New_JSON}    Set To Dictionary    ${JSON_Object}    userType=${ESS_GLOBAL_USERTYPE_DD}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    countryCode=${ESS_GLOBAL_COUNTRY}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    firstName=${ESS_GLOBAL_GIVENAME}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    surname=${ESS_GLOBAL_SURNAME}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    jobTitle=${ESS_GLOBAL_TITLE}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    email=${ESS_GLOBAL_EMAIL}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    contactNumber1=${ESS_GLOBAL_PHONE}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    locale=${ESS_GLOBAL_LANGUAGE_DD}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    osUserId=${ESS_GLOBAL_OSUSERID}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    defaultZone=${ESS_GLOBAL_DEFZONE_DD}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    defaultBranch=${ESS_GLOBAL_DEFBRANCH_DD}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    userType_Table=${ESS_GLOBAL_USERTYPE_TABLE}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    countryCode_Table=${ESS_GLOBAL_COUNTRY_TABLE}

    Log    ${New_JSON}
    ${Converted_JSON}    Evaluate    json.dumps(${New_JSON})    json
    Log    ${Converted_JSON}
    ${JSONFile}    Set Variable    ${sOutputFilePath}${CURRENT_ESSENCE_DATA}.json
    Delete File If Exist    ${dataset_path}${JSONFile}
    Create File    ${dataset_path}${JSONFile}    ${Converted_JSON}
    ${File}    OperatingSystem.Get File    ${dataset_path}${JSONFile}

Add Input Value to JSON for User Comparison Report for Essence
    [Documentation]    This keyword is used to add input values from Essence Application for JSON and save in file.
    ...    @author: clanding    24APR2019    - initial create
    ...    @update: dahijara    15AUG2019    - Updated value being set for default branch from ${CBA}${SPACE}-${SPACE}${sDefBranchCode} to ${sDefBranchCode}
    ...    @update: dahijara    19AUG2019    - Updated value being set for country code from ${sCountryDesc} to ${sCountryDesc}-${sCountryCode_2Code}
    [Arguments]    ${sInputFilePath}    ${sFName}    ${sLName}    ${sTitle}    ${sOSUserID}    ${sCountryCode_2Code}
    ...    ${sCountryDesc}    ${sUserType_Desc}    ${sLanguageCode}    ${sLanguageDesc}    ${sDefZoneCode}    ${sDefBranchCode}
    ...    ${iContactNum1}    ${sEmail}

    ${File_Path}    Set Variable    ${sInputFilePath}${templateinput_SingleLOB}
    ${JSON_Object}    Load JSON From File    ${dataset_path}${File_Path}

    ${sLanguageCode}    Run Keyword If    '${sLanguageCode}'=='no tag' or '${sLanguageCode}'=='null' or '${sLanguageCode}'==''    Set Variable    en
    ...    ELSE    Set Variable    ${sLanguageCode}

    ${New_JSON}    Set To Dictionary    ${JSON_Object}    userType=${sUserType_Desc}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    countryCode=${sCountryDesc}-${sCountryCode_2Code}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    firstName=${sFName}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    surname=${sLName}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    jobTitle=${sTitle}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    email=${sEmail}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    contactNumber1=${iContactNum1}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    locale=${sLanguageDesc}-${sLanguageCode}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    osUserId=${sOSUserID}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    defaultZone=${sDefZoneCode}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    defaultBranch=${sDefBranchCode}    #${CBA}${SPACE}-${SPACE}${sDefBranchCode}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    userType_Table=${sUserType_Desc}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    countryCode_Table=${sCountryCode_2Code}

    Log    ${New_JSON}
    ${Converted_JSON}    Evaluate    json.dumps(${New_JSON})    json
    Log    ${Converted_JSON}
    ${JSONFile}    Set Variable    ${sInputFilePath}${INPUT_ESSENCE_DATA}.json
    Delete File If Exist    ${dataset_path}${JSONFile}
    Create File    ${dataset_path}${JSONFile}    ${Converted_JSON}
    ${File}    OperatingSystem.Get File    ${dataset_path}${JSONFile}

Compare Input and Actual Essence Data
    [Documentation]    This keyword is used to get input and actual Essence data and compare them.
    ...    @author: clanding    24APR2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sOutputFilePath}
    
    ${Current_EssenceData}    OperatingSystem.Get File    ${dataset_path}${sOutputFilePath}${CURRENT_ESSENCE_DATA}.json    
    ${Input_EssenceData}    OperatingSystem.Get File    ${dataset_path}${sInputFilePath}${INPUT_ESSENCE_DATA}.json    
    ${IsMatched}    Run Keyword And Return Status    Mx Compare Json Data    ${Current_EssenceData}    ${Input_EssenceData}
    Run Keyword If    ${IsMatched}==${True}    Log    Input values and current values are equal and have no changes. ${Input_EssenceData} == ${Current_EssenceData}    level=WARN
    ...    ELSE IF    ${IsMatched}==${False}    Log    Input values and current values have differences. ${Input_EssenceData} != ${Current_EssenceData}    level=WARN

Validate Update Details in Search User Dialog in Essence
    [Documentation]    This keyword is used to validate UserID, User Type and User Country if correct in Search User dialog when User details are updated.
    ...    @author: clanding    24APR2019    - initial create
    [Arguments]    ${sLoginID}    ${sUserType}    ${sCountryCode}
    
    ${Count}    SeleniumLibraryExtended.Get Element Count    ${Essence_SearchUser_TableRow}
    @{CountList}    Create List
    :FOR    ${INDEX}    IN RANGE    1    ${Count}+1
    \    
    \    ${User_Table}    Get Text    ${Essence_SearchUser_Table}\[${INDEX}]${Essence_SearchUser_UserID_TableRow}
    \    Run Keyword And Continue On Failure    Should Be Equal    ${sLoginID}    ${User_Table}    
    \    ${USER_MATCH}    Run Keyword And Return Status    Should Be Equal    ${sLoginID}    ${User_Table}
    \    Run Keyword If    ${USER_MATCH}==${True}    Log    Users Matched! ${sLoginID} = ${User_Table}
         ...    ELSE    Log    Users are not Matched! ${sLoginID} != ${User_Table}
    \    Take Screenshot    Essence_SearchUserDialog
    \    
    \    ${UserType_Table}    Run Keyword If    ${USER_MATCH}==${True}    Get Text    ${Essence_SearchUser_Table}\[${INDEX}]${Essence_SearchUser_UserType_TableRow}
    \    ${UserType}    Run Keyword If    ${NOCHANGE_ESS_USERTYPE_TABLE}==${True}    Set Variable    ${ESS_GLOBAL_USERTYPE_TABLE}
         ...    ELSE    Set Variable    ${sUserType}
    \    Run Keyword If    ${USER_MATCH}==${True}    Run Keyword And Continue On Failure    Should Be Equal    ${UserType}    ${UserType_Table}
    \    ${UserType_stat}    Run Keyword If    ${USER_MATCH}==${True}    Run Keyword And Return Status    Should Be Equal    ${sUserType}    ${UserType_Table}
    \    Run Keyword If    ${UserType_stat}==${True}    Log    Matched! User Type is correct. '${sUserType}' = '${UserType_Table}'
         ...    ELSE IF    ${UserType_stat}==${False}    Log    Not Matched! Expected value: '${sUserType}'. Actual value: '${UserType_Table}'.    level=ERROR
    \    
    \    ${CountryCode_Table}    Run Keyword If    ${USER_MATCH}==${True}    Get Text    ${Essence_SearchUser_Table}\[${INDEX}]${Essence_SearchUser_UserCountry_TableRow}
    \    ${CountryCode}    Run Keyword If    ${NOCHANGE_ESS_COUNTRY_TABLE}==${True}    Set Variable    ${ESS_GLOBAL_COUNTRY_TABLE}
         ...    ELSE    Set Variable    ${sCountryCode}
    \    Run Keyword If    ${USER_MATCH}==${True}    Run Keyword And Continue On Failure    Should Be Equal    ${CountryCode}    ${CountryCode_Table}
    \    ${CountryCode_stat}    Run Keyword If    ${USER_MATCH}==${True}    Run Keyword And Return Status    Should Be Equal    ${sCountryCode}    ${CountryCode_Table}
    \    Run Keyword If    ${CountryCode_stat}==${True}    Log    Matched! Country Code is correct. '${sCountryCode}' = '${CountryCode_Table}'
         ...    ELSE IF      ${CountryCode_stat}==${False}    Log    Not Matched! Expected value: '${sCountryCode}'. Actual value: '${CountryCode_Table}'.    level=ERROR
    \    
    \    Run Keyword If    ${INDEX}>${Count}+1 and ${USER_MATCH}==${False}    Log    No Users Matched on the table!!
    \    Exit For Loop If    ${INDEX}==${Count}+1
    Take Screenshot    Essence_SearchUserDialog
    Click Element    ${Essence_SearchUser_Next_Button}
    Wait Until Element Is Visible    ${Essence_EnquireUser_GivenName_TextBox}

Validate Essence Enquire User Fields Have Correct Values for Update
    [Documentation]    This keyword is used to verify if Essence Enquire User fields have correct values as per update details.
    ...    @author: clanding    15APR2019    - initial create
    ...    @update: dahijara    15AUG2019    - added \ on index for element, this is an update for robot to consider it as a string not an index of
    [Arguments]    ${sFName}    ${sLName}    ${sTitle}    ${sOSUserID}    ${sCountry}    ${sUserType}    ${sLanguage}
    ...    ${sDefZone}    ${sDefBranch}    ${sPhone}    ${sEmail}    ${aAddZoneList}    ${aAddBranchList}    ${aRoleList}
    
    ${FName}    Run Keyword If    ${NOCHANGE_ESS_FIRSTNAME}==${True}    Set Variable    ${ESS_GLOBAL_GIVENAME}
    ...    ELSE    Set Variable    ${sFName}
    ${Actual_FName}    Get Value    ${Essence_EnquireUser_GivenName_TextBox}
    Run Keyword And Continue On Failure    Should Be Equal    ${FName}    ${Actual_FName}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${FName}    ${Actual_FName}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${FName} = ${Actual_FName}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${FName} != ${Actual_FName}
    
    ${LName}    Run Keyword If    ${NOCHANGE_ESS_SURNAME}==${True}    Set Variable    ${ESS_GLOBAL_SURNAME}
    ...    ELSE    Set Variable    ${sLName}
    ${Actual_LName}    Get Value    ${Essence_EnquireUser_Surname_TextBox}
    Run Keyword And Continue On Failure    Should Be Equal    ${LName}    ${Actual_LName}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${LName}    ${Actual_LName}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${LName} = ${Actual_LName}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${LName} != ${Actual_LName}
    
    ${Title}    Run Keyword If    ${NOCHANGE_ESS_JOBTITLE}==${True}    Set Variable    ${ESS_GLOBAL_TITLE}
    ...    ELSE    Set Variable    ${sTitle}
    ${Actual_Title}    Get Value    ${Essence_EnquireUser_Title_TextBox}
    Run Keyword And Continue On Failure    Should Be Equal    ${Title}    ${Actual_Title}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${Title}    ${Actual_Title}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${Title} = ${Actual_Title}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${Title} != ${Actual_Title}
    
    ${OSUserID}    Run Keyword If    ${NOCHANGE_ESS_OSUSERID}==${True}    Set Variable    ${ESS_GLOBAL_OSUSERID}
    ...    ELSE    Set Variable    ${sOSUserID}
    ${Actual_OSUserID}    Get Value    ${Essence_EnquireUser_OSUserID_TextBox}
    Run Keyword And Continue On Failure    Should Be Equal    ${OSUserID}    ${Actual_OSUserID}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${OSUserID}    ${Actual_OSUserID}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${OSUserID} = ${Actual_OSUserID}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${OSUserID} != ${Actual_OSUserID}
    
    ${Country}    Run Keyword If    ${NOCHANGE_ESS_COUNTRY}==${True}    Set Variable    ${ESS_GLOBAL_COUNTRY}
    ...    ELSE    Set Variable    ${sCountry}
    ${Actual_Country}    Get Value    ${Essence_EnquireUser_Country_Dropdown}
    Run Keyword And Continue On Failure    Should Be Equal    ${Country}    ${Actual_Country}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${Country}    ${Actual_Country}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${Country} = ${Actual_Country}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${Country} != ${Actual_Country}
    
    ${UserType}    Run Keyword If    ${NOCHANGE_ESS_USERTYPE_DROPDOWN}==${True}    Set Variable    ${ESS_GLOBAL_USERTYPE_DD}
    ...    ELSE    Set Variable    ${sUserType}
    ${Actual_UserType}    Get Value    ${Essence_EnquireUser_UserType_Dropdown}
    Run Keyword And Continue On Failure    Should Be Equal    ${UserType}    ${Actual_UserType}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${UserType}    ${Actual_UserType}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${UserType} = ${Actual_UserType}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${UserType} != ${Actual_UserType}
    
    ${Language}    Run Keyword If    ${NOCHANGE_ESS_LANGUAGE}==${True}    Set Variable    ${ESS_GLOBAL_LANGUAGE_DD}
    ...    ELSE    Set Variable    ${sLanguage}
    ${Actual_Language}    Get Value    ${Essence_EnquireUser_Language_Dropdown}
    Run Keyword And Continue On Failure    Should Be Equal    ${Language}    ${Actual_Language}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${Language}    ${Actual_Language}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${Language} = ${Actual_Language}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${Language} != ${Actual_Language}
    
    ${DefZone}    Run Keyword If    ${NOCHANGE_ESS_DEFZONE}==${True}    Set Variable    ${ESS_GLOBAL_DEFZONE_DD}
    ...    ELSE    Set Variable    ${sDefZone}
    ${Actual_Zone}    Get Value    ${Essence_EnquireUser_DefaultZone_Dropdown}
    Run Keyword And Continue On Failure    Should Be Equal    ${DefZone}    ${Actual_Zone}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${DefZone}    ${Actual_Zone}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${DefZone} = ${Actual_Zone}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${DefZone} != ${Actual_Zone}
    
    ${DefBranch}    Run Keyword If    ${NOCHANGE_ESS_DEFBRANCH}==${True}    Set Variable    ${ESS_GLOBAL_DEFBRANCH_DD}
    ...    ELSE    Set Variable    ${sDefBranch}
    ${Actual_Branch}    Get Value    ${Essence_EnquireUser_BranchName_Dropdown}
    Run Keyword And Continue On Failure    Should Be Equal    ${DefBranch}    ${Actual_Branch}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${DefBranch}    ${Actual_Branch}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${DefBranch} = ${Actual_Branch}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${DefBranch} != ${Actual_Branch}
    
    ${Phone}    Run Keyword If    ${NOCHANGE_ESS_CONTACTNUMBER1}==${True}    Set Variable    ${ESS_GLOBAL_PHONE}
    ...    ELSE    Set Variable    ${sPhone}
    ${Actual_Phone}    Get Value    ${Essence_EnquireUser_Phone_Dropdown}
    Run Keyword And Continue On Failure    Should Be Equal    ${Phone}    ${Actual_Phone}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${Phone}    ${Actual_Phone}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${Phone} = ${Actual_Phone}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${Phone} != ${Actual_Phone}
    
    ${Email}    Run Keyword If    ${NOCHANGE_ESS_EMAIL}==${True}    Set Variable    ${ESS_GLOBAL_EMAIL}
    ...    ELSE    Set Variable    ${sEmail}
    ${Actual_Email}    Get Value    ${Essence_EnquireUser_Email_Dropdown}
    Run Keyword And Continue On Failure    Should Be Equal    ${Email}    ${Actual_Email}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${Email}    ${Actual_Email}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${Email} = ${Actual_Email}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${Email} != ${Actual_Email}
    
    Take Screenshot    Essence_EnquireUser_Fields
    Mx Scroll Element Into View    ${Essence_EnquireUser_AssocZone_TableGrid_Row}
    Take Screenshot    Essence_EnquireUser_Tables
    
    ${ZoneCount}    Get Length    ${ESS_GLOBAL_ZONELIST}
    ${ZoneCount}    Evaluate    ${ZoneCount}+1
    :FOR    ${Index}    IN RANGE    1    ${ZoneCount}
    \    ${Index_Value}    Evaluate    ${Index}-1
    \    ${ZoneValue_From_List}    Get From List    ${ESS_GLOBAL_ZONELIST}    ${Index_Value}
    \    ${ActualZoneValue}    Get Text    ${Essence_EnquireUser_AssocZone_TableGrid_Row}\[${Index}]${TableGrid_RowValues_Zone}
    \    Run Keyword And Continue On Failure    Should Be Equal    ${ZoneValue_From_List}    ${ActualZoneValue}
    \    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${ZoneValue_From_List}    ${ActualZoneValue}
    \    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${ZoneValue_From_List} = ${ActualZoneValue}
         ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${ZoneValue_From_List} != ${ActualZoneValue}
    \    
    \    Exit For Loop If    ${Index}>${ZoneCount}
    
    ${BranchCount}    Get Length    ${ESS_GLOBAL_BRANCHLIST}
    ${BranchCount}    Evaluate    ${BranchCount}+1
    :FOR    ${Index}    IN RANGE    1    ${BranchCount}
    \    ${Index_Value}    Evaluate    ${Index}-1
    \    ${BranchValue_From_List}    Get From List    ${ESS_GLOBAL_BRANCHLIST}    ${Index_Value}
    \    ${ActualBranchValue}    Get Text    ${Essence_EnquireUser_AssocZone_TableGrid_Row}\[${Index}]${TableGrid_RowValues_Branch}
    \    Run Keyword And Continue On Failure    Should Be Equal    ${BranchValue_From_List}    ${ActualBranchValue}
    \    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${BranchValue_From_List}    ${ActualBranchValue}
    \    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${BranchValue_From_List} = ${ActualBranchValue}
         ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${BranchValue_From_List} != ${ActualBranchValue}
    \    
    \    Exit For Loop If    ${Index}>${BranchCount}
    
    
    Validate Associated Roles in Essence Enquire User Page    ${ESS_GLOBAL_ROLELIST}
    
Validate Associated Roles in Essence Enquire User Page Using Role Value
    [Documentation]    This keyword is used to verify Associated Roles for Additional Business Entity values using Role Value.
    ...    @author: jdelacru    23MAY2019    - initial create
    ...    @update: dahijara    15AUG2019    - added \ on index for element, this is an update for robot to consider it as a string not an index of
    [Arguments]    ${sRole}    ${iIndexRole}
    ${ActualRoleValue}    Get Text    ${Essence_EnquireUser_AssocRoles_TableGrid_Row}\[${iIndexRole}+1]${TableGrid_RowValues_Role}
    Run Keyword And Continue On Failure    Should Be Equal    ${sRole}    ${ActualRoleValue}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${sRole}    ${ActualRoleValue}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${sRole} = ${ActualRoleValue}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${sRole} != ${ActualRoleValue}
    
Close Search User ID in Essence
    [Documentation]    This keyword is used to close the search user id text box if no validation is done once a user id has been searched
    ...    @author: cfrancis    04SEP2020    - initial create
    Click Element    ${Essence_SearchUser_Next_Button}
    Wait Until Element Is Visible    ${Essence_EnquireUser_GivenName_TextBox}