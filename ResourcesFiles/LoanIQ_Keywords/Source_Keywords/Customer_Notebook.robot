*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot
Resource    ../../../Configurations/Party_Import_File.robot

*** Keywords ***
Search Customer
    [Documentation]    This keyword searches existing customer using Customer's ID
    ...    @author: ghabal
    ...    @update: amansuet    02APR2020    - updated to align with automation standards and added keyword pre-processing
    ...    @update: amansuet    18MAY2020    - added acquire argument value for all arguments and added take screenshot
    [Arguments]    ${sCustomer_Search}    ${sLIQCustomer_ID}    ${sLIQCustomer_ShortName}

    ### Keyword Pre-processing ###
    ${Customer_Search}    Acquire Argument Value    ${sCustomer_Search}
    ${LIQCustomer_ID}    Acquire Argument Value    ${sLIQCustomer_ID}
    ${LIQCustomer_ShortName}    Acquire Argument Value    ${sLIQCustomer_ShortName}

    Run Keyword If    '${sCustomer_Search}' == 'Search by Customer ID'    Search by Customer ID    ${LIQCustomer_ID}    ${LIQCustomer_ShortName}                
    Run Keyword If    '${sCustomer_Search}' == 'Search by Customer Short Name'    Search by Customer Short Name    ${LIQCustomer_ShortName}    ${LIQCustomer_ID}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ActiveCustomerWindow_GeneralTab

Search by Customer ID
    [Documentation]    This keyword searches existing customer using Customer's ID
    ...    @author: ghabal
    ...    @update: ghabal    -    added more seconds to waiting time
    ...    @update: amansuet    18MAY2020    - added take screenshot and removed unused keywords
    ...                                      - updated to align with automation standards
    [Arguments]    ${sLIQCustomer_ID}    ${sLIQCustomer_ShortName}        

    Select Actions    [Actions];Customer
    Mx LoanIQ Activate    ${LIQ_CustomerSelect_Window}
    Validate Window Title    Customer Select
    Mx LoanIQ Select Combo Box Value    ${LIQ_CustomerSelect_Search_Filter}      Customer ID
    Log    "Customer ID" is selected in the "Identify By" dropdown list.
    Mx LoanIQ Enter    ${LIQ_CustomerSelect_Search_Inputfield}     ${sLIQCustomer_ID}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/CustomerSelectWindow
    Validate Customer ID if a Numeric Value Upon Customer Search by Customer ID    ${sLIQCustomer_ID}    ${sLIQCustomer_ShortName}
    
Validate Customer ID if a Numeric Value Upon Customer Search by Customer ID    
    [Documentation]    This keyword validates if Customer ID is purely numeric and returns an error if not
    ...    @author: ghabal
    ...    @update: amansuet    18MAY2020    - updated to align with automation standards
    [Arguments]    ${sLIQCustomer_ID}    ${sLIQCustomer_ShortName}

    ${result}    Run Keyword And Continue On Failure    Convert To Number    ${sLIQCustomer_ID}
    ${result}    Run Keyword And Return Status    Convert To Number    ${sLIQCustomer_ID}
    Run Keyword If   '${result}'=='True'    Continue with the Customer Search    ${sLIQCustomer_ID}    ${sLIQCustomer_ShortName}
    ...     ELSE    Log    'Customer ID' is NOT a numeric value. Run of Test Automation will not proceed. Please make sure you're using a numeric CIF IDs.            
   
Continue with the Customer Search    
    [Documentation]    This keyword continues the search of the Customer by Customer ID once confirmed numeric
    ...    @author: ghabal
    ...    @update: gerhabal    03SEP2019    - update keyword to accommodate search if the Customer does not exists in Loan IQ
    ...    @update: amansuet    21MAY2020    - removed unused keywords and updated to align with automation standards
    [Arguments]    ${sLIQCustomer_ID}    ${sLIQCustomer_ShortName}   
    
    Log    'Customer ID' is confirmed a numeric value. Run of Test Automation will continue.
    Log    Customer ID No. "${sLIQCustomer_ID}" created in FBE is entered in the "Customer ID" field.
    Mx LoanIQ Click    ${LIQ_CustomerSelect_OK_Button}
    ${LIQ_ActiveCustomerID_DoesNotExist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Error_MessageBox}    VerificationData="Yes"
    Run Keyword If   '${LIQ_ActiveCustomerID_DoesNotExist}'=='True'    Check if Party ID Does Not Exist    ${sLIQCustomer_ID}    ${sLIQCustomer_ShortName}
    ...    ELSE    Run Keywords    Validate 'Active Customer' Window    ${sLIQCustomer_ShortName}
    ...    AND    Switch Customer Notebook to Update Mode

Check if Party ID Does Not Exist
    [Documentation]    This keywords check if the Party Account Id that has existing Shortname is confirmed Not Existing in Loan IQ   
    ...    @author: gerhabal    03SEP2019    - initial create
    ...    @update: gerhabal    04SEP2019    - added screenshot keywords
    ...    @update: amansuet    18MAY2020    - updated to align with automation standards
    [Arguments]    ${sLIQCustomer_ID}    ${sLIQCustomer_ShortName}
    
    ${CustomerID_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_Error_MessageBox}    value%Nothing found for ${sLIQCustomer_ID}.
    Run Keyword If   '${CustomerID_Status}'=='True'    Log    Party Account Id: ${sLIQCustomer_ID} that has existing Shortname of ${sLIQCustomer_ShortName} is confirmed Not Existing in Loan IQ
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    Account ID does not Exsist
    Take Screenshot    ${SCREENSHOT_FILENAME}
    Mx LoanIQ Click Element If Present    ${LIQ_Error_OK_Button}
       
Search by Customer Short Name
    [Documentation]    This keyword searches existing customer using Customer's Enterprise Name\Legal\Short Name
    ...    @author: ghabal
    ...    @update: amansuet    18MAY2020    - added take screenshot , removed unused keywords and updated to align with automation standards
    ...    @update: hstone      09JUN2020    - Added Keyword Pre-processing
    [Arguments]    ${sLIQCustomer_ShortName}    ${sLIQCustomer_ID}
    
    ### Keyword Pre-processing ###
    ${LIQCustomer_ShortName}    Acquire Argument Value    ${sLIQCustomer_ShortName}
    ${LIQCustomer_ID}    Acquire Argument Value    ${sLIQCustomer_ID}

    Select Actions    [Actions];Customer
    Mx LoanIQ Activate    ${LIQ_CustomerSelect_Window}    
    Validate Window Title    Customer Select     
    Mx LoanIQ Enter    ${LIQ_CustomerSelect_Search_Inputfield}     ${LIQCustomer_ShortName}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/CustomerSelectWindow
    Mx LoanIQ Click    ${LIQ_CustomerSelect_OK_Button}
    :FOR    ${i}    IN RANGE    3
    \    ${LIQ_ActiveCustomer_WindowExist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_ActiveCustomer_Window}        VerificationData="Yes"
    \    Exit For Loop If    ${LIQ_ActiveCustomer_WindowExist}==True
    Validate 'Active Customer' Window    ${LIQCustomer_ShortName}
    Validate Customer ID if a Numeric value Upon Customer Search by Customer Short Name    ${LIQCustomer_ID} 

Validate Customer ID if a Numeric value Upon Customer Search by Customer Short Name 
    [Documentation]    This keyword validates if Customer ID if purely numeric and returns an error if not
    ...    @author: ghabal
    ...    @update: amansuet    18MAY2020    - updated to align with automation standards
    [Arguments]    ${sLIQCustomer_ID} 

    ${result}    Run Keyword And Continue On Failure    Convert To Number    ${sLIQCustomer_ID}
    ${result}    Run Keyword And Return Status    Convert To Number    ${sLIQCustomer_ID}    
    Run Keyword If   '${result}'=='True'    Switch Customer Notebook to Update Mode 
    ...     ELSE    Log    'Customer ID' is NOT a numeric value. Run of Test Automation will not proceed. Please make sure you're using a numeric CIF IDs. 

Switch Customer Notebook to Update Mode
    [Documentation]    This keyword switches the current Customer Notebook to Update Mode
    ...    @author: ghabal

    Run Keyword And Continue On Failure    mx LoanIQ click element if present  ${LIQ_Active_Customer_Notebook_InquiryMode}
    ${result}    Run Keyword And Return Status    Run Keyword And Continue On Failure    mx LoanIQ click element if present  ${LIQ_Active_Customer_Notebook_InquiryMode}
    Run Keyword If   '${result}'=='True'    Log    "Customer Notebook" is changed to "Update mode". 
    ...     ELSE    Log    "Customer Notebook" is NOT changed to "Update mode".    

Validate 'Active Customer' Window
    [Documentation]    This keyword validates the Window Name of Active Customer 
    ...    @author: ghabal
    ...    @update: amansuet    21MAY2020    - added acquire argument and take screenshot keywords
    ...                                      - fixed hardcoded locators
    [Arguments]    ${sLIQCustomer_ShortName}

    ### Keyword Pre-processing ###
    ${LIQCustomer_ShortName}    Acquire Argument Value    ${sLIQCustomer_ShortName}

    Mx LoanIQ Activate Window    ${LIQ_ActiveCustomer_Window}

    ${LIQCustomer_ShortName}    Replace Variables    ${LIQCustomer_ShortName}
    ${LIQ_ActiveCustomer_ShortName_Window}    Replace Variables    ${LIQ_ActiveCustomer_ShortName_Window}

    Run Keyword And Continue On Failure     Mx LoanIQ Verify Object Exist    ${LIQ_ActiveCustomer_ShortName_Window}    VerificationData="Yes"
    ${result}    Run Keyword And Return Status    Run Keyword And Continue On Failure     Mx LoanIQ Verify Object Exist    ${LIQ_ActiveCustomer_ShortName_Window}    VerificationData="Yes"
    Run Keyword If   '${result}'=='True'    Log    "Active Customer -- ${LIQCustomer_ShortName}" window has been displayed.
    ...     ELSE    Log    "Active Customer -- ${LIQCustomer_ShortName}" window has been displayed.        
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ActiveCustomerWindow_GeneralTab

Read Excel Data and Validate Customer ID, Short Name and Legal Name fields
    [Documentation]    This keyword validates the Customer ID, Short Name and Legal Name fields against from excel data 
    ...    @author: ghabal
    ...    @update: amansuet    21MAY2020    - removed unused keywords and updated to align with automation standards
    [Arguments]    ${sLIQCustomer_ID}     ${sLIQCustomer_ShortName}    ${sLIQCustomer_LegalName}

    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    General
    Run Keyword And Continue On Failure    Run Keyword And Continue On Failure    Validate Loan IQ Details    ${sLIQCustomer_ID}     ${LIQ_ActiveCustomer_Window_CustomerID}
    Validate if Element is Disabled    ${LIQ_ActiveCustomer_Window_CustomerID}    Customer ID 
    Run Keyword And Continue On Failure    Validate Loan IQ Details    ${sLIQCustomer_ShortName}    ${LIQ_ActiveCustomer_Window_ShortName}
    Validate if Element is Disabled    ${LIQ_ActiveCustomer_Window_ShortName}    Short Name
    Run Keyword And Continue On Failure    Validate Loan IQ Details    ${sLIQCustomer_LegalName}    ${LIQ_ActiveCustomer_Window_LegalName}
    Validate if Element is Disabled    ${LIQ_ActiveCustomer_Window_LegalName}    Legal Name

Select Customer Notice Type Method
    [Documentation]    This keyword selects the notice type method for the customer under General Tab
    ...    @author: ghabal
    ...    @update: amansuet    18MAY2020    - added acquire argument and take screenshot keywords and remove unused keyword
    [Arguments]    ${sCustomerNotice_TypeMethod}=None

    ### Keyword Pre-processing ###
    ${CustomerNotice_TypeMethod}    Acquire Argument Value    ${sCustomerNotice_TypeMethod}

    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    General
    Run Keyword If    '${CustomerNotice_TypeMethod}' != 'None'    Mx LoanIQ Select Combo Box Value    ${LIQ_Active_Customer_Notebook_GeneralTab_NoticeTypePreference_DropdownField}    ${CustomerNotice_TypeMethod}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ActiveCustomerWindow_GeneralTab

Add Expense Code Details under General tab
    [Documentation]    This keyword selects the expense code for the customer under General Tab
    ...    @author: ghabal
    ...    @update: amansuet    18MAY2020    - added acquire argument and take screenshot keywords and remove unused keyword
    [Arguments]    ${sExpense_Code}=None

    ### Keyword Pre-processing ###
    ${Expense_Code}    Acquire Argument Value    ${sExpense_Code}

    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    General
    Run Keyword If    '${Expense_Code}' != 'None'    mx LoanIQ click    ${LIQ_Active_Customer_Notebook_GeneralTab_ExpenseCode_Button}  
    Run Keyword If    '${Expense_Code}' != 'None'    mx LoanIQ enter    ${LIQ_SelectExpense_Codes_ExpenseCode_SearchInput}    ${Expense_Code}
    Run Keyword If    '${Expense_Code}' != 'None'    mx LoanIQ click    ${LIQ_SelectExpense_Codes_OKButton}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ActiveCustomerWindow_GeneralTab

Add Department Code Details under General tab
    [Documentation]    This keyword selects the expense code for the customer under General Tab
    ...    @author: ghabal
    ...    @update: amansuet    18MAY2020    - added acquire argument and take screenshot keywords and remove unused keyword
    [Arguments]    ${sDeparment_Code}=None

    ### Keyword Pre-processing ###
    ${Deparment_Code}    Acquire Argument Value    ${sDeparment_Code}

    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    General
    Run Keyword If    '${Deparment_Code}' != 'None'    mx LoanIQ click    ${LIQ_Active_Customer_Notebook_GeneralTab_DepartmentCode_Button}
    Run Keyword If    '${Deparment_Code}' != 'None'    mx LoanIQ enter    ${LIQ_SelectExpense_Codes_DepartmentCode_SearchInput}    ${Deparment_Code}
    Run Keyword If    '${Deparment_Code}' != 'None'    mx LoanIQ click    ${LIQ_SelectDepartment_Codes_OKButton}        
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ActiveCustomerWindow_GeneralTab

Add Classification Code Details under General tab
    [Documentation]    This keyword selects the classification code for the customer under General Tab
    ...    @author: ghabal
    ...    @update: hstone    04MAY2020    - Added 'Save Customer Details'
    ...    @update: amansuet    18MAY2020    - added acquire argument and take screenshot keywords and remove unused keyword
    [Arguments]    ${sClassification_Code}=None    ${sClassificationCode_Description}=None

    ### Keyword Pre-processing ###
    ${Classification_Code}    Acquire Argument Value    ${sClassification_Code}
    ${ClassificationCode_Description}    Acquire Argument Value    ${sClassificationCode_Description}

    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    General
    Run Keyword If    '${Classification_Code}' != 'None'    mx LoanIQ click    ${LIQ_Active_Customer_Notebook_GeneralTab_ClassificationCode_Button}
    Run Keyword If    '${Classification_Code}' != 'None'    mx LoanIQ enter    ${LIQ_SelectClassification_Codes_ClassificationCode_SearchbyCode}    ${Classification_Code}
    Run Keyword If    '${Classification_Code}' != 'None'    mx LoanIQ click    ${LIQ_SelectClassification_Codes_OKButton}
    Run Keyword If    '${ClassificationCode_Description}' != 'None'    Read Excel Data and Validate Classification Code Details under General Tab    ${ClassificationCode_Description}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ActiveCustomerWindow_GeneralTab
    Save Customer Details

Read Excel Data and Validate Classification Code Details under General Tab
    [Documentation]    This keyword validates the Classification Code Details against from excel data 
    ...    @author: ghabal
    ...    @update: amansuet    21MAY2020    - updated to align with automation standards and removed unused keywords
    [Arguments]    ${sClassificationCode_Description}

    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    General
    Run Keyword And Continue On Failure    Validate Loan IQ Details    ${sClassificationCode_Description}    ${LIQ_Active_Customer_Notebook_GeneralTab_ClassificationCodeDescription_Field}

Uncheck "Subject to GST" checkbox
    [Documentation]    This keyword unchecks the "Subject to GST" checkbox 
    ...    @author: ghabal
    ...    @update: amansuet    18MAY2020    - added take screenshot keywords and remove unused keyword

    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    General    
    Mx LoanIQ Check Or Uncheck    ${LIQ_ActiveCustomer_Window_GST_CheckBox}    OFF
    Validate if Element is Unchecked    ${LIQ_ActiveCustomer_Window_GST_CheckBox}    Subject to GST      
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ActiveCustomerWindow_GeneralTab

Navigate to "SIC" tab and Validate Primary SIC Code
    [Documentation]    This keyword navigates user to "SIC" tab and validates 'Primary SIC' Code
    ...    @author: ghabal
    ...    @update: amansuet    18MAY2020    - added acquire argument and take screenshot keywords and remove unused keyword
    ...                                      - fixed hardcoded locator
    [Arguments]    ${sPrimary_SICCode}    ${sPrimarySICCode_Description}

    ### Keyword Pre-processing ###
    ${Primary_SICCode}    Acquire Argument Value    ${sPrimary_SICCode}
    ${PrimarySICCode_Description}    Acquire Argument Value    ${sPrimarySICCode_Description}

    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    SIC
    Mx LoanIQ Activate    ${LIQ_ActiveCustomer_Window}

    ${Primary_SICCode}    Replace Variables    ${Primary_SICCode}
    ${LIQ_Active_Customer_Notebook_SICTab_PrimarySICCode}    Replace Variables    ${LIQ_Active_Customer_Notebook_SICTab_PrimarySICCode}
    Run Keyword And Continue On Failure    Validate Loan IQ Details    ${Primary_SICCode}    ${LIQ_Active_Customer_Notebook_SICTab_PrimarySICCode}

    ${PrimarySICCode_Description}    Replace Variables    ${PrimarySICCode_Description}
    ${LIQ_Active_Customer_Notebook_SICTab_PrimarySICCodeDescription}    Replace Variables    ${LIQ_Active_Customer_Notebook_SICTab_PrimarySICCodeDescription}
    Run Keyword And Continue On Failure    Validate Loan IQ Details    ${PrimarySICCode_Description}    ${LIQ_Active_Customer_Notebook_SICTab_PrimarySICCodeDescription}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ActiveCustomerWindow_SICTab

Navigate to "Profiles" tab and Validate "Add Profile" Button
    [Documentation]    This keyword navigates user to "Profiles" tab and validates 'Add Profile' button 
    ...    @author: ghabal
    ...    @update: amansuet    24APR2020    - updated keyword name for New Framework
    ...    @update: amansuet    19MAY2020    - added take screenshot keywords and remove unused keyword

    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    Profiles
    Mx LoanIQ Activate    ${LIQ_ActiveCustomer_Window}  
    Validate Only 'Add Profile Button' is Enabled in Profile Tab
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ActiveCustomerWindow_ProfilesTab
    
Validate Only 'Add Profile Button' is Enabled in Profile Tab
    [Documentation]    This keyword validates that only 'Add Profile Button' is Enabled in Profile Tab 
    ...    @author: ghabal

    Validate if Element is Enabled    ${AddProfile_Button}    Add Profile
    Validate if Element is Disabled    ${AddLocation_Button}    Add Location
    Validate if Element is Disabled    ${Delete_Button}    Delete
    Validate If Remaining Buttons are Disabled
     
Add Profile under Profiles Tab
    [Documentation]    This keyword adds a Profile Type to a Customer
    ...    @author: ghabal
    ...    @update: amansuet    19MAY2020    - added acquire argument and take screenshot keywords and remove unused keyword
    [Arguments]    ${sProfile_Type}=None

    ### Keyword Pre-processing ###
    ${Profile_Type}    Acquire Argument Value    ${sProfile_Type}

    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    Profiles
    Run Keyword If    '${Profile_Type}' != 'None'    Mx LoanIQ Click    ${AddProfile_Button}
    Mx LoanIQ Click Element If Present  ${Please Confirm_AddingProfile_Window_YesButton}
    Validate Window Title    Select Profile
    Run Keyword If    '${Profile_Type}' != 'None'    Mx LoanIQ Select String    ${LIQ_Select_Profile_ProfileType_List}    ${Profile_Type}
    Run Keyword If    '${Profile_Type}' != 'None'    Mx LoanIQ Click    ${LIQ_Select_Profile_ProfileType_OkButton}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ProfileDetailsWindow

Add Borrower Profile Details under Profiles Tab
    [Documentation]    This keyword adds a Borrower Profile Details to a Customer
    ...    @author: ghabal
    ...    @update: amansuet    19MAY2020    - added acquire argument and take screenshot keywords and remove unused keyword
    [Arguments]    ${sProfile_Type}=None

    ### Keyword Pre-processing ###
    ${Profile_Type}    Acquire Argument Value    ${sProfile_Type}

    Mx LoanIQ Activate    ${LIQ_BorrowerProfileDetails_Window}    
    Run Keyword If    '${Profile_Type}' != 'None'    Validate 'Profile Details' Window    ${Profile_Type}
    Run Keyword If    '${Profile_Type}' != 'None'    Mx LoanIQ Click    ${LIQ_BorrowerProfileDetails__OkButton}
    Run Keyword If    '${Profile_Type}' != 'None'    Read Excel Data and Validate Details under Profile and Status column in Profile Tab    ${Profile_Type}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ActiveCustomerWindow_ProfilesTab

Validate 'Profile Details' Window
    [Documentation]    This keyword validates the Window Name of Profile Details Window 
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and fixed hardcoded locator
    [Arguments]    ${sProfile_Type}

    ${Profile_Type}    Replace Variables    ${sProfile_Type}
    ${LIQ_Active_Customer_Notebook_ProfileTab_ProfileDetails_Window}    Replace Variables    ${LIQ_Active_Customer_Notebook_ProfileTab_ProfileDetails_Window}
    Run Keyword And Continue On Failure     Mx LoanIQ Verify Object Exist    ${LIQ_Active_Customer_Notebook_ProfileTab_ProfileDetails_Window}    VerificationData="Yes"
    ${result}    Run Keyword And Return Status    Run Keyword And Continue On Failure     Mx LoanIQ Verify Object Exist    ${LIQ_Active_Customer_Notebook_ProfileTab_ProfileDetails_Window}    VerificationData="Yes"
    Run Keyword If   '${result}'=='True'    Log    "${Profile_Type} Profile Details" window has been displayed.
    ...     ELSE    Log    "${Profile_Type} Profile Details" window has been NOT displayed.

Adding Beneficiary Profile Details under Profiles Tab
    [Documentation]    This keyword adds a Benefiary Profile Details to a Customer
    ...    @author: ghabal
    ...    @update: amansuet    20MAY2020    - added acquire argument and take screenshot keywords and remove unused keyword
    [Arguments]    ${sProfile_Type}

    ### Keyword Pre-processing ###
    ${Profile_Type}    Acquire Argument Value    ${sProfile_Type}

    Mx LoanIQ Activate    ${LIQ_BeneficiaryProfileDetails_Window}    
    Validate 'Profile Details' Window    ${Profile_Type}
    Mx LoanIQ Click    ${LIQ_BeneficiaryProfileDetails__OkButton}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ActiveCustomerWindow_ProfilesTab
    Read Excel Data and Validate Details under Profile and Status column in Profile Tab        ${Profile_Type}           

Adding Guarantor Profile Details under Profiles Tab        
    [Documentation]    This keyword adds a Guarantor Profile Details to a Customer
    ...    @author: ghabal
    ...    @update: amansuet    20MAY2020    - added acquire argument and take screenshot keywords and remove unused keyword
    [Arguments]    ${sProfile_Type}

    ### Keyword Pre-processing ###
    ${Profile_Type}    Acquire Argument Value    ${sProfile_Type}

    Mx LoanIQ Activate    ${LIQ_GuarantorProfileDetails_Window}    
    Validate 'Profile Details' Window    ${Profile_Type}  
    Mx LoanIQ Click    ${LIQ_GuarantorProfileDetails__OkButton}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ActiveCustomerWindow_ProfilesTab
    Read Excel Data and Validate Details under Profile and Status column in Profile Tab    ${Profile_Type}
    
Adding Lender Profile Details under Profiles Tab        
    [Documentation]    This keyword adds a Lender Profile Details to a Customer
    ...    @author: ghabal
    ...    @update: amansuet    20MAY2020    - added acquire argument and take screenshot keywords and remove unused keyword
    [Arguments]    ${sProfile_Type}

    ### Keyword Pre-processing ###
    ${Profile_Type}    Acquire Argument Value    ${sProfile_Type}

    Mx LoanIQ Activate    ${LIQ_LenderProfileDetails_Window}    
    Validate 'Profile Details' Window    ${Profile_Type}  
    Mx LoanIQ Click    ${LIQ_LenderProfileDetails__OkButton}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ActiveCustomerWindow_ProfilesTab
    Read Excel Data and Validate Details under Profile and Status column in Profile Tab    ${Profile_Type}
 
