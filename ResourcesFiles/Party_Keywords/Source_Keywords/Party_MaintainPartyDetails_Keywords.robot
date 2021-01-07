*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot
Resource    ../../../Configurations/Party_Import_File.robot

*** Keywords ***
Validate Enterprise Party Details if Correct
	[Documentation]    This keyword is used to validate if all existing field values are correct.
    ...    @author: javinzon    22SEP2020    - initial create
    [Arguments]    ${sLocality}    ${sEntity}    ${sAssigned_Branch}    ${sParty_Type}    ${sParty_Sub_Type}    ${sParty_Category}    ${sParty_ID}    
    ...    ${sEnterprise_Name}    ${sRegistered_Number}    ${sCountry_of_Registration}    ${sCountry_of_Tax_Domicile}    ${sShort_Name}    
    
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    
    Compare Two Arguments    ${sLocality}    ${Party_PreExistenceCheck_Locality_Dropdown}
    Compare Two Arguments    ${sEntity}    ${Party_PreExistenceCheck_Entity_Dropdown} 
    Compare Two Arguments    ${sAssigned_Branch}    ${Party_PartyOnboarding_AssignedBranch_Dropdown}  
	Compare Two Arguments    ${sParty_Type}    ${Party_PartyOnboarding_PartyType_Dropdown}
	Compare Two Arguments    ${sParty_Sub_Type}    ${Party_PartyOnboarding_PartySubType_Dropdown}
	Compare Two Arguments    ${sParty_Category}    ${Party_PartyOnboarding_PartyCategory_Dropdown}
	Compare Two Arguments    ${sParty_ID}    ${Party_MaintainPartyDetails_PartyDetails_PartyId_TextBox} 
    Compare Two Arguments    ${sEnterprise_Name}    ${Party_QuickEnterpriseParty_PartyName_TextBox} 
    Compare Two Arguments    ${sRegistered_Number}    ${Party_QuickEnterpriseParty_RegisteredNumber_TextBox}
	Compare Two Arguments    ${sCountry_of_Registration}    ${Party_QuickEnterpriseParty_CountryOfRegistration_Dropdown}
	Compare Two Arguments    ${sCountry_of_Tax_Domicile}    ${Party_QuickEnterpriseParty_CountryOfTaxDomicile_Dropdown}  
	Compare Two Arguments    ${sShort_Name}    ${Party_QuickEnterpriseParty_ShortName_TextBox}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/Update_ValidateExisting_EnterprisePartyPage--{index}.png
    
Validate Party Address Details in Related Items if Correct 
    [Documentation]    This keyword validates the Party details from Enterprise summary details page.
    ...    @author: javinzon    22SEP2020     - initial create
    [Arguments]    ${sAddress_Type}    ${sAddress_Line_1}    ${sAddress_Line_2}    ${sAddress_Line_3}    ${sAddress_Line_4}    ${sTown_City}    ${sState_Province}    
    ...    ${iPost_Code}    ${sCountry_Region}
          
    Mx Click Element    ${Party_MaintainPartyDetails_EnterpriseParty_RelatedItems_Menu}    
    Mx Click Element    ${Party_EnquirePartyDetails_EnterpriseParty_Addresses_MenuItem}    
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Compare Two Arguments    ${sAddress_Type}    ${Party_MaintainPartyDetails_PartyAddress_AddressType_Dropdown}
    Compare Two Arguments    ${sAddress_Line_1}    ${Party_MaintainPartyDetails_PartyAddress_AddressLine1_Textbox}
    Compare Two Arguments    ${sAddress_Line_2}    ${Party_MaintainPartyDetails_PartyAddress_AddressLine2_Textbox}
    Compare Two Arguments    ${sAddress_Line_3}    ${Party_MaintainPartyDetails_PartyAddress_AddressLine3_Textbox}
    Compare Two Arguments    ${sAddress_Line_4}    ${Party_MaintainPartyDetails_PartyAddress_AddressLine4_Textbox}
    Compare Two Arguments    ${sTown_City}    ${Party_MaintainPartyDetails_PartyAddress_Town_Textbox}
    Compare Two Arguments    ${sState_Province}    ${Party_MaintainPartyDetails_PartyAddress_State_Dropdown}
    Compare Two Arguments    ${iPost_Code}    ${Party_MaintainPartyDetails_PartyAddress_PostCode_Textbox}
    Compare Two Arguments    ${sCountry_Region}    ${Party_MaintainPartyDetails_PartyAddress_AddressCountry_Dropdown}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/Update_ValidateExisting_EnterprisePartyPage--{index}.png
    Wait Until Browser Ready State
    Mx Click Element    ${Party_CloseDialog_Button}

