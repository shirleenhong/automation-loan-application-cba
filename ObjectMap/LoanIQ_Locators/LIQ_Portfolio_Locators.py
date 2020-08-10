LIQ_Portfolio_Positions = 'JavaWindow("title:=Deal Notebook.*").JavaMenu("label:=Options").JavaMenu("label:=Portfolio Positions...")'
LIQ_Portfolio_Positions_Window = 'JavaWindow("title:=Porfolio Positions.*")'
LIQ_Portfolio_Positions_JavaTree = 'JavaWindow("title:=Portfolio Positions.*").JavaTree("tagname:=Drill down or use the.*")'
LIQ_Portfolio_Positions_Adjustment_Button = 'JavaWindow("title:=Portfolio Positions.*").JavaButton("attached text:=Adjustment.*")'
LIQ_Make_Selections_Window = 'JavaWindow("title:=Make Selection.*")'
LIQ_Make_Selections_Portfolio_Transfer_RadioButton = 'JavaWindow("title:=Make Selection.*").JavaRadioButton("attached text:=Portfolio Transfer.*")'
LIQ_Make_Selections_OK_Button = 'JavaWindow("title:=Make Selection.*").JavaButton("attached text:=OK.*")'
LIQ_Portfolio_Transfer_Released_Window = 'JavaWindow("title:=Portfolio Transfer.* Released.*")'
LIQ_Portfolio_Transfer_Window = 'JavaWindow("title:=Portfolio Transfer.*")'
LIQ_Portfolio_Transfer_Effective_Date = 'JavaWindow("title:=Portfolio Transfer.*").JavaEdit("attached text:=Effective Date:.*")'
LIQ_Portfolio_Transfer_To_Portfolio_Button = 'JavaWindow("title:=Portfolio Transfer.*").JavaButton("attached text:=Portfolio\.\.\.", "labeled_containers_path:=Tab:General;Group:To;.*")'
LIQ_Portfolio_Selections_For_Window = 'JavaWindow("title:=Portfolio Selection For.*")'
LIQ_Portfolio_Selections_For_PortfolioExpense = 'JavaWindow("title:=Portfolio Selection For.*").JavaTree("attached text:=Portfolio/Expense.*")'
LIQ_Portfolio_Selections_OK_Button = 'JavaWindow("title:=Portfolio Selection For.*").JavaButton("attached text:=OK.*")'
LIQ_Portfolio_Transfer_Expiry_Date = 'JavaWindow("title:=Portfolio Transfer.*").JavaEdit("attached text:=Expiry Date:.*")'
LIQ_Portfolio_Transfer_Amount = 'JavaWindow("title:=Portfolio Transfer.*").JavaEdit("attached text:=Amount:.*")'
LIQ_Portfolio_Transfer_Save_Button = 'JavaWindow("title:=Portfolio Transfer.*").JavaMenu("label:=File").JavaMenu("label:=Save")'
LIQ_Portfolio_Transfer_Tab_Button = 'JavaWindow("title:=Portfolio Transfer.*").JavaTab("Tagname:=TabFolder")'
LIQ_Portfolio_Transfer_Workflow_Java_Tree = 'JavaWindow("title:=Portfolio Transfer.*").JavaTree("attached text:=Drill down to perform Workflow item.*")'
LIQ_Portfolio_Positions_Exit_Button = 'JavaWindow("title:=Porfolio Positions.*").JavaButton("attached text:=Exit.*")'
LIQ_Make_Selections_SettledDiscountChage_RadioButton = 'JavaWindow("title:=Make Selection.*").JavaRadioButton("attached text:=Portfolio Settled Discount Change.*")'
LIQ_Make_Selections_TradeDateDiscountChange_RadioButton = 'JavaWindow("title:=Make Selection.*").JavaRadioButton("attached text:=Portfolio Trade Date Discount Change.*")'
LIQ_Make_Selections_AssignableChange_RadioButton = 'JavaWindow("title:=Make Selection.*").JavaRadioButton("attached text:=Portfolio Assignable Change.*")'
LIQ_Make_Selections_DefferedPLChange_RadioButton = 'JavaWindow("title:=Make Selection.*").JavaRadioButton("attached text:=Portfolio Deferred P/L Change.*")'
LIQ_Make_Selections_DefferedPLIndicatorChange_RadioButton = 'JavaWindow("title:=Make Selection.*").JavaRadioButton("attached text:=Portfolio Deferred P/L Indicator Change.*")'
LIQ_Make_Selections_TransactionCostAdjustment_RadioButton = 'JavaWindow("title:=Make Selection.*").JavaRadioButton("attached text:=Portfolio Transaction Cost Adjustment.*")'

