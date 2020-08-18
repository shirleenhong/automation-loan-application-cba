*** Settings ***
Resource    ../../Configurations/LoanIQ_Import_File.robot
#Suite Setup    Launch LoanIQ Application    ${LoanIQPath}
#Suite Teardown    Close Application Via CMD   ${LoanIQ}
# Test Setup    Fail if Previous Test Case Failed


*** Variables ***
${rowid}    1


*** Test Cases ***   
Create Quick Party Onboarding for CBA UAT Deal 2 - PTY001    
    [Tags]    01 Create Party within Essence - PTY001
    Mx Execute Template With Multiple Data    Create Deal Borrower initial details in Quick Party Onboarding for BEPTYLTDATF    ${CBAUAT_ExcelPath}    1    PTY001_QuickPartyOnboarding
    Mx Execute Template With Multiple Data    Populate Quick Enterprise Party with Approval for BEPTYLTDATF    ${CBAUAT_ExcelPath}    1    PTY001_QuickPartyOnboarding    
    

    
