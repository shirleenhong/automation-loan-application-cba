*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Create SAPWUL JSON Dictionary
    [Documentation]    This keyword
    ...        @author: hstone    17SEP2019    Initial create
    [Arguments]    ${sJsonKeys}    ${sFileName_KeyIndicator}    @{JsonData}
    ${Dictionary_List}    Create List
    ${JsonKeys_List}    Extract List from a Delimited String    ${sJsonKeys}
    ${Data_Total}    Get Total Data Count    @{JsonData}[0]
    
    :FOR    ${Data_Num}    IN RANGE    ${Data_Total}
    \    ${JsonDictionary}    Set JSON Key Value Pairs    ${JsonKeys_List}    ${JsonData}    ${Data_Num}
    \    Append To List    ${Dictionary_List}    ${JsonDictionary}        
    Log    Dictionary List = ${Dictionary_List}
    [Return]    ${Dictionary_List}
    
Add SAPWUL JSON Nested Dictionary
    [Documentation]    This keyword adds a nested dictionary on a JSON Dictionary.
    ...        @author: hstone    18SEP2019    Initial create
    [Arguments]    ${JsonDictionary_List}    ${sKey}    ${sInternalDictKeys}    @{sInternalDictValues_List}
    ${InternalDictValues_Total}    Get Total Data Count    @{sInternalDictValues_List}[0]
    ${JsonDictionaryResult_List}    Create List
    ${NestedJsonDict_List}    Create List
    
    ${sInternalDictKeys_List}    Extract List from a Delimited String    ${sInternalDictKeys}
    
    :FOR    ${InternalDictValue_Num}    IN RANGE    ${InternalDictValues_Total}
    \    ${JsonDictionary}    Set JSON Key Value Pairs    ${sInternalDictKeys_List}    ${sInternalDictValues_List}    ${InternalDictValue_Num}
    \    Append To List    ${NestedJsonDict_List}    ${JsonDictionary}        
    Log    Dictionary List = ${NestedJsonDict_List}
    
    ${JsonDictionary_List_Total}    Get Length    ${JsonDictionary_List}
    :FOR    ${Dictionary_Num}    IN RANGE    ${JsonDictionary_List_Total}
    \    ${JsonDictionary}    Set Variable    @{JsonDictionary_List}[${Dictionary_Num}]   
    \    ${NestedJsonDict}    Set Variable    @{NestedJsonDict_List}[${Dictionary_Num}]
    \    Set To Dictionary    ${JsonDictionary}    ${sKey}=${NestedJsonDict} 
    \    Append To List    ${JsonDictionaryResult_List}    ${JsonDictionary}
    Log    JsonDictionaryResult_List = ${JsonDictionaryResult_List}    
    [Return]    ${JsonDictionaryResult_List}
    
Set JSON Key Value Pairs
    [Documentation]    This keyword sets the JSON key value pairs to a dictionary.
    ...        @author: hstone    17SEP2019    Initial create
    [Arguments]    ${JsonKey_List}    ${JsonData_List}    ${iPayloadCount}
    ${JsonKeys_Total}    Get Length    ${JsonKey_List}  
    ${JsonDictionary}    Create Dictionary
    :FOR    ${JsonKey_Num}    IN RANGE    ${JsonKeys_Total}
    \    ${JsonValue_List}    Extract List from a Delimited String    @{JsonData_List}[${JsonKey_Num}]
    \    ${key}    Set Variable    @{JsonKey_List}[${JsonKey_Num}]
    \    ${value}    Set Variable    @{JsonValue_List}[${iPayloadCount}]
    \    ${value}    Convert to Boolean Type if String is True of False    ${value} 
    \    Set To Dictionary    ${JsonDictionary}    ${key}=${value}
    Log    JSON Final Dictionary = ${JsonDictionary}
    [Return]  ${JsonDictionary}
    
