*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Keywords ***
Search for a Valid User ID in Party Enquire User Page
    [Documentation]    This keyword is used to search for a valid user id in Enquire User page in Party.
    ...    @author: clanding    16APR2019    - initial create
    ...    @update: jloretiz    24JUL2019    - add additional condition to validate created user without centralUserType and userType
    [Arguments]    ${sLoginID}
    
    Mx Input Text    ${Party_EnquireUser_UserID_TextBox}    ${sLoginID}
    Click Element    ${Party_EnquireUser_Search_Button}
    Wait Until Element Is Visible    ${Party_SearchUser_UserID_TextBox}    30s
    Mx Input Text    ${Party_SearchUser_UserID_TextBox}    ${sLoginID}
    Click Element    ${Party_SearchUser_Search_Button}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${Party_SearchUser_TableRow}        
    ${Count}    SeleniumLibraryExtended.Get Element Count    ${Party_SearchUser_TableRow}
    Run Keyword If    ${Count}==0    Fail    User '${sLoginID}' not found. Change Login ID to continue the Update scenario.
    ...    ELSE    Log    User '${sLoginID}' found.
    Take Screenshot    Party_SearchUser
        
Validate Details in Search User Dialog in Party
    [Documentation]    This keyword is used to validate UserID, User Type and User Country if correct in Search User dialog.
    ...    @author: clanding    16APR2019    - initial create
    ...    @update: dahijara    18JUL2019    - added \ on index for element, this is an update for robot to consider it as a string not an index of
    [Arguments]    ${sLoginID}    ${sUserType}    ${sCountryCode}
    
    ${Count}    SeleniumLibraryExtended.Get Element Count    ${Party_SearchUser_TableRow}
    @{CountList}    Create List
    :FOR    ${INDEX}    IN RANGE    1    ${Count}+1
    \    
    \    ${User_Table}    Get Text    ${Party_SearchUser_Table}\[${INDEX}]${Party_SearchUser_UserID_TableRow}
    \    Run Keyword And Continue On Failure    Should Be Equal    ${sLoginID}    ${User_Table}    
    \    ${USER_MATCH}    Run Keyword And Return Status    Should Be Equal    ${sLoginID}    ${User_Table}
    \    Run Keyword If    ${USER_MATCH}==${True}    Log    Users Matched! ${sLoginID} = ${User_Table}
         ...    ELSE    Log    Users are not Matched! ${sLoginID} != ${User_Table}
    \    Take Screenshot    Party_SearchUserDialog
    \    
    \    ${UserType_Table}    Run Keyword If    ${USER_MATCH}==${True}    Get Text    ${Party_SearchUser_Table}\[${INDEX}]${Party_SearchUser_UserType_TableRow}
    \    ${sUserType}    Run Keyword If    '${sUserType}'=='no tag' or '${sUserType}'=='None' or '${sUserType}'=='null'    Set Variable    Normal
         ...    ELSE    Set Variable    ${sUserType}
    \    Run Keyword If    ${USER_MATCH}==${True}    Run Keyword And Continue On Failure    Should Be Equal    ${sUserType}    ${UserType_Table}
    \    ${UserType_stat}    Run Keyword If    ${USER_MATCH}==${True}    Run Keyword And Return Status    Should Be Equal    ${sUserType}    ${UserType_Table}
    \    Run Keyword If    ${UserType_stat}==${True}    Log    Matched! User Type is correct. '${sUserType}' = '${UserType_Table}'
         ...    ELSE IF    ${UserType_stat}==${False}    Log    Not Matched! Expected value: '${sUserType}'. Actual value: '${UserType_Table}'.    level=ERROR
    \    
    \    ${CountryCode_Table}    Run Keyword If    ${USER_MATCH}==${True}    Get Text    ${Party_SearchUser_Table}\[${INDEX}]${Party_SearchUser_UserCountry_TableRow}
    \    Run Keyword If    ${USER_MATCH}==${True}    Run Keyword And Continue On Failure    Should Be Equal    ${sCountryCode}    ${CountryCode_Table}
    \    
    \    ${CountryCode_stat}    Run Keyword If    ${USER_MATCH}==${True}    Run Keyword And Return Status    Should Be Equal    ${sCountryCode}    ${CountryCode_Table}
    \    Run Keyword If    ${CountryCode_stat}==${True}    Log    Matched! Country Code is correct. '${sCountryCode}' = '${CountryCode_Table}'
         ...    ELSE IF      ${CountryCode_stat}==${False}    Log    Not Matched! Expected value: '${sCountryCode}'. Actual value: '${CountryCode_Table}'.    level=ERROR
    \    
    \    Run Keyword If    ${INDEX}>${Count}+1 and ${USER_MATCH}==${False}    Log    No Users Matched on the table!!
    \    Exit For Loop If    ${INDEX}==${Count}+1
    Click Element    ${Party_SearchUser_Next_Button}
    Wait Until Element Is Visible    ${Party_EnquireUser_GivenName_TextBox}
    

