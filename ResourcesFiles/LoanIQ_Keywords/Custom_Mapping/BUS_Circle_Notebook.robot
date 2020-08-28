*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Check Deal Closing Commitment Amount
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author:sahalder    19JUN2020    - initial create

    Run Keyword    Check Deal Closing Commitment Amount    ${ARGUMENT_1}
    
BUS_Complete Portfolio Allocations for Assignment Sell
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author:sahalder    19JUN2020    - initial create

    Run Keyword    Complete Portfolio Allocations for Assignment Sell    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Check Host Bank Lender Share
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author:sahalder    19JUN2020    - initial create

    Run Keyword    Check Host Bank Lender Share    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Launch Circle Select
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author:sahalder    19JUN2020    - initial create

    Run Keyword    Launch Circle Select    ${ARGUMENT_1}
    
BUS_Populate Circle Selection
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author:sahalder    19JUN2020    - initial create

    Run Keyword    Populate Circle Selection    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}    ${ARGUMENT_8}    ${ARGUMENT_9}
    
BUS_Populate Facilities Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author:sahalder    19JUN2020    - initial create
    ...    @updated: dahijara    10AUG2020    - added 1 argument for runtime varname.

    Run Keyword    Populate Facilities Tab    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}    ${ARGUMENT_8}
    
BUS_Populate Amts or Dates Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author:sahalder    19JUN2020    - initial create

    Run Keyword    Populate Amts or Dates Tab    ${ARGUMENT_1}
    
BUS_Add Contacts
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author:sahalder    19JUN2020    - initial create

    Run Keyword    Add Contacts    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}
    
BUS_Add Servicing Groups
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author:sahalder    19JUN2020    - initial create

    Run Keyword    Add Servicing Groups    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Complete Assignment Fee Sell on Event Fees
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author:sahalder    19JUN2020    - initial create

    Run Keyword    Complete Assignment Fee Sell on Event Fees
    
BUS_Assignment Send to Approval
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author:sahalder    19JUN2020    - initial create

    Run Keyword    Assignment Send to Approval
    
BUS_Assignment Approval
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author:sahalder    19JUN2020    - initial create

    Run Keyword    Assignment Approval    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}
    
BUS_Process Funding Memo
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author:sahalder    19JUN2020    - initial create

    Run Keyword    Process Funding Memo    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}
    
BUS_Complete Funding Memo for Lender Share Adjustment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author:sahalder    19JUN2020    - initial create

    Run Keyword    Complete Funding Memo for Lender Share Adjustment    ${ARGUMENT_1}
    
BUS_Assignment Send to Settlement Approval
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author:sahalder    19JUN2020    - initial create

    Run Keyword    Assignment Send to Settlement Approval
    
BUS_Assignment Settlement Approval
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author:sahalder    19JUN2020    - initial create

    Run Keyword    Assignment Settlement Approval    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}
    
BUS_Close Assignment Transaction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author:sahalder    19JUN2020    - initial create

    Run Keyword    Close Assignment Transaction    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}
        
BUS_Check Host Bank Remaining Share
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author:sahalder    19JUN2020    - initial create

    Run Keyword    Check Host Bank Remaining Share    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}

BUS_Create Assignment Sell
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    19JUN2020    - initial create

    Run Keyword    Create Assignment Sell    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}

BUS_Validate Displayed Sell Amount and Return Value
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    19JUN2020    - initial create

    Run Keyword   Validate Displayed Sell Amount and Return Value    ${ARGUMENT_1}

BUS_Validate Displayed 'Sell Amount' in the Amts/Dates tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    19JUN2020    - initial create

    Run Keyword    Validate Displayed 'Sell Amount' in the Amts/Dates tab    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Add Contact in Pending Assignment Sell
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    19JUN2020    - initial create

    Run Keyword    Add Contact in Pending Assignment Sell    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Add Servicing Group in Pending Assignment Sell
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    19JUN2020    - initial create

    Run Keyword   Add Servicing Group in Pending Assignment Sell    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Circling for Pending Assignment Sell
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    19JUN2020    - initial create

    Run Keyword    Circling for Pending Assignment Sell    ${ARGUMENT_1}

