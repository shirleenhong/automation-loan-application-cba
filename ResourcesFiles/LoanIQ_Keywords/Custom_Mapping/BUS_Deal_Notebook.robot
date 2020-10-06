*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Create New Deal
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    08APR2020    - initial create

    Run Keyword    Create New Deal    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}

BUS_Unrestrict Deal
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    08APR2020    - initial create

    Run Keyword    Unrestrict Deal
    
BUS_Add Deal Borrower
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    14APR2020    - initial create

    Run Keyword    Add Deal Borrower    ${ARGUMENT_1}

BUS_Select Deal Borrower Location and Servicing Group
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    14APR2020    - initial create

    Run Keyword    Select Deal Borrower Location and Servicing Group    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}
    
BUS_Select Deal Borrower Remmitance Instruction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    14APR2020    - initial create

    Run Keyword    Select Deal Borrower Remmitance Instruction    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}
    
BUS_Set Deal as Sole Lender
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    14APR2020    - initial create

    Run Keyword    Set Deal as Sole Lender
    
BUS_Select Deal Classification
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    14APR2020    - initial create

    Run Keyword    Select Deal Classification    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Select Admin Agent
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    14APR2020    - initial create

    Run Keyword    Select Admin Agent    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Select Servicing group and Remittance Instrucion for Admin Agent
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    14APR2020    - initial create

    Run Keyword    Select Servicing group and Remittance Instrucion for Admin Agent    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}
    
BUS_Enter Agreement Date and Proposed Commitment Amount
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    14APR2020    - initial create

    Run Keyword    Enter Agreement Date and Proposed Commitment Amount    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Save Changes on Deal Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Save Changes on Deal Notebook

BUS_Send Deal to Approval
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Send Deal to Approval

BUS_Approve the Deal
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Approve the Deal    ${ARGUMENT_1}

BUS_Close the Deal
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Close the Deal    ${ARGUMENT_1}

BUS_Uncheck Early Discussion Deal Checkbox
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Uncheck Early Discussion Deal Checkbox

BUS_Enter Department on Personel Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Enter Department on Personel Tab    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Enter Expense Code
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Enter Expense Code    ${ARGUMENT_1}

BUS_Delete Holiday on Calendar
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Delete Holiday on Calendar    ${ARGUMENT_1}

BUS_Add Holiday on Calendar
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Add Holiday on Calendar    ${ARGUMENT_1}

BUS_Add Financial Ratio
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Add Financial Ratio    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Add Pricing Option
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Add Pricing Option    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}

BUS_Add Fee Pricing Rules
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Add Fee Pricing Rules    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}

BUS_Verify Details on Events Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Verify Details on Events Tab   ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}
    
BUS_Set Deal Borrower Servicing Group
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    10MAY2020    - initial create

    Run Keyword    Set Deal Borrower Servicing Group   ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}
    
BUS_Add Preferred Remittance Instruction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    10MAY2020    - initial create

    Run Keyword    Add Preferred Remittance Instruction   ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}
    
BUS_Set Deal Admin Agent Servicing Group
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    10MAY2020    - initial create

    Run Keyword    Set Deal Admin Agent Servicing Group   ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}
    
BUS_Set Deal Calendar
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    10MAY2020    - initial create

    Run Keyword    Set Deal Calendar   ${ARGUMENT_1}
    
BUS_Add Deal Pricing Options
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    10MAY2020    - initial create

    Run Keyword    Add Deal Pricing Options   ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}
    ...    ${ARGUMENT_6}    ${ARGUMENT_7}    ${ARGUMENT_8}    ${ARGUMENT_9}    ${ARGUMENT_10}    ${ARGUMENT_11}    ${ARGUMENT_12}    ${ARGUMENT_13} 

BUS_Go To Deal Borrower Preferred RI Window
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    10MAY2020    - initial create

    Run Keyword    Go To Deal Borrower Preferred RI Window
    
BUS_Complete Deal Borrower Setup
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    10MAY2020    - initial create

    Run Keyword    Complete Deal Borrower Setup
    