###Portfolio Settled Discount Change###
LIQ_PortfolioSettledDiscountChange_Window = 'JavaWindow("title:=Portfolio Settled Discount Change.*")'
LIQ_PortfolioSettledDiscountChange_EffectiveDate = 'JavaWindow("title:=Portfolio Settled Discount Change.*").JavaEdit("attached text:=Effective Date:")'
LIQ_PortfolioSettledDiscountChange_CurrentAmount = 'JavaWindow("title:=Portfolio Settled Discount Change.*").JavaEdit("attached text:=Current:")'
LIQ_PortfolioSettledDiscountChange_AdjustmentAmount = 'JavaWindow("title:=Portfolio Settled Discount Change.*").JavaEdit("attached text:=\+/- Adjustment:")'
LIQ_PortfolioSettledDiscountChange_NewAmount = 'JavaWindow("title:=Portfolio Settled Discount Change.*").JavaEdit("attached text:=New:")'
LIQ_PortfolioSettledDiscountChange_GLOffset_Button = 'JavaWindow("title:=Portfolio Settled Discount Change.*").JavaButton("attached text:=GL Offset\.\.\.")'
LIQ_PortfolioSettledDiscountChange_Queries_GLEntries = 'JavaWindow("title:=Portfolio Settled Discount Change.*","displayed:=1").JavaMenu("label:=Options").JavaMenu("label:=GL Entries")'

###GL Offset Details Window###
LIQ_DebitGLOffsetDeatils_ExistingWIP_RadioButton = 'JavaWindow("title:=Debit GL Offset Details").JavaRadioButton("attached text:=Existing WIP")'
LIQ_DebitGLOffsetDeatils_InterestIncome_RadioButton = 'JavaWindow("title:=Debit GL Offset Details").JavaRadioButton("attached text:=Interest Income")'
LIQ_DebitGLOffsetDetails_GLShortName = 'JavaWindow("title:=Debit GL Offset Details").JavaList("attached text:=G/L Short Name:")'
LIQ_DebitGLOffsetDetails_WIPButton = 'JavaWindow("title:=Debit GL Offset Details").JavaButton("attached text:=WIP:")'
LIQ_DebitGLOffsetDetails_Ok_Button = 'JavaWindow("title:=Debit GL Offset Details").JavaButton("attached text:=OK")'

LIQ_FeesHeldAwaitingDispose_Window = 'JavaWindow("title:=Fees Held Awaiting Dispos\..*")'
LIQ_FeesHeldAwaitingDispose_List = 'JavaWindow("title:=Fees Held Awaiting Dispos\..*").JavaTree("attached text:=Drill down to view a WIP Item")'
LIQ_FeesHeldAwaitingDispose_Use_Button = 'JavaWindow("title:=Fees Held Awaiting Dispos\..*").JavaButton("attached text:=Use")'

###Approval###
LIQ_PortfolioSettledDiscountChange_Tab = 'JavaWindow("title:=Portfolio Settled Discount Change.*").JavaTab("Tagname:=TabFolder")'
LIQ_PortfolioSettledDiscountChange_WorkflowItems = 'JavaWindow("title:=Portfolio Settled Discount Change.*").JavaTree("attached text:=Drill down to perform Workflow item.*")'

###Portfolio Trade Date Discount Change Details###
LIQ_PortfolioTradeDateDiscountChange_Window = 'JavaWindow("title:=Portfolio Trade Date Discount Change.*")'
LIQ_PortfolioTradeDateDiscountChange_EffectiveDate = 'JavaWindow("title:=Portfolio Trade Date Discount Change.*").JavaEdit("attached text:=Effective Date:")'
LIQ_PortfolioTradeDateDiscountChange_CurrentAmount = 'JavaWindow("title:=Portfolio Trade Date Discount Change.*").JavaEdit("attached text:=Current:")'
LIQ_PortfolioTradeDateDiscountChange_AdjustmentAmount = 'JavaWindow("title:=Portfolio Trade Date Discount Change.*").JavaEdit("attached text:=\+/- Adjustment:")'
LIQ_PortfolioTradeDateDiscountChange_NewAmount = 'JavaWindow("title:=Portfolio Trade Date Discount Change.*").JavaEdit("attached text:=New:")'

###Portfolio Trade Date Discount Change Details Wokflow items###
LIQ_PortfolioTradeDateDiscountChange_Tab = 'JavaWindow("title:=Portfolio Trade Date Discount Change.*").JavaTab("Tagname:=TabFolder")'
LIQ_PortfolioTradeDateDiscountChange_WorkflowItems = 'JavaWindow("title:=Portfolio Trade Date Discount Change.*").JavaTree("attached text:=Drill down to perform Workflow item")'

LIQ_PortfolioTradeDateDiscountChange_Event_JavaTree = 'JavaWindow("title:=Portfolio Trade Date Discount Change.*").JavaTree("tagname:=Tree")'
