*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Setup Repricing
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    26MAY2020    - initial create

    Run Keyword    Setup Repricing    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}

BUS_Create Repayment Schedule - Loan Repricing
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    26MAY2020    - initial create

    Run Keyword    Create Repayment Schedule - Loan Repricing

BUS_Navigate to Workflow and Review Repayment Schedule
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    26MAY2020    - initial create

    Run Keyword    Navigate to Workflow and Review Repayment Schedule

BUS_Send Loan Repricing for Approval
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    26MAY2020    - initial create

    Run Keyword    Send Loan Repricing for Approval

BUS_Approve Loan Repricing
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    26MAY2020    - initial create

    Run Keyword    Approve Loan Repricing

BUS_Send to Rate Approval
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    26MAY2020    - initial create

    Run Keyword    Send to Rate Approval

BUS_Approve Rate Setting Notice
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    26MAY2020    - initial create

    Run Keyword    Approve Rate Setting Notice
    
BUS_Set RolloverConversion Notebook General Details
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    24JUN2020    - initial create
    ...    @update: dahijara    28aug2020    - Updated arguments

    Run Keyword   Set RolloverConversion Notebook General Details    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}
    
BUS_Set RolloverConversion Notebook Rates
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    24JUN2020    - initial create

    Run Keyword   Set RolloverConversion Notebook Rates    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Navigate from Rollover to Repayment Schedule
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    24JUN2020    - initial create

    Run Keyword   Navigate from Rollover to Repayment Schedule
    
BUS_Close RolloverConversion Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    24JUN2020    - initial create

    Run Keyword   Close RolloverConversion Notebook
    
BUS_Navigate to Rollover Conversion Notebook Workflow
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    24JUN2020    - initial create

    Run Keyword   Navigate to Rollover Conversion Notebook Workflow    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Set FX Rates Rollover or Conversion
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    27AUG2020    - initial create

    Run Keyword   Set FX Rates Rollover or Conversion    ${ARGUMENT_1}
    
BUS_Set Currency FX Rate
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    23SEP2020    - initial create

    Run Keyword    Set Currency FX Rate    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}

BUS_Compute F/X Rate and Percentage of Loan
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    23SEP2020    - initial create

    Run Keyword    Compute F/X Rate and Percentage of Loan    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}

BUS_Validate Amounts in Facility Currency
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    23SEP2020    - initial create

    Run Keyword    Validate Amounts in Facility Currency    ${ARGUMENT_1}    ${ARGUMENT_2}