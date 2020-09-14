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

### Global Variables ###
Resource    ../Variables/Global_Variables.txt
Resource    ../Variables/Calendar_Properties.txt
Resource    ../Variables/DWE_LIQ_Config.txt
Resource    ../Variables/Queries.txt
Resource    ../Variables/Users_Properties.txt
Resource    ../Variables/BaseRatesInterest_Properties.txt
Resource    ../Variables/FXRates_Properties.txt
Resource    ../Variables/Correspondence_Properties.txt
Resource    ../Variables/CommSee_Properties.txt
Resource    ../Variables/SAPWUL_Properties.txt

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
Resource    ../ResourcesFiles/Generic_Keywords/Utility_Keywords/CSV_Keywords.robot
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
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/Calendar/TL_CAL_02.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/Calendar/TL_CAL_03.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/Calendar/TL_CAL_04.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/Calendar/TL_CAL_07.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/Calendar/TL_CAL_08.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/Calendar/TL_CAL_09.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/Calendar/TL_CAL_10.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/Calendar/TL_CAL_11.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/Calendar/TL_CAL_12.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/Calendar/TL_CAL_13.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/Calendar/TL_CAL_14.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/Calendar/TL_CAL_15.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/Calendar/TL_CAL_16.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/Calendar/TL_CAL_17.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/Calendar/TL_CAL_18.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/Calendar/TL_CAL_19.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/Calendar/TL_CAL_20.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/Calendar/TL_CAL_21.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/Calendar/TL_CAL_25.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/Calendar/TL_CAL_26.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/Calendar/TL_CAL_27.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/Calendar/TL_CAL_28.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/Calendar/TL_CAL_29.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/Calendar/TL_CAL_30.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/Calendar/TL_CAL_31.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/Calendar/TL_CAL_32.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/Calendar/TL_CAL_33.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/Calendar/TL_CAL_35.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/Calendar/TL_CAL_36.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/Calendar/TL_CAL_37.robot

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
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/FXRates/TL_FXRATES_02.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/FXRates/TL_FXRATES_03.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/FXRates/TL_FXRATES_04.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/FXRates/TL_FXRATES_05.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/FXRates/TL_FXRATES_06.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/FXRates/TL_FXRATES_07.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/FXRates/TL_FXRATES_08.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/FXRates/TL_FXRATES_09.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/FXRates/TL_FXRATES_10.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/FXRates/TL_FXRATES_11.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/FXRates/TL_FXRATES_12.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/FXRates/TL_FXRATES_13.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/FXRates/TL_FXRATES_14.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/FXRates/TL_FXRATES_15.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/FXRates/TL_FXRATES_16.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/FXRates/TL_FXRATES_17.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/FXRates/TL_FXRATES_18.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/FXRates/TL_FXRATES_19.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/FXRates/TL_FXRATES_20.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/FXRates/TL_FXRATES_21.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/FXRates/TL_FXRATES_25.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/FXRates/TL_FXRATES_26.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/FXRates/TL_FXRATES_27.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/FXRates/TL_FXRATES_28.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/FXRates/TL_FXRATES_29.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/FXRates/TL_FXRATES_30.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/FXRates/TL_FXRATES_31.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/FXRates/TL_FXRATES_32.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Transformation_Layer/FXRates/TL_FXRATES_33.robot


### Integration Resource Files - TL FX Rates - Source Keywords ###
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/Transformation_Layer/FXRates/TL_FXRATES_PREREQUISITE.robot
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/Transformation_Layer/FXRates/TL_FXRATES_LIQ_VAL.robot
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/Transformation_Layer/FXRates/TL_FXRATES_FFC_VAL.robot
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/Transformation_Layer/FXRates/TL_FXRATES_DATABASE_VAL.robot

### Integration Resource Files - DWE Functional - Source Keywords ###
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/Extracts/DWE/DWE_LIQ_Functional/DWELIQ_Database_Validation.robot
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/Extracts/DWE/DWE_LIQ_Functional/DWELIQ_Functional_Validation.robot

