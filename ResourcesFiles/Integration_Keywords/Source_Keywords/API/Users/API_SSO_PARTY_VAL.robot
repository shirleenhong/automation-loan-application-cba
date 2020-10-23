*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Resource    ../../../../../Configurations/Party_Import_File.robot

*** Keywords ***
Validate User Details in Party for Success
    [Documentation]    This keyword is used to validate user details in Party.
    ...    @author: clanding    22APR2019    - initial create
    ...    @update: clanding    24APR2019    - added CBA value for Branch, updated arguments
    ...    @update: clanding    15MAY2019    - removed hard coded value for Default Branch
    ...    @update: rtarayao    28NOV2019    - added logout keyword
    ...    @update: jdelacru    29JAN2020    - modified redirection of Party Validation to Essence (Essence 6.2)
    [Arguments]    ${sLoginID}    ${sUserType}    ${sCountryCode}    ${sFName}    ${sLName}    ${sTitle}
    ...    ${sOSUserID}    ${sCountryDesc}    ${sLanguageDesc}    ${sLanguageCode}    ${sDefZone}    ${sDefBranchCode}    ${sPhone}
    ...    ${sEmail}    ${aAddZoneList}    ${aAddBranchList}    ${aRoleList}
    
    Launch PARTY Page
    # Login To Essence
    Search Process in Party    ${ENQUIRE_USER}
    Search for a Valid User ID in Party Enquire User Page    ${sLoginID}
    Validate Details in Search User Dialog in Party    ${sLoginID}    ${sUserType}    ${sCountryCode}
    Validate Party Enquire User Fields Have Correct Values    ${sFName}    ${sLName}    ${sTitle}    ${sOSUserID}    
    ...    ${sCountryDesc}-${sCountryCode}    ${sUserType}    ${sLanguageDesc}-${sLanguageCode}    ${sDefZone}    ${sDefBranchCode}    ${sPhone}    ${sEmail}
    ...    ${aAddZoneList}    ${aAddBranchList}    ${aRoleList}
    Logout User on Party
    # Logout from Essence
    Close Browser
    

Get Party User Values
    [Documentation]    This keyword is used to get field values from Enquire User Page in Party.
    ...    @author: clanding    25APR2019    - initial create
    [Arguments]    ${sLoginID}
    
    Launch PARTY Page
    Search Process in Essence    ${ENQUIRE_USER}
    Search for a Valid User ID in Party Enquire User Page    ${sLoginID}
    Search for User ID and Get User Details in Party    ${sLoginID}
    Logout User on Party
    Close All Browsers

Validate Update User in Party Page
    [Documentation]    This keyword is used to validate user in Party page if successfully updated.
    ...    @author: clanding    25APR2019    - initial create
    [Arguments]    ${sLoginID}    ${sFName}    ${sLName}    ${sTitle}    ${sOSUserID}    ${sCountryCode}
    ...    ${sCountryDesc}    ${sUserType}    ${sLanguageCode}    ${sLanguageDesc}    ${sDefZoneCode}    ${sDefBranchCode}
    ...    ${sPhone}    ${sEmail}    ${aAddZone_List}    ${aAddBranch_List}    ${aRoleList}
    
    Launch PARTY Page
    Search Process in Essence    ${ENQUIRE_USER}
    Search for a Valid User ID in Party Enquire User Page    ${sLoginID}
    Validate Update Details in Search User Dialog in Party    ${sLoginID}    ${sUserType}    ${sCountryCode}
    Validate Party User Fields Have Correct Values for Update    ${sFName}    ${sLName}    ${sTitle}    ${sOSUserID}    
    ...    ${sCountryDesc}-${sCountryCode}    ${sUserType}    ${sLanguageDesc}-${sLanguageCode}    ${sDefZoneCode}    ${sDefBranchCode}
    ...    ${sPhone}    ${sEmail}    ${aAddZone_List}    ${aAddBranch_List}    ${aRoleList}
    Logout User on Party
    Close All Browsers
    
Validate Party for Delete Success
    [Documentation]    This keyword is used to verify that user in Party Enquire User page for delete scenario.
    ...    @author: amansuet    21AUG2019    - initial create
    ...    @update: cfrancis    03AUG2020    - added logging out before closing browser
    [Arguments]    ${sLoginID}

    Launch PARTY Page
    Search User ID in Party Enquire User Page for Successful Delete    ${sLoginID}
    Logout User on Party
    Close Browser
    
