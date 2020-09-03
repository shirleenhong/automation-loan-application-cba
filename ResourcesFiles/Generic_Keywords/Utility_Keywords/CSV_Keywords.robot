*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***


*** Keywords ***

Validate Records Exist Between 2 CSV Files
    [Documentation]    This keyword validates if records exist between 2 CSV files
    ...    @author: ehugo    28AUG2019
    [Arguments]    ${sReferenceTable_Header_Name}    ${sReferenceTable_Name}    ${sReferenceTable_CSV_FileName}    
    ...    ${sSourceTable_Header_Name}    ${sSourceTable_Name}    ${sSourceTable_CSV_FileName}
    
    ${ReferenceTable_CSV_Content}    Read Csv File To List    ${sReferenceTable_CSV_FileName}    |
    ${SourceTable_CSV_Content}    Read Csv File To List    ${sSourceTable_CSV_FileName}    |
    
    ${ReferenceTable_Length}    Get Length    ${ReferenceTable_CSV_Content}
    ${ReferenceTable_Header_Index}    Get the Column index of the Header    ${sReferenceTable_CSV_FileName}    ${sReferenceTable_Header_Name}
    
    ${SourceTable_Length}    Get Length    ${SourceTable_CSV_Content}
    ${SourceTable_Header_Index}    Get the Column index of the Header    ${sSourceTable_CSV_FileName}    ${sSourceTable_Header_Name}    
    
    ${Item_List}    Create List
    
    :FOR    ${i}    IN RANGE    1    ${ReferenceTable_Length}
    \    ${ReferenceTable_Row_Item}    Get From List    ${ReferenceTable_CSV_Content}    ${i}
    \    ${ReferenceTable_Row_Value}    Get From List    ${ReferenceTable_Row_Item}    ${ReferenceTable_Header_Index}
    \    Append To List     ${Item_List}    ${ReferenceTable_Row_Value}
    
    :FOR    ${i}    IN RANGE    1    ${SourceTable_Length}
    \    ${SourceTable_Row_Item}    Get From List    ${SourceTable_CSV_Content}    ${i}
    \    ${SourceTable_Row_Value}    Get From List    ${SourceTable_Row_Item}    ${SourceTable_Header_Index}
    \    ${count}    Get Match Count    ${Item_List}    ${SourceTable_Row_Value}    
    \    Run Keyword If    ${count}==0    Run Keyword And Continue On Failure    Fail    ${sSourceTable_Name} value '${SourceTable_Row_Value}' does not exist in ${sReferenceTable_Name} table.    
         ...    ELSE    Log    ${sSourceTable_Name} value '${SourceTable_Row_Value}' exists in ${sReferenceTable_Name} table.

Validate Records Exist Between 2 CSV Files - with None value in Source Table
    [Documentation]    This keyword validates if records exist between 2 CSV files
    ...    @author: ehugo    28AUG2019
    [Arguments]    ${sReferenceTable_Header_Name}    ${sReferenceTable_Name}    ${sReferenceTable_CSV_FileName}    
    ...    ${sSourceTable_Header_Name}    ${sSourceTable_Name}    ${sSourceTable_CSV_FileName}
    
    ${ReferenceTable_CSV_Content}    Read Csv File To List    ${sReferenceTable_CSV_FileName}    |
    ${SourceTable_CSV_Content}    Read Csv File To List    ${sSourceTable_CSV_FileName}    |
    
    ${ReferenceTable_Length}    Get Length    ${ReferenceTable_CSV_Content}
    ${ReferenceTable_Header_Index}    Get the Column index of the Header    ${sReferenceTable_CSV_FileName}    ${sReferenceTable_Header_Name}
    
    ${SourceTable_Length}    Get Length    ${SourceTable_CSV_Content}
    ${SourceTable_Header_Index}    Get the Column index of the Header    ${sSourceTable_CSV_FileName}    ${sSourceTable_Header_Name}    
    
    ${Item_List}    Create List
    
    :FOR    ${i}    IN RANGE    1    ${ReferenceTable_Length}
    \    ${ReferenceTable_Row_Item}    Get From List    ${ReferenceTable_CSV_Content}    ${i}
    \    ${ReferenceTable_Row_Value}    Get From List    ${ReferenceTable_Row_Item}    ${ReferenceTable_Header_Index}
    \    Append To List     ${Item_List}    ${ReferenceTable_Row_Value}
    
    :FOR    ${i}    IN RANGE    1    ${SourceTable_Length}
    \    ${SourceTable_Row_Item}    Get From List    ${SourceTable_CSV_Content}    ${i}
    \    ${SourceTable_Row_Value}    Get From List    ${SourceTable_Row_Item}    ${SourceTable_Header_Index}
    \    ${count}    Get Match Count    ${Item_List}    ${SourceTable_Row_Value.strip()}    
    \    Run Keyword If    ${count}==0 and '${SourceTable_Row_Value.strip()}'!='NONE'    Run Keyword And Continue On Failure    Fail    ${sSourceTable_Name} value '${SourceTable_Row_Value}' does not exist in ${sReferenceTable_Name} table.    
         ...    ELSE IF    ${count}==0 and '${SourceTable_Row_Value.strip()}'=='NONE'    Log    ${sSourceTable_Name} value is NONE.
         ...    ELSE    Log    ${sSourceTable_Name} value '${SourceTable_Row_Value}' exists in ${sReferenceTable_Name} table.

