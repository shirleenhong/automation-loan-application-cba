### Party Onboarding Page ###
Party_PartyOnboarding_Locality_Dropdown = '//input[contains(@id,"Locality") and contains(@type, "combo")]'
Party_PartyOnboarding_Entity_Textbox = '//input[contains(@id,"countryDetail")]'
Party_PartyOnboarding_AssignedBranch_Dropdown ='//input[contains(@id,"assignedBranch")]'
Party_PartyOnboarding_PartyType_Dropdown = '//input[contains(@id,"partyType")]'
Party_PartyOnboarding_PartySubType_Label = '//div[contains(@id,"PartySub-Type")]'
Party_PartyOnboarding_PartySubType_Dropdown = '//input[contains(@id,"partySubType")]'
Party_PartyOnboarding_PartyCategory_Dropdown = '//input[contains(@id,"partyCategory") and not(contains(@id, "OffScreen"))]'
Party_PartyOnboarding_Search_Button = '//input[contains(@id,"Button") and @name="Search"]'
Party_PartyOnboarding_ComrLending_Display = '//td[contains(text(),"Commercial Lending")]'
Party_PartyOnboarding_LineOfBusiness_Table = '//div[contains(@id,"PartyLineOfBusinessDetail") and @role="grid"]'
Party_PartyOnboarding_LineOfBusiness_Rows = '//div[contains(@id,"PartyLineOfBusinessDetail") and @role="grid"]//table[contains(@class, "GridRowTable")]//td[@role="gridcell" and @idx="1"]'
Party_PartyOnboarding_LOBName_TableRow = '//td[@role="gridcell" and @idx="1"]'
Party_PartyOnboarding_LOB_CheckBox = '//td[@role="gridcell" and @idx="0"]//div[@role="checkbox"]'

### Party Onboarding Page - Branch List Dialog ###
Party_PartyOnboarding_BranchList_DialogTitle = '//span[text()="Branch List"]'
Party_PartyOnboarding_BranchList_Search_Button = '//form[@name="PT_PFN_SearchBranch_SCF"]//input[@name="Search"]'
Party_PartyOnboarding_BranchList_Next_Button = '//div[@role="dialog"]//input[@name="Next"]'
Party_PartyOnboarding_BranchList_RadioButton_Col = '//td[following-sibling::td[contains(.,"${iBranch_Code}")]]'

### Pre Existence Check Page ###
Party_PreExistenceCheck_EnterpriseName_TextBox = '//td[preceding-sibling::td[contains(.,"Enterprise name")]]'
Party_PreExistenceCheck_Locality_Dropdown = '//input[contains(@id,"locality") and not(contains(@id, "OffScreen"))]'
Party_PreExistenceCheck_Entity_Dropdown = '//input[contains(@id,"Location")]'
Party_PreExistenceCheck_Park_Button = '//input[contains (@id, "Park")]'
Party_PreExistenceCheck_SearchResultTableHeader = '//div[contains(@class, "GridMasterHeader")]//table[contains(@class, "GridRowTable")]//th'
Party_PreExistenceCheck_SearchResultTableRow ='//div[contains(@class, "GridMasterView")]//table[contains(@class, "GridRowTable")]//tr'
Party_PreExistenceCheck_View_Button = '//input[contains(@id, "View")]'

