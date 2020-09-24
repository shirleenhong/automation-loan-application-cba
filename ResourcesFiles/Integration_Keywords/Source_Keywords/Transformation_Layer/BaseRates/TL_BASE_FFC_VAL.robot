*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot


*** Keywords ***
Validate FFC for TL Base Rate Success
    [Documentation]    This keyword is used to validate OpenAPI, Distributor and CustomCBAInterface in MCH FFC UI.
    ...    @author: clanding    21FEB2019    - initial create
    ...    @update: clanding    18MAR2019    - handle inactive funding desk in TextJMS by adding multiple filters
    ...    @update: clanding    19MAR2019    - added Compare Multiple Input and Output JSON
    ...    @update: clanding    08APR2019    - updated Compare Multiple Input and Output JSON to Compare Multiple Input and Output JSON for Base Rate
    ...    @update: clanding    30MAY2019    - added getting ${REQUESTID_VALUE} and using it as filter for OpenAPI, TextJMS. Updating CustomInterface to CBAPush
    ...    @update: jdelacru    26JUL2019    - added optional argument (sOutputType) for keyword Go to Dashboard and Click Source API Name
    [Arguments]    ${sInputFilePath}    ${sInputFileName}    ${sInputXML}    ${sOutputFilePath}    ${sOutputFileName}    ${sOutputXML}    ${sResponse}    ${sResponseMechanism}
    
    Login to MCH UI
    
    ###Base Splitter###
    Wait Until Element Is Visible    ${FFC_Dashboard}    30s
    ${aHeaderRefNameList}    Create List    ${REQUESTS_ID}
    ${aExpectedRefList}    Create List    ${GSFILENAME_WITHTIMESTAMP}   
    Go to Dashboard and Click Source API Name    ${TL_BASE_ACK_MESSAGE_SOURCENAME}    sOutputType=${TLSUCCESS_OUTPUT_TYPE}
    ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    ${Results_Row_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Row}
    ${RequestID_UI}    Get Results Table Column Value by Header Title and Return    ${Results_Row_Count}    ${REQUESTS_ID}
    ${REQUESTID_VALUE}    Split Request ID From Splitter Queue for TL and Return Final Request ID    ${RequestID_UI}    |
    
    ###OpenAPI###
    Go to Dashboard and Click Source API Name    ${BASE_SOURCENAME}    ${OPEAPI_INSTANCE_TL}
    ${ResultsRowList}    Filter by Reference Header and Save Message TextArea and Return Results Row List Value    ${X_REQUEST_ID}    ${REQUESTID_VALUE}    ${sOutputFilePath}${sOutputFileName}    
    ...    ${JSON}    ${RESULTSTABLE_STATUS}    ${CONTENT_TYPE}    ${HTTP_OPERATION}
    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${MESSAGESTATUS_SUCCESSFUL}    ${CONTENT_TYPE_VALUE}    ${POSTMethod}
    Compare Multiple Input and Output JSON for Base Rate    ${sInputFilePath}    ${sInputFileName}  
      
    ###CustomCBAPush###
    Go to Dashboard and Click Source API Name    ${CBAPUSH_SOURCENAME}    ${CBAPUSH_INSTANCE}
    ${aHeaderRefNameList}    Create List    ${JMS_CORRELATION_ID}
    ${aExpectedRefList}    Create List    ${REQUESTID_VALUE}
    ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    ${Results_Row_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Row}
    ${Response_UI}    Get Results Table Column Value by Header Title and Return    ${Results_Row_Count}    ${JMS_PAYLOAD}
    Create File    ${datasetpath}${sOutputFilePath}${sResponse}.${JSON}    ${Response_UI}
    Validate Response from CBA Push Queue    ${sOutputFilePath}${sResponse}    ${REQUESTID_VALUE}    ${POSTMethod}    ${BASEINTERESTRATE_APINAME}    ${OPEARATIONSTATUS_SUCCESS}
    
    ###Distributor###
    Go to Dashboard and Click Source API Name    ${TEXTJMS_SOURCENAME}    ${TEXTJMS_INSTANCE}
    ${aHeaderRefNameList}    Create List    ${HEADER_CORRELATION_ID}    ${RESULTSTABLE_STATUS}
    ${aExpectedRefList}    Create List    ${REQUESTID_VALUE}    ${SENT}
    ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    ${ResultsRowList}    Save Message TextArea and Return Results Row List Value    ${ColumnIndex}    ${sOutputFilePath}${sOutputXML}    ${XML}    ${ROUTEROPERATION}    ${HEADER_CATEGORY}    ${HEADER_OPERATION}    
    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${BASE_ROUTEROPTION}    ${BASE_CATEGORY}    ${POSTMethod}
    Compare Expected and Actual TextJMS for Base Rate TL    ${sInputFilePath}${sInputXML}    ${sOutputFilePath}${sOutputXML}
    
    ###Response Mechanism###
    Go to Dashboard and Click Source API Name    ${RESPONSE_MECHANISM_SOURCENAME}    ${RESPONSE_MECHANISM_INSTANCE}
     ${ResultsRowList}    Filter by Reference Header and Save Message TextArea for Specified File and Return Results Row List Value    ${DESTINATION}    ${DESTINATION_BR}    ${REQUESTID_VALUE}    ${sOutputFilePath}${sResponseMechanism}
    ...    ${JSON}    ${RESULTSTABLE_STATUS}
    Validate Response Mechanism    ${sOutputFilePath}${sResponseMechanism}    ${REQUESTID_VALUE}    ${POSTMethod}    ${BASEINTERESTRATE_APINAME}    ${OPEARATIONSTATUS_SUCCESS}
    
    Logout to MCH UI and Close Browser