Read Excel Data and Validate Details under Profile and Status column in Profile Tab
    [Documentation]    This keyword validates the Details under Profile and Status column in Profile Tab against from excel data 
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and fixed hardcoded locator
    [Arguments]    ${sProfile_Type}

    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    Profiles

    ${Profile_Type}    Replace Variables    ${sProfile_Type}
    ${LIQ_Active_Customer_Notebook_ProfileTab_ProfileDescription_Grid}    Replace Variables    ${LIQ_Active_Customer_Notebook_ProfileTab_ProfileDescription_Grid}
    Run Keyword And Continue On Failure        Mx LoanIQ Verify Object Exist    ${LIQ_Active_Customer_Notebook_ProfileTab_ProfileDescription_Grid}    VerificationData="Yes"
    ${result1}    Run Keyword And Return Status    Run Keyword And Continue On Failure        Mx LoanIQ Verify Object Exist    ${LIQ_Active_Customer_Notebook_ProfileTab_ProfileDescription_Grid}    VerificationData="Yes"
    Run Keyword And Continue On Failure        Mx LoanIQ Verify Object Exist    ${LIQ_Active_Customer_Notebook_ProfileTab_NotInUseStatus_Grid}    VerificationData="Yes"
    ${result2}    Run Keyword And Return Status    Run Keyword And Continue On Failure        Mx LoanIQ Verify Object Exist    ${LIQ_Active_Customer_Notebook_ProfileTab_NotInUseStatus_Grid}    VerificationData="Yes"
    ${result3}    Run Keyword And Return Status    Run Keyword And Continue On Failure    Should Be Equal   ${result1}   ${result2}
    Run Keyword If   '${result3}'=='True'    Log   '${Profile_Type}' is added in "Profile" section with "Not In Use" status.
    ...     ELSE    Log   '${Profile_Type}' is NOT added in "Profile" section with "Not In Use" status.                     
    
Validate Only "Add Profile" and "Add Location" and "Delete" Buttons are Enabled in Profile Tab
    [Documentation]    This keyword validates that only 'Add Profile', 'Add Location' and 'Delete' Buttons are Enabled in Profile Tab 
    ...    @author: ghabal
    ...    @update: amansuet    22APR2020    - updated keyword name for New Framework
    ...    @update: amansuet    19MAY2020    - added take screenshot keyword and remove unused keyword

    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    Profiles
    Validate if Element is Enabled    ${AddProfile_Button}    Add Profile
    Validate if Element is Enabled    ${AddLocation_Button}    Add Location
    Validate if Element is Enabled    ${Delete_Button}    Delete
    Validate If Remaining Buttons are Disabled
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ActiveCustomerWindow_ProfilesTab

Validate If Remaining Buttons are Disabled
    [Documentation]    This keyword validates that all the Remaining Buttons are Disabled 
    ...    @author: ghabal

    Validate if Element is Disabled    ${CompleteLocation_Button}    Complete Location
    Validate if Element is Disabled    ${Addresses_Button}    Addresses
    Validate if Element is Disabled    ${Faxes_Button}    Faxes
    Validate if Element is Disabled    ${Contacts_Button}    Contacts
    Validate if Element is Disabled    ${RemittanceInstructions_Button}    Remittance Instructions
    Validate if Element is Disabled    ${Personnel_Button}    Personnel
    Validate if Element is Disabled    ${ServicingGroups_Button}    Servicing Groups
    
Add Location under Profiles Tab     
    [Documentation]    This keyword adds a Location to a Customer
    ...    @author: ghabal
    ...    @update: amansuet    19MAY2020    - added acquire argument and take screenshot keywords and remove unused keyword
    [Arguments]    ${sCustomer_Location}=None
    
    ### Keyword Pre-processing ###
    ${Customer_Location}    Acquire Argument Value    ${sCustomer_Location}

    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    Profiles
    Run Keyword If    '${Customer_Location}' != 'None'    Mx LoanIQ Click    ${AddLocation_Button}
    Validate Window Title    Select Location
    Run Keyword If    '${Customer_Location}' != 'None'    Mx LoanIQ Enter    ${LIQ_SelectLocation_SearchByDescription}    ${Customer_Location}   
    Run Keyword If    '${Customer_Location}' != 'None'    Mx LoanIQ Click    ${LIQ_SelectLocation_OKButton}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/LocationDetailsWindow

Read Excel Data and Validate Location Details under Profile column in Profile Tab
    [Documentation]    This keyword validates the Location Details under Profile column in Profile Tab  against from excel data 
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and fixed hardcoded locator
    [Arguments]    ${sCustomer_Location}    ${sProfile_Type}

    ${Customer_Location}    Replace Variables    ${sCustomer_Location}
    ${LIQ_Active_Customer_Notebook_ProfileTab_LocationDescription_Grid}    Replace Variables    ${LIQ_Active_Customer_Notebook_ProfileTab_LocationDescription_Grid}

    Run Keyword And Continue On Failure     Mx LoanIQ Verify Object Exist    ${LIQ_Active_Customer_Notebook_ProfileTab_LocationDescription_Grid}    VerificationData="Yes"
    ${result}    Run Keyword And Return Status    Run Keyword And Continue On Failure     Mx LoanIQ Verify Object Exist    ${LIQ_Active_Customer_Notebook_ProfileTab_LocationDescription_Grid}    VerificationData="Yes"
    Run Keyword If   '${result}'=='True'    Log   '${Customer_Location}' is added under ${sProfile_Type}'s Profile Type
    ...     ELSE    Log   '${Customer_Location}' is NOT added under ${sProfile_Type}'s Profile Type
    
Add Borrower/Location Details under Profiles Tab
    [Documentation]    This keyword adds Borrower Details to a Customer upon adding a location
    ...    @author: ghabal
    ...    @update: amansuet    23APR2020    - updated keyword name spelling
    ...    @update: amansuet    19MAY2020    - added acquire argument and take screenshot keywords and remove unused keyword
    ...                                      - fixed hardcoded locator
    [Arguments]    ${sProfile_Type}    ${sCustomer_Location}     

    ### Keyword Pre-processing ###
    ${Profile_Type}    Acquire Argument Value    ${sProfile_Type}
    ${Customer_Location}    Acquire Argument Value    ${sCustomer_Location}

    ${Profile_Type}    Replace Variables    ${Profile_Type}
    ${LIQ_Active_Customer_Notebook_ProfileTab_LocationDetails_Window}    Replace Variables    ${LIQ_Active_Customer_Notebook_ProfileTab_LocationDetails_Window}
    Mx LoanIQ Activate    ${LIQ_Active_Customer_Notebook_ProfileTab_LocationDetails_Window}
    Validate 'Profile/Location' Window    ${Profile_Type}	${Customer_Location}
    Mx LoanIQ Click    ${LIQ_BorrowerDetails_OKButton}
    Read Excel Data and Validate Location Details under Profile column in Profile Tab    ${Customer_Location}    ${Profile_Type}    
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ActiveCustomerWindow_ProfilesTab

Validate 'Profile/Location' Window
    [Documentation]    This keyword validates the Window Name of 'Profile/Location' Window 
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and fixed hardcoded locator
    [Arguments]    ${sProfile_Type}    ${sCustomer_Location}

    ${Profile_Type}    Replace Variables    ${sProfile_Type}
    ${LIQ_Active_Customer_Notebook_ProfileTab_ProfileLocation_Window}    Replace Variables    ${LIQ_Active_Customer_Notebook_ProfileTab_ProfileLocation_Window}
    
    Run Keyword And Continue On Failure     Mx LoanIQ Verify Object Exist    ${LIQ_Active_Customer_Notebook_ProfileTab_ProfileLocation_Window}    VerificationData="Yes"
    ${result}    Run Keyword And Return Status    Run Keyword And Continue On Failure     Mx LoanIQ Verify Object Exist    ${LIQ_Active_Customer_Notebook_ProfileTab_ProfileLocation_Window}    VerificationData="Yes"
    Run Keyword If   '${result}'=='True'    Log    "${Profile_Type}/${sCustomer_Location} Details" window has been displayed.
    ...     ELSE    Log    "${Profile_Type}/${sCustomer_Location} Details" window has been NOT displayed.
    
Adding Beneficiary/Location Details under Profiles Tab    
    [Documentation]    This keyword adds Beneficiary Details to a Customer upon adding a location
    ...    @author: ghabal
    ...    @update: amansuet    21MAY2020    - added acquire argument and take screenshot keywords and remove unused keyword
    [Arguments]    ${sProfile_Type}    ${sCustomer_Location}

    ### Keyword Pre-processing ###
    ${Profile_Type}    Acquire Argument Value    ${sProfile_Type}
    ${Customer_Location}    Acquire Argument Value    ${sCustomer_Location}

    Mx LoanIQ Activate    JavaWindow("title:=${Profile_Type}.*")
    Validate 'Profile/Location' Window    ${Profile_Type}	${Customer_Location}
    Mx LoanIQ Click    ${LIQ_BeneficiaryDetails_OKButton}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ActiveCustomerWindow_ProfilesTab

Adding Guarantor/Location Details under Profiles Tab    
    [Documentation]    This keyword adds Guarantor Details to a Customer upon adding a location
    ...    @author: ghabal
    ...    @update: amansuet    21MAY2020    - added acquire argument and take screenshot keywords and remove unused keyword
    [Arguments]    ${sProfile_Type}    ${sCustomer_Location}

    ### Keyword Pre-processing ###
    ${Profile_Type}    Acquire Argument Value    ${sProfile_Type}
    ${Customer_Location}    Acquire Argument Value    ${sCustomer_Location}

    Mx LoanIQ Activate    JavaWindow("title:=${Profile_Type}.*")    
    Validate 'Profile/Location' Window    ${Profile_Type}	${Customer_Location}   
    Mx LoanIQ Click    ${LIQ_GuarantorDetails_OKButton}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ActiveCustomerWindow_ProfilesTab

Adding Lender/Location Details under Profiles Tab    
    [Documentation]    This keyword adds Lender Details to a Customer upon adding a location
    ...    @author: ghabal
    ...    @update: amansuet    21MAY2020    - added acquire argument and take screenshot keywords and remove unused keyword
    [Arguments]    ${sProfile_Type}    ${sCustomer_Location}

    ### Keyword Pre-processing ###
    ${Profile_Type}    Acquire Argument Value    ${sProfile_Type}
    ${Customer_Location}    Acquire Argument Value    ${sCustomer_Location}

    Mx LoanIQ Activate    JavaWindow("title:=${Profile_Type}.*")    
    Validate 'Profile/Location' Window    ${Profile_Type}	${Customer_Location}     
    Mx LoanIQ Click    ${LIQ_LenderDetails_OKButton}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ActiveCustomerWindow_ProfilesTab

Validate If All Buttons are Enabled
    [Documentation]    This keyword validates if All Buttons are Enabled 
    ...    @author: ghabal
    ...    @update: amansuet    19MAY2020    - added take screenshot keyword and remove unused keyword

    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    Profiles
    Validate if Element is Enabled    ${AddProfile_Button}    Add Profile
    Validate if Element is Enabled    ${Addresses_Button}    Addresses
    Validate if Element is Enabled    ${AddLocation_Button}    Add Location
    Validate if Element is Enabled    ${Faxes_Button}    Faxes
    Validate if Element is Enabled    ${Delete_Button}    Delete
    Validate if Element is Enabled    ${Contacts_Button}    Contacts
    Validate if Element is Enabled    ${Personnel_Button}    Personnel
    Validate if Element is Enabled    ${CompleteLocation_Button}    Complete Location
    Validate if Element is Enabled    ${RemittanceInstructions_Button}    Remittance Instructions
    Validate if Element is Enabled    ${ServicingGroups_Button}    Servicing Groups    
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ActiveCustomerWindow_ProfilesTab

Check Legal Address Details Under Profiles Tab
    [Documentation]    This keyword checks the details of the Legal Address of the Customer created in Essence Party
    ...    @author: ghabal
    ...    @update: amansuet    21MAY2020    - added acquire argument and take screenshot keywords and remove unused keyword
    ...    @update: hstone      08JUN2020    - Fixed argument naming issues.
    [Arguments]    ${sCustomer_Location}    ${sAddress_Code}    ${sAddress_Line1}    ${sAddress_Line2}    ${sAddress_City}    ${sAddress_ZipPostalCode}    ${sLIQCustomer_ShortName}
    
    ### Keyword Pre-processing ###
    ${Customer_Location}    Acquire Argument Value    ${sCustomer_Location}
    ${Address_Code}    Acquire Argument Value    ${sAddress_Code}
    ${Address_Line1}    Acquire Argument Value    ${sAddress_Line1}
    ${Address_Line2}    Acquire Argument Value    ${sAddress_Line2}
    ${Address_City}    Acquire Argument Value    ${sAddress_City}
    ${Address_ZipPostalCode}    Acquire Argument Value    ${sAddress_ZipPostalCode}
    ${LIQCustomer_ShortName}    Acquire Argument Value    ${sLIQCustomer_ShortName}

    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    Profiles
    Mx LoanIQ Click    ${Addresses_Button}
    Mx LoanIQ Activate    ${LIQ_Active_Customer_Notebook_AddressListWindow}
    Validate Address List for 'Location' Window    ${Customer_Location}    
    Mx LoanIQ DoubleClick    ${LIQ_Active_Customer_Notebook_AddressListWindow_LegalAddress}    ${Address_Code}
    Validate Window Title    Update Address   
    Read Excel Data and Validate Address Details in Update Address Window    ${Address_Line1}    ${Address_Line2}    ${Address_City}    ${Address_ZipPostalCode} 
    Mx LoanIQ Click    ${LIQ_Active_Customer_Notebook_UpdateAddressWindow_OKButton}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/UpdateAddressWindow
    Mx LoanIQ Activate    ${LIQ_Active_Customer_Notebook_AddressListWindow}
    Validate Address List for 'Location' Window    ${Customer_Location}
    Mx LoanIQ Click    ${LIQ_Active_Customer_Notebook_AddressListWindow_ExitButton}
    Validate 'Active Customer' Window    ${LIQCustomer_ShortName}
    
Validate Address List for 'Location' Window
    [Documentation]    This keyword validates the Window Name of Address List for 'Location' Window 
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and fixed hardcoded locator
    [Arguments]    ${sCustomer_Location}

    ${Customer_Location}    Replace Variables    ${sCustomer_Location}
    ${LIQ_Active_Customer_Notebook_ProfileTab_AddressListforLocation_Window}    Replace Variables    ${LIQ_Active_Customer_Notebook_ProfileTab_AddressListforLocation_Window}

    Run Keyword And Continue On Failure     Mx LoanIQ Verify Object Exist    ${LIQ_Active_Customer_Notebook_ProfileTab_AddressListforLocation_Window}    VerificationData="Yes"
    ${result}    Run Keyword And Return Status    Run Keyword And Continue On Failure     Mx LoanIQ Verify Object Exist    ${LIQ_Active_Customer_Notebook_ProfileTab_AddressListforLocation_Window}    VerificationData="Yes"
    Run Keyword If   '${result}'=='True'    Log    "Address List for ${Customer_Location}" window has been displayed.
    ...     ELSE    Log    "Address List for ${Customer_Location}" window has been NOT displayed.       
    
Read Excel Data and Validate Address Details in Update Address Window
    [Documentation]    This keyword validates the Address Details in Update Address Window against from excel data
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - remove unused keyword and updated to align with automation standards 
    [Arguments]    ${sAddress_Line1}    ${sAddress_Line2}    ${sAddress_City}    ${sAddress_ZipPostalCode}

    Run Keyword And Continue On Failure    Validate Loan IQ Details    ${sAddress_Line1}     ${LIQ_Active_Customer_Notebook_UpdateAddress_Window_Line1Field}
    Validate if Element is Disabled    ${LIQ_Active_Customer_Notebook_UpdateAddress_Window_Line1Field}    Line 1 
    Run Keyword And Continue On Failure    Validate Loan IQ Details    ${sAddress_Line2}  ${LIQ_Active_Customer_Notebook_UpdateAddress_Window_Line2Field}
    Validate if Element is Disabled    ${LIQ_Active_Customer_Notebook_UpdateAddress_Window_Line2Field}    Line 2
    Run Keyword And Continue On Failure    Validate Loan IQ Details    ${sAddress_City}    ${LIQ_Active_Customer_Notebook_UpdateAddress_Window_CityField}
    Validate if Element is Disabled    ${LIQ_Active_Customer_Notebook_UpdateAddress_Window_CityField}    City 
    Run Keyword And Continue On Failure    Validate Loan IQ Details    ${sAddress_ZipPostalCode}    ${LIQ_Active_Customer_Notebook_UpdateAddress_Window_ZipPostalCodeField}
    Validate if Element is Disabled    ${LIQ_Active_Customer_Notebook_UpdateAddress_Window_ZipPostalCodeField}    Zip/PostalCode  
    
Add Fax Details under Profiles Tab
    [Documentation]    This keyword adds Fax Details to a Customer
    ...    @author: ghabal
    ...    @update: amansuet    19MAY2020    - added acquire argument and take screenshot keywords and remove unused keyword
    [Arguments]    ${sCustomer_Location}    ${sFax_Number}    ${sFax_Description}

    ### Keyword Pre-processing ###
    ${Customer_Location}    Acquire Argument Value    ${sCustomer_Location}
    ${Fax_Number}    Acquire Argument Value    ${sFax_Number}
    ${Fax_Description}    Acquire Argument Value    ${sFax_Description}

    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    Profiles
    Mx LoanIQ Click    ${Faxes_Button}
    Mx LoanIQ Activate    ${FaxListWindow}
    Validate Fax List for 'Location' Window    ${Customer_Location}
    Mx LoanIQ Click    ${FaxListWindow_AddButton}
    Mx LoanIQ Activate    ${FaxDetailWindow}    
    Validate Window Title    Fax Detail    
    Mx LoanIQ Enter    ${FaxDetailWindow_FaxNumber_Field}    ${Fax_Number}
    Mx LoanIQ Enter    ${FaxDetailWindow_Description_Field}    ${Fax_Description} 
    Mx LoanIQ Click    ${FaxDetailWindow_OkButton}
    Mx LoanIQ Activate    ${FaxListWindow}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/FaxListWindow
    Validate Fax List for 'Location' Window    ${Customer_Location}
    Mx LoanIQ Click    ${FaxListWindow_ExitButton}

Validate Fax List for 'Location' Window
    [Documentation]    This keyword validates the Window Name of Fax List for 'Location' Window
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and fixed hardcoded locator
    [Arguments]    ${sCustomer_Location}

    ${Customer_Location}    Replace Variables    ${sCustomer_Location}
    ${LIQ_Active_Customer_Notebook_ProfileTab_FaxListforLocation_Window}    Replace Variables    ${LIQ_Active_Customer_Notebook_ProfileTab_FaxListforLocation_Window}

    Run Keyword And Continue On Failure     Mx LoanIQ Verify Object Exist    ${LIQ_Active_Customer_Notebook_ProfileTab_FaxListforLocation_Window}    VerificationData="Yes"
    ${result}    Run Keyword And Return Status    Run Keyword And Continue On Failure     Mx LoanIQ Verify Object Exist    ${LIQ_Active_Customer_Notebook_ProfileTab_FaxListforLocation_Window}    VerificationData="Yes"
    Run Keyword If   '${result}'=='True'    Log    "Fax List for ${Customer_Location}" window has been displayed.
    ...     ELSE         Log    "Fax List for ${Customer_Location}" window has been NOT displayed.

Add Contact under Profiles Tab
    [Documentation]    This keyword adds Contact to a Customer
    ...    @author: ghabal
    ...    @update: amansuet    02APR2020    Updated to align with automation standards and added keyword pre-processing
    ...    @update: amansuet    19MAY2020    - added acquire argument and take screenshot keywords and remove unused keyword
    [Arguments]    ${sCustomer_Location}    ${sLIQCustomer_ShortName}    ${sContact_FirstName}    ${sContact_LastName}    ${sContact_PreferredLanguage}    ${sContact_PrimaryPhone}    ${sBorrowerContact_Phone}    ${sContact_PurposeType}    ${sContactNotice_Method}    ${sContact_Email}
    ...    ${sProductSBLC_Checkbox}    ${sProductLoan_Checkbox}    ${bBalanceType_Principal_Checkbox}    ${bBalanceType_Interest_Checkbox}    ${bBalanceType_Fees_Checkbox}    ${sAddress_Code}   
    
    ### Keyword Pre-processing ###
    ${Customer_Location}    Acquire Argument Value    ${sCustomer_Location}
    ${LIQCustomer_ShortName}    Acquire Argument Value    ${sLIQCustomer_ShortName}
    ${Contact_FirstName}    Acquire Argument Value    ${sContact_FirstName}
    ${Contact_LastName}    Acquire Argument Value    ${sContact_LastName}
    ${Contact_PreferredLanguage}    Acquire Argument Value    ${sContact_PreferredLanguage}
    ${Contact_PrimaryPhone}    Acquire Argument Value    ${sContact_PrimaryPhone}
    ${BorrowerContact_Phone}    Acquire Argument Value    ${sBorrowerContact_Phone}
    ${Contact_PurposeType}    Acquire Argument Value    ${sContact_PurposeType}
    ${ContactNotice_Method}    Acquire Argument Value    ${sContactNotice_Method}
    ${Contact_Email}    Acquire Argument Value    ${sContact_Email}
    ${ProductSBLC_Checkbox}    Acquire Argument Value    ${sProductSBLC_Checkbox}
    ${ProductLoan_Checkbox}    Acquire Argument Value    ${sProductLoan_Checkbox}
    ${BalanceType_Principal_Checkbox}    Acquire Argument Value    ${bBalanceType_Principal_Checkbox}
    ${BalanceType_Interest_Checkbox}    Acquire Argument Value    ${bBalanceType_Interest_Checkbox}
    ${BalanceType_Fees_Checkbox}    Acquire Argument Value    ${bBalanceType_Fees_Checkbox}
    ${Address_Code}    Acquire Argument Value    ${sAddress_Code}
    
    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    Profiles
    Mx LoanIQ Click    ${Contacts_Button}
    Mx LoanIQ Activate    ${ContactListWindow}
    Validate Contact List for 'Location' Window    ${sCustomer_Location}
    Mx LoanIQ Click    ${ContactListWindow_AddButton}
    Mx LoanIQ Activate    ${ContactDetailWindow}
    Add Contact Detail under Profile Tab    ${Contact_FirstName}    ${Contact_LastName}    ${Contact_PreferredLanguage}    ${Contact_PrimaryPhone}    ${BorrowerContact_Phone}    ${Contact_PurposeType}    ${ContactNotice_Method}    ${Contact_Email}
    ...    ${ProductSBLC_Checkbox}    ${ProductLoan_Checkbox}    ${BalanceType_Principal_Checkbox}    ${BalanceType_Interest_Checkbox}    ${BalanceType_Fees_Checkbox}    ${Address_Code}   
    Mx LoanIQ Activate    ${ContactListWindow}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ContactListWindow
    Validate Contact List for 'Location' Window    ${Customer_Location}
    Mx LoanIQ Click    ${ContactListWindow_ExitButton}
    Validate 'Active Customer' Window    ${LIQCustomer_ShortName}
    
Validate Contact List for 'Location' Window
    [Documentation]    This keyword validates the Window Name of Contact List for 'Location' Window
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and fixed hardcoded locator
    [Arguments]    ${sCustomer_Location}

    ${Customer_Location}    Replace Variables    ${sCustomer_Location}
    ${LIQ_Active_Customer_Notebook_ProfileTab_ContactListforLocation_Window}    Replace Variables    ${LIQ_Active_Customer_Notebook_ProfileTab_ContactListforLocation_Window}

    Run Keyword And Continue On Failure     Mx LoanIQ Verify Object Exist    ${LIQ_Active_Customer_Notebook_ProfileTab_ContactListforLocation_Window}    VerificationData="Yes"
    ${result}    Run Keyword And Return Status    Run Keyword And Continue On Failure     Mx LoanIQ Verify Object Exist     ${LIQ_Active_Customer_Notebook_ProfileTab_ContactListforLocation_Window}    VerificationData="Yes"
    Run Keyword If   '${result}'=='True'    Log    "Contact List for ${Customer_Location}" window has been displayed.
    ...     ELSE    Log    "Contact List for ${Customer_Location}" window has been NOT displayed. 

