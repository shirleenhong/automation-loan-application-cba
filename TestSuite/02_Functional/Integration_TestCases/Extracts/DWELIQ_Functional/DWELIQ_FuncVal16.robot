*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot


*** Test Cases ***
DWELIQ_FuncVal15_Zone2
    [Tags]    Zone2_VLS_OST_RATES
	[Documentation]    This keyword is used to validate ORT_RID_OUTSTANDNG, ORT_PCT_BASE_RATE, ORT_PCT_SPREAD, ORT_CDE_RATE_BASIS and ORT_PCT_BALI_RATE for VLS_OST_RATES.
    ...    @author: ehugo    09SEP2019
    
    Set Test Variable    ${rowid}    1    
    Mx Execute Template With Multiple Data    Validate VLS_OST_RATES Extract    ${DWELIQFunc_Dataset}    ${rowid}    FuncVal15

DWELIQ_FuncVal15_Zone3
    [Tags]    Zone3_VLS_OST_RATES
	[Documentation]    This keyword is used to validate ORT_RID_OUTSTANDNG, ORT_PCT_BASE_RATE, ORT_PCT_SPREAD, ORT_CDE_RATE_BASIS and ORT_PCT_BALI_RATE for VLS_OST_RATES.
    ...    @author: ehugo    09SEP2019
    
    Set Test Variable    ${rowid}    1    
    Mx Execute Template With Multiple Data    Validate VLS_OST_RATES Extract    ${DWELIQFunc_Dataset}    ${rowid}    FuncVal15