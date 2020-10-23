*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Validate FFC for Multiple LOB for Success
    [Documentation]    This keyword is used to get LOB value and validate FFC according to application.
    ...    @author: clanding    05APR2019    - initial create
    ...    @update: clanding    25APR2019    - removing Post and Put handling. Post and Put are already handled inside the keywords.
    ...    @update: clanding    07MAY2019    - added handling when ${JMS_CORRELATION_ID} is empty, no queue are displayed in OpenAPI, moved common keywords outside for loop
    ...    @update: cfrancis    22JUL2020    - added condition for Validate AD Success Response in FFC for User API based on LOB_Count
    [Arguments]    ${sLOB_From_Excel}    ${sInputFilePath}    ${sInputAPIResonse}    ${sOutputFilePath}    ${sOutputAPIResponse}
    ...    ${sHTTPMethod}    ${sLoginID}    ${sOSUserID}    ${sExpected_wsLIQUserDestination}    ${sActual_wsLIQUserDestination}
    ...    ${sExpected_wsFinalLIQDestination}    ${sActual_wsFinalLIQDestination}
    ${LOB_List}    Split String    ${sLOB_From_Excel}    ,
    ${LOB_Count}    Get Length    ${LOB_List}
    
    Set Global Variable    ${LOB_List}    ${LOB_List}
    
    Login to MCH UI
    Run Keyword And Continue On Failure    Validate OpenAPI for User API    ${sInputFilePath}    ${sInputAPIResonse}    ${sOutputFilePath}    ${sOutputAPIResponse}    ${sHTTPMethod}   ALL   sLoginID=${sLoginID}
    Run Keyword If    '${JMS_CORRELATION_ID}'!='' and ${LOB_Count}==1    Run Keyword And Continue On Failure    Validate AD Success Response in FFC for User API    ${sOutputFilePath}    ${sHTTPMethod}    ${sOSUserID}
    Run Keyword If    '${JMS_CORRELATION_ID}'!='' and ${LOB_Count}>1    Run Keyword And Continue On Failure    Validate AD Success Response in FFC for User API    ${sOutputFilePath}    PUT    ${sOSUserID}
    Run Keyword If    '${JMS_CORRELATION_ID}'!=''    Run Keyword And Continue On Failure    Validate SSO Success Response in FFC for User API    ${sOutputFilePath}    ${sHTTPMethod}    ${sLoginID}
    :FOR    ${Index}    IN RANGE    ${LOB_Count}
    \    Exit For Loop If    '${Index}'=='${LOB_Count}'
    \    ${LOB_Value}    Get From List    ${LOB_List}    ${Index}
    \    Run Keyword If    '${LOB_Value}'=='PARTY' and '${JMS_CORRELATION_ID}'!=''    Run Keyword And Continue On Failure    Validate PARTY Success Response in FFC for User API    ${sOutputFilePath}    ${sHTTPMethod}    ${sLoginID}    
    \    Run Keyword If    '${LOB_Value}'=='COMRLENDING' and '${JMS_CORRELATION_ID}'!=''    Run Keyword And Continue On Failure    Validate LIQ Success Response in FFC for User API    ${sInputFilePath}    ${sOutputFilePath}    
         ...    ${sHTTPMethod}    ${sExpected_wsLIQUserDestination}    ${sActual_wsLIQUserDestination}    ${sExpected_wsFinalLIQDestination}    ${sActual_wsFinalLIQDestination}    
    \    Run Keyword If    '${LOB_Value}'=='COREBANKING' and '${JMS_CORRELATION_ID}'!=''    Run Keyword And Continue On Failure    Validate ESSENCE Success Response in FFC for User API    ${sOutputFilePath}    ${sHTTPMethod}    ${sLoginID}
    Logout to MCH UI and Close Browser
    
Validate FFC for Multiple LOB for Error
    [Documentation]    This keyword is used to get LOB value and validate FFC error message according to application.
    ...    @author: cfrancis    14AUG2020    - initial create
    [Arguments]    ${sLOB_From_Excel}    ${sInputFilePath}    ${sInputAPIResonse}    ${sOutputFilePath}    ${sOutputAPIResponse}
    ...    ${sHTTPMethod}    ${sLoginID}    ${sOSUserID}    ${sExpected_wsLIQUserDestination}    ${sActual_wsLIQUserDestination}
    ...    ${sExpected_wsFinalLIQDestination}    ${sActual_wsFinalLIQDestination}    ${sErrorMessage}    ${sStatus}
    ${LOB_List}    Split String    ${sLOB_From_Excel}    ,
    ${LOB_Count}    Get Length    ${LOB_List}
    
    Set Global Variable    ${LOB_List}    ${LOB_List}
    
    Login to MCH UI
    Run Keyword And Continue On Failure    Validate OpenAPI for User API    ${sInputFilePath}    ${sInputAPIResonse}    ${sOutputFilePath}    ${sOutputAPIResponse}    ${sHTTPMethod}   ALL   sLoginID=${sLoginID}
    Run Keyword If    '${JMS_CORRELATION_ID}'!='' and ${LOB_Count}==1    Run Keyword And Continue On Failure    Validate AD Success Response in FFC for User API    ${sOutputFilePath}    ${sHTTPMethod}    ${sOSUserID}
    Run Keyword If    '${JMS_CORRELATION_ID}'!='' and ${LOB_Count}>1    Run Keyword And Continue On Failure    Validate AD Success Response in FFC for User API    ${sOutputFilePath}    PUT    ${sOSUserID}
    Run Keyword If    '${JMS_CORRELATION_ID}'!=''    Run Keyword And Continue On Failure    Validate SSO Success Response in FFC for User API    ${sOutputFilePath}    ${sHTTPMethod}    ${sLoginID}
    :FOR    ${Index}    IN RANGE    ${LOB_Count}
    \    Exit For Loop If    '${Index}'=='${LOB_Count}'
    \    ${LOB_Value}    Get From List    ${LOB_List}    ${Index}
    \    Run Keyword If    '${LOB_Value}'=='PARTY' and '${JMS_CORRELATION_ID}'!=''    Run Keyword And Continue On Failure    Validate PARTY Error Response in FFC for User API    ${sOutputFilePath}    ${sHTTPMethod}    ${sLoginID}    ${sErrorMessage}    ${sStatus}
    \    Run Keyword If    '${LOB_Value}'=='COMRLENDING' and '${JMS_CORRELATION_ID}'!=''    Run Keyword And Continue On Failure    Validate LIQ Error Response in FFC for Failed User API    ${sOutputFilePath}        ${sHTTPMethod}    ${sLoginID}    ${sErrorMessage}    ${sStatus}   
    \    Run Keyword If    '${LOB_Value}'=='COREBANKING' and '${JMS_CORRELATION_ID}'!=''    Run Keyword And Continue On Failure    Validate ESSENCE Error Response in FFC for User API    ${sOutputFilePath}    ${sHTTPMethod}    ${sLoginID}    ${sErrorMessage}    ${sStatus}
    Logout to MCH UI and Close Browser
    
Validate OpenAPI for User API
    [Documentation]    This keyword is used to validate User OpenAPI by searching User API Sourcename and filtering by authentication code
    ...    and getting response API and comparing to request API.
    ...    @update: jdelacru    06NOV2019    - Modify the keyword to handle API Source validation when SSO is either enabled or not
    ...                                      - Modified filtering of instances to get the API Source ID even without using Token
    ...    @update: jdelacru    22NOV2019    - added InputJson as optional argument to validate OpenAPI for delete method 
    ...    @update: jloretiz    29JAN2020    - added LoginId as optional argument to validate OpenAPI for delete method 
    [Arguments]    ${sInputFilePath}    ${sInputAPIResonse}    ${sOutputFilePath}    ${sOutputAPIResponse}    ${sHTTPMethod}    ${sLineOfBusiness}=None    ${InputJson}=None    ${sLoginId}=None
    
    ###OpenAPI###
    Wait Until Element Is Visible    ${FFC_Dashboard}    30s
    Go to Dashboard and Click Source API Name    ${USER_SOURCENAME}    ${OPEAPI_INSTANCE}
    
    Run Keyword If    '${SSO_ENABLED}' == 'YES'    Validate OpenAPI with Token    ${sInputFilePath}    ${sInputAPIResonse}    ${sOutputFilePath}    ${sOutputAPIResponse}    ${sHTTPMethod}    ${sLineOfBusiness}
    ...    ELSE IF    '${SSO_ENABLED}' == 'NO'    Validate OpenAPI without Token    ${sInputFilePath}    ${sInputAPIResonse}    ${sHTTPMethod}    ${InputJson}    ${sLineOfBusiness}    ${sLoginId}

Validate FFC for GET API Success
    [Documentation]    This keyword is used to validate OPEN API for GET and FFC success response.
    ...    @author: jloretiz    29AUG2019    - initial create
    ...    @update: amansuet    06SEP2019    - added condition for Get all user
    [Arguments]    ${sLOB}    ${sInputFilePath}    ${sInputAPIResponse}    ${sInputFFCResponse}    ${sOutputFilePath}    ${sOutputFFCResponse}
    ...    ${sHTTPMethod}    ${sLoginId}=None
    
    Login to MCH UI
    Run Keyword And Continue On Failure    Validate OpenAPI for User GET API    ${sInputFilePath}    ${sInputFFCResponse}    ${sOutputFilePath}    ${sOutputFFCResponse}    ${sHTTPMethod}    ${sLOB}    ${sLoginId}
    Run Keyword If    '${sLoginId}'=='None'    Run Keyword And Continue On Failure    Validate GET Request Success Response in FFC for GET ALL User API    ${sInputFilePath}    ${sInputAPIResponse}    ${sOutputFilePath}    ${sHTTPMethod}    ${sLOB}
    ...    ELSE    Run Keyword And Continue On Failure    Validate GET Request Success Response in FFC for GET User API    ${sInputFilePath}    ${sInputAPIResponse}    ${sOutputFilePath}    ${sHTTPMethod}    ${sLoginId}    ${sLOB}
    Logout to MCH UI and Close Browser

Validate FFC for GET API Deleted User
    [Documentation]    This keyword is used to validate OPEN API for GET and FFC delete user response.
    ...    @author: jloretiz    11SEP2019    - initial create
    [Arguments]    ${sLOB}    ${sInputFilePath}    ${sInputAPIResponse}    ${sInputFFCResponse}    ${sOutputFilePath}    ${sOutputFFCResponse}
    ...    ${sHTTPMethod}    ${sLoginId}
    
    Login to MCH UI
    Run Keyword And Continue On Failure    Validate OpenAPI for User GET API    ${sInputFilePath}    ${sInputFFCResponse}    ${sOutputFilePath}    ${sOutputFFCResponse}    ${sHTTPMethod}    ${sLOB}    ${sLoginId}
    Run Keyword And Continue On Failure    Validate GET Request Success Response in FFC for GET User API    ${sInputFilePath}    ${sInputAPIResponse}    ${sOutputFilePath}    ${sHTTPMethod}    ${sLoginId}    ${sLOB}    ${TRUE}
    Logout to MCH UI and Close Browser

Validate OpenAPI for User GET API
    [Documentation]    This keyword is used to validate User OpenAPI by searching User API Sourcename and filtering by authentication code
    ...    and getting response API and comparing to request API.
    ...    @author: rtarayao    26NOV2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sInputAPIResponse}    ${sOutputFilePath}    ${sOutputAPIResponse}    ${sHTTPMethod}    ${sLOB}    ${sLoginId}=None

    ###OpenAPI###
   Run Keyword If    '${SSO_ENABLED.upper()}'=='YES'    Validate OpenAPI for User GET API with Token    ${sInputFilePath}    ${sInputAPIResponse}    ${sOutputFilePath}    ${sOutputAPIResponse}    ${sHTTPMethod}    ${sLOB}    ${sLoginId}
   Run Keyword If    '${SSO_ENABLED.upper()}'=='NO'    Validate OpenAPI for User GET API without Token    ${sInputFilePath}    ${sInputAPIResponse}    ${sOutputFilePath}    ${sOutputAPIResponse}    ${sHTTPMethod}    ${sLOB}    ${sLoginId}

