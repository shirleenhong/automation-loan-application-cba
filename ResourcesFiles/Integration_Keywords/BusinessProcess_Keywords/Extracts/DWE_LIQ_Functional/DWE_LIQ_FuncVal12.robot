*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Validate VLS_ACCRUAL_CYCLE Extract
    [Documentation]    This keyword is used to validate values from VLS_ACCRUAL_CYCLE CSV in LIQ Screen
    ...    @author: mgaling    04Sep2019    - Initial create
    [Arguments]    ${ExcelPath}        
    
    ${CSV_Content}    Read Csv File To List    &{ExcelPath}[CSV_FilePath]    |
    Log List    ${CSV_Content}
                      
    ${GetRIDCodes_Result}    Run Query to get Records from DB    &{ExcelPath}[Query_GetRIDCodes] 
    
    ### 1. The expectation is that all Loans should have entries in this table. Thus, there should be no orphan records ###
    ${OrphanRecordsChecking_Result}    Run Query to get Records from DB    &{ExcelPath}[Query_OrphanRecordsChecking]
    Validate Loans in VLS_ACCRUAL_CYCLE Table    ${OrphanRecordsChecking_Result}
     
    
    ### 3. ACC_DTE_CYCLE_STRT , ACC_DTE_CYCLE_END, ACC_DTE_CYCLE_DUE: verify all the loans are having all accrual cycle in CSV Extract ### 
    Verify that the Column has no Empty Records    ${CSV_Content}    &{ExcelPath}[CSV_FilePath]    ACC_DTE_CYCLE_STRT
    Verify that the Column has no Empty Records    ${CSV_Content}    &{ExcelPath}[CSV_FilePath]    ACC_DTE_CYCLE_END
    Verify that the Column has no Empty Records    ${CSV_Content}    &{ExcelPath}[CSV_FilePath]    ACC_DTE_CYCLE_DUE
    
    ### 2, 4-6 Validation Points ###
    Validate Accrual Cycles from CSV and LIQ Screen    ${GetRIDCodes_Result}    &{ExcelPath}[CSV_FilePath]    ${CSV_Content}   
