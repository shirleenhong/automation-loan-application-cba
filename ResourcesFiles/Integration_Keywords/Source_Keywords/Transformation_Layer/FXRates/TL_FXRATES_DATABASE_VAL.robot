*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot


*** Keywords ***

Validate Future Date Record in Holding Table for TL FXRates
    [Documentation]    This keyword is used to validate future date record if existing in the FXRates holding tables.
    ...    @author: mnanquil    19MAR2019    - initial create
    ...    @update: cfrancis    07AUG2019    - updated row count evaluation
    ...    @update: dahijara    21NOV2019    - Added keyword to close opened excel file
    [Arguments]    ${aQueryList}    ${sTransformedData_FilePath}
    Open Excel    ${dataset_path}${sTransformedData_FilePath}    
    ${Row_Count}    Get Row Count    Transformed_FXRates
    ${Row_Count}    Evaluate    ${Row_Count}*3
    ${Query_Count}    Get Length    ${aQueryList}
    ${Row_Count_NoHeader}    Evaluate    ${Row_Count}-3
    Run Keyword And Continue On Failure    Should Be Equal    ${Row_Count_NoHeader}    ${Query_Count}    
    ${On_Hold_Equal}    Run Keyword And Return Status    Should Be Equal    ${Row_Count_NoHeader}    ${Query_Count}    
    Run Keyword If    ${On_Hold_Equal}==${True}    Log    Input On Hold and Actual On Hold count are equal. ${Row_Count_NoHeader} == ${Query_Count}
    ...    ELSE    Log    Input On Hold and Actual On Hold count are NOT equal. ${Row_Count_NoHeader} != ${Query_Count}
    Close Current Excel Document
    
Get Future Date Record in Holding Table for TL FXRates
    [Documentation]    This keyword is used to create query for base rate holding table given filename.
    ...    Then connect to oracle database and execute query to get records on the holding tables.
    ...    Master_Mapping and GS_Base_Rate are the holding tables for FX Rate.
    ...    Query_Results columns are on the following orders:
    ...    INSTR_SUB_TYPE | INSTR_CCY | INSTR_PRC_TYPE | INSTR_PRICE | VENDOR_PUBLISH_DATE | INSTR_TENOR | SUB_ENTITY_NAME
    ...    CIBOR | DKK | Last | -0.36 | 2018-07-12 | 001MNTH | NY
    ...    @author: mnanquil    19MAR2019    - initial create
    ...    @update: clanding    31JUL2019    - updated keyword name to 'Connect to MCH Oracle Database and Execute Query'
    ...    @update: cfrancis    07AUG2019    - updated query to only use filename for AUD funding desk for Group 1 file
    ...    @update: cfrancis    08AUG2019    - updated query where paramater to select both files but refer to AUD funding desk for Group 1 file
    [Arguments]    ${sFilename}    ${sTransformedData_FilePath}
    
    ${QUERY_BASE_HOLDING}    Catenate    ${SELECT_Q}    
    ...    ${GS_FX_RATE_TABLE}.${GS_BASE_CCY},
    ...    ${GS_FX_RATE_TABLE}.${GS_INSTR_PRC_TYPE},
    ...    ${GS_FX_RATE_TABLE}.${GS_INSTR_PRICE},
    ...    ${GS_FX_RATE_TABLE}.${GS_INSTR_TYPE},
    ...    ${GS_FX_RATE_TABLE}.${GS_PROCESSING_DATE},
    ...    ${MASTER_MAPPING_TABLE}.${SUB_ENTITY_NAME}
    ...    ${FROM_Q}    ${GS_FX_RATE_TABLE}
    ...    ${INNERJOIN_Q}    ${MASTER_MAPPING_TABLE}
    ...    ${ON_Q}    ${GS_FX_RATE_TABLE}.${MAP_ID}    =    ${MASTER_MAPPING_TABLE}.${MAP_ID}
    ...    ${WHERE_Q}    ${FILE_NAME}    IN    ('${sFilename}_0','${sFilename}_1')    AND    ${MASTER_MAPPING_TABLE}.${SUB_ENTITY_NAME}    =    'AUD'
    ${Query_Results_List}    Connect to MCH Oracle Database and Execute Query    ${QUERY_BASE_HOLDING}
    ${List_for_Query}    Create List    
    ${QueryResult_Count}    Get Length    ${Query_Results_List}
    :FOR    ${INDEX}    IN RANGE    ${QueryResult_Count}
    \    
    \    ${QueryResult_List}    Get From List    ${Query_Results_List}    ${INDEX}
    \    ${QueryResult_SubList}    Create List for Query Result FXRates    ${QueryResult_List}    
    \    Append To List    ${List_for_Query}    ${QueryResult_SubList}
    \    Exit For Loop If    ${INDEX}==${QueryResult_Count}
    [Return]    ${List_for_Query}
    
