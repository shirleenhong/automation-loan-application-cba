*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_NEG06_UPDATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to UPDATE if loginId mismatch.
    ...    @author: jloretiz    13JAN2020    - initial create

    ${rowid}    Set Variable    406
        
    Mx Execute Template With Multiple Data    UPDATE User with Mismatch LoginId    ${APIDataSet}    ${rowid}    Users_Fields