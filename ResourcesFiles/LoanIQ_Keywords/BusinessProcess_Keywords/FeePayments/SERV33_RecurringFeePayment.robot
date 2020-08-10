*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Initiate Recurring Fee Payment
    [Documentation]    This Keyword is use to complete the Event Fee from cashflow to its release.
    ...    @author: jcdelacruz
    ...    @update: fmamaril    24MAY2019    Delete Commented steps not used for Cashflow
    [Arguments]    ${ExcelPath}
    
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    #Work In Process - Event Fee Notebook###
    Navigate Event Fee Notebook in WIP    &{ExcelPath}[WIP_TransactionType]    &{ExcelPath}[WIP_AwaitingCreateCashflowsStatus]    &{ExcelPath}[WIP_OutstandingType]    &{ExcelPath}[Facility_Name]
    
    #Cashflow Window###
    Navigate Notebook Workflow    ${LIQ_EventFeeNotebook_Window}    ${LIQ_EventFeeNotebook_PendingTab_Window}    ${LIQ_EventFee_WorkflowItems_Pending_List}    Create Cashflow
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Remittance1_Description]    &{ExcelPath}[Remittance1_Instruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender2_ShortName]    &{ExcelPath}[Remittance2_Description]    &{ExcelPath}[Remittance2_Instruction]
    Create Cashflow    &{ExcelPath}[Borrower_ShortName]|&{ExcelPath}[Lender1_ShortName]|&{ExcelPath}[Lender2_ShortName]
   
    ###Get Transaction Amount for Cashflow###
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower_ShortName]
    ${Lend1TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender1_ShortName]
    ${Lend2TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender2_ShortName]
    
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[LegalFee_Amount]    &{ExcelPath}[HostBankSharePct]
    ${ComputedLend1TranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[LegalFee_Amount]    &{ExcelPath}[LenderSharePct1]
    ${ComputedLend2TranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[LegalFee_Amount]    &{ExcelPath}[LenderSharePct2] 
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}|${Lend2TranAmount}    ${ComputedHBTranAmount}|${ComputedLend1TranAmount}|${ComputedLend2TranAmount}
 
    ###GL Entries###
    Navigate to GL Entries
    ${HostBank_Credit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Credit Amt
    ${Lender1_Credit}    Get GL Entries Amount    &{ExcelPath}[Lender1_ShortName]    Credit Amt
    ${Lender2_Credit}    Get GL Entries Amount    &{ExcelPath}[Lender2_ShortName]    Credit Amt
    ${Borrower_Debit}    Get GL Entries Amount    &{ExcelPath}[Borrower_ShortName]    Debit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    ${SPACE}Total For:    Credit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    ${SPACE}Total For:    Debit Amt
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}|${Lend2TranAmount}    ${HostBank_Credit}|${Lender1_Credit}|${Lender2_Credit}
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Credit}|${Lender1_Credit}|${Lender2_Credit}    ${Borrower_Debit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalDebitAmt}    ${UITotalCreditAmt}    &{ExcelPath}[LegalFee_Amount]
   
    ##Event Fee Notebook### 
    Send Event Fee to Approval
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ     ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    #Work In Process - Event Fee Notebook###
    Approve Event Fee via WIP LIQ Icon     &{ExcelPath}[WIP_TransactionType]     &{ExcelPath}[WIP_AwaitingApprovalStatus]     &{ExcelPath}[WIP_OutstandingType]
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Work In Process - Event Fee Notebook###
    Release Event Fee via WIP LIQ Icon     &{ExcelPath}[WIP_TransactionType]     &{ExcelPath}[WIP_AwaitingReleaseStatus]     &{ExcelPath}[WIP_OutstandingType]    

####For Bilateral Deal###
Initiate Recurring Fee Payment for Bilateral Deal
    [Documentation]    This Keyword is use to complete the Event Fee from cashflow to its release.
    ...    @author: jcdelacruz
    ...    @update: fmamaril    24MAY2019    Delete Commented steps not used for Cashflow
    [Arguments]    ${ExcelPath}
    
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ##Work In Process - Event Fee Notebook###
    Navigate Event Fee Notebook in WIP    &{ExcelPath}[WIP_TransactionType]    &{ExcelPath}[WIP_AwaitingCreateCashflowsStatus]    &{ExcelPath}[WIP_OutstandingType]    &{ExcelPath}[Facility_Name]
    
    #Cashflow Window###
    Navigate Notebook Workflow    ${LIQ_EventFeeNotebook_Window}    ${LIQ_EventFeeNotebook_PendingTab_Window}    ${LIQ_EventFee_WorkflowItems_Pending_List}    Create Cashflow 
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Remittance1_Description]    &{ExcelPath}[Remittance1_Instruction]    
    Create Cashflow    &{ExcelPath}[Lender1_ShortName]
    
    ###Get Transaction Amount for Cashflow###
    ${HostBankShare}    Get Host Bank Cash in Cashflow    
    ${Lend1TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender1_ShortName] 
    
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[LegalFee_Amount]    &{ExcelPath}[HostBankSharePct]
    ${ComputedLend1TranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[LegalFee_Amount]    &{ExcelPath}[LenderSharePct1]  
 
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}    ${ComputedHBTranAmount}|${ComputedLend1TranAmount}
    ###GL Entries###
    Navigate to GL Entries
    ${HostBank_Credit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Credit Amt
    ${Lender1_Credit}    Get GL Entries Amount    &{ExcelPath}[Lender1_ShortName]    Debit Amt   
    ${UITotalCreditAmt}    Get GL Entries Amount    ${SPACE}Total For:    Credit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    ${SPACE}Total For:    Debit Amt
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}    ${HostBank_Credit}|${Lender1_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalDebitAmt}    ${UITotalCreditAmt}    &{ExcelPath}[LegalFee_Amount]
   
    ##Event Fee Notebook###    
    Send Event Fee to Approval
    
    # ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ     ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ##Work In Process - Event Fee Notebook###
    Approve Event Fee via WIP LIQ Icon     &{ExcelPath}[WIP_TransactionType]     &{ExcelPath}[WIP_AwaitingApprovalStatus]     &{ExcelPath}[WIP_OutstandingType]
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Work In Process - Event Fee Notebook###
    Release Event Fee via WIP LIQ Icon     &{ExcelPath}[WIP_TransactionType]     &{ExcelPath}[WIP_AwaitingReleaseStatus]     &{ExcelPath}[WIP_OutstandingType]  

