*** Settings ***
Resource    Resource    ../../../Configurations/Party_Import_File.robot

*** Keywords ***

Search Party ID in Party Details Page
    [Documentation]    This keyword is used to search Party ID in Party Details Page.
    ...    @author: dahijara    18MAY2020    - initial create. 
    [Arguments]    ${sPartyID}

    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Validate Page Screen is Displayed    ${PARTY_PARTYDETAILS_PAGETITLE}

    Mx Input Text    ${Party_MaintainPartyDetails_PartyDetails_PartyId_TextBox}    ${sPartyID}

    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyDetails-{index}.png

    Mx Click Element    ${Party_Footer_Next_Button}

Update Party Details in Enterprise Party Page
    [Documentation]    This keyword is used to update party details in Enterprise Party Page.
    ...    @author: dahijara    18MAY2020    - initial create. 
    [Arguments]    ${sLocality}    ${sPartySubType}    ${sPartyCategory}    ${sPartyID}    ${sEnterpriseName}
    ...    ${sRegisteredNumber}    ${sCountryOfRegistration}    ${sCountryOfTaxDomicile}    ${sShortName}
    ...    ${sBusinessCountry}    ${sIndustrySector}    ${sBusinessActivity}    ${sIsMainActivity}    ${sIsPrimaryActivity}
    ...    ${sGTSNumber}

    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Validate Page Screen is Displayed    ${PARTY_ENTERPRISEPARTY_PAGETITLE}

    Populate and Validate If Field Value Is Updated    Locality    ${sLocality}    ${Party_PreExistenceCheck_Locality_Dropdown}
    Populate and Validate If Field Value Is Updated    Party SubType    ${sPartySubType}    ${Party_PartyOnboarding_PartySubType_Dropdown}
    Populate and Validate If Field Value Is Updated    Party Category    ${sPartyCategory}    ${Party_PartyOnboarding_PartyCategory_Dropdown}
    Compare Two Arguments    ${sPartyID}    ${Party_QuickEnterpriseParty_PartyId_TextBox}
    Populate and Validate If Field Value Is Updated    Enterprise Name    ${sEnterpriseName}    ${Party_QuickEnterpriseParty_PartyName_TextBox}
    Populate and Validate If Field Value Is Updated    Registered Number    ${sRegisteredNumber}    ${Party_QuickEnterpriseParty_RegisteredNumber_TextBox}
    Populate and Validate If Field Value Is Updated    Country Of Registration    ${sCountryOfRegistration}    ${Party_QuickEnterpriseParty_CountryOfRegistration_Dropdown}
    Populate and Validate If Field Value Is Updated    Country Of Tax Domicile    ${sCountryOfTaxDomicile}    ${Party_QuickEnterpriseParty_CountryOfTaxDomicile_Dropdown}
    Populate and Validate If Field Value Is Updated    Short Name    ${sShortName}    ${Party_QuickEnterpriseParty_ShortName_TextBox}
    Update The Goods & Service Tax Details in Enterprise Party Page    ${sCountryOfTaxDomicile}    ${sGTSNumber}
    Update Business Activity Details in Enterprise Party Page    ${sBusinessCountry}    ${sIndustrySector}    ${sBusinessActivity}    ${sIsMainActivity}    ${sIsPrimaryActivity}

    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/EnterprisePartyPage-{index}.png
    Mx Scroll Element Into View    ${Party_Next_Button}
    Mx Click Element    ${Party_Next_Button}
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    ${isDisplayed}    Run Keyword And Return Status    Wait Until Page Contains Element    ${Party_QuickEnterpriseParty_ApprovalRequired_Dialog}
    Run Keyword If    ${isDisplayed}!=${True}    Run Keywords    Mx Click Element    ${Party_Next_Button}
    ...    AND    Wait Until Page Contains Element    ${Party_QuickEnterpriseParty_ApprovalRequired_Dialog}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyApprovalDialog-{index}.png
    Mx Click Element    ${Party_QuickEnterpriseParty_AskForApproval_Button}
    Wait Until Page Contains Element    ${Party_RaisedMessage_Notification}    

