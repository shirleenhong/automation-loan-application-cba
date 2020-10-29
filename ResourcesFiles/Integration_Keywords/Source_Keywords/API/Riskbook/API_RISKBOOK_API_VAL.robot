*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

GET Request API for Riskbook
    [Documentation]    This keyword is used to GET request API for Riskbook.
    ...    @author: xmiranda    28AUG2019    - initial create
    ...    @update: dhijara    21MAY2019    - removed ${Headers} variable and argument in Get Request API in the condition since this is not needed. 
    [Arguments]    ${sOutputPath}    ${sOutputFile}    ${sUserId}=None   ${sLoginId}=None
    
    Delete All Sessions
    Create Session    ${APISESSION}    ${MDM_HOST_PARTY}
    Log    LoginID: ${sLoginId}
    Log    UserID: ${sUserId}
    Run Keyword If    '${sLoginId}'=='None' and '${sUserId}'!='None'    Get Request API    ${sOutputPath}	${sOutputFile}    ${MDM_RISKBOOK_API}${sUserId}/${RISKBOOKS}
    ...    ELSE IF    '${sLoginId}'!='None' and '${sUserId}'=='None'    Get Request API    ${sOutputPath}    ${sOutputFile}    ${MDM_RISKBOOK_API}${RISKBOOK_LOGIN}/${sLoginId}/${RISKBOOKS}
    
    ${RequestBody}    OperatingSystem.Get File    ${dataset_path}${sOutputPath}${sOutputFile}.json  
    
    ${EMPTY_LIST}    Create List
    
    Run Keyword If    '${RequestBody}' == '${EMPTY_LIST}'    Log    Response is Empty
    ...    ELSE    Log    Response contains an Output            

    Verify Json Response Status Code    ${RESPONSECODE_200}

Update Key Values of Input JSON File for Risk Book API
    [Documentation]    This keyword is used to update JSON key and values related to Risk Book API request.
    ...    @author: dahijara    2SEP2019    - initial create
    [Arguments]    ${sFilePath}    ${sFileName}    ${buySellIndicator}    ${markIndicator}    ${primaryIndicator}    ${riskBookCode}    ${viewPricesIndicator}

    ${Empty_List}    Create List    
    
    ${riskBookCode_List}    Split String    ${riskBookCode}    ,
    ${riskBook_Count}    Get Length    ${riskBookCode_List}
    ${buySellIndicator_List}    Split String    ${buySellIndicator}    ,
    ${markIndicator_List}    Split String    ${markIndicator}    ,
    ${primaryIndicator_List}    Split String    ${primaryIndicator}    ,
    ${viewPricesIndicator_List}    Split String    ${viewPricesIndicator}    ,
    
    :FOR    ${INDEX_0}    IN RANGE    ${riskBook_Count}
    \    Exit For Loop If    ${INDEX_0}==${riskBook_Count} or '${riskBookCode}'==''
    \    
    \    ${val_BuySellIndicator}    Get From List    ${buySellIndicator_List}    ${INDEX_0}
	\    ${val_BuySellIndicator}    Run Keyword If    '${val_BuySellIndicator}'=='null'    Set Variable    ${NONE}
	     ...    ELSE IF    '${val_BuySellIndicator}'==''    Set Variable    ${EMPTY}
	     ...    ELSE IF    '${val_BuySellIndicator}'=='Empty' or '${val_BuySellIndicator}'=='empty' or '${val_BuySellIndicator}'=='EMPTY'
	     ...    Set Variable    ${EMPTY}
	     ...    ELSE    Set Variable    ${val_BuySellIndicator}
	\    
    \    ${val_markIndicator}    Get From List    ${markIndicator_List}    ${INDEX_0}
	\    ${val_markIndicator}    Run Keyword If    '${val_markIndicator}'=='null'    Set Variable    ${NONE}
	     ...    ELSE IF    '${val_markIndicator}'==''    Set Variable    ${EMPTY}
	     ...    ELSE IF    '${val_markIndicator}'=='Empty' or '${val_markIndicator}'=='empty' or '${val_markIndicator}'=='EMPTY'
	     ...    Set Variable    ${EMPTY}
	     ...    ELSE    Set Variable    ${val_markIndicator}
	\    
    \    ${val_primaryIndicator}    Get From List    ${primaryIndicator_List}    ${INDEX_0}
	\    ${val_primaryIndicator}    Run Keyword If    '${val_primaryIndicator}'=='null'    Set Variable    ${NONE}
	     ...    ELSE IF    '${val_primaryIndicator}'==''    Set Variable    ${EMPTY}
	     ...    ELSE IF    '${val_primaryIndicator}'=='Empty' or '${val_primaryIndicator}'=='empty' or '${val_primaryIndicator}'=='EMPTY'
	     ...    Set Variable    ${EMPTY}
	     ...    ELSE    Set Variable    ${val_primaryIndicator}
	\    
    \    ${val_riskBookCode}    Get From List    ${riskBookCode_List}    ${INDEX_0}
	\    ${val_riskBookCode}    Run Keyword If    '${val_riskBookCode}'=='null'    Set Variable    ${NONE}
	     ...    ELSE IF    '${val_riskBookCode}'==''    Set Variable    ${EMPTY}
	     ...    ELSE IF    '${val_riskBookCode}'=='Empty' or '${val_riskBookCode}'=='empty' or '${val_riskBookCode}'=='EMPTY'
	     ...    Set Variable    ${EMPTY}
	     ...    ELSE    Set Variable    ${val_riskBookCode}
	\    
    \    ${val_viewPricesIndicator}    Get From List    ${viewPricesIndicator_List}    ${INDEX_0}
	\    ${val_viewPricesIndicator}    Run Keyword If    '${val_viewPricesIndicator}'=='null'    Set Variable    ${NONE}
	     ...    ELSE IF    '${val_viewPricesIndicator}'==''    Set Variable    ${EMPTY}
	     ...    ELSE IF    '${val_viewPricesIndicator}'=='Empty' or '${val_viewPricesIndicator}'=='empty' or '${val_viewPricesIndicator}'=='EMPTY'
	     ...    Set Variable    ${EMPTY}
	     ...    ELSE    Set Variable    ${val_viewPricesIndicator}
    \     
	\    ${RiskBook_JSON}    Create Dictionary    viewPricesIndicator=${${val_viewPricesIndicator}}    riskBookCode=${val_riskBookCode}    primaryIndicator=${${val_primaryIndicator}}
	     ...    markIndicator=${${val_markIndicator}}    buySellIndicator=${${val_BuySellIndicator}}
	\    
	\    Run Keyword If    '${val_BuySellIndicator}'=='no tag'    Remove From Dictionary    ${RiskBook_JSON}    buySellIndicator
	\    Run Keyword If    '${val_BuySellIndicator}'=='no tag'    Remove From Dictionary    ${RiskBook_JSON}    viewPricesIndicator
	\    Run Keyword If    '${val_riskBookCode}'=='no tag'    Remove From Dictionary    ${RiskBook_JSON}    riskBookCode
	\    Run Keyword If    '${val_primaryIndicator}'=='no tag'    Remove From Dictionary    ${RiskBook_JSON}    primaryIndicator
	\    Run Keyword If    '${val_markIndicator}'=='no tag'    Remove From Dictionary    ${RiskBook_JSON}    markIndicator
	\    
	\    ${RiskBookSingle_JSON}    Evaluate    json.dumps(${RiskBook_JSON})        json
    \    ${TempJSON_File}    Set Variable    ${sFilePath}${sFileName}_${val_riskBookCode}.json
    \    Delete File If Exist    ${dataset_path}${TempJSON_File}
    \    Create File    ${dataset_path}${TempJSON_File}    ${RiskBookSingle_JSON}
    \    ${TempFile}    OperatingSystem.Get File    ${dataset_path}${TempJSON_File}
	\    
	\    Log    ${RiskBook_JSON}
	\    Append To List    ${Empty_List}    ${RiskBook_JSON}
	\    Log    ${Empty_List}
    
    ${Converted_RiskBook_JSON}    Evaluate    json.dumps(${Empty_List})        json
    Log    ${Converted_RiskBook_JSON}

    ${JSON_File}    Set Variable    ${sFilePath}${sFileName}.json
    Delete File If Exist    ${dataset_path}${JSON_File}
    Create File    ${dataset_path}${JSON_File}    ${Converted_RiskBook_JSON}
    ${file}    OperatingSystem.Get File    ${dataset_path}${JSON_File}

