*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Validate VLS_CUSTOMER Extract
    [Documentation]    This keyword is used to validate CUS_XID_CUST_ID and CUS_CID_CUST_ID
    ...    @author: ehugo    28AUG2019    - initial create
    [Arguments]    ${ExcelPath}        
    
    ###Validate CUS_CID_CUST_ID and CUS_XID_CUST_ID in LIQ###
    Validate CUS_CID_CUST_ID and CUS_XID_CUST_ID in LIQ for VLS_Customer    ${dataset_path}&{ExcelPath}[CSV_FilePath]&{ExcelPath}[Customer_CSV_FileName].csv
    
    ###Validate OST_CID_BORROWER in Outstanding Table vs CUS_CID_CUST_ID in Customer Table###
    Validate Records Exist Between 2 CSV Files    CUS_CID_CUST_ID    Customer    ${dataset_path}&{ExcelPath}[CSV_FilePath]&{ExcelPath}[Customer_CSV_FileName].csv    
    ...    OST_CID_BORROWER    Outstanding    ${dataset_path}&{ExcelPath}[CSV_FilePath]&{ExcelPath}[Outstanding_CSV_FileName].csv