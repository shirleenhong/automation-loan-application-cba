*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Save Ongoing Fee Rate in Facility Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    26MAY2020    - initial create

    Run Keyword   Save Ongoing Fee Rate in Facility Notebook    ${ARGUMENT_1}

BUS_Navigate to Pricing Change Transaction Menu
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    26MAY2020    - initial create

    Run Keyword   Navigate to Pricing Change Transaction Menu

BUS_Input Pricing Change Transaction General Information
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    26MAY2020    - initial create

    Run Keyword   Input Pricing Change Transaction General Information    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}
 
BUS_Save Ongoing Fees in Pricing Change Transaction Window
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    26MAY2020    - initial create

    Run Keyword   Save Ongoing Fees in Pricing Change Transaction Window    ${ARGUMENT_1}
 
BUS_Modify Ongoing Fees
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    26MAY2020    - initial create

    Run Keyword   Modify Ongoing Fees    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}
 
BUS_Update Interest Pricing via Pricing Change Transaction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    26MAY2020    - initial create

    Run Keyword   Update Interest Pricing via Pricing Change Transaction    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}
 
BUS_Select Pricing Change Transaction Send to Approval
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    26MAY2020    - initial create

    Run Keyword   Select Pricing Change Transaction Send to Approval
 
BUS_Approve Price Change Transaction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    26MAY2020    - initial create

    Run Keyword   Approve Price Change Transaction
 
BUS_Select Events Tab then Verify the Events
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    26MAY2020    - initial create

    Run Keyword   Select Events Tab then Verify the Events    ${ARGUMENT_1}    ${ARGUMENT_2}
 
BUS_Close the Pricing Change Transaction Window
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    26MAY2020    - initial create

    Run Keyword   Close the Pricing Change Transaction Window
 
BUS_Validate Updated Ongoing Fees in Facility Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    26MAY2020    - initial create

    Run Keyword   Validate Updated Ongoing Fees in Facility Notebook    ${ARGUMENT_1}
 
BUS_Compare Previous and Current Ongoing Fee Values of the Facility Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    26MAY2020    - initial create

    Run Keyword   Compare Previous and Current Ongoing Fee Values of the Facility Notebook    ${ARGUMENT_1}
 
BUS_Select Pricing Change Transaction Release
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    26MAY2020    - initial create

    Run Keyword   Select Pricing Change Transaction Release
 
BUS_Select Pricing Change Transaction Menu
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: clanding    11AUG2020    - initial create

    Run Keyword   Select Pricing Change Transaction Menu    ${ARGUMENT_1}

BUS_Populate Pricing Change Notebook General Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: clanding    11AUG2020    - initial create

    Run Keyword   Populate Pricing Change Notebook General Tab    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Navigate to Pricing Tab - Modify Interest Pricing
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: clanding    11AUG2020    - initial create

    Run Keyword   Navigate to Pricing Tab - Modify Interest Pricing

BUS_Add Matrix Item
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: clanding    11AUG2020    - initial create

    Run Keyword   Add Matrix Item    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}

BUS_Add After Option Item - First
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: clanding    11AUG2020    - initial create

    Run Keyword   Add After Option Item - First    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}

BUS_Add After Option Item - Second
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: clanding    11AUG2020    - initial create

    Run Keyword   Add After Option Item - Second    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}

BUS_Select Financial Ratio in Interest Pricing List
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: clanding    11AUG2020    - initial create

    Run Keyword   Select Financial Ratio in Interest Pricing List    ${ARGUMENT_1}

BUS_Add Matrix Item - Mnemonic
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: clanding    11AUG2020    - initial create

    Run Keyword   Add Matrix Item - Mnemonic    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}

BUS_Validate the Interest Pricing Values with Matrix Item
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: clanding    11AUG2020    - initial create

    Run Keyword   Validate the Interest Pricing Values with Matrix Item

BUS_Pricing Change Transaction Send to Approval
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: clanding    11AUG2020    - initial create

    Run Keyword   Pricing Change Transaction Send to Approval

BUS_Pricing Change Transaction Approval
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: clanding    11AUG2020    - initial create

    Run Keyword   Pricing Change Transaction Approval    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}

BUS_Pricing Change Transaction Release
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: clanding    11AUG2020    - initial create

    Run Keyword   Pricing Change Transaction Release    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}
    
BUS_Clear Interest Pricing Current Values
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: clanding    11AUG2020    - initial create

    Run Keyword   Clear Interest Pricing Current Values