Create List for Query Result FXRates    
    [Documentation]    This keyword is used to create list for the query result by providing designated column headers from the 'select'
    ...    in the query.
    ...    @author: mnanquil    19MAR2019    - initial create
    [Arguments]    ${aQueryResult}    @{aColumnHeaders}
    
    ${QueryResultCount}    Get Length    ${aQueryResult}
    ${QueryResult_SubList}    Create List        
    
    :FOR    ${INDEX}    IN RANGE    ${QueryResultCount}
    \    
    \    ${QueryResult_Val}    Get From List    ${aQueryResult}    ${INDEX}
    \    Append To List    ${QueryResult_SubList}    ${QueryResult_Val}  
    \    
    \    Exit For Loop If    ${INDEX}==${QueryResultCount}
    
    [Return]    ${QueryResult_SubList}
    
Get Future Date Record in Holding Table for TL FXRates of Multiple Files
    [Documentation]    This keyword is used to create query for base rate holding table given multiple filenames.
    ...    Then connect to oracle database and execute query to get records on the holding tables.
    ...    Master_Mapping and GS_Base_Rate are the holding tables for FX Rate.
    ...    Query_Results columns are on the following orders:
    ...    INSTR_SUB_TYPE | INSTR_CCY | INSTR_PRC_TYPE | INSTR_PRICE | VENDOR_PUBLISH_DATE | INSTR_TENOR | SUB_ENTITY_NAME
    ...    CIBOR | DKK | Last | -0.36 | 2018-07-12 | 001MNTH | NY
    ...    @author: cfrancis    08AUG2019    - initial create
    [Arguments]    ${sFilename}    ${sTransformedData_FilePath}    ${Delimiter}=None
    Log    ${sFilename}
    ${InputGSFile_Count}    Get Length    ${sFilename}
    :FOR    ${Index}    IN RANGE    ${InputGSFile_Count}
    \    ${InputGSFile}    Get From List    ${sFilename}    ${Index}
    \    ${QUERY_BASE_HOLDING}    Catenate    ${SELECT_Q}    
         ...    ${GS_FX_RATE_TABLE}.${GS_BASE_CCY},
         ...    ${GS_FX_RATE_TABLE}.${GS_INSTR_PRC_TYPE},
         ...    ${GS_FX_RATE_TABLE}.${GS_INSTR_PRICE},
         ...    ${GS_FX_RATE_TABLE}.${GS_INSTR_TYPE},
         ...    ${GS_FX_RATE_TABLE}.${GS_PROCESSING_DATE},
         ...    ${MASTER_MAPPING_TABLE}.${SUB_ENTITY_NAME}
         ...    ${FROM_Q}    ${GS_FX_RATE_TABLE}
         ...    ${INNERJOIN_Q}    ${MASTER_MAPPING_TABLE}
         ...    ${ON_Q}    ${GS_FX_RATE_TABLE}.${MAP_ID}    =    ${MASTER_MAPPING_TABLE}.${MAP_ID}
         ...    ${WHERE_Q}    ${FILE_NAME}    IN    ('${InputGSFile}_0','${InputGSFile}_1')    AND    ${MASTER_MAPPING_TABLE}.${SUB_ENTITY_NAME}    =    'AUD'
    \    ${Query_Results_List}    Connect to MCH Oracle Database and Execute Query    ${QUERY_BASE_HOLDING}
    \    Log    ${QUERY_BASE_HOLDING}
    \    LOG    ${Query_Results_List}
    \    ${List_for_Query}    Create List
    \    ${QueryResult_Count}    Get Length    ${Query_Results_List}
    \    ${List_for_Query}    Create Multi Query List    ${Query_Results_List}    ${QueryResult_Count}    ${List_for_Query}
    [Return]    ${List_for_Query}
    
Create Multi Query List
    [Documentation]    Separating Loop for Query List of Multiple Files
    ...    @author: cfrancis    08AUG2019    - initial create
    [Arguments]    ${Query_Results_List}    ${QueryResult_Count}    ${List_for_Query}
    :FOR    ${INDEX}    IN RANGE    ${QueryResult_Count}
    \
    \    ${QueryResult_List}    Get From List    ${Query_Results_List}    ${INDEX}
    \    ${QueryResult_SubList}    Create List for Query Result FXRates    ${QueryResult_List}    
    \    Append To List    ${List_for_Query}    ${QueryResult_SubList}
    \    Exit For Loop If    ${INDEX}==${QueryResult_Count}
    [Return]    ${List_for_Query}
