*** Settings ***
Resource    ../../../../Configurations/Import_File.robot
    
*** Keywords ***
Use Other Methods on Get API Endpoints
    [Documentation]    This keyword is used to get All Users with invalid limit value - Response 404
    ...    @author: xmiranda    06NOV2019    - initial create   
    [Arguments]    ${APIDataSet}
      
    Run Keyword and Continue On Failure    Request HTTP Method for User API for All User Endpoints And Validate Response Code    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[loginId]    &{APIDataSet}[lineOfBusiness]    &{APIDataSet}[HTTPMethodType]    LOB    sOffset=0    sLimit=50