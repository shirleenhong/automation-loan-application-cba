*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_DEL10
    [Documentation]    This test case is used to verify that User will get an error when deleting a RiskBook Code that the User does not have using User ID - Response 400
    ...    @author: xmiranda    28OCT2019    - initial create

    ${rowid}    Set Variable    310
    Mx Execute Template With Multiple Data     Delete a Riskbook Code that the User does not have using UserId and Verify Response Status 400    ${APIDataSet}    ${rowid}    Riskbook