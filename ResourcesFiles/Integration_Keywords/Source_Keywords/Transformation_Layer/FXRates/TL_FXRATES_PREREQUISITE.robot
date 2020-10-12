*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot


*** Keywords ***
    
Create Dictionary per Row Count for Csv FXRates Content
    [Documentation]    This keyword is used to get the row values from the input csv file with the corresponding column value.
    ...    This will create dictionary and return dictionoary.
    ...    Then create dictionary and return.
    ...    @author: mnanquil    04MAR2019    - initial create
    [Arguments]    ${aCSV_Content}    ${aCSV_Row_Val}
    ${GS_SNAP_index}    Get Column Header Index From Input Csv File And Return    ${aCSV_Content}    GS_SNAP
    ${GS_INSTR_DESC_index}    Get Column Header Index From Input Csv File And Return    ${aCSV_Content}    GS_INSTR_DESC
    ${GS_BASE_CCY_index}    Get Column Header Index From Input Csv File And Return    ${aCSV_Content}    GS_BASE_CCY
    ${GS_TRGT_CCY_index}    Get Column Header Index From Input Csv File And Return    ${aCSV_Content}    GS_TRGT_CCY
    ${GS_INSTR_TYPE_index}    Get Column Header Index From Input Csv File And Return    ${aCSV_Content}    GS_INSTR_TYPE
    ${GS_INSTR_PRC_TYPE_index}    Get Column Header Index From Input Csv File And Return    ${aCSV_Content}    GS_INSTR_PRC_TYPE
    ${GS_INSTR_PRICE_index}    Get Column Header Index From Input Csv File And Return    ${aCSV_Content}    GS_INSTR_PRICE
    ${GS_VALUE_DATE_index}    Get Column Header Index From Input Csv File And Return    ${aCSV_Content}    GS_VALUE_DATE
    ${GS_PROCESSING_DATE_index}    Get Column Header Index From Input Csv File And Return    ${aCSV_Content}    GS_PROCESSING_DATE
    ${FromCurrency}    Get From List    ${aCSV_Row_Val}    ${GS_BASE_CCY_index}
    ${ToCurrency}    Get From List    ${aCSV_Row_Val}    ${GS_TRGT_CCY_index}
    ${RateType}    Get From List    ${aCSV_Row_Val}    ${GS_INSTR_TYPE_index}
    ${Rate}    Get From List    ${aCSV_Row_Val}    ${GS_INSTR_PRC_TYPE_index}
    ${PriceRate}    Get From List    ${aCSV_Row_Val}    ${GS_INSTR_PRICE_index}
    ${ProcessingDate}    Get From List    ${aCSV_Row_Val}    ${GS_PROCESSING_DATE_index}
    ${dCSV_Row}    Create Dictionary    GS_BASE_CCY=${FromCurrency}    GS_TRGT_CCY=${ToCurrency}    GS_INSTR_TYPE=${RateType}
    ...    GS_INSTR_PRC_TYPE=${Rate}    GS_INSTR_PRICE=${PriceRate}    GS_PROCESSING_DATE=${ProcessingDate}
    [Return]    ${dCSV_Row}
    
Transform FXRates CSV Data to XLS File Readable for JSON Creation
    [Documentation]    This keyword is used to get Zone 1 and Zone 3 LIQ Business Dates, read each row of the CSV File and write to an XLS File in preparation for
    ...    JSON creation. 
    ...    This will create 1 payload only for multiple rows.
    ...    @author: mnanquil    04MAR2019    - initial create
    ...    @update: cfrancis    18JUL2019    - added funding desk argument to be passed down to
    ...    @update: cfrancis    15AUG2019    - added checking for emtpy rows and will be ignored on loop
    ...    @update: cfrancis    19AUG2019    - added checking for duplicate rows and will be ignored on loop
    ...    Get Single Row value from CSV File and Write to Excel for FXRates Keyword
    [Arguments]    ${sCSV_FilePath}    ${sTransformedData_FilePath}    ${sTransformedDataTemplate_FilePath}    ${sTransformedDataXML_FilePath}    ${sFunding_Desk}  
    ${CSV_Content_List}    Read Csv As List    ${dataset_path}${sCSVFilePath}
    ${GS_INSTR_SUB_TYPE_prev}    Set Variable
    ${GS_INSTR_TENOR_prev}    Set Variable
    ${GS_VENDOR_PUBLISH_DATE_prev}    Set Variable
    
    ${Zone1_Curr_Date}    Get LoanIQ Business Date per Zone and Return    Zone1
    ${Zone3_Curr_Date}    Get LoanIQ Business Date per Zone and Return    Zone3
    Close All Windows on LIQ
    
    Delete File If Exist    ${dataset_path}${sTransformedData_FilePath}
    Copy File    ${dataset_path}${sTransformedDataTemplate_FilePath}    ${dataset_path}${sTransformedData_FilePath}
    Copy File    ${dataset_path}${sTransformedDataTemplate_FilePath}    ${dataset_path}${sTransformedDataXML_FilePath}
    ${Csv_Row_Count}    Get Length    ${CSV_Content_List}
    ${INDEX}    Set Variable    1
    ${New_INDEX}    Set Variable    1
    ${INDEX_ForGrouping}    Set Variable    1
    ${Counter}    Set Variable    0
    ${Offset}    Set Variable    1
    :FOR    ${INDEX}    IN RANGE    1    ${Csv_Row_Count}
    \    ${Row_Val_List}    Get From List    ${CSV_Content_List}    ${INDEX}
    \    ${Row_Val_0}    Get From List    ${Row_Val_List}    0
    \    Run Keyword If    '${Row_Val_0}' == ',,,,,,,,'    Continue For Loop
    \    ${Duplicate}    Check for Duplicate Currency Pair    ${CSV_Content_List}    ${Row_Val_List}    ${INDEX}
    \    Run Keyword If    ${Duplicate} > 1    Continue For Loop
    \    ${Row_Val_0_List}    Split String    ${Row_Val_0}    ,    
    \    ${Row_Dictionary}    Create Dictionary per Row Count for Csv FXRates Content    ${CSV_Content_List}    ${Row_Val_0_List}
    \    Set Test Variable    ${ROW_${INDEX}}    ${Row_Dictionary}
    \    ${GS_INSTR_CCY}    Get From Dictionary    ${ROW_${INDEX}}    GS_BASE_CCY
    \    ${GS_TRGT_CCY}    Get From Dictionary    ${ROW_${INDEX}}    GS_TRGT_CCY
    \    ${GS_INSTR_TYPE}    Get From Dictionary    ${ROW_${INDEX}}    GS_INSTR_TYPE
    \    ${GS_INSTR_PRC_TYPE}    Get From Dictionary    ${ROW_${INDEX}}    GS_INSTR_PRC_TYPE
    \    ${GS_INSTR_PRICE}    Get From Dictionary    ${ROW_${INDEX}}    GS_INSTR_PRICE
    \    ${GS_PROCESSING_DATE}    Get From Dictionary    ${ROW_${INDEX}}    GS_PROCESSING_DATE
    \    ${CONFIG_PRICE_TYPE}    Convert Input Price Type to Config Price Type and Return Config Price Type    ${GS_INSTR_PRC_TYPE}
    \    Get Single Row value from CSV File and Write to Excel for FXRates    ${ROW_${INDEX}}    ${Offset}    ${Zone1_Curr_Date}    ${Zone3_Curr_Date}    ${CONFIG_PRICE_TYPE}    ${dataset_path}${sTransformedData_FilePath}    ${sFunding_Desk}
    \    ${Offset}    Evaluate    ${Offset} + 1       
    \    Exit For Loop If    ${INDEX}==${Csv_Row_Count}
    ${TL_BASE_TOTALROW}    Set Variable    ${New_INDEX}
    Set Global Variable    ${TL_BASE_TOTALROW}
    
