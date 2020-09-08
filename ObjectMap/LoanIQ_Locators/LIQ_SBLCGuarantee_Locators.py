###Existing Standby Letter of Credit for Deal Window###
LIQ_ExistingStandbyLettersOfCredit_Window = 'JavaWindow("title:=Existing Standby Letters of Credit For.*")'
LIQ_ExistingStandbyLettersOfCredit_Tree = 'JavaWindow("title:=Existing Standby Letters of Credit For.*").JavaTree("attached text:=Drill down to open the notebook")'
LIQ_ExistingStandbyLettersOfCreditUpdate_Checkbox = 'JavaWindow("title:=Existing Standby Letters of Credit For Deal:.*").JavaCheckBox("tagname:=Open notebook in update mode")'
LIQ_ExistingLettersofCredit_Window = 'JavaWindow("title:=Existing Standby Letters of Credit.*")'
LIQ_ExistingLettersofCredit_LettersofCredit_List = 'JavaWindow("title:=Existing Standby Letters of Credit.*").JavaTree("attached text:=Drill down to open the notebook")'

###SBLC/Guarantee Notebook###
LIQ_SBLCGuarantee_Window = 'JavaWindow("title:=Bank Guarantee/Letter of Credit/Synd Fronted Bank.*")'
LIQ_SBLCGuarantee_Tab = 'JavaWindow("title:=Bank Guarantee/Letter of Credit/Synd Fronted Bank.*").JavaTab("tagname:=TabFolder")'
LIQ_SBLCGuarantee_InquiryMode_Button = 'JavaWindow("title:=Bank Guarantee/Letter of Credit/Synd Fronted Bank.*").JavaButton("label:=.*Inquiry Mode.*")'
LIQ_SBLCGuarantee_UpdateMode_Button = 'JavaWindow("title:=Bank Guarantee/Letter of Credit/Synd Fronted Bank.*").JavaButton("label:=.*Update Mode.*")'
LIQ_SBLCGuarantee_Payments_FeesOnLenderShares = 'JavaWindow("title:=Bank Guarantee/Letter of Credit/Synd Fronted Bank.*").JavaMenu("label:=Payments").JavaMenu("label:=Fees On Lender shares")'
LIQ_SBLCGuarantee_Alias_StaticText = 'JavaWindow("title:=Bank Guarantee/Letter of Credit/Synd Fronted Bank.*").JavaStaticText("x:=164","y:=122")'
LIQ_SBLCGuarantee_GlobalOriginal_StaticText = 'JavaWindow("title:=Bank Guarantee/Letter of Credit/Synd Fronted Bank.*").JavaObject("tagname:=Group","text:=Amounts").JavaEdit("attached text:=Global Original:")'
LIQ_SBLCGuarantee_Rate_StaticText = 'JavaWindow("title:=Bank Guarantee/Letter of Credit/Synd Fronted Bank.*").JavaObject("tagname:=Group","text:=Fee on Lender Shares").JavaEdit("text:=.*%.*")'
LIQ_SBLCGuarantee_RateBasis_Combobox = 'JavaWindow("title:=Bank Guarantee/Letter of Credit/Synd Fronted Bank.*").JavaObject("tagname:=Group","text:=Fee on Lender Shares").JavaList("attached text:=Rate Basis:")'
LIQ_SBLCGuarantee_CycleFrequency_Combobox = 'JavaWindow("title:=Bank Guarantee/Letter of Credit/Synd Fronted Bank.*").JavaObject("tagname:=Group","text:=Fee on Lender Shares").JavaObject("tagname:=Group","text:=Accrual Rules").JavaList("attached text:=Cycle Frequency:")'
LIQ_SBLCGuarantee_StartDate_StaticText = 'JavaWindow("title:=Bank Guarantee/Letter of Credit/Synd Fronted Bank.*").JavaObject("tagname:=Group","text:=Fee on Lender Shares").JavaObject("tagname:=Group","text:=Accrual Rules").JavaEdit("attached text:=Start Date:")'
LIQ_SBLCGuarantee_EffectiveDate_StaticText = 'JavaWindow("title:=Bank Guarantee/Letter of Credit/Synd Fronted Bank.*").JavaStaticText("x:=569","y:=157")'
LIQ_SBLCGuarantee_AccrualRule_Dropdown = 'JavaWindow("title:=.*Bank Guarantee/Letter of Credit/Synd Fronted Bank.*").JavaList("labeled_containers_path:=.*Fee on Lender Shares.*Group.*Accrual Rules.*","text:=Pay in Arrears")'


