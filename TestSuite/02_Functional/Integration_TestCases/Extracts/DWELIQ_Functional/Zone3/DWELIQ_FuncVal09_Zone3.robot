*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Test Cases ***
DWELIQ_FuncVal09_Zone3
    [Tags]    Zone3_VLS_PROD_POS_CUR
    [Documentation]    This keyword is used to validate the columns in CSV vs LIQ Screen 
    ...    @author: mgaling    23SEP2019    - Initial create
        
    Set Global Variable    ${rowid}    2      
    Mx Execute Template With Multiple Data    Validate VLS_PROD_POS_CUR Extract     ${DWELIQFunc_Dataset}    ${rowid}    FuncVal09  
