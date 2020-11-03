*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Post Json File And Return Access Token
    [Documentation]    This keyword will post the payload and will generate the access token.
    ...    @author: mnanquil    26FEB2019    initial draft
    ...    @update: clanding    22MAR2019    - added ${dataset_path} and .json file extension, refactor
    [Arguments]    ${sInputPath}    ${sInputFile}    ${sAPIEndpoint}
    
    &{Headers}    Create Dictionary    Content-Type=application/json; charset=utf-8
    ${Inputjsonfile}    OperatingSystem.Get File    ${dataset_path}${sInputPath}${sInputfile}.json
    ${POSTResp}    Post Request    ${TOKENSESSION}    ${sAPIEndpoint}    ${Inputjsonfile}    headers=${Headers}
    Set Global Variable    ${POSTResp}
    Log    POST Json Response: ${POSTResp.content}
    Should Be Equal    ${POSTResp.status_code}    ${200}
    ${accessToken}    Evaluate    $POSTResp.json().get("access_token")
    Log    ${accessToken}
    Delete All Sessions
    ${accessToken}    Set Variable    Bearer ${accessToken}
    Set Global Variable    ${AUTH_TOKEN}    ${accessToken}
    [Return]    ${accessToken}

Post Json File
    [Documentation]    Send a Post Request using sAPIEndPoint and sAccessToken. Data to be sent is from sInputFile
    ...    and response will be saved to sOutputFile.
    ...    @update: mnanquil    26FEB2019    - added optional argument to handle adding of access token.
    ...    @update: clanding    22MAR2019    - added ${dataset_path} and .json file extension, refactor
    ...    @update: rtarayao    14JAN2020    - added optional argument to handle request with Zone as one of the headers
    [Arguments]    ${sInputPath}    ${sInputFile}    ${sAPIEndPoint}    ${sOutputPath}    ${sOutputFile}    ${sAccessToken}=None    ${sZone}=None
    
    &{Headers1}    Run Keyword If    '${sAccessToken}' != 'None' and '${sZone}' != 'None'    Create Dictionary    Content-Type=application/json    Zone=${sZone}    Authorization=${sAccessToken}
    ...    ELSE IF    '${sAccessToken}' != 'None' and '${sZone}' == 'None'    Create Dictionary    Content-Type=application/json    Authorization=${sAccessToken}
    ...    ELSE IF    '${sAccessToken}' == 'None' and '${sZone}'=='None'    Create Dictionary    Content-Type=application/json; charset=utf-8;
    ...    ELSE IF    '${sAccessToken}' == 'None' and '${sZone}' != 'None'    Create Dictionary    Content-Type=application/json    charset=utf-8    Zone=${sZone}
    Set Global Variable    ${Headers}    &{Headers1}

    ${InputJsonFile}    OperatingSystem.Get File    ${dataset_path}${sInputPath}${sInputFile}.json
    ${API_RESPONSE}    Post Request    ${APISESSION}    ${sAPIEndPoint}    ${InputJsonFile}    headers=${Headers}
    Set Global Variable    ${API_RESPONSE}
    Log    POST Json Response: ${API_RESPONSE.content}
    ${API_RESPONSE_STRING}    Convert To String    ${API_RESPONSE.content}
    Create file    ${dataset_path}${sOutputPath}${sOutputFile}.json    ${API_RESPONSE_STRING}
    ${RESPONSE_FILE}    OperatingSystem.Get File    ${dataset_path}${sOutputPath}${sOutputFile}.json
    Log    ${RESPONSE_FILE}
    Set Global Variable    ${RESPONSE_FILE}
    [Return]    ${API_RESPONSE.content}    

Verify Json Response Status Code
    [Documentation]    This keyword is used to verify if response status code is equal to expected response status code.
    ...    @author: clanding    22MAR2019    - initial create
    [Arguments]    ${iExpected_ResponseCode}
    
    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${iExpected_ResponseCode}    ${API_RESPONSE.status_code}
    ${Resp_Status}    Run Keyword And Return Status    Should Be Equal As Strings    ${iExpected_ResponseCode}    ${API_RESPONSE.status_code}
    Run Keyword If    ${Resp_Status}==${True}    Log    Response Status Code are matched! ${iExpected_ResponseCode} == ${API_RESPONSE.status_code}     
    ...    ELSE IF    ${Resp_Status}==${False}    Log    Response Status Code are NOT matched! ${iExpected_ResponseCode} != ${API_RESPONSE.status_code}    level=ERROR
    
    Log    JSON Request has been created.
    ${Resp_Stat_Code}    Convert To String    ${API_RESPONSE.status_code}
    Set Global Variable    ${Resp_Stat_Code}
    
GET Request API for Comsee Deal Facility
    [Documentation]    This keyword is used to GET request. 
    ...    @author: sacuisia    07AUG2019
    [Arguments]    ${HOST}    ${sAPIEndpoint}    ${Headers}        
    
    &{Headers}    Create Dictionary    ${X_REQUEST_ID}=${Headers}
    Log    ${Headers}  
    ${GET_response}    Get Request    COMHOST    ${sAPIEndpoint}${SESSIONID}    headers=${Headers}
    Set Global Variable    ${GET_response}
    Log    GET Json Response:${GET_response.content}
    Should Be Equal    ${GET_response.status_code}    ${200}    
    Log    ${GET_response.content}
    Log    ${GET_response.status_code}
    ${REQUEST_DATA}    Set Variable    ${GET_response.json()}
    [Return]    ${REQUEST_DATA}  

GET Request API for Comsee Outstandings and Fees
    [Documentation]    This keyword is used to GET request. 
    ...    @author: sacuisia    07AUG2019
    [Arguments]    ${HOST}    ${sAPIEndpoint}    ${Headers}        
    
    &{Headers}    Create Dictionary    ${X_REQUEST_ID}=${Headers}
    Log    ${Headers}  
    ${GET_response}    Get Request    COMHOST    ${sAPIEndpoint}${SESSIONID}/${SESSION_0}${APIENDPOINT_0}    headers=${Headers}
    Set Global Variable    ${GET_response}
    Log    GET Json Response:${GET_response.content}
    Should Be Equal    ${GET_response.status_code}    ${200}    
    Log    ${GET_response.content}
    Log    ${GET_response.status_code}
    ${REQUEST_DATA_VAL}    Set Variable    ${GET_response.json()}
    [Return]    ${REQUEST_DATA_VAL}  
    
GET Request API for Comsee Deal Facility 404 Response
    [Documentation]    This keyword is used to GET request for 404 response status code. 
    ...    @author: sacuisia    15AUG2019
    [Arguments]    ${HOST}    ${sAPIEndpoint}    ${Headers}        
    
    &{Headers}    Create Dictionary    ${X_REQUEST_ID}=${Headers}
    Log    ${Headers}  
    ${GET_response}    Get Request    COMHOST    ${sAPIEndpoint}${SESSIONID}/${SESSION_0}${APIENDPOINT_0}    headers=${Headers}
    Set Global Variable    ${GET_response}
    Log    GET Json Response:${GET_response.content}
    Should Be Equal    ${GET_response.status_code}    ${404}    
    Log    ${GET_response.content}
    Log    ${GET_response.status_code}
    ${REQUEST_DATA_VAL}    Set Variable    ${GET_response.json()}
    [Return]    ${REQUEST_DATA_VAL}    

Check for Technical Error Message
    [Documentation]    This keyword is used to check for correct technical error message in the response.
    ...    @author: jloretiz    12DEC2019    - initial create
    [Arguments]    ${sErrorMessage}
    
    Log    ${RESPONSE_FILE}
    ${ErrFlag}    Run Keyword And Return Status    Should Contain    ${RESPONSE_FILE}    ${sErrorMessage}
    Run Keyword If    ${ErrFlag}==${True}    Log    Technical Error Message is Correct. Error Message ${sErrorMessage} exists.
    ...    ELSE    Log    Technical Error Message " ${sErrorMessage} "" does not exist!    level=ERROR

Compare API Request and Response
    [Documentation]    This keyword is used to compare input API request and API reponse from created session.
    ...    @author: clanding    22MAR2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sFileName}
    
    ${InputJSON}    OperatingSystem.Get File    ${dataset_path}${sInputFilePath}${sFileName}.json   
    Run Keyword And Continue On Failure    Mx Compare Json Data    ${InputJSON}     ${RESPONSE_FILE}
    
    ${Stat}    Run Keyword And Return Status    Mx Compare Json Data    ${InputJSON}     ${RESPONSE_FILE}
    Run Keyword If    ${Stat}==${True}    Log    Input and Output JSON Files are matched. ${InputJSON} == ${RESPONSE_FILE}
    ...    ELSE    Log    Input and Output JSON Files does not matched. ${InputJSON} != ${RESPONSE_FILE}    level=ERROR

Put Json File
    [Documentation]    Send a Put Request using sAPIEndPoint and sAccessToken. Data to be sent is from sInputFile
    ...    and response will be saved to sOutputFile.
    ...    @update: mnanquil    26FEB2019    Added optional argument to handle adding of access token.
    ...    @update: clanding    22MAR2019    - added ${dataset_path} and .json file extension, refactor and added token handling
    ...    @update: mnanquil    17APR2019    - return api response content.
    ...    @update: dahijara    07SEP2019    - Added code to generate timestamp after submitting the request the request.
    [Arguments]    ${sInputPath}    ${sInputFile}    ${sAPIEndPoint}    ${sOutputPath}    ${sOutputFile}    ${sAccessToken}=None
    
    &{Headers1}    Run Keyword If    '${sAccessToken}' != 'None'    Create Dictionary    Content-Type=application/json    Authorization=${sAccessToken}
    Run Keyword If    '${sAccessToken}' != 'None'    Set Global Variable    ${Headers}    &{Headers1}
    &{Headers2}    Run Keyword If    '${sAccessToken}' == 'None'    Create Dictionary    Content-Type=application/json; charset=utf-8;
    Run Keyword If    '${sAccessToken}' == 'None'    Set Global Variable    ${Headers}    &{Headers2}
    ${InputJsonFile}    OperatingSystem.Get File    ${dataset_path}${sInputPath}${sInputFile}.json
    ${API_RESPONSE}    Put Request    ${APISESSION}    ${sAPIEndPoint}    ${InputJsonFile}    headers=${Headers}
    ${PUTREQUEST_TIMESTAMP}    Get Current Date    UTC    + 8 Hour    result_format=%Y-%m-%dT%H:
    
    Set Global Variable    ${PUTREQUEST_TIMESTAMP}
    Set Global Variable    ${API_RESPONSE}
    Log    PUT Json Response: ${API_RESPONSE.content}
    ${API_RESPONSE_STRING}    Convert To String    ${API_RESPONSE.content}
    Create file    ${dataset_path}${sOutputPath}${sOutputFile}.json    ${API_RESPONSE_STRING}

    ${RESPONSE_FILE}    OperatingSystem.Get File    ${dataset_path}${sOutputPath}${sOutputFile}.json
    Log    ${RESPONSE_FILE}
    Set Global Variable    ${RESPONSE_FILE}
    [Return]    ${API_RESPONSE.content}    

Delete Request and Store Response
    [Documentation]    Send a Delete Request using sAPIEndPoint and sAccessToken and response is stored in a variable
    ...    @update: clanding    22MAR2019    - added ${dataset_path} and .json file extension, refactor and added token handling
    ...    @update: amansuet    19AUG2019    - removed json file validation, response is stored in a variable
    [Arguments]    ${sAPIEndPoint}    ${sAccessToken}=None
    
    &{Headers1}    Run Keyword If    '${sAccessToken}' != 'None'    Create Dictionary    Content-Type=application/json    Authorization=${sAccessToken}
    Run Keyword If    '${sAccessToken}' != 'None'    Set Global Variable    ${Headers}    &{Headers1}
    &{Headers2}    Run Keyword If    '${sAccessToken}' == 'None'    Create Dictionary    Content-Type=application/json; charset=utf-8;
    Run Keyword If    '${sAccessToken}' == 'None'    Set Global Variable    ${Headers}    &{Headers2}
    ${API_RESPONSE}    Delete Request    ${APISESSION}    ${sAPIEndPoint}    headers=${Headers}
    Set Global Variable    ${API_RESPONSE}
    Log    POST Json Response: ${API_RESPONSE.content}
    Set Global Variable    ${RESPONSE_FILE}    ${API_RESPONSE.content}

Validate Delete Response Empty
    [Documentation]    This keyword is used to verify if Output Response File is empty.
    ...    @update: clanding    22MAR2019    - added Documentation and refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1, added token handling
    [Arguments]    ${sFileName}
    
    Run Keyword And Continue On Failure    File Should Be Empty    ${sFileName}
    ${ResponseIsEmpty}    Run Keyword And Return Status    File Should Be Empty    ${sFileName}    
    Run Keyword If    ${ResponseIsEmpty}==${True}    Log    Response for Delete is Empty.
    ...    ELSE IF    ${ResponseIsEmpty}==${False}    Log    Response for Delete is NOT Empty.    level=ERROR

Get Request API
    [Documentation]    This keyword is used to perform Get Request for Commsee functionality.
    ...    @author: clanding    20AUG2019    - initial create
    ...    @update: rtarayao    07FEB2020    - added optional argument to handle request with Zone as one of the headers
    [Arguments]    ${sOutputPath}    ${sOutputFile}    ${sEndPoint}    ${sZone}=None
    
    &{Headers1}    Run Keyword If    '${sZone}' != 'None'    Create Dictionary    Content-Type=application/json    Zone=${sZone}
    ...    ELSE IF    '${sZone}' == 'None'    Create Dictionary    Content-Type=application/json
    Set Global Variable    ${Headers}    &{Headers1}
    
    ${API_RESPONSE}    Get Request    ${APISESSION}    ${sEndPoint}   headers=${Headers}
    Set Global Variable    ${API_RESPONSE}
    Log    Get Json Response: ${API_RESPONSE.content}
    Delete File If Exist    ${dataset_path}${sOutputPath}${sOutputFile}.json
    ${API_RESPONSE_STRING}    Convert To String    ${API_RESPONSE.content}
    Create file    ${dataset_path}${sOutputPath}${sOutputFile}.json    ${API_RESPONSE_STRING}
    ${RESPONSE_FILE}    OperatingSystem.Get File    ${dataset_path}${sOutputPath}${sOutputFile}.json
    Log    ${RESPONSE_FILE}
    Set Global Variable    ${RESPONSE_FILE}
    
###JSON KEYWORDS###
Add Item to JSON file
    [Documentation]    This keyword is used to get field value from JSON file using field name
    ...    e.g. var    Add Item to JSON file    file_path    cluster    AUD
    ...    @author: clanding
    [Arguments]    ${file_path}    ${field_name}    ${field_value}
    ${json_object}    Load JSON From File    ${file_path}
    ${new_json}    Update Value To Json    ${json_object}    $..${field_name}    ${field_value}
    Log    ${new_json}
    ${converted_json}    Evaluate    json.dumps(${new_json})        json
    Log    ${converted_json}
    Delete File If Exist    ${file_path}
    Create File    ${file_path}    ${converted_json}

Get Data from JSON file
    [Documentation]    This keyword is used to get field value from JSON file using field name
    ...    e.g. var    Get Data from JSON file    file_path    cluster
    ...    @author: clanding
    [Arguments]    ${file_path}    ${field_name}
    ${json_object}    Load JSON From File    ${file_path}
    ${temp}    Get Value From Json    ${json_object[0]}    $..${field_name}
    Log    ${field_name}
    ${field_value}    Get From List    ${temp}    0
    [Return]     ${field_value}

Split Reason
    [Documentation]    This keyword is used to split "reason: Reason Message" compare with expected error.
    ...    @author: clanding
    [Arguments]    ${Expected_Error_File}    ${REASON}    ${Loop}
    ${ReasonName}    Set Variable    Error_
    @{Splitted_String}=    Split String    ${REASON}    :
    ${reason_string}=    Get From List    ${Splitted_String}    0
    @{Splitted_String1}=    Split String    ${reason_string}    "
    ${reason_string}=    Get From List    ${Splitted_String1}    1
    Run Keyword And Continue On Failure    Should Be Equal   ${reason_string}    reason
    ${result}    Run Keyword And Return Status    Run Keyword And Continue On Failure    Should Be Equal   ${reason_string}    reason
    Run Keyword If   '${result}'=='True'    Log    ${reason_string} is correct.
    ...     ELSE    Log    Value is not ${reason_string}.
    ${REASON}=    Get From List    ${Splitted_String}    1
    @{Splitted_String}=    Split String    ${REASON}    "
    ${REASON}=    Get From List    ${Splitted_String}    1
    Set Test Variable    ${${ReasonName}${Loop}}    ${REASON}
    Set Global Variable    ${${ReasonName}${Loop}}
    ${Expected_Error_List}=    OperatingSystem.Get File    ${Expected_Error_File}
    Run Keyword And Continue On Failure    Should Contain    ${Expected_Error_List}    ${${ReasonName}${Loop}}

Get Reason from Modal Error Rate and compare with Expected Error
    [Documentation]    This keyword is used to get reason for modal error rate and compare with expected error.
    ...    @author: clanding
    [Arguments]    ${Actual_Error_File}
    ${Partial_Err}    Get Substring    ${Response_file}    0    24
    ${Expected_Error_List}    OperatingSystem.Get File    ${Expected_Err_List}
    Run Keyword And Continue On Failure    Should Contain    ${Expected_Error_List}    ${Partial_Err}
    ${err_stat}    Run Keyword And Return Status    Should Contain    ${Expected_Error_List}    ${Partial_Err}
    Delete File If Exist    ${Actual_Error_File}
    Run Keyword If    ${err_stat}==True    Append To File    ${Actual_Error_File}    ${Partial_Err}${\n}
    ${File1}    Get File Size    ${Actual_Error_File}
    ${File2}    Get File Size    ${Expected_Err_List}
    Run Keyword And Continue On Failure    Should Be Equal    ${File1}    ${File2}

Get Reason from Modal Error Date and compare with Expected Error
    [Documentation]    This keyword is used to get reason for modal error date and compare with expected error.
    ...    @author: clanding
    [Arguments]    ${Actual_Error_File}
    ${Partial_Err}    Get Substring    ${Response_file}    0    14
    ${Expected_Error_List}    OperatingSystem.Get File    ${Expected_Err_List}
    Run Keyword And Continue On Failure    Should Contain    ${Expected_Error_List}    ${Partial_Err}
    ${err_stat}    Run Keyword And Return Status    Should Contain    ${Expected_Error_List}    ${Partial_Err}
    Delete File If Exist    ${Actual_Error_File}
    Run Keyword If    ${err_stat}==True    Append To File    ${Actual_Error_File}    ${Partial_Err}${\n}
    ${File1}    Get File Size    ${Actual_Error_File}
    ${File2}    Get File Size    ${Expected_Err_List}
    Run Keyword And Continue On Failure    Should Be Equal    ${File1}    ${File2}

Get Reason from Parse Error Date and compare with Expected Error
    [Arguments]    ${Actual_Error_File}
    ${Partial_Err}    Get Substring    ${Response_file}    0    12
    ${Expected_Error_List}    OperatingSystem.Get File    ${Expected_Err_List}
    Run Keyword And Continue On Failure    Should Contain    ${Expected_Error_List}    ${Partial_Err}
    ${err_stat}    Run Keyword And Return Status    Should Contain    ${Expected_Error_List}    ${Partial_Err}
    Delete File If Exist    ${Actual_Error_File}
    Run Keyword If    ${err_stat}==True    Append To File    ${Actual_Error_File}    ${Partial_Err}${\n}
    ${File1}    Get File Size    ${Actual_Error_File}
    ${File2}    Get File Size    ${Expected_Err_List}
    Run Keyword And Continue On Failure    Should Be Equal    ${File1}    ${File2}

Get Data from JSON file Calendar
    [Arguments]    ${file_path}    ${field_name}
    [Documentation]    This keyword is used to get field value from JSON file using field name
    ...    e.g. var    Get Data from JSON file    file_path    cluster    var1
    ...    @author: jaquitan
    ${json_object}    Load JSON From File    ${file_path}
    ${temp}    Get Value From Json    ${json_object}    $..${field_name}
    Log    ${field_name}
    ${field_value}    Get From List    ${temp}    0
    [Return]     ${field_value}

# Get Data from JSON file Calendar WeeklyHolidays
    # [Arguments]    ${file_path}    ${field_name}
    # [Documentation]    This keyword is used to get field value from JSON file using field name
    # ...    It checks if weekly holidays is empty, then set to default values
    # ...    If weekly holidays is not empty, get the appropriate values based on payload
    # ...    e.g. var    Get Data from JSON file    file_path    cluster    var1
    # ...    @author: jaquitan
    # ${json_object}    Load JSON From File    ${file_path}
    # ${temp}    Get Value From Json    ${json_object}    $..${field_name}
    # Log    ${field_name}

    # ${count}    Get Length    ${temp}
    # ${empty}    Run Keyword And Return Status     Should Be Equal As Integers    ${count}    0
    # ${friday}    ${saturday}    ${sunday}    Run Keyword if    ${empty}==True    Set Default Weekly Holiday Values
    # ...    ELSE    Get Weekly Holiday Values    ${temp}
    # [Return]     ${friday}    ${saturday}    ${sunday}

Get Data from JSON file Calendar BusinessAndNonBusinessDates
    [Arguments]    ${file_path}    ${field_name}
    [Documentation]    This keyword is used to get field value with array of arrays
    ...    e.g "nonBusinessDates": [{"dateValue": "2018-12-25", "reason": "Christmas Day" }, {  "dateValue": "2018-12-30",  "reason": "Rizal Day"  }  ]
    ...    It returns {"dateValue": "2018-12-25", "reason": "Christmas Day" }, {  "dateValue": "2018-12-30",  "reason": "Rizal Day"  }
    ...    It checks if field_name empty
    ...    @author: jaquitan
    ${json_object}    Load JSON From File    ${file_path}
    ${temp}    Get Value From Json    ${json_object}    $..${field_name}
    ${count}    Get Length    ${temp}
    ${empty}    Run Keyword And Return Status    Should Be Equal As Integers    ${count}    0
    ${return_value}    Run Keyword if    ${empty}==True    Log    ${field_name} is empty
    ...    ELSE    Get From List    ${temp}    0

    # ${temp1}    Get From List    ${temp}    0
    # ${max_count}    Get Length    ${temp1}
    # Log To Console    ${max_count}

    [Return]    ${return_value}

