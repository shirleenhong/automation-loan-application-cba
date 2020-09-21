*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Get Facility Global Available to Draw Amount
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create

    Run Keyword   Get Facility Global Available to Draw Amount    ${ARGUMENT_1}

BUS_Get Facility Global Outstandings
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create

    Run Keyword   Get Facility Global Outstandings    ${ARGUMENT_1}
    
BUS_Navigate to Outstanding Select Window
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create

    Run Keyword   Navigate to Outstanding Select Window
    
BUS_Input Initial Loan Drawdown Details
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create

    Run Keyword   Input Initial Loan Drawdown Details    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}      ${ARGUMENT_6}
    
BUS_Validate Initial Loan Dradown Details
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create
    ...    @update: clanding    11AUG2020    - added optional argument

    Run Keyword   Validate Initial Loan Dradown Details    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}
    
BUS_Input General Loan Drawdown Details
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create
    ...    @update: clanding    11AUG2020    - added optional argument

    Run Keyword   Input General Loan Drawdown Details    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}
    ...    ${ARGUMENT_7}    ${ARGUMENT_8}    ${ARGUMENT_9}
    
BUS_Input Loan Drawdown Rates
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create

    Run Keyword   Input Loan Drawdown Rates    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}
    
BUS_Navigate to Drawdown Cashflow Window
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create

    Run Keyword   Navigate to Drawdown Cashflow Window
    
BUS_Verify if Status is set to Do It
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create

    Run Keyword   Verify if Status is set to Do It    ${ARGUMENT_1}
    
BUS_Navigate to GL Entries
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create

    Run Keyword   Navigate to GL Entries
    
BUS_Send Initial Drawdown to Approval
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create

    Run Keyword   Send Initial Drawdown to Approval
    
BUS_Approve Initial Drawdown
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create

    Run Keyword   Approve Initial Drawdown
    
BUS_Send Initial Drawdown to Rate Approval
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create

    Run Keyword   Send Initial Drawdown to Rate Approval
    
BUS_Approve Initial Drawdown Rate
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create

    Run Keyword   Approve Initial Drawdown Rate
    
BUS_Generate Rate Setting Notices for Drawdown
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create

    Run Keyword   Generate Rate Setting Notices for Drawdown    ${ARGUMENT_1}    ${ARGUMENT_2}
   
BUS_Populate Outstanding Select Window
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    28APR2020    - initial create

    Run Keyword   Populate Outstanding Select Window    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}

BUS_Populate General Tab in Initial Drawdown
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    28APR2020    - initial create

    Run Keyword   Populate General Tab in Initial Drawdown    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}

BUS_Create Flex Repayment Schedule
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    28APR2020    - initial create

    Run Keyword   Create Flex Repayment Schedule

BUS_Add Fixed PI Items in Flexible Schedule
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    28APR2020    - initial create

    Run Keyword   Add Fixed PI Items in Flexible Schedule    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}

BUS_Calculate Payments in Flexible Schedule
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    29APR2020    - initial create

    Run Keyword   Calculate Payments in Flexible Schedule    ${ARGUMENT_1}

BUS_Add Principal Only Item in Flexible Schedule
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    29APR2020    - initial create

    Run Keyword   Add Principal Only Item in Flexible Schedule    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}    ${ARGUMENT_8}    ${ARGUMENT_9}

BUS_Add Interest Only Item in Flexible Schedule
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    29APR2020    - initial create

    Run Keyword   Add Interest Only Item in Flexible Schedule    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}    ${ARGUMENT_8}    ${ARGUMENT_9}    ${ARGUMENT_10}    ${ARGUMENT_11}

BUS_Calculate Payments in Flexible Schedule After Adding Items
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    29APR2020    - initial create

    Run Keyword   Calculate Payments in Flexible Schedule After Adding Items    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}    ${ARGUMENT_8}    ${ARGUMENT_9}    ${ARGUMENT_10}

BUS_Validate Flex Schedule Details in Repayment Schedule
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    29APR2020    - initial create

    Run Keyword   Validate Flex Schedule Details in Repayment Schedule     ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Navigate Split Cashflows for Drawdown
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    29APR2020    - initial create

    Run Keyword   Navigate Split Cashflows for Drawdown

BUS_Populate Split Cashflow Details
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    29APR2020    - initial create

    Run Keyword   Populate Split Cashflow Details    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}

BUS_Get Current Commitment Amount
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    29APR2020    - initial create

    Run Keyword   Get Current Commitment Amount    ${ARGUMENT_1}

BUS_Get New Facility Global Outstandings
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    29APR2020    - initial create

    Run Keyword   Get New Facility Global Outstandings    ${ARGUMENT_1}