Update Business Activity Details in Enterprise Party Page
    [Documentation]    This keyword is used to update business activity details in Enterprise Party Page.
    ...    @author: dahijara    18MAY2020    - initial create.
    [Arguments]    ${sBusinessCountry}    ${sIndustrySector}    ${sBusinessActivity}    ${sIsMainActivity}    ${sIsPrimaryActivity}

    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Wait Until Page Contains Element    ${Party_MaintainPartyDetails_EnterpriseParty_BusinessActivity_Checkbox}
    Click Element    ${Party_MaintainPartyDetails_EnterpriseParty_BusinessActivity_Checkbox}

    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Wait Until Page Contains    Create Enterprise Business Activity     

    Populate and Validate If Field Value Is Updated    Business Country    ${sBusinessCountry}    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_Country_Dropdown}
    Populate and Validate If Field Value Is Updated    Industry Sector    ${sIndustrySector}    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_IndustrySector_Dropdown}
    Populate and Validate If Field Value Is Updated    Business Activity    ${sBusinessActivity}    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_BusinessActivity_Dropdown}
    Tick/Untick and Validate If Checkbox Value Is Updated    Is Main Activity    ${sIsMainActivity}    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_IsMainActivity_CheckBox}
    Tick/Untick and Validate If Checkbox Value Is Updated    Is Primary Activity    ${sIsPrimaryActivity}    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_IsPrimaryActivity_CheckBox}
    Mx Click Element    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_SaveRow_Button}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/CreateEnterpriseBusinessActivity-{index}.png
    Mx Click Element    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_Next_Button}

Update Address Details in Enterprise Party Page
    [Documentation]    This keyword is used to update address details in Enterprise Party Page.
    ...    @author: dahijara    18MAY2020    - initial create.
    [Arguments]    ${sAddressType}    ${sAddressCountry}    ${sPostCode}    ${sState}    ${sTown}
    ...    ${sAddressLine1}    ${sAddressLine2}    ${sAddressLine3}    ${sAddressLine4}    ${sAddressLine5}

    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Validate Page Screen is Displayed    ${PARTY_ENTERPRISEPARTY_PAGETITLE}
    Click Element    ${Party_MaintainPartyDetails_EnterpriseParty_RelatedItems_Menu}
    Click Element    ${Party_MaintainPartyDetails_EnterpriseParty_Addresses_MenuItem}

    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Wait Until Page Contains    Party Address

    Populate and Validate If Field Value Is Updated    Address Type    ${sAddressType}    ${Party_MaintainPartyDetails_PartyAddress_AddressType_Dropdown}
    Populate and Validate If Field Value Is Updated    Address Country    ${sAddressCountry}    ${Party_MaintainPartyDetails_PartyAddress_AddressCountry_Dropdown}
    Populate and Validate If Field Value Is Updated    Post Code    ${sPostCode}    ${Party_MaintainPartyDetails_PartyAddress_PostCode_Textbox}
    Populate and Validate If Field Value Is Updated    State    ${sState}    ${Party_MaintainPartyDetails_PartyAddress_State_Dropdown}
    Populate and Validate If Field Value Is Updated    Town    ${sTown}    ${Party_MaintainPartyDetails_PartyAddress_Town_Textbox}
    Populate and Validate If Field Value Is Updated    Address Line1    ${sAddressLine1}    ${Party_MaintainPartyDetails_PartyAddress_AddressLine1_Textbox}
    Populate and Validate If Field Value Is Updated    Address Line2    ${sAddressLine2}    ${Party_MaintainPartyDetails_PartyAddress_AddressLine2_Textbox}
    Populate and Validate If Field Value Is Updated    Address Line3    ${sAddressLine3}    ${Party_MaintainPartyDetails_PartyAddress_AddressLine3_Textbox}
    Populate and Validate If Field Value Is Updated    Address Line4    ${sAddressLine4}    ${Party_MaintainPartyDetails_PartyAddress_AddressLine4_Textbox}
    Populate and Validate If Field Value Is Updated    Address Line5    ${sAddressLine5}    ${Party_MaintainPartyDetails_PartyAddress_AddressLine5_Textbox}

    Mx Click Element    ${Party_Dialog_SaveRow_Button}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/Party_MaintainPartyDetails_PartyAddress-{index}.png
    Mx Click Element    ${Party_QuickEnterpriseParty_AddressDetails_Next_Button}
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    ${isDisplayed}    Run Keyword And Return Status    Wait Until Page Contains Element    ${Party_QuickEnterpriseParty_ApprovalRequired_Dialog}
    Run Keyword If    ${isDisplayed}!=${True}    Run Keywords    Mx Click Element    ${Party_QuickEnterpriseParty_AddressDetails_Next_Button}
    ...    AND    Wait Until Page Contains Element    ${Party_QuickEnterpriseParty_ApprovalRequired_Dialog}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyApprovalDialog-{index}.png
    Mx Click Element    ${Party_QuickEnterpriseParty_AskForApproval_Button}
    Wait Until Page Contains Element    ${Party_RaisedMessage_Notification}   

