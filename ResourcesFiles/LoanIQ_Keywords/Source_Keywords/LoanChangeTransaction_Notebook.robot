*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Navigate to Loan Change Transaction Notebook
    [Documentation]    This keyword navigates the user from Loan Notebook to the Loan Change Transaction Notebook.
    ...    @author: rtarayao    02OCT2019    - Initial Create
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    mx LoanIQ select    ${LIQ_Loan_Options_LoanChangeTransaction_Menu}
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    Verify Window    ${LIQ_LoanChangeTransaction_Window}        

Modify Risk Type, Payment Mode and Maturity Date
    [Documentation]    This keyword modifies the following information for the Loan:
    ...                - Risk Type
    ...                - Maturity Date
    ...                - Payment Mode
    ...    @author: rtarayao    02OCT2019    - Initial Create
    [Arguments]    ${sRiskType}    ${sPaymentMode}    ${sMaturityDate} 
    mx LoanIQ activate window    ${LIQ_LoanChangeTransaction_Window}
    mx LoanIQ click    ${LIQ_LoanChangeTransaction_Add_Button}
    mx LoanIQ activate window    ${LIQ_SelectChangeField_Window}      
    Mx LoanIQ Select String    ${LIQ_SelectChangeField_Tree}    Risk Type
    mx LoanIQ click    ${LIQ_SelectChangeField_OK_Button}
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_LoanChangeTransaction_Tree}    Risk Type%d
    mx LoanIQ activate window    ${LIQ_RiskTypeSelector_Window}
    mx LoanIQ enter    ${LIQ_RiskTypeSelector_Description_RadioButton}    ON    
    mx LoanIQ enter    ${LIQ_RiskTypeSelector_Description_Textfield}    ${sRiskType}    
    mx LoanIQ click    ${LIQ_RiskTypeSelector_OK_Button}
    mx LoanIQ click    ${LIQ_LoanChangeTransaction_Add_Button}
    Mx LoanIQ Select String    ${LIQ_SelectChangeField_Tree}    Payment Mode
    mx LoanIQ click    ${LIQ_SelectChangeField_OK_Button}
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_LoanChangeTransaction_Tree}    Payment Mode%d
    mx LoanIQ activate window    ${LIQ_EnterPaymentMode_Window}
    Mx LoanIQ Select Combo Box Value    ${LIQ_EnterPaymentMode_PaymentMode_Dropdownlist}    ${sPaymentMode}
    mx LoanIQ click    ${LIQ_EnterPaymentMode_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    mx LoanIQ click    ${LIQ_LoanChangeTransaction_Add_Button}
    Mx LoanIQ Select String    ${LIQ_SelectChangeField_Tree}    Maturity Date
    mx LoanIQ click    ${LIQ_SelectChangeField_OK_Button}
    mx LoanIQ activate window    ${LIQ_LoanChangeTransaction_Window}
    Mx LoanIQ Click Javatree Cell    ${LIQ_LoanChangeTransaction_Tree}    Maturity Date%Maturity Date%Field Name
    Mx Native Type    {ENTER}
    mx LoanIQ activate window    ${LIQ_EnterMaturityDate_Window}
    mx LoanIQ enter    ${LIQ_EnterMaturityDate_MaturityDate_Datefield}    ${sMaturityDate}
    mx LoanIQ click    ${LIQ_EnterMaturityDate_OK_Button}
        
    
    
    
    
       
    
    
    
    
    
    
    
