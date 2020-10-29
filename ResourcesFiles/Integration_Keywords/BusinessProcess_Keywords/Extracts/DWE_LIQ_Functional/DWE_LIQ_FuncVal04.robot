*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Validate VLS_FACILITY Extract
    [Documentation]    This keyword is used to validate the following columns for VLS_FACILITY:
    ...    FAC_DTE_TERM_FAC, FAC_DTE_FL_DRAWDWN, FAC_DTE_EFFECTIVE, FAC_DTE_FINAL_MAT, FAC_DTE_EXPIRY, FAC_CDE_CURRENCY, FAC_IND_COMITTED, FAC_DTE_AGREEMENT, FAC_IND_MULTI_CURR,
	...    FAC_DTE_FL_DRAWDWN, fac_cde_fac_type, fac_cde_branch
    ...    @author: ehugo    16SEP2019    - initial create
    ...    @update: mgaling    27OCT2020    - updated csv path and added login and log out to LIQ keywords
    [Arguments]    ${ExcelPath}        
    
    ${Facility_CSV_File}    Set Variable     &{ExcelPath}[CSV_FilePath]&{ExcelPath}[Business_Date]\\&{ExcelPath}[Facility_CSV_FileName]&{ExcelPath}[Business_Date].csv
    
    ${FacilityID_List}    ${Termination_Date_Dictionary}    ${Multi_Currency_Dictionary}    ${FirstLoan_Drawdown_Dictionary}    ${Effective_Date_Dictionary}    ${Final_Maturity_Dictionary}    ${Expiry_Date_Dictionary}    ${Currency_Dictionary}    ${Committed_Dictionary}    ${Agreement_Date_Dictionary}    ${Facility_Type_Dictionary}    ${Branch_Dictionary}    Get Column Records for VLS_FACILITY    ${Facility_CSV_File}

    Login to Loan IQ    ${Excelpath}[LIQ_Username]    ${Excelpath}[LIQ_Password]        
    Validate Records for VLS_FACILITY    ${FacilityID_List}    ${Multi_Currency_Dictionary}    ${Effective_Date_Dictionary}    ${Final_Maturity_Dictionary}    ${Expiry_Date_Dictionary}    
    ...    ${Currency_Dictionary}    ${Agreement_Date_Dictionary}    ${Facility_Type_Dictionary}    ${Termination_Date_Dictionary}    ${FirstLoan_Drawdown_Dictionary}    ${Committed_Dictionary}    
    ...    ${Branch_Dictionary}
    Logout From Loan IQ