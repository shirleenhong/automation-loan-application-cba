*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Validate FFC for TL Calendar Success
    [Documentation]    This keyword is used to validate Calendar Splitter, OpenAPI, Distributor, CustomCBAPush and Response Mechanism in MCH FFC UI.
    ...    @author: clanding    15JUL2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sInputFileName}    ${sInputXML}    ${sOutputFilePath}    ${sOutputFileName}    ${sOutputXML}    ${sResponse}    ${sResponseMechanism}
    
    Login to MCH UI
    
    ###Calendar Splitter###
    Wait Until Element Is Visible    ${FFC_Dashboard}    30s
    ${aHeaderRefNameList}    Create List    ${REQUESTS_ID}
    ${aExpectedRefList}    Create List    ${FILE1_ARCHIVE_NAME}
    Go to Dashboard and Click Source API Name    ${TL_CAL_ACK_MESSAGE_SOURCENAME}    ${CUSTOM_INTERFACE_INSTANCE}
    ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    ${Results_Row_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Row}
    ${RequestID_UI}    Get Results Table Column Value by Header Title and Return    ${Results_Row_Count}    ${REQUESTS_ID}
    ${REQUESTID_VALUE}    Split Request ID From Splitter Queue for TL and Return Final Request ID    ${RequestID_UI}    |
    
    ###OpenAPI###
    Go to Dashboard and Click Source API Name    ${CAL_SOURCENAME}    ${OPEAPI_INSTANCE_TL}
    ${ResultsRowList}    Filter by Reference Header and Save Message TextArea and Return Results Row List Value    ${X_REQUEST_ID}    ${REQUESTID_VALUE}    ${sOutputFilePath}${sOutputFileName}    
    ...    ${JSON}    ${RESULTSTABLE_STATUS}    ${CONTENT_TYPE}    ${HTTP_OPERATION}
    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${MESSAGESTATUS_SUCCESSFUL}    ${CONTENT_TYPE_VALUE}    ${PUTMethod}
    Run Keyword And Continue On Failure    Compare Multiple Input and Output JSON for TL Calendar    ${sInputFilePath}    ${sInputFileName}
    
    ###CustomCBAPush###
    Go to Dashboard and Click Source API Name    ${CBAPUSH_SOURCENAME}    ${CBAPUSH_INSTANCE}
    ${aHeaderRefNameList}    Create List    ${JMS_CORRELATION_ID}
    ${aExpectedRefList}    Create List    ${REQUESTID_VALUE}
    ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    ${Results_Row_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Row}
    ${Response_UI}    Get Results Table Column Value by Header Title and Return    ${Results_Row_Count}    ${JMS_PAYLOAD}
    Create File    ${datasetpath}${sOutputFilePath}${sResponse}.${JSON}    ${Response_UI}
    
    ###Distributor###
    Go to Dashboard and Click Source API Name    ${TEXTJMS_SOURCENAME}    ${TEXTJMS_INSTANCE}
    ${aHeaderRefNameList}    Create List    ${HEADER_CORRELATION_ID}    ${RESULTSTABLE_STATUS}
    ${aExpectedRefList}    Create List    ${REQUESTID_VALUE}    ${SENT}
    ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    ${ResultsRowList}    Save Message TextArea and Return Results Row List Value    ${ColumnIndex}    ${sOutputFilePath}${sOutputXML}    ${XML}    ${HEADER_CATEGORY}    ${HEADER_OPERATION}    
    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${CAL_CATEGORY}    ${PUTMethod}
    Run Keyword And Continue On Failure    Compare Expected and Actual TextJMS for Calendar TL    ${sInputFilePath}${sInputXML}    ${sOutputFilePath}${sOutputXML}
    
    ###Response Mechanism###
    Go to Dashboard and Click Source API Name    ${RESPONSE_MECHANISM_SOURCENAME}    ${RESPONSE_MECHANISM_INSTANCE}
    ${ResultsRowList}    Filter by Reference Header and Save Message TextArea for Specified File and Return Results Row List Value    ${DESTINATION}    ${DESTINATION_CAL}    ${REQUESTID_VALUE}    ${sOutputFilePath}${sResponseMechanism}
    ...    ${JSON}    ${RESULTSTABLE_STATUS}
    Run Keyword And Continue On Failure    Validate Response Mechanism    ${sOutputFilePath}${sResponseMechanism}    ${REQUESTID_VALUE}    ${PUTMethod}    ${CALENDAR_APINAME}    ${OPEARATIONSTATUS_SUCCESS}
    
    Logout to MCH UI and Close Browser

