*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Validate FFC CBACorrespUpdateMQ API
    [Documentation]    This keyword navigates to FFC and Validate the Notice.
    ...    @author: mgaling     DDMMMYYYY    - initial create
    ...    @update: jaquitan    20Mar2019    - updated keywords name
    ...    @update: ehugo       16SEP2019    - added argument for Filter by Reference Header and Save Message TextArea and Return Results Row List Value
    ...    @update: amansuet    27NOV2019    - updated keyword for UTF UPGRADE 4.0
    ...    @update: jloretiz    13JUL2019    - updated documentation
    [Arguments]    ${sCorrelation_id}    ${sOutputFilePath}    ${sOutputFileName}   
    
    Login to MCH UI
    ${CorrelationIdByte}    Encode String To Bytes    ${sCorrelation_id}     UTF-8   
    ${CorrelationIdEncode}    B 32 Encode    ${CorrelationIdByte}
    Wait Until Element Is Visible    ${FFC_Dashboard}    30s
    Go to Dashboard and Click Source API Name    ${CBACORRESPUPDATEMQ_SOURCENAME}    ${CBACorrespUpdateMQ_Instance}
    Log    ${RESULTSTABLE_STATUS}
    ${ResultsRowList}    Filter by Reference Header and Save Message TextArea and Return Results Row List Value    ${RESULTTABLEHEADERS}    correlationid=${CorrelationIdEncode}    ${sOutputFilePath}${sOutputFileName}    
    ...    ${TXT}    ${RESULTSTABLE_STATUS}
    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${MESSAGESTATUS_SUCCESSFUL}
    Logout FFC Correspondence

Validate FFC Processing CBACorrespUpdateMQ API
    [Documentation]    This keyword navigates to FFC and Validate the Notice is currently in Processing status.
    ...    @author: cfrancis
    ...    @update: jaquitan 20Mar2019    updated keywords name
    ...    @update: ehugo    16SEP2019    added argument for Filter by Reference Header and Save Message TextArea and Return Results Row List Value
    [Arguments]    ${sCorrelation_id}    ${sOutputFilePath}    ${sOutputFileName}   
    
    Login FFC Correspondence   
    ${CorrelationIdEncode}    B 32 Encode    ${sCorrelation_id}
    Wait Until Element Is Visible    ${FFC_Dashboard}    30s
    Go to Dashboard and Click Source API Name    ${CBACORRESPUPDATEMQ_SOURCENAME}    ${CBACorrespUpdateMQ_Instance}
    ${ResultsRowList}    Filter by Reference Header and Save Message TextArea and Return Results Row List Value    ${RESULTTABLEHEADERS}    correlationid=${CorrelationIdEncode}    ${sOutputFilePath}${sOutputFileName}    
    ...    ${TXT}    ${RESULTSTABLE_STATUS}
    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${MESSAGESTATUS_ERROR}
    Logout FFC Correspondence

Validate FFC FFC1CMUpdateSourceMQ
    [Documentation]    This keyword navigates to FFC and Validate the Notice.
    ...    @author: mgaling     DDMMMYYYY    - initial create
    ...    @update: jaquitan    20MAR2019    - updated keywords name
    ...    @update: ehugo       16SEP2019    - added argument for Filter by Reference Header and Save Message TextArea and Return Results Row List Value
    [Arguments]    ${dOutput_JSONFile}    ${sMessageId}    ${sOutputFilePath}    ${sOutputFileName}     
    
    ${OutputResponsePayload}    OperatingSystem.Get File    ${dOutput_JSONFile}
    Login to MCH UI
    Wait Until Element Is Visible    ${FFC_Dashboard}    30s
    Go to Dashboard and Click Source API Name    ${FFC1CMUPDATESOURCEMQ_SOURCENAME}    ${FFC1CMUpdateSourceMQ_Instance}
    ${ResultsRowList}    Filter by Reference Header and Save Message TextArea and Return Results Row List Value    ${RESULTTABLECORELATIONID}    ${sMessageId}    ${sOutputFilePath}${sOutputFileName}    
    ...    ${TXT}    ${RESULTSTABLE_STATUS}
    Validate Results Row Values Using Expected Value List    ${ResultsRowList}    ${MESSAGESTATUS_SUCCESSFUL}
    Logout FFC Correspondence
    
Validate FFC Missing FFC1CMUpdateSourceMQ
    [Documentation]    This keyword navigates to FFC and Validate the Notice is not present.
    ...    @author: cfrancis
    ...    @update: jaquitan 20Mar2019    updated keywords name
    ...    @update: ehugo    23AUG2019    uncomment keyword and update steps for proper validation of missing FFC1CMUpdateSourceMQ
    ...    @update: ehugo    04SEP2019    added retrieving of status while clicking the instance. If instance is not available, then it will return as pass.
    ...    @update: ehugo    16SEP2019    added argument for Filter by Reference Header and Save Message TextArea and Return Results Row List Value
    [Arguments]    ${Output_JSONFile}    ${sMessageId}    ${sOutputFilePath}    ${sOutputFileName}     
    
    ${OutputResponsePayload}    OperatingSystem.Get File    ${Output_JSONFile}
    Login FFC Correspondence
    Wait Until Element Is Visible    ${FFC_Dashboard}    30s
    ${Status}    Run Keyword And Return Status    Go to Dashboard and Click Source API Name    ${FFC1CMUPDATESOURCEMQ_SOURCENAME}    ${FFC1CMUpdateSourceMQ_Instance}
    Run Keyword If    ${Status}==False    Log    FFC1CMUpdateSourceMQ instance is not available.
    Run Keyword If    ${Status}==False    Logout FFC Correspondence
    Run Keyword If    ${Status}==False    Return From Keyword    
    ${ResultsRowList}    Filter by Reference Header and Save Message TextArea and Return Results Row List Value    ${RESULTTABLECORELATIONID}    ${sMessageId}    ${sOutputFilePath}${sOutputFileName}    
    ...    ${TXT}    ${RESULTSTABLE_STATUS}
    
    ${list_isEmpty}    Run Keyword And Return Status    Should Be Empty    ${ResultsRowList}
    Run Keyword If     ${list_isEmpty}==False    Fail    Entry found in FFC FFC1CMUpdateSourceMQ.
    
    Logout FFC Correspondence