Update Expected Response for Risk Book API
    [Documentation]    This keyword is used to generate expected response JSON file for risk book API.
    ...    @author: dahijara    2SEP2019    - initial create
    [Arguments]    ${sFilePath}    ${sFileName}    ${userId}    ${createUserId}    ${updateUserId}    ${buySellIndicator}    ${markIndicator}    ${primaryIndicator}    ${riskBookCode}    ${viewPricesIndicator}

    ${Empty_List}    Create List    
    
    ${riskBookCode_List}    Split String    ${riskBookCode}    ,
    ${riskBook_Count}    Get Length    ${riskBookCode_List}
    ${buySellIndicator_List}    Split String    ${buySellIndicator}    ,
    ${markIndicator_List}    Split String    ${markIndicator}    ,
    ${primaryIndicator_List}    Split String    ${primaryIndicator}    ,
    ${viewPricesIndicator_List}    Split String    ${viewPricesIndicator}    ,

    Refresh Tables in LIQ
    mx LoanIQ click    ${LIQ_TableMaintenance_Button}
    
    :FOR    ${INDEX_0}    IN RANGE    ${riskBook_Count}
    \    Exit For Loop If    ${INDEX_0}==${riskBook_Count} or '${riskBookCode}'==''
    \     
    \    ${val_BuySellIndicator}    Get From List    ${buySellIndicator_List}    ${INDEX_0}
	\    ${val_BuySellIndicator}    Run Keyword If    '${val_BuySellIndicator}'=='null'    Set Variable    ${NONE}
	     ...    ELSE IF    '${val_BuySellIndicator}'==''    Set Variable    ${EMPTY}
	     ...    ELSE IF    '${val_BuySellIndicator}'=='Empty' or '${val_BuySellIndicator}'=='empty' or '${val_BuySellIndicator}'=='EMPTY'
	     ...    Set Variable    ${EMPTY}
	     ...    ELSE    Set Variable    ${val_BuySellIndicator}
	\    
    \    ${val_markIndicator}    Get From List    ${markIndicator_List}    ${INDEX_0}
	\    ${val_markIndicator}    Run Keyword If    '${val_markIndicator}'=='null'    Set Variable    ${NONE}
	     ...    ELSE IF    '${val_markIndicator}'==''    Set Variable    ${EMPTY}
	     ...    ELSE IF    '${val_markIndicator}'=='Empty' or '${val_markIndicator}'=='empty' or '${val_markIndicator}'=='EMPTY'
	     ...    Set Variable    ${EMPTY}
	     ...    ELSE    Set Variable    ${val_markIndicator}
	\    
    \    ${val_primaryIndicator}    Get From List    ${primaryIndicator_List}    ${INDEX_0}
	\    ${val_primaryIndicator}    Run Keyword If    '${val_primaryIndicator}'=='null'    Set Variable    ${NONE}
	     ...    ELSE IF    '${val_primaryIndicator}'==''    Set Variable    ${EMPTY}
	     ...    ELSE IF    '${val_primaryIndicator}'=='Empty' or '${val_primaryIndicator}'=='empty' or '${val_primaryIndicator}'=='EMPTY'
	     ...    Set Variable    ${EMPTY}
	     ...    ELSE    Set Variable    ${val_primaryIndicator}
	\    
    \    ${val_riskBookCode}    Get From List    ${riskBookCode_List}    ${INDEX_0}
	\    ${val_riskBookCode}    Run Keyword If    '${val_riskBookCode}'=='null'    Set Variable    ${NONE}
	     ...    ELSE IF    '${val_riskBookCode}'==''    Set Variable    ${EMPTY}
	     ...    ELSE IF    '${val_riskBookCode}'=='Empty' or '${val_riskBookCode}'=='empty' or '${val_riskBookCode}'=='EMPTY'
	     ...    Set Variable    ${EMPTY}
	     ...    ELSE    Set Variable    ${val_riskBookCode}
	\    
    \    ${val_viewPricesIndicator}    Get From List    ${viewPricesIndicator_List}    ${INDEX_0}
	\    ${val_viewPricesIndicator}    Run Keyword If    '${val_viewPricesIndicator}'=='null'    Set Variable    ${NONE}
	     ...    ELSE IF    '${val_viewPricesIndicator}'==''    Set Variable    ${EMPTY}
	     ...    ELSE IF    '${val_viewPricesIndicator}'=='Empty' or '${val_viewPricesIndicator}'=='empty' or '${val_viewPricesIndicator}'=='EMPTY'
	     ...    Set Variable    ${EMPTY}
	     ...    ELSE    Set Variable    ${val_viewPricesIndicator}
	\    
    \    #Get Risk Book Description
    \    Search in Table Maintenance    Risk Book
    \    ${val_RiskBookDesc}    Get Single Description from Table Maintanance    ${val_riskBookCode}    ${LIQ_BrowseRiskBook_Window}
         ...    ${LIQ_BrowseRiskBook_JavaTree}    ${LIQ_BrowseRiskBook_ShowAll_RadioButton}    ${LIQ_BrowseRiskBook_Exit_Button}
	\    
	\    ${RiskBook_JSON}    Create Dictionary    viewPricesIndicator=${${val_viewPricesIndicator}}    riskBookCode=${val_riskBookCode}    primaryIndicator=${${val_primaryIndicator}}
	     ...    markIndicator=${${val_markIndicator}}    buySellIndicator=${${val_BuySellIndicator}}    userId=${userId}    createUserId=${createUserId}    updateUserId=${updateUserId}
	     ...    riskBookDescription=${val_RiskBookDesc}
	\    
	\    Run Keyword If    '${val_BuySellIndicator}'=='no tag'    Remove From Dictionary    ${RiskBook_JSON}    buySellIndicator
	\    Run Keyword If    '${val_BuySellIndicator}'=='no tag'    Remove From Dictionary    ${RiskBook_JSON}    viewPricesIndicator
	\    Run Keyword If    '${val_riskBookCode}'=='no tag'    Remove From Dictionary    ${RiskBook_JSON}    riskBookCode
	\    Run Keyword If    '${val_primaryIndicator}'=='no tag'    Remove From Dictionary    ${RiskBook_JSON}    primaryIndicator
	\    Run Keyword If    '${val_markIndicator}'=='no tag'    Remove From Dictionary    ${RiskBook_JSON}    markIndicator
	\    
	\    ${RiskBookSingle_JSON}    Evaluate    json.dumps(${RiskBook_JSON})        json
    \    ${TempJSON_File}    Set Variable    ${sFilePath}${sFileName}_${val_riskBookCode}.json
    \    Delete File If Exist    ${dataset_path}${TempJSON_File}
    \    Create File    ${dataset_path}${TempJSON_File}    ${RiskBookSingle_JSON}
    \    ${TempFile}    OperatingSystem.Get File    ${dataset_path}${TempJSON_File}
    \    
	\    Log    ${RiskBook_JSON}
	\    Append To List    ${Empty_List}    ${RiskBook_JSON}
    
    ${Converted_RiskBook_JSON}    Evaluate    json.dumps(${Empty_List})        json
    Log    ${Converted_RiskBook_JSON}

    ${JSON_File}    Set Variable    ${sFilePath}${sFileName}.json
    Delete File If Exist    ${dataset_path}${JSON_File}
    Create File    ${dataset_path}${JSON_File}    ${Converted_RiskBook_JSON}
    ${file}    OperatingSystem.Get File    ${dataset_path}${JSON_File}
    