LIQ_SBLCGuarantee_Window_Tab = 'JavaWindow("title:=Bank Guarantee/Letter of Credit.*Synd Fronted Bank.*").JavaTab("tagname:=TabFolder")'
LIQ_SBLCGuarantee_FrontingUsageFee_CycleList = 'JavaWindow("title:=Bank Guarantee/Letter of Credit.*Synd Fronted Bank.*").JavaObject("tagname:=Group", "text:=.* Fee (.*BG.*)").JavaTree("attached text:=Drill down to view details")'
LIQ_SBLCGuarantee_CycleSharesAdjustment_Button = 'JavaWindow("title:=Bank Guarantee/Letter of Credit.*Synd Fronted Bank.*").JavaObject("tagname:=Group", "text:=.* Fee (.*BG.*)").JavaButton("attached text:=Cycle Shares Adjustment")'
LIQ_SBLCGuarantee_UpdateMode_Button = 'JavaWindow("title:=Bank Guarantee/Letter of Credit.*Synd Fronted Bank.*").JavaButton("attached text:=Notebook in Update Mode - F7")'
LIQ_SBLCGuarantee_InquiryMode_Button = 'JavaWindow("title:=Bank Guarantee/Letter of Credit.*Synd Fronted Bank.*").JavaButton("attached text:=Notebook in Inquiry Mode - F7")'


###Cycles for Bank Guarantee/Letter of Credit/Synd Fronted Bank Window###
LIQ_CyclesForBankGuarantee_Window = 'JavaWindow("title:=Cycles for Bank Guarantee.*")'
LIQ_CyclesForBankGuarantee_Prorate_RadioButton = 'JavaWindow("title:=Cycles for Bank Guarantee.*").JavaRadioButton("label:=")'
LIQ_CyclesForBankGuarantee_ProjectedDue_RadioButton = 'JavaWindow("title:=Cycles for Bank Guarantee.*").JavaRadioButton("label:=Projected Due")'
LIQ_CyclesForBankGuarantee_Tree = 'JavaWindow("title:=Cycles for Bank Guarantee.*").JavaTree("attached text:=Choose a cycle to make a payment against")'
LIQ_CyclesForBankGuarantee_OK_Button = 'JavaWindow("title:=Cycles for Bank Guarantee.*").JavaButton("label:=OK")'

###Issuance Fee Payment Notebook###
LIQ_IssuanceFeePaymentNotebook_Window = 'JavaWindow("title:=Bank Guarantee/Letter of Credit/Synd Fronted Bank Issuance Fee Payment.*")'
LIQ_IssuanceFeePaymentNotebook_EffectiveDate_Field = 'JavaWindow("title:=Bank Guarantee/Letter of Credit/Synd Fronted Bank Issuance Fee Payment.*").JavaEdit("attached text:=Effective Date:")'
LIQ_IssuanceFeePaymentNotebook_File_Save = 'JavaWindow("title:=Bank Guarantee/Letter of Credit/Synd Fronted Bank Issuance Fee Payment.*").JavaMenu("label:=File").JavaMenu("label:=Save")'
LIQ_IssuanceFeePaymentNotebook_Tab = 'JavaWindow("title:=Bank Guarantee/Letter of Credit/Synd Fronted Bank Issuance Fee Payment.*").JavaTab("tagname:=TabFolder")'
LIQ_IssuanceFeePaymentNotebook_Workflow_Tree = 'JavaWindow("title:=Bank Guarantee/Letter of Credit/Synd Fronted Bank Issuance Fee Payment.*").JavaTree("attached text:=Drill down to perform Workflow item")'
LIQ_IssuanceFeePaymentNotebook_Options_Cashflow = 'JavaWindow("title:=Bank Guarantee/Letter of Credit.*Issuance Fee Payment.*").JavaMenu("label:=Options").JavaMenu("label:=Cashflow")'
LIQ_IssuanceFeePaymentNotebook_File_Exit = 'JavaWindow("title:=Bank Guarantee/Letter of Credit.*Issuance Fee Payment.*").JavaMenu("label:=File").JavaMenu("label:=Exit")'




