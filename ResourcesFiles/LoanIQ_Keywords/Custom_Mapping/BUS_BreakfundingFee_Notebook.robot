*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
BUS_Get Expense Code from Deal
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    08JUN2020    - initial create

    Run Keyword   Get Expense Code from Deal    ${ARGUMENT_1}
    
BUS_Navigate Breakfunding Fee Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    08JUN2020    - initial create

    Run Keyword   Navigate Breakfunding Fee Notebook    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}
    
BUS_Request Lender Fees
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    08JUN2020    - initial create

    Run Keyword   Request Lender Fees
    
BUS_Generate Lender Shares
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    08JUN2020    - initial create

    Run Keyword   Generate Lender Shares    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}
    
BUS_Add Portfolio and Expense Code
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    08JUN2020    - initial create

    Run Keyword   Add Portfolio and Expense Code    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}
    
BUS_Create Cashflow for Break Funding
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    08JUN2020    - initial create

    Run Keyword   Create Cashflow for Break Funding
    
BUS_Send Breakfunding to Approval
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    08JUN2020    - initial create

    Run Keyword   Send Breakfunding to Approval
    
BUS_Approve Breakfunding via WIP LIQ Icon
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    08JUN2020    - initial create

    Run Keyword   Approve Breakfunding via WIP LIQ Icon    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}
    
BUS_Release Breakfunding via WIP LIQ Icon
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    08JUN2020    - initial create

    Run Keyword   Release Breakfunding via WIP LIQ Icon    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}
    
BUS_Open Breakfunding Fee Notebook via WIP - Awaiting Approval
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    10JUN2020    - initial create

    Run Keyword   Open Breakfunding Fee Notebook via WIP - Awaiting Approval    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}
    
BUS_Approve Breakfunding
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    10JUN2020    - initial create

    Run Keyword   Approve Breakfunding
    
BUS_Open Breakfunding Fee Notebook via WIP - Awaiting Release
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    10JUN2020    - initial create

    Run Keyword   Open Breakfunding Fee Notebook via WIP - Awaiting Release    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}
    
BUS_Release Breakfunding
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    10JUN2020    - initial create

    Run Keyword   Release Breakfunding   