Validate GET Request Success Response in FFC for GET ALL User API
    [Documentation]    Used to validate FFC Response in GETTextJMS for GET Request ALL User API.
    ...    @author: amansuet    04SEP2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sInputAPIResponse}    ${sOutputFilePath}    ${sHTTPMethod}    ${sLOB}

    ${Queuename}    Run Keyword If    '${sLOB}'=='${COMRLENDING}'    Set Variable     ${QNAME_PARSELIQGETUSERALL}
    ...    ELSE IF    '${sLOB}'=='${COREBANKING}'    Set Variable    ${QNAME_PARSEESSENCEGETUSERALL}
    ...    ELSE IF    '${sLOB}'=='${PARTY}'          Set Variable    ${QNAME_PARSEPARTYGETUSERALL}

    ${RouterOption}    Run Keyword If    '${sLOB}'=='${COMRLENDING}'    Set Variable     ${ROUTEROPTION_GETLIQUSERALL} 
    ...    ELSE IF    '${sLOB}'=='${COREBANKING}'    Set Variable    ${ROUTEROPTION_GETESSENCEUSERALL}
    ...    ELSE IF    '${sLOB}'=='${PARTY}'          Set Variable    ${ROUTEROPTION_GETPARTYUSERALL}
    
    ${Category}    Run Keyword If    '${sLOB}'=='${COMRLENDING}'    Set Variable     ${CATEGORY_LIQUSER}
    ...    ELSE IF    '${sLOB}'=='${COREBANKING}'    Set Variable    ${CATEGORY_ESSENCEUSER}
    ...    ELSE IF    '${sLOB}'=='${PARTY}'          Set Variable    ${CATEGORY_PARTYUSER} 
    
    ###GETTextJMS###
    Click Element    ${RefreshButton}
    Wait Until Element Is Visible    ${Summary_Table}    30s
    Go to Dashboard and Click Source API Name    ${GETTEXTJMS_SOURCENAME}    ${GETTEXTJMS_INSTANCE}
    
    ${aHeaderRefNameList}    Create List    ${JMS_CORRELATION_ID}    ${RESULTSTABLE_STATUS}    ${HEADER_QUEUENAME}
    ${aExpectedRefList}    Create List    ${ID}    ${SUCCESSFUL}    ${Queuename}
    ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    ${ResultsRowList}    Save Message TextArea and Return Results Row List Value    ${ColumnIndex}    ${sOutputFilePath}${Queuename}    ${JSON}    ${HEADER_ROUTEROPERATION}
    ...    ${HEADER_CATEGORY}    ${HEADER_OPERATION}
    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${RouterOption}    ${Category}    ${sHTTPMethod}
    Compare Expected FFC Response to Actual Value from Results Table for GET ALL User API    ${sOutputFilePath}${Queuename}    ${JSON}    ${sInputFilePath}    ${sInputAPIResponse}

Validate GET Request Success Response in FFC for GET User API
    [Documentation]    Used to validate GETTextJMS for GET Request User API.
    ...    @author: jloretiz    29AUG2019    - initial create
    ...    @update: amansuet    02SEP2019    - updated the naming of global variable with correct value. 
    [Arguments]    ${sInputFilePath}    ${sInputAPIResonse}    ${sOutputFilePath}    ${sHTTPMethod}    ${sLoginID}    ${sLOB}    ${sIsDelete}=False
        
    ${Queuename}    Run Keyword If    '${sLOB}'=='${COMRLENDING}'    Set Variable     ${QNAME_PARSELIQGETUSER}
    ...    ELSE IF    '${sLOB}'=='${COREBANKING}'    Set Variable    ${QNAME_PARSEESSENCEGETUSER}
    ...    ELSE IF    '${sLOB}'=='${PARTY}'          Set Variable    ${QNAME_PARSEPARTYGETUSER}

    ${RouterOption}    Run Keyword If    '${sLOB}'=='${COMRLENDING}'    Set Variable     ${ROUTEROPTION_GETLIQUSER} 
    ...    ELSE IF    '${sLOB}'=='${COREBANKING}'    Set Variable    ${ROUTEROPTION_GETESSENCEUSER}
    ...    ELSE IF    '${sLOB}'=='${PARTY}'          Set Variable    ${ROUTEROPTION_GETPARTYUSER}
    
    ${Category}    Run Keyword If    '${sLOB}'=='${COMRLENDING}'    Set Variable     ${CATEGORY_LIQUSER}
    ...    ELSE IF    '${sLOB}'=='${COREBANKING}'    Set Variable    ${CATEGORY_ESSENCEUSER}
    ...    ELSE IF    '${sLOB}'=='${PARTY}'          Set Variable    ${CATEGORY_PARTYUSER} 
    
    ###GETTextJMS###
    Click Element    ${RefreshButton}
    Wait Until Element Is Visible    ${Summary_Table}    30s
    Go to Dashboard and Click Source API Name    ${GETTEXTJMS_SOURCENAME}    ${GETTEXTJMS_INSTANCE}
    
    ${aHeaderRefNameList}    Create List    ${JMS_CORRELATION_ID}    ${RESULTSTABLE_STATUS}    ${HEADER_QUEUENAME}
    ${aExpectedRefList}    Run Keyword If    '${sIsDelete}'=='${FALSE}'    Create List    ${ID}    ${SUCCESSFUL}    ${Queuename}
    ...    ELSE IF    '${sIsDelete}'=='${TRUE}' and '${sLOB}'!='${COMRLENDING}'    Create List    ${ID}    ${FAILED}    ${Queuename}
    ...    ELSE IF    '${sIsDelete}'=='${TRUE}' and '${sLOB}'=='${COMRLENDING}'    Create List    ${ID}    ${SUCCESSFUL}    ${Queuename}
    ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    ${ResultsRowList}    Save Message TextArea and Return Results Row List Value    ${ColumnIndex}    ${sOutputFilePath}${Queuename}    ${JSON}    ${HEADER_ROUTEROPERATION}    
    ...    ${HEADER_CATEGORY}    ${HEADER_OPERATION}
    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${RouterOption}    ${Category}    ${sHTTPMethod}
    
    Run Keyword If    ('${sLOB}'=='${COREBANKING}' or '${sLOB}'=='${PARTY}') and '${sIsDelete}'=='${FALSE}'    Compare Expected FFC Response to Actual Value from Results Table    ${sLoginID}    ${sOutputFilePath}${Queuename}    ${JSON}    ${sInputFilePath}    ${sInputAPIResonse}
    ...    ELSE IF    ('${sLOB}'=='${COREBANKING}' or '${sLOB}'=='${PARTY}') and '${sIsDelete}'=='${TRUE}'     Compare Expected FFC Response to Actual Value from Results Table for Deleted User    ${sLoginID}    ${sOutputFilePath}${Queuename}    ${JSON}
    ...    ELSE IF    '${sLOB}'=='${COMRLENDING}' and '${sIsDelete}'=='${FALSE}'    Compare Expected FFC Response to Actual Value from Results Table for LOANIQ    ${sLoginID}    ${sOutputFilePath}${Queuename}    ${JSON}    ${sInputFilePath}    ${sInputAPIResonse}
    ...    ELSE IF    '${sLOB}'=='${COMRLENDING}' and '${sIsDelete}'=='${TRUE}'    Compare Expected FFC Response to Actual Value from Results Table for Deleted User on LOANIQ    ${sLoginID}    ${sOutputFilePath}${Queuename}    ${JSON}

Validate LIQ Success Response in FFC for User API
    [Documentation]    This keyword is used to validate LIQ success response for User API by searching for TextJMS and filtering by ID from OpenAPI,
    ...    Status and Queuename and getting actual XML and comparing to input XML.
    ...    @author: clanding
    ...    @update: clanding    05APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...    @update: clanding    15MAY2019    - updated the validation of wsFinalLIQDestination due to added Header in XML
    ...    @update: dahijara    21AUG2019    - added http methods parameter for verifying security details keyword.
    [Arguments]    ${sInputFilePath}    ${sOutputFilePath}    ${sHTTPMethod}    ${sExpected_wsLIQUserDestination}    ${sActual_wsLIQUserDestination}
    ...    ${sExpected_wsFinalLIQDestination}    ${sActual_wsFinalLIQDestination}
    
    ###Distributor - wsLIQUserDestination###
    Click Element    ${RefreshButton}
    Wait Until Element Is Visible    ${Summary_Table}    30s
    Go to Dashboard and Click Source API Name    ${TEXTJMS_SOURCENAME}    ${TEXTJMS_INSTANCE}
    ${aHeaderRefNameList}    Create List    ${JMS_CORRELATION_ID}    ${RESULTSTABLE_STATUS}    ${HEADER_QUEUENAME}
    ###Added variable assignment handler for ID until GDE-4293 is resolved
    ${ID}    Get Substring    ${ID}    0    22
    ${aExpectedRefList}    Create List    ${ID}    ${SENT}    ${QNAME_WSLIQUSERDESTINATION}
    ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    ${ResultsRowList}    Save Message TextArea and Return Results Row List Value    ${ColumnIndex}    ${sOutputFilePath}${sActual_wsLIQUserDestination}    ${XML}    ${HEADER_ROUTEROPERATION}    
    ...    ${HEADER_CATEGORY}    ${HEADER_OPERATION}
    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${ROUTEROPTION_LIQUSER}    ${CATEGORY_LIQUSER}    ${sHTTPMethod}
    Compare Input and Output XML from Results Table    ${sInputFilePath}${sExpected_wsLIQUserDestination}    ${sOutputFilePath}${sActual_wsLIQUserDestination}    ${XML}
    
    ###Distributor - wsFinalLIQDestination###
    Click Element    ${RefreshButton}
    Wait Until Element Is Visible    ${Summary_Table}    30s
    Go to Dashboard and Click Source API Name    ${TEXTJMS_SOURCENAME}    ${TEXTJMS_INSTANCE}
    ${aHeaderRefNameList}    Create List    ${JMS_CORRELATION_ID}    ${RESULTSTABLE_STATUS}    ${HEADER_QUEUENAME}
    ${aExpectedRefList}    Create List    ${ID}    ${SENT}    ${QNAME_WSFINALLIQDESTINATION}
    ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    ${ResultsRowList}    Save Message TextArea and Return Results Row List Value    ${ColumnIndex}    ${sOutputFilePath}${sActual_wsFinalLIQDestination}    ${XML}    ${HEADER_ROUTEROPERATION}    
    ...    ${HEADER_CATEGORY}    ${HEADER_OPERATION}
    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${ROUTEROPTION_LIQUSERFLOWLATCH}    ${CATEGORY_LIQUSER}    ${sHTTPMethod}
    Verify Security Details in Output XML for User API    ${sInputFilePath}${sExpected_wsFinalLIQDestination}    ${sOutputFilePath}${sActual_wsFinalLIQDestination}    ${XML}    ${sHTTPMethod}

Validate LIQ Success Response in FFC for Delete User API
    [Documentation]    This keyword is used to validate LIQ success response for Delete User API by searching for TextJMS and filtering by ID from OpenAPI,
    ...    Status and Queuename and getting actual XML and comparing to input XML.
    ...    @author: amansuet    16AUG2019    - initial create 
    [Arguments]    ${sOutputFilePath}    ${sHTTPMethod}    ${sLoginID}
    
    ${Queuename}    Run Keyword If    '${sHTTPMethod}'=='${POSTMethod}'    Set Variable    ${QNAME_WSLIQUSERDESTINATION}
    ...    ELSE IF    '${sHTTPMethod}'=='${PUTMethod}'    Set Variable    ${QNAME_WSFINALLIQDESTINATION}
    ...    ELSE IF    '${sHTTPMethod}'=='${DeleteMethod}'    Set Variable    ${QNAME_WSFINALLIQDESTINATION}
    
    ${RouterOption}    Run Keyword If    '${sHTTPMethod}'=='${POSTMethod}'    Set Variable    ${ROUTEROPTION_LIQUSER}
    ...    ELSE IF    '${sHTTPMethod}'=='${PUTMethod}'    Set Variable    ${ROUTEROPTION_LIQUSER}
    ...    ELSE IF    '${sHTTPMethod}'=='${DeleteMethod}'    Set Variable    ${ROUTEROPTION_DELETELIQLOBUSER}
        
    ###Distributor - wsEssenceCreateUserDestinationQueue###
    Click Element    ${RefreshButton}
    Wait Until Element Is Visible    ${Summary_Table}    30s
    Go to Dashboard and Click Source API Name    ${TEXTJMS_SOURCENAME}    ${TEXTJMS_INSTANCE}
    ${aHeaderRefNameList}    Create List    ${JMS_CORRELATION_ID}    ${RESULTSTABLE_STATUS}    ${HEADER_QUEUENAME}
    ###Added variable assignment handler for ID until GDE-4293 is resolved
    ${ID}    Get Substring    ${ID}    0    22
    ${aExpectedRefList}    Create List    ${ID}    ${SENT}    ${Queuename}
    ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    ${ResultsRowList}    Save Message TextArea and Return Results Row List Value    ${ColumnIndex}    ${sOutputFilePath}${Queuename}    ${XML}    ${HEADER_ROUTEROPERATION}    
    ...    ${HEADER_CATEGORY}    ${HEADER_OPERATION}
    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${RouterOption}    ${CATEGORY_LIQUSER}    ${sHTTPMethod}
    Compare Partial Message to Actual Value from Results Table    ${sLoginID}    ${sOutputFilePath}${Queuename}    ${XML}