###Issuance Fee Payment - Generate Intent Notices Window###
LIQ_SBLCGuaranteeFeePaymentGroup_Window = 'JavaWindow("title:=SBLC/Guarantee Fee Payment Group created by.*")'
LIQ_SBLCGuaranteeFeePaymentGroup_Tree = 'JavaWindow("title:=SBLC/Guarantee Fee Payment Group created by.*").JavaTree("attached text:=Drill down to mark notices")'
LIQ_SBLCGuaranteeFeePaymentGroup_Edit_Button = 'JavaWindow("title:=SBLC/Guarantee Fee Payment Group created by.*").JavaButton("label:=Edit Highlighted Notices")'
LIQ_SBLCGuaranteeFeePaymentGroup_Exit_Button = 'JavaWindow("title:=SBLC/Guarantee Fee Payment Group created by.*").JavaButton("label:=Exit")'
LIQ_SBLCGuaranteeFeePaymentGroup_Notice_Window = 'JavaWindow("title:=SBLC/Guarantee Fee Payment created by.*")'
LIQ_SBLCGuaranteeFeePaymentGroup_File_Preview = 'JavaWindow("title:=SBLC/Guarantee Fee Payment Group created by.*").JavaMenu("label:=File").JavaMenu("label:=Preview")'


# Outstanding Select Locators
LIQ_OutstandingSelect_Submenu = 'JavaWindow("title:=Deal Notebook.*","displayed:=1").JavaMenu("label:=Queries").JavaMenu("label:=Outstanding Select...")'
LIQ_OutstandingSelect_Window = 'JavaWindow("title:=Outstanding Select.*","displayed:=1")'
LIQ_OutstandingSelect_New_RadioButton = 'JavaWindow("title:=Outstanding Select.*","displayed:=1").JavaRadioButton("attached text:=New")'
LIQ_OutstandingSelect_Existing_RadioButton = 'JavaWindow("title:=Outstanding Select.*","displayed:=1").JavaRadioButton("attached text:=Existing")'
LIQ_OutstandingSelect_Pending_RadioButton = 'JavaWindow("title:=Outstanding Select.*","displayed:=1").JavaRadioButton("attached text:=Pending Transactions")'
LIQ_OutstandingSelect_Type_Dropdown = 'JavaWindow("title:=Outstanding Select.*","displayed:=1").JavaList("attached text:=Type:")'
LIQ_OutstandingSelect_Facility_Dropdown = 'JavaWindow("title:=Outstanding Select.*","displayed:=1").JavaList("attached text:=Facility:")'
LIQ_OutstandingSelect_PricingOption_Dropdown = 'JavaWindow("title:=Outstanding Select.*","displayed:=1").JavaList("attached text:=Pricing Option:")'
LIQ_OutstandingSelect_Currency_Dropwdown = 'JavaWindow("title:=Outstanding Select.*","displayed:=1").JavaList("attached text:=Currency:")'
LIQ_OutstandingSelect_Alias_JavaEdit = 'JavaWindow("title:=Outstanding Select.*","displayed:=1").JavaEdit("attached text:=Alias:")'
LIQ_OutstandingSelect_Borrower_Dropdown = 'JavaWindow("title:=Outstanding Select.*","displayed:=1").JavaList("attached text:=Borrower:")'
LIQ_OutstandingSelect_Deal_JavaButton = 'JavaWindow("title:=Outstanding Select.*","displayed:=1").JavaButton("attached text:=Deal:")'
LIQ_OutstandingSelect_Deal_JavaEdit = 'JavaWindow("title:=Outstanding Select.*","displayed:=1").JavaEdit("tagname:=Text","index:=0")'