Get Single Row value from CSV File and Write to Excel for FXRates
    [Documentation]    sTLPath_Transformed_Data have the corresponding key fields for Bae Rate JSON file. This keyword will get row value from CSV File and write it to sTLPath_Transformed_Data.
    ...    @author: mnanquil    04MAR2019    - initial create
    ...    @update: cfrancis    18JUL2019    - change logic for subentity to be dependent on excel rather than zone dates
    ...    @update: dahijara    21NOV2019    - Added keyword to close opened excel file
    [Arguments]    ${dRow}    ${irowid}    ${sZone1_Curr_Date}    ${sZone3_Curr_Date}    ${sConfigPriceType}    ${sTLPath_Transformed_Data}    ${sFunding_Desk}
    ${GS_INSTR_CCY}    Get From Dictionary    ${dRow}    GS_BASE_CCY
    ${GS_TRGT_CCY}    Get From Dictionary    ${dRow}    GS_TRGT_CCY
    ${GS_INSTR_TYPE}    Get From Dictionary    ${dRow}    GS_INSTR_TYPE
    ${GS_INSTR_PRC_TYPE}    Get From Dictionary    ${dRow}    GS_INSTR_PRC_TYPE
    ${GS_INSTR_PRICE}    Get From Dictionary    ${dRow}    GS_INSTR_PRICE
    ${GS_PROCESSING_DATE}    Get From Dictionary    ${dRow}    GS_PROCESSING_DATE
    Open Excel    ${sTLPath_Transformed_Data}    
    ${RowCountTotal}    Get Row Count    Transformed_FXRates
    ${lib}    Get Library Instance    ExcelLibrary 
    # Call Method    ${lib.wb}    release_resources
    Close Current Excel Document
    :FOR    ${index}    IN RANGE    1    ${RowCountTotal}
    \    ${index}    Convert To String    ${index}
    \    ${index}    Remove String    ${index}    .0   
    \    ${fromCurrency}    Read Data From Excel    Transformed_FXRates    fromCurrency    ${index}    ${sTLPath_Transformed_Data}
    \    ${toCurrency}    Read Data From Excel    Transformed_FXRates    toCurrency    ${index}    ${sTLPath_Transformed_Data}
    \    Run Keyword If    '${GS_INSTR_CCY}' == '${fromCurrency}' and '${GS_TRGT_CCY}' == '${toCurrency}'    Set Global Variable    ${irowid}    ${index}
    \    Run Keyword If    '${GS_INSTR_CCY}' == '${fromCurrency}' and '${GS_TRGT_CCY}' == '${toCurrency}'    Exit For Loop
         ...    ELSE    Set Global Variable    ${irowid}
    Write Data to Excel Using Row Index    Transformed_FXRates    rowid    ${irowid}    ${irowid}    ${sTLPath_Transformed_Data}
    Run Keyword If    '${GS_INSTR_TYPE}'=='FX-SPOT'    Write Data to Excel Using Row Index    Transformed_FXRates    rateType    ${irowid}    SPOT    ${sTLPath_Transformed_Data}
    Write Data to Excel Using Row Index    Transformed_FXRates    fromCurrency    ${irowid}    ${GS_INSTR_CCY}    ${sTLPath_Transformed_Data}
    Write Data to Excel Using Row Index    Transformed_FXRates    toCurrency    ${irowid}    ${GS_TRGT_CCY}    ${sTLPath_Transformed_Data}
    Write Data to Excel Using Row Index    Transformed_FXRates    effectiveDate    ${irowid}    ${GS_PROCESSING_DATE}    ${sTLPath_Transformed_Data}
    Write Data to Excel Using Row Index    Transformed_FXRates    lineOfBusiness    ${irowid}    COMRLENDING    ${sTLPath_Transformed_Data}
    Write Data to Excel Using Row Index    Transformed_FXRates    businessEntityName    ${irowid}    AUSTRALIA    ${sTLPath_Transformed_Data}
    # ${sZone1_Curr_Date}    Convert Date    ${sZone1_Curr_Date}    date_format=%d-%b-%Y    result_format=datetime
    # ${sZone3_Curr_Date}    Convert Date    ${sZone3_Curr_Date}    date_format=%d-%b-%Y    result_format=datetime 
    # ${Zone1_Input_Diff}    Subtract Date From Date    ${sZone1_Curr_Date}    ${GS_PROCESSING_DATE}   
    # ${Zone3_Input_Diff}    Subtract Date From Date    ${sZone3_Curr_Date}    ${GS_PROCESSING_DATE}
    # ${Zone1_Input_Diff}    Convert To String    ${Zone1_Input_Diff}
    # ${Zone3_Input_Diff}    Convert To String    ${Zone3_Input_Diff}      
    # ${SubEntity_NY_Status}    Run Keyword And Return Status    Should Contain    ${Zone1_Input_Diff}    -
    # ${SubEntity_AUD_Status}    Run Keyword And Return Status    Should Contain    ${Zone3_Input_Diff}    -  
    # Run Keyword If    ${SubEntity_NY_Status}==False and ${SubEntity_AUD_Status}==True    Write Data to Excel Using Row Index    Transformed_FXRates    subEntity    ${irowid}    NY    ${sTLPath_Transformed_Data}
    # ...    ELSE IF    ${SubEntity_NY_Status}==True and ${SubEntity_AUD_Status}==False    Write Data to Excel Using Row Index    Transformed_FXRates    subEntity    ${irowid}    AUD    ${sTLPath_Transformed_Data}
    # ...    ELSE IF    ${SubEntity_NY_Status}==False and ${SubEntity_AUD_Status}==False    Write Data to Excel Using Row Index    Transformed_FXRates    subEntity    ${irowid}    NY,AUD    ${sTLPath_Transformed_Data}
    Run Keyword If    '${sFunding_Desk}'=='NY'    Write Data to Excel Using Row Index    Transformed_FXRates    subEntity    ${irowid}    NY    ${sTLPath_Transformed_Data}
    ...    ELSE IF    '${sFunding_Desk}'=='AUD'    Write Data to Excel Using Row Index    Transformed_FXRates    subEntity    ${irowid}    AUD    ${sTLPath_Transformed_Data}
    Run Keyword If    '${sConfigPriceType}'=='BUYRATE'    Write Data to Excel Using Row Index    Transformed_FXRates    buyRate    ${irowid}    ${GS_INSTR_PRICE}    ${sTLPath_Transformed_Data}
    ...    ELSE IF    '${sConfigPriceType}'=='MIDRATE'    Write Data to Excel Using Row Index    Transformed_FXRates    midRate    ${irowid}    ${GS_INSTR_PRICE}    ${sTLPath_Transformed_Data}
    ...    ELSE IF    '${sConfigPriceType}'=='SELLRATE'   Write Data to Excel Using Row Index    Transformed_FXRates    sellRate    ${irowid}    ${GS_INSTR_PRICE}    ${sTLPath_Transformed_Data}
    
Create Expected JSON for FXRates TL
    [Documentation]    This keyword is used to create expected JSON payload for FXRates Transformation Layer using the transformed data.
    ...    @author: mnanquil    04MAR2019    - initial create
    ...    @update: dahijara    21NOV2019    - Added keyword to close opened excel file
    ...    @update: nbautist    09OCT2020    - removed commented exit condition
    [Arguments]    ${sTransformedData_FilePath}    ${sInputJsonFile}    ${dConvertedCSVFile}    ${sTransformedDataXML_FilePath}      
    Open Excel    ${dataset_path}${sTransformedData_FilePath}    
    ${Row_Count}    Get Row Count    Transformed_FXRates
    ${jsonfile}    Set Variable    ${sInputJsonFile}.json
    Delete File If Exist    ${dataset_path}${jsonfile}
    Create File    ${dataset_path}${jsonfile}
    Close Current Excel Document
    :FOR    ${INDEX}    IN RANGE    1    ${Row_Count}
    \    ${dTransformedData}    ${rowCount}    Create Dictionary Using Transformed Data and Return FXRates    ${dataset_path}${sTransformedData_FilePath}    ${INDEX}
    \    ${New_JSON}    Update Key Values of input JSON file for FXRates TL    ${dTransformedData}    ${dataset_path}${jsonfile}    ${rowCount}    ${dConvertedCSVFile}     ${sTransformedDataXML_FilePath} 
    \    Log    ${New_JSON}
    
    ${file}    OperatingSystem.Get File    ${dataset_path}${jsonfile}
    ${converted_file}    Catenate    SEPARATOR=    [    ${file}    ]
    Create File    ${dataset_path}${jsonfile}    ${converted_file}
    ${converted_file}    OperatingSystem.Get File    ${dataset_path}${jsonfile}
    ${converted_file}    Remove String    ${converted_file}    "|    
    ${converted_file}    Remove String    ${converted_file}    |"
    Delete File If Exist    ${dataset_path}${jsonfile}
    Create File    ${dataset_path}${jsonfile}    ${converted_file}
    
