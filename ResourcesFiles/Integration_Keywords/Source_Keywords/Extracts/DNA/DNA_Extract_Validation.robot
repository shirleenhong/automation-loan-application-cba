*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Test Teardown for DNA
    [Documentation]    This keyword is consists of Test Teardown keywords for DWE execution.
    ...    @author: clanding    28AUG2020    - initial create
    
    Close All Connections
    Run Keyword And Ignore Error    Close All Windows on LIQ
    Run Keyword And Ignore Error    Logout from Loan IQ

Test Setup for DNA
    [Documentation]    This keyword is consists of Test Setup keywords for DWE execution.
    ...    @author: clanding    28AUG2020    - initial create
    
    Mx Launch UFT    Visibility=True    UFTAddins=Java
    Login to Loan IQ    ${DWE_LIQ_USER}    ${DWE_LIQ_PASSWORD}

Validate Extracted Data Assurance File is Generated and Return
    [Documentation]    This keyword is used to go to Extraction folder and verify DAT file is existing.
    ...    @author: clanding    13OCT2020    - initial create
    ...    @update: clanding    29NOV2020    - updated DAT file location, from server '${DNA_SERVER}:${DNA_PORT}' to '\\MANCSWEVERG0006\out\'
    [Arguments]    ${sZone}    ${sExtract_Path}    ${sBus_Date}

    @{ExtractionArea_Files}    OperatingSystem.List Files In Directory    \\\\${DAT_FILE_SERVER}\\${DNA_DAT_FILE_EXTRACTION_AREA_PATH}\\${sZone}
    ${Bus_Date_Converted}    Remove String    ${sBus_Date}    -
    
    ${DAT_File}    Run Keyword If    '${sZone}'=='ZONE3'    Set Variable    ${DNA_CCB_LIQ_FILENAME}SYD_${DNA_DATAASSURANCE_FILENAME}
    ...    ELSE IF    '${sZone}'=='ZONE2'    Set Variable    ${DNA_CCB_LIQ_FILENAME}EUR_${DNA_DATAASSURANCE_FILENAME}

    ### Validate DAT File is existing and download DAT File ###
    ${DAT_File_Exist}    Run Keyword And Return Status    Should Contain    ${ExtractionArea_Files}    ${DAT_File}${Bus_Date_Converted}${DNA_DAT_EXT}
    Run Keyword If    ${DAT_File_Exist}==${True}    Run Keywords    Delete File If Exist    ${sExtract_Path}${sZone}/${DAT_File}${Bus_Date_Converted}${DNA_DAT_EXT}
    ...    AND    OperatingSystem.Copy File    \\\\${DAT_FILE_SERVER}\\${DNA_DAT_FILE_EXTRACTION_AREA_PATH}\\${sZone}\\${DAT_File}${Bus_Date_Converted}${DNA_DAT_EXT}    ${sExtract_Path}${sZone}\\${DAT_File}${Bus_Date_Converted}${DNA_DAT_EXT}
    ...    AND    Log    ${DAT_File}${Bus_Date_Converted}${DNA_DAT_EXT} is EXISTING in Extraction Area.
    ...    AND    Log To Console    ${DAT_File}${Bus_Date_Converted}${DNA_DAT_EXT} is EXISTING in Extraction Area.
    ...    ELSE    Run Keyword and Continue On Failure    FAIL    ${DAT_File}${Bus_Date_Converted}${DNA_DAT_EXT} is NOT EXISTING in Extraction Area:${\n}${ExtractionArea_Files}

    [Return]    ${DAT_File}${Bus_Date_Converted}${DNA_DAT_EXT}

Validate DAT File Contents if Correct
    [Documentation]    This keyword is used to validate DAT file contents are correct.
    ...    @author: clanding    14OCT2020    - initial create
    ...    @author: clanding    15OCT2020    - updated Verify Last Column of DAT File to Verify No Extra Comma in DAT File
    [Arguments]    ${sZone}    ${sExtract_Path}    ${sDAT_File}
    
    ${DAT_File_Content}    OperatingSystem.Get File    ${sExtract_Path}${sZone}/${sDAT_File}
    ${DAT_File_Content_Count}    Get Line Count    ${DAT_File_Content}
    
    :FOR    ${LineCount}    IN RANGE    ${DAT_File_Content_Count}
    \    ${DAT_File_Line_Content}    Get Line    ${DAT_File_Content}    ${LineCount}
    \    Verify No Extra Comma in DAT File    ${DAT_File_Line_Content}
    \    Verify DAT File Columns if Correct    ${DAT_File_Line_Content}
    \    Verify CSV File Contains Delimiter    ${sExtract_Path}${sZone}/${sDAT_File}    ,
    \    Verify DAT File Contents are Not Quoted    ${DAT_File_Line_Content}

    Verify DAT File is in CSV Format    ${DAT_File_Content}
    Verify Trailer Record of DAT File    ${DAT_File_Content}

