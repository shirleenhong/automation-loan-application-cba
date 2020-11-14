*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_NEG01_CREATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to CREATE if field length mismatch.
    ...    When field is more than the maximum length an error 400 field length mismatch occurs.
    ...    @author:    jloretiz    13DEC2019    - initial create

    ${rowid}    Set Variable    4101
    Mx Execute Template With Multiple Data    CREATE User with Invalid Maximum Field Length - 400    ${APIDataSet}    ${rowid}    Users_Fields

API_SSO_NEG01_UPDATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to UPDATE if field length mismatch.
    ...    When field is more than the maximum length an error 400 field length mismatch occurs.
    ...    @author:    jloretiz    13DEC2019    - initial create

    ${rowid}    Set Variable    4102
    Mx Execute Template With Multiple Data    UPDATE User with Invalid Maximum Field Length - 400    ${APIDataSet}    ${rowid}    Users_Fields