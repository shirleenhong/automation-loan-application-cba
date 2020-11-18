*** Settings ***
Resource       ../../../Configurations/Party_Import_File.robot

*** Keywords ***


Create Bulk File for Upload
    [Documentation]    This keyword is used to create the bulk party upload file for the Bulk Party Upload feature
    ...    @author: nbautist    03NOV2020    - initial create
    [Arguments]    ${sParty_Category}    ${sParty_Type}    ${sParty_Sub_Type}    ${bGST_Liable}    ${sAssigned_Branch_Code}    ${bDigital_Banking_Via_Internet}    ${bDigital_Banking_Via_Mobile}
    ...    ${sAlternate_Party_ID}    ${sBusiness_Country}    ${bIs_Main_Activity}    ${bIs_Primary_Activity}    ${sFranchise_Affinity}    ${sBusiness_Activity}    ${sImport_Export}    
    ...    ${sIndustry_Sector}    ${sTax_ID_GST_Number}    ${sGST_Number}    ${sParent}    ${sNon_Resident_License_Permit}    ${sAddress_Type}    
    ...    ${sAddress_Line_1}    ${sAddress_Line_2}    ${sDefault_Address}    ${sAddress_Line_3}    ${sAddress_Line_4}    ${sTown_City}    ${sState_Province}    ${sPost_Code}    
    ...    ${sLine_Of_Business}    ${iNumber_of_Parties}    ${sEnterprise_Prefix}    ${sShort_Name_Prefix}    ${sCountry_Code}    ${sParty_Type_Code}    ${sParty_Sub_Type_Code}    ${sState_Province_Code}     
    ...    ${sAddress_Type_Code}    ${sIndustry_Sector_Code}    ${sBusiness_Activity_Code}    ${sSave_Path}

    ### Prepare containers for party data ###
    ${Bulk_Upload_List}    Create List
    ${Bulk_List}    Create List 
    ${BULK_DICTIONARY}    Create Dictionary  
    ${Parties}    Convert To Integer    ${iNumber_of_Parties}
    
    ### Generate the contents of the bulk party upload file ###
    :FOR    ${INDEX}    IN RANGE    1    ${Parties}+1
    \    ### Create id-based party data ###
    \    ${Generated_Value}    Generate Unique Number or Text With Format for Party        Format=%H8%M%S
    \    ${Party_ID}    Set Variable    ${Generated_Value}
    \    ${Enterprise_Name}    Catenate    ${sEnterprise_Prefix}    ${Generated_Value}
    \    ${Short_Name}    Catenate    ${sShort_Name_Prefix}    ${Generated_Value}
    \    ${Registered_Number}    Catenate    REG    ${Generated_Value}
    \    
    \    ### Add party data to container list ###
    \    Append To List    ${Bulk_List}    ${PARTY_BULK_UNIQUE_ID}${Party_ID};\n
    \    Append To List    ${Bulk_List}    ${PARTY_BULK_PARTY_PARTYID}${Party_ID};\n
    \    ${sParty_Category}    Convert To Uppercase    ${sParty_Category}
    \    Append To List    ${Bulk_List}    ${PARTY_BULK_PARTY_PARTYCATEGORY}${sParty_Category};\n
    \    Append To List    ${Bulk_List}    ${PARTY_BULK_PARTY_PARTYTYPE}${sParty_Type_Code};\n    
    \    Append To List    ${Bulk_List}    ${PARTY_BULK_PARTY_PARTYSUBTYPE}${sParty_Sub_Type_Code};\n
    \    Append To List    ${Bulk_List}    ${PARTY_BULK_PARTY_ISTAXPAYER}${bGST_Liable};\n
    \    Append To List    ${Bulk_List}    ${PARTY_BULK_PARTY_ASSIGNEDBRANCHCODE}${sAssigned_Branch_Code};\n
    \    Append To List    ${Bulk_List}    ${PARTY_BULK_PARTY_ISINTERNET}${bDigital_Banking_Via_Internet};\n
    \    Append To List    ${Bulk_List}    ${PARTY_BULK_PARTY_ISMOBILE}${bDigital_Banking_Via_Mobile};\n
    \    Append To List    ${Bulk_List}    ${PARTY_BULK_PARTY_ALTERNATECUSTOMERID}${sAlternate_Party_ID};\n
    \    Append To List    ${Bulk_List}    ${PARTY_BULK_PARTY_ENTERPRISENAME}${Enterprise_Name};\n
    \    Append To List    ${Bulk_List}    ${PARTY_BULK_PARTY_SHORTNAME}${Short_Name};\n
    \    Append To List    ${Bulk_List}    \n
    \    Append To List    ${Bulk_List}    {${PARTY_BULK_BA_COUNTRY}${sCountry_Code};\n
    \    Append To List    ${Bulk_List}    ${PARTY_BULK_BA_ISMAINACTIVITY}${bIs_Main_Activity};\n
    \    Append To List    ${Bulk_List}    ${PARTY_BULK_BA_ISPRIMARYACTIVITY}${bIs_Primary_Activity};\n
    \    ${sFranchise_Affinity}    Convert To Uppercase    ${sFranchise_Affinity}
    \    Append To List    ${Bulk_List}    ${PARTY_BULK_BA_FRANCHISEAFFINITY}${sFranchise_Affinity};\n
    \    Append To List    ${Bulk_List}    ${PARTY_BULK_BA_BUSINESSACTIVITY}${sBusiness_Activity_Code};\n
    \    ${sImport_Export}    Convert To Uppercase    ${sImport_Export}
    \    Append To List    ${Bulk_List}    ${PARTY_BULK_BA_IMPORTEXPORT}${sImport_Export};\n
    \    Append To List    ${Bulk_List}    ${PARTY_BULK_BA_INDUSTRYSECTOR}${sIndustry_Sector_Code};}\n
    \    Append To List    ${Bulk_List}    \n
    \    Append To List    ${Bulk_List}    ${PARTY_BULK_PTD_ISREGISTEREDFORGST}${sTax_ID_GST_Number};\n
    \    Append To List    ${Bulk_List}    ${PARTY_BULK_PTD_GSTREGISTRATIONNUMBER}${sGST_Number};\n
    \    Append To List    ${Bulk_List}    ${PARTY_BULK_PTD_ISPARENT}${sParent};\n
    \    Append To List    ${Bulk_List}    \n
    \    Append To List    ${Bulk_List}    ${PARTY_BULK_ED_REGISTEREDNUMBER}${Registered_Number};\n
    \    Append To List    ${Bulk_List}    ${PARTY_BULK_ED_NONRESILICORPERMITNO}${sNon_Resident_License_Permit};\n
    \    Append To List    ${Bulk_List}    ${PARTY_BULK_ED_COUNTRYOFREGISTRATION}${sCountry_Code};\n
    \    Append To List    ${Bulk_List}    \n
    \    Append To List    ${Bulk_List}    {${PARTY_BULK_ADDRESS_ADDRESSTYPE}${sAddress_Type_Code};\n
    \    Append To List    ${Bulk_List}    ${PARTY_BULK_ADDRESS_ADDRESSLINE1}${sAddress_Line_1};\n
    \    Append To List    ${Bulk_List}    ${PARTY_BULK_ADDRESS_ADDRESSLINE2}${sAddress_Line_2};\n
    \    Append To List    ${Bulk_List}    ${PARTY_BULK_ADDRESS_ISDEAFULTADDRESS}${sDefault_Address};\n
    \    Append To List    ${Bulk_List}    ${PARTY_BULK_ADDRESS_ADDRESSLINE3}${sAddress_Line_3};\n
    \    Append To List    ${Bulk_List}    ${PARTY_BULK_ADDRESS_ADDRESSLINE4}${sAddress_Line_4};\n
    \    Append To List    ${Bulk_List}    ${PARTY_BULK_ADDRESS_TOWNORCITY}${sTown_City};\n
    \    Append To List    ${Bulk_List}    ${PARTY_BULK_ADDRESS_ADDRESSLINE10}${sState_Province_Code};\n
    \    Append To List    ${Bulk_List}    ${PARTY_BULK_ADDRESS_POSTALCODE}${sPost_Code};\n
    \    Append To List    ${Bulk_List}    ${PARTY_BULK_ADDRESS_COUNTRYCODE}${sCountry_Code};}\n
    \    Append To List    ${Bulk_List}    {${PARTY_BULK_LINEOFBUSINESS_}${sLine_Of_Business};}\n
    \
    \    ### Add container list data to formatted list ###
    \    ${Bulk_Upload_List}    Combine Lists    ${Bulk_Upload_List}    ${Bulk_List}
    \
    \    ### Add party data to reference dictionary ###
    \    Set To Dictionary    ${BULK_DICTIONARY}    ${Party_ID}    ${Bulk_List}
    \    
    \    ### Cleanup and preparation for next party ###
    \    ${Bulk_List}    Create List
    \    Exit For Loop If    ${INDEX}==${Parties}
    \    Append To List    ${Bulk_Upload_List}    |\n

    ### Generate and save the actual file. The format "BulkPartyUpload_%Y%m%d%H%M%S.xml" is the specified format for bulk party upload files.  ###
    ${Filename_Value}    Generate Unique Number or Text with Format for Party    Format=%Y%m%d%H%M%S
    ${BULK_FILENAME}    Set Variable    BulkPartyUpload_${Filename_Value}.xml
    ${Filename_Path}    Set Variable    ${sSave_Path}${BULK_FILENAME}
    Create File    ${Filename_Path}
    :FOR    ${Line}    IN    @{Bulk_Upload_List}
    \    ${Append_Line}    Convert To String    ${Line}
    \    Append To File    ${Filename_Path}    ${Append_Line}
    
    ### Format file path ###
    Replace String    ${Filename_Path}    \    \\
    
    ### Create mapping of coded values to UI values
    Create Mapping For Coded Values From Bulkfile    ${sCountry_Code}    ${sBusiness_Country}    ${sParty_Type_Code}    ${sParty_Type}    ${sParty_Sub_Type_Code}    ${sParty_Sub_Type}
    ...    ${sState_Province_Code}     ${sState_Province}    ${sAddress_Type_Code}    ${sAddress_Type}    ${sIndustry_Sector_Code}    ${sIndustry_Sector}    ${sBusiness_Activity_Code}
    ...    ${sBusiness_Activity}
        
    ### Set Global Variables ###
    Set Global Variable    ${BULK_DICTIONARY}
    Set Global Variable    ${BULK_FILENAME}
    
    [Return]    ${Filename_Path}

