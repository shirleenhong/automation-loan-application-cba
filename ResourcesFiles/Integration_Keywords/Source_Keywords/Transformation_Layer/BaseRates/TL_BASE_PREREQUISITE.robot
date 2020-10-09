*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot


*** Keywords ***
    
Create Dictionary per Row Count for Csv Base Rate Content
    [Documentation]    This keyword is used to get the row values from the input csv file with the corresponding column value.
    ...    This will create dictionary and return dictionoary.
    ...    Then create dictionary and return.
    ...    @author: clanding    19FEB2019    - initial create
    [Arguments]    ${aCSV_Content}    ${aCSV_Row_Val}
    
    ${GS_SNAP_index}    Get Column Header Index From Input Csv File And Return    ${aCSV_Content}    GS_SNAP
    ${GS_INSTR_DESC_index}    Get Column Header Index From Input Csv File And Return    ${aCSV_Content}    GS_INSTR_DESC
    ${GS_INSTR_TYPE_index}    Get Column Header Index From Input Csv File And Return    ${aCSV_Content}    GS_INSTR_TYPE
    ${GS_INSTR_SUB_TYPE_index}    Get Column Header Index From Input Csv File And Return    ${aCSV_Content}    GS_INSTR_SUB_TYPE
    ${GS_INSTR_CCY_index}    Get Column Header Index From Input Csv File And Return    ${aCSV_Content}    GS_INSTR_CCY
    ${GS_INSTR_TENOR_index}    Get Column Header Index From Input Csv File And Return    ${aCSV_Content}    GS_INSTR_TENOR
    ${GS_INSTR_PRC_TYPE_index}    Get Column Header Index From Input Csv File And Return    ${aCSV_Content}    GS_INSTR_PRC_TYPE
    ${GS_INSTR_PRICE_index}    Get Column Header Index From Input Csv File And Return    ${aCSV_Content}    GS_INSTR_PRICE
    ${GS_VENDOR_PUBLISH_DATE_index}    Get Column Header Index From Input Csv File And Return    ${aCSV_Content}    GS_VENDOR_PUBLISH_DATE
    ${GS_VALUE_DATE_index}    Get Column Header Index From Input Csv File And Return    ${aCSV_Content}    GS_VALUE_DATE
    ${GS_PROCESSING_DATE_index}    Get Column Header Index From Input Csv File And Return    ${aCSV_Content}    GS_PROCESSING_DATE
    
    ${InstrumentType}    Get From List    ${aCSV_Row_Val}    ${GS_INSTR_TYPE_index}
    ${BaseRateCode}    Get From List    ${aCSV_Row_Val}    ${GS_INSTR_SUB_TYPE_index}
    ${Currency}    Get From List    ${aCSV_Row_Val}    ${GS_INSTR_CCY_index}
    ${Tenor}    Get From List    ${aCSV_Row_Val}    ${GS_INSTR_TENOR_index}
    ${PriceType}    Get From List    ${aCSV_Row_Val}    ${GS_INSTR_PRC_TYPE_index}
    ${Price}    Get From List    ${aCSV_Row_Val}    ${GS_INSTR_PRICE_index}
    ${EffectiveDate}    Get From List    ${aCSV_Row_Val}    ${GS_VENDOR_PUBLISH_DATE_index}
    ${ValueDate}    Get From List    ${aCSV_Row_Val}    ${GS_VALUE_DATE_index}
    ${ProcessingDate}    Get From List    ${aCSV_Row_Val}    ${GS_PROCESSING_DATE_index}
    
    ${dCSV_Row}    Create Dictionary    GS_INSTR_TYPE=${InstrumentType}    GS_INSTR_SUB_TYPE=${BaseRateCode}    GS_INSTR_CCY=${Currency}
    ...    GS_INSTR_TENOR=${Tenor}    GS_INSTR_PRC_TYPE=${PriceType}    GS_INSTR_PRICE=${Price}    GS_VENDOR_PUBLISH_DATE=${EffectiveDate}
    ...    GS_VALUE_DATE=${ValueDate}    GS_PROCESSING_DATE=${ProcessingDate}
    
    [Return]    ${dCSV_Row}


