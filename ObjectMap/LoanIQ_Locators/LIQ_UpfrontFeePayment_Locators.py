###Upfront Fee Payment Notebook###
LIQ_UpfrontFeePayment_Notebook= 'JavaWindow("title:=.*Upfront Fee Payment from Borrower / Agent / Third Party - .*","displayed:=1")'
LIQ_UpfrontFeePayment_Tab= 'JavaWindow("label:=.*Upfront Fee Payment from Borrower / Agent / Third Party -.*","displayed:=1").JavaTab("Tagname:=TabFolder")'


###Upfront Fee Payment Notebook- General Tab###
LIQ_UpfrontFeeAmount_Field= 'JavaWindow("label:=.*Upfront Fee Payment from Borrower / Agent / Third Party -.*","displayed:=1").JavaEdit("attached text:=Amount:")'
LIQ_FeeDetail_Button= 'JavaWindow("label:=.*Upfront Fee Payment from Borrower / Agent / Third Party -.*","displayed:=1").JavaButton("attached text:=Fee Detail")'
LIQ_UpfrontFee_Comment_Field= 'JavaWindow("label:=.*Upfront Fee Payment from Borrower / Agent / Third Party -.*").JavaEdit("labeled_containers_path:=Tab:General;Group:Comment;","index:=1")'
LIQ_UpfrontFee_EffectiveDate_Field= 'JavaWindow("label:=.*Upfront Fee Payment from Borrower / Agent / Third Party -.*","displayed:=1").JavaEdit("attached text:=Effective Date:")'

###Fee Details Window###
LIQ_FeeDetails_Window= 'JavaWindow("title:=Fee Details","displayed:=1")'
LIQ_FeeDetails_Add_Button= 'JavaWindow("title:=Fee Details","displayed:=1").JavaButton("attached text:=Add")'
LIQ_FeeDetails_OK_Button= 'JavaWindow("title:=Fee Details","displayed:=1").JavaButton("attached text:=OK")'

###Fee Detail Window###
LIQ_FeeDetail_Window= 'JavaWindow("title:=Fee Detail","displayed:=1")'
LIQ_FeeDetail_FeeType_List= 'JavaWindow("title:=Fee Detail","displayed:=1").JavaList("attached text:=Fee Type:")'
LIQ_FeeDetail_Selected_FeeType= 'JavaWindow("title:=Fee Details","displayed:=1").JavaTree("tagname:=Tree","columns_count:=3")'
LIQ_FeeDetail_FeeType_OK_Button= 'JavaWindow("title:=Fee Detail","displayed:=1").JavaButton("attached text:=OK")'

###Upfront Fee Payment Notebook- Workflow Tab###
LIQ_UpfrontFeePayment_WorkflowItems= 'JavaWindow("label:=Upfront Fee Payment from Borrower / Agent / Third Party -.*").JavaTree("attached text:=Workflow Items")'
LIQ_UpfrontFeePayment_Cashflows_Notebook= 'JavaWindow("title:=Cashflows For Upfront Fee Payment from Borrower / Agent / Third Party")'
LIQ_UpfrontFeePayment_Cashflows_JavaTree= 'JavaWindow("title:=Cashflows For Upfront Fee Payment from Borrower / Agent / Third Party").JavaTree("attached text:=Drill down to view/change details")'
LIQ_UpfrontFeePayment_Cashflow_RemittanceDesc_None_StaticText = 'JavaWindow("title:=Cashflows For Upfront Fee Payment from Borrower / Agent / Third Party").JavaStaticText("attached text:=None")'
LIQ_UpfrontFeePaymentNotebook_AwaitingApproval= 'JavaWindow("title:=Upfront Fee Payment from Borrower / Agent / Third Party - Awaiting Approval .*")'
LIQ_UpfrontFeePaymentNotebook_Released= 'JavaWindow("title:=Upfront Fee Payment from Borrower / Agent / Third Party - Released .*")'
LIQ_UpfrontFeePaymentNotebook_WorkflowTab_NoItems= 'JavaWindow("title:=Upfront Fee Payment from Borrower / Agent / Third Party.*").JavaTree("tagname:=Workflow Items","items count:=0")'
LIQ_UpfrontFeePaymentNotebook_File_Exit = 'JavaWindow("title:=Upfront Fee Payment from Borrower / Agent / Third Party.*").JavaMenu("label:=File").JavaMenu("label:=Exit")'
LIQ_UpfrontFeePaymentNotebook_Currency_Dropdown = 'JavaWindow("label:=Upfront Fee Payment from Borrower / Agent / Third Party -.*").JavaList("attached text:=Currency:")'