### Quick Enterprise Party Page ###
Party_QuickEnterpriseParty_PartyId_TextBox = '//input[contains(@id,"partyId") and not(contains(@id, "OffScreen"))]'
Party_QuickEnterpriseParty_AlternativePartyId_TextBox = '//input[contains(@id, "partyAlternativeId")]'
Party_QuickEnterpriseParty_RegisteredNumber_TextBox = '//input[contains(@id,"regNumber") and not(contains(@id, "OffScreen"))]'
Party_QuickEnterpriseParty_CountryOfTaxDomicile_Dropdown = '//input[contains(@id, "taxCountry")]'
Party_QuickEnterpriseParty_EnterpriseName_Dropdown = '//input[contains(@id, "EntFullName")]'
Party_QuickEnterpriseParty_CountryOfRegistration_Dropdown = '//input[contains(@id,"regCountry")]'
Party_QuickEnterpriseParty_StateOfRegistration_Dropdown = '//input[contains(@name,"entPtyBasicDtls:regState")]'
Party_QuickEnterpriseParty_NonResidentLicensePermit_Textbox = '//input[contains(@id, "NonResidentLicenseOrPermitNo")]'
Party_QuickEnterpriseParty_DateFormed_Textbox = '//input[contains(@id, "formationDt")]'
Party_QuickEnterpriseParty_BusinessActivity_CheckBox = '//input[contains(@id,"mainBusinessActivity")]'
Party_QuickEnterpriseParty_EnterpiseStatus_Dropdown = '//input[contains(@id,"busStatus")]'
Party_QuickEnterpriseParty_ShortName_TextBox = '//input[contains(@id,"shortName") and not(contains(@id, "OffScreen"))]' 
Party_QuickEnterpriseParty_WithholdingTaxLiable_CheckBox = '//input[contains(@id,"taxWhtLiable")]' 
Party_QuickEnterpriseParty_TaxExemptionReason_CheckBox = '//input[contains(@id,"taxExemptId:idReference")]' 
Party_QuickEnterpriseParty_GoodsAndServiceTaxLiable_CheckBox = '//input[contains(@id,"taxGstLiable")]'
Party_QuickEnterpriseParty_GoodsAndServiceTaxNumber_TextBox = '//input[contains(@id,"gstRegistration:idReference")]'
Party_QuickEnterpriseParty_AddressType_Dropdown = '//input[contains (@id, "PartyAddrSpecDtl:addressType")]'
Party_QuickEnterpriseParty_CountryRegion_Dropdown = '//input[contains (@id, "PartyAddrDtl:country")]'
Party_QuickEnterpriseParty_PostCode_TextBox = '//input[contains (@id, "PartyAddrDtl:postCode")]'
Party_QuickEnterpriseParty_RecordAddress_Button = '//input[contains (@id, "RecordAddress")]'
Party_QuickEnterpriseParty_CopyAddress_Button = '//input[contains (@id, "CopyAddress")]'
Party_QuickEnterpriseParty_AddressLookUp_Button = '//input[contains (@name, "Address Lookup")]'
Party_QuickEnterpriseParty_DocumentCollectionStatus_Dropdown = '//input[contains(@id, "DocumentStatus")]'
Party_QuickEnterpriseParty_Email_ContactType_Dropdown = '//input[contains(@id, "ContactLocation")]'
Party_QuickEnterpriseParty_Email_Email_TextBox = '//input[contains(@id, "ContactNumber")]'  
Party_QuickEnterpriseParty_Email_ConfirmEmail_TextBox = '//input[contains(@id, "ConfirmEmail")]'
Party_QuickEnterpriseParty_Mobile_ContactType_Dropdown = '//input[contains(@id, "contactTypeForMobile")]'
Party_QuickEnterpriseParty_Mpbile_MobileNumber_CountryCode_TextBox = '//input[contains(@id, "countryCode")]'
Party_QuickEnterpriseParty_Mpbile_MobileNumber_Number_TextBox = '//input[contains(@id, "mobileNumber")]'
Party_QuickEnterpriseParty_NewRow_Button = '//button[contains(@id,"addRow") and contains(@id,"partyRelationDtls")]'
Party_QuickEnterpriseParty_RemoveRow_Button = '//button[contains(@id,"removeRow") and contains(@id,"partyRelationDtls")]'
Party_QuickEnterpriseParty_SaveRow_Button = '//button[contains(@id,"saveRow") and contains(@id,"partyRelationDtls")]'
Party_QuickEnterpriseParty_FromDate_TextBox =  '//input[contains(@id, "dateFrom")]'
Party_QuickEnterpriseParty_RelatedParty_TextBox =  '//input[contains(@id, "relatedParty")]'
Party_QuickEnterpriseParty_RelatedPartyName_TextBox =  '//input[contains(@id, "relatedPartyName")]'
Party_QuickEnterpriseParty_RelationshipType_Dropdown =  '//input[contains(@id, "relationship")]'
Party_QuickEnterpriseParty_Percentage_TextBox = '//input[contains(@id, "percentage")]'
Party_QuickEnterpriseParty_IntegratedCustomerStatemnt_Checkbox = '//input[contains(@id, "IsIntegratedCustomerStatement")]'
Party_QuickEnterpriseParty_BiometricsWarning_Dialog = '//div[@role="dialog" and contains(@id,"EVENT_WARNING")]//child::span[contains(text(),"Warnings")]'
Party_QuickEnterpriseParty_ProceedWarning_Button = '//input[contains(@id,"Proceed")]'
Party_QuickEnterpriseParty_ApprovalRequired_Dialog = '//div[@role="dialog" and contains(@id,"EVENT_WARNING")]//child::span[contains(text(),"Approval Required")]'
Party_QuickEnterpriseParty_AskForApproval_Button = '//input[contains (@id,"AskForApproval")]'
Party_QuickEnterpriseParty_ErrorClose_Button = '//span[@title="Cancel" and @role="button"]'
Party_QuickEnterpriseParty_ErrorUnderlay_Box = '//div[contains(@id,"underlay")]'
Party_QuickEnterpriseParty_Capture_Button = '//input[contains(@name,"Capture")]'
Party_QuickEnterpriseParty_PartyName_TextBox = '//input[contains(@id,"name") and not(contains(@id, "OffScreen"))]' 
Party_QuickEnterpriseParty_Entity_Dropdown = '//input[contains(@id,"location")]'
Party_QuickEnterpriseParty_PartySubType_Dropdown = '//input[contains(@id,"PartySubeType")]'
Party_QuickEnterpriseParty_PartyCategory_Dropdown = '//input[contains(@id,"PartyCategory")]'
Party_QuickEnterpriseParty_PartyType_Dropdown = '//input[contains(@id,"PartyType")]'
Party_EnterpriseDetailsSummary_TaxCountry_Cell = '//div[contains(@id,"partyTaxSchemes") and @role="grid"]//div[@class="dojoxGridMasterView"]//table[1]//td[1]'
Party_EnterpriseDetailsSummary_TaxNumber_Cell = '//div[contains(@id,"partyTaxSchemes") and @role="grid"]//div[@class="dojoxGridMasterView"]//table[1]//td[1]'