Validate FFC for TL Base Rate Success with Multiple Files
    [Documentation]    This keyword is used to validate correct sequencing of Transformation Layer Base Rate on MCH FFC UI for multiple GS files.
    ...    @author: clanding    05MAR2019    - initial create
    ...    @update: clanding    19MAR2019    - added Compare Multiple Input and Output JSON
    ...    @update: clanding    08APR2019    - updated Compare Multiple Input and Output JSON to Compare Multiple Input and Output JSON for Base Rate
    ...    @update: clanding    30MAY2019    - added getting ${REQUESTID_VALUE} and using it as filter for OpenAPI, TextJMS. Updating CustomInterface to CBAPush
    ...    @update: jdelacru    21JUN2019    - added for loop in getting the RequestID from Base Splitter
    ...    @update: jdelacru    08AUG2019    - added for loops for APISource, CustomCBAPush, TextJMS and Response Mechanism to handle validation in processing multiple files
    ...    @update: jdelacru    28AUG2019    - added _${index} in validating OpenAPI base rate and textjms, this is lookup for same file details with different rates.
    [Arguments]    ${sInputFilePath}    ${sInputFileName}    ${sInputXML}    ${sOutputFilePath}    ${sOutputFileName}    ${sOutputXML}    ${sResponse}    ${sResponseMechanism}
    
    Login to MCH UI
    Wait Until Element Is Visible    ${FFC_Dashboard}    30s
    
    ###Base Splitter###
    # Go to Dashboard and Click Source API Name    ${TL_BASE_ACK_MESSAGE_SOURCENAME}    sOutputType=${TLSUCCESS_OUTPUT_TYPE}
    Go to Dashboard and Click Source API Name    ${TL_BASE_ACK_MESSAGE_SOURCENAME}    ${CUSTOM_INTERFACE_INSTANCE}
    Log    ${ARCHIVE_GSFILENAME_LIST}
    ${aHeaderRefNameList}    Create List    ${REQUESTS_ID}
    ${GSFile_Count}    Get Length    ${ARCHIVE_GSFILENAME_LIST}
    @{RequestID_List}    Create List    
    :FOR    ${i}    IN RANGE    ${GSFile_Count}
    \    ${GSFilename}    Get From List    ${ARCHIVE_GSFILENAME_LIST}    ${GSFile_Count-1}
    \    ${aExpectedRefList}    Create List    ${GSFilename}
    \    ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    \    ${Results_Row_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Row}
    \    ${RequestID_UI}    Get Results Table Column Value by Header Title and Return    ${Results_Row_Count}    ${REQUESTS_ID}
    \    ${REQUESTID_VALUE}    Split Request ID From Splitter Queue for TL and Return Final Request ID    ${RequestID_UI}    |
    \    Append To List    ${RequestID_List}    ${REQUESTID_VALUE}
    \    ${GSFile_Count}    Evaluate    ${GSFile_Count}-1
    \    Log    ${RequestID_List}
    \    Exit For Loop If    ${i}==${GSFile_Count}
    Set Global Variable    ${REQUESTID_LIST}    ${RequestID_List}
    
    ###OpenAPI###
    ${RequestID_Count}    Get Length    ${RequestID_List}
    Go to Dashboard and Click Source API Name    ${BASE_SOURCENAME}    ${OPEAPI_INSTANCE_TL}
    ${GSFilename_Last}    Sequence Validation for Multiple Files    ${X_REQUEST_ID}    ${REQUESTID_LIST}
    :FOR    ${i}    IN RANGE    ${RequestID_Count}
    \    ${RequestID}    Get From List    ${RequestID_List}    ${i}
    \    ${ResultsRowList}    Filter by Reference Header and Save Message TextArea and Return Results Row List Value    ${X_REQUEST_ID}    ${RequestID}        
         ...    ${sOutputFilePath}${sOutputFileName}    ${JSON}    ${RESULTSTABLE_STATUS}    ${CONTENT_TYPE}    ${HTTP_OPERATION}
    \    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${MESSAGESTATUS_SUCCESSFUL}    ${CONTENT_TYPE_VALUE}    ${POSTMethod}
    \    Compare Multiple Input and Output JSON for Base Rate    ${sInputFilePath}    ${sInputFileName}_${i}

    ###CustomCBAPush###
    Go to Dashboard and Click Source API Name    ${CBAPUSH_SOURCENAME}    ${CBAPUSH_INSTANCE}
    ${GSFilename_Last}    Sequence Validation for Multiple Files    ${JMS_CORRELATION_ID}    ${REQUESTID_LIST}
    ${aHeaderRefNameList}    Create List    ${JMS_CORRELATION_ID}
    ${RequestID_Count}    Get Length    ${REQUESTID_LIST}
    :FOR    ${i}    IN RANGE    ${RequestID_Count}
    \    ${RequestID}    Get From List    ${RequestID_List}    ${i}
    \    ${aExpectedRefList}    Create List    ${RequestID}
    \    ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    \    ${Results_Row_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Row}
    \    ${Response_UI}    Get Results Table Column Value by Header Title and Return    ${Results_Row_Count}    ${JMS_PAYLOAD}
    \    Create File    ${datasetpath}${sOutputFilePath}${sResponse}.${JSON}    ${Response_UI}
    \    Validate Response from CBA Push Queue    ${sOutputFilePath}${sResponse}    ${RequestID}    ${POSTMethod}    ${BASEINTERESTRATE_APINAME}    ${OPEARATIONSTATUS_SUCCESS}

    ###Distributor###
    Go to Dashboard and Click Source API Name    ${TEXTJMS_SOURCENAME}    ${TEXTJMS_INSTANCE}
    ${aHeaderRefNameList}    Create List    ${HEADER_CORRELATION_ID}
    :FOR    ${i}    IN RANGE    ${RequestID_Count}
    \    ${RequestID}    Get From List    ${REQUESTID_LIST}    ${i}
    \    ${RouterOperation}    Set Variable    ROUTEROPERATION
    \    ${ResultsRowList}    Filter by Reference Header and Save Message TextArea and Return Results Row List Value    ${HEADER_CORRELATION_ID}    ${RequestID}
         ...    ${sOutputFilePath}${sOutputXML}    ${XML}    ${RESULTSTABLE_STATUS}    ${RouterOperation}    ${HEADER_CATEGORY}    ${HEADER_OPERATION}
    \    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${SENT}    ${BASE_ROUTEROPTION}    ${BASE_CATEGORY}    ${POSTMethod}
    \    Compare Expected and Actual TextJMS for Base Rate TL    ${sInputFilePath}${sInputXML}_${i}    ${sOutputFilePath}${sOutputXML}
    
    ###Response Mechanism###
    Go to Dashboard and Click Source API Name    ${RESPONSE_MECHANISM_SOURCENAME}    ${RESPONSE_MECHANISM_INSTANCE}
    :FOR    ${RequestID}    IN    @{RequestID_List}
    \    ${ResultsRowList}    Filter by Reference Header and Save Message TextArea for Specified File and Return Results Row List Value    ${DESTINATION}    ${DESTINATION_BR}    ${RequestID}    ${sOutputFilePath}${sResponseMechanism}
         ...    ${JSON}    ${RESULTSTABLE_STATUS}
    \    Validate Response Mechanism    ${sOutputFilePath}${sResponseMechanism}    ${RequestID}    ${POSTMethod}    ${BASEINTERESTRATE_APINAME}    ${OPEARATIONSTATUS_SUCCESS}

    Logout to MCH UI and Close Browser

