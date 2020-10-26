*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot


*** Keywords ***

FXRates FFC Validation for TL Success
    [Documentation]    This keyword is used to validate OpenAPI and Distributor in MCH FFC UI.
    ...    @author: mnanquil    06MAR2019    - initial create
    ...    @update: clanding    12JUN2019    - updated Custom Interface to Custom CBA Push validation, added Base Splitter checking
    [Arguments]    ${sInputFilePath}    ${sInputFileName}    ${sInputXML}    ${sOutputFilePath}    ${sOutputFileName}    ${sOutputXML}
    ...    ${sXMLExcelFile}    ${sfundingDeskStatus}    ${sResponse}    ${sResponseMechanism}    ${sFundingDesk}=NY
    Login to MCH UI
    
    ###FX Rate Splitter###
    Wait Until Element Is Visible    ${FFC_Dashboard}    30s
    ${aHeaderRefNameList}    Create List    ${REQUESTS_ID}
    ${aExpectedRefList}    Create List    ${GSFILENAME_WITHTIMESTAMP}
    Go to Dashboard and Click Source API Name    ${FXRATES_ACK_MESSAGE_SPLITTER}    ${CUSTOM_INTERFACE_INSTANCE}
    ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    ${Results_Row_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Row}
    ${RequestID_UI}    Get Results Table Column Value by Header Title and Return    ${Results_Row_Count}    ${REQUESTS_ID}
    ${REQUESTID_VALUE}    Split Request ID From Splitter Queue for TL and Return Final Request ID    ${RequestID_UI}    |
    
    ###OpenAPI###
    Go to Dashboard and Click Source API Name    ${FXRATES_SOURCENAME}    ${OPEAPI_INSTANCE_TL}
    ${ResultsRowList}    Filter by Reference Header and Save Message TextArea and Return Results Row List Value    ${X_REQUEST_ID}    ${REQUESTID_VALUE}    ${sOutputFilePath}${sOutputFileName}    
    ...    ${JSON}    ${RESULTSTABLE_STATUS}    ${CONTENT_TYPE}    ${HTTP_OPERATION}
    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${MESSAGESTATUS_SUCCESSFUL}    ${CONTENT_TYPE_VALUE}    ${POSTMethod}
    Validate FFC JSON File    ${sXMLExcelFile}    ${dataset_path}${sOutputFilePath}${sOutputFileName}_1.json    ${sfundingDeskStatus}    
    
    ###CustomCBAPush###
    Go to Dashboard and Click Source API Name    ${CBAPUSH_SOURCENAME}    ${CBAPUSH_INSTANCE}
    ${aHeaderRefNameList}    Create List    ${JMS_CORRELATION_ID}
    ${aExpectedRefList}    Create List    ${REQUESTID_VALUE}
    ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    ${Results_Row_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Row}
    ${Response_UI}    Get Results Table Column Value by Header Title and Return    ${Results_Row_Count}    ${JMS_PAYLOAD}
    Create File    ${datasetpath}${sOutputFilePath}${sResponse}.${JSON}    ${Response_UI}
    Validate Response from CBA Push Queue    ${sOutputFilePath}${sResponse}    ${REQUESTID_VALUE}    ${POSTMethod}    ${FXRATE_APINAME}    ${OPEARATIONSTATUS_SUCCESS}
    
    ###Distributor###
    Go to Dashboard and Click Source API Name    ${TEXTJMS_SOURCENAME}    ${TEXTJMS_INSTANCE}
    ${ResultsRowList}    ${FileName_List}     Filter by Reference Header and Save Message TextArea and Return Results Row List Value TL FXRates    ${HEADER_CORRELATION_ID}    ${sFundingDesk}    ${sfundingDeskStatus}    ${REQUESTID_VALUE}
    ...    ${sOutputFilePath}${sOutputXML}    ${XML}    ${RESULTSTABLE_STATUS}    ${ROUTEROPERATION}    ${HEADER_CATEGORY}    ${HEADER_OPERATION}
    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${SENT}    ${FXRATES_ROUTEROPTION}    ${FXRATES_CATEGORY}     ${POSTMethod}
    Get TextJMS XML Files and Rename with Funding Desk, From Currency, To Currency, and Compare to Input    ${sInputFilePath}${sInputXML}    ${FileName_List}    ${sOutputFilePath}${sOutputXML}

    ###Response Mechanism###
    Go to Dashboard and Click Source API Name    ${RESPONSE_MECHANISM_SOURCENAME}    ${RESPONSE_MECHANISM_INSTANCE}
     ${ResultsRowList}    Filter by Reference Header and Save Message TextArea for Specified File and Return Results Row List Value    ${DESTINATION}    ${DESTINATION_FX}    ${REQUESTID_VALUE}    ${sOutputFilePath}${sResponseMechanism}
    ...    ${JSON}    ${RESULTSTABLE_STATUS}
    Validate Response Mechanism    ${sOutputFilePath}${sResponseMechanism}    ${REQUESTID_VALUE}    ${POSTMethod}    ${FXRATE_APINAME}    ${OPEARATIONSTATUS_SUCCESS}
    Logout to MCH UI and Close Browser

