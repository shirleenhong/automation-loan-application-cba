*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot


*** Test Cases ***   
PTY004_PartyDetailsEnquirySearch  
    [Documentation]    This test case is used to perform Search and Validation in Party Details Enquiry Page
    ...    @author:gagregado    21SEP2020    -initial create
    
    Set Global Variable    ${TestCase_Name}    PTY004_PartyDetailsEnquirySearch
    Mx Execute Template With Specific Test Case Name    Enquiry Party Details in Party Details Enquiry Module    ${PTY_DATASET}    Test_Case    ${TestCase_Name}    QuickPartyOnboarding
