*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Keywords ***

Enquire Party Details Search
    [Documentation]    This keyword is used input party ID to start SEARCH
    ...    @author: gagregado    28SEPT2020    - initial create
    [Arguments]    ${iParty_id}    ${sBranch}    ${sParty_Type}    ${sParty_Sub_Type}    ${sParty_Category}    ${sLine_Of_Business}    ${iAlternate_Party_ID}    ${sParty_Name}    ${sDate_Formed}    ${iNational_ID}    ${iTax_ID_GST_Number}        
 
	Input Text    ${Party_HomePage_Process_Textbox}    Party Details Enquiry
	Mx Press Combination    Key.Enter
	Mx Input Text    ${Party_EnquireEnterpriseParty_PartyId_Text}     ${iParty_id}
	Wait Until Browser Ready State    
	Wait Until Element Is Visible    ${Party_Search}
	Wait Until Element Is Enabled    ${Party_Search}   
	Mx Click Element    ${Party_Search}
	Wait Until Element Is Visible    ${Party_Search_Dialog}
	Party Detail Enquiry Search by Dialog    ${Party_Search_Dialog_PatyID}    ${iParty_id}
	Party Detail Enquiry Search by Dialog    ${Party_Search_Dialog_Branch}    ${sBranch}
	Party Detail Enquiry Search by Dialog    ${Party_Search_Dialog_PartyType}    ${sParty_Type}
	Party Detail Enquiry Search by Dialog    ${Party_Search_Dialog_PartyCategory}    ${sParty_Category}
	Party Detail Enquiry Search by Dialog    ${Party_Search_Dialog_LineOfBusiness}    ${sLine_Of_Business}    
	Verify Party Detail Enquiry Search Row Value    Alternate Party ID   ${iAlternate_Party_ID}    ${iParty_id}    Party ID 
	Verify Party Detail Enquiry Search Row Value    Party Name   ${sParty_Name}    ${iParty_id}    Party ID 
	Verify Party Detail Enquiry Search Row Value    DOB / Date Formed   ${sDate_Formed}    ${iParty_id}    Party ID 
	Verify Party Detail Enquiry Search Row Value    National ID / Reg No.   ${iNational_ID}    ${iParty_id}    Party ID 
	Verify Party Detail Enquiry Search Row Value    Tax ID / GST Number   ${iTax_ID_GST_Number}    ${iParty_id}    Party ID 
	Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyDetailsEnquiry-{index}.png
    Mx Click Element    ${Party_CloseDialog_Button}

Validate Enquire Enterprise Party
    [Documentation]    This keyword validates fields in Enquire Enterprise Party page.
    ...    @author: gagregado    28SEPT2020    - initial create
    [Arguments]    ${iParty_ID}    ${sCountry_of_Tax_Domicile}    ${sCountry_of_Registration}    ${sEnterpriseName}    ${sAssignedBranch}    ${sLocalityContext}
    ...    ${sPartyType}    ${sPartySubtype}    ${sPartyCategory}    ${sBeneficialOwners}    ${sPrincipal}    ${sSignatories}    ${sParent}    ${iNumEmployees}
    ...    ${sManagerId}   ${iRegistered_Number}    ${sShort_Name}    ${iGSTNumber}

    Compare Two Arguments    ${iParty_ID}    ${Party_EnquirePartyDetails_PartyId_Textbox}
    Compare Two Arguments    ${iRegistered_Number}    ${Party_EnquirePartyDetails_Registernumber_Textbox}
    Compare Two Arguments    ${sCountry_of_Tax_Domicile}    ${Party_EnquirePartyDetails_CountryOfTaxDomicile_Textbox}
    Compare Two Arguments    ${sCountry_of_Registration}    ${Party_EnquirePartyDetails_CountryOfRegistration_Textbox}
    Compare Two Arguments    ${sShort_Name}    ${Party_EnquirePartyDetails_ShortName_Textbox}
    Compare Two Arguments    ${sEnterpriseName}    ${Party_EnquirePartyDetails_EnterpriseName_Textbox}
    Compare Two Arguments    ${sAssignedBranch}    ${Party_EnquirePartyDetails_AssignedBranch_Textbox}
    Compare Two Arguments    ${sLocalityContext}    ${Party_EnquirePartyDetails_Locality_Textbox}
    Compare Two Arguments    ${sPartyType}    ${Party_EnquirePartyDetails_Partytype_Textbox}
    Compare Two Arguments    ${sPartySubtype}    ${Party_EnquirePartyDetails_PartySubType_Textbox}
    Compare Two Arguments    ${sPartyCategory}    ${Party_EnquirePartyDetails_PartyCategory_Textbox}
    Compare Two Arguments    ${sBeneficialOwners}    ${Party_EnquirePartyDetails_BeneficialOwners_Textbox}
    Compare Two Arguments    ${sPrincipal}    ${Party_EnquirePartyDetails_Directors_Textbox}
    Compare Two Arguments    ${sSignatories}    ${Party_EnquirePartyDetails_SIgnatories_Textbox}
    Compare Two Arguments    ${sParent}    ${Party_EnquirePartyDetails_isParent_Textbox}
    Compare Two Arguments    ${iNumEmployees}    ${Party_EnquirePartyDetails_NumberOfEmployees_Textbox}
    Compare Two Arguments    ${sManagerId}    ${Party_EnquirePartyDetails_ManagerID_Textbox}
    Get Text From Row and Compare    ${iGSTNumber}    ${Party_EnquirePartyDetails_GoodsServiceTaxNumber_TableGrid_Row}    
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyDetailsEnquiry-{index}.png
    
