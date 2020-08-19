###Customer Select Window###
LIQ_CustomerSelect_Window = 'JavaWindow("title:=Customer Select.*")'
LIQ_CustomerSelect_NewCustomer = 'JavaWindow("title:=Customer Select").JavaRadioButton("label:=New")'
LIQ_CustomerSelect_NewCustomer_CustomerID = 'JavaWindow("title:=Customer Select").JavaEdit("tagname:=Text","Index:=1")'
LIQ_CustomerSelect_NewCustomer_ShortName = 'JavaWindow("title:=Customer Select").JavaEdit("tagname:=Text","x:=301","y:=87")'
LIQ_CustomerSelect_NewCustomer_LegalName = 'JavaWindow("title:=Customer Select").JavaEdit("tagname:=Text","index:=0")'
LIQ_CustomerSelect_Search_Filter = 'JavaWindow("title:=Customer Select.*").JavaList("attached text:=Identify By:","Index:=0")'
LIQ_CustomerSelect_Search_Inputfield = 'JavaWindow("title:=Customer Select.*").JavaEdit("tagname:=Text")'
LIQ_CustomerSelect_Search_Button = 'JavaWindow("title:=Customer Select.*").JavaButton("attached text:=Search")'
LIQ_CustomerSelect_OK_Button = 'JavaWindow("title:=Customer Select.*").JavaButton("attached text:=OK")'

###Customer List By Short Name Window###
LIQ_CustomerListByShortName_OK_Button = 'JavaWindow("title:=Customer Select.*").JavaWindow(":=Customer List By Short.*").JavaButton("attached text:=OK")'
###Customer List By Customer_ID Window###
LIQ_CustomerListByCustomerID_OK_ButtonJavaWindow = 'JavaWindow("title:=Customer Select.*").JavaWindow("title:=Customer List By Customer.*").JavaButton("label:=OK")'

###Active Customer Window###
LIQ_Active_Customer_Notebook_InquiryMode = 'JavaWindow("title:=Active Customer.*").JavaButton("text:=Notebook in Inquiry Mode - F7")'
LIQ_ActiveCustomer_Window = 'JavaWindow("title:=Active Customer.*")'
LIQ_ActiveCustomer_ShortName_Window = 'JavaWindow("title:=Active Customer.*","tagname:=Active Customer -- ${LIQCustomer_ShortName}")'

LIQ_ActiveCustomer_Window_FileMenu_SaveMenu = 'JavaWindow("title:=Active Customer.*").JavaMenu("index:=0").JavaMenu("label:=Save")'

###Active Customer Window_GST ID##
LIQ_ActiveCustomer_Window_GST_CheckBox = 'JavaWindow("title:=Active Customer.*").JavaCheckBox("attached text:=Subject to GST")'
LIQ_ActiveCustomer_Window_GSTID_InputField = 'JavaWindow("title:=Active Customer.*").JavaEdit("attached text:=GST ID:")'

###Active Customer Window_General Tab Validation###
LIQ_ActiveCustomer_Window_CustomerID = 'JavaWindow("title:=Active Customer.*").JavaEdit("attached text:=Customer ID:")'
LIQ_ActiveCustomer_Window_ShortName = 'JavaWindow("title:=Active Customer.*").JavaEdit("attached text:=Short Name:")'
LIQ_ActiveCustomer_Window_LegalName = 'JavaWindow("title:=Active Customer.*").JavaEdit("attached text:=Legal Name:")'
LIQ_ActiveCustomer_Window_Status = 'JavaWindow("title:=Active Customer.*").JavaList("attached text:=Status:")'
LIQ_ActiveCustomer_Window_Branch = 'JavaWindow("title:=Active Customer.*").JavaList("attached text:=Branch:")'
LIQ_ActiveCustomer_Window_Language = 'JavaWindow("title:=Active Customer.*").JavaList("attached text:=Language:")'

###Active Customer Window_GeneralTab###
LIQ_Active_Customer_Notebook_GeneralTab_CustomerID = 'JavaWindow("title:=Active Customer.*").JavaEdit("attached text:=Customer ID:")'
LIQ_Active_Customer_Notebook_GeneralTab_ShortName = 'JavaWindow("title:=Active Customer.*").JaveEdit("title:=Short Name.*").JavaEdit("tagname:=ShortName.*")'

###Active Customer Window_TabSelection###
LIQ_Active_Customer_Notebook_TabSelection = 'JavaWindow("title:=Active Customer -.*").JavaTab("tagname:=Language:")'

###Active Customer Window_OptionsMenu###
LIQ_Active_Customer_Notebook_OptionsMenu_LegalAddress = 'JavaWindow("title:=Active Customer -.*").JavaMenu("label:=Options").JavaMenu("label:=Legal Address")'

###Active Customer Window_OptionsMen Update Address###
LIQ_UpdateAddress_Ok_CancelButton = 'JavaWindow("title:=Update Address.*").JavaButton("label:=Cancel.*")'

###Active Customer Window_OptionsMen View Address###
LIQ_ViewAddress_AddressCode = 'JavaWindow("title:=View Address").JavaEdit("tagname:=Text","x:=215","y:=95")'
LIQ_ViewAddress_Line1 = 'JavaWindow("title:=View Address").JavaEdit("tagname:=Text","x:=215","y:=125")'
LIQ_ViewAddress_Line2 = 'JavaWindow("title:=View Address").JavaEdit("tagname:=Text","x:=215","y:=155")'
LIQ_ViewAddress_Line3 = 'JavaWindow("title:=View Address").JavaEdit("tagname:=Text","x:=215","y:=185")'
LIQ_ViewAddress_Line4 = 'JavaWindow("title:=View Address").JavaEdit("tagname:=Text","x:=215","y:=215")'
LIQ_ViewAddress_Line5 = 'JavaWindow("title:=View Address").JavaEdit("tagname:=Text","x:=566","y:=125")'
LIQ_ViewAddress_City = 'JavaWindow("title:=View Address").JavaEdit("tagname:=Text","x:=215","y:=245")'
LIQ_ViewAddress_Country = 'JavaWindow("title:=View Address").JavaList("tagname:=Combo","x:=215","y:=275")'
LIQ_ViewAddress_TreasuryReportingArea = 'JavaWindow("title:=View Address").JavaList("tagname:=Combo","x:=215","y:=305")'
LIQ_ViewAddress_Province = 'JavaWindow("title:=View Address").JavaList("attached text:=Province:")'
LIQ_ViewAddress_ZipCostalCode = 'JavaWindow("title:=View Address").JavaEdit("attached text:=Zip/Postal Code:")'
LIQ_ViewAddress_Ok_CancelButton = 'JavaWindow("title:=View Address.*").JavaButton("label:=Cancel.*")'

###Active Customer Window_ExpenseCode_section###
LIQ_Active_Customer_Notebook_GeneralTab_ExpenseCode_Button = 'JavaWindow("title:=Active Customer -.*").JavaButton("attached text:=Expense Code")'      
LIQ_Active_Customer_Notebook_GeneralTab_DepartmentCode_Button = 'JavaWindow("title:=Active Customer -.*").JavaButton("attached text:=Department")'
LIQ_SelectExpense_Codes_AllExpenseCode_Button = 'JavaWindow("title:=Select Expense Codes.*").JavaButton("attached text:=All Expense Codes")'
LIQ_SelectExpense_Codes_DepartmentCode_SearchInput = 'JavaWindow("title:=Select Department Code.*").JavaEdit("tagname:=Text")'
LIQ_SelectExpense_Codes_ExpenseCode_SearchInput = 'JavaWindow("title:=Select Expense Code.*").JavaEdit("tagname:=Text")'      
LIQ_SelectExpense_Codes_OKButton = 'JavaWindow("title:=Select Expense Code").JavaButton("attached text:=OK")'
LIQ_SelectDepartment_Codes_OKButton = 'JavaWindow("title:=Select Department Code").JavaButton("attached text:=OK")'

###Active Customer Window_ExpenseCode_Validation###
LIQ_Active_Customer_Notebook_GeneralTab_ExpenseCode_Field = 'JavaWindow("title:=Active Customer -.*").JavaEdit("tagname:=Text","x:=150","y:=380")'
LIQ_Active_Customer_Notebook_GeneralTab_ExpenseCodeDescription_Field = 'JavaWindow("title:=Active Customer -.*").JavaEdit("tagname:=Text","x:=297","y:=380")'

###Active Customer Window_DepartmentCode_Validation###
LIQ_Active_Customer_Notebook_GeneralTab_DepartmentCode_Field = 'JavaWindow("title:=Active Customer -.*").JavaEdit("tagname:=Text","x:=150","y:=410")'
LIQ_Active_Customer_Notebook_GeneralTab_DepartmentCodeDescription_Field = 'JavaWindow("title:=Active Customer -.*").JavaEdit("tagname:=Text","x:=255","y:=410")'