BUS_Complete Portfolio Allocations Workflow for Pending Assignment Sell for Agency Deal
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    19JUN2020    - initial create
    ...    @update: clanding    17AUG2020    - updated keyword

    Run Keyword    Complete Portfolio Allocations Workflow for Pending Assignment Sell for Agency Deal    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Send to Approval for Pending Assignment Sell
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    19JUN2020    - initial create

    Run Keyword    Send to Approval for Pending Assignment Sell

BUS_Approval for Pending Assignment Sell
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    19JUN2020    - initial create

    Run Keyword    Approval for Pending Assignment Sell    ${ARGUMENT_1}

BUS_Send to Settlement Approval for Open Assignment Sell
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    22JUN2020    - initial create

    Run Keyword    Send to Settlement Approval for Open Assignment Sell

BUS_Settlement Approval for Open/Awaiting Settlement Approval Assignment Sell
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    22JUN2020    - initial create

    Run Keyword    Settlement Approval for Open/Awaiting Settlement Approval Assignment Sell    ${ARGUMENT_1}

BUS_Close for Open/Settlement Approved Assignment Sell
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    22JUN2020    - initial create

    Run Keyword    Close for Open/Settlement Approved Assignment Sell

BUS_Open Primary Servicing Groups
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    30JUN2020    - initial create

    Run Keyword    Open Primary Servicing Groups

BUS_Validate Primary SG Remittance Instructions
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    30JUN2020    - initial create

    Run Keyword    Validate Primary SG Remittance Instructions    ${ARGUMENT_1}

BUS_Complete Primary Servicing Group Setup
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    30JUN2020    - initial create

    Run Keyword    Complete Primary Servicing Group Setup

BUS_Get Circle Notebook Sell Amount Per Facility
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    30JUN2020    - initial create

    Run Keyword    Get Circle Notebook Sell Amount Per Facility    ${ARGUMENT_1}    

BUS_Circle Notebook Save And Exit
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    30JUN2020    - initial create

    Run Keyword    Circle Notebook Save And Exit

BUS_Open Lender Circle Notebook From Primaries List
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    30JUN2020    - initial create

    Run Keyword    Open Lender Circle Notebook From Primaries List    ${ARGUMENT_1}     

BUS_Click Portfolio Allocations from Circle Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    30JUN2020    - initial create

    Run Keyword    Click Portfolio Allocations from Circle Notebook 

BUS_Circle Notebook Portfolio Allocation Per Facility
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    30JUN2020    - initial create

    Run Keyword    Circle Notebook Portfolio Allocation Per Facility    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}

BUS_Complete Circle Notebook Portfolio Allocation
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    30JUN2020    - initial create

    Run Keyword    Complete Circle Notebook Portfolio Allocation

BUS_Navigate to Orig Primaries Workflow and Proceed With Transaction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    30JUN2020    - initial create

    Run Keyword    Navigate to Orig Primaries Workflow and Proceed With Transaction    ${ARGUMENT_1}    

BUS_Exit Primaries List Window
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    30JUN2020    - initial create

    Run Keyword    Exit Primaries List Window

BUS_Compute Percentage Amounts for Secondary Sale for Comprehensive Deal
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    27JUL2020    - initial create

    Run Keyword    Compute Percentage Amounts for Secondary Sale for Comprehensive Deal    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}
    ...        ${ARGUMENT_8}    ${ARGUMENT_9}    ${ARGUMENT_10}    ${ARGUMENT_11}    ${ARGUMENT_12}    ${ARGUMENT_13}

BUS_Populate Facilities Lender Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    27JUL2020    - initial create

    Run Keyword    Populate Facilities Lender Tab    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}

BUS_Add Servicing Group
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    27JUL2020    - initial create

    Run Keyword    Add Servicing Group    ${ARGUMENT_1}

BUS_Circling for Assignment Sell
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    27JUL2020    - initial create

    Run Keyword    Circling for Assignment Sell    ${ARGUMENT_1}

BUS_Complete Portfolio Allocations for Pending Assignment Sell
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    27JUL2020    - initial create

    Run Keyword    Complete Portfolio Allocations for Pending Assignment Sell    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}