### Quick Enterprise Party Page - Address Details Dialog ###
Party_QuickEnterpriseParty_AddressDetails_AddressLineOne_TextBox = '//form[@name="PT_PAM_QuickRecordAddress_SCF"]//input[contains (@name, "03PartyAddrDtl:addressLine1") and @type="text"]'
Party_QuickEnterpriseParty_AddressDetails_AddressLineTwo_TextBox = '//form[@name="PT_PAM_QuickRecordAddress_SCF"]//input[contains (@name, "03PartyAddrDtl:addressLine2") and @type="text"]'
Party_QuickEnterpriseParty_AddressDetails_AddressLineThree_TextBox = '//form[@name="PT_PAM_QuickRecordAddress_SCF"]//input[contains (@name, "03PartyAddrDtl:addressLine3") and @type="text"]'
Party_QuickEnterpriseParty_AddressDetails_AddressLineFour_TextBox = '//form[@name="PT_PAM_QuickRecordAddress_SCF"]//input[contains (@name, "03PartyAddrDtl:addressLine4") and @type="text"]'
Party_QuickEnterpriseParty_AddressDetails_TownCity_TextBox = '//form[@name="PT_PAM_QuickRecordAddress_SCF"]//input[contains (@name, "PartyAddrDtl:townOrCity") and @type="text"]'
Party_QuickEnterpriseParty_AddressDetails_StateProvince_Dropdown = '//form[@name="PT_PAM_QuickRecordAddress_SCF"]//input[contains (@id, "PartyAddrDtl:addressLine1") and @type="combo"]'
Party_QuickEnterpriseParty_AddressDetails_Next_Button = '//div[@role="dialog"]//input[@uitype="Button" and contains(@id,"Next")]'