Validate Create Enterprise Business Activity Details 
    [Documentation]    This keyword validates the Create Enterprise Business Activity Details dialog.
    ...    @author: dahijara    05MAY2020    - initial create
    ...    @update: javinzon    03NOV2020    - moved keyword from Party_Quick_PartyOnboarding_Keywords.robot, 
    ...                                        added validation for MainActivity and PrimaryActivity, updated documentation
    [Arguments]    ${sCountry}    ${sIndustrySector}    ${sBusinessActivity}    ${bIsMainActivity}    ${bIsPrimaryActivity}

    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Validate Page Screen is Displayed    ${PARTY_ENTERPRISEPARTY_PAGETITLE}

    Click Button    ${Party_MaintainPartyDetails_EnterpriseParty_BusinessActivity_Checkbox}
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Wait Until Page Contains    Create Enterprise Business Activity  

    Compare Two Arguments    ${sCountry}    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_Country_Dropdown}
    Compare Two Arguments    ${sIndustrySector}    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_IndustrySector_Dropdown}
    Compare Two Arguments    ${sBusinessActivity}    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_BusinessActivity_Dropdown} 
    
    ${IsMainActivity_Actual}    SeleniumLibraryExtended.Get Element Attribute    ${Party_EnquirePartyDetails_BusinessActivity_Is_Main_Activity_Checkbox}    aria-checked
    Run Keyword If    '${IsMainActivity_Actual.upper()}'=='${bIsMainActivity.upper()}'    Log    Value for Main Activity is correct
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Value for Main Activity is incorrect
    
    ${IsPrimaryActivity_Actual}    SeleniumLibraryExtended.Get Element Attribute    ${Party_EnquirePartyDetails_BusinessActivity_Is_Main_Activity_Checkbox}    aria-checked
    Run Keyword If    '${IsPrimaryActivity_Actual.upper()}'=='${bIsPrimaryActivity.upper()}'    Log    Value for Primary Activity is correct 
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Value for Primary Activity is incorrect
    
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/Update_ValidateExisting_EnterprisePartyPage--{index}.png
    Mx Click Element    ${Party_CloseDialog_Button}
    
Validate Goods and Service Tax Details
     [Documentation]    This keyword validates the Goods and Service Tax Details thru Add/Change button.
    ...    @author: javinzon    22SEP2020     - initial create
     [Arguments]    ${sCountry_of_Tax_Domicile}    ${sGST_Number}
    
    Click Button    ${Party_MaintainPartyDetails_EnterpriseParty_GTS_AddChange_Button}
    Mx Click Element    ${Party_TableRadioButton_RadioButton}
    Compare Two Arguments    ${sCountry_of_Tax_Domicile}    ${Party_MaintainPartyDetails_GTSDetails_TaxCountry_Dropdown}
    Compare Two Arguments    ${sGST_Number}    ${Party_MaintainPartyDetails_GTSDetails_GTSNumber_Textbox}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/Update_ValidateExisting_EnterprisePartyPage--{index}.png
    Mx Click Element    ${Party_CloseDialog_Button}