Add Contact Detail under Profile Tab
    [Documentation]    This keyword adds Details of the Contact of a Customer
    ...    @author: ghabal
    ...    @update: ghabal    07MAR2019    - added keyword for the selecting address for Contact
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and removed unused keywords 
    [Arguments]    ${sContact_FirstName}=None    ${sContact_LastName}=None    ${sContact_PreferredLanguage}=None    ${sContact_PrimaryPhone}=None    ${sBorrowerContact_Phone}=None    ${sContact_PurposeType}=None    ${sContactNotice_Method}=None    ${sContact_Email}=None
    ...    ${sProductSBLC_Checkbox}=OFF    ${sProductLoan_Checkbox}=OFF    ${sBalanceType_Principal_Checkbox}=OFF    ${sBalanceType_Interest_Checkbox}=OFF    ${sBalanceType_Fees_Checkbox}=OFF    ${sAddress_Code}=None

    Run Keyword If    '${sContact_FirstName}' != 'None'    mx LoanIQ enter    ${ContactDetailWindow_FirstName_Field}    ${sContact_FirstName}
    Run Keyword If    '${sContact_LastName}' != 'None'    mx LoanIQ enter    ${ContactDetailWindow_LastName_Field}    ${sContact_LastName}
    Run Keyword If    '${sContact_PreferredLanguage}' != 'None'    mx LoanIQ select    ${ContactDetailWindow_PreferredLanguage_Field}    ${sContact_PreferredLanguage}
    Run Keyword If    '${sContact_PrimaryPhone}' != 'None'    mx LoanIQ enter    ${ContactDetailWindow_PrimaryPhone_Field}    ${sContact_PrimaryPhone}              
    Run Keyword If    '${sBorrowerContact_Phone}' != 'None'    mx LoanIQ enter    ${ContactDetailWindow_SecondaryPhone_Field}    ${sBorrowerContact_Phone}        

    Select Product in the Contact Details under Profile Tab    ${sProductSBLC_Checkbox}    ${sProductLoan_Checkbox}
    Select Balance Type in the Contact Details under Profile Tab    ${sBalanceType_Principal_Checkbox}    ${sBalanceType_Interest_Checkbox}    ${sBalanceType_Fees_Checkbox}
    Select Purpose in the Contact Details under Profile Tab    ${sContact_PurposeType}
    Select Notification Method in the Contact Details under Profile Tab    ${sContactNotice_Method}    ${sContact_Email}
    Select Address in the Contact Details under Profile Tab    ${sAddress_Code}
    Mx LoanIQ Select Window Tab    ${LIQ_Active_ContactDetail_TabSelection}    General
    Mx LoanIQ Select    ${ContactDetailWindow_FileMenu_SaveMenu}
    Read Excel Data and Validate Contact Details    ${sContact_FirstName}    ${sContact_LastName}    ${sContact_PreferredLanguage}    ${sContact_PrimaryPhone}
    Mx LoanIQ Select    ${ContactDetailWindow_FileMenu_ExitMenu}
   
Read Excel Data and Validate Contact Details
     [Documentation]    This keyword validates the Contact Details against from excel data
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and removed unused keywords
    [Arguments]    ${sContact_FirstName}    ${sContact_LastName}    ${sContact_PreferredLanguage}    ${sContact_PrimaryPhone}

    Run Keyword And Continue On Failure    Validate Loan IQ Details    ${sContact_FirstName}     ${ContactDetailWindow_FirstName_Field}
    Run Keyword And Continue On Failure    Validate Loan IQ Details    ${sContact_LastName}     ${ContactDetailWindow_LastName_Field}
    Run Keyword And Continue On Failure    Validate Loan IQ Details    ${sContact_PreferredLanguage}     ${ContactDetailWindow_PreferredLanguage_Field}
    Run Keyword And Continue On Failure    Validate Loan IQ Details    ${sContact_PrimaryPhone}     ${ContactDetailWindow_PrimaryPhone_Field}
         
Select Product in the Contact Details under Profile Tab
    [Documentation]    This keyword allows selection of Products to the Details of a Contact of a Customer
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards
    [Arguments]    ${sProductSBLC_Checkbox}=OFF    ${sProductLoan_Checkbox}=OFF

    Run Keyword If    '${sProductSBLC_Checkbox}' != 'OFF'    Mx LoanIQ Check Or Uncheck    ${ContactDetailWindow_ProductSBLC_Checkbox}    ON    
    Run Keyword If    '${sProductLoan_Checkbox}' != 'OFF'    Mx LoanIQ Check Or Uncheck    ${ContactDetailWindow_ProductLoan_Checkbox}    ON
           
Select Balance Type in the Contact Details under Profile Tab    
    [Documentation]    This keyword allows selection of Balance Type to the Details of a Contact of a Customer
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards
    [Arguments]    ${sBalanceType_Principal_Checkbox}=OFF    ${sBalanceType_Interest_Checkbox}=OFF    ${sBalanceType_Fees_Checkbox}=OFF

    Run Keyword If    '${sBalanceType_Principal_Checkbox}' != 'OFF'    Mx LoanIQ Check Or Uncheck    ${ContactDetailWindow_BalanceType_Principal_Checkbox}    ON
    Run Keyword If    '${sBalanceType_Interest_Checkbox}' != 'OFF'    Mx LoanIQ Check Or Uncheck    ${ContactDetailWindow_BalanceType_Interest_Checkbox}    ON
    Run Keyword If    '${sBalanceType_Fees_Checkbox}' != 'OFF'    Mx LoanIQ Check Or Uncheck    ${ContactDetailWindow_BalanceType_Fees_Checkbox}    ON

Select Purpose in the Contact Details under Profile Tab
    [Documentation]    This keyword adds Purpose to the Details of a Contact of a Customer
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards
    [Arguments]    ${sContact_PurposeType}=None

    Mx LoanIQ Click    ${ContactDetailWindow_Purposes_Button}
    Mx LoanIQ Activate    ${ContactPurposeWindow}
    Validate Window Title    Contact Purpose Selection List 
    Mx LoanIQ Activate    ${ContactPurposeWindow}
    Run Keyword If    '${sContact_PurposeType}' != 'None'    Mx LoanIQ Select String    ${ContactPurposeWindow_Available_List}    ${sContact_PurposeType}        
    Mx LoanIQ Click    ${ContactPurposeWindow_OkButton}
    Mx LoanIQ Activate    ${ContactDetailWindow}
    
Select Address in the Contact Details under Profile Tab    
    [Documentation]    This keyword adds Purpose to the Details of a Contact of a Customer
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards
    [Arguments]    ${sAddress_Code}=None

    Mx LoanIQ Select Window Tab    ${LIQ_Active_ContactDetail_TabSelection}    Addresses
    Run Keyword If    '${sAddress_Code}' != 'None'    Mx LoanIQ Select Combo Box Value    ${LIQ_Active_ContactDetail_MailingAddress_DropdownField}    ${sAddress_Code}
    
Select Notification Method in the Contact Details under Profile Tab
    [Documentation]    This keyword adds Notification Method to the Details of a Contact of a Customer
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards
    [Arguments]    ${sContactNotice_Method}=None    ${sContact_Email}=None
    
    Mx LoanIQ Click    ${ContactDetailWindow_Notification_AddButton}
    Mx LoanIQ Activate    ${ContactNoticeWindow}
    Validate Contact Notice Method(s) Selection Window
    Run Keyword If    '${sContactNotice_Method}' != 'None'    Mx LoanIQ Select Combo Box Value    ${ContactNoticeWindow_AvailableMethod_Field}    ${sContactNotice_Method}
    Run Keyword If    '${sContact_Email}' != 'None'    mx LoanIQ enter    ${ContactNoticeWindow_Email_Field}    ${sContact_Email}   
    Mx Native Type    {BACKSPACE}
    Mx LoanIQ Click    ${ContactNoticeWindow_OkButton} 
    Mx LoanIQ Activate    ${ContactDetailWindow}
        
Validate Contact Notice Method(s) Selection Window
      [Documentation]    This keyword validates the Window Name of  Contact Notice Method(s) Selection Window 
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and fixed hardcoded locator

    Run Keyword And Continue On Failure     Mx LoanIQ Verify Object Exist    ${ContactNoticeMethodWindow}    VerificationData="Yes"
    ${result}    Run Keyword And Return Status    Run Keyword And Continue On Failure     Mx LoanIQ Verify Object Exist    ${ContactNoticeMethodWindow}    VerificationData="Yes"
    Run Keyword If   '${result}'=='True'    Log    "Contact Notice Method(s) Selection" window has been displayed. 
    ...     ELSE     Log    "Contact Notice Method(s) Selection" window has been NOT displayed.
    
Complete Location under Profile Tab    
    [Documentation]    This keyword completes the location of a Customer that has a Borrower Profile
    ...    @author: ghabal
    ...    @update: amansuet    19MAY2020    - added acquire argument and take screenshot keywords and remove unused keyword
    [Arguments]    ${sProfile_Type}    ${sCustomer_Location}

    ### Keyword Pre-processing ###
    ${Profile_Type}    Acquire Argument Value    ${sProfile_Type}
    ${Customer_Location}    Acquire Argument Value    ${sCustomer_Location}

    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    Profiles
    Mx LoanIQ Click    ${CompleteLocation_Button}
    Mx LoanIQ Optional Select    ${Profile_Grid}    ${Profile_Type}
    Read Data and Validate 'Complete Location' under Status column in Profile Tab    ${Customer_Location}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ActiveCustomerWindow_ProfilesTab

Read Data and Validate 'Complete Location' under Status column in Profile Tab
    [Documentation]    This keyword validates the 'Complete Location' under Status column in Profile Tab against from excel data 
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and fixed hardcoded locator
    [Arguments]    ${sCustomer_Location}

    ${Customer_Location}    Replace Variables    ${sCustomer_Location}
    ${LIQ_Active_Customer_Notebook_ProfileTab_CompleteLocationStatus_Grid}    Replace Variables    ${LIQ_Active_Customer_Notebook_ProfileTab_CompleteLocationStatus_Grid}

    Run Keyword And Continue On Failure        Mx LoanIQ Verify Object Exist    ${LIQ_Active_Customer_Notebook_ProfileTab_CompleteLocationStatus_Grid}    VerificationData="Yes"
    ${result}    Run Keyword And Return Status    Run Keyword And Continue On Failure        Mx LoanIQ Verify Object Exist    ${LIQ_Active_Customer_Notebook_ProfileTab_CompleteLocationStatus_Grid}    VerificationData="Yes"
    Run Keyword If   '${result}'=='True'    Log   "Complete" is displayed under "Status" column
    ...     ELSE    Log   "Complete" is NOT displayed under "Status" column      
  
Add DDA/IMT/RTGS Remittance Instructions   
    [Documentation]    This keyword adds DDA/IMT/RTGS Remittance Instructions to a specified location
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards
    [Arguments]    ${sCustomer_Location}    ${sRemittanceInstruction_DDAMethod}    ${sRemittanceInstruction_DDADescriptionAUD}    ${sRemittanceInstruction_DDAAccountName}    ${sRemittanceInstruction_DDAAccountNumber}    ${sRemittanceInstruction_DDACurrencyAUD}
    ...    ${sRemittanceInstruction_DirectionSelected}    ${sRemittanceInstruction_IMTMethod}     ${sLIQCustomer_ShortName}   
    ...    ${sRemittanceInstruction_IMTDescriptionUSD}    ${sRemittanceInstruction_IMTCurrencyUSD} 
    ...    ${sIMT_MessageCode}    ${sBOC_Level}    ${sRemittanceInstruction_RTGSDescriptionAUD}    ${sRemittanceInstruction_RTGSMethod}    ${sRemittanceInstruction_RTGSCurrencyAUD}
          
    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    Profiles
    Mx LoanIQ Click    ${RemittanceInstructions_Button}
    Add DDA-AUD Remittance Instruction    ${sCustomer_Location}        ${sRemittanceInstruction_DDAMethod}    ${sRemittanceInstruction_DDADescriptionAUD}    ${sRemittanceInstruction_DDAAccountName}    ${sRemittanceInstruction_DDAAccountNumber}    ${sRemittanceInstruction_DDACurrencyAUD}        ${sRemittanceInstruction_DirectionSelected}
    Add IMT-USD Remittance Instruction    ${sCustomer_Location}    ${sRemittanceInstruction_IMTMethod}    ${sRemittanceInstruction_IMTDescriptionUSD}    ${sRemittanceInstruction_IMTCurrencyUSD}    ${sRemittanceInstruction_DirectionSelected}    ${sIMT_MessageCode}    ${sBOC_Level}
    Add RTGS-AUD Remittance Instruction    ${sCustomer_Location}    ${sRemittanceInstruction_RTGSMethod}    ${sRemittanceInstruction_RTGSDescriptionAUD}    ${sRemittanceInstruction_RTGSCurrencyAUD}    ${sRemittanceInstruction_DirectionSelected}    ${sIMT_MessageCode}        ${sBOC_Level}
    Mx LoanIQ Click    ${RemittanceList_Window_ExitButton}
    Validate 'Active Customer' Window    ${sLIQCustomer_ShortName}

Add DDA Remittance Instruction
    [Documentation]    This keyword adds DDA Remittance Instruction to the Details of a Contact of a Customer
    ...    @author: ghabal
    ...    @update: amansuet    23APR2020    added keyword pre and post processing
    ...    @update: amansuet    19MAY2020    - added acquire argument and take screenshot keywords and remove unused keyword
    [Arguments]    ${sCustomer_Location}    ${sRemittanceInstruction_DDAMethod}    ${sRemittanceInstruction_DDADescriptionAUD}    ${sRemittanceInstruction_DDAAccountName}    ${sRemittanceInstruction_DDAAccountNumber}    ${sRemittanceInstruction_DDACurrencyAUD}    
    ...    ${bRI_ProductLoan_Checkbox}    ${bRI_ProductSBLC_Checkbox}    ${bRI_FromCust_Checkbox}    ${bRI_ToCust_Checkbox}    ${bRI_BalanceType_Principal_Checkbox}    ${bRI_BalanceType_Interest_Checkbox}    ${bRI_BalanceType_Fees_Checkbox}    ${bRI_AutoDoIt_Checkbox}
    
    ### Keyword Pre-processing ###
    ${Customer_Location}    Acquire Argument Value    ${sCustomer_Location}
    ${RemittanceInstruction_DDAMethod}    Acquire Argument Value    ${sRemittanceInstruction_DDAMethod}
    ${RemittanceInstruction_DDADescriptionAUD}    Acquire Argument Value    ${sRemittanceInstruction_DDADescriptionAUD}    ${ARG_TYPE_UNIQUE_DIGIT}
    ${RemittanceInstruction_DDAAccountName}    Acquire Argument Value    ${sRemittanceInstruction_DDAAccountName}
    ${RemittanceInstruction_DDAAccountNumber}    Acquire Argument Value    ${sRemittanceInstruction_DDAAccountNumber}
    ${RemittanceInstruction_DDACurrencyAUD}    Acquire Argument Value    ${sRemittanceInstruction_DDACurrencyAUD}
    ${RI_ProductLoan_Checkbox}    Acquire Argument Value    ${bRI_ProductLoan_Checkbox}
    ${RI_ProductSBLC_Checkbox}    Acquire Argument Value    ${bRI_ProductSBLC_Checkbox}
    ${RI_FromCust_Checkbox}    Acquire Argument Value    ${bRI_FromCust_Checkbox}
    ${RI_ToCust_Checkbox}    Acquire Argument Value    ${bRI_ToCust_Checkbox}
    ${RI_BalanceType_Principal_Checkbox}    Acquire Argument Value    ${bRI_BalanceType_Principal_Checkbox}
    ${RI_BalanceType_Interest_Checkbox}    Acquire Argument Value    ${bRI_BalanceType_Interest_Checkbox}
    ${RI_BalanceType_Fees_Checkbox}    Acquire Argument Value    ${bRI_BalanceType_Fees_Checkbox}
    ${RI_AutoDoIt_Checkbox}    Acquire Argument Value    ${bRI_AutoDoIt_Checkbox}
    
    Mx LoanIQ Click    ${RemittanceList_Window_AddButton}
    Mx LoanIQ Activate    ${RemittanceList_Window_AddRemittanceInstruction_Window}
    Validate Window Title    Add Remittance Instruction
    Mx LoanIQ Click    ${RemittanceList_Window_AddRemittanceInstruction_OkButton} 
    Validate Remittance Instructions Detail Window    ${Customer_Location}
    Adding DDA Remittance Instructions Details    ${RemittanceInstruction_DDAMethod}    ${RemittanceInstruction_DDADescriptionAUD}    ${RemittanceInstruction_DDAAccountName}    ${RemittanceInstruction_DDAAccountNumber}    ${RemittanceInstruction_DDACurrencyAUD}
    ...    ${RI_ProductLoan_Checkbox}    ${RI_ProductSBLC_Checkbox}    ${RI_FromCust_Checkbox}    ${RI_ToCust_Checkbox}    ${RI_BalanceType_Principal_Checkbox}    ${RI_BalanceType_Interest_Checkbox}    ${RI_BalanceType_Fees_Checkbox}    ${RI_AutoDoIt_Checkbox}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/DDARemittanceInstructionsDetailWindow

    Send Remittance Instruction to Approval
    Mx LoanIQ Select    ${LIQ_RemittanceInstruction_Notebook_FileMenu_ExitMenu}

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRemittanceInstruction_DDADescriptionAUD}    ${RemittanceInstruction_DDADescriptionAUD}

Add IMT Remittance Instruction
    [Documentation]    This keyword adds IMT Remittance Instruction to the Details of a Contact of a Customer
    ...    @author: ghabal
    ...    @update: amansuet    23APR2020    added keyword pre and post processing
    ...    @update: amansuet    19MAY2020    - added acquire argument and take screenshot keywords and remove unused keyword
    [Arguments]    ${sCustomer_Location}        ${sRemittanceInstruction_IMTMethod}    ${sRemittanceInstruction_IMTDescriptionUSD}    ${sRemittanceInstruction_IMTCurrencyUSD}        ${sRemittanceInstruction_DirectionSelected}    ${sIMT_MessageCode}    ${sBOC_Level}
    ...    ${bRI_FromCust_Checkbox}    ${bRI_AutoDoIt_Checkbox}    ${bRI_SendersCorrespondent_Checkbox} 
    
    ### Keyword Pre-processing ###
    ${Customer_Location}    Acquire Argument Value    ${sCustomer_Location}
    ${RemittanceInstruction_IMTMethod}    Acquire Argument Value    ${sRemittanceInstruction_IMTMethod}
    ${RemittanceInstruction_IMTDescriptionUSD}    Acquire Argument Value    ${sRemittanceInstruction_IMTDescriptionUSD}    ${ARG_TYPE_UNIQUE_DIGIT}
    ${RemittanceInstruction_IMTCurrencyUSD}    Acquire Argument Value    ${sRemittanceInstruction_IMTCurrencyUSD}
    ${RemittanceInstruction_DirectionSelected}    Acquire Argument Value    ${sRemittanceInstruction_DirectionSelected}
    ${IMT_MessageCode}    Acquire Argument Value    ${sIMT_MessageCode}
    ${BOC_Level}    Acquire Argument Value    ${sBOC_Level}
    ${RI_FromCust_Checkbox}    Acquire Argument Value    ${bRI_FromCust_Checkbox}
    ${RI_AutoDoIt_Checkbox}    Acquire Argument Value    ${bRI_AutoDoIt_Checkbox}
    ${RI_SendersCorrespondent_Checkbox}    Acquire Argument Value    ${bRI_SendersCorrespondent_Checkbox}

    Mx LoanIQ Click    ${RemittanceList_Window_AddButton}
    Mx LoanIQ Activate    ${RemittanceList_Window_AddRemittanceInstruction_Window}
    Validate Window Title    Add Remittance Instruction
    Mx LoanIQ Click    ${RemittanceList_Window_AddRemittanceInstruction_OkButton} 
    Adding IMT Remittance Instructions_Details    ${RemittanceInstruction_IMTMethod}    ${RemittanceInstruction_IMTDescriptionUSD}    ${RemittanceInstruction_IMTCurrencyUSD}    ${RemittanceInstruction_DirectionSelected}    ${IMT_MessageCode}    ${BOC_Level}
    ...    ${RI_FromCust_Checkbox}    ${RI_AutoDoIt_Checkbox}    ${RI_SendersCorrespondent_Checkbox}  
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/IMTRemittanceInstructionsDetailWindow
    Send Remittance Instruction to Approval
    Mx LoanIQ Select    ${LIQ_RemittanceInstruction_Notebook_FileMenu_ExitMenu}   
    Read Excel Data and Validate Remittance Instructions Data Added in the Remittance List Window     ${RemittanceInstruction_IMTDescriptionUSD}    ${Customer_Location}
 
    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRemittanceInstruction_IMTDescriptionUSD}    ${RemittanceInstruction_IMTDescriptionUSD}

Add RTGS Remittance Instruction
    [Documentation]    This keyword adds RTGS-AUD Remittance Instruction to the Details of a Contact of a Customer
    ...    @author: ghabal
    ...    @update: amansuet    23APR2020    added keyword pre and post processing
    ...    @update: amansuet    19MAY2020    - added acquire argument and take screenshot keywords and remove unused keyword
    [Arguments]    ${sCustomer_Location}    ${sRemittanceInstruction_RTGSMethod}    ${sRemittanceInstruction_RTGSDescriptionAUD}    ${sRemittanceInstruction_RTGSCurrencyAUD}    ${sRemittanceInstruction_DirectionSelected}    ${sIMT_MessageCode}        ${sBOC_Level}
    ...    ${bRI_FromCust_Checkbox}    ${bRI_AutoDoIt_Checkbox}    ${bRI_SendersCorrespondent_Checkbox}
    
    ### Keyword Pre-processing ###
    ${Customer_Location}    Acquire Argument Value    ${sCustomer_Location}
    ${RemittanceInstruction_RTGSMethod}    Acquire Argument Value    ${sRemittanceInstruction_RTGSMethod}
    ${RemittanceInstruction_RTGSDescriptionAUD}    Acquire Argument Value    ${sRemittanceInstruction_RTGSDescriptionAUD}    ${ARG_TYPE_UNIQUE_DIGIT}
    ${RemittanceInstruction_RTGSCurrencyAUD}    Acquire Argument Value    ${sRemittanceInstruction_RTGSCurrencyAUD}
    ${RemittanceInstruction_DirectionSelected}    Acquire Argument Value    ${sRemittanceInstruction_DirectionSelected}
    ${IMT_MessageCode}    Acquire Argument Value    ${sIMT_MessageCode}
    ${BOC_Level}    Acquire Argument Value    ${sBOC_Level}
    ${RI_FromCust_Checkbox}    Acquire Argument Value    ${bRI_FromCust_Checkbox}
    ${RI_AutoDoIt_Checkbox}    Acquire Argument Value    ${bRI_AutoDoIt_Checkbox}
    ${RI_SendersCorrespondent_Checkbox}    Acquire Argument Value    ${bRI_SendersCorrespondent_Checkbox}

    Mx LoanIQ Click    ${RemittanceList_Window_AddButton}
    Mx LoanIQ Activate    ${RemittanceList_Window_AddRemittanceInstruction_Window}
    Validate Window Title    Add Remittance Instruction
    Mx LoanIQ Click    ${RemittanceList_Window_AddRemittanceInstruction_OkButton} 
    Adding RTGS Remittance Instructions_Details    ${RemittanceInstruction_RTGSMethod}    ${RemittanceInstruction_RTGSDescriptionAUD}   ${RemittanceInstruction_RTGSCurrencyAUD}        ${RemittanceInstruction_DirectionSelected}    ${IMT_MessageCode}    ${BOC_Level}
    ...    ${RI_FromCust_Checkbox}    ${RI_AutoDoIt_Checkbox}    ${RI_SendersCorrespondent_Checkbox}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/RTGSRemittanceInstructionsDetailWindow
    Send Remittance Instruction to Approval
    Mx LoanIQ Select    ${LIQ_RemittanceInstruction_Notebook_FileMenu_ExitMenu}  
    Read Excel Data and Validate Remittance Instructions Data Added in the Remittance List Window     ${RemittanceInstruction_RTGSDescriptionAUD}    ${Customer_Location}

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRemittanceInstruction_RTGSDescriptionAUD}    ${RemittanceInstruction_RTGSDescriptionAUD}

Add DDA-AUD Remittance Instruction
    [Documentation]    This keyword adds DDA-AUD Remittance Instruction to the Details of a Contact of a Customer
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and removed unused keywords
    [Arguments]    ${sCustomer_Location}    ${sRemittanceInstruction_DDAMethod}    ${sRemittanceInstruction_DDADescriptionAUD}    ${sRemittanceInstruction_DDAAccountName}    ${sRemittanceInstruction_DDAAccountNumber}    ${sRemittanceInstruction_DDACurrencyAUD}    ${sRemittanceInstruction_DirectionSelected}
    
    Mx LoanIQ Click    ${RemittanceList_Window_AddButton}
    Mx LoanIQ Activate    ${RemittanceList_Window_AddRemittanceInstruction_Window}
    Validate Window Title    Add Remittance Instruction
    Mx LoanIQ Click    ${RemittanceList_Window_AddRemittanceInstruction_OkButton} 
    Adding DDA-AUD Remittance Instructions_Details    ${sRemittanceInstruction_DDAMethod}    ${sRemittanceInstruction_DDADescriptionAUD}    ${sRemittanceInstruction_DDAAccountName}    ${sRemittanceInstruction_DDAAccountNumber}    ${sRemittanceInstruction_DDACurrencyAUD}    ${sRemittanceInstruction_DirectionSelected}
    Send Remittance Instruction to Approval
    Mx LoanIQ Select    ${LIQ_RemittanceInstruction_Notebook_FileMenu_ExitMenu}
    Read Excel Data and Validate Remittance Instructions Data Added in the Remittance List Window     ${sRemittanceInstruction_DDADescriptionAUD}    ${sCustomer_Location}

