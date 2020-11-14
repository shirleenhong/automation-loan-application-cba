*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Validate VLS_RISK_PORT_EXP Extract
    [Documentation]    This keyword is used to validate RPE_CDE_EXPENSE, RPE_CDE_PORTFOLIO and RPE_CDE_RISK_BOOK
    ...    @author: ehugo    28AUG2019    - initial create
    ...    @update: mgaling    23OCT2020    - added Branch Code variable and Read Csv File To List keyword
    [Arguments]    ${ExcelPath}        
    
    ###Evidence: 1. RPE_CDE_EXPENSE - DB validation###
    Create Query for VLS_RISK_PORT_EXP to validate RPE_CDE_EXPENSE    &{ExcelPath}[Branch_Code]
    
    ###Evidence: 1. RPE_CDE_PORTFOLIO - DB validation###
    Create Query for VLS_RISK_PORT_EXP to validate RPE_CDE_PORTFOLIO    &{ExcelPath}[Branch_Code]
    
    ###Evidence 3. RPE_CDE_RISK_BOOK - LIQ validation###
    ${CSV_Content}    Read Csv File To List    &{ExcelPath}[CSV_FilePath]&{ExcelPath}[Business_Date]\\&{ExcelPath}[RiskPortExp_CSV_FileName]&{ExcelPath}[Business_Date].csv    |
    Log List    ${CSV_Content}
    
    Login to Loan IQ    ${Excelpath}[LIQ_Username]    ${Excelpath}[LIQ_Password]
    Validate RPE_CDE_RISK_BOOK records exist in LIQ for VLS_RISK_PORT_EXP    ${CSV_Content}
    Logout From Loan IQ