Validate FFC for TL Base Rate Failed
    [Documentation]    This keyword is used to validate CustomCBAPush in MCH FFC UI for status Failed.
    ...    @author: clanding    12MAR2019    - initial create
    ...    @update: cfrancis    03SEP2019    - changed validation from failure to success since payload would show the error
    ...    @update: cfrancis    12SEP2019    - added condition to run only verification of file validation failed on response
    ...    if the error is caused by inactive base rate code
    ...    @update: dahijara    14FEB2019    - added logic to handle/validate multiple expected resopnses.
    [Arguments]    ${sOutputFilePath}    ${sOutputFileName}    ${sExpectedErrorMsg}    ${isMultipleExpectedResponse}=None
    
    Login to MCH UI
    Wait Until Element Is Visible    ${FFC_Dashboard}    30s
    
    ###CustomInterface###
    Go to Dashboard and Click Source API Name    ${CBAPUSH_SOURCENAME}    ${CBAPUSH_INSTANCE}
    ${ResultsRowList}    Filter by Reference Header and Save Header Value and Return Results Row List Value    ${JMS_HEADERS}    X-Request-ID=${GSFILENAME_WITHTIMESTAMP}    ${sOutputFilePath}${sOutputFileName}    
    ...    ${JSON}    ${JMS_PAYLOAD}    ${RESULTSTABLE_STATUS}    ${JMS_INBOUND_QUEUE}    ${HTTPSTATUS}
    #Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${FAILED}    ${TL_NOTIF_OUT}    ${FAILED_STATUS}
    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${SUCCESSFUL}    ${TL_NOTIF_OUT}    ${RESPONSECODE_200}
    
    Verify Expected Value in the Given JSON File for Base Rate TL    ${sOutputFilePath}${sOutputFileName}    ${REQUEST_ID}    ${GSFILENAME_WITHTIMESTAMP}
    Verify Expected Value in the Given JSON File for Base Rate TL    ${sOutputFilePath}${sOutputFileName}    ${APINAME}    ${BASE_APINAME_FAILED}
    Verify Expected Value in the Given JSON File for Base Rate TL    ${sOutputFilePath}${sOutputFileName}    ${CONSOLIDATED_STATUS}    ${MESSAGESTATUS_FAILURE}
    
    #Handle List Value for ErrorMsg
    ${temp_Invalid_BaseRateCodeConfig}    Set Variable    ${INVALID_BASERATECODE_CONFIG}
    ${temp_Invalid_BaseRateCode}    Set Variable    ${INACTIVE_BASERATECODE}
    ${inactive_BaseRateCode}    Run Keyword If    ${isMultipleExpectedResponse}==${True}    Run Keyword And Return Status    List Should Contain Value    ${sExpectedErrorMsg}    ${temp_Invalid_BaseRateCode}
    ${invalid_BaseRateCodeConfig}    Run Keyword If    ${isMultipleExpectedResponse}==${True}    Run Keyword And Return Status    List Should Contain Value    ${sExpectedErrorMsg}    ${temp_Invalid_BaseRateCodeConfig}

    
    Run Keyword If    ${inactive_BaseRateCode}==${False} and ${invalid_BaseRateCodeConfig}==${False}    Verify Expected Value in the Given JSON File for Base Rate TL    ${sOutputFilePath}${sOutputFileName}    ${RESPONSES}    ${FILE_VALIDATION}    ${RESPONSE_DETAILS}    ${MESSAGE_ID}
    ...    ELSE IF    '${sExpectedErrorMsg}' != '${temp_Invalid_BaseRateCode}' and '${sExpectedErrorMsg}' != '${temp_Invalid_BaseRateCodeConfig}'    Verify Expected Value in the Given JSON File for Base Rate TL    ${sOutputFilePath}${sOutputFileName}    ${RESPONSES}    ${FILE_VALIDATION}    ${RESPONSE_DETAILS}    ${MESSAGE_ID}

    Run Keyword If    ${isMultipleExpectedResponse}==${True}    Verify Multiple Expected Value in the Given JSON File for Base Rates TL    ${sOutputFilePath}${sOutputFileName}    ${RESPONSES}    ${sExpectedErrorMsg}    ${RESPONSE_DETAILS}    ${RESPONSE_DESC}
    ...    ELSE    Verify Expected Value in the Given JSON File for Base Rate TL    ${sOutputFilePath}${sOutputFileName}    ${RESPONSES}    ${sExpectedErrorMsg}    ${RESPONSE_DETAILS}    ${RESPONSE_DESC}

    Verify Expected Value in the Given JSON File for Base Rate TL    ${sOutputFilePath}${sOutputFileName}    ${RESPONSES}    ${MESSAGESTATUS_FAILURE}    ${RESPONSE_DETAILS}    ${RESPONSE_STAT}
    
    Logout to MCH UI and Close Browser