### Quick Enterprise Party Page - Enterprise Business Activity Dialog ###
Party_QuickEnterpriseParty_EnterpriseBusinessActivity_NewRow_Button = '//button[contains(@id,"addRow") and contains(@id,"businessActivityDtls")]'
Party_QuickEnterpriseParty_EnterpriseBusinessActivity_SaveRow_Button = '//button[contains(@id, "saveRow_HiddenVector_maintainEntPtyBusActRq")]'
Party_QuickEnterpriseParty_EnterpriseBusinessActivity_Country_Dropdown = '//input[contains(@id, "businessActivityDtls:country")]'
Party_QuickEnterpriseParty_EnterpriseBusinessActivity_IndustrySector_Dropdown = '//input[contains(@id, "businessActivityDtls:indust")]'
Party_QuickEnterpriseParty_EnterpriseBusinessActivity_BusinessActivity_Dropdown = '//input[contains(@id, "Dtls:businessActivity")]'
Party_QuickEnterpriseParty_EnterpriseBusinessActivity_BusinessFocus_Dropdown = '//input[contains(@id, "impExpInd")]'
Party_QuickEnterpriseParty_EnterpriseBusinessActivity_BusinessType_Dropdown = '//input[contains(@id, "franchiseType")]'
Party_QuickEnterpriseParty_EnterpriseBusinessActivity_IsMainActivity_CheckBox = '//input[contains(@id, "isMainActivity")]'
Party_QuickEnterpriseParty_EnterpriseBusinessActivity_IsPrimaryActivity_CheckBox = '//input[contains(@id, "isPrimaryActivity")]'
Party_QuickEnterpriseParty_EnterpriseBusinessActivity_Next_Button = '//div[@role="dialog"]//input[contains(@id, "Next")]'
Party_QuickEnterpriseParty_EnterpriseBusinessActivity_EnquireEntBusinessAct_Next_Button = '//div[contains(@id,"EnquireEntBusActivity")]//input[@name="Next"]'

### Notification Types Page ###

Party_NotificationTypes_TaskType_TextBox = '//input[contains(@id,"taskType")]'

###Referrals Page###
Party_Referrals_ReferralRow_Table = '//div[contains(@id,"REFERRALS")]//div[@role="row" and contains(@class,"Row")]'
Party_Referrals_TaskID_TableCell = '//td[@idx="4" and @role="gridcell"]'
Party_TableRadioButton_RadioButton = '//td[@idx="0" and @role="gridcell"]'
Party_EnterpriseDetailsSummary_TaxCountry_Cell = '//div[contains(@id,"partyTaxSchemes") and @role="grid"]//div[@class="dojoxGridMasterView"]//table[1]//td[1]'
Party_EnterpriseDetailsSummary_TaxNumber_Cell = '//div[contains(@id,"partyTaxSchemes") and @role="grid"]//div[@class="dojoxGridMasterView"]//table[1]//td[2]'
Party_Referrals_Details_Row = '(//div[contains(@id,"Details")]//div[contains(@class,"GridView")]//child::table)'
Party_Referrals_Comment_Textbox = '//input[contains(@name, "03COMMENT")]'
Party_Referrals_Refer_Button = '//input[contains(@id, "Reject")]'
Party_Referrals_Replay_Button = '//input[contains(@id, "Replay")]'
Party_Referrals_ViewDetails_Button = '//input[contains(@name, "View Details")]'
Party_Referrals_OtherTypes_Button = '//input[contains(@id, "Next")]'