Add IMT-USD Remittance Instruction
    [Documentation]    This keyword adds IMT-USD Remittance Instruction to the Details of a Contact of a Customer
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and removed unused keywords
    [Arguments]    ${sCustomer_Location}    ${sRemittanceInstruction_IMTMethod}    ${sRemittanceInstruction_IMTDescriptionUSD}    ${sRemittanceInstruction_IMTCurrencyUSD}    ${sRemittanceInstruction_DirectionSelected}    ${sIMT_MessageCode}    ${sBOC_Level} 
    
    Mx LoanIQ Click    ${RemittanceList_Window_AddButton}
    Mx LoanIQ Activate    ${RemittanceList_Window_AddRemittanceInstruction_Window}
    Validate Window Title    Add Remittance Instruction
    Mx LoanIQ Click    ${RemittanceList_Window_AddRemittanceInstruction_OkButton} 
    Adding IMT-USD Remittance Instructions_Details    ${sRemittanceInstruction_IMTMethod}    ${sRemittanceInstruction_IMTDescriptionUSD}    ${sRemittanceInstruction_IMTCurrencyUSD}    ${sRemittanceInstruction_DirectionSelected}    ${sIMT_MessageCode}    ${sBOC_Level}
    Send Remittance Instruction to Approval
    Mx LoanIQ Select    ${LIQ_RemittanceInstruction_Notebook_FileMenu_ExitMenu}
    Read Excel Data and Validate Remittance Instructions Data Added in the Remittance List Window     ${sRemittanceInstruction_IMTDescriptionUSD}    ${sCustomer_Location}
    
Add RTGS-AUD Remittance Instruction
    [Documentation]    This keyword adds RTGS-AUD Remittance Instruction to the Details of a Contact of a Customer
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and removed unused keywords
    [Arguments]    ${sCustomer_Location}    ${sRemittanceInstruction_RTGSMethod}    ${sRemittanceInstruction_RTGSDescriptionAUD}    ${sRemittanceInstruction_RTGSCurrencyAUD}    ${sRemittanceInstruction_DirectionSelected}    ${sIMT_MessageCode}    ${sBOC_Level}
    
    Mx LoanIQ Click    ${RemittanceList_Window_AddButton}
    Mx LoanIQ Activate    ${RemittanceList_Window_AddRemittanceInstruction_Window}
    Validate Window Title    Add Remittance Instruction
    Mx LoanIQ Click    ${RemittanceList_Window_AddRemittanceInstruction_OkButton} 
    Adding RTGS-AUD Remittance Instructions_Details    ${sRemittanceInstruction_RTGSMethod}    ${sRemittanceInstruction_RTGSDescriptionAUD}    ${sRemittanceInstruction_RTGSCurrencyAUD}    ${sRemittanceInstruction_DirectionSelected}    ${sIMT_MessageCode}    ${sBOC_Level}
    Send Remittance Instruction to Approval
    Mx LoanIQ Select    ${LIQ_RemittanceInstruction_Notebook_FileMenu_ExitMenu}
    Read Excel Data and Validate Remittance Instructions Data Added in the Remittance List Window     ${sRemittanceInstruction_RTGSDescriptionAUD}    ${sCustomer_Location}
    
Validate Remittance List for 'Location' Window
    [Documentation]    This keyword validates the Window Name of Remittance List for 'Location' Window
    ...    @author: ghabal
    [Arguments]    ${Customer_Location}
    ##To Check
    mx LoanIQ activate    ${RemittanceList_Window}
    Run Keyword And Continue On Failure     Mx LoanIQ Verify Object Exist    JavaWindow("title:=Remittance List for ${Customer_Location}","tagname:=Remittance List for ${Customer_Location}")    VerificationData="Yes"
    ${result}    Run Keyword And Return Status    Run Keyword And Continue On Failure     Mx LoanIQ Verify Object Exist    JavaWindow("title:=Remittance List for ${Customer_Location}","tagname:=Remittance List for ${Customer_Location}")    VerificationData="Yes"
    Run Keyword If   '${result}'=='True'    Log    "Remittance List for ${Customer_Location}" window has been displayed.
    ...     ELSE    Log    "Remittance List for ${Customer_Location}" window has been NOT displayed.   
 
Validate Remittance Instructions Detail Window
    [Documentation]    This keyword validates the Window Name of Remittance Instructions Detail Window
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and fixed hardcoded locator
    [Arguments]    ${sCustomer_Location}

    Mx LoanIQ Activate   ${RemittanceList_Window_RemittanceInstructionsDetail_Window}

    ${Customer_Location}    Replace Variables    ${sCustomer_Location}
    ${RemittanceList_Window_RemittanceInstructionsDetail_CustomerLocation_Window}    Replace Variables    ${RemittanceList_Window_RemittanceInstructionsDetail_CustomerLocation_Window}

    Run Keyword And Continue On Failure     Mx LoanIQ Verify Object Exist    ${RemittanceList_Window_RemittanceInstructionsDetail_Window}    VerificationData="Yes"
    ${result}    Run Keyword And Return Status    Run Keyword And Continue On Failure     Mx LoanIQ Verify Object Exist    ${RemittanceList_Window_RemittanceInstructionsDetail_CustomerLocation_Window}    VerificationData="Yes"
    Run Keyword If   '${result}'=='True'    Log    "Remittance Instructions Detail -- ${Customer_Location} -- <Profile_Type>" window has been displayed.
    ...     ELSE    Log    "Remittance Instructions Detail -- ${Customer_Location} -- <Profile_Type>" window has been NOT displayed.     

Adding DDA Remittance Instructions Details
    [Documentation]    This keyword adds details of Simplified DDA-AUD Remittance Instruction to the Details of a Contact of a Customer
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and removed unused keywords
    [Arguments]    ${sRemittanceInstruction_DDAMethod}=None    ${sRemittanceInstruction_DDADescriptionAUD}=None    ${sRemittanceInstruction_DDAAccountName}=None    ${sRemittanceInstruction_DDAAccountNumber}=None    ${sRemittanceInstruction_DDACurrencyAUD}=None
    ...    ${sRI_ProductLoan_Checkbox}=OFF    ${sRI_ProductSBLC_Checkbox}=OFF    ${sRI_FromCust_Checkbox}=OFF    ${sRI_ToCust_Checkbox}=ON    ${sRI_BalanceType_Principal_Checkbox}=OFF    ${sRI_BalanceType_Interest_Checkbox}=OFF    ${sRI_BalanceType_Fees_Checkbox}=OFF    ${sRI_AutoDoIt_Checkbox}=OFF
    
    Mx LoanIQ Activate   ${RemittanceList_Window_RemittanceInstructionsDetail_Window}
    Mx LoanIQ Select Window Tab    ${RemittanceList_Window_RemittanceInstructionsDetail__Notebook_TabSelection}    General
    
    Run Keyword If    '${sRemittanceInstruction_DDAMethod}' == '${sRemittanceInstruction_DDAMethod}'    Mx LoanIQ Select Combo Box Value    ${RemittanceList_Window_RemittanceInstructionsDetail_MethodType}    ${sRemittanceInstruction_DDAMethod}
    Run Keyword If    '${sRemittanceInstruction_DDADescriptionAUD}' != 'None'    Mx LoanIQ Enter    ${RemittanceList_Window_RemittanceInstructionsDetail_Description}    ${sRemittanceInstruction_DDADescriptionAUD}
    Run Keyword If    '${sRemittanceInstruction_DDAAccountName}' != 'None'    Mx LoanIQ Enter    ${RemittanceList_Window_RemittanceInstructionsDetail_DDAAccountName}    ${sRemittanceInstruction_DDAAccountName}
    Run Keyword If    '${sRemittanceInstruction_DDAAccountNumber}' != 'None'    Mx LoanIQ Enter    ${RemittanceList_Window_RemittanceInstructionsDetail_DDAAccountNumber}    ${sRemittanceInstruction_DDAAccountNumber}
    Run Keyword If    '${sRemittanceInstruction_DDACurrencyAUD}' != 'None'    Mx LoanIQ Select Combo Box Value    ${RemittanceList_Window_RemittanceInstructionsDetail_Currency}    ${sRemittanceInstruction_DDACurrencyAUD}
    Run Keyword If    '${sRI_ProductLoan_Checkbox}' != 'ON'    Mx LoanIQ Check Or Uncheck    ${RemittanceList_Window_RemittanceInstructionsDetail_ProductLoan_Checkbox}    OFF
    Run Keyword If    '${sRI_ProductSBLC_Checkbox}' != 'ON'    Mx LoanIQ Check Or Uncheck    ${RemittanceList_Window_RemittanceInstructionsDetail_ProductSBLC_Checkbox}    OFF
    Run Keyword If    '${sRI_FromCust_Checkbox}' != 'OFF'    Mx LoanIQ Check Or Uncheck    ${RemittanceList_Window_RemittanceInstructionsDetail_Direction_FromCust_Checkbox}    ON 
    Run Keyword If    '${sRI_ToCust_Checkbox}' != 'ON'    Mx LoanIQ Check Or Uncheck    ${RemittanceList_Window_RemittanceInstructionsDetail_Direction_ToCust_Checkbox}    OFF
    Run Keyword If    '${sRI_BalanceType_Principal_Checkbox}' != 'ON'    Mx LoanIQ Check Or Uncheck    ${RemittanceList_Window_RemittanceInstructionsDetail_BalanceType_Principal_Checkbox}    OFF
    Run Keyword If    '${sRI_BalanceType_Interest_Checkbox}' != 'ON'    Mx LoanIQ Check Or Uncheck    ${RemittanceList_Window_RemittanceInstructionsDetail_BalanceType_Interest_Checkbox}    OFF
    Run Keyword If    '${sRI_BalanceType_Fees_Checkbox}' != 'ON'    Mx LoanIQ Check Or Uncheck    ${RemittanceList_Window_RemittanceInstructionsDetail_BalanceType_Fees_Checkbox}    OFF
    Run Keyword If    '${sRI_AutoDoIt_Checkbox}' != 'OFF'    Mx LoanIQ Check Or Uncheck    ${RemittanceList_Window_RemittanceInstructionsDetail_AutoDoIt_Checkbox}    ON
    
    Mx LoanIQ Select    ${LIQ_RemittanceInstruction_Notebook_FileMenu_SaveMenu}

Adding IMT Remittance Instructions_Details
    [Documentation]    This keyword adds details of Simplified DDA-AUD Remittance Instruction to the Details of a Contact of a Customer
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and removed unused keywords
    [Arguments]    ${sRemittanceInstruction_IMTMethod}    ${sRemittanceInstruction_IMTDescriptionUSD}    ${sRemittanceInstruction_IMTCurrencyUSD}    ${sRemittanceInstruction_DirectionSelected}    ${sIMT_MessageCode}    ${sBOC_Level}
    ...    ${sRI_FromCust_Checkbox}    ${sRI_AutoDoIt_Checkbox}    ${sRI_SendersCorrespondent_Checkbox}

    Mx LoanIQ Activate   ${RemittanceList_Window_RemittanceInstructionsDetail_Window}
    Mx LoanIQ Select Window Tab    ${RemittanceList_Window_RemittanceInstructionsDetail__Notebook_TabSelection}    General
    
    Run Keyword If    '${sRemittanceInstruction_IMTMethod}' == '${sRemittanceInstruction_IMTMethod}'    Mx LoanIQ Select Combo Box Value    ${RemittanceList_Window_RemittanceInstructionsDetail_MethodType}    ${sRemittanceInstruction_IMTMethod}
    Run Keyword If    '${sRemittanceInstruction_IMTDescriptionUSD}' != 'None'    Mx LoanIQ Enter    ${RemittanceList_Window_RemittanceInstructionsDetail_Description}    ${sRemittanceInstruction_IMTDescriptionUSD}
    Run Keyword If    '${sRemittanceInstruction_IMTCurrencyUSD}' != 'None'    Mx LoanIQ Select Combo Box Value    ${RemittanceList_Window_RemittanceInstructionsDetail_Currency}    ${sRemittanceInstruction_IMTCurrencyUSD}
    Run Keyword If    '${sRI_FromCust_Checkbox}' != 'OFF'    Mx LoanIQ Check Or Uncheck    ${RemittanceList_Window_RemittanceInstructionsDetail_Direction_FromCust_Checkbox}    ON
    Run Keyword If    '${sRI_AutoDoIt_Checkbox}' != 'OFF'    Mx LoanIQ Check Or Uncheck    ${RemittanceList_Window_RemittanceInstructionsDetail_AutoDoIt_Checkbox}    ON
    Mx LoanIQ Click    ${RemittanceList_Window_RemittanceInstructionsDetail_AddButton}
    Mx LoanIQ Click    ${LIQ_Warning_Yes_Button}
    
    Run Keyword If    '${sIMT_MessageCode}' != 'None'    Mx LoanIQ Enter   ${RemittanceList_Window_RemittanceInstructionsDetail_SelectMessageType_SearchField}    ${sIMT_MessageCode}
    Mx LoanIQ Click    ${RemittanceList_Window_RemittanceInstructionsDetail_SelectMessageType_OKButton}
    
    Run Keyword If    '${sRI_SendersCorrespondent_Checkbox}' != 'OFF'    Mx LoanIQ Check Or Uncheck    ${RemittanceList_Window_RemittanceInstructionsDetail_IMT_SendersCorrespondent_Checkbox}    ON
    Run Keyword If    '${sBOC_Level}' == '${sBOC_Level}'    Mx LoanIQ Select Combo Box Value    ${RemittanceList_Window_RemittanceInstructionsDetail_IMT_BankOperationCode}    ${sBOC_Level}
    Mx LoanIQ Click    ${RemittanceList_Window_RemittanceInstructionsDetail_IMT_OKButton}
    Mx LoanIQ Select    ${LIQ_RemittanceInstruction_Notebook_FileMenu_SaveMenu}
    Mx LoanIQ Click    ${LIQ_Warning_OK_Button}

Adding RTGS Remittance Instructions_Details
    [Documentation]    This keyword adds details of Simplified DDA-AUD Remittance Instruction to the Details of a Contact of a Customer
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and removed unused keywords
    [Arguments]    ${sRemittanceInstruction_RTGSMethod}    ${sRemittanceInstruction_RTGSDescriptionAUD}   ${sRemittanceInstruction_RTGSCurrencyAUD}    ${sRemittanceInstruction_DirectionSelected}    ${sIMT_MessageCode}    ${sBOC_Level}
    ...    ${sRI_FromCust_Checkbox}    ${sRI_AutoDoIt_Checkbox}    ${sRI_SendersCorrespondent_Checkbox}

    Mx LoanIQ Activate   ${RemittanceList_Window_RemittanceInstructionsDetail_Window}
    Mx LoanIQ Select Window Tab    ${RemittanceList_Window_RemittanceInstructionsDetail__Notebook_TabSelection}    General

    Run Keyword If    '${sRemittanceInstruction_RTGSMethod}' == '${sRemittanceInstruction_RTGSMethod}'    Mx LoanIQ Select Combo Box Value    ${RemittanceList_Window_RemittanceInstructionsDetail_MethodType}    ${sRemittanceInstruction_RTGSMethod}
    Run Keyword If    '${sRemittanceInstruction_RTGSDescriptionAUD}' != 'None'    Mx LoanIQ Enter    ${RemittanceList_Window_RemittanceInstructionsDetail_Description}    ${sRemittanceInstruction_RTGSDescriptionAUD}
    Run Keyword If    '${sRemittanceInstruction_RTGSCurrencyAUD}' != 'None'    Mx LoanIQ Select Combo Box Value    ${RemittanceList_Window_RemittanceInstructionsDetail_Currency}    ${sRemittanceInstruction_RTGSCurrencyAUD}
    Run Keyword If    '${sRI_FromCust_Checkbox}' != 'OFF'    Mx LoanIQ Check Or Uncheck    ${RemittanceList_Window_RemittanceInstructionsDetail_Direction_FromCust_Checkbox}    ON
    Run Keyword If    '${sRI_AutoDoIt_Checkbox}' != 'OFF'    Mx LoanIQ Check Or Uncheck    ${RemittanceList_Window_RemittanceInstructionsDetail_AutoDoIt_Checkbox}    ON
    Mx LoanIQ Click    ${RemittanceList_Window_RemittanceInstructionsDetail_AddButton}
    Mx LoanIQ Click    ${LIQ_Warning_Yes_Button}
    Run Keyword If    '${sIMT_MessageCode}' != 'None'    Mx LoanIQ Enter   ${RemittanceList_Window_RemittanceInstructionsDetail_SelectMessageType_SearchField}    ${sIMT_MessageCode}
    Mx LoanIQ Click    ${RemittanceList_Window_RemittanceInstructionsDetail_SelectMessageType_OKButton}
    Run Keyword If    '${sRI_SendersCorrespondent_Checkbox}' != 'OFF'    Mx LoanIQ Check Or Uncheck    ${RemittanceList_Window_RemittanceInstructionsDetail_IMT_SendersCorrespondent_Checkbox}    ON
    Run Keyword If    '${sBOC_Level}' == '${sBOC_Level}'    Mx LoanIQ Select Combo Box Value    ${RemittanceList_Window_RemittanceInstructionsDetail_IMT_BankOperationCode}    ${sBOC_Level}
    Mx LoanIQ Click    ${RemittanceList_Window_RemittanceInstructionsDetail_IMT_OKButton}
    Mx LoanIQ Select    ${LIQ_RemittanceInstruction_Notebook_FileMenu_SaveMenu}
    Mx LoanIQ Click    ${LIQ_Warning_OK_Button}

Adding DDA-AUD Remittance Instructions_Details
    [Documentation]    This keyword adds details of Simplified DDA-AUD Remittance Instruction to the Details of a Contact of a Customer
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards
    [Arguments]    ${sRemittanceInstruction_DDAMethod}    ${sRemittanceInstruction_DDADescriptionAUD}    ${sRemittanceInstruction_DDAAccountName}    ${sRemittanceInstruction_DDAAccountNumber}    ${sRemittanceInstruction_DDACurrencyAUD}    ${sRemittanceInstruction_DirectionSelected}
    
    Mx LoanIQ Activate   ${RemittanceList_Window_RemittanceInstructionsDetail_Window}
    Mx LoanIQ Select Window Tab    ${RemittanceList_Window_RemittanceInstructionsDetail__Notebook_TabSelection}    General
    Mx LoanIQ Select Combo Box Value    ${RemittanceList_Window_RemittanceInstructionsDetail_MethodType}    ${sRemittanceInstruction_DDAMethod}
    Mx LoanIQ Enter    ${RemittanceList_Window_RemittanceInstructionsDetail_Description}    ${sRemittanceInstruction_DDADescriptionAUD}
    Mx LoanIQ Enter    ${RemittanceList_Window_RemittanceInstructionsDetail_DDAAccountName}    ${sRemittanceInstruction_DDAAccountName}
    Mx LoanIQ Enter    ${RemittanceList_Window_RemittanceInstructionsDetail_DDAAccountNumber}    ${sRemittanceInstruction_DDAAccountNumber}
    Mx LoanIQ Select Combo Box Value    ${RemittanceList_Window_RemittanceInstructionsDetail_Currency}    ${sRemittanceInstruction_DDACurrencyAUD}
    Read Excel Data and Validate DDA-AUD Remittance Instructions Details    ${sRemittanceInstruction_DDAMethod}    ${sRemittanceInstruction_DDADescriptionAUD}    ${sRemittanceInstruction_DDAAccountName}    ${sRemittanceInstruction_DDAAccountNumber}    ${sRemittanceInstruction_DDACurrencyAUD}
    Mx LoanIQ Check Or Uncheck    ${RemittanceList_Window_RemittanceInstructionsDetail_Direction_FromCust_Checkbox}    ON 
    Mx LoanIQ Check Or Uncheck    ${RemittanceList_Window_RemittanceInstructionsDetail_AutoDoIt_Checkbox}    ON
    Validate 'From Cust' and 'Auto Do It' checkboxes    ${sRemittanceInstruction_DirectionSelected}
    Mx LoanIQ Select    ${LIQ_RemittanceInstruction_Notebook_FileMenu_SaveMenu}

Adding IMT-USD Remittance Instructions_Details
    [Documentation]    This keyword adds details of Simplified DDA-AUD Remittance Instruction to the Details of a Contact of a Customer
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards
    [Arguments]    ${sRemittanceInstruction_IMTMethod}    ${sRemittanceInstruction_IMTDescriptionUSD}    ${sRemittanceInstruction_IMTCurrencyUSD}    ${sRemittanceInstruction_DirectionSelected}    ${sIMT_MessageCode}    ${sBOC_Level}    
    
    Mx LoanIQ Activate   ${RemittanceList_Window_RemittanceInstructionsDetail_Window}
    Mx LoanIQ Select Window Tab    ${RemittanceList_Window_RemittanceInstructionsDetail__Notebook_TabSelection}    General
    Mx LoanIQ Select Combo Box Value    ${RemittanceList_Window_RemittanceInstructionsDetail_MethodType}    ${sRemittanceInstruction_IMTMethod}
    Mx LoanIQ Enter    ${RemittanceList_Window_RemittanceInstructionsDetail_Description}    ${sRemittanceInstruction_IMTDescriptionUSD} 
    Mx LoanIQ Select Combo Box Value    ${RemittanceList_Window_RemittanceInstructionsDetail_Currency}    ${sRemittanceInstruction_IMTCurrencyUSD}
    Read Excel Data and Validate IMT-USD Remittance Instructions Details    ${sRemittanceInstruction_IMTMethod}    ${sRemittanceInstruction_IMTDescriptionUSD}    ${sRemittanceInstruction_IMTCurrencyUSD}
    Mx LoanIQ Check Or Uncheck    ${RemittanceList_Window_RemittanceInstructionsDetail_Direction_FromCust_Checkbox}    ON 
    Mx LoanIQ Check Or Uncheck    ${RemittanceList_Window_RemittanceInstructionsDetail_AutoDoIt_Checkbox}    ON
    Validate 'From Cust' and 'Auto Do It' checkboxes    ${sRemittanceInstruction_DirectionSelected}
    Mx LoanIQ Click    ${RemittanceList_Window_RemittanceInstructionsDetail_AddButton}
    Mx LoanIQ Click    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Enter   ${RemittanceList_Window_RemittanceInstructionsDetail_SelectMessageType_SearchField}    ${sIMT_MessageCode}
    Mx LoanIQ Click    ${RemittanceList_Window_RemittanceInstructionsDetail_SelectMessageType_OKButton}
    Mx LoanIQ Check Or Uncheck    ${RemittanceList_Window_RemittanceInstructionsDetail_IMT_SendersCorrespondent_Checkbox}    ON
    Mx LoanIQ Select Combo Box Value    ${RemittanceList_Window_RemittanceInstructionsDetail_IMT_BankOperationCode}    ${sBOC_Level}
    Mx LoanIQ Click    ${RemittanceList_Window_RemittanceInstructionsDetail_IMT_OKButton}
    Mx LoanIQ Select    ${LIQ_RemittanceInstruction_Notebook_FileMenu_SaveMenu}
    Mx LoanIQ Click    ${LIQ_Warning_OK_Button}
    
