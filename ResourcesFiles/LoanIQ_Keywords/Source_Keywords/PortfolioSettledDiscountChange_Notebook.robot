*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords *** 

GLOffset Interest Income Details
    [Documentation]    This keyword is used to input details to GLOffset interest income details
    ...    @author:    sahalder    24JUL2020    initial create
    [Arguments]    ${sGL_ShortName}
    
    ###Pre-processing Keyword###
    ${GL_ShortName}    Acquire Argument Value    ${sGL_ShortName}
                  
    Mx LoanIQ Activate Window    ${LIQ_DebitGLOffsetDetails_Window}
    Mx LoanIQ Set    ${LIQ_DebitGLOffsetDeatils_InterestIncome_RadioButton}    ON
    Mx LoanIQ Select Combo Box Value    ${LIQ_DebitGLOffsetDetails_GLShortName}    ${GL_ShortName}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OffsetDetails
    Mx LoanIQ Click    ${LIQ_DebitGLOffsetDetails_Ok_Button}
    Mx LoanIQ Activate Window    ${LIQ_PortfolioSettledDiscountChange_Window}
    Select Menu Item    ${LIQ_PortfolioSettledDiscountChange_Window}    File    Save
    
    
Verification of Portfolio Selection Discount Change Transaction
    [Documentation]    This keyword is used to verify the released status of Portfolio Selection Discount Change
    ...    @author:    sahalder    27JUL2020
    ...    @update:    mcastro     13OCT2020    - updated double click to Java tree into Mx LoanIQ Select Or DoubleClick In Javatree
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}     
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Events
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Text In Javatree    ${LIQ_FacilityEvents_JavaTree}    Portfolio Settled Discount Change Released%yes 
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FacilityEvents_JavaTree}    Portfolio Settled Discount Change Released%d
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PortfolioSelectionDiscountChangeStatus     
    mx LoanIQ select    ${LIQ_PortfolioSettledDiscountChange_Queries_GLEntries}
    mx LoanIQ activate window  ${LIQ_GL_Entries_Window}   
    mx LoanIQ maximize    ${LIQ_GL_Entries_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PortfolioSelectionDiscountChangeGLEntries
    mx LoanIQ click element if present    ${LIQ_GL_Entries_Exit_Button}
    Select Menu Item    ${LIQ_FacilityNotebook_Window}    File    Exit

Select Portfolio Position Based on Portfolio Name and Facility Name for Portfolio Settled Discount Change
    [Documentation]    This keyword is used to select the Portfolio position for Settled discount change
    ...    @author: dahijara 26OCT2020
    [Arguments]    ${sPortfolio_Name}    ${sFacilityName_Name}
    
    ###Pre-processing keyword###
    ${Portfolio_Name}    Acquire Argument Value    ${sPortfolio_Name}
    ${FacilityName_Name}    Acquire Argument Value    ${sFacilityName_Name}
       
    Mx LoanIQ Activate Window    ${LIQ_Portfolio_Positions_Window}
    Mx LoanIQ Click    ${LIQ_Portfolio_Positions_CollapseAll_Button}
    Mx LoanIQ DoubleClick    ${LIQ_Portfolio_Positions_JavaTree}    ${Portfolio_Name}
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_Portfolio_Positions_JavaTree}    ${sFacilityName_Name}%s
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PortfolioPosition
    Mx LoanIQ Click    ${LIQ_Portfolio_Positions_Adjustment_Button}
    Mx LoanIQ Activate Window    ${LIQ_Make_Selections_Window}
    Mx LoanIQ Set    ${LIQ_Make_Selections_SettledDiscountChage_RadioButton}    ON
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PortfolioPosition
    Mx LoanIQ Click    ${LIQ_Make_Selections_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PortfolioSettledDiscountChange
    
Update Portfolio Settled Discount Change Details
    [Documentation]    This keyword is used to input details in Portfolio Settled Discount Chnage Window
    ...    @author: dahijara 26OCT2020    - Initial create
    ...    @update: dahijara    29OCT2020    - Added handling for warning messages when entering effective date.
    [Arguments]    ${sEffective_date}    ${sAdjustment_Amount}
    
    ###Pre-processing keywords###
    ${Effective_date}    Acquire Argument Value    ${sEffective_date}
    ${Adjustment_Amount}    Acquire Argument Value    ${sAdjustment_Amount}
                  
    Mx LoanIQ Activate Window    ${LIQ_PortfolioSettledDiscountChange_Window}
    Mx LoanIQ Enter    ${LIQ_PortfolioSettledDiscountChange_EffectiveDate}    ${Effective_date}
    Mx Press Combination    Key.TAB
    Repeat Keyword    3 times    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Enter    ${LIQ_PortfolioSettledDiscountChange_AdjustmentAmount}    ${Adjustment_Amount}
    Mx Press Combination    Key.TAB
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PortfolioSettledDiscountChange

Update GLOffset Details
    [Documentation]    This keyword is used to input details to GLOffset details
    ...    @author: dahijara 26OCT2020
    ...    @update: dahijara    29OCT2020    - Added handling for warning messages when saving data.
    ...    @update: mcastro     20NOV2020    - Update keyword used for selecting dealname in FHAD window
    [Arguments]    ${sGL_ShortName}    ${sGL_Offset_Type}    ${sAwaitingDispose}
    
    ###Pre-processing Keyword###
    ${GL_ShortName}    Acquire Argument Value    ${sGL_ShortName}
    ${GL_Offset_Type}    Acquire Argument Value    ${sGL_Offset_Type}
    ${AwaitingDispose}    Acquire Argument Value    ${sAwaitingDispose}

    Mx LoanIQ Activate Window    ${LIQ_PortfolioSettledDiscountChange_Window}
    Mx LoanIQ Click    ${LIQ_PortfolioSettledDiscountChange_GLOffset_Button}

    Mx LoanIQ Activate Window    ${LIQ_DebitGLOffsetDetails_Window}
    Run Keyword If    '${GL_Offset_Type}'=='Existing WIP'    Mx LoanIQ Set    ${LIQ_DebitGLOffsetDeatils_ExistingWIP_RadioButton}    ON

    Mx LoanIQ Select Combo Box Value    ${LIQ_DebitGLOffsetDetails_GLShortName}    ${GL_ShortName}
    Mx LoanIQ Click    ${LIQ_DebitGLOffsetDetails_WIPButton}
    Mx LoanIQ Activate Window    ${LIQ_FeesHeldAwaitingDispose_Window}
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_FeesHeldAwaitingDispose_List}    ${AwaitingDispose}%s
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OffsetDetails
    Mx LoanIQ Click    ${LIQ_FeesHeldAwaitingDispose_Use_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Activate Window    ${LIQ_DebitGLOffsetDetails_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OffsetDetails
    Mx LoanIQ Click    ${LIQ_DebitGLOffsetDetails_Ok_Button}
    Mx LoanIQ Activate Window    ${LIQ_PortfolioSettledDiscountChange_Window}
    Mx LoanIQ select    ${LIQ_PortfolioSettledDiscountChange_File_Save}
    Repeat Keyword    3 times    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OffsetDetails

Navigate to Portfolio Settled Discount Change Workflow and Proceed With Transaction
    [Documentation]    This keyword navigates to the Portfolio Settled Discount Change Workflow using the desired Transaction
    ...  @author: dahijara    26OCT2020    Initial create
    [Arguments]    ${sTransaction}

    ### Keyword Pre-processing ###
    ${Transaction}    Acquire Argument Value    ${sTransaction}

    Navigate Notebook Workflow    ${LIQ_PortfolioSettledDiscountChange_Window}    ${LIQ_PortfolioSettledDiscountChange_Tab}    ${LIQ_PortfolioSettledDiscountChange_WorkflowItems}    ${Transaction}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanDradown_Workflow