Verify Multiple Expected Value in the Given JSON File for Base Rates TL
    [Documentation]    This keyword is used to validate multiple expected value in the given JSON file.
    ...    @author: dahijara    10FEB2020    - initial create
    [Arguments]    ${sFilePath}    ${sKeyField}    ${sExpectedValue}    ${sSubKeyField_Initial}=None    ${sSubKeyField_Final}=None
    
    ${JSON_Object}    Load JSON From File    ${dataset_path}${sFilePath}.json
    Log    ${sExpectedValue}
    ${expectedValueCount}    Get Length    ${sExpectedValue}
    
    :FOR    ${index}    IN RANGE    ${expectedValueCount}
    \    Log    @{sExpectedValue}[${index}]
    \    ${isMatched}    Run Keyword And Return Status    Verify Expected Value in the Given JSON File for Base Rate TL    ${sFilePath}    ${sKeyField}    @{sExpectedValue}[${index}]    ${sSubKeyField_Initial}    ${sSubKeyField_Final}
    \    ${ExpectedValue_Final}    Run Keyword If    ${isMatched}==${True}    Set Variable    @{sExpectedValue}[${index}]
    \    Exit For Loop If    ${isMatched}==${True}

    Run Keyword If    ${isMatched}==${True}    Log    ${sKeyField} value is '&{JSON_Object}[${sKeyField}]'. Expected: '${ExpectedValue_Final}' is existing in Output: '&{JSON_Object}[${sKeyField}]'.
    ...    ELSE    Fail    ${sKeyField} value is '&{JSON_Object}[${sKeyField}]'. Expected: Any of these response description '${sExpectedValue}' is NOT existing in Output: '&{JSON_Object}[${sKeyField}]'.