Adding RTGS-AUD Remittance Instructions_Details
    [Documentation]    This keyword adds details of Simplified DDA-AUD Remittance Instruction to the Details of a Contact of a Customer
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and removed unused keywords
    [Arguments]    ${sRemittanceInstruction_RTGSMethod}    ${sRemittanceInstruction_RTGSDescriptionAUD}    ${sRemittanceInstruction_RTGSCurrencyAUD}    ${sRemittanceInstruction_DirectionSelected}    ${sIMT_MessageCode}    ${sBOC_Level}
    
    Mx LoanIQ Activate   ${RemittanceList_Window_RemittanceInstructionsDetail_Window}
    Mx LoanIQ Select Window Tab    ${RemittanceList_Window_RemittanceInstructionsDetail__Notebook_TabSelection}    General
    Mx LoanIQ Select Combo Box Value    ${RemittanceList_Window_RemittanceInstructionsDetail_MethodType}    ${sRemittanceInstruction_RTGSMethod}
    Mx LoanIQ Enter    ${RemittanceList_Window_RemittanceInstructionsDetail_Description}    ${sRemittanceInstruction_RTGSDescriptionAUD}
    Mx LoanIQ Select Combo Box Value    ${RemittanceList_Window_RemittanceInstructionsDetail_Currency}    ${sRemittanceInstruction_RTGSCurrencyAUD}
    Read Excel Data and Validate IMT-USD Remittance Instructions Details    ${sRemittanceInstruction_RTGSMethod}    ${sRemittanceInstruction_RTGSDescriptionAUD}    ${sRemittanceInstruction_RTGSCurrencyAUD}
    Mx LoanIQ Check Or Uncheck    ${RemittanceList_Window_RemittanceInstructionsDetail_Direction_FromCust_Checkbox}    ON
    Mx LoanIQ Check Or Uncheck    ${RemittanceList_Window_RemittanceInstructionsDetail_AutoDoIt_Checkbox}    ON
    Validate 'From Cust' and 'Auto Do It' checkboxes    ${sRemittanceInstruction_DirectionSelected}
    Mx LoanIQ Click    ${RemittanceList_Window_RemittanceInstructionsDetail_AddButton}
    Mx LoanIQ Click    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Enter   ${RemittanceList_Window_RemittanceInstructionsDetail_SelectMessageType_SearchField}    ${sIMT_MessageCode}
    Mx LoanIQ Click    ${RemittanceList_Window_RemittanceInstructionsDetail_SelectMessageType_OKButton}
    Mx LoanIQ Check Or Uncheck    ${RemittanceList_Window_RemittanceInstructionsDetail_IMT_SendersCorrespondent_Checkbox}    ON
    Mx LoanIQ Select Combo Box Value    ${RemittanceList_Window_RemittanceInstructionsDetail_IMT_BankOperationCode}    ${sBOC_Level}
    Mx LoanIQ Click    ${RemittanceList_Window_RemittanceInstructionsDetail_IMT_OKButton}
    Mx LoanIQ Select    ${LIQ_RemittanceInstruction_Notebook_FileMenu_SaveMenu}
    Mx LoanIQ Click    ${LIQ_Warning_OK_Button}
   
Read Excel Data and Validate DDA-AUD Remittance Instructions Details
     [Documentation]    This keyword validates the DDA-AUD Remittance Instructions Details against from excel data
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards
    [Arguments]    ${sRemittanceInstruction_DDAMethod}    ${sRemittanceInstruction_DDADescriptionAUD}    ${sRemittanceInstruction_DDAAccountName}    ${sRemittanceInstruction_DDAAccountNumber}    ${sRemittanceInstruction_DDACurrencyAUD}

    Run Keyword And Continue On Failure    Validate Loan IQ Details    ${sRemittanceInstruction_DDAMethod}     ${RemittanceList_Window_RemittanceInstructionsDetail_MethodType}
    Run Keyword And Continue On Failure    Validate Loan IQ Details    ${sRemittanceInstruction_DDADescriptionAUD}     ${RemittanceList_Window_RemittanceInstructionsDetail_Description}
    Run Keyword And Continue On Failure    Validate Loan IQ Details    ${sRemittanceInstruction_DDAAccountName}     ${RemittanceList_Window_RemittanceInstructionsDetail_DDAAccountName}
    Run Keyword And Continue On Failure    Validate Loan IQ Details    ${sRemittanceInstruction_DDAAccountNumber}     ${RemittanceList_Window_RemittanceInstructionsDetail_DDAAccountNumber}
    Run Keyword And Continue On Failure    Validate Loan IQ Details    ${sRemittanceInstruction_DDACurrencyAUD}     ${RemittanceList_Window_RemittanceInstructionsDetail_Currency}

Read Excel Data and Validate IMT-USD Remittance Instructions Details
     [Documentation]    This keyword validates the DDA-AUD Remittance Instructions Details against from excel data
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards
    [Arguments]    ${sRemittanceInstruction_IMTMethod}    ${sRemittanceInstruction_IMTDescriptionUSD}    ${sRemittanceInstruction_IMTCurrencyUSD}

    Run Keyword And Continue On Failure    Validate Loan IQ Details    ${sRemittanceInstruction_IMTMethod}     ${RemittanceList_Window_RemittanceInstructionsDetail_MethodType}
    Run Keyword And Continue On Failure    Validate Loan IQ Details    ${sRemittanceInstruction_IMTDescriptionUSD}     ${RemittanceList_Window_RemittanceInstructionsDetail_Description}
    Run Keyword And Continue On Failure    Validate Loan IQ Details    ${sRemittanceInstruction_IMTCurrencyUSD}     ${RemittanceList_Window_RemittanceInstructionsDetail_Currency}

Validate 'From Cust' and 'Auto Do It' checkboxes
    [Documentation]    This keyword validates the 'From Cust' and 'Auto Do It' checkboxes if selected
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards
    [Arguments]    ${sRemittanceInstruction_DirectionSelected}

    Validate if Element is Checked    ${RemittanceList_Window_RemittanceInstructionsDetail_Direction_FromCust_Checkbox}    ${sRemittanceInstruction_DirectionSelected}
    ${result1}    Run Keyword And Return Status    Validate if Element is Checked    ${RemittanceList_Window_RemittanceInstructionsDetail_Direction_FromCust_Checkbox}    ${sRemittanceInstruction_DirectionSelected}
    Validate if Element is Checked    ${RemittanceList_Window_RemittanceInstructionsDetail_AutoDoIt_Checkbox}    Auto Do It
    ${result2}    Run Keyword And Return Status    Validate if Element is Checked    ${RemittanceList_Window_RemittanceInstructionsDetail_AutoDoIt_Checkbox}    Auto Do It
    ${result3}    Run Keyword And Return Status    Run Keyword And Continue On Failure    Should Be Equal   ${result1}   ${result2}
    Run Keyword If   '${result3}'=='True'    Log   '${sRemittanceInstruction_DirectionSelected}' and 'Auto Do It' checkboxes are both checked
    ...     ELSE    Log   '${sRemittanceInstruction_DirectionSelected}' and 'Auto Do It' checkboxes are NOT both checked
    
Read Excel Data and Validate Remittance Instructions Data Added in the Remittance List Window 
    [Documentation]    This keyword validates the Remittance Instructions Data Added in the Remittance List Window against from excel data 
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and removed unused keywords
    ...                                      - fixed hardcoded locators
    [Arguments]    ${RemittanceInstruction_Description}    ${sCustomer_Location}
    
    Mx LoanIQ Activate    ${RemittanceList_Window} 
    Log    Data is added in "Remittance List for ${sCustomer_Location}" window.

    ${result}    Run Keyword And Return Status    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${RemittanceList_Window_ApprovedStatus}    VerificationData="Yes"
    Run Keyword If   '${result}'=='True'    Log    "Approved" status is set to "Y"
    ...     ELSE    Log    "Approved" status is set to "N"
    
Add Servicing Groups under Profile Tab
    [Documentation]    This keyword adds Add Servicing Groups to a Customer
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and removed unused keywords
    [Arguments]    ${sCustomer_Search}    ${sLIQCustomer_ID}    ${sLIQCustomer_ShortName}    ${sProfile_Type}    ${sGroup_Contact}   ${sContact_LastName} 
    ...    ${sRemittanceInstruction_DDADescriptionAUD}    ${sRemittanceInstruction_IMTDescriptionUSD}    ${sRemittanceInstruction_RTGSDescriptionAUD}    ${sCustomer_Location}
     
    Search Customer    ${sCustomer_Search}    ${sLIQCustomer_ID}    ${sLIQCustomer_ShortName}
    Switch Customer Notebook to Update Mode
    
    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    Profiles
    Mx LoanIQ Optional Select    ${Profile_Grid}    ${sProfile_Type}
    Mx Native Type    {DOWN 1}
    
    Mx LoanIQ Click    ${RemittanceInstructions_Button}
    Read Excel Data and Validate Remittance Instructions Data Added in the Remittance List Window    ${sRemittanceInstruction_DDADescriptionAUD}    ${sCustomer_Location}
    Read Excel Data and Validate Remittance Instructions Data Added in the Remittance List Window    ${sRemittanceInstruction_IMTDescriptionUSD}    ${sCustomer_Location}
    Read Excel Data and Validate Remittance Instructions Data Added in the Remittance List Window    ${sRemittanceInstruction_RTGSDescriptionAUD}    ${sCustomer_Location}
    Mx LoanIQ Click    ${RemittanceList_Window_ExitButton}
    
    Mx LoanIQ Click    ${ServicingGroups_Button}
    Validate 'Serving Groups For:' Window and Click Add Button    ${sLIQCustomer_ShortName}
    Validate 'Informational Message' Window and Click Ok button
    Validate 'Servicing Group Contacts Selection List' Window and add an Available Active Contact    ${sGroup_Contact}
    Validate the 'Name' under "Drill Down To Change Group Members" section   ${sContact_LastName}    ${sLIQCustomer_ShortName}
    Validate 'Servicing Group Remittance Instructions Selection List' Window and Mark a Servicing Group Remittance Instructions    ${sRemittanceInstruction_DDADescriptionAUD}    ${sRemittanceInstruction_IMTDescriptionUSD}    ${sRemittanceInstruction_RTGSDescriptionAUD}    ${sLIQCustomer_ShortName}
    Validate Added Remittance Instructions    ${sRemittanceInstruction_DDADescriptionAUD}    ${sRemittanceInstruction_IMTDescriptionUSD}    ${sRemittanceInstruction_RTGSDescriptionAUD} 
    Mx LoanIQ Click    ${ServicingGroupWindow_ExitButton}
    Validate 'Active Customer' Window    ${sLIQCustomer_ShortName}

Add Servicing Groups Details
    [Documentation]    This keyword adds Add Servicing Groups to a Customer
    ...    @author: ghabal
    ...    @update: amansuet    02APR2020    - Removed Unused Argument ${Customer_Search} and ${LIQCustomer_ID} and ${Profile_Type}
    ...                                      - Updated to align with automation standards and added keyword pre-processing
    ...    @update: amansuet    20MAY2020    - added acquire argument and take screenshot keywords and remove unused keyword
    [Arguments]    ${sLIQCustomer_ShortName}    ${sGroup_Contact}   ${sContact_LastName} 
    
    ### Keyword Pre-processing ###
    ${LIQCustomer_ShortName}    Acquire Argument Value    ${sLIQCustomer_ShortName}
    ${Group_Contact}    Acquire Argument Value    ${sGroup_Contact}
    ${Contact_LastName}    Acquire Argument Value    ${sContact_LastName}

    Mx LoanIQ Click    ${ServicingGroups_Button}
    Validate 'Serving Groups For:' Window and Click Add Button    ${LIQCustomer_ShortName}
    Validate 'Informational Message' Window and Click Ok button
    Validate 'Servicing Group Contacts Selection List' Window and add an Available Active Contact    ${Group_Contact}
    Validate the 'Name' under "Drill Down To Change Group Members" section   ${Contact_LastName}    ${LIQCustomer_ShortName}
    
    Mx LoanIQ Activate    ${ServicingGroupWindow}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ServicingGroupsWindow
    Mx LoanIQ Click    ${ServicingGroupWindow_RemittanceInstructionButton}

Add Servicing Groups under Profile Tab for Location 1 and 2
    [Documentation]    This keyword adds Add Servicing Groups to a Customer for Location 1 and 2
    ...    @author: ghabal
    ...    @update: ghabal    20MAR2019    - Updated to use the latest keywords fro Servicing Groups related keywords
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and removed unused keywords
    [Arguments]    ${sCustomer_Search}    ${sLIQCustomer_ID}    ${sLIQCustomer_ShortName}    ${sProfile_Type}    ${sGroup_Contact}   ${sContact_LastName}    
    ...    ${sRemittanceInstruction_DDADescriptionAUD}    ${sRemittanceInstruction_IMTDescriptionUSD}    ${sRemittanceInstruction_RTGSDescriptionAUD}
    ...    ${sRemittanceInstruction_DDADescriptionAUD2}    ${sRemittanceInstruction_IMTDescriptionUSD2}    ${sRemittanceInstruction_RTGSDescriptionAUD2}    ${sGroup_Contact2}   ${sContact_LastName2}    ${sCustomer_Location}     ${sCustomer_Location2}

    ## Location 1
    Access Remittance List upon Login    ${sProfile_Type}    ${sCustomer_Location}
     
	## Rechecked Added Remittance Instructions for Location if they are in 'Approved' status
    Read Excel Data and Validate Remittance Instructions Data Added in the Remittance List Window    ${sRemittanceInstruction_DDADescriptionAUD}    ${sCustomer_Location}
    Read Excel Data and Validate Remittance Instructions Data Added in the Remittance List Window    ${sRemittanceInstruction_IMTDescriptionUSD}    ${sCustomer_Location}
    Read Excel Data and Validate Remittance Instructions Data Added in the Remittance List Window    ${sRemittanceInstruction_RTGSDescriptionAUD}    ${sCustomer_Location}
    mx LoanIQ click    ${RemittanceList_Window_ExitButton}
        
    Add Servicing Groups Details    ${sLIQCustomer_ShortName}    ${sGroup_Contact}    ${sContact_LastName}
    
    Add Remittance Instruction to Servicing Group    ${sRemittanceInstruction_DDADescriptionAUD}    
    Add Remittance Instruction to Servicing Group    ${sRemittanceInstruction_IMTDescriptionUSD}
    Add Remittance Instruction to Servicing Group    ${sRemittanceInstruction_RTGSDescriptionAUD}
    
    Close Servicing Group Remittance Instructions Selection List Window    ${sLIQCustomer_ShortName}
     
    mx LoanIQ click    ${ServicingGroupWindow_ExitButton}
    Validate 'Active Customer' Window    ${sLIQCustomer_ShortName} 
    
    ## Location 2
    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    Profiles
    Sleep    4s
    Mx LoanIQ Optional Select    ${Profile_Grid}    ${sProfile_Type}
    Mx Native Type    {DOWN 2}
    
    ## Rechecked Added Remittance Instructions for Location 2 if they are in 'Approved' status
    mx LoanIQ click    ${RemittanceInstructions_Button}
    Read Excel Data and Validate Remittance Instructions Data Added in the Remittance List Window    ${sRemittanceInstruction_DDADescriptionAUD2}    ${sCustomer_Location2}
    Read Excel Data and Validate Remittance Instructions Data Added in the Remittance List Window    ${sRemittanceInstruction_IMTDescriptionUSD2}    ${sCustomer_Location2}
    Read Excel Data and Validate Remittance Instructions Data Added in the Remittance List Window    ${sRemittanceInstruction_RTGSDescriptionAUD2}    ${sCustomer_Location2}
    mx LoanIQ click    ${RemittanceList_Window_ExitButton}
        
    Add Servicing Groups Details    ${sLIQCustomer_ShortName}    ${sGroup_Contact2}    ${sContact_LastName2}
    
    Add Remittance Instruction to Servicing Group    ${sRemittanceInstruction_DDADescriptionAUD2}    
    Add Remittance Instruction to Servicing Group    ${sRemittanceInstruction_IMTDescriptionUSD2}
    Add Remittance Instruction to Servicing Group    ${sRemittanceInstruction_RTGSDescriptionAUD2}
    
    Close Servicing Group Remittance Instructions Selection List Window    ${sLIQCustomer_ShortName}
     
    mx LoanIQ click    ${ServicingGroupWindow_ExitButton}
    Validate 'Active Customer' Window    ${sLIQCustomer_ShortName}
  
Validate 'Serving Groups For:' Window and Click Add Button
    [Documentation]    This keyword validates the 'Serving Groups For:' Window and Click Add Button 
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and removed unused keywords
    [Arguments]    ${sLIQCustomer_ShortName}

    Validate 'Serving Groups For:' Window    ${sLIQCustomer_ShortName}    
    Mx LoanIQ Click    ${ServicingGroupWindow_AddButton}
    
Validate 'Serving Groups For:' Window
    [Documentation]    This keyword validates the Window Name of 'Serving Groups For:' Window 
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and removed unused keywords
    ...                                      - fixed hardcoded locators
    [Arguments]    ${sLIQCustomer_ShortName}

    Mx LoanIQ Activate    ${ServicingGroupWindow}

    ${LIQCustomer_ShortName}    Replace Variables    ${sLIQCustomer_ShortName}
    ${ServicingGroupWindow_ServicingGroupsFor}    Replace Variables    ${ServicingGroupWindow_ServicingGroupsFor}

    Run Keyword And Continue On Failure     Mx LoanIQ Verify Object Exist    ${ServicingGroupWindow_ServicingGroupsFor}    VerificationData="Yes"
    ${result}    Run Keyword And Return Status    Run Keyword And Continue On Failure     Mx LoanIQ Verify Object Exist    ${ServicingGroupWindow_ServicingGroupsFor}    VerificationData="Yes"
    Run Keyword If   '${result}'=='True'    Log    "Serving Groups For: ${LIQCustomer_ShortName}" window has been displayed.
    ...     ELSE    Log    "Serving Groups For: ${LIQCustomer_ShortName}" window has been NOT displayed.    
    
