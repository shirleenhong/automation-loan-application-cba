
### Process Notification Page - (Approve Registered Party) Supervisor ###
Party_ProcessNotification_NotificationTypes_Referral_RadioButton = '//div[contains(@class,"GridContent")]//td[following-sibling::td[contains(.,"Referral")]]'
Party_ProcessNotification_ProcessReferrals_Referral_RadioButton = '//div[contains(@id,"grid__View_3")]//td[following-sibling::td[contains(.,"Referral")]]'
Party_ProcessNotification_ProcessReferrals_TableRow = '//div[contains(@id,"grid__View_3")]//div[contains(@class,"Row")]//tbody//tr'
Party_ProcessNotification_ProcessReferrals_TableHeader = '//div[contains(@id,"REFERRALS")]//tbody//th'
Party_ProcessNotification_ProcessReferrals_TableRef = '//div[contains(@id,"grid__View_3")]//div[contains(@class,"Row")]'

### Process Notification Page - (Confirm Approved Party) Inputter ###
Party_ProcessNotification_NotificationTypes_Approval_RadioButton = '//div[contains(@class,"GridContent")]//td[following-sibling::td[contains(.,"Approval")]]'
Party_ProcessNotification_NotificationTypes_Rejection_RadioButton = '//div[contains(@class,"GridContent")]//td[following-sibling::td[contains(.,"Rejection")]]'
Party_ProcessNotification_CancelTask_Button = '//input[contains(@name, "Cancel Task")]'

### Data Protection Statement Page ###
Party_DataProtectionStatement_TickToDenoteCompliance_CheckBox = '//input[contains(@id,"Status")]'
Party_DataProtectionStatement_Textarea = '//form[contains(@name,"PT_POB_TestQuickOnBoarding")]//textarea[contains(@id,"Data")]'
Party_DataProtectionStatement_Next_Button = '//div[contains(@id, "PT_POB_TestQuickOnBoarding_2")]//input[contains(@id,"Next")]'
Party_DataProtectionStatement_Cancel_Button = '//input[contains(@name, "Cancel")]'

### Enterprise Related Party Status Page ###
Party_EnterpriseRelatedPartyStatus_Form = '//form[@name="PT_POB_TestQuickOnBoarding"]'
Party_EnterpriseRelatedPartyStatus_Accept_RadioButton = '//input[contains(@id,"radioAccept")]'
Party_EnterpriseRelatedPartyStatus_Decline_RadioButton = '//input[contains(@id,"radioDecline")]'
Party_EnterpriseRelatedPartyStatus_EnterprisePartyId_Label = '//input[contains(@id,"enterprisePartyID")]'

###Locator For Error Handler###
# FBE_resume_quick_onboarding_next_button = '//div[contains(@aria-labelledby, "ResumeQuickOnBoarding")]//input[@name="Next"]'

### Enquire Enterprise Party Page ###
Party_EnquireEnterpriseParty_Next_Button = '//div[contains(@class,"Visible")]//input[@name="Next"]'
Party_EnquireEnterpriseParty_PartyId_Text = '//input[@name="03PartyID"]'
Party_EnquireEnterpriseParty_EnterpriseName_Text = '//input[contains(@id, "name") and not(contains(@id, "Rs2")) and not(contains(@id, "OffScreen"))]'
Party_EnquireEnterpriseParty_CountryOfTaxDomicile_Text = '//td//input[contains(@id, "taxCountry")]'
Party_EnquireEnterpriseParty_CountryOfRegistration_Text = '//input[contains(@id, "regCountry")]'

### Enterprise Party Summary Details Page ###
FBE_Locality_Text = '//input[@name="03locality"]'
FBE_PartyType_Text = '//input[@name="03PartyType"]'
FBE_PartySubType_Text = '//input[@name="03PartySubeType"]'
FBE_PartyCategory_Text = '//input[@name="03PartyCategory"]'
FBE_PartyId_Text = '//input[contains(@id, "partyId") and not(contains(@id, "OffScreen"))]'
FBE_EnterpriseName_Text = '//input[contains(@id, "name") and not(contains(@id, "OffScreen"))]'
FBE_RegisteredNumber_Text = '//input[contains(@id, "regNumber") and not(contains(@id, "OffScreen"))]'
FBE_AcceptanceStatus_Text = '//input[@name="03AcceptanceStatus"]'
Party_EnterPrisePartySummaryDetails_NonResidentLicensePermit_View_Button = '//input[contains(@name, "View")and contains(@onclick,"PT_PFN_EnquireNonResLicense_SCF")]'
Party_EnterPrisePartySummaryDetails_ViewNonResidentLicensePermit_NonResidentLicensePermitNo_TextBox = '//input[contains(@name, "entpBasicDtls:NonResidentLicenseOrPermitNo")]'
Party_EnterPrisePartySummaryDetails_ViewNonResidentLicensePermit_IssuanceDate_TextBox = '//input[contains(@id, "entpBasicDtls:LicenseOrPermitNoIssuanceDt")]'
Party_EnterPrisePartySummaryDetails_ViewNonResidentLicensePermit_ExpiryDate_TextBox = '//input[contains(@id, "entpBasicDtls:LicenseOrPermitNoExpiryDt")]'
Party_EnterPrisePartySummaryDetails_NumberOfTradingNames_View_Button = '//input[contains(@name, "View")and contains(@onclick,"PT_PAM_EnquireTradingDetails_PRC")]'
Party_EnterPrisePartySummaryDetails_ViewNumberOfTradingNames_RegistrationNumber_Text = '//input[contains(@name, "regReference")]'
Party_EnterPrisePartySummaryDetails_ViewNumberOfTradingNames_RegisteredTradingName_Text = '//input[contains(@name, "tradingName")]'
Party_EnterPrisePartySummaryDetails_ViewNumberOfTradingNames_RegistrationAuthority_Text = '//input[contains(@name, "regAuthority")]'
Party_EnterPrisePartySummaryDetails_ViewNumberOfTradingNames_PlaceOfRegistration_Text = '//input[contains(@name, "03RegCountry")]'
Party_EnterPrisePartySummaryDetails_ViewNumberOfTradingNames_NameType_DropDown = '//input[contains(@id, "entNameType")]'
Party_EnterPrisePartySummaryDetails_ViewNumberOfTradingNames_RegistrationDate_Text = '//input[contains(@name, "regDate")]'
Party_EnterPrisePartySummaryDetails_ViewNumberOfTradingNames_DateRecorded_Text = '//input[contains(@name, "dateRecorded")]'
Party_EnterPrisePartySummaryDetails_ViewNumberOfTradingNames_RegistrationVerified_DropDown = '//input[contains(@id, "isDocVerified")]'
Party_EnterPrisePartySummaryDetails_Print_Button = '//input[contains(@id, "Print")]'
Party_EnterPrisePartySummaryDetails_NonResidentLicensePermit_View_Button = '//input[contains(@name, "View")and contains(@onclick,"PT_PFN_EnquireNonResLicense_SCF")]'
Party_EnterPrisePartySummaryDetails_BusinessActivity_View_Button = '//input[contains(@name, "View")and contains(@onclick,"PT_PAM_EnquireEntBusActivity_PRC")]'