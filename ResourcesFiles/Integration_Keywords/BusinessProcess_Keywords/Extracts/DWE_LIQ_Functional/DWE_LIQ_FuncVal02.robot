*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Validate VLS_CUSTOMER Extract
    [Documentation]    This keyword is used to validate CUS_XID_CUST_ID and CUS_CID_CUST_ID
    ...    @author: ehugo    28AUG2019    - initial create
    ...    @update: mgaling    13OCT20    - updated extract path
    [Arguments]    ${ExcelPath}        
    
    ###Validate CUS_CID_CUST_ID and CUS_XID_CUST_ID in LIQ###
    Validate CUS_CID_CUST_ID and CUS_XID_CUST_ID in LIQ for VLS_Customer    &{ExcelPath}[CSV_FilePath]&{ExcelPath}[Business_Date]\\&{ExcelPath}[Customer_CSV_FileName]&{ExcelPath}[Business_Date].csv
    
    ###Validate OST_CID_BORROWER in Outstanding Table vs CUS_CID_CUST_ID in Customer Table###
    Validate Records Exist Between 2 CSV Files    CUS_CID_CUST_ID    Customer    &{ExcelPath}[CSV_FilePath]&{ExcelPath}[Business_Date]\\&{ExcelPath}[Customer_CSV_FileName]&{ExcelPath}[Business_Date].csv    
    ...    OST_CID_BORROWER    Outstanding    &{ExcelPath}[CSV_FilePath]&{ExcelPath}[Business_Date]\\&{ExcelPath}[Outstanding_CSV_FileName]&{ExcelPath}[Business_Date].csv