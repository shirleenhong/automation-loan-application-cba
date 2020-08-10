*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot


*** Test Cases ***
DWELIQ_FuncVal17_Zone2
    [Tags]    Zone2_VLS_OST_TRAN
	[Documentation]    This keyword is used to validate OTR_IND_ST_TR_UNSC, OTR_AMT_ACTUAL and OTR_CDE_TYPE for VLS_OST_TRAN.
    ...    @author: ehugo    09SEP2019
    
    Set Test Variable    ${rowid}    1    
    Mx Execute Template With Multiple Data    Validate VLS_OST_TRAN Extract    ${DWELIQFunc_Dataset}    ${rowid}    FuncVal17