PUT Request for Risk Book API
    [Documentation]    This keyword is used to get token and create session for Risk Book API and send PUT request for the input JSON.
    ...    @author: dahijara    2SEP2019    - initial create
    ...    @update: xmiranda    12SEP2019    - removed codes related to access token.
    [Arguments]    ${sInputFilePath}    ${sInputJson}    ${sInputAPIResponse}    ${sOutputFilePath}    ${sOutputAPIResponse}
    ...    ${sInputFilePath_AccessToken}    ${sInputFile_AccessToken}    ${sUserId}=None    ${sLoginId}=None

    Delete All Sessions
    Create Session    ${APISESSION}    ${MDM_HOST_PARTY}
    Run Keyword If    '${sUserId}'=='None' and '${sLoginId}'!='None'    Put Json File    ${sInputFilePath}    ${sInputJson}
    ...    ${MDM_RISKBOOK_API}/${RISKBOOK_LOGIN}/${sLoginID}/${RISKBOOKS}    ${sOutputFilePath}    ${sOutputAPIResponse}
    ...    ELSE IF    '${sUserId}'!='None' and '${sLoginId}'=='None'    Put Json File    ${sInputFilePath}    ${sInputJson}
    ...    ${MDM_RISKBOOK_API}${sUserID}/${RISKBOOKS}    ${sOutputFilePath}    ${sOutputAPIResponse}
    Compare Risk Book API Request and Response    ${sInputFilePath}    ${sInputAPIResponse}
    Verify Json Response Status Code    ${RESPONSECODE_200}

Compare Risk Book API Request and Response
    [Documentation]    This keyword is used to validate if the response after submitting risk book API request matched the expected response.
    ...    @author: dahijara    2SEP2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sFileName}
    
    ${InputJSON}    Load JSON From File    ${dataset_path}${sInputFilePath}${sFileName}.json
    ${OutputJSON}    evaluate    json.loads('''${RESPONSE_FILE}''')    ${JSON}
    
    ${InputJSON_Count}    Get Length    ${InputJSON}
    ${OutputJSON_Count}    Get Length    ${OutputJSON}
    
    Run Keyword And Continue On Failure    Should Be Equal As Integers    ${InputJSON_Count}    ${OutputJSON_Count}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Integers    ${InputJSON_Count}    ${OutputJSON_Count}
    Run Keyword If    ${IsEqual}==${True}    Log    Risk Book Count is equal. Input:${InputJSON_Count}==Output:${OutputJSON_Count}
    ...    ELSE    Log    Risk Book Count is NOT equal. Input:${InputJSON_Count}!=Output:${OutputJSON_Count}    level=ERROR
    
    ${Index_0}    Set Variable    0
    :FOR    ${Index_0}    IN RANGE    ${OutputJSON_Count}
    \    Exit For Loop If    ${Index_0}==${OutputJSON_Count}
    \    ${val_RiskBookCode}    Get From Dictionary    @{OutputJSON}[${Index_0}]    riskBookCode
    \    ${val_CreateTimeStamp}    Get From Dictionary    @{OutputJSON}[${Index_0}]    createTimeStamp
    \    ${val_UpdateTimeStamp}    Get From Dictionary    @{OutputJSON}[${Index_0}]    updateTimeStamp
    \    Run Keyword And Continue On Failure    Should Contain    ${val_CreateTimeStamp}    ${PUTREQUEST_TIMESTAMP}
    \    ${Status}    Run Keyword And Return Status    Should Contain    ${val_CreateTimeStamp}    ${PUTREQUEST_TIMESTAMP}
    \    Run Keyword If    ${Status}==${True}    Log    CreateTimeStamps were matched. Expected:${PUTREQUEST_TIMESTAMP} == Actual:${val_CreateTimeStamp}
         ...    ELSE    Log    CreateTimeStamp didn't matched. Expected:${PUTREQUEST_TIMESTAMP} == Actual:${val_CreateTimeStamp}    level=ERROR
    \    Delete Object From Json    @{OutputJSON}[${Index_0}]    createTimeStamp
    \    Delete Object From Json    @{OutputJSON}[${Index_0}]    updateTimeStamp
    \    ${NewOutput_JSON}    Evaluate    json.dumps(@{OutputJSON}[${Index_0}])    json
    \    ${InputRiskBookJSON}    OperatingSystem.Get File    ${dataset_path}${sInputFilePath}${sFileName}_${val_RiskBookCode}.json
    \    Run Keyword And Continue On Failure    Mx Compare Json Data     ${NewOutput_JSON}    ${InputRiskBookJSON}
    \    ${Stat}    Run Keyword And Return Status    Mx Compare Json Data     ${NewOutput_JSON}    ${InputRiskBookJSON}
    \    Run Keyword If    ${Stat}==${True}    Log    Input and Output JSON Files are matched. ${InputRiskBookJSON} == ${NewOutput_JSON}
         ...    ELSE    Log    Input and Output JSON Files does not matched. ${InputRiskBookJSON} != ${NewOutput_JSON}    level=ERROR