Validate FFC for TL FXRates Failed
    [Documentation]    This keyword is used to validate CustomCBAPush in MCH FFC UI.
    ...    @author: mnanquil    19MAR2019    - initial create
    ...    @update: cfrancis    21AUG2019    - Changed value to be validated from ${FAILED} to ${MESSAGESTATUS_SUCCESSFUL}    
    ...    @update: clanding    01OCT2020    - removed X-Request-ID= in filtering GSFILENAME_WITHTIMESTAMP
    ...                                      - moved last Verify Expected Value in the Given JSON File for FXRates TL to ELSE FOR isMultipleExpectedResponse condition
    [Arguments]    ${sOutputFilePath}    ${sOutputFileName}    ${sExpectedErrorMsg}    ${isMultipleExpectedResponse}=None
    Login to MCH UI
    Wait Until Element Is Visible    ${FFC_Dashboard}    30s
    ###CustomInterface###
    Go to Dashboard and Click Source API Name    ${CBAPUSH_SOURCENAME}    ${CBAPUSH_INSTANCE}
    ${ResultsRowList}    Filter by Reference Header and Save Header Value and Return Results Row List Value    ${JMS_HEADERS}    ${GSFILENAME_WITHTIMESTAMP}    ${sOutputFilePath}${sOutputFileName}    
    ...    ${JSON}    ${JMS_PAYLOAD}    ${RESULTSTABLE_STATUS}    ${JMS_INBOUND_QUEUE}    
    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${MESSAGESTATUS_SUCCESSFUL}    ${TL_NOTIF_OUT}    
    Verify Expected Value in the Given JSON File for FXRates TL    ${sOutputFilePath}${sOutputFileName}    ${REQUEST_ID}    ${GSFILENAME_WITHTIMESTAMP}
    Verify Expected Value in the Given JSON File for FXRates TL    ${sOutputFilePath}${sOutputFileName}    ${APINAME}    ${FXRATES_APINAME_FAILED}
    Verify Expected Value in the Given JSON File for FXRates TL    ${sOutputFilePath}${sOutputFileName}    ${CONSOLIDATED_STATUS}    ${MESSAGESTATUS_FAILURE}
    Verify Expected Value in the Given JSON File for FXRates TL    ${sOutputFilePath}${sOutputFileName}    ${RESPONSES}    ${FILE_VALIDATION}    ${RESPONSE_DETAILS}    ${MESSAGE_ID}
    Run Keyword If    ${isMultipleExpectedResponse}==${True}    Verify Multiple Expected Value in the Given JSON File for FXRates TL    ${sOutputFilePath}${sOutputFileName}    ${RESPONSES}    ${sExpectedErrorMsg}    ${RESPONSE_DETAILS}    ${RESPONSE_DESC}
    ...    ELSE    Verify Expected Value in the Given JSON File for FXRates TL    ${sOutputFilePath}${sOutputFileName}    ${RESPONSES}    ${sExpectedErrorMsg}    ${RESPONSE_DETAILS}    ${RESPONSE_DESC}
    Verify Expected Value in the Given JSON File for FXRates TL    ${sOutputFilePath}${sOutputFileName}    ${RESPONSES}    ${MESSAGESTATUS_FAILURE}    ${RESPONSE_DETAILS}    ${RESPONSE_STAT}
    Logout to MCH UI and Close Browser