###Active Customer Window_ClassificationCode_section###
LIQ_Active_Customer_Notebook_GeneralTab_ClassificationCode_Button = 'JavaWindow("title:=Active.*Customer.*").JavaButton("label:=Classification.*")'
LIQ_SelectClassification_Codes_ClassificationCode_SearchbyCode = 'JavaWindow("title:=Select Customer Classification").JavaEdit("tagname:=Text","Index:=0")'
LIQ_SelectClassification_Codes_OKButton = 'JavaWindow("title:=Select Customer Classification").JavaButton("attached text:=OK")'

###Active Customer Window_ClassificationCode_Validation###
LIQ_Active_Customer_Notebook_GeneralTab_ClassificationCodeDescription_Field = 'JavaWindow("title:=Active Customer -.*").JavaEdit("tagname:=Text","x:=150","y:=473")'

###Active Customer Window_NoticeType_Preference###
LIQ_Active_Customer_Notebook_GeneralTab_NoticeTypePreference_DropdownField = 'JavaWindow("title:=Active Customer -.*").JavaList("attached text:=Notice Type Preference:")'

###Active Customer Window_RiskTab_InternalRiskRating###
LIQ_Active_Customer_Notebook_RiskTab_AddInternal_Button = 'JavaWindow("title:=Active Customer -.*").JavaButton("attached text:=Add Internal.*")'
LIQ_Active_Customer_Notebook_RiskTab_InternalRiskRating_JavaTree = 'JavaWindow("title:=Active Customer -.*").JavaTree("attached text:=Drill down to update","index:=1")'
LIQ_Active_Customer_Notebook_RiskTab_InternalRiskRating_Window = 'JavaWindow("title:=Internal Risk Rating.*")'
LIQ_Active_Customer_Notebook_RiskTab_InternalRiskRating_RatingTypeField = 'JavaWindow("title:=Internal Risk Rating.*").JavaList("attached text:=Rating Type:")'
LIQ_Active_Customer_Notebook_RiskTab_InternalRiskRating_RatingField = 'JavaWindow("title:=Internal Risk Rating.*").JavaList("attached text:=Rating:.*")'
LIQ_Active_Customer_Notebook_RiskTab_InternalRiskRating_PercentField = 'JavaWindow("title:=Internal Risk Rating.*").JavaEdit("attached text:=Percent.*")'
LIQ_Active_Customer_Notebook_RiskTab_InternalRiskRating_EffectiveDateField = 'JavaWindow("title:=Internal Risk Rating.*").JavaEdit("attached text:=Effective Date.*")'
LIQ_Active_Customer_Notebook_RiskTab_InternalRiskRating_ExpiryDateField = 'JavaWindow("title:=Internal Risk Rating.*").JavaEdit("attached text:=Expiry Date.*")'
LIQ_Active_Customer_Notebook_RiskTab_InternalRiskRating_OkButton = 'JavaWindow("title:=Internal Risk Rating.*").JavaButton("attached text:=OK.*")'

###Active Customer Window_RiskTab_ExternalRiskRating###
LIQ_Active_Customer_Notebook_RiskTab_AddExternal_Button = 'JavaWindow("title:=Active Customer -.*").JavaButton("attached text:=Add External.*")'
LIQ_Active_Customer_Notebook_RiskTab_ExternalRiskRating_JavaTree = 'JavaWindow("title:=Active Customer -.*").JavaTree("attached text:=Drill down to update","index:=0")'
LIQ_Active_Customer_Notebook_RiskTab_ExternalRiskRating_Window = 'JavaWindow("title:=Add External Risk Rating.*")'
LIQ_Active_Customer_Notebook_RiskTab_ExtenalRiskRating_RatingTypeField = 'JavaWindow("title:=Add External Risk Rating.*").JavaList("attached text:=Rating Type:")'
LIQ_Active_Customer_Notebook_RiskTab_ExtenalRiskRating_RatingField = 'JavaWindow("title:=Add External Risk Rating.*").JavaList("attached text:=Rating:.*")'
LIQ_Active_Customer_Notebook_RiskTab_ExtenalRiskRating_StartDateField = 'JavaWindow("title:=Add External Risk Rating.*").JavaEdit("tagname:=Text.*")'
LIQ_Active_Customer_Notebook_RiskTab_ExtenalRiskRating_OKButton = 'JavaWindow("title:=Add External Risk Rating.*").JavaButton("attached text:=OK.*")'

###Active Customer Window_SIC Tab###
LIQ_Active_Customer_Notebook_SICTab_PrimarySICButton = 'JavaWindow("title:=Active.*Customer.*").JavaButton("attached text:=Primary SIC.*")'
LIQ_Active_Customer_Notebook_SICTab_SICSelect_CodeInputField = 'JavaWindow("title:=SIC Select.*").JavaEdit("attached text:=Code.*")'
LIQ_Active_Customer_Notebook_SICTab_SICSelect_OKButton = 'JavaWindow("title:=SIC Select.*").JavaButton("label:=OK.*")'
LIQ_ActiveCustomer_Window = 'JavaWindow("title:=Active.*Customer.*")'
LIQ_Active_Customer_Notebook_SICTab_PrimarySICText = 'JavaWindow("title:=Active Customer.*").JavaEdit("tagname:=Text","x:=268","y:=17")'
LIQ_Active_Customer_Notebook_SICTab_SIC_TextField = 'JavaWindow("title:=Active.*Customer.*").JavaEdit("value:=${PartyUser_SICCode}")'
LIQ_Active_Customer_Notebook_SICTab_PrimarySICCode = 'JavaWindow("title:=Active.*Customer.*").JavaEdit("value:=${Primary_SICCode}")'
LIQ_Active_Customer_Notebook_SICTab_PrimarySICCodeDescription = 'JavaWindow("title:=Active.*Customer.*").JavaEdit("value:=${PrimarySICCode_Description}")'

###Active Customer Window_Profiles Tab###
Please_Confirm_AddingProfile_Window_YesButton = 'JavaWindow("title:=Please confirm","displayed:=1").JavaButton("label:=Yes")'
AddProfile_Button =  'JavaWindow("title:=Active.*Customer.*").JavaButton("label:=Add Profile")'
LIQ_Select_Profile_ProfileType_List = 'JavaWindow("title:=Select Profile.*").JavaTree("attached text:=Drill down to select.*","index:=0")'
LIQ_Select_Profile_ProfileType_OkButton = 'JavaWindow("title:=Select Profile.*").JavaButton("label:=OK.*")'
LIQ_Active_Customer_Profiles_Borrower = 'JavaWindow("title:=Active Customer -.*").JavaTree("attached text:=Drill down for details.*","index:=0")'
LIQ_Active_Customer_Profiles_Status = 'JavaWindow("title:=Active Customer -.*").JavaTree("attached text:=Drill down for details.*","index:=0")'
AddLocation_Button = 'JavaWindow("title:=Active.*Customer.*").JavaButton("label:=Add Location.*")'
Delete_Button = 'JavaWindow("title:=Active.*Customer.*").JavaButton("label:=Delete.*")'
Addresses_Button = 'JavaWindow("title:=Active.*Customer.*").JavaButton("label:=Addresses.*")'
Faxes_Button = 'JavaWindow("title:=Active.*Customer .*").JavaButton("label:=Faxes.*")'
Contacts_Button = 'JavaWindow("title:=Active.*Customer .*").JavaButton("label:=Contacts.*")'
CompleteLocation_Button = 'JavaWindow("title:=Active.*Customer .*").JavaButton("label:=Complete Location.*")'
Profile_Grid = 'JavaWindow("title:=Active Customer.*").JavaTree("attached text:=Drill down for details")'
ServicingGroups_Button = 'JavaWindow("title:=Active.*Customer .*").JavaButton("label:=Servicing Groups.*")'
Personnel_Button = 'JavaWindow("title:=Active.*Customer .*").JavaButton("label:=Personnel.*")'
RemittanceInstructions_Button = 'JavaWindow("title:=Active.*Customer .*").JavaButton("label:=Remittance Instructions.*")'
LIQ_Active_Customer_Notebook_ProfileTab_LocationDetails_Window = 'JavaWindow("title:=${Profile_Type}.*")'
LIQ_Active_Customer_Notebook_ProfileTab_ProfileDetails_Window = 'JavaWindow("title:=${Profile_Type} Profile Details.*","tagname:=${Profile_Type} Profile Details.*")'
LIQ_Active_Customer_Notebook_ProfileTab_ProfileDescription_Grid = 'JavaWindow("title:=Active Customer.*").JavaTree("attached text:=Drill down for details","developer name:=.*profileDescription=${Profile_Type}.*")'
LIQ_Active_Customer_Notebook_ProfileTab_NotInUseStatus_Grid = 'JavaWindow("title:=Active Customer.*").JavaTree("attached text:=Drill down for details","developer name:=.*status=Not In Use.*")'
LIQ_Active_Customer_Notebook_ProfileTab_LocationDescription_Grid = 'JavaWindow("title:=Active Customer.*").JavaTree("attached text:=Drill down for details","developer name:=.*locationDescription=${Customer_Location}.*")'
LIQ_Active_Customer_Notebook_ProfileTab_ProfileLocation_Window = 'JavaWindow("title:=${Profile_Type}.*","tagname:=${Profile_Type}.*")'
LIQ_Active_Customer_Notebook_ProfileTab_AddressListforLocation_Window = 'JavaWindow("title:=Address List for ${Customer_Location}","tagname:=Address List for ${Customer_Location}")'
LIQ_Active_Customer_Notebook_ProfileTab_FaxListforLocation_Window = 'JavaWindow("title:=Fax List for ${Customer_Location}","tagname:=Fax List for ${Customer_Location}")'
LIQ_Active_Customer_Notebook_ProfileTab_ContactListforLocation_Window = 'JavaWindow("title:=Contact List for ${Customer_Location}","tagname:=Contact List for ${Customer_Location}")'
LIQ_Active_Customer_Notebook_ProfileTab_CompleteLocationStatus_Grid = 'JavaWindow("title:=Active Customer -.*").JavaTree("attached text:=Drill down for details.*","developer name:=.*status=.*locationDescription=${Customer_Location}.*Complete.*")'

