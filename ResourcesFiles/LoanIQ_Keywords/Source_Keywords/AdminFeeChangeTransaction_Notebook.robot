*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Set Admin Fee Change Transaction General Tab Details
    [Documentation]    This keyword sets the details in the General Tab of the Admin Fee Change Transaction Notebook.
    ...    
    ...    | Arguments |
    ...    'Deal_Name' = Name of the Deal
    ...    'EffectiveDate' = Effective date of the Admin Fee Change transaction.
    ...    'ChangeField' = "Effective Date", "Expiry Date", or "Amount Due"
    ...    'NewValue' = A new value for the Admin Fee Change transaction.
    ...                 Should be a date value if 'ChangeField' is Effective Date or Expiry Date. Ex. 01-Jan-2018
    ...                 Should be an amount if 'ChangeField' is Amount Due. Ex. 1,000.00
    ...    
    ...    @author: bernchua
    ...    @update: ritragel    28FEB2019    Added Warning Message Handler for Non-Business Day Dates
    ...    @update: hstone      11JUN2020    - Added Keyword Pre-processing
    ...                                      - Added Take Screenshot
    [Arguments]    ${sDeal_Name}    ${sEffectiveDate}    ${sChangeField}    ${sNewValue}

    ### Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    ${EffectiveDate}    Acquire Argument Value    ${sEffectiveDate}
    ${ChangeField}    Acquire Argument Value    ${sChangeField}
    ${NewValue}    Acquire Argument Value    ${sNewValue}

    mx LoanIQ activate    ${LIQ_AdminFeeChange_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_AdminFeeChange_Tab}    General
    Verify If Text Value Exist as Static Text on Page    Admin Fee Change Transaction    ${Deal_Name}
    mx LoanIQ enter    ${LIQ_AdminFeeChange_EffectiveDate_Datefield}    ${EffectiveDate}
    mx LoanIQ select    ${LIQ_AdminFeeChange_File_Save}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_OK_Button}
    ${ChangeField_AmountDue}    Run Keyword If    '${ChangeField}'=='Amount Due'    Set Change Field For Amortization Amount Due
    Run Keyword If    '${ChangeField_AmountDue}'!='None'    Edit Value On Change Item    ${ChangeField_AmountDue}    ${NewValue}
    ...    ELSE IF    '${ChangeField_AmountDue}'=='None'    Edit Value On Change Item    ${ChangeField}    ${NewValue}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AdminFeeNotebook_General
    
Edit Value On Change Item
    [Documentation]    This keyword does the Admin Fee Change Transaction specifically for the Amortization Period Original Amount Due.
    ...    @author: bernchua
    ...    @update: ritragel    28FEB2019    Added Warning Message Handler for Non-Business Day Dates
    [Arguments]    ${ChangeField}    ${NewValue}
    mx LoanIQ activate    ${LIQ_AdminFeeChange_Window}
    ${ItemExist}    Run Keyword And Return Status    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_AdminFeeChange_General_Tree}    ${ChangeField}%Old Value%value    
    ${OldValue}    Run Keyword If    ${ItemExist}==True    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_AdminFeeChange_General_Tree}    ${ChangeField}%Old Value%value
    Run Keyword If    ${ItemExist}==False or '${OldValue}'=='${EMPTY}'    Run Keywords
    ...    Add Item For Admin Fee Change    ${ChangeField}
    ...    AND    Update Item For Admin Fee Change    ${ChangeField}    ${NewValue}
    ...    ELSE IF    ${ItemExist}==True and '${OldValue}'!='${EMPTY}'    Run Keywords
    ...    Update Item For Admin Fee Change    ${ChangeField}    ${NewValue}
    ...    AND    Validate Admin Fee Change Old And New Value    ${ChangeField}
        
