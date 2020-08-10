*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Keywords ***
Validate VLS_CROSS_CURRENCY Extract
    [Documentation]    This keyword is used to validate the CRC_AMT_EXCHG_RATE field in CSV vs LIQ Screen.  
    ...    @author: mgaling    20Sep2019    - initial create
    [Arguments]    ${Excelpath}        
    
      
    ${CSV_Content}    Read Csv File To List    &{Excelpath}[CSV_FilePath]    |
    Log List    ${CSV_Content}
    
    ${header}    Get From List    ${CSV_Content}    0
    ${CRC_CDE_FUND_DESK_Index}    Get Index From List    ${header}    CRC_CDE_FUND_DESK
    ${CRC_CDE_CURRENCY_Index}    Get Index From List    ${header}    CRC_CDE_CURRENCY
    ${CRC_AMT_EXCHG_RATE_Index}    Get Index From List    ${header}    CRC_AMT_EXCHG_RATE
    
    Validate CSV values in LIQ for VLS_CROSS_CURRENCY   ${CSV_Content}    ${CRC_CDE_FUND_DESK_Index}    ${CRC_CDE_CURRENCY_Index}    ${CRC_AMT_EXCHG_RATE_Index}
