*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Validate VLS_RISK_PORT_EXP Extract
    [Documentation]    This keyword is used to validate RPE_CDE_EXPENSE, RPE_CDE_PORTFOLIO and RPE_CDE_RISK_BOOK
    ...    @author: ehugo    28AUG2019    - initial create
    [Arguments]    ${ExcelPath}        
    
    ###Evidence: 1. RPE_CDE_EXPENSE - DB validation###
    Create Query for VLS_RISK_PORT_EXP to validate RPE_CDE_EXPENSE
    
    ###Evidence: 1. RPE_CDE_PORTFOLIO - DB validation###
    Create Query for VLS_RISK_PORT_EXP to validate RPE_CDE_PORTFOLIO
    
    ###Evidence 3. RPE_CDE_RISK_BOOK - LIQ validation###
    Validate RPE_CDE_RISK_BOOK records exist in LIQ for VLS_RISK_PORT_EXP    ${ExcelPath}
