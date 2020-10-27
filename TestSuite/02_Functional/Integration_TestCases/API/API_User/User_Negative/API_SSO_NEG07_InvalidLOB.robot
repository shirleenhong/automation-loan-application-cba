*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_NEG07_CREATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to CREATE if Lob is invalid.
    ...    @author: jloretiz    13JAN2020    - initial create
    
    ${rowid}    Set Variable    4701
    Mx Execute Template With Multiple Data    CREATE User API with Invalid LOB on Endpoint    ${APIDataSet}    ${rowid}    Users_Fields

API_SSO_NEG07_UPDATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to UPDATE if if Lob is invalid.
    ...    @author: jloretiz    13JAN2020    - initial create
    
    ${rowid}    Set Variable    4702    
    Mx Execute Template With Multiple Data    UPDATE User API with Invalid LOB on Endpoint    ${APIDataSet}    ${rowid}    Users_Fields