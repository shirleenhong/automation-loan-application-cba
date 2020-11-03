*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

POST Request for User API with Error
    [Documentation]    This keyword is used to send POST request for the input JSON with Invalid Mandatory Fields.
    ...    This keyword caters both SSO and Non SSO requests.
    ...    @author: jloretiz    10DEC2019    - initial create
    ...    @author: jloretiz    14JAN2020    - renamed the keyword to a more generic name
    [Arguments]    ${sInputFilePath}    ${sInputJson}    ${sInputAPIResponse}    ${sOutputFilePath}    ${sOutputAPIResponse}
    ...    ${sInputFilePath_AccessToken}    ${sInputFile_AccessToken}
    
    Run Keyword If    '${SSO_ENABLED.upper()}'=='YES'    POST Request for User API with Token for Negative Scenario   ${sInputFilePath}    ${sInputJson}    ${sInputAPIResponse}    ${sOutputFilePath}    ${sOutputAPIResponse}
    ...    ${sInputFilePath_AccessToken}    ${sInputFile_AccessToken}
    Run Keyword If    '${SSO_ENABLED.upper()}'=='NO'    POST Request for User API without Token for Negative Scenario    ${sInputFilePath}    ${sInputJson}    ${sInputAPIResponse}    ${sOutputFilePath}    ${sOutputAPIResponse}

PUT Request for User API with Error
    [Documentation]    This keyword is used to send PUT request for the input JSON with Invalid Mandatory Fields.
    ...    This keyword caters both SSO and Non SSO requests.
    ...    @author: jloretiz    12DEC2019    - initial create
    ...    @author: jloretiz    14JAN2020    - renamed the keyword to a more generic name
    [Arguments]    ${sInputFilePath}    ${sInputJson}    ${sInputAPIResponse}    ${sOutputFilePath}    ${sOutputAPIResponse}
    ...    ${sInputFilePath_AccessToken}    ${sInputFile_AccessToken}    ${sLoginID}

    Run Keyword If    '${SSO_ENABLED.upper()}'=='YES'    PUT Request for User API with Token for Negative Scenario   ${sInputFilePath}    ${sInputJson}    ${sInputAPIResponse}    ${sOutputFilePath}    ${sOutputAPIResponse}
    ...    ${sInputFilePath_AccessToken}    ${sInputFile_AccessToken}    ${sLoginID}
    Run Keyword If    '${SSO_ENABLED.upper()}'=='NO'    PUT Request for User API without Token for Negative Scenario    ${sInputFilePath}    ${sInputJson}    ${sInputAPIResponse}    ${sOutputFilePath}    ${sOutputAPIResponse}
    ...    ${sLoginID}

POST Request for User API
    [Documentation]    This keyword is used to send POST request for the input JSON.
    ...    This keyowrd caters both SSO and Non SSO requests.
    ...    @author: rtarayao    05NOV2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sInputJson}    ${sInputAPIResponse}    ${sOutputFilePath}    ${sOutputAPIResponse}
    ...    ${sInputFilePath_AccessToken}    ${sInputFile_AccessToken}
    
    Run Keyword If    '${SSO_ENABLED.upper()}'=='YES'    POST Request for User API with Token   ${sInputFilePath}    ${sInputJson}    ${sInputAPIResponse}    ${sOutputFilePath}    ${sOutputAPIResponse}
    ...    ${sInputFilePath_AccessToken}    ${sInputFile_AccessToken}
    Run Keyword If    '${SSO_ENABLED.upper()}'=='NO'    POST Request for User API without Token    ${sInputFilePath}    ${sInputJson}    ${sInputAPIResponse}    ${sOutputFilePath}    ${sOutputAPIResponse}
    

PUT Request for User API
    [Documentation]    This keyword is used to send PUT request for the input JSON.
    ...    This keyowrd caters both SSO and Non SSO requests.
    ...    @author: rtarayao    06NOV2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sInputJson}    ${sInputAPIResponse}    ${sOutputFilePath}    ${sOutputAPIResponse}
    ...    ${sInputFilePath_AccessToken}    ${sInputFile_AccessToken}    ${sLoginID}

    Run Keyword If    '${SSO_ENABLED.upper()}'=='YES'    PUT Request for User API with Token   ${sInputFilePath}    ${sInputJson}    ${sInputAPIResponse}    ${sOutputFilePath}    ${sOutputAPIResponse}
    ...    ${sInputFilePath_AccessToken}    ${sInputFile_AccessToken}    ${sLoginID}
    Run Keyword If    '${SSO_ENABLED.upper()}'=='NO'    PUT Request for User API without Token    ${sInputFilePath}    ${sInputJson}    ${sInputAPIResponse}    ${sOutputFilePath}    ${sOutputAPIResponse}
    ...    ${sLoginID}

GET Request for User API Single Lob
    [Documentation]    This keyword is used to GET request API for Single LOB and create file for FFC Users API validation.
    ...    @author: jloretiz    26AUG2019    - initial create
    ...    @update: amansuet    02SEP2019    - added condition to accept path with no datasource. Default value is True if with datasource.
    ...    @update: jloretiz    12SEP2019    - added condition for Delete API
    ...    @update: amansuet    16SEP2019    - added code to store API Response in a global variable.
    [Arguments]    ${sInputFilePath}    ${sInputFFCResponse}    ${sOutputPath}    ${sOutputFile}    ${sLoginId}    
    ...    ${sLOB}    ${sDataSource}=True    ${sIsDelete}=False
    
    Delete All Sessions
    Create Session    ${APISESSION}    ${MDM_HOST_PARTY}
    # ${Headers}    Create Dictionary
    ${getSingleUserParam}    Run Keyword If    '${sDataSource}'=='${TRUE}'    Set Variable    ?${MDM_DATASOURCE_PARAM}
    ...    ELSE IF    '${sDataSource}'=='${FALSE}'    Set Variable    ${EMPTY}
    Get Request API    ${sOutputPath}    ${sOutputFile}   ${MDM_User_API}/${sLoginId}${LOBS}${sLOB}${getSingleUserParam}    # ${Headers}
    Run Keyword If    '${sIsDelete}'=='${FALSE}'    Verify Json Response Status Code    ${RESPONSECODE_200}
    ...    ELSE IF    '${sIsDelete}'=='${TRUE}' and '${sLOB}'!='${COMRLENDING}'    Verify Json Response Status Code    ${RESPONSECODE_404}
    ...    ELSE IF    '${sIsDelete}'=='${TRUE}' and '${sLOB}'=='${COMRLENDING}'    Verify Json Response Status Code    ${RESPONSECODE_200}
    Set Global Variable    ${GETSINGLEUSER_PARAM}    ${getSingleUserParam}
    ${InputValue}    Set Variable    ${sLoginId}${LOBS}${sLOB}/dataSource/LOB/defaultBusinessEntityName/
    Create File    ${dataset_path}${sInputFilePath}${sInputFFCResponse}.txt    ${InputValue}

    ${getAPIResponse}    OperatingSystem.Get File    ${dataset_path}${sOutputPath}${sOutputFile}.${JSON}
    Set Global Variable    ${GETSINGLEAPIRESPONSE}    ${getAPIResponse}
    
