*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_CRE03
    [Documentation]    This keyword is used to verify that user is able to CREATE a user for single LOB - Party.
    ...    @author: clanding
    
    ${rowid}    Set Variable    3
    Mx Execute Template With Multiple Data    Create User for Party    ${APIDataSet}    ${rowid}    Users_Fields