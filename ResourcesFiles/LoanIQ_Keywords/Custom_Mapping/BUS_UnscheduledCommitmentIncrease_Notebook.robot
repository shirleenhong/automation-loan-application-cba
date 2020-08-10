*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Navigate to View/Update Lender Share via Unscheduled Commitment Increase Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    06AUG2020    - initial create

    Run Keyword   Navigate to View/Update Lender Share via Unscheduled Commitment Increase Notebook    
    
BUS_Validate PrimariesAssginees Section
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    06AUG2020    - initial create

    Run Keyword   Validate PrimariesAssginees Section    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}    ${ARGUMENT_8}    ${ARGUMENT_9}    ${ARGUMENT_10}
    
BUS_Validate Actual Total Amount under PrimariesAssginees Section
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    06AUG2020    - initial create

    Run Keyword   Validate Actual Total Amount under PrimariesAssginees Section    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}
    
BUS_Validate Host Bank Shares Section
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    06AUG2020    - initial create

    Run Keyword   Validate Host Bank Shares Section    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}
    
BUS_Validate Actual Net All Total Amount under Host Bank Shares Section
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    06AUG2020    - initial create

    Run Keyword   Validate Actual Net All Total Amount under Host Bank Shares Section    ${ARGUMENT_1}
    
BUS_Generate Intent Notices in Unscheduled Commitment Increase Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    06AUG2020    - initial create

    Run Keyword   Generate Intent Notices in Unscheduled Commitment Increase Notebook
    
BUS_Navigate To Amendment Notebook Workflow 
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    06AUG2020    - initial create

    Run Keyword   Navigate To Amendment Notebook Workflow    ${ARGUMENT_1}   