*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_NEG02_CREATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to CREATE for field length mismatch.
    ...    When fields are less than the minimum length required error 400 should occur.
    ...    @author:    jloretiz    12DEC2019    - initial create

    ${rowid}    Set Variable    4201   
    Mx Execute Template With Multiple Data    CREATE User with Invalid Minimum Field Length - 400    ${APIDataSet}    ${rowid}    Users_Fields

API_SSO_NEG02_UPDATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to UPDATE for field length mismatch.
    ...    When fields are less than the minimum length required error 400 should occur.
    ...    @author:    jloretiz    12DEC2019    - initial create

    ${rowid}    Set Variable    4202   
    Mx Execute Template With Multiple Data    UPDATE User with Invalid Minimum Field Length - 400    ${APIDataSet}    ${rowid}    Users_Fields