DELETE Request API for Riskbook
    [Documentation]    This keyword is used to GET request API for Riskbook.
    ...    @author: xmiranda    10SEP2019    - initial create
    [Arguments]    ${sInputPath}    ${sInputFile}    ${sOutputPath}    ${sOutputFile}    ${sUserId}=None    ${sLoginId}=None
    
    Delete All Sessions
    Create Session    ${APISESSION}    ${MDM_HOST_PARTY}
    
    ${Headers}    Create Dictionary
    
    ${RequestBody}    OperatingSystem.Get File    ${dataset_path}${sInputPath}${sInputFile}.json    
    
    ${API_RESPONSE}    Run Keyword If    '${sUserId}'!='None' and '${sLoginId}'=='None'    Delete Request    ${APISESSION}    ${MDM_RISKBOOK_API}${sUserId}/${RISKBOOKS}    ${RequestBody}    ${Headers}
    ...    ELSE IF    '${sUserId}'=='None' and '${sLoginId}'!='None'    Delete Request    ${APISESSION}    ${MDM_RISKBOOK_API}${RISKBOOK_LOGIN}/${sLoginId}/${RISKBOOKS}    ${RequestBody}    ${Headers}

    Set Global Variable    ${API_RESPONSE}
    Log    Delete Json Response: ${API_RESPONSE.content}
    
    ${EMPTY_LIST}    Create List
    
    Run Keyword If    '${API_RESPONSE.content}' == '${EMPTY_LIST}'    Log    Response is Empty
    ...    ELSE    Log    Response contains an Output    
    
    Verify Json Response Status Code    ${RESPONSECODE_200}
    
    ${API_RESPONSE_STRING}    Convert To String    ${API_RESPONSE.content}
    Create file    ${dataset_path}${sOutputPath}${sOutputFile}.json    ${API_RESPONSE_STRING}

    
Update Key Values and Set Default Indicator Value of Input JSON File for Risk Book API
    [Documentation]    This keyword is used to update JSON key and values related to Risk Book API request.
    ...    @author: dahijara    2SEP2019    - initial create
    [Arguments]    ${sFilePath}    ${sFileName}    ${buySellIndicator}    ${markIndicator}    ${primaryIndicator}    ${riskBookCode}    ${viewPricesIndicator}

    ${Empty_List}    Create List    
    
    ${riskBookCode_List}    Split String    ${riskBookCode}    ,
    ${riskBook_Count}    Get Length    ${riskBookCode_List}
    ${buySellIndicator_List}    Split String    ${buySellIndicator}    ,
    ${markIndicator_List}    Split String    ${markIndicator}    ,
    ${primaryIndicator_List}    Split String    ${primaryIndicator}    ,
    ${viewPricesIndicator_List}    Split String    ${viewPricesIndicator}    ,
    
    :FOR    ${INDEX_0}    IN RANGE    ${riskBook_Count}
    \    Exit For Loop If    ${INDEX_0}==${riskBook_Count} or '${riskBookCode}'==''
    \    
    \    ${val_BuySellIndicator}    Get From List    ${buySellIndicator_List}    ${INDEX_0}
	\    ${val_BuySellIndicator}    Run Keyword If    '${val_BuySellIndicator}'=='null'    Set Variable    ${NONE}
	     ...    ELSE IF    '${val_BuySellIndicator}'==''    Set Variable    ${EMPTY}
	     ...    ELSE IF    '${val_BuySellIndicator}'=='Empty' or '${val_BuySellIndicator}'=='empty' or '${val_BuySellIndicator}'=='EMPTY'
	     ...    Set Variable    ${EMPTY}
	     ...    ELSE    Set Variable    ${val_BuySellIndicator}
	\    
    \    ${val_markIndicator}    Get From List    ${markIndicator_List}    ${INDEX_0}
	\    ${val_markIndicator}    Run Keyword If    '${val_markIndicator}'=='null'    Set Variable    ${NONE}
	     ...    ELSE IF    '${val_markIndicator}'==''    Set Variable    ${EMPTY}
	     ...    ELSE IF    '${val_markIndicator}'=='Empty' or '${val_markIndicator}'=='empty' or '${val_markIndicator}'=='EMPTY'
	     ...    Set Variable    ${EMPTY}
	     ...    ELSE    Set Variable    ${val_markIndicator}
	\    
    \    ${val_primaryIndicator}    Get From List    ${primaryIndicator_List}    ${INDEX_0}
	\    ${val_primaryIndicator}    Run Keyword If    '${val_primaryIndicator}'=='null'    Set Variable    ${NONE}
	     ...    ELSE IF    '${val_primaryIndicator}'==''    Set Variable    ${EMPTY}
	     ...    ELSE IF    '${val_primaryIndicator}'=='Empty' or '${val_primaryIndicator}'=='empty' or '${val_primaryIndicator}'=='EMPTY'
	     ...    Set Variable    ${EMPTY}
	     ...    ELSE    Set Variable    ${val_primaryIndicator}
	\    
    \    ${val_riskBookCode}    Get From List    ${riskBookCode_List}    ${INDEX_0}
	\    ${val_riskBookCode}    Run Keyword If    '${val_riskBookCode}'=='null'    Set Variable    ${NONE}
	     ...    ELSE IF    '${val_riskBookCode}'==''    Set Variable    ${EMPTY}
	     ...    ELSE IF    '${val_riskBookCode}'=='Empty' or '${val_riskBookCode}'=='empty' or '${val_riskBookCode}'=='EMPTY'
	     ...    Set Variable    ${EMPTY}
	     ...    ELSE    Set Variable    ${val_riskBookCode}
	\    
    \    ${val_viewPricesIndicator}    Get From List    ${viewPricesIndicator_List}    ${INDEX_0}
	\    ${val_viewPricesIndicator}    Run Keyword If    '${val_viewPricesIndicator}'=='null'    Set Variable    ${NONE}
	     ...    ELSE IF    '${val_viewPricesIndicator}'==''    Set Variable    ${EMPTY}
	     ...    ELSE IF    '${val_viewPricesIndicator}'=='Empty' or '${val_viewPricesIndicator}'=='empty' or '${val_viewPricesIndicator}'=='EMPTY'
	     ...    Set Variable    ${EMPTY}
	     ...    ELSE    Set Variable    ${val_viewPricesIndicator}
    \    
    \    
	\    ${RiskBook_JSON}    Create Dictionary    
	\    Run Keyword If    '${val_BuySellIndicator}'!='no tag'    Set to Dictionary    ${RiskBook_JSON}    buySellIndicator    ${${val_BuySellIndicator}}
	\    Run Keyword If    '${val_viewPricesIndicator}'!='no tag'    Set to Dictionary	${RiskBook_JSON}	viewPricesIndicator	${${val_viewPricesIndicator}}  
	\    Run Keyword If    '${val_primaryIndicator}'!='no tag'    Set to Dictionary    ${RiskBook_JSON}	primaryIndicator	${${val_primaryIndicator}}
	\    Run Keyword If    '${val_markIndicator}'!='no tag'    Set to Dictionary    ${RiskBook_JSON}	markIndicator    ${${val_markIndicator}}
	\    Run Keyword If    '${val_riskBookCode}'!='no tag'    Set to Dictionary    ${RiskBook_JSON}	riskBookCode    ${val_riskBookCode}
	\      
	\    ${RiskBookSingle_JSON}    Evaluate    json.dumps(${RiskBook_JSON})        json
    \    ${TempJSON_File}    Set Variable    ${sFilePath}${sFileName}_${val_riskBookCode}.json
    \    Delete File If Exist    ${dataset_path}${TempJSON_File}
    \    Create File    ${dataset_path}${TempJSON_File}    ${RiskBookSingle_JSON}
    \    ${TempFile}    OperatingSystem.Get File    ${dataset_path}${TempJSON_File}
	\    
	\    Log    ${RiskBook_JSON}
	\    Append To List    ${Empty_List}    ${RiskBook_JSON}
	\    Log    ${Empty_List}
    
    ${Converted_RiskBook_JSON}    Evaluate    json.dumps(${Empty_List})        json
    Log    ${Converted_RiskBook_JSON}

    ${JSON_File}    Set Variable    ${sFilePath}${sFileName}.json
    Delete File If Exist    ${dataset_path}${JSON_File}
    Create File    ${dataset_path}${JSON_File}    ${Converted_RiskBook_JSON}
    ${file}    OperatingSystem.Get File    ${dataset_path}${JSON_File}

