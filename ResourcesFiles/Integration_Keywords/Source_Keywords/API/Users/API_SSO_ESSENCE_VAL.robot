*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Validate User in Essence Page for Success
    [Documentation]    This keyword is used to validate user in Essence page if successfully created.
    ...    @author: clanding    15APR2019    - initial create
    ...    @update: clanding    15MAY2019    - removed hard coded value for Default Branch
    ...    @update: rtarayao    28NOV2019    - added logout keyword
    [Arguments]    ${sLoginID}    ${sFName}    ${sLName}    ${sTitle}    ${sOSUserID}    ${sCountryCode}
    ...    ${sCountryDesc}    ${sUserType}    ${sLanguageCode}    ${sLanguageDesc}    ${sDefZoneCode}    ${sDefBranchCode}
    ...    ${sPhone}    ${sEmail}    ${aAddZone_List}    ${aAddBranch_List}    ${aRoleList}
    
    Login To Essence
    Search Process in Essence    ${ENQUIRE_USER}
    Search for a Valid User ID in Essence Enquire User Page    ${sLoginID}
    Validate Details in Search User Dialog in Essence    ${sLoginID}    ${sUserType}    ${sCountryCode}
    Validate Essence Enquire User Fields Have Correct Values    ${sFName}    ${sLName}    ${sTitle}    ${sOSUserID}    
    ...    ${sCountryDesc}-${sCountryCode}    ${sUserType}    ${sLanguageDesc}-${sLanguageCode}    ${sDefZoneCode}    ${sDefBranchCode}
    ...    ${sPhone}    ${sEmail}    ${aAddZone_List}    ${aAddBranch_List}    ${aRoleList}
    Logout from Essence
    Close All Browsers

Get Essence User Values
    [Documentation]    This keyword is used to get field values from Enquire User Page in Essence.
    ...    @author: clanding    24APR2019    - initial create
    [Arguments]    ${sLoginID}
    
    Login To Essence
    Search Process in Essence    ${ENQUIRE_USER}
    Search for a Valid User ID in Essence Enquire User Page    ${sLoginID}
    Search for User ID and Get User Details in Essence    ${sLoginID}
    Logout from Essence
    Close All Browsers

Validate Update User in Essence Page
    [Documentation]    This keyword is used to validate user in Essence page if successfully updated.
    ...    @author: clanding    24APR2019    - initial create
    [Arguments]    ${sLoginID}    ${sFName}    ${sLName}    ${sTitle}    ${sOSUserID}    ${sCountryCode}
    ...    ${sCountryDesc}    ${sUserType}    ${sLanguageCode}    ${sLanguageDesc}    ${sDefZoneCode}    ${sDefBranchCode}
    ...    ${sPhone}    ${sEmail}    ${aAddZone_List}    ${aAddBranch_List}    ${aRoleList}
    
    Login To Essence
    Search Process in Essence    ${ENQUIRE_USER}
    Search for a Valid User ID in Essence Enquire User Page    ${sLoginID}
    Validate Update Details in Search User Dialog in Essence    ${sLoginID}    ${sUserType}    ${sCountryCode}
    Validate Essence Enquire User Fields Have Correct Values for Update    ${sFName}    ${sLName}    ${sTitle}    ${sOSUserID}    
    ...    ${sCountryDesc}-${sCountryCode}    ${sUserType}    ${sLanguageDesc}-${sLanguageCode}    ${sDefZoneCode}    ${sDefBranchCode}
    ...    ${sPhone}    ${sEmail}    ${aAddZone_List}    ${aAddBranch_List}    ${aRoleList}
    Logout from Essence
    Close All Browsers
    
    
Validate Essence for Delete Success
    [Documentation]    This keyword is used to verify that user in Essence page for delete scenario.
    ...    @update: xmiranda    15AUG2019    - initial draft
    ...    @update: cfrancis    05AUG2020    - added logout from application
    [Arguments]    ${sloginId}

    Login To Essence
    Search User ID in Essence Enquire User Page for Successful Delete    ${sloginId}
    Logout from Essence
    Close Browser
    
