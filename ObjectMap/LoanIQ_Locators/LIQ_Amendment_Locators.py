###Deal Select Window###  
LIQ_AMD_DealSelect_Name_TextField= 'JavaWindow("title:=Deal Select.*").JavaEdit("tagname:=Text")'

###Amendment List Window###
LIQ_AMD_ShowCancelledTrans_CheckBox= 'JavaWindow("title:=Amendment List for.*").JavaCheckBox("label:=Show Cancelled Transactions")'
LIQ_AMD_ExpandAll_Button= 'JavaWindow("title:=Amendment List for.*").JavaButton("attached text:=Expand All")'
LIQ_AMD_CollapseAll_Button= 'JavaWindow("title:=Amendment List for.*").JavaButton("attached text:=Collapse All")'
LIQ_AMD_OpenNtbk_Button= 'JavaWindow("title:=Amendment List for.*").JavaButton("attached text:=Open Ntbk")'
LIQ_AMD_Add_Button= 'JavaWindow("title:=Amendment List for.*").JavaButton("attached text:=Add")'
LIQ_AMD_Refresh_Button= 'JavaWindow("title:=Amendment List for.*").JavaButton("attached text:=Collapse All")'
LIQ_AMD_Exit_Button= 'JavaWindow("title:=Amendment List for.*").JavaButton("attached text:=Exit")'
LIQ_AMD_JavaTree = 'JavaWindow("title:=Amendment List for.*").JavaTree("attached text:=Drill down on amendments to show transactions.*")'

###AmendMent Notebook###
LIQ_AmendmentNotebook= 'JavaWindow("title:=.* Amendment .*")'
LIQ_AmendmentList_Window= 'JavaWindow("title:=Amendment List for.*")'
LIQ_AmendmentNotebookReleased_Window='JavaWindow("title:=Released Amendment .*")'
LIQ_AmendmentNotebookReleased_FileExit_Menu='JavaWindow("title:=Released Amendment .*").JavaMenu("label:=File").JavaMenu("label:=Exit")'
LIQ_AmendmentNotebookReleased_Tab = 'JavaWindow("title:=Released Amendment .*").JavaTab("tagname:=TabFolder")'
LIQ_AmendmentNotebookPending_Window='JavaWindow("title:=Pending Amendment.*")'
LIQ_AmmendmentNotebook_OptionsAddFacility_Menu='JavaWindow("title:=Pending Amendment.*").JavaMenu("label:=Options").JavaMenu("label:=Add Facility")'
LIQ_AmmendmentNotebook_Add_Button='JavaWindow("title:=.* Amendment.*").JavaButton("labeled_containers_path:=Tab:General;Group:Amendment Transactions.*","label:=Add")'
LIQ_AmmendmentNotebook_WorkflowTab_NoItems= 'JavaWindow("title:=Released Amendment .*").JavaTree("attached text:=Workflow Items","items count:= 0")'
LIQ_AMD_NewTransaction_Window='JavaWindow("title:=New Transaction.*")'
LIQ_NewTran_Facility_Dropdown= 'JavaWindow("title:=New Transaction.*").JavaList("attached text:=Facility.*")'
LIQ_NewTran_TransactionType_Dropdown= 'JavaWindow("title:=New Transaction .*").JavaList("attached text:=Transaction Type:.*")'
LIQ_NewTran_Ok_Button= 'JavaWindow("title:=New Transaction.*").JavaButton("attached text:=OK")'
LIQ_NewTran_Cancel_Button= 'JavaWindow("title:=New Transaction.*").JavaButton("attached text:=Cancel")'
LIQ_AMD_AddTransaction_Window= 'JavaWindow("title:=Add Transaction")'
LIQ_AddTran_Increase_RadioButton= 'JavaWindow("title:=Add Transaction").JavaRadiobutton("attached text:=Increase")'
LIQ_AddTran_Decrease_RadioButton= 'JavaWindow("title:=Add Transaction").JavaRadiobutton("attached text:=Decrease")'
LIQ_AddTran_Amount_Field= 'JavaWindow("title:=Add Transaction").JavaEdit("attached text:=Amount:.*")'
LIQ_AddTran_PercentofCurrentBal_Field= 'JavaWindow("title:=Add Transaction").JavaEdit("attached text:=Percent of Current Balance:.*")'
LIQ_AddTran_EffectiveDate_Field= 'JavaWindow("title:=Add Transaction").JavaEdit("attached text:=Effective Date:.*")'
LIQ_AddTran_OK_Button= 'JavaWindow("title:=Add Transaction").JavaButton("attached text:=OK")'
LIQ_AddTran_Cancel_Button= 'JavaWindow("title:=Add Transaction").JavaButton("attached text:=Cancel")'



###AmendMent Notebook- General Tab###

