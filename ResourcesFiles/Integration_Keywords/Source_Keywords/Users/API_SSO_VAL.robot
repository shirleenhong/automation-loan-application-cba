*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Validate SSO for Post Success
    [Documentation]    This keyword is used to verify SSO page fields if correct based from the input payload.
    ...    @author: clanding
    ...    @update: clanding    20DEC2018    - changed userID to loginId
    ...    @update: clanding    08APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...    @update: xmiranda    22JUL2019    - added a condition for the SSO_AssocApps_tablegrid count. If Count is equal to 0, then it wont validate the Associated Tables.
    ...    @update: xmiranda    23JUL2019    - changed the Deprecated Keyword "Get Matching Xpath Count" to "Get Element Count", Replaced hardcoded "True" and "False" with Boolean Variables ${True} and ${False}
    ...    @update: xmiranda    24JUL2019    - Removed DB Validation Keywords for Essence, Party and LIQ
    ...    @update: dahijara    25JUL2019    - added contition to handle addition of new LOB to an existing user profile
    ...    @update: jdelacru    06NOV2019    - added Return From Keyword If to handle if SSO is enabled/disabled
    [Arguments]    ${sCountryCode_2Code}    ${sCountryDesc}    ${sCentralUserType}    ${sCentralRoles}    ${sLoginID}
    ...    ${sFName}    ${sLName}    ${sJobTitle}    ${sLocale}    ${iContactNum1}    ${sEmail}    ${sOSUserID}
    ...    ${sLOB}
    Return From Keyword If    '${SSO_ENABLED}'=='NO'
    
    ${SSO_UserType_Desc}    ${SSO_Language_Desc}    Get Defined Description for Other Code Values    ${sCentralUserType}

    ${SSO_Role_List}    Run Keyword If    ${USER_MATCH}==${True}    Set Variable    ${SSO_GLOBAL_ROLE}
    ...    ELSE    Get Role Value from Config Setup    ${sCentralRoles}

    Launch SSO Page
    Search User ID in Enquire User Page    ${sLoginID}    ${sCentralUserType}    ${sCountryCode_2Code}
    Validate Enquire User Page Mandatory Fields    ${sFName}    ${sLName}    ${sJobTitle}    ${sCountryCode_2Code}
    ...    ${sCountryDesc}
    Validate Enquire User Page Other Fields    ${SSO_UserType_Desc}    ${SSO_Language_Desc}    ${sLocale}    ${iContactNum1}    ${sEmail}    ${sOSUserID}
    ${Count}    SeleniumLibraryExtended.Get Element Count     ${SSO_AssocApps_tablegrid}    
    @{aLOBList}    Split String    ${sLOB}    ,
    Run Keyword If    ${Count} == 0    Log    No Data found in the Table
    ...    ELSE IF    '${SSO_GLOBAL_USERID}'!='' and '${SSO_GLOBAL_OSUSERID}'!=''    Run Keywords    Append To List    ${SSO_GLOBAL_LOB}    @{aLOBList}
    ...    AND    Validate Enquire User Page Associated Tables    ${SSO_Role_List}    ${SSO_GLOBAL_LOB}
    ...    ELSE IF    ${USER_MATCH}==True and ${LOBS_INPUT_EXIST}==False    Run Keywords    Append To List    ${SSO_GLOBAL_LOB}    ${sLOB}
    ...    AND    Validate Enquire User Page Associated Tables    ${SSO_Role_List}    ${SSO_GLOBAL_LOB}
    ...    ELSE    Validate Enquire User Page Associated Tables    ${SSO_Role_List}    ${sLOB}
    Close Browser

Validate SSO for Delete Success
    [Documentation]    This keyword is used to verify that user in SSO page for delete scenario.
    ...    @author: clanding    20DEC2018    - initial create
    ...    @update: amansuet    15AUG2019    - removed arguments for Launch SSO Page as the code has been updated and updated arguments
    ...    @update: jdelacru    07NOV2019    - added Return From Keyword If to handle if SSO is enabled/disabled
    [Arguments]    ${sLoginID}
    
    Return From Keyword If    '${SSO_ENABLED}'=='NO'
    
    Launch SSO Page
    Search User ID in Enquire User Page for Successful Delete    ${sLoginID}
    Close Browser

Validate User is Not Created in SSO
    [Documentation]    This keyword is used to verify that user in NOT CREATED in SSO Enquire User Page.
    ...    @author: jaquitan
    ...    @update: clanding    20DEC2018    - changed userID to loginId
    ...    @update: clanding    23APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...    @update: jdelacru    07NOV2019    - added Return From Keyword If to handle if SSO is enabled/disabled
    [Arguments]    ${sLoginID}
    Return From Keyword If    '${SSO_ENABLED}'=='NO'
    Launch SSO Page
    Search User ID in Enquire User Page and Validate User Does Not Exist    ${sLoginID}
    Close All Browsers

