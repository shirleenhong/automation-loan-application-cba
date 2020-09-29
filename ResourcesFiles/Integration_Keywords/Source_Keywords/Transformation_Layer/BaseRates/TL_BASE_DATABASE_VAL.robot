*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot


*** Keywords ***

Validate Future Date Record in Holding Table for TL Base Rate
    [Documentation]    This keyword is used to validate future date record if existing in the Base Rate holding tables.
    ...    @author: clanding    07MAR2019    - initial create
    ...    @update: jdelacru    03JUL2019    - deleted validation in comparing number of record in gsfile and database
    ...    @update: jdelacru    29SEP2020    - validated EUR instead of NY in comparing the data on hold
    ...                                      - moved the closing of excel due to conflicting excel sessions
    [Arguments]    ${aQueryList}    ${sTransformedData_FilePath}

    Open Excel    ${dataset_path}${sTransformedData_FilePath} 
    ${Row_Count}    Get Row Count    Transformed_BaseRate
    Close Current Excel Document
    :FOR    ${INDEX}    IN RANGE    1    ${Row_Count}
    \    
    \    ${dTransformedData}    Create Dictionary Using Transformed Data and Return    ${dataset_path}${sTransformedData_FilePath}    ${INDEX}
    \    
    \    ${PriceType_Last}    Run Keyword If    '&{dTransformedData}[lastRate]'!='null'    Set Variable    Last
    \    ${PriceType_Bid}    Run Keyword If    '&{dTransformedData}[buyRate]'!='null'    Set Variable    Bid
    \    ${PriceType_Mid}    Run Keyword If    '&{dTransformedData}[midRate]'!='null'    Set Variable    Mid
    \    ${PriceType_Ask}    Run Keyword If    '&{dTransformedData}[sellRate]'!='null'    Set Variable    Ask
    \    
    \    Run Keyword If    '&{dTransformedData}[subEntity]'=='null' and '${PriceType_Last}'=='Last'    Run Keywords    Compare Expected Data on Hold and Actual Data on Hold    ${aQueryList}    
         ...    ${dTransformedData}    ${PriceType_Last}    AUD
         ...    AND    Compare Expected Data on Hold and Actual Data on Hold    ${aQueryList}    
         ...    ${dTransformedData}    ${PriceType_Last}    EUR
         ...    ELSE IF    '&{dTransformedData}[subEntity]'=='AUD' and '${PriceType_Last}'=='Last'    Compare Expected Data on Hold and Actual Data on Hold    ${aQueryList}    
         ...    ${dTransformedData}    ${PriceType_Last}    EUR
         ...    ELSE IF    '&{dTransformedData}[subEntity]'=='EUR' and '${PriceType_Last}'=='Last'    Compare Expected Data on Hold and Actual Data on Hold    ${aQueryList}    
         ...    ${dTransformedData}    ${PriceType_Last}    AUD
         ...    ELSE    Log    lastRate value is null.
    \    
    \    Run Keyword If    '&{dTransformedData}[subEntity]'=='null' and '${PriceType_Bid}'=='Bid'    Run Keywords    Compare Expected Data on Hold and Actual Data on Hold    ${aQueryList}    
         ...    ${dTransformedData}    ${PriceType_Bid}    AUD
         ...    AND    Compare Expected Data on Hold and Actual Data on Hold    ${aQueryList}    
         ...    ${dTransformedData}    ${PriceType_Bid}    EUR
         ...    ELSE IF    '&{dTransformedData}[subEntity]'=='AUD' and '${PriceType_Bid}'=='Bid'    Compare Expected Data on Hold and Actual Data on Hold    ${aQueryList}    
         ...    ${dTransformedData}    ${PriceType_Bid}    EUR
         ...    ELSE IF    '&{dTransformedData}[subEntity]'=='EUR' and '${PriceType_Bid}'=='Bid'    Compare Expected Data on Hold and Actual Data on Hold    ${aQueryList}    
         ...    ${dTransformedData}    ${PriceType_Bid}    AUD
         ...    ELSE    Log    buyRate value is null.
    \    
    \    Run Keyword If    '&{dTransformedData}[subEntity]'=='null' and '${PriceType_Mid}'=='Mid'    Run Keywords    Compare Expected Data on Hold and Actual Data on Hold    ${aQueryList}    
         ...    ${dTransformedData}    ${PriceType_Mid}    AUD
         ...    AND    Compare Expected Data on Hold and Actual Data on Hold    ${aQueryList}    
         ...    ${dTransformedData}    ${PriceType_Mid}    EUR
         ...    ELSE IF    '&{dTransformedData}[subEntity]'=='AUD' and '${PriceType_Mid}'=='Mid'    Compare Expected Data on Hold and Actual Data on Hold    ${aQueryList}    
         ...    ${dTransformedData}    ${PriceType_Mid}    EUR
         ...    ELSE IF    '&{dTransformedData}[subEntity]'=='EUR' and '${PriceType_Mid}'=='Mid'    Compare Expected Data on Hold and Actual Data on Hold    ${aQueryList}    
         ...    ${dTransformedData}    ${PriceType_Mid}    AUD
         ...    ELSE    Log    midRate value is null.
    \    
    \    Run Keyword If    '&{dTransformedData}[subEntity]'=='null' and '${PriceType_Ask}'=='Ask'    Run Keywords    Compare Expected Data on Hold and Actual Data on Hold    ${aQueryList}    
         ...    ${dTransformedData}    ${PriceType_Ask}    AUD
         ...    AND    Compare Expected Data on Hold and Actual Data on Hold    ${aQueryList}    
         ...    ${dTransformedData}    ${PriceType_Ask}    EUR
         ...    ELSE IF    '&{dTransformedData}[subEntity]'=='AUD' and '${PriceType_Ask}'=='Ask'    Compare Expected Data on Hold and Actual Data on Hold    ${aQueryList}    
         ...    ${dTransformedData}    ${PriceType_Ask}    EUR
         ...    ELSE IF    '&{dTransformedData}[subEntity]'=='EUR' and '${PriceType_Ask}'=='Ask'    Compare Expected Data on Hold and Actual Data on Hold    ${aQueryList}    
         ...    ${dTransformedData}    ${PriceType_Ask}    AUD
         ...    ELSE    Log    sellRate value is null.
    \    
    \    Exit For Loop If    ${INDEX}==${Row_Count}
    # Close Current Excel Document
    
