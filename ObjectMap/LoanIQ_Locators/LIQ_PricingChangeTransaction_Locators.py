###Pricing Change Transaction Notebook ####
LIQ_PendingPricingChangeTransaction_Window = 'JavaWindow("title:=Pending Pricing Change Transaction")'
LIQ_PricingChangeTransaction_Window = 'JavaWindow("title:=.*Pricing Change Transaction.*")'
LIQ_PricingChangeTransaction_Tab = 'JavaWindow("title:=.*Pricing Change Transaction.*").JavaTab("tagname:=TabFolder")'
LIQ_PricingChangeTransaction_File_Exit = 'JavaWindow("title:=.*Pricing Change Transaction.*").JavaMenu("label:=File").JavaMenu("label:=Exit")'
LIQ_PricingChangeTransaction_File_Save = 'JavaWindow("title:=.*Pricing Change Transaction.*").JavaMenu("label:=File").JavaMenu("label:=Save")'
LIQ_PricingChangeTransaction_General_Tab = 'JavaWindow("title:=.*Pricing Change Transaction.*").JavaTab("tagname:=TabFolder", "value:=General")'
LIQ_PricingChangeTransaction_GeneralTab_DealName = 'JavaWindow("title:=.*Pricing Change Transaction.*").JavaStaticText("attached text:=${Deal_Name}")'
LIQ_PricingChangeTransaction_GeneralTab_FacilityName = 'JavaWindow("title:=.*Pricing Change Transaction.*").JavaStaticText("attached text:=${Facility_Name}")'
LIQ_PricingChangeTransaction_GeneralTab_TransactionNumber = 'JavaWindow("title:=.*Pricing Change Transaction.*").JavaEdit("attached text:=Transaction Number:", "value:=${PricingChange_TransactionNo}")'
LIQ_PricingChangeTransaction_GeneralTab_EffectiveDate = 'JavaWindow("title:=.*Pricing Change Transaction.*").JavaEdit("attached text:=Effective Date:", "value:=${PricingChange_EffectiveDate}")'
LIQ_PricingChangeTransaction_GeneralTab_PricingChangeDescription = 'JavaWindow("title:=.*Pricing Change Transaction.*").JavaEdit("attached text:=Pricing Change Description:", "value:=${PricingChange_Desc}")'

###Pricing Change Transaction - General Tab###
LIQ_PricingChangeTransaction_TransactionNo_Textfield = 'JavaWindow("title:=.*Pricing Change Transaction.*").JavaEdit("attached text:=Transaction Number:")'
LIQ_PricingChangeTransaction_EffectDate_Datefield = 'JavaWindow("title:=.*Pricing Change Transaction.*").JavaEdit("attached text:=Effective Date:")'
LIQ_PricingChangeTransaction_Description_Textfield = 'JavaWindow("title:=.*Pricing Change Transaction.*").JavaEdit("attached text:=Pricing Change Description:")'
LIQ_PricingChangeTransaction_TransactionNo_Textfield = 'JavaWindow("title:=.*Pricing Change Transaction.*").JavaEdit("attached text:=Transaction Number:")'

###Pricing Change Transaction - Pricing Tab###
LIQ_Pricing_OngoingFees_Pricing_Tab = 'JavaWindow("title:=.*Pricing Change Transaction.*").JavaTab("tagname:=TabFolder", "value:=Pricing")'
LIQ_Pricing_OngoingFees_AddItemList = 'JavaWindow("title:=Add Item").JavaList("tagname:=List","index:=0")'
LIQ_Pricing_OngoingFees_Type = 'JavaWindow("title:=Add Item").JavaList("attached text:=Type:")'
LIQ_Pricing_OngoingFees_AddItem_OK_Button = 'JavaWindow("title:=Add Item").JavaButton("label:=OK")'
LIQ_Pricing_OngoingFees_FeeSelection_OK_Button = 'JavaWindow("title:=Fee Selection").JavaButton("label:=OK")'
LIQ_Pricing_OngoingFees_After_AddItemList = 'JavaWindow("title:=Add Item").JavaList("tagname:=List","index:=0")'
LIQ_Pricing_OngoingFees_FomulaCategory_Type = 'JavaWindow("title:=Add Item").JavaList("attached text:=Type:")'
LIQ_Pricing_OngoingFees_FormulaCategory_Percent_Radiobutton = 'JavaWindow("title:=Formula Category").JavaRadioButton("attached text:=Percent")'
LIQ_Pricing_OngoingFees_FormulaCategory_Percent_Textfield = 'JavaWindow("title:=Formula Category").JavaEdit("tagname:=X","index:=1")'
LIQ_Pricing_OngoingFees_FormulaCategory_OK_Button = 'JavaWindow("title:=Formula Category").JavaButton("attached text:=OK")'