Create Dictionary Using Transformed Data and Return FXRates
    [Documentation]    This keyword is used to create dictionary for the row values of the Transformed File and Return dictionary.
    ...    @author: mnanquil    04MAR2019    - initial create
    ...    @update: dahijara    21NOV2019    - Added keyword to close opened excel file
    [Arguments]    ${sTransformedData_FilePath}    ${iRowID}
    ${RowData_Dictionary}    Create Dictionary    
    Open Excel    ${sTransformedData_FilePath}    
    ${Column_Count}    Get Column Count    Transformed_FXRates
    ${Row_Count}    Get Row Count    Transformed_FXRates
    :FOR    ${INDEX}    IN RANGE    1    ${Column_Count}
    \    ${Column_Header}    Read Cell Data By Coordinates    Transformed_FXRates    ${INDEX}    0
    \    ${Column_Value}    Read Cell Data By Coordinates    Transformed_FXRates    ${INDEX}    ${iRowID}
    \    Set To Dictionary    ${RowData_Dictionary}    ${Column_Header}=${Column_Value}    
    \    Log    ${RowData_Dictionary}
    \    Exit For Loop If    ${INDEX}==${Column_Count}
    Close Current Excel Document
    [Return]    ${RowData_Dictionary}    ${Row_Count}

Update Key Values of input JSON file for FXRates TL
    [Documentation]    This keyword is used to update key values of JSON file and save to new file.
    ...    @author: mnanquil    04MAR2019    - initial create
    ...    @update: cfrancis    31JUL2019    - added variable counter reset before for loop
    [Arguments]    ${dRowData}    ${jsonFilePath}    ${rowCount}    ${dConvertedCSVFile}    ${sTransformedDataXML_FilePath}         
    ${File_Path}    Set Variable    ${TemplateInput}    
    ${EMPTY}    Set Variable    
    ${JSON_Object}    Load JSON From File    ${File_Path}
    ${INDEX_0}    Set Variable    0
    ${INDEX_00}    Set Variable    0
    ${val_subEntity_0}    Get From Dictionary    ${dRowData}    subEntity
    ${subEntity_list}    Split String    ${val_subEntity_0}    ,
    ${subEntity_length}    Get Length    ${subEntity_list}
    ${totalJSONCount}    Evaluate    ${subEntity_length}*${rowCount}-1 
    ${audBuyRateConvertion}    Read Data From Excel    Transformed_FXRates    buyRate    14    ${dConvertedCSVFile}
    ${audMidRateConvertion}    Read Data From Excel    Transformed_FXRates    midRate    14    ${dConvertedCSVFile}
    ${audSellRateConvertion}    Read Data From Excel    Transformed_FXRates    sellRate    14    ${dConvertedCSVFile}  
    :FOR    ${INDEX}    IN RANGE    ${subEntity_length}
    \    
    \    ${fromCurrency_Val}    Get From Dictionary    ${dRowData}    fromCurrency
    \    ${fromCurrency}    Get From Dictionary    ${dRowData}    fromCurrency
    \    ${toCurrency_Val}    Get From Dictionary    ${dRowData}    toCurrency
    \    
    \    ${status1}    Run Keyword And Return Status	Should Contain    ${fromCurrency}    AUD
    \    ${status2}    Run Keyword And Return Status	Should Contain    ${toCurrency_Val}    USD
    \    
    \    ${buyRate_Val}    Get From Dictionary    ${dRowData}    buyRate
    \    ${buyRate_Val2B}    Get From Dictionary    ${dRowData}    buyRate
    \    ${midRate_Val}    Get From Dictionary    ${dRowData}    midRate
    \    ${midRate_Val2B}    Get From Dictionary    ${dRowData}    midRate
    \    ${sellRate_Val}    Get From Dictionary    ${dRowData}    sellRate
    \    ${sellRate_Val2B}    Get From Dictionary    ${dRowData}    sellRate
    \    ${effectiveDate}    Get From Dictionary    ${dRowData}    effectiveDate
    \    
    \    ${buyRate_Val1}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' == 'USD'    Divide Two Values With Exact Precision    1    ${buyRate_Val}   
    \    ${buyRate_Val1}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' == 'USD'    Evaluate    "%.15f" % ${buyRate_Val1}
    \    ${buyRate_Val1}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' == 'USD'    Strip String    ${buyRate_Val1}    mode=right    characters=0
    \    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' == 'USD'    Set Global Variable    ${buyRate_Val}    ${buyRate_Val1}
    \    
    \    ${midRate_Val1}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' == 'USD'    Divide Two Values With Exact Precision    1    ${midRate_Val}   
    \    ${midRate_Val1}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' == 'USD'    Evaluate    "%.15f" % ${midRate_Val1}
    \    ${midRate_Val1}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' == 'USD'    Strip String    ${midRate_Val1}    mode=right    characters=0
    \    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' == 'USD'    Set Global Variable    ${midRate_Val}    ${midRate_Val1}
    \    
    \    ${sellRate_Val1}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' == 'USD'    Divide Two Values With Exact Precision    1    ${sellRate_Val}   
    \    ${sellRate_Val1}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' == 'USD'    Evaluate    "%.15f" % ${sellRate_Val1}
    \    ${sellRate_Val1}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' == 'USD'    Strip String    ${sellRate_Val1}    mode=right    characters=0
    \    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' == 'USD'    Set Global Variable    ${sellRate_Val}    ${sellRate_Val1}
    \     
    \    ${sellRate_Val2}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' != 'USD'     Divide Two Values With Exact Precision    1    ${sellRate_Val}
    \    ${sellRate_Val2}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' != 'USD'     Evaluate    "%.5f" % ${sellRate_Val2}
    \    ${sellRate_Val2}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' != 'USD'     Divide Two Values With Exact Precision    1    ${sellRate_Val2}  
    \    ${sellRate_Val2}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' != 'USD'     Convert To String    ${sellRate_Val2}     
    \    ${sellRate_ValLeft}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' != 'USD'     Fetch From Left    ${sellRate_Val2}   .
    \    ${sellRate_ValRight}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' != 'USD'     Fetch From Right    ${sellRate_Val2}   .   
    \    ${sellRate_ValDecimal}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' != 'USD'     Get Substring    ${sellRate_ValRight}    0    16
    \    ${sellRate_Val2}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' != 'USD'     Set Variable     ${sellRate_ValLeft}.${sellRate_ValDecimal}     
    \    ${sellRate_Val2}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' != 'USD'     Evaluate    "%.15f" % ${sellRate_Val2}
    \    ${sellRate_Val2}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' != 'USD'     Strip String    ${sellRate_Val2}    mode=right    characters=0       
    \    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' != 'USD'     Set Global Variable    ${sellRate_Val}    ${sellRate_Val2}
    \    
    \    ${buyRate_Val2}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' != 'USD'     Divide Two Values With Exact Precision    1    ${buyRate_Val}
    \    ${buyRate_Val2}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' != 'USD'     Evaluate    "%.5f" % ${buyRate_Val2}
    \    ${buyRate_Val2}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' != 'USD'     Divide Two Values With Exact Precision    1    ${buyRate_Val2}  
    \    ${buyRate_Val2}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' != 'USD'     Convert To String    ${buyRate_Val2}     
    \    ${buyRate_ValLeft}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' != 'USD'     Fetch From Left    ${buyRate_Val2}   .
    \    ${buyRate_ValRight}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' != 'USD'     Fetch From Right    ${buyRate_Val2}   .   
    \    ${buyRate_ValDecimal}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' != 'USD'     Get Substring    ${buyRate_ValRight}    0    16
    \    ${buyRate_Val2}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' != 'USD'     Set Variable     ${buyRate_ValLeft}.${buyRate_ValDecimal}     
    \    ${buyRate_Val2}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' != 'USD'     Evaluate    "%.15f" % ${buyRate_Val2}
    \    ${buyRate_Val2}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' != 'USD'     Strip String    ${buyRate_Val2}    mode=right    characters=0       
    \    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' != 'USD'     Set Global Variable    ${buyRate_Val}    ${buyRate_Val2}
    \    
    \    
    \    ${midRate_Val2}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' != 'USD'     Divide Two Values With Exact Precision    1    ${midRate_Val}
    \    ${midRate_Val2}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' != 'USD'     Evaluate    "%.5f" % ${midRate_Val2}
    \    ${midRate_Val2}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' != 'USD'     Divide Two Values With Exact Precision    1    ${midRate_Val2}  
    \    ${midRate_Val2}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' != 'USD'     Convert To String    ${midRate_Val2}     
    \    ${midRate_ValLeft}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' != 'USD'     Fetch From Left    ${midRate_Val2}   .
    \    ${midRate_ValRight}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' != 'USD'     Fetch From Right    ${midRate_Val2}   .   
    \    ${midRate_ValDecimal}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' != 'USD'     Get Substring    ${midRate_ValRight}    0    16
    \    ${midRate_Val2}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' != 'USD'     Set Variable     ${midRate_ValLeft}.${midRate_ValDecimal}     
    \    ${midRate_Val2}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' != 'USD'     Evaluate    "%.15f" % ${midRate_Val2}
    \    ${midRate_Val2}    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' != 'USD'     Strip String    ${midRate_Val2}    mode=right    characters=0       
    \    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' != 'USD'     Set Global Variable    ${midRate_Val}    ${midRate_Val2}
    \    
    \    ###AUD CURRENCY COMPUTATION###
    \    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${fromCurrency_Val}' != 'USD'    Set Global Variable    ${fromCurrency_Val}    ${toCurrency_Val}
    \    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'NY' and '${toCurrency_Val}' == 'USD'    Set Global Variable    ${toCurrency_Val}    ${fromCurrency}  
    \    
    \    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' != 'AUD'    Set Global Variable    ${fromCurrency_Val}    @{subEntity_list}[${INDEX}]
    \    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${toCurrency_Val}' == 'USD' or '${toCurrency_Val}' == 'AUD'    Set Global Variable    ${toCurrency_Val}    ${fromCurrency}
    \    Run Keyword If    '${fromCurrency_Val}' == '${toCurrencyVal}'    Set Global Variable    ${toCurrency_Val}    USD
    \    
    \    ${status}	Run Keyword and Return Status	Should Contain	${toCurrency_Val}	USD	
   	\    ${buyRate_Val3}	Run Keyword If	'${status}'=='${False}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD'      Multiply Two Values With Exact Precision    ${audBuyRateConvertion}    ${buyRate_Val}
    \    ${buyRate_Val3}	Run Keyword If	'${status}'=='${False}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD'      Evaluate    "%.5f" % ${buyRate_Val3}
    \    ${buyRate_Val3}	Run Keyword If	'${status}'=='${False}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD'      Divide Two Values With Exact Precision    1    ${buyRate_Val3}   
    \    ${buyRate_Val3}	Run Keyword If	'${status}'=='${False}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD'      Evaluate    "%.15f" % ${buyRate_Val3}
    \    ${buyRate_Val3}	Run Keyword If	'${status}'=='${False}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD'      Strip String    ${buyRate_Val3}    mode=right    characters=0
    \    Run Keyword If	'${status}'=='${False}'		Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD'      Set Global Variable    ${buyRate_Val}    ${buyRate_Val3}
    \    
    \    ${buyRate_Val4}	Run Keyword If	'${status1}' == '${False}' and '${status2}' == '${True}'	Run Keyword If	'${status}'=='${False}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD'      Divide Two Values With Exact Precision    ${audBuyRateConvertion}    ${buyRate_Val2B}
    \    ${buyRate_Val4}	Run Keyword If	'${status1}' == '${False}' and '${status2}' == '${True}'	Run Keyword If	'${status}'=='${False}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD'      Evaluate    "%.5f" % ${buyRate_Val4}
    \    ${buyRate_Val4}	Run Keyword If	'${status1}' == '${False}' and '${status2}' == '${True}'	Run Keyword If	'${status}'=='${False}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD'      Divide Two Values With Exact Precision    1    ${buyRate_Val4}   
    \    ${buyRate_Val4}	Run Keyword If	'${status1}' == '${False}' and '${status2}' == '${True}'	Run Keyword If	'${status}'=='${False}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD'      Evaluate    "%.15f" % ${buyRate_Val4}
    \    ${buyRate_Val4}	Run Keyword If	'${status1}' == '${False}' and '${status2}' == '${True}'	Run Keyword If	'${status}'=='${False}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD'      Strip String    ${buyRate_Val4}    mode=right    characters=0
    \    Run Keyword If	'${status1}' == '${False}' and '${status2}' == '${True}'	Run Keyword If	'${status}'=='${False}'		Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD'      Set Global Variable    ${buyRate_Val}    ${buyRate_Val4}
    \    
    \    ${buyRate_Val2A}	Run Keyword If	'${status}'=='${True}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD' and '${toCurrency_Val}' == 'USD'     Evaluate    "%.5f" % ${buyRate_Val}
    \    ${buyRate_Val2A}	Run Keyword If	'${status}'=='${True}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD' and '${toCurrency_Val}' == 'USD'     Divide Two Values With Exact Precision    1    ${buyRate_Val2A}      
    \    ${buyRate_Val2A}	Run Keyword If	'${status}'=='${True}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD' and '${toCurrency_Val}' == 'USD'     Evaluate    "%.15f" % ${buyRate_Val2A}
    \    ${buyRate_Val2A}	Run Keyword If	'${status}'=='${True}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD' and '${toCurrency_Val}' == 'USD'     Strip String    ${buyRate_Val2A}    mode=right    characters=0       
    \    Run Keyword If	'${status}'=='${True}'		Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD' and '${toCurrency_Val}' == 'USD'     Set Global Variable    ${buyRate_Val}    ${buyRate_Val2A}
    \    
    \    ${midRate_Val3}    Run Keyword If	'${status}'=='${False}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD'      Multiply Two Values With Exact Precision    ${audMidRateConvertion}    ${midRate_Val}
    \    ${midRate_Val3}	Run Keyword If	'${status}'=='${False}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD'      Evaluate    "%.5f" % ${midRate_Val3}
    \    ${midRate_Val3}	Run Keyword If	'${status}'=='${False}'	   Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD'      Divide Two Values With Exact Precision    1    ${midRate_Val3}   
    \    ${midRate_Val3}	Run Keyword If	'${status}'=='${False}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD'      Evaluate    "%.15f" % ${midRate_Val3}
    \    ${midRate_Val3}	Run Keyword If	'${status}'=='${False}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD'      Strip String    ${midRate_Val3}    mode=right    characters=0
    \    Run Keyword If    '${status}'=='${False}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD'      Set Global Variable    ${midRate_Val}    ${midRate_Val3}
    \    
    \    ${midRate_Val4}    Run Keyword If	'${status1}' == '${False}' and '${status2}' == '${True}'    Run Keyword If	'${status}'=='${False}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD'      Divide Two Values With Exact Precision    ${audMidRateConvertion}    ${midRate_Val2B}    
    \    ${midRate_Val4}	Run Keyword If	'${status1}' == '${False}' and '${status2}' == '${True}'    Run Keyword If	'${status}'=='${False}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD'      Evaluate    "%.5f" % ${midRate_Val4}
    \    ${midRate_Val4}	Run Keyword If	'${status1}' == '${False}' and '${status2}' == '${True}'    Run Keyword If	'${status}'=='${False}'	   Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD'      Divide Two Values With Exact Precision    1    ${midRate_Val4}   
    \    ${midRate_Val4}	Run Keyword If	'${status1}' == '${False}' and '${status2}' == '${True}'    Run Keyword If	'${status}'=='${False}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD'      Evaluate    "%.15f" % ${midRate_Val4}
    \    ${midRate_Val4}	Run Keyword If	'${status1}' == '${False}' and '${status2}' == '${True}'    Run Keyword If	'${status}'=='${False}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD'      Strip String    ${midRate_Val4}    mode=right    characters=0
    \    Run Keyword If    '${status1}' == '${False}' and '${status2}' == '${True}'    Run Keyword If	'${status}'=='${False}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD'      Set Global Variable    ${midRate_Val}    ${midRate_Val4}
    \    
    \    ${midRate_Val2A}	Run Keyword If	'${status}'=='${True}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD' and '${toCurrency_Val}' == 'USD'     Evaluate    "%.5f" % ${midRate_Val}
    \    ${midRate_Val2A}	Run Keyword If	'${status}'=='${True}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD' and '${toCurrency_Val}' == 'USD'     Divide Two Values With Exact Precision    1    ${midRate_Val2A}  
    \    ${midRate_Val2A}	Run Keyword If	'${status}'=='${True}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD' and '${toCurrency_Val}' == 'USD'     Evaluate    "%.15f" % ${midRate_Val2A}
    \    ${midRate_Val2A}	Run Keyword If	'${status}'=='${True}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD' and '${toCurrency_Val}' == 'USD'     Strip String    ${midRate_Val2A}    mode=right    characters=0       
    \    Run Keyword If    '${status}'=='${True}'	Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD' and '${toCurrency_Val}' == 'USD'     Set Global Variable    ${midRate_Val}    ${midRate_Val2A}
    \    
    \    ${sellRate_Val3}	Run Keyword If	'${status}'=='${False}'	   Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD'      Multiply Two Values With Exact Precision    ${audSellRateConvertion}    ${sellRate_Val}
    \    ${sellRate_Val3}	Run Keyword If	'${status}'=='${False}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD'      Evaluate    "%.5f" % ${sellRate_Val3}
    \    ${sellRate_Val3}	Run Keyword If	'${status}'=='${False}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD'      Divide Two Values With Exact Precision    1    ${sellRate_Val3}   
    \    ${sellRate_Val3}	Run Keyword If	'${status}'=='${False}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD'      Evaluate    "%.15f" % ${sellRate_Val3}
    \    ${sellRate_Val3}	Run Keyword If	'${status}'=='${False}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD'      Strip String    ${sellRate_Val3}    mode=right    characters=0
    \    Run Keyword If    '${status}'=='${False}'		Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD'      Set Global Variable    ${sellRate_Val}    ${sellRate_Val3}
    \    
    \    ${sellRate_Val4}	Run Keyword If	'${status1}' == '${False}' and '${status2}' == '${True}'	Run Keyword If	'${status}'=='${False}'	   Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD'      Divide Two Values With Exact Precision    ${audSellRateConvertion}    ${sellRate_Val2B}
    \    ${sellRate_Val4}	Run Keyword If	'${status1}' == '${False}' and '${status2}' == '${True}'	Run Keyword If	'${status}'=='${False}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD'      Evaluate    "%.5f" % ${sellRate_Val4}
    \    ${sellRate_Val4}	Run Keyword If	'${status1}' == '${False}' and '${status2}' == '${True}'	Run Keyword If	'${status}'=='${False}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD'      Divide Two Values With Exact Precision    1    ${sellRate_Val4}   
    \    ${sellRate_Val4}	Run Keyword If	'${status1}' == '${False}' and '${status2}' == '${True}'	Run Keyword If	'${status}'=='${False}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD'      Evaluate    "%.15f" % ${sellRate_Val4}
    \    ${sellRate_Val4}	Run Keyword If	'${status1}' == '${False}' and '${status2}' == '${True}'	Run Keyword If	'${status}'=='${False}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD'      Strip String    ${sellRate_Val4}    mode=right    characters=0
    \    Run Keyword If    '${status1}' == '${False}' and '${status2}' == '${True}'	Run Keyword If	'${status}'=='${False}'		Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD'      Set Global Variable    ${sellRate_Val}    ${sellRate_Val4}
    \    
    \    ${sellRate_Val2A}	Run Keyword If	'${status}'=='${True}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD' and '${toCurrency_Val}' == 'USD'     Evaluate    "%.5f" % ${sellRate_Val}  
    \    ${sellRate_Val2A}	Run Keyword If	'${status}'=='${True}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD' and '${toCurrency_Val}' == 'USD'     Divide Two Values With Exact Precision    1    ${sellRate_Val2A}  
    \    ${sellRate_Val2A}	Run Keyword If	'${status}'=='${True}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD' and '${toCurrency_Val}' == 'USD'     Evaluate    "%.15f" % ${sellRate_Val2A}
    \    ${sellRate_Val2A}	Run Keyword If	'${status}'=='${True}'    Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD' and '${toCurrency_Val}' == 'USD'     Strip String    ${sellRate_Val2A}    mode=right    characters=0       
    \    Run Keyword If    '${status}'=='${True}'	Run Keyword If    '@{subEntity_list}[${INDEX}]' == 'AUD' and '${fromCurrency_Val}' == 'AUD' and '${toCurrency_Val}' == 'USD'     Set Global Variable    ${sellRate_Val}    ${sellRate_Val2A}
    \    
    \    ${New_JSON}    Run Keyword If    '${fromCurrency_Val}'=='null'    Set To Dictionary    ${JSON_Object}    fromCurrency=${NONE}
         ...    ELSE IF    '${fromCurrency_Val}'==''    Set To Dictionary    ${JSON_Object}    fromCurrency=${EMPTY}
         ...    ELSE IF    '${fromCurrency_Val}'=='Empty' or '${fromCurrency_Val}'=='empty'    Set To Dictionary    ${JSON_Object}    fromCurrency=${EMPTY}
         ...    ELSE IF    '${fromCurrency_Val}'=='no tag'    Set Variable    ${JSON_Object}
         ...    ELSE    Set To Dictionary    ${JSON_Object}    fromCurrency=${fromCurrency_Val}    
    \    
    \    ${New_JSON}    Run Keyword If    '${toCurrency_Val}'=='null'    Set To Dictionary    ${JSON_Object}    toCurrency=${NONE}
         ...    ELSE IF    '${toCurrency_Val}'==''    Set To Dictionary    ${JSON_Object}    toCurrency=${EMPTY}
         ...    ELSE IF    '${toCurrency_Val}'=='Empty' or '${toCurrency_Val}'=='empty'    Set To Dictionary    ${JSON_Object}    toCurrency=${EMPTY}
         ...    ELSE IF    '${toCurrency_Val}'=='no tag'    Set Variable    ${JSON_Object}
         ...    ELSE    Set To Dictionary    ${JSON_Object}    toCurrency=${toCurrency_Val}
    \    
	\    ${New_JSON}    Run Keyword If    '${buyRate_Val}'=='null'    Set To Dictionary    ${New_JSON}    buyRate=${NONE}
         ...    ELSE IF    '${buyRate_Val}'==''    Set To Dictionary    ${New_JSON}    buyRate=${EMPTY}
         ...    ELSE IF    '${buyRate_Val}'=='Empty' or '${buyRate_Val}'=='empty'    Set To Dictionary    ${New_JSON}    buyRate=${EMPTY}
         ...    ELSE IF    '${buyRate_Val}'=='no tag'    Set Variable    ${New_JSON}
         ...    ELSE    Set To Dictionary    ${New_JSON}    buyRate=|${buyRate_Val}|
    \    
	\    ${New_JSON}    Run Keyword If    '${midRate_Val}'=='null'    Set To Dictionary    ${New_JSON}    midRate=${NONE}
         ...    ELSE IF    '${midRate_Val}'==''    Set To Dictionary    ${New_JSON}    midRate=${EMPTY}
         ...    ELSE IF    '${midRate_Val}'=='Empty' or '${midRate_Val}'=='empty'    Set To Dictionary    ${New_JSON}    midRate=${EMPTY}
         ...    ELSE IF    '${midRate_Val}'=='no tag'    Set Variable    ${New_JSON}
         ...    ELSE    Set To Dictionary    ${New_JSON}    midRate=|${midRate_Val}|
    \    
	\    ${New_JSON}    Run Keyword If    '${sellRate_Val}'=='null'    Set To Dictionary    ${New_JSON}    sellRate=${NONE}
         ...    ELSE IF    '${sellRate_Val}'==''    Set To Dictionary    ${New_JSON}    sellRate=${EMPTY}
         ...    ELSE IF    '${sellRate_Val}'=='Empty' or '${sellRate_Val}'=='empty'    Set To Dictionary    ${New_JSON}    sellRate=${EMPTY}
         ...    ELSE IF    '${sellRate_Val}'=='no tag'    Set Variable    ${New_JSON}
         ...    ELSE    Set To Dictionary    ${New_JSON}    sellRate=|${sellRate_Val}|
    \    ${effectiveDate_Val}    Get From Dictionary    ${dRowData}    effectiveDate
	\    ${New_JSON}    Run Keyword If    '${effectiveDate_Val}'=='null'    Set To Dictionary    ${New_JSON}    effectiveDate=${NONE}
         ...    ELSE IF    '${effectiveDate_Val}'==''    Set To Dictionary    ${New_JSON}    effectiveDate=${EMPTY}
         ...    ELSE IF    '${effectiveDate_Val}'=='Empty' or '${effectiveDate_Val}'=='empty'    Set To Dictionary    ${New_JSON}    effectiveDate=${EMPTY}
         ...    ELSE IF    '${effectiveDate_Val}'=='no tag'    Set Variable    ${New_JSON}
         ...    ELSE    Set To Dictionary    ${New_JSON}    effectiveDate=${effectiveDate_Val}
    \    ${rateType_Val}    Get From Dictionary    ${dRowData}    rateType
	\    ${New_JSON}    Run Keyword If    '${rateType_Val}'=='null'    Set To Dictionary    ${New_JSON}    rateType=${NONE}
         ...    ELSE IF    '${rateType_Val}'==''    Set To Dictionary    ${New_JSON}    rateType=${EMPTY}
         ...    ELSE IF    '${rateType_Val}'=='Empty' or '${rateType_Val}'=='empty'    Set To Dictionary    ${New_JSON}    rateType=${EMPTY}
         ...    ELSE IF    '${rateType_Val}'=='no tag'    Set Variable    ${New_JSON}
         ...    ELSE    Set To Dictionary    ${New_JSON}    rateType=${rateType_Val}
    \    ${New_JSON}    Create Expected JSON FxRates TL    ${dRowData}    @{subEntity_list}[${INDEX}]    ${New_JSON}
    \    ${converted_json}    Evaluate    json.dumps(${New_JSON})        json
    \    Log    ${converted_json}
    \    Run Keyword If    ${COUNTER}==0    Append To File    ${jsonFilePath}    ${converted_json}
    \    Run Keyword If    ${COUNTER}>0 or ${counter}==${totalJSONCount}   Append To File    ${jsonFilePath}    ,${converted_json}
    \    ${COUNTER}    Evaluate    int(${COUNTER}+1)
    \    Write Data to Excel Using Row Index    Transformed_FXRates    rowid    ${COUNTER}    ${COUNTER}    ${sTransformedDataXML_FilePath}            
    \    Write Data to Excel Using Row Index    Transformed_FXRates    subEntity    ${COUNTER}    @{subEntity_list}[${INDEX}]    ${sTransformedDataXML_FilePath}    
    \    Write Data to Excel Using Row Index    Transformed_FXRates    fromCurrency    ${COUNTER}    ${fromCurrency_Val}      ${sTransformedDataXML_FilePath}    
    \    Write Data to Excel Using Row Index    Transformed_FXRates    toCurrency    ${COUNTER}    ${toCurrency_Val}      ${sTransformedDataXML_FilePath}    
    \    Write Data to Excel Using Row Index    Transformed_FXRates    buyRate    ${COUNTER}    ${buyRate_Val}      ${sTransformedDataXML_FilePath}           
    \    Write Data to Excel Using Row Index    Transformed_FXRates    midRate    ${COUNTER}    ${midRate_Val}      ${sTransformedDataXML_FilePath}                   
    \    Write Data to Excel Using Row Index    Transformed_FXRates    sellRate    ${COUNTER}    ${sellRate_Val}      ${sTransformedDataXML_FilePath}    
    \    Write Data to Excel Using Row Index    Transformed_FXRates    effectiveDate    ${COUNTER}    ${effectiveDate}      ${sTransformedDataXML_FilePath}                                                          
    \    Set Global Variable    ${COUNTER}
   [Return]    ${NewJSON}
   
