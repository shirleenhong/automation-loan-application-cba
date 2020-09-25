*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_New Facility Select
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create

    Run Keyword   New Facility Select    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}

BUS_Enter Dates on Facility Summary
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create

    Run Keyword    Enter Dates on Facility Summary    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}

BUS_Verify Main SG Details
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create

    Run Keyword    Verify Main SG Details    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}
    
BUS_Add Risk Type
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create

    Run Keyword    Add Risk Type    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}
    
BUS_Add Loan Purpose Type
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create

    Run Keyword    Add Loan Purpose Type    ${ARGUMENT_1}
    
BUS_Add Currency Limit
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create

    Run Keyword    Add Currency Limit    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}
    
BUS_Add Borrower
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create

    Run Keyword    Add Borrower    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}
    
BUS_Modify Ongoing Fee Pricing - Insert Add
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create

    Run Keyword    Modify Ongoing Fee Pricing - Insert Add    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}
    
BUS_Modify Ongoing Fee Pricing - Insert After
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create

    Run Keyword    Modify Ongoing Fee Pricing - Insert After    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}
    
BUS_Modify Interest Pricing - Insert Add
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create

    Run Keyword    Modify Interest Pricing - Insert Add    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}
    
BUS_Verify Pricing Rules
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create

    Run Keyword    Verify Pricing Rules    ${ARGUMENT_1}
    
BUS_Validate Facility
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create

    Run Keyword    Validate Facility
    
BUS_Close Facility Navigator Window
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create

    Run Keyword    Close Facility Navigator Window
    
BUS_Add New Facility
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    10MAY2020    - initial create

    Run Keyword    Add New Facility   ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}

BUS_Set Facility Dates
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    10MAY2020    - initial create

    Run Keyword    Set Facility Dates   ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}
    
BUS_Set Facility Risk Type
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    10MAY2020    - initial create

    Run Keyword    Set Facility Risk Type   ${ARGUMENT_1}
    
BUS_Set Facility Loan Purpose Type
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    10MAY2020    - initial create

    Run Keyword    Set Facility Loan Purpose Type   ${ARGUMENT_1}
    
BUS_Add Facility Currency
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    10MAY2020    - initial create

    Run Keyword    Add Facility Currency    ${ARGUMENT_1}
    
BUS_Add Facility Borrower - Add All
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    10MAY2020    - initial create

    Run Keyword    Add Facility Borrower - Add All   ${ARGUMENT_1}
    
BUS_Validate Risk Type in Borrower Select
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    10MAY2020    - initial create

    Run Keyword    Validate Risk Type in Borrower Select   ${ARGUMENT_1}
    
BUS_Validate Currency Limit in Borrower Select
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    10MAY2020    - initial create

    Run Keyword    Validate Currency Limit in Borrower Select   ${ARGUMENT_1}
    
BUS_Complete Facility Borrower Setup
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    10MAY2020    - initial create

    Run Keyword    Complete Facility Borrower Setup
    
BUS_Navigate to Modify Ongoing Fee Window
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    10MAY2020    - initial create

    Run Keyword    Navigate to Modify Ongoing Fee Window
    
BUS_Validate Facility Pricing Window
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    10MAY2020    - initial create

    Run Keyword    Validate Facility Pricing Window   ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Add Facility Ongoing Fees
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    10MAY2020    - initial create

    Run Keyword    Add Facility Ongoing Fees   ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}
    ...    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}    ${ARGUMENT_8}

BUS_Validate Ongoing Fee or Interest
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    10MAY2020    - initial create

    Run Keyword    Validate Ongoing Fee or Interest 
    
BUS_Add Facility Interest
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    10MAY2020    - initial create

    Run Keyword    Add Facility Interest   ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}
    ...    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}    ${ARGUMENT_8}

BUS_Validate Facility Pricing Rule Items
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    10MAY2020    - initial create

    Run Keyword    Validate Facility Pricing Rule Items    ${ARGUMENT_1}         

BUS_Close Facility Notebook and Navigator Windows
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    01JUN2020    - initial create

    Run Keyword    Close Facility Notebook and Navigator Windows

BUS_Validate Multi CCY Facility
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    01JUN2020    - initial create

    Run Keyword    Validate Multi CCY Facility

BUS_Launch Existing Facility
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    02JUN2020    - initial create

    Run Keyword    Launch Existing Facility    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Get Original Data on Global Facility Amounts Section
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    02JUN2020    - initial create

    Run Keyword    Get Original Data on Global Facility Amounts Section    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}

BUS_Get Updated Data on Global Facility Amounts Section after Principal Payment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    02JUN2020    - initial create

    Run Keyword    Get Updated Data on Global Facility Amounts Section after Principal Payment    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}

BUS_Validate Facility Events Tab after Payment Transaction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    02JUN2020    - initial create

    Run Keyword    Validate Facility Events Tab after Payment Transaction    ${ARGUMENT_1}    

