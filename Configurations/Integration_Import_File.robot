*** Settings ***
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

### Global Variables ###
Resource    ../Variables/Global_Variables.txt
Resource    ../Variables/Calendar_Properties.txt
Resource    ../Variables/Queries.txt
Resource    ../Variables/Users_Properties.txt
Resource    ../Variables/BaseRatesInterest_Properties.txt
Resource    ../Variables/FXRates_Properties.txt
Resource    ../Variables/Correspondence_Properties.txt

### Configurations ###
Resource    ../Configurations/DB_Connection.txt
Variables    ../Configurations/GenericConfig.py
Variables    ../Configurations/Global_Variables.py

### LoanIQ Variable Files - Locators ###
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_Batch_Administration_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_FundingRates_Locator.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_Global_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_TableMaintenance_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_TreasuryNavigation_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_User_Administration_Locators.py

### FFC Variable Files - Locators ###
Variables    ../ObjectMap/FFC_Locators/Dashboard_Locators.py

### SSO Variable Files - Locators ###
Variables    ../ObjectMap/SSO_Locators/SSO_EnquireUser_Locators.py
Variables    ../ObjectMap/SSO_Locators/SSO_Global_Locators.py

### Generic Resource Files - Utility ###
Resource    ../ResourcesFiles/Generic_Keywords/Utility_Keywords/API_UtilityKeywords.robot
Resource    ../ResourcesFiles/Generic_Keywords/Utility_Keywords/BatchAdministration_Keywords.robot
Resource    ../ResourcesFiles/Generic_Keywords/Utility_Keywords/Database_Keywords.robot
Resource    ../ResourcesFiles/Generic_Keywords/Utility_Keywords/GenericKeywords.robot
Resource    ../ResourcesFiles/Generic_Keywords/Utility_Keywords/LoanIQ_Keywords.robot
Resource    ../ResourcesFiles/Generic_Keywords/Utility_Keywords/WinSCP_Keywords.robot
Resource    ../ResourcesFiles/Generic_Keywords/Utility_Keywords/MCH_Keywords.robot
Resource    ../ResourcesFiles/Generic_Keywords/Utility_Keywords/SSO_Keywords.robot

### Integration Resource Files - Correspondence - Source Keywords ###
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/API/Correspondence/API_COR_LOANIQ_VAL.robot
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/API/Correspondence/API_COR_FFC_VAL.robot
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/API/Correspondence/API_COR_PREREQUISITE.robot
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/API/Correspondence/API_COR_VAL.robot

### Integration Resource Files - Correspondence - Business Keywords ###
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/API/Correspondence/API_COR_TC01.robot

### Integration Resource Files - User - Business Keywords ###
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Users/API_SSO_CRE01.robot

### Integration Resource Files - User - Source Keywords ###
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/Users/API_SSO_API_VAL.robot
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/Users/API_SSO_DATABASE_VAL.robot
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/Users/API_SSO_FFC_VAL.robot
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/Users/API_SSO_LOANIQ_VAL.robot
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/Users/API_SSO_PREREQUISITE.robot
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/Users/API_SSO_VAL.robot

### Integration Resource Files - TL Calendar - Business Keywords ###
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/Calendar/TL_CAL_01.robot

### Integration Resource Files - TL Calendar - Source Keywords ###
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/Transformation_Layer/Calendar/TL_CAL_PREREQUISITE.robot
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/Transformation_Layer/Calendar/TL_CAL_LIQ_VAL.robot
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/Transformation_Layer/Calendar/TL_CAL_FFC_VAL.robot
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/Transformation_Layer/Calendar/TL_CAL_DATABASE_VAL.robot

### Integration Resource Files - TL Base Rates - Business Keywords###
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_01.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_02.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_03.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_04.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_05.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_06.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_07.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_08.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_09.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_10.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_11.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_12.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_13.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_14.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_15.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_16.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_17.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_18.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_19.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_20.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_21.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_22.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_26.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_27.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_28.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_29.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_30.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_31.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_33.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_34.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_35.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_36.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_37.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_38.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_39.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_40.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_41.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_42.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_44.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/BaseRates/TL_BASE_45.robot

### Integration Resource Files - TL Base Rates - Source Keywords ###
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/Transformation_Layer/BaseRates/TL_BASE_DATABASE_VAL.robot
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/Transformation_Layer/BaseRates/TL_BASE_FFC_VAL.robot
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/Transformation_Layer/BaseRates/TL_BASE_LIQ_VAL.robot
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/Transformation_Layer/BaseRates/TL_BASE_PREREQUISITE.robot

### Integration Resource Files - API Base Rates - Source Keywords ###
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/API/BaseRates/API_BIR_PREREQUISITE.robot
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/API/BaseRates/API_BIR_LOANIQ_VAL.robot

### Integration Resource Files - TL FX Rates - Business Keywords ###
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/FXRates/TL_FXRATES_01.robot

### Integration Resource Files - TL FX Rates - Source Keywords ###
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/Transformation_Layer/FXRates/TL_FXRATES_PREREQUISITE.robot
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/Transformation_Layer/FXRates/TL_FXRATES_LIQ_VAL.robot
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/Transformation_Layer/FXRates/TL_FXRATES_FFC_VAL.robot
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/Transformation_Layer/FXRates/TL_FXRATES_DATABASE_VAL.robot