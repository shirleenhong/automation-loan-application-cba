*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_GET23
    [Documentation]    This test case is used to verify that user is unable to get RiskBook Collection for an Invalid Login Id - Response 404
    ...    @author: xmiranda    22OCT2019

    ${rowid}    Set Variable    23
    Mx Execute Template With Multiple Data    Get Riskbook Using Login Id and Verify Response Status     ${APIDataSet}    ${rowid}    Riskbook