*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Open Ongoing Fee from Deal Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    04JUN2020    - initial create

    Run Keyword    Open Ongoing Fee from Deal Notebook    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Update Cycle on Commitment Fee
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    04JUN2020    - initial create

    Run Keyword    Update Cycle on Commitment Fee    ${ARGUMENT_1}    ${ARGUMENT_2}    

BUS_Run Online Acrual to Commitment Fee
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    04JUN2020    - initial create

    Run Keyword    Run Online Acrual to Commitment Fee

BUS_Navigate to Scheduled Activity Filter
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    04JUN2020    - initial create

    Run Keyword    Navigate to Scheduled Activity Filter

BUS_Set Scheduled Activity Filter
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    04JUN2020    - initial create

    Run Keyword    Set Scheduled Activity Filter    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}

BUS_Select Fee Due
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    04JUN2020    - initial create

    Run Keyword    Select Fee Due    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    

BUS_Compute Commitment Fee Amount Per Cycle
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    04JUN2020    - initial create

    Run Keyword    Compute Commitment Fee Amount Per Cycle    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}

BUS_Select Cycle Fee Payment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    05JUN2020    - initial create

    Run Keyword    Select Cycle Fee Payment

BUS_Enter Effective Date for Ongoing Fee Payment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    05JUN2020    - initial create

    Run Keyword    Enter Effective Date for Ongoing Fee Payment    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Navigate to Cashflow - Ongoing Fee
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    05JUN2020    - initial create

    Run Keyword    Navigate to Cashflow - Ongoing Fee

BUS_Send Ongoing Fee Payment to Approval
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    05JUN2020    - initial create

    Run Keyword    Send Ongoing Fee Payment to Approval

BUS_Approve Ongoing Fee Payment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    05JUN2020    - initial create

    Run Keyword    Approve Ongoing Fee Payment

BUS_Release Ongoing Fee Payment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    05JUN2020    - initial create

    Run Keyword    Release Ongoing Fee Payment

BUS_Validate Details on Acrual Tab - Commitment Fee
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    05JUN2020    - initial create

    Run Keyword    Validate Details on Acrual Tab - Commitment Fee    ${ARGUMENT_1}    ${ARGUMENT_2}    

BUS_Validate release of Ongoing Fee Payment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    05JUN2020    - initial create

    Run Keyword    Validate release of Ongoing Fee Payment

BUS_Validate GL Entries for Ongoing Fee Payment - Bilateral Deal
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    05JUN2020    - initial create

    Run Keyword    Validate GL Entries for Ongoing Fee Payment - Bilateral Deal    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Get Commitment Fee Payment Information for Reversal Validation
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    05JUN2020    - initial create

    Run Keyword    Get Commitment Fee Payment Information for Reversal Validation    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}

BUS_Navigate and Verify Accrual Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    15JUL2020    - initial create

    Run Keyword    Navigate and Verify Accrual Tab    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}    ${ARGUMENT_8}    ${ARGUMENT_9}    ${ARGUMENT_10}

BUS_Navigate and Verify Accrual Share Adjustment Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    15JUL2020    - initial create

    Run Keyword    Navigate and Verify Accrual Share Adjustment Notebook    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}

BUS_Validate Manual Adjustment Value
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    15JUL2020    - initial create

    Run Keyword    Validate Manual Adjustment Value    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Validate Cycle Due New Value
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    15JUL2020    - initial create

    Run Keyword    Validate Cycle Due New Value    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Validate Projected EOC Due New Value
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    15JUL2020    - initial create

    Run Keyword    Validate Projected EOC Due New Value    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Validate Manual Adjustment Total Value
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    15JUL2020    - initial create

    Run Keyword    Validate Manual Adjustment Total Value    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Validate Cycle Due Total Value
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    15JUL2020    - initial create

    Run Keyword    Validate Cycle Due Total Value    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Validate Ongoing Fee List
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dfajardo    22JUL2020    - initial create

    Run Keyword    Validate Ongoing Fee List    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}  

BUS_Retrieve Intial Amounts in Accrual Tab and Evaluate Expected Values for Reversal Post Validation
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    16JUL2020    - initial create

    Run Keyword    Retrieve Intial Amounts in Accrual Tab and Evaluate Expected Values for Reversal Post Validation    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}

BUS_Retrieve Initial Data From GL Entries After Payment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    16JUL2020    - initial create

    Run Keyword    Retrieve Initial Data From GL Entries After Payment    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}
    ...    ${ARGUMENT_8}    ${ARGUMENT_9}    ${ARGUMENT_10}    ${ARGUMENT_11}    ${ARGUMENT_12}    ${ARGUMENT_13}

BUS_Navigate to Reverse Fee Workflow and Proceed With Transaction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    16JUL2020    - initial create

    Run Keyword    Navigate to Reverse Fee Workflow and Proceed With Transaction    ${ARGUMENT_1}

BUS_Validate Payment Reversal in Accrual Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    16JUL2020    - initial create

    Run Keyword    Validate Payment Reversal in Accrual Tab    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Validate Payment Reversal in Events Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    16JUL2020    - initial create

    Run Keyword    Validate Payment Reversal in Events Tab    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}
    ...    ${ARGUMENT_8}    ${ARGUMENT_9}    ${ARGUMENT_10}    ${ARGUMENT_11}

BUS_Validate GL Entries for Payment Reversal
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    16JUL2020    - initial create

    Run Keyword    Validate GL Entries for Payment Reversal    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}
    ...    ${ARGUMENT_8}    ${ARGUMENT_9}