Update Expected Response and Default Indicator Value for Risk Book API
    [Documentation]    This keyword is used to generate expected response JSON file for risk book API.
    ...    @author: dahijara    2SEP2019    - initial create
    [Arguments]    ${sFilePath}    ${sFileName}    ${userId}    ${createUserId}    ${updateUserId}    ${buySellIndicator}    ${markIndicator}    ${primaryIndicator}    ${riskBookCode}    ${viewPricesIndicator}

    ${Empty_List}    Create List    
    
    ${riskBookCode_List}    Split String    ${riskBookCode}    ,
    ${riskBook_Count}    Get Length    ${riskBookCode_List}
    ${buySellIndicator_List}    Split String    ${buySellIndicator}    ,
    ${markIndicator_List}    Split String    ${markIndicator}    ,
    ${primaryIndicator_List}    Split String    ${primaryIndicator}    ,
    ${viewPricesIndicator_List}    Split String    ${viewPricesIndicator}    ,

    Refresh Tables in LIQ
    mx LoanIQ click    ${LIQ_TableMaintenance_Button}
    
    :FOR    ${INDEX_0}    IN RANGE    ${riskBook_Count}
    \    Exit For Loop If    ${INDEX_0}==${riskBook_Count} or '${riskBookCode}'==''
    \     
    \    ${val_BuySellIndicator}    Get From List    ${buySellIndicator_List}    ${INDEX_0}
	\    ${val_BuySellIndicator}    Run Keyword If    '${val_BuySellIndicator}'=='null'    Set Variable    ${NONE}
	     ...    ELSE IF    '${val_BuySellIndicator}'==''    Set Variable    ${EMPTY}
	     ...    ELSE IF    '${val_BuySellIndicator}'=='Empty' or '${val_BuySellIndicator}'=='empty' or '${val_BuySellIndicator}'=='EMPTY'
	     ...    Set Variable    ${EMPTY}
	     ...    ELSE    Set Variable    ${val_BuySellIndicator}
	\    
    \    ${val_markIndicator}    Get From List    ${markIndicator_List}    ${INDEX_0}
	\    ${val_markIndicator}    Run Keyword If    '${val_markIndicator}'=='null'    Set Variable    ${NONE}
	     ...    ELSE IF    '${val_markIndicator}'==''    Set Variable    ${EMPTY}
	     ...    ELSE IF    '${val_markIndicator}'=='Empty' or '${val_markIndicator}'=='empty' or '${val_markIndicator}'=='EMPTY'
	     ...    Set Variable    ${EMPTY}
	     ...    ELSE    Set Variable    ${val_markIndicator}
	\    
    \    ${val_primaryIndicator}    Get From List    ${primaryIndicator_List}    ${INDEX_0}
	\    ${val_primaryIndicator}    Run Keyword If    '${val_primaryIndicator}'=='null'    Set Variable    ${NONE}
	     ...    ELSE IF    '${val_primaryIndicator}'==''    Set Variable    ${EMPTY}
	     ...    ELSE IF    '${val_primaryIndicator}'=='Empty' or '${val_primaryIndicator}'=='empty' or '${val_primaryIndicator}'=='EMPTY'
	     ...    Set Variable    ${EMPTY}
	     ...    ELSE    Set Variable    ${val_primaryIndicator}
	\    
    \    ${val_riskBookCode}    Get From List    ${riskBookCode_List}    ${INDEX_0}
	\    ${val_riskBookCode}    Run Keyword If    '${val_riskBookCode}'=='null'    Set Variable    ${NONE}
	     ...    ELSE IF    '${val_riskBookCode}'==''    Set Variable    ${EMPTY}
	     ...    ELSE IF    '${val_riskBookCode}'=='Empty' or '${val_riskBookCode}'=='empty' or '${val_riskBookCode}'=='EMPTY'
	     ...    Set Variable    ${EMPTY}
	     ...    ELSE    Set Variable    ${val_riskBookCode}
	\    
    \    ${val_viewPricesIndicator}    Get From List    ${viewPricesIndicator_List}    ${INDEX_0}
	\    ${val_viewPricesIndicator}    Run Keyword If    '${val_viewPricesIndicator}'=='null'    Set Variable    ${NONE}
	     ...    ELSE IF    '${val_viewPricesIndicator}'==''    Set Variable    ${EMPTY}
	     ...    ELSE IF    '${val_viewPricesIndicator}'=='Empty' or '${val_viewPricesIndicator}'=='empty' or '${val_viewPricesIndicator}'=='EMPTY'
	     ...    Set Variable    ${EMPTY}
	     ...    ELSE    Set Variable    ${val_viewPricesIndicator}
	\    
    \    #Get Risk Book Description
    \    Search in Table Maintenance    Risk Book
    \    ${val_RiskBookDesc}    Get Single Description from Table Maintanance    ${val_riskBookCode}    ${LIQ_BrowseRiskBook_Window}
         ...    ${LIQ_BrowseRiskBook_JavaTree}    ${LIQ_BrowseRiskBook_ShowAll_RadioButton}    ${LIQ_BrowseRiskBook_Exit_Button}
	\    
	\    ${RiskBook_JSON}    Create Dictionary
	\    
	\    Set To Dictionary    ${RiskBook_JSON}    createUserId    ${createUserId}
	\    Set To Dictionary    ${RiskBook_JSON}    updateUserId    ${updateUserId}
	\    Set To Dictionary    ${RiskBook_JSON}    riskBookCode    ${val_riskBookCode}
	\    Set To Dictionary    ${RiskBook_JSON}    riskBookDescription    ${val_RiskBookDesc}
	\    Run Keyword If    '${val_BuySellIndicator}'=='no tag'    Set To Dictionary    ${RiskBook_JSON}    primaryIndicator    ${${False}}
	\    Run Keyword If    '${val_BuySellIndicator}'=='no tag'    Set To Dictionary    ${RiskBook_JSON}    viewPricesIndicator    ${${False}}
	\    Run Keyword If    '${val_BuySellIndicator}'=='no tag'    Set To Dictionary    ${RiskBook_JSON}    buySellIndicator    ${${False}}
	\    Run Keyword If    '${val_BuySellIndicator}'=='no tag'    Set To Dictionary    ${RiskBook_JSON}    markIndicator    ${${False}}
	\    Set To Dictionary    ${RiskBook_JSON}    userId    ${userId}
	\    
	\    ${RiskBookSingle_JSON}    Evaluate    json.dumps(${RiskBook_JSON})        json
    \    ${TempJSON_File}    Set Variable    ${sFilePath}${sFileName}_${val_riskBookCode}.json
    \    Delete File If Exist    ${dataset_path}${TempJSON_File}
    \    Create File    ${dataset_path}${TempJSON_File}    ${RiskBookSingle_JSON}
    \    ${TempFile}    OperatingSystem.Get File    ${dataset_path}${TempJSON_File}
    \    
	\    Log    ${RiskBook_JSON}
	\    Append To List    ${Empty_List}    ${RiskBook_JSON}
    
    ${Converted_RiskBook_JSON}    Evaluate    json.dumps(${Empty_List})        json
    Log    ${Converted_RiskBook_JSON}

    ${JSON_File}    Set Variable    ${sFilePath}${sFileName}.json
    Delete File If Exist    ${dataset_path}${JSON_File}
    Create File    ${dataset_path}${JSON_File}    ${Converted_RiskBook_JSON}
    ${file}    OperatingSystem.Get File    ${dataset_path}${JSON_File}
    
    Refresh Tables in LIQ
    
    
