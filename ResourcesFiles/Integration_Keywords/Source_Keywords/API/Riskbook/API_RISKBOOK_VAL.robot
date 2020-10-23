*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Get Riskbook API Response and Validate API Response to Riskbook LoanIQ
    [Documentation]    This keyword is used to get Riskbook API Response from output file and validate riskbook response to LoanIQ
    ...    @author: xmiranda    29AUG2019    - initial create
    ...    @update: xmiranda    09SEP2019    - added logic for user id and login id
    [Arguments]    ${sOutputFilePath}    ${sOutputFile}    ${sUserId}
    
    ${Response_Payload}    OperatingSystem.Get File    ${datasetpath}${sOutputFilePath}${sOutputFile}.${JSON}          
    ${Response_Payload}    Strip String    ${Response_Payload}    mode=left    characters=[
    ${Response_Payload}    Strip String    ${Response_Payload}    mode=right    characters=]
    
    ${Response_Payload_List}    Split String    ${Response_Payload}    },{
    
    ${JsonCount}    Get Length    ${Response_Payload_List}
    
    ${RiskBookCodeDescription_List}    Create List
    
    #Get Risk Book Description
    Refresh Tables in LIQ
    mx LoanIQ click    ${LIQ_TableMaintenance_Button}
    ${Convert_Object}    OperatingSystem.Get File    ${dataset_path}${sOutputFilePath}${sOutputFile}.json
    ${Converted_JSON}    Evaluate    json.loads('''${Convert_Object}''')    ${JSON}
    ${riskBookCode_List}    Get Value From Json    ${Converted_JSON}    $..riskBookCode
    ${riskBookCode_Count}    Get Length    ${riskBookCode_List}  
    
    :FOR    ${INDEX}    IN RANGE    ${riskBookCode_Count}
    \     ### Get JSON field values ###
    \    ${riskBookCode_val}    Get From List    ${riskBookCode_List}    ${INDEX} 
    \    Log    RiskBookCode: ${riskBookCode_val}
    \    Search in Table Maintenance    Risk Book
    \    ${RiskBook_Desc}    Get Single Description from Table Maintanance    ${riskBookCode_val}    ${LIQ_BrowseRiskBook_Window}
         ...    ${LIQ_BrowseRiskBook_JavaTree}    ${LIQ_BrowseRiskBook_ShowAll_RadioButton}    ${LIQ_BrowseRiskBook_Exit_Button}
    \    Append To List    ${RiskBookCodeDescription_List}    ${RiskBook_Desc}
    \    Log    ${INDEX}=${RiskBookCodeDescription_List}        
    
    Log    ${RiskBookCodeDescription_List}
    Refresh Tables in LIQ
    
    Search User in Loan IQ    ${sUserId}
        
    mx LoanIQ click    ${LIQ_OpenAUserProfile_UserList_OK_Button}
    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    
    :FOR    ${Index_Output}    IN RANGE    ${JsonCount}
    \    ${LastIndex}    Evaluate    ${JsonCount}-1    
    \    ${JSON_Value}    Get From List    ${Response_Payload_List}    ${Index_Output}
    \    ${IsEvenOrOdd}    Evaluate    int('${Index_Output}')%2
    \    ${Separated_JSON_Value}    Run Keyword If    ${IsEvenOrOdd}==0 and ${Index_Output}==0 and ${LastIndex}!=0    Catenate    SEPARATOR=    ${JSON_Value}    }
         ...    ELSE IF    ${IsEvenOrOdd}==0 and ${Index_Output}==0 and ${LastIndex}==0    Set Variable    ${JSON_Value}
         ...    ELSE IF    ${IsEvenOrOdd}==0 and ${Index_Output}==${LastIndex}    Catenate    SEPARATOR=    {    ${JSON_Value}
         ...    ELSE IF    ${IsEvenOrOdd}==1 and ${Index_Output}==${LastIndex}    Catenate    SEPARATOR=    {    ${JSON_Value}
         ...    ELSE    Catenate    SEPARATOR=    {    ${JSON_Value}    }
    \    Log    ${Separated_JSON_Value}
    \    
    \    Create File    ${dataset_path}${sOutputFilePath}${sOutputFile}tempfile.json    ${Separated_JSON_Value}
    \    
    \    ### Get JSON field values ###
    \    ${Convert_Object}    OperatingSystem.Get File    ${dataset_path}${sOutputFilePath}${sOutputFile}tempfile.json
    \    ${Converted_JSON}    Evaluate    json.loads('''${Convert_Object}''')    ${JSON}
    \    
    \    ${Response_UpdateTimeStamp}    Set Variable     ${Converted_JSON}[updateTimeStamp]
    \    ${Response_CreateTimeStamp}    Set Variable    ${Converted_JSON}[createTimeStamp]
    \    ${Response_CreateUserId}    Set Variable    ${Converted_JSON}[createUserId]
    \    ${Response_UpdateUserId}    Set Variable    ${Converted_JSON}[updateUserId]
    \    ${Response_RiskBookCode}    Set Variable    ${Converted_JSON}[riskBookCode]
    \    ${Response_ViewPricesIndicator}    Set Variable    ${Converted_JSON}[viewPricesIndicator]
    \    ${Response_BuySellIndicator}    Set Variable    ${Converted_JSON}[buySellIndicator]
    \    ${Response_MarkIndicator}    Set Variable    ${Converted_JSON}[markIndicator]
    \    ${Response_UserId}    Set Variable    ${Converted_JSON}[userId]
    \
    \    Mx LoanIQ Select Window Tab    ${LIQ_RiskBookAccess_Tab}    Risk Book Access
    \    Take Screenshot    LIQ_RiskBookAccess
    \    
    \    ### Risk Book Access ###
    \    
    \    ${IsSelected}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_RiskBookAccess_JavaTree}    ${RiskBookCodeDescription_List}[${Index_Output}]
    \    Run Keyword If    ${IsSelected}==${True}    Log    Risk Book Description: '${RiskBookCodeDescription_List}[${Index_Output}]' is existing in the Risk Book Access Table.
         ...    ELSE    Run Keyword And Continue On Failure    Fail    Risk Book Description: '${RiskBookCodeDescription_List}[${Index_Output}]' is not existing in the Risk Book Access Table.    level=ERROR      
    \    
    \    ### Buy/Sell Indicator ###
    \    
    \    ${BuySellIndicator}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_RiskBookAccess_JavaTree}     ${RiskBookCodeDescription_List}[${Index_Output}]%Buy/Sell%BuySellIndicator
    \    ${LIQ_BuySellIndicator}    Run Keyword If    '${BuySellIndicator}' == 'Y'    Set Variable    True
         ...    ELSE IF    '${BuySellIndicator}' == 'N'    Set Variable    False
    \
    \    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${LIQ_BuySellIndicator}    ${Response_BuySellIndicator} 
    \    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    ${LIQ_BuySellIndicator}    ${Response_BuySellIndicator} 
    \    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. ${LIQ_BuySellIndicator}=${Response_BuySellIndicator} 
         ...    ELSE    Log    Expected and Actual are NOT equal. ${LIQ_BuySellIndicator}!=${Response_BuySellIndicator}    level=ERROR
    \    
    \    ### Mark Indicator ###
    \    
    \    ${MarkIndicator}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_RiskBookAccess_JavaTree}     ${RiskBookCodeDescription_List}[${Index_Output}]%Mark%MarkIndicator
    \    ${LIQ_MarkIndicator}    Run Keyword If    '${MarkIndicator}' == 'Y'    Set Variable    True
         ...    ELSE IF    '${MarkIndicator}' == 'N'    Set Variable    False
    \
    \
    \    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${LIQ_MarkIndicator}    ${Response_MarkIndicator} 
    \    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    ${LIQ_MarkIndicator}    ${Response_MarkIndicator} 
    \    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. ${LIQ_MarkIndicator}=${Response_MarkIndicator} 
         ...    ELSE    Log    Expected and Actual are NOT equal. ${LIQ_MarkIndicator}!=${Response_MarkIndicator}    level=ERROR
    \
    \    ### View Prices Indicator ###
    \    
    \    ${ViewPricesIndicator}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_RiskBookAccess_JavaTree}     ${RiskBookCodeDescription_List}[${Index_Output}]%View Prices%ViewPricesIndicator
    \    ${LIQ_ViewPricesIndicator}    Run Keyword If    '${ViewPricesIndicator}' == 'Y'    Set Variable    True
         ...    ELSE IF    '${ViewPricesIndicator}' == 'N'    Set Variable    False
    \
    \
    \    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${LIQ_ViewPricesIndicator}    ${Response_ViewPricesIndicator} 
    \    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    ${LIQ_ViewPricesIndicator}    ${Response_ViewPricesIndicator} 
    \    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. ${LIQ_ViewPricesIndicator}=${Response_ViewPricesIndicator} 
         ...    ELSE    Log    Expected and Actual are NOT equal. ${LIQ_ViewPricesIndicator}!=${Response_ViewPricesIndicator}    level=ERROR
    \    
    \    ### Update Time Stamp ###
    \    
    \    ### Update Time Stamp Separator and Conversion ###
    \    
    \    ${UpdateTimeStampList}    Split String    ${Response_UpdateTimeStamp}    T
    \    ${DateTimeStamp}    Get Length    ${UpdateTimeStampList}
    \    ${UpdateTimeStamp_DateValue}    Get From List    ${UpdateTimeStampList}    0
    \    ${UpdateTimeStamp_TimeValue}    Get From List    ${UpdateTimeStampList}    1 
    \    Log    Update Time Stamp: '${Response_UpdateTimeStamp}'. Date is: '${UpdateTimeStamp_DateValue}' and Time is: '${UpdateTimeStamp_TimeValue}'
    \    
    \    ### Convert Date to dd-mmm-yyyy format ###    
    \    ${date}    Convert Date    ${UpdateTimeStamp_DateValue}    result_format=%d-%b-%Y
    \    ${UpdateTimeStamp_StringDate}    Convert To String    ${date}
    \    
    \    
    \    ### Events Tab ###
    \    
    \    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    \    Mx LoanIQ Select Window Tab    ${LIQ_Events_Tab}    Events
    \    Take Screenshot    LIQ_Events
    \    
    \    ### Select User Profile Riskbook Updated in Events Table  ###
    \    
    \    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_EventsTable_JavaTree}    ${UpdateTimeStamp_StringDate}\t${UpdateTimeStamp_TimeValue}\t${Response_UpdateUserId}  
    \    ${IsSelected}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_EventsTable_JavaTree}    ${UpdateTimeStamp_StringDate}\t${UpdateTimeStamp_TimeValue}\t${Response_UpdateUserId}
    \    Run Keyword If    ${IsSelected}==${True}    Log    User Profile Riskbook Updated with Date: '${UpdateTimeStamp_StringDate}', Updated Time: '${UpdateTimeStamp_TimeValue}', and '${Response_UpdateUserId}' is existing in the Events Table.
         ...    ELSE    Log    User Profile Riskbook Updated with Date: '${UpdateTimeStamp_StringDate}', Updated Time: '${UpdateTimeStamp_TimeValue}', and '${Response_UpdateUserId}' is existing in the Events Table.    level=ERROR      
    \    
    \    ### User ###
    \    
    \    ${Location_Locator}    Set Static Text to Locator Single Text    User Profile Maintenance    ${Response_UpdateUserId}
    \    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${Location_Locator}    VerificationData="Yes"
    \    ${location_stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${Location_Locator}    VerificationData="Yes"
    \    Run Keyword If    ${location_stat}==True    Log    Location is correct!! USER ID: '${Response_UpdateUserId}' is found
         ...    ELSE    Log    Location is incorrect! !USER ID: '${Response_UpdateUserId}' is not found    level=ERROR
    \    
    \    ### Date ###
    \    
    \    ${Location_Locator}    Set Static Text to Locator Single Text    User Profile Maintenance    ${UpdateTimeStamp_StringDate}
    \    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${Location_Locator}    VerificationData="Yes"
    \    ${location_stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${Location_Locator}    VerificationData="Yes"
    \    Run Keyword If    ${location_stat}==True    Log    Location is correct!! Date from Update Time Stamp: '${UpdateTimeStamp_StringDate}' is found
         ...    ELSE    Log    Location is incorrect!! Date from Update Time Stamp:: '${UpdateTimeStamp_StringDate}' is not found    level=ERROR
    \    
    \    ### Time ###
    \    
    \    ${Location_Locator}    Set Static Text to Locator Single Text    User Profile Maintenance    ${UpdateTimeStamp_TimeValue}
    \    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${Location_Locator}    VerificationData="Yes"
    \    ${location_stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${Location_Locator}    VerificationData="Yes"
    \    Run Keyword If    ${location_stat}==True    Log    Location is correct!! Time from Update Time Stamp: '${UpdateTimeStamp_TimeValue}' is found
         ...    ELSE    Log    Location is incorrect!! Time from Update Time Stamp:: '${UpdateTimeStamp_TimeValue}' is not found    level=ERROR
    \    
    \    
    
    Refresh Tables in LIQ

Validate Empty Riskbook API Response and Validate Riskbook User ID not Displayed in LoanIQ
    [Documentation]    This keyword is used to get Riskbook API Response from output file 
    ...    and validate response if empty
    ...    and validate if there is no Riskbook for user in LoanIQ
    ...    @author: xmiranda    05SEP2019    - initial create
    ...    @update: xmiranda    09SEP2019    - added logic for user id and login id
    [Arguments]    ${sOutputFilePath}    ${sOutputFile}    ${sUserID}
    
    
    ${Response_Payload}    OperatingSystem.Get File    ${datasetpath}${sOutputFilePath}${sOutputFile}.${JSON} 
    
    ### Validate if Response is Empty ###
    Run Keyword If    ${Response_Payload} == []    Log    Riskbook API Response is empty
    ...    ELSE    Log    Riskbook API contains a Response    level=ERROR
    

    Search User in Loan IQ    ${sUserID}    
    mx LoanIQ click    ${LIQ_OpenAUserProfile_UserList_OK_Button}
    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_RiskBookAccess_Tab}    Risk Book Access
    Take Screenshot    LIQ_RiskBookAccess
    
    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_RiskBookAccess_JavaTree}    items count%0
    Run Keyword If    ${status}==${True}    Log    User '${sUserID}' has no Riskbook
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Riskbook found for user '${sUserID}'    level=ERROR    
    
    Refresh Tables in LIQ
    
Get Risk Book Details to an Existing User Before Any Transaction
    [Documentation]    This keyword is used to navigate to LIQ user profile and get the risk book data before any transaction.
    ...    @author: dahijara    4SEP2019     - initial create
    ...    @author: dahijara    10JAN2020    - updated Verify Object Exist Keywork Parameters as part of UTF upgrade.
    [Arguments]    ${sInputFilePath}    ${sInputFileName}    ${sUserId}

    Refresh Tables in LIQ
    #Navigate To User Maintenance Page
    Select Actions    [Actions];User Profile
    mx LoanIQ activate window    ${LIQ_OpenAUserProfile_Window}
    Mx LoanIQ Set    ${LIQ_OpenAUserProfile_Inactive_Checkbox}    ON
    mx LoanIQ select    ${LIQ_OpenAUserProfile_IdentifyUserBy_List}    User ID
    mx LoanIQ enter    ${LIQ_OpenAUserProfile_IdentifyUserBy_Textfield}    ${sUserId}
    mx LoanIQ click    ${LIQ_OpenAUserProfile_Search_Button}

    ###check for error message
    ${Err_exist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_OpenAUserProfile_Error_Dialog}    VerificationData="Yes"    Processtimeout=100
    Run Keyword If    ${Err_exist}==${True}    Run Keywords    mx LoanIQ click    ${LIQ_Error_OK_Button}
    ...    AND    Fail    User does not exists.
    
    mx LoanIQ activate window    ${LIQ_OpenAUserProfile_UserList_Window}
	Take Screenshot    LIQ_SearchUser
    ${UserList_exist}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_OpenAUserProfile_UserList_Tree}    ${sUserId}    60
    Run Keyword If    ${UserList_exist}==${False}    Fail    User '${sUserId}' does not exist!!
    ...    ELSE    Log    User '${sUserId}' exists.
    mx LoanIQ click    ${LIQ_OpenAUserProfile_UserList_OK_Button}    

    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    mx LoanIQ click    ${LIQ_UserProfileMaint_InqMode_Button}
    
    Take Screenshot    LIQ_UserProfile    
    ${input_userid}    Convert To Uppercase    ${sUserId}
    ${UserID_Locator}    Set Static Text to Locator Single Text    User Profile Maintenance    ${input_userid}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${UserID_Locator}    VerificationData="Yes"
    ${userid_stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${UserID_Locator}    VerificationData="Yes"
    Run Keyword If    ${userid_stat}==${True}    Log    User ID is correct!!
    ...    ELSE    Log    User ID is incorrect!!    level=ERROR

    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_UserProfileMaint_Tab}    Risk Book Access
    Take Screenshot    LIQ_UserProfile_RiskBookAccess
    Get Risk Book List From User Profile    ${sInputFilePath}    ${sInputFileName}