###Active Customer_BorrowerProfileDetails_Window###
LIQ_BorrowerProfileDetails_Window  = 'JavaWindow("title:=Borrower Profile Details.*")'
LIQ_BorrowerProfileDetails_TaxPayerID_InputField = 'JavaWindow("title:=Borrower.*").JavaEdit("attached text:=Taxpayer ID:")'
LIQ_BorrowerProfileDetails_TaxPayerID_CreditReview_DateField = 'JavaWindow("title:=Borrower.*").JavaEdit("attached text:=.*Credit Review Date:")'
LIQ_BorrowerProfileDetails__OkButton = 'JavaWindow("title:=Borrower.*").JavaButton("label:=OK.*")' 

###Active Customer_BeneficiaryProfileDetails_Window###
LIQ_BeneficiaryProfileDetails_Window = 'JavaWindow("title:=Beneficiary Profile Details.*")'
LIQ_BeneficiaryProfileDetails_TaxPayerID_InputField = 'JavaWindow("title:=Beneficiary.*Details.*").JavaEdit("attached text:=Not In Use","x:=250","y:=140")'
LIQ_BeneficiaryProfileDetails__OkButton = 'JavaWindow("title:=Beneficiary.*Details.*").JavaButton("label:=OK")' 

###Active Customer_GuarantorProfileDetails_Window###
LIQ_GuarantorProfileDetails_Window = 'JavaWindow("title:=Guarantor Profile Details.*")'
LIQ_GuarantorProfileDetails_TaxPayerID_InputField = 'JavaWindow("title:=Guarantor.*Details.*").JavaEdit("attached text:=Not In Use","x:=250","y:=140")'
LIQ_GuarantorProfileDetails__OkButton = 'JavaWindow("title:=Guarantor.*Details.*").JavaButton("label:=OK")' 

###Active Customer_LenderProfileDetails_Window###
LIQ_LenderProfileDetails_Window = 'JavaWindow("title:=Lender Profile Details.*")'
LIQ_LenderProfileDetails_TaxPayerID_InputField = 'JavaWindow("title:=Lender.*Details.*").JavaEdit("attached text:=Not In Use","x:=250","y:=140")'
LIQ_LenderProfileDetails__OkButton = 'JavaWindow("title:=Lender.*Details.*").JavaButton("label:=OK")'

###Active Customer_ProfileTab_SelectLocation_Window###
LIQ_SelectLocation_SearchByDescription = 'JavaWindow("title:=Select Location.*").JavaEdit("tagname:=Text")'      
LIQ_SelectLocation_OKButton = 'JavaWindow("title:=Select Location.*").JavaButton("label:=OK.*")'

###Active Customer_ProfileTab_SelectLocation_Window###

###Active Customer_ProfileTab_SelectLocation_BorrowerDetails_Window###
LIQ_BorrowerDetails_ExternalID_Field = 'JavaWindow("title:=Borrower/.*").JavaEdit("tagname:=Text","x:=250","y:=50")' 
LIQ_BorrowerDetails_PreferredLanguage_Field = 'JavaWindow("title:=Borrower/.*").JavaList("tagname:=Combo")' 
LIQ_BorrowerDetails_MEI_Field = 'JavaWindow("title:=Borrower/.*").JavaEdit("attached text:=MEI:")' 
LIQ_BorrowerDetails_OKButton = 'JavaWindow("title:=Borrower/.*").JavaButton("attached text:=OK")'
LIQ_BorrowerDetails_Window = 'JavaWindow("title:=Borrower/.*")'

###Active Customer_ProfileTab_SelectLocation_BeneficiaryDetails_Window###
LIQ_BeneficiaryDetails_ExternalID_Field = 'JavaWindow("title:=Beneficiary/.*").JavaEdit("tagname:=Text","x:=250","y:=50")' 
LIQ_BeneficiaryDetails_PreferredLanguage_Field = 'JavaWindow("title:=Beneficiary/.*").JavaList("tagname:=Combo")' 
LIQ_BeneficiaryDetails_MEI_Field = 'JavaWindow("title:=Beneficiary/.*").JavaEdit("attached text:=MEI:")' 
LIQ_BeneficiaryDetails_OKButton = 'JavaWindow("title:=Beneficiary/.*").JavaButton("attached text:=OK")'

###Active Customer_ProfileTab_SelectLocation_GuarantorDetails_Window###
LIQ_GuarantorDetails_ExternalID_Field = 'JavaWindow("title:=Guarantor/.*").JavaEdit("tagname:=Text","x:=250","y:=50")' 
LIQ_GuarantorDetails_PreferredLanguage_Field = 'JavaWindow("title:=Guarantor/.*").JavaList("tagname:=Combo")' 
LIQ_GuarantorDetails_MEI_Field = 'JavaWindow("title:=Guarantor/.*").JavaEdit("attached text:=MEI:")' 
LIQ_GuarantorDetails_OKButton = 'JavaWindow("title:=Guarantor/.*").JavaButton("attached text:=OK")'

###Active Customer_ProfileTab_SelectLocation_LenderDetails_Window### 
LIQ_LenderDetails_OKButton = 'JavaWindow("title:=Lender/.*").JavaButton("attached text:=OK")'

###Active Customer_ProfileTab_Addresses_Window###
LIQ_Active_Customer_Notebook_AddressListWindow = 'JavaWindow("title:=Address List.*")' 
LIQ_Active_Customer_Notebook_AddressListWindow_LegalAddress = 'JavaWindow("title:=Address List.*").JavaTree("attached text:=Drill down to view/update.*")'
LIQ_Active_Customer_Notebook_AddressListWindow_AddButton = 'JavaWindow("title:=Address List.*").JavaButton("label:=Add.*")'
LIQ_Active_Customer_Notebook_UpdateAddressWindow_OKButton = 'JavaWindow("title:=Update Address.*").JavaButton("label:=OK.*")'
LIQ_Active_Customer_Notebook_UpdateAddressWindow_CancelButton = 'JavaWindow("title:=Update Address.*").JavaButton("label:=Cancel.*")'
LIQ_Active_Customer_Notebook_AddressListWindow_ExitButton = 'JavaWindow("title:=Address List.*").JavaButton("label:=Exit.*")'