LIQ_OutstandingSelect_Search_Button = 'JavaWindow("title:=Outstanding Select.*","displayed:=1").JavaButton("label:=Search.*")'
LIQ_OutstandingSelect_OK_Button = 'JavaWindow("title:=Outstanding Select.*","displayed:=1").JavaButton("label:=OK.*")'
LIQ_OutstandingSelect_Warning_Yes_Button = 'JavaWindow("title:=Warning.*","displayed:=1").JavaButton("label:=Yes.*")'
LIQ_OutstandingSelect_InformationalMessage_OK_Button = 'JavaWindow("title:=Informational Message.*","displayed:=1").JavaButton("label:=OK.*")'
LIQ_ExistingOutstandingSelect_JavaTree = 'JavaWindow("title:=Existing Standby Letters of Credit.*","displayed:=1").JavaTree("attached text:=Drill down to.*")'

# SBLC Locators
LIQ_SBLCIssuance_Window = 'JavaWindow("title:=New Bank Guarantee.*","displayed:=1")'
LIQ_SBLCIssuance_Requested_TextField = 'JavaWindow("title:=New Bank Guarantee.*","displayed:=1").JavaEdit("attached text:=Requested:")'
LIQ_SBLCIssuance_EffectiveDate_TextField = 'JavaWindow("title:=New Bank Guarantee.*","displayed:=1").JavaEdit("attached text:=Effective Date:")'
LIQ_SBLCIssuance_EnteredExpiry_TextField = 'JavaWindow("title:=New Bank Guarantee.*","displayed:=1").JavaEdit("attached text:=Entered Expiry:")'
LIQ_SBLCIssuance_ExpiryDate_TextField = 'JavaWindow("title:=New Bank Guarantee.*","displayed:=1").JavaEdit("attached text:=Entered Expiry:")'

LIQ_SBLCIssuance_AdjustextExpiry_TextField = 'JavaWindow("title:=New Bank Guarantee.*","displayed:=1").JavaEdit("attached text:=Adjusted Expiry:")' 
LIQ_SBLCIssuance_Rates_Tab = 'JavaWindow("title:=New Bank Guarantee.*","displayed:=1").JavaTab("tagname:=TabFolder")'
LIQ_SBLCIssuance_FeeOnLenderShares_AccrualRules_CycleFrequency_Dropdown = 'JavaWindow("title:=New Bank Guarantee.*").JavaList("attached text:=Cycle Frequency:","labeled_containers_path:=.*Fee on Lender Shares.*")'
LIQ_SBLCIssuance_FeeOnLenderShares_PricingFormula_Button = 'JavaWindow("title:=New Bank Guarantee.*","displayed:=1").JavaObject("tagname:=Group","text:=Fee on Lender Shares.*").JavaButton("label:=Pricing Formula.*")'
LIQ_SBLCIssuance_FeeOnIssuingBankShares_PricingFormula_Button = 'JavaWindow("title:=New Bank Guarantee.*","displayed:=1").JavaObject("tagname:=Group","text:=Fee on Issuing Bank Shares.*").JavaButton("label:=Pricing Formula.*")'
LIQ_SBLCIssuance_FeeOnLenderShares_PricingFormula_OK_Button = 'JavaWindow("title:=Pricing Formula.*","displayed:=1").JavaButton("label:=OK.*")'
LIQ_SBLCIssuance_FeeOnIssuingBankShares_PricingFormula_OK_Button = 'JavaWindow("title:=Pricing Formula.*","displayed:=1").JavaButton("label:=OK.*")'
LIQ_SBLCIssuance_FeeOnLenderShares_PricingFormula_Window = 'JavaWindow("title:=Pricing Formula.*","displayed:=1")'
LIQ_SBLCIssuance_FeeOnIssuingBankShares_PricingFormula_Window = 'JavaWindow("title:=Pricing Formula.*","displayed:=1")'
LIQ_SBLCIssuance_FeeOnLenderShares_PricingFormula_Label = 'JavaWindow("title:=Pricing Formula.*","displayed:=1").JavaEdit("tagname:=icon")'
LIQ_SBLCIssuance_FeeOnIssuingBankShares_PricingFormula_Label = 'JavaWindow("title:=Pricing Formula.*","displayed:=1").JavaEdit("tagname:=icon")'
LIQ_SBLCIssuance_FeeOnLenderShares_EnableCheckbox = 'JavaWindow("title:=New Bank Guarantee.*","displayed:=1").JavaObject("tagname:=Group","text:=Fee on Lender Shares.*").JavaCheckbox("label:=Enable.*")'
LIQ_SBLCIssuance_FeeOnLenderShares_Type_Dropdown = 'JavaWindow("title:=New Bank Guarantee.*","displayed:=1").JavaObject("tagname:=Group","text:=Fee on Lender Shares.*").JavaList("attached text:=Type.*")'