Validate LIQ Error Response in FFC for Failed User API
    [Documentation]    This keyword is used to validate LIQ error response for Delete User API by searching for TextJMS and filtering by ID from OpenAPI,
    ...    Status and Queuename and getting actual XML and comparing to input XML.
    ...    @author: cfrancis    13AUG2020    - initial create
    [Arguments]    ${sOutputFilePath}    ${sHTTPMethod}    ${sLoginID}    ${sErrorMessage}    ${sStatus}
    
    ${Queuename}    Run Keyword If    '${sHTTPMethod}'=='${POSTMethod}'    Set Variable    ${QNAME_WSLIQUSERDESTINATION}
    ...    ELSE IF    '${sHTTPMethod}'=='${PUTMethod}'    Set Variable    ${QNAME_WSFINALLIQDESTINATION}
    ...    ELSE IF    '${sHTTPMethod}'=='${DeleteMethod}'    Set Variable    ${QNAME_WSFINALLIQDESTINATION}
    
    ${RouterOption}    Run Keyword If    '${sHTTPMethod}'=='${POSTMethod}'    Set Variable    ${ROUTEROPTION_LIQUSER}
    ...    ELSE IF    '${sHTTPMethod}'=='${PUTMethod}'    Set Variable    ${ROUTEROPTION_LIQUSER}
    ...    ELSE IF    '${sHTTPMethod}'=='${DeleteMethod}'    Set Variable    ${ROUTEROPTION_DELETELIQLOBUSER}
            
    ###Added variable assignment handler for ID until GDE-4293 is resolved
    ${ID}    Get Substring    ${ID}    0    22
    ###Distributor - errorLogQueue###
    Click Element    ${RefreshButton}
    Wait Until Element Is Visible    ${Summary_Table}    30s
    Go to Dashboard and Click Source API Name    ${TEXTJMS_SOURCENAME}    ${TEXTJMS_INSTANCE}
    ${aHeaderRefNameList}    Create List    ${JMS_CORRELATION_ID}    ${RESULTSTABLE_STATUS}    ${HEADER_QUEUENAME}    ${DESTINATION}
    ${Destination}    Run Keyword If    '${API_RESPONSE.status_code}'=='201' or '${API_RESPONSE.status_code}'=='200'    Set Variable    ${DEST_DISTERROR}
    ...    ELSE IF    '${API_RESPONSE.status_code}'=='204'    Set Variable    ${DEST_WSFINALLIQDESTINATION}
    ${Router}    Run Keyword If    '${API_RESPONSE.status_code}'=='201' or '${API_RESPONSE.status_code}'=='200'    Set Variable    ${ROUTEROPTION_ADLOBFLOW}
    ...    ELSE IF    '${API_RESPONSE.status_code}'=='204'    Set Variable    ${ROUTEROPTION_LIQRESPONSE}
    ${aExpectedRefList}    Create List    ${ID}    ${sStatus}    ${QName_Error_Users}    ${Destination}
    ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    ${ResultsRowList}    Save Message TextArea and Return Results Row List Value    ${ColumnIndex}    ${sOutputFilePath}${Queuename}    ${XML}    ${HEADER_ROUTEROPERATION}    
    ...    ${HEADER_CATEGORY}    ${HEADER_OPERATION} 
    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${Router}    ${CATEGORY_LIQUSER}    ${sHTTPMethod}
    Compare Partial Message to Actual Value from Results Table    ${sErrorMessage}    ${sOutputFilePath}${Queuename}    ${XML}

Validate LIQ Error Response in FFC for Delete User API
    [Documentation]    This keyword is used to validate LIQ error response for Delete User API by searching for TextJMS and filtering by ID from OpenAPI.
    ...    @author: jloretiz    28JAN2020    - initial create
    ...    @update: cfrancis    14AUG2020    - placed additional filter for destination in FFC
    [Arguments]    ${sOutputFilePath}    ${sHTTPMethod}    ${sActual_wsFinalLIQDestination}    ${sError}
    
    ###Distributor - wsFinalLIQDestination###
    Click Element    ${RefreshButton}
    Wait Until Element Is Visible    ${Summary_Table}    30s
    Go to Dashboard and Click Source API Name    ${TEXTJMS_SOURCENAME}    ${TEXTJMS_INSTANCE}
    ${aHeaderRefNameList}    Create List    ${JMS_CORRELATION_ID}    ${RESULTSTABLE_STATUS}    ${HEADER_QUEUENAME}    ${DESTINATION}
    ###Added variable assignment handler for ID until GDE-4293 is resolved
    ${ID}    Get Substring    ${ID}    0    22
    ${aExpectedRefList}    Create List    ${ID}    ${ERROR}    ${QName_Error_Users}    ${DEST_WSFINALLIQDESTINATION}
    ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    ${ResultsRowList}    Save Message TextArea and Return Results Row List Value    ${ColumnIndex}    ${sOutputFilePath}${sActual_wsFinalLIQDestination}    ${XML}    ${HEADER_ROUTEROPERATION}    
    ...    ${HEADER_CATEGORY}    ${HEADER_OPERATION}
    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${ROUTEROPTION_LIQRESPONSE}    ${CATEGORY_LIQUSER}    ${sHTTPMethod}
    ${Content}    OperatingSystem.Get File    ${dataset_path}${sOutputFilePath}${sActual_wsFinalLIQDestination}_1.xml
    Run Keyword And Continue On Failure    Should Contain    ${Content}    ${sError}
    ${ValueExist_Status}    Run Keyword And Return Status    Should Contain    ${Content}    ${sError}
    Run Keyword If    ${ValueExist_Status}==${True}    Log    'LIQ Record is Locked and cannot be updated.'
    ...    ELSE    Log    'LIQ Record was modified even though it is open on Update Mode.'    level=ERROR

Validate SSO Success Response in FFC for User API
    [Documentation]    This keyword is used to validate SSO success response for User API by searching for TextJMS and filtering by ID from OpenAPI,
    ...    Status and Queuename and validating if expected values are existing in the SSO response.
    ...    @author: clanding    08APR2019    - initial create
    ...    @update: clanding    25APR2019    - add handling for PUT
    ...    @update: dahijara    25JUL2019    - add conditions to handle addition of LOB to existing user profile.
    ...    @update: jdelacru    06NOV2019    - added Return From Keyword If to handle if SSO is enabled/disabled
    [Arguments]    ${sOutputFilePath}    ${sHTTPMethod}    ${sLoginID}
    
    Return From Keyword If    '${SSO_ENABLED}'=='NO'
    
    ###Distributor - ssoRequestRouterQueue###
    Go to Dashboard and Click Source API Name    ${TEXTJMS_SOURCENAME}    ${TEXTJMS_INSTANCE}
    ${aHeaderRefNameList}    Create List    ${JMS_CORRELATION_ID}    ${RESULTSTABLE_STATUS}    ${HEADER_QUEUENAME}
    ${aExpectedRefList}    Create List    ${ID}    ${SPLIT}    ${QNAME_SSOREQUESTROUTERQUEUE}
    ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    ${ResultsRowList}    Save Message TextArea and Return Results Row List Value    ${ColumnIndex}    ${sOutputFilePath}${QNAME_SSOREQUESTROUTERQUEUE}    ${JSON}    ${HEADER_ROUTEROPERATION}    
    ...    ${HEADER_CATEGORY}    ${HEADER_OPERATION}
    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${ROUTEROPTION_ADSUCCESS}    ${EMPTY}    ${sHTTPMethod}
    
    ###Distributor - wsSSOCreateUserDestinationQueue###
    ${Queuename}    Run Keyword If    '${sHTTPMethod}'=='POST' and '${SSO_GLOBAL_OSUSERID}'!=''    Set Variable    ${QNAME_SSOFINALUPDATEUSER}
    ...    ELSE IF    '${sHTTPMethod}'=='${POSTMethod}'    Set Variable    ${QNAME_SSOCREATEUSER}
    ...    ELSE IF    '${sHTTPMethod}'=='${PUTMethod}'    Set Variable    ${QNAME_SSOUPDATEUSER}
    ${RouterOption}    Run Keyword If    '${sHTTPMethod}'=='POST' and '${SSO_GLOBAL_OSUSERID}'!=''    Set Variable    ${ROUTEROPTION_UPDATESSOUSER}
    ...    ELSE IF    '${sHTTPMethod}'=='${POSTMethod}'    Set Variable    ${ROUTEROPTION_CREATESSOUSER}
    ...    ELSE IF    '${sHTTPMethod}'=='${PUTMethod}'    Set Variable    ${ROUTEROPTION_UPDATESSOUSER}
    Click Element    ${RefreshButton}
    Wait Until Element Is Visible    ${Summary_Table}    30s
    Go to Dashboard and Click Source API Name    ${TEXTJMS_SOURCENAME}    ${TEXTJMS_INSTANCE}
    ${aHeaderRefNameList}    Create List    ${JMS_CORRELATION_ID}    ${RESULTSTABLE_STATUS}    ${HEADER_QUEUENAME}
    ${aExpectedRefList}    Create List    ${ID}    ${SENT}    ${Queuename}
    ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    ${ResultsRowList}    Save Message TextArea and Return Results Row List Value    ${ColumnIndex}    ${sOutputFilePath}${Queuename}    ${XML}    ${HEADER_ROUTEROPERATION}    ${HEADER_CATEGORY}    ${HEADER_OPERATION}
    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${RouterOption}    ${CATEGORY_SSOUSER}    ${sHTTPMethod}
    Compare Partial Message to Actual Value from Results Table    ${sLoginID}    ${sOutputFilePath}${Queuename}    ${XML}
    
    ###Distributor - ssoDestination###
    Click Element    ${RefreshButton}
    Wait Until Element Is Visible    ${Summary_Table}    30s
    ${Expected_Message}    Run Keyword If    '${sHTTPMethod}'=='POST' and '${SSO_GLOBAL_OSUSERID}'!=''    Catenate    <Message>User    ${sLoginID}    updated successfully.</Message>
    ...    ELSE IF    '${sHTTPMethod}'=='${POSTMethod}'    Catenate    <Message>User    ${sLoginID}    created successfully.</Message>
    ...    ELSE IF    '${sHTTPMethod}'=='${PUTMethod}'    Catenate    <Message>User    ${sLoginID}    updated successfully.</Message>
    ...    ELSE    Catenate    <Message>User    ${sLoginID}    created successfully.</Message>
    Go to Dashboard and Click Source API Name    ${TEXTJMS_SOURCENAME}    ${TEXTJMS_INSTANCE}
    ${aHeaderRefNameList}    Create List    ${JMS_CORRELATION_ID}    ${RESULTSTABLE_STATUS}    ${HEADER_QUEUENAME}
    ${aExpectedRefList}    Create List    ${ID}    ${SENT}    ${QNAME_SSODESTINATION}
    ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    ${ResultsRowList}    Save Message TextArea and Return Results Row List Value    ${ColumnIndex}    ${sOutputFilePath}${QNAME_SSODESTINATION}    ${XML}    ${HEADER_ROUTEROPERATION}    
    ...    ${HEADER_CATEGORY}    ${HEADER_OPERATION}
    ${ExpectedList1}    Create List    ${ROUTEROPTION_SSOSUCCESS}    ${CATEGORY_SSOUSER}    ${sHTTPMethod}
    ${ExpectedList2}    Create List    ${ROUTEROPTION_SSOUSERREPLY}    ${CATEGORY_SSOUSER}    ${sHTTPMethod}
    Run Keyword If    '${sHTTPMethod}'=='POST' and '${SSO_GLOBAL_OSUSERID}'!=''    Validate Multiple Expected Value List From Results Row Values    ${ResultsRowList}    ${ExpectedList1}    ${ExpectedList2}
    ...    ELSE    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${ROUTEROPTION_SSOUSERREPLY}    ${CATEGORY_SSOUSER}    ${sHTTPMethod}
    Compare Partial Message to Actual Value from Results Table    ${Expected_Message}    ${sOutputFilePath}${QNAME_SSODESTINATION}    ${XML}

