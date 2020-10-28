*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Initiate Upfront Fee Payment
    [Documentation]    Initiate Upfront Fee Payment.
    ...    @author: mgaling
    ...    @update: clanding    05AUG2020    - updated hard coded values to global variables;
    ...    								     - updated 'Release Cashflow' and 'Navigate Notebook Workflow' to 'Release Cashflow Based on Remittance Instruction'
    ...    @update: fluberio    23OCT2020    - added condition to generate intent notices for Upfront Fee Payment
    [Arguments]    ${ExcelPath}

    ###Close all windows and Login as original user###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Open the existing Closed Deal###  
    Search Existing Deal    &{ExcelPath}[Deal_Name]    
    
    ###Upfront Fee Payment-General Tab###
    Populate Upfront Fee Payment Notebook    &{Excelpath}[UpfrontFee_Amount]
    Populate Fee Details Window    &{ExcelPath}[Fee_Type]    &{ExcelPath}[UpfrontFeePayment_Comment]    
    
    ###Upfront Fee Payment Workflow Tab- Create Cashflow Item###
    Navigate Notebook Workflow    ${LIQ_UpfrontFeePayment_Notebook}    ${LIQ_UpfrontFeePayment_Tab}    ${LIQ_UpfrontFeePayment_WorkflowItems}    ${CREATE_CASHFLOWS_TYPE}
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Create Cashflow    &{ExcelPath}[Lender_ShortName]    ${RELEASE_TRANSACTION}
    Run Keyword If   '${SCENARIO}'=='4' and '&{ExcelPath}[Entity]' == 'EU'    Generate Intent Notices For Upfront Fee Payment     &{ExcelPath}[UpfrontFeePayment_NoticeMethod]    &{ExcelPath}[Entity]
 
    ###Upfront Fee Payment Workflow Tab- Send to Approval Item###
    Send to Approval Upfront Fee Payment    
    
    ###Upfront Fee Payment Workflow Tab- Approval Item###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}   ${SUPERVISOR_PASSWORD}
    Navigate to Payment Notebook via WIP    ${PAYMENTS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${FEE_PAYMENT_FROM_BORROWER_TYPE}    &{ExcelPath}[Deal_Name]    
    Approve Upfront Fee Payment
    Release Cashflow Based on Remittance Instruction    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Lender_ShortName]    sNavigateToWorkflow=${PAYMENT_WORKFLOW}
 
    ###Upfront Fee Payment Workflow Tab- Release Item###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate to Payment Notebook via WIP    ${PAYMENTS_TRANSACTION}    ${AWAITING_RELEASE_STATUS}    ${FEE_PAYMENT_FROM_BORROWER_TYPE}    &{ExcelPath}[Deal_Name]
    Release Upfront Fee Payment