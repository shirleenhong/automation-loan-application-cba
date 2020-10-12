*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot
Resource    ../../../Configurations/Party_Import_File.robot

*** Keywords ***

Navigate to Customer Notebook via Customer ID
    [Documentation]    This keyword searches customer in Customer notebook using Customer/PartyID
    ...    @author: dahijara    06MAY2020    - Initial Create
    ...    @update: javinzon    16SEP2020    - Added Refresh Tables in LIQ. Updated keyword Capture Screenshot to Take Screenshot

    [Arguments]    ${sLIQCustomer_CustomerID}         
    Refresh Tables in LIQ
    Select Actions    [Actions];Customer
    mx LoanIQ activate window    ${LIQ_CustomerSelect_Window}
    Validate Window Title    Customer Select
    Mx LoanIQ Select    ${LIQ_CustomerSelect_Search_Filter}    Customer ID
    mx LoanIQ enter    ${LIQ_CustomerSelect_Search_Inputfield}     ${sLIQCustomer_CustomerID}
    Take Screenshot    ${screenshot_path}/Screenshots/Party/PartyLIQCustomerSearchPage   
    mx LoanIQ click    ${LIQ_CustomerSelect_OK_Button}
    mx LoanIQ activate window    ${LIQ_ActiveCustomer_Window}  

Return Customer Details from Active Customer General Tab
    [Documentation]    This keyword searches customer in Customer notebook using Customer/PartyID
    ...    @author: dahijara    06MAY2020    - Initial Create
    ...    @update: javinzon    18SEP2020    - Updated keyword Capture Screenshot to Take Screenshot. Updated name of ${LIQ_ActiveCustomer_Window_GSTID_Textbox}.

    Take Screenshot    ${screenshot_path}/Screenshots/Party/PartyLIQActiveCustomerGeneralTabPage 
    ${CustomerID}    Mx LoanIQ Get Data    ${LIQ_ActiveCustomer_Window_CustomerID}    text
    ${ShortName}    Mx LoanIQ Get Data    ${LIQ_ActiveCustomer_Window_ShortName}    text
    ${LegalName}    Mx LoanIQ Get Data    ${LIQ_ActiveCustomer_Window_LegalName}    text
    # ${Classification}    Mx LoanIQ Get Data    ${LIQ_ActiveCustomer_Window_CustomerID}    text
    ${GSTID}    Mx LoanIQ Get Data    ${LIQ_ActiveCustomer_Window_GSTID_Textbox}    text

    [Return]    ${CustomerID}    ${ShortName}    ${LegalName}    ${GSTID}
    
Return Customer Address Details from Active Customer Listbox fields
    [Documentation]    This keyword gets and return address details that are in Listbox fields 
    ...    @author: javinzon    01OCT2020    - Initial Create
    
    Take Screenshot    ${screenshot_path}/Screenshots/Party/PartyAddressDetailsPage 
    ${Country}    Mx LoanIQ Get Data    ${LIQ_ViewAddress_Country}    text
    ${CountryOfTaxDomicile}    Mx LoanIQ Get Data    ${LIQ_ViewAddress_TreasuryReportingArea}    text
    ${Province}    Mx LoanIQ Get Data    ${LIQ_ViewAddress_Province}    text
   

    [Return]    ${Country}    ${CountryOfTaxDomicile}    ${Province}
    
