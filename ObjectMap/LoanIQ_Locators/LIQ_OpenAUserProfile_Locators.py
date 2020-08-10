##Open A User profile
LIQ_OpenAUserProfile_Window = 'JavaWindow("title:=Open A User Profile.*")'
LIQ_OpenAUserProfile_IdentifyUserBy_List = 'JavaWindow("title:=Open A User Profile.*").JavaList("attached text:=Identify User By.*")'
LIQ_OpenAUserProfile_IdentifyUserBy_Textfield = 'JavaWindow("title:=Open A User Profile.*").JavaEdit("tagname:=Text")'
LIQ_OpenAUserProfile_Search_Button = 'JavaWindow("title:=Open A User Profile.*").JavaButton("label:=Search")'
LIQ_OpenAUserProfile_Active_Checkbox = 'JavaWindow("title:=Open A User Profile.*").JavaCheckBox("label:=Active")'
LIQ_OpenAUserProfile_Inactive_Checkbox = 'JavaWindow("title:=Open A User Profile.*").JavaCheckBox("label:=Inactive")'

##User List
LIQ_OpenAUserProfile_UserList_Window = 'JavaWindow("title:=Open A User Profile.*").JavaWindow("title:=User List")'
LIQ_OpenAUserProfile_UserList_Tree = 'JavaWindow("title:=Open A User Profile.*").JavaWindow("title:=User List").JavaTree("attached text:=Search.*")'
LIQ_OpenAUserProfile_UserList_OK_Button = 'JavaWindow("title:=Open A User Profile.*").JavaWindow("title:=User List").JavaButton("label:=OK")'
LIQ_OpenAUserProfile_UserList_CANCEL_Button = 'JavaWindow("title:=Open A User Profile.*").JavaWindow("title:=User List").JavaButton("label:=Cancel")'

##User Profile Maintenance
LIQ_UserProfileMaint_Window = 'JavaWindow("title:=User Profile Maintenance.*", "displayed:=1")'
LIQ_UserProfileMaint_Email_Textfield = 'JavaWindow("title:=User Profile Maintenance.*").JavaEdit("attached text:=E.*Mail.*ID.*")'
LIQ_UserProfileMaint_FName_Textfield = 'JavaWindow("title:=User Profile Maintenance.*").JavaEdit("attached text:=First.*Name.*")'
LIQ_UserProfileMaint_LName_Textfield = 'JavaWindow("title:=User Profile Maintenance.*").JavaEdit("attached text:=Last.*Name.*")'
LIQ_UserProfileMaint_Dept_Tree = 'JavaWindow("title:=User Profile Maintenance.*").JavaTree("attached text:=Drill Down.*","developer name:=.*departmentName.*")'
LIQ_UserProfileMaint_UserID_StaticText = 'JavaWindow("title:=User Profile Maintenance.*").JavaStaticText("to_class:=JavaStaticText","index:=6")'
LIQ_UserProfileMaint_Branch_StaticText = 'JavaWindow("title:=User Profile Maintenance.*").JavaStaticText("to_class:=JavaStaticText","index:=8")'
LIQ_UserProfileMaint_JobFunc_StaticText = 'JavaWindow("title:=User Profile Maintenance.*").JavaStaticText("to_class:=JavaStaticText","index:=9")'
LIQ_UserProfileMaint_Title_StaticText = 'JavaWindow("title:=User Profile Maintenance.*").JavaStaticText("to_class:=JavaStaticText","index:=10")'
LIQ_UserProfileMaint_Country_StaticText = 'JavaWindow("title:=User Profile Maintenance.*").JavaStaticText("to_class:=JavaStaticText","index:=18")'
LIQ_UserProfileMaint_Language_StaticText = 'JavaWindow("title:=User Profile Maintenance.*").JavaStaticText("to_class:=JavaStaticText","index:=22")'
LIQ_UserProfileMaint_Bank_StaticText = 'JavaWindow("title:=User Profile Maintenance.*").JavaStaticText("to_class:=JavaStaticText","index:=7")'
LIQ_UserProfileMaint_ProcArea_StaticText = 'JavaWindow("title:=User Profile Maintenance.*").JavaStaticText("to_class:=JavaStaticText","index:=13")'
LIQ_UserProfileMaint_Loc_StaticText = 'JavaWindow("title:=User Profile Maintenance.*").JavaStaticText("to_class:=JavaStaticText","index:=19")'
LIQ_UserProfileMaint_SecProcArea_Button = 'JavaWindow("title:=User Profile Maintenance.*").JavaButton("label:=Secondary Proc. Areas.*")'
LIQ_UserProfileMaint_InqMode_Button = 'JavaWindow("title:=User Profile Maintenance.*").JavaButton("label:=Notebook in Inquiry Mode.*")'
LIQ_UserProfileMaint_PhoneFax_Button = 'JavaWindow("title:=User Profile Maintenance.*").JavaButton("label:=Phone.*Fax.*")'
LIQ_Options_ChangeStatus = 'JavaWindow("title:=User Profile Maintenance.*").JavaMenu("label:=Options").JavaMenu("label:=Change Status")'
LIQ_UserProfileMaint_ProcArea_Button = 'JavaWindow("title:=User Profile Maintenance.*").JavaButton("attached text:=Proc. Area")'
LIQ_UserProfileMaint_Branch_Button = 'JavaWindow("title:=User Profile Maintenance.*").JavaButton("attached text:=Branch")'
LIQ_UserProfileMaint_OSUserID_TextField = 'JavaWindow("title:=User Profile Maintenance.*").JavaEdit("attached text:=OS User:")'

