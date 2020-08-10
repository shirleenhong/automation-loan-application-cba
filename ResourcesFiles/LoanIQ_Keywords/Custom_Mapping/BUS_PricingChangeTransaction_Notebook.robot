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
 


    