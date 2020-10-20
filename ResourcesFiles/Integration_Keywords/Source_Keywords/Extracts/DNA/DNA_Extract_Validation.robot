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
    [Arguments]    ${sZone}    ${sExtract_Path}    ${sBus_Date}

    @{ExtractionArea_Files}    SSHLibrary.List Directory    ${DNA_EXTRACTION_AREA_PATH}${sZone}
    ${Bus_Date_Converted}    Remove String    ${sBus_Date}    -
    
    ${DAT_File}    Run Keyword If    '${sZone}'=='ZONE3'    Set Variable    ${DNA_CCB_LIQ_FILENAME}SYD_${DNA_DATAASSURANCE_FILENAME}
    ...    ELSE IF    '${sZone}'=='ZONE2'    Set Variable    ${DNA_CCB_LIQ_FILENAME}EUR_${DNA_DATAASSURANCE_FILENAME}

    ### Validate DAT File is existing and download DAT File ###
    ${DAT_File_Exist}    Run Keyword And Return Status    Should Contain    ${ExtractionArea_Files}    ${DAT_File}${Bus_Date_Converted}${DNA_DAT_EXT}
    Run Keyword If    ${DAT_File_Exist}==${True}    Run Keywords    Delete File If Exist    ${sExtract_Path}${sZone}/${DAT_File}${Bus_Date_Converted}${DNA_DAT_EXT}
    ...    AND    SSHLibrary.Get File    ${DNA_EXTRACTION_AREA_PATH}${sZone}/${DAT_File}${Bus_Date_Converted}${DNA_DAT_EXT}    ${sExtract_Path}${sZone}\\
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
    \    ${Total_Control_Value}    Run Keyword If    '@{DAT_File_Content_List}[${Index_H}]'=='CONTROL_VALUE'    Set Variable    ${Total_Control_Value}
         ...    ELSE    Evaluate    ${Total_Control_Value}+@{DAT_File_Content_List}[${Index_H}]
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
    Compare Two Strings    ${Total_Control_Value}    @{DAT_File_Content_List}[2]
    
    ### Validate Trailer row does not have CRLF ###
    ${IsContains_CRLF}    Run Keyword And Return Status    Should Contain    ${DAT_File_Line_Content}    \r\n
    Run Keyword If    ${IsContains_CRLF}==${False}    Log    Trailer row does not contain CRLF character.
    ...    ELSE    Run Keyword and Continue On Failure    FAIL    Trailer row does contains CRLF character.

