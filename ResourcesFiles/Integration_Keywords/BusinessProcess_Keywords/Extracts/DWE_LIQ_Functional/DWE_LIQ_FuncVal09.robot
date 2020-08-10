*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Keywords ***
Validate VLS_PROD_POS_CUR Extract
    [Documentation]    This keyword is used to validate the fields in VLS_PROD_POS_CUR CSV vs LIQ Screen.  
    ...    @author: mgaling    23SEP2019    - Initial create
    [Arguments]    ${Excelpath}        
       
    ### Read and Get the Index of the Fields from CSV File ###
    ${CSV_Content}    Read Csv File To List    ${dataset_path}&{Excelpath}[CSV_FilePath]&{ExcelPath}[PROD_POS_CUR_CSV_FileName].csv    |
    Log List    ${CSV_Content}
    
    ${header}    Get From List    ${CSV_Content}    0
    
    ${PDC_PID_PRODUCT_ID_Index}    Get Index From List    ${header}    PDC_PID_PRODUCT_ID
    ${PDC_CDE_PROD_TYPE_Index}    Get Index From List    ${header}    PDC_CDE_PROD_TYPE
    
    ${PDC_AMT_BNK_NT_CMT_Index}    Get Index From List    ${header}    PDC_AMT_BNK_NT_CMT
    ${PDC_AMT_BNK_GR_OUT_Index}    Get Index From List    ${header}    PDC_AMT_BNK_GR_OUT
    ${PDC_AMT_BNK_NT_OUT_Index}    Get Index From List    ${header}    PDC_AMT_BNK_NT_OUT
    ${PDC_AMT_GLOBAL_CMT_Index}    Get Index From List    ${header}    PDC_AMT_GLOBAL_CMT
    ${PDC_AMT_BNK_GR_CMT_Index}    Get Index From List    ${header}    PDC_AMT_BNK_GR_CMT
    
    ### Validation 01 ###
    Check Bank and Net Amounts from VLS_PROD_POS_CUR DB Table     &{Excelpath}[SQLQuery_BankNetAmt_Validation]   
    
    ###    Validation 02-07    ###
    Validate CSV values in LIQ for VLS_PROD_POS_CUR    ${CSV_Content}    ${PDC_PID_PRODUCT_ID_Index}    ${PDC_CDE_PROD_TYPE_Index}    ${PDC_AMT_BNK_NT_CMT_Index}    ${PDC_AMT_BNK_GR_OUT_Index}    
    ...    ${PDC_AMT_BNK_NT_OUT_Index}    ${PDC_AMT_GLOBAL_CMT_Index}    ${PDC_AMT_BNK_GR_CMT_Index}
    
    ### Validation 08 ###
    Run Query for Referential Integrity Validation    &{Excelpath}[SQLQuery_PROD_POS_CURVsDEAL]    VLS_PROD_POS_CUR    VLS_DEAL
