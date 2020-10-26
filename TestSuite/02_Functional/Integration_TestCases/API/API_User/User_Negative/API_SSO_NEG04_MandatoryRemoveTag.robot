*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_NEG04_CREATE
    [Documentation]    This testcase is used to Verify that user is NOT allowed to CREATE if field is removed for Mandatory Fields
    ...    @author:    jloretiz    12DEC2019    - initial create
    
    ${rowid}    Set Variable    4401
    Mx Execute Template With Multiple Data    CREATE User with Mandatory Fields Removed on the Payload    ${APIDataSet}    ${rowid}    Users_Fields

API_SSO_NEG04_UPDATE
    [Documentation]    This testcase is used to Verify that user is NOT allowed to UPDATE if field is removed for Mandatory Fields
    ...    @author:    jloretiz    12DEC2019    - initial create
    
    ${rowid}    Set Variable    4402
    Mx Execute Template With Multiple Data    UPDATE User with Mandatory Fields Removed on the Payload    ${APIDataSet}    ${rowid}    Users_Fields