Update The Goods & Service Tax Details in Enterprise Party Page
    [Documentation]    This keyword is used to update GTS details in Enterprise Party Page.
    ...    @author: dahijara    18MAY2020    - initial create.
    [Arguments]    ${sTaxCountry}    ${sGTSNumber}

    Wait Until Page Contains Element    ${Party_MaintainPartyDetails_EnterpriseParty_GTS_AddChange_Button}
    Mx Click Element    ${Party_MaintainPartyDetails_EnterpriseParty_GTS_AddChange_Button}

    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Wait Until Page Contains    Goods & Service Tax Details

    Populate and Validate If Field Value Is Updated    Tax Country    ${sTaxCountry}    ${Party_MaintainPartyDetails_GTSDetails_TaxCountry_Dropdown}
    Populate and Validate If Field Value Is Updated    GTS Number    ${sGTSNumber}    ${Party_MaintainPartyDetails_GTSDetails_GTSNumber_Textbox}

    Mx Click Element    ${Party_Dialog_SaveRow_Button}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/Party_MaintainPartyDetails_PartyAddress_GoodsServiceTaxDetails-{index}.png
    Mx Click Element    ${Party_Dialog_Next_Button}

Validate Updated Enterprise Party
    [Documentation]    This keyword validates fields in Enterprise Party page.
    ...    @author: dahijara    19MAY2020    - initial create
    [Arguments]    ${sLocality}    ${sPartySubType}    ${sPartyCategory}    ${sPartyID}    ${sEnterpriseName}
    ...    ${sRegisteredNumber}    ${sCountryOfRegistration}    ${sCountryOfTaxDomicile}    ${sShortName}
    ...    ${sBusinessCountry}    ${sIndustrySector}    ${sBusinessActivity}    ${sIsMainActivity}    ${sIsPrimaryActivity}
    ...    ${sGTSNumber}

    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Validate Page Screen is Displayed    ${PARTY_ENTERPRISEPARTY_PAGETITLE}

    Compare Two Arguments    ${sLocality}    ${Party_PreExistenceCheck_Locality_Dropdown}
    Compare Two Arguments    ${sPartySubType}    ${Party_PartyOnboarding_PartySubType_Dropdown}
    Compare Two Arguments    ${sPartyCategory}    ${Party_PartyOnboarding_PartyCategory_Dropdown}
    Compare Two Arguments    ${sPartyID}    ${Party_QuickEnterpriseParty_PartyId_TextBox}
    Compare Two Arguments    ${sEnterpriseName}    ${Party_QuickEnterpriseParty_PartyName_TextBox}
    Compare Two Arguments    ${sRegisteredNumber}    ${Party_QuickEnterpriseParty_RegisteredNumber_TextBox}
    Compare Two Arguments    ${sCountryOfRegistration}    ${Party_QuickEnterpriseParty_CountryOfRegistration_Dropdown}
    Compare Two Arguments    ${sCountryOfTaxDomicile}    ${Party_QuickEnterpriseParty_CountryOfTaxDomicile_Dropdown}
    Compare Two Arguments    ${sShortName}    ${Party_QuickEnterpriseParty_ShortName_TextBox}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/EnterprisePartyPage-{index}.png   
    Validate updated The Goods & Service Tax Details in Enterprise Party Page    ${sCountryOfTaxDomicile}    ${sGTSNumber}
    Validate updated Business Activity Details in Enterprise Party Page    ${sBusinessCountry}    ${sIndustrySector}    ${sBusinessActivity}    ${sIsMainActivity}    ${sIsPrimaryActivity}

