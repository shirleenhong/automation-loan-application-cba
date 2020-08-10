*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Validate VLS_PROD_GUARANTEE Extract
    [Documentation]    EVG_DWH_Extract_24    This keyword is used to validate VLS_PROD_GUARANTEE Extract.
    ...    @author: dahijara    23SEP2019
    [Arguments]    ${ExcelPath}
    
    ### PRE-REQUISITES ###
    ${PROD_GUARANTEE_CSV_File}    Set Variable    ${dataset_path}&{ExcelPath}[CSV_FilePath]&{ExcelPath}[PROD_GUARANTEE_CSV_FileName].csv
    ${CSV_Content}    Read Csv File To List    ${PROD_GUARANTEE_CSV_File}    |
    ${Prod_Type_Header_Index}    Get the Column index of the Header    ${PROD_GUARANTEE_CSV_File}    PGU_CDE_PROD_TYPE
    ${Prod_Id_Header_Index}    Get the Column index of the Header    ${PROD_GUARANTEE_CSV_File}    PGU_PID_PRODUCT_ID
    ${Cust_Id_Header_Index}    Get the Column index of the Header    ${PROD_GUARANTEE_CSV_File}    PGU_CID_CUST_ID
    ${Guarantor_Exp_Dt_Header_Index}    Get the Column index of the Header    ${PROD_GUARANTEE_CSV_File}    PGU_DTE_POL_EXP
    
    ### Validation for VLS_PROD_GUARANTEE ###
    Run Keyword And Continue On Failure    Validate CSV values in Loan IQ for VLS_PROD_GUARANTEE    ${CSV_Content}    ${Prod_Type_Header_Index}    ${Prod_Id_Header_Index}    ${Cust_Id_Header_Index}    ${Guarantor_Exp_Dt_Header_Index}
        
