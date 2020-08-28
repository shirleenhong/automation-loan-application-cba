*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Validate VLS_FAM_GLOBAL2 Extract
    [Documentation]    This keyword is used to validate GB2_TID_TABLE_ID for VLS_FAM_GLOBAL2.
    ...    @author: ehugo    06SEP2019    - initial create
    [Arguments]    ${ExcelPath}        
    
    ${CSV_Content}    Read Csv File To List    ${dataset_path}&{ExcelPath}[CSV_FilePath]&{ExcelPath}[FAM_Global2_CSV_FileName].csv    |
    
    ###Validate Distinct Values###
    ${Distinct_List}    Get Distinct Column Data    ${CSV_Content}    ${dataset_path}&{ExcelPath}[CSV_FilePath]&{ExcelPath}[FAM_Global2_CSV_FileName].csv    GB2_TID_TABLE_ID
    
    Validate GB2_TID_TABLE_ID in LIQ for VLS_FAM_GLOBAL2    ${Distinct_List}     