Validate Party Enquire User Fields Have Correct Values
    [Documentation]    This keyword is used to verify if Party Enquire User fields have correct values as per input.
    ...    @author: clanding    16APR2019    - initial create
    ...    @update: dahijara    18JUL2019    - added \ on index for element, this is an update for robot to consider it as a string not an index of
    ...    @update: jloretiz    04SEP2019    - added additional condition for additional business entity
    [Arguments]    ${sFName}    ${sLName}    ${sTitle}    ${sOSUserID}    ${sCountry}    ${sUserType}    ${sLanguage}
    ...    ${sDefZone}    ${sDefBranch}    ${sPhone}    ${sEmail}    ${aAddZoneList}    ${aAddBranchList}    ${aRoleList}
    
    ${Actual_FName}    Get Value    ${Party_EnquireUser_GivenName_TextBox}
    Run Keyword And Continue On Failure    Should Be Equal    ${sFName}    ${Actual_FName}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${sFName}    ${Actual_FName}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${sFName} = ${Actual_FName}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${sFName} != ${Actual_FName}
    
    ${Actual_LName}    Get Value    ${Party_EnquireUser_Surname_TextBox}
    Run Keyword And Continue On Failure    Should Be Equal    ${sLName}    ${Actual_LName}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${sLName}    ${Actual_LName}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${sLName} = ${Actual_LName}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${sLName} != ${Actual_LName}
    
    ${Actual_Title}    Get Value    ${Party_EnquireUser_Title_TextBox}
    Run Keyword And Continue On Failure    Should Be Equal    ${sTitle}    ${Actual_Title}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${sTitle}    ${Actual_Title}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${sTitle} = ${Actual_Title}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${sTitle} != ${Actual_Title}
    
    ${Actual_OSUserID}    Get Value    ${Party_EnquireUser_OSUserID_TextBox}
    Run Keyword And Continue On Failure    Should Be Equal    ${sOSUserID}    ${Actual_OSUserID}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${sOSUserID}    ${Actual_OSUserID}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${sOSUserID} = ${Actual_OSUserID}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${sOSUserID} != ${Actual_OSUserID}
    
    ${Actual_Country}    Get Value    ${Party_EnquireUser_Country_Dropdown}
    Run Keyword And Continue On Failure    Should Be Equal    ${sCountry}    ${Actual_Country}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${sCountry}    ${Actual_Country}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${sCountry} = ${Actual_Country}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${sCountry} != ${Actual_Country}
    
    ${Actual_UserType}    Get Value    ${Party_EnquireUser_UserType_Dropdown}
    ${sUserType}    Run Keyword If    '${sUserType}'=='None'    Set Variable    Normal
    ...    ELSE    Set Variable    ${sUserType}
    Run Keyword And Continue On Failure    Should Be Equal    ${sUserType}    ${Actual_UserType}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${sUserType}    ${Actual_UserType}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${sUserType} = ${Actual_UserType}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${sUserType} != ${Actual_UserType}
    
    ${Actual_Language}    Get Value    ${Party_EnquireUser_Language_Dropdown}
    Run Keyword And Continue On Failure    Should Be Equal    ${sLanguage}    ${Actual_Language}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${sLanguage}    ${Actual_Language}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${sLanguage} = ${Actual_Language}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${sLanguage} != ${Actual_Language}
    
    ${Actual_Zone}    Get Value    ${Party_EnquireUser_DefaultZone_Dropdown}
    Run Keyword And Continue On Failure    Should Be Equal    ${sDefZone}    ${Actual_Zone}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${sDefZone}    ${Actual_Zone}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${sDefZone} = ${Actual_Zone}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${sDefZone} != ${Actual_Zone}
    
    ${Actual_Branch}    Get Value    ${Party_EnquireUser_BranchName_Dropdown}
    Run Keyword And Continue On Failure    Should Be Equal    ${sDefBranch}    ${Actual_Branch}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${sDefBranch}    ${Actual_Branch}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${sDefBranch} = ${Actual_Branch}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${sDefBranch} != ${Actual_Branch}
    
    ${Actual_Phone}    Get Value    ${Party_EnquireUser_Phone_Dropdown}
    Run Keyword And Continue On Failure    Should Be Equal    ${sPhone}    ${Actual_Phone}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${sPhone}    ${Actual_Phone}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${sPhone} = ${Actual_Phone}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${sPhone} != ${Actual_Phone}
    
    ${Actual_Email}    Get Value    ${Party_EnquireUser_Email_Dropdown}
    Run Keyword And Continue On Failure    Should Be Equal    ${sEmail}    ${Actual_Email}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${sEmail}    ${Actual_Email}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${sEmail} = ${Actual_Email}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${sEmail} != ${Actual_Email}
    
    Take Screenshot    Party_EnquireUser_Fields
    Mx Scroll Element Into View    ${Party_EnquireUser_AssocZone_TableGrid_Row}
    Take Screenshot    Party_EnquireUser_Tables
    ${ActualZoneValue}    Get Text    ${Party_EnquireUser_AssocZone_TableGrid_Row}\[1]${TableGrid_RowValues_Zone}
    Run Keyword And Continue On Failure    Should Be Equal    ${sDefZone}    ${ActualZoneValue}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${sDefZone}    ${ActualZoneValue}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${sDefZone} = ${ActualZoneValue}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${sDefZone} != ${ActualZoneValue}
    
    ${ActualBranchValue}    Get Text    ${Party_EnquireUser_AssocZone_TableGrid_Row}\[1]${TableGrid_RowValues_Branch}
    Run Keyword And Continue On Failure    Should Be Equal    ${sDefBranch}    ${ActualBranchValue}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${sDefBranch}    ${ActualBranchValue}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${sDefBranch} = ${ActualBranchValue}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${sDefBranch} != ${ActualBranchValue}
    
    ${AddZone_Value_0}    Get From List    ${aAddZoneList}    0
    ${AddBranch_Value_0}    Get From List    ${aAddBranchList}    0
    Run Keyword If    '${AddZone_Value_0}'=='None' or '${AddBranch_Value_0}'=='None' or '${AddZone_Value_0}'=='[]' or '${AddBranch_Value_0}'=='[]'    Log    No Additional Zone.
    ...    ELSE    Validate Associated Zones in Party Enquire User Page    ${aAddZoneList}    ${aAddBranchList}
    
    Validate Associated Roles in Party Enquire User Page    ${aRoleList}
        