Get Risk Book List From User Profile
    [Documentation]    This keyword is used to get risk book details in user profile risk book access tab
    ...    This returns JSON for the risk book list and also sets the JSON output globally
    ...    @author: dahijara    4SEP2019     - initial create
    ...    @author: dahijara    10JAN2020    - added logs to display riskbook collections
    [Arguments]    ${sFilePath}    ${sFileName}
    
    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    ${RiskBookCollection}    Mx LoanIQ Store Java Tree Items To Array    ${LIQ_RiskBookAccess_JavaTree}    RiskBookCollection
    ${RiskBookCollection}    Split To Lines    ${RiskBookCollection}
    ${RB_Count}    Get Length    ${RiskBookCollection}
    Log    ${RiskBookCollection}
    
    ${RiskBook_List}    Create List    
    ${RiskBook_Dict}    Create Dictionary    
    :FOR    ${Index_1}    IN RANGE    1    ${RB_Count}
    \    Exit For Loop If    ${Index_1}==${RB_Count}
    \    ${valRiskBook}    Replace String    ${RiskBookCollection}[${Index_1}]    \r    ${Empty}
    \    ${valRiskBook}    Strip String    ${valRiskBook}    left    ,
    \    Log    ${Index_1}:${RiskBookCollection}[${Index_1}]
    \    ${RiskBookDetails}    Split String    ${valRiskBook}    \t
    \    ${RiskBook_Dict}    Create Dictionary    
    \    Set To Dictionary    ${RiskBook_Dict}    riskBookDescription=${RiskBookDetails}[0]
    \    Set To Dictionary    ${RiskBook_Dict}    buySellIndicator=${RiskBookDetails}[1]
    \    Set To Dictionary    ${RiskBook_Dict}    markIndicator=${RiskBookDetails}[2]
    \    Set To Dictionary    ${RiskBook_Dict}    viewPricesIndicator=${RiskBookDetails}[3]
    \    Append To List    ${RiskBook_List}    ${RiskBook_Dict}

    ${RiskBook_JSON}    Evaluate    json.dumps(${RiskBook_List})    json
    Log    ${RiskBook_JSON}
    ${JSON_File}    Set Variable    ${sFilePath}${sFileName}.json
    Delete File If Exist    ${dataset_path}${JSON_File}
    Create File    ${dataset_path}${JSON_File}    ${RiskBook_JSON}
    ${file}    OperatingSystem.Get File    ${dataset_path}${JSON_File}    
    ${GLOBAL_LIQ_USERRISKBOOK_JSON}    Set Variable    ${RiskBook_JSON}
    Set Global Variable    ${GLOBAL_LIQ_USERRISKBOOK_JSON}
    [Return]    ${RiskBook_JSON}

