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