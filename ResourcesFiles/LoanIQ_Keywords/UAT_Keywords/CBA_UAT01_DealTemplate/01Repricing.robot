*** Settings ***
Resource    ../../../../Configurations/Import_File.robot


*** Keywords ***
Loan Merge in Deal D00000454
    [Documentation]    This is a high-level keyword to execute loan merge of A1 and A2 outstanding.
    ...    @author: fmamaril    17SEP2019    Initial create    
    [Arguments]    ${ExcelPath}
      
    ## Search for Existing Deal and Facility
    ${Current_Date}    Get System Date
    Launch Existing Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
        
    ### Retrieve Facility Notebook Amounts prior to Loan Merge
    ${GlobalFacility_ProposedCmtBeforeMerge}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_ProposedCmt_Textfield}    input=GlobalFacility_ProposedCmtBeforeMerge        
    ${GlobalFacility_CurrentCmtBeforeMerge}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_CurrentCmt_Amount}    input=GlobalFacility_CurrentCmtBeforeMerge        
    ${GlobalFacility_OutstandingsBeforeMerge}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_Outstandings_Amount}    input=GlobalFacility_OutstandingsBeforeMerge        
    ${GlobalFacility_AvailToDrawBeforeMerge}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_AvailToDraw_Amount}    input=GlobalFacility_AvailToDrawBeforeMerge 
    
    ${HostBank_ProposedCmtBeforeMerge}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBankProposeCmt}    input=HostBank_ProposedCmtBeforeMerge        
    ${HostBank_ContrGrossBeforeMerge}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBankContrGross}    input=HostBank_ContrGrossBeforeMerge        
    ${HostBank_OutstandingsBeforeMerge}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBankOutstanding}    input=HostBank_OutstandingsBeforeMerge        
    ${HostBank_AvailToDrawBeforeMerge}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBankAvailToDraw}    input=HostBank_AvailToDrawBeforeMerge 
        
    ### Search for Existing Outstanding
    mx LoanIQ select    ${LIQ_FacilityNotebook_Options_DealNotebook}
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]
        
    ### Select Two Loans to Merge
    Select Loan to Reprice    &{ExcelPath}[Alias_Loan1]
    Select Repricing Type    &{ExcelPath}[Repricing_Type]
    Select Multiple Loan to Merge    &{ExcelPath}[Alias_Loan1]    &{ExcelPath}[Alias_Loan2]
        
    ### Add Repricing Detail
    ${Total_LoanMergeAmount}    Add Loan Repricing Option    &{ExcelPath}[Repricing_Add_Option]    &{ExcelPath}[BaseRate_OptionName]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Alias_Loan1]
    ...    &{ExcelPath}[Alias_Loan2]    &{ExcelPath}[Outstandings_Loan1]    &{ExcelPath}[Outstandings_Loan2]    ${BaseRate_Code}
    ### Rollover/Conversion Notebook###
    ${NewLoanAlias}    Get Alias and Populate details on Rates Tab    &{ExcelPath}[Base_Rate]
    Write Data To Excel    SERV08C_ComprehensiveRepricing    New_LoanAlias    &{ExcelPath}[rowid]    ${NewLoanAlias}    ${CBAUAT_ExcelPath}
    Add Interest Payment for Loan Repricing
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Create Cashflows
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Borrower_RemittanceDescription]    &{ExcelPath}[Borrower_RemittanceInstruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Lender_RemittanceDescription]    &{ExcelPath}[Lender_RemittanceInstruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender2_ShortName]    &{ExcelPath}[Lender2_RemittanceDescription]    &{ExcelPath}[Lender2_RemittanceInstruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]
    Verify if Status is set to Do It    &{ExcelPath}[Lender1_ShortName]
    Verify if Status is set to Do It    &{ExcelPath}[Lender2_ShortName]
    ### Get Transaction Amount for Cashflow
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower_ShortName]
    ${Lend1TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender1_ShortName]   
    ${Lend2TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender2_ShortName]
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount with exact percentage    &{ExcelPath}[Loan_TotalGlobalInterest]    &{ExcelPath}[LenderShareHost_Percentage]
    ${ComputedLend1TranAmount}    Compute Lender Share Transaction Amount with exact percentage    &{ExcelPath}[Loan_TotalGlobalInterest]    &{ExcelPath}[Lender1ShareHost_Percentage]
    ${ComputedLend2TranAmount}    Compute Lender Share Transaction Amount with exact percentage    &{ExcelPath}[Loan_TotalGlobalInterest]    &{ExcelPath}[Lender2ShareHost_Percentage]
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}|${Lend2TranAmount}    ${ComputedHBTranAmount}|${ComputedLend1TranAmount}|${ComputedLend2TranAmount}  
    Close GL Entries and Cashflow Window
    
    ## Send Loan Repricing to Approval
    Navigate Notebook Workflow    ${LIQ_LoanRepricing_Window}    ${LIQ_LoanRepricing_Tab}    ${LIQ_LoanRepricing_WorkflowItems}    Send to Approval
    Validate Window Title Status    Loan Repricing    Awaiting Approval
        
    ## Approve Loan Repricing
    Close All Windows on LIQ
    Logout from LIQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate Transaction in WIP    Outstandings    Awaiting Generate Rate Setting Notices    Loan Repricing    &{ExcelPath}[Deal_Name]
    Navigate Notebook Workflow    ${LIQ_LoanRepricing_Window}    ${LIQ_LoanRepricing_Tab}    ${LIQ_LoanRepricing_WorkflowItems}    Approval
    Validate Window Title Status    Loan Repricing    Awaiting Send to Rate Approval
        
    ### Send to Rate Approval
    Logout from LIQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate Transaction in WIP    Outstandings    Awaiting Send to Rate Approval    Loan Repricing    &{ExcelPath}[Deal_Name]
    Navigate Notebook Workflow    ${LIQ_LoanRepricing_Window}    ${LIQ_LoanRepricing_Tab}    ${LIQ_LoanRepricing_WorkflowItems}    Send to Rate Approval
    Validate Window Title Status    Loan Repricing    Awaiting Rate Approval
    
    ### Rate Approval and Release###
    Logout from LIQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate Transaction in WIP    Outstandings    Awaiting Generate Rate Setting Notices    Loan Repricing    &{ExcelPath}[Deal_Name]
    Navigate Notebook Workflow    ${LIQ_LoanRepricing_Window}    ${LIQ_LoanRepricing_Tab}    ${LIQ_LoanRepricing_WorkflowItems}    Rate Approval
    Validate Window Title Status    Loan Repricing    Awaiting Release
    Navigate Notebook Workflow    ${LIQ_LoanRepricing_Window}    ${LIQ_LoanRepricing_Tab}    ${LIQ_LoanRepricing_WorkflowItems}    Release
    Validate Window Title Status    Loan Repricing    Released    
    Close All Windows on LIQ
    Logout from LIQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