BUS_Approve Assignment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    27JUL2020    - initial create

    Run Keyword    Approve Assignment    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Validate Lender Query Amount
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    27JUL2020    - initial create

    Run Keyword    Validate Lender Query Amount    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}
    ...        ${ARGUMENT_8}    ${ARGUMENT_9}

BUS_Validate Primaries Lender Share
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    27JUL2020    - initial create

    Run Keyword    Validate Primaries Lender Share    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}

BUS_Add Lender and Location
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create

    Run Keyword    Add Lender and Location    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}
    
BUS_Set Sell Amount and Percent of Deal
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create

    Run Keyword    Set Sell Amount and Percent of Deal    ${ARGUMENT_1}
    
BUS_Add Pro Rate
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create

    Run Keyword    Add Pro Rate    ${ARGUMENT_1}
    
BUS_Add Pricing Comment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create

    Run Keyword    Add Pricing Comment    ${ARGUMENT_1}

BUS_Add Contact in Primary
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create

    Run Keyword    Add Contact in Primary    ${ARGUMENT_1}
    
BUS_Delete Contact in Primary
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create

    Run Keyword    Delete Contact in Primary    ${ARGUMENT_1}
    
BUS_Select Servicing Group on Primaries
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create

    Run Keyword    Select Servicing Group on Primaries    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Validate Delete Error on Servicing Group
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create

    Run Keyword    Validate Delete Error on Servicing Group    ${ARGUMENT_1}
    
BUS_Complete Portfolio Allocations Workflow
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create

    Run Keyword    Complete Portfolio Allocations Workflow    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}
    
BUS_Circling for Primary Workflow
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create

    Run Keyword    Circling for Primary Workflow    ${ARGUMENT_1}
    
BUS_Navigate to Facility Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create

    Run Keyword    Navigate to Facility Notebook    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Close Primaries Windows
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    24APR2020    - initial create
 
    Run Keyword    Close Primaries Windows
    
BUS_Verify Buy/Sell Price in Circle Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    11MAY2020    - initial create
 
    Run Keyword    Verify Buy/Sell Price in Circle Notebook
    
BUS_Get Circle Notebook Sell Amount
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    11MAY2020    - initial create
 
    Run Keyword    Get Circle Notebook Sell Amount
    
BUS_Add Non-Host Bank Lenders for a Syndicated Deal
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    11MAY2020    - initial create
 
    Run Keyword    Add Non-Host Bank Lenders for a Syndicated Deal    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}
    
BUS_Circle Notebook Workflow Navigation
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    11MAY2020    - initial create
 
    Run Keyword    Circle Notebook Workflow Navigation    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}
    ...    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}    ${ARGUMENT_8}

BUS_Circle Notebook Settlement Approval
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    11MAY2020    - initial create
 
    Run Keyword    Circle Notebook Settlement Approval    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Verify Circle Notebook Status After Deal Close
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    11MAY2020    - initial create
 
    Run Keyword    Verify Circle Notebook Status After Deal Close    ${ARGUMENT_1}
    
BUS_Verify Facility Status After Deal Close
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    11MAY2020    - initial create
 
    Run Keyword    Verify Facility Status After Deal Close    ${ARGUMENT_1}
    
BUS_Verify Deal Status After Deal Close
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    11MAY2020    - initial create
 
    Run Keyword    Verify Deal Status After Deal Close
    
BUS_Validate Deal Closing Cmt With Facility Total Global Current Cmt
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    11MAY2020    - initial create
 
    Run Keyword    Validate Deal Closing Cmt With Facility Total Global Current Cmt
    
BUS_Get Deal Closing Cmt
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    11MAY2020    - initial create
 
    Run Keyword    Get Deal Closing Cmt    ${ARGUMENT_1}

BUS_Get Lender Name from Primaries Window
    [Documentation]    This keyword is used to used to get Lender Name from Primaries window.
    ...    @author: clandingin    04AUG2020    - initial create
 
    Run Keyword    Get Lender Name from Primaries Window    ${ARGUMENT_1}

BUS_Go to Lender
    [Documentation]    This keyword is used to to double click on Primaries List and doubleclick on Lender.
    ...    @author: clandingin    04AUG2020    - initial create
 
    Run Keyword    Go to Lender    ${ARGUMENT_1}