Transform Base Rate CSV Data to XLS File Readable for JSON Creation
    [Documentation]    This keyword is used to get Zone 1 and Zone 3 LIQ Business Dates, read each row of the CSV File and write to an XLS File in preparation for
    ...    JSON creation. 
    ...    This will create 1 payload only for multiple rows.
    ...    @author: clanding    19FEB2019    - initial create
    ...    @update: clanding    19MAR2019    - added check for base rate code LIBOR, will add another row corresponsind to LMIR
    ...    @update: jdelacru    19JUL2019    - Modified variables assignment to correct the writing in Transformed TL_Base Sheet
    ...    @update: cfrancis    04SEP2019    - added checking for emtpy rows and will be ignored on loop and variable to subtract empty rows from ${New_INDEX}
    ...    @update: jdelacru    21SEP2020    - added new logic and separated the actual transformation of CSV to XLS to cater multiple sub-entities
    ...    @update: jdelacru    29SEP2020    - revert to the original steps in transforming csv to xls
    ...    @update: mcastro     09OCT2020    - added condition for Empty ${Row_Val_List}
    [Arguments]    ${sCSV_FilePath}    ${sTransformedData_FilePath}    ${sTransformedDataTemplate_FilePath}    
    
    ${CSV_Content_List}    Read Csv As List    ${dataset_path}${sCSVFilePath}
    
    ${BaseRateCode_prev}    Set Variable
    ${GS_INSTR_TENOR_prev}    Set Variable
    ${GS_VENDOR_PUBLISH_DATE_prev}    Set Variable
    
    ${Zone2_Curr_Date}    Get LoanIQ Business Date per Zone and Return    Zone2
    ${Zone3_Curr_Date}    Get LoanIQ Business Date per Zone and Return    Zone3
    Close All Windows on LIQ
    
    Set Global Variable    ${ZONE2_BUSINESSDATE}    ${Zone2_Curr_Date}
    
    Set Global Variable    ${ZONE3_BUSINESSDATE}    ${Zone3_Curr_Date}
    
    Delete File If Exist    ${dataset_path}${sTransformedData_FilePath}
    Copy File    ${dataset_path}${sTransformedDataTemplate_FilePath}    ${dataset_path}${sTransformedData_FilePath}
    
    ${Csv_Row_Count}    Get Length    ${CSV_Content_List}
    ${INDEX}    Set Variable    1
    ${New_INDEX}    Set Variable    1
    ${INDEX_ForGrouping}    Set Variable    1
    ${Counter}    Set Variable    0
    ${Offset}    Set Variable    0
    :FOR    ${INDEX}    IN RANGE    1    ${Csv_Row_Count}
    \    ${Row_Val_List}    Get From List    ${CSV_Content_List}    ${INDEX}
    \    ${Row_Val_List_Length}    Get Length    ${Row_Val_List}
    \    ${Offset}    Run Keyword If    ${Row_Val_List_Length} == 0    Evaluate    ${Offset}+1
         ...    ELSE    Set Variable    ${Offset}
    \    Run Keyword If    ${Row_Val_List_Length} == 0    Continue For Loop
    \    ${Row_Val_0}    Get From List    ${Row_Val_List}    0
    \    ${Row_Val_0_List}    Split String    ${Row_Val_0}    ,    
    \    ${Row_Dictionary}    Create Dictionary per Row Count for Csv Base Rate Content    ${CSV_Content_List}    ${Row_Val_0_List}
    \    Set Test Variable    ${ROW_${INDEX}}    ${Row_Dictionary}
    \    
    \    ${BaseRateCode_curr}    Get From Dictionary    ${ROW_${INDEX}}    GS_INSTR_SUB_TYPE
    \    ${GS_INSTR_SUB_TYPE}    Get From Dictionary    ${ROW_${INDEX}}    GS_INSTR_TYPE
    \    ${GS_INSTR_TENOR_curr}    Get From Dictionary    ${ROW_${INDEX}}    GS_INSTR_TENOR
    \    ${GS_INSTR_PRC_TYPE}    Get From Dictionary    ${ROW_${INDEX}}    GS_INSTR_PRC_TYPE
    \    ${GS_INSTR_PRICE}    Get From Dictionary    ${ROW_${INDEX}}    GS_INSTR_PRICE
    \    ${GS_VENDOR_PUBLISH_DATE_curr}    Get From Dictionary    ${ROW_${INDEX}}    GS_VENDOR_PUBLISH_DATE
    \    ${GS_VALUE_DATE}    Get From Dictionary    ${ROW_${INDEX}}    GS_VALUE_DATE
    \    ${GS_PROCESSING_DATE}    Get From Dictionary    ${ROW_${INDEX}}    GS_PROCESSING_DATE
    \    
    \    ${Same_Rate_Code}    Run Keyword And Return Status    Should Be Equal    ${BaseRateCode_prev}    ${BaseRateCode_curr}
    \    ${Same_Tenor}    Run Keyword And Return Status    Should Be Equal    ${GS_INSTR_TENOR_prev}    ${GS_INSTR_TENOR_curr} 
    \    ${Same_Date}    Run Keyword And Return Status    Should Be Equal    ${GS_VENDOR_PUBLISH_DATE_prev}    ${GS_VENDOR_PUBLISH_DATE_curr}          
    \    
    \    ${BaseRateCode_prev}    Set Variable    ${BaseRateCode_curr}
    \    ${GS_INSTR_TENOR_prev}    Set Variable    ${GS_INSTR_TENOR_curr}
    \    ${GS_VENDOR_PUBLISH_DATE_prev}    Set Variable    ${GS_VENDOR_PUBLISH_DATE_curr}
    \    
    \    ${CONFIG_PRICE_TYPE}    Convert Input Price Type to Config Price Type and Return Config Price Type    ${GS_INSTR_PRC_TYPE}
    \    
    \    ${Counter}    Run Keyword If    ${Same_Rate_Code}==True and ${Same_Tenor}==True and ${Same_Date}==True    Evaluate    ${Counter}+1
         ...    ELSE    Set Variable    ${Counter}
    \    
    \    ${New_INDEX}    Run Keyword If    ${Same_Rate_Code}==True and ${Same_Tenor}==True and ${Same_Date}==True and '${CONFIG_PRICE_TYPE}'=='MIDRATE'    Set Variable    ${INDEX_ForGrouping}    
         ...    ELSE IF    ${Same_Rate_Code}==True and ${Same_Tenor}==True and ${Same_Date}==True and '${CONFIG_PRICE_TYPE}'=='BUYRATE'    Set Variable    ${INDEX_ForGrouping}
         ...    ELSE IF    ${Same_Rate_Code}==True and ${Same_Tenor}==True and ${Same_Date}==True and '${CONFIG_PRICE_TYPE}'=='SELLRATE'    Set Variable    ${INDEX_ForGrouping}
         ...    ELSE IF    ${Same_Rate_Code}==True and ${Same_Tenor}==True and ${Same_Date}==True and '${CONFIG_PRICE_TYPE}'=='LASTRATE'    Set Variable    ${INDEX_ForGrouping}
         ...    ELSE IF    '${INDEX}'=='1'    Set Variable    ${INDEX}
         ...    ELSE    Evaluate    ${INDEX}-${Counter}-${Offset}
    \   
    \    Run Keyword If    ${Same_Rate_Code}==True and ${Same_Tenor}==True and ${Same_Date}==True and '${CONFIG_PRICE_TYPE}'=='MIDRATE'    Write Data to Excel Using Row Index    Transformed_BaseRate    midRate    ${New_INDEX}    ${GS_INSTR_PRICE}    ${dataset_path}${sTransformedData_FilePath}
         ...    ELSE IF    ${Same_Rate_Code}==True and ${Same_Tenor}==True and ${Same_Date}==True and '${CONFIG_PRICE_TYPE}'=='BUYRATE'    Write Data to Excel Using Row Index    Transformed_BaseRate    buyRate    ${New_INDEX}    ${GS_INSTR_PRICE}    ${dataset_path}${sTransformedData_FilePath}
         ...    ELSE IF    ${Same_Rate_Code}==True and ${Same_Tenor}==True and ${Same_Date}==True and '${CONFIG_PRICE_TYPE}'=='SELLRATE'    Write Data to Excel Using Row Index    Transformed_BaseRate    sellRate    ${New_INDEX}    ${GS_INSTR_PRICE}    ${dataset_path}${sTransformedData_FilePath}
         ...    ELSE IF    ${Same_Rate_Code}==True and ${Same_Tenor}==True and ${Same_Date}==True and '${CONFIG_PRICE_TYPE}'=='LASTRATE'    Write Data to Excel Using Row Index    Transformed_BaseRate    lastRate    ${New_INDEX}    ${GS_INSTR_PRICE}    ${dataset_path}${sTransformedData_FilePath}
         ...    ELSE IF    ${Row_Val_List} != [',,,,,,,,,,']   Get Single Row value from CSV File and Write to Excel for Base Rate    ${ROW_${INDEX}}    ${New_INDEX}    ${Zone2_Curr_Date}    ${Zone3_Curr_Date}    ${CONFIG_PRICE_TYPE}    ${dataset_path}${sTransformedData_FilePath}
    \    
    \    ${Index_LMIR}    Evaluate    ${New_INDEX}+1
    \    
    \    Run Keyword If    '${BaseRateCode_curr}'=='LIBOR' and '${CONFIG_PRICE_TYPE}'=='BUYRATE' and '${GS_INSTR_TENOR_curr}'=='001MNTH'    Get Single Row value from CSV File and Write to Excel for Base Rate    ${ROW_${INDEX}}    
         ...    ${Index_LMIR}    ${Zone2_Curr_Date}    ${Zone3_Curr_Date}    ${CONFIG_PRICE_TYPE}    ${dataset_path}${sTransformedData_FilePath}    LMIR
    \    
    \    ${INDEX_ForGrouping}    Set Variable    ${New_INDEX}
    \    
    \    Set Global Variable    ${VALUE_DATE}    ${GS_VALUE_DATE}
    \    Set Global Variable    ${PROCESSING_DATE}    ${GS_PROCESSING_DATE}
    \    Set Global Variable    ${PUBLISH_DATE}    ${GS_VENDOR_PUBLISH_DATE_curr}
    \    
    \    
    \    Exit For Loop If    ${INDEX}==${Csv_Row_Count}
    
    ${TL_BASE_TOTALROW}    Set Variable    ${New_INDEX}
    Set Global Variable    ${TL_BASE_TOTALROW} 
    
