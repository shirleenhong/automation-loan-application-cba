*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot

*** Test Cases ***
DWELIQ_FuncVal06_Zone2
    [Tags]    Zone2_VLS_GL_ENTRY
    [Documentation]    This keyword is used to validate the GLE_CDE_PROC_AREA and GLE_CDE_FEE_TYPE  fields in CSV vs LIQ Screen  
    ...    @author: mgaling    29AUG2019    - Initial create
        
    Set Global Variable    ${rowid}    1      
    Mx Execute Template With Multiple Data    Validate VLS_GL_ENTRY Extract     ${DWELIQFunc_Dataset}    ${rowid}    FuncVal06

DWELIQ_FuncVal06_Zone3
    [Tags]    Zone3_VLS_GL_ENTRY
    [Documentation]    This keyword is used to validate the GLE_CDE_PROC_AREA and GLE_CDE_FEE_TYPE  fields in CSV vs LIQ Screen  
    ...    @author: mgaling    29AUG2019    - Initial create
        
    Set Global Variable    ${rowid}    2      
    Mx Execute Template With Multiple Data    Validate VLS_GL_ENTRY Extract     ${DWELIQFunc_Dataset}    ${rowid}    FuncVal06