###Active Customer_ProfileTab_UpdateAddress_Window_Validation###
LIQ_Active_Customer_Notebook_UpdateAddress_Window_AddressCodeField = 'JavaWindow("title:=Update Address.*").JavaEdit("tagname:=Text","x:=215","y:=95")'
LIQ_Active_Customer_Notebook_UpdateAddress_Window_Line1Field = 'JavaWindow("title:=Update Address.*").JavaEdit("tagname:=Text","x:=215","y:=125")'
LIQ_Active_Customer_Notebook_UpdateAddress_Window_Line2Field = 'JavaWindow("title:=Update Address.*").JavaEdit("tagname:=Text","x:=215","y:=155")'
LIQ_Active_Customer_Notebook_UpdateAddress_Window_Line3Field = 'JavaWindow("title:=Update Address.*").JavaEdit("tagname:=Text","x:=215","y:=185")'
LIQ_Active_Customer_Notebook_UpdateAddress_Window_Line4Field = 'JavaWindow("title:=Update Address.*").JavaEdit("tagname:=Text","x:=215","y:=215")'
LIQ_Active_Customer_Notebook_UpdateAddress_Window_Line5Field = 'JavaWindow("title:=Update Address.*").JavaEdit("tagname:=Line 5.*","x:=566","y:=125")'
LIQ_Active_Customer_Notebook_UpdateAddress_Window_CityField = 'JavaWindow("title:=Update Address.*").JavaEdit("tagname:=Text","x:=215","y:=245")'
LIQ_Active_Customer_Notebook_UpdateAddress_Window_CountryField = 'JavaWindow("title:=Update Address.*").JavaList("tagname:=Combo","x:=215","y:=275")'
LIQ_Active_Customer_Notebook_UpdateAddress_Window_TreasuryReportingArea_Field = 'JavaWindow("title:=Update Address.*").JavaList("tagname:=Combo","x:=215","y:=305")'
LIQ_Active_Customer_Notebook_UpdateAddress_Window_DefaultPhoneField = 'JavaWindow("title:=Update Address.*").JavaEdit("tagname:=Text","x:=215","y:=335")'
LIQ_Active_Customer_Notebook_UpdateAddress_Window_StateField = 'JavaWindow("title:=Update Address.*").JavaList("attached text:=Province:")'
LIQ_Active_Customer_Notebook_UpdateAddress_Window_ZipPostalCodeField = 'JavaWindow("title:=Update Address.*").JavaEdit("attached text:=Zip/Postal Code:")'

###Active Customer_ProfileTab_FaxDetails_Window###
FaxListWindow  =   'JavaWindow("title:=Fax List.*")' 
FaxListWindow_AddButton = 'JavaWindow("title:=Fax List.*for.*").JavaButton("label:=Add.*")'
FaxDetailWindow = 'JavaWindow("title:=Fax Detail.*")'
FaxDetailWindow_FaxNumber_Field = 'JavaWindow("title:=Fax Detail.*").JavaEdit("attached text:=Fax Number:.*")'
FaxDetailWindow_Description_Field = 'JavaWindow("title:=Fax Detail.*").JavaEdit("attached text:=Description:.*")'
FaxDetailWindow_OkButton = 'JavaWindow("title:=Fax Detail.*").JavaButton("label:=OK.*")'
FaxListWindow_ExitButton = 'JavaWindow("title:=Fax List.*for.*").JavaButton("label:=Exit.*")'

###Active Customer_ProfileTab_ContactList_Window###
ContactListWindow =  'JavaWindow("title:=Contact List.*")'
ContactListWindow_AddButton = 'JavaWindow("title:=Contact List.*for.*").JavaButton("label:=Add")' 
ContactListWindow_ExitButton = 'JavaWindow("title:=Contact List.*for.*").JavaButton("label:=Exit")'

###Active Customer_ProfileTab_ContactDetail_Window### 
ContactDetailWindow = 'JavaWindow("title:=Contact Detail.*")'
ContactDetailWindow_FirstName_Field = 'JavaWindow("title:=Contact Detail.*").JavaEdit("attached text:=First Name:.*")'
ContactDetailWindow_LastName_Field = 'JavaWindow("title:=Contact Detail.*").JavaEdit("attached text:=Last Name:.*")'
ContactDetailWindow_PreferredLanguage_Field = 'JavaWindow("title:=Contact Detail.*").JavaList("attached text:=Preferred Language:.*")'
ContactDetailWindow_PrimaryPhone_Field = 'JavaWindow("title:=Contact Detail.*").JavaEdit("attached text:=Prim. Phone:.*")' 
ContactDetailWindow_SecondaryPhone_Field = 'JavaWindow("title:=Contact Detail.*").JavaEdit("attached text:=Sec. Phone:.*")'
ContactDetailWindow_ProductSBLC_Checkbox = 'JavaWindow("title:=Contact Detail.*").JavaCheckBox("attached text:=SBLC.*")'
ContactDetailWindow_ProductLoan_Checkbox = 'JavaWindow("title:=Contact Detail.*").JavaCheckBox("attached text:=Loan.*")'
ContactDetailWindow_BalanceType_Principal_Checkbox = 'JavaWindow("title:=Contact Detail.*").JavaCheckBox("attached text:=Principal.*")'
ContactDetailWindow_BalanceType_Interest_Checkbox = 'JavaWindow("title:=Contact Detail.*").JavaCheckBox("attached text:=Interest.*")'
ContactDetailWindow_BalanceType_Fees_Checkbox = 'JavaWindow("title:=Contact Detail.*").JavaCheckBox("attached text:=Fees.*")'
ContactDetailWindow_Purposes_Button = 'JavaWindow("title:=Contact Detail.*").JavaButton("label:=(P&urposes:|Purposes.*)")'
ContactDetailWindow_Notification_AddButton = 'JavaWindow("title:=Contact Detail.*").JavaButton("label:=Add.*")'
ContactDetailWindow_FileMenu_SaveMenu = 'JavaWindow("title:=Contact Detail.*").JavaMenu("index:=0").JavaMenu("label:=Save")'
ContactDetailWindow_FileMenu_ExitMenu = 'JavaWindow("title:=Contact Detail.*").JavaMenu("index:=0").JavaMenu("label:=Exit")'
LIQ_Active_ContactDetail_TabSelection = 'JavaWindow("title:=Contact Detail.*").JavaTab("tagname:=Language:")'
LIQ_Active_ContactDetail_MailingAddress_DropdownField = 'JavaWindow("title:=Contact Detail.*").Javalist("labeled_containers_path:=.*Mailing Address.*")'

###Active Customer_ProfileTab_ContactPurpose_Window###
ContactPurposeWindow = 'JavaWindow("title:=Contact Purpose Selection List.*")'
ContactPurposeWindow_OkButton = 'JavaWindow("title:=Contact Purpose.*").JavaButton("attached text:=OK")'
ContactPurposeWindow_Available_List = 'JavaWindow("title:=Contact Purpose Selection List.*").JavaTree("attached text:=Available.*")'

###Active Customer_ProfileTab_ContactNotice_Window###
ContactNoticeWindow = 'JavaWindow("title:=Contact Notice Method.*")'
ContactNoticeWindow_AvailableMethod_Field = 'JavaWindow("title:=Contact Notice Method.*").JavaList("tagname:=Combo")'
ContactNoticeWindow_Email_Field = 'JavaWindow("title:=Contact Notice Method.*").JavaEdit("attached text:=E-mail:.*")'
ContactNoticeWindow_OkButton = 'JavaWindow("title:=Contact Notice Method.*").JavaButton("label:=OK.*")'
ContactNoticeMethodWindow = 'JavaWindow("title:=Contact Notice Method.*","tagname:=Contact Notice Method.*")'

###Active Customer_ProfileTab_RemittanceList_Window###
RemittanceList_Window = 'JavaWindow("title:=Remittance List for.*")'
RemittanceList_Window_RemittanceList = 'JavaWindow("title:=Remittance List for.*").JavaTree("tagname:=Drill down to view details")'
RemittanceList_Window_AddButton = 'JavaWindow("title:=Remittance List.*").JavaButton("label:=Add.*")'
RemittanceList_Window_ExitButton = 'JavaWindow("title:=Remittance List.*").JavaButton("label:=Exit.*")'
RemittanceList_Window_ApprovedSIMT = 'JavaWindow("title:=Remittance List for.*").JavaTree("attached text:=Drill down to view details","developer name:=.*approved=Y.*remittanceMethod=IMT.*")'
RemittanceList_Window_ApprovedStatus = 'JavaWindow("title:=Remittance List for.*").JavaTree("attached text:=Drill down to view details","developer name:=.*approved=Y.*")'

###Active Customer_ProfileTab_RemittanceList_AddRemittance_Window###
RemittanceList_Window_AddRemittanceInstruction_Window = 'JavaWindow("title:=Add Remittance Instruction.*")'
RemittanceList_Window_AddRemittanceInstruction_OkButton = 'JavaWindow("title:=Add Remittance Instruction.*").JavaButton("label:=OK.*")'
RemittanceList_Window_AddRemittanceInstruction_SIMT_Checkbox = 'JavaWindow("title:=Add Remittance Instruction.*").JavaRadioButton("label:=Add Simplified IMT Remittance Instruction")'