Validate updated Business Activity Details in Enterprise Party Page
    [Documentation]    This keyword is used to validate updated business activity details in Enterprise Party Page.
    ...    @author: dahijara    18MAY2020    - initial create.
    [Arguments]    ${sBusinessCountry}    ${sIndustrySector}    ${sBusinessActivity}    ${bIsMainActivity}    ${bIsPrimaryActivity}

    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Wait Until Page Contains Element    ${Party_MaintainPartyDetails_EnterpriseParty_BusinessActivity_Checkbox}
    Click Element    ${Party_MaintainPartyDetails_EnterpriseParty_BusinessActivity_Checkbox}

    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Wait Until Page Contains    Create Enterprise Business Activity     

    Compare Two Arguments    ${sBusinessCountry}    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_Country_Dropdown}
    Compare Two Arguments    ${sIndustrySector}    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_IndustrySector_Dropdown}
    Compare Two Arguments    ${sBusinessActivity}    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_BusinessActivity_Dropdown}
    ${IsMainActivityChecked}    SeleniumLibraryExtended.Get Element Attribute    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_IsMainActivity_CheckBox}    aria-checked
    Run Keyword If    '${bIsMainActivity}'=='${TRUE}' and ${${IsMainActivityChecked}}==${True}    Log    IsMainActivity value is correct!
    ...   ELSE    Run Keyword And Continue On Failure    Fail    IsMainActivity value is incorrect! Expected Value: '${bIsMainActivity}' | Actual Value: ${IsMainActivityChecked}
    ${isPrimaryActivityChecked}    SeleniumLibraryExtended.Get Element Attribute    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_IsPrimaryActivity_CheckBox}    aria-checked
    Run Keyword If    '${bIsPrimaryActivity}'=='${TRUE}' and ${${isPrimaryActivityChecked}}==${True}        Log    IsPrimaryActivity value is correct!
    ...   ELSE    Run Keyword And Continue On Failure    Fail    IsPrimaryActivity value is incorrect! Expected Value: '${bIsPrimaryActivity}' | Actual Value: ${isPrimaryActivityChecked}

    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyEnterpriseBusinessActivityPage-{index}.png
    Mx Click Element    ${Party_CloseDialog_Button}
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}

Validate updated The Goods & Service Tax Details in Enterprise Party Page
    [Documentation]    This keyword is used to validate updated GTS details in Enterprise Party Page.
    ...    @author: dahijara    19MAY2020    - initial create.
    [Arguments]    ${sTaxCountry}    ${sGTSNumber}

    Wait Until Page Contains Element    ${Party_MaintainPartyDetails_EnterpriseParty_GTS_AddChange_Button}
    Mx Click Element    ${Party_MaintainPartyDetails_EnterpriseParty_GTS_AddChange_Button}

    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Wait Until Page Contains    Goods & Service Tax Details

    Compare Two Arguments    ${sTaxCountry}    ${Party_MaintainPartyDetails_GTSDetails_TaxCountry_Dropdown}
    Compare Two Arguments    ${sGTSNumber}    ${Party_MaintainPartyDetails_GTSDetails_GTSNumber_Textbox}

    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyEnterpriseGTSDetailsPage-{index}.png
    Mx Click Element    ${Party_CloseDialog_Button}
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}


Accept Approved Updated Party and Validate Details in Enterprise Party Screen
    [Documentation]    This keyword validates the approved updated party details and validate Enterprise Party page.
    ...    @author: dahijara    19MAY2020     - initial create
    [Arguments]    ${sTask_ID_From_Supervisor}    ${sLocality}    ${sPartySubType}    ${sPartyCategory}    ${sPartyID}    ${sEnterpriseName}
    ...    ${sRegisteredNumber}    ${sCountryOfRegistration}    ${sCountryOfTaxDomicile}    ${sShortName}
    ...    ${sBusinessCountry}    ${sIndustrySector}    ${sBusinessActivity}    ${sIsMainActivity}    ${sIsPrimaryActivity}
    ...    ${sGTSNumber}


    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL}   
    
    Accept Approved Updated Party    ${sTask_ID_From_Supervisor}    ${sPartyID}
    Search Party ID in Party Details Page    ${sPartyID}
    Validate Updated Enterprise Party    ${sLocality}    ${sPartySubType}    ${sPartyCategory}    ${sPartyID}    ${sEnterpriseName}
    ...    ${sRegisteredNumber}    ${sCountryOfRegistration}    ${sCountryOfTaxDomicile}    ${sShortName}
    ...    ${sBusinessCountry}    ${sIndustrySector}    ${sBusinessActivity}    ${sIsMainActivity}    ${sIsPrimaryActivity}
    ...    ${sGTSNumber}

    Run Keyword If    '${SSO_ENABLED}'=='NO'    Logout User on Party
    Close Browser    

Accept Approved Updated Party
    [Documentation]    This keyword accepts the approved party of the supervisor account.
    ...    @author: dahijara    19MAY2020    - initial create.
    [Arguments]    ${sTask_ID_From_Supervisor}    ${sPartyID}    ${sRelateditem}=None

    Mx Click Element    ${Party_HomePage_Notification_Icon}    
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Validate Page Screen is Displayed    ${PARTY_NOTIFICATIONTYPES_PAGETITLE}
    Mx Input Text    ${Party_NotificationTypes_TaskType_TextBox}    Approval
    Mx Click Element    ${Party_ProcessNotification_NotificationTypes_Approval_RadioButton}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyNotificationTypesPage-{index}.png
    Mx Click Element    ${Party_Next_Button}

    Wait Until Browser Ready State
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Validate Page Screen is Displayed    ${PARTY_APPROVALS_PAGETITLE}  
    ${Task_ID_From_User}    Select Referral Using Reference ID    ${sTask_ID_From_Supervisor}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyApprovalsPage-{index}.png
    Run Keyword If    '${Task_ID_From_User}'!='None'    Mx Click Element    ${Party_Footer_Next_Button}
    ...    ELSE    Fail    Unable to Find Referral with Task ID:${sTask_ID_From_Supervisor}    
    Wait Until Browser Ready State
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}

    Run Keyword If    '${sRelateditem}'!='Addresses'    Validate Amend Successful Page

