*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_GET22
    [Documentation]    This test case is used to verify that user is unable to get RiskBook Collection for an Invalid User Id - Response 404
    ...    @author: xmiranda    22OCT2019

    ${rowid}    Set Variable    22
    Mx Execute Template With Multiple Data    Get Riskbook Using User Id and Verify Response Status     ${APIDataSet}    ${rowid}    Riskbook