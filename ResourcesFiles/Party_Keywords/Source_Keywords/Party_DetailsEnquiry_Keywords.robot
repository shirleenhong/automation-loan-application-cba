*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Keywords ***
Enquire Party ID in Party Details Page
    [Documentation]    This keyword is used to search Party ID in Party Details Enquiry Page.
    ...    @author: basuppin    21MAY2020 - initial create. 
    [Arguments]    ${sPartyID}
    
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Validate Page Screen is Displayed    ${PARTY_PARTYDETAILS_PAGETITLE}
    Mx Input Text    ${Party_EnquirePartyDetails_PartyDetails_PartyId_TextBox}    ${sPartyID}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyDetails-{index}.png
    Mx Click Element    ${Party_Footer_Next_Button}
        
Enquire Party Details in Party Enquiry Page
    [Documentation]    This keyword is used to search  party details in  Party Deatils Enquiry  Page.
    ...    @author: basuppin    21MAY2020 - initial create. 
    [Arguments]    ${sLocality}    ${sEntity}    ${sPartyID}    ${sEnterpriseName}    ${sPartySubType}    ${sPartyCategory}    ${sRegisteredNumber}    ${sCountry}    ${sGoodsServiceTaxNumber}    ${sAssignedBranch}    ${spartytype}    ${Business_CountryOfRegistration}    ${Business_CountryOfTaxDomicile}    ${sShortName}    	 		        					
     
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}   
    Compare Two Arguments    ${sLocality}    ${Party_EnquirePartyDetails_Locality_Textbox}
    Compare Two Arguments    ${sEntity}    ${Party_EnquirePartyDetails_Entity_Textbox}
    Compare Two Arguments    ${sPartyID}    ${Party_EnquirePartyDetails_PartyId_TextBox}
    Compare Two Arguments    ${sEnterpriseName}    ${Party_EnquirePartyDetails_EnterpriseName_TextBox}   
    Compare Two Arguments    ${sPartySubType}    ${Party_EnquirePartyDetails_PartySubType_Textbox}    
    Compare Two Arguments    ${sPartyCategory}    ${Party_EnquirePartyDetails_PartyCategory_Textbox}
    Compare Two Arguments    ${sRegisteredNumber}    ${Party_EnquirePartyDetails_Registernumber_Textbox}
    ${Country}    Get Text    ${Party_EnquirePartyDetails_Country_TableGrid_Row}
    Run Keyword And Continue On Failure    Should Be Equal    ${sCountry}    ${Country}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${sCountry}    ${Country}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${sCountry} = ${Country}
    ...   ELSE    Run Keyword And Continue On Failure    Fail    Country value is incorrect! Expected Value: '${sCountry}' | Actual Value: ${Country}
    ${GoodsServiceTaxNumber}    Get Text    ${Party_EnquirePartyDetails_GoodsServiceTaxNumber_TableGrid_Row}
    Run Keyword And Continue On Failure    Should Be Equal    ${sGoodsServiceTaxNumber}    ${GoodsServiceTaxNumber}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${sGoodsServiceTaxNumber}    ${GoodsServiceTaxNumber}
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are matched. ${sGoodsServiceTaxNumber} = ${GoodsServiceTaxNumber}
    ...   ELSE    Run Keyword And Continue On Failure    Fail    GoodsServiceTaxNUmber value is incorrect! Expected Value: '${sGoodsServiceTaxNumber}' | Actual Value: ${GoodsServiceTaxNumber}
    Compare Two Arguments    ${sAssignedBranch}    ${Party_EnquirePartyDetails_AssignedBranch_Textbox} 
    Compare Two Arguments    ${spartytype}    ${Party_EnquirePartyDetails_Partytype_Textbox}     
    Compare Two Arguments    ${Business_CountryOfRegistration}    ${Party_EnquirePartyDetails_CountryOfRegistration_Textbox}
    Compare Two Arguments    ${Business_CountryOfTaxDomicile}    ${Party_EnquirePartyDetails_CountryOfTaxDomicile_Textbox}
    Compare Two Arguments    ${sShortName}    ${Party_EnquirePartyDetails_ShortName_TextBox}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyDetails-{index}.png 
    