Get Single Row value from CSV File and Write to Excel for Base Rate
    [Documentation]    sTLPath_Transformed_Data have the corresponding key fields for Bae Rate JSON file. This keyword will get row value from CSV File and write it to sTLPath_Transformed_Data.
    ...    @author: clanding    19FEB2019    - initial create
    ...    @update: clanding    20MAR2019    - added optional for Base Rate Code
    ...    @update: jdelacru    23JUL2019    - added 003W as option for converting tenor
    ...    @update: clanding    21AUG2020    - updated Zone1 to Zone2
    ...    @update: jdelacru    21SEP2020    - make sBaseRateCode as optional field
    ...    @update: jdelacru    21SEP2020    - deleted the condition in writing the subentity in transformed file
    [Arguments]    ${dRow}    ${irowid}    ${sZone2_Curr_Date}    ${sZone3_Curr_Date}    ${sConfigPriceType}    ${sTLPath_Transformed_Data}    ${sBaseRateCode}=None
    ${InstrumentType}    Get From Dictionary    ${dRow}    GS_INSTR_TYPE
    ${BaseRateCode}    Run Keyword If    '${sBaseRateCode}'=='None'    Get From Dictionary    ${dRow}    GS_INSTR_SUB_TYPE    
    ...    ELSE    Set Variable    ${sBaseRateCode}
    ${Currency}    Get From Dictionary    ${dRow}    GS_INSTR_CCY
    ${Tenor}    Get From Dictionary    ${dRow}    GS_INSTR_TENOR
    ${Price}    Get From Dictionary    ${dRow}    GS_INSTR_PRICE
    ${EffectiveDate}    Get From Dictionary    ${dRow}    GS_VENDOR_PUBLISH_DATE
    
    ${BASERATECODEConfig}    OperatingSystem.Get File    ${BASERATECODE_Config}
    ${BASERATECODE_Dict}    Convert Base Rate Config to Dictionary
    
    ${BaseRateCode_Converted}    Remove String    ${BaseRateCode}    ${SPACE}
    ${Tenor_Converted}    Get Substring    ${Tenor}    0    4
    
    ###convert 001W tenor to 007D --based from BASE_RATE_MAPPING table###
    ${Tenor_Converted}    Run Keyword If    '${Tenor_Converted}'=='001W'    Set Variable    007D
    ...    ELSE IF    '${Tenor_Converted}'=='002W'    Set Variable    014D
    ...    ELSE IF    '${Tenor_Converted}'=='003W'    Set Variable    021D
    ...    ELSE IF    '${Tenor_Converted}'=='001M' and '${BaseRateCode_Converted}'=='LIBOR' and '${sConfigPriceType}'=='BUYRATE'    Set Variable    001M
    ...    ELSE IF    '${Tenor_Converted}'=='001M' and '${BaseRateCode_Converted}'=='LMIR' and '${sConfigPriceType}'=='BUYRATE'    Set Variable
    ...    ELSE IF    '${Tenor_Converted}'=='001D' and '${BaseRateCode_Converted}'=='EONIA' and '${sConfigPriceType}'=='BUYRATE'    Set Variable
    ...    ELSE IF    '${Tenor_Converted}'=='001D' and '${BaseRateCode_Converted}'=='FED-FUND' and '${sConfigPriceType}'=='BUYRATE'    Set Variable
    ...    ELSE IF    '${Tenor_Converted}'=='001D' and '${BaseRateCode_Converted}'=='TIIE' and '${sConfigPriceType}'=='BUYRATE'    Set Variable
    ...    ELSE IF    '${Tenor_Converted}'=='001D' and '${BaseRateCode_Converted}'=='RBA' and '${sConfigPriceType}'=='LASTRATE'    Set Variable
    ...    ELSE    Set Variable    ${Tenor_Converted}
    
    Write Data to Excel Using Row Index    Transformed_BaseRate    rowid    ${irowid}    ${irowid}    ${sTLPath_Transformed_Data}
    Write Data to Excel Using Row Index    Transformed_BaseRate    instrumentType    ${irowid}    ${InstrumentType}    ${sTLPath_Transformed_Data}
    Write Data to Excel Using Row Index    Transformed_BaseRate    baseRateCode    ${irowid}    ${BaseRateCode_Converted}    ${sTLPath_Transformed_Data}
    Write Data to Excel Using Row Index    Transformed_BaseRate    currency    ${irowid}    ${Currency}    ${sTLPath_Transformed_Data}
    Write Data to Excel Using Row Index    Transformed_BaseRate    rateTenor    ${irowid}    ${Tenor_Converted}    ${sTLPath_Transformed_Data}
    Write Data to Excel Using Row Index    Transformed_BaseRate    rateEffectiveDate    ${irowid}    ${EffectiveDate}    ${sTLPath_Transformed_Data}
    
    Run Keyword If    '${sConfigPriceType}'=='BUYRATE'    Run Keywords    Write Data to Excel Using Row Index    Transformed_BaseRate    buyRate    ${irowid}    ${Price}    ${sTLPath_Transformed_Data}
    ...    AND    Write Data to Excel Using Row Index    Transformed_BaseRate    midRate    ${irowid}    null    ${sTLPath_Transformed_Data}
    ...    AND    Write Data to Excel Using Row Index    Transformed_BaseRate    sellRate    ${irowid}    null    ${sTLPath_Transformed_Data}
    ...    AND    Write Data to Excel Using Row Index    Transformed_BaseRate    lastRate    ${irowid}    null    ${sTLPath_Transformed_Data}
    ...    ELSE IF    '${sConfigPriceType}'=='MIDRATE'    Run Keywords    Write Data to Excel Using Row Index    Transformed_BaseRate    midRate    ${irowid}    ${Price}    ${sTLPath_Transformed_Data}
    ...    AND    Write Data to Excel Using Row Index    Transformed_BaseRate    buyRate    ${irowid}    null    ${sTLPath_Transformed_Data}
    ...    AND    Write Data to Excel Using Row Index    Transformed_BaseRate    sellRate    ${irowid}    null    ${sTLPath_Transformed_Data}
    ...    AND    Write Data to Excel Using Row Index    Transformed_BaseRate    lastRate    ${irowid}    null    ${sTLPath_Transformed_Data}
    ...    ELSE IF    '${sConfigPriceType}'=='SELLRATE'    Run Keywords    Write Data to Excel Using Row Index    Transformed_BaseRate    sellRate    ${irowid}    ${Price}    ${sTLPath_Transformed_Data}
    ...    AND    Write Data to Excel Using Row Index    Transformed_BaseRate    midRate    ${irowid}    null    ${sTLPath_Transformed_Data}
    ...    AND    Write Data to Excel Using Row Index    Transformed_BaseRate    buyRate    ${irowid}    null    ${sTLPath_Transformed_Data}
    ...    AND    Write Data to Excel Using Row Index    Transformed_BaseRate    lastRate    ${irowid}    null    ${sTLPath_Transformed_Data}
    ...    ELSE IF    '${sConfigPriceType}'=='LASTRATE'    Run Keywords    Write Data to Excel Using Row Index    Transformed_BaseRate    lastRate    ${irowid}    ${Price}    ${sTLPath_Transformed_Data}
    ...    AND    Write Data to Excel Using Row Index    Transformed_BaseRate    sellRate    ${irowid}    null    ${sTLPath_Transformed_Data}
    ...    AND    Write Data to Excel Using Row Index    Transformed_BaseRate    buyRate    ${irowid}    null    ${sTLPath_Transformed_Data}
    ...    AND    Write Data to Excel Using Row Index    Transformed_BaseRate    midRate    ${irowid}    null    ${sTLPath_Transformed_Data}
    
    Write Data to Excel Using Row Index    Transformed_BaseRate    spreadRate    ${irowid}    null    ${sTLPath_Transformed_Data}
    Write Data to Excel Using Row Index    Transformed_BaseRate    spreadEffectiveDate    ${irowid}    null    ${sTLPath_Transformed_Data}
    Write Data to Excel Using Row Index    Transformed_BaseRate    lineOfBusiness    ${irowid}    COMRLENDING    ${sTLPath_Transformed_Data}
    Write Data to Excel Using Row Index    Transformed_BaseRate    businessEntityName    ${irowid}    null    ${sTLPath_Transformed_Data}
    
    ${sZone2_Curr_Date}    Convert Date    ${sZone2_Curr_Date}    date_format=%d-%b-%Y    result_format=datetime
    ${sZone3_Curr_Date}    Convert Date    ${sZone3_Curr_Date}    date_format=%d-%b-%Y    result_format=datetime 
    
    ${Zone2_Input_Diff}    Subtract Date From Date    ${sZone2_Curr_Date}    ${EffectiveDate}        
    ${Zone3_Input_Diff}    Subtract Date From Date    ${sZone3_Curr_Date}    ${EffectiveDate}
    
    ${Zone2_Input_Diff}    Convert To String    ${Zone2_Input_Diff}
    ${Zone3_Input_Diff}    Convert To String    ${Zone3_Input_Diff}      
    
    ${SubEntity_EUR_Status}    Run Keyword And Return Status    Should Contain    ${Zone2_Input_Diff}    -
    ${SubEntity_AUD_Status}    Run Keyword And Return Status    Should Contain    ${Zone3_Input_Diff}    -  
    Run Keyword If    ${SubEntity_EUR_Status}==True and ${SubEntity_AUD_Status}==True    Write Data to Excel Using Row Index    Transformed_BaseRate    subEntity    ${irowid}    null    ${sTLPath_Transformed_Data}
    ...    ELSE    Write Data to Excel Using Row Index    Transformed_BaseRate    subEntity    ${irowid}    AUD,EUR    ${sTLPath_Transformed_Data}


