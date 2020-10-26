*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords *** 
    
Navigate to GL Entries_Upfront Fee payment
    [Documentation]    This keyword will be used to navigate to GL Entries from Upfront Fee payment from Borrower Window
    ...    @author: Archana 13Jul2020   
    mx LoanIQ activate window    ${LIQ_UpfrontFeePayment_Notebook}    
    Select Menu Item    ${LIQ_UpfrontFeePayment_Notebook}    Queries    GL Entries 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ activate window    ${LIQ_UpfrontFee_GLEntries_Window}   
    mx LoanIQ maximize    ${LIQ_UpfrontFee_GLEntries_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/GLEntries
    
Close GL Entries_Upfront Fee payment Notebook
    [Documentation]    This keyword is used to close GL Entries Notebook
    ...    @author:Archana 13Jul2020
    Mx LoanIQ Close Window    ${LIQ_UpfrontFee_GLEntries_Window}    
    
Navigate Notebook Workflow -Create Cashflow
    [Documentation]    This keyword is used to create cashflow in workflow
    ...    @author:Archana 13Jul2020
    mx LoanIQ activate    ${LIQ_UpfrontFeePayment_Notebook}
    Mx LoanIQ Select Window Tab    ${LIQ_UpfrontFeePayment_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_UpfrontFeePayment_WorkflowItems}    Create Cashflows%d
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_BreakFunding_No_Button}
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
  
Navigate to Pending Upfront Fee Payment Notebook
     [Documentation]    This keyword is used to Navigate to the Pending Transaction
    ...    @author: Archana 13Jul2020    
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Pending 
    Mx LoanIQ DoubleClick    ${LIQ_DealNotebook_Pending_ListItem}    Awaiting Release
    Mx LoanIQ Close Window    ${LIQ_DealNotebook_Window}     
 
Navigate to Portfolio Positions Notebook
    [Documentation]    This keyword is used to navigate to Portfolio Positions
    ...    @author:Archana 13Jul2020
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}    
    Select Menu Item    ${LIQ_DealNotebook_Window}    Options    Portfolio Positions...   
   
Select Portfolio Position
    [Documentation]    This keyword is used to select the Portfolio position
    ...    @author: Archana 13Jul2020
    [Arguments]    ${sPortfolio_Position}
    
    ###Pre-processing keyword###
    ${Portfolio_Position}    Acquire Argument Value    ${sPortfolio_Position}
       
    Mx LoanIQ Activate Window    ${LIQ_Portfolio_Positions_Window}
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_Portfolio_Positions_JavaTree}    ${Portfolio_Position}%s
    Mx LoanIQ Click    ${LIQ_Portfolio_Positions_Adjustment_Button}
    Mx LoanIQ Activate Window    ${LIQ_Make_Selections_Window}
    Mx LoanIQ Set    ${LIQ_Make_Selections_SettledDiscountChage_RadioButton}    ON
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PortfolioPosition
    Mx LoanIQ Click    ${LIQ_Make_Selections_OK_Button}
    
Portfolio Settled Discount Change
    [Documentation]    This keyword is used to input details in Portfolio Settled Discount Chnage Window
    ...    @author: Archana 13Jul2020
    ...    @update: mcastro    22OCT2020    Added Clicking of warning OK button if present
    [Arguments]    ${sEffective_date}    ${sAdjustment_Amount}
    
    ###Pre-processing keywords###
    ${Effective_date}    Acquire Argument Value    ${sEffective_date}
    ${Adjustment_Amount}    Acquire Argument Value    ${sAdjustment_Amount}
                  
    Mx LoanIQ Activate Window    ${LIQ_PortfolioSettledDiscountChange_Window}
    Mx LoanIQ Enter    ${LIQ_PortfolioSettledDiscountChange_EffectiveDate}    ${Effective_date}
    Mx LoanIQ Enter    ${LIQ_PortfolioSettledDiscountChange_AdjustmentAmount}    ${Adjustment_Amount}
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PortfolioSettledDiscountChange
    Mx LoanIQ Click    ${LIQ_PortfolioSettledDiscountChange_GLOffset_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_PortfolioSettledDiscountChange_GLOffset_Button}    
    
