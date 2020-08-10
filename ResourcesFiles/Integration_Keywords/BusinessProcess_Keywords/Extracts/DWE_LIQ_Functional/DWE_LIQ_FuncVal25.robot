*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Validate VLS_FAC_BORR_DETL Extract
    [Documentation]    This keyword is used to validate VLS_FAC_BORR_DETL Extract.
    ...    @author: dahijara    25SEP2019    - Initial Create
    [Arguments]    ${ExcelPath}
    
    ### PRE-REQUISITES ###
    ${FAC_BORR_DETL_CSV_File}    Set Variable    ${dataset_path}&{ExcelPath}[CSV_FilePath]&{ExcelPath}[FAC_BORR_DETL_CSV_FileName].csv
    ${DEAL_BORROWER_CSV_File}    Set Variable    ${dataset_path}&{ExcelPath}[CSV_FilePath]&{ExcelPath}[DEAL_BORROWER_CSV_FileName].csv
    ${CSV_Content}    Read Csv File To List    ${FAC_BORR_DETL_CSV_File}    |
    ${Facility_Id_Header_Index}    Get the Column index of the Header    ${FAC_BORR_DETL_CSV_File}    FBD_PID_FACILITY
    ${Borrower_Details_RID_Header_Index}    Get the Column index of the Header    ${FAC_BORR_DETL_CSV_File}    FBD_RID_BORR_DETLS
    ${FBD_Active_Ind_Header_Index}    Get the Column index of the Header    ${FAC_BORR_DETL_CSV_File}    FBD_IND_ACTIVE
    ${FBD_RID_DEAL_BORR_Header_Index}    Get the Column index of the Header    ${FAC_BORR_DETL_CSV_File}    FBD_RID_DEAL_BORR
    
    ### DB Validation - VLS_FAC_BORR_DETL extracts should have all Facilitly Borrowers captured in Loan IQ for a Facility. ###
    Run Keyword And Continue On Failure    Run Query for Referential Integrity Validation    &{ExcelPath}[SQLQuery_FAC_BORR_DETLVsFACILITY]    VLS_FAC_BORR_DETL    VLS_FACILITY
    ### DB Validation - All records in VLS_FAC_BORR_DETL file will have a corresponding entry in VLS_DEAL_BORROWER where FBD_RID_DEAL_BORR =DBR_RID_DEAL_BORR ###
    Run Keyword And Continue On Failure    Run Query for Referential Integrity Validation    &{ExcelPath}[SQLQuery_FAC_BORR_DETLVsDEAL_BORROWER]    VLS_FAC_BORR_DETL    VLS_DEAL_BORROWER
    
    ### Validation for VLS_PROD_GUARANTEE ###
    Run Keyword And Continue On Failure    Validate CSV values in Loan IQ for VLS_FAC_BORR_DETL    ${CSV_Content}    ${Facility_Id_Header_Index}
    ...    ${Borrower_Details_RID_Header_Index}    ${FBD_Active_Ind_Header_Index}    ${FBD_RID_DEAL_BORR_Header_Index}    ${DEAL_BORROWER_CSV_File}