Add SAPWUL JSON Nested List
    [Documentation]    This keyword adds a nested list on a JSON Dictionary.
    ...        @author: hstone    17SEP2019    Initial create
    [Arguments]    ${JsonDictionary_List}    ${sKey}    ${sInternalDictKeys}    ${sInternalDictValues}
    ${JsonDictionaryResult_List}    Create List
    ${NestedJsonList_List}    Create List
    
    ### Data Extraction ###
    ${Keys_List}    Extract List from a Delimited String    ${sInternalDictKeys}
    ${Value_List}    Extract List from a Delimited String    ${sInternalDictValues}
    
    :FOR    ${item}    IN    @{Value_List}
    \     ${Json_List}    Extract Json Nested List    ${item}    ${Keys_List}
    \     Append To List    ${NestedJsonList_List}    ${Json_List}   
    Log    NestedJsonList_List = ${NestedJsonList_List}
    
    ${JsonDictionary_List_Total}    Get Length    ${JsonDictionary_List}
    :FOR    ${Dictionary_Num}    IN RANGE    ${JsonDictionary_List_Total}
    \    ${JsonDictionary}    Set Variable    @{JsonDictionary_List}[${Dictionary_Num}]    
    \    ${NestedJsonList}    Set Variable    @{NestedJsonList_List}[${Dictionary_Num}]
    \    Set To Dictionary    ${JsonDictionary}    ${sKey}=${NestedJsonList} 
    \    Append To List    ${JsonDictionaryResult_List}    ${JsonDictionary}    
    Log    JsonDictionaryResult_List = ${JsonDictionaryResult_List}
    
    [Return]    ${JsonDictionaryResult_List}  
    
Extract Json Nested List
    [Documentation]    This keyword extracts the Json Nested List from the supplied Json Data.
    ...        @author: hstone    17SEP2019    Initial create
    [Arguments]    ${sListInternalItems}    ${sKey_List}    
    ${JsonInternalList_Items}    Extract JSON Internal List Items    ${sListInternalItems}
    ${JSON_List}    Create List
    Log    Test Log = ${sKey_List}
    Log    JsonInternalList_Items = ${JsonInternalList_Items}
    :FOR    ${item}    IN    @{JsonInternalList_Items}
    \    ${ItemDictionaryValues}    Extract Dictionary Values for a JSON Internal List    ${item}
    \    ${ItemDictionary}    Create Json Dictionary    ${sKey_List}    ${ItemDictionaryValues}
    \    Append To List    ${JSON_List}    ${ItemDictionary}
    ${IsKeyAList}    Set Variable    True
    [Return]    ${JSON_List}
    
Create Json Dictionary
    [Documentation]    This keyword creates a dictionary from a supplied list of keys and values.
    ...        @author: hstone    17SEP2019    Initial create
    [Arguments]    ${sKey_List}    ${sValue_List}
    ${Value_Total}    Get Length    ${sValue_List}
    ${Dictionary}    Create Dictionary 
    Log    Test Log = ${sValue_List}
    :FOR    ${Value_Num}    IN RANGE    ${Value_Total}
    \    ${key}    Set Variable    @{sKey_List}[${Value_Num}]
    \    Log    Test Log = @{sKey_List}[${Value_Num}]
    \    ${value}    Set Variable    @{sValue_List}[${Value_Num}]
    \    ${value}    Convert to Boolean Type if String is True of False    ${value}
    \    Set To Dictionary    ${Dictionary}    ${key}=${value}
    Log    Json Dictionary = ${Dictionary}
    [Return]    ${Dictionary}
    
Extract JSON Internal List Items
    [Documentation]    This keyword extracts the checks and extracts nested Json Data List on an extracted json data.
    ...        @author: hstone    17SEP2019    Initial create
    [Arguments]    ${JsonData}    ${sDelimiter}=None
    ### Delimeter Settings ###
    ${Delimiter}    Run Keyword If    '${sDelimiter}'=='None'    Set Variable    ${EXCELDATA_DELIMITER_LISTITEMS}
    ...    ELSE    Set Variable    ${sDelimiter}   
   
    ${NestedJsonData_List}    Split String    ${JsonData}    ${Delimiter}
    [Return]    ${NestedJsonData_List}
    
Extract Dictionary Values for a JSON Internal List
    [Documentation]    This keyword extracts dictionary values of a JSON Internal List.
    ...        @author: hstone    17SEP2019    Initial create
    [Arguments]    ${JsonData}    ${sDelimiter}=None
    ### Delimeter Settings ###
    ${Delimiter}    Run Keyword If    '${sDelimiter}'=='None'    Set Variable    ${EXCELDATA_DELIMITER_DICTIONARY}
    ...    ELSE    Set Variable    ${sDelimiter}
    
    ${NestedJsonData_List}    Split String    ${JsonData}    ${Delimiter}
    [Return]    ${NestedJsonData_List}
    
