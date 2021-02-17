###Notice Select Window###
LIQ_NoticeSelect_Window = 'JavaWindow("title:=Notice Select","displayed:=1")'
LIQ_NoticeSelect_New_RadioButton = 'JavaWindow("title:=Notice Select","displayed:=1").JavaRadioButton("attached text:=New")'
LIQ_NoticeSelect_Existing_RadioButton = 'JavaWindow("title:=Notice Select","displayed:=1").JavaRadioButton("attached text:=Existing")'
LIQ_NoticeSelect_SelectBy_List = 'JavaWindow("title:=Notice Select","displayed:=1").JavaList("attached text:=Select By:")'
LIQ_NoticeSelect_NoticeIdentifier_Field = 'JavaWindow("title:=Notice Select","displayed:=1").JavaEdit("attached text:=Notice Identifier")'
LIQ_NoticeSelect_Search_Button = 'JavaWindow("title:=Notice Select","displayed:=1").JavaButton("attached text:=Search")'

###Notice Select Message###
LIQ_NoticeSelectMessage_Window = 'JavaWindow("title:=Notice Select Message","displayed:=1")'
LIQ_NoticeSelectMessage_FromDate_Field = 'JavaWindow("title:=Notice Select Message").JavaEdit("attached text:=From:")'
LIQ_NoticeSelectMessage_ThruDate_Field = 'JavaWindow("title:=Notice Select Message").JavaEdit("attached text:=Thru:")'
LIQ_NoticeSelectMessage_OK_Button = 'JavaWindow("title:=Notice Select Message").JavaButton("attached text:=OK")'

###Notice Listing Window###
LIQ_NoticeListing_Window = 'JavaWindow("title:=Notice Listing for .*","displayed:=1")'
LIQ_NoticeListing_RemainOpenAfterSelection_CheckBox = 'JavaWindow("title:=Notice Listing for .*","displayed:=1").JavaCheckBox("attached text:=Remain open after selection")'
LIQ_NoticeListing_Search_Field = 'JavaWindow("title:=Notice Listing for .*","displayed:=1").JavaEdit("attached text:=Search:")'
LIQ_NoticeListing_OK_Button = 'JavaWindow("title:=Notice Listing for .*","displayed:=1").JavaButton("attached text:=OK")'
LIQ_NoticeListing_NoticeGroup_Button = 'JavaWindow("title:=Notice Listing for .*","displayed:=1").JavaButton("attached text:=Notice Group")'

###Notice Window###
LIQ_Notice_Window = 'JavaWindow("title:=.* Notice created by .*","displayed:=1")'
LIQ_Notice_NoticeID_Field = 'JavaWindow("title:=.* Notice created by .*","displayed:=1").JavaEdit("attached text:=Notice ID:")'
LIQ_Notice_Customer_Field = 'JavaWindow("title:=.* Notice created by .*","displayed:=1").JavaEdit("tagname:=Text","index:=2")'
LIQ_Notice_NoticeMethod_List = 'JavaWindow("title:=.* Notice created by .*","displayed:=1").JavaList("attached text:=Notice Method:")'
LIQ_Notice_Status_StaticText = 'JavaWindow("title:=.* Notice created by .*","displayed:=1").JavaStaticText("labeled_containers_path:=Group:Status;","index:=7")'
LIQ_Notice_FileSave_Menu = 'JavaWindow("title:=.* Notice created by .*","displayed:=1").JavaMenu("label:=File").JavaMenu("label:=Save")'
LIQ_Notice_OptionsSend_Menu = 'JavaWindow("title:=.* Notice created by .*","displayed:=1").JavaMenu("label:=Options").JavaMenu("label:=Send")'
LIQ_Notice_OptionsEnableForResend_Menu = 'JavaWindow("title:=.* Notice created by .*","displayed:=1").JavaMenu("label:=Options").JavaMenu("label:=Enable for resend")'