Create Mapping For Coded Values From Bulkfile
    [Documentation]    This keyword is used to create the mapping of coded values to meaningful description
    ...    @author: nbautist    03NOV2020    - initial create
    [Arguments]    ${sCountry_Code}    ${sCountry_Description}    ${sPartyType_Code}    ${sPartyType_Desctription}    ${sPartySubType_Code}    ${sPartySubType_Description}    ${sProvince_Code}    ${sProvince_Desctription}    ${sAddressType_Code}    ${sAddressType_Description}    ${sIndustrySectorCode_Code}    ${sIndustrySectorCode_Desctription}    ${sBussActivity_Code}    ${sBussActivity_Description}    
    
    ${PARTY_BULK_MAPPING_COUNTRYCODE}   Create Dictionary    ${sCountry_Code}=${sCountry_Description}
    ${PARTY_BULK_MAPPING_PARTYTYPE}   Create Dictionary    ${sPartyType_Code}=${sPartyType_Desctription}
    ${PARTY_BULK_MAPPING_PARTYSUBTYPE}   Create Dictionary    ${sPartySubType_Code}=${sPartySubType_Description}
    ${PARTY_BULK_MAPPING_PROVINCE}   Create Dictionary    ${sProvince_Code}=${sProvince_Desctription}
    ${PARTY_BULK_MAPPING_ADDRESSTYPE}   Create Dictionary    ${sAddressType_Code}=${sAddressType_Description}
    ${PARTY_BULK_MAPPING_INDUSTRYSECTOR}   Create Dictionary    ${sIndustrySectorCode_Code}=${sIndustrySectorCode_Desctription}
    ${PARTY_BULK_MAPPING_BUSINESSACTIVITY}   Create Dictionary    ${sBussActivity_Code}=${sBussActivity_Description}
    
    Set Global Variable    ${PARTY_BULK_MAPPING_COUNTRYCODE}
    Set Global Variable    ${PARTY_BULK_MAPPING_PARTYTYPE}
    Set Global Variable    ${PARTY_BULK_MAPPING_PARTYSUBTYPE}
    Set Global Variable    ${PARTY_BULK_MAPPING_PROVINCE}
    Set Global Variable    ${PARTY_BULK_MAPPING_ADDRESSTYPE}
    Set Global Variable    ${PARTY_BULK_MAPPING_INDUSTRYSECTOR}
    Set Global Variable    ${PARTY_BULK_MAPPING_BUSINESSACTIVITY}
    Set Global Variable    ${PARTY_BULK_MAPPING_CHECKBOXVALUES}
    