GET Request API for Riskbook and Validate if Riskbook is Not Existing
    [Documentation]    This keyword is used to GET request API for Riskbook.
    ...    @author: xmiranda    17SEP2019    - initial create
    ...    @update: cfrancis    30JUN2020    - removed ${Headers} being paseed as a parameter for Get Request API keyword
    [Arguments]    ${sOutputPath}    ${sOutputFile}    ${sRiskBookCode}    ${sUserId}=None   ${sLoginId}=None
    
    Delete All Sessions
    Create Session    ${APISESSION}    ${MDM_HOST_PARTY}
    ${Headers}    Create Dictionary
    
    Run Keyword If    '${sLoginId}'=='None' and '${sUserId}'!='None'    Get Request API    ${sOutputPath}	${sOutputFile}    ${MDM_RISKBOOK_API}${sUserId}/${RISKBOOKS}
    ...    ELSE IF    '${sLoginId}'!='None' and '${sUserId}'=='None'    Get Request API    ${sOutputPath}    ${sOutputFile}    ${MDM_RISKBOOK_API}${RISKBOOK_LOGIN}/${sLoginId}/${RISKBOOKS}
    
    ${RequestBody}    OperatingSystem.Get File    ${dataset_path}${sOutputPath}${sOutputFile}.json  
    
    ${EMPTY_LIST}    Create List
            
    
    Verify Json Response Status Code    ${RESPONSECODE_200}
    
    ${Response_Payload}    OperatingSystem.Get File    ${datasetpath}${sOutputPath}${sOutputFile}.${JSON}          
    ${Response_Payload}    Strip String    ${Response_Payload}    mode=left    characters=[
    ${Response_Payload}    Strip String    ${Response_Payload}    mode=right    characters=]
    
    ${Response_Payload_List}    Split String    ${Response_Payload}    },{
    
    ${JsonCount}    Get Length    ${Response_Payload_List}
    
    :FOR    ${Index_Output}    IN RANGE    ${JsonCount}
    \    Run Keyword If    '${RequestBody}' == '${EMPTY_LIST}'    Run Keywords    Log    Response is Empty
         ...    AND    Exit For Loop
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
    \    Create File    ${dataset_path}${sOutputPath}${sOutputFile}tempfile.json    ${Separated_JSON_Value}
    \    
    \    ### Get JSON field values ###
    \    ${Convert_Object}    OperatingSystem.Get File    ${dataset_path}${sOutputPath}${sOutputFile}tempfile.json
    \    
    \    
    \    
    \    ${Converted_JSON}    Evaluate    json.loads('''${Convert_Object}''')    ${JSON}
    \    
    \    ${Response_RiskBookCode}    Set Variable    ${Converted_JSON}[riskBookCode]
    \    
    \    Run Keyword If    '${Response_RiskBookCode}' != '${sRiskBookCode}'    Log    Risk Book Code deleted successfully
         ...    ELSE IF     '${Response_RiskBookCode}' == '${sRiskBookCode}'      Run Keyword And Continue On Failure    Fail      Risk Book Code was not deleted successfully
    
    
GET Request API for Riskbook and Validate Default Indicator Values are False
    [Documentation]    This keyword is used to GET request API for Riskbook  and validate if default value for indicator is false.
    ...    @author: xmiranda    18SEP2019    - initial create
    ...    @update: cfrancis    06JUL2020    - removed ${Headers} being passed as a parameter for Get Request API Keyword
    [Arguments]    ${sOutputPath}    ${sOutputFile}    ${sUserId}=None   ${sLoginId}=None
    
    Delete All Sessions
    Create Session    ${APISESSION}    ${MDM_HOST_PARTY}
    ${Headers}    Create Dictionary
    
    Run Keyword If    '${sLoginId}'=='None' and '${sUserId}'!='None'    Get Request API    ${sOutputPath}	${sOutputFile}    ${MDM_RISKBOOK_API}${sUserId}/${RISKBOOKS}
    ...    ELSE IF    '${sLoginId}'!='None' and '${sUserId}'=='None'    Get Request API    ${sOutputPath}    ${sOutputFile}    ${MDM_RISKBOOK_API}${RISKBOOK_LOGIN}/${sLoginId}/${RISKBOOKS}
    
    ${RequestBody}    OperatingSystem.Get File    ${dataset_path}${sOutputPath}${sOutputFile}.json  
    
    ${EMPTY_LIST}    Create List
            
    
    Verify Json Response Status Code    ${RESPONSECODE_200}
    
    ${Response_Payload}    OperatingSystem.Get File    ${datasetpath}${sOutputPath}${sOutputFile}.${JSON}          
    ${Response_Payload}    Strip String    ${Response_Payload}    mode=left    characters=[
    ${Response_Payload}    Strip String    ${Response_Payload}    mode=right    characters=]
    
    ${Response_Payload_List}    Split String    ${Response_Payload}    },{
    
    ${JsonCount}    Get Length    ${Response_Payload_List}
    
    :FOR    ${Index_Output}    IN RANGE    ${JsonCount}
    \    Run Keyword If    '${RequestBody}' == '${EMPTY_LIST}'    Run Keywords    Log    Response is Empty
         ...    AND    Exit For Loop
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
    \    Create File    ${dataset_path}${sOutputPath}${sOutputFile}tempfile.json    ${Separated_JSON_Value}
    \    
    \    ### Get JSON field values ###
    \    ${Convert_Object}    OperatingSystem.Get File    ${dataset_path}${sOutputPath}${sOutputFile}tempfile.json
    \    
    \    ${Converted_JSON}    Evaluate    json.loads('''${Convert_Object}''')    ${JSON}
    \    
    \    ${Response_MarkIndicator}    Set Variable    ${Converted_JSON}[markIndicator]
    \    ${Response_ViewPricesIndicator}    Set Variable    ${Converted_JSON}[viewPricesIndicator]
    \    ${Response_PrimaryIndicator}    Set Variable    ${Converted_JSON}[primaryIndicator]
    \    ${Response_BuySellIndicator}    Set Variable    ${Converted_JSON}[buySellIndicator]
    \    
    \    Run Keyword If    ${Response_MarkIndicator} == ${${False}}    Log    markIndicator default value is false.
         ...    ELSE IF    ${Response_MarkIndicator} == ${${True}}    Run Keyword And Continue On Failure    Fail    markIndicator default value should be false, found true
    \    
    \    Run Keyword If    ${Response_ViewPricesIndicator} == ${${False}}    Log    viewPricesIndicator default value is false.
         ...    ELSE IF    ${Response_ViewPricesIndicator} == ${${True}}    Run Keyword And Continue On Failure    Fail    viewPricesIndicator default value should be false, found true
    \    
    \    Run Keyword If    ${Response_PrimaryIndicator} == ${${False}}    Log    primaryIndicator default value is false.
         ...    ELSE IF    ${Response_PrimaryIndicator} == ${${True}}    Run Keyword And Continue On Failure    Fail    primaryIndicator default value should be false, found true
    \    
    \    Run Keyword If    ${Response_BuySellIndicator} == ${${False}}    Log    buySellIndicator default value is false.
         ...    ELSE IF    ${Response_BuySellIndicator} == ${${True}}    Run Keyword And Continue On Failure    Fail    buySellIndicator default value should be false, found true
    \

GET Request API for Riskbook and Verify Response Status Code 404
    [Documentation]    This keyword is used to GET request API for Riskbook.
    ...    @author: xmiranda    22OCT2019    - initial create
    ...    @update: cfrancis    03JUL2020    - removed passing ${Headers} as a parameter being passed onto Get Request API keyword
    [Arguments]    ${sOutputPath}    ${sOutputFile}    ${sUserId}=None   ${sLoginId}=None
    
    Delete All Sessions
    Create Session    ${APISESSION}    ${MDM_HOST_PARTY}
    ${Headers}    Create Dictionary
    
    Run Keyword If    '${sLoginId}'=='None' and '${sUserId}'!='None'    Get Request API    ${sOutputPath}	${sOutputFile}    ${MDM_RISKBOOK_API}${sUserId}/${RISKBOOKS}
    ...    ELSE IF    '${sLoginId}'!='None' and '${sUserId}'=='None'    Get Request API    ${sOutputPath}    ${sOutputFile}    ${MDM_RISKBOOK_API}${RISKBOOK_LOGIN}/${sLoginId}/${RISKBOOKS}
    
    ${RequestBody}    OperatingSystem.Get File    ${dataset_path}${sOutputPath}${sOutputFile}.json  
    
    ${Message}    Convert To String    ${API_RESPONSE.content}
    Should Contain    ${Message}    ${MESSAGE_OBJECTNOTFOUND}    
    Verify Json Response Status Code    ${RESPONSECODE_404}
    
    
PUT Request for Risk Book API and Verify Response Status Code 400
    [Documentation]    This keyword is used to PUT Request for Riskbook API and verifies if the response status code returned is 400
    ...    @author: xmiranda    23OCT2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sInputJson}    ${sOutputFilePath}    ${sOutputAPIResponse}    ${sUserId}=None    ${sLoginId}=None

    Delete All Sessions
    Create Session    ${APISESSION}    ${MDM_HOST_PARTY}
    Run Keyword If    '${sUserId}'=='None' and '${sLoginId}'!='None'    Put Json File    ${sInputFilePath}    ${sInputJson}
    ...    ${MDM_RISKBOOK_API}/${RISKBOOK_LOGIN}/${sLoginID}/${RISKBOOKS}    ${sOutputFilePath}    ${sOutputAPIResponse}
    ...    ELSE IF    '${sUserId}'!='None' and '${sLoginId}'=='None'    Put Json File    ${sInputFilePath}    ${sInputJson}
    ...    ${MDM_RISKBOOK_API}${sUserID}/${RISKBOOKS}    ${sOutputFilePath}    ${sOutputAPIResponse}
    
    ${Message}    Convert To String    ${API_RESPONSE.content}
    Should Contain    ${Message}    ${MESSAGE_NOTAVALIDCODE}    
    Verify Json Response Status Code    ${RESPONSECODE_400}
    