Update LIQ Risk Book Data for Comparison
    [Documentation]    This keyword is used to get input and actual Risk Book data and compare them.
    ...    @author: dahijara    4SEP2019    - initial create
    [Arguments]    ${sFilePath}    ${sFileName}
    
    ${LIQ_JSON}    Load JSON From File    ${dataset_path}${sFilePath}${sFileName}.json
    ${LIQ_JSON_Count}    Get Length    ${LIQ_JSON}
    Refresh Tables in LIQ
    mx LoanIQ click    ${LIQ_TableMaintenance_Button}
    
    :FOR    ${index}    IN RANGE    ${LIQ_JSON_Count}
    \    Exit For Loop If    ${index}==${LIQ_JSON_Count}
    \    ${val_RiskBookDesc}    Get From Dictionary    ${LIQ_JSON}[${index}]    riskBookDescription
    \    
    \    #Get Risk Book Description
    \    Search in Table Maintenance    Risk Book
    \    ${val_RiskBookCode}    Get Code from Table Maintenance for Single Value    ${val_RiskBookDesc}    ${LIQ_BrowseRiskBook_Window}
         ...    ${LIQ_BrowseRiskBook_JavaTree}    ${LIQ_BrowseRiskBook_ShowAll_RadioButton}    ${LIQ_BrowseRiskBook_Exit_Button}
    \    
    \    Set To Dictionary    ${LIQ_JSON}[${index}]    riskBookCode=${val_RiskBookCode}
    \    Remove From Dictionary    ${LIQ_JSON}[${index}]    riskBookDescription
    \    
    \    ${val_viewPricesIndicator}    Get From Dictionary    ${LIQ_JSON}[${index}]    viewPricesIndicator
    \    Run Keyword If    '${val_viewPricesIndicator}'=='Y'    Set To Dictionary    ${LIQ_JSON}[${index}]    viewPricesIndicator=${${True}}
         ...    ELSE    Set To Dictionary    ${LIQ_JSON}[${index}]    viewPricesIndicator=${${False}}
    \    
    \    ${val_markIndicator}    Get From Dictionary    ${LIQ_JSON}[${index}]    markIndicator
    \    Run Keyword If    '${val_markIndicator}'=='Y'    Set To Dictionary    ${LIQ_JSON}[${index}]    markIndicator=${${True}}
         ...    ELSE    Set To Dictionary    ${LIQ_JSON}[${index}]    markIndicator=${${False}}
    \    
    \    ${val_buySellIndicator}    Get From Dictionary    ${LIQ_JSON}[${index}]    buySellIndicator
    \    Run Keyword If    '${val_buySellIndicator}'=='Y'    Set To Dictionary    ${LIQ_JSON}[${index}]    buySellIndicator=${${True}}
         ...    ELSE    Set To Dictionary    ${LIQ_JSON}[${index}]    buySellIndicator=${${False}}
    \      
    \    ${RiskBookSingle_JSON}    Evaluate    json.dumps(${LIQ_JSON}[${index}])    json
    \    Log    ${RiskBookSingle_JSON}
    \    ${JSON_File}    Set Variable    ${sFilePath}${sFileName}_${val_RiskBookCode}.json
    \    Delete File If Exist    ${dataset_path}${JSON_File}
    \    Create File    ${dataset_path}${JSON_File}    ${RiskBookSingle_JSON}
    \    ${file}    OperatingSystem.Get File    ${dataset_path}${JSON_File} 

    ${RiskBook_JSON}    Evaluate    json.dumps(${LIQ_JSON})    json
    Log    ${RiskBook_JSON}
    ${JSON_File}    Set Variable    ${sFilePath}${sFileName}.json
    Delete File If Exist    ${dataset_path}${JSON_File}
    Create File    ${dataset_path}${JSON_File}    ${RiskBook_JSON}
    ${file}    OperatingSystem.Get File    ${dataset_path}${JSON_File}  
       
Compare Input and Actual Risk Book Data for LIQ
    [Documentation]    This keyword is used to get input and actual Risk Book data and compare them.
    ...    @author: dahijara    4SEP2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sInputFileName}    ${sOutputFilePath}    ${sOutputFileName}
    
    
    ${Input_JSON}    Load JSON From File    ${dataset_path}${sInputFilePath}${sInputFileName}.json
    ${LIQ_JSON}    Load JSON From File    ${dataset_path}${sOutputFilePath}${sOutputFileName}.json
    ${LIQJSON_Count}    Get Length    ${LIQ_JSON}
    ${InputJSON_Count}    Get Length    ${Input_JSON}

    :FOR    ${index}    IN RANGE    ${InputJSON_Count}
    \    Exit For Loop If    ${index}==${InputJSON_Count}
    \    ${val_riskBookCode}    Get From Dictionary    ${Input_JSON}[${index}]    riskBookCode
    \    ${InputSingleJSON}    OperatingSystem.Get File    ${dataset_path}${sInputFilePath}${sInputFileName}_${val_riskBookCode}.json
    \    ${InputSingleJSON}    evaluate    json.loads('''${InputSingleJSON}''')    ${JSON}
    \    Delete Object From Json    ${InputSingleJSON}    primaryIndicator
    \    ${InputSingleJSON}    evaluate    json.dumps(${InputSingleJSON})    json
    \    ${FileStatus}    Run Keyword And Return Status    OperatingSystem.File Should Exist    ${dataset_path}${sOutputFilePath}${sOutputFileName}_${val_riskBookCode}.json    
    \    Run Keyword If    ${FileStatus}==${False}    Run Keywords    Log    (Before Request)Risk Book:${val_riskBookCode} does not exist in LIQ User    level=WARN
         ...    AND    Continue For Loop
    \    ${LIQSingleJSON}    OperatingSystem.Get File    ${dataset_path}${sOutputFilePath}${sOutputFileName}_${val_riskBookCode}.json
    \    ${IsMatched}    Run Keyword And Return Status    Mx Compare Json Data    ${InputSingleJSON}    ${LIQSingleJSON}
    \    Run Keyword If    ${IsMatched}==${True}    Log    Input values and current values are equal and have no changes. ${InputSingleJSON} == ${LIQSingleJSON}    level=WARN
         ...    ELSE    Log    Input values and current values have differences. ${InputSingleJSON} != ${LIQSingleJSON}    level=WARN    
 
