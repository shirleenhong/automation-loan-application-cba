*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Validate VLS_FUNDING_DESK Extract
    [Documentation]    This keyword is used to validate VLS_FUNDING_DESK Extract values in LIQ Screen.
    ...    @author: amansuet    20SEP2019    Initial create
    [Arguments]    ${ExcelPath}        
    
    ${CSV_Content}    Read Csv File To List    ${dataset_path}&{ExcelPath}[CSV_FilePath]&{ExcelPath}[VLS_FUNDING_DESK_FileName].csv    |
    Log List    ${CSV_Content}
    
    ${header}    Get From List    ${CSV_Content}    0
    ${FDE_IND_ACTIVE_Index}    Get Index From List    ${header}    FDE_IND_ACTIVE
    ${FDE_DSC_FUND_DESK_Index}    Get Index From List    ${header}    FDE_DSC_FUND_DESK
    ${FDE_CDE_FUND_DESK_Index}    Get Index From List    ${header}    FDE_CDE_FUND_DESK
    
    Validate CSV Values in LIQ for VLS_FUNDING_DESK    ${CSV_Content}    ${FDE_IND_ACTIVE_Index}    ${FDE_DSC_FUND_DESK_Index}    ${FDE_CDE_FUND_DESK_Index}