Validate Associated Zones in Party Enquire User Page
    [Documentation]    This keyword is used to verify Associated Zones - Zone Name and Branch Name for Additional Business Entity values.
    ...    @author: clanding    16APR2019    - initial create
    [Arguments]    ${aAddZoneList}    ${aAddBranchList}
        
    ${ZoneCount}    Get Length    ${aAddZoneList}
    ${ZoneCount}    Evaluate    ${ZoneCount}+1    ###Add Default Zone Value
    :FOR    ${Index}    IN RANGE    ${ZoneCount}
    \    ${Index_AddZone}    Evaluate    ${Index}+2
    \    
    \    ${ZoneValue_From_List}    Get From List    ${aAddZoneList}    ${Index}
    \    ${ActualZoneValue}    Get Text    ${Party_EnquireUser_AssocZone_TableGrid_Row}\[${Index_AddZone}]${TableGrid_RowValues_Zone}
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
    \    ${ActualBranchValue}    Get Text    ${Party_EnquireUser_AssocZone_TableGrid_Row}\[${Index_AddBranch}]${TableGrid_RowValues_Branch}
    \    Run Keyword And Continue On Failure    Should Be Equal    ${BranchValue_From_List}    ${ActualBranchValue}
    \    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${BranchValue_From_List}    ${ActualBranchValue}
    \    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${BranchValue_From_List} = ${ActualBranchValue}
         ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${BranchValue_From_List} != ${ActualBranchValue}
    \    
    \    Exit For Loop If    ${Index}>${BranchCount}
    
Validate Associated Roles in Party Enquire User Page
    [Documentation]    This keyword is used to verify Associated Roles for Additional Business Entity values.
    ...    @author: clanding    16APR2019    - initial create
    ...    @update: dahijara    18JUL2019    - added \ on index for element, this is an update for robot to consider it as a string not an index of
    [Arguments]    ${aRoleList}
        
    ${RoleCount}    Get Length    ${aRoleList}
    :FOR    ${Index}    IN RANGE    ${RoleCount}
    \    ${Index_AddRole}    Evaluate    ${Index}+1
    \    
    \    ${RoleValue_From_List}    Get From List    ${aRoleList}    ${Index}
    \    ${ActualRoleValue}    Get Text    ${Party_EnquireUser_AssocRoles_TableGrid_Row}\[${Index_AddRole}]${TableGrid_RowValues_Role}
    \    Run Keyword And Continue On Failure    Should Be Equal    ${RoleValue_From_List}    ${ActualRoleValue}
    \    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${RoleValue_From_List}    ${ActualRoleValue}
    \    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${RoleValue_From_List} = ${ActualRoleValue}
         ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${RoleValue_From_List} != ${ActualRoleValue}
    \    
    \    Exit For Loop If    ${Index}>${RoleCount}

Search for User ID and Get User Details in Party
    [Documentation]    This keyword is used to search for User ID and get field values from Enquire User Page in Party.
    ...    @author: clanding    25APR2019    - initial create
    ...    @update: dahijara    18JUL2019    - added \ on index for element, this is an update for robot to consider it as a string not an index of
    ...    @update: dahijara    15AUG2019    - Get Matching Xpath Count' is deprecated. Updated keyword with `Get Element Count` instead. 
    [Arguments]    ${sLoginID}
    
    ${Count}    SeleniumLibraryExtended.Get Element Count    ${Party_SearchUser_TableRow}
    @{CountList}    Create List
    :FOR    ${INDEX}    IN RANGE    1    ${Count}+1
    \    
    \    ${User_Table}    Get Text    ${Party_SearchUser_Table}\[${INDEX}]${Party_SearchUser_UserID_TableRow}
    \    ${USER_MATCH}    Run Keyword And Return Status    Should Be Equal    ${sLoginID}    ${User_Table}
    \    Take Screenshot    Party_SearchUserDialog
    \    ${PTY_GLOBAL_USERTYPE_TABLE}    Run Keyword If    ${USER_MATCH}==${True}    Get Text    ${Party_SearchUser_Table}\[${INDEX}]${Party_SearchUser_UserType_TableRow}
    \    ${PTY_GLOBAL_COUNTRY_TABLE}    Run Keyword If    ${USER_MATCH}==${True}    Get Text    ${Party_SearchUser_Table}\[${INDEX}]${Party_SearchUser_UserCountry_TableRow}
    \    Run Keyword If    ${INDEX}>${Count}+1 and ${USER_MATCH}==${False}    Log    No Users Matched on the table!!
    \    Exit For Loop If    ${INDEX}==${Count}+1
    Take Screenshot    Party_SearchUserDialog
    Click Element    ${Party_SearchUser_Next_Button}
    Run Keyword And Continue On Failure    Wait Until Element Is Visible    ${Party_EnquireUser_GivenName_TextBox}
    
    ${PTY_GLOBAL_GIVENAME}    Get Value    ${Party_EnquireUser_GivenName_TextBox}
    ${PTY_GLOBAL_SURNAME}    Get Value    ${Party_EnquireUser_Surname_TextBox}
    ${PTY_GLOBAL_TITLE}    Get Value    ${Party_EnquireUser_Title_TextBox}
    ${PTY_GLOBAL_OSUSERID}    Get Value    ${Party_EnquireUser_OSUserID_TextBox}
    ${PTY_GLOBAL_COUNTRY}    Get Value    ${Party_EnquireUser_Country_Dropdown}
    ${PTY_GLOBAL_USERTYPE_DD}    Get Value    ${Party_EnquireUser_UserType_Dropdown}
    ${PTY_GLOBAL_LANGUAGE_DD}    Get Value    ${Party_EnquireUser_Language_Dropdown}
    ${PTY_GLOBAL_DEFZONE_DD}    Get Value    ${Party_EnquireUser_DefaultZone_Dropdown}
    ${PTY_GLOBAL_DEFBRANCH_DD}    Get Value    ${Party_EnquireUser_BranchName_Dropdown}
    ${PTY_GLOBAL_PHONE}    Get Value    ${Party_EnquireUser_Phone_Dropdown}
    ${PTY_GLOBAL_EMAIL}    Get Value    ${Party_EnquireUser_Email_Dropdown}
    Take Screenshot    Party_EnquireUser_Fields
    Mx Scroll Element Into View    ${Party_EnquireUser_AssocZone_TableGrid_Row}
    Take Screenshot    Party_EnquireUser_Tables
    ${PTY_GLOBAL_ZONELIST}    Create List    
    ${ZoneCount}    SeleniumLibraryExtended.Get Element Count    ${Party_EnquireUser_AssocZone_TableGrid_Row}
    ${ZoneCount}    Evaluate    ${ZoneCount}+1
    :FOR    ${Index}    IN RANGE    1    ${ZoneCount}
    \    ${ActualZoneValue}    Get Text    ${Party_EnquireUser_AssocZone_TableGrid_Row}\[${Index}]${TableGrid_RowValues_Zone}
    \    Append To List    ${PTY_GLOBAL_ZONELIST}    ${ActualZoneValue}
    \    Exit For Loop If    ${Index}==${ZoneCount}
    
    ${PTY_GLOBAL_BRANCHLIST}    Create List
    ${BranchCount}    SeleniumLibraryExtended.Get Element Count    ${Party_EnquireUser_AssocZone_TableGrid_Row}
    ${BranchCount}    Evaluate    ${BranchCount}+1
    :FOR    ${Index}    IN RANGE    1    ${BranchCount}
    \    ${ActualBranchValue}    Get Text    ${Party_EnquireUser_AssocZone_TableGrid_Row}\[${Index}]${TableGrid_RowValues_Branch}
    \    Append To List    ${PTY_GLOBAL_BRANCHLIST}    ${ActualBranchValue}
    \    Exit For Loop If    ${Index}==${BranchCount}
    
    ${PTY_GLOBAL_ROLELIST}    Create List
    ${RoleCount}    SeleniumLibraryExtended.Get Element Count    ${Party_EnquireUser_AssocRoles_TableGrid_Row}
    ${RoleCount}    Evaluate    ${RoleCount}+1    
    :FOR    ${Index}    IN RANGE    1    ${RoleCount}
    \    ${ActualRoleValue}    Get Text    ${Party_EnquireUser_AssocRoles_TableGrid_Row}\[${Index}]${TableGrid_RowValues_Role}
    \    Append To List    ${PTY_GLOBAL_ROLELIST}    ${ActualRoleValue}
    \    Exit For Loop If    ${Index}==${RoleCount}
    
    Set Global Variable    ${PTY_GLOBAL_GIVENAME}
    Set Global Variable    ${PTY_GLOBAL_SURNAME}
    Set Global Variable    ${PTY_GLOBAL_TITLE}
    Set Global Variable    ${PTY_GLOBAL_OSUSERID}
    Set Global Variable    ${PTY_GLOBAL_COUNTRY}
    Set Global Variable    ${PTY_GLOBAL_USERTYPE_DD}
    Set Global Variable    ${PTY_GLOBAL_LANGUAGE_DD}
    Set Global Variable    ${PTY_GLOBAL_DEFZONE_DD}
    Set Global Variable    ${PTY_GLOBAL_DEFBRANCH_DD}
    Set Global Variable    ${PTY_GLOBAL_PHONE}
    Set Global Variable    ${PTY_GLOBAL_EMAIL}
    Set Global Variable    ${PTY_GLOBAL_ZONELIST}
    Set Global Variable    ${PTY_GLOBAL_BRANCHLIST}
    Set Global Variable    ${PTY_GLOBAL_ROLELIST}
    Set Global Variable    ${PTY_GLOBAL_USERTYPE_TABLE}
    Set Global Variable    ${PTY_GLOBAL_COUNTRY_TABLE}