Validate FFC with Empty Payload for TL Calendar
    [Documentation]    This keyword is used to validate CustomCBAPush for an 'Empty Payload' description response in MCH FFC UI.
    ...    @author: clanding    05AUG2019    - initial create
    ...    @update: jloretiz    26AUG2019    - adds validation on the payload content
    [Arguments]    ${sInputFilePath}    ${sFileName}    ${sOutputFilePath}    ${sResponse}
    
    Login to MCH UI
    
    ###Manually split file name###
    Log    ${FILE1_ARCHIVE_NAME}
    ${Request_ID}    Remove String    ${FILE1_ARCHIVE_NAME}    Holidays_    .${XLS}
    
    ###CustomCBAPush###
    Go to Dashboard and Click Source API Name    ${CBAPUSH_SOURCENAME}    ${CBAPUSH_INSTANCE}
    ${aHeaderRefNameList}    Create List    ${JMS_CORRELATION_ID}
    ${aExpectedRefList}    Create List    ${Request_ID}
    ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    ${Results_Row_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Row}
    ${Response_UI}    Get Results Table Column Value by Header Title and Return    ${Results_Row_Count}    ${JMS_PAYLOAD}
    Create File    ${datasetpath}${sOutputFilePath}${sResponse}.${JSON}    ${Response_UI}
    ${Json_Object}    Load JSON From File    ${datasetpath}${sOutputFilePath}${sResponse}.${JSON}
    ${Json_Object_Del}    Delete Object From Json    ${Json_Object}    $..responses..responseDetails..dateTime
    Log    ${Json_Object_Del}
    ${Converted_Json}    Evaluate    json.dumps(${Json_Object_Del})    json
    Create File    ${datasetpath}${sOutputFilePath}${sResponse}.${JSON}    ${Converted_Json}
    
    ###Compare JSON Value###
    ${JSON_Value}    Load JSON From File    ${datasetpath}${sOutputFilePath}${sResponse}.${JSON}
    ${RespDescriptionList}    Get Value From Json    ${JSON_Value}    $..responseDescription
    ${Response_Description}    Get From List    ${RespDescriptionList}    0
    Should Be Equal    ${Response_Description}    ${NO_CALENDAR_CHANGE}
    
    ${RespStatusList}    Get Value From Json    ${JSON_Value}    $..responseStatus
    ${Response_Status}    Get From List    ${RespStatusList}    0
    Should Be Equal    ${Response_Status}    ${OPEARATIONSTATUS_SUCCESS} 
    
    ${MessageIdList}    Get Value From Json    ${JSON_Value}    $..messageId
    ${Message_ID}    Get From List    ${MessageIdList}    0
    Should Be Equal    ${Message_ID}    ${EMPTY_PAYLOAD} 
    
    Logout to MCH UI and Close Browser
    

Validate FFC for CustomCBAPush Failure Response for TL Calendar
    [Documentation]    This keyword is used to validate CustomCBAPush for a failure response in MCH FFC UI.
    ...    @author: dahijara    08JAN2020    - initial create
    [Arguments]    ${sInputFilePath}    ${sFileName}    ${sOutputFilePath}    ${sResponse}    ${sExpectedResponseDesc}    ${sExpectedMessageID}    ${bInvalidFileName}=False
    
    Login to MCH UI
    
    ###Manually split file name###
    Log    ${FILE1_ARCHIVE_NAME}
    ${Request_ID}    Remove String    ${FILE1_ARCHIVE_NAME}    Holidays_    .${XLS}
    ${TimeStamp}    Get Substring    ${Request_ID}    -13
    ${Request_ID}    Run Keyword If    ${bInvalidFileName}==${True}    Set Variable    ${TimeStamp}
    ...    ELSE    Set Variable    ${Request_ID}
    
    ###CustomCBAPush###
    Go to Dashboard and Click Source API Name    ${CBAPUSH_SOURCENAME}    ${CBAPUSH_INSTANCE}
    ${aHeaderRefNameList}    Create List    ${JMS_CORRELATION_ID}
    ${aExpectedRefList}    Create List    ${Request_ID}
    ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    ${Results_Row_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Row}
    ${Response_UI}    Get Results Table Column Value by Header Title and Return    ${Results_Row_Count}    ${JMS_PAYLOAD}
    Create File    ${datasetpath}${sOutputFilePath}${sResponse}.${JSON}    ${Response_UI}
    ${Json_Object}    Load JSON From File    ${datasetpath}${sOutputFilePath}${sResponse}.${JSON}
    ${Json_Object_Del}    Delete Object From Json    ${Json_Object}    $..responses..responseDetails..dateTime
    Log    ${Json_Object_Del}
    ${Converted_Json}    Evaluate    json.dumps(${Json_Object_Del})    json
    Create File    ${datasetpath}${sOutputFilePath}${sResponse}.${JSON}    ${Converted_Json}
    
    ###Compare JSON Value###
    ${JSON_Value}    Load JSON From File    ${datasetpath}${sOutputFilePath}${sResponse}.${JSON}
    ${RespDescriptionList}    Get Value From Json    ${JSON_Value}    $..responseDescription
    ${Response_Description}    Get From List    ${RespDescriptionList}    0
    ${Response_Description}    Strip String    ${Response_Description}
    ${sExpectedResponseDesc}    Strip String    ${sExpectedResponseDesc}
    Should Be Equal    ${Response_Description}    ${sExpectedResponseDesc}
    
    ${RespStatusList}    Get Value From Json    ${JSON_Value}    $..responseStatus
    ${Response_Status}    Get From List    ${RespStatusList}    0
    Should Be Equal    ${Response_Status}    ${MESSAGESTATUS_FAILURE} 
    
    ${MessageIdList}    Get Value From Json    ${JSON_Value}    $..messageId
    ${Message_ID}    Get From List    ${MessageIdList}    0
    Should Be Equal    ${Message_ID}    ${sExpectedMessageID} 
    
    Logout to MCH UI and Close Browser

