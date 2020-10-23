*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***
API_SSO_NEG05_CREATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to CREATE if email format mismatch.
    ...    @author: jloretiz    13JAN2020    - initial create
    
    ${rowid}    Set Variable    4501
    Mx Execute Template With Multiple Data    CREATE User with Invalid Email Format    ${APIDataSet}    ${rowid}    Users_Fields
    
API_SSO_NEG05_UPDATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to UPDATE if email format mismatch.
    ...    @author: jloretiz    13JAN2020    - initial create
    
    ${rowid}    Set Variable    4502  
    
    Mx Execute Template With Multiple Data    UPDATE User with Invalid Email Format    ${APIDataSet}    ${rowid}    Users_Fields