Create Expected JSON FxRates TL
    [Arguments]    ${dRowData}    ${sSubEntity}    ${New_JSON}   
         
    ${Val_LOB_0}    Get From Dictionary    ${dRowData}    lineOfBusiness
    ${Lob_List}    Split String    ${Val_LOB_0}    /
    ${LOB_count}    Get Length    ${Lob_List}
   ${val_businessEntityName_0}    Get From Dictionary    ${dRowData}    businessEntityName
   ${businessEntityName_list}    Split String    ${val_businessEntityName_0}    /
   ${lineOfBusinessList}    Create List
   :FOR    ${INDEX_0}    IN RANGE    ${LOB_count}
   \    Log    ${INDEX_0}
   \    ${Val_LOB}    Get From List    ${Lob_List}    ${INDEX_0}
   \    
   \    ${Val_LOB_0}    Run Keyword If    '${Val_LOB_0}'!=''    Get From List    ${Lob_List}    0
   \    ${Val_LOB}    Run Keyword If    '${Val_LOB_0}'=='lineOfBusiness='    Set Variable    ${EMPTY}
        ...    ELSE IF    '${Val_LOB_0}'=='lineOfBusiness=null'    Set Variable    ${NONE}
        ...    ELSE IF    '${Val_LOB_0}'=='lineOfBusiness=null'    Set Variable    ${NONE}
        ...    ELSE    Set Variable    ${Val_LOB}
   \    ${businessEntityNameDictionary}    Create Array for Multiple Values    ${businessEntityName_list}    ${INDEX_0}    businessEntityName    ,
   \    ${subEntityDictionary}    Create List    ${sSubEntity}
   \    ${businessEntityNameDictionary}    Run Keyword If    ${businessEntityNameDictionary}==${NONE}    Create List
        ...    ELSE    Set Variable    ${businessEntityNameDictionary}
   \    ${subEntityDictionary}    Run Keyword If    ${subEntityDictionary}==${NONE}    Create List
        ...    ELSE    Set Variable    ${subEntityDictionary}
   \    ${businessEntityNameDictionary}    Run Keyword If    ${businessEntityNameDictionary}==${NONE}    Create List
        ...    ELSE    Set Variable    ${businessEntityNameDictionary}
   \    ${lineOfBusinessDictionary}    Create Dictionary    lineOfBusiness=${Val_LOB}
        ...    businessEntityName=${businessEntityNameDictionary}    subEntity=${subEntityDictionary}
   \    ${businessEntityNameVal}    Get From List    ${businessEntityNameList}    ${INDEX_0}
   \    Run Keyword If    '${businessEntityNameVal}'=='no tag'    Remove From Dictionary    ${lineOfBusinessDictionary}    businessEntityName
   \    Run Keyword If    '${Val_LOB}'=='lineOfBusiness=no tag'    Remove From Dictionary    ${lineOfBusinessDictionary}    lineOfBusiness
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
   
