*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_UPD16
    [Documentation]    This test case is used to verify that user is unable to Update RiskBook for an Invalid Risk Code using User Id - Response 400
    ...    @author: xmiranda    23OCT2019    - initial create

    ${rowid}    Set Variable    216
    Mx Execute Template With Multiple Data    Update Riskbook for an Invalid Riskbook Code Using Login Id and Verify Response Status    ${APIDataSet}    ${rowid}    Riskbook