Validate SSO Success Response in FFC for Delete User API
    [Documentation]    This keyword is used to validate SSO success response for Delete User API by searching for TextJMS and filtering by ID from OpenAPI,
    ...    Status and Queuename and validating if expected values are existing in the SSO response.
    ...    @author: amansuet    15AUG2019    - initial create
    [Arguments]    ${sOutputFilePath}    ${sHTTPMethod}    ${sLoginID}
    Return From Keyword If    '${SSO_ENABLED}'=='NO'
    
    ###Distributor - wsSSOCreateUserDestinationQueue###   
    Click Element    ${RefreshButton}
    Wait Until Element Is Visible    ${Summary_Table}    30s
    Go to Dashboard and Click Source API Name    ${TEXTJMS_SOURCENAME}    ${TEXTJMS_INSTANCE}
    ${aHeaderRefNameList}    Create List    ${JMS_CORRELATION_ID}    ${RESULTSTABLE_STATUS}    ${HEADER_QUEUENAME}
    ${aExpectedRefList}    Create List    ${ID}    ${SENT}    ${QNAME_SSODELETEUSER}
    ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    ${ResultsRowList}    Save Message TextArea and Return Results Row List Value    ${ColumnIndex}    ${sOutputFilePath}${QNAME_SSODELETEUSER}    ${XML}    ${HEADER_ROUTEROPERATION}    
    ...    ${HEADER_CATEGORY}    ${HEADER_OPERATION}
    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${ROUTEROPTION_DELETESSOUSER}    ${CATEGORY_SSOUSER}    ${sHTTPMethod}
    Compare Partial Message to Actual Value from Results Table    ${sLoginID}    ${sOutputFilePath}${QNAME_SSODELETEUSER}    ${XML}
    
    ###Distributor - ssoDestination###
    Click Element    ${RefreshButton}
    Wait Until Element Is Visible    ${Summary_Table}    30s
    ${Expected_Message}    Catenate    <Message>User(s) deleted successfully.</Message>
    Go to Dashboard and Click Source API Name    ${TEXTJMS_SOURCENAME}    ${TEXTJMS_INSTANCE}
    ${aHeaderRefNameList}    Create List    ${JMS_CORRELATION_ID}    ${RESULTSTABLE_STATUS}    ${HEADER_QUEUENAME}
    ${aExpectedRefList}    Create List    ${ID}    ${SENT}    ${QNAME_SSODESTINATION}
    ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    ${ResultsRowList}    Save Message TextArea and Return Results Row List Value    ${ColumnIndex}    ${sOutputFilePath}${QNAME_SSODESTINATION}    ${XML}    ${HEADER_ROUTEROPERATION}    
    ...    ${HEADER_CATEGORY}    ${HEADER_OPERATION}
    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${ROUTEROPTION_SSOUSERDELETEREPLY}    ${CATEGORY_SSOUSER}    ${sHTTPMethod}
    Compare Partial Message to Actual Value from Results Table    ${Expected_Message}    ${sOutputFilePath}${QNAME_SSODESTINATION}    ${XML}   

Validate AD Success Response in FFC for User API
    [Documentation]    This keyword is used to validate AD success response for User API by searching for TextJMS and filtering by ID from OpenAPI,
    ...    Status and Queuename and validating if expected values are existing in the AD response.
    ...    @author: clanding    08APR2019    - initial create
    ...    @update: clanding    22APR2019    - added filtering for operation status ${HEADER_OPERATION}, added handling for adding existing OSUserID
    ...    @update: jdelacru    28MAY2019    - Uses ${HEADER_HTTP_OPERATION} in determining header for operation
    ...    @update: amansuet    16AUG2019    - Added condition for delete methods, added condition on Router Option Value
    ...    @update: jdelacru    10JAN2019    - Deleted incorrect AD Message assignment
    [Arguments]    ${sOutputFilePath}    ${sHTTPMethod}    ${sOSUserID}
    
    ${RouterOption}    Run Keyword If    '${sHTTPMethod}'=='DELETE'    Set Variable    ${ROUTEROPTION_ADUSERDELETEREPLY}
    ...    ELSE    Set Variable    ${ROUTEROPTION_ADUSERREPLY}

    ###Distributor - adFinalDestination###
    ${AD_Message}    Run Keyword If    '${sHTTPMethod}'=='POST' and '${SSO_GLOBAL_OSUSERID}'==''    Catenate    {"code":"0000","message":"Successfully created user with ID ${sOSUserID}"}
    ...    ELSE IF    '${sHTTPMethod}'=='PUT'    Catenate    {"code":"0000","message":"User ${sOSUserID} has been updated successfully."}
    ...    ELSE IF    '${sHTTPMethod}'=='POST' and '${SSO_GLOBAL_OSUSERID}'!=''    Catenate    {"code":"0000","message":"Successfully created user with ID ${sOSUserID}"}
    ...    ELSE IF    '${sHTTPMethod}'=='DELETE'    Catenate    {"code":"0000","message":"User ${sOSUserID} has been disabled successfully."}
    Go to Dashboard and Click Source API Name    ${TEXTJMS_SOURCENAME}    ${TEXTJMS_INSTANCE}
    ${aHeaderRefNameList}    Create List    ${JMS_CORRELATION_ID}    ${RESULTSTABLE_STATUS}    ${HEADER_QUEUENAME}    ${HEADER_HTTP_OPERATION}
    ${aExpectedRefList}    Create List    ${ID}    ${SENT}    ${QNAME_ADFINALDESTINATION}    ${sHTTPMethod}
    ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    ${ResultsRowList}    Save Message TextArea and Return Results Row List Value    ${ColumnIndex}    ${sOutputFilePath}${QNAME_ADFINALDESTINATION}    ${JSON}    ${HEADER_ROUTEROPERATION}    
    ...    ${HEADER_CATEGORY}
    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${RouterOption}    ${CATEGORY_ADUSER}
    Compare Expected and Actual Values from Results Table    ${AD_Message}    ${sOutputFilePath}${QNAME_ADFINALDESTINATION}    ${JSON}

Validate PARTY Success Response in FFC for User API
    [Documentation]    Used to validate Queuename for Party.
    ...    @author: clanding    15APR2019    - initial create
    ...    @update: clanding    22APR2019    - changed category to CATEGORY_PARTYUSER
    ...    @update: clanding    25APR2019    - add handling for PUT
    ...    @update: amansuet    16AUG2019    - add handling for DELETE
    [Arguments]    ${sOutputFilePath}    ${sHTTPMethod}    ${sLoginID}
    
    ${Queuename}    Run Keyword If    '${sHTTPMethod}'=='${POSTMethod}'    Set Variable    ${QNAME_WSPARTYCREATEUSER}
    ...    ELSE IF    '${sHTTPMethod}'=='${PUTMethod}'    Set Variable    ${QNAME_WSPARTYUPDATEUSER}
    ...    ELSE IF    '${sHTTPMethod}'=='${DeleteMethod}'    Set Variable    ${QNAME_WSPARTYDELETEUSER}
    
    ${RouterOption}    Run Keyword If    '${sHTTPMethod}'=='${POSTMethod}'    Set Variable    ${ROUTEROPTION_CREATEPARTYUSER}
    ...    ELSE IF    '${sHTTPMethod}'=='${PUTMethod}'    Set Variable    ${ROUTEROPTION_UPDATEPARTYUSER}
    ...    ELSE IF    '${sHTTPMethod}'=='${DeleteMethod}'    Set Variable    ${ROUTEROPTION_DELETEPARTYUSER}
        
    ###Distributor - wsEssenceCreateUserDestinationQueue###
    Click Element    ${RefreshButton}
    Wait Until Element Is Visible    ${Summary_Table}    30s
    Go to Dashboard and Click Source API Name    ${TEXTJMS_SOURCENAME}    ${TEXTJMS_INSTANCE}
    ${aHeaderRefNameList}    Create List    ${JMS_CORRELATION_ID}    ${RESULTSTABLE_STATUS}    ${HEADER_QUEUENAME}
    ###Added variable assignment handler for ID until GDE-4293 is resolved
    ${ID}    Get Substring    ${ID}    0    22
    ${aExpectedRefList}    Create List    ${ID}    ${SENT}    ${Queuename}
    ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    ${ResultsRowList}    Save Message TextArea and Return Results Row List Value    ${ColumnIndex}    ${sOutputFilePath}${Queuename}    ${XML}    ${HEADER_ROUTEROPERATION}    
    ...    ${HEADER_CATEGORY}    ${HEADER_OPERATION}
    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${RouterOption}    ${CATEGORY_PARTYUSER}    ${sHTTPMethod}
    Compare Partial Message to Actual Value from Results Table    ${sLoginID}    ${sOutputFilePath}${Queuename}    ${XML}
    
Validate PARTY Error Response in FFC for User API
    [Documentation]    Used to validate Queuename for Party.
    ...    @author: cfrancis    13AUG2020    - initial create
    [Arguments]    ${sOutputFilePath}    ${sHTTPMethod}    ${sLoginID}    ${sErrorMessage}    ${sStatus}
    
    ${Queuename}    Run Keyword If    '${sHTTPMethod}'=='${POSTMethod}'    Set Variable    ${QNAME_WSPARTYCREATEUSER}
    ...    ELSE IF    '${sHTTPMethod}'=='${PUTMethod}'    Set Variable    ${QNAME_WSPARTYUPDATEUSER}
    ...    ELSE IF    '${sHTTPMethod}'=='${DeleteMethod}'    Set Variable    ${QNAME_WSPARTYDELETEUSER}
    
    ${RouterOption}    Run Keyword If    '${sHTTPMethod}'=='${POSTMethod}'    Set Variable    ${ROUTEROPTION_CREATEPARTYUSER}
    ...    ELSE IF    '${sHTTPMethod}'=='${PUTMethod}'    Set Variable    ${ROUTEROPTION_UPDATEPARTYUSER}
    ...    ELSE IF    '${sHTTPMethod}'=='${DeleteMethod}'    Set Variable    ${ROUTEROPTION_DELETEPARTYUSER}
        
    ###Added variable assignment handler for ID until GDE-4293 is resolved
    ${ID}    Get Substring    ${ID}    0    22
    ###Distributor - errorLogQueue###
    Click Element    ${RefreshButton}
    Wait Until Element Is Visible    ${Summary_Table}    30s
    Go to Dashboard and Click Source API Name    ${TEXTJMS_SOURCENAME}    ${TEXTJMS_INSTANCE}
    ${aHeaderRefNameList}    Create List    ${JMS_CORRELATION_ID}    ${RESULTSTABLE_STATUS}    ${HEADER_QUEUENAME}    ${DESTINATION}
    ${aExpectedRefList}    Create List    ${ID}    ${sStatus}    ${QName_Error_Users}    ${DEST_WSPARTYDELETEUSER}
    ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    ${ResultsRowList}    Save Message TextArea and Return Results Row List Value    ${ColumnIndex}    ${sOutputFilePath}${Queuename}    ${XML}    ${HEADER_ROUTEROPERATION}    
    ...    ${HEADER_CATEGORY}    ${HEADER_OPERATION} 
    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${ROUTEROPTION_PLATFORMUSERREPLY}    ${CATEGORY_PARTYUSER}    ${sHTTPMethod}
    Compare Partial Message to Actual Value from Results Table    ${sErrorMessage}    ${sOutputFilePath}${Queuename}    ${XML}

Validate ESSENCE Success Response in FFC for User API
    [Documentation]    Used to validate Queuename for Essence.
    ...    @author: clanding    15APR2019    - initial create
    ...    @update: clanding    22APR2019    - changed category to CATEGORY_ESSENCEUSER
    ...    @update: amansuet    16AUG2019    - add handling for DELETE
    [Arguments]    ${sOutputFilePath}    ${sHTTPMethod}    ${sLoginID}
    
    ${Queuename}    Run Keyword If    '${sHTTPMethod}'=='${POSTMethod}'    Set Variable    ${QNAME_WSESSENCECREATEUSER}
    ...    ELSE IF    '${sHTTPMethod}'=='${PUTMethod}'    Set Variable    ${QNAME_WSESSENCEUPDATEUSER}
    ...    ELSE IF    '${sHTTPMethod}'=='${DeleteMethod}'    Set Variable    ${QNAME_WSESSENCEDELETEEUSER}
    
    ${RouterOption}    Run Keyword If    '${sHTTPMethod}'=='${POSTMethod}'    Set Variable    ${ROUTEROPTION_CREATEESSENCEUSER}
    ...    ELSE IF    '${sHTTPMethod}'=='${PUTMethod}'    Set Variable    ${ROUTEROPTION_UPDATEESSENCEUSER}
    ...    ELSE IF    '${sHTTPMethod}'=='${DeleteMethod}'    Set Variable    ${ROUTEROPTION_DELETEESSENCEUSER}
    
    ###Distributor - wsEssenceCreateUserDestinationQueue###
    Click Element    ${RefreshButton}
    Wait Until Element Is Visible    ${Summary_Table}    30s
    Go to Dashboard and Click Source API Name    ${TEXTJMS_SOURCENAME}    ${TEXTJMS_INSTANCE}
    ${aHeaderRefNameList}    Create List    ${JMS_CORRELATION_ID}    ${RESULTSTABLE_STATUS}    ${HEADER_QUEUENAME}
    ###Added variable assignment handler for ID until GDE-4293 is resolved
    ${ID}    Get Substring    ${ID}    0    22
    ${aExpectedRefList}    Create List    ${ID}    ${SENT}    ${Queuename}
    ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    ${ResultsRowList}    Save Message TextArea and Return Results Row List Value    ${ColumnIndex}    ${sOutputFilePath}${Queuename}    ${XML}    ${HEADER_ROUTEROPERATION}    
    ...    ${HEADER_CATEGORY}    ${HEADER_OPERATION}
    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${RouterOption}    ${CATEGORY_ESSENCEUSER}    ${sHTTPMethod}
    Compare Partial Message to Actual Value from Results Table    ${sLoginID}    ${sOutputFilePath}${Queuename}    ${XML}