Verify Expected Value in the Given JSON File for FXRates TL
    [Documentation]    This keyword is used to verify if given expected value is existing in the given json file.
    ...    @author: mnanquil    19MAR2019    - initial create
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

FXRates FFC Validation for On Hold Files
    [Documentation]    This keyword is used to validate if there will be no data consumed if future date is set in tl-fxrates
    ...    @author by mnanquil    20MAR2019    - initial create
   [Arguments]    ${sInputFilePath}    ${sInputFileName}    ${sInputXML}    ${sOutputFilePath}    ${sOutputFileName}    ${sOutputXML}    ${sXMLExcelFile}
    Login to MCH UI
    ###OpenAPI###
    Wait Until Element Is Visible    ${FFC_Dashboard}    30s
    Go to Dashboard and Click Source API Name    ${FXRATES_SOURCENAME}    ${OPEAPI_INSTANCE_TL}
    ${status}    Run Keyword And Return Status    TL FXRates Filter by Reference Header and Save Message TextArea    ${X_REQUEST_ID}    ${GSFILENAME_WITHTIMESTAMP}    ${sOutputFilePath}${sOutputFileName}    
    ...    ${JSON}    ${RESULTSTABLE_STATUS}    ${CONTENT_TYPE}    ${HTTP_OPERATION}
    Run Keyword If    '${status}'==${False}    Run Keyword And Continue on Failure    Fail    Data has been consumed in FFC.
    Run Keyword If    '${status}'==${True}    Log    No data has been consumed in FFC.  
    
    ###CustomInterface###
    Go to Dashboard and Click Source API Name    ${CBAINTERFACE_SOURCENAME_FXRATES}    ${CBAINTERFACE_INSTANCE}
    ${status}    Run Keyword And Return Status    TL FXRates Filter by Reference Header and Save Message TextArea    ${JMS_CORRELATION_ID}    ${GSFILENAME_WITHTIMESTAMP}    ${sOutputFilePath}${TEMPLATE_TEXTFILE}    
    ...    ${TXT}    ${RESULTSTABLE_STATUS}    ${JMS_INBOUND_QUEUE}    ${HTTPSTATUS}    ${OPERATION_STATUS}
    Run Keyword If    '${status}'==${True}    Run Keyword And Continue on Failure    Fail    Data has been consumed in FFC. Please check the effective date if it's greater than LIQ Date.
    Run Keyword If    '${status}'==${False}    Log    No data has been consumed in FFC.  
   
    ###Distributor###
    Go to Dashboard and Click Source API Name    ${TEXTJMS_SOURCENAME}    ${TEXTJMS_INSTANCE}
    ${status}    Run Keyword And Return Status    TL FXRates Filter by Reference Header and Save Message TextArea    ${HEADER_CORRELATION_ID}    ${GSFILENAME_WITHTIMESTAMP}    ${GSFILENAME_WITHTIMESTAMP}
    ...    ${sOutputFilePath}${sOutputXML}    ${XML}    ${RESULTSTABLE_STATUS}    ${ROUTEROPERATION}    ${HEADER_CATEGORY}    ${HEADER_OPERATION}
    Run Keyword If    '${status}'==${True}    Run Keyword And Continue on Failure    Fail    Data has been consumed in FFC. Please check the effective date if it's greater than LIQ Date.
    Run Keyword If    '${status}'==${False}    Log    No data has been consumed in FFC.  
    Logout to MCH UI and Close Browser
    