BUS_Go to Facility Notebook Update Mode
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    05JUN2020    - initial create

    Run Keyword    Go to Facility Notebook Update Mode

BUS_Navigate to Facility Interest Pricing Option Details
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    05JUN2020    - initial create

    Run Keyword    Navigate to Facility Interest Pricing Option Details    ${ARGUMENT_1}

BUS_Setup Facility All-In Rate Cap
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    05JUN2020    - initial create

    Run Keyword    Setup Facility All-In Rate Cap    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}

BUS_Setup Facility All-In Rate Floor
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    05JUN2020    - initial create

    Run Keyword    Setup Facility All-In Rate Floor    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}

BUS_Confirm Facility Interest Pricing Options Settings
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    05JUN2020    - initial create

    Run Keyword    Confirm Facility Interest Pricing Options Settings

BUS_Save Facility Notebook Transaction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    05JUN2020    - initial create

    Run Keyword    Save Facility Notebook Transaction

BUS_Validate Facility Cap Settings
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    05JUN2020    - initial create

    Run Keyword    Validate Facility Cap Settings    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}

BUS_Validate Facility Floor Settings
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    05JUN2020    - initial create

    Run Keyword    Validate Facility Floor Settings    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}

BUS_Navigate to Deal Notebook Workflow and Proceed With Transaction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    05JUN2020    - initial create

    Run Keyword    Navigate to Deal Notebook Workflow and Proceed With Transaction    ${ARGUMENT_1}

BUS_Add Interest Pricing
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    10JUN2020    - initial create

    Run Keyword    Add Interest Pricing    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Set External Rating on Interest Pricing Modification
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    10JUN2020    - initial create

    Run Keyword    Set External Rating on Interest Pricing Modification    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}

BUS_Validate Interest Pricing Formula
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    10JUN2020    - initial create

    Run Keyword    Validate Interest Pricing Formula    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}
    ...    ${ARGUMENT_7}    ${ARGUMENT_8}    ${ARGUMENT_9}    ${ARGUMENT_10}    ${ARGUMENT_11}    ${ARGUMENT_12}

BUS_Select Interest Pricing Formula
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    10JUN2020    - initial create

    Run Keyword    Select Interest Pricing Formula    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}
    ...    ${ARGUMENT_7}    ${ARGUMENT_8}    ${ARGUMENT_9}    ${ARGUMENT_10}    ${ARGUMENT_11}    ${ARGUMENT_12}

BUS_Add After Interest Pricing
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    10JUN2020    - initial create

    Run Keyword    Add After Interest Pricing    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Set Interest Pricing Option Condition
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    10JUN2020    - initial create

    Run Keyword    Set Interest Pricing Option Condition    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Set Formula Category Values
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    10JUN2020    - initial create

    Run Keyword    Set Formula Category Values    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Validate and Confirm Interest Pricing
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    10JUN2020    - initial create

    Run Keyword    Validate and Confirm Interest Pricing

BUS_Navigate to Interest Pricing Zoom
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    10JUN2020    - initial create

    Run Keyword    Navigate to Interest Pricing Zoom

BUS_Validate Interest Pricing Zoom Matrix
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    10JUN2020    - initial create

    Run Keyword    Validate Interest Pricing Zoom Matrix    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}
    ...    ${ARGUMENT_7}    ${ARGUMENT_8}    ${ARGUMENT_9}    ${ARGUMENT_10}    ${ARGUMENT_11}    ${ARGUMENT_12}    ${ARGUMENT_13}

BUS_Validate Interest Pricing Zoom Details
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    10JUN2020    - initial create

    Run Keyword    Validate Interest Pricing Zoom Details    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}
    ...    ${ARGUMENT_7}    ${ARGUMENT_8}    ${ARGUMENT_9}    ${ARGUMENT_10}    ${ARGUMENT_11}    ${ARGUMENT_12}

BUS_Verify If Facility Window Does Not Exist
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    22JUN2020    - initial create
    ...    @update: amansuet    24JUN2020    - updated based on keyword updates

    Run Keyword    Verify If Facility Window Does Not Exist

BUS_Navigate to Ongoing Fee Pricing Window
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    26JUN2020    - initial create

    Run Keyword    Navigate to Ongoing Fee Pricing Window

BUS_Validate Facility Pricing Items
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    26JUN2020    - initial create

    Run Keyword    Validate Facility Pricing Items    ${ARGUMENT_1}

BUS_Navigate to Facility Increase Decrease Schedule
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    01JUL2020    - initial create

    Run Keyword    Navigate to Facility Increase Decrease Schedule    ${ARGUMENT_1}

BUS_Reschedule Facility
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    01JUL2020    - initial create

    Run Keyword    Reschedule Facility    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}

