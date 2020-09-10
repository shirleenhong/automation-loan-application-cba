*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Set SAPWUL Test Data    
    [Documentation]    This keyword sets the SAPWUL Test Data for Event XML Section Verification.
    ...    @author: hstone    24SEP2019    Initial create
    ...    @update: hstone    01OCT2019    Added Other Facility Updates Key/Value List for future facility updates that may be specified by the user.
    [Arguments]    ${sSapwulEvent}    ${sSapwulDataSetRowId}    ${sFacilityName}    ${sFacilityID}    ${sFacilityControlNumber}    ${sEventUsername}    ${sCustomerExternalId_List}
    ...    ${OtherFacilityUpdates_Key_List}=@{EMPTY}    ${OtherFacilityUpdates_Value_List}=@{EMPTY} 
    Run Keyword If    '${sSapwulEvent}'!='None'    Run Keywords                
    ...    Set SAPWUL Cell List    SAPWUL_Payload    Payload_customerExternalID    ${sSapwulDataSetRowId}    ${sCustomerExternalId_List}        
    ...    AND    Set SAPWUL Data to Excel    SAPWUL_Payload    Payload_facilityName    ${sSapwulDataSetRowId}    ${sFacilityName}
    ...    AND    Set SAPWUL Data to Excel    SAPWUL_Payload    Payload_facilityControlNumber    ${sSapwulDataSetRowId}    ${sFacilityControlNumber}
    ...    AND    Set SAPWUL Data to Excel    SAPWUL_Payload    Internal_facilityId    ${sSapwulDataSetRowId}    ${sFacilityID}
    ...    AND    Set SAPWUL Data to Excel    SAPWUL_Payload    Internal_userId    ${sSapwulDataSetRowId}    ${sEventUsername} 
     
    Run Keyword If    ${OtherFacilityUpdates_Key_List}!=@{EMPTY}    Set Other SAPWUL Test Data    ${OtherFacilityUpdates_Key_List}    ${OtherFacilityUpdates_Value_List}    ${sSapwulDataSetRowId}
    
Set Other SAPWUL Test Data 
    [Documentation]    This keyword sets other SAPWUL Test Data speciified by the user for Event XML Section Verification.
    ...    @author: hstone    24SEP2019    Initial create
    [Arguments]    ${OtherFacilityUpdates_Key_List}    ${OtherFacilityUpdates_Value_List}    ${sSapwulDataSetRowId}
    ${iTestDataUpdate_Count}    Get Length    ${OtherFacilityUpdates_Key_List}
    :FOR    ${iTestData_Num}    IN RANGE    ${iTestDataUpdate_Count}
    \    Set SAPWUL Data to Excel    SAPWUL_Payload    @{OtherFacilityUpdates_Key_List}[${iTestData_Num}]    ${sSapwulDataSetRowId}    @{OtherFacilityUpdates_Value_List}[${iTestData_Num}]             
    
Set SAPWUL Cell List
    [Documentation]    This keyword sets the SAPWUL Object inside a cell.
    ...    @author: hstone    13SEP2019    Initial create
    [Arguments]    ${sExcelSheetName}    ${sColumnName}    ${sRowId}    ${sDataObjectList}    ${sDelimiter}=None   
    ${Delimiter}    Run Keyword If    '${sDelimiter}'=='None'    Set Variable    ${EXCELDATA_DELIMITER_LISTITEMS}
    ...    ELSE    Set Variable    ${sDelimiter}
    
    ${sDataList}    Create List
    ${iDataObject_Count}    Get Length    ${sDataObjectList}
    ${iDataObjectLastItem}    Evaluate    ${iDataObject_Count}-1
    :FOR    ${iDataObject_Num}    IN RANGE    ${iDataObject_Count}
    \    ${sDataObjectItem_List}    Get From List    ${sDataObjectList}    ${iDataObject_Num}    
    \    Log    (Set SAPWUL Cell List) sDataObjectItem_List = ${sDataObjectItem_List}
    \    ${iDataObjectItem_ListLength}    Get Length    ${sDataObjectItem_List}
    \    ${iLastItem_Num}    Evaluate    ${iDataObjectItem_ListLength}-1
    \    Run Keyword If    ${iDataObject_Count}>1 and ${iDataObject_Num}<${iDataObjectLastItem}    Set List Value    ${sDataObjectItem_List}    ${iLastItem_Num}    @{sDataObjectItem_List}[${iLastItem_Num}]${Delimiter}
    \    Log    (Set SAPWUL Cell List) sDataObjectItem_List - After Last Item Delimeter Concatenate = ${sDataObjectItem_List}
    \    ${sDataList}    Combine Lists    ${sDataList}    ${sDataObjectItem_List}      
    Log    (Set SAPWUL Cell List) sDataList = ${sDataList}   
    
    Set SAPWUL Cell Object    ${sExcelSheetName}    ${sColumnName}    ${sRowId}    ${sDataList}    sListDelimeter=${Delimiter} 
    