Compare Party Data from Input Data
    [Documentation]    This keyword is used to compare Party data from Input data if update is done for the specific element.
    ...    @author: clanding    26APR2019    - initial create
    ...    @udpate: jdelacru    23MAY2019    - Added for loop to determine where Role has been updated or not
    [Arguments]    ${sFName}    ${sLName}    ${sTitle}    ${sOSUserID}    ${sCountryCode_2Code}
    ...    ${sCountryDesc}    ${sUserType_Desc}    ${sLanguageCode}    ${sLanguageDesc}    ${sDefZoneCode}    ${sDefBranchCode}
    ...    ${iContactNum1}    ${sEmail}    ${sRoleConfigList}

    ${NOCHANGE_PTY_USERTYPE_TABLE}    Run Keyword And Return Status    Should Be Equal As Strings    ${sUserType_Desc}    ${PTY_GLOBAL_USERTYPE_TABLE}
    ${NOCHANGE_PTY_COUNTRY_TABLE}    Run Keyword And Return Status    Should Be Equal As Strings    ${sCountryCode_2Code}    ${PTY_GLOBAL_COUNTRY_TABLE}
    ${NOCHANGE_PTY_JOBTITLE}    Run Keyword And Return Status    Should Be Equal As Strings    ${sTitle}    ${PTY_GLOBAL_TITLE}
    ${NOCHANGE_PTY_FIRSTNAME}    Run Keyword And Return Status    Should Be Equal As Strings    ${sFName}    ${PTY_GLOBAL_GIVENAME}
    ${NOCHANGE_PTY_SURNAME}    Run Keyword And Return Status    Should Be Equal As Strings    ${sLName}    ${PTY_GLOBAL_SURNAME}
    ${NOCHANGE_PTY_COUNTRY}    Run Keyword And Return Status    Should Be Equal As Strings    ${sCountryDesc}-${sCountryCode_2Code}    ${PTY_GLOBAL_COUNTRY}
    ${NOCHANGE_PTY_USERTYPE_DROPDOWN}    Run Keyword And Return Status    Should Be Equal As Strings    ${sUserType_Desc}    ${PTY_GLOBAL_USERTYPE_DD}
    ${NOCHANGE_PTY_CONTACTNUMBER1}    Run Keyword And Return Status    Should Be Equal As Strings    ${iContactNum1}    ${PTY_GLOBAL_PHONE}
    ${NOCHANGE_PTY_EMAIL}    Run Keyword And Return Status    Should Be Equal As Strings    ${sEmail}    ${PTY_GLOBAL_EMAIL}
    ${NOCHANGE_PTY_DEFZONE}    Run Keyword And Return Status    Should Be Equal As Strings    ${sDefZoneCode}    ${PTY_GLOBAL_DEFZONE_DD}
    ${NOCHANGE_PTY_DEFBRANCH}    Run Keyword And Return Status    Should Be Equal As Strings    ${sDefBranchCode}    ${PTY_GLOBAL_DEFBRANCH_DD}
    ${sLanguageCode}    Run Keyword If    '${sLanguageCode}'=='no tag' or '${sLanguageCode}'=='null' or '${sLanguageCode}'==''    Set Variable    en
    ...    ELSE    Set Variable    ${sLanguageCode}
    ${NOCHANGE_PTY_LANGUAGE}    Run Keyword And Return Status    Should Be Equal As Strings    ${sLanguageDesc}-${sLanguageCode}    ${PTY_GLOBAL_LANGUAGE_DD}
    ${sOSUserID}    Run Keyword If    '${sOSUserID}'=='no tag' or '${sOSUserID}'=='null' or '${sOSUserID}'==''    Set Variable
    ...    ELSE    Set Variable    ${sOSUserID}
    ${NOCHANGE_PTY_OSUSERID}    Run Keyword And Return Status    Should Be Equal As Strings    ${sOSUserID}    ${PTY_GLOBAL_OSUSERID}

    ${TotalUIRole}    Get Length    ${PTY_GLOBAL_ROLELIST}
    ${NOCHANGE_PTY_ROLELIST}    Create List
    :FOR    ${index}    IN RANGE    ${TotalUIRole}
    \    Log    ${index}
    \    ${RoleFromConfig}    Get From List   ${sRoleConfigList}    ${index}
    \    ${RoleFromUi}    Get From List    ${PTY_GLOBAL_ROLELIST}    ${index}
    \    ${NOCHANGE_PTY_ROLE}    Run Keyword And Return Status    Should Be Equal As Strings    ${RoleFromConfig}    ${RoleFromUi}
    \    Append To List    ${NOCHANGE_PTY_ROLELIST}    ${NOCHANGE_PTY_ROLE}

    Set Global Variable    ${NOCHANGE_PTY_JOBTITLE}
    Set Global Variable    ${NOCHANGE_PTY_FIRSTNAME}
    Set Global Variable    ${NOCHANGE_PTY_SURNAME}
    Set Global Variable    ${NOCHANGE_PTY_EMAIL}
    Set Global Variable    ${NOCHANGE_PTY_CONTACTNUMBER1}
    Set Global Variable    ${NOCHANGE_PTY_LANGUAGE}
    Set Global Variable    ${NOCHANGE_PTY_OSUSERID}
    Set Global Variable    ${NOCHANGE_PTY_COUNTRY}
    Set Global Variable    ${NOCHANGE_PTY_USERTYPE_DROPDOWN}
    Set Global Variable    ${NOCHANGE_PTY_USERTYPE_TABLE}
    Set Global Variable    ${NOCHANGE_PTY_COUNTRY_TABLE}
    Set Global Variable    ${NOCHANGE_PTY_DEFZONE}
    Set Global Variable    ${NOCHANGE_PTY_DEFBRANCH}
    Set Global Variable    ${NOCHANGE_PTY_ROLE}
    Set Global Variable    ${NOCHANGE_PTY_ROLELIST}  

