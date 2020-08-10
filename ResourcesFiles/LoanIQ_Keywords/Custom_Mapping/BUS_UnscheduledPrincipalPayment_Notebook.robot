*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Get Current Facility Outstandings, Avail to Draw, Commitment Amount
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    03JUL2020    - initial create

    Run Keyword   Get Current Facility Outstandings, Avail to Draw, Commitment Amount    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}
    
BUS_Get Global Current and Host Bank Gross Loan Amounts
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    03JUL2020    - initial create

    Run Keyword   Get Global Current and Host Bank Gross Loan Amounts
     
BUS_Get Loan Interest Rate, Rate Basis, and New Start Date
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    03JUL2020    - initial create

    Run Keyword   Get Loan Interest Rate, Rate Basis, and New Start Date    ${ARGUMENT_1}
    
BUS_Navigate to Repayment Schedule from Loan Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    03JUL2020    - initial create

    Run Keyword   Navigate to Repayment Schedule from Loan Notebook
    
BUS_Add Unscheduled Transaction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    03JUL2020    - initial create

    Run Keyword   Add Unscheduled Transaction    ${ARGUMENT_1}
    
BUS_Navigate to Unscheduled Principal Payment Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    03JUL2020    - initial create

    Run Keyword   Navigate to Unscheduled Principal Payment Notebook    ${ARGUMENT_1}
    
BUS_Navigate to Principal Payment Notebook Workflow
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    03JUL2020    - initial create

    Run Keyword   Navigate to Principal Payment Notebook Workflow    ${ARGUMENT_1}
    
BUS_Send Unscheduled Principal Payment to Approval
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    03JUL2020    - initial create

    Run Keyword   Send Unscheduled Principal Payment to Approval
    
BUS_Open Unscheduled Principal Payment Notebook via WIP - Awaiting Approval
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    03JUL2020    - initial create

    Run Keyword   Open Unscheduled Principal Payment Notebook via WIP - Awaiting Approval    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}
    
BUS_Approve Unscheduled Principal Payment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    03JUL2020    - initial create

    Run Keyword   Approve Unscheduled Principal Payment
    
BUS_Open Unscheduled Payment Notebook via WIP - Awaiting Release
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    03JUL2020    - initial create

    Run Keyword   Open Unscheduled Payment Notebook via WIP - Awaiting Release    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}
    
BUS_Release Unscheduled Principal Payment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    03JUL2020    - initial create

    Run Keyword   Release Unscheduled Principal Payment
    
BUS_Validate Principal Prepayment in Loan Events Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    03JUL2020    - initial create

    Run Keyword   Validate Principal Prepayment in Loan Events Tab
    
BUS_Validate New Global Current Cmt, Outstandings, and Avail to Draw for Term Facility
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    03JUL2020    - initial create

    Run Keyword   Validate New Global Current Cmt, Outstandings, and Avail to Draw for Term Facility    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}

BUS_Validate New Global Current Cmt, Outstandings, and Avail to Draw for Revolver Facility
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    03JUL2020    - initial create

    Run Keyword   Validate New Global Current Cmt, Outstandings, and Avail to Draw for Revolver Facility    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}

BUS_Open Payment Notebook via WIP - Awaiting Release Cashflow
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    09JUL2020    - initial create

    Run Keyword   Open Payment Notebook via WIP - Awaiting Release Cashflow    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}
    
BUS_Release Payment Cashflows with Three Lenders
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    09JUL2020    - initial create

    Run Keyword   Release Payment Cashflows with Three Lenders    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    