Validate Risk Book Details to an Existing User in LoanIQ for PUT
    [Documentation]    This keyword is used to navigate to LIQ user profile and validate the risk book data after PUT request.
    ...    @author: dahijara    4SEP2019    - initial create
    ...    @update: jdelacru    10JAN2020    - Corrected number of arguments for Err_Exist
    [Arguments]    ${sUserId}    ${sRiskBookCode}    ${sBuySellIndicator}    ${sMarkIndicator}    ${sViewPricesIndicator}    ${sUpdateUserId}
    
    ${RiskBookCode_List}    Split String    ${sRiskBookCode}    ,
    ${BuySellIndicator_List}    Split String    ${sBuySellIndicator}    ,
    ${MarkIndicator_List}    Split String    ${sMarkIndicator}    ,
    ${ViewPricesIndicator_List}    Split String    ${sViewPricesIndicator}    ,
    ${RiskBookDesc_List}    Create List    
    ${RiskBookCount}    Get Length    ${RiskBookCode_List}
    
    #Get Risk Book Description
    Refresh Tables in LIQ
    mx LoanIQ click    ${LIQ_TableMaintenance_Button}
    :FOR    ${index}    IN RANGE    ${RiskBookCount}
    \    Exit For Loop If    ${index}==${RiskBookCount}
    \    Search in Table Maintenance    Risk Book
    \    ${RiskBook_Desc}    Get Single Description from Table Maintanance    @{RiskBookCode_List}[${index}]    ${LIQ_BrowseRiskBook_Window}
         ...    ${LIQ_BrowseRiskBook_JavaTree}    ${LIQ_BrowseRiskBook_ShowAll_RadioButton}    ${LIQ_BrowseRiskBook_Exit_Button}
    \    Append To List    ${RiskBookDesc_List}    ${RiskBook_Desc}

    #Navigate To User Maintenance Page
    Select Actions    [Actions];User Profile
    mx LoanIQ activate window    ${LIQ_OpenAUserProfile_Window}
    Mx LoanIQ Set    ${LIQ_OpenAUserProfile_Inactive_Checkbox}    ON
    mx LoanIQ select    ${LIQ_OpenAUserProfile_IdentifyUserBy_List}    User ID
    mx LoanIQ enter    ${LIQ_OpenAUserProfile_IdentifyUserBy_Textfield}    ${sUserId}
    mx LoanIQ click    ${LIQ_OpenAUserProfile_Search_Button}

    ###check for error message
    ${Err_exist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_OpenAUserProfile_Error_Dialog}    VerificationData="Yes"    Processtimeout=100
    Run Keyword If    ${Err_exist}==${True}    Run Keywords    mx LoanIQ click    ${LIQ_Error_OK_Button}
    ...    AND    Fail    User does not exists.
    
    mx LoanIQ activate window    ${LIQ_OpenAUserProfile_UserList_Window}
	Take Screenshot    LIQ_SearchUser
    ${UserList_exist}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_OpenAUserProfile_UserList_Tree}    ${sUserId}    60
    Run Keyword If    ${UserList_exist}==${False}    Fail    User '${sUserId}' does not exist!!
    ...    ELSE    Log    User '${sUserId}' exists.
    mx LoanIQ click    ${LIQ_OpenAUserProfile_UserList_OK_Button}    

    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    mx LoanIQ click    ${LIQ_UserProfileMaint_InqMode_Button}
    
    Take Screenshot    LIQ_UserProfile    
    ${input_userid}    Convert To Uppercase    ${sUserId}
    ${UserID_Locator}    Set Static Text to Locator Single Text    User Profile Maintenance    ${input_userid}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${UserID_Locator}    VerificationData="Yes"
    ${userid_stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${UserID_Locator}    VerificationData="Yes"
    Run Keyword If    ${userid_stat}==${True}    Log    User ID is correct!!
    ...    ELSE    Log    User ID is incorrect!!    level=ERROR

    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_UserProfileMaint_Tab}    Risk Book Access

    :FOR    ${index}    IN RANGE    ${RiskBookCount}
    \    Exit For Loop If    ${index}==${RiskBookCount}
    \    ${IsSelected}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_RiskBookAccess_JavaTree}    @{RiskBookDesc_List}[${index}]
    \    Run Keyword If    ${IsSelected}==${True}    Log    Risk Book Description: '@{RiskBookDesc_List}[${index}]' is existing in the Risk Book Access Table.
         ...    ELSE    Log    Risk Book Description: '@{RiskBookDesc_List}[${index}]' is not existing in the Risk Book Access Table.    level=ERROR
    \    
    \    ${BuySellIndicator}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_RiskBookAccess_JavaTree}    @{RiskBookDesc_List}[${index}]%Buy/Sell%BuySellIndicator
    \    ${LIQ_BuySellIndicator}    Run Keyword If    '${BuySellIndicator}' == 'Y'    Set Variable    true
         ...    ELSE IF    '${BuySellIndicator}' == 'N'    Set Variable    false
    \
    \    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${LIQ_BuySellIndicator}    ${BuySellIndicator_List}[${index}]
    \    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    ${LIQ_BuySellIndicator}    ${BuySellIndicator_List}[${index}]
    \    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. ${LIQ_BuySellIndicator}=${BuySellIndicator_List}[${index}]
         ...    ELSE    Log    Expected and Actual are NOT equal. ${LIQ_BuySellIndicator}!=${BuySellIndicator_List}[${index}]    level=ERROR
    \    
    \    ${MarkIndicator}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_RiskBookAccess_JavaTree}    @{RiskBookDesc_List}[${index}]%Mark%MarkIndicator
    \    ${LIQ_MarkIndicator}    Run Keyword If    '${MarkIndicator}' == 'Y'    Set Variable    true
         ...    ELSE IF    '${MarkIndicator}' == 'N'    Set Variable    false
    \
    \
    \    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${LIQ_MarkIndicator}    ${MarkIndicator_List}[${index}]
    \    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    ${LIQ_MarkIndicator}    ${MarkIndicator_List}[${index}]
    \    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. ${LIQ_MarkIndicator}=${MarkIndicator_List}[${index}]
         ...    ELSE    Log    Expected and Actual are NOT equal. ${LIQ_MarkIndicator}!=${MarkIndicator_List}[${index}]    level=ERROR
    \    
    \    ${ViewPricesIndicator}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_RiskBookAccess_JavaTree}    @{RiskBookDesc_List}[${index}]%View Prices%ViewPricesIndicator
    \    ${LIQ_ViewPricesIndicator}    Run Keyword If    '${ViewPricesIndicator}' == 'Y'    Set Variable    true
         ...    ELSE IF    '${ViewPricesIndicator}' == 'N'    Set Variable    false
    \
    \
    \    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${LIQ_ViewPricesIndicator}    ${ViewPricesIndicator_List}[${index}]
    \    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    ${LIQ_ViewPricesIndicator}    ${ViewPricesIndicator_List}[${index}]
    \    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. ${LIQ_ViewPricesIndicator}=${ViewPricesIndicator_List}[${index}]
         ...    ELSE    Log    Expected and Actual are NOT equal. ${LIQ_ViewPricesIndicator}!=${ViewPricesIndicator_List}[${index}]    level=ERROR
    
    Take Screenshot    LIQ_UserProfile_RiskBookAccess
    Mx LoanIQ Select Window Tab    ${LIQ_UserProfileMaint_Tab}    Events
    
    
    ### Update Time Stamp ###
    ### Update Time Stamp Separator and Conversion ###
    ${OutputJSON}    evaluate    json.loads('''${RESPONSE_FILE}''')    ${JSON}
    ${Response_TimeStamp}    Get From Dictionary    ${OutputJSON}[0]    updateTimeStamp
    ${ResponseDateTimeStampList}    Split String    ${Response_TimeStamp}    T
    ${DateTimeStampList}    Split String    ${PUTREQUEST_TIMESTAMP}    T
    ${UpdateTimeStamp_DateValue}    Get From List    ${DateTimeStampList}    0
    ${UpdateTimeStamp_TimeValue}    Get From List    ${ResponseDateTimeStampList}    1
    
    ### Convert Date to dd-mmm-yyyy format ###    
    ${date}    Convert Date    ${UpdateTimeStamp_DateValue}    result_format=%d-%b-%Y
    ${UpdateTimeStamp_StringDate}    Convert To String    ${date}    
    
    ### Select User Profile Riskbook Updated in Events Table  ###

    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_EventsTable_JavaTree}    ${UpdateTimeStamp_StringDate}\t${UpdateTimeStamp_TimeValue}\t${sUpdateUserId}  
    ${IsSelected}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_EventsTable_JavaTree}    ${UpdateTimeStamp_StringDate}\t${UpdateTimeStamp_TimeValue}\t${sUpdateUserId}
    Run Keyword If    ${IsSelected}==${True}    Log    User Profile Riskbook Updated with Date: '${UpdateTimeStamp_StringDate}', Updated Time: '${UpdateTimeStamp_TimeValue}', and '${sUpdateUserId}' is existing in the Events Table.
    ...    ELSE    Log    User Profile Riskbook Updated with Date: '${UpdateTimeStamp_StringDate}', Updated Time: '${UpdateTimeStamp_TimeValue}', and '${sUpdateUserId}' is existing in the Events Table.    level=ERROR      
    
    ### User ###
    
    ${Location_Locator}    Set Static Text to Locator Single Text    User Profile Maintenance    ${sUpdateUserId}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${Location_Locator}    VerificationData="Yes"
    ${location_stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${Location_Locator}    VerificationData="Yes"
    Run Keyword If    ${location_stat}==True    Log    Location is correct!! USER ID: '${sUpdateUserId}' is found
    ...    ELSE    Log    Location is incorrect! !USER ID: '${sUpdateUserId}' is not found    level=ERROR
    
    ### Date ###
    
    ${Location_Locator}    Set Static Text to Locator Single Text    User Profile Maintenance    ${UpdateTimeStamp_StringDate}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${Location_Locator}    VerificationData="Yes"
    ${location_stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${Location_Locator}    VerificationData="Yes"
    Run Keyword If    ${location_stat}==True    Log    Location is correct!! Date from Update Time Stamp: '${UpdateTimeStamp_StringDate}' is found
    ...    ELSE    Log    Location is incorrect!! Date from Update Time Stamp:: '${UpdateTimeStamp_StringDate}' is not found    level=ERROR
    
    ### Time ###
    
    ${Location_Locator}    Set Static Text to Locator Single Text    User Profile Maintenance    ${UpdateTimeStamp_TimeValue}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${Location_Locator}    VerificationData="Yes"
    ${location_stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${Location_Locator}    VerificationData="Yes"
    Run Keyword If    ${location_stat}==True    Log    Location is correct!! Time from Update Time Stamp: '${UpdateTimeStamp_TimeValue}' is found
    ...    ELSE    Log    Location is incorrect!! Time from Update Time Stamp:: '${UpdateTimeStamp_TimeValue}' is not found    level=ERROR
    
    Take Screenshot    LIQ_UserProfile_Events
    Refresh Tables in LIQ    

Update Details for Single Risk Book
    [Documentation]    This keyword is used to update risk book detail in LIQ User Profile risk book access tab.
    ...    @author: dahijara    2SEP2019    - initial create
    [Arguments]    ${sJavaTreeLocator}    ${sRiskBook_Desc}    ${sColHeader}    ${sValue}
    ${sValue}    Convert To Uppercase    ${sValue}
    Mx LoanIQ Click Javatree Cell    ${sJavaTreeLocator}    ${sRiskBook_Desc}%${sColHeader}
    # Mx Wait    1
    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    Mx LoanIQ Select JavaTreeCell To Enter With RowNumber    ${sJavaTreeLocator}    ${sRiskBook_Desc}%${sColHeader}
    Run Keyword If    '${sValue}'=='YES'    mx LoanIQ enter    ${LIQ_RiskBookAccess_Yes_RadioButton}    ON
    ...    ELSE IF    '${sValue}'=='NO'    mx LoanIQ enter    ${LIQ_RiskBookAccess_No_RadioButton}    ON

Update Risk Book to Existing User in LoanIQ
    [Documentation]    This keyword is used to navigate LIQ to update risk book for user.
    ...    @author: dahijara    2SEP2019    - initial create
    ...    @update: xmiranda    16SEP2019    - added Refresh Tables in LIQ keyword
    ...    @update: jdelacru    10JAN2020    - Corrected number of arguments for Err_Exist
    [Arguments]    ${sUserId}    ${sRiskBookCode}

    ${RiskBookCode_List}    Split String    ${sRiskBookCode}    ,
    ${RiskBookDesc_List}    Create List    
    ${RiskBookCount}    Get Length    ${RiskBookCode_List}
    
    #Get Risk Book Description
    Refresh Tables in LIQ
    mx LoanIQ click    ${LIQ_TableMaintenance_Button}
    :FOR    ${index}    IN RANGE    ${RiskBookCount}
    \    Exit For Loop If    ${index}==${RiskBookCount}
    \    Search in Table Maintenance    Risk Book
    \    ${RiskBook_Desc}    Get Single Description from Table Maintanance    @{RiskBookCode_List}[${index}]    ${LIQ_BrowseRiskBook_Window}
         ...    ${LIQ_BrowseRiskBook_JavaTree}    ${LIQ_BrowseRiskBook_ShowAll_RadioButton}    ${LIQ_BrowseRiskBook_Exit_Button}
    \    Append To List    ${RiskBookDesc_List}    ${RiskBook_Desc}

    #Navigate To User Maintenance Page
    Select Actions    [Actions];User Profile
    mx LoanIQ activate window    ${LIQ_OpenAUserProfile_Window}
    Mx LoanIQ Set    ${LIQ_OpenAUserProfile_Inactive_Checkbox}    ON
    mx LoanIQ select    ${LIQ_OpenAUserProfile_IdentifyUserBy_List}    User ID
    mx LoanIQ enter    ${LIQ_OpenAUserProfile_IdentifyUserBy_Textfield}    ${sUserId}
    mx LoanIQ click    ${LIQ_OpenAUserProfile_Search_Button}

    ###check for error message
    ${Err_exist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_OpenAUserProfile_Error_Dialog}    VerificationData="Yes"    Processtimeout=100 
    Run Keyword If    ${Err_exist}==${True}    Run Keywords    mx LoanIQ click    ${LIQ_Error_OK_Button}
    ...    AND    Fail    User does not exists.
    
    mx LoanIQ activate window    ${LIQ_OpenAUserProfile_UserList_Window}
	Take Screenshot    LIQ_SearchUser
    ${UserList_exist}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_OpenAUserProfile_UserList_Tree}    ${sUserId}    60
    Run Keyword If    ${UserList_exist}==${False}    Fail    User '${sUserId}' does not exist!!
    ...    ELSE    Log    User '${sUserId}' exists.
    mx LoanIQ click    ${LIQ_OpenAUserProfile_UserList_OK_Button}    

    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    mx LoanIQ click    ${LIQ_UserProfileMaint_InqMode_Button}
    
    Take Screenshot    LIQ_UserProfile    
    ${input_userid}    Convert To Uppercase    ${sUserId}
    ${UserID_Locator}    Set Static Text to Locator Single Text    User Profile Maintenance    ${input_userid}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${UserID_Locator}    VerificationData="Yes"
    ${userid_stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${UserID_Locator}    VerificationData="Yes"
    Run Keyword If    ${userid_stat}==${True}    Log    User ID is correct!!
    ...    ELSE    Log    User ID is incorrect!!    level=ERROR

    #Validate Risk Book
    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_UserProfileMaint_Tab}    Risk Book Access
    Take Screenshot    LIQ_UserProfile_RiskBookAccess
    mx LoanIQ click    ${LIQ_RiskBookAccess_Button}
    mx LoanIQ activate window    ${LIQ_RiskBookSelection_Window}

    :FOR    ${index}    IN RANGE    ${RiskBookCount}
    \    Exit For Loop If    ${index}==${RiskBookCount}    
    \    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_RiskBookSelection_Tree}    ${RiskBookCode_List}[${index}]%s
    \    Mx Native Type    {SPACE}
    
    mx LoanIQ click    ${LIQ_RiskBookSelection_Ok_Button}

    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    Take Screenshot    LIQ_UserProfile_RiskBookAccess_AddedRiskBook
    
    :FOR    ${index}    IN RANGE    ${RiskBookCount}
    \    Exit For Loop If    ${index}==${RiskBookCount}
    \    ${IsSelected}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_RiskBookAccess_JavaTree}    @{RiskBookDesc_List}[${index}]
    \    Run Keyword If    ${IsSelected}==${True}    Log    Risk Book Description: '@{RiskBookDesc_List}[${index}]' is successfuly added in the Risk Book Access Table.
         ...    ELSE    Run Keyword And Continue On Failure    Fail    Risk Book Description: '@{RiskBookDesc_List}[${index}]' is NOT added in the Risk Book Access Table.
    
    mx LoanIQ select    ${LIQ_User_Profile_Maintenance_File_Save}
    Refresh Tables in LIQ
    