Validate Enterprise Party Summary in Maintain Party Details
    [Documentation]    This keyword is used to validate Party details in Maintain Party Details Module.
	...    @author: javinzon    22SEP2020    - initial create
	[Arguments]    ${sLocality}    ${sEntity}    ${sAssigned_Branch}    ${sParty_Type}    ${sParty_Sub_Type}    ${sParty_Category}     ${sParty_ID}    ${sEnterprise_Name}
	...    ${sRegistered_Number}    ${sCountry_of_Registration}    ${sCountry_of_Tax_Domicile}    ${sShort_Name}    ${sAddress_Type}    ${sAddress_Line_1}    ${sAddress_Line_2}    ${sAddress_Line_3}    ${sAddress_Line_4}    ${sTown_City}    ${sState_Province}    
    ...    ${iPost_Code}    ${sCountry_Region}    ${sCountry}    ${sIndustrySector}    ${sBusinessActivity}    ${bIsMainActivity}    ${bIsPrimaryActivity}    ${sGST_Number}
 
	Validate Enterprise Party Details if Correct    ${sLocality}    ${sEntity}    ${sAssigned_Branch}    ${sParty_Type}    ${sParty_Sub_Type}    ${sParty_Category}
	...    ${sParty_ID}    ${sEnterprise_Name}    ${sRegistered_Number}    ${sCountry_of_Registration}    ${sCountry_of_Tax_Domicile}    ${sShort_Name}
	   
	Validate Party Address Details in Related Items if Correct    ${sAddress_Type}    ${sAddress_Line_1}    ${sAddress_Line_2}    ${sAddress_Line_3}    ${sAddress_Line_4}    ${sTown_City}    ${sState_Province}    
    ...    ${iPost_Code}    ${sCountry_Region}       
    
    Validate Create Enterprise Business Activity Details    ${sCountry}    ${sIndustrySector}    ${sBusinessActivity}    ${bIsMainActivity}    ${bIsPrimaryActivity}
    
    Validate Goods and Service Tax Details    ${sCountry_of_Tax_Domicile}    ${sGST_Number}

Update Enterprise Party Details And Return Values
    [Documentation]    This keyword is used to update enterprise party details generate and update Enterprise Name in Excel File
    ...    @author: javinzon    22SEP2020    - intial create 
    [Arguments]        ${sLocality}    ${sParty_Sub_Type}    ${sParty_Category}    ${sEnterprise_Prefix}    ${sRegistered_Number}    ${sShort_Name_Prefix}
    ...    ${sCountry_of_Tax_Domicile}   ${sCountry_of_Registration} 
    
    Wait Until Browser Ready State
    Mx Input Text    ${Party_EnquirePartyDetails_Locality_Textbox}    ${sLocality}
    Mx Input Text    ${Party_PartyOnboarding_PartySubType_Dropdown}    ${sParty_Sub_Type}
    Mx Input Text    ${Party_PartyOnboarding_PartyCategory_Dropdown}    ${sParty_Category}
    ${New_Enterprise_Name}    ${Generated_Value}    Generate New Enterprise Name And Return Values    ${sEnterprise_Prefix} 
    Mx Input Text    ${Party_QuickEnterpriseParty_PartyName_TextBox}    ${New_Enterprise_Name}     
    Mx Input Text    ${Party_QuickEnterpriseParty_RegisteredNumber_TextBox}    ${sRegistered_Number}
    ${Short_Name}    Get Short Name Value and Return    ${sShort_Name_Prefix}    ${Generated_Value}
    Mx Input Text    ${Party_QuickEnterpriseParty_ShortName_TextBox}    ${Short_Name}
    Mx Input Text    ${Party_QuickEnterpriseParty_CountryOfTaxDomicile_Dropdown}    ${sCountry_of_Tax_Domicile}
    Mx Input Text    ${Party_QuickEnterpriseParty_CountryOfRegistration_Dropdown}    ${sCountry_of_Registration}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/Update_EnterprisePartyDetailsPage--{index}.png
    
    [Return]    ${New_Enterprise_Name}    ${Short_Name}
    
