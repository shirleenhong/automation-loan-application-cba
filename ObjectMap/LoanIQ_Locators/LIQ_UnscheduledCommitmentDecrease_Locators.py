###Amortization Schedule for Facility Notebook###
LIQ_AmortizationScheduleforFacility_Window = 'JavaWindow("title:=Amortization Schedule For Facility -.*")'
LIQ_AmortizationScheduleforFacility_AddUnsch_Button = 'JavaWindow("title:=Amortization Schedule For Facility -.*").JavaButton("attached text:=Add Unsch\. Tran")'
LIQ_AmortizationScheduleforFacility_AmortizationStatus_List = 'JavaWindow("title:=Amortization Schedule For Facility -.*").JavaList("attached text:=Amortization Schedule Status:")'
LIQ_AmortizationScheduleforFacility_Modify_Button = 'JavaWindow("title:=Amortization Schedule For Facility -.*").JavaButton("attached text:=Modify")'
LIQ_AmortizationScheduleforFacility_Schedule_List = 'JavaWindow("title:=Amortization Schedule For Facility -.*").JavaTree("labeled_containers_path:=Group:Current Schedule;","attached text:=item\(s\) selected\.")'
LIQ_AmortizationScheduleforFacility_CreatePending_Button = 'JavaWindow("title:=Amortization Schedule For Facility -.*").JavaButton("attached text:=Create Pending")'
LIQ_AmortizationScheduleforFacility_TranNB_Button = 'JavaWindow("title:=Amortization Schedule For Facility -.*").JavaButton("attached text:=Tran\. NB")'
LIQ_AmortizationScheduleforFacility_Add_Button = 'JavaWindow("title:=Amortization Schedule For Facility -.*").JavaButton("attached text:=Add")'
LIQ_AmortizationScheduleforFacility_Save_Button = 'JavaWindow("title:=Amortization Schedule For Facility -.*").JavaButton("attached text:=Save")'
LIQ_AmortizationScheduleforFacility_Exit_Button = 'JavaWindow("title:=Amortization Schedule For Facility -.*").JavaButton("attached text:=Exit")'
LIQ_AmortizationScheduleforFacility_Frequency_List = 'JavaWindow("title:=Amortization Schedule For Facility -.*").JavaList("attached text:=Frequency:")'

###Schedule Item Window###
LIQ_ScheduleItem_Window = 'JavaWindow("title:=Add Schedule Item")'
LIQ_ScheduleItem_Decrease_RadioButton = 'JavaWindow("title:=Add Schedule Item").JavaRadioButton("attached text:=Decrease")'
LIQ_ScheduleItem_Amount = 'JavaWindow("title:=Add Schedule Item").JavaEdit("attached text:=Amount:")'
LIQ_ScheduleItem_PercentofCurrent = 'JavaWindow("title:=Add Schedule Item").JavaEdit("attached text:=Percent of Current Balance:")'
LIQ_ScheduleItem_Schedule = 'JavaWindow("title:=Add Schedule Item").JavaEdit("attached text:=Schedule Date:")'
LIQ_ScheduleItem_Ok_Button = 'JavaWindow("title:=Add Schedule Item").JavaButton("attached text:=OK")'

###Modify Transaction###
LIQ_ModifyTransaction_Window = 'JavaWindow("title:=Modify Transaction")'
LIQ_ModifyTransaction_Ok_Button = 'JavaWindow("title:=Modify Transaction").JavaButton("attached text:=OK")'

###Modify Schedule Item Window###
LIQ_ModifySchedule_Window = 'JavaWindow("title:=Modify Schedule Item")'
LIQ_ModifySchedule_Decrease_RadioButton = 'JavaWindow("title:=Modify Schedule Item").JavaRadioButton("attached text:=Decrease")'
LIQ_ModifySchedule_Amount = 'JavaWindow("title:=Modify Schedule Item").JavaEdit("attached text:=Amount:")'
LIQ_ModifySchedule_PercentofCurrent = 'JavaWindow("title:=Modify Schedule Item").JavaEdit("attached text:=Percent of Current Balance:")'
LIQ_ModifySchedule_Date = 'JavaWindow("title:=Modify Schedule Item").JavaEdit("attached text:=Schedule Date:")'
LIQ_ModifySchedule_Ok_Button = 'JavaWindow("title:=Modify Schedule Item").JavaButton("attached text:=OK")'

