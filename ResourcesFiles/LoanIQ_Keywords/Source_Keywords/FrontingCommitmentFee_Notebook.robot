*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Navigate to Fronting Commitment Fee Notebook
    [Documentation]    This keywod navigates to Fronting Commitment Fee Notebook from Facility.
    ...    @author: rtarayao    30AUG2019    - Initial Create
    [Arguments]    ${sFeeType}
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    mx LoanIQ select    ${LIQ_FacilityNotebook_Queries_OngoingFeeList}
    mx LoanIQ activate window    ${LIQ_Facility_FeeList}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Facility_FeeList_JavaTree}    ${sFeeType}%d


Get Fronting Commitment Fee Current Rate
    [Documentation]    This keyword gets the Fronting Commitment Fee Rate and returns the value.
    ...    author: rtarayao    30AUG2019    - Initial Create
    mx LoanIQ activate window    ${LIQ_FrontingCmtFeeNotebook_Window}
    ${Rate}    Mx LoanIQ Get Data    ${LIQ_FrontingCommitmentFee_CurrentRate_Field}    value%Rate
    ${Rate}    Convert To String    ${Rate}
    ${Rate}    Remove String    ${Rate}    .000000%    
    Log    The Fronting Commitment Fee Rate is ${Rate}
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    Fronting Commitment Fee Rate
    Take Screenshot    ${SCREENSHOT_FILENAME}
    [Return]    ${Rate}

Get Fronting Commitment Fee Currency
    [Documentation]    This keyword gets the Fronting Commitment Fee Currency and returns the value.
    ...    author: rtarayao    30AUG2019    - Initial Create
    mx LoanIQ activate window    ${LIQ_FrontingCmtFeeNotebook_Window}
    ${FeeCurrency}    Mx LoanIQ Get Data    ${LIQ_FrontingCommitmentFee_Currency_Text}    value%Currency
    Log    The Fronting Commitment Fee Currency is ${FeeCurrency}
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    Fronting Commitment Fee Currency
    Take Screenshot    ${SCREENSHOT_FILENAME}
    [Return]    ${FeeCurrency}

Get Fronting Commitment Fee Effective and Actual Expiry Date
    [Documentation]    This keyword returns the Fronting Commitment Fee Effective and Expiry Date value.
    ...    author: rtarayao    30AUG2019    - Initial Create
    mx LoanIQ activate window    ${LIQ_FrontingCmtFeeNotebook_Window}
    ${FeeEffectiveDate}    Mx LoanIQ Get Data    ${LIQ_FrontingCommitmentFee_EffectiveDate_Field}    value%EffectiveDate
    ${FeeActualExpiryDate}    Mx LoanIQ Get Data    ${LIQ_FrontingCommitmentFee_ActualExpiryDate_Text}    value%ActualExpiryDate
    Log    The Fronting Commitment Fee Effective Date is ${FeeEffectiveDate}
    Log    The Fronting Commitment Fee Actual Expiry Date is ${FeeActualExpiryDate}
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    Fronting Commitment Fee Effective and Expiry Dates
    Take Screenshot    ${SCREENSHOT_FILENAME}
    [Return]    ${FeeEffectiveDate}    ${FeeActualExpiryDate}
    
Get Fronting Commitment Fee Adjusted Due Date
    [Documentation]    This keyword returns the Fronting Commitment Fee Adjusted Due Date value.
    ...    author: rtarayao    30AUG2019    - Initial Create
    mx LoanIQ activate window    ${LIQ_FrontingCmtFeeNotebook_Window}
    ${FeeAdjustedDueDate}    Mx LoanIQ Get Data    ${LIQ_FrontingCommitmentFee_AdjustedDueDate}    value%AdjDueDate
    Log    The Fronting Commitment Fee Adjusted Due Date is ${FeeAdjustedDueDate}
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    Fronting Commitment Fee Adj Due Date
    Take Screenshot    ${SCREENSHOT_FILENAME}
    [Return]    ${FeeAdjustedDueDate}
    
Get Fronting Commitment Accrued to Date Amount
    [Documentation]    This keyword returns the Fronting Commitment Fee total accured to date value.
    ...    @author: rtarayao    23AUG2019    - Initial Create
    mx LoanIQ activate window    ${LIQ_FrontingCmtFeeNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FrontingCommitmentFee_Tab}    Accrual
    ${AccruedtodateAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_FrontingCommitmentFee_Acrual_JavaTree}    TOTAL:${SPACE}%Accrued to date%Accruedtodate    
    Log    The Fronting Commitment Fee Accrued to Date amount is ${AccruedtodateAmount} 
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    Fronting Commitment Fee Accrual Screen
    Take Screenshot    ${SCREENSHOT_FILENAME}
    [Return]    ${AccruedtodateAmount} 

    
    
    
    
    
    
    
    
               
