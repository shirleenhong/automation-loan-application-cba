*** Settings ***
Library    ArchiveLibrary
Library    BaselineComparator
Library    Collections
Library    CSVLib    
Library    CSVLibrary    
Library    SeleniumLibraryExtended
Library    DatabaseLibrary
Library    DateTime
Library    EssenceLib
Library    ExcelLibrary
Library    GenericLib
Library    HttpLibraryExtended
Library    JSONLibraryKeywords
Library    Keyboard
Library    LoanIQ    exception_handling=No
Library    OperatingSystem
Library    Process
Library    RequestsLibrary
Library    Screenshot
Library    SSHLibrary
Library    String
Library    UFTGeneric    Visibility=True     UFTAddins=Java
Library    Dialogs
Library    XML
Library    base64
Library    PdfToText
Library    MathLibrary  

###Party Variable Files###
Variables    ../ObjectMap/PTY_Locators/PTY_CreateUser_Locators.py
Variables    ../ObjectMap/PTY_Locators/PTY_DeleteUser_Locators.py
Variables    ../ObjectMap/PTY_Locators/PTY_EnquireUser_Locators.py
Variables    ../ObjectMap/PTY_Locators/PTY_Global_Locators.py
Variables    ../ObjectMap/PTY_Locators/PTY_Party_Locators.py
Variables    ../ObjectMap/PTY_Locators/PTY_QuickPartyOnboarding_Locators.py
Variables    ../ObjectMap/PTY_Locators/PTY_MaintainPartyDetails_Locators.py
Variables    ../ObjectMap/PTY_Locators/PTY_PartyDetailsEnquiry_Locators.py
Resource    ../Variables/Party_Properties.txt

###Party Resource Files - Business Process Keywords###
Resource    ../ResourcesFiles/Party_Keywords/BusinessProcess_Keywords/PTY000_CreatePartyID.robot
Resource    ../ResourcesFiles/Party_Keywords/BusinessProcess_Keywords/PTY001_QuickPartyOnboarding.robot
Resource    ../ResourcesFiles/Party_Keywords/BusinessProcess_Keywords/PTY002_UpdatePartyDetails.robot
Resource    ../ResourcesFiles/Party_Keywords/BusinessProcess_Keywords/PTY004_PartyDetailsEnquiry.robot
Resource    ../ResourcesFiles/Party_Keywords/BusinessProcess_Keywords/PTY005_QuickPartyOnboarding_Reject.robot
Resource    ../ResourcesFiles/Party_Keywords/BusinessProcess_Keywords/PTY007_DuplicateEnterpriseName.robot
Resource    ../ResourcesFiles/Party_Keywords/BusinessProcess_Keywords/PTY008_DuplicateEnterpriseName_AcrossEntities.robot
Resource    ../ResourcesFiles/Party_Keywords/BusinessProcess_Keywords/PTY009_DuplicateShortName.robot
Resource    ../ResourcesFiles/Party_Keywords/BusinessProcess_Keywords/PTY010_DuplicateShortName_AcrossEntities.robot
Resource    ../ResourcesFiles/Party_Keywords/BusinessProcess_Keywords/PTY011_DuplicateShortNameEditSingle.robot
Resource    ../ResourcesFiles/Party_Keywords/BusinessProcess_Keywords/PTY014_QuickEnterpriseParty_Validation_Mandatory_Fields.robot
Resource    ../ResourcesFiles/Party_Keywords/BusinessProcess_Keywords/PTY015_QuickPartyOnboarding_Validation_Disabled_Fields.robot
Resource    ../ResourcesFiles/Party_Keywords/BusinessProcess_Keywords/PTY016_PartyOnboarding_Validation_Branch.robot
Resource    ../ResourcesFiles/Party_Keywords/BusinessProcess_Keywords/PTY017_QuickPartyOnboarding_FieldsValidationForSIC.robot  
Resource    ../ResourcesFiles/Party_Keywords/BusinessProcess_Keywords/PTY018_AU_Party_Navigation.robot

###Party Resource Files - Source###
Resource    ../ResourcesFiles/Party_Keywords/Source_Keywords/PartyCommon_Keywords.robot
Resource    ../ResourcesFiles/Party_Keywords/Source_Keywords/Party_Generic_Keywords.robot
Resource    ../ResourcesFiles/Party_Keywords/Source_Keywords/Party_QuickPartyOnboarding_Keywords.robot
Resource    ../ResourcesFiles/Party_Keywords/Source_Keywords/Party_LoanIQVal_Keywords.robot
Resource    ../ResourcesFiles/Party_Keywords/Source_Keywords/Party_EnquirePartyDetails_Keywords.robot
Resource    ../ResourcesFiles/Party_Keywords/Source_Keywords/Party_EnquireUser_Keywords.robot
Resource    ../ResourcesFiles/Party_Keywords/Source_Keywords/Party_DeleteUser_Keywords.robot

##Party Global Variables##
Resource    ../Variables/Party_Properties.txt

### Generic Resource Files - Utility ###
Resource    ../ResourcesFiles/Generic_Keywords/Utility_Keywords/GenericKeywords.robot

### LIQ Variable Files ###
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_Customer_Locators.py