PUT Request for Risk Book API and Verify Response Status Code 404
    [Documentation]    This keyword is used to PUT Request for Riskbook API and verifies if the response status code returned is 404
    ...    @author: xmiranda    23OCT2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sInputJson}    ${sOutputFilePath}    ${sOutputAPIResponse}    ${sUserId}=None    ${sLoginId}=None

    Delete All Sessions
    Create Session    ${APISESSION}    ${MDM_HOST_PARTY}
    Run Keyword If    '${sUserId}'=='None' and '${sLoginId}'!='None'    Put Json File    ${sInputFilePath}    ${sInputJson}
    ...    ${MDM_RISKBOOK_API}/${RISKBOOK_LOGIN}/${sLoginID}/${RISKBOOKS}    ${sOutputFilePath}    ${sOutputAPIResponse}
    ...    ELSE IF    '${sUserId}'!='None' and '${sLoginId}'=='None'    Put Json File    ${sInputFilePath}    ${sInputJson}
    ...    ${MDM_RISKBOOK_API}${sUserID}/${RISKBOOKS}    ${sOutputFilePath}    ${sOutputAPIResponse}
    
    ${Message}    Convert To String    ${API_RESPONSE.content}
    
    Run Keyword If    '${sUserId}'=='None' and '${sLoginId}'!='None'    Should Contain    ${Message}    ${MESSAGE_OBJECTNOTFOUND}
    ...    ELSE IF    '${sUserId}'!='None' and '${sLoginId}'=='None'    Should Contain    ${Message}    ${MESSAGE_USERIDNOTONFILE}    
 
    Verify Json Response Status Code    ${RESPONSECODE_404}

