*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_GET14
    [Documentation]    This test case is used to verify that user is able to get RiskBook Collection for a newly created RiskBook code using Login Id
    ...    @author: xmiranda    20SEP2019    - initial create
    
    ${rowid}    Set Variable    14
    Mx Execute Template With Multiple Data    Add New Risk Book and Validate Risk Book Collection using Login Id     ${APIDataSet}    ${rowid}    Riskbook