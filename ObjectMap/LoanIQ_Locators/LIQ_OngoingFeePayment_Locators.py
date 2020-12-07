LIQ_OngoingFeePayment_Window = 'JavaWindow("title:=.*Ongoing Fee Payment.*")'
LIQ_OngoingFeePayment_Tab = 'JavaWindow("title:=.*Ongoing Fee Payment.*").JavaTab("index:=0")'
LIQ_OngoingFeePayment_Requested_Textfield ='JavaWindow("title:=.*Ongoing Fee Payment.*").JavaObject("tagname:=Group","text:=.*Amounts.*").JavaEdit("editable:=1")'
LIQ_OngoingFeePayment_EffectiveDate_Textfield = 'JavaWindow("title:=.*Ongoing Fee Payment.*").JavaEdit("attached text:=Effective Date:")'
LIQ_OngoingFeePayment_DueDate_Text = 'JavaWindow("title:=.*Ongoing Fee Payment.*").JavaObject("tagname:=Group","text:=Cycle").JavaStaticText("index:=5")'
LIQ_OngoingFeePayment_Workflow = 'JavaWindow("title:=.*Ongoing Fee Payment.*").JavaTree("attached text:=Drill down to perform Workflow item")'
LIQ_OngoingFeePayment_Notice_Exit_Button= 'JavaWindow("title:=Fee Payment Notice Group created.*","displayed:=1").JavaButton("label:=Exit.*")'

### Ongoing Fee Notebook ###
LIQ_OngoingFee_Cycle_List = 'JavaWindow("title:=.*Fee /.*").JavaList("attached text:=Cycle.*")'
LIQ_OngoingFee_Save_Menu = 'JavaWindow("title:=.*Fee /.*").JavaMenu("label:=File").JavaMenu("label:=Save")'
LIQ_OngoingFee_AdjustedDueDate = 'JavaWindow("title:=.*Fee /.*").JavaEdit("attached text:=Adjusted Due Date:.*")'
LIQ_OngoingFee_OnlineAcrual_Menu = 'JavaWindow("title:=.*Fee /.*").JavaMenu("label:=Options").JavaMenu("label:=Perform Online Accrual")'
LIQ_OngoingFee_CurrentRate_Field = 'JavaWindow("title:=.*Fee /.*").JavaEdit("attached text:=Current Rate:")'
LIQ_OngoingFee_RateBasis_Text = 'JavaWindow("title:=.*Fee /.*").JavaStaticText("attached text:=Actual/.*")'
LIQ_OngoingFee_BalanceAmount_Field = 'JavaWindow("title:=.*Fee /.*").JavaEdit("attached text:=Balance Amount:")'
LIQ_OngoingFee_General_OptionsPayment_Menu = 'JavaWindow("title:=.*Fee /.*","displayed:=1").JavaMenu("label:=Options").JavaMenu("label:=Payment")'

### Ongoing Fee Notebook - General Tab ###
LIQ_OngoingFee_InquiryMode_Button = 'JavaWindow("title:=.*Fee /.*","displayed:=1").JavaButton("attached text:=Notebook in Inquiry Mode.*")'
LIQ_OngoingFee_Window = 'JavaWindow("title:=.*Fee /.*","displayed:=1")'
LIQ_OngoingFee_Tab = 'JavaWindow("title:=.*Fee /.*","displayed:=1").JavaTab("tagname:=TabFolder")' 
LIQ_OngoingFee_EffectiveDate_Field = 'JavaWindow("title:=.*Fee /.*","displayed:=1").JavaEdit("attached text:=Effective Date:.*")'
LIQ_OngoingFee_FloatRateStartDate_Field = 'JavaWindow("title:=.*Fee /.*","displayed:=1").JavaEdit("attached text:=Float Rate Start Date:.*")'
LIQ_OngoingFee_ActualDueDate_Field = 'JavaWindow("title:=.*Fee /.*","displayed:=1").JavaEdit("attached text:=Actual Due Date:.*")'
LIQ_OngoingFee_AdjustedDueDate = 'JavaWindow("title:=.*Fee /.*","displayed:=1").JavaEdit("attached text:=Adjusted Due Date:.*")'
LIQ_OngoingFee_Accrue_Dropdown = 'JavaWindow("title:=.*Fee /.*","displayed:=1").JavaList("attached text:=Accrue.*")'
LIQ_OngoingFee_AccrualEndDate_Field = 'JavaWindow("title:=.*Fee /.*","displayed:=1").JavaEdit("attached text:=Accrual End Date:.*")'
LIQ_OngoingFee_FeePaidBy_Button = 'JavaWindow("title:=.*Fee /.*","displayed:=1").JavaButton("attached text:=Fee Paid By:.*")'
LIQ_OngoingFee_ServicingGroup_Button = 'JavaWindow("title:=.*Fee /.*","displayed:=1").JavaButton("attached text:=Servicing Group.*")'

### Ongoing Fee Menu ###
LIQ_OngoingFee_Save_Menu = 'JavaWindow("title:=.*Fee /.*","displayed:=1").JavaMenu("label:=File").JavaMenu("label:=Save")'
LIQ_OngoingFee_Exit_Menu = 'JavaWindow("title:=.*Fee /.*","displayed:=1").JavaMenu("label:=File").JavaMenu("label:=Exit")'