Upload Bulk Party File
    [Documentation]    This keyword is used to upload the bulk party upload file to the Bulk Party Upload feature
    ...    @author: nbautist    03NOV2020    - initial create
    [Arguments]    ${sFilename_Path}
    
    Mx Hover And Click Element    ${Party_BulkPartyUpload_Browse_Button}
    Mx Send Keys    ${sFilename_Path}
    Mx Press Combination    KEY.ENTER
    Wait Until Element Is Visible    ${Party_BulkPartyUpload_Upload_Button}
    Mx Click Element    ${Party_BulkPartyUpload_Upload_Button}
    
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/BulkPartyUploadPage-{index}.png
    
Verify Bulk Party Upload Successful
    [Documentation]    This keyword is used to verify the bulk party file was successfully uploaded
    ...    @author: nbautist    03NOV2020    - initial create
    [Arguments]    ${sFilename_Path}    
    
    ### Verify if the bulk upload file in the File table is present ###
    ${Party_BulkPartyUploadEnquiry_UploadedFile}    Replace Variables    ${Party_BulkPartyUploadEnquiry_UploadedFile}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${Party_BulkPartyUploadEnquiry_UploadedFile}    ${BULK_PARTY_UPLOAD_FAILED_ERROR_MESSAGE}
    
    ### Verify if the parties in the Party table were added successfully ###
    :FOR    ${key}    IN    @{BULK_DICTIONARY}
    \    ${Unique_Id}    Set Variable    ${key}
    \    ${Party_BulkPartyUploadEnquiry_Party_Row}    Replace Variables    ${Party_BulkPartyUploadEnquiry_Party_Row}
    \    Run Keyword And Continue On Failure    Element Should Be Visible    ${Party_BulkPartyUploadEnquiry_Party_Row}    ${PARTY_UPLOAD_FAILED_ERROR_MESSAGE}
        
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/BulkPartyUploadEnquiryPage-{index}.png