Compare Expected Data on Hold and Actual Data on Hold
    [Documentation]    This keyword is used to compare expexted data on hold from the input file and actual data on hold from the query.
    ...    @author: clanding    07MAR2019    - initial create
    [Arguments]    ${aQueryList}    ${dTransformedData}    ${PriceType}    ${sSubEntity}
    
    ${Rate}    Run Keyword If    '${PriceType}'=='Last'    Set Variable    lastRate
    ...    ELSE IF    '${PriceType}'=='Bid'    Set Variable    buyRate
    ...    ELSE IF    '${PriceType}'=='Mid'    Set Variable    midRate
    ...    ELSE IF    '${PriceType}'=='Ask'    Set Variable    sellRate
    
    ###convert 001W tenor to 007D --based from BASE_RATE_MAPPING table###
    ${rateTenor}    Run Keyword If    '&{dTransformedData}[rateTenor]'=='007D'    Set Variable    001W
    ...    ELSE IF    '&{dTransformedData}[rateTenor]'=='014D'    Set Variable    002W
    ...    ELSE IF    '&{dTransformedData}[rateTenor]'=='001M' and '&{dTransformedData}[rateTenor]'=='LIBOR' and '${PriceType}'=='Bid'    Set Variable    001M
    ...    ELSE IF    '&{dTransformedData}[rateTenor]'=='' and '&{dTransformedData}[rateTenor]'=='LMIR' and '${PriceType}'=='Bid'    Set Variable    001M
    ...    ELSE IF    '&{dTransformedData}[rateTenor]'=='' and '&{dTransformedData}[rateTenor]'=='EONIA' and '${PriceType}'=='Bid'    Set Variable    001D
    ...    ELSE IF    '&{dTransformedData}[rateTenor]'=='' and '&{dTransformedData}[rateTenor]'=='DFFR' and '${PriceType}'=='Bid'    Set Variable    001D
    ...    ELSE IF    '&{dTransformedData}[rateTenor]'=='' and '&{dTransformedData}[rateTenor]'=='TIIE' and '${PriceType}'=='Bid'    Set Variable    001D
    ...    ELSE IF    '&{dTransformedData}[rateTenor]'=='' and '&{dTransformedData}[rateTenor]'=='RBA' and '${PriceType}'=='Last'    Set Variable    001D
    ...    ELSE    Set Variable    &{dTransformedData}[rateTenor]
    
    ${rateTenor_4th}    Get Substring    ${rateTenor}    -1    
    ${rateTenor_suffix}    Run Keyword If    '${rateTenor_4th}'=='M'    Set Variable    NTH
    ...    ELSE IF    '${rateTenor_4th}'=='D'    Set Variable    AY
    ...    ELSE IF    '${rateTenor_4th}'=='W'    Set Variable    EEK
    ...    ELSE IF    '${rateTenor_4th}'=='Y'    Set Variable    EAR
    
    ${Tenor_Converted}    Catenate    SEPARATOR=    ${rateTenor}    ${rateTenor_suffix}
    
    ${TransformedData_List}    Create List    &{dTransformedData}[baseRateCode]    &{dTransformedData}[currency]    ${PriceType}
    ...    &{dTransformedData}[${Rate}]    &{dTransformedData}[rateEffectiveDate]    ${Tenor_Converted}
    ...    ${sSubEntity}
    

    Run Keyword And Continue On Failure    Should Contain    ${aQueryList}    ${TransformedData_List}    
    ${Input_Exists_in_DB}    Run Keyword And Return Status    Should Contain    ${aQueryList}    ${TransformedData_List}
    Run Keyword If    ${Input_Exists_in_DB}==${True}    Log    Input '${TransformedData_List}' exists in Query Result: ${aQueryList}
    ...    ELSE    Log    Input '${TransformedData_List}' does not exists in Query Result: ${aQueryList}
    
