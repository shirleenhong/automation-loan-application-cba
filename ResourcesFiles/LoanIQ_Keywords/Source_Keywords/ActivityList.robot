*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Navigate to Fee Activity List from Loan
    [Documentation]    This keyword navigates and validates Fee Activity List from Loan
    ...    @author: fmamaril
    Mx LoanIQ Activate Window    ${LIQ_Loan_Window}
    Mx LoanIQ Select    ${LIQ_Loan_Queries_FeeActivityLIst_Menu}        
    Mx LoanIQ Activate Window    ${LIQ_ActivityList_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ActivityList
    
Validate Loan Activity list Tab
    [Documentation]    This keyword validates Loan Acitivity List Tab
    ...    @author: fmamaril
    Mx LoanIQ Select Window Tab    ${LIQ_ActivityList_Tab}    Loan Activity List
    Mx LoanIQ Verify Object Exist    ${LIQ_LoanActivityList_ActualActivity_JavaTree}    
    Mx LoanIQ Verify Object Exist    ${LIQ_LoanActivityList_ProjectedActivity_JavaTree}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanActivityList
    
Validate Ongoing Fee Income Tab
    [Documentation]    This keyword validates Ongoing Fee Income Tab
    ...    @author: fmamaril
    Mx LoanIQ Select Window Tab    ${LIQ_ActivityList_Tab}    Ongoing Fee Income
    Mx LoanIQ Verify Object Exist    ${LIQ_OngoingFeeIncome_ActualActivity_JavaTree}    
    Mx LoanIQ Verify Object Exist    ${LIQ_OngoingFeeIncome_ProjectedActivity_JavaTree}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OngoingFeeIncome

Validate Ongoing Fee Expense Tab
    [Documentation]    This keyword validates Ongoing Fee Expense Tab
    ...    @author: fmamaril
    Mx LoanIQ Select Window Tab    ${LIQ_ActivityList_Tab}    Ongoing Fee Expense
    Mx LoanIQ Verify Object Exist    ${LIQ_OngoingFeeExpense_ActualActivity_JavaTree}    
    Mx LoanIQ Verify Object Exist    ${LIQ_OngoingFeeExpense_ProjectedActivity_JavaTree}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OngoingFeeExpense

Validate Free Form Event Fee Income
    [Documentation]    This keyword validates Free Form Events fee Income Tab
    ...    @author: fmamaril
    Mx LoanIQ Select Window Tab    ${LIQ_ActivityList_Tab}    Free Form Event Fee Income
    Mx LoanIQ Verify Object Exist    ${LIQ_FreeFormEventFeeIncome_ActualActivity_JavaTree}    
    Mx LoanIQ Verify Object Exist    ${LIQ_FreeFormEventFeeIncome_ProjectedActivity_JavaTree}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FreeFormEventFeeIncome

Validate Free Form Event Fee Expense
    [Documentation]    This keyword validates Free Form Events fee Expense Tab
    ...    @author: fmamaril
    Mx LoanIQ Select Window Tab    ${LIQ_ActivityList_Tab}    Free Form Event Fee Expense
    Mx LoanIQ Verify Object Exist    ${LIQ_FreeFormEventFeeExpense_ActualActivity_JavaTree}    
    Mx LoanIQ Verify Object Exist    ${LIQ_FreeFormEventFeeExpense_ProjectedActivity_JavaTree}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FreeFormEventFeeExpense