Enquire Address Details in Party Details Page
    [Documentation]    This keyword is used to search  address details in  Party details Enquiry  Page.
    ...    @author: basuppin    21MAY2020    - initial create.
    [Arguments]    ${sAddressType}    ${sPost_Code}    ${sAddressLine1}    ${sAddressLine2}    ${sAddressLine3}    ${sAddressLine4}    ${sPartyAddressCountry}    ${sState_Province}    ${sTown}            
    
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Click Element    ${Party_EnquirePartyDetails_EnterpriseParty_RelatedItems_Menu}
    Click Element    ${Party_EnquirePartyDetails_EnterpriseParty_Addresses_MenuItem}
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Wait Until Page Contains    Party Address
    Compare Two Arguments    ${sAddressType}    ${Party_EnquirePartyDetails_PartyAddress_AddressType_Dropdown}
    Compare Two Arguments    ${sPost_Code}    ${Party_EnquirePartyDetails_PartyAddress_Post_Code_Textbox}
    Compare Two Arguments    ${sAddressLine1}    ${Party_EnquirePartyDetails_PartyAddress_AddressLine1_Textbox}
    Compare Two Arguments    ${sAddressLine2}    ${Party_EnquirePartyDetails_PartyAddress_AddressLine2_Textbox}   
    Compare Two Arguments    ${sAddressLine3}    ${Party_EnquirePartyDetails_PartyAddress_AddressLine3_Textbox}
    Compare Two Arguments    ${sAddressLine4}    ${Party_EnquirePartyDetails_PartyAddress_AddressLine4_Textbox}
    Compare Two Arguments    ${sPartyAddressCountry}    ${Party_EnquirePartyDetails_PartyAddress_AddressCountry_Textbox}    
    Compare Two Arguments    ${sState_Province}    ${Party_EnquirePartyDetails_PartyAddress_StateProvince_Dropdown}
    Compare Two Arguments    ${sTown}    ${Party_EnquirePartyDetails_PartyAddress_Town_Textbox}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyDetails-{index}.png
    Mx Click Element    ${Party_CloseDialog_Button}
         
         
Enquire Business Activity Details in Party Details Page
    [Documentation]    This keyword is used to  search  business activity details in  Party details Enquiry  Page.
    ...    @author: basuppin    21MAY2020    - initial create.
    [Arguments]    ${Country}    ${sIndustrySector}    ${sBusinessActivity}    ${sIsMainActivity}    ${sIsPrimaryActivity}                      
    
    Mx Click Element  ${Party_EnquirePartyDetails_BusinessActivity_Viewbutton}
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Compare Two Arguments    ${Country}    ${Party_EnquirePartyDetails_BusinessActivity_Country_Combobox}
    Compare Two Arguments    ${sIndustrySector}    ${Party_EnquirePartyDetails_BusinessActivity_Industrysector_Combobox}
    Compare Two Arguments    ${sBusinessActivity}    ${Party_EnquirePartyDetails_BusinessActivity_Combobox }
    ${IsMainActivityChecked}    SeleniumLibraryExtended.Get Element Attribute    ${Party_EnquirePartyDetails_BusinessActivity_Is_Main_Activity_Checkbox}    aria-checked
    Run Keyword If    '${sIsMainActivity}'=='${TRUE}' and ${${IsMainActivityChecked}}==${True}    Log    IsMainActivity value is correct!
    ...   ELSE    Run Keyword And Continue On Failure    Fail    IsMainActivity value is incorrect! Expected Value: '${sIsMainActivity}' | Actual Value: ${IsMainActivityChecked}
    ${isPrimaryActivityChecked}    SeleniumLibraryExtended.Get Element Attribute    ${Party_EnquirePartyDetails_BusinessActivity_Is_Primary_Activity_checkbox}    aria-checked
    Run Keyword If    '${sIsPrimaryActivity}'=='${TRUE}' and ${${isPrimaryActivityChecked}}==${True}    Log    IsPrimaryActivity value is correct!
    ...   ELSE    Run Keyword And Continue On Failure    Fail    IsPrimaryActivity value is incorrect! Expected Value: '${sIsPrimaryActivity}' | Actual Value: ${isPrimaryActivityChecked}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyDetails-{index}.png
    Mx Click Element    ${Party_Footer_Next_Button}
    
    
    
    