*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_DEL12    
    [Documentation]    This test case is used to verify that User will get an error when deleting a RiskBook Code that the User does not have using Login ID - Response 400
    ...    @author: xmiranda    28OCT2019    - initial create

    ${rowid}    Set Variable    312
    Mx Execute Template With Multiple Data     Delete a Riskbook Code that the User does not have using LoginId and Verify Response Status 400    ${APIDataSet}    ${rowid}    Riskbook