GET Request for All User API per LOB
    [Documentation]    This keyword is used to GET request for All User API per LOB and create file for FFC Users API validation.
    ...    This keyword accepts limit as an input in which by default it is set to 50 which is the maximum value for limit.
    ...    Values allowed for Limit are 1-50 and ${EMPTY}.
    ...    @author: amansuet    03SEP2019    - initial create
    ...    @author: jloretiz    10SEP2019    - add isDelete parameter to determine the purpose of GET request.
    ...    @update: amansuet    13SEP2019    - added validations for limit and condition if limit set is empty.
    ...    @update: amansuet    16SEP2019    - added condition when limit is not added in the parameter.
    ...    @update: amansuet    16SEP2019    - added code to get the API Response and store it in a global variable.
    ...    @update: cfrancis    17SEP2019    - changed ${offSetValue} into an optional argument for the keyword
    ...                                      - added logic that if ${offSetValue} is used as an argument, looping to find
    ...                                        loginID will no longer be performed
    ...                                      - changed ${Limit_Value_Response} to use get from list rather than index
    ...    @update: jdelacru    13DEC2019    - cleaned depricated whitespace not support for UTF 4.0
    [Arguments]    ${sInputFilePath}    ${sInputFFCResponse}    ${sOutputFilePath}    ${sOutputFile}    ${sLoginId}    ${sLOB}    
    ...    ${sDataSource}=True    ${sLimitValue}=50    ${sIsDelete}=False    ${hasLimit}=True    ${sOffSetValue}=0
    
    Delete All Sessions
    Create Session    ${APISESSION}    ${MDM_HOST_PARTY}
    
    ${totalUsersCount}    Create Query for All Users per LOB and Return Total Count    ${sLOB}    ## Get total count of users per LOB via DB ##
    ${pageCount}    Run Keyword If    '${hasLimit}'=='${False}' or '${sLimitValue}'=='${EMPTY}'    Evaluate    ${totalUsersCount} / 50 + 1    ## Get page count when limit value is empty or not added as parameter ##
    ...    ELSE    Evaluate    ${totalUsersCount} / ${sLimitValue} + 1    ## Get page count based on limit value ##
    ${pageCount}    Convert to Integer    ${pageCount}
    
    # ${Headers}    Create Dictionary
    ${offSetValue}    Set Variable    ${sOffSetValue}
    ${offSetUsed}    Run Keyword If    ${offSetValue} != 0    Set Variable    ${TRUE}
    ...    ELSE    Set Variable    ${FALSE}
    :FOR    ${INDEX}    IN RANGE    ${pageCount}
    \    ${currentPageNumber}    Evaluate    ${INDEX} + 1
    \    Log    offSet: ${offSetValue}, limit: ${sLimitValue}, pageCount: ${pageCount}, totalCount: ${totalUsersCount}, page: ${currentPageNumber}.
    \    
    \    ${getAllUserParams}    Run Keyword If    '${sDataSource}'=='${TRUE}' and '${hasLimit}'=='${True}'    Set Variable    ?${MDM_DATASOURCE_PARAM}&${MDM_LIMIT_PARAM}=${sLimitValue}&${MDM_OFFSET_PARAM}=${offSetValue}&${MDM_BUSINESSENTITY_PARAM}
         ...    ELSE IF    '${sDataSource}'=='${FALSE}' and '${hasLimit}'=='${True}'    Set Variable    ?${MDM_LIMIT_PARAM}=${sLimitValue}&${MDM_OFFSET_PARAM}=${offSetValue}&${MDM_BUSINESSENTITY_PARAM}
         ...    ELSE IF    '${sDataSource}'=='${TRUE}' and '${hasLimit}'=='${False}'    Set Variable    ?${MDM_DATASOURCE_PARAM}&${MDM_OFFSET_PARAM}=${offSetValue}&${MDM_BUSINESSENTITY_PARAM}
         ...    ELSE IF    '${sDataSource}'=='${FALSE}' and '${hasLimit}'=='${False}'    Set Variable    ?${MDM_OFFSET_PARAM}=${offSetValue}&${MDM_BUSINESSENTITY_PARAM}
    \    
    \    Get Request API    ${sOutputFilePath}    ${sOutputFile}   ${MDM_User_API}${LOBS}${sLOB}${getAllUserParams}    # ${Headers}
    \    Verify Json Response Status Code    ${RESPONSECODE_200}
    \    ${ActualValue}    OperatingSystem.Get File    ${dataset_path}${sOutputFilePath}${sOutputFile}.${JSON}
    \    Run Keyword If    '${offSetUsed}'=='${TRUE}'    Exit For Loop
    \    ${status}    Run Keyword And Return Status    Should Contain    ${ActualValue}    ${sLoginId}    ## Validate User is Existing ##
    \    ${offSetValue}    Run Keyword If    '${status}'=='${FALSE}' and '${sLimitValue}'!='${EMPTY}'    Evaluate    ${offSetValue} + ${sLimitValue}
         ...    ELSE IF    '${status}'=='${FALSE}' and '${sLimitValue}'=='${EMPTY}'    Evaluate    ${offSetValue} + 50
         ...    ELSE IF    '${status}'=='${FALSE}' and '${hasLimit}'=='${False}'    Evaluate    ${offSetValue} + 50
         ...    ELSE IF    '${status}'=='${TRUE}' and '${sIsDelete}'=='${TRUE}' and '${sLOB}'!='${COMRLENDING}'    Run Keywords    Fail    [DELETE] User "${sLoginId}" is Found in Page:"${currentPageNumber}" for "${sLOB}" LOB.    AND    Exit For Loop
         ...    ELSE IF    '${status}'=='${TRUE}'    Run Keywords    Log    [GET] User "${sLoginId}" is Found in Page:"${currentPageNumber}" for "${sLOB}" LOB.    AND    Exit For Loop
    \    
    \    Run Keyword If    ${offSetValue}>${totalUsersCount} and '${sIsDelete}'=='${FALSE}'   Fail    User "${sLoginId}" is NOT Existing in "${sLOB}" LOB.
         ...    ELSE IF    ${offSetValue}>${totalUsersCount} and '${sIsDelete}'=='${TRUE}' and '${sLOB}'!='${COMRLENDING}'    Log    User "${sLoginId}" is successfully deleted and is not existing in "${sLOB}" LOB.
    
    ${oldValue}    Set Variable    ${offSetValue}
    ${offSetValue}    Run Keyword If     ${offSetValue}>${totalUsersCount} and '${sIsDelete}'=='${TRUE}'    Evaluate    ${offSetValue} - ${sLimitValue}
    ${offSetValue}    Run Keyword If    '${offSetValue}'=='${NONE}' or '${offSetValue}'=='None'    Set Variable    ${oldValue}
    ...    ELSE    Set Variable    ${offSetValue}
    
    ${InputValue}    Run Keyword If    '${sLimitValue}'=='${EMPTY}' or '${hasLimit}'=='${False}'    Set Variable    ${LOBS}${sLOB}/${DATASOURCEANDBUSINESSENTITY}/${MDM_OFFSET_PARAM}/${offSetValue}/${MDM_LIMIT_PARAM}/50
    ...    ELSE    Set Variable    ${LOBS}${sLOB}/${DATASOURCEANDBUSINESSENTITY}/${MDM_OFFSET_PARAM}/${offSetValue}/${MDM_LIMIT_PARAM}/${sLimitValue}

    Create File    ${dataset_path}${sInputFilePath}${sInputFFCResponse}.txt    ${InputValue}
    Set Global Variable    ${GETALLUSER_PARAM}    ${getAllUserParams}

    ## Get Response For Validation ##
    ${ValidateActualValue}    OperatingSystem.Get File    ${dataset_path}${sOutputFilePath}${sOutputFile}.${JSON}
    Set Global Variable    ${GETALLAPIRESPONSE}    ${ValidateActualValue}
    ${Convert_JSON}    evaluate    json.loads('''${ValidateActualValue}''')    ${JSON}
    
    ## Validate Limit Set matches number of users displayed ##
    ${loginId}    Get Value From Json    ${Convert_JSON}    $..users..loginId
    ${loginId_count_val}    Get Length    ${loginId}
    
    Run Keyword If    '${sLimitValue}'!='${EMPTY}' and '${hasLimit}'=='${True}' and '${sIsDelete}'=='${False}'    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${sLimitValue}     ${loginId_count_val}
    ${Stat}    Run Keyword If    '${sLimitValue}'!='${EMPTY}' and '${hasLimit}'=='${True}' and '${sIsDelete}'=='${False}'    Run Keyword And Return Status    Should Be Equal As Strings    ${sLimitValue}     ${loginId_count_val}
    Run Keyword If    ${Stat}==${True}    Log    Limit value Set and Number of Users displayed are matched. ${sLimitValue} == ${loginId_count_val}
    ...    ELSE IF    ${Stat}==${False}    Log    Limit value Set and Number of Users displayed does not matched. ${sLimitValue} != ${loginId_count_val}    level=ERROR

    ## Validate Limit Set matches Limit value displayed ##
    ${Limit_Value}    Get Value From Json    ${Convert_JSON}    $.._meta..limit
    ${Limit_Value_Response}    Get From List    ${Limit_Value}    0
    
    Run Keyword If    '${sLimitValue}'!='${EMPTY}' and '${hasLimit}'=='${True}' and '${sIsDelete}'=='${False}'    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${sLimitValue}     ${Limit_Value_Response}
    ${Stat}    Run Keyword If    '${sLimitValue}'!='${EMPTY}' and '${hasLimit}'=='${True}' and '${sIsDelete}'=='${False}'    Run Keyword And Return Status    Should Be Equal As Strings    ${sLimitValue}     ${Limit_Value_Response}
    Run Keyword If    ${Stat}==${True}    Log    Limit value Set and Limit value Response are matched. ${sLimitValue} == ${Limit_Value_Response}
    ...    ELSE IF    ${Stat}==${False}    Log    Limit value Set and Limit value Response does not matched. ${sLimitValue} != ${Limit_Value_Response}    level=ERROR
    
    ## Validate Limit with No Value has default value of 50 ##
    Run Keyword If    '${sLimitValue}'=='${EMPTY}' or '${hasLimit}'=='${False}'    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${Limit_Value_Response}    50
    ${Stat}    Run Keyword If    '${sLimitValue}'=='${EMPTY}' or '${hasLimit}'=='${False}'    Run Keyword And Return Status    Should Be Equal As Strings    ${Limit_Value_Response}    50
    Run Keyword If    ${Stat}==${True}    Log    No Limit Value set has default value of 50. ${Limit_Value_Response} == 50
    ...    ELSE IF    ${Stat}==${False}    Log    No Limit Value set does NOT have a default value of 50. ${Limit_Value_Response} != 50    level=ERROR
    
    ## Validate Offset matches on Response if Offset Value placed as input
    ${Offset_Value}    Run Keyword If    '${offSetUsed}'=='${TRUE}'    Get Value From Json    ${Convert_JSON}    $.._meta..offset
    ${Offset_Value_Response}    Run Keyword If    '${offSetUsed}'=='${TRUE}'    Get From List    ${Offset_Value}    0
    Run Keyword If    '${offSetUsed}'=='${TRUE}'    Should Be Equal As Strings    ${Offset_Value_Response}    ${sOffSetValue}