Extract List from a Delimited String
    [Documentation]    This keyword extracts List on an excel raw data separated by a token defined. Token is '|' by default
    ...        @author: hstone    17SEP2019    Initial create
    [Arguments]    ${String}    ${sDelimiter}=None
    ### Delimeter Settings ###
    ${Delimiter}    Run Keyword If    '${sDelimiter}'=='None'    Set Variable    ${EXCELDATA_DELIMITER_PIPE}
    ...    ELSE    Set Variable    ${sDelimiter}
    
    ${List}    Split String    ${String}    ${Delimiter}
    [Return]    ${List}
    
Get Total Data Count
    [Documentation]    This keyword gets the total test data count on a given json data sample.
    ...        @author: hstone    17SEP2019    Initial create
    [Arguments]    ${JsonDataCellSample}
    ${JsonDataCellSample_List}    Extract List from a Delimited String    ${JsonDataCellSample}
    ${DataCount}    Get Length    ${JsonDataCellSample_List}
    [Return]    ${DataCount}
    
Save Dictionary List Items to Individual JSON File
    [Documentation]    This keyword is used to save Dictionary List items to individual JSON File
    ...                @author: hstone    18SEP2019    Initial create
    [Arguments]    ${JsonDictionary_List}    ${sFilePath}    ${sFileName}    ${sKey_FileNameSuffix}=None
    Create Directory    ${dataset_path}${sFilePath}
    ${JsonDictionary_Total}    Get Length    ${JsonDictionary_List}
    :FOR    ${JsonDictionary_Num}    IN RANGE    ${JsonDictionary_Total}  
    \    Run Keyword If    '${sKey_FileNameSuffix}'!='None'    Save Dictionary to JSON File with a Key Value File Name Suffix    @{JsonDictionary_List}[${JsonDictionary_Num}]    ${sFilePath}    ${sFileName}    ${sKey_FileNameSuffix}        
         ...    ELSE    Save Dictionary to JSON File    @{JsonDictionary_List}[${JsonDictionary_Num}]    ${sFilePath}    ${sFileName}_${JsonDictionary_Num}

Save Dictionary to JSON File with a Key Value File Name Suffix
    [Documentation]    This keyword is used to save a Dictionary to a JSON File with a key value file name suffix
    ...                @author: hstone    18SEP2019    Initial create
    [Arguments]    ${JsonDictionary}    ${sFilePath}    ${sFileName}    ${sKey_FileNameSuffix}
    ${sValue_FileNameSuffix}    Get From Dictionary    ${JsonDictionary}    ${sKey_FileNameSuffix}
    Save Dictionary to JSON File    ${JsonDictionary}    ${sFilePath}    ${sFileName}_${sValue_FileNameSuffix}
    
Save Dictionary to JSON File
    [Documentation]    This keyword is used to save a Dictionary to a JSON File
    ...                @author: hstone    17SEP2019    Initial create
    [Arguments]    ${JsonDictionary}    ${sFilePath}    ${sFileName}
    ${JSON_File}    Set Variable    ${dataset_path}${sFilePath}${sFileName}.${JSON}
    Log    Json File = ${JSON_File}
    Log    Json Dictionary = ${JsonDictionary}
    ${JSON_Result}    Evaluate    json.dumps(${JsonDictionary})    json
    Log    Json Result = ${JSON_Result}
    Delete File If Exist    ${JSON_File}
    Create File    ${JSON_File}    ${JSON_Result}
    [Return]    ${JSON_File}
    
Save String to JSON File
    [Documentation]    This keyword is used to save a String to a JSON File
    ...                @author: hstone    17SEP2019    Initial create
    [Arguments]    ${JsonString}    ${sFilePath}    ${sFileName}
    ${JSON_File}    Set Variable    ${dataset_path}${sFilePath}${sFileName}.${JSON}
    Log    Json File = ${JSON_File}
    Log    Json String = ${JsonString}
    Delete File If Exist    ${JSON_File}
    Create File    ${JSON_File}    ${JsonString}
    [Return]    ${JSON_File}
    
