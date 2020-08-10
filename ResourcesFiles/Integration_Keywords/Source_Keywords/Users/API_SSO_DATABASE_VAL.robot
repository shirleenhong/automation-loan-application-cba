*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Create Query for Essence Global User and Validate User is Not Existing
    [Documentation]    This keyword is used to create a/an SQL Query for User in Essence Global and validates if user is not existing.
    ...    @author: xmiranda    24JUL2019    - initial create
    ...    @update: dahijara        30JUL2019    - remove get length functionalty as the query keyword will now return the actual row count of the query results.
    [Arguments]    ${sLoginID}

    
    ${QUERY_USERID}    Catenate    ${SELECT_Q}    ${ESSENCE_GLOBAL_BFNAMEPK}
    ...    ${FROM_Q}    ${ESSENCE_GLOBAL_BANKFUSION_SCHEMA}.${ESSENCE_GLOBAL_BFTB_USER}    ${WHERE_Q}
    ...    ${ESSENCE_GLOBAL_BFNAMEPK}    =    '${sLoginID}'

    ${RESULTS_COUNT}    Connect To Essence Global Database And Return Row Count     ${QUERY_USERID}
    
    Run Keyword If    ${RESULTS_COUNT} == 0    Log    User ${sLoginID} not found in Essence Global Database
    ...    ELSE    Log    User ${sLoginID} should not be created in Essence Global Database    level=ERROR  

    
Create Query for Party User and Validate User is Not Existing
    [Documentation]    This keyword is used to create a/an SQL Query for User in Essence Global and validates if user is not existing.
    ...    @author: xmiranda    24JUL2019    - initial create
    ...    @update: dahijara        30JUL2019    - remove get length functionalty as the query keyword will now return the actual row count of the query results.
    [Arguments]    ${sLoginID}

    
    ${QUERY_USERID}    Catenate    ${SELECT_Q}    ${PARTY_BFNAMEPK}
    ...    ${FROM_Q}    ${PARTY_BANKFUSION_SCHEMA}.${PARTY_BFTB_USER}    ${WHERE_Q}
    ...    ${PARTY_BFNAMEPK}    =    '${sLoginID}'

    ${RESULTS_COUNT}    Connect to Party Database and Return Row Count     ${QUERY_USERID}
    
    Run Keyword If    ${RESULTS_COUNT} == 0    Log    User ${sLoginID} not found in Party Database
    ...    ELSE    Log    User ${sLoginID} should not be created in Party Database    level=ERROR

    
    
Create Query for LIQ and Validate User is Not Existing
    [Documentation]    This keyword is used to create a/an SQL Query for User in Essence Global and validates if user is not existing.
    ...    @author: xmiranda    24JUL2019    - initial create
    [Arguments]    ${sLoginID}

    
    ${QUERY_USERID}    Catenate    ${SELECT_Q}    ${LOANIQ_UPT_UID_USERID}
    ...    ${FROM_Q}    ${LOANIQ_LIQ7474_SCHEMA}.${LOANIQ_TLS_USER_PROFILE}    ${WHERE_Q}
    ...    ${LOANIQ_UPT_UID_USERID}    =    '${sLoginID}'
    
    ${RESULTS_COUNT}    Connect to LIQ Database and Return Row Count     ${QUERY_USERID}
    
    Run Keyword If    ${RESULTS_COUNT} == 0    Log    User ${sLoginID} not found in LIQ Database
    ...    ELSE    Log    User ${sLoginID} should not be created in LIQ Database    level=ERROR