###Profile Tab_Remittance Instructions_Detail - DDA###
RemittanceList_Window_RemittanceInstructionsDetail_Window = 'JavaWindow("title:=Remittance Instructions Detail.*")'
RemittanceList_Window_RemittanceInstructionsDetail__Notebook_TabSelection = 'JavaWindow("title:=Remittance Instructions Detail.*").JavaTab("tagname:=Language:")'
LIQ_RemittanceInstruction_Notebook_WorkflowAction = 'JavaWindow("title:=Remittance Instructions Detail.*").JavaTree("attached text:=Drill down to perform Workflow item")'
LIQ_RemittanceInstruction_Notebook_FileMenu_SaveMenu = 'JavaWindow("title:=Remittance Instructions Detail.*").JavaMenu("index:=0").JavaMenu("label:=Save")'
LIQ_RemittanceInstruction_Notebook_FileMenu_ExitMenu = 'JavaWindow("title:=Remittance Instructions Detail.*").JavaMenu("index:=0").JavaMenu("label:=Exit")'
RemittanceList_Window_RemittanceInstructionsDetail_MethodType = 'JavaWindow("title:=Remittance Instructions Detail.*","displayed:=1").JavaList("attached text:=Method:")'
RemittanceList_Window_RemittanceInstructionsDetail_Description = 'JavaWindow("title:=Remittance Instructions Detail.*").JavaEdit("attached text:=Description:.*")'
RemittanceList_Window_RemittanceInstructionsDetail_DDAAccountName = 'JavaWindow("title:=Remittance Instructions Detail.*").JavaEdit("attached text:=.*Acct Name:")'
RemittanceList_Window_RemittanceInstructionsDetail_DDAAccountNumber = 'JavaWindow("title:=Remittance Instructions Detail.*").JavaEdit("attached text:=.*Acct Num.*")'
RemittanceList_Window_RemittanceInstructionsDetail_Currency = 'JavaWindow("title:=Remittance Instructions Detail.*").JavaList("attached text:=Currency:.*")'
RemittanceList_Window_RemittanceInstructionsDetail_ProductLoan_Checkbox = 'JavaWindow("title:=Remittance Instructions Detail.*").JavaCheckBox("attached text:=All Loan Types")'
RemittanceList_Window_RemittanceInstructionsDetail_ProductSBLC_Checkbox = 'JavaWindow("title:=Remittance Instructions Detail.*").JavaCheckBox("attached text:=SBLC/BA")'
RemittanceList_Window_RemittanceInstructionsDetail_Direction_FromCust_Checkbox = 'JavaWindow("title:=Remittance Instructions Detail.*").JavaCheckBox("attached text:=From Cust")'
RemittanceList_Window_RemittanceInstructionsDetail_Direction_ToCust_Checkbox = 'JavaWindow("title:=Remittance Instructions Detail.*").JavaCheckBox("attached text:=To Cust")'
RemittanceList_Window_RemittanceInstructionsDetail_BalanceType_Principal_Checkbox = 'JavaWindow("title:=Remittance Instructions Detail.*").JavaCheckBox("attached text:=Principal")'
RemittanceList_Window_RemittanceInstructionsDetail_BalanceType_Interest_Checkbox = 'JavaWindow("title:=Remittance Instructions Detail.*").JavaCheckBox("attached text:=Interest")'
RemittanceList_Window_RemittanceInstructionsDetail_BalanceType_Fees_Checkbox = 'JavaWindow("title:=Remittance Instructions Detail.*").JavaCheckBox("attached text:=Fees")'
RemittanceList_Window_RemittanceInstructionsDetail_AutoDoIt_Checkbox = 'JavaWindow("title:=Remittance Instructions Detail.*").JavaCheckBox("attached text:=Auto Do It.*")'
RemittanceList_Window_RemittanceInstructionsDetail_AddButton = 'JavaWindow("title:=Remittance Instructions Detail.*").JavaButton("label:=Add")'
RemittanceList_Window_RemittanceInstructionsDetail_ApproveButton = 'JavaWindow("title:=Remittance Instructions Detail.*").JavaButton("label:=Approve")'
RemittanceList_Window_RemittanceInstructionsDetail_DDAOKButton = 'JavaWindow("title:=Remittance Instructions Detail.*").JavaButton("attached text:=OK")'
RemittanceList_Window_RemittanceInstructionsDetail_SummaryNotices_TextField = 'JavaWindow("title:=Remittance Instructions Detail.*").JavaEdit("labeled_containers_path:=.*Advice.*")'
RemittanceList_Window_RemittanceInstructionsDetail_CustomerLocation_Window = 'JavaWindow("title:=Remittance Instructions Detail -- ${Customer_Location} -- .*","tagname:=Remittance Instructions Detail -- ${Customer_Location} -- .*")'

###Profile Tab_Remittance Instructions_Detail - IMT###
RemittanceList_Window_RemittanceInstructionsDetail_SelectMessageType_SearchField = 'JavaWindow("title:=Select Message Type.*").JavaEdit("tagname:=Text","Index:=0")'
RemittanceList_Window_RemittanceInstructionsDetail_SelectMessageType_OKButton = 'JavaWindow("title:=Select Message Type.*").JavaButton("attached text:=OK")'

###Profile Tab_Remittance Instructions_Detail - Message Type###
RemittanceList_Window_RemittanceInstructionsDetail_IMT_SendersCorrespondent_Checkbox = 'JavaWindow("title:=.*IMT message.*").JavaCheckBox("attached text:=Use Senders Correspondent for Receiver")'
RemittanceList_Window_RemittanceInstructionsDetail_IMT_SwiftRoleList = 'JavaWindow("title:=Non Host Bank IMT message.*","displayed:=1").JavaTree("attached text:=Drill down to view or update.*")'
RemittanceList_Window_RemittanceInstructionsDetail_IMT_SwiftRoleList_DeleteButton = 'JavaWindow("title:=Non Host Bank IMT message.*","displayed:=1").JavaButton("label:=Delete.*")'
RemittanceList_Window_RemittanceInstructionsDetail_IMT_SwiftRoleList_AddButton = 'JavaWindow("title:=Non Host Bank IMT message.*","displayed:=1").JavaButton("label:=Add.*")'
RemittanceList_Window_RemittanceInstructionsDetail_IMT_DetailsofCharges = 'JavaWindow("title:=.*IMT message.*").JavaList("attached text:=Details of Charges:")'
RemittanceList_Window_RemittanceInstructionsDetail_IMT_DetailsofPayment = 'JavaWindow("title:=.*IMT message.*").JavaEdit("attached text:=Details of payment:")'
RemittanceList_Window_RemittanceInstructionsDetail_IMT_OrderingCustomer = 'JavaWindow("title:=.*IMT message.*").JavaEdit("attached text:=Ordering Customer:")'
RemittanceList_Window_RemittanceInstructionsDetail_IMT_SenderToReceiver = 'JavaWindow("title:=.*IMT message.*").JavaEdit("attached text:=Sender to receiver info:")'
RemittanceList_Window_RemittanceInstructionsDetail_IMT_BankOperationCode = 'JavaWindow("title:=.*IMT message.*").JavaList("attached text:=Bank Operation Code:")'
RemittanceList_Window_RemittanceInstructionsDetail_IMT_OKButton = 'JavaWindow("title:=.*IMT message.*").JavaButton("attached text:=OK")'
RemittanceList_Window_RemittanceInstructionsDetail_IMT_Window = 'JavaWindow("title:=.*IMT message.*")'
RemittanceList_Window_RemittanceInstructionsDetail_IMT_AddButton = 'JavaWindow("title:=.*IMT message.*").JavaButton("attached text:=Add")'

##Profile Tab_Remittance Instructions_Detail - Message Type - Swift Details###
RemittanceList_Window_RemittanceInstructionsDetail_SwiftRoleType = 'JavaWindow("title:=Add a SWIFT Role to IMT Message.*").JavaList("attached text:=SWIFT Role Type:")'
RemittanceList_Window_RemittanceInstructionsDetail_SwiftIDButton = 'JavaWindow("title:=Add a SWIFT Role to IMT Message.*").JavaButton("label:=SWIFT ID.*")'
RemittanceList_Window_RemittanceInstructionsDetail_SwiftIDCheckbox = 'JavaWindow("title:=Choose a SWIFT ID.*").JavaRadioButton("label:=Swift ID")'
RemittanceList_Window_RemittanceInstructionsDetail_SwiftIDSearch_InputField = 'JavaWindow("title:=Choose a SWIFT ID.*").JavaEdit("tagname:=Search for Swift ID:")'
RemittanceList_Window_RemittanceInstructionsDetail_SwiftID_OKButton = 'JavaWindow("title:=Choose a SWIFT ID.*").JavaButton("label:=OK.*")'
RemittanceList_Window_RemittanceInstructionsDetail_AddSwiftID_Description = 'JavaWindow("title:=Add a SWIFT Role to IMT Message.*").JavaEdit("attached text:=Description:.*")'
RemittanceList_Window_RemittanceInstructionsDetail_AddSwiftID_AccountNumber = 'JavaWindow("title:=Add a SWIFT Role to IMT Message.*").JavaEdit("attached text:=Account Number:.*")'
RemittanceList_Window_RemittanceInstructionsDetail_AddSwiftID_OKButton = 'JavaWindow("title:=Add a SWIFT Role to IMT Message.*").JavaButton("label:=OK.*")'
RemittanceList_Window_RemittanceInstructionsDetail_AddSwiftID_Window = 'JavaWindow("title:=Add a SWIFT Role to IMT Message.*")'
RemittanceList_Window_RemittanceInstructionsDetail_AddSwiftID_ClearingNumber = 'JavaWindow("title:=Add a SWIFT Role to IMT Message.*").JavaEdit("attached text:=Clearing Num:.*")'
RemittanceList_Window_RemittanceInstructionsDetail_AddSwiftID_ClearingTypeList =  'JavaWindow("title:=Add a SWIFT Role to IMT Message.*").JavaList("attached text:=Clearing Type:")'