Validate FFC for TL Base Rate Error
    [Documentation]    This keyword is used to validate CustomCBAPush in MCH FFC UI for status Error.
    ...    @author by clanding    12MAR2019    - initial create
    [Arguments]    ${sOutputFilePath}    ${sOutputFileName}    ${sExpectedErrorMsg}
    
    Login to MCH UI
    Wait Until Element Is Visible    ${FFC_Dashboard}    30s
    
    ###CustomInterface###
    Go to Dashboard and Click Source API Name    ${CBAPUSH_SOURCENAME}    ${CBAPUSH_INSTANCE}
    ${ResultsRowList}    Filter by Reference Header and Save Header Value and Return Results Row List Value    ${JMS_HEADERS}    ${GSFILENAME_WITHTIMESTAMP}    ${sOutputFilePath}${sOutputFileName}    
    ...    ${JSON}    ${JMS_PAYLOAD}    ${RESULTSTABLE_STATUS}    ${JMS_INBOUND_QUEUE}
    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${SUCCESSFUL}    ${TL_NOTIF_OUT}
    
    Verify Expected Value in the Given JSON File for Base Rate TL    ${sOutputFilePath}${sOutputFileName}    ${REQUEST_ID}    ${GSFILENAME_WITHTIMESTAMP}
    Verify Expected Value in the Given JSON File for Base Rate TL    ${sOutputFilePath}${sOutputFileName}    ${APINAME}    ${BASE_APINAME_FAILED}
    Verify Expected Value in the Given JSON File for Base Rate TL    ${sOutputFilePath}${sOutputFileName}    ${CONSOLIDATED_STATUS}    ${MESSAGESTATUS_FAILURE}
    Verify Expected Value in the Given JSON File for Base Rate TL    ${sOutputFilePath}${sOutputFileName}    ${RESPONSES}    ${FILE_VALIDATION}    ${RESPONSE_DETAILS}    ${MESSAGE_ID}
    Verify Expected Value in the Given JSON File for Base Rate TL    ${sOutputFilePath}${sOutputFileName}    ${RESPONSES}    ${sExpectedErrorMsg}    ${RESPONSE_DETAILS}    ${RESPONSE_DESC}
    Verify Expected Value in the Given JSON File for Base Rate TL    ${sOutputFilePath}${sOutputFileName}    ${RESPONSES}    ${MESSAGESTATUS_FAILURE}    ${RESPONSE_DETAILS}    ${RESPONSE_STAT}
    
    Logout to MCH UI and Close Browser

Verify Expected Value in the Given JSON File for Base Rate TL
    [Documentation]    This keyword is used to verify if given expected value is existing in the given json file.
    ...    @author: clanding    12MAR2019    - initial create
    [Arguments]    ${sFilePath}    ${sKeyField}    ${sExpectedValue}    ${sSubKeyField_Initial}=None    ${sSubKeyField_Final}=None
    
    ${JSON_Object}    Load JSON From File    ${dataset_path}${sFilePath}.json
    
    Run Keyword If    '${sSubKeyField_Initial}'=='None' and '${sSubKeyField_Final}'=='None'    Run Keyword And Continue On Failure    Should Contain    &{JSON_Object}[${sKeyField}]    ${sExpectedValue}
    ${Stat}    Run Keyword If    '${sSubKeyField_Initial}'=='None' and '${sSubKeyField_Final}'=='None'    Run Keyword And Return Status    Should Contain    &{JSON_Object}[${sKeyField}]    ${sExpectedValue}
    Run Keyword If    ${Stat}==${True}    Log    ${sKeyField} value is '&{JSON_Object}[${sKeyField}]'. Expected: '${sExpectedValue}' is existing in Output: '&{JSON_Object}[${sKeyField}]'.
    ...    ELSE IF    ${Stat}==${False}    Log    ${sKeyField} value is '&{JSON_Object}[${sKeyField}]'. Expected: '${sExpectedValue}' is NOT existing in Output: '&{JSON_Object}[${sKeyField}]'.    level=ERROR
    ...    ELSE    Log    Keyword not applicable.
    
    Run Keyword If    '${sSubKeyField_Initial}'!='None' and '${sSubKeyField_Final}'!='None'    Get Sub KeyField Value and Compare to Expected Value    &{JSON_Object}[${sKeyField}]    
    ...    ${sSubKeyField_Initial}    ${sSubKeyField_Final}    ${sExpectedValue}
    ...    ELSE    Log    No sub keyfield provided. Step is not applicable and will be skipped.
    
        
Get Sub KeyField Value and Compare to Expected Value
    [Documentation]    This keyword is used to get sub keyfiled value and verify if expected value is existing in the sub keyfield value.
    ...    @author: clanding    12MAR2019    - initial create
    [Arguments]    ${dKeyFieldList}    ${sSubKeyField_Initial}    ${sSubKeyField_Final}    ${sExpectedValue}
    
    ${Resp_Count}    Get Length    ${dKeyFieldList}
    :FOR    ${Index}    IN RANGE    ${Resp_Count}
    \    
    \    ${KeyField_Dict_Initial}    Get From List    ${dKeyFieldList}    ${Index}
    \    ${KeyField_Initial_List}    Get From Dictionary    ${KeyField_Dict_Initial}    ${sSubKeyField_Initial}
    \    ${KeyField_Dict}    Get From List    ${KeyField_Initial_List}    0
    \    Run Keyword And Continue On Failure    Should Contain    &{KeyField_Dict}[${sSubKeyField_Final}]    ${sExpectedValue}
    \    ${Stat}    Run Keyword And Return Status    Should Contain    &{KeyField_Dict}[${sSubKeyField_Final}]    ${sExpectedValue}
    \    Run Keyword If    ${Stat}==${True}    Log    ${sSubKeyField_Final} value is '&{KeyField_Dict}[${sSubKeyField_Final}]'. Expected: '${sExpectedValue}' is existing in Output: '&{KeyField_Dict}[${sSubKeyField_Final}]'.
         ...    ELSE    Log    ${sSubKeyField_Final} value is '&{KeyField_Dict}[${sSubKeyField_Final}]'. Expected: '${sExpectedValue}' is NOT existing in Output: '&{KeyField_Dict}[${sSubKeyField_Final}]'.    level=ERROR
    \    
    \    Exit For Loop If    ${Index}==${Resp_Count}
    