Validate Non-Existing Risk Book Code in Risk Book Collection
    [Documentation]    This keyword is used to navigate to LIQ user profile and validate the risk book data after DELETE request.
    ...    @author: xmiranda    10SEP2019    - initial create
    ...    @update: jdelacru    10JAN2020    - Corrected number of arguments for Err_Exist
    ...    @update: cfrancis    30JUN2020    - added Mx LoanIQ Set Window in order to revert focus back to LIQ window instead of Javatree before Last Refresh Table
    ...    @update: cfrancis    03JUL2020    - removed Mx LoanIQ Set Window and instead modified to use Mx LoanIQ Select Or DoubleClick In Javatree instead of Mx LoanIQ Select String
    ...    which was causing the previous error
    [Arguments]    ${sRiskBookCode}    ${sUserId}=None    ${sLoginId}=None    
    
    ${RiskBookCode_List}    Split String    ${sRiskBookCode}    ,
    ${RiskBookDesc_List}    Create List    
    ${RiskBookCount}    Get Length    ${RiskBookCode_List}
    
    #Get Risk Book Description
    Refresh Tables in LIQ
    mx LoanIQ click    ${LIQ_TableMaintenance_Button}
    :FOR    ${index}    IN RANGE    ${RiskBookCount}
    \    Exit For Loop If    ${index}==${RiskBookCount}
    \    Search in Table Maintenance    Risk Book
    \    ${RiskBook_Desc}    Get Single Description from Table Maintanance    @{RiskBookCode_List}[${index}]    ${LIQ_BrowseRiskBook_Window}
         ...    ${LIQ_BrowseRiskBook_JavaTree}    ${LIQ_BrowseRiskBook_ShowAll_RadioButton}    ${LIQ_BrowseRiskBook_Exit_Button}
    \    Append To List    ${RiskBookDesc_List}    ${RiskBook_Desc}
    
    Refresh Tables in LIQ
    
    #Navigate To User Maintenance Page
    Select Actions    [Actions];User Profile
    mx LoanIQ activate window    ${LIQ_OpenAUserProfile_Window}
    mx LoanIQ Set    ${LIQ_OpenAUserProfile_Inactive_Checkbox}    ON
    mx LoanIQ select    ${LIQ_OpenAUserProfile_IdentifyUserBy_List}    User ID
    
    ${ID}    Run Keyword If    '${sUserId}'!='None' and '${sLoginId}'=='None'    Set Variable    ${sUserId}    
    ...    ELSE IF    '${sUserId}'=='None' and '${sLoginId}'!='None'    Set Variable    ${sLoginId}     
    
    mx LoanIQ enter    ${LIQ_OpenAUserProfile_IdentifyUserBy_Textfield}    ${ID}
    mx LoanIQ click    ${LIQ_OpenAUserProfile_Search_Button}
    
    ###check for error message
    ${Err_exist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_OpenAUserProfile_Error_Dialog}    VerificationData="Yes"    Processtimeout=100
    Run Keyword If    ${Err_exist}==${True}    Run Keywords    mx LoanIQ click    ${LIQ_Error_OK_Button}
    ...    AND    Fail    User does not exists.
    
    mx LoanIQ activate window    ${LIQ_OpenAUserProfile_UserList_Window}
	Take Screenshot    LIQ_SearchUser
    ${UserList_exist}    Run Keyword And Return Status    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_OpenAUserProfile_UserList_Tree}    ${ID}%s
    # ${UserList_exist}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_OpenAUserProfile_UserList_Tree}    ${ID}    60
    
    Run Keyword If    ${UserList_exist}==${False}    Fail    User '${ID}' does not exist!!
    ...    ELSE    Log    User '${ID}' exists.
    mx LoanIQ click    ${LIQ_OpenAUserProfile_UserList_OK_Button}    

    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    mx LoanIQ click    ${LIQ_UserProfileMaint_InqMode_Button}
    
    Take Screenshot    LIQ_UserProfile    
    ${input_userid}    Convert To Uppercase    ${ID}
    ${UserID_Locator}    Set Static Text to Locator Single Text    User Profile Maintenance    ${input_userid}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${UserID_Locator}    VerificationData="Yes"
    ${userid_stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${UserID_Locator}    VerificationData="Yes"
    Run Keyword If    ${userid_stat}==${True}    Log    User ID is correct!!
    ...    ELSE    Log    User ID is incorrect!!    level=ERROR

    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_UserProfileMaint_Tab}    Risk Book Access
    Take Screenshot    LIQ_UserProfile_RiskBookAccess

    :FOR    ${index}    IN RANGE    ${RiskBookCount}
    \        
    \    Exit For Loop If    ${index}==${RiskBookCount}
    \    # ${IsSelected}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_RiskBookAccess_JavaTree}    @{RiskBookDesc_List}[${index}]    5 
    \    ${IsSelected}    Run Keyword And Return Status    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_RiskBookAccess_JavaTree}    @{RiskBookDesc_List}[${index}]
    \    Run Keyword If    ${IsSelected}==${False}    Log    Risk Book Description: '@{RiskBookDesc_List}[${index}]' is not existing in the Risk Book Access Table.
         ...    ELSE    Log    Risk Book Description: '@{RiskBookDesc_List}[${index}]' is existing in the Risk Book Access Table.    level=ERROR
    \    
    Refresh Tables in LIQ