Add Current Value to JSON for User Comparison Report for Party
    [Documentation]    This keyword is used to add current values from Party Application for JSON and save in file.
    ...    @author: clanding    26APR2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sOutputFilePath}

    ${File_Path}    Set Variable    ${sInputFilePath}${templateinput_SingleLOB}
    ${JSON_Object}    Load JSON From File    ${dataset_path}${File_Path}

    ${New_JSON}    Set To Dictionary    ${JSON_Object}    userType=${PTY_GLOBAL_USERTYPE_DD}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    countryCode=${PTY_GLOBAL_COUNTRY}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    firstName=${PTY_GLOBAL_GIVENAME}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    surname=${PTY_GLOBAL_SURNAME}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    jobTitle=${PTY_GLOBAL_TITLE}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    email=${PTY_GLOBAL_EMAIL}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    contactNumber1=${PTY_GLOBAL_PHONE}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    locale=${PTY_GLOBAL_LANGUAGE_DD}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    osUserId=${PTY_GLOBAL_OSUSERID}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    defaultZone=${PTY_GLOBAL_DEFZONE_DD}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    defaultBranch=${PTY_GLOBAL_DEFBRANCH_DD}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    userType_Table=${PTY_GLOBAL_USERTYPE_TABLE}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    countryCode_Table=${PTY_GLOBAL_COUNTRY_TABLE}

    Log    ${New_JSON}
    ${Converted_JSON}    Evaluate    json.dumps(${New_JSON})    json
    Log    ${Converted_JSON}
    ${JSONFile}    Set Variable    ${sOutputFilePath}${CURRENT_PARTY_DATA}.json
    Delete File If Exist    ${dataset_path}${JSONFile}
    Create File    ${dataset_path}${JSONFile}    ${Converted_JSON}
    ${File}    OperatingSystem.Get File    ${dataset_path}${JSONFile}

Add Input Value to JSON for User Comparison Report for Party
    [Documentation]    This keyword is used to add input values from Party Application for JSON and save in file.
    ...    @author: clanding    26APR2019    - initial create
    ...    @update: jdelacru    02MAY2019    - added 2 country code for userType variable
    ...    @update: dahijara    19AUG2019    - Updated value being set for country code from ${sCountryDesc} to ${sCountryDesc}-${sCountryCode_2Code}
    ...    @update: dahijara    19AUG2019    - Updated value being set for userType code from ${sUserType_Desc}-${sCountryCode_2Code} to ${sUserType_Desc}
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
    ${New_JSON}    Set To Dictionary    ${New_JSON}    defaultBranch=${sDefBranchCode}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    userType_Table=${sUserType_Desc}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    countryCode_Table=${sCountryCode_2Code}

    Log    ${New_JSON}
    ${Converted_JSON}    Evaluate    json.dumps(${New_JSON})    json
    Log    ${Converted_JSON}
    ${JSONFile}    Set Variable    ${sInputFilePath}${INPUT_PARTY_DATA}.json
    Delete File If Exist    ${dataset_path}${JSONFile}
    Create File    ${dataset_path}${JSONFile}    ${Converted_JSON}
    ${File}    OperatingSystem.Get File    ${dataset_path}${JSONFile}