Validate FFC for TL Base Rate Error in Distributor
    [Documentation]    This keyword is used to validate OpenAPI, Distributor and CustomCBAInterface in MCH FFC UI.
    ...    This also used to validate if Distributor encountered status Error.
    ...    @author: clanding    19MAR2019    - initial create
    ...    @update: clanding    08APR2019    - updated Compare Multiple Input and Output JSON to Compare Multiple Input and Output JSON for Base Rate
    [Arguments]    ${sInputFilePath}    ${sInputFileName}    ${sInputXML}    ${sOutputFilePath}    ${sOutputFileName}    ${sOutputXML}
    
    Login to MCH UI
    
    ###OpenAPI###
    Wait Until Element Is Visible    ${FFC_Dashboard}    30s
    Go to Dashboard and Click Source API Name    ${BASE_SOURCENAME}    ${OPEAPI_INSTANCE_TL}
    ${ResultsRowList}    Filter by Reference Header and Save Message TextArea and Return Results Row List Value    ${X_REQUEST_ID}    ${GSFILENAME_WITHTIMESTAMP}    ${sOutputFilePath}${sOutputFileName}    
    ...    ${JSON}    ${RESULTSTABLE_STATUS}    ${CONTENT_TYPE}    ${HTTP_OPERATION}
    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${MESSAGESTATUS_SUCCESSFUL}    ${CONTENT_TYPE_VALUE}    ${POSTMethod}
    Compare Multiple Input and Output JSON for Base Rate    ${sInputFilePath}    ${sInputFileName}
    
    ###CustomInterface###
    Go to Dashboard and Click Source API Name    ${CBAINTERFACE_SOURCENAME}    ${CBAINTERFACE_INSTANCE}
    ${ResultsRowList}    Filter by Reference Header and Save Message TextArea and Return Results Row List Value    ${JMS_CORRELATION_ID}    ${GSFILENAME_WITHTIMESTAMP}    ${sOutputFilePath}${TEMPLATE_TEXTFILE}    
    ...    ${TXT}    ${RESULTSTABLE_STATUS}    ${JMS_INBOUND_QUEUE}    ${HTTPSTATUS}    ${OPERATION_STATUS}
    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${MESSAGESTATUS_SUCCESSFUL}    ${TL_BASE_OUT}    ${POST_STATUS}    ${OPEARATIONSTATUS_SUCCESS}
    
    ###Distributor###
    Go to Dashboard and Click Source API Name    ${TEXTJMS_SOURCENAME}    ${TEXTJMS_INSTANCE}
    ${aHeaderRefNameList}    Create List    ${HEADER_CORRELATION_ID}    ${RESULTSTABLE_STATUS}
    ${aExpectedRefList}    Create List    ${GSFILENAME_WITHTIMESTAMP}    ${ERROR}
    ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    ${ResultsRowList}    Save Message TextArea and Return Results Row List Value    ${ColumnIndex}    ${sOutputFilePath}${sOutputXML}    ${XML}    ${ROUTEROPERATION}    ${HEADER_CATEGORY}    ${HEADER_OPERATION}    
    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${LIQ RESPONSE}    ${BASE_CATEGORY}    ${POSTMethod}
    Compare Expected and Actual TextJMS for Base Rate TL    ${sInputFilePath}${sInputXML}    ${sOutputFilePath}${sOutputXML}
    
    Logout to MCH UI and Close Browser
    