Verify If Value Exists in Loan IQ
    [Documentation]    This keyword validates field value if existing in Loan IQ screen
    ...    @author: dahijara    06MAY2020    - initial create    
    ...    @update: javinzon    18SEP2020    - updated keyword "Set List Text with 1 word to Locator" to  "Set List Text with 2 words to Locator"
    ...    @update: javinzon    01OCT2020    - updated keyword "Set List Text with 2 words to Locator" to  "Set List Text with 1 word to Locator",
    ...                                        added ${bWildCard} argument, updated ELSE condition to remove "Set List Text with 1 word to Locator"
    
    [Arguments]    ${sFieldName}    ${sFieldValue}    ${sLIQWindowName}    ${sFieldType}    ${bWildCard}=True

    ${Location_Locator}    Run Keyword If    '${sFieldType}'=='Textbox'    Set Edit Text to Locator Single Text    ${sLIQWindowName}    ${sFieldValue}    ${bWildCard}   
    ...    ELSE     Log    FieldType is not a Textbox    
    #'${sFieldType}'=='Listbox'    Set List Text with 1 word to Locator   ${sLIQWindowName}    ${index}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${Location_Locator}    VerificationData="Yes"
    ${location_stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${Location_Locator}    VerificationData="Yes"
    Run Keyword If    ${location_stat}==True    Log    Location is correct!! ${sFieldName}: '${sFieldValue}' is found
    ...    ELSE    Log    Location is incorrect! ${sFieldName}: '${sFieldValue}' is not found    level=ERROR

Validate Customer SIC
    [Documentation]    This keyword validates primary SIC value based from Party Details against Loan IQ 
    ...    @author: dahijara    06MAY2020    - initial create    
    [Arguments]    ${sPartyBusinessActivity}    ${sBusinessCountry}
    
    ${sBusinessCountry}    Run Keyword If    '${sBusinessCountry}'=='Australia'    Set Variable    AU
    ...    ELSE    Set Variable    ${sBusinessCountry}

    ${PrimarySIC}    Catenate    SEPARATOR=    ${sBusinessCountry}    ${SPACE}/${SPACE}${sPartyBusinessActivity}
    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    SIC
    Mx LoanIQ Activate    ${LIQ_ActiveCustomer_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/Party/PartyLIQActiveCustomerSICTabPage
    Verify If Value Exists in Loan IQ    Primary SIC    ${PrimarySIC}    Active Customer    Textbox

Validate Customer Legal Address Details in Textbox
    [Documentation]    This keywords validates Customer Legal Address Details of the given Party User Details against Loan IQ that are in Textbox fields
    ...    @author: dahijara    06MAY2020    - initial create
    ...    @author: javinzon    16SEP2020    - updated arguments for value verification of Address Lines 3 and 4 in Loan IQ
    ...    @author: javinzon    01OCT2020    - Added False argument to City validation. Updated the documentation.
    ...                                        Added "Textbox" in keyword name; Removed Listbox field verification
    [Arguments]    ${sEnterpriseName}    ${sAddressCode}    ${sAddressLine1}    ${sAddressLine2}    ${sAddressLine3}   ${sAddressLine4}    ${sCity}    ${sPostalCode}    
        
    
    Take Screenshot    ${screenshot_path}/Screenshots/Party/PartyLIQActiveCustomerLegalAddressPage
   
    Verify If Value Exists in Loan IQ    Enterprise Name    ${sEnterpriseName}    View Address    Textbox
    Verify If Value Exists in Loan IQ    Address Code    ${sAddressCode.upper()}    View Address    Textbox
    Verify If Value Exists in Loan IQ    Line1    ${sAddressLine1}    View Address    Textbox
    Verify If Value Exists in Loan IQ    Line2    ${sAddressLine2}    View Address    Textbox
    Verify If Value Exists in Loan IQ    Line3    ${sAddressLine3}    View Address    Textbox
    Verify If Value Exists in Loan IQ    Line4    ${sAddressLine4}    View Address    Textbox
    Verify If Value Exists in Loan IQ    City    ${sCity}    View Address    Textbox    False
    Verify If Value Exists in Loan IQ    Postal Code    ${sPostalCode}    View Address    Textbox
    Mx LoanIQ Click    ${LIQ_ViewAddress_Ok_CancelButton}
    #${LIQ_Active_Customer_Notebook_ViewAddressWindow_CancelButton}     
  

Validate Party Details in Loan IQ
    [Documentation]    This keyword navigates active customer and validates party details in Loan IQ
    ...    @author: dahijara    06MAY2020    - Initial Create
    ...    @update: javinzon    17SEP2020    - Added arguments for Address 3 and 4
    ...    @update: javinzon    01OCT2020    - Added validation for Country, CountryOfTaxDomicile, Country
    ...                                        Added Return Customer Address Details from Active Customer Listbox fields
    ...										   Updated label from PARTY SUBTYPE to Classification
    ...	   @update: javinzon	09OCT2020	 - Added comments for SIC, Country of Tax Domicile, and Province Validation
    [Arguments]    ${sPartyID}    ${sShortName}    ${sEnterpriseName}    ${sGSTID}    ${sPartySubType}    ${sPartyBusinessActivity}    ${sBusinessCountry}    
    ...    ${sAddressCode}    ${sAddressLine1}    ${sAddressLine2}    ${sAddressLine3}    ${sAddressLine4}    ${sCity}    ${sCountry}    ${sCountryOfTaxDomicile}    ${sProvince}    ${sPostalCode}
    
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate to Customer Notebook via Customer ID    ${sPartyID}
    
    ### Get LIQ Values ###
    ${LIQ_CustomerID}    ${LIQ_ShortName}    ${LIQ_LegalName}    ${LIQ_GSTID}    Return Customer Details from Active Customer General Tab

    ### Party ID Validation ###
    ${isMatched}    Run Keyword And Return Status    Should Be Equal    ${sPartyID}    ${LIQ_CustomerID}
    Run Keyword If    ${isMatched}==${True}    Log    Party ID: '${sPartyID}' matched Customer ID: '${LIQ_CustomerID}' in Loan IQ
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Party ID: '${sPartyID}' does NOT match Customer ID: '${LIQ_CustomerID}' in Loan IQ

    ### Short Name Validation ###
    ${isMatched}    Run Keyword And Return Status    Should Be Equal    ${sShortName.upper()}    ${LIQ_ShortName}
    Run Keyword If    ${isMatched}==${True}    Log    Shortname: '${sShortName}' matched Shortname: '${LIQ_ShortName}' in Loan IQ
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Shortname: '${sShortName}' does NOT match Shortname: '${LIQ_ShortName}' in Loan IQ

    ### Enterprise Name Validation ###
    ${isMatched}    Run Keyword And Return Status    Should Be Equal    ${sEnterpriseName}    ${LIQ_LegalName}
    Run Keyword If    ${isMatched}==${True}    Log    Enterprise Name: '${sEnterpriseName}' matched Legal Name: '${LIQ_LegalName}' in Loan IQ
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Enterprise Name: '${sEnterpriseName}' does NOT match Legal Name: '${LIQ_LegalName}' in Loan IQ

    ### GST ID Validation ###
    ${isMatched}    Run Keyword And Return Status    Should Be Equal    ${sGSTID}    ${LIQ_GSTID}
    Run Keyword If    ${isMatched}==${True}    Log    GST ID: '${sGSTID}' matched GST ID: '${LIQ_GSTID}' in Loan IQ
    ...    ELSE    Run Keyword And Continue On Failure    Fail    GST ID: '${sGSTID}' does NOT match GST ID: '${LIQ_GSTID}' in Loan IQ    

    ### Party Subtype Validation ###
    Verify If Value Exists in Loan IQ    Classification    ${sPartySubType}    Active Customer    Textbox

    ### Customer SIC Validation ###
    Validate Customer SIC    ${sPartyBusinessActivity}    ${sBusinessCountry}
    
    ### Get Address details that are in Listbox ###
    Mx LoanIQ Select    ${LIQ_Active_Customer_Notebook_OptionsMenu_LegalAddress}
    ${Country}    ${CountryOfTaxDomicile}    ${Province}    Return Customer Address Details from Active Customer Listbox fields
    
    ### Country Validation ###
    ${isMatched}    Run Keyword And Return Status    Should Be Equal    ${sCountry}    ${Country}
    Run Keyword If    ${isMatched}==${True}    Log    Country: '${sCountry}' matched Country: '${Country}' in Loan IQ
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Country: '${sCountry}' does NOT match Country: '${Country}' in Loan IQ   
    
    ### Country of Tax Domicile Validation ###
    ${isMatched}    Run Keyword And Return Status    Should Be Equal    ${sCountryOfTaxDomicile}    ${CountryOfTaxDomicile}
    Run Keyword If    ${isMatched}==${True}    Log    CountryOfTaxDomicile: '${sCountryOfTaxDomicile}' matched CountryOfTaxDomicile: '${CountryOfTaxDomicile}' in Loan IQ
    ...    ELSE    Run Keyword And Continue On Failure    Fail    CountryOfTaxDomicile: '${sCountryOfTaxDomicile}' does NOT match CountryOfTaxDomicile: '${CountryOfTaxDomicile}' in Loan IQ   
    
    ### Province Validation ###
    ${isMatched}    Run Keyword And Return Status    Should Be Equal    ${sProvince}    ${Province}
    Run Keyword If    ${isMatched}==${True}    Log    Province: '${sProvince}' matched Province: '${Province}' in Loan IQ
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Province: '${sProvince}' does NOT match Province: '${Province}' in Loan IQ   
        
    Validate Customer Legal Address Details in Textbox    ${sEnterpriseName}    ${sAddressCode}    ${sAddressLine1}    ${sAddressLine2}    ${sAddressLine3}    ${sAddressLine4}    ${sCity}    ${sPostalCode}
    
    Mx LoanIQ close window    ${LIQ_ActiveCustomer_Window}    