Update Short Name and Enterprise Name And Return Values
    [Documentation]    This keyword is used to update enterprise name and short name, generate and update Enterprise Name in Excel File
    ...    @author: makcamps    17DEC2020    - intial create 
    [Arguments]        ${sEnterprise_Prefix}    ${sShort_Name_Prefix}    ${sParty_ID}
    
    Wait Until Browser Ready State
    ${New_Enterprise_Name}    Set Variable    ${sEnterprise_Prefix} ${sParty_ID}
    Mx Input Text    ${Party_QuickEnterpriseParty_PartyName_TextBox}    ${New_Enterprise_Name}
    ${Short_Name}    Get Short Name Value and Return    ${sShort_Name_Prefix}    ${sParty_ID}
    Mx Input Text    ${Party_QuickEnterpriseParty_ShortName_TextBox}    ${Short_Name}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/Update_EnterprisePartyDetailsPage--{index}.png
    
    [Return]    ${New_Enterprise_Name}    ${Short_Name}
    
Update Enterprise Party Address Details
    [Documentation]    This keyword is used to update Party address details
    ...    @author: javinzon    22SEP2020    - initial create
    ...    @update: javinzon    19NOV2020    - removed old scripts of Approval required and replaced with keywords
    ...                                        'Proceed with Approval Required Dialog' 
    [Arguments]    ${sAddress_Type}    ${sAddress_Line_1}    ${sAddress_Line_2}    ${sAddress_Line_3}    ${sAddress_Line_4}    ${sTown_City}
    ...    ${sState_Province}    ${sPost_Code}    ${sCountry_Region}    ${sExpected_Error_Message}=None
    
    Mx Click Element    ${Party_MaintainPartyDetails_EnterpriseParty_RelatedItems_Menu}    
    Mx Click Element    ${Party_EnquirePartyDetails_EnterpriseParty_Addresses_MenuItem}    
    Wait Until Page Contains    Party Address
    Mx Input Text    ${Party_MaintainPartyDetails_PartyAddress_AddressType_Dropdown}    ${sAddress_Type}
    Mx Input Text    ${Party_MaintainPartyDetails_PartyAddress_AddressLine1_Textbox}    ${sAddress_Line_1}
    Mx Input Text    ${Party_MaintainPartyDetails_PartyAddress_AddressLine2_Textbox}    ${sAddress_Line_2}
    Mx Input Text    ${Party_MaintainPartyDetails_PartyAddress_AddressLine3_Textbox}    ${sAddress_Line_3}
    Mx Input Text    ${Party_MaintainPartyDetails_PartyAddress_AddressLine4_Textbox}    ${sAddress_Line_4} 
    Mx Input Text    ${Party_MaintainPartyDetails_PartyAddress_Town_Textbox}    ${sTown_City}
    Mx Input Text    ${Party_MaintainPartyDetails_PartyAddress_State_Dropdown}    ${sState_Province}
    Mx Input Text    ${Party_MaintainPartyDetails_PartyAddress_PostCode_Textbox}    ${sPost_Code}
    Mx Input Text    ${Party_MaintainPartyDetails_PartyAddress_AddressCountry_Dropdown}    ${sCountry_Region}
    Mx Click Element    ${Party_Dialog_SaveRow_Button}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/Update_EnterprisePartyDetailsPage--{index}.png
    Mx Click Element    ${Party_QuickEnterpriseParty_AddressDetails_Next_Button}
    
    Proceed with Approval Required Dialog    ${sExpected_Error_Message}
    
Update Enterprise Business Activity Details
    [Documentation]    This keyword is used to update all details in Business Activity Details Dialog
    ...    @author: javinzon    22SEP2020    - initial create
    [Arguments]    ${sBusiness_Country}    ${sIndustry_Sector}    ${sBusiness_Activity}    ${sExpected_Error_Message}=None
    
    Wait Until Page Contains Element    ${Party_MaintainPartyDetails_EnterpriseParty_BusinessActivity_Checkbox}
    Double Click Element    ${Party_MaintainPartyDetails_EnterpriseParty_BusinessActivity_Checkbox}
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Wait Until Page Contains    Create Enterprise Business Activity 
    Mx Click Element    ${Party_TableRadioButton_RadioButton}
    Mx Input Text    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_Country_Dropdown}    ${sBusiness_Country}
    Mx Input Text    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_IndustrySector_Dropdown}    ${sIndustry_Sector}
    Mx Input Text    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_BusinessActivity_Dropdown}    ${sBusiness_Activity}
    Double Click Element    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_IsMainActivity_CheckBox}
    Double Click Element    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_IsPrimaryActivity_CheckBox}
    Mx Click Element    ${Party_Dialog_SaveRow_Button}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/Update_EnterprisePartyDetailsPage--{index}.png
    Mx Click Element    ${Party_QuickEnterpriseParty_AddressDetails_Next_Button}
    