Set SAPWUL Cell Object
    [Documentation]    This keyword sets the SAPWUL Object inside a cell.
    ...    @author: hstone    13SEP2019    Initial create
    ...    @update: hstone    25SEP2019    Added List Delimeter Optional Argument
    [Arguments]    ${sExcelSheetName}    ${sColumnName}    ${sRowId}    ${sDataList}    ${sDelimiter}=None    ${sListDelimeter}=None   
    ${Delimiter}    Run Keyword If    '${sDelimiter}'=='None'    Set Variable    ${EXCELDATA_DELIMITER_DICTIONARY}
    ...    ELSE    Set Variable    ${sDelimiter}
    
    ${sNewExcelData}    Set Variable    ${EMPTY} 
    :FOR    ${data}    IN    @{sDataList}
    \    ${sNewExcelData}    Run Keyword If    '${sNewExcelData}'==''    Set Variable    ${data}
         ...    ELSE    Catenate    SEPARATOR=${Delimiter}    ${sNewExcelData}    ${data}
    
    ${sNewExcelData}    Run Keyword If    '${sListDelimeter}'!='None'    Replace String    ${sNewExcelData}    ${sListDelimeter}${Delimiter}    ${sListDelimeter}    
    Set SAPWUL Data to Excel    ${sExcelSheetName}    ${sColumnName}    ${sRowId}    ${sNewExcelData}    
    
Set SAPWUL Data to Excel
    [Documentation]    This keyword sets the sapwul data at the excel data sheet.
    ...    @author: hstone    13SEP2019    Initial create
    ...    @update: hstone    06NOV2019    Additional condition
    [Arguments]    ${sExcelSheetName}    ${sColumnName}    ${sRowId}    ${sDataToAppend}    ${sDelimiter}=None
    ### Delimeter Setting ###
    ${Delimiter}    Run Keyword If    '${sDelimiter}'=='None'    Set Variable    ${EXCELDATA_DELIMITER_PIPE}
    ...    ELSE    Set Variable    ${sDelimiter}
    
    ${sCurrentExcelCellContent}    Read Data From Excel    ${sExcelSheetName}    ${sColumnName}   ${sRowId}    ${SAPWUL_DATASET}
    Log    sCurrentExcelCellContent = ${sCurrentExcelCellContent}
    Run Keyword If    '${sCurrentExcelCellContent}'=='Empty' or '${sCurrentExcelCellContent}'=='empty' or '${sCurrentExcelCellContent}'=='null' or '${sCurrentExcelCellContent}'=='' or '${sCurrentExcelCellContent}'=='None'     
    ...    Write Data To Excel    ${sExcelSheetName}    ${sColumnName}    ${sRowId}    ${sDataToAppend}    ${SAPWUL_DATASET}
    ...    ELSE    Append SAPWUL Data to Excel Cell    ${sExcelSheetName}    ${sColumnName}    ${sRowId}    ${sCurrentExcelCellContent}    ${sDataToAppend}    ${Delimiter}
    
Append SAPWUL Data to Excel Cell
    [Documentation]    This keyword appends the data to non-empty excel cell.
    ...    @author: hstone    13SEP2019    Initial create
    [Arguments]    ${sExcelSheetName}    ${sColumnName}    ${sRowId}    ${sCurrentExcelCellContent}    ${sDataToAppend}    ${sCellDataDelimiter}
    ${sNewExcelData}    Catenate    SEPARATOR=${sCellDataDelimiter}    ${sCurrentExcelCellContent}    ${sDataToAppend}
    Write Data To Excel    ${sExcelSheetName}    ${sColumnName}    ${sRowId}    ${sNewExcelData}    ${SAPWUL_DATASET}
    
