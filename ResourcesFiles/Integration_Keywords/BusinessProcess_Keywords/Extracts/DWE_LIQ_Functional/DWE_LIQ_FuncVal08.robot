*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Variables ***
${rowid}    1

*** Keywords ***
Validate VLS_OUTSTANDING Extract
    [Documentation]    This keyword is used to validate the fields in VLS_OUTSTANDING CSV vs LIQ Screen  
    ...    @author: mgaling    19SEP2019    - initial create
    ...    @update: mgaling    26OCT2020    - added login and logout to LIQ keywords
    [Arguments]    ${Excelpath}        
    
    ${CSV_Content}    Read Csv File To List    &{ExcelPath}[CSV_FilePath]&{ExcelPath}[Business_Date]\\&{ExcelPath}[OUTSTANDING_CSV_FileName]&{ExcelPath}[Business_Date].csv    |
    Log List    ${CSV_Content}
    
    ${header}    Get From List    ${CSV_Content}    0
    
    ${OST_RID_OUTSTANDNG_Index}    Get Index From List    ${header}    OST_RID_OUTSTANDNG
    ${OST_DTE_EXPIRY_ENT_Index}    Get Index From List    ${header}    OST_DTE_EXPIRY_ENT    
    ${OST_DTE_REPRICING_Index}    Get Index From List    ${header}    OST_DTE_REPRICING    
    ${OST_CDE_REPR_FREQ_Index}    Get Index From List    ${header}    OST_CDE_REPR_FREQ    
    ${OST_IND_FLOAT_RATE_Index}    Get Index From List    ${header}    OST_IND_FLOAT_RATE    
    ${OST_DTE_EFFECTIVE_Index}    Get Index From List    ${header}    OST_DTE_EFFECTIVE    
    ${OST_CDE_ACR_PERIOD_Index}    Get Index From List    ${header}    OST_CDE_ACR_PERIOD        
    ${OST_CDE_PRICE_OPT_Index}    Get Index From List    ${header}    OST_CDE_PRICE_OPT    
    ${OST_DTE_EXPIRY_CLC_Index}    Get Index From List    ${header}    OST_DTE_EXPIRY_CLC    
    ${OST_CDE_CURRENCY_Index}    Get Index From List    ${header}    OST_CDE_CURRENCY    
    ${OST_AMT_BANK_NET_Index}    Get Index From List    ${header}    OST_AMT_BANK_NET    
    ${OST_CDE_RISK_TYPE_Index}    Get Index From List    ${header}    OST_CDE_RISK_TYPE        
    ${OST_NME_ALIAS_Index}    Get Index From List    ${header}    OST_NME_ALIAS
    ${OST_CID_BORROWER_Index}    Get Index From List    ${header}    OST_CID_BORROWER
    ${OST_CDE_OB_ST_CTG_Index}    Get Index From List    ${header}    OST_CDE_OB_ST_CTG 
    ${OST_CDE_OBJ_STATE_Index}    Get Index From List    ${header}    OST_CDE_OBJ_STATE
    ${OST_CDE_PERF_STAT_Index}    Get Index From List    ${header}    OST_CDE_PERF_STAT
    ${OST_AMT_FC_CURRENT_Index}    Get Index From List    ${header}    OST_AMT_FC_CURRENT
    ${OST_CDE_LOAN_PURP_Index}    Get Index From List    ${header}    OST_CDE_LOAN_PURP
    ${OST_RTE_FC_RATE_Index}    Get Index From List    ${header}    OST_RTE_FC_RATE
    
    Login to Loan IQ    ${Excelpath}[LIQ_Username]    ${Excelpath}[LIQ_Password]
    Validate CSV values in LIQ for VLS_Outstanding    ${CSV_Content}    ${OST_RID_OUTSTANDNG_Index}    ${OST_DTE_EXPIRY_ENT_Index}    ${OST_DTE_REPRICING_Index}    ${OST_CDE_REPR_FREQ_Index}    ${OST_IND_FLOAT_RATE_Index}
    ...    ${OST_DTE_EFFECTIVE_Index}    ${OST_CDE_ACR_PERIOD_Index}    ${OST_CDE_PRICE_OPT_Index}    ${OST_DTE_EXPIRY_CLC_Index}    ${OST_CDE_CURRENCY_Index}    ${OST_AMT_BANK_NET_Index}
    ...    ${OST_CDE_RISK_TYPE_Index}    ${OST_NME_ALIAS_Index}    ${OST_CID_BORROWER_Index}    ${OST_CDE_OB_ST_CTG_Index}    ${OST_CDE_OBJ_STATE_Index}    ${OST_CDE_PERF_STAT_Index}
    ...    ${OST_AMT_FC_CURRENT_Index}    ${OST_CDE_LOAN_PURP_Index}    ${OST_RTE_FC_RATE_Index}
    Logout From Loan IQ