Update Enterprise Business Activity Field
    [Documentation]    This keyword is used to update industry sector and business activity field only
    ...    @author: makcamps    17DEC2020    - initial create
    [Arguments]    ${sIndustry_Sector}    ${sBusiness_Activity}    ${sExpected_Error_Message}=None
    
    Wait Until Page Contains Element    ${Party_MaintainPartyDetails_EnterpriseParty_BusinessActivity_Checkbox}
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Wait Until Page Contains    Create Enterprise Business Activity 
    Double Click Element    ${Party_TableRadioButton_RadioButton}
    Mx Input Text    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_IndustrySector_Dropdown}    ${sIndustry_Sector}
    Mx Input Text    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_BusinessActivity_Dropdown}    ${sBusiness_Activity}
    Mx Click Element    ${Party_Dialog_SaveRow_Button}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/Update_EnterprisePartyDetailsPage--{index}.png
    Mx Click Element    ${Party_QuickEnterpriseParty_AddressDetails_Next_Button}
    
Update Goods and Service Tax Details
    [Documentation]    This keyword is used to update GST Number in Goods and Service Tax Dialog
    ...    @author: javinzon    22SEP2020    - initial create
    [Arguments]    ${sCountry_of_Tax_Domicile}    ${sGST_Number}
    
    Wait Until Page Contains Element    ${Party_MaintainPartyDetails_EnterpriseParty_GTS_AddChange_Button}
    Click Button    ${Party_MaintainPartyDetails_EnterpriseParty_GTS_AddChange_Button}
    Mx Click Element    ${Party_TableRadioButton_RadioButton}
    Mx Input Text    ${Party_MaintainPartyDetails_GTSDetails_TaxCountry_Dropdown}    ${sCountry_of_Tax_Domicile}
    Mx Input Text    ${Party_MaintainPartyDetails_GTSDetails_GTSNumber_Textbox}    ${sGST_Number}
    Mx Click Element    ${Party_Dialog_SaveRow_Button}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/Update_EnterprisePartyDetailsPage--{index}.png
    Mx Click Element    ${Party_QuickEnterpriseParty_AddressDetails_Next_Button}
    
Update Party Details in Enterprise Party Page
    [Documentation]    This keyword is used to update all party details in Enterprise Party Page
    ...    @author: javinzon    22SEP2020    - initial create 
    [Arguments]        ${sLocality}    ${sParty_Sub_Type}    ${sParty_Category}    ${sEnterprise_Prefix}    ${sRegistered_Number}    ${sShort_Name_Prefix}
    ...    ${sCountry_of_Tax_Domicile}   ${sCountry_of_Registration}    ${sAddress_Type}    ${sAddress_Line_1}    ${sAddress_Line_2}    ${sAddress_Line_3}    
    ...    ${sAddress_Line_4}    ${sTown_City}   ${sState_Province}    ${sPost_Code}    ${sCountry_Region}    ${sBusiness_Country}    ${sIndustry_Sector}    ${sBusiness_Activity}
    ...    ${sGST_Number}    
        
    Update Enterprise Business Activity Details    ${sBusiness_Country}    ${sIndustry_Sector}    ${sBusiness_Activity}
    
    Update Goods and Service Tax Details    ${sCountry_of_Tax_Domicile}    ${sGST_Number}
    
    Update Enterprise Party Address Details    ${sAddress_Type}    ${sAddress_Line_1}    ${sAddress_Line_2}    ${sAddress_Line_3}    ${sAddress_Line_4}    ${sTown_City}
    ...    ${sState_Province}    ${sPost_Code}    ${sCountry_Region}
    
    ${New_Enterprise_Name}    ${Short_Name}    Update Enterprise Party Details And Return Values   ${sLocality}    ${sParty_Sub_Type}    ${sParty_Category}    ${sEnterprise_Prefix}    ${sRegistered_Number}    ${sShort_Name_Prefix}
    ...    ${sCountry_of_Tax_Domicile}   ${sCountry_of_Registration} 
    Mx Scroll Element Into View    ${Party_Footer_Next_Button}
    Wait Until Page Contains Element    ${Party_Footer_Next_Button}    60s
    Double Click Element    ${Party_Footer_Next_Button}
    Wait Until Page Contains Element    ${Party_QuickEnterpriseParty_ApprovalRequired_Dialog}    60s 
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyApprovalDialog-{index}.png
    Mx Click Element    ${Party_QuickEnterpriseParty_AskForApproval_Button}

    Wait Until Page Contains Element    ${Party_RaisedMessage_Notification}
    
    [Return]    ${New_Enterprise_Name}    ${Short_Name}
    
