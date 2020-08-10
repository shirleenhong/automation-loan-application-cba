*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Keywords ***
Validate VLS_CURRENCY Extract
    [Documentation]    This keyword is used to validate the CCY_DSC_CURRENCY and CCY_IND_ACTIVE fields in CSV vs LIQ Screen.  
    ...    @author: mgaling    20Sep2019    - initial create
    [Arguments]    ${Excelpath}        
    
      
    ${CSV_Content}    Read Csv File To List    ${dataset_path}&{ExcelPath}[CSV_FilePath]&{ExcelPath}[CURRENCY_CSV_FileName].csv    |  
    Log List    ${CSV_Content}
    
    ${header}    Get From List    ${CSV_Content}    0
    ${CCY_CDE_CURRENCY_Index}    Get Index From List    ${header}    CCY_CDE_CURRENCY
    ${CCY_DSC_CURRENCY_Index}    Get Index From List    ${header}    CCY_DSC_CURRENCY
    ${CCY_IND_ACTIVE_Index}    Get Index From List    ${header}    CCY_IND_ACTIVE
    
    Validate CSV values in LIQ for VLS_CURRENCY   ${CSV_Content}    ${CCY_CDE_CURRENCY_Index}    ${CCY_DSC_CURRENCY_Index}    ${CCY_IND_ACTIVE_Index}    