Create Expected TextJMS XML for FXRates TL
    [Documentation]    This keyword is used to create expected XML for every row in the csv file and save file name with Base Rate Code, Funding Desk and Repricing Frequency.
    ...    @author: mnanquil    04MAR2019    - initial create
    ...    @update: dahijara    21NOV2019    - Added keyword to close opened excel file
    ...    @update: jdelacru    04SEP2020    - added new argument for the location of template files, TemplateFilePath
    [Arguments]    ${sTransformedData_FilePath}    ${sInputFilePath}    ${sFileName}    ${sTemplateFilePath}
    Open Excel    ${dataset_path}${sTransformedData_FilePath}    
    ${Row_Count}    Get Row Count    Transformed_FXRates
    Close Current Excel Document
    :FOR    ${INDEX}    IN RANGE    1    ${Row_Count}
    \    
    \    ${dTransformedData}    ${rowCount}    Create Dictionary Using Transformed Data and Return FXRates    ${dataset_path}${sTransformedData_FilePath}    ${INDEX}
    \    
    \    Get Individual Subentity Value and Create XML for FXRates TL    ${dTransformedData}    ${sInputFilePath}    ${sFileName}    ${sTemplateFilePath}
    \    Exit For Loop If    ${INDEX}==${Row_Count}

Get Individual Subentity Value and Create XML for FXRates TL
    [Documentation]    This keyword is used to get individual subentity values for multiple subentities in one line of business values.
    ...    i.e. sample input in datasheet AUD,NY
    ...    @author: mnanquil    04MAR2019    - initial create
    ...    @update: jdelacru    04SEP2020    - added new argument for the location of template files, TemplateFilePath
    [Arguments]    ${dRowData}    ${sInputFilePath}    ${sFileName}    ${sTemplateFilePath}
    Log    ${dRowData}
    ${SubEntityList}    Split String    &{dRowData}[subEntity]    ,
    ${subentity_count}    Get Length    ${subentity_list}
    :FOR    ${INDEX}    IN RANGE    0    ${subentity_count}
    \    ${SubEntityVal}    Get From List    ${SubEntityList}    ${INDEX}  
    \    Update Expected XML Elements for wsFinalLIQDestination - FXRates TL    ${sInputFilePath}    ${sFileName}    &{dRowData}[fromCurrency]    &{dRowData}[toCurrency]    &{dRowData}[effectiveDate]    ${SubEntityVal}       &{dRowData}[midRate]    ${sTemplateFilePath}         
    \    Exit For Loop If    ${INDEX}==${subentity_count}

