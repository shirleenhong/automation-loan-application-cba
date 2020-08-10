###Outstanding Select Window###  
LIQ_OutstandingSelect_ExistingRadioButton = 'JavaWindow("title:=Outstanding Select").JavaRadioButton("attached text:=Existing")'
LIQ_OutstandingSelect_Type_Combobox = 'JavaWindow("title:=Outstanding Select").JavaList("attached text:=Type:")'
LIQ_OustandingSelect_Deal_Button = 'JavaWindow("title:=Outstanding Select").JavaButton("attached text:=Deal:")'
LIQ_OutstandingSelect_Facility_Combo = 'JavaWindow("title:=Outstanding Select").JavaList("attached text:=Facility:")'
LIQ_OutstandingSelect_Search_Button = 'JavaWindow("title:=Outstanding Select").JavaButton("attached text:=Search")'

###Existing Standby Letters of Credit For Facility Window###
LIQ_ExistingStandbyLettersofCredit_Javatree = 'JavaWindow("title:=Existing Standby Letters of Credit.*").JavaTree("attached text:=Drill down to open the notebook")'

###Bank Guarantee###
LIQ_BankGuarantee_Window = 'JavaWindow("title:=Bank Guarantee/Letter of Credit/Synd Fronted Bank.*")'
LIQ_BankGuarantee_Draw_Tab = 'JavaWindow("title:=Bank Guarantee/Letter of Credit/Synd Fronted Bank.*").JavaTab("tagname:=TabFolder")'
LIQ_BankGuarantee_AvailableToDraw = 'JavaWindow("title:=Bank Guarantee/Letter of Credit/Synd Fronted Bank.*").JavaEdit("x:=300","y:=37")'
LIQ_BankGuarantee_Create_Button = 'JavaWindow("title:=Bank Guarantee/Letter of Credit/Synd Fronted Bank.*").JavaButton("attached text:=Create")'

###Draw Against Bank Guarantee###
LIQ_DrawAgainstBankGuarantee_Window = 'JavaWindow("title:=Draw against Bank Guarantee/Letter of Credit/Synd Fronted Bank.*")'
LIQ_DrawAgainstBankGuarantee_DrawnAmount = 'JavaWindow("title:=Draw against Bank Guarantee/Letter of Credit/Synd Fronted Bank.*").JavaEdit("attached text:=Drawn:")'
LIQ_DrawAgainstBankGuarantee_Beneficiaries_Customer_Record_JavaTree = 'JavaWindow("title:=Draw against Bank Guarantee/Letter of Credit/Synd Fronted Bank.*").JavaTree("attached text:=Drill down to edit")'
LIQ_DrawAgainstBankGuarantee_Delete_Button = 'JavaWindow("title:=Draw against Bank Guarantee/Letter of Credit/Synd Fronted Bank.*").JavaButton("attached text:=Delete")'
LIQ_DrawAgainstBankGuarantee_CreateFromIssuingBank_Button = 'JavaWindow("title:=Draw against Bank Guarantee/Letter of Credit/Synd Fronted Bank.*").JavaButton("attached text:=Create from Issuing Banks")'
LIQ_BankGuarantee_OK_Button = 'JavaWindow("title:=Draw against Bank Guarantee/Letter of Credit/Synd Fronted Bank.*").JavaButton("attached text:=OK")'
LIQ_IssuingBank_Javatree = 'JavaWindow("title:=Draw against Bank Guarantee/Letter of Credit/Synd Fronted Bank.*").JavaTree("attached text:=Drill down to edit")'

###Bank Guarantee pending###
LIQ_BankGuarantee_Payment_Window = 'JavaWindow("title:=Bank Guarantee/Letter of Credit/Synd Fronted Bank Draw Payment.*")'
LIQ_BankGuarantee_PaymentTab = 'JavaWindow("title:=Bank Guarantee/Letter of Credit/Synd Fronted Bank Draw Payment.*").JavaTab("tagname:=TabFolder")'
LIQ_BankGuarantee_Workflow_JavaTree = 'JavaWindow("title:=Bank Guarantee/Letter of Credit/Synd Fronted Bank Draw Payment.*").JavaTree("attached text:=Drill down to perform Workflow item")'
LIQ_BankGuarantee_GenerateIntentNotices_ListItem = 'JavaWindow("title:=Bank Guarantee/Letter of Credit/Synd Fronted Bank Draw Payment.*").JavaTree("attached text:=Drill down to.*")'  

LIQ_BankGuarantee_Payment_Released_Window = 'JavaWindow("title:=Bank Guarantee/Letter of Credit/Synd Fronted Bank Draw Payment.*")'
LIQ_BankGuarantee_Events_Tree = 'JavaWindow("title:=Bank Guarantee/Letter of Credit/Synd Fronted Bank Draw Payment.*").JavaTree("attached text:=Select event to view details")'
BankGuarantee_Payment_FileExit_Menu = 'JavaWindow("title:=Bank Guarantee/Letter of Credit/Synd Fronted Bank Draw Payment.*").JavaMenu("label:=File").JavaMenu("label:=Exit")'

###Cashflows Window###
LIQ_Close_CashFlowForBankGuarantee_Window ='JavaWindow("title:=Cashflows For Bank Guarantee/Letter of Credit/Synd Fronted Bank Draw Payment.*")'
LIQ_CashFlowForBankGuarantee_Ok_Button = 'JavaWindow("title:=Cashflows For Bank Guarantee/Letter of Credit/Synd Fronted Bank Draw Payment.*").JavaButton("attached text:=OK")'

###Facility Window###
LIQ_Facility_OustandingAmount = 'JavaWindow("title:=Facility -.*").JavaEdit("x:=162","y:=119")'
LIQ_Facility_AvailToDraw = 'JavaWindow("title:=Facility -.*").JavaEdit("x:=162","y:=148")'
LIQ_Facility_ProposedCmt = 'JavaWindow("title:=Facility -.*").JavaEdit("attached text:=Proposed Cmt:")'
LIQ_Facility_CurrentAmt = 'JavaWindow("title:=Facility -.*").JavaEdit("attached text:=Current Cmt:")'