Update Business Activity, Short Name and Enterprise Name in Enterprise Party Page
    [Documentation]    This keyword is used to update Business Activity fields, Short Name and Enterprise Name in Enterprise Party Page
    ...    @author: makcamps    17DEC2020    - initial create 
    [Arguments]    ${sEnterprise_Prefix}    ${sShort_Name_Prefix}    ${sParty_ID}    ${sIndustry_Sector}    ${sBusiness_Activity}
        
    Update Enterprise Business Activity Field    ${sIndustry_Sector}    ${sBusiness_Activity}
    
    ${New_Enterprise_Name}    ${Short_Name}    Update Short Name and Enterprise Name And Return Values   ${sEnterprise_Prefix}    ${sShort_Name_Prefix}    ${sParty_ID}
    Mx Scroll Element Into View    ${Party_Footer_Next_Button}
    Wait Until Page Contains Element    ${Party_Footer_Next_Button}    60s
    Double Click Element    ${Party_Footer_Next_Button}
    Wait Until Page Contains Element    ${Party_QuickEnterpriseParty_ApprovalRequired_Dialog}    60s 
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyApprovalDialog-{index}.png
    Mx Click Element    ${Party_QuickEnterpriseParty_AskForApproval_Button}

    Wait Until Page Contains Element    ${Party_RaisedMessage_Notification}
    
    [Return]    ${New_Enterprise_Name}    ${Short_Name}
    
Approve Updated Party via Supervisor Account
    [Documentation]    This keyword is used to Approve updated party details via Maintain Party Details
    ...    @author: javinzon    04NOV2020    - initial create 
    [Arguments]    ${sPartyID}    ${sUserZone}    ${sUserBranch}

    Login User to Party    ${PARTY_SUPERVISOR_USERNAME}    ${PARTY_SUPERVISOR_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_APPROVER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL}
    
    Configure Zone and Branch    ${sUserZone}    ${sUserBranch}
    
    ${TaskID_ForAddress}    Approve Registered Party    ${sPartyID}    
    ${TaskID_ForPartyDetails}    Approve Registered Party    ${sPartyID}   
    
    Run Keyword If    '${SSO_ENABLED}'=='NO'    Logout User on Party
    ...    ELSE    Close Browser
    
    [Return]    ${TaskID_ForAddress}    ${TaskID_ForPartyDetails}
    