GET Request for User API Without Success Validation
    [Documentation]    This keyword is used to GET request API for Single LOB without validation for negative scenarios.
    ...    @author: jloretiz    13JAN2020    - initial create
    [Arguments]    ${sOutputPath}    ${sOutputFile}    ${sLoginId}    ${sLob}
    
    # ${Headers}    Create Dictionary
    Delete All Sessions
    Create Session    ${APISESSION}    ${MDM_HOST_PARTY}
    Get Request API    ${sOutputPath}    ${sOutputFile}   ${MDM_User_API}/${sLoginId}${LOBS}${sLob}?${MDM_DATASOURCE_PARAM}    # ${Headers}

Validate PUT API Response Field and GET ALL API Response Field
    [Documentation]    This keyword is used to validate the fields updated from PUT API Response matches with the fields in GET All User API Response.
    ...    @author: amansuet    18SEP2019    - initial create
    [Arguments]    ${sLoginId}    ${sFieldtoCheck}
    
    ## Get PUT API Response ##
    ${PUTValue}    Set Variable    ${PUTAPIRESPONSE}
    ${Convert_JSON_Put}    evaluate    json.loads('''${PUTValue}''')    ${JSON}
    ${putResponse}    Get Value From Json    ${Convert_JSON_Put}    $..${sFieldtoCheck}
    
    ## Get GET ALL USER API Response ##
    ${GETAllValue}    Set Variable    ${GETALLAPIRESPONSE}
    ${Convert_JSON_Get}    evaluate    json.loads('''${GETAllValue}''')    ${JSON}
    ${loginId_List}    Get Value From Json    ${Convert_JSON_Get}    $..loginId
    ${loginId_Count}    Get Length    ${loginId_List}
    :FOR    ${INDEX}    IN RANGE    ${loginId_Count}
    \    ${loginId_Value}    Get From List    ${loginId_List}    ${INDEX}
    \    Exit For Loop If    '${loginId_Value}'=='${sLoginId}'
    ${getAllResponse}    Get Value From Json    ${Convert_JSON_Get}    $..users[${INDEX}].${sFieldtoCheck}

    ## Validate Field Values are Matched ##
    Run Keyword And Continue On Failure    Should Be Equal    ${putResponse}     ${getAllResponse}
    ${Stat}    Run Keyword And Return Status    Should Be Equal    ${putResponse}     ${getAllResponse}
    Run Keyword If    ${Stat}==${True}    Log    '${sFieldtoCheck}' field from PUT API Response and GET ALL USER API Response are matched. ${putResponse} == ${getAllResponse}
    ...    ELSE    Log    '${sFieldtoCheck}' field from PUT API Response and GET ALL USER API Response does not matched. ${putResponse} != ${getAllResponse}    level=ERROR

