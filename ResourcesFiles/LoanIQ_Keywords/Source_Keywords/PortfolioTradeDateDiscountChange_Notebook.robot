*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Select Portfolio Position and Make Adjustment
    [Documentation]    This keyword is used to select the Portfolio position and make adjustment
    ...    @author: Archana 23JUL2020
    [Arguments]    ${sPortfolio_Position}
    
    ###Pre-processing keyword###
    ${Portfolio_Position}    Acquire Argument Value    ${sPortfolio_Position}
       
    Mx LoanIQ Activate Window    ${LIQ_Portfolio_Positions_Window}
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_Portfolio_Positions_JavaTree}    ${Portfolio_Position}%s
    Mx LoanIQ Click    ${LIQ_Portfolio_Positions_Adjustment_Button}
    Mx LoanIQ Activate Window    ${LIQ_Make_Selections_Window}
    Mx LoanIQ Set    ${LIQ_Make_Selections_TradeDateDiscountChange_RadioButton}    ON
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PortfolioPosition
    Mx LoanIQ Click    ${LIQ_Make_Selections_OK_Button}

Portfolio Trade Date Discount Change Details
    [Documentation]    This keyword is used to input details in Portfolio Trade Date Discount Chnage Window
    ...    @author: Archana 23JUL2020
    ...            - Added Pre and Post processing Keyword
    [Arguments]    ${sEffective_date}    ${sAdjustment_Amount}    ${RuntimeVar_CurrentAmount}=None
    
    ###Pre-processing keywords###
    ${Effective_date}    Acquire Argument Value    ${sEffective_date}
    ${Adjustment_Amount}    Acquire Argument Value    ${sAdjustment_Amount}
                  
    Mx LoanIQ Activate    ${LIQ_PortfolioTradeDateDiscountChange_Window}
    Mx LoanIQ Enter    ${LIQ_PortfolioTradeDateDiscountChange_EffectiveDate}    ${Effective_date}
    ${CurrentAmount}    Mx LoanIQ Get Data    ${LIQ_PortfolioTradeDateDiscountChange_CurrentAmount}    input=value   
    Mx LoanIQ Enter    ${LIQ_PortfolioTradeDateDiscountChange_AdjustmentAmount}    ${Adjustment_Amount}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PortfolioTradeDateDiscountChange
    Select Menu Item    ${LIQ_PortfolioTradeDateDiscountChange_Window}    File    Save
    
    Save Values of Runtime Execution on Excel File    ${RuntimeVar_CurrentAmount}    ${CurrentAmount}    
    [Return]    ${CurrentAmount}  
    
Send to Approval Portfolio Trade Date Discount Change
    [Documentation]    This keyword sends the Portfolio Trade Date Discount Change to Approval. 
    ...    @author: Archana  23JUL2020        
    mx LoanIQ activate    ${LIQ_PortfolioTradeDateDiscountChange_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_PortfolioTradeDateDiscountChange_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PortfolioTradeDateDiscountChange_WorkflowItems}    Send to Approval%d
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}  
    
Approve Portfolio Trade Date Discount Change
    [Documentation]    This keyword navigates the 'Work In Process' window and approves the Portfolio Trade Date Discount Change.
    ...    @author: Archana 23JUL2020
    mx LoanIQ activate window    ${LIQ_PortfolioTradeDateDiscountChange_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_PortfolioTradeDateDiscountChange_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PortfolioTradeDateDiscountChange_WorkflowItems}    Approval%d 
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Select Menu Item    ${LIQ_PortfolioTradeDateDiscountChange_Window}    File    Exit
      
Navigate to Pending Portfolio Trade Date Discount Change
     [Documentation]    This keyword is used to Navigate to the Pending Transaction
    ...    @author: Archana 23JUL2020    
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Pending 
    Mx LoanIQ DoubleClick    ${LIQ_FacilityNotebook_PendingListItem}    Awaiting Release
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PendingAwaitingReleaseTransaction 
    Mx LoanIQ Close Window    ${LIQ_FacilityNotebook_Window}
    
Release Portfolio Trade Date Discount Change
    [Documentation]    This keyword navigates the 'Work In Process' window and release the Portfolio Trade Date Discount Change.
    ...    @author: Archana 23JUL2020
    ...           - Added Post-processing keyword
    [Arguments]    ${RuntimeVar_New_Amount}=None       
    mx LoanIQ activate    ${LIQ_PortfolioTradeDateDiscountChange_Window}
    ${New_Amount}    Mx LoanIQ Get Data    ${LIQ_PortfolioTradeDateDiscountChange_NewAmount}    input=value    
    Mx LoanIQ Select Window Tab    ${LIQ_PortfolioTradeDateDiscountChange_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PortfolioTradeDateDiscountChange_WorkflowItems}    Release%d
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
    ###Post-Processing keyword###
    Save Values of Runtime Execution on Excel File    ${RuntimeVar_New_Amount}    ${New_Amount}    
    [Return]    ${New_Amount} 
   
Validate Events Tab for Portfolio Trade Date Discount Change
    [Documentation]    This  keyword will validate Portfolio Trade Date Discount Change Events in the Events tab
    ...    @author: Archana 21JUL2020
    mx LoanIQ activate window    ${LIQ_PortfolioTradeDateDiscountChange_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_PortfolioTradeDateDiscountChange_Tab}    Events
    Mx LoanIQ Verify Text In Javatree    ${LIQ_PortfolioTradeDateDiscountChange_Event_JavaTree}    Released
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PortfolioTradeDateDiscountChange_ReleasedStatus   
    
Validation of Adjusted Amount
    [Documentation]    This keyword is used to validate the new adjusted Amount
    ...    @author :Archana    22JUL2020
    [Arguments]    ${CurrentAmount}    ${New_Amount}    ${Adjustment_Amount}        
     ${CurrentAmount}    Remove Comma, Negative Character and Convert to Number    ${CurrentAmount}
     ${New_Amount}    Remove Comma, Negative Character and Convert to Number    ${New_Amount}
     ${Computed_NewAmount}    Evaluate    ${CurrentAmount}+${Adjustment_Amount}
     ${Computed_NewAmount}    Convert To String    ${Computed_NewAmount}
     ${New_Amount}    Convert To String    ${New_Amount}
     ${NewAmount_ValidateStatus}    Set Variable If    '${New_Amount}'=='${Computed_NewAmount}'    True    