Update Expected XML Elements for wsFinalLIQDestination - FXRates TL
    [Documentation]    This keyword is used to update XML Elements using the input dictionary values for wsFinalLIQDestination for FX Rate TL
    ...    @author: mnanquil    04MAR2019    - initial create
    ...    @update: cfrancis    18JUL2019    - update added saving XML for NY subentity
    ...    @update: jdelacru    04SEP2020    - added new argument for the location of template files, TemplateFilePath
    [Arguments]    ${sInputFilePath}    ${sFileName}    ${fromCurrency}    ${sCurrency}    ${sRateEffDate}    ${sSubentityVal}    ${sMidRate}    ${sTemplateFilePath} 
    Run Keyword If    '${sSubentityVal}'=='AUD' and '${fromCurrency}'=='USD'    Set Global Variable    ${fromCurrency}    AUD    
    ${Expected_wsFinalLIQDestination}    Set Variable    ${dataset_path}${sInputFilePath}${sFileName}_${fromCurrency}_${sCurrency}.xml
    ${template}    Set Variable    ${dataset_path}${sTemplateFilePath}template_TextJMS_fxrates_tl.xml
    Delete File If Exist    ${Expected_wsFinalLIQDestination}    
    ${xpath}    Set Variable    UpdateCrossCurrency
    ${val_RateEffDate}    Convert Date    ${sRateEffDate}    result_format=%d-%b-%Y
    ${Updated_template}    Set Element Attribute    ${template}    currency    ${sCurrency}    xpath=${xpath}
    ${Updated_template}    Set Element Attribute    ${Updated_template}    date    ${val_RateEffDate}    xpath=${xpath}
    ${Updated_template}    Set Element Attribute    ${Updated_template}    fundingDesk    ${sSubentityVal}    xpath=${xpath}
    ${MidRate}    Convert To String    ${sMidRate}    
    ${Updated_template}    Set Element Attribute    ${Updated_template}    rate    ${MidRate}    xpath=${xpath}
    ${attr}    XML.Get Element Attributes    ${Updated_template}    ${xpath}
    Log    ${attr}
    Run Keyword If    '${sSubentityVal}'=='AUD'    Save Xml    ${Updated_template}    ${Expected_wsFinalLIQDestination}
    ...    ELSE IF    '${sSubentityVal}'=='NY'    Save Xml    ${Updated_template}    ${Expected_wsFinalLIQDestination}
    