# Validate Update/Delete SSO Users for Negative
    # [Documentation]    This  keyword is used to validate existing user did not update
    # ...    @author:jaquitan
    # [Arguments]    ${APIDataSet}
    # # ...    ${SSO_GLOBAL_USERID}    ${SSO_GLOBAL_EMAIL}    ${SSO_GLOBAL_ROLE}    ${SSO_GLOBAL_COUNTRYCODE}    ${SSO_GLOBAL_LOB}
    # Launch SSO Page    &{APIDataSet}[Browser_used]    &{APIDataSet}[SSO_Server]:&{APIDataSet}[SSO_PORT]&{APIDataSet}[SSO_URL]
    # # Validate SSO Data    ${SSO_GLOBAL_USERID}    ${SSO_GLOBAL_EMAIL}    ${SSO_GLOBAL_ROLE}    ${SSO_GLOBAL_COUNTRYCODE}    ${SSO_GLOBAL_LOB}
    # Validate SSO Data
    # Close Browser

Get SSO User Values
    [Documentation]    This keyword is used to get SSO User values.
    ...    @author: jaquitan/clanding
    ...    @update: clanding    20DEC2019    - changed userID to loginId
    ...    @update: clanding    22APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...    @update: jdelacru    07NOV2019    - added Return From Keyword If to handle if SSO is enabled/disabled
    [Arguments]    ${sCentralRoles}    ${sLoginID}    ${sLOBs_from_Excel}
    
    Return From Keyword If    '${SSO_ENABLED}'=='NO'
    
    ###get roleType values from config file using the input json
    ${SSO_Role_List}    Get Role Value from Config Setup    ${sCentralRoles}

    Launch SSO Page
    Get SSO User Values in Enquire User Page    ${sLoginID}    ${SSO_Role_List}    ${sLOBs_from_Excel}
    Close Browser

Validate SSO Page for Put
    [Documentation]    This keyword is used to verify SSO page fields if correct based from the input payload or the previous values.
    ...    @author: clanding
    ...    @update: clanding    22APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...    @update: dahijara    15AUG2019    - Updated keyword name according to standards.
    ...    @update: jdelacru    07NOV2019    - added Return From Keyword If to handle if SSO is enabled/disabled
    [Arguments]    ${sCountryCode_2Code}    ${sCountryDesc}    ${sCentralUserType}    ${sFName}    ${sLName}
    ...    ${sJobTitle}    ${sOSUserID}    ${sLocale}    ${iContactNum1}    ${sEmail}    ${sLoginID}

    Return From Keyword If    '${SSO_ENABLED}'=='NO'
    
    ${SSO_UserType_Desc}    ${SSO_Language_Desc}    Get Defined Description for Other Code Values    ${sCentralUserType}

    ###Role in SSO cannot be updated.
    ${SSO_Role_List}    Set Variable    ${SSO_GLOBAL_ROLE}
    Run Keyword If    ${NOCHANGE_SSO_ROLE}==${False}    Log    Associated Roles in SSO cannot be updated. Input 'centralRoles' is different from the current value.    level=ERROR

    ###Associated Applications in SSO cannot be updated
    ${SSO_Lob_List}    Set Variable    ${SSO_GLOBAL_LOB}
    Run Keyword If    ${NOCHANGE_SSO_APP}==${False}    Log    Associated Applications in SSO cannot be updated. Input 'lineOfBusiness' is different from the current value.    level=ERROR

    Launch SSO Page
    Search User ID in Enquire User Page for Put    ${sCountryCode_2Code}    ${sLoginID}    ${sCentralUserType}
    Validate Enquire User Mandatory Fields for Put    ${sCountryCode_2Code}    ${sCountryDesc}    ${sFName}    ${sLName}    ${sJobTitle}
    Validate Enquire User Page Other Fields for Put    ${sCentralUserType}    ${sOSUserID}    ${sLocale}    ${iContactNum1}    ${sEmail}
    Validate Enquire User Page Associated Tables for Put    ${SSO_Role_List}    ${SSO_Lob_List}
    Close Browser