ValidateBusinessDay
    [Documentation]    This keyword is to map Boolean values to Y or N flag in Holiday Calendars business day
    ...    @author: jaquitan
    [Arguments]    ${businessDay}    ${booleanDay}
    ${booleanvalue}    Run Keyword And Return Status    Should Be Equal As Strings    ${booleanDay}    true
    Run Keyword If    '${booleanvalue}'=='True'    Should Be Equal As Strings    ${businessDay}    Y
    ...    ELSE IF    '${booleanvalue}'=='False'   Should Be Equal As Strings    ${businessDay}    N
    ...    ELSE    Log    Incorrect Flag
    Log    ${booleanvalue}
    Log    ${businessDay}

Get Data from JSON file and handle None for FX Rate
    [Documentation]    This keyword is used to get field value from JSON file using field name
    ...    e.g. var    Get Data from JSON file    file_path    cluster
    ...    @author: clanding
    [Arguments]    ${file_path}    ${field_name}
    ${json_object}    Load JSON From File    ${file_path}
    ${temp}    Get Value From Json    ${json_object[0]}    $..${field_name}
    ${temp_length}    Get Length    ${temp}
    # ${field_value}    Get From List    ${temp}    0
    # ${field_value}    Run Keyword If    ${temp_length}==1 or ${temp_length}>1    Set Variable    ${field_value}
    ${field_value}    Run Keyword If    ${temp_length}==1 or ${temp_length}>1    Get From List    ${temp}    0
    [Return]     ${field_value}

Get Data from JSON file and handle no output for FX Rate
    [Documentation]    This keyword is used to get field value from JSON file using field name
    ...    e.g. var    Get Data from JSON file    file_path    cluster
    ...    @author: clanding
    [Arguments]    ${file_path}    ${field_name}    ${min}    ${max}
    ${json_object}    Load JSON From File    ${file_path}
    ${field_value_list}    Get Value From Json    ${json_object}    $..${field_name}
    ${field_value_length}    Get Length    ${field_value_list}
    ${field_value}    Run Keyword If    ${field_value_length}>0    Get From List    ${field_value_list}     0
    ${field_value}    Convert To String    ${field_value}

    #when value is ""
    ${field_value_empty}    Run Keyword And Return Status    Should Be Empty    ${field_value}
    #when value is null or tag is removed
    ${field_None}    Run Keyword And Return Status    Should Be Equal As Strings    ${field_value}    None
    ${field_value_length}    Run Keyword If    ${field_None}==False    Get Length    ${field_value}

    ${key}    Run Keyword If    ${field_None}==True and ${field_value_empty}==False      Set Variable    True
    ...    ELSE    Set Variable    False
    ${val}    Run Keyword If    ${key}==False    Evaluate Field Value    ${field_None}    ${field_value_empty}    ${field_value_length}    ${min}    ${max}

    [Return]     ${val}    ${key}

Get Data From JSON File and Handle No Output
    [Documentation]    This keyword is used to get field value from JSON file using field name
    ...    @author: clanding    28MAR2019    - initial create
    [Arguments]    ${sFilePath}    ${sFieldName}    ${iMinValue}    ${iMaxValue}
    
    ${JSON_Object}    Load JSON From File    ${dataset_path}${sFilePath}.json
    ${Field_Value_List}    Get Value From Json    ${JSON_Object}    $..${sFieldName}
    ${Field_Value_Length}    Get Length    ${Field_Value_List}
    ${Field_Value}    Run Keyword If    ${Field_Value_Length}>0    Get From List    ${Field_Value_List}     0
    ${Field_Value}    Convert To String    ${Field_Value}

    ${Field_Value_Empty}    Run Keyword And Return Status    Should Be Empty    ${Field_Value}
    ${Field_Value_None}    Run Keyword And Return Status    Should Be Equal As Strings    ${Field_Value}    None
    ${Field_Value_Length}    Run Keyword If    ${Field_Value_None}==${False}    Get Length    ${Field_Value}

    ${Key}    Run Keyword If    ${Field_Value_None}==${True} and ${Field_Value_Empty}==${False}      Set Variable    True
    ...    ELSE    Set Variable    False
    ${Val}    Run Keyword If    ${Key}==${False}    Evaluate Field Value    ${Field_Value_None}    ${Field_Value_Empty}    ${Field_Value_Length}    ${iMinValue}    ${iMaxValue}

    [Return]     ${Val}    ${Key}

Get Data from JSON file and handle invalid application value for FX Rate
    [Documentation]    This keyword is used to get field value from JSON file using field name
    ...    e.g. var    Get Data from JSON file    file_path    cluster
    ...    @author: clanding
    [Arguments]    ${file_path}    ${field_name}    ${min}    ${max}
    ${json_object}    Load JSON From File    ${file_path}
    ${field_value_list}    Get Value From Json    ${json_object}    $..${field_name}
    ${field_value_length}    Get Length    ${field_value_list}
    ${field_value}    Run Keyword If    ${field_value_length}>0    Get From List    ${field_value_list}     0
    ${field_value}    Convert To String    ${field_value}
    ${field_val_length}    Get Length    ${field_value}

    # when value is invalid
    ${lob_valid_values}    OperatingSystem.Get File    ${Valid_LOB}
    ${lob_stat}    Run Keyword If    ${field_val_length}>2    Run Keyword And Return Status    Should Contain    ${lob_valid_values}    ${field_value}
    ${invalid_var}    Run Keyword If    ${lob_stat}==False    Set Variable    True
    ...    ELSE    Set Variable    False
    [Return]     ${invalid_var}    ${field_value}

Get Data from JSON file and handle invalid rate for FX Rate
    [Documentation]    This keyword is used to get field value from JSON file using field name and validate if invalid
    ...    e.g. var    Get Data from JSON file    file_path    cluster
    ...    @author: clanding
    [Arguments]    ${file_path}    ${field_name}
    ${json_object}    Load JSON From File    ${file_path}
    ${field_value_list}    Get Value From Json    ${json_object}    $..${field_name}
    ${field_value}    Get From List    ${field_value_list}    0
    ${field_value_stat}    Run Keyword And Return Status    Convert To Number    ${field_value}

    #when rate is invalid
    ${invalid_val}    Run Keyword If    ${field_value_stat}==False    Set Variable    True
    ...    ELSE    Set Variable    False

    [Return]     ${invalid_val}

Get Data from JSON file and handle invalid date for FX Rate
    [Documentation]    This keyword is used to get field value from JSON file using field name and validate if invalid
    ...    e.g. var    Get Data from JSON file    file_path    cluster
    ...    @author: clanding
    [Arguments]    ${file_path}    ${field_name}
    ${json_object}    Load JSON From File    ${file_path}
    ${field_value_list}    Get Value From Json    ${json_object}    $..${field_name}
    ${field_value}    Get From List    ${field_value_list}    0
    ${curr_date}    Get Current Date    time_zone=local
    ${date_format}    Run Keyword And Return Status    Subtract Date From Date    ${curr_date}    ${field_value}

    #when date is invalid
    ${invalid_val}    Run Keyword If    ${date_format}==False    Set Variable    True
    ...    ELSE    Set Variable    False

    [Return]     ${invalid_val}

Get Data from JSON file and handle no output user Roles
    [Arguments]    ${file_path}    ${field_name}

    ${json_object}    Load JSON From File    ${file_path}
    ${temp}    Get Value From Json    ${json_object}    $..${field_name}
    ${count}    Get Length    ${temp}
    ${empty}    Run Keyword And Return Status    Should Be Equal As Integers    ${count}    0
    ${return_value}    Run Keyword if    ${empty}==True    Log    ${field_name} is empty
    ...    ELSE    Get From List    ${temp}    0
   [Return]    ${return_value}

Get Data from JSON file and handle invalid email
    [Arguments]    ${file_path}    ${field_name}    ${min}    ${max}
    [Documentation]    This keyword is used to get field value from JSON file using field name
    ...    e.g. var    Get Data from JSON file    file_path    cluster
    ...    handles remove tag, field value empty string and null
    ...    returns key True when field has no tag, and field is null, fieldNone == True
    ...    return val True when field is ""
    ...    @author: jaquitan
    ${json_object}    Load JSON From File    ${file_path}
    ${field_value_list}    Get Value From Json    ${json_object}    $..${field_name}
    ${field_value_length}    Get Length    ${field_value_list}
    ${field_value}    Run Keyword If    ${field_value_length}>0    Get From List    ${field_value_list}     0
    #when value is ""
    ${field_value_empty}    Run Keyword And Return Status    Should Be Empty    ${field_value}
    #when value is null or tag is removed
    ${field_None}    Run Keyword And Return Status    Should Be Equal As Strings    ${field_value}    None
    ${field_value_length}    Run Keyword If    ${field_None}==False    Get Length    ${field_value}
    ${key}    Run Keyword If    ${field_None}==True and ${field_value_empty}==False      Set Variable    True
    ...    ELSE    Set Variable    False
    ${val}    Run Keyword If    ${key}==False    Evaluate Field Value    ${field_None}    ${field_value_empty}    ${field_value_length}    ${min}    ${max}
    ${val2}    Run Keyword If    ${key}==False and ${val}==False    Evaluate Email Value    ${field_value}
    [Return]     ${val2}    ${val}    ${key}

Get Data from JSON file and handle no output user
    [Arguments]    ${file_path}    ${field_name}    ${min}    ${max}
    [Documentation]    This keyword is used to get field value from JSON file using field name
    ...    e.g. var    Get Data from JSON file    file_path    cluster
    ...    handles remove tag, field value empty string and null
    ...    returns key True when field has no tag, and field is null, fieldNone == True
    ...    return val True when field is ""
    ...    @author: jaquitan
    ${json_object}    Load JSON From File    ${file_path}
    ${field_value_list}    Get Value From Json    ${json_object}    $..${field_name}
    ${field_value_length}    Get Length    ${field_value_list}
    ${field_value}    Run Keyword If    ${field_value_length}>0    Get From List    ${field_value_list}     0
    #when value is ""
    ${field_value_empty}    Run Keyword And Return Status    Should Be Empty    ${field_value}
    #when value is null or tag is removed
    ${field_None}    Run Keyword And Return Status    Should Be Equal As Strings    ${field_value}    None
    ${field_value_length}    Run Keyword If    ${field_None}==False    Get Length    ${field_value}
    ${key}    Run Keyword If    ${field_None}==True and ${field_value_empty}==False      Set Variable    True
    ...    ELSE    Set Variable    False
    ${val}    Run Keyword If    ${key}==False    Evaluate Field Value    ${field_None}    ${field_value_empty}    ${field_value_length}    ${min}    ${max}
    [Return]     ${val}    ${key}

Update JSON value for single data
    [Documentation]    This keyword is used to update JSON value for singe key field.
    ...    @author: clanding
    [Arguments]    ${value}    ${main_keyfield}    ${keyfield}    ${json_object}

    ${tempdict}    Create Dictionary    ${keyfield}=${value}
    ${new_json}    Add Object To Json    ${json_object}    $..${main_keyfield}    ${tempdict}
    [Return]    ${new_json}

Get Data from JSON file and handle no output status
    [Arguments]    ${file_path}    ${field_name}    ${min}    ${max}
    [Documentation]    This keyword is used to get field value from JSON file using field name
    ...    e.g. var    Get Data from JSON file    file_path    cluster
    ...    @author: jaquitan
    ${json_object}    Load JSON From File    ${file_path}
    ${field_value_list}    Get Value From Json    ${json_object}    $..${field_name}
    ${field_value_length}    Get Length    ${field_value_list}
    ${field_value}    Run Keyword If    ${field_value_length}>0    Get From List    ${field_value_list}     0
    #when value is ""
    ${field_value_empty}    Run Keyword And Return Status    Should Be Empty    ${field_value}
    #when value is null or tag is removed
    ${field_None}    Run Keyword And Return Status    Should Be Equal As Strings    ${field_value}    None
    ${field_value_length}    Run Keyword If    ${field_None}==False    Get Length    ${field_value}
    ${key}    Run Keyword If    ${field_None}==False and ${field_value_empty}==True      Set Variable    True
    ...    ELSE    Set Variable    False
    ${val}    Run Keyword If    ${key}==False    Evaluate Field Value    ${field_None}    ${field_value_empty}    ${field_value_length}    ${min}    ${max}
    [Return]     ${val}    ${key}

Get Data from JSON file and handle no output userID mismatch
    [Arguments]    ${json_object}    ${field_name}    ${min}    ${max}    ${link_field_value}
    [Documentation]    This keyword is used to get field value from JSON file using field name
    ...    e.g. var    Get Data from JSON file    file_path    cluster
    ...    @author: jaquitan
    ${field_value_list}    Get Value From Json    ${json_object}    $..${field_name}
    ${field_value_length}    Get Length    ${field_value_list}
    ${field_value}    Run Keyword If    ${field_value_length}>0    Get From List    ${field_value_list}     0
    ${field_value}    Convert To String    ${field_value}
    ${field_val_length}    Get Length    ${field_value}

    # when value is invalid
    ${userIdNotMatch}    Run Keyword And Return Status    Should Not Be Equal As Strings    ${field_value}    ${link_field_value}
    ${invalid_var}    Run Keyword If    ${userIdNotMatch}==True    Set Variable    True
    ...    ELSE    Set Variable    False

    [Return]     ${invalid_var}    ${link_field_value}

Get Data from JSON file for null or no tag User
    [Documentation]    This keyword is used to get field value from JSON file using field name
    ...    @author: clanding
    [Arguments]    ${file_path}    ${field_name}    ${min}    ${max}
    ${json_object}    Load JSON From File    ${file_path}
    ${field_value_list}    Get Value From Json    ${json_object}    $..${field_name}
    ${field_value_length}    Get Length    ${field_value_list}
    ${field_value}    Run Keyword If    ${field_value_length}>0    Get From List    ${field_value_list}     0
    ${field_value}    Convert To String    ${field_value}

    #when value is ""
    ${field_value_empty}    Run Keyword And Return Status    Should Be Empty    ${field_value}
    #when value is null or tag is removed
    ${field_None}    Run Keyword And Return Status    Should Be Equal As Strings    ${field_value}    None
    ${field_value_length}    Run Keyword If    ${field_None}==False    Get Length    ${field_value}

    ${key}    Run Keyword If    ${field_None}==True and ${field_value_empty}==False      Set Variable    True
    ...    ELSE    Set Variable    False
    ${val}    Run Keyword If    ${key}==False    Evaluate Field Value    ${field_None}    ${field_value_empty}    ${field_value_length}    ${min}    ${max}

    [Return]     ${val}    ${key}

Update JSON value for multiple sub keyfields
    [Documentation]    This keyword is used to update JSON value for multiple sub-key field.
    ...    subkeyfield_list values should be separated by , and no spaces.
    ...    @author: clanding
    [Arguments]    ${new_json}    ${main_keyfield}    ${subkeyfield_list}

    ${keyfield_count}    Get Length    ${subkeyfield_list}
    ${INDEX_0}    Set Variable    0
    :FOR    ${INDEX_0}    IN RANGE    ${keyfield_count}
    \    Exit For Loop If    ${INDEX_0}==${keyfield_count}
    \    ${subkeyfield_val}    Get From List    ${subkeyfield_list}    ${INDEX_0}
    \    ${subkeyfield_val_list}    Split String    ${subkeyfield_val}    =
    \    ${keyfield}    Get From List    ${subkeyfield_val_list}    0
    \    ${value}    Get From List    ${subkeyfield_val_list}    1
    \    ${tempdict}    Create Dictionary    ${keyfield}=${value}
    \    ${temp_initial}    Create Dictionary    ${keyfield}=${NONE}
    \    ${new_json}    Add Object To Json    ${new_json}    $..${main_keyfield}    ${temp_initial}
    \    Log    ${new_json}
    \    ${new_json}    Run Keyword If    '${value}'=='null'    Update Value To Json    ${new_json}    $..${keyfield}    ${NONE}
         ...    ELSE IF    '${value}'=='""'    Update Value To Json    ${new_json}    $..${keyfield}    ${EMPTY}
         ...    ELSE    Update Value To Json    ${new_json}    $..${keyfield}    ${value}
    [Return]    ${new_json}

Get Data from JSON file and handle list data
    [Documentation]    @author:jaquitan
    [Arguments]    ${file_path}    ${field_name}
    ${json_object}    Load JSON From File    ${file_path}
    ${temp}    Get Value From Json    ${json_object}    $..${field_name}
    ${count}    Get Length    ${temp}
    ${empty}    Run Keyword And Return Status    Should Be Equal As Integers    ${count}    0
    ${return_value}    Run Keyword if    ${empty}==True    Log    ${field_name} is empty
    ...    ELSE    Get From List    ${temp}    0
   [Return]    ${return_value}

Get Data from JSON object and handle list data
    [Documentation]    @author:jaquitan
    [Arguments]    ${json_object}    ${field_name}
    ${temp}    Get Value From Json    ${json_object}    $..${field_name}
    ${count}    Get Length    ${temp}
    ${empty}    Run Keyword And Return Status    Should Be Equal As Integers    ${count}    0
    ${return_value}    Run Keyword if    ${empty}==True    Log    ${field_name} is empty
    ...    ELSE    Get From List    ${temp}    0
   [Return]    ${return_value}

Get Reason from Reponse Error and compare with Expected Error2
    [Arguments]    ${Actual_Error_File}    ${Expected_Error_File}    ${Output_File_Path}
    [Documentation]    This keyword is used loop through the response file and gets the all the reason from the details object
    ...    e.g.    "details": ["name": "file:/C:/ffc-releases/ffc-2.1.2.0.0/mch-2.1.2.0.0-5923/etc/openAPI/Errors.html#Technical-Validation-Errors",
    ...    "reason": "Field Length mismatch for description field."}]
    ...    writes to actual error list
    ...    and compares to expected error list
    ...    @author: jaquitan
    ${json_object}    Load JSON From File    ${Output_File_Path}
    ${temp}    Get Value From Json    ${json_object}    $..details
    ${count}    Get Length    ${temp}
    ${empty}    Run Keyword And Return Status    Should Be Equal As Integers    ${count}    0
    ${details}    Run Keyword if    ${empty}==True    Log    reason is empty
    ...    ELSE    Get From List    ${temp}    0
    Delete File If Exist    ${Actual_Error_File}
    :FOR   ${detail}   IN  @{details}
    \   Log  ${detail}
    \   ${reason} =  Set variable    ${detail['reason']}
    \   Append To File    ${Actual_Err_List}    ${reason}${\n}
    \   # get error type
    \   ${details_name} =  Set variable    ${detail['name']}
    \   Set Global Variable    ${details_name}
    ${File1}    Get File Size    ${Expected_Err_List}
    ${File2}    Get File Size    ${Actual_Err_List}
    Run Keyword And Continue On Failure    Should Be Equal    ${File1}    ${File2}

Get Reason from Reponse Error and Compare with Expected Error
    [Documentation]    This keyword is used loop through the response file and gets the all the reason from the details object
    ...    e.g.    "details": ["name": "file:/C:/ffc-releases/ffc-2.1.2.0.0/mch-2.1.2.0.0-5923/etc/openAPI/Errors.html#Technical-Validation-Errors",
    ...    "reason": "Field Length mismatch for description field."}]
    ...    writes to actual error list
    ...    and compares to expected error list
    ...    @author: jaquitan
    ...    @author: clanding    27MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1, added token handling
    ...    @update: mnanquil    17APR2019    - modified on how to validate error message for expected error list and actual error list.
    [Arguments]    ${sOutputJSONFile}
    
    ${JSON_Object}    Load JSON From File    ${dataset_path}${sOutputJSONFile}.json
    ${Temp}    Get Value From Json    ${JSON_Object}    $..causes
    ${Count}    Get Length    ${Temp}
    ${Empty}    Run Keyword And Return Status    Should Be Equal As Integers    ${Count}    0
    ${Details}    Run Keyword if    ${Empty}==${True}    Log    reason is empty
    ...    ELSE    Get From List    ${Temp}    0
    Delete File If Exist    ${ACTUAL_ERROR_LIST}
    :FOR   ${Detail}   IN  @{Details}
    \   Log  ${Detail}
    \   ${Reason}    Set variable    ${Detail['reason']}
    \   Append To File    ${ACTUAL_ERROR_LIST}    ${Reason}${\n}
    ${File1}    OperatingSystem.Get File    ${EXPECTED_ERROR_LIST}
    ${File2}    OperatingSystem.Get File    ${ACTUAL_ERROR_LIST}
    ${actualErrorCount}    Get Line Count    ${File1}
    :FOR    ${index}    IN RANGE    ${actualErrorCount} 
    \    ${actualError}    Get Line    ${File1}    ${index}
    \    ${status}    Run Keyword and Return Status    Should Contain    ${File2}    ${actualError}
    \    Run Keyword If    '${status}'=='${False}'    Run Keyword And Continue On Failure    Fail    ${actualError} is not present in ${File2}
    \    Run Keyword If    '${status}'=='${True}'    Log    ${actualError} is present in ${File2}     
       

Get Data from JSON file and handle no output calendar
    [Arguments]    ${file_path}    ${field_name}    ${min}    ${max}
    [Documentation]    This keyword is used to get field value from JSON file using field name
    ...    e.g. var    Get Data from JSON file    file_path    cluster
    ...    handles remove tag, field value empty string and null
    ...    returns key True when field has no tag, and field is null, fieldNone == True
    ...    return val True when field is ""
    ...    @author: jaquitan
    ${json_object}    Load JSON From File    ${file_path}
    ${field_value_list}    Get Value From Json    ${json_object}    $..${field_name}
    ${field_value_length}    Get Length    ${field_value_list}
    ${field_value}    Run Keyword If    ${field_value_length}>0    Get From List    ${field_value_list}     0
    #when value is ""
    ${field_value_empty}    Run Keyword And Return Status    Should Be Empty    ${field_value}
    #when value is null or tag is removed
    ${field_None}    Run Keyword And Return Status    Should Be Equal As Strings    ${field_value}    None
    ${field_value_length}    Run Keyword If    ${field_None}==False    Get Length    ${field_value}
    ${key}    Run Keyword If    ${field_None}==True and ${field_value_empty}==False      Set Variable    True
    ...    ELSE    Set Variable    False
    ${val}    Run Keyword If    ${key}==False    Evaluate Field Value    ${field_None}    ${field_value_empty}    ${field_value_length}    ${min}    ${max}
    [Return]     ${val}    ${key}