LIQ_PricingChangeTransaction_ModifyOngoingFees_Button = 'JavaWindow("title:=.*Pricing Change Transaction.*").JavaButton("attached text:=Modify Ongoing Fees...")'
LIQ_PricingChangeTransaction_OngoingFees_Add_Button = 'JavaWindow("title:=.*Ongoing Fee Pricing.*").JavaButton("attached text:=Add")'
LIQ_PricingChangeTransaction_OngoingFees_After_Button = 'JavaWindow("title:=.*Ongoing Fee Pricing.*").JavaButton("attached text:=After")'
LIQ_PricingChangeTransaction_OngoingFees_OK_Button = 'JavaWindow("title:=.*Ongoing Fee Pricing.*").JavaButton("attached text:=OK")'
LIQ_PricingChangeTransaction_FeeSelection_CategoryList = 'JavaWindow("title:=Fee Selection").JavaList("attached text:=Category:")'
LIQ_PricingChangeTransaction_FeeSelection_TypeList = 'JavaWindow("title:=Fee Selection").JavaList("attached text:=Type:")'
LIQ_PricingChangeTransaction_FeeSelection_RateBasisList = 'JavaWindow("title:=Fee Selection").JavaList("attached text:=Rate Basis:")'
LIQ_FormulaCatergory_Window = 'JavaWindow("title:=Formula Category")'
LIQ_FeeSelection_Window = 'JavaWindow("title:=Fee Selection")'
LIQ_PricingChangeTransaction_OngoingFeePricing_Window = 'JavaWindow("title:=.*Ongoing Fee Pricing.*")'
LIQ_PricingChangeTransaction_ModifyInterestPricing_Button = 'JavaWindow("title:=.*Pricing Change Transaction.*").JavaButton("attached text:=Modify Interest Pricing.*")'
LIQ_PricingChangeTransaction_InterestPricing_Add_Button = 'JavaWindow("title:=.*Interest Pricing.*").JavaButton("label:=Add")'
LIQ_PricingChangeTransaction_InterestPricing_StaticText = 'JavaWindow("title:=.*Pricing Change Transaction.*").JavaTree("attached text:=Split Tiered:")'
LIQ_PricingChangeTransaction_InterestPricing_OK_Button = 'JavaWindow("title:=.*Interest Pricing.*").JavaButton("label:=OK")'
LIQ_PricingChangeTransaction_InterestPricing_MatrixOnly_RadioButton = 'JavaWindow("title:=.*Interest Pricing.*").JavaRadioButton("label:=Matrix Only")'
LIQ_PricingChangeTransaction_InterestPricing_OptionOnly_RadioButton = 'JavaWindow("title:=.*Interest Pricing.*").JavaRadioButton("label:=Options Only")'
LIQ_PricingChangeTransaction_InterestPricing_JavaTree = 'JavaWindow("title:=.*Interest Pricing.*").JavaTree("displayed:=1")'
LIQ_AddItem_OptionName_List = 'JavaWindow("title:=Add Item").JavaList("attached text:=Option Name:")'    
LIQ_AddItem_RateBasis_List = 'JavaWindow("title:=Add Item").JavaList("attached text:=Rate Basis:")'   
LIQ_AddItem_Cancel_Button =  'JavaWindow("title:=Add Item").JavaButton("attached text:=Cancel")' 

