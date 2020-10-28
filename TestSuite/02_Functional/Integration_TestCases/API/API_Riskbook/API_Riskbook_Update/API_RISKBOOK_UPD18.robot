*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_UPD18
    [Documentation]    This test case is used to verify that user is unable to Update RiskBook for an Invalid Login Id - Response 404
    ...    @author: xmiranda    23OCT2019    - initial create

    ${rowid}    Set Variable    218
    Mx Execute Template With Multiple Data    Update Riskbook Using Login Id and Verify Response Status 404    ${APIDataSet}    ${rowid}    Riskbook