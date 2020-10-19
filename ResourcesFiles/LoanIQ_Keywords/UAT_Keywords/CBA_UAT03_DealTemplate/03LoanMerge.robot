*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Initiate Loan Merge and Conversion - D00000454
    [Documentation]    This is a high level keyword for Loan Merge of D1 and D2 including the conversion of D1 from BBSY to BBSW
    ...    @author: ritragel    27SEP2019    Initial create    
    [Arguments]    ${ExcelPath}
    
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ### Search for Existing Deal and Facility
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
        
    ## Rollover/Conversion Notebook###
    ${NewLoanAlias}    Add New Outstandings    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Base_Rate]    &{ExcelPath}[Loan_NewOutstanding]    &{ExcelPath}[Repricing_Frequency]
    
    ### Add Interest Repricing
    Select Loan to Process    &{ExcelPath}[Alias_Loan2]
    Add Repricing Details    Interest Payment    
    ${CycleAmount}    Select Cycles for Loan Item    Projected Due    &{ExcelPath}[Cycle]
    Verify Interest Payment    ${CycleAmount}    &{ExcelPath}[Payment_Effective_Date]

    Select Loan to Process    &{ExcelPath}[Alias_Loan1]
    Add Repricing Details    Interest Payment    
    ${CycleAmount}    Select Cycles for Loan Item    Projected Due    &{ExcelPath}[Cycle]
    Verify Interest Payment    ${CycleAmount}    &{ExcelPath}[Payment_Effective_Date]
    
    ### Create Cashflows
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Create Cashflows
    
    # Remittance Instruction Addition per Cashflow ###   
    Add Remittance Instructions    None    &{ExcelPath}[Borrower_RemittanceDescription]    &{ExcelPath}[Tran_Amount]    &{ExcelPath}[Loan_Currency]
    Add Remittance Instructions    None    &{ExcelPath}[Borrower_RemittanceDescription_2]    &{ExcelPath}[Loan_Increase]    &{ExcelPath}[Loan_Currency]
    Set All Items to Do It

    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Send to Approval
    
    ### LIQ Window ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
        
    ### Work in process notebook ###
    Select Item in Work in Process    Outstandings    Awaiting Generate Rate Setting Notices    Loan Repricing    &{ExcelPath}[Facility_Name]
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Approval
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Send to Rate Approval
    
    ### LIQ Window ###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Select Item in Work in Process    Outstandings    Awaiting Rate Approval    Loan Repricing    &{ExcelPath}[Facility_Name]
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Rate Approval
    
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    Outstandings    Awaiting Release    Loan Repricing    &{ExcelPath}[Facility_Name]
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Release
    
    Close All Windows on LIQ
    
