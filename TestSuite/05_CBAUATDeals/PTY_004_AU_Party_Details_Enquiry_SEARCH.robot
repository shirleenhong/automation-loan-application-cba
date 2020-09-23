*** Settings ***
Resource    ../../Configurations/LoanIQ_Import_File.robot
#Suite Setup    Launch LoanIQ Application    ${LoanIQPath}
#Suite Teardown    Close Application Via CMD   ${LoanIQ}
# Test Setup    Fail if Previous Test Case Failed


*** Variables ***
${rowid}    1


*** Test Cases ***   
Enquiry Party Details in Party Details Enquiry SEARCH  
    [Tags]    04 AU Party Details Enquiry - PTY004
    
    Mx Execute Template With Multiple Data    Enquiry Party Details in Party Details Enquiry Module    ${CBAUAT_ExcelPath}    2    PTY003_PartyDetailsEnquiry