LIQ_SBLCIssuance_Banks_Tab = 'JavaWindow("title:=New Bank Guarantee.*","displayed:=1").JavaTab("tagname:=TabFolder")'
LIQ_SBLCIssuance_Beneficiaries_Add_Button = 'JavaWindow("title:=New Bank Guarantee.*","displayed:=1").JavaObject("tagname:=Group","text:=Beneficiaries:.*").JavaButton("label:=Add Ben..*")'
LIQ_SBLCIssuance_CustomerSelect_Window = 'JavaWindow("title:=Customer Select.*","displayed:=1")'
LIQ_SBLCIssuance_CustomerSelect_TextField = 'JavaWindow("title:=Customer Select.*","displayed:=1").JavaEdit("tagname:=Text.*")'
LIQ_SBLCIssuance_CustomerSelect_OK_Button = 'JavaWindow("title:=Customer Select.*","displayed:=1").JavaButton("label:=OK.*")'
LIQ_SBLCIssuance_Beneficiaries_Customer_Record_JavaTree = 'JavaWindow("title:=New Bank Guarantee.*","displayed:=1").JavaObject("tagname:=Group","text:=Beneficiaries:.*").JavaTree("attached text:=Drill down to.*")'

LIQ_SBLCIssuance_PreferredRemittanceInstruction = 'JavaWindow("title:=New Bank Guarantee.*","displayed:=1").JavaButton("attached text:=Preferred Remittance Instructions.*")'

LIQ_SBLCIssuance_Save_Submenu = 'JavaWindow("title:=New Bank Guarantee.*","displayed:=1").JavaMenu("label:=File").JavaMenu("label:=Save")'
LIQ_SBLCIssuance_Warning_Yes = 'JavaWindow("title:=Warning.*","displayed:=1").JavaButton("label:=Yes.*")'

LIQ_SBLCIssuance_Workflow_Tab = 'JavaWindow("title:=New Bank Guarantee.*","displayed:=1").JavaTab("tagname:=TabFolder")'
LIQ_SBLCIssuance_GenerateIntentNotices_ListItem = 'JavaWindow("title:=New Bank Guarantee.*","displayed:=1").JavaTree("attached text:=Drill down to.*")'
LIQ_SBLCIssuance_SendToApproval_ListItem = 'JavaWindow("title:=New Bank Guarantee.*","displayed:=1").JavaTree("attached text:=Drill down to.*")'
LIQ_SBLCIssuance_Release_ListItem = 'JavaWindow("title:=New Bank Guarantee.*","displayed:=1").JavaTree("attached text:=Drill down to.*")'
LIQ_SBLCIssuance_Warning_Yes_Button = 'JavaWindow("title:=Warning.*","displayed:=1").JavaButton("label:=Yes.*")'
LIQ_SBLCIssuance_Question_Yes_Button = 'JavaWindow("title:=Question.*","displayed:=1").JavaButton("label:=Yes.*")'
LIQ_SBLCIssuance_Workflow_ListItem = 'JavaWindow("title:=New Bank Guarantee.*","displayed:=1").JavaTree("attached text:=Drill down to.*")'

LIQ_SBLCIssuance_Codes_Purpose = 'JavaWindow("title:=New Bank Guarantee.*","displayed:=1").JavaList("attached text:=Purpose.*")'

LIQ_SBLC_Intent_Notice_Window = 'JavaWindow("title:=SBLC/Guarantee Issuance Intent Notice Group.*","displayed:=1")'
LIQ_SBLC_EditHighlightedNotice_Button = 'JavaWindow("title:=SBLC/Guarantee Issuance Intent Notice Group.*","displayed:=1").JavaButton("label:=Edit Highlighted Notice.*")'
LIQ_SBLC_Intent_Notice_List = 'JavaWindow("title:=SBLC/Guarantee Issuance Intent Notice Group.*","displayed:=1").JavaTree("attached text:=Drill down to.*")'
LIQ_SBLC_Intent_Notice_Exit_Button = 'JavaWindow("title:=SBLC/Guarantee Issuance Intent Notice Group.*","displayed:=1").JavaButton("label:=Exit.*")'