Validate User is Existing for Essence in GET All User Success
    [Documentation]    This keyword is used to validate user is existing in Party application.
    ...    @author: amansuet    06SEP2019    - initial create
    [Arguments]    ${sLoginID}
    
    Login To Essence
    Search Process in Essence    ${ENQUIRE_USER}
    Search for a Valid User ID in Essence Enquire User Page    ${sLoginID}
    Close Search User ID in Essence
    Logout from Essence
    Close All Browsers    

Create User in Essence
    [Documentation]    This keyword is used to create user in Essence.
    ...    @author: jloretiz    11SEP2019    - initial create
	...    @update: jloretiz    17SEP2019    - added setting of value for roles
    [Arguments]    ${APIDataSet}
    
    ${UserType}    Get User Type Code and Return Description    &{APIDataSet}[userType]    0
    ${2Code_CountryCode}    Get 3-code country from the input 2-code country    &{APIDataSet}[countryCode]
    ${CountryDesc}    Get Country Desc from the input 2-code country    &{APIDataSet}[countryCode]
    ${Zone}    Get Default Zone Configuration and Return Corresponding Value    &{APIDataSet}[defaultBusinessEntity]    |    ${COREBANKING}    0
    
    Login To Essence
    Search Process in Essence    ${CREATE_USER}
    
    Mx Scroll Element Into View    ${Essence_CreateUser_Roles_Table}
    Mx Click Element    ${Essence_CreateUser_Role_SelectAll}
    Mx Click Element    ${Essence_CreateUser_Role_SelectAll}
    
    ${Count}    SeleniumLibraryExtended.Get Element Count    ${Essence_CreateUser_Roles_Table}
    @{CountList}    Create List
    :FOR    ${INDEX}    IN RANGE    1    ${Count} + 1
    \    
    \    ${Role_Name}    Get Text    ${Essence_CreateUser_Roles_Table}\[${INDEX}]${Essence_CreateUser_RoleName_TableRow}
    \    Mx Scroll Element Into View    ${Essence_CreateUser_Roles_Table}\[${INDEX}]${Essence_CreateUser_RoleName_TableRow}
    \    Run Keyword If    '${Role_Name}'=='&{APIDataSet}[roles]'    Mx Click Element    ${Essence_CreateUser_Roles_Table}\[${INDEX}]${Essence_CreateUser_Role_CheckBox}
    \    
    \    Exit For Loop If    '${Role_Name}'=='&{APIDataSet}[roles]'
    
    Input Text    ${Essence_CreateUser_UserId_TextBox}    &{APIDataSet}[loginId]
    Input Text    ${Essence_CreateUser_GivenName_TextBox}    &{APIDataSet}[firstName]
    Input Text    ${Essence_CreateUser_SurName_TextBox}    &{APIDataSet}[surname]
    Input Text    ${Essence_CreateUser_BusinessTitle_TextBox}    &{APIDataSet}[jobTitle]
    Input Text    ${Essence_CreateUser_OSUserID_TextBox}    &{APIDataSet}[osUserId]
    Input Text    ${Essence_CreateUser_CountryCode_TextBox}    ${CountryDesc}-${2Code_CountryCode}
    Input Text    ${Essence_CreateUser_UserType_TextBox}    ${UserType}
    Input Text    ${Essence_CreateUser_LanguageCode_TextBox}    English-&{APIDataSet}[locale]
    Input Text    ${Essence_CreateUser_Email_TextBox}    &{APIDataSet}[email]
    Input Text    ${Essence_CreateUser_Phone_TextBox}    &{APIDataSet}[contactNumber1]
    Input Text    ${Essence_CreateUser_DefaultZone_TextBox}   ${Zone}
    Press key     ${Essence_CreateUser_DefaultZone_TextBox}   ${Keyboard_Enter}
    
    ${Branch}    Get Default Branch Configuration and Return Corresponding Value    &{APIDataSet}[defaultBusinessEntity]    |    ${COREBANKING}    0
    ${DefaultBranch_COREBANKING}    Create Query for Essence Branch and Return     ${Branch}
    
    Input Text    ${Essence_CreateUser_BranchName_TextBox}    ${DefaultBranch_COREBANKING}
    Press key     ${Essence_CreateUser_BranchName_TextBox}    ${Keyboard_Enter}
    Click Button   ${Essence_CreateUser_Next_Button}
    Wait Until Element Is Visible     ${Essence_CreateUser_Message_Text}    timeout=30s
    ${textValue}    Get Value    ${Essence_CreateUser_Message_Text}
    Should Be Equal    ${textValue}    User &{APIDataSet}[loginId] created successfully.  
    Click Button   ${Essence_CreateUser_Next_Button}
    
    Logout from Essence
    Close Browser

