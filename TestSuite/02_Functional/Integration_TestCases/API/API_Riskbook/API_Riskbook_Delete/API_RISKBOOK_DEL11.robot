*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_DEL11
    [Documentation]    This test case is used to verify that User will get an error when deleting a RiskBook Code that is invalid using User ID - Response 400
    ...    @author: xmiranda    28OCT2019    - initial create

    ${rowid}    Set Variable    311
    Mx Execute Template With Multiple Data     Delete an Invalid Riskbook Code to a User using UserId and Verify Response Status 400    ${APIDataSet}    ${rowid}    Riskbook