##User Status dialog
LIQ_UserStatus_Dialog = 'JavaWindow("title:=User Status.*")'
LIQ_UserStatus_Cancel_Button = 'JavaWindow("title:=User Status.*").JavaButton("label:=Cancel")'
LIQ_UserStatus_Inactive_RadioButton = 'JavaWindow("title:=User Status.*").JavaRadioButton("attached text:=Inactive","value:=1")'
LIQ_UserStatus_Active_RadioButton = 'JavaWindow("title:=User Status.*").JavaRadioButton("attached text:=Inactive","value:=1")'
LIQ_UserStatus_RadioButton_On = 'JavaWindow("title:=User Status.*").JavaRadioButton("value:=1")'
LIQ_UserStatus_Inactive_RadioButton_ToSet = 'JavaWindow("title:=User Status.*").JavaRadioButton("attached text:=Inactive")'
LIQ_UserStatus_OK_Button = 'JavaWindow("title:=User Status.*").JavaButton("label:=OK")'

##Phone/Fax Dialog
LIQ_PhoneFax_Window = 'JavaWindow("title:=Phone.*Fax for.*")'
LIQ_PhoneFax_PhoneNum1_Textfield = 'JavaWindow("title:=Phone.*Fax for.*").JavaEdit("attached text:=Phone Number.*")'
LIQ_PhoneFax_Email_Textfield = 'JavaWindow("title:=Phone.*Fax for.*").JavaEdit("attached text:=E-Mai.*ID.*")'
LIQ_PhoneFax_Cancel_Button = 'JavaWindow("title:=Phone.*Fax for.*").JavaButton("attached text:=Cancel")'

##Secondary Areas Selection list
LIQ_SecArea_Window = 'JavaWindow("title:=Secondary Areas Selection.*")'
LIQ_SecArea_Tree = 'JavaWindow("title:=Secondary Areas Selection.*").JavaTree("attached text:=Secondary Areas.*")'
LIQ_SecArea_Cancel_Button = 'JavaWindow("title:=Secondary Areas Selection.*").JavaButton("label:=Cancel")'

##Security profile
LIQ_UserProfileMaint_Tab = 'JavaWindow("title:=User Profile Maintenance.*").JavaTab("tagname:=TabFolder")'
LIQ_UserProfileMaint_Tab_UserLoginID = 'JavaWindow("title:=User Profile Maintenance.*").JavaEdit("attached text:=User Login ID.*")'
LIQ_UserProfileMaint_Tab_UserLocked = 'JavaWindow("title:=User Profile Maintenance.*").JavaCheckBox("attached text:=User Locked")'

##Risk Book Access
LIQ_RiskBookAccess_Tab = 'JavaWindow("title:=User Profile Maintenance.*").JavaTab("tagname:=TabFolder")'
LIQ_RiskBookAccess_Tab_UserLoginID = 'JavaWindow("title:=User Profile Maintenance.*").JavaEdit("attached text:=User Login ID.*")'
LIQ_RiskBookAccess_Tab_UserLocked = 'JavaWindow("title:=User Profile Maintenance.*").JavaCheckBox("attached text:=User Locked")'
LIQ_RiskBookAccess_JavaTree = 'JavaWindow("title:=User Profile Maintenance.*").JavaTree("labeled_containers_path:=Tab:Risk Book Access;")' 
LIQ_RiskBookList_Button = 'JavaWindow("title:=User Profile Maintenance.*").JavaButton("attached text:=Risk Book Access List \.\.\.","enabled:=1")'