Verify Correct Party Details From Bulk Upload
    [Documentation]    This keyword is used to verify the party details from the uploaded bulk party file
    ...    @author: nbautist    03NOV2020    - initial create
    [Arguments]    ${sLocality}    ${sEntity}    ${sCountry_of_Tax_Domicile}
    
    ### This loop will iterate through all the parties to verify if the parties' details were uploaded successfully. ###    
    :FOR    ${key}    IN    @{BULK_DICTIONARY}
    \    ### Open Party Tab ###
    \    Close Active Tab
    \    Search Process In Party    ${PARTYDETAILS_ENQUIRY}
    \    Wait Until Browser Ready State
    \    Wait Until Keyword Succeeds    10x    2s     Mx Input Text    ${Party_EnquireEnterpriseParty_PartyId_Text}     ${key}
    \    Wait Until Browser Ready State
    \    Wait Until Element Is Visible    ${Party_EnquireEnterpriseParty_Next_Button}
    \    Wait Until Element Is Enabled    ${Party_EnquireEnterpriseParty_Next_Button}       
    \    Mx Click Element    ${Party_EnquireEnterpriseParty_Next_Button}
    \    Wait Until Browser Ready State
    \    Wait Until Page Contains    ${PARTY_ENQUIREENTERPRISEPARTY_PAGETITLE}    20s
    \
    \    ### Open Party Details and verify data from bulk file ###
    \    ${Party_List}    Get From Dictionary    ${BULK_DICTIONARY}    ${key}
    \    ${Party_ID}    Get Info From Party Details From List    ${Party_List}    ${PARTY_BULK_PARTY_PARTYID}
    \    ${PartyType}    Get Info From Party Details From List    ${Party_List}    ${PARTY_BULK_PARTY_PARTYTYPE}
    \    ${PartyType}    Get From Dictionary    ${PARTY_BULK_MAPPING_PARTYTYPE}    ${PartyType}
    \    ${PartySubtype}    Get Info From Party Details From List    ${Party_List}    ${PARTY_BULK_PARTY_PARTYSUBTYPE}
    \    ${PartySubtype}    Get From Dictionary    ${PARTY_BULK_MAPPING_PARTYSUBTYPE}    ${PartySubtype}
    \    ${PartyCategory}    Get Info From Party Details From List    ${Party_List}    ${PARTY_BULK_PARTY_PARTYCATEGORY}
    \    ${EnterpriseName}    Get Info From Party Details From List    ${Party_List}    ${PARTY_BULK_PARTY_ENTERPRISENAME}
    \    ${Registered_Number}    Get Info From Party Details From List    ${Party_List}    ${PARTY_BULK_ED_REGISTEREDNUMBER}
    \    ${Country_of_Registration}    Get Info From Party Details From List    ${Party_List}    ${PARTY_BULK_ED_COUNTRYOFREGISTRATION}
    \    ${Country_of_Registration}    Get From Dictionary    ${PARTY_BULK_MAPPING_COUNTRYCODE}    ${Country_of_Registration}
    \    ${Short_Name}    Get Info From Party Details From List    ${Party_List}    ${PARTY_BULK_PARTY_SHORTNAME}
    \    ${GSTNumber}    Get Info From Party Details From List    ${Party_List}    ${PARTY_BULK_PTD_GSTREGISTRATIONNUMBER}
    \    Validate Enquire Enterprise Party For Bulk Party    ${Party_ID}    ${sLocality}    ${sEntity}    ${PartyType}    ${PartySubtype}    ${PartyCategory}    ${EnterpriseName}    ${Registered_Number}    ${sCountry_of_Tax_Domicile}    ${Country_of_Registration}    ${Short_Name}    ${GSTNumber}
    \
    \    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyDetailsEnquiryPage-{index}.png
    \
    \    ### Open Party Address Details and verify data from bulk file ###
    \    Mx Click Element    ${Party_EnquirePartyDetails_EnterpriseParty_RelatedItems_Menu}
    \    Mx Click Element    ${Party_EnquirePartyDetails_EnterpriseParty_Addresses_MenuItem}
    \    ${AddressType}    Get Info From Party Details From List    ${Party_List}    ${PARTY_BULK_ADDRESS_ADDRESSTYPE}
    \    ${AddressType}    Get From Dictionary    ${PARTY_BULK_MAPPING_ADDRESSTYPE}    ${AddressType}    
    \    ${Country}    Get Info From Party Details From List    ${Party_List}    ${PARTY_BULK_ADDRESS_COUNTRYCODE}
    \    ${Country}    Get From Dictionary    ${PARTY_BULK_MAPPING_COUNTRYCODE}    ${Country}    
    \    ${StateProvince}    Get Info From Party Details From List    ${Party_List}    ${PARTY_BULK_ADDRESS_ADDRESSLINE10}
    \    ${StateProvince}    Get From Dictionary   ${PARTY_BULK_MAPPING_PROVINCE}    ${StateProvince}    
	\    ${TownCity}    Get Info From Party Details From List    ${Party_List}    ${PARTY_BULK_ADDRESS_TOWNORCITY}
	\    ${AddressLine1}    Get Info From Party Details From List    ${Party_List}    ${PARTY_BULK_ADDRESS_ADDRESSLINE1}
	\    ${AddressLine2}    Get Info From Party Details From List    ${Party_List}    ${PARTY_BULK_ADDRESS_ADDRESSLINE2}
	\    ${AddressLine3}    Get Info From Party Details From List    ${Party_List}    ${PARTY_BULK_ADDRESS_ADDRESSLINE3}
	\    ${AddressLine4}    Get Info From Party Details From List    ${Party_List}    ${PARTY_BULK_ADDRESS_ADDRESSLINE4}
	\    ${PostalCode}    Get Info From Party Details From List    ${Party_List}    ${PARTY_BULK_ADDRESS_POSTALCODE}
    \    Validate Address Details For Bulk Party    ${AddressType}    ${Country}    ${StateProvince}    ${TownCity}    ${AddressLine1}    ${AddressLine2}    ${AddressLine3}    ${AddressLine4}    ${PostalCode}
    \
    \    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyDetailsAddressPage-{index}.png
    \
    \    ### Open Party Enterprise Business Details and verify data from bulk file ###
    \    Mx Click Element    ${Party_CloseDialog_Button}
    \    Mx Click Element    ${Party_EnquirePartyDetails_BusinessActivity_Viewbutton}
    \    ${BusinessCountry}    Get Info From Party Details From List    ${Party_List}    ${PARTY_BULK_BA_COUNTRY}
    \    ${BusinessCountry}    Get From Dictionary    ${PARTY_BULK_MAPPING_COUNTRYCODE}    ${BusinessCountry}    
    \    ${IndustrySector}    Get Info From Party Details From List    ${Party_List}    ${PARTY_BULK_BA_INDUSTRYSECTOR}
    \    ${IndustrySector}    Get From Dictionary    ${PARTY_BULK_MAPPING_INDUSTRYSECTOR}    ${IndustrySector}
    \    ${BusinessActivity}    Get Info From Party Details From List    ${Party_List}    ${PARTY_BULK_BA_BUSINESSACTIVITY}
	\    ${BusinessActivity}    Get From Dictionary    ${PARTY_BULK_MAPPING_BUSINESSACTIVITY}    ${BusinessActivity}
    \    ${IsMainActivity}    Get Info From Party Details From List    ${Party_List}    ${PARTY_BULK_BA_ISMAINACTIVITY}
	\    ${IsMainActivity}    Get From Dictionary    ${PARTY_BULK_MAPPING_CHECKBOXVALUES}    ${IsMainActivity}
    \    ${IsPrimaryActivity}    Get Info From Party Details From List    ${Party_List}    ${PARTY_BULK_BA_ISPRIMARYACTIVITY}
	\    ${IsPrimaryActivity}    Get From Dictionary    ${PARTY_BULK_MAPPING_CHECKBOXVALUES}    ${IsPrimaryActivity}
    \    Validate Enquire Business Activity For Bulk Party    ${BusinessCountry}    ${IndustrySector}    ${BusinessActivity}    ${IsMainActivity}    ${IsPrimaryActivity}
    \
    \    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyDetailsEnterpriseBusinessPage-{index}.png
    \
    \    Close Active Tab
    
    Close Active Tab
    