Validate NO SAPWUL Related Trigger Business Events
    [Documentation]    This keyword is used to validate if there is no SAP WUL Related Triggers at the latest Deal Business Events
    ...                @author: hstone    19SEP2019    Initial create 
    ...                @update: mcastro   10SEP2020    Update screenshot path  
    ### Refresh Business Event Records and Confirm Empty Record Information Window   ###
    mx LoanIQ activate window    ${LIQ_BusinessEventOutput_Window}
    mx LoanIQ maximize    ${LIQ_BusinessEventOutput_Window} 
       
    ### Get Notice Identifier on Event ID Field ###
    ${sNotice_Identifier}    Mx LoanIQ Get Data    ${LIQ_BusinessEventOutput_EventID_Field}    text          
    Log    ${sNotice_Identifier}
    
    ### Verify if Notice Identifier does not exist at the events record ###
    Mx LoanIQ Verify Object Exist    ${LIQ_BusinessEventOutput_Records}    VerificationData="Yes"
    ${Status}    Run Keyword And Return Status    Mx LoanIQ Click Javatree Cell    ${LIQ_BusinessEventOutput_Records}    ${sNotice_Identifier}%${sNotice_Identifier}%Owner ID        
    Run Keyword If    ${Status}==True    Fail    ${sNotice_Identifier} is available
    ...    ELSE    Log    ${sNotice_Identifier} is not found at the Business Event Record
    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Business_Event_Output
    
Validate SAPWUL Related Trigger on Business Events
    [Documentation]    This keyword is used to validate the existing SAPWUL Related trigger at the Business Events
    ...                @author: hstone    09SEP2019    Initial create
    ...                @update: mcastro   10SEP2020    Updated screenshot path   
    ### Refresh Business Event Records and Confirm Empty Record Information Window   ### 
    mx LoanIQ activate window    ${LIQ_BusinessEventOutput_Window}
    mx LoanIQ maximize    ${LIQ_BusinessEventOutput_Window}    
    
    ### Get Notice Identifier on Event ID Field ###
    ${sNotice_Identifier}    Mx LoanIQ Get Data    ${LIQ_BusinessEventOutput_EventID_Field}    text          
    Log    ${sNotice_Identifier}
    
    ### Select the Event Output Record ###
    Mx LoanIQ Verify Object Exist    ${LIQ_BusinessEventOutput_Records}    VerificationData="Yes"
    ${Status}    Run Keyword And Return Status    Mx LoanIQ Click Javatree Cell    ${LIQ_BusinessEventOutput_Records}    ${sNotice_Identifier}%${sNotice_Identifier}%Owner ID        
    Run Keyword If    ${Status}==False    Fail    ${sNotice_Identifier} is not available
    
    ${EventStatus}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_BusinessEventOutput_Records}    ${sNotice_Identifier}%Status%value 
    Run Keyword If    '${EventStatus}'=='Delivered'    Log    Event Status is 'Delivered'
    ...    ELSE    Fail    Event Status is '${EventStatus}' instead of 'Delivered'.
   
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Business_Event_Output

Get Business Event ID
    [Documentation]    This keyword is used to get the Business Event ID entered at the lookup field
    ...                @author: hstone    09SEP2019    Initial create     
    ### Refresh Business Event Records and Confirm Empty Record Information Window   ###
    mx LoanIQ activate window    ${LIQ_BusinessEventOutput_Window}
    mx LoanIQ maximize    ${LIQ_BusinessEventOutput_Window}  
    
    ### Get Notice Identifier on Event ID Field ###
    ${EventID}    Mx LoanIQ Get Data    ${LIQ_BusinessEventOutput_EventID_Field}    text          
    Log    ${EventID}
    
    mx LoanIQ close window    ${LIQ_BusinessEventOutput_Window}    
    [Return]    ${EventID}
    
