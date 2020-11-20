*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Initiate Usage Fee Payment
    [Documentation]    This keyword initiate Line Fee payment.
    ...    @author: dahijara    19NOV2020    Initial Create 
    [Arguments]    ${sCycle_Number}    ${sEffectiveDate}

    ### GetRuntime Keyword Pre-processing ###
    ${Cycle_Number}    Acquire Argument Value    ${sCycle_Number}

    mx LoanIQ activate window    ${LIQ_UsageFeeNotebook_Window}    
    mx LoanIQ select    ${LIQ_UsageFee_Options_Payment_Menu}
    mx LoanIQ enter    ${LIQ_ChoosePayment_Fee_RadioButton}    ON
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/UsageFeePayment
    mx LoanIQ click    ${LIQ_ChoosePayment_OK_Button}

    mx LoanIQ enter    ${LIQ_UsagetFee_Cycles_CycleDue_RadioButton}    ON   

    ${CycleDueAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_UsageFee_Cycles_Javatree}    ${Cycle_Number}%Cycle Due%value
    ${CycleDueAmount}    Remove comma and convert to number - Cycle Due    ${CycleDueAmount}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/UsageFeePayment
    mx LoanIQ click    ${LIQ_UsageFee_Cycles_OK_Button}
    mx LoanIQ activate window    ${LIQ_Payment_Window}
    mx LoanIQ click element if present    ${LIQ_UsageFee_InquiryMode_Button} 
    mx LoanIQ enter    ${LIQ_OngoingFeePayment_EffectiveDate_DateField}    ${sEffectiveDate} 
    mx LoanIQ enter    ${LIQ_OngoingFeePayment_RequestedAmount_Textfield}    ${CycleDueAmount}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/UsageFeePayment
    [Return]    ${CycleDueAmount}

Validate Release of Usage Fee Payment
    [Documentation]    This keyword validates the release of Usage Fee Payment on Events.
    ...    @author: dahijara    20NOV2020    - initial create

    mx LoanIQ activate window    ${LIQ_UsageFeeNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_UsageFee_Tab}    ${EVENTS_TAB}
    Mx LoanIQ Select String    ${LIQ_UsageFee_Events_Javatree}   ${RELEASED_STATUS}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CommitmentFeeWindow_EventsTab_UsageFeePayment