#### Rate Setting Notice Group
LIQ_RateSettingNoticeGroup_EditHighlightedNotice_Button = 'JavaWindow("title:=Rate Setting Notice Group.*","displayed:=1").JavaButton("label:=Edit Highlighted Notice.*")'
LIQ_RateSetting_Notice_Email_Window = 'JavaWindow("title:=Rate Setting Notice created.*","displayed:=1")'
LIQ_RateSetting_Notice_FileMenu_PreviewMenu = 'JavaWindow("title:=Rate Setting Notice created.*","displayed:=1").JavaMenu("index:=0").JavaMenu("label:=Preview")'
LIQ_RateSettingNoticeGroup_Exit_Button = 'JavaWindow("title:=Rate Setting Notice Group.*","displayed:=1").JavaButton("label:=Exit.*")'
LIQ_RateSettingNoticeGroup_Table = 'JavaWindow("title:=Rate Setting Notice Group.*","displayed:=1").JavaTree("attached text:=Drill down to.*")'

#### Interest Payment Notice
LIQ_InterestPayment_Notice_FileMenu_PreviewMenu = 'JavaWindow("title:=Interest Payment Notice created.*","displayed:=1").JavaMenu("index:=0").JavaMenu("label:=Preview")'
LIQ_InterestPayment_Notice_Email_Window = 'JavaWindow("title:=Interest Payment Notice created.*","displayed:=1")'
LIQ_InterestPayment_Notice_Exit_Button = 'JavaWindow("title:=Interest Payment Notice Group created.*","displayed:=1").JavaButton("label:=Exit.*")'


LIQ_SBLC_Intent_Notice_FileMenu_PreviewMenu = 'JavaWindow("title:=SBLC/Guarantee Issuance Intent Notice created.*","displayed:=1").JavaMenu("index:=0").JavaMenu("label:=Preview")'
LIQ_SBLC_Intent_Notice_Email_Window = 'JavaWindow("title:=SBLC/Guarantee Issuance Intent Notice created.*","displayed:=1")'
LIQ_SBLC_Intent_Notice_Customer_TextField = 'JavaWindow("title:=SBLC/Guarantee Issuance Intent Notice created.*","displayed:=1").JavaEdit("text:=JORDAN BRAND INC")'
LIQ_SBLC_Intent_Notice_Status_Label = 'JavaWindow("title:=SBLC/Guarantee Issuance Intent Notice created.*","displayed:=1").JavaObject("tagname:=Group","text:=Status").JavaStaticText("text:=Awaiting release")'


LIQ_SBLC_NoticePreview_FileMenu_ExitMenu = 'JavaWindow("title:=Notice Preview.*","displayed:=1").JavaMenu("index:=0").JavaMenu("label:=Exit")'

LIQ_SBLCIssuance_Events_Tab = 'JavaWindow("title:=Bank Guarantee.*","displayed:=1").JavaTab("tagname:=TabFolder")'
LIQ_SBLCIssuance_Events_ListItem = 'JavaWindow("title:=Bank Guarantee.*","displayed:=1").JavaTree("attached text:=Select event.*")'

LIQ_SBLCIssuance_SBLCNotebook_Submenu = 'JavaWindow("title:=New Bank Guarantee.*","displayed:=1").JavaMenu("label:=Options").JavaMenu("label:=SBLC Notebook")'
LIQ_SBLC_Window = 'JavaWindow("title:=SBLC.*","displayed:=1")'
LIQ_SBLC_PerformOnlineAccrual_Submenu = 'JavaWindow("title:=SBLC.*","displayed:=1").JavaMenu("label:=Accounting").JavaMenu("label:=Perform Online Accrual")'

LIQ_SBLC_UpdateMode_Button = 'JavaWindow("title:=Bank Guarantee.*","displayed:=1").JavaButton("label:=Notebook in Inquiry Mode.*")'

LIQ_SBLC_Warning_Yes_Button = 'JavaWindow("title:=Warning.*","displayed:=1").JavaButton("label:=Yes.*")'
LIQ_SBLC_InformationalMessage_OK_Button = 'JavaWindow("title:=Informational Message.*","displayed:=1").JavaButton("label:=OK.*")'