Validate 'Informational Message' Window and Click Ok button
   [Documentation]    This keyword validates the Window Name of 'Informational Message' Window and Click Ok button 
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and removed unused keywords

    Mx LoanIQ Activate    ${LIQ_Information_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${ServicingGroupWindow_InformationalMessage}    VerificationData="Yes"
    ${result}    Run Keyword And Return Status    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${ServicingGroupWindow_InformationalMessage}    VerificationData="Yes"
    Run Keyword If   '${result}'=='True'    Log    'INFORMATIONAL MESSAGE": Contacts available for selection include only active contacts." with "OK" button has been displayed.
    ...     ELSE    Log    'INFORMATIONAL MESSAGE": Contacts available for selection include only active contacts." with "OK" button has been NOT displayed.
    Mx LoanIQ Click    ${LIQ_Information_OK_Button}
       
Validate 'Servicing Group Contacts Selection List' Window and add an Available Active Contact
   [Documentation]    This keyword validates the Window Name of 'Servicing Group Contacts Selection List' Window and add an Available Active Contact 
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and removed unused keywords
    [Arguments]    ${sGroup_Contact}=None
    
    Mx LoanIQ Activate    ${ContactsSelectionList_Window}
    Validate Window Title    Servicing Group Contacts Selection List
    Run Keyword If    '${sGroup_Contact}' != 'None'    Mx LoanIQ DoubleClick    ${ContactsSelectionList_Window_Available_List}    ${sGroup_Contact}
    Mx LoanIQ Click    ${ContactsSelectionList_Window_OkButton}

Validate the 'Name' under "Drill Down To Change Group Members" section
    [Documentation]    This keyword validates the 'Name' under "Drill Down To Change Group Members" section 
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and removed unused keywords
    ...                                      - fixed hardcoded locators
    [Arguments]   ${sContact_LastName}    ${sLIQCustomer_ShortName}

    ${Contact_LastName1}   Convert To Uppercase    ${sContact_LastName}
    Mx LoanIQ Activate    ${ServicingGroupWindow}
    
    ${LIQCustomer_ShortName}    Replace Variables    ${sLIQCustomer_ShortName}
    ${Contact_LastName1}    Replace Variables    ${Contact_LastName1}
    ${ServicingGroupWindow_ServicingGroupsFor_DrillDownToChangeGroupMembers}    Replace Variables    ${ServicingGroupWindow_ServicingGroupsFor_DrillDownToChangeGroupMembers}

    Run Keyword And Continue On Failure        Mx LoanIQ Verify Object Exist    ${ServicingGroupWindow_ServicingGroupsFor_DrillDownToChangeGroupMembers}    VerificationData="Yes"
    ${result}    Run Keyword And Return Status    Run Keyword And Continue On Failure        Mx LoanIQ Verify Object Exist    ${ServicingGroupWindow_ServicingGroupsFor_DrillDownToChangeGroupMembers}    VerificationData="Yes"
    Run Keyword If   '${result}'=='True'    Log   "${Contact_LastName1}" is added under "Drill Down To Change Group Members" section
    ...     ELSE    Log   "${Contact_LastName1}" is NOT added under "Drill Down To Change Group Members" section       

Validate 'Servicing Group Remittance Instructions Selection List' Window and Mark a Servicing Group Remittance Instructions
    [Documentation]    This keyword validates the 'Servicing Group Remittance Instructions Selection List' Window and Mark a Servicing Group Remittance Instructions 
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and removed unused keywords
    ...                                      - fixed hardcoded locators
    [Arguments]    ${RemittanceInstruction_DDADescriptionAUD}        ${RemittanceInstruction_IMTDescriptionUSD}    ${RemittanceInstruction_RTGSDescriptionAUD}     ${LIQCustomer_ShortName}
    
    Mx LoanIQ Activate    ${ServicingGroupWindow}
    Mx LoanIQ Click    ${ServicingGroupWindow_RemittanceInstructionButton}
    Validate Window Title    Servicing Group Remittance Instructions Selection List
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${ServicingGroupWindow_SelectionList_RemittanceInstructionItem}    ${RemittanceInstruction_DDADescriptionAUD}%s
    Mx Native Type    {SPACE}
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${ServicingGroupWindow_SelectionList_RemittanceInstructionItem}    ${RemittanceInstruction_IMTDescriptionUSD}%s
    Mx Native Type    {SPACE}
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${ServicingGroupWindow_SelectionList_RemittanceInstructionItem}    ${RemittanceInstruction_RTGSDescriptionAUD}%s
    Mx Native Type    {SPACE}
    Mx LoanIQ Click    ${ServicingGroupWindow_SelectionList_OkButton}
    Mx LoanIQ Activate    ${ServicingGroupWindow}
    Validate 'Serving Groups For:' Window    ${LIQCustomer_ShortName}
 
Add Remittance Instruction to Servicing Group
    [Documentation]    This keyword validates the 'Servicing Group Remittance Instructions Selection List' Window and Mark a Servicing Group Remittance Instructions 
    ...    @author: ghabal
    ...    @update: ghabal    06MAR2019    - optimize keyword for reusability    
    ...    @update: amansuet    23APR2020    - added keyword pre-processing
    ...    @update: amansuet    20MAY2020    - take screenshot keyword and remove unused keyword
    [Arguments]    ${sRemittanceInstruction_DDADescriptionAUD}=None

    ### GetRuntime Keyword Pre-processing ###
    ${RemittanceInstruction_DDADescriptionAUD}    Acquire Argument Value    ${sRemittanceInstruction_DDADescriptionAUD}

    Validate Window Title    Servicing Group Remittance Instructions Selection List
    Run Keyword If    '${RemittanceInstruction_DDADescriptionAUD}' != 'None'    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${ServicingGroupWindow_SelectionList_RemittanceInstructionItem}    ${RemittanceInstruction_DDADescriptionAUD}%s
    Mx Native Type    {SPACE}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ServicingGroupRemittanceInstructionsSelectionListWindow

Close Servicing Group Remittance Instructions Selection List Window
    [Documentation]    This keyword validates the 'Servicing Group Remittance Instructions Selection List' Window and Mark a Servicing Group Remittance Instructions 
    ...    @author: ghabal
    ...    @update: amansuet    23APR2020    Updated to align with automation standards and added keyword pre-processing
    ...    @update: amansuet    20MAY2020    - added take screenshot keyword and remove unused keyword
    [Arguments]    ${sLIQCustomer_ShortName}=None    

    ### GetRuntime Keyword Pre-processing ###
    ${LIQCustomer_ShortName}    Acquire Argument Value    ${sLIQCustomer_ShortName}

    Mx LoanIQ Click    ${ServicingGroupWindow_SelectionList_OkButton}
    Mx LoanIQ Activate    ${ServicingGroupWindow}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ServicingGroupsWindow
    Run Keyword If    '${LIQCustomer_ShortName}' != 'None'    Validate 'Serving Groups For:' Window    ${LIQCustomer_ShortName}
    
Validate Added Remittance Instructions
    [Documentation]    This keyword validates the Added Remittance Instructions against from excel data  
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and fixed hardcoded locator
    [Arguments]    ${sRemittanceInstruction_DDADescriptionAUD}    ${sRemittanceInstruction_IMTDescriptionUSD}    ${sRemittanceInstruction_RTGSDescriptionAUD}      
    
    ${RemittanceInstruction_DDADescriptionAUD}    Replace Variables    ${sRemittanceInstruction_DDADescriptionAUD}
    ${ServicingGroupWindow_RemittanceInstructionDetails_DDADescription}    Replace Variables    ${ServicingGroupWindow_RemittanceInstructionDetails_DDADescription}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${ServicingGroupWindow_RemittanceInstructionDetails_DDADescription}    VerificationData="Yes"

    ${RemittanceInstruction_IMTDescriptionUSD}    Replace Variables    ${sRemittanceInstruction_IMTDescriptionUSD}
    ${ServicingGroupWindow_RemittanceInstructionDetails_IMTDescription}    Replace Variables    ${ServicingGroupWindow_RemittanceInstructionDetails_IMTDescription}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${ServicingGroupWindow_RemittanceInstructionDetails_IMTDescription}    VerificationData="Yes"

    ${RemittanceInstruction_RTGSDescriptionAUD}    Replace Variables    ${sRemittanceInstruction_RTGSDescriptionAUD}
    ${ServicingGroupWindow_RemittanceInstructionDetails_RTGSDescription}    Replace Variables    ${ServicingGroupWindow_RemittanceInstructionDetails_RTGSDescription}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${ServicingGroupWindow_RemittanceInstructionDetails_RTGSDescription}    VerificationData="Yes"
    
Save Customer Details
     [Documentation]    This keyword saves Customer Details 
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and removed unused keywords
    
    Mx LoanIQ Select    ${LIQ_ActiveCustomer_Window_FileMenu_SaveMenu}
    Take Screenshot    Customer Details are Saved
    Mx LoanIQ click element If Present   ${LIQ_Warning_OK_Button}
    
Generate LIQ Customer ShortName and Legal Name and Save it to Excel
    [Documentation]    This keyword generates LIQ Customer ShortName and Legal Name and Save it to Excel
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards
    [Arguments]     ${sLIQCustomerShortName_Prefix}    ${sLIQCustomerLegalName_Prefix}    ${rowid}

    ${LIQCustomer_ShortName}    Auto Generate Only 5 Numeric Test Data    ${sLIQCustomerShortName_Prefix}
    log    LIQ Customer Short Name: ${LIQCustomer_ShortName}
    ${LIQCustomer_LegalName}    Auto Generate Only 5 Numeric Test Data    ${sLIQCustomerLegalName_Prefix}    
    log    LIQ Customer Legal Name: ${LIQCustomer_LegalName}
    [Return]    ${LIQCustomer_ShortName}    ${LIQCustomer_LegalName}
    
Generate LIQ Remittance Instruction Descriptions
    [Documentation]    This keyword generates LIQ Remittance Instruction Descriptions and Save it to Excel
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards
    [Arguments]    ${sRemittanceInstruction_DDADescriptionAUDPrefix}    ${sRemittanceInstruction_IMTDescriptionUSDPrefix}    ${sRemittanceInstruction_RTGSDescriptionAUDPrefix}   
        
    ${RemittanceInstruction_DDADescriptionAUD}    Auto Generate Only 4 Numeric Test Data    ${sRemittanceInstruction_DDADescriptionAUDPrefix}
    log    LIQ Customer DDA AUD Remittance Instruction Description: ${RemittanceInstruction_DDADescriptionAUD}

    ${RemittanceInstruction_IMTDescriptionUSD}    Auto Generate Only 4 Numeric Test Data    ${sRemittanceInstruction_IMTDescriptionUSDPrefix}
    log    LIQ Customer IMT USD Remittance Instruction Description: ${RemittanceInstruction_IMTDescriptionUSD}
    
    ${RemittanceInstruction_RTGSDescriptionAUD}    Auto Generate Only 4 Numeric Test Data    ${sRemittanceInstruction_RTGSDescriptionAUDPrefix}
    Log    LIQ Customer RTGS AUD Remittance Instruction Description: ${RemittanceInstruction_RTGSDescriptionAUD}

    [Return]    ${RemittanceInstruction_DDADescriptionAUD}    ${RemittanceInstruction_IMTDescriptionUSD}    ${RemittanceInstruction_RTGSDescriptionAUD}
    
Write Remittance Description
    [Documentation]    This keyword writes remittance description to excel according to the inputted scenario
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - removed unused keywords and added documentation on keyword
    ...    @update: dahijara    08JUL2020    - add test data writing for scenario 6
    ...    @update: dahijara    16JUL2020    - add test data writing for scenario 6 - MTAM05B_CycleShareAdjustment
    [Arguments]    ${sScenario}    ${sRemittanceInstruction}    ${RemittanceInstruction_DDADescriptionAUD}    ${RemittanceInstruction_IMTDescriptionUSD}    ${RemittanceInstruction_RTGSDescriptionAUD}
    
    Run Keyword if    '${sRemittanceInstruction}' == 'DDA' and '${sScenario}' == '1'    Run Keywords    Write Data To Excel    SERV01_LoanDrawdown    Remittance_Description    ${rowid}    ${RemittanceInstruction_DDADescriptionAUD}
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    SERV18_Payments    Borrower1_RTGSRemittanceDescription    ${rowid}    ${RemittanceInstruction_DDADescriptionAUD}
    ...    AND    Write Data To Excel    SERV18_Payments    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    SERV21_InterestPayments    Borrower1_RTGSRemittanceDescription    ${rowid}    ${RemittanceInstruction_DDADescriptionAUD}
    ...    AND    Write Data To Excel    SERV21_InterestPayments    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Borrower1_RTGSRemittanceInstruction    ${rowid}    ${RemittanceInstruction_DDADescriptionAUD}
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Borrower1_RTGSRemittanceDescription    ${rowid}    ${sRemittanceInstruction}

    Run Keyword if    '${sRemittanceInstruction}' == 'IMT' and '${sScenario}' == '1'    Run Keywords    Write Data To Excel    SERV01_LoanDrawdown    Remittance_Description    ${rowid}    ${RemittanceInstruction_IMTDescriptionUSD}
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    SERV18_Payments    Borrower1_RTGSRemittanceDescription    ${rowid}    ${RemittanceInstruction_IMTDescriptionUSD}
    ...    AND    Write Data To Excel    SERV18_Payments    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    SERV21_InterestPayments    Borrower1_RTGSRemittanceDescription    ${rowid}    ${RemittanceInstruction_IMTDescriptionUSD}
    ...    AND    Write Data To Excel    SERV21_InterestPayments    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Borrower1_RTGSRemittanceInstruction    ${rowid}    ${RemittanceInstruction_IMTDescriptionUSD}
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Borrower1_RTGSRemittanceDescription    ${rowid}    ${sRemittanceInstruction}
    
	Run Keyword if    '${sRemittanceInstruction}' == 'RTGS' and '${sScenario}' == '1'    Run Keywords    Write Data To Excel    SERV01_LoanDrawdown    Remittance_Description    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    SERV18_Payments    Borrower1_RTGSRemittanceDescription    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}
    ...    AND    Write Data To Excel    SERV18_Payments    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    SERV21_InterestPayments    Borrower1_RTGSRemittanceDescription    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}
    ...    AND    Write Data To Excel    SERV21_InterestPayments    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Borrower1_RTGSRemittanceInstruction    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Borrower1_RTGSRemittanceDescription    ${rowid}    ${sRemittanceInstruction}

    Run Keyword if    '${sRemittanceInstruction}' == 'DDA' and '${sScenario}' == '2'    Run Keywords    Write Data To Excel    SERV23_PaperclipTransaction    Remittance_Description    ${rowid}    ${RemittanceInstruction_DDADescriptionAUD}
    ...    AND    Write Data To Excel    SERV23_PaperclipTransaction    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    SERV40_BreakFunding    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    SERV40_BreakFunding    Remittance_Description    ${rowid}    ${RemittanceInstruction_DDADescriptionAUD}
    ...    AND    Write Data To Excel    SERV20_UnschedPrincipalPayments    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    SERV20_UnschedPrincipalPayments    Remittance_Description    ${rowid}    ${RemittanceInstruction_DDADescriptionAUD}
    ...    AND    Write Data To Excel    SERV33_RecurringFee    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    SERV33_RecurringFee    Remittance_Description    ${rowid}    ${RemittanceInstruction_DDADescriptionAUD} 
    ...    AND    Write Data To Excel    SERV21_InterestPayments    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    SERV21_InterestPayments    Remittance_Description    ${rowid}    ${RemittanceInstruction_DDADescriptionAUD}    
    ...    AND    Write Data To Excel    SERV08_ComprehensiveRepricing    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    SERV08_ComprehensiveRepricing    Remittance_Description    ${rowid}    ${RemittanceInstruction_DDADescriptionAUD}       
    ...    AND    Write Data To Excel    SERV01A_LoanDrawdown    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    SERV01A_LoanDrawdown    Remittance_Description    ${rowid}    ${RemittanceInstruction_DDADescriptionAUD}
    ...    AND    Write Data To Excel    SERV30_AdminFeePayment    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    SERV30_AdminFeePayment    Remittance_Description    ${rowid}    ${RemittanceInstruction_DDADescriptionAUD}
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Remittance_Description    ${rowid}    ${RemittanceInstruction_DDADescriptionAUD}
    ...    AND    Write Data To Excel    MTAM07_FacilityShareAdjustment    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    MTAM07_FacilityShareAdjustment    Remittance_Description    ${rowid}    ${RemittanceInstruction_DDADescriptionAUD}
    ...    AND    Write Data To Excel    AMCH10_ChangeAgencyFee    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    AMCH10_ChangeAgencyFee    Remittance_Description    ${rowid}    ${RemittanceInstruction_DDADescriptionAUD}

    Run Keyword if    '${sRemittanceInstruction}' == 'IMT' and '${sScenario}' == '2'    Run Keywords    Write Data To Excel    SERV23_PaperclipTransaction    Remittance_Description    ${rowid}    ${RemittanceInstruction_IMTDescriptionUSD}
    ...    AND    Write Data To Excel    SERV23_PaperclipTransaction    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    SERV40_BreakFunding    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    SERV40_BreakFunding    Remittance_Description    ${rowid}    ${RemittanceInstruction_IMTDescriptionUSD}
    ...    AND    Write Data To Excel    SERV20_UnschedPrincipalPayments    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    SERV20_UnschedPrincipalPayments    Remittance_Description    ${rowid}    ${RemittanceInstruction_IMTDescriptionUSD}
    ...    AND    Write Data To Excel    SERV33_RecurringFee    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    SERV33_RecurringFee    Remittance_Description    ${rowid}    ${RemittanceInstruction_IMTDescriptionUSD} 
    ...    AND    Write Data To Excel    SERV21_InterestPayments    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    SERV21_InterestPayments    Remittance_Description    ${rowid}    ${RemittanceInstruction_IMTDescriptionUSD}    
    ...    AND    Write Data To Excel    SERV08_ComprehensiveRepricing    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    SERV08_ComprehensiveRepricing    Remittance_Description    ${rowid}    ${RemittanceInstruction_IMTDescriptionUSD}       
    ...    AND    Write Data To Excel    SERV01A_LoanDrawdown    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    SERV01A_LoanDrawdown    Remittance_Description    ${rowid}    ${RemittanceInstruction_IMTDescriptionUSD}
    ...    AND    Write Data To Excel    SERV30_AdminFeePayment    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    SERV30_AdminFeePayment    Remittance_Description    ${rowid}    ${RemittanceInstruction_IMTDescriptionUSD}
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Remittance_Description    ${rowid}    ${RemittanceInstruction_IMTDescriptionUSD}
    ...    AND    Write Data To Excel    MTAM07_FacilityShareAdjustment    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    MTAM07_FacilityShareAdjustment    Remittance_Description    ${rowid}    ${RemittanceInstruction_IMTDescriptionUSD}
    ...    AND    Write Data To Excel    AMCH10_ChangeAgencyFee    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    AMCH10_ChangeAgencyFee    Remittance_Description    ${rowid}    ${RemittanceInstruction_IMTDescriptionUSD}
	
	Run Keyword if    '${sRemittanceInstruction}' == 'RTGS' and '${sScenario}' == '2'    Run Keywords    Write Data To Excel    SERV23_PaperclipTransaction    Remittance_Description    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}
    ...    AND    Write Data To Excel    SERV23_PaperclipTransaction    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    SERV40_BreakFunding    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    SERV40_BreakFunding    Remittance_Description    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}
    ...    AND    Write Data To Excel    SERV20_UnschedPrincipalPayments    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    SERV20_UnschedPrincipalPayments    Remittance_Description    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}
    ...    AND    Write Data To Excel    SERV33_RecurringFee    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    SERV33_RecurringFee    Remittance_Description    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD} 
    ...    AND    Write Data To Excel    SERV21_InterestPayments    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    SERV21_InterestPayments    Remittance_Description    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}    
    ...    AND    Write Data To Excel    SERV08_ComprehensiveRepricing    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    SERV08_ComprehensiveRepricing    Remittance_Description    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}       
    ...    AND    Write Data To Excel    SERV01A_LoanDrawdown    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    SERV01A_LoanDrawdown    Remittance_Description    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}
    ...    AND    Write Data To Excel    SERV30_AdminFeePayment    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    SERV30_AdminFeePayment    Remittance_Description    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Remittance_Description    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}
    ...    AND    Write Data To Excel    MTAM07_FacilityShareAdjustment    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    MTAM07_FacilityShareAdjustment    Remittance_Description    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}
    ...    AND    Write Data To Excel    AMCH10_ChangeAgencyFee    Remittance_Instruction    ${rowid}    ${sRemittanceInstruction}
    ...    AND    Write Data To Excel    AMCH10_ChangeAgencyFee    Remittance_Description    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}

	Run Keyword if    '${sRemittanceInstruction}' == 'RTGS' and '${sScenario}' == '6'    Run Keywords    Write Data To Excel    SERV29_PaymentFees    Borrower1_RTGSRemittanceDescription    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Borrower1_RTGSRemittanceDescription    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}
    ...    AND    Write Data To Excel    MTAM05B_CycleShareAdjustment    Borrower1_RTGSRemittanceDescription    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}

	Run Keyword if    '${sRemittanceInstruction}' == 'RTGS' and '${sScenario}' == '7'    Run Keywords    Write Data To Excel    SERV01_LoanDrawdown    Remittance_Description    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Borrower1_RTGSRemittanceDescription    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}
    ...    AND    Write Data To Excel    SERV19_UnscheduledPayments    Borrower1_RTGSRemittanceDescription    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}    
    ...    AND    Write Data To Excel    SERV21_InterestPayments    Borrower1_RTGSRemittanceDescription    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}

Generate LIQ Remittance Instruction Descriptions for Location 1 and 2
    [Documentation]    This keyword generates LIQ Remittance Instruction Descriptions for Location 1 and 2 and Save it to Excel
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and removed unused keywords
    [Arguments]    ${sRemittanceInstruction_DDADescriptionAUDPrefix}    ${sRemittanceInstruction_IMTDescriptionUSDPrefix}    ${sRemittanceInstruction_RTGSDescriptionAUDPrefix}
    ...    ${sRemittanceInstruction_DDADescriptionAUDPrefix2}    ${sRemittanceInstruction_IMTDescriptionUSDPrefix2}    ${sRemittanceInstruction_RTGSDescriptionAUDPrefix2}         
     
    ##Location 1    
    ${RemittanceInstruction_DDADescriptionAUD}    Auto Generate Only 4 Numeric Test Data    ${sRemittanceInstruction_DDADescriptionAUDPrefix}
    log    LIQ Customer DDA AUD Remittance Instruction Description: ${RemittanceInstruction_DDADescriptionAUD}
    Write Data To Excel    ORIG03_Customer    RemittanceInstruction_DDADescriptionAUD    ${rowid}    ${RemittanceInstruction_DDADescriptionAUD}
    
    ${RemittanceInstruction_IMTDescriptionUSD}    Auto Generate Only 4 Numeric Test Data    ${sRemittanceInstruction_IMTDescriptionUSDPrefix}
    log    LIQ Customer IMT USD Remittance Instruction Description: ${RemittanceInstruction_IMTDescriptionUSD}
    Write Data To Excel    ORIG03_Customer    RemittanceInstruction_IMTDescriptionUSD    ${rowid}    ${RemittanceInstruction_IMTDescriptionUSD}
    
    ${RemittanceInstruction_RTGSDescriptionAUD}    Auto Generate Only 4 Numeric Test Data    ${sRemittanceInstruction_RTGSDescriptionAUDPrefix}
    log    LIQ Customer IMT USD Remittance Instruction Description: ${RemittanceInstruction_RTGSDescriptionAUD}
    Write Data To Excel    ORIG03_Customer    RemittanceInstruction_RTGSDescriptionAUD    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}
    
    ## Location 2    
    ${RemittanceInstruction_DDADescriptionAUD2}    Auto Generate Only 4 Numeric Test Data    ${sRemittanceInstruction_DDADescriptionAUDPrefix2}
    log    LIQ Customer DDA AUD Remittance Instruction Description: ${RemittanceInstruction_DDADescriptionAUD2}
    Write Data To Excel    ORIG03_Customer    RemittanceInstruction_DDADescriptionAUD2    ${rowid}    ${RemittanceInstruction_DDADescriptionAUD2}
    
    ${RemittanceInstruction_IMTDescriptionUSD2}    Auto Generate Only 4 Numeric Test Data    ${sRemittanceInstruction_IMTDescriptionUSDPrefix2}
    log    LIQ Customer IMT USD Remittance Instruction Description: ${RemittanceInstruction_IMTDescriptionUSD2}
    Write Data To Excel    ORIG03_Customer    RemittanceInstruction_IMTDescriptionUSD2    ${rowid}    ${RemittanceInstruction_IMTDescriptionUSD2}
    
    ${RemittanceInstruction_RTGSDescriptionAUD2}    Auto Generate Only 4 Numeric Test Data    ${sRemittanceInstruction_RTGSDescriptionAUDPrefix2}
    log    LIQ Customer IMT USD Remittance Instruction Description: ${RemittanceInstruction_RTGSDescriptionAUD2}
    Write Data To Excel    ORIG03_Customer    RemittanceInstruction_RTGSDescriptionAUD2    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD2}

Generate LIQ Remittance Instruction Descriptions_TDP
    [Documentation]    This keyword generates LIQ Remittance Instruction Descriptions and Save it to Excel
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and removed unused keywords
    [Arguments]    ${rowid}    ${sRemittanceInstruction_DDADescriptionAUDPrefix}    ${sRemittanceInstruction_IMTDescriptionUSDPrefix}    ${sRemittanceInstruction_RTGSDescriptionAUDPrefix}         
        
    ${RemittanceInstruction_DDADescriptionAUD}    Auto Generate Only 4 Numeric Test Data    ${sRemittanceInstruction_DDADescriptionAUDPrefix}
    log    LIQ Customer DDA AUD Remittance Instruction Description: ${RemittanceInstruction_DDADescriptionAUD}
    Write Data To Excel    TDP_ORIG03Customer    RemittanceInstruction_DDADescriptionAUD    ${rowid}    ${RemittanceInstruction_DDADescriptionAUD}
    
    ## For Scenario 4
    Write Data To Excel    SYND05_UpfrontFee_Payment    Remittance_Description    ${rowid}    ${RemittanceInstruction_DDADescriptionAUD}
    Write Data To Excel    SERV01_LoanDrawdown    Remittance_Description    ${rowid}    ${RemittanceInstruction_DDADescriptionAUD}
    
    ${RemittanceInstruction_IMTDescriptionUSD}    Auto Generate Only 4 Numeric Test Data    ${sRemittanceInstruction_IMTDescriptionUSDPrefix}
    log    LIQ Customer IMT USD Remittance Instruction Description: ${RemittanceInstruction_IMTDescriptionUSD}
    Write Data To Excel    TDP_ORIG03Customer    RemittanceInstruction_IMTDescriptionUSD    ${rowid}    ${RemittanceInstruction_IMTDescriptionUSD}
    
    ${RemittanceInstruction_RTGSDescriptionAUD}    Auto Generate Only 4 Numeric Test Data    ${sRemittanceInstruction_RTGSDescriptionAUDPrefix}
    log    LIQ Customer IMT USD Remittance Instruction Description: ${RemittanceInstruction_RTGSDescriptionAUD}
    Write Data To Excel    TDP_ORIG03Customer    RemittanceInstruction_RTGSDescriptionAUD    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}

Get Customer ID and Save it to Excel
    [Documentation]    This keyword generates LIQ Customer ShortName and Legal Name and Save it to Excel
    ...    @author: ghabal    
    ...    @update: amansuet    22APR2020    - added optional argument for keyword post processing
    [Arguments]    ${sRuntime_Variable}=None

    ${LIQCustomer_ID}    Mx LoanIQ Get Data    ${LIQ_CustomerSelect_NewCustomer_CustomerID}    testdata

    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRuntime_Variable}    ${LIQCustomer_ID}

    [Return]    ${LIQCustomer_ID}
        
Create New Customer
    [Documentation]    This keyword redirects select 'New' option in the Customer Select menu
    ...    @author: ghabal      
    ...    @update: jdelacru    13DEC2019    - used Mx LoanIQ Activate Window in activating window
    ...    @update: amansuet    18MAY2020    - removed unused keywords and added take screenshot
    
    Select Actions    [Actions];Customer
    Mx LoanIQ Activate Window    ${LIQ_CustomerSelect_Window}
    Validate Window Title    Customer Select
    Mx LoanIQ Set    ${LIQ_CustomerSelect_NewCustomer}    ON
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/CustomerSelectWindow

Create Customer and Enter Customer ShortName and Legal Name
    [Documentation]    This keyword initiates creation of Customer and enters Customer ShortName and Legal Name
    ...    @author: ghabal
    ...    @update: amansuet    22APR2020    - updated to align with automation standards and added keyword pre and post processing
    ...    @update: amansuet    18MAY2020    - added take screenshot
    [Arguments]    ${sLIQCustomer_ShortName}    ${sLIQCustomer_LegalName}    

    ### Keyword Pre-processing ###
    ${LIQCustomer_ShortName}    Acquire Argument Value    ${sLIQCustomer_ShortName}    ${ARG_TYPE_UNIQUE_DIGIT}
    ${LIQCustomer_LegalName}    Acquire Argument Value    ${sLIQCustomer_LegalName}    ${ARG_TYPE_UNIQUE_DIGIT}

    Enter LIQ Customer ShortName and Legal Name    ${LIQCustomer_ShortName}    ${LIQCustomer_LegalName}
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    Validate 'Active Customer' Window    ${LIQCustomer_ShortName}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ActiveCustomerWindow_GeneralTab

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sLIQCustomer_ShortName}    ${LIQCustomer_ShortName}
    Save Values of Runtime Execution on Excel File    ${sLIQCustomer_LegalName}    ${LIQCustomer_LegalName}

Enter LIQ Customer ShortName and Legal Name
    [Documentation]    This keyword enters Customer ShortName and Legal Name
    ...    @author: ghabal
    ...    @update: jdelacru    13MAR2020    - Deleted native type backspace
    ...    @update: amansuet    18MAY2020    - added take screenshot and removed sleep
    [Arguments]    ${sLIQCustomer_ShortName}    ${sLIQCustomer_LegalName}

    mx LoanIQ enter    ${LIQ_CustomerSelect_NewCustomer_ShortName}    ${sLIQCustomer_ShortName}
    mx LoanIQ enter    ${LIQ_CustomerSelect_NewCustomer_LegalName}    ${sLIQCustomer_LegalName}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/CustomerSelectWindow
    mx LoanIQ click    ${LIQ_CustomerSelect_OK_Button}
   
Add Customer Legal Address Details
     [Documentation]    This keywords adds Customer Legal Address Details  
    ...    @author: ghabal
    ...    @update: amansuet    18MAY2020    - added keyword Pre-processing for all arguments, added take screenshot after populating fields and removed sleep
    [Arguments]    ${sAddress_Line1}=None    ${sAddress_Line2}=None    ${sAddress_City}=None    ${sAddress_Country}=None    ${sAddress_TRA}=None    ${sAddress_State}=None    ${sAddress_ZipPostalCode}=None    ${sAddress_DefaultPhone}=None
    
    ### Keyword Pre-processing ###
    ${Address_Line1}    Acquire Argument Value    ${sAddress_Line1}
    ${Address_Line2}    Acquire Argument Value    ${sAddress_Line2}
    ${Address_City}    Acquire Argument Value    ${sAddress_City}
    ${Address_Country}    Acquire Argument Value    ${sAddress_Country}
    ${Address_TRA}    Acquire Argument Value    ${sAddress_TRA}
    ${Address_State}    Acquire Argument Value    ${sAddress_State}
    ${Address_ZipPostalCode}    Acquire Argument Value    ${sAddress_ZipPostalCode}
    ${Address_DefaultPhone}    Acquire Argument Value    ${sAddress_DefaultPhone}

    Mx LoanIQ Select    ${LIQ_Active_Customer_Notebook_OptionsMenu_LegalAddress}

    Run Keyword If    '${Address_Line1}' != 'None'    Mx LoanIQ Enter    ${LIQ_Active_Customer_Notebook_UpdateAddress_Window_Line1Field}    ${Address_Line1}
    Run Keyword If    '${Address_Line2}' != 'None'    Mx LoanIQ Enter   ${LIQ_Active_Customer_Notebook_UpdateAddress_Window_Line2Field}    ${Address_Line2}
    Run Keyword If    '${Address_City}' != 'None'    Mx LoanIQ Enter   ${LIQ_Active_Customer_Notebook_UpdateAddress_Window_CityField}    ${Address_City}
    Run Keyword If    '${Address_Country}' != 'None'    Mx LoanIQ Select Combo Box Value    ${LIQ_Active_Customer_Notebook_UpdateAddress_Window_CountryField}    ${Address_Country}  
    Run Keyword If    '${Address_TRA}' != 'None'    Mx LoanIQ Select Combo Box Value    ${LIQ_Active_Customer_Notebook_UpdateAddress_Window_TreasuryReportingArea_Field}    ${Address_TRA}
    Run Keyword If    '${Address_State}' != 'None'    Mx LoanIQ Select Combo Box Value    ${LIQ_Active_Customer_Notebook_UpdateAddress_Window_StateField}    ${Address_State}
    Run Keyword If    '${Address_ZipPostalCode}' != 'None'    Mx LoanIQ Enter   ${LIQ_Active_Customer_Notebook_UpdateAddress_Window_ZipPostalCodeField}    ${Address_ZipPostalCode}
    Run Keyword If    '${Address_DefaultPhone}' != 'None'    Mx LoanIQ Enter   ${LIQ_Active_Customer_Notebook_UpdateAddress_Window_DefaultPhoneField}    ${Address_DefaultPhone}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/UpdateAddressWindow

    Mx LoanIQ Click    ${LIQ_Active_Customer_Notebook_UpdateAddressWindow_OKButton}