BUS_Get Borrower Name From Deal Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    10MAY2020    - initial create

    Run Keyword    Get Borrower Name From Deal Notebook
    
BUS_Get Customer Legal Name From Customer Notebook Via Deal Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    10MAY2020    - initial create

    Run Keyword    Get Customer Legal Name From Customer Notebook Via Deal Notebook
    
BUS_Go To Admin Agent Preferred RI Window
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    10MAY2020    - initial create

    Run Keyword    Go To Admin Agent Preferred RI Window
    
BUS_Complete Deal Admin Agent Setup
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    10MAY2020    - initial create

    Run Keyword    Complete Deal Admin Agent Setup
    
BUS_Add Admin Fee in Deal Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    10MAY2020    - initial create

    Run Keyword    Add Admin Fee in Deal Notebook    ${ARGUMENT_1}
    
BUS_Validate Status of Deal and Navigate to Deal Change Transaction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    21MAY2020    - initial create

    Run Keyword    Validate Status of Deal and Navigate to Deal Change Transaction

BUS_Add Pricing Option for SBLC
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    01JUN2020    - initial create

    Run Keyword    Add Pricing Option for SBLC    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}
    ...    ${ARGUMENT_6}    ${ARGUMENT_7}

BUS_Add Bank Role
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    01JUN2020    - initial create

    Run Keyword    Add Bank Role    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}
    ...    ${ARGUMENT_6}    ${ARGUMENT_7}    ${ARGUMENT_8}    ${ARGUMENT_9}

BUS_Get Deal Borrower Remittance Instruction Description
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    02JUN2020    - initial create

    Run Keyword    Get Deal Borrower Remittance Instruction Description    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Get Customer Lender Remittance Instruction Desc Via Lender Shares In Deal Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    02JUN2020    - initial create

    Run Keyword    Get Customer Lender Remittance Instruction Desc Via Lender Shares In Deal Notebook    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    

BUS_Validate Upfront Fee Decisions in Maintenance
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    12JUN2020    - initial create
    Run Keyword    Validate Upfront Fee Decisions in Maintenance    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}

BUS_Validate Deal Financial Ratio Added
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    10JUN2020    - initial create

    Run Keyword    Validate Deal Financial Ratio Added    ${ARGUMENT_1}

BUS_Navigate to Facility Notebook from Deal Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    10JUN2020    - initial create

    Run Keyword    Navigate to Facility Notebook from Deal Notebook    ${ARGUMENT_1}

BUS_Open Admin Fee From Deal Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    15JUN2020    - initial create

    Run Keyword    Open Admin Fee From Deal Notebook    ${ARGUMENT_1}

BUS_Create Admin Fee Change Transaction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    15JUN2020    - initial create

    Run Keyword    Create Admin Fee Change Transaction

BUS_Validate Admin Fee New Data
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    15JUN2020    - initial create

    Run Keyword    Validate Admin Fee New Data    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Set Deal Borrower
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    23JUN2020    - initial create

    Run Keyword    Set Deal Borrower    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Mark All Preferred Remittance Instruction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    23JUN2020    - initial create

    Run Keyword    Mark All Preferred Remittance Instruction

BUS_Validate Deal As Not Sole Lender
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    23JUN2020    - initial create

    Run Keyword    Validate Deal As Not Sole Lender

BUS_Enter Deal Projected Close Date
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    23JUN2020    - initial create

    Run Keyword    Enter Deal Projected Close Date    ${ARGUMENT_1}

BUS_Delete Calendar from Deal Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    23JUN2020    - initial create

    Run Keyword    Delete Calendar from Deal Notebook    ${ARGUMENT_1}    

BUS_Validate Interest Pricing Frequency Addded From Base Rate API
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    29JUN2020    - initial create

    Run Keyword    Validate Interest Pricing Frequency Addded From Base Rate API    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Deal Pricing Option Select All Frequency
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    29JUN2020    - initial create

    Run Keyword    Deal Pricing Option Select All Frequency

BUS_Close Interest Pricing Option Details Window
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    29JUN2020    - initial create

    Run Keyword    Close Interest Pricing Option Details Window
    
