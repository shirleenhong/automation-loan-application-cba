*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_GET02
    [Documentation]    This test case is used to verify that GET function will GET a list for all existing users by LOB
    ...    @author: amansuet    02SEP2019    - initial create

    ## PARTY LOB ###
    ${rowid}    Set Variable   5102
    Mx Execute Template With Multiple Data    Get All Users on LOB with Datasource Specified    ${APIDataSet}    ${rowid}    Users_Fields
    
    ### ESSENCE LOB ###
    ${rowid}    Set Variable   5202
    Mx Execute Template With Multiple Data    Get All Users on LOB with Datasource Specified    ${APIDataSet}    ${rowid}    Users_Fields
    
    ### LOAN IQ LOB ###
    ${rowid}    Set Variable   5302
    Mx Execute Template With Multiple Data    Get All Users on LOB with Datasource Specified    ${APIDataSet}    ${rowid}    Users_Fields