LIQ_AMD_EffectiveDate= 'JavaWindow("title:=.* Amendment .*").JavaTab("Text:=General").JavaEdit("x:=180","y:=11")'
LIQ_AMD_AmendmentNo= 'JavaWindow("title:=.* Amendment.*").JavaEdit("tagname:=Text","x:=618","y:=11")'
LIQ_AMD_Comment= 'JavaWindow("title:=.* Amendment.*").JavaEdit("labeled_containers_path:=Tab:General;Group:Comment;")'
LIQ_AMD_AmendmentTrans_Section= 'JavaWindow("title:=.* Amendment .*").JavaObject("text:=Amendment Transactions")'
LIQ_AMD_General_Add_Button= 'JavaWindow("title:=.* Amendment .*").JavaButton("attached text:=Add","labeled_containers_path:=Tab:General;Group:Amendment Transactions;")'
LIQ_AMD_General_Delete_Button= 'JavaWindow("title:=.* Amendment .*").JavaButton("attached text:=Delete","labeled_containers_path:=Tab:General;Group:Amendment Transactions;")'
LIQ_AMD_Tab = 'JavaWindow("title:=.* Amendment .*").JavaTab("Tagname:=TabFolder")'
LIQ_AMD_Workflow_JavaTree= 'JavaWindow("title:=.* Amendment .*").JavaTree("attached text:=Workflow Items")'
LIQ_WorkInProcess_TransactionStatus_DealList= 'JavaWindow("title:=Transactions In Process that Satisfy the Filter").JavaTree("attached text:=0")'
LIQ_Amendment_OK_Button= 'JavaWindow("title:=Amendment .*").JavaButton("attached text:=OK")'
###Facility Select###
LIQ_AMD_DealName_FacSelect_TextField= 'JavaWindow("title:=Facility Select.*").JavaEdit("x:=245","y:=75")'
LIQ_AMD_FacilitySelect_Search_Button='JavaWindow("title:=Facility Select").JavaButton("label:=Search")'


###Facility Notebook - Summary Tab###

LIQ_FacilityNotebook_MainSG_Customer= 'JavaWindow("title:=Facility .*").JavaStaticText("attached text:=&{ExcelPath}[MSG_Customer].*")'
LIQ_FacilityNotebook_FileExit_Menu='JavaWindow("title:=Facility .*").JavaMenu("label:=File").JavaMenu("label:=Exit")'

###Facility Notebook- Main Customer Window - Summary Tab###
LIQ_MainCustomer_SG_Button= 'JavaWindow("title:=Main Customer/SG .*").JavaButton("attached text:=Servicing Group")'
LIQ_ServicingGroup_OK_Button= 'JavaWindow("title:=Servicing Groups For.*").JavaButton("label:=OK")'
LIQ_FacilityNotebook_FileSaveFacility_Menu= 'JavaWindow("title:=Facility .*").JavaMenu("label:=File").JavaMenu("label:=Save")'

###Facility Notebook - Restriction Tab###
LIQ_CurrencyDetail_SG_Button= 'JavaWindow("title:=Currency Detail").JavaButton("attached text:=Servicing Group")'
LIQ_CurrencyDetail_PRI_Button='JavaWindow("title:=Currency Detail").JavaButton("attached text:=Preferred Remittance Instructions")'
LIQ_CurrencyDetail_OK_Button= 'JavaWindow("title:=Currency Detail").JavaButton("attached text:=OK")'
LIQ_SGProductCurrency_Customer= 'JavaWindow("title:=Servicing Group For Product Currency").JavaList("attached text:=Customer")'
LIQ_SGProductCurrency_SG_Button= 'JavaWindow("title:=Servicing Group For Product Currency").JavaButton("attached text:=Servicing Group")'
LIQ_SGProductCurrency_OK_Button= 'JavaWindow("title:=Servicing Group For Product Currency").JavaButton("attached text:=OK")'
LIQ_DealServicingGroup_OK_Button= 'JavaWindow("title:=Deal Servicing Group Details").JavaButton("attached text:=OK")'
LIQ_CurrencyDetail_DrawLimit_Textfield = 'JavaWindow("title:=Currency Detail").JavaEdit("labeled_containers_path:=.*Draw Limit.*","tagname:=text")'

###Facility Notebook- Pricing Tab###
LIQ_FacilityPricicng_Validate_Button= 'JavaWindow("title:=Facility: .*").JavaButton("attached text:=Validate")'
LIQ_Validation_Congratulations_Window= 'JavaWindow("title:=Congratulations","displayed:=1").JavaEdit("text:=Validation completed successfully.")'