TL FXRates Filter by Reference Header and Save Message TextArea
    [Documentation]    This keyword is used to search Header Reference and filter using Expected Reference Value.
    ...    @author: mnanquil    20MAR2019    - initial create
    [Arguments]    ${sHeaderRefName}    ${sExpectedRefValue}    ${sOutputFilePath}    ${sFileExtension}    @{aHeaderNames}
    ${Results_Column_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Header}
    ${Results_Row_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Row}
    :FOR    ${ResultsHeaderColIndex}    IN RANGE    1    ${Results_Column_Count}+1
    \    Mx Scroll Element Into View    ${Results_Header}[${ResultsHeaderColIndex}]${Results_Header_Text}
    \    Wait Until Element Is Visible    ${Results_Header}[${ResultsHeaderColIndex}]${Results_Header_Text}
    \    ${HeaderText}    Get Text    ${Results_Header}[${ResultsHeaderColIndex}]${Results_Header_Text}
    \    Exit For Loop If    '${HeaderText}'=='${sHeaderRefName}'
    Log    ${ResultsHeaderColIndex}
    
    ${ResultsHeaderColIndex_After}    Evaluate    ${ResultsHeaderColIndex}+1
    ${ResultsHeaderColIndex}    Evaluate    ${ResultsHeaderColIndex}-1
    ${ResultsHeaderColIndex_After_Exist}    Run Keyword And Return Status    Page Should Contain Element    ${ResultsHeaderColIndex_After}    
    Run Keyword If    ${ResultsHeaderColIndex_After_Exist}==${True}    Mx Scroll Element Into View    ${Results_FilterPanel}[${ResultsHeaderColIndex_After}]
    ...    ELSE    Mx Scroll Element Into View    ${Results_FilterPanel}[${ResultsHeaderColIndex}]
    Mx Input Text    ${Results_FilterPanel}[${ResultsHeaderColIndex}]    ${sExpectedRefValue}
    Wait Until Element Is Visible    ${Results_Row}    
    
    ${Multiple_List}    Create List    
    ${Results_Row_Count_With_Ref}    SeleniumLibraryExtended.Get Element Count    ${Results_Row}
    Set Global Variable    ${RESULTS_ROW_WITHREF}    ${Results_Row_Count_With_Ref}
    :FOR    ${ResultsRowIndex_Ref}    IN RANGE    1    ${Results_Row_Count_With_Ref}+1
    \    @{ResultsRowList}    Get Results Table Column Value by Header List and Return    ${ResultsRowIndex_Ref}    @{aHeaderNames}
    \    Append To List    ${Multiple_List}    ${ResultsRowList}    
    \    Element Should Not Be Visible    ${Results_Row}[${ResultsRowIndex_Ref}]${PerColumnValue}[${ResultsHeaderColIndex}]${TextValue}
    \    Get Message TextArea Value and Save to File    ${sOutputFilePath}    ${ResultsRowIndex_Ref}    ${ResultsHeaderColIndex}    ${sFileExtension}