Validate Risk Book Details to an Existing User in LoanIQ for Delete
    [Documentation]    This keyword is used to navigate to LIQ user profile and validate the risk book data after Delete request.
    ...    @author: dahijara    10SEP2019    - initial create
    ...    @update: jdelacru    10JAN2020    - Corrected number of arguments for Err_Exist
    [Arguments]    ${sUserId}    ${sRiskBookCode}
    
    ${RiskBookCode_List}    Split String    ${sRiskBookCode}    ,
    ${RiskBookDesc_List}    Create List    
    ${RiskBookCount}    Get Length    ${RiskBookCode_List}
    
    #Get Risk Book Description
    Refresh Tables in LIQ
    mx LoanIQ click    ${LIQ_TableMaintenance_Button}
    :FOR    ${index}    IN RANGE    ${RiskBookCount}
    \    Exit For Loop If    ${index}==${RiskBookCount}
    \    Search in Table Maintenance    Risk Book
    \    ${RiskBook_Desc}    Get Single Description from Table Maintanance    @{RiskBookCode_List}[${index}]    ${LIQ_BrowseRiskBook_Window}
         ...    ${LIQ_BrowseRiskBook_JavaTree}    ${LIQ_BrowseRiskBook_ShowAll_RadioButton}    ${LIQ_BrowseRiskBook_Exit_Button}
    \    Append To List    ${RiskBookDesc_List}    ${RiskBook_Desc}

    #Navigate To User Maintenance Page
    Select Actions    [Actions];User Profile
    mx LoanIQ activate window    ${LIQ_OpenAUserProfile_Window}
    Mx LoanIQ Set    ${LIQ_OpenAUserProfile_Inactive_Checkbox}    ON
    mx LoanIQ select    ${LIQ_OpenAUserProfile_IdentifyUserBy_List}    User ID
    mx LoanIQ enter    ${LIQ_OpenAUserProfile_IdentifyUserBy_Textfield}    ${sUserId}
    mx LoanIQ click    ${LIQ_OpenAUserProfile_Search_Button}

    ###check for error message
    ${Err_exist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_OpenAUserProfile_Error_Dialog}    VerificationData="Yes"    Processtimeout=100
    Run Keyword If    ${Err_exist}==${True}    Run Keywords    mx LoanIQ click    ${LIQ_Error_OK_Button}
    ...    AND    Fail    User does not exists.
    
    mx LoanIQ activate window    ${LIQ_OpenAUserProfile_UserList_Window}
	Take Screenshot    LIQ_SearchUser
    ${UserList_exist}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_OpenAUserProfile_UserList_Tree}    ${sUserId}    60
    Run Keyword If    ${UserList_exist}==${False}    Fail    User '${sUserId}' does not exist!!
    ...    ELSE    Log    User '${sUserId}' exists.
    mx LoanIQ click    ${LIQ_OpenAUserProfile_UserList_OK_Button}    

    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    mx LoanIQ click    ${LIQ_UserProfileMaint_InqMode_Button}
    
    Take Screenshot    LIQ_UserProfile    
    ${input_userid}    Convert To Uppercase    ${sUserId}
    ${UserID_Locator}    Set Static Text to Locator Single Text    User Profile Maintenance    ${input_userid}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${UserID_Locator}    VerificationData="Yes"
    ${userid_stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${UserID_Locator}    VerificationData="Yes"
    Run Keyword If    ${userid_stat}==${True}    Log    User ID is correct!!
    ...    ELSE    Log    User ID is incorrect!!    level=ERROR

    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_UserProfileMaint_Tab}    Risk Book Access
    Take Screenshot    LIQ_UserProfile_RiskBookAccess

    :FOR    ${index}    IN RANGE    ${RiskBookCount}
    \    Exit For Loop If    ${index}==${RiskBookCount}
    \    ${IsSelected}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_RiskBookAccess_JavaTree}    @{RiskBookDesc_List}[${index}]    5
    \    Run Keyword If    ${IsSelected}==${False}    Log    Risk Book Description: '@{RiskBookDesc_List}[${index}]' is successfuly deleted in the Risk Book Access Table.
         ...    ELSE    Run Keyword And Continue On Failure    Fail    Risk Book Description: '@{RiskBookDesc_List}[${index}]' is NOT deleted in the Risk Book Access Table.
    

    
Validate Risk Book Details to an Existing User in LoanIQ for Delete All Risk Books
    [Documentation]    This keyword is used to navigate to LIQ user profile and validate that all risk books were deleted for user.
    ...    @author: dahijara    10SEP2019    - initial create
    ...    @update: jdelacru    10JAN2020    - Corrected number of arguments for Err_Exist
    [Arguments]    ${sUserId}    ${sRiskBookCode}    ${sOutputFilePath}    ${sOutputFileName}
    
    ${RiskBookCode_List}    Split String    ${sRiskBookCode}    ,
    ${RiskBookDesc_List}    Create List    
    ${RiskBookCount}    Get Length    ${RiskBookCode_List}
    
    #Get Risk Book Description
    Refresh Tables in LIQ
    mx LoanIQ click    ${LIQ_TableMaintenance_Button}
    :FOR    ${index}    IN RANGE    ${RiskBookCount}
    \    Exit For Loop If    ${index}==${RiskBookCount}
    \    Search in Table Maintenance    Risk Book
    \    ${RiskBook_Desc}    Get Single Description from Table Maintanance    @{RiskBookCode_List}[${index}]    ${LIQ_BrowseRiskBook_Window}
         ...    ${LIQ_BrowseRiskBook_JavaTree}    ${LIQ_BrowseRiskBook_ShowAll_RadioButton}    ${LIQ_BrowseRiskBook_Exit_Button}
    \    Append To List    ${RiskBookDesc_List}    ${RiskBook_Desc}

    #Navigate To User Maintenance Page
    Select Actions    [Actions];User Profile
    mx LoanIQ activate window    ${LIQ_OpenAUserProfile_Window}
    Mx LoanIQ Set    ${LIQ_OpenAUserProfile_Inactive_Checkbox}    ON
    mx LoanIQ select    ${LIQ_OpenAUserProfile_IdentifyUserBy_List}    User ID
    mx LoanIQ enter    ${LIQ_OpenAUserProfile_IdentifyUserBy_Textfield}    ${sUserId}
    mx LoanIQ click    ${LIQ_OpenAUserProfile_Search_Button}

    ###check for error message
    ${Err_exist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_OpenAUserProfile_Error_Dialog}    VerificationData="Yes"    Processtimeout=100
    Run Keyword If    ${Err_exist}==${True}    Run Keywords    mx LoanIQ click    ${LIQ_Error_OK_Button}
    ...    AND    Fail    User does not exists.
    
    mx LoanIQ activate window    ${LIQ_OpenAUserProfile_UserList_Window}
	Take Screenshot    LIQ_SearchUser
    ${UserList_exist}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_OpenAUserProfile_UserList_Tree}    ${sUserId}    60
    Run Keyword If    ${UserList_exist}==${False}    Fail    User '${sUserId}' does not exist!!
    ...    ELSE    Log    User '${sUserId}' exists.
    mx LoanIQ click    ${LIQ_OpenAUserProfile_UserList_OK_Button}    

    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    mx LoanIQ click    ${LIQ_UserProfileMaint_InqMode_Button}
    
    Take Screenshot    LIQ_UserProfile    
    ${input_userid}    Convert To Uppercase    ${sUserId}
    ${UserID_Locator}    Set Static Text to Locator Single Text    User Profile Maintenance    ${input_userid}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${UserID_Locator}    VerificationData="Yes"
    ${userid_stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${UserID_Locator}    VerificationData="Yes"
    Run Keyword If    ${userid_stat}==${True}    Log    User ID is correct!!
    ...    ELSE    Log    User ID is incorrect!!    level=ERROR

    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_UserProfileMaint_Tab}    Risk Book Access
    Take Screenshot    LIQ_UserProfile_RiskBookAccess
    
    ${UserRiskBookCollection}    Get Risk Book List From User Profile    ${sOutputFilePath}    ${sOutputFileName}
    ${UserRiskBookCollection}    evaluate    json.loads('${UserRiskBookCollection}')    ${JSON}
    ${UserRiskBookCollection_Count}    Get Length    ${UserRiskBookCollection}

    Run Keyword If    ${UserRiskBookCollection_Count}==0    Log    All User's risk books were Deleted
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Risk books were not deleted for user. Risk Book: ${UserRiskBookCollection}