Validate Business Event XML Section Details
    [Documentation]    This keyword validates the actual XML Section Details at the Business Event Output.
    ...                @author: hstone    18SEP2019    Initial create
    ...                @update: mcastro   10SEP2020    Updated Screenshot path
    [Arguments]    ${sExpectedJsonFilePath}    ${sFileName}    ${sFileName_Suffix}=None    
    mx LoanIQ activate window    ${LIQ_BusinessEventOutput_Window}
    
    ${ExpectedXmlSection_Json}    Run Keyword If    '${sFileName_Suffix}'!='None'    Set Variable    ${dataset_path}${sExpectedJsonFilePath}${sFileName}_${sFileName_Suffix}.${JSON}
    ...    ELSE    Set Variable    ${dataset_path}${sExpectedJsonFilePath}${sFileName}.${JSON} 
    
    ${ActualXmlSection_Json}    Extract XML Section JSON File    ${SAPWUL_EVENTRECORDS_PATH}    ${sFileName}    $..eventTimeStamp
    Log    (Validate Business Event XML Section Details) ActualXmlSection_Json = ${ActualXmlSection_Json}   
    
    Verify SAPWUL JSON Event Timestamp    ${SAPWUL_EVENTRECORDS_PATH}    ${sFileName}    
    Compare SAPWUL JSON Files    ${ExpectedXmlSection_Json}    ${ActualXmlSection_Json}    Expected XML Section JSON    Actual XML Section JSON
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Validate Business Event XML Section Details
    
Extract XML Section JSON File
    [Documentation]    This keyword extracts the JSON String at the XML Section.
    ...                @author: hstone    18SEP2019    Initial create
    [Arguments]    ${sFilePath}    ${sFileName}    @{sKeysToRemove}
    Create Directory    ${dataset_path}${SAPWUL_EVENTRECORDS_PATH}    
    ${EventTxtFile}    Set Variable     ${dataset_path}${SAPWUL_EVENTRECORDS_PATH}${sFileName}.txt
    Log    (Extract XML Section JSON File) EventTxtFile = ${EventTxtFile}
    ### Get XML Section Data ###
    Delete File If Exist    ${EventTxtFile} 
    mx LoanIQ activate window    ${LIQ_BusinessEventOutput_Window}
    Mx Select All Data And Save To Notepad    ${LIQ_BusinessEventOutput_XML_Section}    ${EventTxtFile}
    
    ### Get JSON Data on XML Section's Text File ###
    ${Data}    Get Element Text    ${EventTxtFile}
    ${List}    Split String    ${Data}    "array"
    ${JsonString}    Get From List    ${List}    0
    Log    (Extract XML Section Dictionary) JsonString = ${JsonString}
    
    ${JsonFile}    Save String to JSON File    ${JsonString}    ${sFilePath}    ${sFileName}
    Log    (Extract XML Section JSON Dictionary) JsonFile = ${JsonFile}   
    
    ${JsonObject}    Load JSON From File    ${JsonFile} 
    Log    (Extract XML Section JSON Dictionary) JsonObject = ${JsonObject}
    
    Save Dictionary to JSON File    ${JsonObject}    ${sFilePath}    ${sFileName}
    
    Log    (Extract XML Section JSON Object) sKeysToRemove = @{sKeysToRemove}    
    :FOR    ${key}    IN    @{sKeysToRemove}   
    \    ${JsonObject}    Delete Object From Json    ${JsonObject}    ${key} 
   
    ${XmlSectionJson_Extract}    Save Dictionary to JSON File    ${JsonObject}    ${sFilePath}    ${sFileName}_NoeventTimeStamp 
    [Return]    ${XmlSectionJson_Extract}

Verify SAPWUL JSON Event Timestamp
    [Documentation]    This keyword is used to verify the event timestamp of the JSON file extracted from the XML Section.
    ...    @author: hstone    26SEP2019    initial create
    [Arguments]    ${sFilePath}    ${sFileName}    ${sJsonKeyPath}=None
    ${sExpectedTimeStampKeyPath}    Run Keyword If    '${sJsonKeyPath}'=='None'    Set Variable    ${SAPWUL_JSONKEYPATH_EVENTTIMESTAMP}
    ...    ELSE    Set Variable    ${sJsonKeyPath}
         
    ${JsonFile}    Set Variable     ${dataset_path}${sFilePath}${sFileName}.${JSON}
    
    ${JsonObject}    Load JSON From File    ${JsonFile} 
    Log    (Extract XML Section JSON Dictionary) JsonObject = ${JsonObject} 
     
    ${sEventTimestamp_List}    Get Value From Json    ${JsonObject}    ${sExpectedTimeStampKeyPath}
    ${sEventTimestamp}    Get From List    ${sEventTimestamp_List}    0
    Verify Timestamp Format    ${sEventTimestamp}    ${SAPWUL_FORMAT_EVENTTIMESTAMP}  
            