Compare Input and Actual Party Data
    [Documentation]    This keyword is used to get input and actual Party data and compare them.
    ...    @author: clanding    26APR2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sOutputFilePath}
    
    ${Current_PartyData}    OperatingSystem.Get File    ${dataset_path}${sOutputFilePath}${CURRENT_PARTY_DATA}.json    
    ${Input_PartyData}    OperatingSystem.Get File    ${dataset_path}${sInputFilePath}${INPUT_PARTY_DATA}.json    
    ${IsMatched}    Run Keyword And Return Status    Mx Compare Json Data    ${Current_PartyData}    ${Input_PartyData}
    Run Keyword If    ${IsMatched}==${True}    Log    Input values and current values are equal and have no changes. ${Input_PartyData} == ${Current_PartyData}    level=WARN
    ...    ELSE IF    ${IsMatched}==${False}    Log    Input values and current values have differences. ${Input_PartyData} != ${Current_PartyData}    level=WARN

Validate Update Details in Search User Dialog in Party
    [Documentation]    This keyword is used to validate UserID, User Type and User Country if correct in Search User dialog when User details are updated.
    ...    @author: clanding    26APR2019    - initial create
    ...    @update: dahijara    15AUG2019    - added \ on index for element, this is an update for robot to consider it as a string not an index of
    ...    @update: dahijara    15AUG2019    - Get Matching Xpath Count' is deprecated. Updated keyword with `Get Element Count` instead. 
    [Arguments]    ${sLoginID}    ${sUserType}    ${sCountryCode}
    
    ${Count}    SeleniumLibraryExtended.Get Element Count    ${Party_SearchUser_TableRow}
    @{CountList}    Create List
    :FOR    ${INDEX}    IN RANGE    1    ${Count}+1
    \    
    \    ${User_Table}    Get Text    ${Party_SearchUser_Table}\[${INDEX}]${Party_SearchUser_UserID_TableRow}
    \    Run Keyword And Continue On Failure    Should Be Equal    ${sLoginID}    ${User_Table}    
    \    ${USER_MATCH}    Run Keyword And Return Status    Should Be Equal    ${sLoginID}    ${User_Table}
    \    Run Keyword If    ${USER_MATCH}==${True}    Log    Users Matched! ${sLoginID} = ${User_Table}
         ...    ELSE    Log    Users are not Matched! ${sLoginID} != ${User_Table}
    \    Take Screenshot    Party_SearchUserDialog
    \    
    \    ${UserType_Table}    Run Keyword If    ${USER_MATCH}==${True}    Get Text    ${Party_SearchUser_Table}\[${INDEX}]${Party_SearchUser_UserType_TableRow}
    \    ${UserType}    Run Keyword If    ${NOCHANGE_PTY_USERTYPE_TABLE}==${True}    Set Variable    ${PTY_GLOBAL_USERTYPE_TABLE}
         ...    ELSE    Set Variable    ${sUserType}
    \    Run Keyword If    ${USER_MATCH}==${True}    Run Keyword And Continue On Failure    Should Be Equal    ${UserType}    ${UserType_Table}
    \    ${UserType_stat}    Run Keyword If    ${USER_MATCH}==${True}    Run Keyword And Return Status    Should Be Equal    ${sUserType}    ${UserType_Table}
    \    Run Keyword If    ${UserType_stat}==${True}    Log    Matched! User Type is correct. '${sUserType}' = '${UserType_Table}'
         ...    ELSE IF    ${UserType_stat}==${False}    Log    Not Matched! Expected value: '${sUserType}'. Actual value: '${UserType_Table}'.    level=ERROR
    \    
    \    ${CountryCode_Table}    Run Keyword If    ${USER_MATCH}==${True}    Get Text    ${Party_SearchUser_Table}\[${INDEX}]${Party_SearchUser_UserCountry_TableRow}
    \    ${CountryCode}    Run Keyword If    ${NOCHANGE_PTY_COUNTRY_TABLE}==${True}    Set Variable    ${PTY_GLOBAL_COUNTRY_TABLE}
         ...    ELSE    Set Variable    ${sCountryCode}
    \    Run Keyword If    ${USER_MATCH}==${True}    Run Keyword And Continue On Failure    Should Be Equal    ${CountryCode}    ${CountryCode_Table}
    \    ${CountryCode_stat}    Run Keyword If    ${USER_MATCH}==${True}    Run Keyword And Return Status    Should Be Equal    ${sCountryCode}    ${CountryCode_Table}
    \    Run Keyword If    ${CountryCode_stat}==${True}    Log    Matched! Country Code is correct. '${sCountryCode}' = '${CountryCode_Table}'
         ...    ELSE IF      ${CountryCode_stat}==${False}    Log    Not Matched! Expected value: '${sCountryCode}'. Actual value: '${CountryCode_Table}'.    level=ERROR
    \    
    \    Run Keyword If    ${INDEX}>${Count}+1 and ${USER_MATCH}==${False}    Log    No Users Matched on the table!!
    \    Exit For Loop If    ${INDEX}==${Count}+1
    Take Screenshot    Party_SearchUserDialog
    Click Element    ${Party_SearchUser_Next_Button}
    Wait Until Element Is Visible    ${Party_EnquireUser_GivenName_TextBox}