Validate FFC for TL Base Rate Success with Multiple SubEntities
    [Documentation]    This keyword is used to validate Transformation Layer Base Rate on MCH FFC UI with multiple subentities.
    ...    @author: jdelacru    21SEP2020    - initial create
    [Arguments]    ${sInputFilePath}    ${sInputFileName}    ${sInputXML}    ${sOutputFilePath}    ${sOutputFileName}    ${sOutputXML}    ${sResponse}    ${sResponseMechanism}
    
    Login to MCH UI
    
    ###Base Splitter###
    Wait Until Element Is Visible    ${FFC_Dashboard}    30s
    ${aHeaderRefNameList}    Create List    ${REQUESTS_ID}
    ${aExpectedRefList}    Create List    ${GSFILENAME_WITHTIMESTAMP}   
    Go to Dashboard and Click Source API Name    ${TL_BASE_ACK_MESSAGE_SOURCENAME}    sOutputType=${TLSUCCESS_OUTPUT_TYPE}
    ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    ${Results_Row_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Row}
    ${RequestID_UI}    Get Results Table Column Value by Header Title and Return    ${Results_Row_Count}    ${REQUESTS_ID}
    ${REQUESTID_VALUE}    Split Request ID From Splitter Queue for TL and Return Final Request ID    ${RequestID_UI}    |

    ###OpenAPI###
    ${SubEntityCount}    Get Length    ${SUBENTITYLIST}
    :FOR    ${Index}    IN RANGE    0    ${SubEntityCount}
    \    ${SubEntity}    Get From List    ${SUBENTITYLIST}    ${Index}
    \    Go to Dashboard and Click Source API Name    ${BASE_SOURCENAME}    ${OPEAPI_INSTANCE_TL}
    \    ${REQUESTID_VALUE}    Run Keyword If    '${SubEntity}'=='EUR'    Set Variable    ${REQUESTID_VALUE}_0
         ...    ELSE    Set Variable    ${REQUESTID_VALUE}
    \    Log     RequestID is ${REQUESTID_VALUE}
    \    ${ResultsRowList}    Filter by Reference Header and Save Message TextArea and Return Results Row List Value    ${X_REQUEST_ID}    ${REQUESTID_VALUE}    ${sOutputFilePath}${sOutputFileName}    
         ...    ${JSON}    ${RESULTSTABLE_STATUS}    ${CONTENT_TYPE}    ${HTTP_OPERATION}
    \    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${MESSAGESTATUS_SUCCESSFUL}    ${CONTENT_TYPE_VALUE}    ${POSTMethod}
    \    Compare Multiple Input and Output JSON for Base Rate    ${sInputFilePath}    ${sInputFileName}    ${SubEntity}
    \    Pause Execution

    ###CustomCBAPush###
    :FOR    ${Index}    IN RANGE    0    ${SubEntityCount}
    \    ${SubEntity}    Get From List    ${SUBENTITYLIST}    ${Index}
    \    Go to Dashboard and Click Source API Name    ${CBAPUSH_SOURCENAME}    ${CBAPUSH_INSTANCE}
    \    ${REQUESTID_VALUE}    Run Keyword If    '${SubEntity}'=='EUR'    Set Variable    ${REQUESTID_VALUE}_0
         ...    ELSE    Get Substring    ${REQUESTID_VALUE}    0    -2
    \    Log     RequestID is ${REQUESTID_VALUE}
    \    ${aHeaderRefNameList}    Create List    ${JMS_CORRELATION_ID}
    \    ${aExpectedRefList}    Create List    ${REQUESTID_VALUE}
    \    ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    \    ${Results_Row_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Row}
    \    ${Response_UI}    Get Results Table Column Value by Header Title and Return    ${Results_Row_Count}    ${JMS_PAYLOAD}
    \    Create File    ${datasetpath}${sOutputFilePath}${sResponse}.${JSON}    ${Response_UI}
    \    Validate Response from CBA Push Queue    ${sOutputFilePath}${sResponse}    ${REQUESTID_VALUE}    ${POSTMethod}    ${BASEINTERESTRATE_APINAME}    ${OPEARATIONSTATUS_SUCCESS}

    ###Distributor###
    :FOR    ${Index}    IN RANGE    0    ${SubEntityCount}
    \    ${SubEntity}    Get From List    ${SUBENTITYLIST}    ${Index}
    \    Go to Dashboard and Click Source API Name    ${TEXTJMS_SOURCENAME}    ${TEXTJMS_INSTANCE}
    \    ${REQUESTID_VALUE}    Run Keyword If    '${SubEntity}'=='EUR'    Set Variable    ${REQUESTID_VALUE}_0
         ...    ELSE    Get Substring    ${REQUESTID_VALUE}    0    -2
    \     Log     RequestID is ${REQUESTID_VALUE}
    \    ${aHeaderRefNameList}    Create List    ${HEADER_CORRELATION_ID}    ${RESULTSTABLE_STATUS}
    \    ${aExpectedRefList}    Create List    ${REQUESTID_VALUE}    ${SENT}
    \    ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    \    Log    Router Operation is ${ROUTEROPERATION}
    \    ${ResultsRowList}    Save Message TextArea and Return Results Row List Value    ${ColumnIndex}    ${sOutputFilePath}${sOutputXML}    ${XML}    ${ROUTEROPERATION}    ${HEADER_CATEGORY}    ${HEADER_OPERATION}    
    \    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${BASE_ROUTEROPTION}    ${BASE_CATEGORY}    ${POSTMethod}
    \    Compare Expected and Actual TextJMS for Base Rate TL    ${sInputFilePath}${sInputXML}    ${sOutputFilePath}${sOutputXML}
  
    ###Response Mechanism###
    :FOR    ${Index}    IN RANGE    0    ${SubEntityCount}
    \    ${SubEntity}    Get From List    ${SUBENTITYLIST}    ${Index}
    \    Go to Dashboard and Click Source API Name    ${RESPONSE_MECHANISM_SOURCENAME}    ${RESPONSE_MECHANISM_INSTANCE}
    \    ${REQUESTID_VALUE}    Run Keyword If    '${SubEntity}'=='EUR'    Set Variable    ${REQUESTID_VALUE}_0
         ...    ELSE    Get Substring    ${REQUESTID_VALUE}    0    -2
    \    Log     RequestID is ${REQUESTID_VALUE}
    \    ${ResultsRowList}    Filter by Reference Header and Save Message TextArea for Specified File and Return Results Row List Value    ${DESTINATION}    ${DESTINATION_BR}    ${REQUESTID_VALUE}    ${sOutputFilePath}${sResponseMechanism}
        ...    ${JSON}    ${RESULTSTABLE_STATUS}    sSubEntity=${SubEntity}    sRequestId=${REQUESTID_VALUE}
    \    Validate Response Mechanism    ${sOutputFilePath}${sResponseMechanism}    ${REQUESTID_VALUE}    ${POSTMethod}    ${BASEINTERESTRATE_APINAME}    ${OPEARATIONSTATUS_SUCCESS}    ${SubEntity}
    
    Logout to MCH UI and Close Browser
    
    