Compare SAPWUL JSON Files
    [Documentation]    This keyword is used to compare two SAPWUL Json File.
    ...    @author: hstone    12SEP2019    initial create
    ...    @update: mcastro   14SEP2020    Updated validation to reflect failure 
    [Arguments]    ${sJsonFile_1}    ${sJsonFile_2}    ${sJsonFileDetails_1}=None    ${sJsonFileDetails_2}=None
    ${JsonDetails_1}    Run Keyword If    '${sJsonFileDetails_1}'!='None'    Set Variable    (${sJsonFileDetails_1})
    ...    ELSE    Set Variable    (JSON_1)    
    
    ${JsonDetails_2}    Run Keyword If    '${sJsonFileDetails_2}'!='None'    Set Variable    (${sJsonFileDetails_2})
    ...    ELSE    Set Variable    (JSON_2)
    
    ### Open JSON Files to Compare ###
    ${Json_1}    OperatingSystem.Get File    ${sJsonFile_1}
    ${Json_2}    OperatingSystem.Get File    ${sJsonFile_2}
    
    ### JSON Comparison Block ###
    ${IsMatched}    Run Keyword And Continue On Failure    Run Keyword And Return Status    Mx Compare Json Data    ${Json_1}     ${Json_2}
    Run Keyword If    ${IsMatched}==${True}    Log    JSON Files Matched.
    ...    ELSE    Log    ${JsonDetails_1} and ${JsonDetails_2} JSON File did not Matched. ${JsonDetails_1} ${Json_1} != ${JsonDetails_2} ${Json_2}    level=ERROR  
    
Validate FFC Facility Payload
    [Documentation]    This keyword is used to Validate FFC Facility Payload.
    ...    @author: hstone    12SEP2019    initial create
    ...    @update: hstone    26SEP2019    Added Test Case Directory for Extracted Payloads
    ...    @update: rtarayao    20FEB2020    - moved Go to Dashboard and Click Source API Name inside the for loop to cater multiple filtering in FFC.
    [Arguments]    ${sTestCase}    ${sFacilityNames}    ${sFacIds} 
    ${sPayloadsPath}    Set Variable    ${dataset_path}${SAPWUL_FFCPAYLOAD_PATH}
    ${sPayloadsTestCaseFolder}    Set Variable    ${SAPWUL_FFCPAYLOAD_PATH}${sTestCase}\\
    ${sTestCasePayloadsPath}    Set Variable    ${dataset_path}${sPayloadsTestCaseFolder}
    Create Directory    ${sPayloadsPath} 
    Create Directory    ${sTestCasePayloadsPath}  
    ${FacilityName_List}    Extract List from a Delimited String    ${sFacilityNames}
    ${FacIds_List}    Extract List from a Delimited String    ${sFacIds}        
    ${ExpectedPayloadFile_List}    Create List
    ${ActualPayloadFile_List}    Create List 
    ${Facility_Total}    Get Length    ${FacilityName_List} 
    
    ${ExpectedPayloadFile_List}    Get Expected Payload File List    ${SAPWUL_EVENTRECORDS_PATH}    ${sTestCase}    ${FacilityName_List}    $..internal    
    Log    (Validate FFC Facility Payload) ExpectedPayload_List = ${ExpectedPayloadFile_List}                 
    
    ### Navigate to FFC Sapwul Triggers ###
    Login to MCH UI
    Wait Until Element Is Visible    ${FFC_Dashboard}    ${FFC_DASHBOARD_WAITDURATION}
    
    :FOR    ${Facility_Num}    IN RANGE    ${Facility_Total}
    \    Log    (Validate FFC Facility Payload) Facility ID '@{FacIds_List}[${Facility_Num}]'
    \    Go to Dashboard and Click Source API Name    ${SAPWULSENDQMQ_SOURCENAME}    ${SAPWULSENDQMQ_OUTPUTTYPE_SUCCESS}
    \    ${ActualPayloadFile_List}    Get FFC SAPWUL Payload File List    ${HEADER_FACID}    @{FacIds_List}[${Facility_Num}]    ${HEADER_PAYLOAD}    ${sPayloadsTestCaseFolder}  
    \    Log    (Validate FFC Facility Payload) ExpectedPayloadFile_List[${Facility_Num}] = @{ExpectedPayloadFile_List}[${Facility_Num}]       
    \    Compare FFC Expected JSON File to FFC Actual JSON File List    @{ExpectedPayloadFile_List}[${Facility_Num}]    ${ActualPayloadFile_List}
    
    Logout to MCH UI and Close Browser