Get Info From Party Details From List
    [Documentation]    This keyword is used to get specific party info from the party info list
    ...    @author: nbautist    03NOV2020    - initial create
    [Arguments]    ${aList}    ${String_Prefix}
    
    ${Party_Item}    Set Variable    ${None}
    :FOR    ${Item}    IN    @{aList}
    \    ${Party_Item}    Get Lines Containing String    ${Item}    ${String_Prefix}
    \    Exit For Loop If    '${Party_Item}'!='${EMPTY}'
        
    ${Party_Info}    Fetch From Right    ${Party_Item}    ${String_Prefix}
    ${Party_Info}    Strip String    ${Party_Info}    characters=;}${SPACE}
    
    [return]    ${Party_Info}

Validate Enquire Enterprise Party For Bulk Party
    [Documentation]    This keyword validates fields in Enquire Enterprise Party page after bulk party upload.
    ...    @author: nbautist    09NOV2020    - initial create
    [Arguments]    ${iParty_ID}    ${sLocalityContext}    ${Entity}    ${sPartyType}    ${sPartySubtype}    ${sPartyCategory}    ${sEnterpriseName}    ${iRegistered_Number}
    ...    ${sCountry_of_Tax_Domicile}    ${sCountry_of_Registration}    ${sShort_Name}    ${iGSTNumber}

    Compare Two Arguments    ${iParty_ID}    ${Party_EnquirePartyDetails_PartyId_Textbox}
    Compare Two Arguments    ${iRegistered_Number}    ${Party_EnquirePartyDetails_Registernumber_Textbox}
    Compare Two Arguments    ${sCountry_of_Tax_Domicile}    ${Party_EnquirePartyDetails_CountryOfTaxDomicile_Textbox}
    Compare Two Arguments    ${sCountry_of_Registration}    ${Party_EnquirePartyDetails_CountryOfRegistration_Textbox}
    Compare Two Arguments    ${sShort_Name}    ${Party_EnquirePartyDetails_ShortName_Textbox}
    Compare Two Arguments    ${sEnterpriseName}    ${Party_EnquirePartyDetails_EnterpriseName_Textbox}
    Compare Two Arguments    ${sLocalityContext}    ${Party_EnquirePartyDetails_Locality_Textbox}
    Compare Two Arguments    ${sPartyType}    ${Party_EnquirePartyDetails_Partytype_Textbox}
    Compare Two Arguments    ${sPartySubtype}    ${Party_EnquirePartyDetails_PartySubType_Textbox}
    Compare Two Normalized Arguments    ${sPartyCategory}    ${Party_EnquirePartyDetails_PartyCategory_Textbox}
    Get Text From Row and Compare    ${iGSTNumber}    ${Party_EnquirePartyDetails_GoodsServiceTaxNumber_TableGrid_Row}
    
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyDetailsEnquiry-{index}.png
    
