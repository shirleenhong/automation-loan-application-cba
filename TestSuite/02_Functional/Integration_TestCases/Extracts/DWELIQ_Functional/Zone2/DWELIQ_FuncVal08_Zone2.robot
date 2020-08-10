*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Test Cases ***
DWELIQ_FuncVal08_Zone2
    [Tags]    Zone2_VLS_OUTSTANDING
    [Documentation]    This keyword is used to validate the fields in VLS_OUTSTANDING CSV vs LIQ Screen 
    ...    @author: mgaling    26Sep2019    - Initial create
        
    Set Global Variable    ${rowid}    1      
    Mx Execute Template With Multiple Data    Validate VLS_OUTSTANDING Extract     ${DWELIQFunc_Dataset}    ${rowid}    FuncVal08