### Integration Resource Files - DWE LIQ Extracts - Source Keywords ###
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/Extracts/DWE/DWE_LIQ_Extracts/DWELIQ_Extracts_Validation.robot

### Integration Resource Files - DWE Functional - Business Process Keywords ###
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Extracts/DWE_LIQ_Functional/DWE_LIQ_FuncVal01.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Extracts/DWE_LIQ_Functional/DWE_LIQ_FuncVal02.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Extracts/DWE_LIQ_Functional/DWE_LIQ_FuncVal03.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Extracts/DWE_LIQ_Functional/DWE_LIQ_FuncVal04.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Extracts/DWE_LIQ_Functional/DWE_LIQ_FuncVal05.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Extracts/DWE_LIQ_Functional/DWE_LIQ_FuncVal06.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Extracts/DWE_LIQ_Functional/DWE_LIQ_FuncVal07.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Extracts/DWE_LIQ_Functional/DWE_LIQ_FuncVal08.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Extracts/DWE_LIQ_Functional/DWE_LIQ_FuncVal09.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Extracts/DWE_LIQ_Functional/DWE_LIQ_FuncVal11.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Extracts/DWE_LIQ_Functional/DWE_LIQ_FuncVal12.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Extracts/DWE_LIQ_Functional/DWE_LIQ_FuncVal13.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Extracts/DWE_LIQ_Functional/DWE_LIQ_FuncVal14.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Extracts/DWE_LIQ_Functional/DWE_LIQ_FuncVal15.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Extracts/DWE_LIQ_Functional/DWE_LIQ_FuncVal16.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Extracts/DWE_LIQ_Functional/DWE_LIQ_FuncVal17.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Extracts/DWE_LIQ_Functional/DWE_LIQ_FuncVal19.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Extracts/DWE_LIQ_Functional/DWE_LIQ_FuncVal21.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Extracts/DWE_LIQ_Functional/DWE_LIQ_FuncVal22.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Extracts/DWE_LIQ_Functional/DWE_LIQ_FuncVal23.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Extracts/DWE_LIQ_Functional/DWE_LIQ_FuncVal24.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Extracts/DWE_LIQ_Functional/DWE_LIQ_FuncVal25.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Extracts/DWE_LIQ_Functional/DWE_LIQ_FuncVal26.robot

### Integration Resource Files - DWE LIQ Extracts - Business Process Keywords ###
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Extracts/DWE_LIQ_Extracts/DWE_LIQ_E2E.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Extracts/DWE_LIQ_Extracts/DWE_LIQ_EV.robot

### Integration Resource Files - CommSee - Business Keywords ###
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/API/CommSee/API_Response.robot

### Integration Resource Files - CommSee - Source Keywords ###
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/API/CommSee/API/API_COM_VAL.robot
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/API/CommSee/LoanIQ/CommSee_DealSetup.robot
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/API/CommSee/LoanIQ/CommSee_FacilityFeeSetup.robot
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/API/CommSee/LoanIQ/CommSee_FacilitySetup.robot
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/API/CommSee/LoanIQ/CommSee_Outstanding.robot
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/API/CommSee/LoanIQ/CommSee_Payment.robot

### Integration Resource Files - GL Extracts - Source Keywords ###
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/Extracts/GL/GLEssence_Extracts_Validation.robot

### Integration Resource Files - GL - Business Process Keywords ###
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/Extracts/GL_Essence/GLPOST_14.robot

### Integration Resource Files - SAPWUL - Business Keywords ###
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/API/SAPWUL/SAPWUL_DealSetup.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/API/SAPWUL/SAPWUL_EventsVerify.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/API/SAPWUL/SAPWUL_FacilityUpdates.robot
Resource    ../ResourcesFiles/Integration_Keywords/BusinessProcess_Keywords/API/SAPWUL/SAPWUL_LIQVerify.robot

### Integration Resource Files - SAPWUL - Source Keywords ###
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/API/SAPWUL/SAPWUL_EventsVal.robot
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/API/SAPWUL/SAPWUL_Generic.robot
Resource    ../ResourcesFiles/Integration_Keywords/Source_Keywords/API/SAPWUL/SAPWUL_TableMaintenance.robot