*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Validate VLS_INT_PRC_OPTION Extract
    [Documentation]    This keyword is used to validate IPO_PID_DEAL for VLS_INT_PRC_OPTION.
    ...    @author: ehugo    09SEP2019    - initial create
    [Arguments]    ${ExcelPath}        
    
    ###Validate IPO_PID_DEAL in INT_PRC_OPTION Table vs OST_PID_DEAL in Outstanding Table### 
    Validate Records Exist Between 2 CSV Files    OST_PID_DEAL    Outstanding    ${dataset_path}&{ExcelPath}[CSV_FilePath]&{ExcelPath}[OUTSTANDING_CSV_FileName].csv    
    ...    IPO_PID_DEAL    INT_PRC_OPTION    ${dataset_path}&{ExcelPath}[CSV_FilePath]&{ExcelPath}[INT_PRC_OPTION_CSV_FileName].csv    
    
    ###Validate IPO_PID_DEAL in INT_PRC_OPTION Table vs DEA_PID_DEAL in Deal Table### 
    Validate Records Exist Between 2 CSV Files    DEA_PID_DEAL    Deal    ${dataset_path}&{ExcelPath}[CSV_FilePath]&{ExcelPath}[DEAL_CSV_FileName].csv    
    ...    IPO_PID_DEAL    INT_PRC_OPTION    ${dataset_path}&{ExcelPath}[CSV_FilePath]&{ExcelPath}[INT_PRC_OPTION_CSV_FileName].csv    
    
    ###Validate DEA_PID_DEAL in Deal Table vs IPO_PID_DEAL in INT_PRC_OPTION Table### 
    Validate Records Exist Between 2 CSV Files    IPO_PID_DEAL    INT_PRC_OPTION    ${dataset_path}&{ExcelPath}[CSV_FilePath]&{ExcelPath}[INT_PRC_OPTION_CSV_FileName].csv    
    ...    DEA_PID_DEAL    Deal    ${dataset_path}&{ExcelPath}[CSV_FilePath]&{ExcelPath}[DEAL_CSV_FileName].csv   