##Profile Tab_Remittance Instructions_Detail - Message Type - Swift Details - UPDATE MODE### 
RemittanceList_Window_RemittanceInstructionsDetail_UpdateMode_SwiftRoleType = 'JavaWindow("title:=Update.* IMT Message.*").JavaList("attached text:=SWIFT Role Type:")'
RemittanceList_Window_RemittanceInstructionsDetail_UpdateMode_SwiftIDButton = 'JavaWindow("title:=Update.* IMT Message.*").JavaButton("label:=SWIFT ID.*")'
RemittanceList_Window_RemittanceInstructionsDetail_UpdateMode_AddSwiftID_Description = 'JavaWindow("title:=Update.* IMT Message.*").JavaEdit("attached text:=Description:.*")'
RemittanceList_Window_RemittanceInstructionsDetail_UpdateMode_AddSwiftID_AccountNumber = 'JavaWindow("title:=Update.* IMT Message.*").JavaEdit("attached text:=Account Number:.*")'
RemittanceList_Window_RemittanceInstructionsDetail_UpdateMode_AddSwiftID_OKButton = 'JavaWindow("title:=Update.* IMT Message.*").JavaButton("label:=OK.*")'
RemittanceList_Window_RemittanceInstructionsDetail_UpdateMode_AddSwiftID_ClearingNumber = 'JavaWindow("title:=Update.* IMT Message.*").JavaEdit("attached text:=Clearing Num.*")'
RemittanceList_Window_RemittanceInstructionsDetail_UpdateMode_ClearingTypeList =  'JavaWindow("title:=Update.* IMT Message.*").JavaList("attached text:=Clearing Type:")'

###Profile Tab_Remittance Instructions_Detail - Simplified IMT###
RemittanceList_Window_RemittanceInstructionsDetail_SIMTDescription = 'JavaWindow("title:=Simplified International Money Transfer.*","displayed:=1").JavaEdit("attached text:=Description:.*","index:=0")'
RemittanceList_Window_RemittanceInstructionsDetail_SIMTMethodType = 'JavaWindow("title:=Simplified International Money Transfer.*","displayed:=1").JavaList("attached text:=Method:.*")'
RemittanceList_Window_RemittanceInstructionsDetail_SIMTCurrency = 'JavaWindow("title:=Simplified International Money Transfer.*").JavaList("attached text:=Currency:.*")'
# RemittanceList_Window_RemittanceInstructionsDetail_SWIFTIDButton =  'JavaWindow("title:=Simplified International Money Transfer.*","displayed:=1").JavaButton("attached text:=SWIFT ID:","labeled_containers_path:=Group:From Customer;")'
RemittanceList_Window_RemittanceInstructionsDetail_SWIFTIDBankFromCustomer =  'JavaWindow("title:=Simplified International Money Transfer.*","displayed:=1").JavaEdit("text:=COMMONWEALTH BANK OF AUSTRALIA SYDNEY","labeled_containers_path:=Group:From Customer;")'
RemittanceList_Window_RemittanceInstructionsDetail_SWIFTIDBankToCustomer = 'JavaWindow("title:=Simplified International Money Transfer.*","displayed:=1").JavaEdit("text:=COMMONWEALTH BANK OF AUSTRALIA SYDNEY","labeled_containers_path:=Group:To Customer;")'
RemittanceList_Window_RemittanceInstructionsDetail_SIMTOKButton = 'JavaWindow("title:=Simplified International Money Transfer.*","displayed:=1").JavaButton("attached text:=OK")'
RemittanceList_Window_RemittanceInstructionsDetail_SIMTApproveButton = 'JavaWindow("title:=Simplified International Money Transfer.*","displayed:=1").JavaButton("attached text:=Approve")'

###Profile Tab_Remittance Instructions_Detail - IMT Checkboxes###
ContactDetailWindow_IMTProductSBLC_Checkbox = 'JavaWindow("title:=Simplified International Money Transfer.*","displayed:=1").JavaCheckBox("attached text:=SBLC.*")'
ContactDetailWindow_IMTProductLoan_Checkbox = 'JavaWindow("title:=Simplified International Money Transfer.*","displayed:=1").JavaCheckBox("attached text:=All Loan.*")'
ContactDetailWindow_IMTBalanceType_Principal_Checkbox = 'JavaWindow("title:=Simplified International Money Transfer.*","displayed:=1").JavaCheckBox("attached text:=Principal.*")'
ContactDetailWindow_IMTBalanceType_Interest_Checkbox = 'JavaWindow("title:=Simplified International Money Transfer.*","displayed:=1").JavaCheckBox("attached text:=Interest.*")'
ContactDetailWindow_IMTBalanceType_Fees_Checkbox = 'JavaWindow("title:=Simplified International Money Transfer.*","displayed:=1").JavaCheckBox("attached text:=Fees.*")'
RemittanceList_Window_RemittanceInstructionsDetail_IMTAutoDoIt_Checkbox = 'JavaWindow("title:=Simplified International Money Transfer.*","displayed:=1").JavaCheckBox("attached text:=Auto Do It.*")'

###Profile Tab_Remittance Instructions_Detail - SwiftID###
RemittanceList_Window_RemittanceInstructionsDetail_SearchBySWIFTID =  'JavaWindow("title:=Choose a SWIFT ID").JavaRadioButton("label:=Swift ID")'
RemittanceList_Window_RemittanceInstructionsDetail_SWIFTIDInputField =  'JavaWindow("title:=Choose a SWIFT ID").JavaEdit("attached text:=Search for Swift ID:")'
RemittanceList_Window_RemittanceInstructionsDetail_SWIFTIDescriptionField =  'JavaWindow("title:=Choose a SWIFT ID").JavaEdit("attached text:=Description:")'
RemittanceList_Window_RemittanceInstructionsDetail_OKButton =  'JavaWindow("title:=Choose a SWIFT ID").JavaButton("label:=OK")'
RemittanceList_Window_RemittanceInstructionsDetail_ClearingTypeList =  'JavaWindow("title:=Choose a SWIFT ID").JavaList("attached text:=Clearing Type:")'

###Profile Tab_Remittance Instructions_Detail - Approvals###
RemittanceList_Window_RemittanceInstructionsDetail_PasswordRequiredWindow_InputPassword = 'JavaWindow("title:=Password Required.*").JavaEdit("attached text:=Please enter password for.*")'
RemittanceList_Window_RemittanceInstructionsDetail_PasswordRequiredWindow_OkButton = 'JavaWindow("title:=Password Required.*").JavaButton("label:=OK")'

