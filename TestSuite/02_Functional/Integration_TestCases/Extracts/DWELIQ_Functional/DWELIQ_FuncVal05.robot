*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***
DWELIQ_FuncVal05_Zone2
    [Tags]    Zone2_VLS_FACILITY_TYPE
    [Documentation]    This keyword is used to validate the FAC_CDE_FAC_TYPE  field in CSV vs LIQ Screen  
    ...    @author: mgaling    02Sep2019    - Initial create
        
    Set Global Variable    ${rowid}    1          
    Mx Execute Template With Multiple Data    Validate VLS_FACILITY_TYPE Extract     ${DWELIQFunc_Dataset}    ${rowid}    FuncVal05

DWELIQ_FuncVal05_Zone3
    [Tags]    Zone3_VLS_FACILITY_TYPE
    [Documentation]    This keyword is used to validate the FAC_CDE_FAC_TYPE  field in CSV vs LIQ Screen  
    ...    @author: mgaling    02Sep2019    - Initial create
        
    Set Global Variable    ${rowid}    2          
    Mx Execute Template With Multiple Data    Validate VLS_FACILITY_TYPE Extract     ${DWELIQFunc_Dataset}    ${rowid}    FuncVal05   