Validate ESSENCE Error Response in FFC for User API
    [Documentation]    Used to validate Queuename for Essence.
    ...    @author: cfrancis    13AUG2020    - initial create
    [Arguments]    ${sOutputFilePath}    ${sHTTPMethod}    ${sLoginID}    ${sErrorMessage}    ${sStatus}
    
    ${Queuename}    Run Keyword If    '${sHTTPMethod}'=='${POSTMethod}'    Set Variable    ${QNAME_WSESSENCECREATEUSER}
    ...    ELSE IF    '${sHTTPMethod}'=='${PUTMethod}'    Set Variable    ${QNAME_WSESSENCEUPDATEUSER}
    ...    ELSE IF    '${sHTTPMethod}'=='${DeleteMethod}'    Set Variable    ${QNAME_WSESSENCEDELETEEUSER}
    
    ${RouterOption}    Run Keyword If    '${sHTTPMethod}'=='${POSTMethod}'    Set Variable    ${ROUTEROPTION_CREATEESSENCEUSER}
    ...    ELSE IF    '${sHTTPMethod}'=='${PUTMethod}'    Set Variable    ${ROUTEROPTION_UPDATEESSENCEUSER}
    ...    ELSE IF    '${sHTTPMethod}'=='${DeleteMethod}'    Set Variable    ${ROUTEROPTION_DELETEESSENCEUSER}
    
    ###Added variable assignment handler for ID until GDE-4293 is resolved
    ${ID}    Get Substring    ${ID}    0    22
    ###Distributor - errorLogQueue###
    Click Element    ${RefreshButton}
    Wait Until Element Is Visible    ${Summary_Table}    30s
    Go to Dashboard and Click Source API Name    ${TEXTJMS_SOURCENAME}    ${TEXTJMS_INSTANCE}
    ${aHeaderRefNameList}    Create List    ${JMS_CORRELATION_ID}    ${RESULTSTABLE_STATUS}    ${HEADER_QUEUENAME}    ${DESTINATION}
    ${aExpectedRefList}    Create List    ${ID}    ${ERROR}    ${QName_Error_Users}    ${DEST_WSESSENCEDELETEUSER}
    ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    ${ResultsRowList}    Save Message TextArea and Return Results Row List Value    ${ColumnIndex}    ${sOutputFilePath}${Queuename}    ${XML}    ${HEADER_ROUTEROPERATION}    
    ...    ${HEADER_CATEGORY}    ${HEADER_OPERATION} 
    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${ROUTEROPTION_PLATFORMUSERREPLY}    ${CATEGORY_ESSENCEUSER}    ${sHTTPMethod}
    Compare Partial Message to Actual Value from Results Table    ${sErrorMessage}    ${sOutputFilePath}${Queuename}    ${XML}

Validate FFC for User API Technical 400
    [Documentation]    This keyword is used for FFC validation of User API with Technical Error 400 status.
    ...    @author: clanding    23APR2019    - initial create
    
    Login to MCH UI
    
    Wait Until Element Is Visible    ${FFC_Dashboard}    30s
    ${SourceNameExist}    Validate if Source API Name Does Exist    ${BASE_SOURCENAME}    ${OPEAPI_INSTANCE}
    Run Keyword If    ${SourceNameExist}==${True}    Run Keywords    Go to Dashboard and Click Source API Name    ${BASE_SOURCENAME}    ${OPEAPI_INSTANCE}
    ...    AND    Filter by Reference Header and Value and Expect No Row in Results Table    ${AUTHORIZATION}    ${AUTH_TOKEN}
    ...    ELSE IF    ${SourceNameExist}==${False}    Log    Source Name '${BASE_SOURCENAME}' have no recent transaction for the dates indicated in MCH UI.    level=WARN
    
    Logout to MCH UI and Close Browser

    
Validate AD Failed Response in FFC for User API
    [Documentation]    This keyword is used to validate AD failed response for User API by searching for TextJMS and filtering by ID from OpenAPI,
    ...    Status and Queuename and validating if expected values are existing in the AD response.
    ...    This keyword will validate the negative testing wherein the user should not be created in AD after successfull POST
    ...    @author: dahijara    31JUL2019    - initial create
    ...    @update: dahijara    7AUG2019    - Added condition to validate when OSUserId field is not populated.
    [Arguments]    ${sLOB_From_Excel}    ${sInputFilePath}    ${sInputAPIResonse}    ${sOutputFilePath}    ${sOutputAPIResponse}
    ...    ${sHTTPMethod}    ${sLoginID}    ${sOSUserID}

    Login to MCH UI
    Run Keyword And Continue On Failure    Validate OpenAPI for User API    ${sInputFilePath}    ${sInputAPIResonse}    ${sOutputFilePath}    ${sOutputAPIResponse}    ${sHTTPMethod}
    ###Distributor - errorLogQueue###
    ${AD_Message}    Run Keyword If    '${sOSUserID}'=='no tag' or '${sOSUserID}'=='null'    Set Variable    osUserId field is missing
    ...    ELSE    Catenate    {"code":"0000","message":"Successfully created user with ID ${sOSUserID}"}
    
    Go to Dashboard and Click Source API Name    ${TEXTJMS_SOURCENAME}    ${TEXTJMS_INSTANCE}
    ${HeaderRefNameList}    Create List    ${JMS_CORRELATION_ID}    ${RESULTSTABLE_STATUS}    ${HEADER_QUEUENAME}
    ${ExpectedRefList}    Create List    ${ID}    ${FAILED}    ${QName_Error_Users}
    ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${HeaderRefNameList}    ${ExpectedRefList}
    
    ${ResultsRowList}    Save Message TextArea and Return Results Row List Value    ${ColumnIndex}    ${sOutputFilePath}${QName_Error_Users}    ${JSON}    ${RESULTSTABLE_STATUS}  
    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${FAILED}
    Compare Partial Message to Actual Value from Results Table    ${AD_Message}    ${sOutputFilePath}${QName_Error_Users}    ${JSON}
    Logout to MCH UI and Close Browser

Validate AD Error Response in FFC for User API
    [Documentation]    This keyword is used to validate FFC for error in AD user creation.
    ...    @author: dahijara    8AUG2019    - initial create
    [Arguments]    ${sLOB_From_Excel}    ${sInputFilePath}    ${sInputAPIResonse}    ${sOutputFilePath}    ${sOutputAPIResponse}
    ...    ${sHTTPMethod}    ${sLoginID}    ${sOSUserID}    ${sTitle}=None    ${sCentralRole}=None
    
    Login to MCH UI
    Run Keyword And Continue On Failure    Validate OpenAPI for User API    ${sInputFilePath}    ${sInputAPIResonse}    ${sOutputFilePath}    ${sOutputAPIResponse}    ${sHTTPMethod}
    ###Distributor - errorLogQueue###
    ${AD_Message}    Run Keyword If    '${sTitle}'!='None'    Validate JobTitle Length and Return Expected FFC Response Message    ${sTitle}
    ...    ELSE IF    '${sCentralRole}'!='None'    Validate Central Role Validity and Return Expected FFC Response Message    ${sCentralRole}
    ...    ELSE    Catenate    {"code":"0000","message":"Successfully created user with ID ${sOSUserID}"}
    
    Go to Dashboard and Click Source API Name    ${TEXTJMS_SOURCENAME}    ${TEXTJMS_INSTANCE}
	${HeaderRefNameList}    Create List    ${JMS_CORRELATION_ID}    ${RESULTSTABLE_STATUS}    ${HEADER_QUEUENAME}    ${HEADER_HTTP_OPERATION}
    ${ExpectedRefList}    Create List    ${ID}    ${ERROR}    ${QName_Error_Users}     ${sHTTPMethod}    
    ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${HeaderRefNameList}    ${ExpectedRefList}
    
    ${ResultsRowList}    Save Message TextArea and Return Results Row List Value    ${ColumnIndex}    ${sOutputFilePath}${QName_Error_Users}    ${JSON}    ${HEADER_ROUTEROPERATION}    ${HEADER_CATEGORY}    
    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${ROUTEROPTION_ADUSEROPERATIONCODE}    ${CATEGORY_ADUSER}
    Compare Partial Message to Actual Value from Results Table    ${AD_Message}    ${sOutputFilePath}${QName_Error_Users}    ${JSON}
    Logout to MCH UI and Close Browser    
 

Validate JobTitle Length and Return Expected FFC Response Message
    [Documentation]    This keyword is used to validate jobTitle length.
    ...    And return the expected error message FFC response.
    ...    @author: dahijara    1AUG2019    - initial create
    [Arguments]    ${sJobTitle}
  
    ${TitleCount}    Get Length    ${sJobTitle}
    ${TitleErrorMessage}    Run Keyword If    ${TitleCount} > 5    Set Variable    title's size should be between 2 and 5
    ...    ELSE IF    ${TitleCount} < 2    Set Variable    title's size should be between 2 and 5
    ...    ELSE    Set Variable    Successfully created user
  
    [Return]    ${TitleErrorMessage}

Validate Central Role Validity and Return Expected FFC Response Message
    [Documentation]    This keyword is used to validate Role value.
    ...    And return the expected error message FFC response.
    ...    @author: jloretiz    7AUG2019    - initial create
    [Arguments]    ${sCentralRoles}
  
    ${RoleConfig}    OperatingSystem.Get File    ${AD_ROLE_CONFIG}
    ${Role_List_Count}    Get Line Count    ${RoleConfig}
    :FOR    ${Index}    IN RANGE    ${Role_List_Count}
    \    ${RoleConfig_Line}    Get Line    ${RoleConfig}    ${Index}
    \    ${Role_Matched}    Run Keyword If    '${RoleConfig_Line}'=='${sCentralRoles}'    Set Variable    ${True}
         ...    ELSE    Set Variable    ${False}
    \    Exit For Loop If    '${RoleConfig_Line}'=='${sCentralRoles}'
    
    #code:0004 means error in role
    ${RoleErrorMessage}    Run Keyword If    ${Role_Matched}==${False}    Catenate    {"code":"0004","message":"Role ${sCentralRoles} is not found."}
    ...    ELSE    Set Variable    Successfully created user
  
    [Return]    ${RoleErrorMessage}

Validate FFC for Multiple LOB for Successful Delete
    [Documentation]    This keyword is used to get LOB value for successful delete.
    ...    And validate FFC according to application.
    ...    @author: amansuet    08AUG2019    - initial create
    ...    @update: amansuet    23AUG2019    - added Validate OpenAPI in the loop
    ...    @update: jdelacru    22NOV2019    - added InputJson as optional argument used to validate OpenAPI
    ...    @update: jloretiz    29JAN2020    - added an optional argument to validate OpenAPI for delete method 
    [Arguments]    ${sLOB_From_Excel}    ${sInputFilePath}    ${sInputFFCResponse}    ${sOutputFilePath}    ${sOutputFFCResponse}
    ...    ${sHTTPMethod}    ${sOSUserID}    ${sLoginId}    ${sExpected_wsFinalLIQDestination}    ${sActual_wsFinalLIQDestination}    ${InputJson}=None    ${sLIQError}=None
        
    ${LOB_List}    Split String    ${sLOB_From_Excel}    ,
    ${LOB_Count}    Get Length    ${LOB_List}

    ### DB check if user is existing in the application###
    ${ResultsCount_LIQ}    Create Query for Active LIQ User and Return Results Count    ${sLoginId}
    ${ResultsCount_Essence}    Create Query for Essence User and Return Results Count    ${sLoginId}
    ${ResultsCount_Party}    Create Query for Party User and Return Results Count    ${sLoginId}
    ### End of DB check if user is existing in the application ###

    Login to MCH UI

    :FOR    ${Index}    IN RANGE    ${LOB_Count}
    \    Exit For Loop If    '${Index}'=='${LOB_Count}'
    \    ${LOB_Value}    Get From List    ${LOB_List}    ${Index}
    \    Run Keyword and Continue on Failure    Validate OpenAPI for User API    ${sInputFilePath}    ${sInputFFCResponse}${LOB_Value}    ${sOutputFilePath}    ${sOutputFFCResponse}${LOB_Value}    ${sHTTPMethod}    ${LOB_Value}    ${InputJson}    sLoginId=${sLoginId} 
    \    Run Keyword If    '${LOB_Value}'=='ALL' and '${sLIQError}'=='None'    Run Keywords    Run Keyword and Continue on Failure    Validate LIQ Success Response in FFC for Delete User API    ${sOutputFilePath}    ${sHTTPMethod}    ${sLoginId}    # ${sInputFilePath}    ${sOutputFilePath}    ${sHTTPMethod}    ${sExpected_wsFinalLIQDestination}    ${sActual_wsFinalLIQDestination}
         ...    AND    Run Keyword and Continue on Failure    Validate ESSENCE Success Response in FFC for User API    ${sOutputFilePath}    ${sHTTPMethod}    ${sLoginId}
         ...    AND    Run Keyword and Continue on Failure    Validate PARTY Success Response in FFC for User API    ${sOutputFilePath}    ${sHTTPMethod}    ${sLoginId}
         ...    ELSE IF    '${LOB_Value}'=='COMRLENDING' and '${sLIQError}'=='TRUE'    Run Keyword and Continue on Failure    Validate LIQ Error Response in FFC for Delete User API    ${sOutputFilePath}    ${sHTTPMethod}    ${sActual_wsFinalLIQDestination}    ${LIQUPDATELOCKED}
         ...    ELSE IF    '${LOB_Value}'=='COMRLENDING' and '${sLIQError}'=='None'    Run Keyword and Continue on Failure    Validate LIQ Success Response in FFC for Delete User API    ${sOutputFilePath}    ${sHTTPMethod}    ${sLoginId}    # ${sInputFilePath}    ${sOutputFilePath}    ${sHTTPMethod}    ${sExpected_wsFinalLIQDestination}    ${sActual_wsFinalLIQDestination}    
         ...    ELSE IF    '${LOB_Value}'=='COREBANKING'    Run Keyword and Continue on Failure    Validate ESSENCE Success Response in FFC for User API    ${sOutputFilePath}    ${sHTTPMethod}    ${sLoginId}
         ...    ELSE IF    '${LOB_Value}'=='PARTY'    Run Keyword and Continue on Failure    Validate PARTY Success Response in FFC for User API    ${sOutputFilePath}    ${sHTTPMethod}    ${sLoginId}

    Run Keyword If    ${ResultsCount_LIQ}==0 and ${ResultsCount_Essence}==0 and ${ResultsCount_Party}==0
    ...    Run Keywords    Run Keyword and Continue on Failure    Validate AD Success Response in FFC for User API    ${sOutputFilePath}    ${sHTTPMethod}    ${sOSUserID}
    ...    AND    Run Keyword and Continue on Failure    Validate SSO Success Response in FFC for Delete User API    ${sOutputFilePath}    ${sHTTPMethod}    ${sLoginId}
    ...    ELSE    Log    User is still existing on one of the LOBs!

    Logout to MCH UI and Close Browser