Verify No Extra Comma in DAT File
    [Documentation]    This keyword is used to verify the last column of DAT file does not contain ',,,'.
    ...    @author: clanding    14OCT2020    - initial create
    ...    @author: clanding    15OCT2020    - updated validation and keyword name
    [Arguments]    ${sDAT_File_Content}

    ${IsTrailer}    Run Keyword And Return Status    Should Contain    ${sDAT_File_Content}    T,
    Return From Keyword If    ${IsTrailer}==${True}
    ${Expected_Columns}    OperatingSystem.Get File    ${DNA_DAT_FILE_COLUMNS}
    ${Expected_Column_Count}    Get Line Count    ${Expected_Columns}
    ${DAT_File_Comma}    Get Count    ${sDAT_File_Content}    ,
    ${No_Extra_Comma}    Run Keyword And Return Status    Should Be Equal As Integers    ${Expected_Column_Count}    ${DAT_File_Comma}
    Run Keyword If    ${No_Extra_Comma}==${True}    Log    ${sDAT_File_Content} does not contain extra comma.
    ...    ELSE    Run Keyword and Continue On Failure    FAIL    ${sDAT_File_Content} contains extra comma.

Verify DAT File Columns if Correct
    [Documentation]    This keyword is used to verify the columns in the DAT file are correct.
    ...    @author: clanding    14OCT2020    - initial create
    [Arguments]    ${sDAT_File_Content}
    
    ${DAT_File_Content_List}    Split String    ${sDAT_File_Content}    ,
    ${DAT_File_Content_List_Count}    Get Length    ${DAT_File_Content_List}
    Return From Keyword If    '@{DAT_File_Content_List}[0]'!='H'
    
    ${Expected_Columns}    OperatingSystem.Get File    ${DNA_DAT_FILE_COLUMNS}
    :FOR    ${Index}    IN RANGE    1    ${DAT_File_Content_List_Count}
    \    ${IsColumnExisting}    Run Keyword And Return Status    Should Contain    ${Expected_Columns}    @{DAT_File_Content_List}[${Index}]
    \    Run Keyword If    ${IsColumnExisting}==${True}    Log    @{DAT_File_Content_List}[${Index}] is existing in expected columns:${\n}${Expected_Columns}
         ...    ELSE    Run Keyword and Continue On Failure    FAIL    @{DAT_File_Content_List}[${Index}] is NOT existing in expected columns:${\n}${Expected_Columns}

Verify DAT File Contents are Not Quoted
    [Documentation]    This keyword is used to verify the contents in the DAT file does not contain double quotes.
    ...    @author: clanding    14OCT2020    - initial create
    [Arguments]    ${sDAT_File_Content}
    
    ${DAT_File_Content_List}    Split String    ${sDAT_File_Content}    ,
    ${DAT_File_Content_List_Count}    Get Length    ${DAT_File_Content_List}
    
    :FOR    ${Index}    IN RANGE    ${DAT_File_Content_List_Count}
    \    ${IsQuoteNotExisting}    Run Keyword And Return Status    Should Not Contain    @{DAT_File_Content_List}[${Index}]    "
    \    Run Keyword If    ${IsQuoteNotExisting}==${True}    Log    " is not existing @{DAT_File_Content_List}[${Index}].
         ...    ELSE    Run Keyword and Continue On Failure    FAIL    " is existing @{DAT_File_Content_List}[${Index}].