###Amortization Schedule for Facility Window###
LIQ_AMD_AmortizationSchedforFacility_Window= 'JavaWindow("title:=Amortization Schedule For Facility.*")'
LIQ_AMD_AmortSched_Add_Button= 'JavaWindow("title:=Amortization Schedule For Facility.*").JavaButton("attached text:=Add")'
LIQ_AMD_AmortSched_TranNB_Button= 'JavaWindow("title:=Amortization Schedule For Facility.*").JavaButton("attached text:=Tran\. NB")'
LIQ_AMD_AmortSched_Save_Button= 'JavaWindow("title:=Amortization Schedule For Facility.*").JavaButton("attached text:=Save")'
LIQ_AMD_AmortSched_Exit_Button= 'JavaWindow("title:=Amortization Schedule For Facility.*").JavaButton("attached text:=Exit")'
LIQ_AMD_AmortSched_CreateNotices_Button= 'JavaWindow("title:=Amortization Schedule For Facility.*").JavaButton("attached text:=Create Notices")'
LIQ_AMD_AmortSched_EqualizeAmounts_Button= 'JavaWindow("title:=Amortization Schedule For Facility.*").JavaButton("attached text:=Equalize Amounts")'
LIQ_AMD_AmortSched_CreatePending_Button = 'JavaWindow("title:=Amortization Schedule For Facility.*").JavaButton("attached text:=Create Pending")'
LIQ_AMD_AmortSched_AddScheduleItem_Window= 'JavaWindow("title:=Add Schedule Item")'
LIQ_AMD_AmortSched_Status_Dropdown= 'JavaWindow("title:=Amortization Schedule For Facility.*").JavaList("attached text:=Amortization Schedule Status:")'
AmortizationSchedforFacility_CurrentSchedule= 'JavaWindow("title:=Amortization Schedule For Facility.*").JavaTree("attached text:=item\(s\) selected\.")'
LIQ_AMD_AmortSched_ExitAndSave_Button= 'JavaWindow("title:=Exiting").JavaButton("attached text:=Save & Exit")'

LIQ_EqualizingAmounts_PleaseConfirm_Window = 'JavaWindow("title:=Please confirm","displayed:=1")'
LIQ_EqualizingAmounts_PleaseConfirm_Message = 'JavaWindow("title:=Please confirm","displayed:=1").JavaEdit("attached text:=PLEASE CONFIRM")'
LIQ_EqualizingAmounts_PleaseConfirm_Yes_Button = 'JavaWindow("title:=Please confirm","displayed:=1").JavaButton("attached text:=Yes")'

LIQ_AddSchedItem_Window = 'JavaWindow("title:=Add Schedule Item")'
LIQ_AddSchedItem_Increase_RadioButton= 'JavaWindow("title:=Add Schedule Item").JavaRadiobutton("attached text:=Increase")'
LIQ_AddSchedItem_Decrease_RadioButton= 'JavaWindow("title:=Add Schedule Item").JavaRadiobutton("attached text:=Decrease")'
LIQ_AddSchedItem_Amount_Field= 'JavaWindow("title:=Add Schedule Item").JavaEdit("attached text:=Amount:.*")'
LIQ_AddSchedItem_PercentofCurrentBal_Field= 'JavaWindow("title:=Add Schedule Item").JavaEdit("attached text:=Percent of Current Balance:.*")'
LIQ_AddSchedItem_ScheduleDate_Field= 'JavaWindow("title:=Add Schedule Item").JavaEdit("attached text:=Schedule Date:.*")'
LIQ_AddSchedItem_OK_Button= 'JavaWindow("title:=Add Schedule Item").JavaButton("attached text:=OK")'
LIQ_AddSchedItem_Cancel_Button= 'JavaWindow("title:=Add Schedule Item").JavaButton("attached text:=Cancel")'


LIQ_AmortSched_CreateGroupAddressedNotice_Window = 'JavaWindow("title:=Create a Group Addressed Notice")'
LIQ_AmortSched_CreateGroupAddressedNotice_Create_Button = 'JavaWindow("title:=Create a Group Addressed Notice").JavaButton("attached text:=Create")'
LIQ_AmortSched_FacilityAddGroup_Window = 'JavaWindow("title:=Facility Addressed Group .*")'
LIQ_AmortSched_FacilityAddGroup_Exit_Button = 'JavaWindow("title:=Facility Addressed Group .*").JavaButton("attached text:=Exit")'

LIQ_AmortSched_EffectiveDate_TextField = 'JavaWindow("title:=Effective Date").JavaEdit("tagname:=Text")'
LIQ_AmortSched_EffectiveDate_OK_Button = 'JavaWindow("title:=Effective Date").JavaButton("attached text:=OK")'

###AmendMent Notebook- Events Tab###
LIQ_AMD_Events_JavaTree = 'JavaWindow("title:=Released Amendment .*").JavaTree("attached text:=Select event to view details")'
LIQ_AMD_Events_EventQueue_Button = 'JavaWindow("title:=Released Amendment .*").JavaButton("attached text:=Event Queue")'

###Amendment Notebook - Facility Extension###
LIQ_AMD_FacilityExtension_Window = 'JavaWindow("title:=Pending Extension for Facility-.*")'


####Amendment####
LIQ_CovenantChange_Window = 'JavaWindow("title:=Pending Covenant Change for Facility-.*")'
LIQ_CovenantChange_AmendmentNO = 'JavaWindow("title:=Pending Covenant Change for Facility-.*").JavaStaticText("x:=618","y:=13")'
LIQ_CovenantChange_Comment = 'JavaWindow("title:=Pending Covenant Change for Facility-.*").JavaEdit("x:=9","y:=28")'
LIQ_CovenantChangeAwaitingApproval = 'JavaWindow("title:=Awaiting Send To Approval Covenant Change for Facility-.*")'