Validate Party User Fields Have Correct Values for Update
    [Documentation]    This keyword is used to verify if Party Enquire User fields have correct values as per update details.
    ...    @author: clanding    26APR2019    - initial create
    ...    @update: jdelacru    23MAY2019    - added for loop for validating if role has been updated or not using role value
    [Arguments]    ${sFName}    ${sLName}    ${sTitle}    ${sOSUserID}    ${sCountry}    ${sUserType}    ${sLanguage}
    ...    ${sDefZone}    ${sDefBranch}    ${sPhone}    ${sEmail}    ${aAddZoneList}    ${aAddBranchList}    ${aRoleList}
    
    ${FName}    Run Keyword If    ${NOCHANGE_PTY_FIRSTNAME}==${True}    Set Variable    ${PTY_GLOBAL_GIVENAME}
    ...    ELSE    Set Variable    ${sFName}
    ${Actual_FName}    Get Value    ${Party_EnquireUser_GivenName_TextBox}
    Run Keyword And Continue On Failure    Should Be Equal    ${FName}    ${Actual_FName}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${FName}    ${Actual_FName}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${FName} = ${Actual_FName}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${FName} != ${Actual_FName}
    
    ${LName}    Run Keyword If    ${NOCHANGE_PTY_SURNAME}==${True}    Set Variable    ${PTY_GLOBAL_SURNAME}
    ...    ELSE    Set Variable    ${sLName}
    ${Actual_LName}    Get Value    ${Party_EnquireUser_Surname_TextBox}
    Run Keyword And Continue On Failure    Should Be Equal    ${LName}    ${Actual_LName}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${LName}    ${Actual_LName}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${LName} = ${Actual_LName}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${LName} != ${Actual_LName}
    
    ${Title}    Run Keyword If    ${NOCHANGE_PTY_JOBTITLE}==${True}    Set Variable    ${PTY_GLOBAL_TITLE}
    ...    ELSE    Set Variable    ${sTitle}
    ${Actual_Title}    Get Value    ${Party_EnquireUser_Title_TextBox}
    Run Keyword And Continue On Failure    Should Be Equal    ${Title}    ${Actual_Title}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${Title}    ${Actual_Title}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${Title} = ${Actual_Title}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${Title} != ${Actual_Title}
    
    ${OSUserID}    Run Keyword If    ${NOCHANGE_PTY_OSUSERID}==${True}    Set Variable    ${PTY_GLOBAL_OSUSERID}
    ...    ELSE    Set Variable    ${sOSUserID}
    ${Actual_OSUserID}    Get Value    ${Party_EnquireUser_OSUserID_TextBox}
    Run Keyword And Continue On Failure    Should Be Equal    ${OSUserID}    ${Actual_OSUserID}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${OSUserID}    ${Actual_OSUserID}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${OSUserID} = ${Actual_OSUserID}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${OSUserID} != ${Actual_OSUserID}
    
    ${Country}    Run Keyword If    ${NOCHANGE_PTY_COUNTRY}==${True}    Set Variable    ${PTY_GLOBAL_COUNTRY}
    ...    ELSE    Set Variable    ${sCountry}
    ${Actual_Country}    Get Value    ${Party_EnquireUser_Country_Dropdown}
    Run Keyword And Continue On Failure    Should Be Equal    ${Country}    ${Actual_Country}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${Country}    ${Actual_Country}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${Country} = ${Actual_Country}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${Country} != ${Actual_Country}
    
    ${UserType}    Run Keyword If    ${NOCHANGE_PTY_USERTYPE_DROPDOWN}==${True}    Set Variable    ${PTY_GLOBAL_USERTYPE_DD}
    ...    ELSE    Set Variable    ${sUserType}
    ${Actual_UserType}    Get Value    ${Party_EnquireUser_UserType_Dropdown}
    Run Keyword And Continue On Failure    Should Be Equal    ${UserType}    ${Actual_UserType}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${UserType}    ${Actual_UserType}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${UserType} = ${Actual_UserType}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${UserType} != ${Actual_UserType}
    
    ${Language}    Run Keyword If    ${NOCHANGE_PTY_LANGUAGE}==${True}    Set Variable    ${PTY_GLOBAL_LANGUAGE_DD}
    ...    ELSE    Set Variable    ${sLanguage}
    ${Actual_Language}    Get Value    ${Party_EnquireUser_Language_Dropdown}
    Run Keyword And Continue On Failure    Should Be Equal    ${Language}    ${Actual_Language}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${Language}    ${Actual_Language}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${Language} = ${Actual_Language}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${Language} != ${Actual_Language}
    
    ${DefZone}    Run Keyword If    ${NOCHANGE_PTY_DEFZONE}==${True}    Set Variable    ${PTY_GLOBAL_DEFZONE_DD}
    ...    ELSE    Set Variable    ${sDefZone}
    ${Actual_Zone}    Get Value    ${Party_EnquireUser_DefaultZone_Dropdown}
    Run Keyword And Continue On Failure    Should Be Equal    ${DefZone}    ${Actual_Zone}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${DefZone}    ${Actual_Zone}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${DefZone} = ${Actual_Zone}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${DefZone} != ${Actual_Zone}
    
    ${DefBranch}    Run Keyword If    ${NOCHANGE_PTY_DEFBRANCH}==${True}    Set Variable    ${PTY_GLOBAL_DEFBRANCH_DD}
    ...    ELSE    Set Variable    ${sDefBranch}
    ${Actual_Branch}    Get Value    ${Party_EnquireUser_BranchName_Dropdown}
    Run Keyword And Continue On Failure    Should Be Equal    ${DefBranch}    ${Actual_Branch}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${DefBranch}    ${Actual_Branch}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${DefBranch} = ${Actual_Branch}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${DefBranch} != ${Actual_Branch}
    
    ${Phone}    Run Keyword If    ${NOCHANGE_PTY_CONTACTNUMBER1}==${True}    Set Variable    ${PTY_GLOBAL_PHONE}
    ...    ELSE    Set Variable    ${sPhone}
    ${Actual_Phone}    Get Value    ${Party_EnquireUser_Phone_Dropdown}
    Run Keyword And Continue On Failure    Should Be Equal    ${Phone}    ${Actual_Phone}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${Phone}    ${Actual_Phone}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${Phone} = ${Actual_Phone}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${Phone} != ${Actual_Phone}
    
    ${Email}    Run Keyword If    ${NOCHANGE_PTY_EMAIL}==${True}    Set Variable    ${PTY_GLOBAL_EMAIL}
    ...    ELSE    Set Variable    ${sEmail}
    ${Actual_Email}    Get Value    ${Party_EnquireUser_Email_Dropdown}
    Run Keyword And Continue On Failure    Should Be Equal    ${Email}    ${Actual_Email}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${Email}    ${Actual_Email}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${Email} = ${Actual_Email}
    ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${Email} != ${Actual_Email}
    
    Take Screenshot    Party_EnquireUser_Fields
    Mx Scroll Element Into View    ${Party_EnquireUser_AssocZone_TableGrid_Row}
    Take Screenshot    Party_EnquireUser_Tables
    
    ${ZoneCount}    Get Length    ${PTY_GLOBAL_ZONELIST}
    ${ZoneCount}    Evaluate    ${ZoneCount}+1
    :FOR    ${Index}    IN RANGE    1    ${ZoneCount}
    \    ${Index_Value}    Evaluate    ${Index}-1
    \    ${ZoneValue_From_List}    Get From List    ${PTY_GLOBAL_ZONELIST}    ${Index_Value}
    \    ${ActualZoneValue}    Get Text    ${Party_EnquireUser_AssocZone_TableGrid_Row}\[${Index}]${TableGrid_RowValues_Zone}
    \    Run Keyword And Continue On Failure    Should Be Equal    ${ZoneValue_From_List}    ${ActualZoneValue}
    \    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${ZoneValue_From_List}    ${ActualZoneValue}
    \    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${ZoneValue_From_List} = ${ActualZoneValue}
         ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${ZoneValue_From_List} != ${ActualZoneValue}
    \    
    \    Exit For Loop If    ${Index}>${ZoneCount}
    
    ${BranchCount}    Get Length    ${PTY_GLOBAL_BRANCHLIST}
    ${BranchCount}    Evaluate    ${BranchCount}+1
    :FOR    ${Index}    IN RANGE    1    ${BranchCount}
    \    ${Index_Value}    Evaluate    ${Index}-1
    \    ${BranchValue_From_List}    Get From List    ${PTY_GLOBAL_BRANCHLIST}    ${Index_Value}
    \    ${ActualBranchValue}    Get Text    ${Party_EnquireUser_AssocZone_TableGrid_Row}\[${Index}]${TableGrid_RowValues_Branch}
    \    Run Keyword And Continue On Failure    Should Be Equal    ${BranchValue_From_List}    ${ActualBranchValue}
    \    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${BranchValue_From_List}    ${ActualBranchValue}
    \    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${BranchValue_From_List} = ${ActualBranchValue}
         ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual are NOT matched. ${BranchValue_From_List} != ${ActualBranchValue}
    \    
    \    Exit For Loop If    ${Index}>${BranchCount}
    
    ${RoleCount}    Get Length    ${NOCHANGE_PTY_ROLELIST}
    :FOR    ${Index}    IN RANGE    ${RoleCount}
    \    ${NOCHANGE_PTY_ROLEVALUE}    Get From List    ${NOCHANGE_PTY_ROLELIST}    ${Index}
    \    ${PTY_ROLEVALUE}    Get From List    ${PTY_GLOBAL_ROLELIST}    ${Index}
    \    ${PTY_RoleValueFromExcel}    Get From List    ${aRoleList}    ${Index}
    \    Run Keyword If    ${NOCHANGE_PTY_ROLEVALUE}==${True}    Validate Associated Roles in Essence Enquire User Page Using Role Value    ${PTY_ROLEVALUE}    ${Index}
         ...    ELSE IF    ${NOCHANGE_PTY_ROLEVALUE}==${False}    Validate Associated Roles in Essence Enquire User Page Using Role Value    ${PTY_RoleValueFromExcel}    ${Index}