Verify DAT File is in CSV Format
    [Documentation]    This keyword is used to verify DAT file is in CSV Format
    ...    @author: clanding    14OCT2020    - initial create
    [Arguments]    ${sDAT_File_Content}
    
    ${LineCount}    Get Line Count    ${sDAT_File_Content}
    
    ### Get header/column count ###
    ${DAT_File_Line_Content_H}    Get Line    ${sDAT_File_Content}    0
    ${DAT_File_Content_List}    Split String    ${DAT_File_Line_Content_H}    ,
    ${H_Column_Count}    Get Length    ${DAT_File_Content_List}
    
    :FOR    ${Index}    IN RANGE    1    ${LineCount}
    \    ${DAT_File_Line_Content_D}    Get Line    ${sDAT_File_Content}    ${Index}
    \    ${DAT_File_Content_List}    Split String    ${DAT_File_Line_Content_D}    ,
    \    Exit For Loop If    '@{DAT_File_Content_List}[0]'=='T'
    \    ${D_Column_Count}    Get Length    ${DAT_File_Content_List}
    \    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Integers    ${D_Column_Count}    ${H_Column_Count}
    \    Run Keyword If    ${IsEqual}==${True}    Log    Header (${H_Column_Count}) and Data (${D_Column_Count}) columns are equal.
         ...    ELSE    Run Keyword and Continue On Failure    FAIL    Header (${H_Column_Count}) and Data (${D_Column_Count}) columns are NOT equal.

Verify Trailer Record of DAT File
    [Documentation]    This keyword is used to verify Trailer row format of DAT file.
    ...    @author: clanding    14OCT2020    - initial create
    ...    @update: clanding    05NOV2020    - added handling for negative control value
    [Arguments]    ${sDAT_File_Content}
    
    ${LineCount}    Get Line Count    ${sDAT_File_Content}
    
    ### Get CONTROL_VALUE Index ###
    ${DAT_File_Line_Content_H}    Get Line    ${sDAT_File_Content}    0
    ${DAT_File_Content_H_List}    Split String    ${DAT_File_Line_Content_H}    ,
    ${H_Count}    Get Length    ${DAT_File_Content_H_List}
    :FOR    ${Index_H}    IN RANGE    ${H_Count}
    \    Log    @{DAT_File_Content_H_List}[${Index_H}]
    \    Exit For Loop If    '@{DAT_File_Content_H_List}[${Index_H}]'=='CONTROL_VALUE'
    
    ### Get Total Record Count and Control Value ###
    ${Record_Count}    Set Variable    0
    ${Total_Control_Value}    Set Variable    0
    :FOR    ${Index}    IN RANGE    ${LineCount}
    \    ${DAT_File_Line_Content}    Get Line    ${sDAT_File_Content}    ${Index}
    \    ${DAT_File_Content_List}    Split String    ${DAT_File_Line_Content}    ,
    \    ${Record_Count}    Evaluate    ${Record_Count}+1
    \    Exit For Loop If    '@{DAT_File_Content_List}[0]'=='T'
    \    Log    Current Control Value: @{DAT_File_Content_List}[${Index_H}]
    \    ${Contains_Negative}    Run Keyword And Return Status    Should Contain    @{DAT_File_Content_List}[${Index_H}]    -
    \    ${Control_Value}    Run Keyword If    ${Contains_Negative}==${True}    Remove String    @{DAT_File_Content_List}[${Index_H}]    -
         ...    ELSE    Set Variable    @{DAT_File_Content_List}[${Index_H}]
    \    ${Total_Control_Value}    Run Keyword If    '${Control_Value}'=='CONTROL_VALUE'    Set Variable    ${Total_Control_Value}
         ...    ELSE IF    ${Contains_Negative}==${True}    Evaluate    ${Total_Control_Value}-${Control_Value}
         ...    ELSE    Evaluate    ${Total_Control_Value}+${Control_Value}
    \    Log    Running Total: ${Total_Control_Value}
    Log    Total Record Count: ${Record_Count}
    Log    Control Value Sum: ${Total_Control_Value}

    ### Get Trailer index ###
    :FOR    ${Index_T}    IN RANGE    ${LineCount}
    \    ${DAT_File_Line_Content}    Get Line    ${sDAT_File_Content}    ${Index_T}
    \    ${DAT_File_Content_List}    Split String    ${DAT_File_Line_Content}    ,
    \    Exit For Loop If    '@{DAT_File_Content_List}[0]'=='T'
    
    Log    Trailer Record Count: @{DAT_File_Content_List}[1]
    Log    Trailer Control Value Sum: @{DAT_File_Content_List}[2]
    
    Compare Two Strings    ${Record_Count}    @{DAT_File_Content_List}[1]
    ${Total_Control_Value}    Evaluate  "%.2f" % (${Total_Control_Value})
    ${Actual_Control_Value}    Evaluate  "%.2f" % (@{DAT_File_Content_List}[2])
    Compare Two Strings    ${Total_Control_Value}    ${Actual_Control_Value}
    
    ### Validate Trailer row does not have CRLF ###
    ${IsContains_CRLF}    Run Keyword And Return Status    Should Contain    ${DAT_File_Line_Content}    \r\n
    Run Keyword If    ${IsContains_CRLF}==${False}    Log    Trailer row does not contain CRLF character.
    ...    ELSE    Run Keyword and Continue On Failure    FAIL    Trailer row does contains CRLF character.