Create Expected JSON for Base Rate TL
    [Documentation]    This keyword is used to create expected JSON payload for Base Rate Transformation Layer using the transformed data.
    ...    @author: clanding    20FEB2019    - initial create
    [Arguments]    ${sTransformedData_FilePath}    ${sInputJsonFile}
    
    Open Excel    ${dataset_path}${sTransformedData_FilePath}    
    ${Row_Count}    Get Row Count    Transformed_BaseRate
    ${jsonfile}    Set Variable    ${sInputJsonFile}.json
    Delete File If Exist    ${dataset_path}${jsonfile}
    Create File    ${dataset_path}${jsonfile}
    Close Current Excel Document
    :FOR    ${INDEX}    IN RANGE    1    ${Row_Count}
    \    
    \    ${File}    OperatingSystem.Get File    ${dataset_path}${jsonfile}
    \    ${File_Empty}    Run Keyword And Return Status    Should Be Empty    ${File}
    \    
    \    ${dTransformedData}    Create Dictionary Using Transformed Data and Return    ${dataset_path}${sTransformedData_FilePath}    ${INDEX}
    \    ${val_subEntity}    Get From Dictionary    ${dTransformedData}    subEntity
    \    ${New_JSON}    Update Key Values of Input JSON file for Base Rate TL	${dTransformedData}
    \    Log    ${New_JSON}
    \    ${converted_json}    Evaluate    json.dumps(${New_JSON})    json
    \    Log    ${converted_json}
    \    Run Keyword If    ${INDEX}==1 and '${val_subEntity}'!='null'    Append To File    ${dataset_path}${jsonfile}    ${converted_json}
         ...    ELSE IF    ${INDEX}!=1 and ${File_Empty}==${True} and '${val_subEntity}'!='null'    Append To File    ${dataset_path}${jsonfile}    ${converted_json}
         ...    ELSE IF    ${INDEX}!=1 and ${File_Empty}==${False} and '${val_subEntity}'!='null'    Append To File    ${dataset_path}${jsonfile}    ,${converted_json}
    \    
    \    Exit For Loop If    ${INDEX}==${Row_Count}

    ${file}    OperatingSystem.Get File    ${dataset_path}${jsonfile}
    ${converted_file}    Catenate    SEPARATOR=    [    ${file}    ]
    Create File    ${dataset_path}${jsonfile}    ${converted_file}
    

Create Dictionary Using Transformed Data and Return
    [Documentation]    This keyword is used to create dictionary for the row values of the Transformed File and Return dictionary.
    ...    @author: clanding    20FEB2019    - initial create
    [Arguments]    ${sTransformedData_FilePath}    ${iRowID}
    
    ${RowData_Dictionary}    Create Dictionary    
    Open Excel    ${sTransformedData_FilePath}    
    ${Column_Count}    Get Column Count    Transformed_BaseRate
    :FOR    ${INDEX}    IN RANGE    1    ${Column_Count}
    \    ${Column_Header}    Read Cell Data By Coordinates    Transformed_BaseRate    ${INDEX}    0
    \    ${Column_Value}    Read Cell Data By Coordinates    Transformed_BaseRate    ${INDEX}    ${iRowID}
    \    Set To Dictionary    ${RowData_Dictionary}    ${Column_Header}=${Column_Value}    
    \    Exit For Loop If    ${INDEX}==${Column_Count}
    Close Current Excel Document
    [Return]    ${RowData_Dictionary}