Validate User is Existing for Party in GET All User Success
    [Documentation]    This keyword is used to validate user is existing in Party application.
    ...    @author: amansuet    06SEP2019    - initial create
    ...    @update: jdelacru    29JAN2020    - modified redirection of Party Validation to Essence (Essence 6.2)
    [Arguments]    ${sLoginID}
    
    Launch PARTY Page
    # Login To Essence
    Search Process in Party    ${ENQUIRE_USER}
    Search for a Valid User ID in Party Enquire User Page    ${sLoginID}
    Close Search User ID in Party
    Logout User on Party
    Close Browser
    # Logout From Essence

Create User in Party
    [Documentation]    This keyword is used to create user in Party.
    ...    @author: jloretiz    11SEP2019    - initial create
    ...    @update: jloretiz    17SEP2019    - added setting of value for roles
    ...    @update: cfrancis    03AUG2020    - added logging out before closing browser
    [Arguments]    ${APIDataSet}
    
    ${UserType}    Get User Type Code and Return Description    &{APIDataSet}[userType]    0
    ${2Code_CountryCode}    Get 3-code country from the input 2-code country    &{APIDataSet}[countryCode]
    ${CountryDesc}    Get Country Desc from the input 2-code country    &{APIDataSet}[countryCode]
    ${Zone}    Get Default Zone Configuration and Return Corresponding Value    &{APIDataSet}[defaultBusinessEntity]    |    ${PARTY}    0
    
    Launch PARTY Page
    Wait Until Element Is Visible     ${Party_HomePage_Process_TextBox}    timeout=20s
    Input Text    ${Party_HomePage_Process_TextBox}    Create User
    Press key    ${Party_HomePage_Process_TextBox}   ${Keyboard_Enter}
    Wait Until Element Is Visible     ${Party_CreateUser_UserId_TextBox}    timeout=10s
    
    Mx Scroll Element Into View    ${Party_CreateUser_Roles_Table}
    Mx Click Element    ${Party_CreateUser_Role_SelectAll}
    Mx Click Element    ${Party_CreateUser_Role_SelectAll}
    
    ${Count}    SeleniumLibraryExtended.Get Element Count    ${Party_CreateUser_Roles_Table}
    @{CountList}    Create List
    :FOR    ${INDEX}    IN RANGE    1    ${Count} + 1
    \    
    \    ${Role_Name}    Get Text    ${Party_CreateUser_Roles_Table}\[${INDEX}]${Party_CreateUser_RoleName_TableRow}
    \    Mx Scroll Element Into View    ${Party_CreateUser_Roles_Table}\[${INDEX}]${Party_CreateUser_RoleName_TableRow}
    \    Run Keyword If    '${Role_Name}'=='&{APIDataSet}[roles]'    Mx Click Element    ${Party_CreateUser_Roles_Table}\[${INDEX}]${Party_CreateUser_Role_CheckBox}
    \    
    \    Exit For Loop If    '${Role_Name}'=='&{APIDataSet}[roles]'
    
    Input Text    ${Party_CreateUser_UserId_TextBox}    &{APIDataSet}[loginId]
    Input Text    ${Party_CreateUser_GivenName_TextBox}    &{APIDataSet}[firstName]
    Input Text    ${Party_CreateUser_SurName_TextBox}    &{APIDataSet}[surname]
    Input Text    ${Party_CreateUser_BusinessTitle_TextBox}    &{APIDataSet}[jobTitle]
    Input Text    ${Party_CreateUser_OSUserID_TextBox}    &{APIDataSet}[osUserId]
    Input Text    ${Party_CreateUser_CountryCode_TextBox}    ${CountryDesc}-${2Code_CountryCode}
    Input Text    ${Party_CreateUser_UserType_TextBox}    ${UserType}
    Input Text    ${Party_CreateUser_LanguageCode_TextBox}    English-&{APIDataSet}[locale]
    Input Text    ${Party_CreateUser_Email_TextBox}    &{APIDataSet}[email]
    Input Text    ${Party_CreateUser_Phone_TextBox}    &{APIDataSet}[contactNumber1]
    Input Text    ${Party_CreateUser_DefaultZone_TextBox}   ${Zone}
    Press key     ${Party_CreateUser_DefaultZone_TextBox}   ${Keyboard_Enter}
    
    ${Branch}    Get Default Branch Configuration and Return Corresponding Value    &{APIDataSet}[defaultBusinessEntity]    |    ${PARTY}    0
    ${DefaultBranch_PARTY}    Create Query for Party Branch and Return    ${Branch}
    
    Press key     ${Party_CreateUser_BranchName_TextBox}    ${DefaultBranch_PARTY}
    Press key     ${Party_CreateUser_BranchName_TextBox}    ${Keyboard_Enter}
    Click Button   ${Party_CreateUser_Next_Button}
    Wait Until Element Is Visible     ${Party_CreateUser_Message_Text}    timeout=10s
    ${textValue}    Get Value    ${Party_CreateUser_Message_Text}
    Should Be Equal    ${textValue}    User &{APIDataSet}[loginId] created successfully.  
    Click Button   ${Party_CreateUser_Next_Button}
    Logout User on Party
    Close Browser