Clear SAPWUL Cell Data
    [Documentation]    This keyword clears the data on the supplied column names (var args) and row ID excel cell.
    ...    @author: hstone    13SEP2019    Initial create
    [Arguments]    ${sExcelSheetName}    ${sRowId}    @{sColumnNames}
    :FOR    ${ColumnName}    IN    @{sColumnNames}    
    \    Write Data To Excel    SAPWUL_Payload    ${ColumnName}    ${sRowId}    ${EMPTY}    ${SAPWUL_DATASET}

Clear Other Specified SAPWUL Cell Data
    [Documentation]    This keyword clears the data on the supplied column names(Specified on the Data Sheet) and row ID excel cell.
    ...    @author: hstone    01OCT2019    Initial create
    [Arguments]    ${sExcelSheetName}    ${sRowId}    ${OtherPayloadValClear}
    ${sColumnNames}    Extract List from a Delimited String    ${OtherPayloadValClear}
    :FOR    ${ColumnName}    IN    @{sColumnNames}    
    \    Write Data To Excel    SAPWUL_Payload    ${ColumnName}    ${sRowId}    ${EMPTY}    ${SAPWUL_DATASET}        

Create Customer External ID List
    [Documentation]    This keyword creates an External ID list.
    ...    @author: hstone    13SEP2019    Initial create
    ...    @update: hstone    10OCT2019    Customers Arranged by their Customer ID (Increasing Order)
    [Arguments]    @{sCustomerExternalIdItems}
    ${sCustomerExternalId_List}    Create List
    Append To List    ${sCustomerExternalId_List}    @{sCustomerExternalIdItems}[0]
    ${sCustomerExternalIdItems_Max}    Get Length    ${sCustomerExternalIdItems}
    :FOR    ${CustomerExternalId_Item_Num}    IN RANGE    1    ${sCustomerExternalIdItems_Max}
    \    Exit For Loop If    ${CustomerExternalId_Item_Num}==${sCustomerExternalIdItems_Max}
    \    ${sCustomerExternalId_List}    Insert to Customer External ID List    ${sCustomerExternalId_List}    @{sCustomerExternalIdItems}[${CustomerExternalId_Item_Num}]
    Log    (Create Customer External ID Item) sCustomerExternalId_List = ${sCustomerExternalId_List}
    [Return]    ${sCustomerExternalId_List}

Insert to Customer External ID List
    [Documentation]    This keyword inserts a customer to an External ID list.
    ...    @author: hstone    10OCT2019    Initial create
    [Arguments]    ${sCustomerExternalId_List}    ${sCustomerExternalId_Item}
    ${bStatus}    Set Variable    ${FALSE} 
    ${sCustomerExternalIdItems_Max}    Get Length    ${sCustomerExternalId_List}
    :FOR    ${CustomerExternalId_Item_Num}    IN RANGE    ${sCustomerExternalIdItems_Max}
    \    ${curentExternalIdItem}    Set Variable    @{sCustomerExternalId_List}[${CustomerExternalId_Item_Num}] 
    \    ${iCurrent}    Convert To Integer    @{sCustomerExternalId_Item}[${SAPWUL_CUSTOMEREXTERNALID_CUSTID}]   
    \    ${iToBeInserted}    Convert To Integer    @{curentExternalIdItem}[${SAPWUL_CUSTOMEREXTERNALID_CUSTID}]         
    \    Run Keyword If    @{sCustomerExternalId_Item}[${SAPWUL_CUSTOMEREXTERNALID_CUSTID}]<@{curentExternalIdItem}[${SAPWUL_CUSTOMEREXTERNALID_CUSTID}]    Run Keywords    
         ...    Insert Into List    ${sCustomerExternalId_List}    ${CustomerExternalId_Item_Num}    ${sCustomerExternalId_Item}
         ...    AND    Set Test Variable    ${bStatus}    ${TRUE}   
         ...    AND    Exit For Loop 
    
    Run Keyword If    ${bStatus}==${FALSE}    Append To List    ${sCustomerExternalId_List}    ${sCustomerExternalId_Item}
    
    [Return]    ${sCustomerExternalId_List}
    