Update Key Values of Input JSON file for Base Rate TL
    [Documentation]    This keyword is used to update key values of JSON file and save to new file.
    ...    @author: clanding
    [Arguments]    ${dRowData}
    
    ${File_Path}    Set Variable    ${TemplateInput}    
    ${EMPTY}    Set Variable    
    ${JSON_Object}    Load JSON From File    ${File_Path}
    
    ## set variables
    ${INDEX_0}    Set Variable    0
    ${INDEX_00}    Set Variable    0
    
    ${baseRateCode_Val}    Get From Dictionary    ${dRowData}    baseRateCode
    ${New_JSON}    Run Keyword If    '${baseRateCode_Val}'=='null'    Set To Dictionary    ${JSON_Object}    baseRateCode=${NONE}
    ...    ELSE IF    '${baseRateCode_Val}'==''    Set To Dictionary    ${JSON_Object}    baseRateCode=${EMPTY}
    ...    ELSE IF    '${baseRateCode_Val}'=='Empty' or '${baseRateCode_Val}'=='empty'    Set To Dictionary    ${JSON_Object}    baseRateCode=${EMPTY}
    ...    ELSE IF    '${baseRateCode_Val}'=='no tag'    Set Variable    ${JSON_Object}
    ...    ELSE    Set To Dictionary    ${JSON_Object}    baseRateCode=${baseRateCode_Val}
    
    ${currency_Val}    Get From Dictionary    ${dRowData}    currency
	${New_JSON}    Run Keyword If    '${currency_Val}'=='null'    Set To Dictionary    ${New_JSON}    currency=${NONE}
    ...    ELSE IF    '${currency_Val}'==''    Set To Dictionary    ${New_JSON}    currency=${EMPTY}
    ...    ELSE IF    '${currency_Val}'=='Empty' or '${currency_Val}'=='empty'    Set To Dictionary    ${New_JSON}    currency=${EMPTY}
    ...    ELSE IF    '${currency_Val}'=='no tag'    Set Variable    ${New_JSON}
    ...    ELSE    Set To Dictionary    ${New_JSON}    currency=${currency_Val}
    
    ${buyRate_Val}    Get From Dictionary    ${dRowData}    buyRate
    ${Count}    Get Length    ${buyRate_Val}
    ${RoundOff_Rate_with_0}    ${buyRate_Val}    Run Keyword If    ${Count}>8    Round Off on the Nth Decimal Place    ${buyRate_Val}    6
    ...    ELSE    Set Variable    ${buyRate_Val}    ${buyRate_Val}
	${New_JSON}    Run Keyword If    '${buyRate_Val}'=='null'    Set To Dictionary    ${New_JSON}    buyRate=${NONE}
    ...    ELSE IF    '${buyRate_Val}'==''    Set To Dictionary    ${New_JSON}    buyRate=${EMPTY}
    ...    ELSE IF    '${buyRate_Val}'=='Empty' or '${buyRate_Val}'=='empty'    Set To Dictionary    ${New_JSON}    buyRate=${EMPTY}
    ...    ELSE IF    '${buyRate_Val}'=='no tag'    Set Variable    ${New_JSON}
    ...    ELSE    Set To Dictionary    ${New_JSON}    buyRate=${${buyRate_Val}}
    
    ${midRate_Val}    Get From Dictionary    ${dRowData}    midRate
    ${Count}    Get Length    ${midRate_Val}
    ${RoundOff_Rate_with_0}    ${midRate_Val}    Run Keyword If    ${Count}>8    Round Off on the Nth Decimal Place    ${midRate_Val}    6
    ...    ELSE    Set Variable    ${midRate_Val}    ${midRate_Val}
	${New_JSON}    Run Keyword If    '${midRate_Val}'=='null'    Set To Dictionary    ${New_JSON}    midRate=${NONE}
    ...    ELSE IF    '${midRate_Val}'==''    Set To Dictionary    ${New_JSON}    midRate=${EMPTY}
    ...    ELSE IF    '${midRate_Val}'=='Empty' or '${midRate_Val}'=='empty'    Set To Dictionary    ${New_JSON}    midRate=${EMPTY}
    ...    ELSE IF    '${midRate_Val}'=='no tag'    Set Variable    ${New_JSON}
    ...    ELSE    Set To Dictionary    ${New_JSON}    midRate=${${midRate_Val}}
    
    ${sellRate_Val}    Get From Dictionary    ${dRowData}    sellRate
    ${Count}    Get Length    ${sellRate_Val}
    ${RoundOff_Rate_with_0}    ${sellRate_Val}    Run Keyword If    ${Count}>8    Round Off on the Nth Decimal Place    ${sellRate_Val}    6
    ...    ELSE    Set Variable    ${sellRate_Val}    ${sellRate_Val}
	${New_JSON}    Run Keyword If    '${sellRate_Val}'=='null'    Set To Dictionary    ${New_JSON}    sellRate=${NONE}
    ...    ELSE IF    '${sellRate_Val}'==''    Set To Dictionary    ${New_JSON}    sellRate=${EMPTY}
    ...    ELSE IF    '${sellRate_Val}'=='Empty' or '${sellRate_Val}'=='empty'    Set To Dictionary    ${New_JSON}    sellRate=${EMPTY}
    ...    ELSE IF    '${sellRate_Val}'=='no tag'    Set Variable    ${New_JSON}
    ...    ELSE    Set To Dictionary    ${New_JSON}    sellRate=${${sellRate_Val}}
	
    ${lastRate_Val}    Get From Dictionary    ${dRowData}    lastRate
    ${Count}    Get Length    ${lastRate_Val}
    ${RoundOff_Rate_with_0}    ${lastRate_Val}    Run Keyword If    ${Count}>8    Round Off on the Nth Decimal Place    ${lastRate_Val}    6
    ...    ELSE    Set Variable    ${lastRate_Val}    ${lastRate_Val}
	${New_JSON}    Run Keyword If    '${lastRate_Val}'=='null'    Set To Dictionary    ${New_JSON}    lastRate=${NONE}
    ...    ELSE IF    '${lastRate_Val}'==''    Set To Dictionary    ${New_JSON}    lastRate=${EMPTY}
    ...    ELSE IF    '${lastRate_Val}'=='Empty' or '${lastRate_Val}'=='empty'    Set To Dictionary    ${New_JSON}    lastRate=${EMPTY}
    ...    ELSE IF    '${lastRate_Val}'=='no tag'    Set Variable    ${New_JSON}
    ...    ELSE    Set To Dictionary    ${New_JSON}    lastRate=${${lastRate_Val}}
	
    ${rateEffectiveDate_Val}    Get From Dictionary    ${dRowData}    rateEffectiveDate
	${New_JSON}    Run Keyword If    '${rateEffectiveDate_Val}'=='null'    Set To Dictionary    ${New_JSON}    rateEffectiveDate=${NONE}
    ...    ELSE IF    '${rateEffectiveDate_Val}'==''    Set To Dictionary    ${New_JSON}    rateEffectiveDate=${EMPTY}
    ...    ELSE IF    '${rateEffectiveDate_Val}'=='Empty' or '${rateEffectiveDate_Val}'=='empty'    Set To Dictionary    ${New_JSON}    rateEffectiveDate=${EMPTY}
    ...    ELSE IF    '${rateEffectiveDate_Val}'=='no tag'    Set Variable    ${New_JSON}
    ...    ELSE    Set To Dictionary    ${New_JSON}    rateEffectiveDate=${rateEffectiveDate_Val}
	
    ${spreadRate_Val}    Get From Dictionary    ${dRowData}    spreadRate
	${New_JSON}    Run Keyword If    '${spreadRate_Val}'=='null'    Set To Dictionary    ${New_JSON}    spreadRate=${NONE}
    ...    ELSE IF    '${spreadRate_Val}'==''    Set To Dictionary    ${New_JSON}    spreadRate=${EMPTY}
    ...    ELSE IF    '${spreadRate_Val}'=='Empty' or '${spreadRate_Val}'=='empty'    Set To Dictionary    ${New_JSON}    spreadRate=${EMPTY}
    ...    ELSE IF    '${spreadRate_Val}'=='no tag'    Set Variable    ${New_JSON}
    ...    ELSE    Set To Dictionary    ${New_JSON}    spreadRate=${${spreadRate_Val}}
	
    ${spreadEffectiveDate_Val}    Get From Dictionary    ${dRowData}    spreadEffectiveDate
	${New_JSON}    Run Keyword If    '${spreadEffectiveDate_Val}'=='null'    Set To Dictionary    ${New_JSON}    spreadEffectiveDate=${NONE}
    ...    ELSE IF    '${spreadEffectiveDate_Val}'==''    Set To Dictionary    ${New_JSON}    spreadEffectiveDate=${EMPTY}
    ...    ELSE IF    '${spreadEffectiveDate_Val}'=='Empty' or '${spreadEffectiveDate_Val}'=='empty'    Set To Dictionary    ${New_JSON}    spreadEffectiveDate=${EMPTY}
    ...    ELSE IF    '${spreadEffectiveDate_Val}'=='no tag'    Set Variable    ${New_JSON}
    ...    ELSE    Set To Dictionary    ${New_JSON}    spreadEffectiveDate=${spreadEffectiveDate_Val}
	
    ${rateTenor_Val}    Get From Dictionary    ${dRowData}    rateTenor
	${New_JSON}    Run Keyword If    '${rateTenor_Val}'=='null'    Set To Dictionary    ${New_JSON}    rateTenor=${NONE}
    ...    ELSE IF    '${rateTenor_Val}'==''    Set To Dictionary    ${New_JSON}    rateTenor=${NONE}
    ...    ELSE IF    '${rateTenor_Val}'=='Empty' or '${rateTenor_Val}'=='empty'    Set To Dictionary    ${New_JSON}    rateTenor=${EMPTY}
    ...    ELSE IF    '${rateTenor_Val}'=='no tag'    Set Variable    ${New_JSON}
    ...    ELSE    Set To Dictionary    ${New_JSON}    rateTenor=${rateTenor_Val}
    
    ${instrumentType_Val}    Get From Dictionary    ${dRowData}    instrumentType
	${New_JSON}    Run Keyword If    '${instrumentType_Val}'=='null'    Set To Dictionary    ${New_JSON}    instrumentType=${NONE}
    ...    ELSE IF    '${instrumentType_Val}'==''    Set To Dictionary    ${New_JSON}    instrumentType=${EMPTY}
    ...    ELSE IF    '${instrumentType_Val}'=='Empty' or '${instrumentType_Val}'=='empty'    Set To Dictionary    ${New_JSON}    instrumentType=${EMPTY}
    ...    ELSE IF    '${instrumentType_Val}'=='no tag'    Set Variable    ${New_JSON}
    ...    ELSE    Set To Dictionary    ${New_JSON}    instrumentType=${instrumentType_Val}
	
   ${Val_LOB_0}    Get From Dictionary    ${dRowData}    lineOfBusiness
   ${Lob_List}    Split String    ${Val_LOB_0}    /
   ${LOB_count}    Get Length    ${Lob_List}
   
   ${val_businessEntityName_0}    Get From Dictionary    ${dRowData}    businessEntityName
   ${businessEntityName_list}    Split String    ${val_businessEntityName_0}    /
   
   ${val_subEntity_0}    Get From Dictionary    ${dRowData}    subEntity
   ${subEntity_list}    Split String    ${val_subEntity_0}    /
   
   ${lineOfBusinessList}    Create List
   
   :FOR    ${INDEX_0}    IN RANGE    ${LOB_count}
   \    Log    ${INDEX_0}
   \    ${Val_LOB}    Get From List    ${Lob_List}    ${INDEX_0}
   \    
   \    ${Val_LOB_0}    Run Keyword If    '${Val_LOB_0}'!=''    Get From List    ${Lob_List}    0
   \    ${Val_LOB}    Run Keyword If    '${Val_LOB_0}'=='lineOfBusiness=""'    Set Variable    ${EMPTY}
        ...    ELSE IF    '${Val_LOB_0}'=='lineOfBusiness=null'    Set Variable    ${NONE}
        ...    ELSE IF    '${Val_LOB_0}'=='lineOfBusiness=null'    Set Variable    ${NONE}
        ...    ELSE    Set Variable    ${Val_LOB}
   \    
   \    ${businessEntityNameDictionary}    Create Array for Multiple Values    ${businessEntityName_list}    ${INDEX_0}    businessEntityName    ,
   \    ${subEntityDictionary}    Create Array for Multiple Values    ${subEntity_list}    ${INDEX_0}    subEntity    ,
   \    
   \    ${businessEntityNameDictionary}    Run Keyword If    ${businessEntityNameDictionary}==${NONE}    Create List
        ...    ELSE    Set Variable    ${businessEntityNameDictionary}
   \    
   \    ${subEntityDictionary}    Run Keyword If    ${subEntityDictionary}==${NONE}    Create List
        ...    ELSE    Set Variable    ${subEntityDictionary}
   \    
   \    ${lineOfBusinessDictionary}    Create Dictionary    lineOfBusiness=${Val_LOB}
        ...    businessEntityName=${businessEntityNameDictionary}    subEntity=${subEntityDictionary}
   \    
   \    ${businessEntityNameVal}    Get From List    ${businessEntityNameList}    ${INDEX_0}
   \    ${subEntityVal}    Get From List    ${subEntityList}    ${INDEX_0}
   \    Run Keyword If    '${businessEntityNameVal}'=='no tag'    Remove From Dictionary    ${lineOfBusinessDictionary}    businessEntityName
   \    Run Keyword If    '${subEntityVal}'=='no tag'    Remove From Dictionary    ${lineOfBusinessDictionary}    subEntity
   \    Run Keyword If    '${Val_LOB}'=='lineOfBusiness=no tag'    Remove From Dictionary    ${lineOfBusinessDictionary}    lineOfBusiness
   \    
   \    Append To List    ${lineOfBusinessList}    ${lineOfBusinessDictionary}    
   \    Exit For Loop If    ${INDEX_0}==${LOB_count} or '${Val_LOB_0}'==''
   
   ${Lobs_Dict}    Create List    
   
   ${New_JSON}    Run Keyword If    '${Val_LOB_0}'=='null'    Set To Dictionary    ${New_JSON}    lobs=${NONE}    
   ...    ELSE IF    '${Val_LOB_0}'==''    Set To Dictionary    ${New_JSON}    lobs=${Lobs_Dict}
   ...    ELSE IF    '${Val_LOB_0}'=='Empty' or '${Val_LOB_0}'=='empty'    Set To Dictionary    ${New_JSON}    lobs=${Lobs_Dict}
   ...    ELSE IF    '${Val_LOB_0}'=='no tag'    Set Variable    ${New_JSON}
   ...    ELSE    Set To Dictionary    ${New_JSON}    lobs=${lineOfBusinessList}
   Log    ${New_JSON}
   
   [Return]    ${New_JSON}

