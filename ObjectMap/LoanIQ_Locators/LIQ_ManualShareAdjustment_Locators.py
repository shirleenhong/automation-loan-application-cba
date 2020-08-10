###Existing Loan Window###
LIQ_ExistingLoans_Window = 'JavaWindow("title:=Existing Loans For Deal:.*")'
LIQ_ExistingLoans_UpdateMode = 'JavaWindow("title:=Existing Loans For Deal:.*").JavaCheckBox("attached text:=Open notebook in update mode")'
LIQ_ExistingLoans_JavaTree = 'JavaWindow("title:=Existing Loans For Deal:.*").JavaTree("attached text:=Drill down to open the notebook")'

###Loan Notebook###
LIQ_Options_ShareAdjustment = 'JavaMenu("label:=Options").JavaMenu("label:=Share Adjustment")'

###Choose Adjustment Window###
LIQ_ChooseAdjustment_Window = 'JavaWindow("title:=Choose an Adjustment")'
LIQ_ChooseAdjustment_LenderShares_RadioButton = 'JavaWindow("title:=Choose an Adjustment").JavaRadioButton("attached text:=Lender Shares")'
LIQ_ChooseAdjustment_OK_Button = 'JavaWindow("title:=Choose an Adjustment").JavaButton("attached text:=OK")'

###Manual Share Adjustment Notebook###
LIQ_ManualShareAdjustment_Window = 'JavaWindow("title:=.* Manual Share Adjustment .*","displayed:=1")'
LIQ_ManualShareAdjustment_Tab = 'JavaWindow("title:=.* Manual Share Adjustment .*","displayed:=1").JavaTab("path:=TabFolder;Shell;")'
LIQ_ManualShareAdjustment_EffectiveDate = 'JavaWindow("title:=.* Manual Share Adjustment .*","displayed:=1").JavaEdit("x:=188","y:=349")'
LIQ_ManualShareAdjustment_ManualSharedAdj_Reason = 'JavaWindow("title:=.* Manual Share Adjustment .*","displayed:=1").JavaEdit("x:=188","y:=451")'
LIQ_ManualShareAdjustment_FileSave = 'JavaWindow("title:=.* Manual Share Adjustment .*","displayed:=1").JavaMenu("label:=File").JavaMenu("label:=Save")'
LIQ_ManualShareAdjustment_Options_ViewUpdateLenderShare = 'JavaWindow("title:=.* Manual Share Adjustment .*","displayed:=1").JavaMenu("label:=Options").JavaMenu("label:=View/Update Lender Shares")'

###Workflow Tab###
LIQ_ManualShareAdjustment_WorkflowItem = 'JavaWindow("title:=.* Manual Share Adjustment .*","displayed:=1").JavaTree("attached text:=Drill down to perform Workflow item")'

###Portfolio Share Edit###
LIQ_PortfolioShareEdit_Window = 'JavaWindow("title:=Portfolio Share Edit")'
LIQ_PortfolioShareEdit_Funding = 'JavaWindow("title:=Portfolio Share Edit").JavaTree("labeled_containers_path:=Group:Funding;")'
LIQ_PortfolioShareEdit_OK_Button = 'JavaWindow("title:=Portfolio Share Edit").JavaButton("attached text:=OK")'
LIQ_PortfolioShareEdit_Legal_Field = 'JavaWindow("title:=Portfolio Share Edit").JavaEdit("attached text:=Legal:")'
LIQ_PortfolioShareEdit_Book_Field = 'JavaWindow("title:=Portfolio Share Edit").JavaEdit("attached text:=Book:")'
LIQ_PortfolioShareEdit_NewBalance_Field = 'JavaWindow("title:=Portfolio Share Edit").JavaEdit("x:=638","y:=128")'