Verify Timestamp Format
    [Documentation]    This keyword verifies the timestamp format.
    ...    @author: hstone    26SEP2019    Initial create
    [Arguments]    ${sActualTime}    ${sExpectedTimeFormat}
    ${sActualTime_List}    Convert To List    ${sActualTime}
    ${sExpectedTimeFormat_List}    Convert To List    ${sExpectedTimeFormat}
    Log    (Verify Timestamp Format) sActualTime_List = ${sActualTime_List}   
    Log    (Verify Timestamp Format) sExpectedTimeFormat_List = ${sExpectedTimeFormat_List}
    
    ${iActualTime_Length}    Get Length    ${sActualTime_List}
    ${sExpectedTimeFormat_Length}    Get Length    ${sExpectedTimeFormat_List}    
    
    ${bTimeStrLen_status}    Run Keyword and Return Status    Should Be Equal As Integers    ${iActualTime_Length}    ${sExpectedTimeFormat_Length}
    Run Keyword If    ${bTimeStrLen_status}==${True}    Log    Actual Time String Lengh Check Passed.
    ...    ELSE    Fail    Actual Timestamp Length did not match expected time format. Actual Timestamp : "${sActualTime}" ; Expected Time Format : "${sExpectedTimeFormat}".
    
    :FOR    ${str_index}    IN RANGE    ${iActualTime_Length}
    \    ${sExpectedCharacter}    Set Variable    @{sExpectedTimeFormat_List}[${str_index}]
    \    ${sActualCharacter}    Set Variable    @{sActualTime_List}[${str_index}]
    \    ${bStatus}    Run Keyword If    '${sExpectedCharacter}'=='Y' or '${sExpectedCharacter}'=='y'    Verify if Digit is Within Accepted Range    ${sActualCharacter}
         ...    ELSE IF    '${sExpectedCharacter}'=='M' or '${sExpectedCharacter}'=='m'    Verify if Digit is Within Accepted Range    ${sActualCharacter}
         ...    ELSE IF    '${sExpectedCharacter}'=='D' or '${sExpectedCharacter}'=='d'    Verify if Digit is Within Accepted Range    ${sActualCharacter}   
         ...    ELSE IF    '${sExpectedCharacter}'=='H' or '${sExpectedCharacter}'=='h'    Verify if Digit is Within Accepted Range    ${sActualCharacter} 
         ...    ELSE IF    '${sExpectedCharacter}'=='S' or '${sExpectedCharacter}'=='s'    Verify if Digit is Within Accepted Range    ${sActualCharacter}     
         ...    ELSE    Run Keyword and Return Status    Should Be Equal As Strings    ${sActualCharacter}    ${sExpectedCharacter}
    \    Run Keyword If    ${bStatus}==${False}    Fail    Timestamp Format Verification Failed. Actual Timestamp : "${sActualTime}" ; Expected Time Format : "${sExpectedTimeFormat}".
    
    Log    Timestamp Format Verification Passed. Actual Timestamp : "${sActualTime}" ; Expected Time Format : "${sExpectedTimeFormat}".
   
Verify if Digit is Within Accepted Range 
    [Documentation]    This keyword verifies a number on string type is within 0 to 9 or a specified max digit number.
    ...    @author: hstone    26SEP2019    Initial create
    [Arguments]    ${sDigitUnderTest}    ${iMaxDigitNum}=None
    ${iMaxDigitNumAccepted}    Run Keyword If    '${iMaxDigitNum}'=='None'    Set Variable    9
    ...    ELSE    Set Variable    ${iMaxDigitNum}
    
    ${iDigitUnderTest}    Convert To Integer    ${sDigitUnderTest}  
    
    ${bStatus}    Run Keyword If    ${iDigitUnderTest}>=0 and ${iDigitUnderTest}<=${iMaxDigitNumAccepted}    Set Variable    ${True}
    ...    ELSE    Set Variable    ${False}
    [Return]    ${bStatus}  