Create Expected TextJMS XML for Base Rate TL
    [Documentation]    This keyword is used to create expected XML for every row in the csv file and save file name with Base Rate Code, Funding Desk and Repricing Frequency.
    ...    @author: clanding    27FEB2019    - initial create
    ...    @update: jdelacru    11AUG2020    - added new argument ${sTemplateFilePath}
    [Arguments]    ${sTransformedData_FilePath}    ${sInputFilePath}    ${sFileName}    ${sTemplateFilePath}
    
    Open Excel    ${dataset_path}${sTransformedData_FilePath}    
    ${Row_Count}    Get Row Count    Transformed_BaseRate
    Close Current Excel Document
    :FOR    ${INDEX}    IN RANGE    1    ${Row_Count}
    \    
    \    ${dTransformedData}    Create Dictionary Using Transformed Data and Return    ${dataset_path}${sTransformedData_FilePath}    ${INDEX}
    \    
    \    Get Individual Subentity Value and Create XML for TL    ${dTransformedData}    ${sInputFilePath}    ${sFileName}    ${sTemplateFilePath}
    \    Exit For Loop If    ${INDEX}==${Row_Count}
    
    
Get Individual Subentity Value and Create XML for TL
    [Documentation]    This keyword is used to get individual subentity values for multiple subentities in one line of business values.
    ...    i.e. sample input in datasheet AUD,NY
    ...    @author: clanding    27FEB2019    - initial create
    ...    @update: clanding    03MAR2019    - added checking for inactive funding desk and create expected textjms
    ...    @update: jdelacru    11AUG2020    - added new argument ${sTemplateFilePath}
    [Arguments]    ${dRowData}    ${sInputFilePath}    ${sFileName}    ${sTemplateFilePath}
    
    ${subEntity_Val}    Get From Dictionary    ${dRowData}    subEntity
    ${SubEntityList}    Split String    ${subEntity_Val}    ,
    ${subentity_count}    Get Length    ${subentity_list}
    
    :FOR    ${INDEX}    IN RANGE    0    ${subentity_count}
    \    ${SubEntityVal}    Get From List    ${SubEntityList}    ${INDEX}
    \    
    \    Create Initial wsFinalLIQDestination for Base Rate TL    ${dRowData}    ${SubEntityVal}    ${sInputFilePath}    ${sFileName}    ${sTemplateFilePath}
    \    ${FundingDeskStat}    Get Funding Desk Status from Table Maintenance    ${SubEntityVal}
    \    Run Keyword If    '${FundingDeskStat}'=='I'    Create Expected XML for Inactive Funding Desk    ${SubEntityVal}    ${sInputFilePath}    ${sFileName}
         ...    ELSE    Log    Funding Desk is Active. Keyword is not applicable.
    \    Exit For Loop If    ${INDEX}==${subentity_count}