LIQ_SBLC_DealName_Label = 'JavaWindow("title:=SBLC.*","displayed:=1").JavaStaticText("attached text:=T_EVERSBLC1 BIDEAL.*")'
LIQ_SBLC_Facility_Label = 'JavaWindow("title:=SBLC.*","displayed:=1").JavaStaticText("attached text:=T_EVER 3MM.*")'
LIQ_SBLC_PerformingStatus_Label = 'JavaWindow("title:=SBLC.*","displayed:=1").JavaStaticText("label:=Accrual.*")'

LIQ_Pending_SBLC_Window = 'JavaWindow("title:=Pending SBLC/Guarantee.*","displayed:=1")'
LIQ_Pending_SBLC_JavaTree = 'JavaWindow("title:=Pending SBLC/Guarantee.*","displayed:=1").JavaTree("attached text:=Drill down to.*")'

LIQ_Existing_Standby_Letters = 'JavaWindow("title:=Existing Standby Letters.*","displayed:=1")'
LIQ_Existing_Standby_Letters_JavaTree = 'JavaWindow("title:=Existing Standby Letters.*","displayed:=1").JavaTree("attached text:=Drill down to.*")'
LIQ_Bank_Guarantee_Window = 'JavaWindow("title:=Bank Guarantee.*","displayed:=1")'
LIQ_Bank_Guarantee_Update_Button = 'JavaWindow("title:=Bank Guarantee.*","displayed:=1").JavaButton("label:=Notebook in Inquiry Mode.*")'
LIQ_Bank_Guarantee_Draw_Tab = 'JavaWindow("title:=Bank Guarantee.*","displayed:=1").JavaTab("tagname:=TabFolder")'

LIQ_Bank_Guarantee_Create_Button = 'JavaWindow("title:=Bank Guarantee.*","displayed:=1").JavaObject("tagname:=Group","text:=Draws.*").JavaButton("label:=Create.*")'

LIQ_Generic_OneLiner_Warning_Window = 'JavaWindow("title:=Warning.*","displayed:=1").JavaEdit("attached text:=WARNING", "height:=68")' 
LIQ_Generic_MultiLine_Warning_Window = 'JavaWindow("title:=Warning.*","displayed:=1").JavaEdit("attached text:=WARNING", "height:=84")'
LIQ_Generic_RichText_Warning_Window = 'JavaWindow("title:=Warning.*","displayed:=1").JavaEdit("attached text:=WARNING", "height:=100")'
LIQ_Generic_Multiline_Richtext_Warning_Window = 'JavaWindow("title:=Warning.*","displayed:=1").JavaEdit("attached text:=WARNING", "height:=132")'
LIQ_Generic_OneLiner_Warning_Yes_Button = 'JavaWindow("title:=Warning.*","displayed:=1").JavaButton("label:=Yes.*")'
LIQ_Generic_Question_Window = 'JavaWindow("title:=Question.*","displayed:=1").JavaEdit("attached text:=QUESTION","height:=68")'
LIQ_Generic_Question_Yes_Button = 'JavaWindow("title:=Question.*","displayed:=1").JavaButton("label:=Yes.*")'
LIQ_Generic_InformationalMessage_Window = 'JavaWindow("title:=Informational Message.*","displayed:=1")'
LIQ_InformationalMessage_OK_Button = 'JavaWindow(title:=Informational Message.*", "displayed:=1").JavaButton("label:=OK")'