Get the Column index of the Header
    [Documentation]    This keyword retrieves the Column index for a certain Header
    ...    @author: ehugo    29AUG2019
    [Arguments]    ${sCSV_FileName}    ${sHeader_Name}
    
    ${CSV_Content}    Read Csv File To List    ${sCSV_FileName}    |
    
    ${Header}    Get From List    ${CSV_Content}    0
    ${Header_Index}    Get Index From List    ${Header}    ${sHeader_Name}
    [Return]    ${Header_Index}

Get the Column Value using Row Number and Column Index
    [Documentation]    This keyword retrieves the Column Value using Row Number and Column Index
    ...    @author: ehugo    29AUG2019
    [Arguments]    ${sCSV_FileName}    ${sRowToValidate}    ${iColumn_Index}
    
    ${CSV_Content}    Read Csv File To List    ${sCSV_FileName}    |
    
    ${Row_Item}    Get From List    ${CSV_Content}    ${sRowToValidate}
    ${Column_Value}    Get From List    ${Row_Item}    ${iColumn_Index}    
    [Return]    ${Column_Value}

Verify that the Column has no Empty Records 
    [Documentation]    This keyword validates a certain column in CSV that it doesn't have a blank/empty record.
    ...    @author: mgaling    04Sep2019    Initial Create
    [Arguments]    ${aCSV_Content}    ${sCSV_FileName}    ${sHeader_Name}    
     
    ${Row_Count}    Get Length    ${aCSV_Content}  
    ${Header_Index}    Get the Column index of the Header    ${sCSV_FileName}    ${sHeader_Name}
    
    ${Column_Records}    Create List
    :FOR    ${i}    IN RANGE    1    ${Row_Count}
    \    ${Table_Row_Item}    Get From List    ${aCSV_Content}    ${i}
    \    ${Table_Row_Value}    Get From List    ${Table_Row_Item}    ${Header_Index}
    \    Append To List     ${Column_Records}    ${Table_Row_Value}
    
    ${result}    Run Keyword And Return Status        Should Not Contain    ${Column_Records}    ${Empty}
    Run Keyword If    ${result}==${True}    Log    ${sHeader_Name} column has no empty records.
    ...    ELSE    Log    Fail    ${sHeader_Name} column has empty records.

Verify CSV File Contains Delimiter
    [Documentation]    This keyword is used to verify CSV file have specified delimiter value.
    ...    @author: clanding    09JUL2020    - initial create
    [Arguments]    ${sCSV_File}    ${sDelimiter}=None

    ${Delimiter}    Run Keyword If    '${sDelimiter}'=='None'    Set Variable    ,
    ...    ELSE    Set Variable    ${sDelimiter}

    ${CSV_Content}    OperatingSystem.Get File    ${sCSV_File}
    ${CSV_Line_Content_List}    Split String    ${CSV_Content}    ${Delimiter}
    ${CSV_Line_Content_List_Count}    Get Length    ${CSV_Line_Content_List}
    Run Keyword If    ${CSV_Line_Content_List_Count}==1    Run Keyword And Continue On Failure    FAIL    CSV DOES NOT contain delimiter: '${Delimiter}'.
    ...    ELSE    Log    CSV contains delimiter: '${Delimiter}'.