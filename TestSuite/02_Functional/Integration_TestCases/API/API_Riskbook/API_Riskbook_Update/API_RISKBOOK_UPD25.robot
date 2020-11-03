*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_UPD25
    [Documentation]    This test case is used to validate not accepting empty array payload using User Id - Response 400
    ...    @author: xmiranda    25OCT2019    - initial create

    ${rowid}    Set Variable    225
    Mx Execute Template With Multiple Data    Update Riskbook with an Empty Payload Using User Id and Verify Response Status 400    ${APIDataSet}    ${rowid}    Riskbook