# Get Data from JSON file and handle no output calendar year
    # [Arguments]    ${file_path}    ${field_name}
    # [Documentation]    This keyword is used to get field value from JSON file using field name
    # ...    handles remove tag, field value empty string and null
    # ...    @author: jaquitan
    # ${json_object}    Load JSON From File    ${file_path}
    # ${field_value_list}    Get Value From Json    ${json_object}    $..${field_name}
    # ${field_value_length}    Get Length    ${field_value_list}
    # ${field_value}    Run Keyword If    ${field_value_length}>0    Get From List    ${field_value_list}     0
    # #when value is ""
    # ${field_value_empty}    Run Keyword And Return Status    Should Be Empty    ${field_value}
    # #when value is null or tag is removed
    # ${field_None}    Run Keyword And Return Status    Should Be Equal As Strings    ${field_value}    None
    # ${key}    Run Keyword If    ${field_None}==True or ${field_value_empty}==True      Set Variable    True
    # ...    ELSE    Set Variable    False
    # ${val1}    Run Keyword If    ${field_None}==True or ${field_value_empty}==True      Set Variable    False
    # ...    ELSE    Run Keyword And Return Status    Should Be True    ${field_value}<1900
    # ${val2}    Run Keyword If    ${field_None}==True or ${field_value_empty}==True      Set Variable    False
    # ...    ELSE    Run Keyword And Return Status    Should Be True    ${field_value}>9999
    # ${val3}    Run Keyword If    ${field_None}==True or ${field_value_empty}==True      Set Variable    False
    # ...    ELSE    Run Keyword    Evaluate Year    ${field_value}
    # [Return]     ${val3}    ${val2}    ${val1}    ${key}

Get Data from JSON file and handle no output calendar weeklyHolidays
    [Arguments]    ${file_path}    ${field_name}    ${min}    ${max}
    [Documentation]    This keyword is used to get field value from JSON file using field name
    ...    e.g. var    Get Data from JSON file    file_path    cluster
    ...    @author: jaquitan
    ${json_object}    Load JSON From File    ${file_path}
    ${field_value_list}    Get Value From Json    ${json_object}    $..${field_name}
    ${field_value_length}    Get Length    ${field_value_list}
    ${field_value}    Run Keyword If    ${field_value_length}>0    Get From List    ${field_value_list}     0
    #when value is ""
    ${field_value_empty}    Run Keyword And Return Status    Should Be Empty    ${field_value}
    #when value is null or tag is removed
    ${field_None}    Run Keyword And Return Status    Should Be Equal As Strings    ${field_value}    None
    ${field_value_length}    Run Keyword If    ${field_None}==False    Get Length    ${field_value}
    ${key}    Run Keyword If    ${field_None}==False and ${field_value_empty}==True      Set Variable    True
    ...    ELSE    Set Variable    False
    ${val}    Run Keyword If    ${key}==False    Evaluate Field Value    ${field_None}    ${field_value_empty}    ${field_value_length}    ${min}    ${max}
    [Return]     ${val}    ${key}

Get Reason from Reponse Error and compare with Expected Model Type Error
    [Arguments]    ${Actual_Error_File}    ${Expected_Error_File}
    [Documentation]    This keyword is used to compare errors for Model Type Error
    ...    e.g    Double to String,
    Delete File If Exist    ${Actual_Error_File}
    Append To File    ${Actual_Err_List}    ${Response_file}
    ${File1}    OperatingSystem.Get File    ${Expected_Err_List}
    # ${expected}    Convert To String    ${File1}
    ${expected}    Catenate    ${File1}
    ${File2}    OperatingSystem.Get File    ${Actual_Err_List}
    ${actual}    Convert To String    ${File2}
    Run Keyword And Continue On Failure    Should Contain    ${actual}    Cannot deserialize value of type

Get Reason from Reponse Error and compare with Expected Invalid Format
    [Arguments]    ${Actual_Error_File}    ${Expected_Error_File}
    [Documentation]    This keyword is used to compare errors for Invalid Format
    ...    e.g    year input as alpha ("ABCD")
    Delete File If Exist    ${Actual_Error_File}
    Append To File    ${Actual_Err_List}    ${Response_file}
    ${File1}    OperatingSystem.Get File    ${Expected_Err_List}
    ${expected}    Convert To String    ${File1}
    ${File2}    OperatingSystem.Get File    ${Actual_Err_List}
    ${actual}    Convert To String    ${File2}
    Run Keyword And Continue On Failure    Should Contain    ${actual}    Invalid format:

Get Data from JSON file and handle no output calendar BusinessAndNonBusinessDates
    [Arguments]    ${file_path}    ${field_name}
    [Documentation]    This keyword is used get field from Json files for array of arrays
    ${json_object}    Load JSON From File    ${file_path}
    ${temp}    Get Value From Json    ${json_object}    $..${field_name}
    ${count}    Get Length    ${temp}
    ${empty}    Run Keyword And Return Status    Should Be Equal As Integers    ${count}    0
    ${return_value}    Run Keyword if    ${empty}==True    Log    ${field_name} is empty
    ...    ELSE    Get From List    ${temp}    0
   [Return]    ${return_value}

Get Data from JSON object and handle no output calendar
    [Arguments]    ${json_object}    ${field_name}    ${min}    ${max}
    [Documentation]    This keyword is used to get field value from JSON file using field name
    ...    e.g. var    Get Data from JSON file    file_path    cluster
    ...    @author: jaquitan
    ${field_value_list}    Get Value From Json    ${json_object}    $..${field_name}
    ${field_value_length}    Get Length    ${field_value_list}
    ${field_value}    Run Keyword If    ${field_value_length}>0    Get From List    ${field_value_list}     0
    #when value is ""
    ${field_value_empty}    Run Keyword And Return Status    Should Be Empty    ${field_value}
    #when value is null or tag is removed
    ${field_None}    Run Keyword And Return Status    Should Be Equal As Strings    ${field_value}    None
    ${field_value_length}    Run Keyword If    ${field_None}==False    Get Length    ${field_value}
    ${key}    Run Keyword If    ${field_None}==True and ${field_value_empty}==False      Set Variable    True
    ...    ELSE    Set Variable    False
    ${val}    Run Keyword If    ${key}==False    Evaluate Field Value    ${field_None}    ${field_value_empty}    ${field_value_length}    ${min}    ${max}
    [Return]     ${val}    ${key}

Get Data from JSON object and handle no output calendar dateValue
     [Arguments]    ${json_object}    ${field_name}
     [Documentation]    This keyword is used to get field value from JSON file using field name
    ...    e.g. var    Get Data from JSON object    ex. NonBusinessDates    dateValue
    ...    It returns key1 and key2 as True field empty for "",null, and no tag
    ...    It returns key3 as True if field is not empty and format is not valid
    ...    @author: jaquitan
    ${field_value_list}    Get Value From Json    ${json_object}    $..${field_name}
    ${field_value_length}    Get Length    ${field_value_list}
    ${field_value}    Run Keyword If    ${field_value_length}>0    Get From List    ${field_value_list}     0
    #when value is ""
    ${field_value_empty}    Run Keyword And Return Status    Should Be Empty    ${field_value}
    #when value is null or tag is removed
    ${field_None}    Run Keyword And Return Status    Should Be Equal As Strings    ${field_value}    None
    ${convert_field_value}    Run Keyword And Return Status    Convert Date    ${field_value}    result_format=%Y-%m-%d
    ${key1}    Run Keyword If    ${field_None}==True and ${field_value_empty}==False      Set Variable    True
    ${key2}    Run Keyword If    ${field_None}==False and ${field_value_empty}==True      Set Variable    True
    ${key3}    Run Keyword If    ${field_None}==False and ${field_value_empty}==False and ${convert_field_value}==False      Set Variable    True
    ${key}    Run Keyword If    ${key1}==True or ${key2}==True or ${key3}==True      Set Variable    True
    ...    ELSE    Set Variable    False
    ${val}    Run Keyword If    ${key}==False    Set Variable    False

    [Return]    ${val}    ${key}

Get Data from JSON object and handle no output calendar application
    [Arguments]    ${json_object}    ${field_name}    ${min}    ${max}
    [Documentation]    This keyword is used to get field value from JSON file using field name
    ...    e.g. var    Get Data from JSON file    file_path    cluster
    ...    @author: jaquitan
    ${field_value_list}    Get Value From Json    ${json_object}    $..${field_name}
    ${field_value_length}    Get Length    ${field_value_list}
    ${field_value}    Run Keyword If    ${field_value_length}>0    Get From List    ${field_value_list}     0
    #when value is ""
    ${field_value_empty}    Run Keyword And Return Status    Should Be Empty    ${field_value}
    #when value is null or tag is removed
    ${field_None}    Run Keyword And Return Status    Should Be Equal As Strings    ${field_value}    None
    ${key}    Run Keyword If    ${field_None}==True and ${field_value_empty}==False      Set Variable    True
    ...    ELSE    Set Variable    False
    ${val}    Run Keyword If    ${key}==False    Evaluate Field Value    ${field_None}    ${field_value_empty}    ${field_value_length}    ${min}    ${max}
    [Return]     ${val}    ${key}

Get Data from JSON file and handle no output calendar LOB
    [Arguments]    ${file_path}    ${field_name}

    ${json_object}    Load JSON From File    ${file_path}
    ${temp}    Get Value From Json    ${json_object}    $..${field_name}
    ${count}    Get Length    ${temp}
    ${empty}    Run Keyword And Return Status    Should Be Equal As Integers    ${count}    0
    ${return_value}    Run Keyword if    ${empty}==True    Log    ${field_name} is empty
    ...    ELSE    Get From List    ${temp}    0
   [Return]    ${return_value}

Get Data from JSON file and handle invalid application value for Calendar
    [Arguments]    ${file_path}    ${field_name}    ${min}    ${max}
    [Documentation]    This keyword is used to get field value from JSON file using field name
    ...    e.g. var    Get Data from JSON file    file_path    cluster
    ...    @author: clanding
    ${json_object}    Load JSON From File    ${file_path}
    ${field_value_list}    Get Value From Json    ${json_object}    $..${field_name}
    ${field_value_length}    Get Length    ${field_value_list}
    ${field_value}    Run Keyword If    ${field_value_length}>0    Get From List    ${field_value_list}     0
    ${field_value}    Convert To String    ${field_value}
    ${field_val_length}    Get Length    ${field_value}

    # when value is invalid
    ${lob_valid_values}    Get File    ${Valid_LOB}
    ${lob_stat}    Run Keyword If    ${field_val_length}>2    Run Keyword And Return Status    Should Contain    ${lob_valid_values}    ${field_value}
    ${invalid_var}    Run Keyword If    ${lob_stat}==False    Set Variable    True
    ...    ELSE    Set Variable    False
    [Return]     ${invalid_var}    ${field_value}


Get Data from JSON file and handle invalid calendar year
    [Arguments]    ${file_path}    ${field_name}
    [Documentation]    This keyword is used to get field value from JSON file using field name
    ...    e.g. var    Get Data from JSON file    file_path    cluster
    ...    @author: jaquitan
    ${json_object}    Load JSON From File    ${file_path}
    ${field_value_list}    Get Value From Json    ${json_object}    $..${field_name}
    ${field_value_length}    Get Length    ${field_value_list}
    ${field_value}    Run Keyword If    ${field_value_length}>0    Get From List    ${field_value_list}     0
    ${field_value}    Convert To String    ${field_value}
    ${field_val_length}    Get Length    ${field_value}

    # when value is invalid
    ${date_year}    Get Current Date    result_format=%Y
    ${year_past}    Run Keyword And Return Status    Should Be True    ${field_value}<${date_year}

    [Return]     ${year_past}    ${field_value}

Get Data from JSON file and handle invalid date value
    [Arguments]    ${json_object}    ${field_name}    ${year}
    [Documentation]    This keyword is used to get field value from JSON file using field name
    ...    e.g. var    Get Data from JSON file    file_path    cluster
    ...    @author: jaquitan
     ${field_value_list}    Get Value From Json    ${json_object}    $..${field_name}
    ${field_value_length}    Get Length    ${field_value_list}
    ${field_value}    Run Keyword If    ${field_value_length}>0    Get From List    ${field_value_list}     0

    ${field_value}    Convert To String    ${field_value}
    ${field_val_length}    Get Length    ${field_value}

    # when value is invalid
    ${field_value_year}    Convert Date    ${field_value}    result_format=%Y
    ${year_past}    Run Keyword And Return Status    Should Be True    ${field_value_year}!=${year}

    [Return]    ${year_past}    ${field_value}

Get Data from JSON file and handle no output calendar invalid application value
    [Arguments]    ${json_object}    ${field_name}    ${min}    ${max}
    [Documentation]    This keyword is used to get field value from JSON file using field name
    ...    e.g. var    Get Data from JSON file    file_path    cluster
    ...    @author: jaquitan
    ${field_value_list}    Get Value From Json    ${json_object}    $..${field_name}
   ${field_value_length}    Get Length    ${field_value_list}
    ${field_value}    Run Keyword If    ${field_value_length}>0    Get From List    ${field_value_list}     0
    ${field_value}    Convert To String    ${field_value}
    ${field_val_length}    Get Length    ${field_value}

    # when value is invalid
    ${lob_valid_values}    OperatingSystem.Get File    ${Valid_LOB}
    ${lob_stat}    Run Keyword If    ${field_val_length}>2    Run Keyword And Return Status    Should Contain    ${lob_valid_values}    ${field_value}
    ${invalid_var}    Run Keyword If    ${lob_stat}==False    Set Variable    True
    ...    ELSE    Set Variable    False

    [Return]     ${invalid_var}    ${field_value}

Get Data from JSON file for Users
    [Documentation]    This keyword is used to get field value from JSON file using field name
    ...    e.g. var    Get Data from JSON file    file_path    cluster
    ...    @author: clanding
    [Arguments]    ${file_path}    ${field_name}
    ${json_object}    Load JSON From File    ${file_path}
    ${temp}    Get Value From Json    ${json_object}    $..${field_name}
    Log    ${field_name}
    ${field_value}    Get From List    ${temp}    0
    [Return]     ${field_value}

Get Role from Roles keyfield in the payload
    [Documentation]    This keyword is used to get Role value/s from Roles keyfield in the payload.
    ...    e.g.
    ...    "roles": [{"role": "Authorizor"},{"role": "superit"}]
    ...    @author: clanding
    [Arguments]    ${Roles_json}

    @{returnroles}    Create List
    :FOR    ${roles}    IN    @{Roles_json}
    \    Log    ${roles}
    \    Log    ${Roles_json}
    \    ${role_val}    Set Variable    ${roles['role']}
    \    Append To List    ${returnroles}    ${role_val}
    [Return]    ${returnroles}

Get Application from LOBS keyfield in the payload
    [Documentation]    This keyword is used to get Role value/s from Roles keyfield in the payload.
    ...    e.g.
    ...    "lobs": [{"application": "COMRLENDING"},{"application": "PARTY"}]
    ...    @author: clanding
    [Arguments]    ${lobs_json}

    @{returnapplication}    Create List
    :FOR    ${lobs}    IN    @{lobs_json}
    \    Log    ${lobs}
    \    ${application_val}    Set Variable    ${lobs['application']}
    \    Append To List    ${returnapplication}    ${application_val}
    [Return]    ${returnapplication}

Update JSON value for multiple data
    [Documentation]    This keyword is used to update JSON value for multiple key fields.
    ...    @author: clanding
    [Arguments]    ${value_list}    ${main_keyfield}    ${keyfield}    ${json_object}

    ${i}    Set Variable    0
    @{fieldlist}    Split String    ${value_list}    ,
    ${max_loop}    Get Length    ${fieldlist}
    ${keyval}    Get From List    ${fieldlist}    0
    :FOR    ${i}    IN RANGE    0    ${max_loop}
    \    ${keyval}    Get From List    ${fieldlist}    ${i}
    \    ${field_dict}    Create Dictionary    ${keyfield}=${keyval}
    \    ${new_json}    Add Object To Json    ${json_object}    $..${main_keyfield}    ${field_dict}
    \    Log    ${new_json}
    \    Run Keyword If    ${i}>${max_loop}    Exit For Loop
    [Return]    ${new_json}

Get Role Value from Config Setup
    [Documentation]    This keyword is used to get corresponding Role value from the config setup of the Role value from the input payload
    ...    @author: clanding/jaquitan
    [Arguments]    ${input_rolelist}

    ${RoleType}    OperatingSystem.Get File    ${RoleType_Config}
    ${RoleType_count}    Get Line Count    ${RoleType}
    ${RoleTypeDict}    Create Dictionary
    ${i}    Set Variable    0
    :FOR    ${i}    IN RANGE    ${RoleType_count}
    \    ${RoleTypeconfig}    Get Line    ${RoleType}    ${i}
    \    ${RoleTypeconfiglist}    Split String    ${RoleTypeconfig}    =
    \    ${key}    Get From List    ${RoleTypeconfiglist}    0
    \    ${value}    Get From List    ${RoleTypeconfiglist}    1
    \    Set To Dictionary    ${RoleTypeDict}    ${key}=${value}
    \    Exit For Loop If    '${i}'=='${RoleType_count}'
    Log    ${RoleTypeDict}

    ${rolelist}    Split String    ${input_rolelist}    /
    ${role_count}    Get Length    ${rolelist}
    ${i}    Set Variable    0
    ${SSO_Role_List}    Create List
    :FOR    ${i}    IN RANGE    ${role_count}
    \    ${role_val}    Get From List    ${rolelist}    ${i}
    \    ${dictionary_create}    Run Keyword And Return Status    Get From Dictionary    ${RoleTypeDict}    ${role_val}
    \    Run Keyword If    ${dictionary_create}==False    Log    No role matched
    \    ${SSO_Role}    Run Keyword If    ${dictionary_create}==True    Get From Dictionary    ${RoleTypeDict}    ${role_val}
    \    Run Keyword If     ${dictionary_create}==True   Append To List    ${SSO_Role_List}    ${SSO_Role}
    \    Exit For Loop If    '${i}'=='${role_count}'
    Log    ${SSO_Role_List}
    [Return]    ${SSO_Role_List}

Compare Expected and Actual Error for Correspondence
    [Arguments]    ${Actual_Error_File}    ${Expected_Error_File}    ${Output_File_Path}
    [Documentation]    This keyword is used loop through the response file and gets the all the reason from the details object
    ...    e.g.    "details": ["name": "file:/C:/ffc-releases/ffc-2.1.2.0.0/mch-2.1.2.0.0-5923/etc/openAPI/Errors.html#Technical-Validation-Errors",
    ...    "reason": "Field Length mismatch for description field."}]
    ...    writes to actual error list
    ...    and compares to expected error list
    ...    @author: Cmartill
    ${json_object}    Load JSON From File    ${Output_File_Path}
    ${temp}    Get Value From Json    ${json_object}    $..error
    ${errMsg}    Get From List    ${temp}    0

    Delete File If Exist    ${Actual_Error_File}

    Append To File    ${Actual_Err_List}    ${errMsg}${\n}

    ${File1}    Get File Size    ${Expected_Err_List}
    ${File2}    Get File Size    ${Actual_Err_List}
    Run Keyword And Continue On Failure    Should Be Equal    ${File1}    ${File2}

Get Data From JSON File and Handle Single Data
    [Documentation]    This keyword is used to get field value from JSON file using field name
    ...    @author: jaquitan
    ...    @update: clanding    23APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sFilePath}    ${sFieldName}    ${iMinValue}    ${iMaxValue}
    ${JSON_Object}    Load JSON From File    ${sFilePath}
    ${Field_Value_List}    Get Value From Json    ${JSON_Object}    $..${sFieldName}
    ${Field_Value_Length}    Get Length    ${Field_Value_List}
    ${Field_Value}    Run Keyword If    ${Field_Value_Length}>0    Get From List    ${Field_Value_List}     0
    #when value is ""
    ${Field_Value_Empty}    Run Keyword And Return Status    Should Be Empty    ${Field_Value}
    #when value is null or tag is removed
    ${Field_None}    Run Keyword And Return Status    Should Be Equal As Strings    ${Field_Value}    None
    ${Field_Value_Length}    Run Keyword If    ${Field_None}==False    Get Length    ${Field_Value}
    ${Key}    Run Keyword If    ${Field_None}==True and ${Field_Value_Empty}==False      Set Variable    True
    ...    ELSE    Set Variable    False
    ${Val}    Run Keyword If    ${Key}==False    Evaluate Field Value    ${Field_None}    ${Field_Value_Empty}    ${Field_Value_Length}    ${iMinValue}    ${iMaxValue}
    [Return]     ${Val}    ${Key}

Get Data from JSON Object and Handle Single Data
    [Documentation]    This keyword is used to get field value from JSON file using field name
    ...    e.g. var    Get Data from JSON file    sFilePath    cluster
    ...    @author: jaquitan
    ...    @update: clanding    23APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${dJSON_Object}    ${sFieldName}    ${iMinValue}    ${iMaxValue}
    ${Field_Value_List}    Get Value From Json    ${dJSON_Object}    $..${sFieldName}
    ${Field_Value_Length}    Get Length    ${Field_Value_List}
    ${Field_Value}    Run Keyword If    ${Field_Value_Length}>0    Get From List    ${Field_Value_List}     0
    ###when input value is ""
    ${Field_Value_Empty}    Run Keyword And Return Status    Should Be Empty    ${Field_Value}
    ###when input value is null or tag is removed
    ${Field_None}    Run Keyword And Return Status    Should Be Equal As Strings    ${Field_Value}    None
    ${Field_Value_Length}    Run Keyword If    ${Field_None}==False    Get Length    ${Field_Value}
    ${Key}    Run Keyword If    ${Field_None}==True and ${Field_Value_Empty}==False      Set Variable    True
    ...    ELSE    Set Variable    False
    ${Val}    Run Keyword If    ${Key}==False    Evaluate Field Value    ${Field_None}    ${Field_Value_Empty}    ${Field_Value_Length}    ${iMinValue}    ${iMaxValue}
    [Return]     ${Val}    ${Key}