Create Query for All Users per LOB and Return Total Count
    [Documentation]    This keyword is used to create an SQL Query to get total count of users per lob.
    ...    @author: amansuet    02SEP2019    - initial create
    [Arguments]    ${sLineOfBusiness}

    ${sLineOfBusiness}    Convert To Uppercase    ${sLineOfBusiness}

    ${QUERY_LIQ_COUNT}    Catenate    ${SELECT_Q}    *
    ...    ${FROM_Q}    ${LOANIQ_LIQ7474_SCHEMA}.${LOANIQ_TLS_USER_PROFILE}

    ${QUERY_ESSENCE_COUNT}    Catenate    ${SELECT_Q}    *
    ...    ${FROM_Q}    ${ESSENCE_GLOBAL_BANKFUSION_SCHEMA}.${ESSENCE_GLOBAL_BFTB_USER}

    ${QUERY_PARTY_COUNT}    Catenate    ${SELECT_Q}    *
    ...    ${FROM_Q}    ${PARTY_BANKFUSION_SCHEMA}.${PARTY_BFTB_USER}    ${WHERE_Q}
    ...    ${PARTY_BFRECDELETETDATE}    =    '0'

    ${TOTAL_RESULTS_COUNT}    Run Keyword If    '${sLineOfBusiness}'=='${COMRLENDING}'    Connect to LIQ Database and Return Row Count    ${QUERY_LIQ_COUNT}
    ...    ELSE IF    '${sLineOfBusiness}'=='${COREBANKING}'    Connect to Essence Global Database and Return Row Count    ${QUERY_ESSENCE_COUNT}
    ...    ELSE IF    '${sLineOfBusiness}'=='${PARTY}'    Connect to Party Database and Return Row Count    ${QUERY_PARTY_COUNT}

    [Return]    ${TOTAL_RESULTS_COUNT}

Validate Created User in LIQ Database
    [Documentation]    This keyword is used validate if the user is created in LOAN IQ database.
    ...    @author: dahijara    22JUL2019    - initial create
    ...    @update: dahijara    29JUL2019    - added 'isExist' argument and if condition statements to handle negative testing
    [Arguments]    ${sLoginId}    ${bIsExist}=True
    ${iCtr}    Set Variable        1
    :FOR	${iCtr}    IN RANGE    10        #10 is equal to the max number of try the function will query
    \    ${ResultsCount}    Create Query for LIQ User and Return Results Count    ${sLoginId}    
    \    Run Keyword If    ${ResultsCount}==1    Exit For Loop
         ...    ELSE    Log To Console    Try ${iCtr}: '${sLoginId}' not found.

    Run Keyword If    ${ResultsCount}==1 and ${bIsExist}==${True}    Log    User '${sLoginId}' is created in LIQ.
    ...    ELSE IF    ${ResultsCount}==0 and ${bIsExist}==${True}    Fail    User '${sLoginId}' is not created in LIQ.
    ...    ELSE IF    ${ResultsCount}==1 and ${bIsExist}==${False}    Fail    User '${sLoginId}' is created in LIQ.
    ...    ELSE IF    ${ResultsCount}==0 and ${bIsExist}==${False}    Log    User '${sLoginId}' is not created in LIQ.


Validate Created User in Essence Database
    [Documentation]    This keyword is used validate if the user is created in Essence database.
    ...    @author: dahijara    22JUL2019    - initial create
    ...	@update: dahijara    29JUL2019    - added 'isExist' argument and if condition statements to handle negative testing
    [Arguments]    ${sLoginId}    ${bIsExist}=True
    ${iCtr}    Set Variable        1
    :FOR	${iCtr}    IN RANGE    10        #10 is equal to the max number of try the function will query
    \    ${ResultsCount}    Create Query for Essence User and Return Results Count    ${sLoginId}    
    \    Run Keyword If    ${ResultsCount}==1    Exit For Loop
         ...    ELSE    Log To Console    Try ${iCtr}: '${sLoginId}' not found.

    Run Keyword If    ${ResultsCount}==1 and ${bIsExist}==${True}    Log    User '${sLoginId}' is created in Essence.
    ...    ELSE IF    ${ResultsCount}==0 and ${bIsExist}==${True}    Fail    User '${sLoginId}' is not created in Essence.
    ...    ELSE IF    ${ResultsCount}==1 and ${bIsExist}==${False}    Fail    User '${sLoginId}' is created in Essence.
    ...    ELSE IF    ${ResultsCount}==0 and ${bIsExist}==${False}    Log    User '${sLoginId}' is not created in Essence.
    
