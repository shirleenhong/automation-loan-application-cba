*** Settings ***
Resource    ../../../../Configurations/Import_File.robot

*** Keywords ***
GET User API with Invalid LoginID
    [Documentation]    This keyword is used to create prerequisites for execution for GET API.
    ...    And send a GET request for a single user with invalid LoginID.
    ...    Then validates response error 400.
    ...    @author: jloretiz    13JAN2020    - initial create
    ...    @update: jloretiz    17JAN2020    - renamed the keyword to make it generic
    [Arguments]    ${APIDataSet}
    
    ${ErrorList}    Create List     ${404_LOGIN_INVALID}

    ###OPEN API###
    Run Keyword And Continue On Failure    GET Request for User API Without Success Validation    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]
    ...    &{APIDataSet}[loginId]    &{APIDataSet}[lineOfBusiness]

    ###VALIDATION###
    Run Keyword And Continue On Failure    Validate Technical Errors on API User Response     ${RESPONSECODE_404}     ${ErrorList}