Get Data from JSON object and handle single data with inner field name
    [Arguments]    ${json_object}    ${field_name}    ${inner_fieldName}    ${min}    ${max}
    [Documentation]    This keyword is used to get inner field value from JSON file using field name
    ...    @author: jaquitan
    ${field_value_list}    Get Value From Json    ${json_object}    $..${field_name}..${inner_fieldName}
    ${field_value_length}    Get Length    ${field_value_list}
    ${field_value}    Run Keyword If    ${field_value_length}>0    Get From List    ${field_value_list}     0
    #when value is ""
    ${field_value_empty}    Run Keyword And Return Status    Should Be Empty    ${field_value}
    #when value is null or tag is removed
    ${field_None}    Run Keyword And Return Status    Should Be Equal As Strings    ${field_value}    None
    ${field_value_length}    Run Keyword If    ${field_None}==False    Get Length    ${field_value}
    ${key}    Run Keyword If    ${field_None}==True and ${field_value_empty}==False      Set Variable    True
    ...    ELSE    Set Variable    False
    ${val}    Run Keyword If    ${key}==False    Evaluate Field Value    ${field_None}    ${field_value_empty}    ${field_value_length}    ${min}    ${max}
    [Return]     ${val}    ${key}

Get Data from JSON file and handle single data for Correspondence
    [Arguments]    ${file_path}    ${field_name}    ${min}    ${max}
    [Documentation]    This keyword is used to get field value from JSON file using field name
    ...    @author: cmartill
    ${json_object}    Load JSON From File    ${file_path}
    ${field_value_list}    Get Value From Json    ${json_object}    $..${field_name}
    ${field_value_length}    Get Length    ${field_value_list}
    ${field_value}    Run Keyword If    ${field_value_length}>0    Get From List    ${field_value_list}     0
    #when value is ""
    ${field_value_empty}    Run Keyword And Return Status    Should Be Empty    ${field_value}
    #when value is null or tag is removed
    ${field_None}    Run Keyword And Return Status    Should Be Equal As Strings    ${field_value}    None
    ${field_value_length}    Run Keyword If    ${field_None}==False    Get Length    ${field_value}
    ${val}    Run Keyword If    ${field_value_length}<${max} and ${field_value_empty}==False and ${field_None}==False    Set Variable    invalidValue
    ...    ELSE IF    ${field_value_empty}==True    Set Variable    isEmpty
    ...    ELSE IF    ${field_value_length}>${max}    Set Variable    hasExceeded
    ...    ELSE IF    ${field_None}==True    Set Variable    isNone
    [Return]    ${val}

Compare Expected and Actual Error
    [Documentation]    This keyword is used loop through the response file and gets the all the reason from the details object
    ...    e.g.    "causes": [{"name": "http://localhost:8083/ccb/Errors.html#Technical-Validation-Errors",
    ...    "reason": "Field Length mismatch for os User Id field."}]
    ...    writes to actual error list
    ...    and compares to expected error list
    ...    @author: jaquitan
    ...    @update: clanding    23APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1, added token handling
    [Arguments]    ${Actual_Error_File}    ${Expected_Error_File}    ${Output_File_Path}
    
	${Expected_Error_List}=    OperatingSystem.Get File    ${Expected_Error_File}
	${json_object}    Load JSON From File    ${dataset_path}${Output_File_Path}.json
    ${temp}    Get Value From Json    ${json_object}    $..causes
    ${count}    Get Length    ${temp}
    ${empty}    Run Keyword And Return Status    Should Be Equal As Integers    ${count}    0
    ${causes}    Run Keyword if    ${empty}==True    Log    reason is empty
    ...    ELSE    Get From List    ${temp}    0
    Delete File If Exist    ${Actual_Error_File}
    :FOR   ${cause}   IN  @{causes}
    \   Log  ${cause}
    \   Set Global Variable    ${cause}
    \   ${reason} =  Set variable    ${cause['reason']}
    \    @{reasonSplit}    Split String    ${reason}    -
    \    ${reasonSplitList}    Get From List    ${reasonSplit}    0
    \    ${reasonFinal}    Strip String    ${SPACE}${reasonSplitList}${SPACE}
    \    ${ReasonMatch_Status}    Run Keyword and Return Status    Run Keyword And Continue On Failure    Should Contain    ${Expected_Error_List}    ${reasonFinal}
    \    Run Keyword If    ${ReasonMatch_Status}==True    Log    Error - ${reasonFinal} - is existing on the Expected Error file!
         ...    ELSE    Log    Error - ${reasonFinal} - does not exist on the Expected Error file!    Level=ERROR
    \    Append To File    ${Actual_Err_List}    ${reasonFinal}${\n}
    \    ${causes_name}=  Set variable    ${cause['name']}
    \    Set Global Variable    ${causes_name}
    \    Set Global Variable    ${reason}

    ${File1}    Get File Size    ${Expected_Err_List}
    ${File2}    Get File Size    ${Actual_Err_List}
    Run Keyword And Continue On Failure    Should Be Equal    ${File1}    ${File2}

Update Key Values of input JSON file for FxRates APItest
    [Documentation]    This keyword is used to update key values of JSON file and save to new file.
    ...    @author: chanario
    [Arguments]    ${APIDataSet}

    # ${file_path}    Set Variable    ${Input_File_Path_FXRates}${templateinput_SingleLOB}
    # ${EMPTY}    Set Variable
    # ${json_object}    Load JSON From File    ${file_path}

    ${rateType}    Run Keyword If    '&{APIDataSet}[rateType]'=='null'    Set Variable    null
    ...    ELSE IF    '&{APIDataSet}[rateType]'==''    Set Variable    ""
    ...    ELSE IF    '&{APIDataSet}[rateType]'=='Empty' or '&{APIDataSet}[rateType]'=='empty'    Set Variable    ""
    ...    ELSE    Set Variable    &{APIDataSet}[rateType]

    ${data}    OperatingSystem.Get File    ${Input_File_Path_FXRates}${templateinput_SingleLOB}
    ${data}    Set Variable    ${data}
    ${data}    Replace Variables    ${data}

    ${newFileName}    Set Variable    &{APIDataSet}[InputJson]
    Create File    ${Input_File_Path_FXRates}${newFileName}    ${data}

Update Key Values of input JSON file for FxRates API
    [Documentation]    This keyword is used to update key values of JSON file and save to new file.
    ...    @author: chanario
    [Arguments]    ${APIDataSet}

    ${file_path}    Set Variable    ${Input_File_Path_FXRates}${templateinput_MultipleLOB}
    ${EMPTY}    Set Variable
    ${json_object}    Load JSON From File    ${file_path}

    ## set variables
    ${INDEX_0}    Set Variable    0
    ${INDEX_00}    Set Variable    0

    ## add demographic fields here
    ${new_json}    Run Keyword If    '&{APIDataSet}[rateType]'=='null'    Set To Dictionary    ${json_object}    rateType=${NONE}
    ...    ELSE IF    '&{APIDataSet}[rateType]'==''    Set To Dictionary    ${json_object}    rateType=${EMPTY}
    ...    ELSE IF    '&{APIDataSet}[rateType]'=='Empty' or '&{APIDataSet}[rateType]'=='empty'    Set To Dictionary    ${json_object}    rateType=${EMPTY}
    ...    ELSE IF    '&{APIDataSet}[rateType]'=='no tag'    Set Variable    ${json_object}
    ...    ELSE    Set To Dictionary    ${json_object}    rateType=&{APIDataSet}[rateType]

    ${new_json}    Run Keyword If    '&{APIDataSet}[fromCurrency]'=='null'    Set To Dictionary    ${new_json}    fromCurrency=${NONE}
    ...    ELSE IF    '&{APIDataSet}[fromCurrency]'==''    Set To Dictionary    ${new_json}    fromCurrency=${EMPTY}
    ...    ELSE IF    '&{APIDataSet}[fromCurrency]'=='Empty' or '&{APIDataSet}[fromCurrency]'=='empty'    Set To Dictionary    ${new_json}    fromCurrency=${EMPTY}
    ...    ELSE IF    '&{APIDataSet}[fromCurrency]'=='no tag'    Set Variable    ${new_json}
    ...    ELSE    Set To Dictionary    ${new_json}    fromCurrency=&{APIDataSet}[fromCurrency]

    ${new_json}    Run Keyword If    '&{APIDataSet}[toCurrency]'=='null'    Set To Dictionary    ${new_json}    toCurrency=${NONE}
    ...    ELSE IF    '&{APIDataSet}[toCurrency]'==''    Set To Dictionary    ${new_json}    toCurrency=${EMPTY}
    ...    ELSE IF    '&{APIDataSet}[toCurrency]'=='Empty' or '&{APIDataSet}[toCurrency]'=='empty'    Set To Dictionary    ${new_json}    toCurrency=${EMPTY}
    ...    ELSE IF    '&{APIDataSet}[toCurrency]'=='no tag'    Set Variable    ${new_json}
    ...    ELSE    Set To Dictionary    ${new_json}    toCurrency=&{APIDataSet}[toCurrency]

    ${new_json}    Run Keyword If    '&{APIDataSet}[buyRate]'=='null'    Set To Dictionary    ${new_json}    buyRate=${NONE}
    ...    ELSE IF    '&{APIDataSet}[buyRate]'==''    Set To Dictionary    ${new_json}    buyRate=${EMPTY}
    ...    ELSE IF    '&{APIDataSet}[buyRate]'=='Empty' or '&{APIDataSet}[buyRate]'=='empty'    Set To Dictionary    ${new_json}    buyRate=${EMPTY}
    ...    ELSE IF    '&{APIDataSet}[buyRate]'=='no tag'    Set Variable    ${new_json}
    ...    ELSE    Set To Dictionary    ${new_json}    buyRate=&{APIDataSet}[buyRate]

    ${new_json}    Run Keyword If    '&{APIDataSet}[midRate]'=='null'    Set To Dictionary    ${new_json}    midRate=${NONE}
    ...    ELSE IF    '&{APIDataSet}[midRate]'==''    Set To Dictionary    ${new_json}    midRate=${EMPTY}
    ...    ELSE IF    '&{APIDataSet}[midRate]'=='Empty' or '&{APIDataSet}[midRate]'=='empty'    Set To Dictionary    ${new_json}    midRate=${EMPTY}
    ...    ELSE IF    '&{APIDataSet}[midRate]'=='no tag'    Set Variable    ${new_json}
    ...    ELSE    Set To Dictionary    ${new_json}    midRate=&{APIDataSet}[midRate]

    ${new_json}    Run Keyword If    '&{APIDataSet}[sellRate]'=='null'    Set To Dictionary    ${new_json}    sellRate=${NONE}
    ...    ELSE IF    '&{APIDataSet}[sellRate]'==''    Set To Dictionary    ${new_json}    sellRate=${EMPTY}
    ...    ELSE IF    '&{APIDataSet}[sellRate]'=='Empty' or '&{APIDataSet}[sellRate]'=='empty'    Set To Dictionary    ${new_json}    sellRate=${EMPTY}
    ...    ELSE IF    '&{APIDataSet}[sellRate]'=='no tag'    Set Variable    ${new_json}
    ...    ELSE    Set To Dictionary    ${new_json}    sellRate=&{APIDataSet}[sellRate]

    # ${new_json}    Run Keyword If    '&{APIDataSet}[reciprocal]'=='null'    Set To Dictionary    ${new_json}    reciprocal=${NONE}
    # ...    ELSE IF    '&{APIDataSet}[reciprocal]'==''    Set To Dictionary    ${new_json}    reciprocal=${EMPTY}
    # ...    ELSE IF    '&{APIDataSet}[reciprocal]'=='Empty' or '&{APIDataSet}[reciprocal]'=='empty'    Set To Dictionary    ${new_json}    reciprocal=${EMPTY}
    # ...    ELSE IF    '&{APIDataSet}[reciprocal]'=='no tag'    Set Variable    ${new_json}
    # ...    ELSE    Set To Dictionary    ${new_json}    reciprocal=&{APIDataSet}[reciprocal]

    ${new_json}    Run Keyword If    '&{APIDataSet}[effectiveDate]'=='null'    Set To Dictionary    ${new_json}    effectiveDate=${NONE}
    ...    ELSE IF    '&{APIDataSet}[effectiveDate]'==''    Set To Dictionary    ${new_json}    effectiveDate=${EMPTY}
    ...    ELSE IF    '&{APIDataSet}[effectiveDate]'=='Empty' or '&{APIDataSet}[effectiveDate]'=='empty'    Set To Dictionary    ${new_json}    effectiveDate=${EMPTY}
    ...    ELSE IF    '&{APIDataSet}[effectiveDate]'=='no tag'    Set Variable    ${new_json}
    ...    ELSE    Set To Dictionary    ${new_json}    effectiveDate=&{APIDataSet}[effectiveDate]

   ## get lineOfBusiness field values
   ${LOB_list}    Split String    &{APIDataSet}[lineOfBusiness]    ,
   ${LOB_count}    Get Length    ${LOB_list}
   ${BusinessEntityList}    Split String    &{APIDataSet}[businessEntityName]    ,
   ${subEntityList}    Split String    &{APIDataSet}[subEntity]    ,

   ## add 'line of business' fields here
   :FOR    ${INDEX_0}    IN RANGE    ${LOB_count}
   \    Exit For Loop If    ${INDEX_0}==${LOB_count} or '&{APIDataSet}[lineOfBusiness]'==''
   \    Log    ${new_json}
   \    ${val_LOB}    Get From List    ${LOB_list}    ${INDEX_0}
   \
   \    ##check lineOfBusiness if null or empty or have valid value
   \    ${val_LOB_0}    Run Keyword If    '&{APIDataSet}[lineOfBusiness]'!=''    Get From List    ${LOB_list}    0
   \    ${val_LOB}    Run Keyword If    '${val_LOB_0}'=='lineOfBusiness=""'    Set Variable    ${EMPTY}
        ...    ELSE IF    '${val_LOB_0}'=='lineOfBusiness=null'    Set Variable    ${NONE}
        ...    ELSE    Set Variable    ${val_LOB}
   \
   \    ${BusinessEntityDictionary}    Create Array for Multiple Values    ${BusinessEntityList}    ${INDEX_0}    businessEntityName    |
   \    ${subEntityDictionary}    Create Array for Multiple Values    ${subEntityList}    ${INDEX_0}    subEntity    |
   \
   \
   \
   \    ${lineOfBusinessDictionary}    Create Dictionary    lineOfBusiness=${val_LOB}
        ...    businessEntityName=${BusinessEntityDictionary}    subEntity=${subEntityDictionary}
   \
   \    ${BusinessEntityVal}    Get From List    ${BusinessEntityList}    0
   \    ${subEntityVal}    Get From List    ${subEntityList}    0
   \
   \    Run Keyword If    '${BusinessEntityVal}'=='no tag'    Remove From Dictionary    ${lineOfBusinessDictionary}    businessEntityName
   \    Run Keyword If    '${subEntityVal}'=='no tag'    Remove From Dictionary    ${lineOfBusinessDictionary}    subEntity
   \    ${lineOfBusiness_notag_0}    Get From Dictionary    ${lineOfBusinessDictionary}    lineOfBusiness
   \    Run Keyword If    '${lineOfBusiness_notag_0}'=='no tag'    Remove From Dictionary    ${lineOfBusinessDictionary}    lineOfBusiness
   \
   \    ${new_json}    Run Keyword If    '&{APIDataSet}[lineOfBusiness]'=='null'    Set To Dictionary    ${new_json}    lobs=${NONE}
        ...    ELSE IF    '&{APIDataSet}[lineOfBusiness]'==''    Set To Dictionary    ${new_json}    lobs=${EMPTY}
        ...    ELSE IF    '&{APIDataSet}[lineOfBusiness]'=='Empty' or '&{APIDataSet}[lineOfBusiness]'=='empty'    Set To Dictionary    ${new_json}    lobs=${EMPTY}
        ...    ELSE    Add Object To Json    ${new_json}    $..lobs    ${lineOfBusinessDictionary}

    Log    ${new_json}
    ${converted_json}    Evaluate    json.dumps(${new_json})        json
    Log    ${converted_json}
    ${converted_json}    Catenate    [    ${converted_json}    ]

    ${jsonfile}    Set Variable    &{APIDataSet}[InputFilePath]&{APIDataSet}[InputJson].json
    Delete File If Exist    ${dataset_path}${jsonfile}
    Create File    ${dataset_path}${jsonfile}    ${converted_json}
    ${file}    OperatingSystem.Get File    ${dataset_path}${jsonfile}


Update Expected API Response for FX Rates
    [Documentation]    This keyword is used to update expected API Response.
    ...    @author: chanario
    [Arguments]    ${APIDataSet}

        ${file_path}    Set Variable    ${Input_File_Path_FXRates}${templateinput_MultipleLOB}
    ${EMPTY}    Set Variable
    ${json_object}    Load JSON From File    ${file_path}

    ## set variables
    ${INDEX_0}    Set Variable    0
    ${INDEX_00}    Set Variable    0

    ## add demographic fields here
    ${new_json}    Run Keyword If    '&{APIDataSet}[rateType]'=='null'    Set To Dictionary    ${json_object}    rateType=${NONE}
    ...    ELSE IF    '&{APIDataSet}[rateType]'==''    Set To Dictionary    ${json_object}    rateType=${EMPTY}
    ...    ELSE IF    '&{APIDataSet}[rateType]'=='Empty' or '&{APIDataSet}[rateType]'=='empty'    Set To Dictionary    ${json_object}    rateType=${EMPTY}
    ...    ELSE IF    '&{APIDataSet}[rateType]'=='no tag'    Set Variable    ${json_object}
    ...    ELSE    Set To Dictionary    ${json_object}    rateType=&{APIDataSet}[rateType]

    ${new_json}    Run Keyword If    '&{APIDataSet}[fromCurrency]'=='null'    Set To Dictionary    ${new_json}    fromCurrency=${NONE}
    ...    ELSE IF    '&{APIDataSet}[fromCurrency]'==''    Set To Dictionary    ${new_json}    fromCurrency=${EMPTY}
    ...    ELSE IF    '&{APIDataSet}[fromCurrency]'=='Empty' or '&{APIDataSet}[fromCurrency]'=='empty'    Set To Dictionary    ${new_json}    fromCurrency=${EMPTY}
    ...    ELSE IF    '&{APIDataSet}[fromCurrency]'=='no tag'    Set Variable    ${new_json}
    ...    ELSE    Set To Dictionary    ${new_json}    fromCurrency=&{APIDataSet}[fromCurrency]


    ${new_json}    Run Keyword If    '&{APIDataSet}[toCurrency]'=='null'    Set To Dictionary    ${new_json}    toCurrency=${NONE}
    ...    ELSE IF    '&{APIDataSet}[toCurrency]'==''    Set To Dictionary    ${new_json}    toCurrency=${EMPTY}
    ...    ELSE IF    '&{APIDataSet}[toCurrency]'=='Empty' or '&{APIDataSet}[toCurrency]'=='empty'    Set To Dictionary    ${new_json}    toCurrency=${EMPTY}
    ...    ELSE IF    '&{APIDataSet}[toCurrency]'=='no tag'    Set Variable    ${new_json}
    ...    ELSE    Set To Dictionary    ${new_json}    toCurrency=&{APIDataSet}[toCurrency]

    ${buyRate}    Read Data From Excel for API_Data    FxRate_Fields    buyRate    ${rowid}
    ${new_json}    Run Keyword If    '&{APIDataSet}[buyRate]'=='null'    Set To Dictionary    ${new_json}    buyRate=${NONE}
    ...    ELSE IF    '&{APIDataSet}[buyRate]'==''    Set To Dictionary    ${new_json}    buyRate=${EMPTY}
    ...    ELSE IF    '&{APIDataSet}[buyRate]'=='Empty' or '&{APIDataSet}[buyRate]'=='empty'    Set To Dictionary    ${new_json}    buyRate=${EMPTY}
    ...    ELSE IF    '&{APIDataSet}[buyRate]'=='no tag'    Set Variable    ${new_json}
    ...    ELSE    Set To Dictionary    ${new_json}    buyRate=${${buyRate}}

    ${midRate}    Read Data From Excel for API_Data    FxRate_Fields    midRate    ${rowid}
    ${new_json}    Run Keyword If    '&{APIDataSet}[midRate]'=='null'    Set To Dictionary    ${new_json}    midRate=${NONE}
    ...    ELSE IF    '&{APIDataSet}[midRate]'==''    Set To Dictionary    ${new_json}    midRate=${EMPTY}
    ...    ELSE IF    '&{APIDataSet}[midRate]'=='Empty' or '&{APIDataSet}[midRate]'=='empty'    Set To Dictionary    ${new_json}    midRate=${EMPTY}
    ...    ELSE IF    '&{APIDataSet}[midRate]'=='no tag'    Set Variable    ${new_json}
    ...    ELSE    Set To Dictionary    ${new_json}    midRate=${${midRate}}

    ${sellRate}    Read Data From Excel for API_Data    FxRate_Fields    sellRate    ${rowid}
    ${new_json}    Run Keyword If    '&{APIDataSet}[sellRate]'=='null'    Set To Dictionary    ${new_json}    sellRate=${NONE}
    ...    ELSE IF    '&{APIDataSet}[sellRate]'==''    Set To Dictionary    ${new_json}    sellRate=${EMPTY}
    ...    ELSE IF    '&{APIDataSet}[sellRate]'=='Empty' or '&{APIDataSet}[sellRate]'=='empty'    Set To Dictionary    ${new_json}    sellRate=${EMPTY}
    ...    ELSE IF    '&{APIDataSet}[sellRate]'=='no tag'    Set Variable    ${new_json}
    ...    ELSE    Set To Dictionary    ${new_json}    sellRate=${${sellRate}}

    # ${new_json}    Run Keyword If    '&{APIDataSet}[reciprocal]'=='null'    Set To Dictionary    ${new_json}    reciprocal=${NONE}
    # ...    ELSE IF    '&{APIDataSet}[reciprocal]'==''    Set To Dictionary    ${new_json}    reciprocal=${EMPTY}
    # ...    ELSE IF    '&{APIDataSet}[reciprocal]'=='Empty' or '&{APIDataSet}[reciprocal]'=='empty'    Set To Dictionary    ${new_json}    reciprocal=${EMPTY}
    # ...    ELSE IF    '&{APIDataSet}[reciprocal]'=='no tag'    Set Variable    ${new_json}
    # ...    ELSE    Set To Dictionary    ${new_json}    reciprocal=&{APIDataSet}[reciprocal]

    ${new_json}    Run Keyword If    '&{APIDataSet}[effectiveDate]'=='null'    Set To Dictionary    ${new_json}    effectiveDate=${NONE}
    ...    ELSE IF    '&{APIDataSet}[effectiveDate]'==''    Set To Dictionary    ${new_json}    effectiveDate=${EMPTY}
    ...    ELSE IF    '&{APIDataSet}[effectiveDate]'=='Empty' or '&{APIDataSet}[effectiveDate]'=='empty'    Set To Dictionary    ${new_json}    effectiveDate=${EMPTY}
    ...    ELSE IF    '&{APIDataSet}[effectiveDate]'=='no tag'    Set Variable    ${new_json}
    ...    ELSE    Set To Dictionary    ${new_json}    effectiveDate=&{APIDataSet}[effectiveDate]

   ## get lineOfBusiness field values
   ${LOB_list}    Split String    &{APIDataSet}[lineOfBusiness]    ,
   ${LOB_count}    Get Length    ${LOB_list}
   ${BusinessEntityList}    Split String    &{APIDataSet}[businessEntityName]    ,
   ${subEntityList}    Split String    &{APIDataSet}[subEntity]    ,

   ## add 'line of business' fields here
   :FOR    ${INDEX_0}    IN RANGE    ${LOB_count}
   \    Exit For Loop If    ${INDEX_0}==${LOB_count} or '&{APIDataSet}[lineOfBusiness]'==''
   \    Log    ${new_json}
   \    ${val_LOB}    Get From List    ${LOB_list}    ${INDEX_0}
   \
   \    ##check lineOfBusiness if null or empty or have valid value
   \    ${val_LOB_0}    Run Keyword If    '&{APIDataSet}[lineOfBusiness]'!=''    Get From List    ${LOB_list}    0
   \    ${val_LOB}    Run Keyword If    '${val_LOB_0}'=='lineOfBusiness=""'    Set Variable    ${EMPTY}
        ...    ELSE IF    '${val_LOB_0}'=='lineOfBusiness=null'    Set Variable    ${NONE}
        ...    ELSE    Set Variable    ${val_LOB}
   \
   \    ${BusinessEntityDictionary}    Create Array for Multiple Values    ${BusinessEntityList}    ${INDEX_0}    businessEntityName    |
   \    ${subEntityDictionary}    Create Array for Multiple Values    ${subEntityList}    ${INDEX_0}    subEntity    |
   \
   \
   \
   \    ${lineOfBusinessDictionary}    Create Dictionary    lineOfBusiness=${val_LOB}
        ...    businessEntityName=${BusinessEntityDictionary}    subEntity=${subEntityDictionary}
   \
   \    ${BusinessEntityVal}    Get From List    ${BusinessEntityList}    0
   \    ${subEntityVal}    Get From List    ${subEntityList}    0
   \
   \    Run Keyword If    '${BusinessEntityVal}'=='no tag'    Remove From Dictionary    ${lineOfBusinessDictionary}    businessEntityName
   \    Run Keyword If    '${subEntityVal}'=='no tag'    Remove From Dictionary    ${lineOfBusinessDictionary}    subEntity
   \    ${lineOfBusiness_notag_0}    Get From Dictionary    ${lineOfBusinessDictionary}    lineOfBusiness
   \    Run Keyword If    '${lineOfBusiness_notag_0}'=='no tag'    Remove From Dictionary    ${lineOfBusinessDictionary}    lineOfBusiness
   \
   \    ${new_json}    Run Keyword If    '&{APIDataSet}[lineOfBusiness]'=='null'    Set To Dictionary    ${new_json}    lobs=${NONE}
        ...    ELSE IF    '&{APIDataSet}[lineOfBusiness]'==''    Set To Dictionary    ${new_json}    lobs=${EMPTY}
        ...    ELSE IF    '&{APIDataSet}[lineOfBusiness]'=='Empty' or '&{APIDataSet}[lineOfBusiness]'=='empty'    Set To Dictionary    ${new_json}    lobs=${EMPTY}
        ...    ELSE    Add Object To Json    ${new_json}    $..lobs    ${lineOfBusinessDictionary}

    Log    ${new_json}
    ${converted_json}    Evaluate    json.dumps(${new_json})        json
    Log    ${converted_json}
    ${converted_json}    Catenate    [    ${converted_json}    ]

    ${jsonfile}    Set Variable    &{APIDataSet}[InputFilePath]&{APIDataSet}[InputAPIResponse].json
    Delete File If Exist    ${dataset_path}${jsonfile}
    Create File    ${dataset_path}${jsonfile}    ${converted_json}
    ${file}    OperatingSystem.Get File    ${dataset_path}${jsonfile}