# Validate FFC for TL Base Rate Success
    # [Documentation]    This keyword is used to validate OpenAPI, Distributor and CustomCBAInterface in MCH FFC UI.
    # [Arguments]    ${sInputFilePath}    ${sInputFileName}    ${sInputXML}    ${sOutputFilePath}    ${sOutputFileName}    ${sOutputXML}    ${sResponse}    ${sResponseMechanism}
    
    # Login to MCH UI
    
    # ###Base Splitter###
    # Wait Until Element Is Visible    ${FFC_Dashboard}    30s
    # ${aHeaderRefNameList}    Create List    ${REQUESTS_ID}
    # ${aExpectedRefList}    Create List    ${GSFILENAME_WITHTIMESTAMP}   
    # Go to Dashboard and Click Source API Name    ${TL_BASE_ACK_MESSAGE_SOURCENAME}    sOutputType=${TLSUCCESS_OUTPUT_TYPE}
    # ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    # ${Results_Row_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Row}
    # ${RequestID_UI}    Get Results Table Column Value by Header Title and Return    ${Results_Row_Count}    ${REQUESTS_ID}
    # ${REQUESTID_VALUE}    Split Request ID From Splitter Queue for TL and Return Final Request ID    ${RequestID_UI}    |
    
    # ###OpenAPI###
    # Go to Dashboard and Click Source API Name    ${BASE_SOURCENAME}    ${OPEAPI_INSTANCE_TL}
    # ${ResultsRowList}    Filter by Reference Header and Save Message TextArea and Return Results Row List Value    ${X_REQUEST_ID}    ${REQUESTID_VALUE}    ${sOutputFilePath}${sOutputFileName}    
    # ...    ${JSON}    ${RESULTSTABLE_STATUS}    ${CONTENT_TYPE}    ${HTTP_OPERATION}
    # Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${MESSAGESTATUS_SUCCESSFUL}    ${CONTENT_TYPE_VALUE}    ${POSTMethod}
    # Compare Multiple Input and Output JSON for Base Rate    ${sInputFilePath}    ${sInputFileName}  
      
    # ###CustomCBAPush###
    # Go to Dashboard and Click Source API Name    ${CBAPUSH_SOURCENAME}    ${CBAPUSH_INSTANCE}
    # ${aHeaderRefNameList}    Create List    ${JMS_CORRELATION_ID}
    # ${aExpectedRefList}    Create List    ${REQUESTID_VALUE}
    # ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    # ${Results_Row_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Row}
    # ${Response_UI}    Get Results Table Column Value by Header Title and Return    ${Results_Row_Count}    ${JMS_PAYLOAD}
    # Create File    ${datasetpath}${sOutputFilePath}${sResponse}.${JSON}    ${Response_UI}
    # Validate Response from CBA Push Queue    ${sOutputFilePath}${sResponse}    ${REQUESTID_VALUE}    ${POSTMethod}    ${BASEINTERESTRATE_APINAME}    ${OPEARATIONSTATUS_SUCCESS}
    
    # ###Distributor###
    # Go to Dashboard and Click Source API Name    ${TEXTJMS_SOURCENAME}    ${TEXTJMS_INSTANCE}
    # ${aHeaderRefNameList}    Create List    ${HEADER_CORRELATION_ID}    ${RESULTSTABLE_STATUS}
    # ${aExpectedRefList}    Create List    ${REQUESTID_VALUE}    ${SENT}
    # ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    # ${ResultsRowList}    Save Message TextArea and Return Results Row List Value    ${ColumnIndex}    ${sOutputFilePath}${sOutputXML}    ${XML}    ${ROUTEROPERATION}    ${HEADER_CATEGORY}    ${HEADER_OPERATION}    
    # Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${BASE_ROUTEROPTION}    ${BASE_CATEGORY}    ${POSTMethod}
    # Compare Expected and Actual TextJMS for Base Rate TL    ${sInputFilePath}${sInputXML}    ${sOutputFilePath}${sOutputXML}
    
    # ###Response Mechanism###
    # Go to Dashboard and Click Source API Name    ${RESPONSE_MECHANISM_SOURCENAME}    ${RESPONSE_MECHANISM_INSTANCE}
     # ${ResultsRowList}    Filter by Reference Header and Save Message TextArea for Specified File and Return Results Row List Value    ${DESTINATION}    ${DESTINATION_BR}    ${REQUESTID_VALUE}    ${sOutputFilePath}${sResponseMechanism}
    # ...    ${JSON}    ${RESULTSTABLE_STATUS}
    # Validate Response Mechanism    ${sOutputFilePath}${sResponseMechanism}    ${REQUESTID_VALUE}    ${POSTMethod}    ${BASEINTERESTRATE_APINAME}    ${OPEARATIONSTATUS_SUCCESS}
    
    # Logout to MCH UI and Close Browser