Validate No Result in FFC for CustomCBAPush for TL Calendar
    [Documentation]    This keyword is used to validate that response does not exists in CustomCBAPush in MCH FFC UI.
    ...    @author: dahijara    3FEB2020    - initial create
    
    Login to MCH UI
    
    ###Manually split file name###
    Log    ${FILE1_ARCHIVE_NAME}
    ${Request_ID}    Remove String    ${FILE1_ARCHIVE_NAME}    Holidays_    .${XLS}
    ${Request_ID}    Get Substring    ${Request_ID}    0    14
    
    ###CustomCBAPush###
    Go to Dashboard and Click Source API Name    ${CBAPUSH_SOURCENAME}    ${CBAPUSH_INSTANCE}
    
    Filter by Reference Header and Value and Expect No Row in Results Table    ${JMS_CORRELATION_ID}    ${Request_ID}

    Logout to MCH UI and Close Browser
    
Validate Response Mechanism for Failure Response on TL Calendar
    [Documentation]    This keyword is used to validate response mechanism for a failure response in MCH FFC UI.
    ...    @author: jdelacru    26OCT2020    - initial create
    [Arguments]    ${sOutputFilePath}    ${sResponseMechanism}
    
    Login to MCH UI
    
    ###Calendar Splitter###
    Wait Until Element Is Visible    ${FFC_Dashboard}    30s
    ${aHeaderRefNameList}    Create List    ${REQUESTS_ID}
    ${aExpectedRefList}    Create List    ${FILE1_ARCHIVE_NAME}
    Go to Dashboard and Click Source API Name    ${TL_CAL_ACK_MESSAGE_SOURCENAME}    ${CUSTOM_INTERFACE_INSTANCE}
    ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    ${Results_Row_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Row}
    ${RequestID_UI}    Get Results Table Column Value by Header Title and Return    ${Results_Row_Count}    ${REQUESTS_ID}
    ${REQUESTID_VALUE}    Split Request ID From Splitter Queue for TL and Return Final Request ID    ${RequestID_UI}    |
    
    ###Response Mechanism###
    Go to Dashboard and Click Source API Name    ${RESPONSE_MECHANISM_SOURCENAME}    ${RESPONSE_MECHANISM_INSTANCE}
    ${ResultsRowList}    Filter by Reference Header and Save Message TextArea for Specified File and Return Results Row List Value    ${DESTINATION}    ${DESTINATION_CAL}    ${REQUESTID_VALUE}    ${sOutputFilePath}${sResponseMechanism}
    ...    ${JSON}    ${RESULTSTABLE_STATUS}
    Run Keyword And Continue On Failure    Validate Response Mechanism    ${sOutputFilePath}${sResponseMechanism}    ${REQUESTID_VALUE}    ${PUTMethod}    ${CALENDAR_APINAME}    ${MESSAGESTATUS_FAILURE}
    
    Logout to MCH UI and Close Browser