Validate Created User in Party Database
    [Documentation]    This keyword is used validate if the user is created in Party database.
    ...    @author: dahijara    22JUL2019    - initial create
    ...    @update: dahijara    29JUL2019    - added 'isExist' argument and if condition statements to handle negative testing
    [Arguments]    ${sLoginId}    ${bIsExist}=True
    ${iCtr}    Set Variable        1
    :FOR	${iCtr}    IN RANGE    10        #10 is equal to the max number of try the function will query
    \    ${ResultsCount}    Create Query for Party User and Return Results Count    ${sLoginId}    
    \    Run Keyword If    ${ResultsCount}==1    Exit For Loop
         ...    ELSE    Log To Console    Try ${iCtr}: '${sLoginId}' not found.

    Run Keyword If    ${ResultsCount}==1 and ${bIsExist}==${True}    Log    User '${sLoginId}' is created in Party.
    ...    ELSE IF    ${ResultsCount}==0 and ${bIsExist}==${True}    Fail    User '${sLoginId}' is not created in Party.
    ...    ELSE IF    ${ResultsCount}==1 and ${bIsExist}==${False}    Fail    User '${sLoginId}' is created in Party.
    ...    ELSE IF    ${ResultsCount}==0 and ${bIsExist}==${False}    Log    User '${sLoginId}' is not created in Party.

Validate User If Existing in Database
    [Documentation]    This keyword is used to validate that the user is successfully created/existing in the database of the given application.
    ...    ${sLineOfBusiness} values are COMRLENDING, COREBANKING, PARTY
    ...    @author: dahijara    22AUG2019    - initial create
    ...    @update: amansuet    28AUG2019    - added loop for db query
    [Arguments]    ${sLoginId}    ${sLineOfBusiness}
    
    ### MDM QUERY ###
    ${ResultsCount}    Query for User and Return Results Count    ${sLoginId}    ${MDM}
    Run Keyword If    ${ResultsCount}==1    Log    User '${sLoginId}' is existing in ${MDM}.      
    ...    ELSE    Log    User '${sLoginId}' is not existing in ${MDM}.    level=ERROR
    Run Keyword And Continue On Failure    Should Not Be Equal As Strings    ${ResultsCount}    0

    ### LOB QUERY ###
    ${LOB_List}    Split String    ${sLineOfBusiness}    ,
    ${LOB_Count}    Get Length    ${LOB_List}
    :FOR    ${Index}    IN RANGE    ${LOB_Count}
    \    Exit For Loop If    '${Index}'=='${LOB_Count}'
    \    ${LOB_Value}    Get From List    ${LOB_List}    ${Index}
    \    ${ResultsCount}    Query for User and Return Results Count    ${sLoginId}    ${LOB_Value}
    \    Run Keyword If    '${LOB_Value}'=='' or '${LOB_Value}'=='no tag' or '${lob_value}'=='null'    Exit For Loop
         ...    ELSE IF    ${ResultsCount}==1    Log    User '${sLoginId}' is existing in ${LOB_Value}.
         ...    ELSE    Log    User '${sLoginId}' is not existing in ${LOB_Value}.    level=ERROR
    \    Run Keyword And Continue On Failure    Should Not Be Equal As Strings    ${ResultsCount}    0
    