Get Future Date Record in Holding Table for TL Base Rate
    [Documentation]    This keyword is used to create query for base rate holding table given filename.
    ...    Then connect to oracle database and execute query to get records on the holding tables.
    ...    Master_Mapping and GS_Base_Rate are the holding tables for Base Rate.
    ...    Query_Results columns are on the following orders:
    ...    INSTR_SUB_TYPE | INSTR_CCY | INSTR_PRC_TYPE | INSTR_PRICE | VENDOR_PUBLISH_DATE | INSTR_TENOR | SUB_ENTITY_NAME
    ...    CIBOR | DKK | Last | -0.36 | 2018-07-12 | 001MNTH | NY
    ...    @author: clanding    06MAR2019    - initial create
    ...    @update: jdelacru    02JUL2019    - used 'LIKE' instead of '=' for the query
    ...    @update: clanding    31JUL2019    - updated keyword name to 'Connect to MCH Oracle Database and Execute Query'
    [Arguments]    ${sFilename}    ${sTransformedData_FilePath}
    
    ${QUERY_BASE_HOLDING}    Catenate    ${SELECT_Q}    
    ...    ${GS_BASE_RATE_TABLE}.${INSTR_SUB_TYPE},
    ...    ${GS_BASE_RATE_TABLE}.${INSTR_CCY},
    ...    ${GS_BASE_RATE_TABLE}.${INSTR_PRC_TYPE},
    ...    ${GS_BASE_RATE_TABLE}.${INSTR_PRICE},
    ...    ${GS_BASE_RATE_TABLE}.${VENDOR_PUBLISH_DATE},
    ...    ${GS_BASE_RATE_TABLE}.${INSTR_TENOR},
    ...    ${MASTER_MAPPING_TABLE}.${SUB_ENTITY_NAME}
    ...    ${FROM_Q}    ${GS_BASE_RATE_TABLE}
    ...    ${INNERJOIN_Q}    ${MASTER_MAPPING_TABLE}
    ...    ${ON_Q}    ${GS_BASE_RATE_TABLE}.${MAP_ID}    =    ${MASTER_MAPPING_TABLE}.${MAP_ID}
    ...    ${WHERE_Q}    ${FILE_NAME}    LIKE    '%${sFilename}%'
    
    ${Query_Results_List}    Connect to MCH Oracle Database and Execute Query    ${QUERY_BASE_HOLDING}
    
    ${List_for_Query}    Create List    
    ${QueryResult_Count}    Get Length    ${Query_Results_List}
    :FOR    ${INDEX}    IN RANGE    ${QueryResult_Count}
    \    
    \    ${QueryResult_List}    Get From List    ${Query_Results_List}    ${INDEX}
    \    ${QueryResult_SubList}    Create List for Query Result    ${QueryResult_List}    
    \    Append To List    ${List_for_Query}    ${QueryResult_SubList}
    \    
    \    Exit For Loop If    ${INDEX}==${QueryResult_Count}
    [Return]    ${List_for_Query}
    
Create List for Query Result
    [Documentation]    This keyword is used to create list for the query result by providing designated column headers from the 'select'
    ...    in the query.
    ...    @author: clanding    06MAR2019    - initial create
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
    