Validate Address Details For Bulk Party
    [Documentation]    This keyword validates fields in Enquire Enterprise Party page after bulk party upload.
    ...    @author: nbautist    09NOV2020    - initial create
    [Arguments]    ${sAddressType}    ${sCountry}    ${sStateProvince}    ${sTownCity}    ${sAddressLine1}    ${sAddressLine2}    ${sAddressLine3}    ${sAddressLine4}    ${sPostalCode}
    
    Compare Two Arguments    ${sAddressType}    ${Party_EnquirePartyDetails_PartyAddress_AddressType_Dropdown}
    Compare Two Arguments    ${sCountry}    ${Party_EnquirePartyDetails_PartyAddress_AddressCountry_Textbox}
    Compare Two Arguments    ${sStateProvince}    ${Party_EnquirePartyDetails_PartyAddress_StateProvince_Dropdown}
	Compare Two Arguments    ${sTownCity}    ${Party_EnquirePartyDetails_PartyAddress_Town_Textbox}
	Compare Two Arguments    ${sAddressLine1}    ${Party_EnquirePartyDetails_PartyAddress_AddressLine1_Textbox}
	Compare Two Arguments    ${sAddressLine2}    ${Party_EnquirePartyDetails_PartyAddress_AddressLine2_Textbox}
	Compare Two Arguments    ${sAddressLine3}    ${Party_EnquirePartyDetails_PartyAddress_AddressLine3_Textbox}
	Compare Two Arguments    ${sAddressLine4}    ${Party_EnquirePartyDetails_PartyAddress_AddressLine4_Textbox}
	Compare Two Arguments    ${sPostalCode}    ${Party_EnquirePartyDetails_PartyAddress_PostCode_Textbox}
	
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyDetailsEnquiryPageAddressDetails-{index}.png
	
