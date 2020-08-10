*** Settings ***
Resource     ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Initiate Break Funding Early Full Repayment
    [Documentation]    This Keyword initiates Interest Payment of the specified Loan
    ...    @update: sahalder    08JUL2020    Modified keyword as per BNS framework
    [Arguments]    ${ExcelPath}
    
    ###Login to Original User###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###LIQ Window
    Search Deal    &{ExcelPath}[Deal_Name]
    
    ###Deal Notebook
    Get Expense Code from Deal    ${rowid}
        
    ###Existing Loans for Facility
    Search Loan   &{ExcelPath}[Type]    &{ExcelPath}[Search_By]    &{ExcelPath}[Facility_Name]
    
    ###Breakfunding Notebook
    Navigate Breakfunding Fee Notebook    &{ExcelPath}[Loan_Alias]    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Pricing_Option_From_Breakfunding]    
    ...    &{ExcelPath}[Currency]
    Request Lender Fees
    Generate Lender Shares    &{ExcelPath}[Legal_Entity]    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Lender2_ShortName]    &{ExcelPath}[HostBankSharePct]    &{ExcelPath}[LenderSharePct1]    &{ExcelPath}[LenderSharePct2]
    Add Portfolio and Expense Code    &{ExcelPath}[Legal_Entity]    &{ExcelPath}[HostBankSharePct]    &{ExcelPath}[rowid]
    
    ###Cashflow  Window    
    Create Cashflow for Break Funding
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Remittance1_Description]    &{ExcelPath}[Remittance1_Instruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender2_ShortName]    &{ExcelPath}[Remittance2_Description]    &{ExcelPath}[Remittance2_Instruction]    
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]  
    Verify if Status is set to Do It    &{ExcelPath}[Lender1_ShortName]
    Verify if Status is set to Do It    &{ExcelPath}[Lender2_ShortName]

    ###GL Entries###
    Navigate to GL Entries
    ${HostBank_Debit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Credit Amt
    ${Lender1_Debit}    Get GL Entries Amount    &{ExcelPath}[Lender1_ShortName]    Credit Amt
    ${Lender2_Debit}    Get GL Entries Amount    &{ExcelPath}[Lender2_ShortName]    Credit Amt
    ${Borrower_Credit}    Get GL Entries Amount    &{ExcelPath}[Borrower_ShortName]    Debit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    ${SPACE}Total For:    Credit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    ${SPACE}Total For:    Debit Amt
	
	###Breakfunding Notebook
	Send Breakfunding to Approval
	
	###LIQ Window
	Logout from Loan IQ
	Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
	
	#Breakfunding Notebook
	Approve Breakfunding via WIP LIQ Icon    &{ExcelPath}[WIP_TransactionType]    &{ExcelPath}[WIP_AwaitingApprovalStatus]    &{ExcelPath}[WIP_OutstandingType]
		
	#Breakfunding Notebook
	Release Breakfunding via WIP LIQ Icon    &{ExcelPath}[WIP_TransactionType]    &{ExcelPath}[WIP_AwaitingReleaseStatus]    &{ExcelPath}[WIP_OutstandingType]
	
	
	
    
    
