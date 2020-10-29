*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Validate VLS_DEAL Extract
    [Documentation]    This keyword is used to validate values from VLS_DEAL CSV in LIQ Screen
    ...    @author: mgaling    10Sep2019    - initial create
    ...    update: mgaling    09Oct2020    - updated data set variable
    [Arguments]    ${ExcelPath}        
    
    ${CSV_Content}    Read Csv File To List    &{ExcelPath}[CSV_FilePath]&{ExcelPath}[Business_Date]\\&{ExcelPath}[DEAL_CSV_FileName]&{ExcelPath}[Business_Date].csv    |
    Log List    ${CSV_Content}
                        
    ${header}    Get From List    ${CSV_Content}    0
    
    ${DEA_PID_DEAL_Index}    Get Index From List    ${header}    DEA_PID_DEAL
    ${DEA_DTE_APPROVED_Index}    Get Index From List    ${header}    DEA_DTE_APPROVED
    ${DEA_DTE_TERM_EFF_Index}    Get Index From List    ${header}    DEA_DTE_TERM_EFF 
    ${DEA_DTE_CANCEL_EFF_Index}    Get Index From List    ${header}    DEA_DTE_CANCEL_EFF
    ${DEA_CDE_ORIG_CCY_Index}    Get Index From List    ${header}    DEA_CDE_ORIG_CCY
    ${DEA_IND_ACTIVE_Index}    Get Index From List    ${header}    DEA_IND_ACTIVE
    ${DEA_IND_SOLE_LENDR_Index}    Get Index From List    ${header}    DEA_IND_SOLE_LENDR
    ${DEA_CDE_EXPENSE_Index}    Get Index From List    ${header}    DEA_CDE_EXPENSE
    ${DEA_DTE_DEAL_CLSD_Index}    Get Index From List    ${header}    DEA_DTE_DEAL_CLSD
    ${DEA_DTE_AGREEMENT_Index}    Get Index From List    ${header}    DEA_DTE_AGREEMENT
    ${DEA_CDE_DEAL_STAT_Index}    Get Index From List    ${header}    DEA_CDE_DEAL_STAT
    ${DEA_CDE_DEAL_CLASS_Index}    Get Index From List    ${header}    DEA_CDE_DEAL_CLASS
    ${DEA_CDE_BRANCH_Index}    Get Index From List    ${header}    DEA_CDE_BRANCH

    Validate CSV values in LIQ for VLS_Deal    ${CSV_Content}    ${DEA_PID_DEAL_Index}    ${DEA_DTE_APPROVED_Index}    ${DEA_DTE_TERM_EFF_Index}    ${DEA_DTE_CANCEL_EFF_Index}    ${DEA_CDE_ORIG_CCY_Index}
    ...    ${DEA_IND_ACTIVE_Index}    ${DEA_IND_SOLE_LENDR_Index}    ${DEA_CDE_EXPENSE_Index}    ${DEA_DTE_DEAL_CLSD_Index}    ${DEA_DTE_AGREEMENT_Index}
    ...    ${DEA_CDE_DEAL_STAT_Index}    ${DEA_CDE_DEAL_CLASS_Index}    ${DEA_CDE_BRANCH_Index}