Verify DAT File Control Value and DB Record are Matched
    [Documentation]    This keyword is used to validate DAT file content matched DB results.
    ...    @author: clanding    15OCT2020    - initial create
    [Arguments]    ${sZone}    ${sExtract_Path}    ${sDAT_File}    ${sBranch_Code}
    
    ${DAT_File_Content}    OperatingSystem.Get File    ${sExtract_Path}${sZone}/${sDAT_File}
    ${DAT_File_Content_Count}    Get Line Count    ${DAT_File_Content}
    
    ${DAT_File_Line_Content_H}    Get Line    ${DAT_File_Content}    0    ### Header
    ${DAT_File_List_H}    Split String    ${DAT_File_Line_Content_H}    ,
    ${DAT_File_ListCount}    Get Length    ${DAT_File_List_H}
    
    ### Get CONTROL_MATRIX index ###
    :FOR    ${CONTROL_MATRIX_Index}    IN RANGE    ${DAT_File_ListCount}
    \    Log    @{DAT_File_List_H}[${CONTROL_MATRIX_Index}]
    \    Exit For Loop If    '@{DAT_File_List_H}[${CONTROL_MATRIX_Index}]'=='CONTROL_MATRIX'
    
    ### Get BUSINESS_DATE index ###
    :FOR    ${BUSINESS_DATE_Index}    IN RANGE    ${DAT_File_ListCount}
    \    Log    @{DAT_File_List_H}[${BUSINESS_DATE_Index}]
    \    Exit For Loop If    '@{DAT_File_List_H}[${BUSINESS_DATE_Index}]'=='BUSINESS_DATE'
    
    ### Get CONTROL_VALUE index ###
    :FOR    ${CONTROL_VALUE_Index}    IN RANGE    ${DAT_File_ListCount}
    \    Log    @{DAT_File_List_H}[${CONTROL_VALUE_Index}]
    \    Exit For Loop If    '@{DAT_File_List_H}[${CONTROL_VALUE_Index}]'=='CONTROL_VALUE'

    ### Get CURRENCY index ###
    :FOR    ${CURRENCY_Index}    IN RANGE    ${DAT_File_ListCount}
    \    Log    @{DAT_File_List_H}[${CURRENCY_Index}]
    \    Exit For Loop If    '@{DAT_File_List_H}[${CURRENCY_Index}]'=='CURRENCY'
    
    :FOR    ${LineCount}    IN RANGE    1    ${DAT_File_Content_Count}
    \    ${DAT_File_Line_Content}    Get Line    ${DAT_File_Content}    ${LineCount}
    \    Validate DAT File Line Value and Compare to DB Result    ${sZone}    ${sBranch_Code}    ${DAT_File_Line_Content}
         ...    ${CONTROL_MATRIX_Index}    ${BUSINESS_DATE_Index}    ${CONTROL_VALUE_Index}    ${CURRENCY_Index}

