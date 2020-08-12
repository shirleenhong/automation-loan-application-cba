*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot

*** Test Cases ***
DWELIQ_FuncVal13_Zone2
    [Tags]    Zone2_VLS_FAC_PORT_POS
    [Documentation]    This keyword is used to validate the FPP_CDE_PORTFOLIO  field in CSV vs LIQ Screen  
    ...    @author: mgaling    03Sep2019    - initial create
        
    Set Global Variable    ${rowid}    1      
    Mx Execute Template With Multiple Data    Validate VLS_FAC_PORT_POS Extract     ${DWELIQFunc_Dataset}    ${rowid}    FuncVal13  

DWELIQ_FuncVal13_Zone3
    [Tags]    Zone3_VLS_FAC_PORT_POS
    [Documentation]    This keyword is used to validate the FPP_CDE_PORTFOLIO  field in CSV vs LIQ Screen  
    ...    @author: mgaling    03Sep2019    - initial create
        
    Set Global Variable    ${rowid}    1      
    Mx Execute Template With Multiple Data    Validate VLS_FAC_PORT_POS Extract     ${DWELIQFunc_Dataset}    ${rowid}    FuncVal13  