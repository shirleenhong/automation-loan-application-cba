*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot
    
*** Keywords ***
Get Single User with Invalid DataSource Value
    [Documentation]    This keyword is used to create prerequisites for execution for GET API.
    ...    
    [Arguments]    ${APIDataSet}
    
    Run Keyword and Continue On Failure    GET Request for User API Single Lob and Validate Response Code 400    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[loginId]    &{APIDataSet}[lineOfBusiness]    INVALID