###Unscheduled Commitment Decrease###
LIQ_UnscheduledCommitmentDecrease_Window = 'JavaWindow("title:=Unscheduled Commitment Decrease.*","displayed:=1")'
LIQ_UnscheduledCommitmentDecrease_Type = 'JavaWindow("title:=Unscheduled Commitment Decrease.*","displayed:=1").JavaStaticText("attached text:=Unscheduled Commitment Decrease")'
LIQ_UnscheduledCommitmentDecrease_ChangeAmount = 'JavaWindow("title:=Unscheduled Commitment Decrease.*","displayed:=1").JavaStaticText("attached text:=-10,000\.00","displayed:=1")'

###Notices Window###
LIQ_UnscheduledCommitmentDecrease_Notices_Window = 'JavaWindow("title:=Notices")'
LIQ_UnscheduledCommitmentDecrease_Notices_Lender_List = 'JavaWindow("title:=Notices").JavaCheckBox("attached text:=Lenders")'
LIQ_UnscheduledCommitmentDecrease_Ok_Button = 'JavaWindow("title:=Notices").JavaButton("attached text:=OK")'

LIQ_UnscheduledCommitmentDecrease_Workflow_Tab = 'JavaWindow("title:=Unscheduled Commitment Decrease.*","displayed:=1").JavaTab("tagname:=TabFolder")'
LIQ_UnscheduledCommitmentDecrease_Workflow_List = 'JavaWindow("title:=Unscheduled Commitment Decrease.*","displayed:=1").JavaTree("attached text:=Drill down to perform Workflow item")'

###Facility Notebook###
LIQ_FacilityNotebook_Pending_Tab = 'JavaWindow("title:=Facility -.*","displayed:=1").JavaTab("tagname:=TabFolder")'
LIQ_FacilityNotebook_PendingListItem = 'JavaWindow("title:=Facility -.*","displayed:=1").JavaTree("attached text:=Pending Transactions")'

###Shares for Unscheduled Commitment Decrease Window###
LIQ_SharesForUnscheduledCommitmentDecrease_Window = 'JavaWindow("title:=.*Unscheduled Commitment Decrease in Facility:.*")'
LIQ_HostBankShares_List = 'JavaWindow("title:=.*Unscheduled Commitment Decrease in Facility:.*").JavaTree("attached text:=Drill Down for Portfolio Shares")'
LIQ_SharesForUnscheduledCommitmentDecrease_OK_Button = 'JavaWindow("title:=.*Unscheduled Commitment Decrease in Facility:.*").JavaButton("attached text:=OK")'

LIQ_HostBankShare_Window = 'JavaWindow("title:=Host Bank Share for:.*")'
LIQ_HostBankShare_AddPortfolio_Button = 'JavaWindow("title:=Host Bank Share for:.*").JavaButton("attached text:=Add Portfolio/Expense Code")'
LIQ_PortfolioSelection_window = 'JavaWindow("title:=Portfolio Selection For:.*")'
LIQ_PortfolioSelection_List ='JavaWindow("title:=Portfolio Selection For:.*").JavaTree("attached text:=Portfolio/Expense:")'
LIQ_HostBankPortfolioSelection_Ok_Button = 'JavaWindow("title:=Host Bank Share for:.*").JavaButton("attached text:=OK")'

LIQ_PortfolioShare_Window = 'JavaWindow("title:=Portfolio Share Edit")'
LIQ_PortfolioShare_ActualAmount = 'JavaWindow("title:=Portfolio Share Edit").JavaEdit("attached text:=BG_COL - Corporate Lending")'
LIQ_PortfolioShare_Ok_Button = 'JavaWindow("title:=Portfolio Share Edit").JavaButton("attached text:=OK")'