Update User in Party
    [Documentation]    This keyword is used to update user in Party.
    ...    @author: jloretiz    11SEP2019    - initial create
    ...    @update: rtarayao    26NOV2019    - added logout keyword
    ...    @update: jdelacru    29JAN2020    - modified redirection of Party Validation to Essence (Essence 6.2)
    [Arguments]    ${APIDataSet}
    
    ${UserType}    Get User Type Code and Return Description    &{APIDataSet}[userType]    0
    ${2Code_CountryCode}    Get 3-code country from the input 2-code country    &{APIDataSet}[countryCode]
    ${CountryDesc}    Get Country Desc from the input 2-code country    &{APIDataSet}[countryCode]
    ${Zone}    Get Default Zone Configuration and Return Corresponding Value    &{APIDataSet}[defaultBusinessEntity]    |    ${PARTY}    0
    
    Launch PARTY Page
    # Login To Essence
    Wait Until Element Is Visible     ${Party_HomePage_Process_TextBox}    timeout=20s
    Input Text    ${Party_HomePage_Process_TextBox}    Amend User
    Press key    ${Party_HomePage_Process_TextBox}   ${Keyboard_Enter}
    Wait Until Element Is Visible     ${Party_AmendUser_UserId_TextBox}    timeout=5s
    
    Click Element    ${Party_EnquireUser_Search_Button}
    Wait Until Element Is Visible    ${Party_SearchUser_UserID_TextBox}    30s
    Mx Input Text    ${Party_SearchUser_UserID_TextBox}    &{APIDataSet}[loginId]
    Click Element    ${Party_SearchUser_Search_Button}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${Party_SearchUser_TableRow}        
    ${Count}    SeleniumLibraryExtended.Get Element Count    ${Party_SearchUser_TableRow}
    Run Keyword If    ${Count}==0    Fail    User '&{APIDataSet}[loginId]' not found. Change Login ID to continue the Update scenario.
    ...    ELSE    Log    User '&{APIDataSet}[loginId]' found.
    Take Screenshot    Party_SearchUser
    
    Validate Details in Search User Dialog in Party    &{APIDataSet}[loginId]    ${UserType}    ${2Code_CountryCode}
    
    Wait Until Element Is Visible     ${Party_AmendUser_GivenName_TextBox}    10s
    Input Text    ${Party_AmendUser_GivenName_TextBox}    &{APIDataSet}[firstName]
    Input Text    ${Party_AmendUser_SurName_TextBox}    &{APIDataSet}[surname]
    
    Click Button   ${Party_AmendUser_Next_Button}
    Wait Until Element Is Visible     ${Party_CreateUser_Message_Text}    timeout=10s
    ${textValue}    Get Value    ${Party_CreateUser_Message_Text}
    Should Be Equal    ${textValue}    User &{APIDataSet}[loginId] updated successfully.  
    Wait Until Element Is Visible     ${Party_AmendUser_Next_Button}    timeout=10s
    Mx Click Element   ${Party_AmendUser_Next_Button}
    Logout User on Party
    # Logout from Essence