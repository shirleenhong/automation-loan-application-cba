*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Open Tickler
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: archana

    Run Keyword    Open Tickler    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Tickler Details Window
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: archana

    Run Keyword    Tickler Details Window    ${ARGUMENT_1}
    
BUS_User Distribution SelectionList
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: archana

    Run Keyword    User Distribution SelectionList    ${ARGUMENT_1}

BUS_Tickler Remainders for Once
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: archana

    Run Keyword    Tickler Remainders for Once    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}
  
BUS_ Tickler Remainders for Every Occurance
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: archana

    Run Keyword     Tickler Remainders for Every Occurance    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}
    
BUS_Open Existing Tickler
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: archana

    Run Keyword    Open Existing Tickler    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}
    
 