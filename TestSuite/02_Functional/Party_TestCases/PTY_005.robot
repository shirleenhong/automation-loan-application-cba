*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Test Cases ***   
PTY_005
    [Documentation]    This test case is used to perform Reject Party Details Enquiry Page
    ...    @author:gagregado    01OCT2020    -initial create
    
    Set Global Variable    ${TestCase_Name}    PTY005_PartyDetailsEnquiryReject
    Mx Execute Template With Specific Test Case Name    Create Party in Quick Party Onboarding and Reject Referral    ${PTY_DATASET}    Test_Case    ${TestCase_Name}    QuickPartyOnboarding