Validate PUT API Response Field and GET Single API Response Field
    [Documentation]    This keyword is used to validate the fields updated from PUT API Response matches with the fields in GET Single User API Response.
    ...    @author: amansuet    18SEP2019    - initial create
    [Arguments]    ${sFieldtoCheck}
    
    ## Get PUT API Response ##
    ${PUTValue}    Set Variable    ${PUTAPIRESPONSE}
    ${Convert_JSON_Put}    evaluate    json.loads('''${PUTValue}''')    ${JSON}
    ${putResponse}    Get Value From Json    ${Convert_JSON_Put}    $..${sFieldtoCheck}
    
    ## Get GET Single USER API Response ##
    ${GETSingleValue}    Set Variable    ${GETSINGLEAPIRESPONSE}
    ${Convert_JSON_GetSingle}    evaluate    json.loads('''${GETSingleValue}''')    ${JSON}
    
    ${getSingleResponse}    Get Value From Json    ${Convert_JSON_GetSingle}    $..${sFieldtoCheck}

    ## Validate Field Values are Matched ##
    Run Keyword And Continue On Failure    Should Be Equal    ${putResponse}     ${getSingleResponse}
    ${Stat}    Run Keyword And Return Status    Should Be Equal    ${putResponse}     ${getSingleResponse}
    Run Keyword If    ${Stat}==${True}    Log    '${sFieldtoCheck}' field from PUT API Response and GET ALL USER API Response are matched. ${putResponse} == ${getSingleResponse}
    ...    ELSE    Log    '${sFieldtoCheck}' field from PUT API Response and GET ALL USER API Response does not matched. ${putResponse} != ${getSingleResponse}    level=ERROR

DELETE Request on Single or Multiple or All LOB for User API
    [Documentation]    This keyword is used to Delete single or All lobs.
    ...    It sends a delete request for all lobs or single lobs like LIQ, essence and party.
    ...    Then it creates a text file for FFCResponse validation.
    ...    @author: amansuet    14AUG2019    - initial create
    ...    @update: amansuet    23AUG2019    - updated based on delete request update
    ...    @update: amansuet    23AUG2019    - removed if conditions for different lobs
    ...    @update: rtarayao    11NOV2019    - modified delete request logic to handle both SSO and Non SSO environment
    ...    @update: jdelacru    13DEC2019    - cleaned depricated whitespace not support for UTF 4.0
    [Arguments]    ${sInputFilePath}    ${sInputFFCResponse}    ${sInputFile_AccessToken_FilePath}    ${sInputFile_AccessToken}    ${sLoginId}    ${sLineOfBusiness}
    
    ${lob_list}    Split String    ${sLineOfBusiness}    ,
    ${lob_count}    Get Length    ${lob_list}
    ${INDEX}    Set Variable    0
    
    :FOR    ${INDEX}    IN RANGE    ${lob_count}
    \    ${lob_value}    Get From List    ${lob_list}    ${INDEX}
    \    ${API_URL}    Run Keyword If    '${lob_value}'=='' or '${lob_value}'=='no tag'    Set Variable    ${sLoginId}
         ...    ELSE IF    '${lob_value}'=='ALL' or '${lob_value}'=='null'    Set Variable    ${sLoginId}
         ...    ELSE    Set Variable    ${sLoginId}/lobs/${lob_value}
    \    Create File    ${dataset_path}${sInputFilePath}${sInputFFCResponse}${lob_value}.txt    ${API_URL}
    \    Run Keyword If    '${SSO_ENABLED.upper()}'=='YES'    Run Keyword And Continue On Failure    DELETE Request for User API with Token   ${sInputFile_AccessToken_FilePath}    ${sInputFile_AccessToken}    ${API_URL}    ${lob_value}
         ...    ELSE IF    '${SSO_ENABLED.upper()}'=='NO'    Run Keyword And Continue On Failure    DELETE Request for User API without Token    ${API_URL}
    \    Exit For Loop If    '${INDEX}'=='${lob_count}'

DELETE Request on Single or Multiple or All LOB for User API with Error
    [Documentation]    This keyword is used to Delete single or All lobs with expected Error.
    ...    It sends a delete request for all lobs or single lobs like LIQ, essence and party.
    ...    Then it creates a text file for FFCResponse validation.
    ...    @author: jloretiz    20JAN2020    - initial create
    [Arguments]    ${sInputFile_AccessToken_FilePath}    ${sInputFile_AccessToken}    ${sLoginId}    ${sLineOfBusiness}
    
    ${lob_list}    Split String    ${sLineOfBusiness}    ,
    ${lob_count}    Get Length    ${lob_list}
    ${INDEX}    Set Variable    0
    
    :FOR    ${INDEX}    IN RANGE    ${lob_count}
    \    ${lob_value}    Get From List    ${lob_list}    ${INDEX}
    \    ${API_URL}    Run Keyword If    '${lob_value}'=='' or '${lob_value}'=='no tag'    Set Variable    ${sLoginId}
         ...    ELSE IF    '${lob_value}'=='ALL' or '${lob_value}'=='null'    Set Variable    ${sLoginId}
         ...    ELSE    Set Variable    ${sLoginId}/lobs/${lob_value}
    \    Run Keyword If    '${SSO_ENABLED.upper()}'=='YES'    Run Keyword And Continue On Failure    DELETE Request for User API with Token with Error   ${sInputFile_AccessToken_FilePath}    ${sInputFile_AccessToken}    ${API_URL}    ${lob_value}
         ...    ELSE IF    '${SSO_ENABLED.upper()}'=='NO'    Run Keyword And Continue On Failure    DELETE Request for User API without Token with Error    ${API_URL}
    \    Exit For Loop If    '${INDEX}'=='${lob_count}'

POST or PUT Request for User API with Technical Error
    [Documentation]    This keyword is used to get token and create session for Base Rate API and send POST request for the input JSON.
    ...    Expected Technical Error (Status 400) will be encountered.
    ...    This also compares the input error list and output error list.
    ...    @author: jaquitan
    ...    @update: clanding    01SEP2019    - Change APITesting Create Session to APITesting Create Session for User
    ...    @update: clanding    23APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1, added token handling
    [Arguments]    ${sInputFilePath}    ${sInputJson}    ${sInputAPIResponse}    ${sOutputFilePath}    ${sOutputAPIResponse}
    ...    ${sInputFilePath_AccessToken}    ${sInputFile_AccessToken}

    Delete All Sessions
    Create Session    ${TOKENSESSION}    ${MDM_HOST_TOKEN}
    ${accessToken}    Post Json File And Return Access Token    ${sInputFilePath_AccessToken}    ${sInputFile_AccessToken}    ${MDM_ACCESS_TOKEN}  
    Create Session    ${APISESSION}    ${MDM_HOST}
    Post Json File    ${sInputFilePath}    ${sInputJson}    ${MDM_User_API}    ${sOutputFilePath}    ${sOutputAPIResponse}    ${accessToken}
    Compare API Request and Response    ${sInputFilePath}    ${sInputAPIResponse}
    Verify Json Response Status Code    ${RESPONSECODE_400}
    Get Reason from Reponse Error and Compare with Expected Error    ${sOutputFilePath}${sOutputAPIResponse}


GET Request for User API Single Lob and Validate Response Code 400
    [Documentation]    This keyword is used to GET request API for Single LOB and Validate Response Code 400
    ...    @author: xmiranda    29OCT2019    - initial create
    [Arguments]    ${sOutputPath}    ${sOutputFile}    ${sLoginId}    ${sLOB}    ${sDataSourceValue}
    
    Delete All Sessions
    Create Session    ${APISESSION}    ${MDM_HOST_PARTY}
    # ${Headers}    Create Dictionary
    ${getSingleUserParam}    Set Variable    ?${MDM_DATASOURCE_VALUE}${sDataSourceValue}
    
    Get Request API    ${sOutputPath}    ${sOutputFile}   ${MDM_User_API}/${sLoginId}${LOBS}${sLOB}${getSingleUserParam}    # ${Headers}
    
    Verify Json Response Status Code    ${RESPONSECODE_400}
    
    ${Message}    Convert To String    ${API_RESPONSE.content}
    Should Contain    ${Message}    ${MESSAGE_DATASOURCEERROR}
    
    