Validate FFC for TL FX Rate Success with Multiple Files
    [Documentation]    This keyword is used to validate OpenAPI and Distributor in MCH FFC UI.
    ...    @author: cfrancis    01AUG2019    - initial create
    ...    @update: nbautist    07OCT2020    - new argument to replace incorrect input parameter; removed incorrect index; updated file extension
    ...    @update: jdelacru    26OCT2020    - added new argument FileNameWithTimeStamp
    ...                                      - deleted evaluating value of Result_Row_Count
    ...                                      - added creating list for aExpectedRefList for correct argument type
    [Arguments]    ${sInputFilePath}    ${sInputFileName}    ${sInputXML}    ${sOutputFilePath}    ${sOutputFileName}    ${sOutputXML}
    ...    ${sXMLExcelFile}    ${sfundingDeskStatus}    ${sResponse}    ${sResponseMechanism}    ${iIndex}    ${sInputGSFile}    ${FileNameWithTimeStamp}=None    ${sFundingDesk}=NY    ${Delimiter}=None
    Login to MCH UI
    Pause Execution
    
    ###FX Rate Splitter###
    @{InputGSFile_List}    Run Keyword If    '${Delimiter}'=='None'    Split String    ${sInputGSFile}    ,
    ...    ELSE    Split String    ${sInputGSFile}    ${Delimiter}
    ${InputGSFile_Count}    Get Length    ${InputGSFile_List}
    Wait Until Element Is Visible    ${FFC_Dashboard}    30s
    ${aHeaderRefNameList}    Create List    ${REQUESTS_ID}
    ${aExpectedRefList}    Create List
    Append to List    ${aExpectedRefList}    ${FileNameWithTimeStamp}
    Go to Dashboard and Click Source API Name    ${FXRATES_ACK_MESSAGE_SPLITTER}    ${CUSTOM_INTERFACE_INSTANCE}
    ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    ${Results_Row_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Row}
    ${Row_Count_Diff}    Evaluate    ${Results_Row_Count} - ${InputGSFile_Count}
    ${Results_Row_Count_Temp}    Evaluate    ${Results_Row_Count} - ${Row_Count_Diff}
    ${Results_Row_Count}    Set Variable If    ${Results_Row_Count} > ${InputGSFile_Count}    ${Results_Row_Count_Temp}    ${Results_Row_Count}  
    ${RequestID_UI}    Get Results Table Column Value by Header Title and Return    ${Results_Row_Count}    ${REQUESTS_ID}
    ${REQUESTID_VALUE}    Split Request ID From Splitter Queue for TL and Return Final Request ID    ${RequestID_UI}    |   
      
    ###OpenAPI###
    Go to Dashboard and Click Source API Name    ${FXRATES_SOURCENAME}    ${OPEAPI_INSTANCE_TL}
    ${ResultsRowList}    Filter by Reference Header and Save Message TextArea and Return Results Row List Value    ${X_REQUEST_ID}    ${REQUESTID_VALUE}    ${sOutputFilePath}${sOutputFileName}    
    ...    ${JSON}    ${RESULTSTABLE_STATUS}    ${CONTENT_TYPE}    ${HTTP_OPERATION}
    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${MESSAGESTATUS_SUCCESSFUL}    ${CONTENT_TYPE_VALUE}    ${POSTMethod}
    Validate FFC JSON File    ${sXMLExcelFile}    ${dataset_path}${sOutputFilePath}${sOutputFileName}_1.json    ${sfundingDeskStatus}    
    
    ###CustomCBAPush###
    Go to Dashboard and Click Source API Name    ${CBAPUSH_SOURCENAME}    ${CBAPUSH_INSTANCE}
    ${aHeaderRefNameList}    Create List    ${JMS_CORRELATION_ID}
    ${aExpectedRefList}    Create List    ${REQUESTID_VALUE}
    ${ColumnIndex}    Filter by Multiple Reference Headers and Values and Return Column Index    ${aHeaderRefNameList}    ${aExpectedRefList}
    ${Results_Row_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Row}
    ${Response_UI}    Get Results Table Column Value by Header Title and Return    ${Results_Row_Count}    ${JMS_PAYLOAD}
    Create File    ${datasetpath}${sOutputFilePath}${sResponse}.${JSON}    ${Response_UI}
    Validate Response from CBA Push Queue    ${sOutputFilePath}${sResponse}    ${REQUESTID_VALUE}    ${POSTMethod}    ${FXRATE_APINAME}    ${OPEARATIONSTATUS_SUCCESS}
    
    ###Distributor###
    Go to Dashboard and Click Source API Name    ${TEXTJMS_SOURCENAME}    ${TEXTJMS_INSTANCE}
    ${ResultsRowList}    ${FileName_List}     Filter by Reference Header and Save Message TextArea and Return Results Row List Value TL FXRates    ${HEADER_CORRELATION_ID}    ${sFundingDesk}    ${sfundingDeskStatus}    ${REQUESTID_VALUE}
    ...    ${sOutputFilePath}${sOutputXML}    ${XML}    ${RESULTSTABLE_STATUS}    ${ROUTEROPERATION}    ${HEADER_CATEGORY}    ${HEADER_OPERATION}
    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${SENT}    ${FXRATES_ROUTEROPTION}    ${FXRATES_CATEGORY}     ${POSTMethod}
    Get TextJMS XML Files and Rename with Funding Desk, From Currency, To Currency, and Compare to Input    ${sInputFilePath}${sInputXML}    ${FileName_List}    ${sOutputFilePath}${sOutputXML}

    ###Response Mechanism###
    Go to Dashboard and Click Source API Name    ${RESPONSE_MECHANISM_SOURCENAME}    ${RESPONSE_MECHANISM_INSTANCE}
    ${ResultsRowList}    Filter by Reference Header and Save Message TextArea for Specified File and Return Results Row List Value    ${DESTINATION}    ${DESTINATION_FX}    ${REQUESTID_VALUE}    ${sOutputFilePath}${sResponseMechanism}
    ...    ${JSON}    ${RESULTSTABLE_STATUS}
    Validate Response Mechanism    ${sOutputFilePath}${sResponseMechanism}    ${REQUESTID_VALUE}    ${POSTMethod}    ${FXRATE_APINAME}    ${OPEARATIONSTATUS_SUCCESS}
    
    Logout to MCH UI and Close Browser
    
