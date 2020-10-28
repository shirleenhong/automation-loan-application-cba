*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot
    
*** Keywords ***
Get All Users with Invalid Limit Value
    [Documentation]    This keyword is used to get All Users with invalid limit value - Response 404
    ...    @author: xmiranda    29OCT2019    - initial create   
    [Arguments]    ${APIDataSet}
    
    Run Keyword and Continue On Failure    GET Request for User API All Users and Validate Response Code 404    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[loginId]    &{APIDataSet}[lineOfBusiness]    sOffset=0    sLimit=INVALID