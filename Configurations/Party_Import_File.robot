*** Settings ***

###Party Variable Files###
Variables    ../ObjectMap/PTY_Locators/PTY_Global_Locators.py
Variables    ../ObjectMap/PTY_Locators/PTY_Party_Locators.py
Variables    ../ObjectMap/PTY_Locators/PTY_QuickPartyOnboarding_Locators.py
Variables    ../ObjectMap/PTY_Locators/PTY_MaintainPartyDetails_Locators.py
Variables    ../ObjectMap/PTY_Locators/PTY_PartyDetailsEnquiry_Locators.py
Resource    ../Variables/Party_Properties.txt

###Party Resource Files - Business Process Keywords###
Resource    ../ResourcesFiles/Party_Keywords/BusinessProcess_Keywords/PTY001_QuickPartyOnboarding.robot
Resource    ../ResourcesFiles/Party_Keywords/BusinessProcess_Keywords/PTY002_UpdatePartyDetails.robot
Resource    ../ResourcesFiles/Party_Keywords/BusinessProcess_Keywords/PTY003_QuickPartyOnboarding_Enquiry.robot
Resource    ../ResourcesFiles/Party_Keywords/BusinessProcess_Keywords/PTY004_QuickPartyOnboarding_Reject.robot

###Party Resource Files - Sourcel###
Resource    ../ResourcesFiles/Party_Keywords/Source_Keywords/PartyCommon_Keywords.robot
Resource    ../ResourcesFiles/Party_Keywords/Source_Keywords/Party_DeleteUser_Keywords.robot
Resource    ../ResourcesFiles/Party_Keywords/Source_Keywords/Party_DetailsEnquiry_Keywords.robot
Resource    ../ResourcesFiles/Party_Keywords/Source_Keywords/Party_EnquireUser_Keywords.robot
Resource    ../ResourcesFiles/Party_Keywords/Source_Keywords/Party_Generic_Keywords.robot
Resource    ../ResourcesFiles/Party_Keywords/Source_Keywords/Party_LoanIQVal_Keywords.robot
Resource    ../ResourcesFiles/Party_Keywords/Source_Keywords/Party_MaintainPartyDetails_Keywords.robot
Resource    ../ResourcesFiles/Party_Keywords/Source_Keywords/Party_QuickPartyOnboarding_Keywords.robot