Validate Multiple Files for Success on TL FX Rates in FFC
    [Documentation]    This keyword is used to validate multiple FX Rates files in FFC
    ...    @author: cfrancis    01AUG2019    - initial create
    ...    @update: nbautist    08OCT2020    - updated extension
    ...    @update: jdelacru    26OCT2020    - added getting the value from list for GSFILENAME_WITHTIMESTAMP to be assigned to new argument FileNameWithTimeStamp
    [Arguments]    ${sInputFilePath}    ${sInputFileName}    ${sInputXML}    ${sOutputFilePath}    ${sOutputFileName}    ${sOutputXML}
    ...    ${sXMLExcelFile}    ${sfundingDeskStatus}    ${sResponse}    ${sResponseMechanism}    ${sInputGSFile}    ${sFundingDesk}    ${Delimiter}=None
    @{InputGSFile_List}    Run Keyword If    '${Delimiter}'=='None'    Split String    ${sInputGSFile}    ,
    ...    ELSE    Split String    ${sInputGSFile}    ${Delimiter}
    ${InputGSFile_Count}    Get Length    ${InputGSFile_List}
    @{XMLExcelFile_NoExt}    Split String    ${sXMLExcelFile}    .
    ${sXMLExcelFile_NoExt}    Set Variable    @{XMLExcelFile_NoExt}[0]
    :FOR    ${Index}    IN RANGE    ${InputGSFile_Count}
    \    ${FileNameWithTimeStamp}    Get From List    ${GSFILENAME_WITHTIMESTAMP}    ${Index}
    \    Validate FFC for TL FX Rate Success with Multiple Files    ${sInputFilePath}    ${sInputFileName}_${Index}    ${sInputXML}_${Index}    ${sOutputFilePath}    ${sOutputFileName}_${Index}    ${sOutputXML}_${Index}
         ...    ${sXMLExcelFile_NoExt}${Index}.${XLSX}    ${fundingDeskStatus}    ${sResponse}_${Index}    ${sResponseMechanism}_${Index}    ${Index}    ${sInputGSFile}    ${FileNameWithTimeStamp}    ${sFundingDesk}
    Set Global Variable    ${COUNTER}    ${Index}

Verify Multiple Expected Value in the Given JSON File for FXRates TL
    [Documentation]    This keyword is used to validate multiple expected value in the given JSON file.
    ...    @author: dahijara    7FEB2020    - initial create
    [Arguments]    ${sFilePath}    ${sKeyField}    ${sExpectedValue}    ${sSubKeyField_Initial}=None    ${sSubKeyField_Final}=None
    
    ${JSON_Object}    Load JSON From File    ${dataset_path}${sFilePath}.json
    Log    ${sExpectedValue}
    ${expectedValueCount}    Get Length    ${sExpectedValue}
    
    :FOR    ${index}    IN RANGE    ${expectedValueCount}
    \    Log    @{sExpectedValue}[${index}]
    \    ${isMatched}    Run Keyword And Return Status    Verify Expected Value in the Given JSON File for FXRates TL    ${sFilePath}    ${sKeyField}    @{sExpectedValue}[${index}]    ${sSubKeyField_Initial}    ${sSubKeyField_Final}
    \    ${ExpectedValue_Final}    Run Keyword If    ${isMatched}==${True}    Set Variable    @{sExpectedValue}[${index}]
    \    Exit For Loop If    ${isMatched}==${True}

    Run Keyword If    ${isMatched}==${True}    Log    ${sKeyField} value is '&{JSON_Object}[${sKeyField}]'. Expected: '${ExpectedValue_Final}' is existing in Output: '&{JSON_Object}[${sKeyField}]'.
    ...    ELSE    Fail    ${sKeyField} value is '&{JSON_Object}[${sKeyField}]'. Expected: Any of these response description '${sExpectedValue}' is NOT existing in Output: '&{JSON_Object}[${sKeyField}]'.
