*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Validate VLS_OST_TRAN Extract
    [Documentation]    This keyword is used to validate OTR_IND_ST_TR_UNSC, OTR_AMT_ACTUAL and OTR_CDE_TYPE for VLS_OST_TRAN.
    ...    @author: ehugo    11SEP2019    - initial create
    [Arguments]    ${sExcelPath}        
    
    ${OST_TRAN_CSV_File}    Set Variable    ${dataset_path}&{sExcelPath}[CSV_FilePath]&{sExcelPath}[OST_TRAN_CSV_FileName].csv
    
    ###Validate OTR_IND_ST_TR_UNSC###
    Validate OTR_IND_ST_TR_UNSC for VLS_OST_TRAN    ${OST_TRAN_CSV_File}
    
    ###Get the unique values for OTR_RID_OST_TRAN. Then get the values for the following column: OTR_RID_OST_TRAN, OTR_RID_LINK_TRN, OTR_CDE_TYPE, OTR_AMT_ACTUAL###
    ${Outstanding_Transaction_List}    ${Transaction_Type_Dictionary}    ${Actual_Amount_Dictionary}    ${Link_Transaction_List}    Get Column Records for VLS_OST_TRAN    ${OST_TRAN_CSV_File}
    
    ###Validate OTR_AMT_ACTUAL###
    Validate OTR_AMT_ACTUAL in LIQ for VLS_OST_TRAN    ${sExcelPath}    ${Outstanding_Transaction_List}    ${Transaction_Type_Dictionary}    ${Actual_Amount_Dictionary}    ${Link_Transaction_List}
    
    ###Validate OTR_CDE_TYPE###
    Validate OTR_CDE_TYPE records exist in LIQ for VLS_OST_TRAN    ${sExcelPath}
