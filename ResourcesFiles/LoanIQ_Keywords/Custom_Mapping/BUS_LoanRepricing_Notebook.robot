*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
BUS_Select Loan to Reprice
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    03JUN2020    - initial create

    Run Keyword   Select Loan to Reprice    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Select Repricing Type
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    03JUN2020    - initial create

    Run Keyword   Select Repricing Type    ${ARGUMENT_1}
    
BUS_Select Loan Repricing for Deal
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    03JUN2020    - initial create

    Run Keyword   Select Loan Repricing for Deal    ${ARGUMENT_1}
    
BUS_Add Changes for Quick Repricing
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    03JUN2020    - initial create

    Run Keyword   Add Changes for Quick Repricing    ${ARGUMENT_1}    ${ARGUMENT_2}
    

BUS_Approve Loan Repricing And Send to Rate Approval
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    03JUN2020    - initial create

    Run Keyword   Approve Loan Repricing And Send to Rate Approval

BUS_Navigate to Create Cashflow for Loan Repricing
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    26MAY2020    - initial create

    Run Keyword    Navigate to Create Cashflow for Loan Repricing

BUS_Navigate to Loan Repricing Workflow and Proceed With Transaction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    26MAY2020    - initial create

    Run Keyword    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${ARGUMENT_1}

BUS_Add New Outstandings
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    28MAY2020    - initial create

    Run Keyword    Add New Outstandings    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}

BUS_Add Interest Payment for Loan Repricing
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    28MAY2020    - initial create
	...    @update: amansuet    15JUN2020    - added argument

    Run Keyword    Add Interest Payment for Loan Repricing    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Add Principal Payment after New Outstanding Addition
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    28MAY2020    - initial create

    Run Keyword    Add Principal Payment after New Outstanding Addition    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Validate Interest Payments Amount
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    28MAY2020    - initial create

    Run Keyword    Validate Interest Payments Amount    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Add Rollover Conversion to New
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    01JUN2020    - initial create
	...    @update: amansuet    15JUN2020    - added argument

    Run Keyword    Add Rollover Conversion to New    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}

BUS_Compute Lender Share Transaction Amount - Repricing
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    15JUN2020    - initial create

    Run Keyword    Compute Lender Share Transaction Amount - Repricing    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Get Calculated Cycle Due Amount and Validate
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    15JUN2020    - initial create
    ...    @update: clanding    14AUG2020    - added additional argument

    Run Keyword    Get Calculated Cycle Due Amount and Validate    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}
    
BUS_Select Existing Outstandings for Loan Repricing
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    24JUN2020    - initial create

    Run Keyword   Select Existing Outstandings for Loan Repricing    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Cick Add in Loan Repricing Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    24JUN2020    - initial create

    Run Keyword   Cick Add in Loan Repricing Notebook

BUS_Set Repricing Detail Add Options
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    24JUN2020    - initial create

    Run Keyword   Set Repricing Detail Add Options    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}

BUS_Validate Loan Repricing New Outstanding Amount
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    24JUN2020    - initial create
    ...    @update: dahijara    25AUG2020    - added 1 argument

    Run Keyword   Validate Loan Repricing New Outstanding Amount    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Validate Loan Repricing Effective Date
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    24JUN2020    - initial create

    Run Keyword   Validate Loan Repricing Effective Date    ${ARGUMENT_1} 
    
BUS_Navigate to Existing Outstanding
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    09JUL2020    - initial create

    Run Keyword    Navigate to Existing Outstanding    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}
    
BUS_Select Multiple Loan to Merge
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    09JUL2020    - initial create

    Run Keyword    Select Multiple Loan to Merge    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Add Loan Repricing Option
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    09JUL2020    - initial create

    Run Keyword    Add Loan Repricing Option    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}    ${ARGUMENT_8}    ${ARGUMENT_9}
    
BUS_Validate Generals Tab in Rollover/Conversion to BBSY
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    09JUL2020    - initial create

    Run Keyword    Validate Generals Tab in Rollover/Conversion to BBSY    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}
    
BUS_Change Effective Date for Loan Repricing
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    09JUL2020    - initial create

    Run Keyword    Change Effective Date for Loan Repricing    ${ARGUMENT_1}
    
BUS_Navigate to Loan Repricing Notebook Workflow
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    09JUL2020    - initial create

    Run Keyword    Navigate to Loan Repricing Notebook Workflow    ${ARGUMENT_1}

BUS_Get Cycle Due Date for Loan Repricing
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: clanding    14AUG2020    - initial create

    Run Keyword    Get Cycle Due Date for Loan Repricing    ${ARGUMENT_1}    ${ARGUMENT_2}