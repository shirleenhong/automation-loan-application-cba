*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_UPD21
    [Documentation]    This test case is used to verify that default value is false incase the fields are missing in payload using User Id
    ...    @author: xmiranda    17SEP2019    - initial create

    ${rowid}    Set Variable    221
    Mx Execute Template With Multiple Data    Validate Default Value if False incase the Fields are Missing in Payload using User Id    ${APIDataSet}    ${rowid}    Riskbook