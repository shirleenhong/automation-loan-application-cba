*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_UPD19
    [Documentation]    This test case is used to verify that user is unable to Update a Riskbook with invalid parameters using User Id - Response 400
    ...    @author: xmiranda    24OCT2019    - initial create

    ${rowid}    Set Variable    219
    Mx Execute Template With Multiple Data    Update Riskbook Using User Id and Verify Response Status 400 and Exception Message    ${APIDataSet}    ${rowid}    Riskbook