LIQ_PricingChangeTransaction_WarningMessage_StaticText = 'JavaWindow("title:=Warning.*","displayed:=1").JavaEdit("attached text:=WARNING", "height:=68")'
LIQ_PricingChangeTransaction_SendToApprovalWarningMessage_StaticText = 'JavaWindow("title:=Warning.*","displayed:=1").JavaEdit("attached text:=WARNING", "height:=68")'
LIQ_PricingChangeTransaction_ReleaseWarningMessage_StaticText = 'JavaWindow("title:=Warning.*","displayed:=1").JavaEdit("attached text:=WARNING", "height:=84")'
LIQ_PricingChangeTransaction_ApprovalWarningMessage_StaticText = 'JavaWindow("title:=Warning.*","displayed:=1").JavaEdit("attached text:=WARNING", "height:=68")'
LIQ_PricingChangeTransaction_QuestionMessage_StaticText = 'JavaWindow("title:=Question.*","displayed:=1").JavaEdit("attached text:=QUESTION")'
LIQ_PricingChangeTransaction_PricingTab_OngoingFee = 'JavaWindow("title:=.*Pricing Change Transaction.*").JavaTab("attached text:=Split Tiered:").JavaTree("index:=0")'

###Pricing Change Transaction - Workflow Tab###
LIQ_PricingChangeTransaction_WorkflowAction = 'JavaWindow("title:=.*Pricing Change Transaction.*").JavaTree("attached text:=Drill down to perform Workflow item")'


###Pricing Change Transaction - Events Tab###
LIQ_PricingChangeTransaction_Event = 'JavaWindow("title:=.*Pricing Change Transaction.*").JavaTree("attached text:=Select event to view details")'
LIQ_PricingChangeTransaction_Create_Event = 'JavaWindow("title:=.*Pricing Change Transaction.*").JavaTree("attached text:=Select event to view details", "developer name:=.*${Created_Event}.*")'
LIQ_PricingChangeTransaction_OngoingFeePricingChanged_Event = 'JavaWindow("title:=.*Pricing Change Transaction.*").JavaTree("attached text:=Select event to view details", "developer name:=.*${OngoingFeePricingChanged_Event}.*")'

###Available Pricing Window###
LIQ_PCT_AvailablePricing_Window= 'JavaWindow("title:=Available Pricing")'
LIQ_PCT_AvailablePricing_List= 'JavaWindow("title:=Available Pricing").JavaTree("tagname:=Tree")'
LIQ_PCT_AvailablePricing_OK_Button= 'JavaWindow("title:=Available Pricing").JavaButton("attached text:=OK")'
LIQ_PCT_AwaitingApproval_Window = 'JavaWindow("title:=Awaiting Approval.*")'
LIQ_PCT_AwaitingRelease_Window = 'JavaWindow("title:=Awaiting Release.*")'
LIQ_PCT_Released_Window = 'JavaWindow("title:=Released Pricing Change.*")'

