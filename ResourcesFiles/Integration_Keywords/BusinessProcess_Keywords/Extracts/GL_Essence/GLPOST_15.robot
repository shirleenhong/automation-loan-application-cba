*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Execute GL Validation Tool
    [Documentation]    This keyword is used to open CMD and run GL Validation Tool and verify output file if all 'Matched'.
    ...    @author: clanding    11SEP2020    - initial create
    ...    @update: clanding    07OCT2020    - added argument for sZoneAndCode
    [Arguments]    ${ExcelPath}
    
    ${Generated_Output_File}    Run GL Validation Tool    &{ExcelPath}[Extract_Files_Path]    &{ExcelPath}[CSV_File]    &{ExcelPath}[ZoneAndCode]
    Validate Output File if Matched    ${Generated_Output_File}

Get CSV File from Decryption
    [Documentation]    This keyword is used to get CSV file name from dataset row for decyrption process and write in this test case row.
    ...    @author: clanding    11SEP2020    - initial create
    ...    @update: clandng    07OCT2020    - added for loop to handle multi entity
    [Arguments]    ${ExcelPath}
    
    Log    ${ExcelPath}
    Log    &{ExcelPath}[CSV_File]
    ${TestCase_Name_ValTool_List}    Split String    ${TestCase_Name_ValTool}    |
    Write Data to Excel    GL_Posting    CSV_File    @{TestCase_Name_ValTool_List}[${DATAROW_INDEX}]    &{ExcelPath}[CSV_File]    ${GLExcelPath}    bTestCaseColumn=True