BUS_Enable MassSale on DealNotebook
    [Documentation]    This keyword is used to Enable Mass Sale Checkbox on DealNotebook
    ...    @author: Archana     15JUL2020    - initial create
    
    Run Keyword    Enable MassSale on DealNotebook
    
BUS_Check Pending Transaction in Deal
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dfajardo    22JUL2020    - initial create

    Run Keyword    Check Pending Transaction in Deal    ${ARGUMENT_1}
    
BUS_Terminate a Deal
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dfajardo    22JUL2020    - initial create

    Run Keyword    Terminate a Deal    ${ARGUMENT_1}

BUS_Add Event Fees in Deal Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    24JJUL2020    - initial create

    Run Keyword    Add Event Fees in Deal Notebook    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}

BUS_Check if Admin Fee is Added
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    21JUL2020    - initial create

    Run Keyword    Check if Admin Fee is Added    ${ARGUMENT_1}

BUS_Verify Admin Fee Status
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    21JUL2020    - initial create

    Run Keyword    Verify Admin Fee Status    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}

BUS_Add Deal Pricing Options for BBSW-Mid
    [Documentation]    This keyword is used to add Pricing Options with BBSW-Mid in the Deal Notebook.
    ...    @author: clanding    29JUL2020    - initial create

    Run Keyword    Add Deal Pricing Options (BBSW-Mid)   ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}
    ...    ${ARGUMENT_6}    ${ARGUMENT_7}

BUS_Set Deal Upfront Fees
    [Documentation]    This keyword is used to add Upfront Fee in the Deal Notebook's Fees tab.
    ...    @author: clanding    29JUL2020    - initial create

    Run Keyword    Set Deal Upfront Fees    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}

BUS_Validate Upfront Fee Pricing
    [Documentation]    This keyword is used to validate the added Upfront Fee Pricing items in the Deal Notebook.
    ...    @author: clanding    29JUL2020    - initial create

    Run Keyword    Validate Upfront Fee Pricing    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Set Bank Role
    [Documentation]    This keyword is used to set the Bank Role in a Deal.
    ...    @author: clanding    29JUL2020    - initial create

    Run Keyword    Set Bank Role    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}

BUS_Verify Status on Circle and Facility and Deal
    [Documentation]    This keyword is used to verify the status of Circle, Facility and Deal notebook.
    ...    @author: clanding    29JUL2020    - initial create

    Run Keyword    Verify Status on Circle and Facility and Deal    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Get Financial Ratio Type Effective Date and Return
    [Documentation]    This keyword is used to get Effective Date from Financial Ratio Type and return.
    ...    @author: clanding    04AUG2020    - initial create

    Run Keyword    Get Financial Ratio Type Effective Date and Return    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Get the Original Amount on Summary Tab of Deal Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    06AUG2020    - initial create
    ...    @update: dahijara    24SEP2020    - added arguments

    Run Keyword    Get the Original Amount on Summary Tab of Deal Notebook    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}
    
BUS_Get Original Amount on Deal Lender Shares
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    06AUG2020    - initial create
    ...    @update: dahijara    24SEP2020    - added arguments

    Run Keyword    Get Original Amount on Deal Lender Shares    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}    ${ARGUMENT_8}    ${ARGUMENT_9}
    
BUS_Create Amendment via Deal Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    06AUG2020    - initial create

    Run Keyword    Create Amendment via Deal Notebook
    
BUS_Validate the Updates on Deal Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    06AUG2020    - initial create

    Run Keyword    Validate the Updates on Deal Notebook    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}
    
BUS_Validate the Updates on Lender Shares
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    06AUG2020    - initial create

    Run Keyword    Validate the Updates on Lender Shares    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}    ${ARGUMENT_8}    ${ARGUMENT_9}
    
BUS_Validate the Updates on Primaries
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    06AUG2020    - initial create

    Run Keyword    Validate the Updates on Primaries    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Get Customer Lender Legal Name Via Lender Shares In Deal Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    03SEP2020    - initial create

    Run Keyword    Get Customer Lender Legal Name Via Lender Shares In Deal Notebook    ${ARGUMENT_1}    ${ARGUMENT_2}