GET Request for User API All Users and Validate Response Code 404
    [Documentation]    This keyword is used to GET request API for All Users and Validate Response Code 404
    ...    @author: xmiranda    29OCT2019    - initial create
    [Arguments]    ${sOutputPath}    ${sOutputFile}    ${sLoginId}    ${sLOB}    ${sOffset}=None    ${sLimit}=None
    
    Delete All Sessions
    Create Session    ${APISESSION}    ${MDM_HOST_PARTY}
    # ${Headers}    Create Dictionary
    
    ${getSingleUserParam}    Run Keyword If    '${sOffset}'!='None' and '${sLimit}'=='None'    Set Variable    ?${MDM_DATASOURCE_PARAM}&${MDM_OFFSET_PARAM}=${sOffset}&${MDM_BUSINESSENTITY_PARAM}
    ...    ELSE IF    '${sOffset}'=='None' and '${sLimit}'!='None'    Set Variable    ?${MDM_DATASOURCE_PARAM}&${MDM_LIMIT_PARAM}=${sLimit}&${MDM_BUSINESSENTITY_PARAM}
    ...    ELSE IF    '${sOffset}'!='None' and '${sLimit}'!='None'    Set Variable    ?${MDM_DATASOURCE_PARAM}&${MDM_LIMIT_PARAM}=${sLimit}&${MDM_OFFSET_PARAM}=${sOffset}&${MDM_BUSINESSENTITY_PARAM}
    ...    ELSE    Fail    Invalid Parameters for Response Validation
    
    Get Request API    ${sOutputPath}    ${sOutputFile}   ${MDM_User_API}${LOBS}${sLOB}${getSingleUserParam}    # ${Headers}
    
    Verify Json Response Status Code    ${RESPONSECODE_404}
    
    ${Message}    Convert To String    ${API_RESPONSE.content}
    
    Should Be Empty    ${Message}    
    

Request HTTP Method for User API for All User Endpoints And Validate Response Code
    [Documentation]    This keyword is used to validate response code 405 using methods aside from GET with GET All User Endpoint
    ...    @author: xmiranda    06NOV2019    - initial create
    [Arguments]    ${sInputPath}    ${sInputFile}    ${sOutputPath}    ${sOutputFile}    ${sLoginId}    ${sLOB}    ${sMethod}    ${sDataSourceValue}    ${sOffset}=None    ${sLimit}=None
    
    Delete All Sessions
    Create Session    ${APISESSION}    ${MDM_HOST_PARTY}
    ${Headers}    Create Dictionary
    
    ${getAllUserParam}    Run Keyword If    '${sOffset}'!='None' and '${sLimit}'=='None'    Set Variable    ?${MDM_DATASOURCE_PARAM}&${MDM_OFFSET_PARAM}=${sOffset}&${MDM_BUSINESSENTITY_PARAM}
    ...    ELSE IF    '${sOffset}'=='None' and '${sLimit}'!='None'    Set Variable    ?${MDM_DATASOURCE_PARAM}&${MDM_LIMIT_PARAM}=${sLimit}&${MDM_BUSINESSENTITY_PARAM}
    ...    ELSE IF    '${sOffset}'!='None' and '${sLimit}'!='None'    Set Variable    ?${MDM_DATASOURCE_PARAM}&${MDM_LIMIT_PARAM}=${sLimit}&${MDM_OFFSET_PARAM}=${sOffset}&${MDM_BUSINESSENTITY_PARAM}
    ...    ELSE    Fail    Invalid Parameters for Response Validation

  
    Run Keyword If    '${sMethod}' == 'POST'    Post Json File    ${sInputPath}    ${sInputFile}    ${MDM_User_API}${LOBS}${sLOB}${getAllUserParam}    ${sOutputPath}    ${sOutputFile}
    ...    ELSE IF    '${sMethod}' == 'PUT'    Put Json File    ${sInputPath}    ${sInputFile}    ${MDM_User_API}${LOBS}${sLOB}${getAllUserParam}    ${sOutputPath}    ${sOutputFile}
    ...    ELSE IF    '${sMethod}' == 'DELETE'    Delete Request and Store Response    ${MDM_User_API}${LOBS}${sLOB}${getAllUserParam}
    
    Verify Json Response Status Code    ${RESPONSECODE_405}
    # Create File    ${dataset_path}${sOutputPath}${sOutputFile}ALL.json    ${API_RESPONSE.content}
    ${Message}    Convert To String    ${API_RESPONSE.content}
    Should Be Empty    ${Message}
    
    ${getSingleUserParam}    Set Variable    ?${MDM_DATASOURCE_VALUE}${sDataSourceValue}
        
    Run Keyword If    '${sMethod}' == 'POST'    Post Json File    ${sInputPath}    ${sInputFile}    ${MDM_User_API}/${sLoginId}${LOBS}${sLOB}${getSingleUserParam}    ${sOutputPath}    ${sOutputFile}
    ...    ELSE IF    '${sMethod}' == 'PUT'    Put Json File    ${sInputPath}    ${sInputFile}    ${MDM_User_API}/${sLoginId}${LOBS}${sLOB}${getSingleUserParam}    ${sOutputPath}    ${sOutputFile}
    ...    ELSE IF    '${sMethod}' == 'DELETE'    Delete Request and Store Response    ${MDM_User_API}/${sLoginId}${LOBS}${sLOB}${getSingleUserParam}
    

    Run Keyword If    '${sMethod}' == 'POST' or '${sMethod}' == 'PUT'    Verify Json Response Status Code    ${RESPONSECODE_405}
    
    Run Keyword If    '${sMethod}' == 'DELETE'    Verify Json Response Status Code    ${RESPONSECODE_204}
    
    # Create File    ${dataset_path}${sOutputPath}${sOutputFile}SINGLE.json    ${API_RESPONSE.content}
    ${Message}    Convert To String    ${API_RESPONSE.content}
    Should Be Empty    ${Message}
   
   
   
# User PUT API with Modal Error
    # [Arguments]    ${APIDataSet}    ${Expected_Err_List}
    # [Documentation]    Used to check DB records and delete if record exist, then POST API file and check response error 400.
    # ...    This also compares the input error list and output error list.
    # ...    @author: jaquitan
    # ...    01/09/19 updated by clanding: Change APITesting Create Session to APITesting Create Session for User

    # Oracle_Database_Connection
    # Delete All Sessions
    # APITesting Create Session for User    &{APIDataSet}[MDM_HOST]:&{APIDataSet}[MDM_PORT]
    # Delete_old_records_from_DB
    # Put_Json_File    ${dataset_path}&{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson].json    ${MDM_USER_API}/&{APIDataSet}[loginId]    ${dataset_path}&{APIDataSet}[OutputFilePath]   &{APIDataSet}[OutputAPIResponse]
    # Verify PUT Json Response Status Code 400 Bad Request
    # Compare Expected and Actual Error    ${Actual_Err_List}    ${Expected_Err_List}     ${dataset_path}&{APIDataSet}[OutputFilePath]&{APIDataSet}[OutputAPIResponse]