###Active Customer_ProfileTab_ServicingGroup_Window###
ServicingGroupWindow  = 'JavaWindow("title:=Servicing Groups.*For.*")'
ServicingGroupWindow_AddButton = 'JavaWindow("title:=Servicing Groups.*For.*").JavaButton("label:=Add.*")'
ServicingGroupWindow_RemittanceInstructionButton = 'JavaWindow("title:=Servicing Groups.*For.*").JavaButton("label:=Remittance Instructions.*")'
ServicingGroupWindow_InformationalMessage = 'JavaWindow("title:=Informational Message.*","displayed:=1").JavaEdit("attached text:=INFORMATIONAL MESSAGE","value:=Contacts available for selection include only active contacts.*")' 
ServicingGroupWindow_ExitButton = 'JavaWindow("title:=Servicing Groups.*For.*").JavaButton("label:=Exit.*")'
ServicingGroupWindow_SelectionList_RemittanceInstructionItem = 'JavaWindow("title:=Servicing Group Remittance Instructions Selection List","displayed:=1").JavaTree("attached text:=Servicing Group Remittance Instructions")'
ServicingGroupWindow_SelectionList_OkButton = 'JavaWindow("title:=Servicing Group Remittance Instructions Selection List","displayed:=1").JavaButton("label:=OK.*")'
ServicingGroupWindow_ServicingGroupsFor = 'JavaWindow("title:=Servicing Groups.*For.*","tagname:=Serving Groups For: ${LIQCustomer_ShortName}")'
ServicingGroupWindow_ServicingGroupsFor_DrillDownToChangeGroupMembers = 'JavaWindow("title:=Servicing Groups.*For.*","tagname:=Serving Groups For: ${LIQCustomer_ShortName}").JavaTree("attached text:=Drill Down To Change Group Members","developer name:=.*${Contact_LastName1}.*")'
ServicingGroupWindow_RemittanceInstructionDetails_DDADescription = 'JavaWindow("title:=Servicing Groups.*For.*").JavaTree("attached text:=Drill Down For Remittance Instruction Details","developer name:=.*description=${RemittanceInstruction_DDADescriptionAUD}.*")'
ServicingGroupWindow_RemittanceInstructionDetails_IMTDescription = 'JavaWindow("title:=Servicing Groups.*For.*").JavaTree("attached text:=Drill Down For Remittance Instruction Details","developer name:=.*description=${RemittanceInstruction_IMTDescriptionUSD}.*")'
ServicingGroupWindow_RemittanceInstructionDetails_RTGSDescription = 'JavaWindow("title:=Servicing Groups.*For.*").JavaTree("attached text:=Drill Down For Remittance Instruction Details","developer name:=.*description=${RemittanceInstruction_RTGSDescriptionAUD}.*")'

###Active Customer_ProfileTab_ServicingGroup_ContactsSelectionList_Window###
ContactsSelectionList_Window = 'JavaWindow("title:=Servicing Group Contacts Selection List.*")'
ContactsSelectionList_Window_SearchInput_Field = 'JavaWindow("title:=Servicing Group Contacts Selection List.*").JavaEdit("tagname:=Text")' 
ContactsSelectionList_Window_Available_List = 'JavaWindow("title:=Servicing Group Contacts Selection List.*").JavaTree("attached text:=Available.*")'
ContactsSelectionList_Window_OkButton = 'JavaWindow("title:=Servicing Group Contacts Selection List.*").JavaButton("label:=OK.*")'

###Active Customer_ProfileTab_ServicingGroup_ContactsSelectionList_Window###

### Customer Locators - Rodel ####
LIQ_ActiveCustomer_Window = 'JavaWindow("title:=Active Customer --.*")'
LIQ_ActiveCustomer_InquiryMode_Button = 'JavaWindow("title:=Active Customer --.*").JavaButton("attached text:=Notebook in Inquiry Mode - F7")'
LIQ_ActiveCustomer_UpdateMode_Button = 'JavaWindow("title:=Active Customer --.*").JavaButton("attached text:=Notebook in Update Mode - F7")'
LIQ_ActiveCustomer_Tab = 'JavaWindow("title:=Active Customer --.*").JavaTab("tagname:=TabFolder")'
LIQ_ActiveCustomer_BorrowerDetails_List = 'JavaWindow("title:=Active Customer --.*").JavaTree("attached text:=Drill down for details")'
LIQ_ActiveCustomer_RemittanceInstructions_Button = 'JavaWindow("title:=Active Customer.*").JavaButton("attached text:=Remittance Instructions")'
LIQ_ActiveCustomer_RemittanceList_Window = 'JavaWindow("title:=Remittance List for.*")'
LIQ_ActiveCustomer_Remittance_List = 'JavaWindow("title:=Remittance List for.*").JavaTree("attached text:=Drill down to view details")'
LIQ_ActiveCustomer_Remittance_List_Exit_Button = 'JavaWindow("title:=Remittance List for.*").JavaButton("attached text:=Exit")'

LIQ_RemittanceInstruction_IMT_Window = 'JavaWindow("title:=Simplified International Money Transfer")'
LIQ_RemittanceInstruction_IMT_AuotDoIt_Checkbox = 'JavaWindow("title:=Simplified International Money Transfer").JavaCheckBox("attached text:=Auto Do It")'
LIQ_RemittanceInstruction_IMT_Approved_Checkbox = 'JavaWindow("title:=Simplified International Money Transfer").JavaCheckBox("attached text:=Approved")'
LIQ_RemittanceInstruction_IMT_Approve_Button = 'JavaWindow("title:=Simplified International Money Transfer").JavaButton("attached text:=Approve")'
LIQ_RemittanceInstruction_ApprovalPassword_Textfield = 'JavaWindow("title:=Password Required").JavaEdit("attached text:=.*enter password.*")'
LIQ_RemittanceInstruction_ApprovalPassword_Window = 'JavaWindow("title:=Password Required")'
LIQ_RemittanceInstruction_ApprovalPassword_OK_Button = 'JavaWindow("title:=Password Required").JavaButton("attached text:=OK")'
LIQ_RemittanceInstruction_IMT_OK_Button = 'JavaWindow("title:=Simplified International Money Transfer").JavaButton("attached text:=OK")'
LIQ_RemittanceInstruction_IMT_AllLoanTypes_Checkbox = 'JavaWindow("title:=Simplified International Money Transfer").JavaCheckBox("attached text:=All Loan Types")'
LIQ_RemittanceInstruction_IMT_SBLCBA_Checkbox = 'JavaWindow("title:=Simplified International Money Transfer").JavaCheckBox("attached text:=SBLC/BA")'
LIQ_RemittanceInstruction_IMT_Principal_Checkbox = 'JavaWindow("title:=Simplified International Money Transfer").JavaCheckBox("attached text:=Principal")'
LIQ_RemittanceInstruction_IMT_Interest_Checkbox = 'JavaWindow("title:=Simplified International Money Transfer").JavaCheckBox("attached text:=Interest")'
LIQ_RemittanceInstruction_IMT_Fees_Checkbox = 'JavaWindow("title:=Simplified International Money Transfer").JavaCheckBox("attached text:=Fees")'
LIQ_RemittanceInstruction_IMT_FromCustomer_SwiftType_List = 'JavaWindow("title:=Simplified International Money Transfer").JavaObject("text:=From Customer").JavaList("attached text:=Swift Message Type:")'
LIQ_RemittanceInstruction_IMT_ToCustomer_SwiftType_List = 'JavaWindow("title:=Simplified International Money Transfer").JavaObject("text:=To Customer").JavaList("attached text:=Swift Message Type:")'
LIQ_RemittanceInstruction_IMT_FromCustomer_SwiftID_Text = 'JavaWindow("title:=Simplified International Money Transfer").JavaObject("text:=From Customer").JavaEdit("attached text:=Swift Receiver Information:")'
LIQ_RemittanceInstruction_IMT_ToCustomer_SwiftID_Text = 'JavaWindow("title:=Simplified International Money Transfer").JavaObject("text:=To Customer").JavaEdit("attached text:=Primary Processing Area:")'

LIQ_RemittanceInstruction_DDA_Window = 'JavaWindow("title:=Remittance Instructions Detail--Type: Demand Deposit Account")'
LIQ_RemittanceInstruction_DDA_AuotDoIt_Checkbox = 'JavaWindow("title:=Remittance Instructions Detail--Type: Demand Deposit Account").JavaCheckBox("attached text:=Auto Do It")'
LIQ_RemittanceInstruction_DDA_Approved_Checkbox = 'JavaWindow("title:=Remittance Instructions Detail--Type: Demand Deposit Account").JavaCheckBox("attached text:=Approved")'
LIQ_RemittanceInstruction_DDA_Approve_Button = 'JavaWindow("title:=Remittance Instructions Detail--Type: Demand Deposit Account").JavaButton("attached text:=Approve")'
LIQ_RemittanceInstruction_DDA_OK_Button = 'JavaWindow("title:=Remittance Instructions Detail--Type: Demand Deposit Account").JavaButton("attached text:=OK")'
LIQ_RemittanceInstruction_DDA_AllLoanTypes_Checkbox = 'JavaWindow("title:=Remittance Instructions Detail--Type: Demand Deposit Account").JavaCheckBox("attached text:=All Loan Types")'
LIQ_RemittanceInstruction_DDA_SBLCBA_Checkbox = 'JavaWindow("title:=Remittance Instructions Detail--Type: Demand Deposit Account").JavaCheckBox("attached text:=SBLC/BA")'
LIQ_RemittanceInstruction_DDA_Principal_Checkbox = 'JavaWindow("title:=Remittance Instructions Detail--Type: Demand Deposit Account").JavaCheckBox("attached text:=Principal")'
LIQ_RemittanceInstruction_DDA_Interest_Checkbox = 'JavaWindow("title:=Remittance Instructions Detail--Type: Demand Deposit Account").JavaCheckBox("attached text:=Interest")'
LIQ_RemittanceInstruction_DDA_Fees_Checkbox = 'JavaWindow("title:=Remittance Instructions Detail--Type: Demand Deposit Account").JavaCheckBox("attached text:=Fees")'
LIQ_RemittanceInstruction_DDA_FromCust_Checkbox = 'JavaWindow("title:=Remittance Instructions Detail--Type: Demand Deposit Account").JavaCheckBox("attached text:=From Cust")'
LIQ_RemittanceInstruction_DDA_ToCust_Checkbox = 'JavaWindow("title:=Remittance Instructions Detail--Type: Demand Deposit Account").JavaCheckBox("attached text:=To Cust")'