Add Province Details in the Legal Address
     [Documentation]    This keywords adds Province   
    ...    @author: ghabal
    ...    @update: amansuet    18MAY2020    - added acquire argument and take screenshot keywords and remove unused keyword
    [Arguments]    ${sAddress_State}=None

    ### Keyword Pre-processing ###
    ${Address_State}    Acquire Argument Value    ${sAddress_State}

    Mx LoanIQ Select    ${LIQ_Active_Customer_Notebook_OptionsMenu_LegalAddress}
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    Run Keyword If    '${Address_State}' != 'None'    Mx LoanIQ Select Combo Box Value    ${LIQ_Active_Customer_Notebook_UpdateAddress_Window_StateField}    ${Address_State}
    Mx LoanIQ Click    ${LIQ_Active_Customer_Notebook_UpdateAddressWindow_OKButton}    
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/UpdateAddressWindow

Assign Primary SIC Code
    [Documentation]    This keyword navigates user to "SIC" tab and validates 'Primary SIC' Code 
    ...    @author: ghabal
    ...    @update amansuet    18MAY2020    - added keyword pre-processing, added take screenshot and removed sleep
    [Arguments]    ${sPrimary_SICCode}=None

    ### Keyword Pre-processing ###
    ${Primary_SICCode}    Acquire Argument Value    ${sPrimary_SICCode}

    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    SIC  
    Mx LoanIQ Activate    ${LIQ_ActiveCustomer_Window}
    Run Keyword If    '${Primary_SICCode}' != 'None'    Mx LoanIQ Click    ${LIQ_Active_Customer_Notebook_SICTab_PrimarySICButton}  
    Validate Window Title    SIC Select
    Run Keyword If    '${Primary_SICCode}' != 'None'    Mx LoanIQ Enter    ${LIQ_Active_Customer_Notebook_SICTab_SICSelect_CodeInputField}    ${Primary_SICCode}
    Run Keyword If    '${Primary_SICCode}' != 'None'    Mx LoanIQ Click    ${LIQ_Active_Customer_Notebook_SICTab_SICSelect_OKButton}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ActiveCustomerWindow_SICTab

Approve Added Remittance Instructions  
    [Documentation]    This keyword approves added Remittance Instructions
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and removed unused keywords
    [Arguments]    ${sCustomer_Search}    ${sLIQCustomer_ID}    ${sLIQCustomer_ShortName}    ${sProfile_Type}    ${sCustomer_Location}
    ...    ${sRemittanceInstruction_DDADescriptionAUD}    ${sRemittanceInstruction_IMTDescriptionUSD}    ${sRemittanceInstruction_RTGSDescriptionAUD}
    
    Search Customer    ${sCustomer_Search}    ${sLIQCustomer_ID}    ${sLIQCustomer_ShortName}
    Switch Customer Notebook to Update Mode
    
    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    Profiles
    Mx LoanIQ Optional Select    ${Profile_Grid}    ${sProfile_Type}
    Mx Native Type    {DOWN 1}
    Mx LoanIQ Click    ${RemittanceInstructions_Button}
    Validate Remittance List for 'Location' Window    ${sCustomer_Location}
    Approving DDA-AUD Remittance Instruction    ${sRemittanceInstruction_DDADescriptionAUD}    ${sCustomer_Location}
    Approving IMT-USD Remittance Instruction    ${sRemittanceInstruction_IMTDescriptionUSD}    ${sCustomer_Location}
    Approving RTGS-AUD Remittance Instruction    ${sRemittanceInstruction_RTGSDescriptionAUD}    ${sCustomer_Location}
        
    Mx LoanIQ Click    ${RemittanceList_Window_ExitButton}
    Validate 'Active Customer' Window    ${sLIQCustomer_ShortName}

Release Added Remittance Instructions    
    [Documentation]    This keyword releases Added Remittance Instructions
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and removed unused keywords
    [Arguments]    ${sCustomer_Search}    ${sLIQCustomer_ID}    ${sLIQCustomer_ShortName}    ${sProfile_Type}    ${sCustomer_Location}   
    ...    ${sRemittanceInstruction_DDADescriptionAUD}    ${sRemittanceInstruction_IMTDescriptionUSD}    ${sRemittanceInstruction_RTGSDescriptionAUD}
     
    Search Customer    ${sCustomer_Search}    ${sLIQCustomer_ID}    ${sLIQCustomer_ShortName}
    Switch Customer Notebook to Update Mode
    
    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    Profiles
    Mx LoanIQ Optional Select    ${Profile_Grid}    ${sProfile_Type}
    Mx Native Type    {DOWN 1}
    Mx LoanIQ Click    ${RemittanceInstructions_Button}
    Validate Remittance List for 'Location' Window    ${sCustomer_Location}
    Releasing DDA-AUD Remittance Instruction    ${sRemittanceInstruction_DDADescriptionAUD}    ${sCustomer_Location}
    Releasing IMT-USD Remittance Instruction    ${sRemittanceInstruction_IMTDescriptionUSD}    ${sCustomer_Location}
    Releasing RTGS-AUD Remittance Instruction    ${sRemittanceInstruction_RTGSDescriptionAUD}    ${sCustomer_Location}
    
    Mx LoanIQ Click    ${RemittanceList_Window_ExitButton}
    Validate 'Active Customer' Window    ${sLIQCustomer_ShortName}
   
Release Added Remittance Instructions for Location 1 and 2    
    [Documentation]    This keyword releases Added Remittance Instructions for Location 1 and 2
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and removed unused keywords
    [Arguments]    ${sCustomer_Search}    ${sLIQCustomer_ID}    ${sLIQCustomer_ShortName}    ${sProfile_Type}    ${sCustomer_Location}
    ...    ${sRemittanceInstruction_DDADescriptionAUD}    ${sRemittanceInstruction_IMTDescriptionUSD}    ${sRemittanceInstruction_RTGSDescriptionAUD} 
    ...    ${sRemittanceInstruction_DDADescriptionAUD2}    ${sRemittanceInstruction_IMTDescriptionUSD2}    ${sRemittanceInstruction_RTGSDescriptionAUD2}    ${sCustomer_Location2}
    
    ## Releasing Added Remittance Instructions
    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    Profiles
    Mx LoanIQ Optional Select    ${Profile_Grid}    ${sProfile_Type}
    Mx Native Type    {UP 1}
    Mx LoanIQ Click    ${RemittanceInstructions_Button}
    Releasing Remittance Instruction    ${sRemittanceInstruction_DDADescriptionAUD}    ${sCustomer_Location}
    Releasing Remittance Instruction    ${sRemittanceInstruction_IMTDescriptionUSD}    ${sCustomer_Location}
    Releasing Remittance Instruction    ${sRemittanceInstruction_RTGSDescriptionAUD}    ${sCustomer_Location}
                  
    Mx LoanIQ Click    ${RemittanceList_Window_ExitButton}

    Validate 'Active Customer' Window    ${sLIQCustomer_ShortName}
           
    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    Profiles
    Mx LoanIQ Optional Select    ${Profile_Grid}    ${sProfile_Type}
    Mx Native Type    {DOWN 2}
    Mx LoanIQ Click    ${RemittanceInstructions_Button}    
    Validate Remittance List for 'Location' Window    ${sCustomer_Location2}
    Releasing Remittance Instruction    ${sRemittanceInstruction_DDADescriptionAUD2}    ${sCustomer_Location2}
    Releasing Remittance Instruction    ${sRemittanceInstruction_IMTDescriptionUSD2}    ${sCustomer_Location2}
    Releasing Remittance Instruction    ${sRemittanceInstruction_RTGSDescriptionAUD2}    ${sCustomer_Location2}
    
    Mx LoanIQ Click    ${RemittanceList_Window_ExitButton}
    Validate 'Active Customer' Window    ${sLIQCustomer_ShortName}
       
Access Remittance List upon Login
    [Documentation]    This keyword access Remittance List
    ...    @author: ghabal
    ...    @update: amansuet    19MAY2020    - added acquire argument and updated take screenshot keyword and remove unused keyword
    [Arguments]    ${sProfile_Type}    ${sCustomer_Location}        
    
    ### Keyword Pre-processing ###
    ${Profile_Type}    Acquire Argument Value    ${sProfile_Type}
    ${Customer_Location}    Acquire Argument Value    ${sCustomer_Location}

    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    Profiles
    Mx LoanIQ Optional Select    ${Profile_Grid}    ${Profile_Type}
    Mx Press Combination    key.DOWN
    Mx LoanIQ Click    ${RemittanceInstructions_Button}
    Validate Remittance List for 'Location' Window    ${Customer_Location}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/RemittanceListWindow

Approving Remittance Instruction
    [Documentation]    This keyword approves DDA-AUD Remittance Instruction to the Details of a Contact of a Customer
    ...    @author: ghabal
    ...    @update: amansuet    23APR2020    added keyword pre-processing
    ...    @update: amansuet    19MAY2020    - added acquire argument and take screenshot keywords and remove unused keyword
    [Arguments]    ${sRemittanceInstruction_DDADescriptionAUD}    ${sCustomer_Location}

    ### Keyword Pre-processing ###
    ${RemittanceInstruction_DDADescriptionAUD}    Acquire Argument Value    ${sRemittanceInstruction_DDADescriptionAUD}
    ${Customer_Location}    Acquire Argument Value    ${sCustomer_Location}
    
    Mx LoanIQ DoubleClick    ${RemittanceList_Window_RemittanceList}    ${RemittanceInstruction_DDADescriptionAUD}
    Approve Remittance Instruction
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/RemittanceInstructionsDetailWindow
    Mx LoanIQ Select    ${LIQ_RemittanceInstruction_Notebook_FileMenu_ExitMenu}
        
Approving DDA-AUD Remittance Instruction
    [Documentation]    This keyword approves DDA-AUD Remittance Instruction to the Details of a Contact of a Customer
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and removed unused keywords
    [Arguments]    ${sRemittanceInstruction_DDADescriptionAUD}    ${sCustomer_Location}

    Mx LoanIQ DoubleClick    ${RemittanceList_Window_RemittanceList}    ${sRemittanceInstruction_DDADescriptionAUD}
    Approve Remittance Instruction
    Mx LoanIQ Select    ${LIQ_RemittanceInstruction_Notebook_FileMenu_ExitMenu}      
    Read Excel Data and Validate Remittance Instructions Data Added in the Remittance List Window    ${sRemittanceInstruction_DDADescriptionAUD}    ${sCustomer_Location}

Releasing Remittance Instruction
    [Documentation]    This keyword release DDA-AUD Remittance Instruction to the Details of a Contact of a Customer
    ...    @author: ghabal
    ...    @update: amansuet    23APR2020    added keyword pre-processing
    ...    @update: amansuet    19MAY2020    - added acquire argument and take screenshot keywords and remove unused keyword
    [Arguments]    ${sRemittanceInstruction_DDADescriptionAUD}    ${sCustomer_Location}

    ### GetRuntime Keyword Pre-processing ###
    ${RemittanceInstruction_DDADescriptionAUD}    Acquire Argument Value    ${sRemittanceInstruction_DDADescriptionAUD}
    ${Customer_Location}    Acquire Argument Value    ${sCustomer_Location}

    Mx LoanIQ DoubleClick    ${RemittanceList_Window_RemittanceList}    ${RemittanceInstruction_DDADescriptionAUD}
    Release Remittance Instruction
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/RemittanceInstructionsDetailWindow
    Mx LoanIQ Select    ${LIQ_RemittanceInstruction_Notebook_FileMenu_ExitMenu}

Releasing DDA-AUD Remittance Instruction
    [Documentation]    This keyword release DDA-AUD Remittance Instruction to the Details of a Contact of a Customer
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and removed unused keywords
    [Arguments]    ${sRemittanceInstruction_DDADescriptionAUD}    ${sCustomer_Location}        
    
    Mx LoanIQ DoubleClick    ${RemittanceList_Window_RemittanceList}    ${sRemittanceInstruction_DDADescriptionAUD}
    Release Remittance Instruction
    Mx LoanIQ Select    ${LIQ_RemittanceInstruction_Notebook_FileMenu_ExitMenu}      
    Read Excel Data and Validate Remittance Instructions Data Added in the Remittance List Window    ${sRemittanceInstruction_DDADescriptionAUD}    ${sCustomer_Location}
 
Approving IMT-USD Remittance Instruction
    [Documentation]    This keyword approves IMT-USD Remittance Instruction to the Details of a Contact of a Customer
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and removed unused keywords
    [Arguments]    ${sRemittanceInstruction_IMTDescriptionUSD}    ${sCustomer_Location}        
    
    Mx LoanIQ DoubleClick    ${RemittanceList_Window_RemittanceList}    ${sRemittanceInstruction_IMTDescriptionUSD}
    Approve Remittance Instruction
    Mx LoanIQ Select    ${LIQ_RemittanceInstruction_Notebook_FileMenu_ExitMenu}      
    Read Excel Data and Validate Remittance Instructions Data Added in the Remittance List Window    ${sRemittanceInstruction_IMTDescriptionUSD}    ${sCustomer_Location}

Releasing IMT-USD Remittance Instruction
    [Documentation]    This keyword release IMT-USD Remittance Instruction to the Details of a Contact of a Customer
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and removed unused keywords
    [Arguments]    ${sRemittanceInstruction_IMTDescriptionUSD}    ${sCustomer_Location}        
    
    Mx LoanIQ DoubleClick    ${RemittanceList_Window_RemittanceList}    ${sRemittanceInstruction_IMTDescriptionUSD}
    Release Remittance Instruction
    Mx LoanIQ Select    ${LIQ_RemittanceInstruction_Notebook_FileMenu_ExitMenu}      
    Read Excel Data and Validate Remittance Instructions Data Added in the Remittance List Window    ${sRemittanceInstruction_IMTDescriptionUSD}    ${sCustomer_Location}

Approving RTGS-AUD Remittance Instruction
    [Documentation]    This keyword approves DDA-AUD Remittance Instruction to the Details of a Contact of a Customer
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and removed unused keywords
    [Arguments]    ${sRemittanceInstruction_RTGSDescriptionAUD}    ${sCustomer_Location}        
    
    Mx LoanIQ DoubleClick    ${RemittanceList_Window_RemittanceList}    ${sRemittanceInstruction_RTGSDescriptionAUD}
    Approve Remittance Instruction
    Mx LoanIQ Select    ${LIQ_RemittanceInstruction_Notebook_FileMenu_ExitMenu}      
    Read Excel Data and Validate Remittance Instructions Data Added in the Remittance List Window    ${sRemittanceInstruction_RTGSDescriptionAUD}    ${sCustomer_Location}

Releasing RTGS-AUD Remittance Instruction
    [Documentation]    This keyword release RTGS-AUD Remittance Instruction to the Details of a Contact of a Customer
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and removed unused keywords
    [Arguments]    ${sRemittanceInstruction_RTGSDescriptionAUD}    ${sCustomer_Location}        
    
    Mx LoanIQ DoubleClick    ${RemittanceList_Window_RemittanceList}    ${sRemittanceInstruction_RTGSDescriptionAUD}
    Release Remittance Instruction
    Mx LoanIQ Select    ${LIQ_RemittanceInstruction_Notebook_FileMenu_ExitMenu}      
    Read Excel Data and Validate Remittance Instructions Data Added in the Remittance List Window    ${sRemittanceInstruction_RTGSDescriptionAUD}    ${sCustomer_Location}

Send Remittance Instruction to Approval
    [Documentation]    This keyword is used to do 'send to approval' process for a remittance instruction 
    ...    @author: ghabal

    Mx LoanIQ Activate   ${RemittanceList_Window_RemittanceInstructionsDetail_Window}
    Mx LoanIQ Select Window Tab    ${RemittanceList_Window_RemittanceInstructionsDetail__Notebook_TabSelection}    Workflow
    Mx LoanIQ DoubleClick    ${LIQ_RemittanceInstruction_Notebook_WorkflowAction}    Send to Approval  
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}

Approve Remittance Instruction
    [Documentation]    This keyword is used to do 'approval' process for a remittance instruction 
    ...    @author: ghabal

    Mx LoanIQ Activate   ${RemittanceList_Window_RemittanceInstructionsDetail_Window}
    Mx LoanIQ Select Window Tab    ${RemittanceList_Window_RemittanceInstructionsDetail__Notebook_TabSelection}    Workflow
    Mx LoanIQ DoubleClick    ${LIQ_RemittanceInstruction_Notebook_WorkflowAction}    Approval  
    Mx LoanIQ Click Element If Present    ${LIQ_Question_Yes_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}

Release Remittance Instruction
    [Documentation]    This keyword is used to do 'release' process for a remittance instruction 
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - removed unused keyword

    Mx LoanIQ Activate   ${RemittanceList_Window_RemittanceInstructionsDetail_Window}
    Mx LoanIQ Select Window Tab    ${RemittanceList_Window_RemittanceInstructionsDetail__Notebook_TabSelection}    Workflow
    Mx LoanIQ DoubleClick    ${LIQ_RemittanceInstruction_Notebook_WorkflowAction}    Release  
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}

Add and Complete Location, Fax and Contact Details 
    [Documentation]    This keyword is used to add and complete location, Fax and Contact Details  
    ...    @author: ghabal
    ...    @update: amansuet    22MAY2020    - updated to align with automation standards and removed unused keywords
    [Arguments]    ${sCustomer_Location}     ${sProfile_Type}    ${sFax_Number}    ${sFax_Description}    ${sLIQCustomer_ShortName}   ${sContact_FirstName}   
    ...    ${sContact_LastName}   ${sContact_PreferredLanguage}   ${sContact_PrimaryPhone}   ${sBorrowerContact_Phone}    ${sContact_PurposeType}    ${sContactNotice_Method}    ${sContact_Email}
    ...    ${sProductSBLC_Checkbox}    ${sProductLoan_Checkbox}    ${sBalanceType_Principal_Checkbox}    ${sBalanceType_Interest_Checkbox}    ${sBalanceType_Fees_Checkbox}    ${sAddress_Code}    
    
    ###Adding Location###          
    Add Location under Profiles Tab    ${sCustomer_Location}  
    
    ###Adding Borrowwer/Location Details###
    Add Borrower/Location Details under Profiles Tab   ${sProfile_Type}    ${sCustomer_Location}    
    
    ###Validating Buttons if Enabled###
    Validate If All Buttons are Enabled
    
	###Adding Fax Details###                 
    Add Fax Details under Profiles Tab    ${sCustomer_Location}    ${sFax_Number}    ${sFax_Description}    
    
    ###Adding Contact Details###
    Add Contact under Profiles Tab    ${sCustomer_Location}    ${sLIQCustomer_ShortName}    ${sContact_FirstName}    ${sContact_LastName}    ${sContact_PreferredLanguage}    ${sContact_PrimaryPhone}    ${sBorrowerContact_Phone}    ${sContact_PurposeType}    ${sContactNotice_Method}    ${sContact_Email}
    ...    ${sProductSBLC_Checkbox}    ${sProductLoan_Checkbox}    ${sBalanceType_Principal_Checkbox}    ${sBalanceType_Interest_Checkbox}    ${sBalanceType_Fees_Checkbox}    ${sAddress_Code}
    
    ###Completing Location###              
    Complete Location under Profile Tab    ${sProfile_Type}    ${sCustomer_Location}

Navigate to Remittance List Page
    [Documentation]    This keyword navigates user from Profile to Remittance List Window
    ...    @author: fmamaril    19AUG2019
    ...    @update: amansuet    19MAY2020    - added take screenshot keyword

    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    Profiles
    Mx LoanIQ Click    ${RemittanceInstructions_Button}
    Mx LoanIQ Activate Window    ${RemittanceList_Window_RemittanceInstructionsDetail_Window}   
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/RemittanceListWindow

Get Customer ID at Active Customer Window
    [Documentation]    This keyword gets the Customer ID at the Active Customer Window.
    ...    @author: hstone    10SEP2019
    mx LoanIQ activate window    ${LIQ_ActiveCustomer_Window}
    ${CustomerID}    Mx LoanIQ Get Data    ${LIQ_ActiveCustomer_Window_CustomerID}    text          
    Log    Cusomter ID is "${CustomerID}". Customer ID Value succesfully acquired.
    mx LoanIQ close window    ${LIQ_ActiveCustomer_Window}  
    [Return]    ${CustomerID}

Close Remittance List Window
    [Documentation]    This keyword selects the exit button to close the Remittance List window.
    ...                @author: amansuet    24APR2020    - initial create

    Mx LoanIQ Click    ${RemittanceList_Window_ExitButton}

Add Standard Remittance Instruction
    [Documentation]    This keyword adds Remittance Instruction to the Details of a Contact of a Customer
    ...    @author: amansuet    22MAY2020    - initial create
    [Arguments]    ${sCustomer_Location}    ${sRemittanceInstruction_Method}    ${sRemittanceInstruction_Description}    ${sRemittanceInstruction_Currency}    
    ...    ${bRI_ProductLoan_Checkbox}    ${bRI_ProductSBLC_Checkbox}    ${bRI_FromCust_Checkbox}    ${bRI_ToCust_Checkbox}    ${bRI_BalanceType_Principal_Checkbox}    ${bRI_BalanceType_Interest_Checkbox}    ${bRI_BalanceType_Fees_Checkbox}    ${bRI_AutoDoIt_Checkbox}
    ...    ${sRemittanceInstruction_DDAAccountName}=None    ${sRemittanceInstruction_DDAAccountNumber}=None    ${sIMT_MessageCode}=None    ${sBOC_Level}=None    ${bRI_SendersCorrespondent_Checkbox}=OFF    ${sRemittanceInstruction_DirectionSelected}=None
    
	### Keyword Pre-processing ###
    ${Customer_Location}    Acquire Argument Value    ${sCustomer_Location}
    ${RemittanceInstruction_Method}    Acquire Argument Value    ${sRemittanceInstruction_Method}
    ${RemittanceInstruction_Description}    Acquire Argument Value    ${sRemittanceInstruction_Description}
    ${RemittanceInstruction_Currency}    Acquire Argument Value    ${sRemittanceInstruction_Currency}
    ${RI_ProductLoan_Checkbox}    Acquire Argument Value    ${bRI_ProductLoan_Checkbox}
    ${RI_ProductSBLC_Checkbox}    Acquire Argument Value    ${bRI_ProductSBLC_Checkbox}
    ${RI_FromCust_Checkbox}    Acquire Argument Value    ${bRI_FromCust_Checkbox}
    ${RI_ToCust_Checkbox}    Acquire Argument Value    ${bRI_ToCust_Checkbox}
    ${RI_BalanceType_Principal_Checkbox}    Acquire Argument Value    ${bRI_BalanceType_Principal_Checkbox}
    ${RI_BalanceType_Interest_Checkbox}    Acquire Argument Value    ${bRI_BalanceType_Interest_Checkbox}
    ${RI_BalanceType_Fees_Checkbox}    Acquire Argument Value    ${bRI_BalanceType_Fees_Checkbox}
    ${RI_AutoDoIt_Checkbox}    Acquire Argument Value    ${bRI_AutoDoIt_Checkbox}
    ${RemittanceInstruction_DDAAccountName}    Acquire Argument Value    ${sRemittanceInstruction_DDAAccountName}
    ${RemittanceInstruction_DDAAccountNumber}    Acquire Argument Value    ${sRemittanceInstruction_DDAAccountNumber}
    ${IMT_MessageCode}    Acquire Argument Value    ${sIMT_MessageCode}
    ${BOC_Level}    Acquire Argument Value    ${sBOC_Level}
    ${RI_SendersCorrespondent_Checkbox}    Acquire Argument Value    ${bRI_SendersCorrespondent_Checkbox}
    ${RemittanceInstruction_DirectionSelected}    Acquire Argument Value    ${sRemittanceInstruction_DirectionSelected}
    
    Mx LoanIQ Click    ${RemittanceList_Window_AddButton}
    Mx LoanIQ Activate    ${RemittanceList_Window_AddRemittanceInstruction_Window}
    Validate Window Title    Add Remittance Instruction
    Mx LoanIQ Click    ${RemittanceList_Window_AddRemittanceInstruction_OkButton}
    Validate Remittance Instructions Detail Window    ${Customer_Location}
    
	Run Keyword If    '${RemittanceInstruction_Method}'=='DDA (Demand Deposit Acct)'    Adding DDA Remittance Instructions Details    ${sRemittanceInstruction_Method}    ${RemittanceInstruction_Description}    ${RemittanceInstruction_DDAAccountName}    ${RemittanceInstruction_DDAAccountNumber}    ${RemittanceInstruction_Currency}
    ...    ${RI_ProductLoan_Checkbox}    ${RI_ProductSBLC_Checkbox}    ${RI_FromCust_Checkbox}    ${RI_ToCust_Checkbox}    ${RI_BalanceType_Principal_Checkbox}    ${RI_BalanceType_Interest_Checkbox}    ${RI_BalanceType_Fees_Checkbox}    ${RI_AutoDoIt_Checkbox}
	...    ELSE IF    '${RemittanceInstruction_Method}'=='International Money Transfer'    Adding IMT Remittance Instructions_Details    ${sRemittanceInstruction_Method}    ${RemittanceInstruction_Description}    ${RemittanceInstruction_Currency}    ${RemittanceInstruction_DirectionSelected}    ${IMT_MessageCode}    ${BOC_Level}
    ...    ${RI_FromCust_Checkbox}    ${RI_AutoDoIt_Checkbox}    ${RI_SendersCorrespondent_Checkbox}
	...    ELSE IF    '${RemittanceInstruction_Method}'=='High Value Local RTGS (AUD)'    Adding RTGS Remittance Instructions_Details    ${sRemittanceInstruction_Method}    ${RemittanceInstruction_Description}   ${RemittanceInstruction_Currency}    ${RemittanceInstruction_DirectionSelected}    ${IMT_MessageCode}    ${BOC_Level}
    ...    ${RI_FromCust_Checkbox}    ${RI_AutoDoIt_Checkbox}    ${RI_SendersCorrespondent_Checkbox}
	...    ELSE    Log    Selected Remittance Instruction Method is invalid.    level=WARN
	
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/DDARemittanceInstructionsDetailWindow
    Send Remittance Instruction to Approval
    Mx LoanIQ Select    ${LIQ_RemittanceInstruction_Notebook_FileMenu_ExitMenu}

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRemittanceInstruction_Description}    ${RemittanceInstruction_Description}