Get Data from JSON File and Handle Invalid LOB Value
    [Documentation]    This keyword is used to get field value from JSON file using field name and validate
    ...    if line of business value is invalid value and return invalid value.
    ...    @author: clanding    01APR2019    - initial create
    [Arguments]    ${sFilePath}    ${sFieldName}    ${iMinValue}    ${iMaxValue}
    ${JSON_Object}    Load JSON From File    ${dataset_path}${sFilePath}.json
    ${Field_Value_List}    Get Value From Json    ${JSON_Object}    $..${sFieldName}
    ${Field_Value_Length}    Get Length    ${Field_Value_List}
    ${Field_Value}    Run Keyword If    ${Field_Value_Length}>0    Get From List    ${Field_Value_List}     0
    ${Field_Value}    Convert To String    ${Field_Value}
    ${Field_Val_Length}    Get Length    ${Field_Value}
    
    ${LOB_Valid_Values}    OperatingSystem.Get File    ${Valid_LOB}
    ${Valid_Val}    Run Keyword If    ${iMaxValue}<${Field_Val_Length}>${iMinValue}    Run Keyword And Return Status    Should Contain    ${LOB_Valid_Values}    ${Field_Value}
    ...    ELSE IF    ${Field_Val_Length}<${iMinValue}    Set Variable    False
    ...    ELSE IF    ${Field_Val_Length}>${iMaxValue}    Set Variable    False
    ...    ELSE IF    ${Field_Val_Length}==0    Set Variable    False

    [Return]     ${Valid_Val}    ${Field_Value}

###DATA MANIPULATION KEYWORDS###
Convert Date With Zero
    [Documentation]    This keyword is used to convert date to DD-MMM-YYYY
    ...    e.g. var    Convert Date With Zero
    ...    @author: clanding
    [Arguments]    ${date}
    ${converted_date_with_0}=    Convert Date    ${date}    result_format=%d-%b-%Y
    [Return]    ${converted_date_with_0}

Convert Date Without Zero
    [Documentation]    This keyword is used to convert date to D-MMM-YYYY
    ...    e.g. var    Convert Date Without Zero
    ...    @author: clanding
    [Arguments]    ${date}
    ${converted_date}=    Convert Date    ${date}    result_format=%#d-%b-%Y
    [Return]    ${converted_date}

BackDate Date by N day
    [Documentation]    This keyword is used to backdate given date by given N day/s
    ...    e.g.    BackDate Date by N day    2014-01-01    1
    ...    @author: clanding
    [Arguments]    ${date}    ${N_day}
    ${backdated_val}    Subtract Time From Date    ${date}    ${N_day} d
    [Return]    ${backdated_val}

Compute for FX Rate from Mid Rate
    [Documentation]    This keyword is used to compute for FX Rate using Mid Rate from JSON file
    ...    e.g.    var    Compute for FX Rate from Mid Rate    mid_rate_value
    ...    @author: clanding
    [Arguments]    ${mid_rate}
    ${fx_rate1}    Evaluate    1/${mid_rate}
    ${fxrate_computed}    Convert To Number    ${fx_rate1}    9
    [Return]    ${fxrate_computed}

Convert Mid Rate
    [Documentation]    This keyword is used to convertmid rate.
    ...    @author: clanding
    [Arguments]    ${mid_rate}
    ${fx_rate1}    Evaluate    1/${mid_rate}
    ${fx_rate1}    Convert To Number    ${fx_rate1}    9
    ${fx_rate}    Convert To String    ${fx_rate1}
    @{split_rate}    Split String    ${fx_rate}    .
    ${rate_len}    Get Length    ${split_rate}
    ${fxrate_whole}    Get From List    ${split_rate}    0
    ${fxrate_whole}    Convert To Number    ${fxrate_whole}
    ${fxrate_dec}    Run Keyword If    ${rate_len}==2    Get From List    ${split_rate}    1
    ${FX_Rate_no_0}    ${FXRate_whole_no_0}    ${FXRate_dec_no_0}    Run Keyword And Return If    ${fxrate_whole}==0 and ${rate_len}==2    Get Significant Figure including whole number    ${fx_rate}
    ${FX_Rate_no_0}    ${FXRate_whole_no_0}    ${FXRate_dec_no_0}    Run Keyword And Return If    ${fxrate_whole}>0 and ${rate_len}==2    Get Significant Figure excluding whole number    ${fx_rate}
    [Return]    ${FX_Rate_no_0}    ${FXRate_whole_no_0}    ${FXRate_dec_no_0}
    
Get Significant Mid Rate
    [Documentation]    This keyword is used to 9 significant figures for mid rate.
    ...    @author: cfrancis    18JUL2019
    [Arguments]    ${mid_rate}
    ${fx_rate}    Convert To String    ${mid_rate}
    @{split_rate}    Split String    ${fx_rate}    .
    ${rate_len}    Get Length    ${split_rate}
    ${fxrate_whole}    Get From List    ${split_rate}    0
    ${fxrate_whole}    Convert To Number    ${fxrate_whole}
    ${fxrate_dec}    Run Keyword If    ${rate_len}==2    Get From List    ${split_rate}    1
    ${FX_Rate_no_0}    ${FXRate_whole_no_0}    ${FXRate_dec_no_0}    Run Keyword And Return If    ${fxrate_whole}==0 and ${rate_len}==2    Get Significant Figure including whole number    ${fx_rate}
    ${FX_Rate_no_0}    ${FXRate_whole_no_0}    ${FXRate_dec_no_0}    Run Keyword And Return If    ${fxrate_whole}>0 and ${rate_len}==2    Get Significant Figure excluding whole number    ${fx_rate}
    [Return]    ${FX_Rate_no_0}    ${FXRate_whole_no_0}    ${FXRate_dec_no_0}

Get Significant Figure including whole number
    [Documentation]    This keyword is used to get significant figure including the whole number
    ...    @author: clanding
    [Arguments]    ${fx_rate}
    # ${rate}    Get Substring    ${fx_rate}    0    11
    ${rate}    Convert To Number    ${fx_rate}    9
    ${rate}    Convert To String    ${rate}
    @{split_rate}    Split String    ${rate}    .
    ${fxrate_whole}    Get From List    ${split_rate}    0
    ${fxrate_dec}    Get From List    ${split_rate}    1
    ${fxrate_dec}    Strip String    ${fxrate_dec}    mode=right    characters=0
    ${fxrate_dec}    Catenate    SEPARATOR=    .    ${fxrate_dec}
    ${temp}    Convert To String    ${rate}
    ${temp}    Strip String    ${temp}    mode=right    characters=0
    ${FX_Rate_no_0}    Convert To Number    ${temp}
    [Return]    ${FX_Rate_no_0}    ${fxrate_whole}    ${fxrate_dec}

Get Significant Figure excluding whole number
    [Documentation]    This keyword is used to get significant figure excluding the whole number
    ...    @author: clanding
    [Arguments]    ${fx_rate}
    # ${rate}    Get Substring    ${fx_rate}    0    10
    ${rate}    Convert To String    ${fx_rate}
    @{split_rate}    Split String    ${rate}    .
    ${fxrate_whole}    Get From List    ${split_rate}    0
    ${fxrate_whole_len}    Get Length    ${fxrate_whole}
    ${fxrate_dec}    Get From List    ${split_rate}    1
    ${dec_place}    Evaluate    9-${fxrate_whole_len}
    ${fx_rate_converted}    Convert To Number    ${fx_rate}    ${dec_place}
    ${rate}    Convert To String    ${fx_rate_converted}
    @{split_rate}    Split String    ${rate}    .
    ${fxrate_whole}    Get From List    ${split_rate}    0
    ${fxrate_dec}    Get From List    ${split_rate}    1
    ${fxrate_dec}    Convert To String    ${fxrate_dec}
    ${fxrate_dec}    Strip String    ${fxrate_dec}    mode=right    characters=.0
    ${fxrate_dec}    Catenate    SEPARATOR=    .    ${fxrate_dec}
    ${temp}    Convert To String    ${fx_rate_converted}
    ${temp}    Strip String    ${temp}    mode=right    characters=0
    ${FX_Rate_no_0}    Convert To Number    ${temp}
    [Return]    ${FX_Rate_no_0}    ${fxrate_whole}    ${fxrate_dec}

Set Static Text to Locator Single Text
    [Documentation]    This keyword is used to create locator for single Static Text
    ...    @author: clanding
    [Arguments]    ${WindowName}    ${Static_Text}
    ${Locator}    Set Variable    JavaWindow("title:=${WindowName}.*").JavaStaticText("label:=${Static_Text}")
    [Return]    ${Locator}

Set Static Text to Locator Multiple Text
    [Documentation]    This keyword is used to create locator for multiple Static Text
    ...    @author: clanding
    [Arguments]    ${WindowName}    ${Static_Text}
    ${Static_Text_1}    Get First Value from Static    ${Static_Text}
    ${Locator}    Set Variable    JavaWindow("title:=${WindowName}.*").JavaStaticText("label:=${Static_Text_1}.*")
    [Return]    ${Locator}

Set Edit Text to Locator Single Text
    [Arguments]    ${WindowName}    ${Edit_Text}    ${bWildCard}=True
    [Documentation]    This keyword is used to create a dyanmic locator of JavaEdit.
    ...    [WindowsName, text/value]
     ${Locator}    Run Keyword If    '${bWildCard}'=='True'    Set Variable    JavaWindow("title:=${WindowName}.*").JavaEdit("text:=${Edit_Text}.*","value:=${Edit_Text}.*")
    ...    ELSE    Set Variable    JavaWindow("title:=${WindowName}.*").JavaEdit("text:=${Edit_Text}","value:=${Edit_Text}")
    [Return]    ${Locator}

Set Attached and Label Text with 2 words to Locator
    [Arguments]    ${WindowName}    ${Static_Text}
    [Documentation]    This keyword is for creation of locator with the text of 2 words which will add a wildcard (.*) on each word to be splitted.
    @{string1}    Split String    ${Static_Text}    ${SPACE}
    ${label_1}=    Get From List    ${string1}    0
    ${label_2}=    Get From List    ${string1}    1
    ${Locator}    Set Variable    JavaWindow("title:=${WindowName}.*").JavaStaticText("label:=${label_1}.*${label_2}.*","attached text:=${label_1}.*${label_2}.*")
    [Return]    ${Locator}
    
Set List Text with 2 words to Locator
    [Arguments]    ${WindowName}    ${List_Text}
    [Documentation]    This keyword is for creation of locator with the text of 2 words which will add a wildcard (.*) on each word to be splitted.
    @{string1}    Split String    ${List_Text}    ${SPACE}
    ${label_1}=    Get From List    ${string1}    0
    ${label_2}=    Get From List    ${string1}    1
    ${Locator}    Set Variable    JavaWindow("title:=${WindowName}.*").JavaList("text:=${label_1}.*${label_2}.*")
    [Return]    ${Locator}

Set List Text with 3 words to Locator
    [Arguments]    ${WindowName}    ${List_Text}
    [Documentation]    This keyword is for creation of locator with the text of 3 words which will add a wildcard (.*) on each word to be splitted.
    @{string1}    Split String    ${List_Text}    ${SPACE}
    ${label_1}=    Get From List    ${string1}    0
    ${label_2}=    Get From List    ${string1}    1
    ${label_3}=    Get From List    ${string1}    2
    ${Locator}    Set Variable    JavaWindow("title:=${WindowName}.*").JavaList("text:=${label_1}.*${label_2}.*${label_3}.*")
    [Return]    ${Locator}

Set Edit Text with 2 words to Locator
    [Arguments]    ${WindowName}    ${Edit_Text}
    [Documentation]    This keyword is for creation of locator with the text of 2 words which will add a wildcard (.*) on each word to be splitted.
    @{string1}    Split String    ${Edit_Text}    ${SPACE}
    ${label_1}=    Get From List    ${string1}    0
    ${label_2}=    Get From List    ${string1}    1
    ${Locator}    Set Variable    JavaWindow("title:=${WindowName}.*").JavaEdit("text:=${label_1}.*${label_2}.*","value:=${label_1}.*${label_2}.*")
    [Return]    ${Locator}

Set Attached Text and Label Locator Single Text
    [Arguments]    ${WindowName}    ${Static_Text}
    ${Locator}    Set Variable    JavaWindow("title:=${WindowName}.*").JavaStaticText("label:=${Static_Text}","attached text:=${Static_Text}")
    [Return]    ${Locator}

Get First Value from Static
    [Arguments]    ${Static_Text}
    @{temp_list}    Split String    ${Static_Text}
    ${first_value}    Get From List    ${temp_list}    0
    [Return]    ${first_value}

Get System Date on LIQ and Return Value
    [Documentation]    This keyword gets the business date from LIQ and return the value.
    ...    @author: clanding
    Mx LoanIQ Get Data    ${LIQ_Window}    label%temp
    ${SystemDate1}    Fetch From Right    ${temp}    :${SPACE}
    log    System Date: ${SystemDate1}
    ${SystemDate}    Convert Date    ${SystemDate1}     result_format=%Y-%m-%d    date_format=%d-%b-%Y
    ${Effective_Date}    Set Variable    ${SystemDate1}
    log    Converted Date: ${SystemDate}
    [Return]    ${SystemDate}

Compute Base Rate from Table Clipboard
	[Documentation]    This keyword is use to compute the percentage of base rate in Funding Rate History table to Log the exact value
    ...    e.g. Compute Base Rate Percentage    base_rate
    ...    @author: cmartill
    [Arguments]    ${rate}
    ${computed_value_1}    Evaluate    ${rate}*100
    ${computed_value_2}    Evaluate    ${rate}/100

    ${convertRate}=  Evaluate  "%.6f" % ${rate}
    Log     ${convertRate}
    ${rateInPercentage}    Catenate    SEPARATOR=    ${convertRate}    %
    [Return]    ${computed_value_1}     ${rateInPercentage}    ${rate}

Compute Rate Percentage 5 Decimal Places
    [Arguments]    ${rate}
    ${new_rate}    Evaluate    ${rate}*100
    ${converted_rate}=  Evaluate  "%.5f" % ${new_rate}
    ${new_rate%}    Catenate    SEPARATOR=    ${converted_rate}    %
    Log     Converted Rate For Funding Rates Update: ${new_rate%}
    [Return]    ${new_rate%}


Compute Rate Percentage 6 Decimal Places
    [Arguments]    ${rate}
    ${rate}    Convert To Number    ${rate}
    ${new_rate}    Evaluate    ${rate}*100
    ${convertRate}=  Evaluate  "%.6f" % ${new_rate}
    Log     ${convertRate}
    ${new_rate%}    Catenate    SEPARATOR=    ${convertRate}    %
    [Return]    ${new_rate%}    ${rate}

Compute Rate Percentage to N Decimal Values and Return
    [Documentation]    This keyword is used to compute iRate provided to iDecimalPlaces and return value.
    ...    @author: clanding    28FEB2019    - intial create
    [Arguments]    ${iRate}    ${iDecimalPlaces}
    ${rate}    Convert To Number    ${iRate}
    ${new_rate}    Evaluate    ${rate}*100
    ${convertRate}=  Evaluate  "%.${iDecimalPlaces}f" % ${new_rate}
    Log     ${convertRate}
    ${new_rate%}    Catenate    SEPARATOR=    ${convertRate}    %
    [Return]    ${new_rate%}    ${rate}

Convert to Whole Number
	[Documentation]	This keyword is used to convert the base rate to whole number.
	...	e.g 1.0 to 1 for table clipboard
	...    @author: cmartill
    [Arguments]    ${rate}
    ${wholeRate}    Strip String    ${rate}    mode=right    characters=0
    ${actualRate}    Remove String    ${wholeRate}    .
    ${new_rate%}    ${new_rate}    Compute Rate Percentage 6 Decimal Places    ${actualRate}
    [Return]     ${new_rate%}    ${actualRate}

Get Error Message from Error Master List
    [Documentation]    This keyword is used to get the error message from the Error Master List and append to Error File List.
    ...    @author: clanding
    [Arguments]    ${Err_Master_List}
    ${temp}    Set Variable    &{Err_Master_List}[ErrorMessage]
    Append To File    ${EXPECTED_ERROR_LIST}        ${temp}${\n}

Get Error Message without Newline Character from Error Master List
    [Documentation]    This keyword is used to get the error message from the Error Master List and append to Error File List
    ...    without introducing a newline character at the end of the file.
    ...    @author: cfrancis
    [Arguments]    ${Err_Master_List}
    ${temp}    Set Variable    &{Err_Master_List}[ErrorMessage]
    Append To File    ${EXPECTED_ERROR_LIST}        ${temp}