# User DELETE API with Technical Validation Error
    # [Arguments]    ${APIDataSet}    ${Expected_Err_List}
    # [Documentation]    Used to check DB records and delete if record exist, then POST API file and check response error 400.
    # ...    This also compares the input error list and output error list.
    # ...    @author: jaquitan
    # ...    01/09/19 updated by clanding: Change APITesting Create Session to APITesting Create Session for User

    # Oracle_Database_Connection
    # Delete All Sessions
    # APITesting Create Session for User    &{APIDataSet}[MDM_HOST]:&{APIDataSet}[MDM_PORT]
    # Delete_old_records_from_DB
    # Delete Request JSON File    ${dataset_path}&{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson].json    ${MDM_USER_API}/&{APIDataSet}[loginId]    ${dataset_path}&{APIDataSet}[OutputFilePath]   &{APIDataSet}[OutputAPIResponse]
    # Verify DELETE Json Response Status Code 400 Bad Request
    # Get Reason from Reponse Error and compare with Expected Error2    ${Actual_Err_List}    ${Expected_Err_List}     ${dataset_path}&{APIDataSet}[OutputFilePath]&{APIDataSet}[OutputAPIResponse]

# User POST API Validation Expected Model Type Error
    # [Arguments]    ${APIDataSet}    ${Expected_Err_List}
    # [Documentation]    Used to check DB records and delete if record exist, then POST API file and check response error 400.
    # ...    This also compares the input error list and output error list.
    # ...    @author: jaquitan
    # ...    01/09/19 updated by clanding: Change APITesting Create Session to APITesting Create Session for User

    # Oracle_Database_Connection
    # Delete All Sessions
    # APITesting Create Session for User    &{APIDataSet}[MDM_HOST]:&{APIDataSet}[MDM_PORT]
    # Delete_old_records_from_DB
    # Post_Json_File    ${dataset_path}&{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson].json    ${MDM_USER_API}    ${dataset_path}&{APIDataSet}[OutputFilePath]   &{APIDataSet}[OutputAPIResponse]
    # Verify POST Json Response Status Code 400 Bad Request
    # Get Reason from Reponse Error and compare with Expected Model Type Error   ${Actual_Err_List}    ${Expected_Err_List}

# User PUT API Validation Expected Model Type Error
    # [Arguments]    ${APIDataSet}    ${Expected_Err_List}
    # [Documentation]    Used to check DB records and delete if record exist, then POST API file and check response error 400.
    # ...    This also compares the input error list and output error list.
    # ...    @author: jaquitan
    # ...    01/09/19 updated by clanding: Change APITesting Create Session to APITesting Create Session for User

    # Oracle_Database_Connection
    # Delete All Sessions
    # APITesting Create Session for User    &{APIDataSet}[MDM_HOST]:&{APIDataSet}[MDM_PORT]
    # Delete_old_records_from_DB
    # Put_Json_File    ${dataset_path}&{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson].json    ${MDM_USER_API}/&{APIDataSet}[loginId]    ${dataset_path}&{APIDataSet}[OutputFilePath]   &{APIDataSet}[OutputAPIResponse]
    # Verify PUT Json Response Status Code 400 Bad Request
    # Get Reason from Reponse Error and compare with Expected Model Type Error   ${Actual_Err_List}    ${Expected_Err_List}

# User DELETE API Validation Expected Model Type Error
    # [Arguments]    ${APIDataSet}    ${Expected_Err_List}
    # [Documentation]    Used to check DB records and delete if record exist, then POST API file and check response error 400.
    # ...    This also compares the input error list and output error list.
    # ...    @author: jaquitan
    # ...    01/09/19 updated by clanding: Change APITesting Create Session to APITesting Create Session for User

    # Oracle_Database_Connection
    # Delete All Sessions
    # APITesting Create Session for User    &{APIDataSet}[MDM_HOST]:&{APIDataSet}[MDM_PORT]
    # Delete_old_records_from_DB
    # Delete Request JSON File    ${dataset_path}&{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson].json    ${MDM_USER_API}/&{APIDataSet}[loginId]    ${dataset_path}&{APIDataSet}[OutputFilePath]   &{APIDataSet}[OutputAPIResponse]
    # Verify DELETE Json Response Status Code 400 Bad Request
    # Get Reason from Reponse Error and compare with Expected Model Type Error   ${Actual_Err_List}    ${Expected_Err_List}

# User PUT API with Functional Validation Error
    # [Arguments]    ${APIDataSet}    ${Expected_Err_List}
    # [Documentation]    Used to check DB records and delete if record exist, then PUT API file and check response error 400.
    # ...    This also compares the input error list and output error list.
    # ...    @author: jaquitan
    # ...    01/09/19 updated by clanding: Change APITesting Create Session to APITesting Create Session for User

    # Oracle_Database_Connection
    # Delete All Sessions
    # APITesting Create Session for User    &{APIDataSet}[MDM_HOST]:&{APIDataSet}[MDM_PORT]
    # Delete_old_records_from_DB
    # Put_Json_File    ${dataset_path}&{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson].json    ${MDM_USER_API}/&{APIDataSet}[userIDLink]    ${dataset_path}&{APIDataSet}[OutputFilePath]   &{APIDataSet}[OutputAPIResponse]
    # Verify PUT Json Response Status Code 400 Bad Request
    # Compare Expected and Actual Error    ${Actual_Err_List}    ${Expected_Err_List}     ${dataset_path}&{APIDataSet}[OutputFilePath]&{APIDataSet}[OutputAPIResponse]
# User DELETE API with Functional Validation Error
    # [Arguments]    ${APIDataSet}    ${Expected_Err_List}
    # [Documentation]    Used to check DB records and delete if record exist, then PUT API file and check response error 400.
    # ...    This also compares the input error list and output error list.
    # ...    @author: jaquitan
    # ...    01/09/19 updated by clanding: Change APITesting Create Session to APITesting Create Session for User

    # Oracle_Database_Connection
    # Delete All Sessions
    # APITesting Create Session for User    &{APIDataSet}[MDM_HOST]:&{APIDataSet}[MDM_PORT]
    # Delete_old_records_from_DB
    # Delete Request JSON File    ${dataset_path}&{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson].json    ${MDM_USER_API}/&{APIDataSet}[userIDLink]    ${dataset_path}&{APIDataSet}[OutputFilePath]   &{APIDataSet}[OutputAPIResponse]
    # Verify DELETE Json Response Status Code 400 Bad Request
    # Get Reason from Reponse Error and compare with Expected Error2    ${Actual_Err_List}    ${Expected_Err_List}     ${dataset_path}&{APIDataSet}[OutputFilePath]&{APIDataSet}[OutputAPIResponse]