Validate FFC JSON File
    [Documentation]    This keyword will validate the xls file against the created json file in FFC
    ...    @author: mnanquil    12MAR2019    - initial draft
    ...    @update: clanding    12JUN2019    - added else statement
    ...    @update: dahijara    21NOV2019    - Added keyword to close opened excel file
    [Arguments]    ${dXMLExcelFile}    ${dCreatedJSONFile}    ${sFundingDeskStatus}    
    Open Excel    ${dXMLExcelFile}   
    ${rowCountTotal}    Get Row Count    Transformed_FXRates
    ${ffcJSON}    OperatingSystem.Get File    ${dCreatedJSONFile}   
    Close Current Excel Document 
    :FOR    ${index}    IN RANGE    1    ${rowCountTotal}
    \    ${fromCurrency}    Read Data From Excel    Transformed_FXRates    fromCurrency    ${index}    ${dXMLExcelFile} 
    \    ${toCurrency}    Run Keyword If    '${fromCurrency}'!='USD' and '${sFundingDeskStatus}'=='I'    Read Data From Excel    Transformed_FXRates    toCurrency    ${index}    ${dXMLExcelFile}    
    \    ${buyRate}    Run Keyword If    '${fromCurrency}'!='USD' and '${sFundingDeskStatus}'=='I'    Read Data From Excel    Transformed_FXRates    buyRate    ${index}    ${dXMLExcelFile}
    \    ${midRate}    Run Keyword If    '${fromCurrency}'!='USD' and '${sFundingDeskStatus}'=='I'    Read Data From Excel    Transformed_FXRates    midRate    ${index}    ${dXMLExcelFile}
    \    ${sellRate}    Run Keyword If    '${fromCurrency}'!='USD' and '${sFundingDeskStatus}'=='I'    Read Data From Excel    Transformed_FXRates    sellRate    ${index}    ${dXMLExcelFile}
    \    ${effectiveDate}    Run Keyword If    '${fromCurrency}'!='USD' and '${sFundingDeskStatus}'!='I'    Read Data From Excel    Transformed_FXRates    effectiveDate    ${index}    ${dXMLExcelFile}
         ...    ELSE    Set Variable    ${EMPTY}
    \    Run Keyword If    '${fromCurrency}'!='USD' and '${sFundingDeskStatus}'=='I'    Set Test Variable    ${fromCurrency}
    \    Run Keyword If    '${fromCurrency}'!='USD' and '${sFundingDeskStatus}'=='I'    Set Test Variable    ${toCurrency}    
    \    Run Keyword If    '${fromCurrency}'!='USD' and '${sFundingDeskStatus}'=='I'    Set Test Variable    ${buyRate}
    \    Run Keyword If    '${fromCurrency}'!='USD' and '${sFundingDeskStatus}'=='I'    Set Test Variable    ${midRate}
    \    Run Keyword If    '${fromCurrency}'!='USD' and '${sFundingDeskStatus}'=='I'    Set Test Variable    ${sellRate}    
    \    Run Keyword If    '${fromCurrency}'!='USD' and '${sFundingDeskStatus}'=='I'    Set Test Variable    ${effectiveDate}    
    \    Run Keyword If    '${fromCurrency}'!='USD' and '${sFundingDeskStatus}'=='I'    Should Contain    ${ffcJSON}    ${fromCurrency}    
    \    Run Keyword If    '${fromCurrency}'!='USD' and '${sFundingDeskStatus}'=='I'    Should Contain    ${ffcJSON}    ${toCurrency}   
    \    Run Keyword If    '${fromCurrency}'!='USD' and '${sFundingDeskStatus}'=='I'    Should Contain    ${ffcJSON}    ${buyRate}      
    \    Run Keyword If    '${fromCurrency}'!='USD' and '${sFundingDeskStatus}'=='I'    Should Contain    ${ffcJSON}    ${midRate}    
    \    Run Keyword If    '${fromCurrency}'!='USD' and '${sFundingDeskStatus}'=='I'    Should Contain    ${ffcJSON}    ${effectiveDate} 
    