Validate Enquire Business Activity For Bulk Party
    [Documentation]    This keyword validates fields in Enquire Business Activity for Party after bulk party upload.
    ...    @author: nbautist    09NOV2020    - initial create
    [Arguments]    ${sBusinessCountry}    ${sIndustrySector}    ${sBusinessActivity}    ${bIsMainActivity}    ${bIsPrimaryActivity}
    
    Compare Two Arguments    ${sBusinessCountry}    ${Party_EnquirePartyDetails_BusinessActivity_Country_Combobox}
	Compare Two Arguments    ${sIndustrySector}    ${Party_EnquirePartyDetails_BusinessActivity_Industrysector_Combobox}
	Compare Two Arguments    ${sBusinessActivity}    ${Party_EnquirePartyDetails_BusinessActivity_Combobox}
	Compare Two Arguments    ${bIsMainActivity}    ${Party_EnquirePartyDetails_BusinessActivity_Is_Main_Activity_Checkbox}
	Compare Two Arguments    ${bIsPrimaryActivity}    ${Party_EnquirePartyDetails_BusinessActivity_Is_Primary_Activity_checkbox}

    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyDetailsEnterpriseBusinessActivity-{index}.png
    
Verify Correct Bulk Party Details In LoanIQ
    [Documentation]    This keyword validates fields in LoanIQ if consistent with bulk party upload daata.
    ...    @author: nbautist    09NOV2020    - initial create
    
    Mx LoanIQ Activate Window    ${LIQ_Window}
    
    ### Prepare data transform for some data from code to description ###
    
    :FOR    ${key}    IN    @{BULK_DICTIONARY}
    \    ### Get Party data from reference dictionary and verify data from bulk file ###
    \    ${Party_List}    Get From Dictionary    ${BULK_DICTIONARY}    ${key}
    \    ${Party_ID}    Get Info From Party Details From List    ${Party_List}    ${PARTY_BULK_PARTY_PARTYID}
    \    ${Short_Name}    Get Info From Party Details From List    ${Party_List}    ${PARTY_BULK_PARTY_SHORTNAME}
    \    ${EnterpriseName}    Get Info From Party Details From List    ${Party_List}    ${PARTY_BULK_PARTY_ENTERPRISENAME}
    \    ${GSTNumber}    Get Info From Party Details From List    ${Party_List}    ${PARTY_BULK_PTD_GSTREGISTRATIONNUMBER}
    \    Mx LoanIQ Click    ${LIQ_Actions_Button} 
    \    Search by Customer ID    ${Party_ID}    ${Short_Name}
    \    Run Keyword And Continue On Failure    mx LoanIQ click element if present  ${LIQ_ActiveCustomer_UpdateMode_Button}
    \    ${CustomerID}    ${ShortName}    ${LegalName}    ${GSTID}    Return Customer Details from Active Customer General Tab
	\    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${Party_ID}    ${CustomerID}
	\    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${Short_Name}    ${ShortName}
	\    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${EnterpriseName}    ${LegalName}
	\    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${GSTNumber}    ${GSTID}
    \
    \    Take Screenshot    ${screenshot_path}/Screenshots/Party/LIQPartyDetailsGeneral-{index}.png
	\
    \    ### Open LIQ Party SIC details and verify data from bulk file ###
	\    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    SIC
    \    ${BusinessActivity}    Get Info From Party Details From List    ${Party_List}    ${PARTY_BULK_BA_BUSINESSACTIVITY}
    \    ${Primary_SICCode}    Fetch From Right    ${BusinessActivity}    _    
    \    ${LIQ_Active_Customer_Notebook_SICTab_PrimarySICCode}    Replace Variables    ${LIQ_Active_Customer_Notebook_SICTab_PrimarySICCode}    
    \    ${BusinessActivity}    Mx LoanIQ Get Data    ${LIQ_Active_Customer_Notebook_SICTab_PrimarySICCode}    text
	\    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${Primary_SICCode}    ${BusinessActivity}
    \
    \    Take Screenshot    ${screenshot_path}/Screenshots/Party/LIQPartyDetailsSIC-{index}.png
    \    
    \    ### Open LIQ Party address details and verify data from bulk file ###
    \    Mx LoanIQ Select    ${LIQ_Active_Customer_Notebook_OptionsMenu_LegalAddress}
    \    ${Country_From_Party_Data}    Get Info From Party Details From List    ${Party_List}    ${PARTY_BULK_ED_COUNTRYOFREGISTRATION}
    \    ${Country_From_Party_Data}    Get From Dictionary    ${PARTY_BULK_MAPPING_COUNTRYCODE}    ${Country_From_Party_Data}
    \    ${Province_From_Party_Data}    Get Info From Party Details From List    ${Party_List}    ${PARTY_BULK_ADDRESS_ADDRESSLINE10}
    \    ${Province_From_Party_Data}    Get From Dictionary    ${PARTY_BULK_MAPPING_PROVINCE}    ${Province_From_Party_Data}
    \    ${Country}    ${CountryOfTaxDomicile}    ${Province}    Return Customer Address Details from Active Customer Listbox fields
    \    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${Country_From_Party_Data}    ${Country}
    \    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${Province_From_Party_Data}    ${Province}
    \    ${EnterpriseName}    Get Info From Party Details From List    ${Party_List}    ${PARTY_BULK_PARTY_ENTERPRISENAME}
    \    ${AddressCode}    Get Info From Party Details From List    ${Party_List}    ${PARTY_BULK_ADDRESS_ADDRESSTYPE}
    \    ${AddressCode}    Get From Dictionary    ${PARTY_BULK_MAPPING_ADDRESSTYPE}    ${AddressCode}    
    \    ${AddressLine1}    Get Info From Party Details From List    ${Party_List}    ${PARTY_BULK_ADDRESS_ADDRESSLINE1}
    \    ${AddressLine2}    Get Info From Party Details From List    ${Party_List}    ${PARTY_BULK_ADDRESS_ADDRESSLINE2}
    \    ${AddressLine3}    Get Info From Party Details From List    ${Party_List}    ${PARTY_BULK_ADDRESS_ADDRESSLINE3}
    \    ${AddressLine4}    Get Info From Party Details From List    ${Party_List}    ${PARTY_BULK_ADDRESS_ADDRESSLINE4}
    \    ${City}    Get Info From Party Details From List    ${Party_List}    ${PARTY_BULK_ADDRESS_TOWNORCITY}
	\    ${PostalCode}    Get Info From Party Details From List    ${Party_List}    ${PARTY_BULK_ADDRESS_POSTALCODE}
    \    Validate Customer Legal Address Details in Textbox    ${EnterpriseName}    ${AddressCode}    ${AddressLine1}    ${AddressLine2}    ${AddressLine3}   ${AddressLine4}    ${City}    ${PostalCode}
    \
    \    Take Screenshot    ${screenshot_path}/Screenshots/Party/LIQPartyDetailsAddress-{index}.png
    \    
    \    Close All Windows on LIQ