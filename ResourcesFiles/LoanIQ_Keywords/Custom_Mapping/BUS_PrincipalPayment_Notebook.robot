*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Create Repayment Schedule for Fixed Loan with Interest
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    28APR2020    - initial create

    Run Keyword    Create Repayment Schedule for Fixed Loan with Interest

BUS_Navigate to Oustanding Facility Window
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    01JUN2020    - initial create

    Run Keyword    Navigate to Oustanding Facility Window    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Get Current Commitment Outstanding and Available to Draw on Facility Before Payment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    01JUN2020    - initial create

    Run Keyword    Get Current Commitment, Outstanding and Available to Draw on Facility Before Payment    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}

BUS_Search Loan
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    02JUN2020    - initial create

    Run Keyword    Search Loan    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Navigate from Loan to Repayment Schedule
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    02JUN2020    - initial create

    Run Keyword    Navigate from Loan to Repayment Schedule

BUS_Create Pending Transaction for Payment Schedule
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    02JUN2020    - initial create

    Run Keyword    Create Pending Transaction for Payment Schedule    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Navigate to Scheduled Principal Payment Cashflow Window
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    02JUN2020    - initial create

    Run Keyword    Navigate to Scheduled Principal Payment Cashflow Window

BUS_Send Scheduled Principal Payment to Approval
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    02JUN2020    - initial create

    Run Keyword    Send Scheduled Principal Payment to Approval

BUS_Open Scheduled Principal Payment Notebook from Repayment Schedule
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    02JUN2020    - initial create

    Run Keyword    Open Scheduled Principal Payment Notebook from Repayment Schedule    ${ARGUMENT_1}

BUS_Approve Scheduled Principal Payment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    02JUN2020    - initial create

    Run Keyword    Approve Scheduled Principal Payment

BUS_Release Scheduled Principal Payment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    02JUN2020    - initial create

    Run Keyword    Release Scheduled Principal Payment

BUS_Validate if Outstanding Amount has decreased
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    02JUN2020    - initial create

    Run Keyword    Validate if Outstanding Amount has decreased    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}

BUS_Validate Loan on Repayment Schedule
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    02JUN2020    - initial create

    Run Keyword    Validate Loan on Repayment Schedule    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}

BUS_Validate on Events Tab for Principal Payment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    02JUN2020    - initial create

    Run Keyword    Validate on Events Tab for Principal Payment

BUS_Get Current Commitment Outstanding and Available to Draw on Facility After Payment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    02JUN2020    - initial create

    Run Keyword    Get Current Commitment, Outstanding and Available to Draw on Facility After Payment    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}

BUS_Validate Principal Payment for Term Facility on Oustanding Window
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    02JUN2020    - initial create

    Run Keyword    Validate Principal Payment for Term Facility on Oustanding Window    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}

BUS_Validate Principal Payment for Revolver Facility on Oustanding Window
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    02JUN2020    - initial create

    Run Keyword    Validate Principal Payment for Revolver Facility on Oustanding Window    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}    

BUS_Populate Principal Payment General Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    02JUN2020    - initial create

    Run Keyword    Populate Principal Payment General Tab    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    

BUS_Compute For Lender Share Percentage
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    02JUN2020    - initial create

    Run Keyword    Compute For Lender Share Percentage    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}     

BUS_Generate Intent Notices on Principal Payment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    02JUN2020    - initial create

    Run Keyword    Generate Intent Notices on Principal Payment 
    
BUS_Send Principal Payment to Approval
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    02JUN2020    - initial create

    Run Keyword    Send Principal Payment to Approval

BUS_Approve Principal Payment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    02JUN2020    - initial create

    Run Keyword    Approve Principal Payment

BUS_Release Principal Payment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    02JUN2020    - initial create

    Run Keyword    Release Principal Payment

BUS_Validation on Principal Payment Notebook - Events Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    02JUN2020    - initial create

    Run Keyword    Validation on Principal Payment Notebook - Events Tab

BUS_Validation on Principal Payment Notebook - GL Entries Window
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    02JUN2020    - initial create

    Run Keyword    Validation on Principal Payment Notebook - GL Entries Window    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}
    ...    ${ARGUMENT_8}    ${ARGUMENT_9}    ${ARGUMENT_10}

BUS_Validation on Principal Payment Notebook - Lender Shares Window
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    02JUN2020    - initial create

    Run Keyword    Validation on Principal Payment Notebook - Lender Shares Window   ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}

BUS_Open Scheduled Principal Payment Notebook from Repayment Flex Schedule
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    10JUL2020    - initial create

    Run Keyword    Open Scheduled Principal Payment Notebook from Repayment Flex Schedule   ${ARGUMENT_1}

BUS_Close Selected Windows for Payment Release
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    10JUL2020    - initial create

    Run Keyword    Close Selected Windows for Payment Release

BUS_Validate if Outstanding Amount has decreased after Principal Payment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    10JUL2020    - initial create

    Run Keyword    Validate if Outstanding Amount has decreased after Principal Payment   ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}