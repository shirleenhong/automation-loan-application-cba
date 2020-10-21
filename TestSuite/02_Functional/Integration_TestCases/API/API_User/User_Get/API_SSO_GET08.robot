*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_GET08
    [Documentation]    This test case is used to verify that GET function will select at LOB when NO Datasource is specified (SINGLE User)
    ...    @author: amansuet    02SEP2019    - initial create

    ## PARTY LOB ###
    ${rowid}    Set Variable   5108
    Mx Execute Template With Multiple Data    Get User with Single LOB and No Datasource Specified    ${APIDataSet}    ${rowid}    Users_Fields

    ## ESSENCE LOB ###  
    ${rowid}    Set Variable   5208
    Mx Execute Template With Multiple Data    Get User with Single LOB and No Datasource Specified    ${APIDataSet}    ${rowid}    Users_Fields

    # LOAN IQ LOB ###
    ${rowid}    Set Variable   5308
    Mx Execute Template With Multiple Data    Get User with Single LOB and No Datasource Specified    ${APIDataSet}    ${rowid}    Users_Fields