Validate Enquire Enterprise Party After Amendment
    [Documentation]    This keyword is used to validate all amended party details via Party details enquiry.
    ...    @author: javinzon    04NOV2020    - initial create
    ...	   @update: javinzon	20NOV2020	 - moved the approval keywords for party address details and validation for amendment successful page.
    [Arguments]    ${sCountry}    ${sIndustrySector}    ${sBusinessActivity}    ${bIsMainActivity}    ${bIsPrimaryActivity}    ${sLocality}    ${sEntity}    ${sAssigned_Branch}    ${sParty_Type}    ${sParty_Sub_Type}    ${sParty_Category}    ${sParty_ID}    
    ...    ${sEnterprise_Name}    ${sRegistered_Number}    ${sCountry_of_Registration}    ${sCountry_of_Tax_Domicile}    ${sShort_Name}    ${sAddress_Type}    ${sAddress_Line_1}    ${sAddress_Line_2}    ${sAddress_Line_3}    ${sAddress_Line_4}    ${sTown_City}    
    ...    ${sState_Province}    ${iPost_Code}    ${sCountry_Region}    ${sGTS_Number}
    
    Navigate Party Details Enquiry    ${sParty_ID}
    
    Compare Two Arguments    ${sLocality}    ${Party_EnquirePartyDetails_Locality_Textbox}
    Compare Two Arguments    ${sEntity}    ${Party_EnquirePartyDetails_Entity_Textbox}
    Compare Two Arguments    ${sAssigned_Branch}    ${Party_EnquirePartyDetails_AssignedBranch_Textbox}
    Compare Two Arguments    ${sParty_Type}    ${Party_EnquirePartyDetails_Partytype_Textbox}
    Compare Two Arguments    ${sParty_Sub_Type}    ${Party_EnquirePartyDetails_PartySubType_Textbox}
    Compare Two Arguments    ${sParty_Category}    ${Party_EnquirePartyDetails_PartyCategory_Textbox}
    Compare Two Arguments    ${sParty_ID}    ${Party_EnquirePartyDetails_PartyId_Textbox}
    Compare Two Arguments    ${sEnterprise_Name}    ${Party_EnquirePartyDetails_EnterpriseName_Textbox}
    Compare Two Arguments    ${sRegistered_Number}    ${Party_EnquirePartyDetails_Registernumber_Textbox}
    Compare Two Arguments    ${sCountry_of_Registration}    ${Party_EnquirePartyDetails_CountryOfRegistration_Textbox}
    Compare Two Arguments    ${sCountry_of_Tax_Domicile}    ${Party_EnquirePartyDetails_CountryOfTaxDomicile_Textbox}
    Compare Two Arguments    ${sShort_Name}    ${Party_EnquirePartyDetails_ShortName_Textbox}

    ${sGTS_Number}    Replace Variables    ${sGTS_Number}
    ${Party_EnquirePartyDetails_GeographicLocationsAndTaxNumbers_GSTNumber_Row_Locator}    Replace Variables    ${Party_EnquirePartyDetails_GeographicLocationsAndTaxNumbers_GSTNumber_Row_Locator}
    ${isVisible}    Run Keyword And Return Status    Element Should Be Visible    ${Party_EnquirePartyDetails_GeographicLocationsAndTaxNumbers_GSTNumber_Row_Locator}    
    Run Keyword If    ${isVisible}==${True}    Log    Goods & Service Tax Number value is correct! GST Number:${sGTS_Number}    level=INFO
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Goods & Service Tax Number value is incorrect! Expected Goods & Service Tax Number:${sGTS_Number}       
    
    ${sCountry_of_Tax_Domicile}    Replace Variables    ${sCountry_of_Tax_Domicile}
    ${Party_EnquirePartyDetails_GeographicLocationsAndTaxNumbers_Country_Row_Locator}    Replace Variables    ${Party_EnquirePartyDetails_GeographicLocationsAndTaxNumbers_Country_Row_Locator}
    ${isVisible}    Run Keyword And Return Status    Element Should Be Visible    ${Party_EnquirePartyDetails_GeographicLocationsAndTaxNumbers_Country_Row_Locator}    
    Run Keyword If    ${isVisible}==${True}    Log    Country value is correct! Country is:${sCountry_of_Tax_Domicile}    level=INFO
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Country value is incorrect! Expected Country:${sCountry_of_Tax_Domicile}
    
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyDetailsEnquiryPage-{index}.png
    Validate Party Address Details in Related Items if Correct     ${sAddress_Type}    ${sAddress_Line_1}    ${sAddress_Line_2}    ${sAddress_Line_3}    ${sAddress_Line_4}    ${sTown_City}    ${sState_Province}    
    ...    ${iPost_Code}    ${sCountry_Region}
    
    Validate Enquire Enterprise Business Activity Details    ${sCountry}    ${sIndustrySector}    ${sBusinessActivity}    ${bIsMainActivity}    ${bIsPrimaryActivity}
    
    Run Keyword If    '${SSO_ENABLED}'=='NO'    Logout User on Party
    ...    ELSE    Close Browser
    
