*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Validate VLS_SCHEDULE Extract
    [Documentation]    This keyword is used to validate fields from CSV to LIQ Screen for VLS_SCHEDULE.
    ...    @author: mgaling    25SEP2019    - initial create
    ...    @update: mgaling    22OCT2020    - updated csv path and added keywords for login and logout in LIQ
    [Arguments]    ${ExcelPath}         
  
    ###    Referential Integrity Validation for SCH_RID_OWNER field   ###
    Run Query for Referential Integrity Validation    &{Excelpath}[SQLQuery_ScheduleVsOutstanding]    VLS_SCHEDULE    VLS_OUTSTANDING
    Run Query for Referential Integrity Validation    &{Excelpath}[SQLQuery_ScheduleVsFacility]    VLS_SCHEDULE    VLS_OUTSTANDING
    
    ###    SCH_CDE_BAL_TYPE Field Validation    ###

    ${CSV_Content}    Read Csv File To List    &{ExcelPath}[CSV_FilePath]&{ExcelPath}[Business_Date]\\&{ExcelPath}[SCHEDULE_CSV_FileName]&{ExcelPath}[Business_Date].csv    |
    Log List    ${CSV_Content}
    
    ${header}    Get From List    ${CSV_Content}    0
    ${RID_OWNER_Index}    Get Index From List    ${header}    SCH_RID_OWNER
    ${CDE_BAL_TYPE_Index}    Get Index From List    ${header}    SCH_CDE_BAL_TYPE
    ${AMT_RESIDUAL_Index}    Get Index From List    ${header}    SCH_AMT_RESIDUAL 
    
    Login to Loan IQ    ${Excelpath}[LIQ_Username]    ${Excelpath}[LIQ_Password]
    Validate CSV values in LIQ for VLS_SCHEDULE    ${CSV_Content}    ${RID_OWNER_Index}    ${CDE_BAL_TYPE_Index}    ${AMT_RESIDUAL_Index}
    Logout From Loan IQ