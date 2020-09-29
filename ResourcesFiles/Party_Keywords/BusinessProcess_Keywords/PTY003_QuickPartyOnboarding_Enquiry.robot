*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Variables ***
${rowid}    1

*** Keywords ***




Enquiry Party Details in Party Details Enquiry Module
    [Documentation]    This keyword is used to search Enquiry for Party details module.
    ...    @author: basuppin    21MAY2020    - initial create.
    [Arguments]    ${ExcelPath}    
     Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_SSO_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL}     
     Navigate Party Details Enquiry    &{ExcelPath}[Party_ID]
     Validate Party Details Enquiry - Enquire Enterprise Party   &{ExcelPath}[Party_ID]    &{ExcelPath}[Country_of_Tax_Domicile]    &{ExcelPath}[Country_of_Registration]    &{ExcelPath}[Enterprise_Prefix]     &{ExcelPath}[Assigned_Branch]     &{ExcelPath}[Locality]    &{ExcelPath}[Party_Type]     &{ExcelPath}[Industry_Sector]    &{ExcelPath}[Business_Activity]    &{ExcelPath}[Is_Main_Activity]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]     &{ExcelPath}[Beneficial_Owners]    &{ExcelPath}[Principal_Directors]    &{ExcelPath}[Signatories]    &{ExcelPath}[Parent]    &{ExcelPath}[Num_Employees]    &{ExcelPath}[Manager_ID]    &{ExcelPath}[Business_Country]    &{ExcelPath}[Is_Primary_Activity]     &{ExcelPath}[Registered_Number]     &{ExcelPath}[Short_Name]    &{ExcelPath}[Tax_ID_GST_Number]    
     Enquire Party Details Search    &{ExcelPath}[Party_ID]    &{ExcelPath}[Assigned_Branch]    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]     &{ExcelPath}[Line_Of_Business]    &{ExcelPath}[Alternate_Party_ID]    &{ExcelPath}[Party_Name]    &{ExcelPath}[Date_Formed]    &{ExcelPath}[National_ID]    &{ExcelPath}[Tax_ID_GST_Number]    
     Logout User on Party                   
     


Validate Party Details Enquiry - Enquire Enterprise Party
    [Documentation]    This keyword validates fields in Enquire Enterprise Party page.
    ...    @author: gagregado    28SEPT2020    - initial create
    [Arguments]    ${sParty_ID}    ${sCountry_of_Tax_Domicile}    ${sCountry_of_Registration}    ${sEnterpriseName}    ${sAssignedBranch}    ${sLocalityContext}
    ...    ${sPartyType}    ${sIndustry_Sector}    ${sBusiness_Activity}    ${bIs_Main_Activity}    ${sPartySubtype}
    ...    ${sPartyCategory}    ${sBeneficialOwners}    ${sPrincipal}    ${sSignatories}    ${sParent}    ${sNumEmployees}    ${sManagerId}    ${sBusiness_Country}    ${bIs_Primary_Activity}    ${iRegistered_Number}    ${sShort_Name}
    ...    ${sGSTNumber}

    Compare Two Arguments    ${sParty_ID}    ${Party_EnquirePartyDetails_PartyId_TextBox}
    Compare Two Arguments    ${iRegistered_Number}    ${Party_EnquirePartyDetails_Registernumber_Textbox}
    Compare Two Arguments    ${sCountry_of_Tax_Domicile}    ${Party_EnquirePartyDetails_CountryOfTaxDomicile_Textbox}
    Compare Two Arguments    ${sCountry_of_Registration}    ${Party_EnquirePartyDetails_CountryOfRegistration_Textbox}
    Compare Two Arguments    ${sShort_Name}    ${Party_EnquirePartyDetails_ShortName_TextBox}
    Compare Two Arguments    ${sEnterpriseName}    ${Party_EnquirePartyDetails_EnterpriseName_TextBox}
    Compare Two Arguments    ${sAssignedBranch}    ${Party_EnquirePartyDetails_AssignedBranch_Textbox}
    Compare Two Arguments    ${sLocalityContext}    ${Party_EnquirePartyDetails_Locality_Textbox}
    Compare Two Arguments    ${sPartyType}    ${Party_EnquirePartyDetails_Partytype_Textbox}
    Compare Two Arguments    ${sPartySubtype}    ${Party_EnquirePartyDetails_PartySubType_Textbox}
    Compare Two Arguments    ${sPartyCategory}    ${Party_EnquirePartyDetails_PartyCategory_Textbox}
    Compare Two Arguments    ${sBeneficialOwners}    ${Party_EnquirePartyDetails_BeneficialOwners_Textbox}
    Compare Two Arguments    ${sPrincipal}    ${Party_EnquirePartyDetails_Directors_Textbox}
    Compare Two Arguments    ${sSignatories}    ${Party_EnquirePartyDetails_SIgnatories_Textbox}
    Compare Two Arguments    ${sParent}    ${Party_EnquirePartyDetails_isParent_Textbox}
    Compare Two Arguments    ${sNumEmployees}    ${Party_EnquirePartyDetails_NumberOfEmployees_Textbox}
    Compare Two Arguments    ${sManagerId}    ${Party_EnquirePartyDetails_ManagerID_TextBox}
    Get Text From Row and Compare    ${sGSTNumber}    ${Party_EnquirePartyDetails_GoodsServiceTaxNumber_TableGrid_Row}    
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyDetailsEnquiry-{index}.png

    

    Validate Party Details Enquiry - Enterprise Business Activity    ${sIndustry_Sector}    ${sBusiness_Activity}    ${bIs_Main_Activity}    ${sBusiness_Country}    ${bIs_Primary_Activity}




Validate Party Details Enquiry - Enterprise Business Activity
    [Documentation]    This keyword validates fields in Enterprise Business Activity modal.
    ...    @author: dahijara    11MAY2020    - initial create
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

                                  

     
     
                   
     
     
     
     
     
     
     
     

     