Evaluate Field Value for LOBS
    [Documentation]    This keyword is used to evaluate the value for lobs
    ...    @author: clanding
    [Arguments]    ${file_path}
    ${json_object}    Load JSON From File    ${file_path}
    ${field_value_list}    Get Value From Json    ${json_object}    $..lobs
    ${field_list_length}    Get Length    ${field_value_list}
    ${field_value}    Run Keyword If    ${field_list_length}>0    Get From List    ${field_value_list}     0
    ${field_value_none}    Run Keyword And Return Status    Should Be Equal    '${field_value}'    'None'
    ${field_value_bracket}    Run Keyword And Return Status    Should Be Equal    '${field_value}'    '[]'
    ${var}    Run Keyword If    ${field_value_none}==True or ${field_value_bracket}==True    Set Variable    False
    ...    ELSE    Set Variable    True
    [Return]    ${var}

Write Data To Excel for API
    [Documentation]    This keyword will dynamically store data in Excel file
    ...    author: ritragel/jdelacru/clanding
    [Arguments]    ${SheetName}    ${ColumnName}    ${rowID}    ${NewValue}
    log    ${ExcelPath_API}
    log    ${ExcelPath_API_temp}
    Copy File    ${ExcelPath_API}    ${ExcelPath_API_temp}
    Open Excel    ${ExcelPath_API_temp}
    ${ColumnCount}    Get Column Count    ${SheetName}
    :FOR    ${y}    IN RANGE    0    ${ColumnCount}
    \    ${header}    Read Cell Data By Coordinates    ${SheetName}    ${y}    0
    \    # Verify header
    \    Run Keyword If    "${header}"=="${ColumnName}"    Set Test Variable    ${ColumnCount}    ${y}
    \    Exit For Loop If    "${header}"=="${ColumnName}"
    log    ${ColumnCount}
    Put String To Cell    ${SheetName}    ${ColumnCount}     ${rowID}    ${NewValue}
    Save Excel    ${ExcelPath_API_temp}
    Copy File    ${ExcelPath_API_temp}    ${ExcelPath_API}
    Remove File    ${ExcelPath_API_temp}
    ${lib}    Get Library Instance    ExcelLibrary
    Call Method    ${lib.wb}    release_resources

Read Data From Excel for API
    [Documentation]    This keyword will dynamically read data in Excel file
    ...    author: ritragel/jdelacru/clanding
    [Arguments]    ${SheetName}    ${ColumnName}    ${rowID}
    log    ${ColumnName}
    Open Excel    ${ExcelPath_API}
    # Get row count
    ${ColumnCount}    Get Column Count    ${SheetName}
    :FOR    ${y}    IN RANGE    0    ${ColumnCount}
    \    ${header}    Read Cell Data By Coordinates    ${SheetName}    ${y}    0
    \    # Check header
    \    Run Keyword If    "${header}"=="${ColumnName}"    Set Test Variable    ${ColumnCount}    ${y}
    \    Exit For Loop If    "${header}"=="${ColumnName}"
    log    ${ColumnCount}
    ${SearchedData}    Read Cell Data By Coordinates    ${SheetName}    ${ColumnCount}    ${rowID}
    Put String To Cell    ${SheetName}    0     1    1
    Save Excel    ${ExcelPath_API}
    [Return]    ${SearchedData}

Write Data To Excel for Audit
    [Documentation]    This keyword will dynamically store data in Excel file
    ...    author: clanding
    ...    @update: jdelacru    18DEC2019    - Used xlsx instead of xls
    ...    @update: jdelacru    20DEC2019    - Uses close all excel documents keyword instead of releasing resources
    [Arguments]    ${SheetName}    ${ColumnName}    ${rowid}    ${NewValue}
    Copy File    DataSet${/}API_DataSet${/}Audit${/}Audit_Log_Data_Set.xlsx    DataSet${/}API_DataSet${/}Audit${/}audittemp.xlsx
    Open Excel    DataSet${/}API_DataSet${/}Audit${/}audittemp.xlsx
    ${ColumnCount}    Get Column Count    ${SheetName}
    :FOR    ${y}    IN RANGE    0    ${ColumnCount}
    \    ${header}    Read Cell Data By Coordinates    ${SheetName}    ${y}    0
    \    # Verify header
    \    Run Keyword If    "${header}"=="${ColumnName}"    Set Test Variable    ${ColumnCount}    ${y}
    \    Exit For Loop If    "${header}"=="${ColumnName}"
    log    ${ColumnCount}
    Put String To Cell    ${SheetName}    ${ColumnCount}     ${rowid}    ${NewValue}
    Save Excel    DataSet${/}API_DataSet${/}Audit${/}audittemp.xlsx
    Copy File    DataSet${/}API_DataSet${/}Audit${/}audittemp.xlsx    DataSet${/}API_DataSet${/}Audit${/}Audit_Log_Data_Set.xlsx
    Delete File If Exist    DataSet${/}API_DataSet${/}Audit${/}audittemp.xlsx
    Close All Excel Documents

Write Data To Excel for API_Data
    [Documentation]    This keyword will dynamically store data in Excel file.
    ...    author: mgaling
    ...    @update: amansuet    19NOV2019    - updated keyword, added close current excel keyword
    [Arguments]    ${SheetName}    ${ColumnName}    ${rowID}    ${NewValue}
    log    ${APIDataSet}
    log    ${ExcelPath_API_temp}
    Copy File    ${APIDataSet}    ${ExcelPath_API_temp}
    Open Excel    ${ExcelPath_API_temp}
    ${ColumnCount}    Get Column Count    ${SheetName}
    :FOR    ${y}    IN RANGE    0    ${ColumnCount}
    \    ${header}    Read Cell Data By Coordinates    ${SheetName}    ${y}    0
    \    # Verify header
    \    Run Keyword If    "${header}"=="${ColumnName}"    Set Test Variable    ${ColumnCount}    ${y}
    \    Exit For Loop If    "${header}"=="${ColumnName}"
    log    ${ColumnCount}
    Put String To Cell    ${SheetName}    ${ColumnCount}     ${rowID}    ${NewValue}
    Save Excel    ${ExcelPath_API_temp}
    Copy File    ${ExcelPath_API_temp}    ${APIDataSet}
    Remove File    ${ExcelPath_API_temp}
    # ${lib}    Get Library Instance    ExcelLibrary
    # Call Method    ${lib.wb}    release_resources
    Close Current Excel Document
    

Read Data From Excel for API_Data
    [Documentation]    This keyword will dynamically read data in Excel file.
    ...    author: mgaling
    ...    @update: amansuet    21NOV2019    - added close current excel document keyword to fix error
    [Arguments]    ${SheetName}    ${ColumnName}    ${rowID}
    log    ${ColumnName}
    Open Excel    ${APIDataSet}
    # Get row count
    ${ColumnCount}    Get Column Count    ${SheetName}
    :FOR    ${y}    IN RANGE    0    ${ColumnCount}
    \    ${header}    Read Cell Data By Coordinates    ${SheetName}    ${y}    0
    \    # Check header
    \    Run Keyword If    "${header}"=="${ColumnName}"    Set Test Variable    ${ColumnCount}    ${y}
    \    Exit For Loop If    "${header}"=="${ColumnName}"
    log    ${ColumnCount}
    ${SearchedData}    Read Cell Data By Coordinates    ${SheetName}    ${ColumnCount}    ${rowID}
    Put String To Cell    ${SheetName}    0     1    1
    Save Excel    ${APIDataSet}
    Close Current Excel Document
    [Return]    ${SearchedData}

Read Data From Excel for ZeroPath
    [Documentation]    This keyword will dynamically read data in Excel file.
    ...    author: mgaling
	...    @update: amansuet    21NOV2019    - added close current excel document keyword to fix error
    [Arguments]    ${Zero_TempPath}    ${SheetName}    ${ColumnName}    ${rowID}
    log    ${ColumnName}
    Open Excel    ${Zero_TempPath}

    ${ColumnCount}    Get Column Count    ${SheetName}
    :FOR    ${y}    IN RANGE    0    ${ColumnCount}
    \    ${header}    Read Cell Data By Coordinates    ${SheetName}    ${y}    0
    \    # Check header
    \    Run Keyword If    "${header}"=="${ColumnName}"    Set Test Variable    ${ColumnCount}    ${y}
    \    Exit For Loop If    "${header}"=="${ColumnName}"
    log    ${ColumnCount}
    ${SearchedData}    Read Cell Data By Coordinates    ${SheetName}    ${ColumnCount}    ${rowID}
    Put String To Cell    ${SheetName}    0     1    1
    Close Current Excel Document
    [Return]    ${SearchedData}
    # ${wsFinalLIQDestination_XML}    Parse Xml    ${Expected_wsFinalLIQDestination}
    # Log    ${wsFinalLIQDestination_XML.attrib}
    # ${element}    Get Element    ${Expected_wsFinalLIQDestination}    CreateUserProfile

Substring Country Code
    [Arguments]    ${3codecountry}
    ${2code_countrycode}    Get Substring    ${3codecountry}    0
    [Return]   ${2code_countrycode}

Continue Get Country Desc from the input 2-code country
    [Arguments]    ${rowval_dict}    ${3codecountry}
    ${countrydesc}    Get From Dictionary    ${rowval_dict}    ${3codecountry}
    [Return]    ${countrydesc}

Substring Country Desc
    [Arguments]    ${3codecountry}
    ${countrydesc}    Get Substring    ${3codecountry}    0
    [Return]   ${countrydesc}

Read Cell Data Using Reference Column Name and Row Number and Return
    [Documentation]    This keyword is used to read cell data using referenced column name and row number and return cell data.
    ...    @update: clanding    18JUN2019    - initial create
    ...    @update: jloretiz    26NOV2019    - add keyword to close the current excel document
    [Arguments]    ${sSheetName}    ${sColumnName}    ${iRowNum}    ${sFilePath}=${ExcelPath}   
    log    ${sColumnName}
    Open Excel    ${sFilePath}
    ${ColumnCount}    Get Column Count    ${sSheetName}
    :FOR    ${x}    IN RANGE    0    ${ColumnCount}
    \    ${header}    Read Cell Data By Coordinates    ${sSheetName}    ${x}    0
    \    # Check header
    \    Run Keyword If    "${header}"=="${sColumnName}"    Set Test Variable    ${ColumnCount}    ${x}
    \    Exit For Loop If    "${header}"=="${sColumnName}"
    ${CellData}    Read Cell Data By Coordinates    ${sSheetName}    ${ColumnCount}    ${iRowNum}
    [Return]    ${CellData}
    Close Current Excel Document

###SSH KEYWORDS###
Open Connection and Login
    [Documentation]    This keyword is used to open connection to server and login using the defined credentials.
    ...    @author: clanding
    [Arguments]    ${HOST}    ${PORT}    ${Username}    ${Password}
    SSHLibrary.Open Connection    ${HOST}    port=${PORT}
    SSHLibrary.Login    ${Username}    ${Password}

###XML KEYWORDS###
Update Expected XML Elements for wsFinalLIQDestination - Delete
    [Documentation]    This keyword is used to update XML Elements using the input json values for wsFinalLIQDestination.
    ...    @author: clanding
    ...    12/20/18 updated by clanding: Changed userID to loginId
    ...    @update: amansuet    15AUG2019	- updated arguments
    [Arguments]   ${sInputFilePath}   ${sExpected_wsFinalLIQDestination}    ${sHTTPMethodType}    ${sloginId}    

    ${Expected_wsFinalLIQDestination}    Set Variable    ${dataset_path}${sInputFilePath}${sExpected_wsFinalLIQDestination}.xml
    ${template}   Run Keyword If    '${sHTTPMethodType}'=='DELETE'    Set Variable    ${Input_File_Path_Users}wsFinalLIQDestination_template_delete.xml
    ...    ELSE    FAIL    HTTP Method is not DELETE. Please check input dataset.
    Delete File If Exist    ${Expected_wsFinalLIQDestination}

    ${xpath}    Run Keyword If    '${sHTTPMethodType}'=='POST'    Set Variable    CreateUserSecurityProfile
    ...    ELSE IF    '${sHTTPMethodType}'=='PUT' or '${sHTTPMethodType}'=='DELETE'    Set Variable    UpdateUserProfile

    ${loginID}    Convert To Uppercase    ${sloginId}
    ${Updated_template}    Set Element Attribute    ${template}    loginId    ${loginID}    xpath=${xpath}
    ${Updated_template}    Set Element Attribute    ${Updated_template}    userStatus    I    xpath=${xpath}

    ${attr}    XML.Get Element Attributes    ${Updated_template}    ${xpath}
    Save Xml    ${Updated_template}    ${Expected_wsFinalLIQDestination}

###OTHER KEYWORDS###
Evaluate Email Value
    [Documentation]    This keyword is used to validate if email is invalid
    ...    @author:jaquitan
    [Arguments]    ${field_value}
    ${email_format}    Run Keyword And Return Status    Should Match Regexp    ${field_value}    ^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$
    ${val2}    Run Keyword If    ${email_format}==False    Set Variable    True
    [Return]    ${val2}