Filter by Reference Header and Save Message TextArea and Return Results Row List Value TL FXRates
    [Documentation]    This keyword is used to search Header Reference and filter using Expected Reference Value.
    ...    Then gets the row values using array of Header Names. Then gets the Message Text after clicking results row.
    ...    @author: mnanquil    13MAR2019    - initial create
    ...    @update: clanding    12JUN2019    - added \ on index for element, this is an update for robot to consider it as a string not an index of
    [Arguments]    ${sHeaderRefName}    ${sFundingDesk}    ${sFundingStatus}    ${sExpectedRefValue}    ${sOutputFilePath}    ${sFileExtension}    @{aHeaderNames}
    
    ${Results_Column_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Header}
    ${Results_Row_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Row}
    
    :FOR    ${ResultsHeaderColIndex}    IN RANGE    1    ${Results_Column_Count}+1
    \    Mx Scroll Element Into View    ${Results_Header}\[${ResultsHeaderColIndex}]${Results_Header_Text}
    \    Wait Until Element Is Visible    ${Results_Header}\[${ResultsHeaderColIndex}]${Results_Header_Text}
    \    ${HeaderText}    Get Text    ${Results_Header}\[${ResultsHeaderColIndex}]${Results_Header_Text}
    \    Exit For Loop If    '${HeaderText}'=='${sHeaderRefName}'
    Log    ${ResultsHeaderColIndex}
    
    ${ResultsHeaderColIndex_After}    Evaluate    ${ResultsHeaderColIndex}+1
    ${ResultsHeaderColIndex}    Evaluate    ${ResultsHeaderColIndex}-1
    ${ResultsHeaderColIndex_After_Exist}    Run Keyword And Return Status    Page Should Contain Element    ${ResultsHeaderColIndex_After}    
    Run Keyword If    ${ResultsHeaderColIndex_After_Exist}==${True}    Mx Scroll Element Into View    ${Results_FilterPanel}\[${ResultsHeaderColIndex_After}]
    ...    ELSE    Mx Scroll Element Into View    ${Results_FilterPanel}\[${ResultsHeaderColIndex}]
    Mx Input Text    ${Results_FilterPanel}\[${ResultsHeaderColIndex}]    ${sExpectedRefValue}
    Wait Until Element Is Visible    ${Results_Row}    
    
    ${Multiple_List}    Create List
    ${FileName_List}    Create List    
    ${Results_Row_Count_With_Ref}    SeleniumLibraryExtended.Get Element Count    ${Results_Row}
    Set Global Variable    ${RESULTS_ROW_WITHREF}    ${Results_Row_Count_With_Ref}
    :FOR    ${ResultsRowIndex_Ref}    IN RANGE    1    ${Results_Row_Count_With_Ref}+100
    \    ${status1}    Run Keyword And Return Status    Double Click Element    ${Results_Row}\[${ResultsRowIndex_Ref}]${PerColumnValue}\[${ResultsHeaderColIndex}]${TextValue}/parent::td[1]/following-sibling::td[1]
    \    Exit For Loop If    '${status1}' == '${False}'
    \    @{ResultsRowList}    Get Results Table Column Value by Header List and Return    ${ResultsRowIndex_Ref}    @{aHeaderNames}
    \    Wait Until Element Is Visible    ${Textarea}
    \    Mx Scroll Element Into View    ${Textarea}
    \    ${FFC_RESPONSE}    Get Value   ${Textarea}
    \    ${status1}    Run Keyword If    '${sFundingStatus}'=='I'    Run Keyword And Return Status    Should Contain    ${FFC_RESPONSE}    Value ${sFundingDesk} of field fundingDesk is not an active code in table Funding Desk.    
    \    Run Keyword If    '${status1}' == '${True}'    Log    ${sFundingDesk} is currently inactive will not create xml file.
    \    ${status2}    Run Keyword If    '${status1}' == '${False}'    Run Keyword And Return Status    Should Contain    ${FFC_RESPONSE}    fundingDesk='${sFundingDesk}'        
    \    Run Keyword If    '${status2}' == '${True}'    Log    ${sFundingDesk} is currently inactive will not create xml file.
    \    lOG    ${FFC_RESPONSE}
    \    Run Keyword If    '${status2}' == '${False}'    Create File    ${dataset_path}${sOutputFilePath}_${ResultsRowIndex_Ref}.${sFileExtension}    ${FFC_RESPONSE}
    \    Run Keyword If    '${status2}' == '${False}'    Append To List    ${Multiple_List}    ${ResultsRowList}
    \    Run Keyword If    '${status2}' == '${False}'    Append To List    ${FileName_List}    ${dataset_path}${sOutputFilePath}_${ResultsRowIndex_Ref}.${sFileExtension}
    [Return]    ${Multiple_List}    ${FileName_List}    

Create Prerequisite for Multiple FX Files Scenario
    [Documentation]    This keyword is used to get the number of input GS files in the dataset and transformed the last CSV file to XLS file.
    ...    @author: cfrancis    23JUL2019    - intial create
    ...    @update: nbautist    08OCT2020    - updated arguments; removed comments on prerequisite generation
    [Arguments]    ${sInputGSFile}    ${sTransformedDataFile_FXRates}    ${sTransformedDataFileXML_FXRates}    ${sTransformedDataFile_Template_FXRates}    ${sfundingDesk}
    ...    ${sInputJSON}    ${sInputFilePath}    ${sFinalLIQDestination}    ${sTemplateFilePath}    ${Delimiter}=None
    @{InputGSFile_List}    Run Keyword If    '${Delimiter}'=='None'    Split String    ${sInputGSFile}    ,
    ...    ELSE    Split String    ${sInputGSFile}    ${Delimiter}
    ${InputGSFile_Count}    Get Length    ${InputGSFile_List}
    @{TransformedDataFile_FXRates_NoExt}    Split String    ${sTransformedDataFile_FXRates}    .
    ${sTransformedDataFile_FXRates_NoExt}    Set Variable    @{TransformedDataFile_FXRates_NoExt}[0]
    @{TransformedDataFileXML_FXRates_NoExt}    Split String    ${sTransformedDataFileXML_FXRates}    .
    ${sTransformedDataFileXML_FXRates_NoExt}    Set Variable    @{TransformedDataFileXML_FXRates_NoExt}[0]
    ${TransformedData_List}    Create List
    :FOR    ${Index}    IN RANGE    ${InputGSFile_Count}
    \    Set Global Variable    ${COUNTER}    0    
    \    ${InputGSFile}    Get From List    ${InputGSFile_List}    ${Index}
    \    Transform FXRates CSV Data to XLS File Readable for JSON Creation    ${sInputFilePath}${InputGSFile}    ${sTransformedDataFile_FXRates_NoExt}${Index}.${XLSX}    ${sTransformedDataFile_Template_FXRates}    ${sTransformedDataFileXML_FXRates_NoExt}${Index}.${XLSX}    ${sfundingDesk}
    \    Create Expected JSON for FXRates TL    ${sTransformedDataFile_FXRates_NoExt}${Index}.${XLSX}    ${sInputJSON}_${Index}    ${dataset_path}${sTransformedDataFile_FXRates_NoExt}${Index}.${XLSX}    ${dataset_path}${sTransformedDataFileXML_FXRates_NoExt}${Index}.${XLSX}
    \    Create Expected TextJMS XML for FXRates TL    ${sTransformedDataFileXML_FXRates_NoExt}${Index}.${XLSX}    ${sInputFilePath}    ${sFinalLIQDestination}_${Index}    ${sTemplateFilePath}
    \    Append To List    ${TransformedData_List}    ${sTransformedDataFileXML_FXRates_NoExt}${Index}.${XLSX}
    \    ${InputGSFile_Count}    Evaluate    ${InputGSFile_Count}-1    
    Set Global Variable    ${TRANSFORMEDDATA_LIST}    ${TransformedData_List}
    
Check for Duplicate Currency Pair
    [Documentation]    This keyword is used to verify if there are duplicate rows in the file
    ...    @author: cfrancis    19AUG2019    - initial create
    ...    @update: xmiranda    28AUG2019    - 'in Range' Keyword changed to 'IN RANGE' (uppercase)
    [Arguments]    ${aCSV_Content_List}    ${aRow_Val_List_Check}    ${iCurrent_Index}
    ${Index}    Set Variable    1
    ${Duplicate}    Set Variable    0
    ${Csv_Row_Count}    Get Length    ${aCSV_Content_List}
    :FOR    ${Index}    IN RANGE    1    ${Csv_Row_Count}
    \    Run Keyword If    ${iCurrent_Index}>${Index}    Continue For Loop
    \    ${Row_Val_List}    Get From List    ${aCSV_Content_List}    ${Index}
    \    ${Row_Val_0}    Get From List    ${Row_Val_List}    0
    \    ${Row_Val_Check_0}    Get From List    ${aRow_Val_List_Check}    0
    \    @{List_Row_Val_0}    Split String    ${Row_Val_0}    ,
    \    @{List_Row_Check_0}    Split String    ${Row_Val_Check_0}    ,
    \    ${Duplicate}    Run Keyword If    '@{List_Row_Val_0}[0]'=='@{List_Row_Check_0}[0]' and '@{List_Row_Val_0}[1]'=='@{List_Row_Check_0}[1]' and '@{List_Row_Val_0}[2]'=='@{List_Row_Check_0}[2]' and '@{List_Row_Val_0}[3]'=='@{List_Row_Check_0}[3]' and '@{List_Row_Val_0}[4]'=='@{List_Row_Check_0}[4]' and '@{List_Row_Val_0}[5]'=='@{List_Row_Check_0}[5]'    Evaluate    ${Duplicate} + 1
         ...    ELSE    Set Variable    ${Duplicate}
    [Return]    ${Duplicate}
