*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_GET12
    [Documentation]    This test case is used to verify that user is able to get RiskBook Collection for a pre-existing Login ID with RiskBook setup 
    ...    @author: xmiranda    09SEP2019    - initial create

    ${rowid}    Set Variable    12
    Mx Execute Template With Multiple Data    Get Riskbook API Response and Validate Response to LoanIQ Using Login ID   ${APIDataSet}    ${rowid}    Riskbook