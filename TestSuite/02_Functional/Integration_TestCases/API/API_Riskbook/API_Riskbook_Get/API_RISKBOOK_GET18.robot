*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_GET18
    [Documentation]    This test case is used to verify the RiskBook Collection for Valid Login Id after a RiskBook has been deleted via API
    ...    @author: xmiranda    11SEP2019    - initial create
    ...    @update: xmiranda    11SEP2018    - added PUT before deletion of Riskbook
    ...    @update: cfrancis    03JUL2020    - updated to use keyword for updating using Login Id

    ${rowid}    Set Variable    181
    Mx Execute Template With Multiple Data    Update an Risk Book Without LIQ Validation using Login Id     ${APIDataSet}    ${rowid}    Riskbook
    
    ${rowid}    Set Variable    18
    Mx Execute Template With Multiple Data    Verify the RiskBook Collection for Valid Login Id after a RiskBook has been Deleted via API     ${APIDataSet}    ${rowid}    Riskbook