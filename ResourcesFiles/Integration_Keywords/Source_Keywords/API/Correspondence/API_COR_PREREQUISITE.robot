*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Update Key Values of input JSON file for Correspondence API
    [Documentation]    This keyword is used to update key values of JSON file and save to new file.
    ...    @author: cmartill/chanario    DDMMMYYYY    - initial create
    [Arguments]    ${messageId}    ${status}    ${errorMessage}    ${Input_JsonFile}

    ${file_path}    Set Variable    ${templateinput}
    ${EMPTY}    Set Variable
    ${json_object}    Load JSON From File    ${file_path}

    ## add demographic fields here
    ${new_json}    Run Keyword If    '${messageId}'=='null'    Set To Dictionary    ${json_object}    messageId=${NONE}
    ...    ELSE IF    '${messageId}'==''    Set To Dictionary    ${json_object}    messageId=${EMPTY}
    ...    ELSE IF    '${messageId}'=='Empty' or '${messageId}'=='empty'    Set To Dictionary    ${json_object}    messageId=${EMPTY}
    ...    ELSE IF    '${messageId}'=='no tag'    Set Variable    ${json_object}
    ...    ELSE    Set To Dictionary    ${json_object}    messageId=${messageId}

    ${new_json}    Run Keyword If    '${status}'=='null'    Set To Dictionary    ${new_json}    status=${NONE}
    ...    ELSE IF    '${status}'==''    Set To Dictionary    ${new_json}    status=${EMPTY}
    ...    ELSE IF    '${status}'=='Empty' or '${status}'=='empty'    Set To Dictionary    ${new_json}    status=${EMPTY}
    ...    ELSE IF    '${status}'=='no tag'    Set Variable    ${new_json}
    ...    ELSE    Set To Dictionary    ${new_json}    status=${status}

    ${new_json}    Run Keyword If    '${errorMessage}'=='null'    Set To Dictionary    ${new_json}    errorMessage=${NONE}
    ...    ELSE IF    '${errorMessage}'==''    Set To Dictionary    ${new_json}    errorMessage=${EMPTY}
    ...    ELSE IF    '${errorMessage}'=='Empty' or '${errorMessage}'=='empty'    Set To Dictionary    ${new_json}    errorMessage=${EMPTY}
    ...    ELSE IF    '${errorMessage}'=='no tag'    Set Variable    ${new_json}
    ...    ELSE    Set To Dictionary    ${new_json}    errorMessage=${errorMessage}

    Log    ${new_json}
    ${converted_json}    Evaluate    json.dumps(${new_json})        json
    Log    ${converted_json}

    ${jsonfile}    Set Variable    ${Input_JsonFile}
    Delete File If Exist    ${dataset_path}${jsonfile}
    Create File    ${dataset_path}${jsonfile}    ${converted_json}
    ${file}    OperatingSystem.Get File    ${dataset_path}${jsonfile}

Process Fields
    [Documentation]    This keyword is used to process fields with invalid input for minimum field length
    ...    @author: cmartill    21MAR2019    - iniial create
    [Arguments]    ${Input_JsonFile}
    
    #messageId    Mandatory
    ${val}    Get Data from JSON file and handle single data for Correspondence   ${dataset_path}${Input_JsonFile}    messageId    1    40    
    # Run Keyword If    '${val}'=='invalidValue'    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    Correspondence_MessageId
    Run Keyword If    '${val}'=='hasExceeded'    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    3    Correspondence_MessageId
    ...    ELSE IF    '${val}'=='isEmpty' or '${val}'=='isNone'    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    Correspondence_MessageId
    ${MessageIdErrorCheck}    Run Keyword If    '${val}'=='isEmpty' or '${val}'=='isNone'    Get File Size    ${Expected_Err_List}
    ...    ELSE    Set Variable    0

Create Session Correspondence
    [Documentation]    This keyword is used to create session for testing Correspondence API
    ...    @author: jaquitan    21MAR2019    - iniial create

    ${Resp}    Create Session    ${APISESSION}    ${API_CORRES_HOST}
    Log    ${Resp}

Encode and Decode Bytes to String
    [Documentation]    This keyword is used to encode string to bytes then decode Bytes to string
    ...    @author: mcastro    14DEC2020    - Initial Create
    [Arguments]   ${sCorrelationID}

    ### Keyword Pre-processing ###
    ${CorrelationID}    Acquire Argument Value    ${sCorrelationID}

    ${CorrelationIdByte}    Encode String To Bytes    ${CorrelationID}     UTF-8
    ${MessageIdEncode}    B 32 Encode    ${CorrelationIdByte}
    ${MessageIdDecode}    Decode Bytes To String    ${MessageIdEncode}    UTF-8

    [Return]    ${MessageIdDecode}