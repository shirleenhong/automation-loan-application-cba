*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_GET01
    
    [Documentation]    This test case is used to verify that user is able to get RiskBook Collection for a pre-existing User Id with RiskBook setup 
    ...    @author: xmiranda    29AUG2019    - initial create

    ${rowid}    Set Variable    1
    Mx Execute Template With Multiple Data    Get Riskbook API Response and Validate Response to LoanIQ    ${APIDataSet}    ${rowid}    Riskbook