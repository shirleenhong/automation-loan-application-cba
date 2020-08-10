*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords *** 

Navigate to Manual Cashflow Select
    [Documentation]    This keyword is used for navigating to Manual Cashflow Window thru Accounting and Control icon.
    ...    @author: mgaling
    ...    @update: hstone      02JUL2020      - Added Keyword Pre-processing
    ...    @update: hstone      07JUL2020      - Moved from 'IncomingManualCashflow_Notebook.robot' to 'ManualCashflow_Notebook.robot'
    [Arguments]    ${sDeal_Name}=None    ${sDeal_Borrower}=None

    ### Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    ${Deal_Borrower}    Acquire Argument Value    ${sDeal_Borrower}
    
    Select Actions    [Actions];Accounting and Control
    mx LoanIQ activate window     ${LIQ_AccountingANDControl_Window}
    Mx LoanIQ Set    ${LIQ_AccountingANDControl_ManualCashflow_RadioButton}    ON
    
    ###Add Deal###
    Run Keyword If    '${Deal_Name}'!='None'    Run Keywords    mx LoanIQ click    ${LIQ_AccountingANDControl_Deal_Button}
    ...    AND    mx LoanIQ activate window    ${LIQ_DealSelect_Window}
    ...    AND    Mx LoanIQ Set    ${LIQ_DelectSelect_Active_RadioButton}    ON
    ...    AND    mx LoanIQ enter    ${LIQ_DealSelect_Search_TextField}    ${Deal_Name}
    ...    AND    mx LoanIQ click    ${LIQ_DealSelect_Ok_Button}   
    
    ###Add Customer###
    Run Keyword If    '${Deal_Borrower}'!='None'    Run Keywords    mx LoanIQ click    ${LIQ_AccountingANDControl_Customer_Button}
    ...    AND    mx LoanIQ activate window    ${LIQ_CustomerSelect_Window}
    ...    AND    mx LoanIQ enter    ${LIQ_CustomerSelect_ShortName_Field}    ${Deal_Borrower}
    ...    AND    mx LoanIQ click    ${LIQ_CustomerSelect_OK_Button}        
    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AccountingAndControl
    mx LoanIQ activate window    ${LIQ_AccountingANDControl_Window}
    mx LoanIQ click    ${LIQ_AccountingANDControl_OK_Button}