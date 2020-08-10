*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Connect to MCH Oracle Database and Execute Query
    [Documentation]    This keyword is used to connect to MCH database using DBUsername/DBPassword to DBHost:DBPort and DBServiceName.
    ...    and execute sQuery
    ...    @author: clanding    06MAR2019    - initial create
    ...    @update: clanding    31JUL2019    - updated documentation and keyword name
    [Arguments]    ${sQuery}
    
    Connect To Database Using Custom Params    ${CX_ORACLE}    "${DBUsername}/${DBPassword}@${DBHost}:${DBPort}/${DBServiceName}"
    ${Query_Results_List}    Query    ${sQuery}
    Log    ${Query_Results_List}
    Disconnect From Database
    
    [Return]    ${Query_Results_List}

Connect to Essence AU Database and Execute Query and Return List
    [Documentation]    This keyword is used to connect to Essence AU and Global database to get an existing user and return user id.
    ...    @author: clanding    29APR2019    - initial create
    ...    @update: jdelacru    16MAY2019    - Updated keyword name base on funcion (Execute and Return List)
    [Arguments]    ${sQuery}
    
    Connect To Database Using Custom Params    ${CX_ORACLE}    "${DBUSERNAME_ESS_AU}/${DBPASSWORD_ESS_AU}@${DBHOST_ESS_AU}:${DBPORT_ESS_AU}/${DBSERVICENAME_ESS_AU}"
    ${Query_Results_List}    Query    ${sQuery}
    Log    ${Query_Results_List}
    Disconnect From Database
    
    [Return]    ${Query_Results_List}

Connect to Party Database and Execute Query and Return List
    [Documentation]    This keyword is used to connect to Party database to get an existing user and return user id.
    ...    @author: clanding    29APR2019    - initial create
    ...    @update: jdelacru    16MAY2019    - Updated keyword name base on funcion (Execute and Return List)
    [Arguments]    ${sQuery}
    
    Connect To Database Using Custom Params    ${CX_ORACLE}    "${DBUSERNAME_PTY}/${DBPASSWORD_PTY}@${DBHOST_PTY}:${DBPORT_PTY}/${DBSERVICENAME_PTY}"
    ${Query_Results_List}    Query    ${sQuery}
    Log    ${Query_Results_List}
    Disconnect From Database
    
    [Return]    ${Query_Results_List}

Connect to LIQ Database and Return Results
    [Documentation]    This keyword is used to connect to LOAN IQ database to get result using sQuery.
    ...    @author: clanding    29APR2019    - initial create
    ...    @update: clanding    28JUN2019    - updated keyword name and documentation
    [Arguments]    ${sQuery}
    
    Connect To Database Using Custom Params    ${CX_ORACLE}    "${DBUSERNAME_LIQ}/${DBPASSWORD_LIQ}@${DBHOST_LIQ}:${DBPORT_LIQ}/${DBSERVICENAME_LIQ}"
    ${Query_Results_List}    Query    ${sQuery}
    Log    ${Query_Results_List}
    Disconnect From Database
    
    [Return]    ${Query_Results_List}

Connect to LIQ Database and Return Row Count
    [Documentation]    This keyword is used to connect to LOAN IQ database and get row count value.
    ...    @author: clanding    28JUN2019    - initial create
    ...    @update: clanding    25JUL2019    - added query to display the query results in the logs
    [Arguments]    ${sQuery}
    
    Connect To Database Using Custom Params    ${CX_ORACLE}    "${DBUSERNAME_LIQ}/${DBPASSWORD_LIQ}@${DBHOST_LIQ}:${DBPORT_LIQ}/${DBSERVICENAME_LIQ}"
    ${Query_Results_List}    Query    ${sQuery}
    Log    ${Query_Results_List}
    ${Row_Count}    Row Count    ${sQuery}
    Log    ${Row_Count}
    Disconnect From Database
    
    [Return]    ${Row_Count}
    