Get Expected Payload File List
    [Documentation]    This keyword is used Get Expected Payload File.
    ...    @author: hstone    12SEP2019    initial create
    [Arguments]    ${sFilePath}    ${sFileName}    ${sFacilityName_List}    @{sKeysToRemove}
    ${ExpectedPayloadFile_List}    Create List
    ${JsonObject}    Load JSON From File    ${dataset_path}${sFilePath}${sFileName}.${JSON} 
    Log    (Remove JSON Keys) JsonObject = ${JsonObject}
    
    Log    (Remove JSON Keys) sKeysToRemove = @{sKeysToRemove}    
    :FOR    ${key}    IN    @{sKeysToRemove}   
    \    ${JsonObject}    Delete Object From Json    ${JsonObject}    ${key} 
    Log    (Remove JSON Keys) JsonObject = ${JsonObject}
    
    ${Facility_Total}    Get Length    ${sFacilityName_List}
    :FOR    ${Facility_Num}    IN RANGE    ${Facility_Total}
    \    ${ExpectedPayloadFile}    Save Dictionary to JSON File    @{JsonObject}[${Facility_Num}]    ${sFilePath}    @{sFacilityName_List}[${Facility_Num}]
    \    Append To List    ${ExpectedPayloadFile_List}    ${ExpectedPayloadFile}       
    Log    (Get Expected Payload File List) ExpectedPayloadFile_List = ${ExpectedPayloadFile_List}
    [Return]    ${ExpectedPayloadFile_List}

Get FFC SAPWUL Payload File List
    [Documentation]    This keyword is used to the JSON File Names of the actual FFC SAPWUL Payloads.
    ...    @author: hstone    18SEP2019    initial create
    ...    @update: rtarayao    19FEB2020    - added remove string keyword to remove special character of the filename
    ...    @update: mcastro   10SEP2020    Updated screenshot path
    [Arguments]    ${sColumnToFilter}    ${sColumnFilterValue}    ${sColumnToFetch}    ${sFilePathToSave}    @{sKeysToRemove}
    Log    (Get FFC SAPWUL Payload File List) sColumnFilterValue is Facility ID '${sColumnFilterValue}'
    ${ActualPayLoadFile_List}    Create List
    Log    (Get FFC SAPWUL Payload File List) sFilePathToSave = ${sFilePathToSave}
    ${FFCPayload_Search_Result}    Filter by Reference Header and Save Message TextArea and Return Results Row List Value    ${sColumnToFilter}    ${sColumnFilterValue}    ${sFilePathToSave}    
    ...    ${TXT}    ${sColumnToFetch}
    Log    (Get FFC SAPWUL Payload File List) FFCPayload_Search_Result = ${FFCPayload_Search_Result}
    
    ${FFCPayload_Search_Result_Total}    Get Length    ${FFCPayload_Search_Result}
    :FOR    ${Payload_Num}    IN RANGE    ${FFCPayload_Search_Result_Total}
    \    ${ActualPayload_FileName}    Set Variable    Payload_${sColumnFilterValue}_${Payload_Num}
    \    ${Payload_String}    Get From List    @{FFCPayload_Search_Result}[${Payload_Num}]    0    
    \    Log    (Get FFC SAPWUL Payload File) Payload_String = ${Payload_String}
    \    ${ActualPayload_FileName}    Remove String    ${ActualPayload_FileName}    *
    \    ${ActualPayload_File}    Save String to JSON File    ${Payload_String}    ${sFilePathToSave}    ${ActualPayload_FileName}
    \    Log    (Get FFC SAPWUL Payload File) ActualPayload_File = ${ActualPayload_File}
    \    ${ActualPayload_File}    Remove JSON Keys    ${sFilePathToSave}    ${ActualPayload_FileName} 
    \    Log    (Get FFC SAPWUL Payload File) ActualPayload_File After Key Removal = ${ActualPayload_File}   
    \    Append To List    ${ActualPayLoadFile_List}    ${ActualPayload_File}
    \    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Get FFC SAPWUL Payload File List_Payload Save      
    Log    (Get FFC SAPWUL Payload File) ActualPayLoadFile_List = ${ActualPayLoadFile_List}  
    
    Delete Files with File Extension    ${TXT}    ${sFilePathToSave}
    [Return]    ${ActualPayLoadFile_List}
    