###Pricing Change Transaction Notebook via FCT - General Tab###
LIQ_PricingChangeTransaction_Notebook= 'JavaWindow("title:=.* Pricing Change Transaction")'
LIQ_PCT_Tab= 'JavaWindow("title:=.* Pricing Change Transaction").JavaTab("Tagname:=TabFolder")'
LIQ_PCT_TransactionNo= 'JavaWindow("title:=.* Pricing Change Transaction").JavaEdit("attached text:=Transaction Number:")'
LIQ_PCT_EffectiveDate= 'JavaWindow("title:=.* Pricing Change Transaction").JavaEdit("attached text:=Effective Date:")'
LIQ_PCT_Description= 'JavaWindow("title:=.* Pricing Change Transaction").JavaEdit("attached text:=Pricing Change Description:")'
LIQ_PCT_ModifyInterestPricing_Button= 'JavaWindow("title:=.* Pricing Change Transaction").JavaButton("attached text:=Modify Interest Pricing\.\.\.")'
LIQ_PCT_InterestPricing_Add_Button= 'JavaWindow("title:= .* Interest Pricing").JavaButton("attached text:=Add")'
LIQ_PCT_InterestPricing_After_Button= 'JavaWindow("title:= .* Interest Pricing").JavaButton("attached text:=After")'
LIQ_PCT_InterestPricing_List= 'JavaWindow("title:= .* Interest Pricing").JavaTree("tagname:=Tree")'
LIQ_PCT_InterestPricing_Validate_Button= 'JavaWindow("title:= .* Interest Pricing").JavaButton("attached text:=Validate")'
LIQ_PCT_InterestPricing_OK_Button=  'JavaWindow("title:= .* Interest Pricing").JavaButton("attached text:=OK")'
LIQ_PCT_InterestPricing_Clear_Button = 'JavaWindow("title:= .* Interest Pricing").JavaButton("attached text:=Clear")'

###Pricing Change Transaction Notebook via FCT - Workflow Tab###
LIQ_PCT_Workflow_JavaTree= 'JavaWindow("title:=.* Pricing Change Transaction").JavaTab("tagname:=TabFolder").JavaTree("attached text:=Drill down to perform Workflow item")'
LIQ_WorkInProcess_TransactionStatus_FacilityList= 'JavaWindow("title:=Transactions In Process.*").JavaTab("tagname:=TabFolder").JavaTree("labeled_containers_path:=Group:Details;Tab:Facilities;")'
LIQ_PCTNotebookReleased_Window= 'JavaWindow("title:=Released Pricing Change Transaction")'
LIQ_PCTNotebookReleased_WorkflowTab_NoItems= 'JavaWindow("title:=Released Pricing Change Transaction").JavaTree("attached text:=Drill down to perform Workflow item","items count:=0")'
LIQ_PCTNotebookReleased_FileExit_Menu= 'JavaWindow("title:=Released Pricing Change Transaction").JavaMenu("label:=File").JavaMenu("label:=Exit")'

###Pricing Change Transaction - Ongoing Fee Pricing Window###
LIQ_PricingChangeTransaction_OngoingFeePricingWindow_Item_Javatree = 'JavaWindow("title:=.*Ongoing Fee Pricing").JavaTree("tagname:=Tree")'
LIQ_PricingChangeTransaction_OngoingFeePricingWindow_FacilityOngoingFee_Item = 'JavaWindow("title:=.*Ongoing Fee Pricing").JavaTree("tagname:=Tree", "developer name:=.*${PricingChange_OngoingFeeStr}.*")'
LIQ_PricingChangeTransaction_OngoingFeePricingWindow_UnutilizedXRateValue_Item = 'JavaWindow("title:=.*Ongoing Fee Pricing").JavaTree("tagname:=Tree", "developer name:=.*${UnutilizedRate}.*")'
LIQ_PricingChangeTransaction_OngoingFeePricingWindow_GlobalCurrentXRateValue_Item = 'JavaWindow("title:=.*Ongoing Fee Pricing").JavaTree("tagname:=Tree", "developer name:=.*${GlobalRate}.*")'

###Pricing Change Transaction - Interest Pricing Window###
LIQ_PricingChangeTransaction_InterestPricing_Window = 'JavaWindow("title:=.*Interest Pricing.*")'
LIQ_PricingChangeTransaction_InterestPricingWindow_Item_Javatree = 'JavaWindow("title:=.*Interest Pricing.*").JavaTree("tagname:=Tree")'
LIQ_PricingChangeTransaction_InterestPricingWindow_InterestPricing_Item = 'JavaWindow("title:=.*Interest Pricing.*").JavaTree("tagname:=Tree", "developer name:=.*${OptionName}.*")'
LIQ_PricingChangeTransaction_InterestPricingWindow_FixRateOptionValue_Item = 'JavaWindow("title:=.*Interest Pricing.*").JavaTree("developer name:=.*${Spread}%.*")'