# User POST with API Modal Error
    # [Documentation]    Used to check DB records and delete if record exist, then POST API file and check response error 400.
    # ...    This also compares the input error list and output error list.
    # ...    @author: chanario
    # ...    01/09/19 updated by clanding: Change APITesting Create Session to APITesting Create Session for User
    # [Arguments]    ${APIDataSet}

    # Oracle_Database_Connection
    # Delete All Sessions
    # APITesting Create Session for User    &{APIDataSet}[MDM_HOST]:&{APIDataSet}[MDM_PORT]
    # Delete_old_records_from_DB
    # Post_Json_File    ${dataset_path}&{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson].json    ${MDM_USER_API}    ${dataset_path}&{APIDataSet}[OutputFilePath]   &{APIDataSet}[OutputAPIResponse].json
    # Verify POST Json Response Status Code 400 Bad Request
    # Run Keyword And Continue On Failure    Get Reason from Modal Error Rate and compare with Expected Error    ${Actual_Err_List}
    # # [Return]    ${POSTResp.status_code}

# User PUT API Modal Error
    # [Arguments]    ${APIDataSet}
    # [Documentation]    Used to check DB records and delete if record exist, then POST API file and check response error 400.
    # ...    This also compares the input error list and output error list.
    # ...    @author: chanario
    # ...    01/09/19 updated by clanding: Change APITesting Create Session to APITesting Create Session for User

    # Oracle_Database_Connection
    # Delete All Sessions
    # APITesting Create Session for User    &{APIDataSet}[MDM_HOST]:&{APIDataSet}[MDM_PORT]
    # Delete_old_records_from_DB
    # Put_Json_File    ${dataset_path}&{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson].json    ${MDM_USER_API}/&{APIDataSet}[loginId]    ${dataset_path}&{APIDataSet}[OutputFilePath]   &{APIDataSet}[OutputAPIResponse]
    # Verify PUT Json Response Status Code 400 Bad Request
    # Run Keyword And Continue On Failure    Get Reason from Modal Error Rate and compare with Expected Error    ${Actual_Err_List}

POST Request for User API without Token for Negative Scenario
    [Documentation]    This keyword is used to create session for User API and send POST request for the input JSON
    ...    with Invalid or Null values for Mandatory Fields.
    ...    @author: jloretiz    10DEC2019    - initial create
    ...    @author: jloretiz    14JAN2020    - renamed the keyword to a more generic name
    [Arguments]    ${sInputFilePath}    ${sInputJson}    ${sInputAPIResponse}    ${sOutputFilePath}    ${sOutputAPIResponse}

    Delete All Sessions
    Create Session    ${APISESSION}    ${MDM_HOST}
    Post Json File    ${sInputFilePath}    ${sInputJson}    ${MDM_User_API}    ${sOutputFilePath}    ${sOutputAPIResponse}
    
POST Request for User API with Token for Negative Scenario
    [Documentation]    This keyword is used to get token and create session for User API and send POST request for the input JSON
    ...    with Invalid or Null values for Mandatory Fields.
    ...    @author: jloretiz    10DEC2019    - initial create
    ...    @author: jloretiz    14JAN2020    - renamed the keyword to a more generic name
    [Arguments]    ${sInputFilePath}    ${sInputJson}    ${sInputAPIResponse}    ${sOutputFilePath}    ${sOutputAPIResponse}
    ...    ${sInputFilePath_AccessToken}    ${sInputFile_AccessToken}

    Delete All Sessions
    Create Session    ${TOKENSESSION}    ${MDM_HOST_TOKEN}
    ${accessToken}    Post Json File And Return Access Token    ${sInputFilePath_AccessToken}    ${sInputFile_AccessToken}    ${MDM_ACCESS_TOKEN}  
    Create Session    ${APISESSION}    ${MDM_HOST}
    Post Json File    ${sInputFilePath}    ${sInputJson}    ${MDM_User_API}    ${sOutputFilePath}    ${sOutputAPIResponse}    ${accessToken}

PUT Request for User API without Token for Negative Scenario
    [Documentation]    This keyword is used to create session for User API and send PUT request for the input JSON
    ...    with Invalid or Null values for Mandatory Fields.
    ...    @author: jloretiz    10DEC2019    - initial create
    ...    @author: jloretiz    14JAN2020    - renamed the keyword to a more generic name
    [Arguments]    ${sInputFilePath}    ${sInputJson}    ${sInputAPIResponse}    ${sOutputFilePath}    ${sOutputAPIResponse}
    ...    ${sLoginID}

    Delete All Sessions
    Create Session    ${APISESSION}    ${MDM_HOST}
    Put Json File    ${sInputFilePath}    ${sInputJson}    ${MDM_User_API}/${sLoginID}    ${sOutputFilePath}    ${sOutputAPIResponse}

PUT Request for User API with Token for Negative Scenario
    [Documentation]    This keyword is used to get token and create session for User API and send PUT request for the input JSON
    ...    with Invalid or Null values for Mandatory Fields.
    ...    @author: jloretiz    10DEC2019    - initial create
    ...    @author: jloretiz    14JAN2020    - renamed the keyword to a more generic name
    [Arguments]    ${sInputFilePath}    ${sInputJson}    ${sInputAPIResponse}    ${sOutputFilePath}    ${sOutputAPIResponse}
    ...    ${sInputFilePath_AccessToken}    ${sInputFile_AccessToken}    ${sLoginID}

    Delete All Sessions
    Create Session    ${TOKENSESSION}    ${MDM_HOST_TOKEN}
    ${accessToken}    Post Json File And Return Access Token    ${sInputFilePath_AccessToken}    ${sInputFile_AccessToken}    ${MDM_ACCESS_TOKEN}
    Create Session    ${APISESSION}    ${MDM_HOST}
    Put Json File    ${sInputFilePath}    ${sInputJson}    ${MDM_User_API}/${sLoginID}    ${sOutputFilePath}    ${sOutputAPIResponse}    ${accessToken}

POST Request for User API without Token
    [Documentation]    This keyword is used to create session for User API and send POST request for the input JSON.
    ...    @author: rtarayao    05NOV2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sInputJson}    ${sInputAPIResponse}    ${sOutputFilePath}    ${sOutputAPIResponse}

    Delete All Sessions
    Create Session    ${APISESSION}    ${MDM_HOST}
    Post Json File    ${sInputFilePath}    ${sInputJson}    ${MDM_User_API}    ${sOutputFilePath}    ${sOutputAPIResponse}
    Compare API Request and Response    ${sInputFilePath}    ${sInputAPIResponse}
    Verify Json Response Status Code    ${RESPONSECODE_201}

POST Request for User API with Token
    [Documentation]    This keyword is used to get token and create session for User API and send POST request for the input JSON.
    ...    @author: clanding
    ...    @update: clanding    05APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1, added token handling
    ...    @update: rtarayao    05NOV2019    - modified the keyword name to be specific for SSO enabled environment
    [Arguments]    ${sInputFilePath}    ${sInputJson}    ${sInputAPIResponse}    ${sOutputFilePath}    ${sOutputAPIResponse}
    ...    ${sInputFilePath_AccessToken}    ${sInputFile_AccessToken}

    Delete All Sessions
    Create Session    ${TOKENSESSION}    ${MDM_HOST_TOKEN}
    ${accessToken}    Post Json File And Return Access Token    ${sInputFilePath_AccessToken}    ${sInputFile_AccessToken}    ${MDM_ACCESS_TOKEN}  
    Create Session    ${APISESSION}    ${MDM_HOST}
    Post Json File    ${sInputFilePath}    ${sInputJson}    ${MDM_User_API}    ${sOutputFilePath}    ${sOutputAPIResponse}    ${accessToken}
    Compare API Request and Response    ${sInputFilePath}    ${sInputAPIResponse}
    Verify Json Response Status Code    ${RESPONSECODE_201}