Search User ID in Party Enquire User Page for Successful Delete
    [Documentation]    This keyword is used to search User ID on Party Enquire User page and validate that User is deleted from Party.
    ...    @author: amansuet    121AUG2019    - initial create
    [Arguments]    ${sUserID}

    Wait Until Element Is Visible     ${Party_HomePage_Process_TextBox}    timeout=20s
    Input Text    ${Party_HomePage_Process_TextBox}    Enquire User
    Press key    ${Party_HomePage_Process_TextBox}   ${Keyboard_Enter}
    Wait Until Element Is Visible     ${Party_EnquireUser_UserID_TextBox}    timeout=20s
    Mx Input Text    ${Party_EnquireUser_UserID_TextBox}    ${sUserID}
    Click Element    ${Party_EnquireUser_Search_Button}
    Wait Until Element Is Visible    ${Party_SearchUser_UserID_TextBox}    timeout=20s
    Mx Input Text    ${Party_SearchUser_UserID_TextBox}    ${sUserID}
    Click Element    ${Party_SearchUser_Search_Button}
    ${Party_SearchUser_User_Not_Found_Label_Status}    Run Keyword And Return Status    Element Should Be Visible    ${Party_SearchUser_User_Not_Found_Label}
    Run Keyword If    ${Party_SearchUser_User_Not_Found_Label_Status}==True    Log    Correct!!! User(s) not found
    ...    ELSE    Log    Incorrect!!! User still exist.    level=ERROR
    Element Should Not Be Visible    ${Party_SearchUser_Results_Table}${Party_SearchUser_UserID_TableRow}
    Take Screenshot    Party_Search_UserNotFound
    Click Element    ${Party_SearchUser_Close_Dialog}
    Wait Until Element Is Visible    ${Party_EnquireUser_GivenName_TextBox}
    ${Given_Name_Empty}    Run Keyword And Return Status    SeleniumLibraryExtended.Element Text Should Be    ${Party_EnquireUser_GivenName_TextBox}    ${EMPTY}
    Run Keyword If    ${Given_Name_Empty}==True    Log    Correct!! Given Name is blank.
    ...    ELSE    Log    Incorrect!! Given Name is populated.    level=ERROR
    Take Screenshot    Party_Search_GivenNameEmpty