Comprehensive Repricing Interest Payment with Multiple Lenders in Deal D00000454
    [Documentation]    This is a high-level keyword to Create Comprehensive Repricing with interest payment only for more than 2 lenders
    ...    @author: fmamaril    19SEP2019    INITIAL CREATION
    [Arguments]    ${ExcelPath}  
    ### Perforn Online Accrual ###
    Search for Deal    &{ExcelPath}[Deal_Name]
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]
    Perform Online Accrual for a Loan Alias    &{ExcelPath}[Loan_Alias]
    
    ### Select Loan to Reprice ###
    Search for Deal    &{ExcelPath}[Deal_Name]
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]
    Select Loan to Reprice    &{ExcelPath}[Loan_Alias]    &{ExcelPath}[Loan_CurrentOutstanding]
    Select Repricing Type    &{ExcelPath}[Repricing_Type]
    Select Loan Repricing for Deal    &{ExcelPath}[Loan_Alias]
    
    ### Rollover/Conversion Notebook###
    ${NewLoanAlias}    Add New Outstandings    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Base_Rate]    &{ExcelPath}[Loan_NewOutstanding]
    Write Data To Excel    SERV08C_ComprehensiveRepricing    New_LoanAlias    &{ExcelPath}[rowid]    ${NewLoanAlias}    ${CBAUAT_ExcelPath}
    Run Keyword If    &{ExcelPath}[rowid] == 1    Run Keyword    Write Data To Excel    COMPR06_LoanMerge    Alias_Loan1    1    ${NewLoanAlias}    ${CBAUAT_ExcelPath}
    Run Keyword If    &{ExcelPath}[rowid] == 2    Run Keyword    Write Data To Excel    COMPR06_LoanMerge    Alias_Loan2    1    ${NewLoanAlias}    ${CBAUAT_ExcelPath}
    Run Keyword If    &{ExcelPath}[rowid] == 1    Write Data To Excel    SERV23_Paperclip    Loan_Alias    1    ${NewLoanAlias}    ${CBAUAT_ExcelPath}    
    Run Keyword If    &{ExcelPath}[rowid] == 2    Write Data To Excel    SERV23_Paperclip    Loan_Alias    2    ${NewLoanAlias}    ${CBAUAT_ExcelPath}
    
    Add Interest Payment for Loan Repricing
    Validate Interest Payments Amount    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Loan_Alias]    &{ExcelPath}[Loan_TotalGlobalInterest]
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Create Cashflows
    
    ### Remittance Instruction Addition per Cashflow ### 
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Borrower_RemittanceDescription]    &{ExcelPath}[Borrower_RemittanceInstruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Lender_RemittanceDescription]    &{ExcelPath}[Lender_RemittanceInstruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender2_ShortName]    &{ExcelPath}[Lender2_RemittanceDescription]    &{ExcelPath}[Lender2_RemittanceInstruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]
    Verify if Status is set to Do It    &{ExcelPath}[Lender1_ShortName]
    Verify if Status is set to Do It    &{ExcelPath}[Lender2_ShortName]
      
    ### Get Transaction Amount for Cashflow
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower_ShortName]
    ${Lend1TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender1_ShortName]
    ${Lend2TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender2_ShortName]    
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount with exact percentage    &{ExcelPath}[Loan_TotalGlobalInterest]    &{ExcelPath}[HostBank_LenderShare]
    ${ComputedLend1TranAmount}    Compute Lender Share Transaction Amount with exact percentage    &{ExcelPath}[Loan_TotalGlobalInterest]    &{ExcelPath}[Lender1_Share]
    ${ComputedLend2TranAmount}    Compute Lender Share Transaction Amount with exact percentage    &{ExcelPath}[Loan_TotalGlobalInterest]    &{ExcelPath}[Lender2_Share]  
    
    ### GL Entries
    Navigate to GL Entries
    Close GL Entries and Cashflow Window
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Send to Approval
    
    ### LIQ Window ###
    Logout from LIQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ### Work in process notebook ###
    Select Item in Work in Process    Outstandings    Awaiting Generate Rate Setting Notices    Loan Repricing    &{ExcelPath}[Deal_Name]
    
    ### Rate Approval ###
    Approve Loan Repricing
    Send to Rate Approval
    
    ### LIQ Window ###
    Logout from LIQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ## Work in process notebook ###
    Select Item in Work in Process    Outstandings    Awaiting Generate Rate Setting Notices    Loan Repricing    &{ExcelPath}[Deal_Name]
    
    Approve Rate Setting Notice
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Release Cashflows
    Release Cashflow    &{ExcelPath}[Borrower_ShortName]
    Release Cashflow    &{ExcelPath}[Lender1_ShortName]    
    Release Cashflow    &{ExcelPath}[Lender2_ShortName]    release    
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Release
    Take Screenshot    LoanRepricing-Released
    
    Close All Windows on LIQ
    Logout from LIQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
