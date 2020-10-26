*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_GET09
    [Documentation]    This test case is used to verify that GET function will select at LOB when NO Datasource is specified (ALL User List)
    ...    @author: amansuet    02SEP2019    - initial create

    ## PARTY LOB ###
    ${rowid}    Set Variable   5109
    Mx Execute Template With Multiple Data    Get All Users on LOB with No Datasource Specified    ${APIDataSet}    ${rowid}    Users_Fields
    
    ### ESSENCE LOB ###
    ${rowid}    Set Variable   5209
    Mx Execute Template With Multiple Data    Get All Users on LOB with No Datasource Specified    ${APIDataSet}    ${rowid}    Users_Fields
    
    ### LOAN IQ LOB ###
    ${rowid}    Set Variable   5309
    Mx Execute Template With Multiple Data    Get All Users on LOB with No Datasource Specified    ${APIDataSet}    ${rowid}    Users_Fields