LIQ_RemittanceInstruction_RTGS_Window = 'JavaWindow("title:=Remittance Instructions Detail--Type: International Money Transfer")'
LIQ_RemittanceInstruction_RTGS_AuotDoIt_Checkbox = 'JavaWindow("title:=Remittance Instructions Detail--Type: International Money Transfer").JavaCheckBox("attached text:=Auto Do It")'
LIQ_RemittanceInstruction_RTGS_Approved_Checkbox = 'JavaWindow("title:=Remittance Instructions Detail--Type: International Money Transfer").JavaCheckBox("attached text:=Approved")'
LIQ_RemittanceInstruction_RTGS_Approve_Button = 'JavaWindow("title:=Remittance Instructions Detail--Type: International Money Transfer").JavaButton("attached text:=Approve")'
LIQ_RemittanceInstruction_RTGS_OK_Button = 'JavaWindow("title:=Remittance Instructions Detail--Type: International Money Transfer").JavaButton("attached text:=OK")'
LIQ_RemittanceInstruction_RTGS_AllLoanTypes_Checkbox = 'JavaWindow("title:=Remittance Instructions Detail--Type: International Money Transfer").JavaCheckBox("attached text:=All Loan Types")'
LIQ_RemittanceInstruction_RTGS_SBLCBA_Checkbox = 'JavaWindow("title:=Remittance Instructions Detail--Type: International Money Transfer").JavaCheckBox("attached text:=SBLC/BA")'
LIQ_RemittanceInstruction_RTGS_Principal_Checkbox = 'JavaWindow("title:=Remittance Instructions Detail--Type: International Money Transfer").JavaCheckBox("attached text:=Principal")'
LIQ_RemittanceInstruction_RTGS_Interest_Checkbox = 'JavaWindow("title:=Remittance Instructions Detail--Type: International Money Transfer").JavaCheckBox("attached text:=Interest")'
LIQ_RemittanceInstruction_RTGS_Fees_Checkbox = 'JavaWindow("title:=Remittance Instructions Detail--Type: International Money Transfer").JavaCheckBox("attached text:=Fees")'
LIQ_RemittanceInstruction_RTGS_FromCust_Checkbox = 'JavaWindow("title:=Remittance Instructions Detail--Type: International Money Transfer").JavaCheckBox("attached text:=From Cust")'
###RemittanceInstructionsChangeTransaction###
LIQ_SelectBorrower_JavaTree = 'JavaWindow("title:=Active Customer.*").JavaTree("attached text:=Drill down for details")'

###RemittanceList###
LIQ_RemittanceList_Window = 'JavaWindow("title:=Remittance List.*")'
LIQ_RemittanceList_Method = 'JavaWindow("title:=Remittance List.*").JavaTree("attached text:=Drill down to view details")'

###RemittanceInstructionDetail###
LIQ_RemittanceInstructionsDetails_Window = 'JavaWindow("title:=Remittance Instructions Detail--.*")'
LIQ_RemittanceInstructionsDetails_AccountName = 'JavaWindow("title:=Remittance Instructions Detail--.*").JavaStaticText("attached text:= Acct Name:")'
LIQ_RemittanceInstructionsDetails_TabSelection = 'JavaWindow("title:=Remittance Instructions Detail--.*").JavaTab("tagname:=Pending:")'
LIQ_RemittanceInstructionsDetails_Pending_JavaTree = 'JavaWindow("title:=Remittance Instructions Detail--.*").JavaTree("attached text:=Pending Transactions")'

###Approval RemittanceChangeTransaction###
LIQ_RemittanceChangeTransaction_Window = 'JavaWindow("title:=.*Remittance Instruction Change Transaction")'
LIQ_RemittanceChangeTransaction_EffectiveDate = 'JavaWindow("title:=.*Remittance Instruction Change Transaction").JavaEdit("attached text:=Effective Date:")'
LIQ_RemittanceChangeTransaction_AccountName = 'JavaWindow("title:=.*Remittance Instruction Change Transaction").JavaTree("attached text:=Drill down to edit the new value on a change item")'
LIQ_RemittanceChangeTransaction_AccountNumber = 'JavaWindow("title:=.*Remittance Instruction Change Transaction").JavaTree("attached text:=Drill down to edit the new value on a change item")'

LIQ_RemittanceChangeTransaction_AccountName_Window = 'JavaWindow("title:=Enter Account Name")'
LIQ_RemittanceChangeTransaction_NewAccountName = 'JavaWindow("title:=Enter Account Name").JavaEdit("tagname:=Text")'
LIQ_RemittanceChangeTransaction_NewAccount_Ok_Button = 'JavaWindow("title:=Enter Account Name").JavaButton("attached text:=OK")'

LIQ_RemittanceChangeTransaction_AccountNumber_Window = 'JavaWindow("title:=Enter Account Number")'
LIQ_RemittanceChangeTransaction_NewAccountNumber = 'JavaWindow("title:=Enter Account Number").JavaEdit("tagname:=Text")'
LIQ_RemittanceChangeTransaction_Ok_Button = 'JavaWindow("title:=Enter Account Number").JavaButton("attached text:=OK")'

LIQ_RemittanceChangeTransaction_Workflow_Tab = 'JavaWindow("title:=.*Remittance Instruction Change Transaction").JavaTab("tagname:=TabFolder")'
LIQ_RemittanceChangeTransaction_Warning_Yes_Button = 'JavaWindow("title:=Warning.*","displayed:=1").JavaButton("label:=Yes.*")'
LIQ_RemittanceChangeTransaction_ListItem = 'JavaWindow("title:=.*Remittance Instruction Change Transaction").JavaTree("attached text:=Drill down to perform Workflow item")'
LIQ_SelectBorrower_JavaTree = 'JavaWindow("title:=Awaiting Send To Approval.*").JavaTree("tagname:=attached text:=To edit the new value(s) highlight the cell","displayed:=1")'
LIQ_AmendedValue_JavaTree = 'JavaWindow("title:=.*Contact Change Transaction").JavaTree("tagname:=attached text:=To edit the new value\(s\) highlight the cell","displayed:=1")'

LIQ_ActiveCustomer_Contacts_Button = 'JavaWindow("title:=Active Customer.*").JavaButton("attached text:=Contacts")'

###Contact list###
LIQ_ContactList_Window = 'JavaWindow("title:=Contact List.*")'
LIQ_SelectName_JavaTree = 'JavaWindow("title:=Contact List.*").JavaTree("attached text:=Drill down to view details")'

###ContactDetails###
LIQ_ContactDetails_Window = 'JavaWindow("title:=Contact Detail -.*")'
LIQ_ContactDetails_Notebook_InquiryMode = 'JavaWindow("title:=Contact Detail -.*").JavaButton("text:=Notebook in Inquiry Mode - F7")'
LIQ_ContactDetails_Notebook_UpdateMode = 'JavaWindow("title:=Contact Detail -.*").JavaButton("text:=Notebook in Update Mode - F7")'
LIQ_ContactDetails_Nickname = 'JavaWindow("title:=Contact Detail -.*").JavaEdit("attached text:=Nickname:")'

###Contact Change Transaction Approval###
LIQ_ContactChangeTransactionApproval_Window ='JavaWindow("title:=.*Contact Change Transaction")'
LIQ_ContactChangeTransactionApproval_JavaTree ='JavaWindow("title:=.*Contact Change Transaction").JavaTree("columns_count:=3","labeled_containers_path:=Tab:General;")'

LIQ_ContactChangeTransaction_Workflow_Tab = 'JavaWindow("title:=.*Contact Change Transaction").JavaTab("tagname:=TabFolder")'
LIQ_ContactChangeTransaction_Warning_Yes_Button = 'JavaWindow("title:=Warning.*","displayed:=1").JavaButton("label:=Yes.*")'
LIQ_ContactChangeTransaction_ListItem = 'JavaWindow("title:=.*Contact Change Transaction").JavaTree("attached text:=Drill down to perform Workflow item")'