Get Future Date Record in Holding Table for Multiple Files for TL Base Rate
    [Documentation]    This keyword is used to create query for base rate holding table given filename.
    ...    Then connect to oracle database and execute query to get records on the holding tables.
    ...    Master_Mapping and GS_Base_Rate are the holding tables for Base Rate.
    ...    Query_Results columns are on the following orders:
    ...    INSTR_SUB_TYPE | INSTR_CCY | INSTR_PRC_TYPE | INSTR_PRICE | VENDOR_PUBLISH_DATE | INSTR_TENOR | SUB_ENTITY_NAME
    ...    CIBOR | DKK | Last | -0.36 | 2018-07-12 | 001MNTH | NY
    ...    @author: clanding    06MAR2019    - initial create
    ...    @update: jdelacru    02JUL2019    - used 'LIKE' instead of '=' for the query
    ...    @update: clanding    31JUL2019    - updated keyword name to 'Connect to MCH Oracle Database and Execute Query'
    ...    @update: jdelacru    12AUG2019    - removed ${sTransformedData_FilePath} as argument
    ...    @update: jdelacru    29SEP2020    - change the variable ${FILE_NAME} to ${FILE_NAME_QUERY}
    [Arguments]    ${sFilename}
    ${List_for_Query_Temp}    Create List
    ${InputGSFile_Count}    Get Length    ${sFilename}
    :FOR    ${Index}    IN RANGE    ${InputGSFile_Count}
    \    ${InputGSFile}    Get From List    ${sFilename}    ${Index}
    \    ${QUERY_BASE_HOLDING}    Catenate    ${SELECT_Q}    
         ...    ${GS_BASE_RATE_TABLE}.${INSTR_SUB_TYPE},
         ...    ${GS_BASE_RATE_TABLE}.${INSTR_CCY},
         ...    ${GS_BASE_RATE_TABLE}.${INSTR_PRC_TYPE},
         ...    ${GS_BASE_RATE_TABLE}.${INSTR_PRICE},
         ...    ${GS_BASE_RATE_TABLE}.${VENDOR_PUBLISH_DATE},
         ...    ${GS_BASE_RATE_TABLE}.${INSTR_TENOR},
         ...    ${MASTER_MAPPING_TABLE}.${SUB_ENTITY_NAME}
         ...    ${FROM_Q}    ${GS_BASE_RATE_TABLE}
         ...    ${INNERJOIN_Q}    ${MASTER_MAPPING_TABLE}
         ...    ${ON_Q}    ${GS_BASE_RATE_TABLE}.${MAP_ID}    =    ${MASTER_MAPPING_TABLE}.${MAP_ID}
         ...    ${WHERE_Q}    ${FILE_NAME_QUERY}    LIKE    '%${InputGSFile}%'
    \    Log    ${QUERY_BASE_HOLDING}
    \    ${Query_Results_List}    Connect to MCH Oracle Database and Execute Query    ${QUERY_BASE_HOLDING}
    \    Log    ${Query_Results_List}
    \    ${QueryResult_Count}    Get Length    ${Query_Results_List} 
    \    ${List_for_Query_Res}    Create Multi Query List for Base Rate    ${Query_Results_List}    ${QueryResult_Count}    
    \    Append To List    ${List_for_Query_Temp}    ${List_for_Query_Res}
    [Return]    ${List_for_Query_Temp}
    
Create Multi Query List for Base Rate
    [Documentation]    Separating Loop for Query List of Multiple Files
    ...    @author: jdelacru    09AUG2019    - initial create   
    [Arguments]    ${Query_Results_List}    ${QueryResult_Count}
    ${List_for_Query}    Create List
    :FOR    ${INDEX}    IN RANGE    ${QueryResult_Count}
    \    ${QueryResult_List}    Get From List    ${Query_Results_List}    ${INDEX}
    \    ${QueryResult_SubList}    Create List for Query Result    ${QueryResult_List}    
    \    Append To List    ${List_for_Query}    ${QueryResult_SubList}
    \    Exit For Loop If    ${INDEX}==${QueryResult_Count}
    [Return]    ${List_for_Query}
    
Validate Future Date Record in Holding Table for TL Base Rate for Multiple Files
    [Documentation]    This keyword is used to validate multiple records in holding table.
    ...    @author: jdelacru    12AUG2019    - initial create
    [Arguments]    ${aQueryList}
    ${aQueryList_Count}    Get Length    ${aQueryList}
    Reverse List    ${TRANSFORMEDDATA_LIST}
    Log    ${TRANSFORMEDDATA_LIST}
    :FOR     ${INDEX}    IN RANGE    ${aQueryList_Count}
    \    ${QueryListValue}    Get From List    ${aQueryList}    ${INDEX}
    \    ${sTransformedData_FilePath}    Get From List    ${TRANSFORMEDDATA_LIST}    ${INDEX}
    \    Validate Future Date Record in Holding Table for TL Base Rate    ${QueryListValue}    ${sTransformedData_FilePath}
    \    Exit For Loop If    ${INDEX}==${aQueryList_Count-1}
    