Validate FFC for Multiple LOB for Failed Delete
    [Documentation]    This keyword is used to get LOB value for failed delete.
    ...    And validate FFC according to application.
    ...    @author: cfrancis    13AUG2020    - initial create 
    [Arguments]    ${sLOB_From_Excel}    ${sInputFilePath}    ${sInputFFCResponse}    ${sOutputFilePath}    ${sOutputFFCResponse}
    ...    ${sHTTPMethod}    ${sOSUserID}    ${sLoginId}    ${sExpected_wsFinalLIQDestination}    ${sActual_wsFinalLIQDestination}    ${InputJson}=None    ${sLIQError}=None
        
    ${LOB_List}    Split String    ${sLOB_From_Excel}    ,
    ${LOB_Count}    Get Length    ${LOB_List}

    ### DB check if user is existing in the application###
    ${ResultsCount_LIQ}    Create Query for Active LIQ User and Return Results Count    ${sLoginId}
    ${ResultsCount_Essence}    Create Query for Essence User and Return Results Count    ${sLoginId}
    ${ResultsCount_Party}    Create Query for Party User and Return Results Count    ${sLoginId}
    ### End of DB check if user is existing in the application ###

    Login to MCH UI

    :FOR    ${Index}    IN RANGE    ${LOB_Count}
    \    Exit For Loop If    '${Index}'=='${LOB_Count}'
    \    ${LOB_Value}    Get From List    ${LOB_List}    ${Index}
    \    Run Keyword and Continue on Failure    Validate OpenAPI for User API    ${sInputFilePath}    ${sInputFFCResponse}${LOB_Value}    ${sOutputFilePath}    ${sOutputFFCResponse}${LOB_Value}    ${sHTTPMethod}    ${LOB_Value}    ${InputJson}    sLoginId=${sLoginId} 
    \    Run Keyword If    '${LOB_Value}'=='ALL' and '${sLIQError}'=='None'    Run Keywords    Run Keyword and Continue on Failure    Validate LIQ Error Response in FFC for Failed User API    ${sOutputFilePath}    ${sHTTPMethod}    ${sLoginId}    ${MESSAGE_LOGINIDNOTONFILE}    ${ERROR}
         ...    AND    Run Keyword and Continue on Failure    Validate ESSENCE Error Response in FFC for User API    ${sOutputFilePath}    ${sHTTPMethod}    ${sLoginId}    ${MESSAGE_USERIDNOTEXIST} ${sLoginId}    ${ERROR}
         ...    AND    Run Keyword and Continue on Failure    Validate PARTY Error Response in FFC for User API    ${sOutputFilePath}    ${sHTTPMethod}    ${sLoginId}    ${MESSAGE_USERIDNOTEXIST} ${sLoginId}    ${ERROR}
         ...    ELSE IF    '${LOB_Value}'=='COMRLENDING' and '${sLIQError}'=='TRUE'    Run Keyword and Continue on Failure    Validate LIQ Error Response in FFC for Delete User API    ${sOutputFilePath}    ${sHTTPMethod}    ${sActual_wsFinalLIQDestination}    ${LIQUPDATELOCKED}
         ...    ELSE IF    '${LOB_Value}'=='COMRLENDING' and '${sLIQError}'=='None'    Run Keyword and Continue on Failure    Validate LIQ Error Response in FFC for Failed User API    ${sOutputFilePath}    ${sHTTPMethod}    ${sLoginId}    ${MESSAGE_LOGINIDNOTONFILE}    ${ERROR}
         ...    ELSE IF    '${LOB_Value}'=='COREBANKING'    Run Keyword and Continue on Failure    Validate ESSENCE Error Response in FFC for User API    ${sOutputFilePath}    ${sHTTPMethod}    ${sLoginId}    ${MESSAGE_USERIDNOTEXIST} ${sLoginId}    ${ERROR}
         ...    ELSE IF    '${LOB_Value}'=='PARTY'    Run Keyword and Continue on Failure    Validate PARTY Error Response in FFC for User API    ${sOutputFilePath}    ${sHTTPMethod}    ${sLoginId}    ${MESSAGE_USERIDNOTEXIST} ${sLoginId}    ${ERROR}
    
    Logout to MCH UI and Close Browser

Validate OpenAPI with Token
    [Documentation]    This keyword is used to validate OpenAPISource when SSO feature is enabled, previously part of Validate OpenAPI for User API
    ...    @author: jdelacru    05NOV2019    - Initial Create
    [Arguments]    ${sInputFilePath}    ${sInputAPIResonse}    ${sOutputFilePath}    ${sOutputAPIResponse}    ${sHTTPMethod}    ${sLineOfBusiness}=None
    ${authTokenOpenAPI}    Run Keyword If    '${sLineOfBusiness}'=='ALL' and '${sHTTPMethod}'=='DELETE'    Set Variable    ${AUTH_TOKEN_ALL}
    ...    ELSE IF    '${sLineOfBusiness}'=='COMRLENDING' and '${sHTTPMethod}'=='DELETE'    Set Variable    ${AUTH_TOKEN_LIQ}
    ...    ELSE IF    '${sLineOfBusiness}'=='COREBANKING' and '${sHTTPMethod}'=='DELETE'    Set Variable    ${AUTH_TOKEN_ESS}
    ...    ELSE IF    '${sLineOfBusiness}'=='PARTY' and '${sHTTPMethod}'=='DELETE'    Set Variable    ${AUTH_TOKEN_PTY}
    ...    ELSE    Set Variable    ${AUTH_TOKEN}
    ${ResultsRowList}    Filter by Reference Header and Save Message TextArea and Return Results Row List Value    ${AUTHORIZATION}    ${authTokenOpenAPI}
    ...    ${sOutputFilePath}${sOutputAPIResponse}    ${JSON}    ${RESULTSTABLE_STATUS}    ${HTTP_OPERATION}
    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${MESSAGESTATUS_SUCCESSFUL}    ${sHTTPMethod}
    Run Keyword If    '${sHTTPMethod}'=='DELETE'    Compare Input and Output File for Delete and Get Users    ${sInputFilePath}    ${sInputAPIResonse}
    ...    ELSE    Compare Input and Output JSON for User    ${sInputFilePath}    ${sInputAPIResonse}
    @{ResultsRowList}    Get Results Table Column Value by Header List and Return    ${RESULTS_ROW_WITHREF}    ${HEADER_ID}
    
Validate OpenAPI without Token
    [Documentation]    This keyword is used to validate OpenAPISource when SSO feature is disabled
    ...    @author: jdelacru    05NOV2019    - Initial Create
    ...    @update: jdelacru    22NOV2019    - Separated reading loginId for Post/Put and Delete operations
    ...    @update: jloretiz    29JAN2020    - added an optional argument to validate OpenAPI for delete method 
    ...    @updade: jdelacru    14FEB2020    - added condition for PUT method in reading LoginID
    [Arguments]    ${sInputFilePath}    ${sInputAPIResponse}    ${sHTTPMethod}    ${InputJson}=None    ${sLineOfBusiness}=None    ${sLoginId}=None

    ${loginId}    Run Keyword If    '${sHTTPMethod}'=='POST' or '${sHTTPMethod}'=='PUT' and '${sLoginId}'=='None'    Read Login ID Value for Post    ${sInputFilePath}    ${sInputAPIResponse}
    ...    ELSE IF    '${sHTTPMethod}'=='DELETE' and '${sLoginId}'=='None'    Read Login ID Value for Delete    ${sInputFilePath}    ${InputJson}
    ...    ELSE    Set Variable    ${sLoginId}

    ${Results_Column_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Header}
    ${Results_Row_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Row}
    
    Run Keyword If    '${sLineOfBusiness}'=='ALL' and '${sHTTPMethod}'=='DELETE'    Filter by Reference Header for Multiple LOB for User    ${loginId}    ${Results_Column_Count}    ${LOB}
    ...    ELSE    Filter by Reference Header for Single LOB for User    ${loginId}    ${sHTTPMethod}    ${Results_Row_Count}    ${sLineOfBusiness}

# User/SSO FFC Validation for SSO Error
    # [Documentation]    Used to validate API in FFC UI.
    # ...    AD Fail, no user creates
    # ...    @author: jaquitan
    # [Arguments]    ${APIDataSet}    ${expected_message}
    # Login to FFC for User    &{APIDataSet}[MDM_FFC_SERVER]:&{APIDataSet}[MDM_FFC_PORT]&{APIDataSet}[MDM_FFC_URL]    &{APIDataSet}[Browser_used]    &{APIDataSet}[MDM_FFC_Username]    &{APIDataSet}[MDM_FFC_Password]
    # FFC UI Verification - OpenAPI for User    ${UsersName}    ${dataset_path}&{APIDataSet}[InputFilePath]    ${dataset_path}&{APIDataSet}[OutputFilePath]
    # ...    ${Users_Parent_Entry}    ${UsersRow_Child_Entry}    ${MessageStatus_SUCCESS}    &{APIDataSet}[HTTPMethodType]    &{APIDataSet}[OutputFFCResponse].json
    # Compare_FFC_output_with_response    ${dataset_path}&{APIDataSet}[InputFilePath]   &{APIDataSet}[InputFFCResponse].json    ${FFC_Response}
    # FFC UI Verification - TextJMS for User SSO Error    &{APIDataSet}[HTTPMethodType]    ${MessageStatus_ERROR}    ${expected_message}    ${dataset_path}&{APIDataSet}[OutputFilePath]
    # FFC_Logout
    # Close Browser

# FFC UI Verification - TextJMS for User SSO Fail - No Category Name filter
    # [Documentation]    Used to validate API in FFC UI.
    # ...    AD Fail, no user creates
    # ...    @author: jaquitan
    # [Arguments]    ${APIDataSet}    ${expected_message}
    # Login to FFC for User    &{APIDataSet}[MDM_FFC_SERVER]:&{APIDataSet}[MDM_FFC_PORT]&{APIDataSet}[MDM_FFC_URL]    &{APIDataSet}[Browser_used]    &{APIDataSet}[MDM_FFC_Username]    &{APIDataSet}[MDM_FFC_Password]
    # FFC UI Verification - OpenAPI for User    ${UsersName}    ${dataset_path}&{APIDataSet}[InputFilePath]    ${dataset_path}&{APIDataSet}[OutputFilePath]
    # ...    ${Users_Parent_Entry}    ${UsersRow_Child_Entry}    ${MessageStatus_SUCCESS}    &{APIDataSet}[HTTPMethodType]    &{APIDataSet}[OutputFFCResponse].json
    # Compare_FFC_output_with_response    ${dataset_path}&{APIDataSet}[InputFilePath]   &{APIDataSet}[InputFFCResponse].json    ${FFC_Response}
    # FFC UI Verification - TextJMS Fail - No Category Name filter    &{APIDataSet}[HTTPMethodType]    ${MessageStatus_FAILED}    ${expected_message}
    # FFC_Logout
    # Close Browser