###Upfront Fee Payment- Generate Intent Notice###
LIQ_UpfrontFeePaymentGroup_Tree = 'JavaWindow("title:=Upfront Fee From Borrower/Agent/Third Party Intent Notice Group .*","displayed:=1").JavaTree("attached text:=Drill down to mark notices")'
LIQ_UpfrontFeePaymentGroup_IntentNotice_File_Preview = 'JavaWindow("title:=Upfront Fee From Borrower/Agent/Third Party Intent Notice created by .*","displayed:=1").JavaMenu("label:=File").JavaMenu("label:=Preview")'
LIQ_UpfrontFeePaymentGroup_Edit_Button = 'JavaWindow("title:=Upfront Fee From Borrower/Agent/Third Party Intent Notice Group .*","displayed:=1").JavaButton("label:=Edit Highlighted Notices")'
LIQ_UpfrontFeePaymentGroup_IntentNotice_Window = 'JavaWindow("title:=Upfront Fee From Borrower/Agent/Third Party Intent Notice created by .*","displayed:=1")'
LIQ_UpfrontFeePaymentGroup_Exit_Button = 'JavaWindow("title:=Upfront Fee From Borrower/Agent/Third Party Intent Notice Group .*","displayed:=1").JavaButton("label:=Exit")'
LIQ_UpfrontFeePaymentGroup_IntentNoticeGroup_Window = 'JavaWindow("title:=Upfront Fee From Borrower/Agent/Third Party Intent Notice Group .*","displayed:=1")'
LIQ_Notice_Preview= 'JavaWindow("title:=Notice Preview")'
LIQ_UpfrontFeePaymentGroup_Queries_GLEntries_SubMenu = 'JavaWindow("label:=Upfront Fee Payment from Borrower / Agent / Third Party -.*","displayed:=1").JavaMenu("label:=Queries").JavaMenu("label:=GL Entries.*")'

LIQ_UpfrontFeePayment_NoticeGroup_Window = 'JavaWindow("title:=Upfront Fee From Borrower.*Group created by.*","displayed:=1")'
LIQ_UpfrontFeePayment_NoticeGroup_Exit_Button = 'JavaWindow("title:=Upfront Fee From Borrower.*Group created by.*","displayed:=1").JavaButton("label:=Exit")'

#### GL Entries for Upfron Fee Payment##
LIQ_UpfrontFee_GLEntries_Window = 'JavaWindow("title:=GL Entries For Upfront.*","displayed:=1")'
LIQ_UpfrontFee_GLEntries_JavaTree = 'JavaWindow("title:=GL Entries For Upfront.*","displayed:=1").JavaTree("attached text:=Drill down.*")'
LIQ_UpfrontFEe_GLEntries_Exit_Button = 'JavaWindow("title:=GL Entries For Upfront.*","displayed:=1").JavaButton("label:=Exit")'

###Upfront Fee Payment Notebook- Events Tab###
LIQ_UpfrontFeePayment_Events_Items = 'JavaWindow("title:=Upfront Fee Payment from Borrower / Agent / Third Party - .*").JavaTree("attached text:=Select event to view details")'

###Upfront Fee From Borrower###
LIQ_UpfrontFeeFromBorrower_Window = 'JavaWindow("title:=.*Upfront Fee Payment from Borrower / Agent / Third Party - .*")'
LIQ_UpfrontFeeFromBorrower_Options_Save = 'JavaWindow("title:=.*Upfront Fee Payment from Borrower / Agent / Third Party - .*").JavaMenu("label:=File").JavaMenu("label:=Save")'
LIQ_UpfrontFeeFromBorrower_Options_Exit = 'JavaWindow("title:=.*Upfront Fee Payment from Borrower / Agent / Third Party - .*").JavaMenu("label:=File").JavaMenu("label:=Exit")'
LIQ_UpfrontFeeFromBorrower_EffectiveDate_Textfield = 'JavaWindow("title:=.*Upfront Fee Payment from Borrower / Agent / Third Party - .*").JavaEdit("attached text:=Effective Date:")'
LIQ_UpfrontFeeFromBorrower_Amount_Textfield = 'JavaWindow("title:=.*Upfront Fee Payment from Borrower / Agent / Third Party - .*").JavaEdit("attached text:=Amount:")'
LIQ_UpfrontFeeFromBorrower_Branch_ComboBox = 'JavaWindow("title:=.*Upfront Fee Payment from Borrower / Agent / Third Party - .*").JavaList("attached text:=Branch:")'
LIQ_UpfrontFeeFromBorrower_FeeDetail_Button = 'JavaWindow("title:=.*Upfront Fee Payment from Borrower / Agent / Third Party - .*").JavaButton("attached text:=Fee Detail")'
LIQ_UpfrontFeeFromBorrower_Currency_ComboBox = 'JavaWindow("title:=.*Upfront Fee Payment from Borrower / Agent / Third Party - .*").JavaList("attached text:=Currency:")'