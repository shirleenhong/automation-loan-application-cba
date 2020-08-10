*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Validate VLS_SCHEDULE Extract
    [Documentation]    This keyword is used to validate fields from CSV to LIQ Screen for VLS_SCHEDULE.
    ...    @author: mgaling    25SEP2019    Initial create
    [Arguments]    ${ExcelPath}         
    
    ${CSV_Content}    Read Csv File To List    ${dataset_path}&{Excelpath}[CSV_FilePath]&{ExcelPath}[SCHEDULE_CSV_FileName].csv    |
    Log List    ${CSV_Content}
    
    ###    Validation 01 - Referential Integrity Validation for SCH_RID_OWNER field   ###
    Run Query for Referential Integrity Validation    &{Excelpath}[SQLQuery_ScheduleVsOutstanding]    VLS_SCHEDULE    VLS_OUTSTANDING
    Run Query for Referential Integrity Validation    &{Excelpath}[SQLQuery_ScheduleVsFacility]    VLS_SCHEDULE    VLS_OUTSTANDING
    
    ###    Validation 03 - SCH_CDE_BAL_TYPE Field Validation    ###
    ${header}    Get From List    ${CSV_Content}    0
    ${RID_OWNER_Index}    Get Index From List    ${header}    SCH_RID_OWNER
    ${CDE_BAL_TYPE_Index}    Get Index From List    ${header}    SCH_CDE_BAL_TYPE
    ${AMT_RESIDUAL_Index}    Get Index From List    ${header}    SCH_AMT_RESIDUAL 
    
    Validate CSV values in LIQ for VLS_SCHEDULE    ${CSV_Content}    ${RID_OWNER_Index}    ${CDE_BAL_TYPE_Index}    ${AMT_RESIDUAL_Index}