# User/SSO FFC Validation for SSO Fail - No Category Name filter
    # [Documentation]    Used to validate API in FFC UI.
    # ...    AD Fail, no user creates
    # ...    @author: jaquitan
    # [Arguments]    ${APIDataSet}    ${expected_message}
    # Login to FFC for User    &{APIDataSet}[MDM_FFC_SERVER]:&{APIDataSet}[MDM_FFC_PORT]&{APIDataSet}[MDM_FFC_URL]    &{APIDataSet}[Browser_used]    &{APIDataSet}[MDM_FFC_Username]    &{APIDataSet}[MDM_FFC_Password]
    # FFC UI Verification - OpenAPI for User    ${UsersName}    ${dataset_path}&{APIDataSet}[InputFilePath]    ${dataset_path}&{APIDataSet}[OutputFilePath]
    # ...    ${Users_Parent_Entry}    ${UsersRow_Child_Entry}    ${MessageStatus_SUCCESS}    &{APIDataSet}[HTTPMethodType]    &{APIDataSet}[OutputFFCResponse].json
    # Compare_FFC_output_with_response    ${dataset_path}&{APIDataSet}[InputFilePath]   &{APIDataSet}[InputFFCResponse].json    ${FFC_Response}
    # FFC UI Verification - TextJMS Fail - Single    &{APIDataSet}[HTTPMethodType]    ${MessageStatus_FAILED}    ${expected_message}
    # FFC_Logout
    # Close Browser

# User/SSO FFC Validation for SSO Success
    # [Documentation]    Used to validate API in FFC UI.
    # ...    AD success
    # ...    SSO success
    # ...    LIQ fail
    # ...    @author: jaquitan
    # [Arguments]    ${APIDataSet}    ${expected_message}
    # Login to FFC for User    &{APIDataSet}[MDM_FFC_SERVER]:&{APIDataSet}[MDM_FFC_PORT]&{APIDataSet}[MDM_FFC_URL]    &{APIDataSet}[Browser_used]    &{APIDataSet}[MDM_FFC_Username]    &{APIDataSet}[MDM_FFC_Password]
    # FFC UI Verification - OpenAPI for User    ${UsersName}    ${dataset_path}&{APIDataSet}[InputFilePath]    ${dataset_path}&{APIDataSet}[OutputFilePath]
    # ...    ${Users_Parent_Entry}    ${UsersRow_Child_Entry}    ${MessageStatus_SUCCESS}    &{APIDataSet}[HTTPMethodType]    &{APIDataSet}[OutputFFCResponse].json
    # Compare_FFC_output_with_response    ${dataset_path}&{APIDataSet}[InputFilePath]   &{APIDataSet}[InputFFCResponse].json    ${FFC_Response}
    # FFC UI Verification - TextJMS for User AD/SSO Success   &{APIDataSet}[HTTPMethodType]    ${MessageStatus_SENT}    ${APIDataSet}    ${dataset_path}&{APIDataSet}[OutputFilePath]
    # FFC UI Verification - TextJMS for User LIQ Fail    &{APIDataSet}[HTTPMethodType]    ${MessageStatus_ERROR}    ${expected_message}
    # FFC_Logout
    # Close Browser

# User/SSO FFC Validation for Delete Success - LIQ
    # [Documentation]    Used to validate API in FFC UI for Delete.
    # ...    @author: clanding
    # [Arguments]    ${APIDataSet}    ${lobs}
    # Login to FFC for User    &{APIDataSet}[MDM_FFC_SERVER]:&{APIDataSet}[MDM_FFC_PORT]&{APIDataSet}[MDM_FFC_URL]    &{APIDataSet}[Browser_used]    &{APIDataSet}[MDM_FFC_Username]    &{APIDataSet}[MDM_FFC_Password]
    # FFC UI Verification - OpenAPI for Delete User    ${UsersName}    ${lobs}    ${dataset_path}&{APIDataSet}[OutputFilePath]
    # ...    ${Users_Parent_Entry}    ${UsersRow_Child_Entry}    ${MessageStatus_SUCCESS}    &{APIDataSet}[HTTPMethodType]    &{APIDataSet}[OutputFFCResponse]_LIQ.txt
    # ${InputFFCResponse}    OperatingSystem.Get File    ${dataset_path}&{APIDataSet}[InputFilePath]&{APIDataSet}[InputFFCResponse]_LIQ.txt
    # ${OutputFFCResponse}    OperatingSystem.Get File    ${dataset_path}&{APIDataSet}[OutputFilePath]&{APIDataSet}[OutputFFCResponse]_LIQ.txt
    # ${status}    Run Keyword And Return Status    Should Be Equal    ${InputFFCResponse}    ${OutputFFCResponse}
    # Run Keyword If    ${status}==True    Log    Correct!!! Input FFC Response is equal to Output FFC Response. ${InputFFCResponse}=${OutputFFCResponse}
    # ...    ELSE    Log    Incorrect!!! Input FFC Response is NOT equal to Output FFC Response. ${InputFFCResponse}!=${OutputFFCResponse}    level=ERROR
    # Run Keyword And Continue On Failure    FFC UI Verification - TextJMS for Delete User LIQ    &{APIDataSet}[HTTPMethodType]    ${MessageStatus_SENT}    ${APIDataSet}    ${dataset_path}&{APIDataSet}[OutputFilePath]
    # Run Keyword And Continue On Failure    Mx Compare Xml With Baseline File    ${dataset_path}&{APIDataSet}[InputFilePath]&{APIDataSet}[Expected_wsFinalLIQDestination].xml    ${dataset_path}&{APIDataSet}[OutputFilePath]&{APIDataSet}[Actual_wsFinalLIQDestination].xml
    # FFC_Logout
    # Close Browser

# User/SSO FFC Validation for Delete Success - PARTY
    # [Documentation]    Used to validate API in FFC UI for Delete.
    # ...    @author: clanding
    # [Arguments]    ${APIDataSet}    ${lobs}
    # Login to FFC for User    &{APIDataSet}[MDM_FFC_SERVER]:&{APIDataSet}[MDM_FFC_PORT]&{APIDataSet}[MDM_FFC_URL]    &{APIDataSet}[Browser_used]    &{APIDataSet}[MDM_FFC_Username]    &{APIDataSet}[MDM_FFC_Password]
    # FFC UI Verification - OpenAPI for Delete User    ${UsersName}    ${lobs}    ${dataset_path}&{APIDataSet}[OutputFilePath]
    # ...    ${Users_Parent_Entry}    ${UsersRow_Child_Entry}    ${MessageStatus_SUCCESS}    &{APIDataSet}[HTTPMethodType]    &{APIDataSet}[OutputFFCResponse]_PARTY.txt
    # ${InputFFCResponse}    OperatingSystem.Get File    ${dataset_path}&{APIDataSet}[InputFilePath]&{APIDataSet}[InputFFCResponse]_PARTY.txt
    # ${OutputFFCResponse}    OperatingSystem.Get File    ${dataset_path}&{APIDataSet}[OutputFilePath]&{APIDataSet}[OutputFFCResponse]_PARTY.txt
    # ${status}    Run Keyword And Return Status    Should Be Equal    ${InputFFCResponse}    ${OutputFFCResponse}
    # Run Keyword If    ${status}==True    Log    Correct!!! Input FFC Response is equal to Output FFC Response. ${InputFFCResponse}=${OutputFFCResponse}
    # ...    ELSE    Log    Incorrect!!! Input FFC Response is NOT equal to Output FFC Response. ${InputFFCResponse}!=${OutputFFCResponse}    level=ERROR
    # ##add TextJMS checking for PARTY
    # # Run Keyword And Continue On Failure    Mx Compare Xml With Baseline File    ${dataset_path}&{APIDataSet}[InputFilePath]&{APIDataSet}[Expected_wsFinalLIQDestination].xml    ${dataset_path}&{APIDataSet}[OutputFilePath]&{APIDataSet}[Actual_wsFinalLIQDestination].xml
    # FFC_Logout
    # Close Browser

# User/SSO FFC Validation for Delete Success - ALL
    # [Documentation]    Used to validate API in FFC UI for Delete.
    # ...    @author: clanding
    # [Arguments]    ${APIDataSet}    ${lobs}
    # Login to FFC for User    &{APIDataSet}[MDM_FFC_SERVER]:&{APIDataSet}[MDM_FFC_PORT]&{APIDataSet}[MDM_FFC_URL]    &{APIDataSet}[Browser_used]    &{APIDataSet}[MDM_FFC_Username]    &{APIDataSet}[MDM_FFC_Password]
    # FFC UI Verification - OpenAPI for Delete User    ${UsersName}    ${lobs}    ${dataset_path}&{APIDataSet}[OutputFilePath]
    # ...    ${Users_Parent_Entry}    ${UsersRow_Child_Entry}    ${MessageStatus_SUCCESS}    &{APIDataSet}[HTTPMethodType]    &{APIDataSet}[OutputFFCResponse].txt
    # ${InputFFCResponse}    OperatingSystem.Get File    ${dataset_path}&{APIDataSet}[InputFilePath]&{APIDataSet}[InputFFCResponse].txt
    # ${OutputFFCResponse}    OperatingSystem.Get File    ${dataset_path}&{APIDataSet}[OutputFilePath]&{APIDataSet}[OutputFFCResponse].txt
    # ${status}    Run Keyword And Return Status    Should Be Equal    ${InputFFCResponse}    ${OutputFFCResponse}
    # Run Keyword If    ${status}==True    Log    Correct!!! Input FFC Response is equal to Output FFC Response. ${InputFFCResponse}=${OutputFFCResponse}
    # ...    ELSE    Log    Incorrect!!! Input FFC Response is NOT equal to Output FFC Response. ${InputFFCResponse}!=${OutputFFCResponse}    level=ERROR
    # Run Keyword And Continue On Failure    FFC UI Verification - TextJMS for Delete User ALL    &{APIDataSet}[HTTPMethodType]    ${MessageStatus_SENT}    ${APIDataSet}    ${dataset_path}&{APIDataSet}[OutputFilePath]
    # Run Keyword And Continue On Failure    Mx Compare Xml With Baseline File    ${dataset_path}&{APIDataSet}[InputFilePath]&{APIDataSet}[Expected_wsFinalLIQDestination].xml    ${dataset_path}&{APIDataSet}[OutputFilePath]&{APIDataSet}[Actual_wsFinalLIQDestination].xml
    # FFC_Logout
    # Close Browser

# User/SSO FFC Validation for Delete Error - ALL
    # [Documentation]    Used to validate API in FFC UI for Delete.
    # ...    @author: clanding
    # [Arguments]    ${APIDataSet}    ${lobs}
    # Login to FFC for User    &{APIDataSet}[MDM_FFC_SERVER]:&{APIDataSet}[MDM_FFC_PORT]&{APIDataSet}[MDM_FFC_URL]    &{APIDataSet}[Browser_used]    &{APIDataSet}[MDM_FFC_Username]    &{APIDataSet}[MDM_FFC_Password]
    # FFC UI Verification - OpenAPI for Delete User    ${UsersName}    ${lobs}    ${dataset_path}&{APIDataSet}[OutputFilePath]
    # ...    ${Users_Parent_Entry}    ${UsersRow_Child_Entry}    ${MessageStatus_SUCCESS}    &{APIDataSet}[HTTPMethodType]    &{APIDataSet}[OutputFFCResponse].txt

    # ##check for queuename errorLogQueue
    # ${expected_message_SSO}    Set Variable    E_USER_DOES_NOT_EXIST
    # ${expected_message_LIQ}    Set Variable    User ID not on file.
    # ${expected_message_AD}    Catenate    User &{APIDataSet}[userID] couldn't be found.

    # Run Keyword If    '${lobs}'=='ALL' or '${lobs}'=='null'    Run Keywords    Mx Scroll Element Into View    ${TextJMS_Parent_Entry}
    # ...    AND    FFC UI Dashboard - Click TextJMS Row Summary Table
    # ...    AND    Run Keyword And Continue On Failure    FFC UI Dashboard - TextJMS Message Table with no Expected XML and Check Partial Message    SSOUser    &{APIDataSet}[HTTPMethodType]    ${expected_message_SSO}    ${MessageStatus_ERROR}
    # ...    ELSE IF    '${lobs}'=='COMRLENDING'    Run Keywords    Mx Scroll Element Into View    ${TextJMS_Parent_Entry}
    # ...    AND    FFC UI Dashboard - Click TextJMS Row Summary Table
    # ...    AND    Run Keyword And Continue On Failure    FFC UI Dashboard - TextJMS Message Table with no Expected XML and Check Partial Message    LIQUSER    &{APIDataSet}[HTTPMethodType]    ${expected_message_LIQ}    ${MessageStatus_ERROR}
    # ##placeholder for textjms party validation
    # # ...    ELSE IF    '${lobs}'=='PARTY'    Run Keyword And Continue On Failure    FFC UI Dashboard - TextJMS Message Table with no Expected XML and Check Partial Message    ADUser    &{APIDataSet}[HTTPMethodType]    ${expected_message_AD}    ${MessageStatus_ERROR}

    # FFC_Logout
    # Close Browser