Create Initial wsFinalLIQDestination for Base Rate TL
    [Documentation]    This keyword is used to create initial wsFinalLIQDestination for each valid Base Rate Code for TL.
    ...    @author: clanding    27FEB2019    - initial create
    ...    @update: jdelacru    11AUG2020    - added new argument ${sTemplateFilePath}
    ...    @update: jdelacru    06OCT2020    - used conditional statement in assigning the value of ${val_RateTenor}
    [Arguments]    ${dRowData}    ${sSubentityVal}    ${sInputFilePath}    ${sFileName}    ${sTemplateFilePath}
    
    ${val_RateTenor}    Run Keyword If    '&{dRowData}[rateTenor]'=='None'    Set Variable    ${EMPTY}
    ...    ELSE    Strip String    &{dRowData}[rateTenor]    both    0
    
    ${BASERATECODEConfig}    OperatingSystem.Get File    ${BASERATECODE_Config}
    ${BASERATECODE_Dict}    Convert Base Rate Config to Dictionary
    
    Delete File If Exist    ${dataset_path}${sInputFilePath}${Expected_Error_Message}
    Create File    ${dataset_path}${sInputFilePath}${Expected_Error_Message}    
    
    Log    Config check for Base Rate Code and Buy Rate
    ${Stat_BuyRate}    Run Keyword And Return Status    Should Be Equal    &{dRowData}[buyRate]    null
    ${val_Buyrate}    Run Keyword If    ${Stat_BuyRate}==${True}    Set Variable    ${NONE}
    ...    ELSE    Set Variable    &{dRowData}[buyRate]
    ${BUYRATE}    Run Keyword If    ${val_Buyrate}!=0 or ${val_Buyrate}!=${NONE}    Set Variable    BUYRATE
    ${BaseConfig_Buy_exist}    Run Keyword And Return Status    Should Contain    ${BASERATECODEConfig}    &{dRowData}[baseRateCode].${BUYRATE}
    ${BaseCode_Buy}    Run Keyword If    ${BaseConfig_Buy_exist}==${True}    Get From Dictionary    ${BASERATECODE_Dict}    &{dRowData}[baseRateCode].${BUYRATE}
    ${expected_error}    Run Keyword If    ${BaseConfig_Buy_exist}==${True} and ${val_Buyrate}!=${NONE}    Update Expected XML Elements for wsFinalLIQDestination - Base Rate TL    ${sInputFilePath}    ${sFileName}    ${BaseCode_Buy}    &{dRowData}[currency]            
    ...    &{dRowData}[rateEffectiveDate]    ${val_RateTenor}    ${sSubentityVal}    ${val_Buyrate}    ${sTemplateFilePath}
    ...    ELSE IF    ${val_Buyrate}!=0    Catenate    There is no baseratecode configuration available at COMRLENDING corresponding to baseratecode-&{dRowData}[baseRateCode]  and Buyrate:${val_Buyrate}
    
    Run Keyword If    '${expected_error}'!='None'    Append To File    ${dataset_path}${sInputFilePath}${Expected_Error_Message}    ${expected_error}${\n}    
    
    Log    Config check for Base Rate Code and Mid Rate
    ${Stat_MidRate}    Run Keyword And Return Status    Should Be Equal    &{dRowData}[midRate]    null
    ${val_MidRate}    Run Keyword If    ${Stat_MidRate}==${True}    Set Variable    ${NONE}
    ...    ELSE    Set Variable    &{dRowData}[midRate]
    ${MIDRATE}    Run Keyword If    ${val_MidRate}!=0 or ${val_MidRate}!=${NONE}    Set Variable    MIDRATE
    ${BaseConfig_Mid_exist}    Run Keyword And Return Status    Should Contain    ${BASERATECODEConfig}    &{dRowData}[baseRateCode].${MIDRATE}
    ${BaseCode_Mid}    Run Keyword If    ${BaseConfig_Mid_exist}==True    Get From Dictionary    ${BASERATECODE_Dict}    &{dRowData}[baseRateCode].${MIDRATE}
    ${expected_error}    Run Keyword If    ${BaseConfig_Mid_exist}==True and ${val_MidRate}!=${NONE}    Update Expected XML Elements for wsFinalLIQDestination - Base Rate TL    ${sInputFilePath}    ${sFileName}    ${BaseCode_Mid}    &{dRowData}[currency]            
    ...    &{dRowData}[rateEffectiveDate]    ${val_RateTenor}    ${sSubentityVal}    ${val_MidRate}    ${sTemplateFilePath}
    ...    ELSE IF    ${val_MidRate}!=0    Catenate    There is no baseratecode configuration available at COMRLENDING corresponding to baseratecode-&{dRowData}[baseRateCode]  and Midrate:${val_MidRate}
    
    Run Keyword If    '${expected_error}'!='None'    Append To File    ${dataset_path}${sInputFilePath}${Expected_Error_Message}    ${expected_error}${\n}
    
    Log    Config check for Base Rate Code and Sell Rate
    ${Stat_SellRate}    Run Keyword And Return Status    Should Be Equal    &{dRowData}[sellRate]    null
    ${val_Sellrate}    Run Keyword If    ${Stat_SellRate}==${True}    Set Variable    ${NONE}
    ...    ELSE    Set Variable    &{dRowData}[sellRate]
    ${SELLRATE}    Run Keyword If    ${val_Sellrate}!=0 or ${val_Sellrate}!=${NONE}    Set Variable    SELLRATE
    ${BaseConfig_Sell_exist}    Run Keyword And Return Status    Should Contain    ${BASERATECODEConfig}    &{dRowData}[baseRateCode].${SELLRATE}
    ${BaseCode_Sell}    Run Keyword If    ${BaseConfig_Sell_exist}==True    Get From Dictionary    ${BASERATECODE_Dict}    &{dRowData}[baseRateCode].${SELLRATE}
    ${expected_error}    Run Keyword If    ${BaseConfig_Sell_exist}==True and ${val_Sellrate}!=${NONE}    Update Expected XML Elements for wsFinalLIQDestination - Base Rate TL    ${sInputFilePath}    ${sFileName}    ${BaseCode_Sell}    &{dRowData}[currency]            
    ...    &{dRowData}[rateEffectiveDate]    ${val_RateTenor}    ${sSubentityVal}    ${val_Sellrate}    ${sTemplateFilePath}
    ...    ELSE IF    ${val_Sellrate}!=0    Catenate    There is no baseratecode configuration available at COMRLENDING corresponding to baseratecode-&{dRowData}[baseRateCode]  and Sellrate:${val_Sellrate}
    
    Run Keyword If    '${expected_error}'!='None'    Append To File    ${dataset_path}${sInputFilePath}${Expected_Error_Message}    ${expected_error}${\n}
    
    Log    Config check for Base Rate Code and Last Rate
    ${Stat_LastRate}    Run Keyword And Return Status    Should Be Equal    &{dRowData}[lastRate]    null
    ${val_LastRate}    Run Keyword If    ${Stat_LastRate}==${True}    Set Variable    ${NONE}
    ...    ELSE    Set Variable    &{dRowData}[lastRate]
    ${LASTRATE}    Run Keyword If    ${val_LastRate}!=0 or ${val_LastRate}!=${NONE}    Set Variable    LASTRATE
    ${BaseConfig_Last_exist}    Run Keyword And Return Status    Should Contain    ${BASERATECODEConfig}    &{dRowData}[baseRateCode].${LASTRATE}
    ${BaseCode_Last}    Run Keyword If    ${BaseConfig_Last_exist}==True    Get From Dictionary    ${BASERATECODE_Dict}    &{dRowData}[baseRateCode].${LASTRATE}
    ${expected_error}    Run Keyword If    ${BaseConfig_Last_exist}==True and ${val_LastRate}!=${NONE}    Update Expected XML Elements for wsFinalLIQDestination - Base Rate TL    ${sInputFilePath}    ${sFileName}    ${BaseCode_Last}    &{dRowData}[currency]            
    ...    &{dRowData}[rateEffectiveDate]    ${val_RateTenor}    ${sSubentityVal}    ${val_LastRate}    ${sTemplateFilePath}
    ...    ELSE IF    ${val_LastRate}!=0    Catenate    There is no baseratecode configuration available at COMRLENDING corresponding to baseratecode-&{dRowData}[baseRateCode]  and Lastrate:${val_LastRate}
    
    Run Keyword If    '${expected_error}'!='None'    Append To File    ${dataset_path}${sInputFilePath}${Expected_Error_Message}    ${expected_error}${\n}
    
Update Expected XML Elements for wsFinalLIQDestination - Base Rate TL
    [Documentation]    This keyword is used to update XML Elements using the input dictionary values for wsFinalLIQDestination for Base Rate TL
    ...    @author: clanding    27FEB2019    - initial create
    ...    @update: clanding    19MAR2019    - added handling for ${sRateTenor} if empty
    ...    @update: jdelacru    11AUG2020    - added new argument ${sTemplateFilePath}
    ...    @update: jdelacru    21SEP2020    - using division method in evaluating the iRate instead of multiplying it to 0.01
    ...    @update: jdelacru    06OCT2020    - used the keyword Multiply Two Values With Exact Precision to get the actual value of rates
    [Arguments]    ${sInputFilePath}    ${sFileName}    ${sBaseCode}    ${sCurrency}    ${sRateEffDate}    ${sRateTenor}    ${sSubentityVal}    ${iRate}    ${sTemplateFilePath}
    
    ${sRateTenor}    Run Keyword If    '${sRateTenor}'==''    Set Variable    None
    ...    ELSE    Set Variable    ${sRateTenor}    
    
    ${Expected_wsFinalLIQDestination}    Set Variable    ${dataset_path}${sInputFilePath}${sFileName}_${sBaseCode}_${sRateTenor}_${sSubentityVal}.xml
    ${template}    Set Variable    ${dataset_path}${sTemplateFilePath}template_TextJMS_baserate_tl.xml
    Delete File If Exist    ${Expected_wsFinalLIQDestination}
    Create File    ${Expected_wsFinalLIQDestination}    
    
    ${xpath}    Set Variable    UpdateFundingRate
    ${val_RateEffDate}    Convert Date    ${sRateEffDate}    result_format=%d-%b-%Y
    ${RoundOff_Rate_with_0}    ${iRate}    Round Off on the Nth Decimal Place    ${iRate}    6
    ${val_Rate}    Multiply Two Values With Exact Precision    ${iRate}    0.01
    ${val_Rate}    Convert To String    ${val_Rate}  
    
    ${Updated_template}    Set Element Attribute    ${template}    baseRate    ${sBaseCode}    xpath=${xpath}
    ${Updated_template}    Set Element Attribute    ${Updated_template}    currency    ${sCurrency}    xpath=${xpath}
    ${Updated_template}    Set Element Attribute    ${Updated_template}    effectiveDate    ${val_RateEffDate}    xpath=${xpath}
    ${Updated_template}    Run Keyword If    '${sRateTenor}'=='None'    Remove Element Attribute    ${Updated_template}    repricingFrequency    xpath=${xpath}    
    ...    ELSE    Set Element Attribute    ${Updated_template}    repricingFrequency    ${sRateTenor}    xpath=${xpath}
    ${Updated_template}    Set Element Attribute    ${Updated_template}    fundingDesk    ${sSubentityVal}    xpath=${xpath}
    ${Updated_template}    Set Element Attribute    ${Updated_template}    rate    ${val_Rate}    xpath=${xpath}
    
    ${attr}    XML.Get Element Attributes    ${Updated_template}    ${xpath}
    Log    ${attr}
    Save Xml    ${Updated_template}    ${Expected_wsFinalLIQDestination}

