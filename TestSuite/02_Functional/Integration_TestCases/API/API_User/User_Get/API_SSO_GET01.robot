*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_GET01
    [Documentation]    This test case is used to verify that user is able to do a GET for existing Single User by LoginID and LOB.
    ...    @author: jloretiz    02SEP2019    - initial create

    ###PARTY###
    ${rowid}    Set Variable    5101
    Mx Execute Template With Multiple Data    Get User with Single LOB    ${APIDataSet}    ${rowid}    Users_Fields
    
    ###ESSENCE###
    ${rowid}    Set Variable    5201
    Mx Execute Template With Multiple Data    Get User with Single LOB    ${APIDataSet}    ${rowid}    Users_Fields
    
    ###LOANIQ###
    ${rowid}    Set Variable    5301
    Mx Execute Template With Multiple Data    Get User with Single LOB    ${APIDataSet}    ${rowid}    Users_Fields