Validate DAT File Line Value and Compare to DB Result
    [Documentation]    This keyword is used to connect in Loan IQ database and execute query designed for each row of DAT file
    ...    and validate amount value is correct.
    [Arguments]    ${sZone}    ${sBranch_Code}    ${sDAT_File_Line}    ${iCONTROL_MATRIX_Index}    ${iBUSINESS_DATE_Index}    ${iCONTROL_VALUE_Index}
    ...    ${iCURRENCY_Index}
    
    ${DAT_File_List}    Split String    ${sDAT_File_Line}    ,
    ${DAT_File_ListCount}    Get Length    ${DAT_File_List}
    Return From Keyword If    '@{DAT_File_List}[0]'=='T'
    
    Log    DAT File CONTROL_MATRIX: @{DAT_File_List}[${iCONTROL_MATRIX_Index}]
    Log    DAT File BUSINESS_DATE: @{DAT_File_List}[${iBUSINESS_DATE_Index}]
    Log    DAT File CONTROL_VALUE: @{DAT_File_List}[${iCONTROL_VALUE_Index}]
    Log    DAT File CURRENCY: @{DAT_File_List}[${iCURRENCY_Index}]

    ${Expected_Currency}    Run Keyword If    '@{DAT_File_List}[${iCURRENCY_Index}]'!=''    Set Variable    @{DAT_File_List}[${iCURRENCY_Index}]
    ...    ELSE IF    '${sZone}'=='ZONE3'    Set Variable    AUD
    ...    ELSE IF    '${sZone}'=='ZONE2'    Set Variable    EUR
    
    ${DB_Branch_Code}    Set Variable
    ${Branch_Code_List}    Split String    ${sBranch_Code}    ,
    ${Branch_Code_ListCount}    Get Length    ${Branch_Code_List}
    :FOR    ${Index}    IN RANGE    ${Branch_Code_ListCount}
    \    ${DB_Branch_Code}    Run Keyword If    '${Index}'=='0'    Catenate    SEPARATOR=    '    @{Branch_Code_List}[${Index}]    '
         ...    ELSE    Catenate    SEPARATOR=    ${DB_Branch_Code}    ,    '    @{Branch_Code_List}[${Index}]    '
    \    Log    ${DB_Branch_Code}
    Log    Branch Code: ${DB_Branch_Code}    

    ${Control_Matrix}    Set Variable    @{DAT_File_List}[${iCONTROL_MATRIX_Index}]
    ${Expected_Date}    Convert Date    @{DAT_File_List}[${iBUSINESS_DATE_Index}]    result_format=%d-%b-%Y    date_format=%Y-%m-%d
    ${DB_Control_Value}    Run Keyword If    '${Control_Matrix}'=='SUM_NEW_FUNDING_AMOUNT'    Get Sum New Funding Amount from LIQ Database    ${Expected_Date}    ${Expected_Currency}
    ...    ELSE IF    '${Control_Matrix}'=='SUM_OF_ACCRUED_FEES'    Get Sum of Accrued Fees from LIQ Database    ${DB_Branch_Code}    ${Expected_Currency}
    ...    ELSE IF    '${Control_Matrix}'=='SUM_OF_ACCRUED_INTEREST'    Get Sum of Accrued Interest from LIQ Database    ${DB_Branch_Code}    ${Expected_Currency}
    ...    ELSE IF    '${Control_Matrix}'=='SUM_OF_HB_DEAL_LIMITS_GROSS'    Get Sum of Deal Limits Gross from LIQ Database    ${DB_Branch_Code}    ${Expected_Currency}
    ...    ELSE IF    '${Control_Matrix}'=='SUM_OF_HB_DEAL_LIMITS_NET'    Get Sum of Deal Limits Net from LIQ Database    ${DB_Branch_Code}    ${Expected_Currency}
    ...    ELSE IF    '${Control_Matrix}'=='SUM_OF_HB_FAC_LIMITS_GROSS'    Get Sum of Facility Limits Gross from LIQ Database    ${DB_Branch_Code}    ${Expected_Currency}
    ...    ELSE IF    '${Control_Matrix}'=='SUM_OF_HB_FAC_LIMITS_NET'    Get Sum of Facility Limits Net from LIQ Database    ${DB_Branch_Code}    ${Expected_Currency}
    ...    ELSE IF    '${Control_Matrix}'=='SUM_OF_PRINCIPAL_BALANCES'    Get Sum of Principal Balances from LIQ Database    ${DB_Branch_Code}    ${Expected_Currency}
    ...    ELSE IF    '${Control_Matrix}'=='SUM_TRANSACTION_AMOUNT'    Get Sum of Transaction Amount from LIQ Database    ${DB_Branch_Code}    ${Expected_Currency}
    ...    ELSE IF    '${Control_Matrix}'=='TOTAL_ACTIVE_DEAL_BORROWERS'    Get Total Active Deal Borrowers from LIQ Database    ${DB_Branch_Code}    ${Expected_Date}
    ...    ELSE IF    '${Control_Matrix}'=='TOTAL_ACTIVE_DEAL_COUNT'    Get Total Active Deal Count from LIQ Database    ${DB_Branch_Code}    ${Expected_Date}
    ...    ELSE IF    '${Control_Matrix}'=='TOTAL_ACTIVE_FAC_BORROWERS'    Get Total Active Facility Borrowers from LIQ Database    ${DB_Branch_Code}
    ...    ELSE IF    '${Control_Matrix}'=='TOTAL_ACTIVE_FAC_COUNT'    Get Total Active Facility Count from LIQ Database    ${DB_Branch_Code}
    ...    ELSE IF    '${Control_Matrix}'=='TOTAL_ACTIVE_OST_BORROWERS'    Get Total Active OST Borrowers from LIQ Database    ${DB_Branch_Code}
    ...    ELSE IF    '${Control_Matrix}'=='TOTAL_ACTIVE_OST_COUNT'    Get Total Active OST Count from LIQ Database    ${DB_Branch_Code}
    ...    ELSE    Set Variable    0

    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Integers    @{DAT_File_List}[${iCONTROL_VALUE_Index}]    ${DB_Control_Value}
    Run Keyword If    ${IsEqual}==${True}    Log    DAT File Control Value: '@{DAT_File_List}[${iCONTROL_VALUE_Index}]' is equal to DB Control Value: ${DB_Control_Value}
    ...    ELSE    Run Keyword and Continue On Failure    FAIL    DAT File Control Value: '@{DAT_File_List}[${iCONTROL_VALUE_Index}]' is NOT equal to DB Control Value: ${DB_Control_Value}

