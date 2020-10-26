*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot
*** Test Cases ***

API_SSO_GET25
    [Documentation]    This test case is used to verify that user is able to do a GET All User by LoginID and LOB with different offset values.
    ...    @author: cfrancis    16SEP2019    - initial create
        
    ###LOANIQ###
    ${rowid}    Set Variable    5125
    Mx Execute Template With Multiple Data    GET Request for All User API per LOB with Different Offset    ${APIDataSet}    ${rowid}    Users_Fields
    
    ###ESSENCE###
    ${rowid}    Set Variable    5225
    Mx Execute Template With Multiple Data    GET Request for All User API per LOB with Different Offset    ${APIDataSet}    ${rowid}    Users_Fields
    
    ###PARTY###
    ${rowid}    Set Variable    5325
    Mx Execute Template With Multiple Data    GET Request for All User API per LOB with Different Offset    ${APIDataSet}    ${rowid}    Users_Fields