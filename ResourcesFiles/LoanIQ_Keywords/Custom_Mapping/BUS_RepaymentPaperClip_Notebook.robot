*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Initiate Paper Clip Payment and Return Payment Due Date
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    06JUL2020    - initial create

    Run Keyword    Initiate Paper Clip Payment and Return Payment Due Date    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Input Paper Clip Details
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    06JUL2020    - initial create

    Run Keyword    Input Paper Clip Details    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Add Event Fee for Paper Clip Transaction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    06JUL2020    - initial create

    Run Keyword    Add Event Fee for Paper Clip Transaction    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}

BUS_Compute Principal Payment Amount
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    07JUL2020    - initial create

    Run Keyword    Compute Principal Payment Amount    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Validate Repayment Paper Clip Transaction Details
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    07JUL2020    - initial create

    Run Keyword    Validate Repayment Paper Clip Transaction Details    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}

BUS_Evaluate Fee Payment Amount with VAT Inclusion
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    07JUL2020    - initial create

    Run Keyword    Evaluate Fee Payment Amount with VAT Inclusion    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}

BUS_Compute Paper Clip Total Amount with VAT Inclusion for Fee
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    07JUL2020    - initial create

    Run Keyword    Compute Paper Clip Total Amount with VAT Inclusion for Fee    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}

BUS_Validate Interest and Principal Payments on Loan Events Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    07JUL2020    - initial create

    Run Keyword    Validate Interest and Principal Payments on Loan Events Tab    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Navigate to Scheduled Interest Payment Notebook from Loan Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    07JUL2020    - initial create

    Run Keyword    Navigate to Scheduled Interest Payment Notebook from Loan Notebook

BUS_Validate Fee, Interest and Principal Payments on Repayment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    07JUL2020    - initial create

    Run Keyword    Validate Fee, Interest and Principal Payments on Repayment    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Get Current Outstandings Host Bank Gross and Host Bank Net
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    10JUL2020    - initial create

    Run Keyword    Get Current Outstandings Host Bank Gross and Host Bank Net    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Create Pending Transaction for Payment Flex Schedule
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    10JUL2020    - initial create

    Run Keyword    Create Pending Transaction for Payment Flex Schedule    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}