##Risk Book List
LIQ_RiskBookList_Window = 'JavaWindow("title:=Risk Book Selection List")'
LIQ_RiskBookList_JavaTree = 'JavaWindow("title:=Risk Book Selection List").JavaTree("attached text:=Risk Book")'
LIQ_RiskBookList_OK_Button = 'JavaWindow("title:=Risk Book Selection List").JavaButton("attached text:=OK")'



LIQ_RiskBookList_RadioButton_Yes = 'JavaWindow("title:=User Profile Maintenance.*").JavaTree("attached text:=Risk Book").JavaRadioButton("attached text:=Y")'
LIQ_RiskBookList_RadioButton_No = 'JavaWindow("title:=User Profile Maintenance.*").JavaTree("attached text:=Risk Book").JavaRadioButton("attached text:=N")'


##Events
LIQ_Events_Tab = 'JavaWindow("title:=User Profile Maintenance.*").JavaTab("tagname:=TabFolder")'
LIQ_Events_Tab_UserLoginID = 'JavaWindow("title:=User Profile Maintenance.*").JavaEdit("attached text:=User Login ID.*")'
LIQ_Events_Tab_UserLocked = 'JavaWindow("title:=User Profile Maintenance.*").JavaCheckBox("attached text:=User Locked")'
LIQ_EventsTable_JavaTree = 'JavaWindow("title:=User Profile Maintenance.*").JavaTree("attached text:=Select event to view details.*")' 

##Error Dialog
LIQ_OpenAUserProfile_Error_Dialog = 'JavaWindow("title:=Error.*","displayed:=1").JavaEdit("value:=No user found for.*")'

###Select Processing area
LIQ_ProcArea_Window = 'JavaWindow("title:=Select Processing Area")'
LIQ_ProcArea_JavaTree = 'JavaWindow("title:=Select Processing Area").JavaTree("attached text:=Search by code:")'
LIQ_ProcArea_OK_Button = 'JavaWindow("title:=Select Processing Area").JavaButton("attached text:=OK")'
LIQ_ProcArea_Cancel_Button = 'JavaWindow("title:=Select Processing Area").JavaButton("attached text:=Cancel")'

###Select Branch
LIQ_SelectBranch_Window = 'JavaWindow("title:=Select Branch")'
LIQ_SelectBranch_JavaTree = 'JavaWindow("title:=Select Branch").JavaTree("attached text:=Search by code:")'
LIQ_SelectBranch_Cancel_Button = 'JavaWindow("title:=Select Branch").JavaButton("attached text:=Cancel")'


###Risk Book Access
LIQ_RiskBookAccess_Button = 'JavaWindow("title:=User Profile Maintenance.*").JavaButton("attached text:=Risk Book Access List.*")'
LIQ_RiskBookAccess_JavaTree = 'JavaWindow("title:=User Profile Maintenance.*").JavaTree("labeled_containers_path:=Tab:Risk Book Access;")'
LIQ_RiskBookAccess_Yes_RadioButton = 'JavaWindow("title:=User Profile Maintenance.*").JavaTree("labeled_containers_path:=Tab:Risk Book Access;").JavaRadioButton("label:=Y")'
LIQ_RiskBookAccess_No_RadioButton = 'JavaWindow("title:=User Profile Maintenance.*").JavaTree("labeled_containers_path:=Tab:Risk Book Access;").JavaRadioButton("label:=N")'
###Risk Book Selection List 
LIQ_RiskBookSelection_Window = 'JavaWindow("title:=Risk Book Selection List.*")'
LIQ_RiskBookSelection_Tree = 'JavaWindow("title:=Risk Book Selection List.*").JavaTree("attached text:=Risk Book")'
LIQ_RiskBookSelection_Ok_Button = 'JavaWindow("title:=Risk Book Selection List.*").JavaButton("attached text:=OK")'
LIQ_RiskBookSelection_Cancel_Button = 'JavaWindow("title:=Risk Book Selection List.*").JavaButton("attached text:=Cancel")'


###User Profile Maintenance Window Buttons 
LIQ_NotebookInInquiryMode_Button = 'JavaWindow("title:=User Profile Maintenance.*").JavaButton("attached text:=Notebook in Inquiry Mode - F7")'