Validate User If Not Existing in Database
    [Documentation]    This keyword is used to validate that the user is not created or not existing in the database of the given application.
    ...    ${sLineOfBusiness} values are COMRLENDING, COREBANKING, PARTY
    ...    @author: dahijara    22AUG2019    - initial create
    ...    @update: amansuet    28AUG2019    - added loop for db query
    ...    @update: jloretiz    01JAN2020    - added parameters and condition to handle LIQ error
    [Arguments]    ${sLoginId}    ${sLineOfBusiness}    ${sMDM}=True    ${sLIQError}=None
    
    ### MDM QUERY ###
    ${ResultsCount}    Run Keyword If    '${sMDM}'=='True'    Query for User and Return Results Count    ${sLoginId}    ${MDM}
    ...    ELSE    Set Variable    0
    Run Keyword If    ${ResultsCount}==0    Log    User '${sLoginId}' is NOT existing in ${MDM}.      
    ...    ELSE    Log    User '${sLoginId}' is existing in ${MDM}.    level=ERROR
    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${ResultsCount}    0

    ### LOB QUERY ###
    ${LOB_List}    Split String    ${sLineOfBusiness}    ,
    ${LOB_Count}    Get Length    ${LOB_List}
    :FOR    ${Index}    IN RANGE    ${LOB_Count}
    \    Exit For Loop If    '${Index}'=='${LOB_Count}'
    \    ${LOB_Value}    Get From List    ${LOB_List}    ${Index}
    \    Exit For Loop If    '${sLIQError}'=='TRUE' and '${LOB_Value}'=='COMRLENDING'
    \    ${ResultsCount}    Query for User and Return Results Count    ${sLoginId}    ${LOB_Value}
    \    Run Keyword If    '${LOB_Value}'=='' or '${LOB_Value}'=='no tag' or '${lob_value}'=='null'    Exit For Loop
         ...    ELSE IF    ${ResultsCount}==0    Log    User '${sLoginId}' is NOT existing in ${LOB_Value}.      
         ...    ELSE    Log    User '${sLoginId}' is existing in ${LOB_Value}.    level=ERROR
    \    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${ResultsCount}    0

Query for User and Return Results Count
    [Documentation]    This keyword is used to create sql query for User in an application and return results count.
    ...    @author: dahijara    22AUG2019    - initial create
    [Arguments]    ${sUserID}    ${sApplicationName}

    ${sApplicationName}    Convert To Uppercase    ${sApplicationName}
        
    ${QUERY_LIQ_USERID}    Catenate    ${SELECT_Q}    ${LOANIQ_UPT_UID_USERID}
    ...    ${FROM_Q}    ${LOANIQ_TLS_USER_PROFILE}    ${WHERE_Q}
    ...    ${LOANIQ_UPT_UID_USERID}    =    '${sUserID}'

    ${QUERY_ESSENCE_USERID}    Catenate    ${SELECT_Q}    ${ESSENCE_GLOBAL_BFNAMEPK}
    ...    ${FROM_Q}    ${ESSENCE_GLOBAL_BFTB_USER}    ${WHERE_Q}
    ...    ${ESSENCE_GLOBAL_BFNAMEPK}    =    '${sUserID}'

    ${QUERY_PARTY_USERID}    Catenate    ${SELECT_Q}    ${PARTY_BFNAMEPK}
    ...    ${FROM_Q}    ${PARTY_BFTB_USER}    ${WHERE_Q}
    ...    ${PARTY_BFNAMEPK}    =    '${sUserID}'

    ${QUERY_MDM_USERID}    Catenate    ${SELECT_Q}    ${FFC_MCH_LOGINID}
    ...    ${FROM_Q}    ${FFC_MDM_USER}    ${WHERE_Q}
    ...    ${FFC_MCH_LOGINID}    =    '${sUserID}' 

    
    ${iCtr}    Set Variable        1
    ${RESULTS_COUNT}    Set Variable    0    #initialize results count value to 0
    :FOR	${iCtr}    IN RANGE    10        #10 is equal to the max number of try the function will query
    \    Run Keyword If    '${sApplicationName}'=='' or '${sApplicationName}'=='no tag' or '${sApplicationName}'=='null'    Exit For Loop
    \    ${RESULTS_COUNT}    Run Keyword If    '${sApplicationName}'=='${COMRLENDING}'    Connect to LIQ Database and Return Row Count    ${QUERY_LIQ_USERID}
         ...    ELSE IF    '${sApplicationName}'=='${COREBANKING}'    Connect to Essence Global Database and Return Row Count    ${QUERY_ESSENCE_USERID}
         ...    ELSE IF    '${sApplicationName}'=='${PARTY}'    Connect to Party Database and Return Row Count    ${QUERY_PARTY_USERID}
         ...    ELSE IF    '${sApplicationName}'=='${MDM}'    Connect to MCH Oracle Database and Return Row Count    ${QUERY_MDM_USERID}
    \    Run Keyword If    ${RESULTS_COUNT}==1    Exit For Loop
         ...    ELSE    Log    Unable to send user query for ${sApplicationName}.
    
    [Return]    ${RESULTS_COUNT}