BUS_Increase Facility Schedule
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    01JUL2020    - initial create

    Run Keyword    Increase Facility Schedule    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Decrease Facility Schedule
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    01JUL2020    - initial create

    Run Keyword    Decrease Facility Schedule    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Verify Remaining Amount after Increase
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    01JUL2020    - initial create

    Run Keyword    Verify Remaining Amount after Increase    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Verify Remaining Amount after Decrease
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    01JUL2020    - initial create

    Run Keyword    Verify Remaining Amount after Decrease    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Equalize Amounts and Verify that Remaining Amount is Zero
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    01JUL2020    - initial create

    Run Keyword    Equalize Amounts and Verify that Remaining Amount is Zero    ${ARGUMENT_1}

BUS_Create Notices
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    01JUL2020    - initial create

    Run Keyword    Create Notices    ${ARGUMENT_1}
 
BUS_Set Schedule Status to Final and Save
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    01JUL2020    - initial create

    Run Keyword    Set Schedule Status to Final and Save

BUS_Validate Commitment Amount
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    01JUL2020    - initial create

    Run Keyword    Validate Commitment Amount    ${ARGUMENT_1}
    
BUS_Add Interest Pricing Financial Ratio
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    30JUN2020    - initial create

    Run Keyword    Add Interest Pricing Financial Ratio

BUS_Set Financial Ratio
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    30JUN2020    - initial create

    Run Keyword    Set Financial Ratio    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    

BUS_Enter Facility Dates With Business Day and Non-Business Day Validations for Term Facility
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    30JUN2020    - initial create

    Run Keyword    Enter Facility Dates With Business Day and Non-Business Day Validations for Term Facility    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    

BUS_Enter Facility Dates With Business Day and Non-Business Day Validations for Revolver Facility
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    30JUN2020    - initial create

    Run Keyword    Enter Facility Dates With Business Day and Non-Business Day Validations for Revolver Facility    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}
    
BUS_Check Pending Transaction in Facility
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dfajardo    22JUL2020    - initial create

    Run Keyword    Check Pending Transaction in Facility    ${ARGUMENT_1}    ${ARGUMENT_2} 
    
BUS_Modify Current Amortization Schedule
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dfajardo    22JUL2020    - initial create

    Run Keyword    Modify Current Amortization Schedule    ${ARGUMENT_1}  
    
BUS_Create Pending Transaction from Schedule item
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dfajardo    22JUL2020    - initial create

    Run Keyword    Create Pending Transaction from Schedule item    ${ARGUMENT_1}
    
BUS_Verify if Facility is Terminated
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dfajardo    22JUL2020    - initial create

    Run Keyword    Verify if Facility is Terminated    ${ARGUMENT_1}    ${ARGUMENT_2}     
   
BUS_Go to Modify Ongoing Fee
    [Documentation]    This keyword is used to click Mondify Ongoing Fee Button.
    ...    @author: clanding    04AUG2020    - initial create

    Run Keyword    Go to Modify Ongoing Fee

BUS_Click Modify Interest Pricing Button
    [Documentation]    This keyword is used to click Modify Interest Pricing button in Facility Pricing window.
    ...    @author: clanding    04AUG2020    - initial create

    Run Keyword    Click Modify Interest Pricing Button

BUS_Get Effective and Expiry Date from Summary Tab in Facility Notebook
    [Documentation]    This keyword is used to get Effective and Expiry Date from Fcility Notebook > Summary tab.
    ...    @author: clanding    04AUG2020    - initial create

    Run Keyword    Get Effective and Expiry Date from Summary Tab in Facility Notebook    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Get Original Amount on Summary Tab of Facility Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    06AUG2020    - initial create

    Run Keyword    Get Original Amount on Summary Tab of Facility Notebook
    
BUS_Get Original Amount on Facility Lender Shares
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    06AUG2020    - initial create

    Run Keyword    Get Original Amount on Facility Lender Shares    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}    ${ARGUMENT_8}    ${ARGUMENT_9}
    
BUS_Validate the Updates on Facility Notebook Summary Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    06AUG2020    - initial create

    Run Keyword    Validate the Updates on Facility Notebook Summary Tab    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}    ${ARGUMENT_8}    ${ARGUMENT_9}    ${ARGUMENT_10}
    
BUS_Validate Restrictions and Events Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    06AUG2020    - initial create

    Run Keyword    Validate Restrictions and Events Tab    ${ARGUMENT_1}
    
BUS_Validate the Updates on Facility Lender Shares
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    06AUG2020    - initial create

    Run Keyword    Validate the Updates on Facility Lender Shares    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}    ${ARGUMENT_8}    ${ARGUMENT_9}    

BUS_Validate Host Bank Share Gross Amounts
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    03SEP2020    - initial create

    Run Keyword    Validate Host Bank Share Gross Amounts    ${ARGUMENT_1}

BUS_Post Validation Of Computed Amounts In Facility After Drawdown
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    22SEP2020    - initial create

    Run Keyword    Post Validation Of Computed Amounts In Facility After Drawdown    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}

BUS_Post Validation Of Facility Summary Amounts After Drawdown
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    22SEP2020    - initial create

    Run Keyword    Post Validation Of Facility Summary Amounts After Drawdown    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}