Validate Enterprise Business Activity Page
    [Documentation]    This keyword validates fields in Enterprise Business Activity modal.
    ...    @author: dahijara    11MAY2020    - initial create
    ...    @author: gbagregado  29SEPT2020   - moved keyword to Party_EnquirePartyDetails_Keywords.robot under source keywords
    [Arguments]    ${sIndustry_Sector}    ${sBusiness_Activity}    ${bIs_Main_Activity}    ${sBusiness_Country}    ${bIs_Primary_Activity}

    Click Element    ${Party_EnquirePartyDetails_BusinessActivity_Viewbutton}
    Wait Until Page Contains Element    ${Party_EnquirePartyDetails_BusinessActivity_Is_Main_Activity_Checkbox}
    Compare Two Arguments    ${sBusiness_Country}    ${Party_EnquirePartyDetails_BusinessActivity_Country_Combobox}
    Compare Two Arguments    ${sIndustry_Sector}    ${Party_EnquirePartyDetails_BusinessActivity_Industrysector_Combobox}
    Compare Two Arguments    ${sBusiness_Activity}    ${Party_EnquirePartyDetails_BusinessActivity_Combobox}
    ${IsMainActivityChecked}    Get Element Attribute    ${Party_EnquirePartyDetails_BusinessActivity_Is_Main_Activity_Checkbox}    aria-checked
    Run Keyword If    '${bIs_Main_Activity}'=='${TRUE}' and ${${IsMainActivityChecked}}==${True}    Log    IsMainActivity value is correct!
    ...   ELSE    Run Keyword And Continue On Failure    Fail    IsMainActivity value is incorrect! Expected Value: '${bIs_Main_Activity}' | Actual Value: ${IsMainActivityChecked}
    ${isPrimaryActivityChecked}    Get Element Attribute    ${Party_EnquirePartyDetails_BusinessActivity_Is_Main_Activity_Checkbox}    aria-checked
    Run Keyword If    '${bIs_Primary_Activity}'=='${TRUE}' and ${${isPrimaryActivityChecked}}==${True}        Log    IsPrimaryActivity value is correct!
    ...   ELSE    Run Keyword And Continue On Failure    Fail    IsPrimaryActivity value is incorrect! Expected Value: '${bIs_Primary_Activity}' | Actual Value: ${isPrimaryActivityChecked}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyEnterpriseBusinessActivityPage-{index}.png
    Mx Click Element    ${Party_Footer_Next_Button}
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}


Verify Party Detail Enquiry Search Row Value
    [Documentation]    This keyword is used get row value of and compare with the know value from dataset
    ...    @author: gagregado    28SEP2020    - initial create
    [Arguments]    ${sHeaderName}    ${sRowKnownValue}    ${iKeyReferenceValue}    ${sKeyReferenceHeader}
    ${VerifiedRowValue}    Get Table Value Containing Row Value in Party Detail Search Dialog     ${sKeyReferenceHeader}    ${iKeyReferenceValue}      ${sHeaderName}
    Compare Two Strings    ${VerifiedRowValue}    ${sRowKnownValue}
    
Party Detail Enquiry Search by Dialog
    [Documentation]    This keyword is to perform search in dialog
    ...    @author: gagregado    28SEP2020    - initial create
    [Arguments]    ${eInputLocator}    ${sInputVal}
    Mx Input Text    ${eInputLocator}    ${sInputVal}
    Mx Click Element    ${Party_Search_Dialog_Search_Button}
    Wait Until Element Is Visible    ${Party_Search_Dialog_RowSelectedResult}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyDetailsEnquiry-{index}.png
                                  

     




