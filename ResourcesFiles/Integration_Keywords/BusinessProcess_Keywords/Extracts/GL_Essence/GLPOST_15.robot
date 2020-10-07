*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Execute GL Validation Tool
    [Documentation]    This keyword is used to open CMD and run GL Validation Tool and verify output file if all 'Matched'.
    ...    @author: clanding    11SEP2020    - initial create
    [Arguments]    ${ExcelPath}
    
    ${Generated_Output_File}    Run GL Validation Tool    &{ExcelPath}[Extract_Files_Path]    &{ExcelPath}[CSV_File]
    Validate Output File if Matched    ${Generated_Output_File}

Get CSV File from Decryption
    [Documentation]    This keyword is used to get CSV file name from dataset row for decyrption process and write in this test case row.
    ...    @author: clanding    11SEP2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Log    ${ExcelPath}
    Log    &{ExcelPath}[CSV_File]
    Write Data to Excel    GL_Posting    CSV_File    ${TestCase_Name_ValTool}    &{ExcelPath}[CSV_File]    ${GLExcelPath}    bTestCaseColumn=True