# User/SSO FFC Validation for SSO Success for Multiple Input
    # [Documentation]    Used to validate API in FFC UI when expected message is multiple.
    # ...    AD success
    # ...    SSO success
    # ...    LIQ fail
    # ...    @author: jaquitan
    # [Arguments]    ${APIDataSet}    ${expected_message_list}    ${message}
    # Login to FFC for User    &{APIDataSet}[MDM_FFC_SERVER]:&{APIDataSet}[MDM_FFC_PORT]&{APIDataSet}[MDM_FFC_URL]    &{APIDataSet}[Browser_used]    &{APIDataSet}[MDM_FFC_Username]    &{APIDataSet}[MDM_FFC_Password]
    # FFC UI Verification - OpenAPI for User    ${UsersName}    ${dataset_path}&{APIDataSet}[InputFilePath]    ${dataset_path}&{APIDataSet}[OutputFilePath]
    # ...    ${Users_Parent_Entry}    ${UsersRow_Child_Entry}    ${MessageStatus_SUCCESS}    &{APIDataSet}[HTTPMethodType]    &{APIDataSet}[OutputFFCResponse].json
    # Compare_FFC_output_with_response    ${dataset_path}&{APIDataSet}[InputFilePath]   &{APIDataSet}[InputFFCResponse].json    ${FFC_Response}
    # FFC UI Verification - TextJMS for User AD/SSO Success   &{APIDataSet}[HTTPMethodType]    ${MessageStatus_SENT}    ${APIDataSet}    ${dataset_path}&{APIDataSet}[OutputFilePath]

    # ##validate LIQ Fail mutiple times
    # ${INDEX}    Set Variable    0
    # Log    ${expected_message_list}
    # ${expected_message_count}    Get Length    ${expected_message_list}
    # :FOR    ${INDEX}    IN RANGE    ${expected_message_count}
    # \    ${value}    Get From List    ${expected_message_list}    ${INDEX}
    # \    ${expected_message}    Catenate    ${value}    ${message}
    # \    FFC UI Verification - TextJMS for User LIQ Fail    &{APIDataSet}[HTTPMethodType]    ${MessageStatus_ERROR}    ${expected_message}
    # \    Exit For Loop If    '${INDEX}'=='${expected_message_count}'

    # FFC_Logout
    # Close Browser

# User/SSO FFC Validation for SSO Fail
    # [Documentation]    Used to validate API in FFC UI.
    # ...    AD Fail, no user creates
    # ...    @author: jaquitan
    # [Arguments]    ${APIDataSet}    ${expected_message}
    # Login to FFC for User    &{APIDataSet}[MDM_FFC_SERVER]:&{APIDataSet}[MDM_FFC_PORT]&{APIDataSet}[MDM_FFC_URL]    &{APIDataSet}[Browser_used]    &{APIDataSet}[MDM_FFC_Username]    &{APIDataSet}[MDM_FFC_Password]
    # FFC UI Verification - OpenAPI for User    ${UsersName}    ${dataset_path}&{APIDataSet}[InputFilePath]    ${dataset_path}&{APIDataSet}[OutputFilePath]
    # ...    ${Users_Parent_Entry}    ${UsersRow_Child_Entry}    ${MessageStatus_SUCCESS}    &{APIDataSet}[HTTPMethodType]    &{APIDataSet}[OutputFFCResponse].json
    # Compare_FFC_output_with_response    ${dataset_path}&{APIDataSet}[InputFilePath]   &{APIDataSet}[InputFFCResponse].json    ${FFC_Response}
    # FFC UI Verification - TextJMS for User SSO Fail    &{APIDataSet}[HTTPMethodType]    ${MessageStatus_FAILED}    ${expected_message}    ${dataset_path}&{APIDataSet}[OutputFilePath]
    # FFC_Logout
    # Close Browser
    
Read Login ID Value for Post
    [Documentation]    This keyword is use to read LoginID in response file of Post Operations for User API
    ...    @jdelacru    22NOV2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sInputAPIResponse}
    ${ValidateActualValue}    OperatingSystem.Get File    ${dataset_path}${sInputFilePath}${sInputAPIResponse}.${JSON}
    Set Global Variable    ${GETALLAPIRESPONSE}    ${ValidateActualValue}
    ${JSON_Object}    Evaluate    json.loads('''${ValidateActualValue}''')    ${JSON}
    ${loginId_List}    Get Value From Json    ${JSON_Object}    $..loginId
    ${loginId}    Get From List    ${loginId_List}    0
    [Return]    ${loginId}
    
Read Login ID Value for Delete
    [Documentation]    This keyword is use to read LoginID in Input JSON file of Delete Operations for User API
    ...    @jdelacru    22NOV2019    - initial create
    [Arguments]    ${sInputFilePath}    ${InputJson}
    ${ValidateActualValue}    OperatingSystem.Get File    ${dataset_path}${sInputFilePath}${InputJson}.${JSON}
    Set Global Variable    ${GETALLAPIRESPONSE}    ${ValidateActualValue}
    ${JSON_Object}    Evaluate    json.loads('''${ValidateActualValue}''')    ${JSON}
    ${loginId_List}    Get Value From Json    ${JSON_Object}    $..loginId
    ${loginId}    Get From List    ${loginId_List}    0
    [Return]    ${loginId}

    
Filter by Reference Header for Multiple LOB for User
    [Documentation]    This keyword is use to filter FFC instance given parameter and set the ${ID} for multiple user operation
    ...    @author: jdelacru    - initial create
    [Arguments]    ${loginId}    ${Results_Column_Count}    ${sHeaderRefName}
    :FOR    ${ResultsHeaderColIndex}    IN RANGE    1    ${Results_Column_Count}+1
    \    Mx Scroll Element Into View    ${Results_Header}\[${ResultsHeaderColIndex}]${Results_Header_Text}
    \    ${ElementVisible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${Results_Header}\[${ResultsHeaderColIndex}]${Results_Header_Text}
    \    ${HeaderText}    Get Text    ${Results_Header}\[${ResultsHeaderColIndex}]${Results_Header_Text}
    \    Exit For Loop If    '${HeaderText}'=='${sHeaderRefName}'
    Log    ${ResultsHeaderColIndex}
    
    ${ResultsHeaderColIndex_After}    Evaluate    ${ResultsHeaderColIndex}+1
    ${ResultsHeaderColIndex}    Evaluate    ${ResultsHeaderColIndex}-1
    ${ResultsHeaderColIndex_After_Exist}    Run Keyword And Return Status    Page Should Contain Element    ${ResultsHeaderColIndex_After}    
    Run Keyword If    ${ResultsHeaderColIndex_After_Exist}==${True}    Mx Scroll Element Into View    ${Results_FilterPanel}\[${ResultsHeaderColIndex_After}]
    ...    ELSE    Mx Scroll Element Into View    ${Results_FilterPanel}\[${ResultsHeaderColIndex}]
    
    Mx Input Text    ${Results_FilterPanel}\[${ResultsHeaderColIndex}]    ${MULTIPLE_LOB}    
    
    :FOR    ${Index}    IN RANGE    10
    \    ${Status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${Results_Row}
    \    Exit For Loop If    ${Status}==${True}  
    
    ${Results_Row_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Row}
    
    :FOR    ${Row_Index}    IN RANGE    1    ${Results_Row_Count}
    \    Double Click Element    ${Results_Row}\[${Row_Index}]${PerColumnValue}\[27]${TextValue}
    \    Mx Scroll Element Into View    ${Textarea}
    \    ${Value}    Get Value   ${Textarea}
    \    Log    ${Value}
    \    ${TextToValidate}    Set Variable    ${loginId}
    \    ${Status}    Run Keyword And Return Status    Should Contain    ${Value}    ${TextToValidate}
    \    @{ResultsRowList}    Get Results Table Column Value by Header List and Return    ${Row_Index}    ${HEADER_ID}
    \    Exit For Loop If    ${Status}==${True}
    

Filter by Reference Header for Single LOB for User
    [Documentation]    This keyword is use to filter FFC instance given parameter and set the ${ID} for single user method
    ...    @author: jdelacru    - initial create
    ...    @update: jloretiz    29JAN2020    - modify the condition for text to validate to match the loginID with the correct LOB.
    [Arguments]    ${loginId}    ${sHTTPMethod}    ${Results_Row_Count}    ${sLineOfBusiness}=None
    :FOR    ${Row_Index}    IN RANGE    1    ${Results_Row_Count}
    \    Double Click Element    ${Results_Row}\[${Row_Index}]${PerColumnValue}\[5]${TextValue}
    \    Mx Scroll Element Into View    ${Textarea}
    \    ${Value}    Get Value   ${Textarea}
    \    Log    ${Value}
    \    ${TextToValidate}    Set Variable    "loginId":"${loginId}"
    \    ${LOBToValidate}    Set Variable    "lineOfBusiness":"${sLineOfBusiness}"
    # \    ${TextToValidate}    Run Keyword If    '${sHTTPMethod}'=='POST'    Set Variable    "loginId":"${loginId}"
    #      ...    ELSE IF    '${sHTTPMethod}'=='DELETE'    Set Variable    ${loginId}/lobs/${sLineOfBusiness}
    \    ${Status}    Run Keyword And Return Status    Should Contain    ${Value}    ${TextToValidate}
    \    ${Status_LOB}    Run Keyword And Return Status    Should Contain    ${Value}    ${LOBToValidate}
    \    @{ResultsRowList}    Get Results Table Column Value by Header List and Return    ${Row_Index}    ${HEADER_ID}
    \    Exit For Loop If    ${Status}==${True} or ${Status_LOB}==${True}

Validate OpenAPI for User GET API with Token
    [Documentation]    This keyword is used to validate User OpenAPI by searching User API Sourcename and filtering by authentication code
    ...    and getting response API and comparing to request API.
    ...    @author: jloretiz    27AUG2019    - initial create
    ...    @update: amansuet    04SEP2019    - added condition to accept Get All User API. Set Login argument as optional.
    ...    @update: rtarayao    26NOV2019    - modified the keyword name to be specific for SSO enabled environment
    [Arguments]    ${sInputFilePath}    ${sInputAPIResponse}    ${sOutputFilePath}    ${sOutputAPIResponse}    ${sHTTPMethod}    ${sLOB}    ${sLoginId}=None

    ###OpenAPI###
    Wait Until Element Is Visible    ${FFC_Dashboard}    30s
    Go to Dashboard and Click Source API Name    ${USER_SOURCENAME}    ${OPEAPI_INSTANCE}
    ${endPoint}    Run Keyword If    '${sLoginId}'=='None'    Set Variable    ${LOBS}${sLOB}${GETALLUSER_PARAM}
    ...    ELSE    Set Variable    /${sLoginId}${LOBS}${sLOB}${GETSINGLEUSER_PARAM}
    ${ResultsRowList}    Filter by Reference Header and Save Message TextArea and Return Results Row List Value    ${URL}    ${MDM_HOST}${MDM_User_API}${endPoint}
    ...    ${sOutputFilePath}${sOutputAPIResponse}    ${JSON}    ${RESULTSTABLE_STATUS}    ${HTTP_OPERATION}
    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${MESSAGESTATUS_SUCCESSFUL}    ${sHTTPMethod}
    Compare Input and Output File for Delete and Get Users    ${sInputFilePath}    ${sInputAPIResponse}
    @{ResultsRowList}    Get Results Table Column Value by Header List and Return    1    ${HEADER_ID}

Validate OpenAPI for User GET API without Token
    [Documentation]    This keyword is used to validate User OpenAPI by searching User API Sourcename and filtering by authentication code
    ...    and getting response API and comparing to request API.
    ...    @author: rtarayao    26NOV2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sInputAPIResponse}    ${sOutputFilePath}    ${sOutputAPIResponse}    ${sHTTPMethod}    ${sLOB}    ${sLoginId}=None

    ###OpenAPI###
    Wait Until Element Is Visible    ${FFC_Dashboard}    30s
    Go to Dashboard and Click Source API Name    ${USER_SOURCENAME}    ${OPEAPI_INSTANCE}
    ${endPoint}    Run Keyword If    '${sLoginId}'=='None'    Set Variable    ${LOBS}${sLOB}${GETALLUSER_PARAM}
    ...    ELSE    Set Variable    /${sLoginId}${LOBS}${sLOB}${GETSINGLEUSER_PARAM}
    ${ResultsRowList}    Filter by Reference Header and Save Message TextArea and Return Results Row List Value    ${URL}    ${MDM_HOST_NONSSO}${MDM_User_API}${endPoint}
    ...    ${sOutputFilePath}${sOutputAPIResponse}    ${JSON}    ${RESULTSTABLE_STATUS}    ${HTTP_OPERATION}
    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${MESSAGESTATUS_SUCCESSFUL}    ${sHTTPMethod}
    Compare Input and Output File for Delete and Get Users    ${sInputFilePath}    ${sInputAPIResponse}
    @{ResultsRowList}    Get Results Table Column Value by Header List and Return    1    ${HEADER_ID}