Comprehensive Repricing Interest Payment in Deal D00000454
    [Documentation]    This is a high-level keyword to Create Comprehensive Repricing with interest payment only with additional 1 lender
    ...    @author: fmamaril    19SEP2019    INITIAL CREATION
    [Arguments]    ${ExcelPath}  
    ### Perforn Online Accrual ###
    Search for Deal    &{ExcelPath}[Deal_Name]
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]
    Perform Online Accrual for a Loan Alias    &{ExcelPath}[Loan_Alias]
    
    ## Select Loan to Reprice ###
    Search for Deal    &{ExcelPath}[Deal_Name]
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]
    Select Loan to Reprice    &{ExcelPath}[Loan_Alias]    &{ExcelPath}[Loan_CurrentOutstanding]
    Select Repricing Type    &{ExcelPath}[Repricing_Type]
    Select Loan Repricing for Deal    &{ExcelPath}[Loan_Alias]
    
    ### Rollover/Conversion Notebook###
    ${NewLoanAlias}    Add New Outstandings    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Base_Rate]    &{ExcelPath}[Loan_NewOutstanding]
    Write Data To Excel    SERV08C_ComprehensiveRepricing    New_LoanAlias    &{ExcelPath}[rowid]    ${NewLoanAlias}    ${CBAUAT_ExcelPath}
    Run Keyword If    &{ExcelPath}[rowid] == 2    Write Data To Excel    SERV23_Paperclip    Loan_Alias    1    ${NewLoanAlias}    ${CBAUAT_ExcelPath}    
    Run Keyword If    &{ExcelPath}[rowid] == 3    Write Data To Excel    SERV23_Paperclip    Loan_Alias    2    ${NewLoanAlias}    ${CBAUAT_ExcelPath}
    Add Interest Payment for Loan Repricing
    Validate Interest Payments Amount    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Loan_Alias]    &{ExcelPath}[Loan_TotalGlobalInterest]
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Create Cashflows
    
    ### Remittance Instruction Addition per Cashflow ### 
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Borrower_RemittanceDescription]    &{ExcelPath}[Borrower_RemittanceInstruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Lender_RemittanceDescription]    &{ExcelPath}[Lender_RemittanceInstruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]
    Verify if Status is set to Do It    &{ExcelPath}[Lender1_ShortName]
      
    ### Get Transaction Amount for Cashflow
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower_ShortName]
    ${Lend1TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender1_ShortName]   
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount with exact percentage    &{ExcelPath}[Loan_TotalGlobalInterest]    &{ExcelPath}[HostBank_LenderShare]
    ${ComputedLend1TranAmount}    Compute Lender Share Transaction Amount with exact percentage    &{ExcelPath}[Loan_TotalGlobalInterest]    &{ExcelPath}[Lender1_Share]
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}    ${ComputedHBTranAmount}|${ComputedLend1TranAmount}  
    Close GL Entries and Cashflow Window
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Send to Approval
    
    ### LIQ Window ###
    Logout from LIQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ### Work in process notebook ###
    Select Item in Work in Process    Outstandings    Awaiting Generate Rate Setting Notices    Loan Repricing    &{ExcelPath}[Deal_Name]
    
    ### Rate Approval ###
    Approve Loan Repricing
    Send to Rate Approval
    
    ### LIQ Window ###
    Logout from LIQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ### Work in process notebook ###
    Select Item in Work in Process    Outstandings    Awaiting Generate Rate Setting Notices    Loan Repricing    &{ExcelPath}[Deal_Name]
    
    Approve Rate Setting Notice
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Release Cashflows
    Release Cashflow    &{ExcelPath}[Borrower_ShortName]
    Release Cashflow    &{ExcelPath}[Lender1_ShortName]    release    
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Release
    Take Screenshot    LoanRepricing-Released
    
    Close All Windows on LIQ
    Logout from LIQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