Connect to Essence Global Database and Return Row Count
    [Documentation]    This keyword is used to connect to  Essence Global Database and get row count value.
    ...    @author: xmiranda    23JUL2019    - initial create
    ...    @update: xmiranda    24JUL2019    - changed the prepositions in the Keyword name to lowercase
    ...    @update: dahijara    30JUL2019    - changed keyword form 'Query' to 'Row Count' 
    ...    @update: dahijara    30JUL2019    - changed database connection from GB server to AU server
    ...    @udpate: jdelacru    22NOV2019    - replaced old variables to geniric variables for essence db credential
    [Arguments]    ${sQuery}
    
    Connect To Database Using Custom Params    ${CX_ORACLE}    "${DBUSERNAME_ESS}/${DBPASSWORD_ESS}@${DBHOST_ESS}:${DBPORT_ESS}/${DBSERVICENAME_ESS}"
    ${Row_Count}    Row Count    ${sQuery}
    Log    ${Row_Count}
    Disconnect From Database
    
    [Return]    ${Row_Count}

Connect to Party Database and Return Row Count
    [Documentation]    This keyword is used to connect to  Essence Global Database and get row count value.
    ...    @author: xmiranda    23JUL2019    - initial create
    ...    @update: xmiranda    24JUL2019    - changed the prepositions in the Keyword name to lowercase 
    ...    @update: dahijara        30JUL2019    - changed keyword form 'Query' to 'Row Count'   
    [Arguments]    ${sQuery}
    
    Connect To Database Using Custom Params    ${CX_ORACLE}    "${DBUSERNAME_PTY}/${DBPASSWORD_PTY}@${DBHOST_PTY}:${DBPORT_PTY}/${DBSERVICENAME_PTY}"		
    ${Row_Count}    Row Count    ${sQuery}			
    Log    ${Row_Count}
    Disconnect From Database
    
    [Return]    ${Row_Count} 

Connect to MCH Oracle Database and Return Row Count
    [Documentation]    This keyword is used to connect to MCH database using DBUsername/DBPassword to DBHost:DBPort and DBServiceName.
    ...    and execute sQuery and get row count value.
    ...    @author: dahijara    22AUG2019    - initial create
    [Arguments]    ${sQuery}
    
    Connect To Database Using Custom Params    ${CX_ORACLE}    "${DBUsername}/${DBPassword}@${DBHost}:${DBPort}/${DBServiceName}"
    ${Row_Count}    Row Count    ${sQuery}			
    Log    ${Row_Count}
    Disconnect From Database
    
    [Return]    ${Row_Count} 
    
Get Count of Non-Unique Items from Different Tables
    [Documentation]    This keyword is used to retrieve the count of non-unique items from 2 columns of different tables. 
    ...    @author: ehugo    04SEP2019    - initial create
    [Arguments]    ${ColumnName_SourceTable}    ${SourceTable_Name}    ${ColumnName_ReferenceTable}    ${ReferenceTable_Name}
    
    ${Query}    Set Variable    select count(distinct ${ColumnName_SourceTable}) from ${SourceTable_Name} left join ${ReferenceTable_Name} on ${SourceTable_Name}.${ColumnName_SourceTable} = ${ReferenceTable_Name}.${ColumnName_ReferenceTable} where ${ReferenceTable_Name}.${ColumnName_ReferenceTable} is null having count(*) > 0
    ${Result}    Connect to LIQ Database and Return Results    ${Query}
    
    ${Result}    Convert To String    ${Result}
    ${Result}=    Remove String    ${Result}    [    (    ,    )    ]
    
    ${Result_isEmpty}    Run Keyword And Return Status    Should Be Empty    ${Result}
    Run Keyword If     ${Result_isEmpty}==False    Run Keyword And Continue On Failure    Fail    ${ColumnName_SourceTable}: Non-unique item count is not equal to 0. Current count is ${Result}.
    ...    ELSE    Log    ${ColumnName_SourceTable}: Non-unique item count is equal to ${Result}.
    
