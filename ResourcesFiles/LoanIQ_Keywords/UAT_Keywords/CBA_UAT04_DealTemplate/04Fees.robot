*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Setup Establishment Fee for Deal D00000963
    [Documentation]    High-level keyword used to create the Establishment Fee in Deal D00000963.
    ...                @author: bernchua    26AUG2019    Initial create
    [Arguments]    ${ExcelPath}
    
    ### To be automated...
    Refresh Tables in LIQ
    

Release Facility Ongoing Fee for Deal D00000963
    [Documentation]    High-level keyword used to Release the Ongoing Fee of the Facilities for Deal D00000963 after Deal Close.
    ...                @author: bernchua    28AUG2019     Initial create
    [Arguments]    ${ExcelPath}
    
    Refresh Tables in LIQ
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Open Facility Navigator from Deal Notebook
    Open Ongoing Fee List from Facility Navigator    &{ExcelPath}[Facility_Name]
    Open Pending Ongoing Fee from Ongoing Fee List    &{ExcelPath}[OngoingFee_Alias]
    Navigate Notebook Workflow    ${LIQ_LineFeeNotebook_Window}    ${LIQ_LineFee_Tab}    ${LIQ_LineFeeNotebook_Workflow_JavaTree}    Release
    Validate Window Title Status    ${ExcelPath}[OngoingFee_Type]    Released
    Close All Windows on LIQ
    
    
Create Payment for Ongoing Fees in Deal D00000963
    [Documentation]    High-level keyword for creating the Payment for the Facility Ongoing Fees in Deal D00000963
    ...                @author: bernchua    24SEP2019    Initial create
    [Arguments]        ${ExcelPath}
    
    ${Portfolio_Name}    Read Data From Excel    CRED01_DealSetup    Primary_Portfolio    1    ${CBAUAT_ExcelPath}
    ${Portfolio_ExpenseCode}    Read Data From Excel    CRED01_DealSetup    Deal_ExpenseCode    1    ${CBAUAT_ExcelPath}
    ${HostBank_CustomerPortfolio}    Set Variable    CB001/${Portfolio_Name}/${Portfolio_ExpenseCode}
    ${HostBankLender_Share}    Read Data From Excel    CRED01_DealSetup    Primary_PctOfDeal    1    ${CBAUAT_ExcelPath}
    
    Refresh Tables in LIQ
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Open Facility Navigator from Deal Notebook
    Open Ongoing Fee List from Facility Navigator    &{ExcelPath}[Facility_Name]
    Open Ongoing Fee from Fee List    &{ExcelPath}[OngoingFee_Alias]
    Set Notebook to Update Mode    ${LIQ_LineFeeNotebook_Window}    ${LIQ_LineFee_InquiryMode_Button}
    
    Choose Payment Type for Line Fee    Fee Payment
    ${CycleDue_Amount}    Select Cycle for Line Fee Payment    Cycle Due    &{ExcelPath}[LineFeePayment_DueDate]
    Set Ongoing Fee Payment General Tab Details    ${CycleDue_Amount}    &{ExcelPath}[LineFeePayment_EffectiveDate]
    
    Navigate Notebook Workflow    ${LIQ_OngoingFeePayment_Window}    ${LIQ_OngoingFeePayment_Tab}    ${LIQ_OngoingFeePayment_Workflow}    Create Cashflows
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_Name]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]    ${CycleDue_Amount}    AUD
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_Name]    &{ExcelPath}[Remittance_Instruction]    ${CycleDue_Amount}
    
    ### Get Transaction Amount for Cashflow
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower_Name]
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    ${CycleDue_Amount}    ${HostBankLender_Share}
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${ComputedHBTranAmount}
    
    ### GL Entries
    Navigate to GL Entries
    ${Borrower_Debit}    Get GL Entries Amount    &{ExcelPath}[Borrower_Name]    Debit Amt
    ${HostBank_Credit}    Get GL Entries Amount    ${HostBank_CustomerPortfolio}    Credit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    Total For:    Credit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    Total For:    Debit Amt
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${HostBank_Credit}
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Credit}    ${Borrower_Debit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalCreditAmt}    ${CycleDue_Amount}
    
    Navigate Notebook Workflow    ${LIQ_OngoingFeePayment_Window}    ${LIQ_OngoingFeePayment_Tab}    ${LIQ_OngoingFeePayment_Workflow}    Send to Approval
    
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate Transaction in WIP    Payments    Awaiting Approval    Ongoing Fee Payment    &{ExcelPath}[Deal_Name]
    Navigate Notebook Workflow    ${LIQ_OngoingFeePayment_Window}    ${LIQ_OngoingFeePayment_Tab}    ${LIQ_OngoingFeePayment_Workflow}    Approval
    
    Navigate Notebook Workflow    ${LIQ_OngoingFeePayment_Window}    ${LIQ_OngoingFeePayment_Tab}    ${LIQ_OngoingFeePayment_Workflow}    Release Cashflows
    Cashflows Mark All To Release
    Click OK In Cashflows
    
    Navigate Notebook Workflow    ${LIQ_OngoingFeePayment_Window}    ${LIQ_OngoingFeePayment_Tab}    ${LIQ_OngoingFeePayment_Workflow}    Release
    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    

    