Compare FFC Expected JSON File to FFC Actual JSON File List
    [Documentation]    This keyword is used to compare FFC Expected JSON File to FFC Actual JSON File List.
    ...    @author: hstone    18SEP2019    initial create
    [Arguments]    ${sExpectedJsonFile}    ${sActualJsonFile_List}
    ${ExpectedPayloadExists}    Set Variable    False
   
    ${ExpectedJson}    OperatingSystem.Get File    ${sExpectedJsonFile}
    
    Log    (Compare FFC Expected JSON File to FFC Actual JSON File List) sActualJsonFile_List = ${sActualJsonFile_List}
    ${sActualJsonFile_Total}    Get Length    ${sActualJsonFile_List}
    :FOR    ${ActualJsonFile_Num}    IN RANGE    ${sActualJsonFile_Total}
    \    ${ActualJson}    OperatingSystem.Get File    @{sActualJsonFile_List}[${ActualJsonFile_Num}]
    \    Log    (Compare FFC Expected JSON File to FFC Actual JSON File List) ActualJson[${ActualJsonFile_Num}] = ${ActualJson}
    \    ${IsMatched}    Run Keyword And Return Status    Mx Compare Json Data    ${ExpectedJson}     ${ActualJson}
    \    Run Keyword If    ${IsMatched}==${True}    Run Keywords    
         ...    Set Test Variable    ${ExpectedPayloadExists}    True  
         ...    AND    Exit For Loop          
    Log    (Compare FFC Expected JSON File to FFC Actual JSON File List) ExpectedPayloadExists = ${ExpectedPayloadExists}
    
    Run Keyword If    '${ExpectedPayloadExists}'=='True'    Log    Expected Payload Exists at FFC.
    ...    ELSE    Fail    ${sExpectedJsonFile} Payload File does not exist at FFC.
    
Remove JSON Keys
    [Documentation]    This keyword removes keys passed thru a list.
    ...    @author: hstone    18SEP2019    initial create
    [Arguments]    ${sFilePath}    ${sFileName}    @{sKeysToRemove}      
    ${JsonObject}    Load JSON From File    ${dataset_path}${sFilePath}${sFileName}.${JSON} 
    Log    (Remove JSON Keys) JsonObject = ${JsonObject}
    
    Log    (Remove JSON Keys) sKeysToRemove = @{sKeysToRemove}    
    :FOR    ${key}    IN    @{sKeysToRemove}   
    \    ${JsonObject}    Delete Object From Json    ${JsonObject}    ${key} 
    Log    (Remove JSON Keys) JsonObject = ${JsonObject}
    
    ${JSON_File}    Save Dictionary to JSON File    ${JsonObject}    ${sFilePath}    ${sFileName}
    [Return]    ${JSON_File}

Delete Files with File Extension
    [Documentation]    This keyword is used to save a Dictionary to a JSON File
    ...                @author: hstone    17SEP2019    Initial create
    [Arguments]    ${sFileExtension}    ${sFilePath}
    @{FILE_List} =    OperatingSystem.List Files In Directory    ${dataset_path}${sFilePath}    *.${sFileExtension}    absolute
    Log    (Delete Files with File Extension) FILE_List = @{FILE_List}
    :FOR    ${FILE}    IN    @{FILE_List}  
    \    Remove File    ${FILE}  
    \    Log    ${FILE} File is removed.     
