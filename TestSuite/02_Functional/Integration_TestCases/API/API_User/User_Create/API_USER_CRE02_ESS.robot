*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_CRE02
    [Documentation]    This testcase is used to verify that user is able to create user for single LOB - Essence.
    ...    @author: clanding
    
    ${rowid}    Set Variable    2
    Mx Execute Template With Multiple Data    Create User for Essence    ${APIDataSet}    ${rowid}    Users_Fields