Add Internal Risk Rating
    [Documentation]    This keyword adds an internal risk rating at the customer notebook.
    ...    @author: hstone    09JUN2020    - initial create
    [Arguments]    ${sRatingType}    ${sRating}    ${sPercent}    ${sEffectiveDate}    ${sExpiryDate}

    ### Keyword Pre-processing ###
    ${RatingType}    Acquire Argument Value    ${sRatingType}
    ${Rating}    Acquire Argument Value    ${sRating}
    ${Percent}    Acquire Argument Value    ${sPercent}
    ${EffectiveDate}    Acquire Argument Value    ${sEffectiveDate}
    ${ExpiryDate}    Acquire Argument Value    ${sExpiryDate}

    ### Active Customer Window ###
    Mx LoanIQ Activate    ${LIQ_ActiveCustomer_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    Risk
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ActiveCustomer_Risk
    Mx LoanIQ Click    ${LIQ_Active_Customer_Notebook_RiskTab_AddInternal_Button}

    ### Internal Risk Rating Window ###
    Mx LoanIQ Activate    ${LIQ_Active_Customer_Notebook_RiskTab_InternalRiskRating_Window}
    Mx LoanIQ Select Combo Box Value    ${LIQ_Active_Customer_Notebook_RiskTab_InternalRiskRating_RatingTypeField}    ${RatingType}
    Mx LoanIQ Select Combo Box Value    ${LIQ_Active_Customer_Notebook_RiskTab_InternalRiskRating_RatingField}    ${Rating}
    mx LoanIQ enter    ${LIQ_Active_Customer_Notebook_RiskTab_InternalRiskRating_PercentField}    ${Percent}
    mx LoanIQ enter    ${LIQ_Active_Customer_Notebook_RiskTab_InternalRiskRating_EffectiveDateField}    ${EffectiveDate}
    mx LoanIQ enter    ${LIQ_Active_Customer_Notebook_RiskTab_InternalRiskRating_ExpiryDateField}    ${ExpiryDate}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AddInternalRiskRating
    mx LoanIQ click    ${LIQ_Active_Customer_Notebook_RiskTab_InternalRiskRating_OkButton}
    mx LoanIQ click element if present    ${LIQ_Active_Customer_Notebook_RiskTab_InternalRiskRating_OkButton}

Validate Internal Risk Rating Table
    [Documentation]    This keyword adds validates internal risk rating table at the customer notebook.
    ...    @author: hstone    09JUN2020    - initial create
    [Arguments]    ${sRatingType}    ${sRating}    ${sPercent}    ${sEffectiveDate}    ${sExpiryDate}

    ### Keyword Pre-processing ###
    ${Reference_RatingType}    Acquire Argument Value    ${sRatingType}
    ${Expected_Rating}    Acquire Argument Value    ${sRating}
    ${Expected_Percent}    Acquire Argument Value    ${sPercent}
    ${Expected_EffectiveDate}    Acquire Argument Value    ${sEffectiveDate}
    ${Expected_ExpiryDate}    Acquire Argument Value    ${sExpiryDate}

    ### Active Customer Window ###
    Mx LoanIQ Activate    ${LIQ_ActiveCustomer_Window}

    ### Acquire Actual UI Values ###
    ${Actual_Rating}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Active_Customer_Notebook_RiskTab_InternalRiskRating_JavaTree}    ${Reference_RatingType}%Rating%Rating
    ${Actual_Percent}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Active_Customer_Notebook_RiskTab_InternalRiskRating_JavaTree}    ${Reference_RatingType}%Percent%Percent
    ${Actual_EffectiveDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Active_Customer_Notebook_RiskTab_InternalRiskRating_JavaTree}    ${Reference_RatingType}%Effective%EffectiveDate
    ${Actual_ExpiryDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Active_Customer_Notebook_RiskTab_InternalRiskRating_JavaTree}    ${Reference_RatingType}%Expiry%ExpiryDate

    ${Expected_Percent}    Convert Number to Percentage Format    ${Expected_Percent}    2

    ### Compare Actual UI Values to Expected Values ###
    Run Keyword And Continue On Failure    Should Be Equal   ${Actual_Rating}    ${Expected_Rating}
    Run Keyword And Continue On Failure    Should Be Equal   ${Actual_Percent}    ${Expected_Percent}
    Run Keyword And Continue On Failure    Should Be Equal   ${Actual_EffectiveDate}    ${Expected_EffectiveDate}
    Run Keyword And Continue On Failure    Should Be Equal   ${Actual_ExpiryDate}    ${Expected_ExpiryDate}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ActiveCustomer_Risk

Add External Risk Rating
    [Documentation]    This keyword adds an external risk rating at the customer notebook.
    ...    @author: hstone    09JUN2020    - initial create
    [Arguments]    ${sRatingType}    ${sRating}    ${sStartDate}

    ### Keyword Pre-processing ###
    ${RatingType}    Acquire Argument Value    ${sRatingType}
    ${Rating}    Acquire Argument Value    ${sRating}
    ${StartDate}    Acquire Argument Value    ${sStartDate}

    ### Active Customer Window ###
    Mx LoanIQ Activate    ${LIQ_ActiveCustomer_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    Risk
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ActiveCustomer_Risk
    Mx LoanIQ Click    ${LIQ_Active_Customer_Notebook_RiskTab_AddExternal_Button}

    ### External Risk Rating Window ###
    Mx LoanIQ Activate    ${LIQ_Active_Customer_Notebook_RiskTab_ExternalRiskRating_Window}
    Mx LoanIQ Select Combo Box Value    ${LIQ_Active_Customer_Notebook_RiskTab_ExtenalRiskRating_RatingTypeField}    ${RatingType}
    Mx LoanIQ Select Combo Box Value    ${LIQ_Active_Customer_Notebook_RiskTab_ExtenalRiskRating_RatingField}    ${Rating}
    mx LoanIQ enter    ${LIQ_Active_Customer_Notebook_RiskTab_ExtenalRiskRating_StartDateField}    ${StartDate}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AddExternalRiskRating
    Mx LoanIQ Click    ${LIQ_Active_Customer_Notebook_RiskTab_ExtenalRiskRating_OKButton}

Validate External Risk Rating Table
    [Documentation]    This keyword adds validates external risk rating table at the customer notebook.
    ...    @author: hstone    09JUN2020    - initial create
    [Arguments]    ${sRatingType}    ${sRating}    ${sStartDate}

    ### Keyword Pre-processing ###
    ${Reference_RatingType}    Acquire Argument Value    ${sRatingType}
    ${Expected_Rating}    Acquire Argument Value    ${sRating}
    ${Expected_StartDate}    Acquire Argument Value    ${sStartDate}

    ### Active Customer Window ###
    Mx LoanIQ Activate    ${LIQ_ActiveCustomer_Window}

    ### Acquire Actual UI Values ###
    ${Actual_Rating}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Active_Customer_Notebook_RiskTab_ExternalRiskRating_JavaTree}    ${Reference_RatingType}%Rating%Rating
    ${Actual_StartDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Active_Customer_Notebook_RiskTab_ExternalRiskRating_JavaTree}    ${Reference_RatingType}%Effective%StartDate

    ### Compare Actual UI Values to Expected Values ###
    Run Keyword And Continue On Failure    Should Be Equal   ${Actual_Rating}    ${Expected_Rating}
    Run Keyword And Continue On Failure    Should Be Equal   ${Actual_StartDate}    ${Expected_StartDate}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ActiveCustomer_Risk

Populate Details on Customer Remittance Instructions
    [Documentation]    This keyword populates the Customer Remittance Instruction Details
    ...    @author: fmamaril    16AUG2019
    ...    @update: ritragel    16AUG2020    Added Activate Window to for 2nd round of run to focus on Remmitance Instruction List
    ...    @update: ritragel    17AUG2020    Added Keyword preprocessing for customization
    [Arguments]    ${sRemittanceInstruction_Method}    ${sRemittanceInstruction_Description}    ${sRemittanceInstruction_Currency}    ${sProductLoan_Checkbox}    ${sProductSBLC_Checkbox}
    ...    ${sRI_FromCust_Checkbox}    ${sRI_ToCust_Checkbox}    ${sBalanceType_Principal_Checkbox}    ${sBalanceType_Interest_Checkbox}    ${sBalanceType_Fees_Checkbox}
    ...    ${sRI_AutoDoIt_Checkbox}    ${sNoticesSummary}
    
    ### Keyword Pre-processing ###
    ${RemittanceInstruction_Method}    Acquire Argument Value    ${sRemittanceInstruction_Method}
    ${RemittanceInstruction_Description}    Acquire Argument Value    ${sRemittanceInstruction_Description}
    ${RemittanceInstruction_Currency}    Acquire Argument Value    ${sRemittanceInstruction_Currency}
    ${ProductLoan_Checkbox}    Acquire Argument Value    ${sProductLoan_Checkbox}
    ${ProductSBLC_Checkbox}    Acquire Argument Value    ${sProductSBLC_Checkbox}
    ${RI_FromCust_Checkbox}    Acquire Argument Value    ${sRI_FromCust_Checkbox}
    ${RI_ToCust_Checkbox}    Acquire Argument Value    ${sRI_ToCust_Checkbox}
    ${BalanceType_Principal_Checkbox}    Acquire Argument Value    ${sBalanceType_Principal_Checkbox}    
    ${BalanceType_Interest_Checkbox}    Acquire Argument Value    ${sBalanceType_Interest_Checkbox}  
    ${BalanceType_Fees_Checkbox}    Acquire Argument Value    ${sBalanceType_Fees_Checkbox}  
    ${RI_AutoDoIt_Checkbox}    Acquire Argument Value    ${sRI_AutoDoIt_Checkbox}
    ${NoticesSummary}    Acquire Argument Value    ${sNoticesSummary}


    mx LoanIQ Activate Window    ${RemittanceList_Window_RemittanceInstructionsDetail_Window}             
    mx LoanIQ click    ${RemittanceList_Window_AddButton}
    mx LoanIQ activate    ${RemittanceList_Window_AddRemittanceInstruction_Window}
    Validate Window Title    Add Remittance Instruction
    mx LoanIQ click    ${RemittanceList_Window_AddRemittanceInstruction_OkButton} 
    mx LoanIQ activate window   ${RemittanceList_Window_RemittanceInstructionsDetail_Window}
    Mx LoanIQ Select Window Tab    ${RemittanceList_Window_RemittanceInstructionsDetail__Notebook_TabSelection}    General
    Mx LoanIQ Select Combo Box Value    ${RemittanceList_Window_RemittanceInstructionsDetail_MethodType}    ${RemittanceInstruction_Method}
    mx LoanIQ enter    ${RemittanceList_Window_RemittanceInstructionsDetail_Description}    ${RemittanceInstruction_Description}    
    Mx LoanIQ Select Combo Box Value    ${RemittanceList_Window_RemittanceInstructionsDetail_Currency}    ${RemittanceInstruction_Currency}
    Mx LoanIQ Check Or Uncheck    ${RemittanceList_Window_RemittanceInstructionsDetail_ProductLoan_Checkbox}    ${ProductLoan_Checkbox}
    Mx LoanIQ Check Or Uncheck    ${RemittanceList_Window_RemittanceInstructionsDetail_ProductSBLC_Checkbox}    ${ProductSBLC_Checkbox}    
    Mx LoanIQ Check Or Uncheck    ${RemittanceList_Window_RemittanceInstructionsDetail_Direction_FromCust_Checkbox}    ${RI_FromCust_Checkbox}
    Mx LoanIQ Check Or Uncheck    ${RemittanceList_Window_RemittanceInstructionsDetail_Direction_ToCust_Checkbox}    ${RI_ToCust_Checkbox}
    Mx LoanIQ Check Or Uncheck    ${RemittanceList_Window_RemittanceInstructionsDetail_BalanceType_Principal_Checkbox}    ${BalanceType_Principal_Checkbox}      
    Mx LoanIQ Check Or Uncheck    ${RemittanceList_Window_RemittanceInstructionsDetail_BalanceType_Interest_Checkbox}    ${BalanceType_Interest_Checkbox}
    Mx LoanIQ Check Or Uncheck    ${RemittanceList_Window_RemittanceInstructionsDetail_BalanceType_Fees_Checkbox}    ${BalanceType_Fees_Checkbox}    
    Mx LoanIQ Check Or Uncheck    ${RemittanceList_Window_RemittanceInstructionsDetail_AutoDoIt_Checkbox}    ${RI_AutoDoIt_Checkbox}
    Run Keyword If    '${sRI_FromCust_Checkbox}'=='OFF'    mx LoanIQ enter    ${RemittanceList_Window_RemittanceInstructionsDetail_SummaryNotices_TextField}    ${NoticesSummary}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Remittance_Instruction_List

Add IMT Message in Remittance Instructions Detail
    [Documentation]    This keyword adds IMT message in Remittance Instructions detail of a Customer
    ...    @author: fmamaril    19AUG2019
    ...    @update: ritragel    17AUG2020    Added Keyword preprocessing for customization
    [Arguments]    ${sIMT_MessageCode} 
   
    ### Keyword Pre-processing ###
    ${IMT_MessageCode}    Acquire Argument Value    ${sIMT_MessageCode}
 
    mx LoanIQ click    ${RemittanceList_Window_RemittanceInstructionsDetail_AddButton}    
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ enter   ${RemittanceList_Window_RemittanceInstructionsDetail_SelectMessageType_SearchField}    ${IMT_MessageCode}
    Mx Native Type    {ENTER}
    mx LoanIQ activate window    ${RemittanceList_Window_RemittanceInstructionsDetail_IMT_Window}
    Mx LoanIQ Check Or Uncheck    ${RemittanceList_Window_RemittanceInstructionsDetail_IMT_SendersCorrespondent_Checkbox}    ON
    
Add Swift Role in IMT message
    [Documentation]    This keyword adds a swift role in IMT message
    ...    @author: fmamaril    19AUG2019
    ...    @update: ritragel    17AUG2020    Added Keyword preprocessing for customization
    [Arguments]    ${sRI_SendersCorrespondent_Checkbox}    ${sSwift_Role}    ${sSwiftID}    ${sSwift_Description}=${EMPTY}
    ...    ${sClearingType}=${EMPTY}    ${sClearingNumber}=${EMPTY}    ${sAccountNumber}=${EMPTY}

    ### Keyword Pre-processing ###
    ${RI_SendersCorrespondent_Checkbox}    Acquire Argument Value    ${sRI_SendersCorrespondent_Checkbox}    
    ${Swift_Role}    Acquire Argument Value    ${sSwift_Role}    
    ${SwiftID}    Acquire Argument Value    ${sSwiftID}    
    ${Swift_Description}    Acquire Argument Value    ${sSwift_Description}
    ${ClearingType}    Acquire Argument Value    ${sClearingType}
    ${ClearingNumber}    Acquire Argument Value    ${sClearingNumber}
    ${AccountNumber}    Acquire Argument Value    ${sAccountNumber}    

    mx LoanIQ activate window    ${RemittanceList_Window_RemittanceInstructionsDetail_IMT_Window}            
    Mx LoanIQ Check Or Uncheck    ${RemittanceList_Window_RemittanceInstructionsDetail_IMT_SendersCorrespondent_Checkbox}    ${RI_SendersCorrespondent_Checkbox}
    mx LoanIQ click    ${RemittanceList_Window_RemittanceInstructionsDetail_IMT_AddButton}
    mx LoanIQ activate window    ${RemittanceList_Window_RemittanceInstructionsDetail_AddSwiftID_Window}  
    Mx LoanIQ select combo box value    ${RemittanceList_Window_RemittanceInstructionsDetail_SwiftRoleType}    ${Swift_Role}    
    Run Keyword If    '${sSwiftID}'!='${EMPTY}'    mx LoanIQ click    ${RemittanceList_Window_RemittanceInstructionsDetail_SwiftIDButton}
    Run Keyword If    '${sSwiftID}'!='${EMPTY}'    mx LoanIQ enter    ${RemittanceList_Window_RemittanceInstructionsDetail_SearchBySWIFTID}    ON
    Run Keyword If    '${sSwiftID}'!='${EMPTY}'    mx LoanIQ enter    ${RemittanceList_Window_RemittanceInstructionsDetail_SWIFTIDInputField}    ${SwiftID}    
    Run Keyword If    '${sSwiftID}'!='${EMPTY}'    mx LoanIQ click    ${RemittanceList_Window_RemittanceInstructionsDetail_OKButton} 
    Run Keyword If    '${sSwiftID}'!='${EMPTY}'    mx LoanIQ activate window    ${RemittanceList_Window_RemittanceInstructionsDetail_AddSwiftID_Window}
    Run Keyword If    '${sSwiftID}'=='${EMPTY}'    Mx Native Type    {TAB}
    Run Keyword If    '${sSwiftID}'=='${EMPTY}'    Mx Native Type    {TAB}    
    Run Keyword If    '${sSwift_Description}'!='${EMPTY}'    mx LoanIQ enter    ${RemittanceList_Window_RemittanceInstructionsDetail_AddSwiftID_Description}    ${Swift_Description}
    Run Keyword If    '${sClearingType}'!='${EMPTY}'    Mx LoanIQ Select Combo Box Value    ${RemittanceList_Window_RemittanceInstructionsDetail_AddSwiftID_ClearingTypeList}    ${ClearingType}    
    Run Keyword If    '${sClearingNumber}'!='${EMPTY}'    mx LoanIQ enter    ${RemittanceList_Window_RemittanceInstructionsDetail_AddSwiftID_ClearingNumber}    ${ClearingNumber}
    Run Keyword If    '${sAccountNumber}'!='${EMPTY}'    mx LoanIQ enter    ${RemittanceList_Window_RemittanceInstructionsDetail_AddSwiftID_AccountNumber}    ${AccountNumber}
    mx LoanIQ click    ${RemittanceList_Window_RemittanceInstructionsDetail_AddSwiftID_OKButton}
    
Update Swift Role in IMT message    
    [Documentation]    This keyword updates a swift role in IMT message
    ...    @author: fmamaril    19AUG2019
    ...    @update: ritragel    17AUG2020    Added Keyword preprocessing for customization
    [Arguments]    ${sSwift_Role}    ${sSwift_Description}=${EMPTY}    ${sClearingType}=${EMPTY}    ${sClearingNumber}=${EMPTY}    ${sAccountNumber}=${EMPTY}      

    ### Keyword Pre-processing ###  
    ${Swift_Role}    Acquire Argument Value    ${sSwift_Role} 
    ${Swift_Description}    Acquire Argument Value    ${sSwift_Description}
    ${ClearingType}    Acquire Argument Value    ${sClearingType}
    ${ClearingNumber}    Acquire Argument Value    ${sClearingNumber}
    ${AccountNumber}    Acquire Argument Value    ${sAccountNumber}

    mx LoanIQ activate window    ${RemittanceList_Window_RemittanceInstructionsDetail_IMT_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${RemittanceList_Window_RemittanceInstructionsDetail_IMT_SwiftRoleList}    ${SwiftRole}%d    
    mx LoanIQ activate window    ${RemittanceList_Window_RemittanceInstructionsDetail_AddSwiftID_Window}
    Run Keyword If    '${sSwift_Description}'!='${EMPTY}'    mx LoanIQ enter    ${RemittanceList_Window_RemittanceInstructionsDetail_UpdateMode_AddSwiftID_Description}    ${Swift_Description}
    Run Keyword If    '${sClearingType}'!='${EMPTY}'    Mx LoanIQ Select Combo Box Value    ${RemittanceList_Window_RemittanceInstructionsDetail_UpdateMode_ClearingTypeList}    ${ClearingType}            
    Run Keyword If    '${sClearingNumber}'!='${EMPTY}'    mx LoanIQ enter    ${RemittanceList_Window_RemittanceInstructionsDetail_UpdateMode_AddSwiftID_ClearingNumber}    ${ClearingNumber}
    Run Keyword If    '${sAccountNumber}'!='${EMPTY}'    mx LoanIQ enter    ${RemittanceList_Window_RemittanceInstructionsDetail_UpdateMode_AddSwiftID_AccountNumber}    ${AccountNumber}    
    mx LoanIQ click    ${RemittanceList_Window_RemittanceInstructionsDetail_UpdateMode_AddSwiftID_OKButton}
    
Populate Details on IMT     
    [Documentation]    This keyword populates details in IMT message window
    ...    @author: fmamaril    19AUG2019
    ...    @update: ritragel    17AUG2020    Added Keyword preprocessing for customization
    [Arguments]    ${sDetails_Of_Charges}=${EMPTY}    ${sBOC_Level}=${EMPTY}    ${sDetailsOfPayment}=${EMPTY}    ${sSenderToReceiverInfo}=${EMPTY}    ${sOrderingCustomer}=${EMPTY}

    ### Keyword Pre-processing ###  
    ${Details_Of_Charges}    Acquire Argument Value    ${sDetails_Of_Charges} 
    ${BOC_Level}    Acquire Argument Value    ${sBOC_Level} 
    ${DetailsOfPayment}    Acquire Argument Value    ${sDetailsOfPayment} 
    ${SenderToReceiverInfo}    Acquire Argument Value    ${sSenderToReceiverInfo} 
    ${OrderingCustomer}    Acquire Argument Value    ${sOrderingCustomer} 
                       
    mx LoanIQ activate window    ${RemittanceList_Window_RemittanceInstructionsDetail_IMT_Window}
    Run Keyword If    '${sDetailsOfPayment}'!='${EMPTY}'    Mx LoanIQ Select Combo Box Value    ${RemittanceList_Window_RemittanceInstructionsDetail_IMT_DetailsofCharges}    ${Details_Of_Charges}
    Run Keyword If    '${sDetailsOfPayment}'!='${EMPTY}'    mx LoanIQ enter    ${RemittanceList_Window_RemittanceInstructionsDetail_IMT_DetailsofPayment}    ${DetailsOfPayment}
    Run Keyword If    '${sSenderToReceiverInfo}'!='${EMPTY}'    mx LoanIQ enter    ${RemittanceList_Window_RemittanceInstructionsDetail_IMT_SenderToReceiver}    ${SenderToReceiverInfo}        
    Run Keyword If    '${sBOC_Level}'!='${EMPTY}'    Mx LoanIQ Select Combo Box Value    ${RemittanceList_Window_RemittanceInstructionsDetail_IMT_BankOperationCode}    ${BOC_Level}
    Run Keyword If    '${sOrderingCustomer}'!='${EMPTY}'    mx LoanIQ enter    ${RemittanceList_Window_RemittanceInstructionsDetail_IMT_OrderingCustomer}    ${OrderingCustomer}    