Create Prerequisite for Multiple GS Files Scenario
    [Documentation]    This keyword is used to get the number of input GS files in the dataset and transformed the last CSV file to XLS file.
    ...    @author: clanding    04MAR2019    - intial create
    ...    @update: clanding    19MAR2019    - added Create Individual Expected JSON for Base Rate TL
    ...    @update: jdelacru    28AUG2019    - added index for the filename in creating expected input/output json and textjms to handle
    ...                                        processing file with the same details but different rate
    ...    @update: dahijara    20NOV2019    - updated file format from XLS to XLSX
    ...    @update: clanding    21AUG2020    - added new argument    ${sTemplateFilePath}
    [Arguments]    ${sInputFilePath}    ${sTransformedData_FilePath}    ${sTransformedDataTemplate_FilePath}    ${sInputGSFile}    ${sInputJson}
    ...    ${sExpected_TextJMS}    ${Delimiter}=None    ${sTemplateFilePath}=None
    
    @{InputGSFile_List}    Run Keyword If    '${Delimiter}'=='None'    Split String    ${sInputGSFile}    ,
    ...    ELSE    Split String    ${sInputGSFile}    ${Delimiter}
    ${InputGSFile_Count}    Get Length    ${InputGSFile_List}
    ${TransformedData_List}    Create List
    :FOR    ${Index}    IN RANGE    ${InputGSFile_Count}
    \    ${InputGSFile_Count_Last}    Evaluate    ${InputGSFile_Count}-1    
    \    ${InputGSFile}    Get From List    ${InputGSFile_List}    ${InputGSFile_Count_Last}
    \    Transform Base Rate CSV Data to XLS File Readable for JSON Creation    ${sInputFilePath}${InputGSFile}    ${sInputFilePath}${sTransformedData_FilePath}_${Index}.${XLSX}
         ...    ${sTransformedDataTemplate_FilePath}
    \    Create Expected JSON for Base Rate TL    ${sInputFilePath}${sTransformedData_FilePath}_${Index}.${XLSX}    ${sInputFilePath}${sInputJson}_${Index}
    \    Create Individual Expected JSON for Base Rate TL    ${sInputFilePath}${sTransformedData_FilePath}_${Index}.${XLSX}    ${sInputFilePath}${sInputJson}_${Index}
    \    Create Expected TextJMS XML for Base Rate TL    ${sInputFilePath}${sTransformedData_FilePath}_${Index}.${XLSX}    ${sInputFilePath}    ${sExpected_TextJMS}_${Index}    ${sTemplateFilePath}
    \    Append To List    ${TransformedData_List}    ${sInputFilePath}${sTransformedData_FilePath}_${Index}.${XLSX}
    \    ${InputGSFile_Count}    Evaluate    ${InputGSFile_Count}-1
    
    Set Global Variable    ${TRANSFORMEDDATA_LIST}    ${TransformedData_List}
    Log    ${TRANSFORMEDDATA_LIST}
    
Create Expected XML for Inactive Funding Desk
    [Documentation]    This keyword is used to create expected xml file for Funding Desk that are inactive in LIQ during run time.
    ...    @author: clanding    15MAR2019    - initial create
    [Arguments]    ${sFundingDesk}    ${sInputFilePath}    ${Expected_wsFinalLIQDestination}
    
    ${template}    Set Variable    ${dataset_path}${sInputFilePath}${TEMPLATE_INACTIVEFUNDINGDESK}
    Delete File If Exist    ${dataset_path}${sInputFilePath}${Expected_wsFinalLIQDestination}.xml
    ${msg}    Catenate    Value ${sFundingDesk} of field fundingDesk is not an active code in table Funding Desk.
    Create File    ${dataset_path}${sInputFilePath}${Expected_wsFinalLIQDestination}.xml    ${msg}
    
    ${FUNDINGDESK_INACTIVE_COUNTER}    Evaluate    ${FUNDINGDESK_INACTIVE_COUNTER}+1
    Set Global Variable    ${FUNDINGDESK_INACTIVE_COUNTER}    ${FUNDINGDESK_INACTIVE_COUNTER}

Create Individual Expected JSON for Base Rate TL
    [Documentation]    This keyword is used to create indeividual expected JSON payload for Base Rate Transformation Layer using the transformed data.
    ...    @author: clanding    18MAR2019    - initial create
    ...    @update: jdelacru    21SEP2020    - added ${val_subEntity} variable to correct the filename of generated json file
    [Arguments]    ${sTransformedData_FilePath}    ${sInputJsonFile}
    
    Open Excel    ${dataset_path}${sTransformedData_FilePath}    
    ${Row_Count}    Get Row Count    Transformed_BaseRate
    Close Current Excel Document
    :FOR    ${INDEX}    IN RANGE    1    ${Row_Count}
    \    
    \    ${dTransformedData}    Create Dictionary Using Transformed Data and Return    ${dataset_path}${sTransformedData_FilePath}    ${INDEX}
    \    ${val_baseRateCode}    Get From Dictionary    ${dTransformedData}    baseRateCode
    \    ${val_rateTenor}    Get From Dictionary    ${dTransformedData}    rateTenor
    \    ${val_rateTenor}    Run Keyword If    '${val_rateTenor}'==''    Set Variable    None
         ...    ELSE    Set Variable    ${val_rateTenor}
    \
    \    ${New_JSON}    Update Key Values of Input JSON file for Base Rate TL	${dTransformedData}
    \    Log    ${New_JSON}
    \    ${converted_json}    Evaluate    json.dumps(${New_JSON})        json
    \    Log    ${converted_json}
    \    
    \    Delete File If Exist    ${dataset_path}${sInputJsonFile}_${val_baseRateCode}_${val_rateTenor}.json
    \    Create File    ${dataset_path}${sInputJsonFile}_${val_baseRateCode}_${val_rateTenor}.json    ${converted_json}
    \    
    \    Exit For Loop If    ${INDEX}==${Row_Count}
    

Convert GS Filename with Timestamp to Request ID
    [Documentation]    This keyword converts the GS Filename with Timestamp to a value that can be used on the Request ID for FFC
    ...    @uathor: cfrancis    12SEP2019    - initial create
    [Arguments]    ${sFileExtension}=None
    ${RequestID}    Get Substring    ${GSFILENAME_WITHTIMESTAMP}   22
    ${RequestID}    Remove String    ${RequestID}    ROUP
    ${FileExtension}    Run Keyword If    '${sFileExtension}'=='None'    Set Variable    csv
    ...    ELSE    Set Variable    ${sFileExtension}
    ${RequestID}    Remove String    ${RequestID}    .${FileExtension}
    Set Global Variable    ${GSFILENAME_WITHTIMESTAMP}    ${RequestID}