Validate Amend Successful Page
    [Documentation]    This keyword accepts the approved party of the supervisor account.
    ...    @author: dahijara    19MAY2020    - initial create.

    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Validate Page Screen is Displayed    ${PARTY_AMENDSUCCESSFUL_PAGETITLE}
    Wait Until Page Contains    Party Details Amended Successfully          
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/AmendSuccessfulPage-{index}.png
    Mx Click Element    ${Party_Footer_Next_Button}
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}

Accept Approved Updated Party and Validate Address Details in Enterprise Party
    [Documentation]    This keyword validates the approved updated party address details and validate Party Address page.
    ...    @author: dahijara    19MAY2020     - initial create
    [Arguments]    ${sTask_ID_From_Supervisor}    ${sPartyID}    ${sAddressType}    ${sAddressCountry}    ${sPostCode}    ${sState}    ${sTown}
    ...    ${sAddressLine1}    ${sAddressLine2}    ${sAddressLine3}    ${sAddressLine4}    ${sAddressLine5}    ${sSelectedModule}


    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL}   
    
    Accept Approved Updated Party    ${sTask_ID_From_Supervisor}    ${sPartyID}    Addresses
    Search Process in Party    ${sSelectedModule}
    Search Party ID in Party Details Page    ${sPartyID}
    Validate Updated Address Details in Enterprise Party Page    ${sAddressType}    ${sAddressCountry}    ${sPostCode}    ${sState}    ${sTown}
    ...    ${sAddressLine1}    ${sAddressLine2}    ${sAddressLine3}    ${sAddressLine4}    ${sAddressLine5}

    Run Keyword If    '${SSO_ENABLED}'=='NO'    Logout User on Party
    Close Browser    


Validate Updated Address Details in Enterprise Party Page
    [Documentation]    This keyword is used to validate updated address details in Enterprise Party Page.
    ...    @author: dahijara    18MAY2020    - initial create.
    [Arguments]    ${sAddressType}    ${sAddressCountry}    ${sPostCode}    ${sState}    ${sTown}
    ...    ${sAddressLine1}    ${sAddressLine2}    ${sAddressLine3}    ${sAddressLine4}    ${sAddressLine5}

    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Validate Page Screen is Displayed    ${PARTY_ENTERPRISEPARTY_PAGETITLE}
    Click Element    ${Party_MaintainPartyDetails_EnterpriseParty_RelatedItems_Menu}
    Click Element    ${Party_MaintainPartyDetails_EnterpriseParty_Addresses_MenuItem}

    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Wait Until Page Contains    Party Address

    Compare Two Arguments    ${sAddressType}    ${Party_MaintainPartyDetails_PartyAddress_AddressType_Dropdown}
    Compare Two Arguments    ${sAddressCountry}    ${Party_MaintainPartyDetails_PartyAddress_AddressCountry_Dropdown}
    Compare Two Arguments    ${sPostCode}    ${Party_MaintainPartyDetails_PartyAddress_PostCode_Textbox}
    Compare Two Arguments    ${sState}    ${Party_MaintainPartyDetails_PartyAddress_State_Dropdown}
    Compare Two Arguments    ${sTown}    ${Party_MaintainPartyDetails_PartyAddress_Town_Textbox}
    Compare Two Arguments    ${sAddressLine1}    ${Party_MaintainPartyDetails_PartyAddress_AddressLine1_Textbox}
    Compare Two Arguments    ${sAddressLine2}    ${Party_MaintainPartyDetails_PartyAddress_AddressLine2_Textbox}
    Compare Two Arguments    ${sAddressLine3}    ${Party_MaintainPartyDetails_PartyAddress_AddressLine3_Textbox}
    Compare Two Arguments    ${sAddressLine4}    ${Party_MaintainPartyDetails_PartyAddress_AddressLine4_Textbox}
    Compare Two Arguments    ${sAddressLine5}    ${Party_MaintainPartyDetails_PartyAddress_AddressLine5_Textbox}

    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyAddressPage-{index}.png
    Mx Click Element    ${Party_CloseDialog_Button}