LIQ_BankGuarantee_Window = 'JavaWindow("title:=Bank Guarantee.*","displayed:=1")'
LIQ_BankGuarantee_Accrual_JavaTree = 'JavaWindow("title:=Bank Guarantee.*").JavaTab("text:=Accrual").JavaTree("labeled_containers_path:=.*Issuance Fee.*")'
LIQ_BankGuarantee_RequestedAmount_Field = 'JavaWindow("title:=Bank Guarantee.*Pending").JavaEdit("index:=0","enabled:=1","tagname:=Text","labeled_containers_path:=.*Group.*Amounts.*")'
LIQ_ActiveSBLC_Rates_Tab = 'JavaWindow("title:=Bank Guarantee.*","displayed:=1").JavaTab("tagname:=TabFolder")'
LIQ_ActiveSBLC_Rates_StartDate = 'JavaWindow("title:=Bank Guarantee.*","displayed:=1").JavaObject("tagname:=Group","text:=Fee on Lender Shares.*").JavaObject("tagname:=Group","text:=Accrual Rules.*").JavaEdit("attached text:=Start Date:")'
LIQ_ActiveSBLC_Accrual_Tab = 'JavaWindow("title:=Bank Guarantee.*","displayed:=1").JavaTab("tagname:=TabFolder")'
LIQ_SBLC_PerformOnlineAccrual_Menu = 'JavaWindow("title:=Bank Guarantee.*","displayed:=1").JavaMenu("label:=Accounting").JavaMenu("label:=Perform Online Accrual")'

LIQ_ActiveSBLC_FrontinUsageFee_JavaTree = 'JavaWindow("title:=Bank Guarantee.*","displayed:=1").JavaObject("tagname:=Group","text:=Fronting Usage Fee.*").JavaTree("tagname:=Drill down to.*")'
LIQ_ActiveSBLC_IssuanceFee_JavaTree = 'JavaWindow("title:=Bank Guarantee.*","displayed:=1").JavaObject("tagname:=Group","text:=Issuance Fee.*").JavaTree("tagname:=Drill down to.*")'
LIQ_BankGuarantee_AccrualCCY_Text = 'JavaWindow("title:=Bank Guarantee.*").JavaList("attached text:=Accrual Currency:")'
LIQ_BankGuarantee_FeeType_Dropdown = 'JavaWindow("title:=Bank Guarantee.*").JavaObject("tagname:=Group","text:=Fee on Lender Shares.*").JavaList("attached text:=Type:")'
LIQ_ActiveSBLC_Rates_EndDate = 'JavaWindow("title:=Bank Guarantee.*","displayed:=1").JavaObject("tagname:=Group","text:=Fee on Lender Shares.*").JavaObject("tagname:=Group","text:=Accrual Rules.*").JavaEdit("attached text:=End Date:")'
LIQ_ActiveSBLC_Rates_AdjustedDueDate = 'JavaWindow("title:=Bank Guarantee.*","displayed:=1").JavaObject("tagname:=Group","text:=Fee on Lender Shares.*").JavaObject("tagname:=Group","text:=Accrual Rules.*").JavaEdit("attached text:=Adjusted Due Date:")'
LIQ_ActiveSBLC_Currency_Text = 'JavaWindow("title:=Bank Guarantee.*").JavaStaticText("index:=0","enabled:=1","labeled_containers_path:=Tab:General;Group:Amounts;", "Index:=4")'
LIQ_ActiveSBLC_RiskType_Text = 'JavaWindow("title:=Bank Guarantee.*").JavaEdit("enabled:=1","labeled_containers_path:=Tab:General;", "index:=0")'
LIQ_ActiveSBLC_EffectiveDate_Text = 'JavaWindow("title:=Bank Guarantee.*").JavaStaticText("x:=569", "index:=157")'
LIQ_Active_AdjustextExpiry_Text = 'JavaWindow("title:=Bank Guarantee.*").JavaEdit("attached text:=Adjusted Expiry:")' 
LIQ_ActiveSBLC_HostBankGross_Text = 'JavaWindow("title:=Bank Guarantee.*").JavaEdit("attached text:=Host Bank Gross:")'
LIQ_ActiveSBLC_HostBankNet_Text = 'JavaWindow("title:=Bank Guarantee.*").JavaEdit("attached text:=Host Bank Net:")'
LIQ_ActiveSBLC_GlobalOriginal_Text = 'JavaWindow("title:=Bank Guarantee.*").JavaEdit("attached text:=Global Original:")'
LIQ_ActiveSBLC_GlobalCurrent_Text = 'JavaWindow("title:=Bank Guarantee.*").JavaEdit("attached text:=Global Current:")'
LIQ_Active_Beneficiaries_JavaTree = 'JavaWindow("title:=Bank Guarantee.*").JavaTree("attached text:=Drill down to set Servicing Group", "labeled_containers_path:=Tab:Banks;Group:Beneficiaries:;")'



