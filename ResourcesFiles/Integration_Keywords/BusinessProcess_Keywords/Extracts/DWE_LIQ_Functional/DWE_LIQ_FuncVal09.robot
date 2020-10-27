*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Validate VLS_PROD_POS_CUR Extract
    [Documentation]    This keyword is used to validate the fields in VLS_PROD_POS_CUR CSV vs LIQ Screen.  
    ...    @author: mgaling    23SEP2019    - initial create
    ...    @update: mgaling    25OCT2020    - removed Get Index From List keywords and added login and log out to LIQ keywords
    [Arguments]    ${Excelpath}        
       
    ### Validation 01 ###
    Check Bank and Net Amounts from VLS_PROD_POS_CUR DB Table     &{Excelpath}[SQLQuery_BankNetAmt_Validation]   
    
    ###    Validation 02-07    ###
    ${CSV_Content}    Read Csv File To List    &{ExcelPath}[CSV_FilePath]&{ExcelPath}[Business_Date]\\&{ExcelPath}[PROD_POS_CUR_CSV_FileName]&{ExcelPath}[Business_Date].csv    |
    Log List    ${CSV_Content}
    
    Login to Loan IQ    ${Excelpath}[LIQ_Username]    ${Excelpath}[LIQ_Password]
    Validate CSV values in LIQ for VLS_PROD_POS_CUR     ${CSV_Content}
    Logout From Loan IQ
    
    ### Validation 08 ###
    Run Query for Referential Integrity Validation    &{Excelpath}[SQLQuery_PROD_POS_CURVsDEAL]    VLS_PROD_POS_CUR    VLS_DEAL
