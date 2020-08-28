*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Validate VLS_OST_RATES Extract
    [Documentation]    This keyword is used to validate ORT_RID_OUTSTANDNG, ORT_PCT_BASE_RATE, ORT_PCT_SPREAD, ORT_CDE_RATE_BASIS and ORT_PCT_BALI_RATE for VLS_OST_RATES.
    ...    @author: ehugo    09SEP2019    - initial create
    [Arguments]    ${ExcelPath}        
    
    ${OST_RATES_CSV_File}    Set Variable    ${dataset_path}&{ExcelPath}[CSV_FilePath]&{ExcelPath}[OST_RATES_CSV_FileName].csv
    
    ###Validate ORT_RID_OUTSTANDNG in OST_RATES Table vs OST_PID_DEAL in Outstanding Table###
    Validate Records Exist Between 2 CSV Files    OST_RID_OUTSTANDNG    Outstanding    ${dataset_path}&{ExcelPath}[CSV_FilePath]&{ExcelPath}[OUTSTANDING_CSV_FileName].csv    
    ...    ORT_RID_OUTSTANDNG    OST_RATES    ${OST_RATES_CSV_File}    
    
    ###Get unique values for ORT_RID_OUTSTANDNG. Then get the values for the following column: ORT_PCT_BASE_RATE, ORT_PCT_SPREAD, ORT_CDE_RATE_BASIS, ORT_PCT_BALI_RATE.###
    ${Outstanding_List}    ${Base_Rate_Dictionary}    ${Spread_Dictionary}    ${Rate_Basis_Dictionary}    ${AllIn_Rate_Dictionary}    Get Column Records for VLS_OST_RATES    ${OST_RATES_CSV_File}
    
    ###Validate ORT_PCT_BASE_RATE, ORT_PCT_SPREAD, ORT_CDE_RATE_BASIS, ORT_PCT_BALI_RATE in LIQ###
    Validate ORT_PCT_BASE_RATE, ORT_PCT_SPREAD, ORT_CDE_RATE_BASIS, ORT_PCT_BALI_RATE in LIQ for VLS_OST_RATES    ${Outstanding_List}    ${Base_Rate_Dictionary}    ${Spread_Dictionary}    ${Rate_Basis_Dictionary}    ${AllIn_Rate_Dictionary}