BUS_Compute New Global Outstandings of the Facility
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    29APR2020    - initial create

    Run Keyword   Compute New Global Outstandings of the Facility    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Validate Outstandings
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    29APR2020    - initial create

    Run Keyword   Validate Outstandings    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Get New Facility Available to Draw Amount
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    29APR2020    - initial create

    Run Keyword   Get New Facility Available to Draw Amount    ${ARGUMENT_1}

BUS_Compute New Facility Available to Draw Amount after Drawdown
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    29APR2020    - initial create

    Run Keyword   Compute New Facility Available to Draw Amount after Drawdown    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Validate Draw Amounts
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    29APR2020    - initial create

    Run Keyword   Validate Draw Amounts    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Navigate to Loan Drawdown Workflow and Proceed With Transaction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    29APR2020    - initial create

    Run Keyword   Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${ARGUMENT_1}

BUS_Create Principal Repayment Schedule
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    19MAY2020    - initial create

    Run Keyword   Create Principal Repayment Schedule    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}

BUS_Send Loan Drawdown to Approval
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    19MAY2020    - initial create

    Run Keyword   Send Loan Drawdown to Approval

BUS_Approve Loan Drawdown via WIP LIQ Icon
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    19MAY2020    - initial create

    Run Keyword   Approve Loan Drawdown via WIP LIQ Icon    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}

BUS_Send Loan Drawdown Rates to Approval
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    19MAY2020    - initial create

    Run Keyword   Send Loan Drawdown Rates to Approval

BUS_Open Loan Initial Drawdown Notebook via WIP - Awaiting Rate Approval
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    19MAY2020    - initial create

    Run Keyword   Open Loan Initial Drawdown Notebook via WIP - Awaiting Rate Approval    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}

BUS_Release Loan Initial Drawdown
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    19MAY2020    - initial create

    Run Keyword   Release Loan Initial Drawdown

BUS_Verify Select Fixed Payment Amount
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    26MAY2020    - initial create

    Run Keyword   Verify Select Fixed Payment Amount

BUS_Navigate to Loan Pending Tab and Proceed with the Transaction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    29MAY2020    - initial create

    Run Keyword   Navigate to Loan Pending Tab and Proceed with the Transaction    ${ARGUMENT_1}

BUS_Add Items in Flexible Schedule
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    04JUNY2020    - initial create

    Run Keyword   Add Items in Flexible Schedule    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}    ${ARGUMENT_8}

BUS_Create Temporary Payment Plan on Repayment Schedule
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    04JUNY2020    - initial create

    Run Keyword   Create Temporary Payment Plan on Repayment Schedule

BUS_Get Original Data on Loan Amounts Section
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    02JUN2020    - initial create

    Run Keyword   Get Original Data on Loan Amounts Section    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}

BUS_Navigate to Principal Payment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    02JUN2020    - initial create

    Run Keyword   Navigate to Principal Payment

BUS_Get Updated Data on Loan Amounts Section after Principal Payment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    02JUN2020    - initial create

    Run Keyword   Get Updated Data on Loan Amounts Section after Principal Payment    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}

BUS_Navigate to Outstanding Select Window from Deal
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    01JUN2020    - initial create

    Run Keyword   Navigate to Outstanding Select Window from Deal
    
BUS_Add Borrower Base Rate and Facility Spread
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    24JUN2020    - initial create

    Run Keyword   Add Borrower Base Rate and Facility Spread    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Save Initial Drawdown Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    19JUN2020    - initial create

    Run Keyword   Save Initial Drawdown Notebook

BUS_Navigate to View/Update Lender Share via Loan Drawdown Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    19JUN2020    - initial create

    Run Keyword   Navigate to View/Update Lender Share via Loan Drawdown Notebook

BUS_Set Base Rate Details
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    19JUN2020    - initial create

    Run Keyword   Set Base Rate Details    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Go To Initial Drawdown GL Entries
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    19JUN2020    - initial create

    Run Keyword   Go To Initial Drawdown GL Entries

BUS_Go To Facility From Initial Drawdown Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    19JUN2020    - initial create

    Run Keyword   Go To Facility From Initial Drawdown Notebook

BUS_Validate New Facility Available to Draw Amount
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    19JUN2020    - initial create

    Run Keyword   Validate New Facility Available to Draw Amount    ${ARGUMENT_1}    

BUS_Create Flex Repayment Schedule for Initial Drawdown
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    03JUL2020    - initial create

    Run Keyword   Create Flex Repayment Schedule for Initial Drawdown
    
BUS_Create Flex Reschedule
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    27JUL2020    - initial create

    Run Keyword   Create Flex Reschedule
    
