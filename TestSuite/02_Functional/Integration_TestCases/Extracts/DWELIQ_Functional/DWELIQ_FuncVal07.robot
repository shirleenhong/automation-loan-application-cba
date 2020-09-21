*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***
DWELIQ_FuncVal07_Zone2
    [Tags]    Zone2_VLS_GL_SHORT_NAME    
    [Documentation]    This keyword is used to validate the SNM_CDE_GL_SHTNAME and SNM_CDE_NATURL_BAL  columns in CSV vs LIQ Screen 
    ...    @author: mgaling    23AUG2019    - Initial create
        
    Set Global Variable    ${rowid}    1      
    Mx Execute Template With Multiple Data    Validate VLS_GL_SHORT_NAME Extract     ${DWELIQFunc_Dataset}    ${rowid}    FuncVal07


DWELIQ_FuncVal07_Zone3
    [Tags]    Zone3_VLS_GL_SHORT_NAME    
    [Documentation]    This keyword is used to validate the SNM_CDE_GL_SHTNAME and SNM_CDE_NATURL_BAL  columns in CSV vs LIQ Screen 
    ...    @author: mgaling    23AUG2019    - Initial create
        
    Set Global Variable    ${rowid}    2      
    Mx Execute Template With Multiple Data    Validate VLS_GL_SHORT_NAME Extract     ${DWELIQFunc_Dataset}    ${rowid}    FuncVal07