Add Item For Admin Fee Change
    [Documentation]    This keyword adds a Change Item in the General Tab of the Admin Fee Change Transaction Notebook.
    ...    @author: bernchua
    ...    @update: ritragel    28FEB2019    Added Warning Message Handler for Non-Business Day Dates
    [Arguments]    ${ChangeField}
    mx LoanIQ activate    ${LIQ_AdminFeeChange_Window}
    mx LoanIQ click    ${LIQ_AdminFeeChange_Add_Button}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_SelectAChangeField_Tree}    ${ChangeField}%s
    mx LoanIQ click    ${LIQ_SelectAChangeField_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
Update Item For Admin Fee Change
    [Documentation]    This keyword updates the selected Admin Fee Change Transaction Item.
    ...    @author: bernchua
    [Arguments]    ${ChangeField}    ${NewValue}
    mx LoanIQ activate    ${LIQ_AdminFeeChange_Window}
    Mx LoanIQ DoubleClick    ${LIQ_AdminFeeChange_General_Tree}    ${ChangeField}
    Run Keyword If    '${ChangeField}'=='Effective Date'    Run Keywords
    ...    mx LoanIQ enter    ${LIQ_EnterEffectiveDate_Datefield}    ${NewValue}
    ...    AND    mx LoanIQ click    ${LIQ_EnterEffectiveDate_OK_Button}
    ...    ELSE IF    '${ChangeField}'=='Expiry Date'    Run Keywords
    ...    mx LoanIQ enter    ${LIQ_EnterExpiryDate_Datefield}    ${NewValue}
    ...    AND    mx LoanIQ click    ${LIQ_EnterExpiryDate_OK_Button}
    ...    ELSE    Run Keywords
    ...    mx LoanIQ enter    ${LIQ_EnterAmortPeriodOrigAmountDue_Textfield}    ${NewValue}
    ...    AND    mx LoanIQ click    ${LIQ_EnterAmortPeriodOrigAmountDue_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
Validate Admin Fee Change Old And New Value
    [Documentation]    This keyword validates the Admin Fee Change Transaction's Old and New Value and should not be equal.
    ...    @author: bernchua
    [Arguments]    ${ChangeField}
    mx LoanIQ activate    ${LIQ_AdminFeeChange_Window}
    ${OldValue}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_AdminFeeChange_General_Tree}    ${ChangeField}%Old Value%value
    ${NewValue}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_AdminFeeChange_General_Tree}    ${ChangeField}%New Value%value
    Run Keyword If    '${OldValue}'!='${NewValue}'    Log    Old value ${OldValue} will be updated to New Value ${NewValue}, and is verified.    
    
Set Change Field For Amortization Amount Due
    [Documentation]    This keyword sets the 'ChangeField' to the dynamic value of the 'Amortization Period Original Amount Due' with dates.
    ...    @author: bernchua
    ${AdminFee_EffectiveDate}    Get Data From LoanIQ    ${LIQ_AdminFeeNotebook_Window}    ${LIQ_AdminFeeNotebook_JavaTab}    General    ${LIQ_AdminFeeNotebook_EffectiveDate_Datefield}
    ${AdminFee_AmortizeEndDate}    Get Data From LoanIQ    ${LIQ_AdminFeeNotebook_Window}    ${LIQ_AdminFeeNotebook_JavaTab}    General    ${LIQ_AdminFee_EndDate_Datefield}
    ${ChangeField}    Set Variable    ${AdminFee_EffectiveDate} - ${AdminFee_AmortizeEndDate} Amortization Period Original Amount Due
    [Return]    ${ChangeField}

Navigate to Admin Fee Change Workflow and Proceed With Transaction
    [Documentation]    This keyword navigates to the Admin Fee Change Workflow using the desired Transaction
    ...  @author: hstone    11JUN2020    Initial create
    [Arguments]    ${sTransaction}

    ### Keyword Pre-processing ###
    ${Transaction}    Acquire Argument Value    ${sTransaction}

    Navigate Notebook Workflow    ${LIQ_AdminFeeChange_Window}    ${LIQ_AdminFeeChange_Tab}    ${LIQ_AdminFeeChange_Workflow_Tree}    ${Transaction}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AdminFeeChange_Workflow


