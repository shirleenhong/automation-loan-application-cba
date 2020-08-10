*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Validate VLS_DEAL_BORROWER Extract
    [Documentation]    EVG_DWH_Extract_26    This keyword is used to validate VLS_DEAL_BORROWER Extract.
    ...    @author: dahijara    24SEP2019
    [Arguments]    ${ExcelPath}
    
    ### PRE-REQUISITES ###
    ${DEAL_BORROWER_CSV_File}    Set Variable    ${dataset_path}&{ExcelPath}[CSV_FilePath]&{ExcelPath}[DEAL_BORROWER_CSV_FileName].csv
    ${CSV_Content}    Read Csv File To List    ${DEAL_BORROWER_CSV_File}    |
    ${Prod_Id_Header_Index}    Get the Column index of the Header    ${DEAL_BORROWER_CSV_File}    DBR_PID_DEAL
    ${Cust_Id_Header_Index}    Get the Column index of the Header    ${DEAL_BORROWER_CSV_File}    DBR_CID_CUST_ID
    ${BorrowerInd_Header_Index}    Get the Column index of the Header    ${DEAL_BORROWER_CSV_File}    DBR_IND_BORROWER
    ${DepositorInd_Header_Index}    Get the Column index of the Header    ${DEAL_BORROWER_CSV_File}    DBR_IND_DEPOSITOR
    
    ### DB Validation - VLS_DEAL_BORROWER vs VLS_CUSTOMER ###
    Run Keyword And Continue On Failure    Run Query for Referential Integrity Validation    &{ExcelPath}[SQLQuery_DEAL_BORROWERVsCUSTOMER]    VLS_DEAL_BORROWER    VLS_CUSTOMER
    
    ### DB Validation - VLS_DEAL_BORROWER vs VLS_DEAL ###
    Run Keyword And Continue On Failure    Run Query for Referential Integrity Validation    &{ExcelPath}[SQLQuery_DEAL_BORROWERVsDEAL]    VLS_DEAL_BORROWER    VLS_DEAL
    
    ### Validation for VLS_PROD_GUARANTEE ###
    Run Keyword And Continue On Failure    Validate CSV values in Loan IQ for VLS_DEAL_BORROWER    ${CSV_Content}    ${Prod_Id_Header_Index}
    ...    ${Cust_Id_Header_Index}    ${BorrowerInd_Header_Index}    ${DepositorInd_Header_Index}     