LIQ_Notice_Customer_Button = 'JavaWindow("title:=.* Notice created by .*","displayed:=1").JavaButton("attached text:=Customer:")'
LIQ_Notice_Contact_Button = 'JavaWindow("title:=.* Notice created by .*","displayed:=1").JavaButton("attached text:=Contact:")'
LIQ_Notice_NoticeMethod_JavaStaticText = 'JavaWindow("title:=.* Notice created by .*","displayed:=1").JavaStaticText("attached text:=Notice Method:")' 
LIQ_Notice_NoticeID_JavaStaticText = 'JavaWindow("title:=.* Notice created by .*","displayed:=1").JavaStaticText("attached text:=Notice ID:")'
LIQ_Notice_Email_JavaStaticText = 'JavaWindow("title:=.* Notice created by .*","displayed:=1").JavaStaticText("attached text:=E-mail:")'
LIQ_Notice_Language_JavaStaticText = 'JavaWindow("title:=.* Notice created by .*","displayed:=1").JavaStaticText("attached text:=Language:")'
LIQ_Notice_Regarding_JavaStaticText = 'JavaWindow("title:=.* Notice created by .*","displayed:=1").JavaStaticText("attached text:=Regarding:")'
LIQ_Notice_Text_JavaStaticText = 'JavaWindow("title:=.* Notice created by .*","displayed:=1").JavaStaticText("attached text:=Text:")'
LIQ_Notice_Status_JavaStaticText = 'JavaWindow("title:=.* Notice created by .*","displayed:=1").JavaStaticText("attached text:=Status:")'
LIQ_Notice_DateLastSent_JavaStaticText = 'JavaWindow("title:=.* Notice created by .*","displayed:=1").JavaStaticText("label:=Date Last Sent:")'
LIQ_Notice_TimeLastSent_JavaStaticText = 'JavaWindow("title:=.* Notice created by .*","displayed:=1").JavaStaticText("label:=Time Last Sent:")'
LIQ_Notice_LastSentBy_JavaStaticText = 'JavaWindow("title:=.* Notice created by .*","displayed:=1").JavaStaticText("label:=Last Sent By:")'


###WIP###
LIQ_WorkInProgress_NoticeTransactionStatus_List = 'JavaWindow("title:=Transactions In Process.*").JavaTree("labeled_containers_path:=Group:Details;Tab:Notices;")'

###Notice Group Window###
LIQ_NoticeGroup_Window = 'JavaWindow("title:=.* Group created by .*","displayed:=1")'
LIQ_NoticeGroup_Items_JavaTree = 'JavaWindow("title:=.* Group created by .*","displayed:=1").JavaTree("attached text:=Drill down to mark notices")'
LIQ_NoticeGroup_Refresh_Button = 'JavaWindow("title:=.* Notice Group created by .*","displayed:=1").JavaButton("attached text:=Refresh")'
LIQ_NoticeGroup_Unmarkall_Button = 'JavaWindow("title:=.* Notice Group created by .*","displayed:=1").JavaButton("attached text:=Unmark all")'
LIQ_NoticeGroup_Markall_Button = 'JavaWindow("title:=.* Notice Group created by .*","displayed:=1").JavaButton("attached text:=Mark all")'
LIQ_NoticeGroup_Send_Button = 'JavaWindow("title:=.* Notice Group created by .*","displayed:=1").JavaButton("attached text:=Send")'
LIQ_NoticeGroup_EditHighlightNotices = 'JavaWindow("title:=.* Group created by .*","displayed:=1").JavaButton("attached text:=Edit Highlighted Notices")'

###Notice Groups For Window###
LIQ_NoticeGroupsFor_Window = 'JavaWindow("title:=.* Groups for.*","displayed:=1")'
LIQ_NoticeGroupsFor_Items = 'JavaWindow("title:=.* Groups for.*").JavaTree("attached text:=Drill down to process a group")'

### Generic Notice Locators ###
LIQ_Notice_Notice_Window = 'JavaWindow("title:=.*Notice.*","displayed:=1")'
LIQ_Notice_Ok_Button = 'JavaWindow("title:=.*Notice.*","displayed:=1").JavaButton("attached text:=OK")'
LIQ_Notice_GroupComment_Button = 'JavaWindow("title:=.*Notice.*","displayed:=1").JavaButton("attached text:=Group comment.*")'
LIQ_Notice_CommentEdit_Window = 'JavaWindow("title:=Comment Edit","displayed:=1")'
LIQ_Notice_CommentEdit_Subject_Textbox = 'JavaWindow("title:=Comment Edit","displayed:=1").JavaEdit("attached text:=Subject.*")'
LIQ_Notice_CommentEdit_Comment_Textbox = 'JavaWindow("title:=Comment Edit","displayed:=1").JavaEdit("attached text:=Comment.*")'
LIQ_Notice_CommentEdit_OK_Button = 'JavaWindow("title:=Comment Edit","displayed:=1").JavaButton("attached text:=OK")'

### Commitment Change Group Locators ###
LIQ_Notice_CommitmentChangeGroup_Window = 'JavaWindow("title:=.*Commitment Change Group.*","displayed:=1")'