Accept Approved Updated Party
    [Documentation]    This keyword is used to Accept the Approved Updated Party.
    ...    @author: javinzon    04NOV2020    - initial create
    [Arguments]    ${sTaskID_ForPartyDetails}    ${sTaskID_ForAddress}    ${sUserZone}    ${sUserBranch}   
    
    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL}   
    
    Configure Zone and Branch    ${sUserZone}    ${sUserBranch}
    
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
    
    ${TaskId_ForAddress}    Select Referral Using Reference ID    ${sTaskID_ForAddress}   
    ${IsPresent}    Run Keyword And Return Status    Wait Until Page Contains    ${PARTY_ADDRESSESCHANGE_DESCRIPTION}    5s
    Run Keyword If    ${isPresent}==${True}    Run Keywords    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyApprovalPage-{index}.png
    ...    AND    Mx Click Element    ${Party_Footer_Next_Button} 
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Approved Referral must be for Addresses Changed.
    
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
    
    ${TaskId_ForPartyDetails}    Select Referral Using Reference ID    ${sTaskID_ForPartyDetails}    
    ${IsPresent}    Run Keyword And Return Status    Wait Until Page Contains    ${PARTY_ENTERPRISEPARTYDETAILSCHANGE_DESCRIPTION}    5s
    Run Keyword If    ${isPresent}==${True}    Run Keywords    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyApprovalPage-{index}.png
    ...    AND    Mx Click Element    ${Party_Footer_Next_Button} 
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Approved Referral must be for Enterprise Party Details Changed.
    
    Wait Until Browser Ready State
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Validate Page Screen is Displayed    ${PARTY_AMENDSUCCESSFUL_PAGETITLE}
    ${isSuccessful}    Run Keyword And Return Status    Wait Until Page Contains    ${PARTY_AMENDSUCCESSFUL_MESSAGE}    10s
    Run Keyword If    ${isSuccessful}==${True}   Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyAmendment-{index}.png
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Amendment is unsuccessful.        
    
    Mx Click Element    ${Party_CloseTab_Button}
    
Accept Approved Updated Selected Details Party
    [Documentation]    This keyword is used to Accept the Approved Updated party with Business Activity fields, Short Name and Enterprise Name updates
    ...    @author: makcamps    17DEC2020    - initial create
    [Arguments]    ${sTaskID_ForPartyDetails}    ${sUserZone}    ${sUserBranch}   
    
    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL}   
    
    Configure Zone and Branch    ${sUserZone}    ${sUserBranch}
    
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
    
    ${TaskId_ForPartyDetails}    Select Referral Using Reference ID    ${sTaskID_ForPartyDetails}    
    ${IsPresent}    Run Keyword And Return Status    Wait Until Page Contains    ${PARTY_ENTERPRISEPARTYDETAILSCHANGE_DESCRIPTION}    5s
    Run Keyword If    ${isPresent}==${True}    Run Keywords    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyApprovalPage-{index}.png
    ...    AND    Mx Click Element    ${Party_Footer_Next_Button} 
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Approved Referral must be for Enterprise Party Details Changed.
    
    Wait Until Browser Ready State
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Validate Page Screen is Displayed    ${PARTY_AMENDSUCCESSFUL_PAGETITLE}
    ${isSuccessful}    Run Keyword And Return Status    Wait Until Page Contains    ${PARTY_AMENDSUCCESSFUL_MESSAGE}    10s
    Run Keyword If    ${isSuccessful}==${True}   Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyAmendment-{index}.png
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Amendment is unsuccessful.        
    
    Mx Click Element    ${Party_CloseTab_Button}