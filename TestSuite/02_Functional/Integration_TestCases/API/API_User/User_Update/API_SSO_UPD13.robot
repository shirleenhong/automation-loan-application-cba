*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_UPD13
    [Documentation]    This testcase is used to verify that user is able to UPDATE a user details with the following sequence: 1.Send demographic update without LOB, 
    ...    2.Send LOB update with an already  updated Demographic,3. Send LOB and Demographic Update details.
    ...    @auhtor: dahijara    26AUG2019    - initial create.
        
    ${rowID}    Set Variable   3131
    Mx Execute Template With Multiple Data    Create User without LOB without FFC Validation    ${APIDataSet}    ${rowID}    Users_Fields
    
    ${rowID}    Set Variable   3132
    Mx Execute Template With Multiple Data    Create User with COMRLENDING LOB without FFC Validation    ${APIDataSet}    ${rowID}    Users_Fields    
    
    ${rowID}    Set Variable   313
    Mx Execute Template With Multiple Data    Update Existing LIQ User After Adding LIQ LOB to a User    ${APIDataSet}    ${rowID}    Users_Fields