Convert LIQ Date to Payload Date    
    [Documentation]    This keyword converts the LIQ Date (e.g. 09-Mar-2019) to a desired date format (e.g y-m-d = 2018-03-05).
    ...    @author: hstone    01OCT2019    Initial create
    [Arguments]    ${sLiqDate}    ${sDateFormat}
    ${DateParts_List}    Extract List from a Delimited String    ${sLiqDate}    - 
    
    ${sDay}    Set Variable    @{DateParts_List}[0]
    ${sMonth}    Set Variable    @{DateParts_List}[1]
    ${sYear}    Set Variable    @{DateParts_List}[2]
    ${sTimeResult}    Set Variable    ${EMPTY}
    
    ${sMonth}    Convert To Uppercase    ${sMonth}
    ${sMonth}    Run Keyword If    '${sMonth}'=='${DATE_3CHAR_JANUARY}'    Set Variable    01
    ...    ELSE IF    '${sMonth}'=='${DATE_3CHAR_FEBRUARY}'    Set Variable    02
    ...    ELSE IF    '${sMonth}'=='${DATE_3CHAR_MARCH}'    Set Variable    03
    ...    ELSE IF    '${sMonth}'=='${DATE_3CHAR_APRIL}'    Set Variable    04
    ...    ELSE IF    '${sMonth}'=='${DATE_3CHAR_MAY}'    Set Variable    05
    ...    ELSE IF    '${sMonth}'=='${DATE_3CHAR_JUNE}'    Set Variable    06
    ...    ELSE IF    '${sMonth}'=='${DATE_3CHAR_JULY}'    Set Variable    07
    ...    ELSE IF    '${sMonth}'=='${DATE_3CHAR_AUGUST}'    Set Variable    08
    ...    ELSE IF    '${sMonth}'=='${DATE_3CHAR_SEPTEMBER}'    Set Variable    09
    ...    ELSE IF    '${sMonth}'=='${DATE_3CHAR_OCTOBER}'    Set Variable    10
    ...    ELSE IF    '${sMonth}'=='${DATE_3CHAR_NOVEMBER}'    Set Variable    11
    ...    ELSE IF    '${sMonth}'=='${DATE_3CHAR_DECEMBER}'    Set Variable    12 
    ...    ELSE    Fail    (Convert LIQ Date to Payload Date) Date Conversion Failed. ${sLiqDate} contains an invalid month value.       
    
    ${sExpectedTimeFormat_List}    Convert To List    ${sDateFormat}
    ${sExpectedTimeFormat_List_Length}    Get Length    ${sExpectedTimeFormat_List}
    :FOR    ${str_index}    IN RANGE    ${sExpectedTimeFormat_List_Length}
    \    ${sTimeCharacter}    Set Variable    @{sExpectedTimeFormat_List}[${str_index}]
    \    ${sTimePartResult}    Run Keyword If    '${sTimeCharacter}'=='Y'    Replace String    @{sExpectedTimeFormat_List}[${str_index}]    Y    ${sYear}
         ...    ELSE IF    '${sTimeCharacter}'=='y'    Replace String    @{sExpectedTimeFormat_List}[${str_index}]    y    ${sYear}
         ...    ELSE IF    '${sTimeCharacter}'=='M'    Replace String    @{sExpectedTimeFormat_List}[${str_index}]    M    ${sMonth}        
         ...    ELSE IF    '${sTimeCharacter}'=='m'    Replace String    @{sExpectedTimeFormat_List}[${str_index}]    m    ${sMonth}
         ...    ELSE IF    '${sTimeCharacter}'=='D'    Replace String    @{sExpectedTimeFormat_List}[${str_index}]    D    ${sDay}
         ...    ELSE IF    '${sTimeCharacter}'=='d'    Replace String    @{sExpectedTimeFormat_List}[${str_index}]    d    ${sDay}
         ...    ELSE    Set Variable    @{sExpectedTimeFormat_List}[${str_index}]
    \    ${sTimeResult}    Catenate    SEPARATOR=    ${sTimeResult}    ${sTimePartResult}
    [Return]    ${sTimeResult} 

Verify if String Exists as Java Tree Header
    [Documentation]    This keyword checks if the input string exists at the supplied Java Tree Locator.
    ...    @author: hstone    08JAN2020    Initial create
    [Arguments]    ${sJavaTree_Locator}    ${sStringToFind}    
    ${bExistenceStatus}    Set Variable    ${FALSE}
    
    ${JavaTree_Table}    Mx LoanIQ Store Java Tree Items To Array    ${sJavaTree_Locator}    Table
    ${JavaTree_Table}    Split To Lines    ${JavaTree_Table}
    ${TableHeaders}    Replace String    @{JavaTree_Table}[0]    \r    ${Empty} 
    ${TableHeader_List}    Split String    ${TableHeaders}    \t   
    
    :FOR    ${sTableHeader}    IN    @{TableHeader_List}
    \    Exit For Loop If    ${bExistenceStatus}==${TRUE}
    \    ${sTableHeader}    Convert To Uppercase    ${sTableHeader}
    \    ${sStringToFind}    Convert To Uppercase    ${sStringToFind}
    \    ${bExistenceStatus}    Run Keyword And Return Status    Should Be Equal As Strings    ${sTableHeader}    ${sStringToFind}     

    [Return]    ${bExistenceStatus}