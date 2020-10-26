*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_DEL13    
    [Documentation]    This test case is used to verify that User will get an error when deleting a RiskBook Code that is invalid using Login ID - Response 400
    ...    @author: xmiranda    29OCT2019    - initial create

    ${rowid}    Set Variable    313
    Mx Execute Template With Multiple Data     Delete an Invalid Riskbook Code to a User using Login Id and Verify Response Status 400    ${APIDataSet}    ${rowid}    Riskbook