Update User in Essence
    [Documentation]    This keyword is used to update user in Essence.
    ...    @author: jloretiz    16SEP2019    - initial create
    ...    @update: jloretiz    17SEP2019    - added setting of value for roles
    ...    @update: rtarayao    26NOV2019    - added logout keyword
    [Arguments]    ${APIDataSet}
    
    ${UserType}    Get User Type Code and Return Description    &{APIDataSet}[userType]    0
    ${2Code_CountryCode}    Get 3-code country from the input 2-code country    &{APIDataSet}[countryCode]
    ${CountryDesc}    Get Country Desc from the input 2-code country    &{APIDataSet}[countryCode]
    ${Zone}    Get Default Zone Configuration and Return Corresponding Value    &{APIDataSet}[defaultBusinessEntity]    |    ${COREBANKING}    0
    
    Login To Essence
    Search Process in Essence    ${AMEND_USER}
    
    Wait Until Element Is Visible    ${Essence_EnquireUser_Search_Button}    30s
    Click Element    ${Essence_EnquireUser_Search_Button}
    Wait Until Element Is Visible    ${Essence_SearchUser_UserID_TextBox}    30s
    Mx Input Text    ${Essence_SearchUser_UserID_TextBox}    &{APIDataSet}[loginId]
    Click Element    ${Essence_SearchUser_Search_Button}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${Essence_SearchUser_TableRow}        
    ${Count}    SeleniumLibraryExtended.Get Element Count    ${Essence_SearchUser_TableRow}
    Run Keyword If    ${Count}==0    Fail    User '&{APIDataSet}[loginId]' not found. Change Login ID to continue the Update scenario.
    ...    ELSE    Log    User '&{APIDataSet}[loginId]' found.
    Take Screenshot    Essence_SearchUser

    Validate Details in Search User Dialog in Essence    &{APIDataSet}[loginId]    ${UserType}    ${2Code_CountryCode}
    
    Wait Until Element Is Visible     ${Essence_AmendUser_GivenName_TextBox}    10s
    Input Text    ${Essence_AmendUser_GivenName_TextBox}    &{APIDataSet}[firstName]
    Input Text    ${Essence_AmendUser_SurName_TextBox}    &{APIDataSet}[surname]
    
    Click Button   ${Essence_AmendUser_Next_Button}
    Wait Until Element Is Visible     ${Essence_CreateUser_Message_Text}    timeout=10s
    ${textValue}    Get Value    ${Essence_CreateUser_Message_Text}
    Should Be Equal    ${textValue}    User &{APIDataSet}[loginId] updated successfully.  
    Wait Until Element Is Visible     ${Essence_AmendUser_Next_Button}    timeout=10s
    Mx Click Element    ${Essence_AmendUser_Next_Button}
    Logout from Essence
    Close Browser

Delete User in Essence
    [Documentation]    This keyword is used to navigate to Delete User page in Essence and delete user in Essence based on Login Id.
    ...    This validates that user is succesfully deleted.  
    ...    @author: dahijara    19SEP2019    - initial create
    ...    @update: rtarayao    21NOV2019    - added keyword to log out user from essence
    [Arguments]    ${iPartyID}
      
    Login To Essence
    Search Process in Essence    ${DELETE_USER}
    Delete User in Essence Using LoginId    ${iPartyID}
    Logout from Essence
    Close Browser