Handle Roles
    [Documentation]    @author:jaquitan
    [Arguments]    @{roles}
    :FOR   ${role}   IN  @{roles}
    \   Log  ${role}
    \   ${val}    ${key}    Get Data from JSON object and handle single data    ${role}    $..role    1    20
    \    Run Keyword If    ${val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_Role
         ...    ELSE IF    ${key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_Role

Handle AdditionalBusinessEntity
    [Documentation]    @author:jaquitan
    [Arguments]    @{additionalBusinessEntities}
    :FOR   ${additionalBusinessEntity}   IN  @{additionalBusinessEntities}
    \   Log  ${additionalBusinessEntity}
    \   ${val}    ${key}    Get Data from JSON object and handle single data    ${additionalBusinessEntity}    $..businessEntityName    2    20
    \    Run Keyword If    ${val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_BusinessEntityName
         ...    ELSE IF    ${key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_BusinessEntityName
    \   ${val}    ${key}    Get Data from JSON object and handle single data    ${additionalBusinessEntity}    $..defaultBranch    2    10
    \    Run Keyword If    ${val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_DefaultBranch
         ...    ELSE IF    ${key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_DefaultBranch

Handle AdditionalDepartments
    [Documentation]    @author:jaquitan
    [Arguments]    @{additionalDepartments}
    :FOR   ${additionalDepartment}   IN  @{additionalDepartments}
    \   Log  ${additionalDepartment}
    \   ${val}    ${key}    Get Data from JSON object and handle single data    ${additionalDepartment}    $..departmentCode    1    5
    \    Run Keyword If    ${val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_DepartmentCode
         ...    ELSE IF    ${key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_DepartmentCode

Handle AdditionalProcessingArea
    [Documentation]    @author:jaquitan
    [Arguments]    @{additionalProcessingAreas}
    :FOR   ${additionalProcessingArea}   IN  @{additionalProcessingAreas}
    \   Log  ${additionalProcessingArea}
    \   ${val}    ${key}    Get Data from JSON object and handle single data    ${additionalProcessingArea}    $..processingArea    2    5
    \    Run Keyword If    ${val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_ProcessingAreaCode
         ...    ELSE IF    ${key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_ProcessingAreaCode

Create Dictionary for Single Sub-Keyfield
    [Documentation]    This keyword is used to create dictionary for single data sub-keyfield.
    ...    i.e. "defaultProcessingArea": {"processingArea": "CB02"}
    ...    @author: clanding
    [Arguments]    ${datalist}    ${INDEX_0}    ${subkeyfield}
    ${value_from_list}    Get From List    ${datalist}    ${INDEX_0}
    ${emptyval}    Set Variable    ${subkeyfield}=""
    ${nullval}    Set Variable    ${subkeyfield}=null
    ${value_from_list_0}    Run Keyword If    '${value_from_list}'=='${emptyval}'    Set Variable    ${EMPTY}
    ...    ELSE IF    '${value_from_list}'=='${nullval}'    Set Variable    ${NONE}
    ...    ELSE    Set Variable    ${value_from_list}
    ${value_dict}    Run Keyword If    '${value_from_list}'==''    Set Variable    ${EMPTY}
    ...    ELSE IF    '${value_from_list}'=='null'    Set Variable    ${NONE}
    ...    ELSE    Create Dictionary    ${subkeyfield}=${value_from_list_0}
    ${mainfield_dict}    Set Variable    ${value_dict}
    [Return]    ${mainfield_dict}

Create Dictionary for Multiple Same Sub-Keyfield
    [Documentation]    This keyword is used to create dictionary for multiple data (array) with multiple same sub-keyfield.
    ...    i.e. "additionalProcessingArea": [{"processingArea": "CB01"}, {"processingArea": "CB"}]
    ...    @author: jaquitan/clanding
    [Arguments]    ${datalist}    ${INDEX_0}    ${subkeyfield}
    ${value_from_list}    Get From List    ${datalist}    ${INDEX_0}
    ${emptyval}    Set Variable    ${subkeyfield}=""
    ${nullval}    Set Variable    ${subkeyfield}=null
    ${notagval}    Set Variable    ${subkeyfield}=no tag
    ${multipleval}    Run Keyword And Return Status    Should Contain    ${value_from_list}    /
    ${value_from_list}    Run Keyword If    ${multipleval}==False    Get From List    ${datalist}    ${INDEX_0}
    ...    ELSE    Get Multiple Data    ${value_from_list}
    ${value_from_list_0}    Run Keyword If    ${multipleval}==False    Get From List    ${datalist}    ${INDEX_0}
    ${subkeyfield_dict}    Run Keyword If    ${multipleval}==False and '${value_from_list_0}'=='${emptyval}'    Create Dictionary    ${subkeyfield}=${EMPTY}
    ...    ELSE IF    ${multipleval}==False and '${value_from_list_0}'=='${nullval}'    Create Dictionary    ${subkeyfield}=${NONE}
    ...    ELSE IF    ${multipleval}==False and '${notagval}'=='${value_from_list_0}'    Create Dictionary
    ...    ELSE IF    ${multipleval}==False    Create Dictionary    ${subkeyfield}=${value_from_list}
    ...    ELSE    Create Dictionary for Single Multiple Data    ${value_from_list}    ${subkeyfield}
    ${mainkeyfield}    Run Keyword If    ${multipleval}==False    Create List           ${subkeyfield_dict}
    ...    ELSE    Set Variable           ${subkeyfield_dict}
    [Return]    ${mainkeyfield}

Create Dictionary for Single Set of Multiple Different Sub-Keyfields
    [Documentation]    This keyword is used to create dictionary for multiple different sub-keyfields.
    ...    i.e. "defaultBusinessEntity": {"defaultBranch": "value2", "businessEntityName": "value1"}
    ...    @author: jaquitan/clanding
    ...    @update: jloretizo	03SEP2019	- added additional arguments for sLOB, specifically for comrlending.
    [Arguments]    ${datalist}    ${INDEX_0}    ${subkeyfield_list}    ${sLOB}=None
    ${value_from_list}    Get From List    ${datalist}    ${INDEX_0}
    ${multipleval}    Run Keyword And Return Status    Should Contain    ${value_from_list}    |

    ${subfield_val}    Run Keyword If    ${multipleval}==True    Split String    ${value_from_list}    |
    ...    ELSE    Set Variable    ${value_from_list}

    ${keyfield_count}    Run Keyword If    ${multipleval}==True    Get Length    ${subfield_val}
    ...    ELSE    Set Variable    1
    ${INDEX_00}    Set Variable    0
    ${tempdict}    Create Dictionary
    ${subkeyfieldlist}    Split String    ${subkeyfield_list}    ,
    :FOR    ${INDEX_00}    IN RANGE    ${keyfield_count}
    \    Exit For Loop If    ${INDEX_00}==${keyfield_count}
    \    ${subkeyfield}    Get From List    ${subkeyfieldlist}    ${INDEX_00}
    \    ${subkeyfield_0}    Run Keyword If    ${keyfield_count}==1    Get From List    ${subkeyfieldlist}    0
    \    ${subkeyfield_1}    Run Keyword If    ${keyfield_count}==1    Get From List    ${subkeyfieldlist}    1
    \    ${subkeyfield_0_exist}    Run Keyword And Return Status    Should Contain    ${subfield_val}    ${subkeyfield_0}
    \    ${subkeyfield_1_exist}    Run Keyword And Return Status    Should Contain    ${subfield_val}    ${subkeyfield_1}
    \    ${subfield_val_0}    Run Keyword If    ${keyfield_count}==2    Get From List    ${subfield_val}    0
    \    ${subkeyfield_val}    Run Keyword If    ${keyfield_count}==1    Set Variable    ${subfield_val}
         ...    ELSE    Get From List    ${subfield_val}    ${INDEX_00}
    \    ${emptyval}    Run Keyword If    ${keyfield_count}==1 and ${subkeyfield_0_exist}==True    Set Variable    ${subkeyfield_0}=""
         ...    ELSE IF    ${keyfield_count}==1 and ${subkeyfield_1_exist}==True    Set Variable    ${subkeyfield_1}=""
         ...    ELSE    Set Variable    ${subkeyfield}=""
    \    ${nullval}    Set Variable    ${subkeyfield}=null
    \    Run Keyword If    ${keyfield_count}==2 and '${subkeyfield_val}'=='${emptyval}'    Set To Dictionary    ${tempdict}    ${subkeyfield}=${EMPTY}
         ...    ELSE IF    ${keyfield_count}==2 and '${subkeyfield_val}'=='${nullval}'    Set To Dictionary    ${tempdict}    ${subkeyfield}=${NONE}
         ...    ELSE IF    ${keyfield_count}==1 and '${subkeyfield_val}'=='${emptyval}' and ${subkeyfield_0_exist}==True    Set To Dictionary    ${tempdict}    ${subkeyfield_0}=${EMPTY}
         ...    ELSE IF    ${keyfield_count}==1 and '${subkeyfield_val}'=='${nullval}' and ${subkeyfield_0_exist}==True    Set To Dictionary    ${tempdict}    ${subkeyfield_0}=${NONE}
         ...    ELSE IF    ${keyfield_count}==1 and '${subkeyfield_val}'=='${emptyval}' and ${subkeyfield_1_exist}==True    Set To Dictionary    ${tempdict}    ${subkeyfield_1}=${EMPTY}
         ...    ELSE IF    ${keyfield_count}==1 and '${subkeyfield_val}'=='${nullval}' and ${subkeyfield_1_exist}==True    Set To Dictionary    ${tempdict}    ${subkeyfield_1}=${NONE}
         ...    ELSE IF    '${subkeyfield}'=='businessEntityName' and '${sLOB}'=='${COMRLENDING}'    Log    No Business Entity Name is generated for LOANIQ GET FFC Response!
         ...    ELSE    Set To Dictionary    ${tempdict}    ${subkeyfield}=${subkeyfield_val}
    ${tempdict}    Run Keyword If    '${subkeyfield_val}'==''    Set Variable    ${EMPTY}
    ...    ELSE IF    '${subkeyfield_val}'=='null'    Set Variable    ${NONE}
    ...    ELSE IF    '${subkeyfield_val}'=='no tag'    Create List
    ...    ELSE    Set Variable    ${tempdict}
    [Return]    ${tempdict}

Create Dictionary for Multiple Set of Multiple Different Sub-Keyfields
    [Documentation]    This keyword is used to create dictionary for multiple set of multiple different sub-keyfieds.
    ...    i.e. "additionalBusinessEntity": [{"defaultBranch": "CB0001", "businessEntityName": "Australia1"}, {"defaultBranch": "CB00011", "businessEntityName": "Australia11"}]
    ...    or "additionalDepartments": [{"departmentCode": "GLB2"}, {"departmentCode": "GB"}]
    ...    @author: clandingin
    [Arguments]    ${list}    ${INDEX_0}    ${subkeyfield_list}

    ##get keyfield value
    ${value_list}    Get From List    ${list}    ${INDEX_0}
    ${MultipleValue}    Run Keyword And Return Status    Should Contain    ${value_list}    /
    ${value}    Run Keyword If    ${MultipleValue}==False    Get From List    ${list}    ${INDEX_0}
    ...    ELSE    Get Multiple Data    ${value_list}
    ${val_dict}    Run Keyword If    ${MultipleValue}==False    Create Dictionary for Multiple Fields    ${value}    ${subkeyfield_list}
    ...    ELSE    Create Dictionary for List Multiple Data    ${value}    ${subkeyfield_list}
     ${final_dict}    Run Keyword If    ${MultipleValue}==False    Create List           ${val_dict}
    ...    ELSE    Set Variable     ${val_dict}
    [Return]    ${final_dict}

Create Dictionary for Multiple Fields
    [Documentation]    This keyword is used to create dictionary for multiple fields.
    ...    @author: jaquitan
    ...    @updated: jaquitan    21May2019    used parameter in keyword, removed hardcoded value
   [Arguments]    ${value_from_list}    ${defaultBusinessEntity_sublist}
   ${multipleval}    Run Keyword And Return Status    Should Contain    ${value_from_list}    |
   ${subfield_val}    Run Keyword If    ${multipleval}==True    Split String    ${value_from_list}    |
    ...    ELSE    Set Variable    ${value_from_list}

    ${keyfield_count}    Run Keyword If    ${multipleval}==True    Get Length    ${subfield_val}
    ...    ELSE    Set Variable    1
    ${INDEX_00}    Set Variable    0
    ${tempdict}    Create Dictionary
    ${subkeyfieldlist}    Split String    ${defaultBusinessEntity_sublist}    ,
    :FOR    ${INDEX_00}    IN RANGE    ${keyfield_count}
    \    Exit For Loop If    ${INDEX_00}==${keyfield_count}
    \    ${subkeyfield}    Get From List    ${subkeyfieldlist}    ${INDEX_00}
    \    ${subkeyfield_0}    Run Keyword If    ${keyfield_count}==1    Get From List    ${subkeyfieldlist}    0
    \    ${subkeyfield_1}    Run Keyword If    ${keyfield_count}==1    Get From List    ${subkeyfieldlist}    1
    \    ${subkeyfield_0_exist}    Run Keyword And Return Status    Should Contain    ${subfield_val}    ${subkeyfield_0}
    \    ${subkeyfield_1_exist}    Run Keyword And Return Status    Should Contain    ${subfield_val}    ${subkeyfield_1}
    \    ${subfield_val_0}    Run Keyword If    ${keyfield_count}==2    Get From List    ${subfield_val}    0
    \    ${subkeyfield_val}    Run Keyword If    ${keyfield_count}==1    Set Variable    ${subfield_val}
         ...    ELSE    Get From List    ${subfield_val}    ${INDEX_00}
    \    ${emptyval}    Run Keyword If    ${keyfield_count}==1 and ${subkeyfield_0_exist}==True    Set Variable    ${subkeyfield_0}=""
         ...    ELSE IF    ${keyfield_count}==1 and ${subkeyfield_1_exist}==True    Set Variable    ${subkeyfield_1}=""
         ...    ELSE    Set Variable    ${subkeyfield}=""
    \    ${nullval}    Set Variable    ${subkeyfield}=null
    \    Run Keyword If    ${keyfield_count}==2 and '${subkeyfield_val}'=='${emptyval}'    Set To Dictionary    ${tempdict}    ${subkeyfield}=${EMPTY}
         ...    ELSE IF    ${keyfield_count}==2 and '${subkeyfield_val}'=='${nullval}'    Set To Dictionary    ${tempdict}    ${subkeyfield}=${NONE}
         ...    ELSE IF    ${keyfield_count}==1 and '${subkeyfield_val}'=='${emptyval}' and ${subkeyfield_0_exist}==True    Set To Dictionary    ${tempdict}    ${subkeyfield_0}=${EMPTY}
         ...    ELSE IF    ${keyfield_count}==1 and '${subkeyfield_val}'=='${nullval}' and ${subkeyfield_0_exist}==True    Set To Dictionary    ${tempdict}    ${subkeyfield_0}=${NONE}
         ...    ELSE IF    ${keyfield_count}==1 and '${subkeyfield_val}'=='${emptyval}' and ${subkeyfield_1_exist}==True    Set To Dictionary    ${tempdict}    ${subkeyfield_1}=${EMPTY}
         ...    ELSE IF    ${keyfield_count}==1 and '${subkeyfield_val}'=='${nullval}' and ${subkeyfield_1_exist}==True    Set To Dictionary    ${tempdict}    ${subkeyfield_1}=${NONE}
         ...    ELSE    Set To Dictionary    ${tempdict}    ${subkeyfield}=${subkeyfield_val}
    ${tempdict}    Run Keyword If    '${subkeyfield_val}'==''    Set Variable    ${EMPTY}
    ...    ELSE IF    '${subkeyfield_val}'=='null'    Set Variable    ${NONE}
    ...    ELSE    Set Variable    ${tempdict}
    [Return]    ${tempdict}

Get Multiple Data
    [Documentation]    This keyword is used to get multiple data for sub keyfield.
    ...    @author: jaquitan/clanding
    [Arguments]    ${val_list}
    ${list}    Split String    ${val_list}    /
    ${list_count}    Get Length    ${list}
    ${INDEX_0}    Set Variable    0
    ${final_list}    Create List
    :FOR    ${INDEX_0}    IN RANGE    ${list_count}
    \    Exit For Loop If    ${INDEX_0}==${list_count}
    \    ${list_val}    Get From List    ${list}    ${INDEX_0}
    \    Append To List    ${final_list}    ${list_val}
    [Return]    ${final_list}

Create Dictionary for Single Multiple Data
    [Documentation]    This keyword is used to create dictionary for multiple data for sub keyfields.
    ...    @author: jaquitan/clanding
    [Arguments]    ${list}    ${subkeyfield}
    ${list_count}    Get Length    ${list}
    ${INDEX_0}    Set Variable    0
    ${main_list}    Create List
    :FOR    ${INDEX_0}    IN RANGE    ${list_count}
    \    Exit For Loop If    ${INDEX_0}==${list_count}
    \    ${list_val}    Get From List    ${list}    ${INDEX_0}
    \    ${dictionary}    Run Keyword If    '${list_val}'==''    Set Variable    ${EMPTY}
         ...    ELSE IF    '${list_val}'=='null'    Set Variable    ${NONE}
         ...    ELSE    Create Dictionary    ${subkeyfield}=${list_val}
    \    Append To List    ${main_list}    ${dictionary}
    \    Log    ${main_list}
    Log    ${dictionary}
    [Return]    ${main_list}

Create Dictionary for List Multiple Data
    [Documentation]    This keyword is used to create dictionary for multiple data for sub keyfields.
    ...    @author: jaquitan
    [Arguments]    ${list}    ${field_sublist}
    ${list_count}    Get Length    ${list}
    ${INDEX_0}    Set Variable    0
    ${main_list}    Create List
    :FOR    ${INDEX_0}    IN RANGE    ${list_count}
    \    Exit For Loop If    ${INDEX_0}==${list_count}
    \    ${list_val}    Get From List    ${list}    ${INDEX_0}
    \    ${dictionary}    Create Dictionary for Multiple Fields    ${list_val}    ${field_sublist}
    \    Append To List    ${main_list}    ${dictionary}
    \    Log    ${main_list}
    Log    ${dictionary}
    [Return]    ${main_list}

Create Dictionary for Multiple Same Sub-Keyfield with Null/No Tag value
    [Documentation]    This keyword is used to create dictionary for multiple data (array) with multiple same sub-keyfield.
    ...    i.e. "additionalProcessingArea": [null]
    ...    @author: jaquitan/clanding
    [Arguments]    ${datalist}    ${INDEX_0}    ${subkeyfield}
    ${value_from_list}    Get From List    ${datalist}    ${INDEX_0}
    ${emptyval}    Set Variable    ${subkeyfield}=""
    ${nullval}    Set Variable    ${subkeyfield}=null
    ${multipleval}    Run Keyword And Return Status    Should Contain    ${value_from_list}    /
    ${value_from_list}    Run Keyword If    ${multipleval}==False    Get From List    ${datalist}    ${INDEX_0}
    ...    ELSE    Get Multiple Data    ${value_from_list}
    ${value_from_list_0}    Run Keyword If    ${multipleval}==False    Get From List    ${datalist}    ${INDEX_0}
    ${subkeyfield_dict}    Run Keyword If    ${multipleval}==False and '${value_from_list_0}'=='${emptyval}'    Create Dictionary    ${subkeyfield}=${EMPTY}
    ...    ELSE IF    ${multipleval}==False and '${value_from_list_0}'=='${nullval}'    Create Dictionary    ${subkeyfield}=${NONE}
    ...    ELSE IF    ${multipleval}==False    Create Dictionary    ${subkeyfield}=${value_from_list}
    ...    ELSE    Create Dictionary for Single Multiple Data    ${value_from_list}    ${subkeyfield}
    ${mainkeyfield}    Run Keyword If    ${multipleval}==False    Create List           ${subkeyfield_dict}
    ...    ELSE    Set Variable           ${subkeyfield_dict}
    [Return]    ${mainkeyfield}

Evaluate Field Value
    [Documentation]    This keyword is used to evaluate the value for field length mismatch
    ...    value "",<min,>max
    ...    @author: jaquitan
    [Arguments]    ${field_None}    ${field_value_empty}    ${field_value_length}    ${min}    ${max}
    ${val}    Run Keyword If    ${field_None}==False and ${field_value_empty}==True      Set Variable    True
    ...    ELSE    Run Keyword And Return Status    Should Be True    ${field_value_length}<${min} or ${field_value_length}>${max}
    [Return]    ${val}


Evaluate Config File for Invalid Field value
    [Documentation]    This keyword is used to get corresponding Role value from the config setup of the Role value from the input payload
    ...    @author: clanding/jaquitan
    [Arguments]    ${ConfigFile}    ${inputvalue}

    ${Valid_FieldValues}    OperatingSystem.Get File    ${ConfigFile}
    ${Valuelist}    Split String    ${Valid_FieldValues}   ,
    ${Value_count}    Get Length    ${Valuelist}
    ${ValueDict}    Create List
    ${i}    Set Variable    0
    :FOR    ${i}    IN RANGE    ${Value_count}
    \    ${field_val}    Get From List    ${Valuelist}    ${i}
    \    ${FieldValue_Status}    Run Keyword And Return Status    Should Be Equal    ${field_val}    ${inputvalue}
    \    Exit For Loop If    ${FieldValue_Status}==True
    \    Exit For Loop If    '${i}'=='${Value_count}'
    [Return]    ${FieldValue_Status}

Create Array for Multiple Values
    [Documentation]    This keyword is used to create dictionary for single data (array) with multiple value.
    ...    i.e. "subEntity": ["AUSTRALIA","SINGAPORE"]
    ...    @author: clanding
    ...    @update: clanding    22MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet_v1.0.1
    [Arguments]    ${aDataList}    ${iDataIndex}    ${sSubKeyfield}    ${cDelimiter}
    ${Value_From_List}    Get From List    ${aDataList}    ${iDataIndex}
    ${MultipleVal}    Run Keyword And Return Status    Should Contain    ${Value_From_List}    ${cDelimiter}
    ${Value_From_List_1}    Run Keyword If    ${MultipleVal}==False    Get From List    ${aDataList}    ${iDataIndex}
    ...    ELSE    Get Multiple Data for Same Field    ${Value_From_List}    ${cDelimiter}
    ${Value_From_List_0}    Run Keyword If    ${MultipleVal}==False    Get From List    ${aDataList}    ${iDataIndex}
    ${MainKeyfield}    Run Keyword If    ${MultipleVal}==True    Set Variable    ${Value_From_List_1}
    ...    ELSE IF    ${MultipleVal}==False and '${Value_From_List_0}'=='${EMPTY}'    Create List    ${EMPTY}
    ...    ELSE IF    ${MultipleVal}==False and '${Value_From_List_0}'=='null'    Set Variable    ${NONE}
    ...    ELSE IF    ${MultipleVal}==False and '${Value_From_List_0}'=='no tag'    Set Variable
    ...    ELSE IF    ${MultipleVal}==False    Create List    ${Value_From_List_0}
    [Return]    ${MainKeyfield}

Create Array for Multiple Values for Expected Response
    [Documentation]    This keyword is used to create dictionary for single data (array) with multiple value.
    ...    i.e. "subEntity": ["AUSTRALIA","SINGAPORE"]
    ...    @author: clanding
    ...    @update: clanding    22MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet_v1.0.1
    [Arguments]    ${aDataList}    ${iDataIndex}    ${sSubKeyfield}    ${cDelimiter}
    ${Value_From_List}    Get From List    ${aDataList}    ${iDataIndex}
    ${MultipleVal}    Run Keyword And Return Status    Should Contain    ${Value_From_List}    ${cDelimiter}
    ${Value_From_List_1}    Run Keyword If    ${MultipleVal}==False    Get From List    ${aDataList}    ${iDataIndex}
    ...    ELSE    Get Multiple Data for Same Field    ${Value_From_List}    ${cDelimiter}
    ${Value_From_List_0}    Run Keyword If    ${MultipleVal}==False    Get From List    ${aDataList}    ${iDataIndex}
    ${MainKeyfield}    Run Keyword If    ${MultipleVal}==True    Set Variable    ${Value_From_List_1}
    ...    ELSE IF    ${MultipleVal}==False and '${Value_From_List_0}'=='${EMPTY}'    Create List    ${EMPTY}
    ...    ELSE IF    ${MultipleVal}==False and '${Value_From_List_0}'=='null'    Set Variable    ${NONE}
    ...    ELSE IF    ${MultipleVal}==False and '${Value_From_List_0}'=='no tag'    Set Variable    ${NONE}
    ...    ELSE IF    ${MultipleVal}==False    Create List    ${Value_From_List_0}
    [Return]    ${MainKeyfield}

Get Multiple Data for Same Field
    [Documentation]    This keyword is used to get multiple data for sub keyfield.
    ...    @author: clanding
    [Arguments]    ${val_list}    ${Delimiter}
    ${list}    Split String    ${val_list}    ${Delimiter}
    ${list_count}    Get Length    ${list}
    ${INDEX_0}    Set Variable    0
    ${final_list}    Create List
    :FOR    ${INDEX_0}    IN RANGE    ${list_count}
    \    Exit For Loop If    ${INDEX_0}==${list_count}
    \    ${list_val}    Get From List    ${list}    ${INDEX_0}
    \    Append To List    ${final_list}    ${list_val}
    [Return]    ${final_list}

Get Column Header Index From Input Csv File And Return
    [Documentation]    This keyword is used get column header index from input csv file and return index.
    ...    @author: clanding    19FEB2019    - initial create
    [Arguments]    ${aCSV_Data}    ${sColumn_Header}
    
    ${Column_Header_Val_List}    Get From List    ${aCSV_Data}    0
    ${Column_Header_Val}    Get From List    ${Column_Header_Val_List}    0
    ${Column_Header_List}    Split String    ${Column_Header_Val}    ,
    ${Column_Header_Count}    Get Length    ${Column_Header_List}
    
    :FOR    ${INDEX}    IN RANGE    ${Column_Header_Count}
    \    ${Actual_Column_Header}    Get From List    ${Column_Header_List}    ${INDEX}
    \    Exit For Loop If    '${Actual_Column_Header}'=='${sColumn_Header}'
    ${Column_Header_Index}    Set Variable    ${INDEX}
    [Return]    ${Column_Header_Index}

Convert Input Price Type to Config Price Type and Return Config Price Type
    [Documentation]    This keyword is used to convert input price type based from the existing configured price type. It will return the Config Price Type value.
    ...    @author: clanding    19FEB2019    - initial create
    [Arguments]    ${sGS_INSTR_PRC_TYPE}
     
    ${CONFIG_PRICE_TYPE}    Run Keyword If    '${sGS_INSTR_PRC_TYPE}'=='Bid' or '${sGS_INSTR_PRC_TYPE}'=='BID'    Set Variable    BUYRATE
    ...    ELSE IF    '${sGS_INSTR_PRC_TYPE}'=='Mid' or '${sGS_INSTR_PRC_TYPE}'=='MID'    Set Variable    MIDRATE
    ...    ELSE IF    '${sGS_INSTR_PRC_TYPE}'=='Asked Price' or '${sGS_INSTR_PRC_TYPE}'=='ASK'    Set Variable    SELLRATE
    ...    ELSE IF    '${sGS_INSTR_PRC_TYPE}'=='Last'    Set Variable    LASTRATE
    
    [Return]    ${CONFIG_PRICE_TYPE}

Get LoanIQ Business Date per Zone and Return
    [Documentation]    This keyword is used to get LoanIQ Business Date given Zone number and return value.
    ...    @author: clanding    19FEB2019    - initial create
    ...    @update: clanding    19JUN2019    - added Close All Windows on LIQ
    [Arguments]    ${Zone}
    
    Select Actions    [Actions];Batch Administration
    mx LoanIQ activate window    ${LIQ_Batch_Admin_Window}
    ${Zone_Curr_Date}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Batch_Admin_TimeZone_JavaTree}    ${Zone}%Current%Zone_Curr_Date
    Close All Windows on LIQ
    [Return]    ${Zone_Curr_Date}
    
Round Off on the Nth Decimal Place
    [Documentation]    This keyword is used to round off given iRate on the iDecimalPlace and return value with 0 and without 0.
    ...    i.e. Round off 1.123456789 into 6th decimal place - iDecimalPlace value should be 6.
    ...    @author: clanding    11MAR2019    - initial create
    [Arguments]    ${iRate}    ${iDecimalPlace}
    
    ${iRate}    Convert To Number    ${iRate}    
    ${RoundOff_Rate_with_0}    Evaluate  "%${iDecimalPlace}f" % (${iRate})
    
    ${sRate}    Convert To String    ${RoundOff_Rate_with_0}
    ${sRate}    Strip String    ${sRate}    right    0
    ${RoundOff_Rate_without_0}    Convert To Number    ${sRate}    
    
    [Return]    ${RoundOff_Rate_with_0}    ${RoundOff_Rate_without_0}

### CONFIG ###
Get Default Branch Configuration and Return Corresponding Value
    [Documentation]    This keyword is used to get Default Branch Configuration and get equivalent value from config of the input value and return value
    ...    @author: clanding    15APR2019    - initial create
    ...    @update: clanding    22APR2019    - added handling for no matched in dictionary
    ...    @update: clanding    24APR2019    - update handling when config is not available for the given record
    ...    @update: clanding    07MAY2019    - added index for LOB
    [Arguments]    ${sBusinessEntity}    ${sDelimiter}    ${sLOB}    ${Index}=None
    
    ${Default_Branch_Config}    Run Keyword If    '${sLOB}'=='${COREBANKING}'    OperatingSystem.Get File    ${ESSENCE_BRANCH_CONFIG}
    ...    ELSE IF    '${sLOB}'=='${PARTY}'    OperatingSystem.Get File    ${PARTY_BRANCH_CONFIG}
    
    ${BusinessEntity_List}    Split String    ${sBusinessEntity}    ,
    ${BusinessEntity_Val}    Run Keyword If    '${Index}'=='None'    Set Variable    ${sBusinessEntity}
    ...    ELSE    Get From List    ${BusinessEntity_List}    ${Index}
    ${Default_Branch_Dictionary}    Create Dictionary    
    ${Branch_Count}    Get Line Count    ${Default_Branch_Config}
    :FOR    ${Index}    IN RANGE    ${Branch_Count}
    \    ${Default_Branch_Line}    Get Line    ${Default_Branch_Config}    ${Index}
    \    ${Default_Branch_LineList}    Split String    ${Default_Branch_Line}    =
    \    ${Default_Branch_Key}    Get From List    ${Default_Branch_LineList}    0
    \    ${Default_Branch_Value}    Get From List    ${Default_Branch_LineList}    1
    \    Set To Dictionary    ${Default_Branch_Dictionary}    ${Default_Branch_Key}=${Default_Branch_Value}
    Log    ${Default_Branch_Dictionary}
    ${DefaultBusinessEntity_List}    Split String    ${BusinessEntity_Val}    ${sDelimiter}
    ${Branch}    Get From List    ${DefaultBusinessEntity_List}    1
    ${Branch_Config_Matched}    Run Keyword And Return Status    Get From Dictionary    ${Default_Branch_Dictionary}    ${Branch}
    ${Branch_Config_Value}    Run Keyword If    ${Branch_Config_Matched}==${True}    Get From Dictionary    ${Default_Branch_Dictionary}    ${Branch}
    ...    ELSE IF    ${Branch_Config_Matched}==${False}    Set Variable    ${Branch}
    [Return]    ${Branch_Config_Value}

Get Default Zone Configuration and Return Corresponding Value
    [Documentation]    This keyword is used to get Zone Configuration and get equivalent value from config of the input value and return value.
    ...    @author: clanding    16APR2019    - initial create
    ...    @update: clanding    22APR2019    - added Party Config, added handling for no matched in dictionary
    ...    @update: clanding    24APR2019    - update handling when config is not available for the given record
    ...    @update: clanding    07MAY2019    - updated Zone_Config_Matched when value is False, added handling for multiple LOB
    [Arguments]    ${sBusinessEntity}    ${sDelimiter}    ${sLOB}    ${Index}=None
    
    ${ZoneConfig}    Run Keyword If    '${sLOB}'=='${COREBANKING}'    OperatingSystem.Get File    ${ESSENCE_ZONE_CONFIG}
    ...    ELSE IF    '${sLOB}'=='${PARTY}'    OperatingSystem.Get File    ${PARTY_BUSINESSENTITY_CONFIG}
    
    ${BusinessEntity_List}    Split String    ${sBusinessEntity}    ,
    ${BusinessEntity_Val}    Run Keyword If    '${Index}'=='None'    Set Variable    ${sBusinessEntity}
    ...    ELSE    Get From List    ${BusinessEntity_List}    ${Index}
    ${Zone_Dictionary}    Create Dictionary    
    ${Zone_Count}    Get Line Count    ${ZoneConfig}
    :FOR    ${Index}    IN RANGE    ${Zone_Count}
    \    ${Zone_Line}    Get Line    ${ZoneConfig}    ${Index}
    \    ${Zone_LineList}    Split String    ${Zone_Line}    =
    \    ${Zone_Key}    Get From List    ${Zone_LineList}    0
    \    ${Zone_Value}    Get From List    ${Zone_LineList}    1
    \    Set To Dictionary    ${Zone_Dictionary}    ${Zone_Key}=${Zone_Value}
    Log    ${Zone_Dictionary}
    ${DefaultBusinessEntity_List}    Split String    ${BusinessEntity_Val}    ${sDelimiter}
    ${Zone}    Get From List    ${DefaultBusinessEntity_List}    0
    ${Zone_Config_Matched}    Run Keyword And Return Status    Get From Dictionary    ${Zone_Dictionary}    ${Zone.upper()}
    ${Zone_Config_Value}    Run Keyword If    ${Zone_Config_Matched}==${True}    Get From Dictionary    ${Zone_Dictionary}    ${Zone.upper()}
    ...    ELSE IF    ${Zone_Config_Matched}==${False}    Set Variable    ${Zone.upper()}
    [Return]    ${Zone_Config_Value}

Get Additional Branch Configuration and Return Corresponding Value List
    [Documentation]    This keyword is used to get Default Branch Configuration and get equivalent value from config of the input value and return list.
    ...    @author: clanding    16APR2019    - initial create
    [Arguments]    ${sBusinessEntity}    ${sDelimiter}    ${sLOB}    ${Index_LOB}
    
    ${Branch_Config_List}    Create List    
    ${BusinessEntity_List}    Split String    ${sBusinessEntity}    ,
    ${AddBusinessEntity_LOB}    Get From List    ${BusinessEntity_List}    ${Index_LOB}
    ${AddBusinessEntityList}    Split String    ${AddBusinessEntity_LOB}    /
    ${AddBusinessEntityList_Count}    Get Length    ${AddBusinessEntityList}
    :FOR    ${Index}    IN RANGE    ${AddBusinessEntityList_Count}
    \
    \    ${AddBusinessEntity}    Get From List    ${AddBusinessEntityList}    ${Index}
    \    ${ContainsNull}    Run Keyword And Return Status    Should Contain    ${AddBusinessEntity}    null
    \    ${ContainsNoTag}    Run Keyword And Return Status    Should Contain    ${AddBusinessEntity}    no tag
    \    ${ContainsEmpty}    Run Keyword And Return Status    Should Be Empty    ${AddBusinessEntity}
    \    ${BranchValue}    Run Keyword If    ${ContainsNull}==${True}    Log    No Additional Business Entity in the input.
         ...    ELSE IF    ${ContainsNoTag}==${True}    Log    No Additional Business Entity in the input.
         ...    ELSE IF    ${ContainsEmpty}==${True}    Log    No Additional Business Entity in the input.
         ...    ELSE    Get Default Branch Configuration and Return Corresponding Value    ${AddBusinessEntity}    ${sDelimiter}    ${sLOB}
    \    Append To List    ${Branch_Config_List}    ${BranchValue} 
    \
    \    Exit For Loop If    ${Index}==${AddBusinessEntityList_Count}
    Log    ${Branch_Config_List}
    
    [Return]    ${Branch_Config_List}

Get Additional Zone Configuration and Return Corresponding Value List
    [Documentation]    This keyword is used to get Zone Configuration and get equivalent value from config of the input value and return list.
    ...    @author: clanding    16APR2019    - initial create
    [Arguments]    ${sBusinessEntity}    ${sDelimiter}    ${sLOB}    ${Index_LOB}
    
    ${Zone_Config_List}    Create List    
    ${BusinessEntity_List}    Split String    ${sBusinessEntity}    ,
    ${AddBusinessEntity_LOB}    Get From List    ${BusinessEntity_List}    ${Index_LOB}
    ${AddBusinessEntityList}    Split String    ${AddBusinessEntity_LOB}    /
    ${AddBusinessEntityList_Count}    Get Length    ${AddBusinessEntityList}
    :FOR    ${Index}    IN RANGE    ${AddBusinessEntityList_Count}
    \
    \    ${AddBusinessEntity}    Get From List    ${AddBusinessEntityList}    ${Index}
    \    ${ContainsNull}    Run Keyword And Return Status    Should Contain    ${AddBusinessEntity}    null
    \    ${ContainsNoTag}    Run Keyword And Return Status    Should Contain    ${AddBusinessEntity}    no tag
    \    ${ContainsEmpty}    Run Keyword And Return Status    Should Be Empty    ${AddBusinessEntity}
    \    ${ZoneValue}    Run Keyword If    ${ContainsNull}==${True}    Log    No Additional Business Entity in the input.
         ...    ELSE IF    ${ContainsNoTag}==${True}    Log    No Additional Business Entity in the input.
         ...    ELSE IF    ${ContainsEmpty}==${True}    Log    No Additional Business Entity in the input.
         ...    ELSE    Get Default Zone Configuration and Return Corresponding Value    ${AddBusinessEntity}    ${sDelimiter}    ${sLOB}
    \    Append To List    ${Zone_Config_List}    ${ZoneValue} 
    \
    \    Exit For Loop If    ${Index}==${AddBusinessEntityList_Count}
    Log    ${Zone_Config_List}
    
    [Return]    ${Zone_Config_List}

Get Language Description from Code and Return Description
    [Documentation]    This keyword is used to get Language Description from provided Locale Code.
    ...    @author: clanding    16APR2019    - initial create
    ...    @update: clanding    22APR2019    - added handling for no matched in dictionary
    [Arguments]    ${sLanguageCode}
    
    ${Language_Dictionary}    Create Dictionary    
    ${LanguageConfig}    OperatingSystem.Get File    ${LOCAL_CONFIG}
    ${Language_Count}    Get Line Count    ${LanguageConfig}
    :FOR    ${Index}    IN RANGE    ${Language_Count}
    \    ${LanguageConfig_Line}    Get Line    ${LanguageConfig}    ${Index}
    \    ${LanguageConfig_LineList}    Split String    ${LanguageConfig_Line}    =
    \    ${LanguageConfig_Key}    Get From List    ${LanguageConfig_LineList}    0
    \    ${LanguageConfig_Value}    Get From List    ${LanguageConfig_LineList}    1
    \    Set To Dictionary    ${Language_Dictionary}    ${LanguageConfig_Key}=${LanguageConfig_Value}
    
    Log    ${Language_Dictionary}
    ${Language_Desc}    Run Keyword And Continue On Failure    Get From Dictionary    ${Language_Dictionary}    ${sLanguageCode}
    ${Language_Matched}    Run Keyword And Return Status    Get From Dictionary    ${Language_Dictionary}    ${sLanguageCode}
    Run Keyword If    ${Language_Matched}==${False}    Log    '${sLanguageCode}' have no matched in the config.    level=ERROR
    ...    ELSE IF    ${Language_Matched}==${True}    Log    '${sLanguageCode}' have matched in the config.
    [Return]    ${Language_Desc}

Get Role Configuration and Return Corresponding Config Value
    [Documentation]    This keyword is used to get Role Configuration and get equivalent value from config of the input value and return value.
    ...    @author: clanding    16APR2019    - initial create
    ...    @update: clanding    22APR2019    - added party config, added handling for no matched in dictionary
    ...    @update: clanding    24APR2019    - update handling when config is not available for the given record
    [Arguments]    ${sRole}    ${sLOB}
    
    ${RoleConfig}    Run Keyword If    '${sLOB}'=='${COMRLENDING}'    OperatingSystem.Get File    ${LIQ_ROLE_CONFIG}
    ...    ELSE IF    '${sLOB}'=='${COREBANKING}'    OperatingSystem.Get File    ${ESSENCE_ROLE_CONFIG}
    ...    ELSE IF    '${sLOB}'=='${PARTY}'    OperatingSystem.Get File    ${PARTY_ROLE_CONFIG}
    ${Role_Dictionary}    Create Dictionary    
    ${Role_Count}    Get Line Count    ${RoleConfig}
    :FOR    ${Index}    IN RANGE    ${Role_Count}
    \    ${RoleConfig_Line}    Get Line    ${RoleConfig}    ${Index}
    \    ${RoleConfig_LineList}    Split String    ${RoleConfig_Line}    =
    \    ${RoleConfig_Key}    Get From List    ${RoleConfig_LineList}    0
    \    ${RoleConfig_Value}    Get From List    ${RoleConfig_LineList}    1
    \    Set To Dictionary    ${Role_Dictionary}    ${RoleConfig_Key}=${RoleConfig_Value}
    Log    ${Role_Dictionary}
    ${Role_Matched}    Run Keyword And Return Status    Get From Dictionary    ${Role_Dictionary}    ${sRole}
    ${Role_Config}    Run Keyword If    ${Role_Matched}==${True}    Get From Dictionary    ${Role_Dictionary}    ${sRole}
    ...    ELSE IF    ${Role_Matched}==${False}    Set Variable    ${sRole}
    [Return]    ${Role_Config}

Get Role Configuration and Return Corresponding Value List
    [Documentation]    This keyword is used to get Role Configuration and get equivalent value from config of the input value and return list.
    ...    @author: clanding    16APR2019    - initial create
    [Arguments]    ${sRole}    ${sLOB}    ${Index_LOB}
    
    ${Role_Config_List}    Create List    
    ${Role_List}    Split String    ${sRole}    ,
    ${Role_LOB}    Get From List    ${Role_List}    ${Index_LOB}
    ${RoleList}    Split String    ${Role_LOB}    /
    ${RoleList_Count}    Get Length    ${RoleList}
    :FOR    ${Index}    IN RANGE    ${RoleList_Count}
    \    ${Role}    Get From List    ${RoleList}    ${Index}
    \    ${Role_Config}    Get Role Configuration And Return Corresponding Config Value    ${Role}    ${sLOB}
    \    Append To List    ${Role_Config_List}    ${Role_Config} 
    \    Exit For Loop If    ${Index}==${RoleList_Count}
    [Return]    ${Role_Config_List}

Get Job Title Configuration and Return Corresponding Config Value
    [Documentation]    This keyword is used to get Job Title Configuration and get equivalent value from config of the input value and return value.
    ...    @author: clanding    16APR2019    - initial create
    ...    @update: clanding    22APR2019    - added Party Config, added handling for no matched in dictionary
    ...    @update: clanding    24APR2019    - update handling when config is not available for the given record
    [Arguments]    ${sTitle}    ${sLOB}
    
    ${TitleConfig}    Run Keyword If    '${sLOB}'=='${COMRLENDING}'    OperatingSystem.Get File    ${LIQ_JOBTITLE_CONFIG}
    ...    ELSE IF    '${sLOB}'=='${COREBANKING}'    OperatingSystem.Get File    ${ESSENCE_JOBTITLE_CONFIG}
    ...    ELSE IF    '${sLOB}'=='${PARTY}'    OperatingSystem.Get File    ${PARTY_TITLE_CONFIG} 
    ${Title_Dictionary}    Create Dictionary    
    ${Title_Count}    Get Line Count    ${TitleConfig}
    :FOR    ${Index}    IN RANGE    ${Title_Count}
    \    ${TitleConfig_Line}    Get Line    ${TitleConfig}    ${Index}
    \    ${TitleConfig_LineList}    Split String    ${TitleConfig_Line}    =
    \    ${TitleConfig_Key}    Get From List    ${TitleConfig_LineList}    0
    \    ${TitleConfig_Value}    Get From List    ${TitleConfig_LineList}    1
    \    Set To Dictionary    ${Title_Dictionary}    ${TitleConfig_Key}=${TitleConfig_Value}
    Log    ${Title_Dictionary}
    ${Title_Config_Matched}    Run Keyword And Return Status    Get From Dictionary    ${Title_Dictionary}    ${sTitle}
    ${Title_Config}    Run Keyword If    ${Title_Config_Matched}==${True}    Get From Dictionary    ${Title_Dictionary}    ${sTitle}
    ...    ELSE IF    ${Title_Config_Matched}==${False}    Set Variable    ${sTitle}
    [Return]    ${Title_Config}
   
Convert SQL Result to List and Return
    [Documentation]    This keyword is used to convert sql result to a readable list and return the list created.
    ...    @author: clanding    19JUN2019    - initial create
    [Arguments]    ${aSQLResult}
    
    ${SQL_Result_List}    Create List    
    :FOR    ${SQL_Result}    IN    @{aSQLResult}
    \    ${SQL_Result_0}    Get From List    ${SQL_Result}    0
    \    Append To List    ${SQL_Result_List}    ${SQL_Result_0}
    [Return]    ${SQL_Result_List}    

Generate Single Random Number and Return
    [Documentation]    This keyword is used to generate and return a single random number from a range given as input.
    ...    @author: cfrancis    06AUG2019    - inital create
    [Arguments]    ${iStart}    ${iEnd}
    
    ${iNumber}    Evaluate    random.sample(range(${iStart}, ${iEnd}), 1)    random
    ${iNumber}    Get From List    ${iNumber}    0
    [Return]    ${iNumber}

Get ProfileID and Return Corresponding Value from Excel
    [Documentation]    This keyword is used to get corresponding ProfileID value from from the given excel
    ...    @author: dahijara    16AUG2019    - initial create
    [Arguments]    ${sProfileIDList_from_Excel}    ${index}
    
    ${sProfileIDList}    Split String    ${sProfileIDList_from_Excel}    ,
    ${ProfileID}    Get From List    ${sProfileIDList}    ${index}
    [Return]    ${ProfileID}

Patch Json File
    [Documentation]    Send a Patch Request using sAPIEndPoint and sAccessToken. Data to be sent is from sInputFile
    ...    and response will be saved to sOutputFile.
    ...    @author: gerhabal    06SEP2019    - initial create and based this from "Post Json File" and "Put Json File" existing keywords
    ...    @update: rtarayao    14JAN2020    - added optional argument to handle request with Zone as one of the headers
    ...                                      - also added keyword to convert the response content to string
    [Arguments]    ${sInputPath}    ${sInputFile}    ${sAPIEndPoint}    ${sOutputPath}    ${sOutputFile}    ${sAccessToken}=None    ${sZone}=None
    
    &{Headers1}    Run Keyword If    '${sAccessToken}' != 'None' and '${sZone}' != 'None'    Create Dictionary    Content-Type=application/json    Zone=${sZone}    Authorization=${sAccessToken}
    ...    ELSE IF    '${sAccessToken}' != 'None' and '${sZone}' == 'None'    Create Dictionary    Content-Type=application/json    Authorization=${sAccessToken}
    ...    ELSE IF    '${sAccessToken}' == 'None' and '${sZone}'=='None'    Create Dictionary    Content-Type=application/json; charset=utf-8;
    ...    ELSE IF    '${sAccessToken}' == 'None' and '${sZone}' != 'None'    Create Dictionary    Content-Type=application/json    charset=utf-8    Zone=${sZone}
    Set Global Variable    ${Headers}    &{Headers1}
    
    ${InputJsonFile}    OperatingSystem.Get File    ${dataset_path}${sInputPath}${sInputFile}.json
    ${API_RESPONSE}    Patch Request    ${APISESSION}    ${sAPIEndPoint}    ${InputJsonFile}    headers=${Headers}
    Set Global Variable    ${API_RESPONSE}
    Log    PATCH Json Response: ${API_RESPONSE.content}
    ${API_RESPONSE_STRING}    Convert To String    ${API_RESPONSE.content}
    Create file    ${dataset_path}${sOutputPath}${sOutputFile}.json    ${API_RESPONSE_STRING}
    ${RESPONSE_FILE}    OperatingSystem.Get File    ${dataset_path}${sOutputPath}${sOutputFile}.json
    Log    ${RESPONSE_FILE}
    Set Global Variable    ${RESPONSE_FILE}
    [Return]    ${API_RESPONSE.content}
    
Delete Request API
    [Documentation]    This keyword is used to perform Delete Request for Party API
    ...    @author: gerhabal    18SEP2019    - initial create and based this from "Get Request API" existing keywords  
    ...    @update: rtarayao    07FEB2020    - added optional argument to handle request with Zone as one of the headers
    ...                                      - also added keyword to convert the response content to string  
    [Arguments]    ${sOutputPath}    ${sOutputFile}    ${sEndPoint}    ${sZone}=None    
    
    &{Headers1}    Run Keyword If    '${sZone}' != 'None'    Create Dictionary    Content-Type=application/json    Zone=${sZone}
    ...    ELSE IF    '${sZone}' == 'None'    Create Dictionary    Content-Type=application/json
    Set Global Variable    ${Headers}    &{Headers1}    

    ${API_RESPONSE}    Delete Request    ${APISESSION}    ${sEndPoint}   headers=${Headers}
    Set Global Variable    ${API_RESPONSE}
    Log    Delete Json Response: ${API_RESPONSE.content}
    ${API_RESPONSE_STRING}    Convert To String    ${API_RESPONSE.content}
    Delete File If Exist    ${dataset_path}${sOutputPath}${sOutputFile}.json
    Create file    ${dataset_path}${sOutputPath}${sOutputFile}.json    ${API_RESPONSE_STRING}
    ${RESPONSE_FILE}    OperatingSystem.Get File    ${dataset_path}${sOutputPath}${sOutputFile}.json
    Log    ${RESPONSE_FILE}
    Set Global Variable    ${RESPONSE_FILE}
            
Verify User Exists in LOBs
    [Documentation]    This keyword is used to verify that the User Exist in different LOB(Party, Essence, LIQ)
    ...    @author: jloretiz    10DEC2019    - initial create
    [Arguments]    ${sLoginID}  ${sLob}
    
    Delete All Sessions
    Create Session    ${APISESSION}    ${MDM_HOST}
    ${Headers}    Create Dictionary
    ${LOB_List}    Split String    ${sLob}    ,
    ${LOB_Count}    Get Length    ${LOB_List}
    ${INDEX}    Set Variable    0
    :FOR    ${INDEX}    IN RANGE    ${LOB_Count}
    \   ${API_RESPONSE}    Get Request    ${APISESSION}    ${MDM_User_API}/${sLoginId}${LOBS}${LOB_List}[${INDEX}]?${MDM_DATASOURCE_PARAM}    headers=${Headers}
    \   ${Resp_Status}    Run Keyword And Return Status    Should Be Equal As Strings    ${RESPONSECODE_200}    ${API_RESPONSE.status_code}
    \   Run Keyword If    ${Resp_Status}==${True}    Log    Response Status Code are matched! ${RESPONSECODE_200} == ${API_RESPONSE.status_code}     
        ...    ELSE IF    ${Resp_Status}==${False}    Log    Response Status Code are NOT matched! ${RESPONSECODE_200} != ${API_RESPONSE.status_code}   level=ERROR

Validate Technical Errors on API User Response
    [Documentation]    This keyword is used to validate the technical errors on API response.
    ...    @author: jloretiz    10DEC2019    - initial create
    ...    @update: jloretiz    17JAN2020    - renamed the keyword to make it generic
    [Arguments]    ${sResponseCode}    ${sErrors}

    ${Error_Count}    Get Length    ${sErrors}
    ${INDEX}    Set Variable    0
    :FOR    ${INDEX}    IN RANGE    ${Error_Count}
    \   ${ErrorDescription}   Get From List    ${sErrors}    ${INDEX} 
    \   Check for Technical Error Message   ${ErrorDescription}
    Verify Json Response Status Code    ${sResponseCode}

Remove Fields on JSON Payload
    [Documentation]    This keyword is used to validate the technical errors on API response.
    ...    @author: jloretiz    10DEC2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sInputJSON}    ${sFields}

    ${Field_Count}    Get Length    ${sFields}
    ${INDEX}    Set Variable    0

    ${JSON_File}    Set Variable    ${sInputFilePath}${sInputJSON}.json
    ${file}    OperatingSystem.Get File    ${dataset_path}${JSON_File}
    ${JSON_Object}    Load JSON From File    ${dataset_path}${JSON_File}

    :FOR    ${INDEX}    IN RANGE    ${Field_Count}
    \   ${FieldDescription}   Get From List    ${sFields}    ${INDEX} 
    \   Remove From Dictionary    ${JSON_Object}    ${FieldDescription}

    ${Converted_JSON}    Evaluate    json.dumps(${JSON_Object})        json
    Log    ${Converted_JSON}
    Delete File If Exist    ${dataset_path}${JSON_File}
    Create File    ${dataset_path}${JSON_File}    ${Converted_JSON}
    
Get the MessageId Decode Value
    [Documentation]    This keyword is used to get the MessageId Decode using CorrelationID
    ...    @author: fluberio    28OCT2020    - initial create
    [Arguments]    ${sCorrelationID}

    ${CorrelationIdByte}    Encode String To Bytes    ${sCorrelationID}     UTF-8
    ${MessageIdEncode}    B 32 Encode    ${CorrelationIdByte}
    ${MessageIdDecode}    Decode Bytes To String    ${MessageIdEncode}    UTF-8
    [Return]    ${MessageIdDecode}