SSO Validation for Additional LOB
    [Documentation]    This keyword is used to verify SSO page fields if correct based from the input payload.
    ...    @author: clanding
    ...    @update: clanding    20DEC2018    - changed userID to loginId
    ...    @update: clanding    22APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sCountryCode_2Code}    ${sCountryDesc}    ${sCentralUserType}    ${sCentralRoles}    ${sLOB_from_Excel}
    ...    ${sLoginID}    ${sFName}    ${sLName}    ${sJobTitle}    ${sLocale}    ${iContactNum1}    ${sEmail}    ${sOSUserID}

    ###get description for code values
    ${SSO_UserType_Desc}    ${SSO_Language_Desc}    Get Defined Description for Other Code Values    ${sCentralUserType}

    ###get roleType values from config file using the input json
    ${SSO_Role_List}    Get Role Value from Config Setup    ${sCentralRoles}

    ## get previous LOB and add current LOB
    ${Prev_LOB}    Set Variable    ${CURR_LOB}
    ${Curr_Input_LOB}    Set Variable    ${sLOB_from_Excel}
    ${LOBlist}    Catenate    SEPARATOR=    ${Prev_LOB}    ${Curr_Input_LOB}

    Launch SSO Page
    Search User ID in Enquire User Page    ${sLoginID}    ${sCentralUserType}    ${sCountryCode_2Code}
    Validate Enquire User Page Mandatory Fields    ${sFName}    ${sLName}    ${sJobTitle}    ${sCountryCode_2Code}
    ...    ${sCountryDesc}
    Validate Enquire User Page Other Fields    ${SSO_UserType_Desc}    ${SSO_Language_Desc}    ${sLocale}    ${iContactNum1}    ${sEmail}    ${sOSUserID}
    Validate Enquire User Page Associated Tables    ${SSO_Role_List}    ${LOBlist}
    Close Browser

Validate User ID if existing in SSO
    [Documentation]    This keyword is used to verify if User ID is existing in SSO.
    ...    @author: clanding
    ...    12/20/2018 updated by clanding: changed userID to loginId
    ...    @author: xmiranda    23JUL2019    - replaced Get Matching Xpath Count to Get Element Count
    [Arguments]    ${sLoginID}

    Launch SSO Page
    ${USER_MATCH}    Search User ID only    ${sLoginID}

    ## role count from the table
    ${tableroles_count}    Get Element Count    ${SSO_AssocRoles_tablegrid}
    ${tablerole_list}    Create List
    ${Count+1}    Evaluate    ${tableroles_count}+1
    :FOR    ${INDEX}    IN RANGE    1    ${Count+1}
    \    ${AssocRoles_Table}    Get Text    ${SSO_AssocRoles_tablegrid}\[${INDEX}]${SSO_AssocRoles_tablegrid_values}
    \    Append To List    ${tablerole_list}    ${AssocRoles_Table}
    \    Exit For Loop If    ${INDEX}>${Count+1}
    ${SSO_GLOBAL_ROLE}    Set Variable    ${tablerole_list}
    Set Global Variable    ${SSO_GLOBAL_ROLE}

    ## app count from the table
    ${tableapp_count}    Get Element Count    ${SSO_AssocApps_tablegrid}
    ${tableapp_list}    Create List
    ${Count+1}    Evaluate    ${tableapp_count}+1
    :FOR    ${INDEX}    IN RANGE    1    ${Count+1}
    \    ${AssocApp_Table}    Get Text    ${SSO_AssocApps_tablegrid}\[${INDEX}]${SSO_AssocApps_tablegrid_values}
    \    Append To List    ${tableapp_list}    ${AssocApp_Table}
    \    Exit For Loop If    ${INDEX}>${Count+1}
    ${SSO_GLOBAL_LOB}    Set Variable    ${tableapp_list}
    Set Global Variable    ${SSO_GLOBAL_LOB}

    Close Browser
    [Return]    ${USER_MATCH}

# Validate User ID if NOT EXISTING in SSO
    # [Documentation]    This keyword is used to verify if User ID is NOT EXISTING in SSO.
    # ...    12/20/2018 updated by clanding: changed userID to loginId
    # ...    @author: clanding
    # [Arguments]    ${APIDataSet}

    # Launch SSO Page    &{APIDataSet}[Browser_used]    &{APIDataSet}[SSO_Server]:&{APIDataSet}[SSO_PORT]&{APIDataSet}[SSO_URL]
    # Search User ID in Enquire User Page for Negative    &{APIDataSet}[loginId]
    # Close Browser
    # [Return]    ${USER_MATCH}

# Validate Create SSO Users for Negative when UserID is NULL
    # [Documentation]    This keyword is used to verify that user in SSO page for negative scenario.
    # ...    @author: jaquitan
    # ...    12/20/2018 updated by clanding: changed userID to loginId
    # [Arguments]    ${APIDataSet}
    # Launch SSO Page    &{APIDataSet}[Browser_used]    &{APIDataSet}[SSO_Server]:&{APIDataSet}[SSO_PORT]&{APIDataSet}[SSO_URL]
    # Search User ID for NULL    &{APIDataSet}[loginId]
    # Close Browser
