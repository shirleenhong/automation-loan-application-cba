*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_UPD20
    [Documentation]    This test case is used to verify that user is unable to Update a Riskbook with invalid parameters using Login Id - Response 400
    ...    @author: xmiranda    24OCT2019    - initial create

    ${rowid}    Set Variable    220
    Mx Execute Template With Multiple Data    Update Riskbook Using Login Id and Verify Response Status 400 and Exception Message    ${APIDataSet}    ${rowid}    Riskbook