Verify DAT File Control Value and CSV Files are Matched
    [Documentation]    This keyword is used to validate DAT file content matched CSV files record.
    ...    @author: clanding    19OCT2020    - initial create
    [Arguments]    ${sZone}    ${sExtract_Path}    ${sDAT_File}    ${sBranch_Code}    ${sDWE_Extract_Path}    ${sBus_Date}
    
    ${DAT_File_Content}    OperatingSystem.Get File    ${sExtract_Path}${sZone}/${sDAT_File}
    ${DAT_File_Content_Count}    Get Line Count    ${DAT_File_Content}
    
    ${DAT_File_Line_Content_H}    Get Line    ${DAT_File_Content}    0    ### Header
    ${DAT_File_List_H}    Split String    ${DAT_File_Line_Content_H}    ,
    ${DAT_File_ListCount}    Get Length    ${DAT_File_List_H}
    
    ### Get CONTROL_MATRIX index ###
    :FOR    ${CONTROL_MATRIX_Index}    IN RANGE    ${DAT_File_ListCount}
    \    Log    @{DAT_File_List_H}[${CONTROL_MATRIX_Index}]
    \    Exit For Loop If    '@{DAT_File_List_H}[${CONTROL_MATRIX_Index}]'=='CONTROL_MATRIX'
    
    ### Get BUSINESS_DATE index ###
    :FOR    ${BUSINESS_DATE_Index}    IN RANGE    ${DAT_File_ListCount}
    \    Log    @{DAT_File_List_H}[${BUSINESS_DATE_Index}]
    \    Exit For Loop If    '@{DAT_File_List_H}[${BUSINESS_DATE_Index}]'=='BUSINESS_DATE'
    
    ### Get CONTROL_VALUE index ###
    :FOR    ${CONTROL_VALUE_Index}    IN RANGE    ${DAT_File_ListCount}
    \    Log    @{DAT_File_List_H}[${CONTROL_VALUE_Index}]
    \    Exit For Loop If    '@{DAT_File_List_H}[${CONTROL_VALUE_Index}]'=='CONTROL_VALUE'

    ### Get CURRENCY index ###
    :FOR    ${CURRENCY_Index}    IN RANGE    ${DAT_File_ListCount}
    \    Log    @{DAT_File_List_H}[${CURRENCY_Index}]
    \    Exit For Loop If    '@{DAT_File_List_H}[${CURRENCY_Index}]'=='CURRENCY'
    
    :FOR    ${LineCount}    IN RANGE    1    ${DAT_File_Content_Count}
    \    ${DAT_File_Line_Content}    Get Line    ${DAT_File_Content}    ${LineCount}
    \    ${DAT_File_Line_Content_List}    Split String    ${DAT_File_Line_Content}    ,
    \    Exit For Loop If    '@{DAT_File_Line_Content_List}[0]'=='T'    ###Exit when data is on the Trailer row
    \    
    \    ${Expected_Currency}    Run Keyword If    '@{DAT_File_Line_Content_List}[${CURRENCY_Index}]'!=''    Set Variable    @{DAT_File_Line_Content_List}[${CURRENCY_Index}]
         ...    ELSE IF    '${sZone}'=='ZONE3'    Set Variable    AUD
         ...    ELSE IF    '${sZone}'=='ZONE2'    Set Variable    EUR
    \
    \    ${Control_Matrix}    Set Variable    @{DAT_File_Line_Content_List}[${CONTROL_MATRIX_Index}]
    \    ${CSV_Control_Value}    Run Keyword If    '${Control_Matrix}'=='SUM_NEW_FUNDING_AMOUNT'    Access GL Entry CSV File for New Funding Amount and Return Sum of Amount    ${sDWE_Extract_Path}    ${sZone}    ${sBus_Date}
         ...    ELSE IF    '${Control_Matrix}'=='SUM_OF_ACCRUED_FEES'    Access Balance Subledger CSV File and Return Sum of Amount    ${sDWE_Extract_Path}    ${sZone}    ${sBus_Date}    ${Expected_Currency}    FEERC
         ...    ELSE IF    '${Control_Matrix}'=='SUM_OF_ACCRUED_INTEREST'    Access Balance Subledger CSV File and Return Sum of Amount    ${sDWE_Extract_Path}    ${sZone}    ${sBus_Date}    ${Expected_Currency}    INTRC
         ...    ELSE IF    '${Control_Matrix}'=='SUM_OF_HB_DEAL_LIMITS_GROSS'    Access Deal and Prod Pos Current CSV Files and Return Sum    ${sDWE_Extract_Path}    ${sZone}    ${sBus_Date}    ${Expected_Currency}    ${Control_Matrix}
         ...    ELSE IF    '${Control_Matrix}'=='SUM_OF_HB_DEAL_LIMITS_NET'    Access Deal and Prod Pos Current CSV Files and Return Sum    ${sDWE_Extract_Path}    ${sZone}    ${sBus_Date}    ${Expected_Currency}    ${Control_Matrix}
         ...    ELSE IF    '${Control_Matrix}'=='SUM_OF_PRINCIPAL_BALANCES'    Access Balance Subledger CSV File and Return Sum of Amount    ${sDWE_Extract_Path}    ${sZone}    ${sBus_Date}    ${Expected_Currency}    PRINC
         ...    ELSE IF    '${Control_Matrix}'=='SUM_TRANSACTION_AMOUNT'    Access GL Entry CSV File for Transaction Amount and Return Sum of Amount    ${sDWE_Extract_Path}    ${sZone}    ${sBus_Date}    ${Expected_Currency}
         ...    ELSE IF    '${Control_Matrix}'=='TOTAL_ACTIVE_DEAL_BORROWERS'    Access Deal and Borrower CSV Files and Return Sum    ${sDWE_Extract_Path}    ${sZone}    ${sBus_Date}
         ...    ELSE IF    '${Control_Matrix}'=='TOTAL_ACTIVE_DEAL_COUNT'    Access Deal CSV File and Return Sum    ${sDWE_Extract_Path}    ${sZone}    ${sBus_Date}    ${sBranch_Code}
         ...    ELSE    Log    Control Matrix '${Control_Matrix}' is not yet handled.    level=WARN
    \    Continue For Loop If    '${CSV_Control_Value}'=='None'
    \    
    \    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Integers    @{DAT_File_Line_Content_List}[${CONTROL_VALUE_Index}]    ${CSV_Control_Value}
    \    Run Keyword If    ${IsEqual}==${True}    Log    Control Matrix '${Control_Matrix}' - DAT File Control Value: '@{DAT_File_Line_Content_List}[${CONTROL_VALUE_Index}]' is equal to CSV Control Value: '${CSV_Control_Value}'
         ...    ELSE    Run Keyword and Continue On Failure    FAIL    Control Matrix '${Control_Matrix}' - DAT File Control Value: '@{DAT_File_Line_Content_List}[${CONTROL_VALUE_Index}]' is NOT equal to CSV Control Value: '${CSV_Control_Value}'
