*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Validate VLS_CUSTOMER Extract
    [Documentation]    This keyword is used to validate CUS_XID_CUST_ID and CUS_CID_CUST_ID
    ...    @author: ehugo    28AUG2019    - initial create
    [Arguments]    ${DWELIQFunc_Dataset}        
    
    ###Validate CUS_CID_CUST_ID and CUS_XID_CUST_ID in LIQ###
    Validate CUS_CID_CUST_ID and CUS_XID_CUST_ID in LIQ for VLS_Customer    &{DWELIQFunc_Dataset}[CSV_FilePath]&{DWELIQFunc_Dataset}[Customer_CSV_FileName]${DWE_LIQ_BusinessDate}.csv
    
    ###Validate OST_CID_BORROWER in Outstanding Table vs CUS_CID_CUST_ID in Customer Table###
    Validate Records Exist Between 2 CSV Files    CUS_CID_CUST_ID    Customer    &{DWELIQFunc_Dataset}[CSV_FilePath]&{DWELIQFunc_Dataset}[Customer_CSV_FileName]${DWE_LIQ_BusinessDate}.csv    
    ...    OST_CID_BORROWER    Outstanding    &{DWELIQFunc_Dataset}[CSV_FilePath]&{DWELIQFunc_Dataset}[Outstanding_CSV_FileName]${DWE_LIQ_BusinessDate}.csv