GLOffset Details
    [Documentation]    This keyword is used to input details to GLOffset details
    ...    @author: Archana 13Jul2020
    [Arguments]    ${sGL_ShortName}    ${sAwaitingDispose}
    
    ###Pre-processing Keyword###
    ${GL_ShortName}    Acquire Argument Value    ${sGL_ShortName}
    ${AwaitingDispose}    Acquire Argument Value    ${sAwaitingDispose}
              
    Mx LoanIQ Activate Window    ${LIQ_DebitGLOffsetDetails_Window}
    Mx LoanIQ Set    ${LIQ_DebitGLOffsetDeatils_ExistingWIP_RadioButton}    ON
    Mx LoanIQ Select Combo Box Value    ${LIQ_DebitGLOffsetDetails_GLShortName}    ${GL_ShortName}
    Mx LoanIQ Click    ${LIQ_DebitGLOffsetDetails_WIPButton}
    Mx LoanIQ Activate Window    ${LIQ_FeesHeldAwaitingDispose_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FeesHeldAwaitingDispose_List}    ${AwaitingDispose}%s
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OffsetDetails
    Mx LoanIQ Click    ${LIQ_FeesHeldAwaitingDispose_Use_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Activate Window    ${LIQ_DebitGLOffsetDetails_Window}
    Mx LoanIQ Click    ${LIQ_DebitGLOffsetDetails_Ok_Button}
    Mx LoanIQ Activate Window    ${LIQ_PortfolioSettledDiscountChange_Window}
    Select Menu Item    ${LIQ_PortfolioSettledDiscountChange_Window}    File    Save
    
Send to Approval Portfolio Selection Discount Change
    [Documentation]    This keyword sends the Portfolio Selection Discount Change to Approval. 
    ...    @author: Archana  13Jul2020        
    mx LoanIQ activate    ${LIQ_PortfolioSettledDiscountChange_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_PortfolioSettledDiscountChange_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PortfolioSettledDiscountChange_WorkflowItems}    Send to Approval%d
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}   
    
Approve Portfolio Selection Discount Change
    [Documentation]    This keyword navigates the 'Work In Process' window and approves the Portfolio Selection Discount Change.
    ...    @author: Archana 13Jul2020
    mx LoanIQ activate window    ${LIQ_PortfolioSettledDiscountChange_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_PortfolioSettledDiscountChange_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PortfolioSettledDiscountChange_WorkflowItems}    Approval%d 
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Select Menu Item    ${LIQ_PortfolioSettledDiscountChange_Window}    File    Exit
    Close All Windows on LIQ   
    
Navigate to Pending Portfolio Selection Discount Change
    [Documentation]    This keyword is used to Navigate to Pending transaction is facility Notebook
    ...    @author: Archana 13Jul2020
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Pending 
    Mx LoanIQ DoubleClick    ${LIQ_FacilityNotebook_PendingListItem}    Awaiting Release
 
Release Portfolio Selection Discount Change
    [Documentation]    This keyword navigates the 'Work In Process' window and release the Portfolio Selection Discount Change.
    ...    @author: Archana 13Jul2020    
    mx LoanIQ activate    ${LIQ_PortfolioSettledDiscountChange_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_PortfolioSettledDiscountChange_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PortfolioSettledDiscountChange_WorkflowItems}    Release%d
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Select Menu Item    ${LIQ_PortfolioSettledDiscountChange_Window}    File    Exit
    
Verification of Portfolio Selection Discount Change
    [Documentation]    This keyword is used to verify the released status of Portfolio Selection Discount Change
    ...    @author:Archana 13Jul2020
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}     
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Events
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Text In Javatree    ${LIQ_FacilityEvents_JavaTree}    Portfolio Settled Discount Change Released%yes
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PortfolioSelectionDiscountChangeStatus     
    Select Menu Item    ${LIQ_FacilityNotebook_Window}    File    Exit 
    
Verification of Released Upfront Fee Payment Status
    [Documentation]    This keyword is used to verify the Released Upfront Fee Payment status
    ...    @author: Archana 13Jul2020
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}     
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Events
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Text In Javatree    ${LIQ_Events_Javatree}    Upfront Fee Payment from Borrower/Agent Released%yes 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/UpfrontFeePaymentStatus       
    Select Menu Item    ${LIQ_DealNotebook_Window}    File    Exit   