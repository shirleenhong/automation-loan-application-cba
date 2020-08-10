*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Get Host Bank Cash in Cashflow
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    27APR2020    - initial create

    Run Keyword   Get Host Bank Cash in Cashflow    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Get Transaction Amount in Cashflow
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    27APR2020    - initial create

    Run Keyword   Get Transaction Amount in Cashflow    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Compute Lender Share Transaction Amount
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    27APR2020    - initial create

    Run Keyword   Compute Lender Share Transaction Amount    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Compare UIAmount versus Computed Amount
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    27APR2020    - initial create

    Run Keyword   Compare UIAmount versus Computed Amount    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Get GL Entries Amount
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    27APR2020    - initial create

    Run Keyword   Get GL Entries Amount    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Validate if Debit and Credit Amt is Balanced
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    27APR2020    - initial create

    Run Keyword   Validate if Debit and Credit Amt is Balanced    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Validate if Debit and Credit Amt is equal to Transaction Amount
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    27APR2020    - initial create

    Run Keyword   Validate if Debit and Credit Amt is equal to Transaction Amount    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Verify GL Entries Amount
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    27APR2020    - initial create

    Run Keyword   Verify GL Entries Amount    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}

BUS_Release a Cashflow
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    29APR2020    - initial create

    Run Keyword   Release a Cashflow    ${ARGUMENT_1}    ${ARGUMENT_2}    ${Argument_3}

BUS_Create Cashflow
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    19MAY2020    - initial create

    Run Keyword   Create Cashflow    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Release Cashflow Based on Remittance Instruction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    19MAY2020    - initial create
    ...    @update: amansuet    22JUN2020    - added new argument based on the keyword update

    Run Keyword   Release Cashflow Based on Remittance Instruction    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}

BUS_Click OK In Cashflows
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    19JUN2020    - initial create

    Run Keyword   Click OK In Cashflows
    
BUS_Set the Status to Send all to SPAP
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    23JUL2020    - initial create

    Run Keyword   Set the Status to Send all to SPAP
    
BUS_Release Cashflow
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    21JUL2020    - initial create

    Run Keyword   Release Cashflow    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Verify if Method has Remittance Instruction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create
    ...    @update: clanding    05AUG2020    - moved from BUS_LoanDrawdown_Notebook.robot; added 2 optional arguments

    Run Keyword   Verify if Method has Remittance Instruction    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}