PUT Request for Risk Book API and Verify Response Status Code 400 and Exception Message
    [Documentation]    This keyword is used to PUT Request for Riskbook API and verifies if the response status code returned is 400 and exception in the response message
    ...    @author: xmiranda    24OCT2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sInputJson}    ${sOutputFilePath}    ${sOutputAPIResponse}    ${sUserId}=None    ${sLoginId}=None

    Delete All Sessions
    Create Session    ${APISESSION}    ${MDM_HOST_PARTY}
    Run Keyword If    '${sUserId}'=='None' and '${sLoginId}'!='None'    Put Json File    ${sInputFilePath}    ${sInputJson}
    ...    ${MDM_RISKBOOK_API}/${RISKBOOK_LOGIN}/${sLoginID}/${RISKBOOKS}    ${sOutputFilePath}    ${sOutputAPIResponse}
    ...    ELSE IF    '${sUserId}'!='None' and '${sLoginId}'=='None'    Put Json File    ${sInputFilePath}    ${sInputJson}
    ...    ${MDM_RISKBOOK_API}${sUserID}/${RISKBOOKS}    ${sOutputFilePath}    ${sOutputAPIResponse}
    
    Verify Json Response Status Code    ${RESPONSECODE_400}
    
    ${Message}    Convert To String    ${API_RESPONSE.content}
    
    ${Status1}    Run Keyword And Return Status    Should Contain    ${Message}    ${MESSAGE_EXCEPTION}
    Run Keyword If    ${Status1} == ${True}    Log    Response Status Code is 400 and Response Message has an Exception
    ...    ELSE    Log    Response Message does not contain an Exception
    
    ${Status2}    Run Keyword And Return Status    Should Contain    ${Message}    ${MESSAGE_EMPTYARRAY}
    Run Keyword If    ${Status2} == ${True}    Log    Response Status Code is 400 and Response Message has an Error: Payload must contain at least 1 Riskbook
    ...    ELSE    Log    Response Message does not contain an Empty Array Error    
    
    Run Keyword If    ${Status1} == ${Status2}    Fail    Response Status Code and Message Validation Error     
    

DELETE Request API for Riskbook and Verify Response Status Code 404
    [Documentation]    This keyword is used to DELETE Request for Riskbook API and verifies if the response status code returned is 404
    ...    @author: dahijara    23OCT2019    - initial create
    ...    @update: cfrancis    06JUL2020    - updated to use ${Message} instead of $${API_RESPONSE.content} for Create File keyword
    [Arguments]    ${sInputPath}    ${sInputFile}    ${sOutputPath}    ${sOutputFile}    ${sUserId}=None    ${sLoginId}=None
    
    Delete All Sessions
    Create Session    ${APISESSION}    ${MDM_HOST_PARTY}
    
    ${Headers}    Create Dictionary
    
    ${RequestBody}    OperatingSystem.Get File    ${dataset_path}${sInputPath}${sInputFile}.json    
    
    ${API_RESPONSE}    Run Keyword If    '${sUserId}'!='None' and '${sLoginId}'=='None'    Delete Request    ${APISESSION}    ${MDM_RISKBOOK_API}${sUserId}/${RISKBOOKS}    ${RequestBody}    ${Headers}
    ...    ELSE IF    '${sUserId}'=='None' and '${sLoginId}'!='None'    Delete Request    ${APISESSION}    ${MDM_RISKBOOK_API}${RISKBOOK_LOGIN}/${sLoginId}/${RISKBOOKS}    ${RequestBody}    ${Headers}

    Set Global Variable    ${API_RESPONSE}
    ${Message}    Convert To String    ${API_RESPONSE.content}
    Should Contain    ${Message}    ${MESSAGE_OBJECTNOTFOUND}    
    Verify Json Response Status Code    ${RESPONSECODE_404}
    Create File    ${dataset_path}${sOutputPath}${sOutputFile}.json    ${Message}
    
DELETE Request API for Riskbook and Verify Response Status Code 400 and Response Message
    [Documentation]    This keyword is used to DELETE Request for Riskbook API and verifies if the response status code returned is 400
    ...    @author: xmiranda    28OCT2019    - initial create
    ...    @update: cfrancis    06JUL2020    - updated to use ${Message} instead of $${API_RESPONSE.content} for Create File keyword
    [Arguments]    ${sInputPath}    ${sInputFile}    ${sOutputPath}    ${sOutputFile}    ${sUserId}=None    ${sLoginId}=None
    
    Delete All Sessions
    Create Session    ${APISESSION}    ${MDM_HOST_PARTY}
    
    ${Headers}    Create Dictionary
    
    ${RequestBody}    OperatingSystem.Get File    ${dataset_path}${sInputPath}${sInputFile}.json    
    
    ${API_RESPONSE}    Run Keyword If    '${sUserId}'!='None' and '${sLoginId}'=='None'    Delete Request    ${APISESSION}    ${MDM_RISKBOOK_API}${sUserId}/${RISKBOOKS}    ${RequestBody}    ${Headers}
    ...    ELSE IF    '${sUserId}'=='None' and '${sLoginId}'!='None'    Delete Request    ${APISESSION}    ${MDM_RISKBOOK_API}${RISKBOOK_LOGIN}/${sLoginId}/${RISKBOOKS}    ${RequestBody}    ${Headers}

    Set Global Variable    ${API_RESPONSE}
    ${Message}    Convert To String    ${API_RESPONSE.content}
    Should Contain    ${Message}    ${MESSAGE_ITEMNOTASSIGNED}    
    Verify Json Response Status Code    ${RESPONSECODE_400}
    Create File    ${dataset_path}${sOutputPath}${sOutputFile}.json    ${Message}