BUS_Add Items in Flexible Reschedule Add Window
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    27JUL2020    - initial create

    Run Keyword   Add Items in Flexible Reschedule Add Window        ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}
    
BUS_Create Temporary Payment Plan After Reschedule
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    27JUL2020    - initial create

    Run Keyword   Create Temporary Payment Plan After Reschedule
     
BUS_Become Legal Payment Plan on Temporary Payment Plan
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    27JUL2020    - initial create

    Run Keyword   Become Legal Payment Plan on Temporary Payment Plan
    
BUS_Save And Exit Repayment Schedule Window
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    27JUL2020    - initial create

    Run Keyword   Save And Exit Repayment Schedule Window
    
BUS_Add MIS Code in Loan Drawdown
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: jloretiz    02AUG2020    - initial create

    Run Keyword   Add MIS Code in Loan Drawdown    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Add Holiday Calendar Date
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: jloretiz    02AUG2020    - initial create

    Run Keyword   Add Holiday Calendar Date    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}    ${ARGUMENT_8}    ${ARGUMENT_9}

BUS_Enter Initial Loan Drawdown Details
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    30JUL2020    - initial create

    Run Keyword   Enter Initial Loan Drawdown Details    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}    ${ARGUMENT_8}

BUS_Enter Loan Drawdown Details
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    30JUL2020    - initial create

    Run Keyword   Enter Loan Drawdown Details    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}

BUS_Enter Loan Drawdown Rates
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    30JUL2020    - initial create

    Run Keyword   Enter Loan Drawdown Rates    ${ARGUMENT_1}    ${ARGUMENT_2}       

BUS_Compute New Facility Available to Draw Amount
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    30JUL2020    - initial create

    Run Keyword   Compute New Facility Available to Draw Amount    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    

BUS_Accept Loan Drawdown Rates for Term Facility
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    03SEP2020    - initial create

    Run Keyword    Accept Loan Drawdown Rates for Term Facility    ${ARGUMENT_1}

BUS_Validate Rate Set
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    03SEP2020    - initial create

    Run Keyword    Validate Rate Set    ${ARGUMENT_1}

BUS_Validate Global Facility Amounts - Balanced
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    03SEP2020    - initial create

    Run Keyword    Validate Global Facility Amounts - Balanced    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Enter Loan Drawdown Details for AUD Libor Option
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    03SEP2020    - initial create

    Run Keyword    Enter Loan Drawdown Details for AUD Libor Option    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}    ${ARGUMENT_8}

BUS_New Outstanding Select
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    08SEP2020    - initial create

    Run Keyword    New Outstanding Select    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}
    
    BUS_Enter Loan Drawdown Details for USD Libor Option
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    24AUG2020    - initial create

    Run Keyword   Enter Loan Drawdown Details for USD Libor Option    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}

BUS_Input Loan Drawdown Rates for Term Facility (USD)
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    24AUG2020    - initial create

    Run Keyword   Input Loan Drawdown Rates for Term Facility (USD)    ${ARGUMENT_1}

BUS_Create Repayment Schedule - Fixed Principal Plus Interest Due
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    24AUG2020    - initial create

    Run Keyword   Create Repayment Schedule - Fixed Principal Plus Interest Due

BUS_Verify Fixed Principal Payment Amount
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    24AUG2020    - initial create

    Run Keyword   Verify Fixed Principal Payment Amount    ${ARGUMENT_1}
    
BUS_Validate Total Amount of the Repayment Schedule vs Current Host Bank Amount
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    24AUG2020    - initial create

    Run Keyword   Validate Total Amount of the Repayment Schedule vs Current Host Bank Amount    ${ARGUMENT_1}

BUS_Approve Initial Loan Drawdown via WIP
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    24AUG2020    - initial create

    Run Keyword   Approve Initial Loan Drawdown via WIP    ${ARGUMENT_1}

BUS_Set FX Rates Loan Drawdown
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    24AUG2020    - initial create

    Run Keyword   Set FX Rates Loan Drawdown    ${ARGUMENT_1}

BUS_Send to Rate Approval Initial Loan Drawdown via WIP
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    24AUG2020    - initial create

    Run Keyword   Send to Rate Approval Initial Loan Drawdown via WIP    ${ARGUMENT_1}

BUS_Rate Approval Initial Loan Drawdown via WIP
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    24AUG2020    - initial create

    Run Keyword   Rate Approval Initial Loan Drawdown via WIP    ${ARGUMENT_1}

BUS_Generate Rate Setting Notices via WIP
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    24AUG2020    - initial create

    Run Keyword   Generate Rate Setting Notices via WIP    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Release Initial Loan Drawdown
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    24AUG2020    - initial create

    Run Keyword   Release Initial Loan Drawdown    ${ARGUMENT_1}
    