Delete RiskBook in LIQ
    [Documentation]    This keyword is used to get Riskbook API Response from output file and delete riskbook codes to LoanIQ
    ...    @author: xmiranda    16SEP2019    - initial create

    [Arguments]    ${sOutputFilePath}    ${sOutputFile}    ${sRiskBookCode}    ${sUserId}
    
    ${Response_Payload}    OperatingSystem.Get File    ${datasetpath}${sOutputFilePath}${sOutputFile}.${JSON}          
    ${Response_Payload}    Strip String    ${Response_Payload}    mode=left    characters=[
    ${Response_Payload}    Strip String    ${Response_Payload}    mode=right    characters=]
    
    ${Response_Payload_List}    Split String    ${Response_Payload}    },{
    
    ${JsonCount}    Get Length    ${Response_Payload_List}
    
    ${RiskBookCodeDescription_List}    Create List
    
    #Get Risk Book Description
    Refresh Tables in LIQ
    mx LoanIQ click    ${LIQ_TableMaintenance_Button}
    ${Convert_Object}    OperatingSystem.Get File    ${dataset_path}${sOutputFilePath}${sOutputFile}.json
    ${Converted_JSON}    Evaluate    json.loads('''${Convert_Object}''')    ${JSON}
    ${riskBookCode_List}    Get Value From Json    ${Converted_JSON}    $..riskBookCode
    ${riskBookCode_Count}    Get Length    ${riskBookCode_List}  
    
    :FOR    ${INDEX}    IN RANGE    ${riskBookCode_Count}
    \     ### Get JSON field values ###
    \    ${riskBookCode_val}    Get From List    ${riskBookCode_List}    ${INDEX} 
    \    Log    RiskBookCode: ${riskBookCode_val}
    \    Search in Table Maintenance    Risk Book
    \    ${RiskBook_Desc}    Get Single Description from Table Maintanance    ${riskBookCode_val}    ${LIQ_BrowseRiskBook_Window}
         ...    ${LIQ_BrowseRiskBook_JavaTree}    ${LIQ_BrowseRiskBook_ShowAll_RadioButton}    ${LIQ_BrowseRiskBook_Exit_Button}
    \    Append To List    ${RiskBookCodeDescription_List}    ${RiskBook_Desc}
    \    Log    ${INDEX}=${RiskBookCodeDescription_List}        
    
    Log    ${RiskBookCodeDescription_List}
    Refresh Tables in LIQ
    
    Search User in Loan IQ    ${sUserId}
        
    mx LoanIQ click    ${LIQ_OpenAUserProfile_UserList_OK_Button}
    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    
    :FOR    ${Index_Output}    IN RANGE    ${JsonCount}
    \    ${LastIndex}    Evaluate    ${JsonCount}-1    
    \    ${JSON_Value}    Get From List    ${Response_Payload_List}    ${Index_Output}
    \    ${IsEvenOrOdd}    Evaluate    int('${Index_Output}')%2
    \    ${Separated_JSON_Value}    Run Keyword If    ${IsEvenOrOdd}==0 and ${Index_Output}==0 and ${LastIndex}!=0    Catenate    SEPARATOR=    ${JSON_Value}    }
         ...    ELSE IF    ${IsEvenOrOdd}==0 and ${Index_Output}==0 and ${LastIndex}==0    Set Variable    ${JSON_Value}
         ...    ELSE IF    ${IsEvenOrOdd}==0 and ${Index_Output}==${LastIndex}    Catenate    SEPARATOR=    {    ${JSON_Value}
         ...    ELSE IF    ${IsEvenOrOdd}==1 and ${Index_Output}==${LastIndex}    Catenate    SEPARATOR=    {    ${JSON_Value}
         ...    ELSE    Catenate    SEPARATOR=    {    ${JSON_Value}    }
    \    Log    ${Separated_JSON_Value}
    \    
    \    Create File    ${dataset_path}${sOutputFilePath}${sOutputFile}tempfile.json    ${Separated_JSON_Value}
    \    
    \    ### Get JSON field values ###
    \    ${Convert_Object}    OperatingSystem.Get File    ${dataset_path}${sOutputFilePath}${sOutputFile}tempfile.json
    \    ${Converted_JSON}    Evaluate    json.loads('''${Convert_Object}''')    ${JSON}
    \    
    \    ${Response_UpdateTimeStamp}    Set Variable     ${Converted_JSON}[updateTimeStamp]
    \    ${Response_CreateTimeStamp}    Set Variable    ${Converted_JSON}[createTimeStamp]
    \    ${Response_CreateUserId}    Set Variable    ${Converted_JSON}[createUserId]
    \    ${Response_UpdateUserId}    Set Variable    ${Converted_JSON}[updateUserId]
    \    ${Response_RiskBookCode}    Set Variable    ${Converted_JSON}[riskBookCode]
    \    ${Response_ViewPricesIndicator}    Set Variable    ${Converted_JSON}[viewPricesIndicator]
    \    ${Response_BuySellIndicator}    Set Variable    ${Converted_JSON}[buySellIndicator]
    \    ${Response_MarkIndicator}    Set Variable    ${Converted_JSON}[markIndicator]
    \    ${Response_UserId}    Set Variable    ${Converted_JSON}[userId]
    \
    \    Mx LoanIQ Select Window Tab    ${LIQ_RiskBookAccess_Tab}    Risk Book Access
    \    Take Screenshot    LIQ_RiskBookAccess
    \    
    \    ### Risk Book Access ###
    \    
    \    ${IsSelected}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_RiskBookAccess_JavaTree}    ${RiskBookCodeDescription_List}[${Index_Output}]
    \    Run Keyword If    ${IsSelected}==${True}    Log    Risk Book Description: '${RiskBookCodeDescription_List}[${Index_Output}]' is existing in the Risk Book Access Table.
         ...    ELSE    Log    Risk Book Description: '${RiskBookCodeDescription_List}[${Index_Output}]' is not existing in the Risk Book Access Table.    level=ERROR      
    \    
    \    ### Buy/Sell Indicator ###
    \    
    \    ${BuySellIndicator}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_RiskBookAccess_JavaTree}     ${RiskBookCodeDescription_List}[${Index_Output}]%Buy/Sell%BuySellIndicator
    \    ${LIQ_BuySellIndicator}    Run Keyword If    '${BuySellIndicator}' == 'Y'    Set Variable    True
         ...    ELSE IF    '${BuySellIndicator}' == 'N'    Set Variable    False
    \
    \    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${LIQ_BuySellIndicator}    ${Response_BuySellIndicator} 
    \    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    ${LIQ_BuySellIndicator}    ${Response_BuySellIndicator} 
    \    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. ${LIQ_BuySellIndicator}=${Response_BuySellIndicator} 
         ...    ELSE    Log    Expected and Actual are NOT equal. ${LIQ_BuySellIndicator}!=${Response_BuySellIndicator}    level=ERROR
    \    
    \    ### Mark Indicator ###
    \    
    \    ${MarkIndicator}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_RiskBookAccess_JavaTree}     ${RiskBookCodeDescription_List}[${Index_Output}]%Mark%MarkIndicator
    \    ${LIQ_MarkIndicator}    Run Keyword If    '${MarkIndicator}' == 'Y'    Set Variable    True
         ...    ELSE IF    '${MarkIndicator}' == 'N'    Set Variable    False
    \
    \
    \    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${LIQ_MarkIndicator}    ${Response_MarkIndicator} 
    \    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    ${LIQ_MarkIndicator}    ${Response_MarkIndicator} 
    \    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. ${LIQ_MarkIndicator}=${Response_MarkIndicator} 
         ...    ELSE    Log    Expected and Actual are NOT equal. ${LIQ_MarkIndicator}!=${Response_MarkIndicator}    level=ERROR
    \
    \    ### View Prices Indicator ###
    \    
    \    ${ViewPricesIndicator}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_RiskBookAccess_JavaTree}     ${RiskBookCodeDescription_List}[${Index_Output}]%View Prices%ViewPricesIndicator
    \    ${LIQ_ViewPricesIndicator}    Run Keyword If    '${ViewPricesIndicator}' == 'Y'    Set Variable    True
         ...    ELSE IF    '${ViewPricesIndicator}' == 'N'    Set Variable    False
    \
    \
    \    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${LIQ_ViewPricesIndicator}    ${Response_ViewPricesIndicator} 
    \    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    ${LIQ_ViewPricesIndicator}    ${Response_ViewPricesIndicator} 
    \    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. ${LIQ_ViewPricesIndicator}=${Response_ViewPricesIndicator} 
         ...    ELSE    Log    Expected and Actual are NOT equal. ${LIQ_ViewPricesIndicator}!=${Response_ViewPricesIndicator}    level=ERROR
    \    
    
    mx LoanIQ click    ${LIQ_NotebookInInquiryMode_Button}
    Mx LoanIQ Verify Object Exist    ${LIQ_RiskBookAccess_Button}    VerificationData="Yes"
    mx LoanIQ click    ${LIQ_RiskBookAccess_Button}
    mx LoanIQ activate window    ${LIQ_RiskBookSelection_Window}
    
    ${RiskBookCodeList}    Split String    ${sRiskBookCode}    ,
    ${RiskBookCodeCount}    Get Length    ${RiskBookCodeList}
    
    mx LoanIQ activate window    ${LIQ_RiskBookSelection_Window}

    :FOR    ${index}    IN RANGE    ${RiskBookCodeCount}
    \    Exit For Loop If    ${index}==${RiskBookCodeCount}    
    \    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_RiskBookSelection_Tree}    ${RiskBookCodeList}[${index}]%s
    \    Mx Native Type    {SPACE}
    
    mx LoanIQ click    ${LIQ_RiskBookSelection_Ok_Button}
    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    Take Screenshot    LIQ_UserProfile_RiskBookAccess_DeletedRiskBook
    mx LoanIQ select    ${LIQ_User_Profile_Maintenance_File_Save}

    Refresh Tables in LIQ

