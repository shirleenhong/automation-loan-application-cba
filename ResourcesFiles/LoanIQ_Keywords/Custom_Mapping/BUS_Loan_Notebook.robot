*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Get Interest Actual Due Date on Loan Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    01JUN2020    - initial create

    Run Keyword   Get Interest Actual Due Date on Loan Notebook    ${ARGUMENT_1}
 
   
BUS_Select Reschedule Menu in Repayment Schedule
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    24JUN2020    - initial create

    Run Keyword   Select Reschedule Menu in Repayment Schedule


BUS_Select Type of Schedule
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    24JUN2020    - initial create

    Run Keyword   Select Type of Schedule    ${ARGUMENT_1}


BUS_Add Item in Flexible Schedule Window
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    24JUN2020    - initial create

    Run Keyword   Add Item in Flexible Schedule Window


BUS_Tick Flexible Schedule Add Item Pay Thru Maturity
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    24JUN2020    - initial create

    Run Keyword   Tick Flexible Schedule Add Item Pay Thru Maturity


BUS_Set Flexible Schedule Add Item Type
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    24JUN2020    - initial create

    Run Keyword   Set Flexible Schedule Add Item Type    ${ARGUMENT_1}


BUS_Tick Flexible Schedule Add Item PI Amount
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    24JUN2020    - initial create

    Run Keyword   Tick Flexible Schedule Add Item PI Amount    ${ARGUMENT_1}


BUS_Enter Flexible Schedule Add Item PI Amount
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    24JUN2020    - initial create

    Run Keyword   Enter Flexible Schedule Add Item PI Amount    ${ARGUMENT_1}


BUS_Click OK in Add Items for Flexible Schedule
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    24JUN2020    - initial create

    Run Keyword   Click OK in Add Items for Flexible Schedule


BUS_Click OK in Flexible Schedule Window
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    24JUN2020    - initial create

    Run Keyword   Click OK in Flexible Schedule Window


BUS_Save and Exit Repayment Schedule For Loan
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    24JUN2020    - initial create

    Run Keyword   Save and Exit Repayment Schedule For Loan

BUS_Navigate to Loan Pending Tab and Proceed with the Pending Transaction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    19JUN2020    - initial create

    Run Keyword   Navigate to Loan Pending Tab and Proceed with the Pending Transaction    ${ARGUMENT_1}

BUS_Navigate to an Existing Loan
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    04JUNY2020    - initial create

    Run Keyword   Navigate to an Existing Loan    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}
    
BUS_Navigate to Existing Loan
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    29MAY2020    - initial create

    Run Keyword   Navigate to Existing Loan    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

    
BUS_Open Existing Inactive Loan from a Facility
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dfajardo    22JUL2020    - initial create

    Run Keyword   Open Existing Inactive Loan from a Facility    ${ARGUMENT_1}
    
BUS_Verify Global Current Amount
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dfajardo    22JUL2020    - initial create

    Run Keyword   Verify Global Current Amount
    
BUS_Verify Cycle Due Amount
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dfajardo    22JUL2020    - initial create

    Run Keyword   Verify Cycle Due Amount    ${ARGUMENT_1}

BUS_Verify Current Commitment Amount if Zero
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dfajardo    22JUL2020    - initial create

    Run Keyword   Verify Current Commitment Amount if Zero

BUS_Select Resync Settings in Flexible Schedule
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    28JUL2020    - initial create

    Run Keyword   Select Resync Settings in Flexible Schedule    ${ARGUMENT_1}

BUS_Save Repayment Schedule For Loan
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    28JUL2020    - initial create

    Run Keyword   Save Repayment Schedule For Loan

BUS_Validate Repayment Schedule Resync Settings Value
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    28JUL2020    - initial create

    Run Keyword   Validate Repayment Schedule Resync Settings Value    ${ARGUMENT_1}

BUS_Validate Repayment Schedule Last Payment Remaining Value
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    29JUL2020    - initial create

    Run Keyword   Validate Repayment Schedule Last Payment Remaining Value    ${ARGUMENT_1}