PUT Request for User API without Token
    [Documentation]    This keyword is used to create session for User API and send PUT request for the input JSON.
    ...    @author: rtarayao    06NOV2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sInputJson}    ${sInputAPIResponse}    ${sOutputFilePath}    ${sOutputAPIResponse}
    ...    ${sLoginID}

    Delete All Sessions
    Create Session    ${APISESSION}    ${MDM_HOST}
    Put Json File    ${sInputFilePath}    ${sInputJson}    ${MDM_User_API}/${sLoginID}    ${sOutputFilePath}    ${sOutputAPIResponse}
    Compare API Request and Response    ${sInputFilePath}    ${sInputAPIResponse}
    Verify Json Response Status Code    ${RESPONSECODE_200}

PUT Request for User API with Token
    [Documentation]    This keyword is used to get token and create session for User API and send PUT request for the input JSON.
    ...    @author: clanding
    ...    @update: rtarayao    06NOV2019    - modified the keyword name to be specific for SSO enabled environment
    [Arguments]    ${sInputFilePath}    ${sInputJson}    ${sInputAPIResponse}    ${sOutputFilePath}    ${sOutputAPIResponse}
    ...    ${sInputFilePath_AccessToken}    ${sInputFile_AccessToken}    ${sLoginID}

    Delete All Sessions
    Create Session    ${TOKENSESSION}    ${MDM_HOST_TOKEN}
    ${accessToken}    Post Json File And Return Access Token    ${sInputFilePath_AccessToken}    ${sInputFile_AccessToken}    ${MDM_ACCESS_TOKEN}
    Create Session    ${APISESSION}    ${MDM_HOST}
    Put Json File    ${sInputFilePath}    ${sInputJson}    ${MDM_User_API}/${sLoginID}    ${sOutputFilePath}    ${sOutputAPIResponse}    ${accessToken}
    Compare API Request and Response    ${sInputFilePath}    ${sInputAPIResponse}
    Verify Json Response Status Code    ${RESPONSECODE_200}

DELETE Request for User API without Token
    [Documentation]    This keyword is used to get token and create session for User API.
    ...    @author: rtarayao    08NOV2019    - initial create
    [Arguments]    ${sAPI_URL}

    Delete All Sessions
    Create Session    ${APISESSION}    ${MDM_HOST}   
    Delete Request and Store Response    ${MDM_User_API}/${sAPI_URL}
    Verify Json Response Status Code    ${RESPONSECODE_204}
    Run Keyword And Continue On Failure    Should Be Empty    ${RESPONSE_FILE}
    ${IsEmpty}    Run Keyword And Return Status    Should Be Empty    ${RESPONSE_FILE}
    Run Keyword If    ${IsEmpty}==${True}    Log    Response is empty.
    ...    ELSE    Log    Response is NOT empty: '${RESPONSE_FILE}'.    level=ERROR

DELETE Request for User API with Token
    [Documentation]    This keyword is used to get token and create session for User API.
    ...    And send Delete Request then validate response is empty.
    ...    @author: clanding
    ...    @update: clanding    22APR2019    - added ${sLoginID} in argument
    ...    @update: amansuet    16AUG2019    - removed the put script and updated argument for delete request json file
    ...    @update: amansuet    19AUG2019    - removed json file validation
    ...    @update: amansuet    23AUG2019    - added lob argument and condition to set accesstoken to global variable
    ...    @update: rtarayao    08NOV2019    - modified the keyword name to be specific for SSO enabled environment
    [Arguments]    ${sInputFilePath_AccessToken}    ${sInputFile_AccessToken}    ${sAPI_URL}    ${sLOB_value}

    Delete All Sessions
    Create Session    ${TOKENSESSION}    ${MDM_HOST_TOKEN}
    ${accessToken}    Post Json File And Return Access Token    ${sInputFilePath_AccessToken}    ${sInputFile_AccessToken}    ${MDM_ACCESS_TOKEN}
    Create Session    ${APISESSION}    ${MDM_HOST}   
    Delete Request and Store Response    ${MDM_User_API}/${sAPI_URL}    ${accessToken}
    Verify Json Response Status Code    ${RESPONSECODE_204}
    Run Keyword And Continue On Failure    Should Be Empty    ${RESPONSE_FILE}
    ${IsEmpty}    Run Keyword And Return Status    Should Be Empty    ${RESPONSE_FILE}
    Run Keyword If    ${IsEmpty}==${True}    Log    Response is empty.
    ...    ELSE    Log    Response is NOT empty: '${RESPONSE_FILE}'.    level=ERROR

    Run Keyword If    '${sLOB_value}'=='ALL'    Set Global Variable    ${AUTH_TOKEN_ALL}    ${accessToken}
    ...    ELSE IF    '${sLOB_value}'=='COMRLENDING'    Set Global Variable    ${AUTH_TOKEN_LIQ}    ${accessToken}
    ...    ELSE IF    '${sLOB_value}'=='COREBANKING'    Set Global Variable    ${AUTH_TOKEN_ESS}    ${accessToken}
    ...    ELSE IF    '${sLOB_value}'=='PARTY'    Set Global Variable    ${AUTH_TOKEN_PTY}    ${accessToken}

DELETE Request for User API without Token with Error
    [Documentation]    This keyword is used to get token and create session for User API Delete
    ...    And send Delete Request then validate response is error.
    ...    @author: jloretiz    20JAN2020    - initial create
    [Arguments]    ${sAPI_URL}

    Delete All Sessions
    Create Session    ${APISESSION}    ${MDM_HOST}   
    Delete Request and Store Response    ${MDM_User_API}/${sAPI_URL}
    Verify Json Response Status Code    ${RESPONSECODE_400}

DELETE Request for User API with Token with Error
    [Documentation]    This keyword is used to get token and create session for User API with Error.
    ...    And send Delete Request then validate response is error.
    ...    @author: jloretiz    20JAN2020    - initial create
    [Arguments]    ${sInputFilePath_AccessToken}    ${sInputFile_AccessToken}    ${sAPI_URL}    ${sLOB_value}

    Delete All Sessions
    Create Session    ${TOKENSESSION}    ${MDM_HOST_TOKEN}
    ${accessToken}    Post Json File And Return Access Token    ${sInputFilePath_AccessToken}    ${sInputFile_AccessToken}    ${MDM_ACCESS_TOKEN}
    Create Session    ${APISESSION}    ${MDM_HOST}   
    Delete Request and Store Response    ${MDM_User_API}/${sAPI_URL}    ${accessToken}
    Verify Json Response Status Code    ${RESPONSECODE_400}

    Run Keyword If    '${sLOB_value}'=='ALL'    Set Global Variable    ${AUTH_TOKEN_ALL}    ${accessToken}
    ...    ELSE IF    '${sLOB_value}'=='COMRLENDING'    Set Global Variable    ${AUTH_TOKEN_LIQ}    ${accessToken}
    ...    ELSE IF    '${sLOB_value}'=='COREBANKING'    Set Global Variable    ${AUTH_TOKEN_ESS}    ${accessToken}
    ...    ELSE IF    '${sLOB_value}'=='PARTY'    Set Global Variable    ${AUTH_TOKEN_PTY}    ${accessToken}