Delete Risk Book to Existing User in LoanIQ
    [Documentation]    This keyword is used to navigate LIQ to delete risk book for user.
    ...    This keyword will validate that all riskbooks were deleted for the user.
    ...    @author: dahijara    18SEP2019    - initial create
    ...    @update: jdelacru    10JAN2020    - Corrected number of arguments for Err_Exist
    [Arguments]    ${sUserId}    ${sRiskBookCode}    ${sOutputFilePath}    ${sOutputFileName}

    ${RiskBookCode_List}    Split String    ${sRiskBookCode}    ,
    ${RiskBookDesc_List}    Create List    
    ${RiskBookCount}    Get Length    ${RiskBookCode_List}
    
    #Get Risk Book Description
    Refresh Tables in LIQ
    mx LoanIQ click    ${LIQ_TableMaintenance_Button}
    :FOR    ${index}    IN RANGE    ${RiskBookCount}
    \    Exit For Loop If    ${index}==${RiskBookCount}
    \    Search in Table Maintenance    Risk Book
    \    ${RiskBook_Desc}    Get Single Description from Table Maintanance    @{RiskBookCode_List}[${index}]    ${LIQ_BrowseRiskBook_Window}
         ...    ${LIQ_BrowseRiskBook_JavaTree}    ${LIQ_BrowseRiskBook_ShowAll_RadioButton}    ${LIQ_BrowseRiskBook_Exit_Button}
    \    Append To List    ${RiskBookDesc_List}    ${RiskBook_Desc}

    #Navigate To User Maintenance Page
    Select Actions    [Actions];User Profile
    mx LoanIQ activate window    ${LIQ_OpenAUserProfile_Window}
    Mx LoanIQ Set    ${LIQ_OpenAUserProfile_Inactive_Checkbox}    ON
    mx LoanIQ select    ${LIQ_OpenAUserProfile_IdentifyUserBy_List}    User ID
    mx LoanIQ enter    ${LIQ_OpenAUserProfile_IdentifyUserBy_Textfield}    ${sUserId}
    mx LoanIQ click    ${LIQ_OpenAUserProfile_Search_Button}

    ###check for error message
    ${Err_exist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_OpenAUserProfile_Error_Dialog}    VerificationData="Yes"    Processtimeout=100
    Run Keyword If    ${Err_exist}==${True}    Run Keywords    mx LoanIQ click    ${LIQ_Error_OK_Button}
    ...    AND    Fail    User does not exists.
    
    mx LoanIQ activate window    ${LIQ_OpenAUserProfile_UserList_Window}
	Take Screenshot    LIQ_SearchUser
    ${UserList_exist}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_OpenAUserProfile_UserList_Tree}    ${sUserId}    60
    Run Keyword If    ${UserList_exist}==${False}    Fail    User '${sUserId}' does not exist!!
    ...    ELSE    Log    User '${sUserId}' exists.
    mx LoanIQ click    ${LIQ_OpenAUserProfile_UserList_OK_Button}    

    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    mx LoanIQ click    ${LIQ_UserProfileMaint_InqMode_Button}
    
    Take Screenshot    LIQ_UserProfile    
    ${input_userid}    Convert To Uppercase    ${sUserId}
    ${UserID_Locator}    Set Static Text to Locator Single Text    User Profile Maintenance    ${input_userid}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${UserID_Locator}    VerificationData="Yes"
    ${userid_stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${UserID_Locator}    VerificationData="Yes"
    Run Keyword If    ${userid_stat}==${True}    Log    User ID is correct!!
    ...    ELSE    Log    User ID is incorrect!!    level=ERROR

    #Validate Risk Book
    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_UserProfileMaint_Tab}    Risk Book Access
    
    
    :FOR    ${index}    IN RANGE    ${RiskBookCount}
    \    Exit For Loop If    ${index}==${RiskBookCount}
    \    ${IsSelected}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_RiskBookAccess_JavaTree}    @{RiskBookDesc_List}[${index}]
    \    Run Keyword If    ${IsSelected}==${True}    Log    Risk Book Description: '@{RiskBookDesc_List}[${index}]' is exists the Risk Book Access Table.
         ...    ELSE    Run Keyword And Continue On Failure    Fail    Risk Book Description: '@{RiskBookDesc_List}[${index}]' does not exist the Risk Book Access Table.
    
    Take Screenshot    LIQ_UserProfile_RiskBookAccess
    
    mx LoanIQ click    ${LIQ_RiskBookAccess_Button}
    mx LoanIQ activate window    ${LIQ_RiskBookSelection_Window}

    :FOR    ${index}    IN RANGE    ${RiskBookCount}
    \    Exit For Loop If    ${index}==${RiskBookCount}    
    \    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_RiskBookSelection_Tree}    ${RiskBookCode_List}[${index}]%s
    \    Mx Native Type    {SPACE}
    
    Take Screenshot    LIQ_UserProfile_DeleteRiskBook
    mx LoanIQ click    ${LIQ_RiskBookSelection_Ok_Button}

    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    
    Take Screenshot    LIQ_UserProfile_RiskBookAccess_DeletedRiskBook
    
    ${UserRiskBookCollection}    Get Risk Book List From User Profile    ${sOutputFilePath}    ${sOutputFileName}
    ${UserRiskBookCollection}    evaluate    json.loads('${UserRiskBookCollection}')    ${JSON}
    ${UserRiskBookCollection_Count}    Get Length    ${UserRiskBookCollection}

    Run Keyword If    ${UserRiskBookCollection_Count}==0    Log    All User's risk books were Deleted
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Risk books were not deleted for user. Risk Book: ${UserRiskBookCollection}
        
    mx LoanIQ select    ${LIQ_User_Profile_Maintenance_File_Save}
    Refresh Tables in LIQ
    
Add New Risk Book Code in Table Maintenance
        
    [Documentation]    This keyword is used to create a new riskbook code in LIQ Table Maintenance
    ...    @author: xmiranda    18SEP2019    - initial create
    [Arguments]    ${sRiskBookCode}    ${sRiskBookDescription}    ${sPortfolio}    ${sExpense}    ${sOptionalComment}
    
    Refresh Tables in LIQ
    mx LoanIQ click    ${LIQ_TableMaintenance_Button}
    Search in Table Maintenance    Risk Book
    
    ${RiskBookCode_List}    Split String    ${sRiskBookCode}    ,    
    ${RiskBookCount}    Get Length    ${RiskBookCode_List}
    
    ${RiskBookDescription_List}    Split String    ${sRiskBookDescription}    ,    
    ${RiskBookDescriptionCount}    Get Length    ${RiskBookDescription_List}
    
    ${Portfolio_List}    Split String    ${sPortfolio}    ,    
    ${PortfolioCount}    Get Length    ${Portfolio_List}
    
    ${Expense_List}    Split String    ${sExpense}    ,    
    ${ExpenseCount}    Get Length    ${Expense_List}
    
    ${OptionalComment_List}    Split String    ${sOptionalComment}    ,    
    ${OptionalCommentCount}    Get Length    ${OptionalComment_List}
    
    :FOR    ${index}    IN RANGE    ${RiskBookCount}
    \    Exit For Loop If    ${index}==${RiskBookCount}
    \    mx LoanIQ click    ${LIQ_BrowseRiskBook_Add_Button}
    \    Log    Risk Book Code '@{RiskBookCode_List}[${index}]' - '@{RiskBookDescription_List}[${index}]'
    \    mx LoanIQ activate window    ${LIQ_RiskBookInsert_Window}
    \    mx LoanIQ enter    ${LIQ_RiskBookInsert_Code_Field}    @{RiskBookCode_List}[${index}]
    \    mx LoanIQ enter    ${LIQ_RiskBookInsert_Description_Field}    @{RiskBookDescription_List}[${index}]
    \    mx LoanIQ click    ${LIQ_RiskBookInsert_Add_Button}
    \    
    \    mx LoanIQ activate window    ${LIQ_PortfolioExpense_Window}
    \    mx LoanIQ select list    ${LIQ_PortfolioExpense_Porfolio_JavaList}    @{Portfolio_List}[${index}]
    \    mx LoanIQ select list    ${LIQ_PortfolioExpense_Expense_JavaList}    @{Expense_List}[${index}]
    \    mx LoanIQ click    ${LIQ_PortfolioExpense_OK_Button}
    \    
    \    mx LoanIQ activate window    ${LIQ_RiskBookInsert_Window}
    \    mx LoanIQ click    ${LIQ_RiskBookInsert_OK_Button}
    \    
    \    mx LoanIQ activate window    ${LIQ_EnterOptionalUserComment_Window}
    \    mx LoanIQ enter    ${LIQ_EnterOptionalUserComment_Field}    @{OptionalComment_List}[${index}]
    \    mx LoanIQ click    ${LIQ_EnterOptionalUserComment_OK_Button}
    \    
    
    Take Screenshot    LIQ_BrowseRiskBook 
    mx LoanIQ click    ${LIQ_BrowseRiskBook_Exit_Button}
    Refresh Tables in LIQ