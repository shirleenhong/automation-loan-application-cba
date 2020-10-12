*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Create Loan Merge
    [Documentation]    This is a high-level keyword to execute creation of a Loan Merge from two Term Drawdowns.
    ...    @author: chanario
    ...    @update: bernchua    06DEC2018    Scenario 8 integration - Lender share percentages read from Excel data of Secondary Sale
    ...    @update: bernchua    18MAR2019    Deleted old scripts used for API automation, will update using new TL automation scripts.
    ...    @update: bernchua    18MAR2019    Updated username/password variables as per standards.
    ...    @update: bernchua    18MAR2019    Updated WIP & Workflow navigation keywords with "Navigate Transaction in WIP" & "Navigate Notebook Workflow".
    ...    @update: sahalder    09JUL2020    Updated as per new BNS framework, Moved keyword from SERV12 to New SERV11 resource file.
    ...    @update: dahijara    28SEP2020    Removed wait keyword for getting BaseRate_Percentage
    ...                                      Moved MX keywords to a source keyword
    ...                                      Updated argument for Navigate to Existing Outstanding
    ...                                      Updated hardcoded values with global variables.
    ...                                      Moved changing of effecftive date before adding loan repricing option
    [Arguments]    ${ExcelPath}
    
    ### Retrieve Base Rate Payload Values ###
    ${BaseRate_OptionName}    Read Data From Excel    CRED01_DealSetup    Deal_PricingOption1    &{ExcelPath}[rowid]
    ${BaseRate_Code}    Read Data From Excel    CRED08_OngoingFeeSetup    Interest_BaseRateCode1    2
    ${BaseRate_Frequency}    Read Data From Excel    SERV01_LoanDrawdown    Loan_RepricingFrequency    3
    ${BaseRate_Percentage}    Get Base Rate from Funding Rate Details    ${BaseRate_Code}    ${BaseRate_Frequency}    &{ExcelPath}[Loan_Currency]
    
    
    ### Get data from secondary sale scenario ###
    ${Borrower_ShortName}    Read Data From Excel    CRED01_DealSetup    Borrower_ShortName    1
    ${Lender1_ShortName}    Read Data From Excel    TRP002_SecondarySale    Buyer_Lender    1
    ${Lender2_ShortName}    Read Data From Excel    TRP002_SecondarySale    Buyer_Lender_2    1
    ${Lender1_Share}    Read Data From Excel    TRP002_SecondarySale    PctofDeal    &{ExcelPath}[rowid]
    ${Lender2_Share}    Read Data From Excel    TRP002_SecondarySale    PctofDeal2    &{ExcelPath}[rowid]
    ${HostBankLender_Share}    Evaluate    100-(${Lender1_Share}+${Lender2_Share})
    
    
        
    ### Search for Existing Deal and Facility ###
    ${Current_Date}    Get System Date
    Launch Existing Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    
    
    ### Retrieve Facility Notebook Amounts prior to Loan Merge ###
    ${GlobalFacility_ProposedCmtBeforeMerge}    ${GlobalFacility_CurrentCmtBeforeMerge}    ${GlobalFacility_OutstandingsBeforeMerge}    ${GlobalFacility_AvailToDrawBeforeMerge}
    ...    ${HostBank_ProposedCmtBeforeMerge}    ${HostBank_ContrGrossBeforeMerge}    ${HostBank_OutstandingsBeforeMerge}    ${HostBank_AvailToDrawBeforeMerge}    Retrieve Facility Notebook Amounts prior to Loan Merge
    # ${GlobalFacility_ProposedCmtBeforeMerge}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_ProposedCmt_Textfield}    input=GlobalFacility_ProposedCmtBeforeMerge        
    # ${GlobalFacility_CurrentCmtBeforeMerge}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_CurrentCmt_Amount}    input=GlobalFacility_CurrentCmtBeforeMerge        
    # ${GlobalFacility_OutstandingsBeforeMerge}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_Outstandings_Amount}    input=GlobalFacility_OutstandingsBeforeMerge        
    # ${GlobalFacility_AvailToDrawBeforeMerge}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_AvailToDraw_Amount}    input=GlobalFacility_AvailToDrawBeforeMerge 
    
    # ${HostBank_ProposedCmtBeforeMerge}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBankProposeCmt}    input=HostBank_ProposedCmtBeforeMerge        
    # ${HostBank_ContrGrossBeforeMerge}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBankContrGross}    input=HostBank_ContrGrossBeforeMerge        
    # ${HostBank_OutstandingsBeforeMerge}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBankOutstanding}    input=HostBank_OutstandingsBeforeMerge        
    # ${HostBank_AvailToDrawBeforeMerge}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBankAvailToDraw}    input=HostBank_AvailToDrawBeforeMerge 
    
    
    ### Search for Existing Outstanding
    Navigate to Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]
        
    ### Select Two Loans to Merge
    Select Loan to Reprice    &{ExcelPath}[Alias_Loan1]
    Select Repricing Type    &{ExcelPath}[Repricing_Type]
    Select Multiple Loan to Merge    &{ExcelPath}[Alias_Loan1]    &{ExcelPath}[Alias_Loan2]
    
    Change Effective Date for Loan Repricing    ${Current_Date}

    ### Add Repricing Detail
    ${Total_LoanMergeAmount}    Add Loan Repricing Option    &{ExcelPath}[Repricing_Add_Option]    ${BaseRate_OptionName}    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Alias_Loan1]
    ...    &{ExcelPath}[Alias_Loan2]    &{ExcelPath}[Outstandings_Loan1]    &{ExcelPath}[Outstandings_Loan2]    ${BaseRate_Code}
    ${Alias_LoanMerge}    Validate Generals Tab in Rollover/Conversion to BBSY    ${BaseRate_Percentage}    &{ExcelPath}[Outstandings_Loan1]    &{ExcelPath}[Outstandings_Loan2]    ${BaseRate_Frequency}
    ...    ${Total_LoanMergeAmount}    &{ExcelPath}[OutstandingSelect_Type]
    
    Write Data To Excel    SERV11_Loan Amalgamation    LoanMerge_Amount    &{ExcelPath}[rowid]    ${Total_LoanMergeAmount}
    Write Data To Excel    SERV11_Loan Amalgamation    Alias_LoanMerge    &{ExcelPath}[rowid]    ${Alias_LoanMerge}
    Write Data To Excel    CAP03_OngoingFeeCapitalization    Loan_Alias    &{ExcelPath}[rowid]    ${Alias_LoanMerge}
    Write Data To Excel    CAP02_CapitalizedFeePayment    Loan_Alias    &{ExcelPath}[rowid]    ${Alias_LoanMerge}
    Write Data To Excel    SERV18_Payments    Loan_Alias    &{ExcelPath}[rowid]    ${Alias_LoanMerge}
    
    
    ### Send Loan Repricing to Approval
    Navigate to Loan Repricing Notebook Workflow    ${SEND_TO_APPROVAL_STATUS}
    Validate Window Title Status    ${LOAN_REPRICING}    ${AWAITING_APPROVAL_STATUS}
    
    
    ### Approve Loan Repricing
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${LOAN_REPRICING}    &{ExcelPath}[Deal_Name]
    Navigate to Loan Repricing Notebook Workflow    ${APPROVAL_STATUS}
    Validate Window Title Status    ${LOAN_REPRICING}    ${AWAITING_SEND_TO_RATE_APPROVAL_STATUS}
    
    
    ### Send to Rate Approval
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_SEND_TO_RATE_APPROVAL_STATUS}    ${LOAN_REPRICING}    &{ExcelPath}[Deal_Name]
    Navigate to Loan Repricing Notebook Workflow    ${SEND_TO_RATE_APPROVAL_STATUS}
    Validate Window Title Status    ${LOAN_REPRICING}    ${AWAITING_RATE_APPROVAL_STATUS}

    
    ### Rate Approval and Generate Rate Setting Notice
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_RATE_APPROVAL_STATUS}    ${LOAN_REPRICING}    &{ExcelPath}[Deal_Name]
    Navigate to Loan Repricing Notebook Workflow    ${RATE_APPROVAL_STATUS}
    Validate Window Title Status    ${LOAN_REPRICING}    ${AWAITING_RELEASE_STATUS}
    
    ### Release Loan Repricing
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_RELEASE_STATUS}    ${LOAN_REPRICING}    &{ExcelPath}[Deal_Name]
    Navigate to Loan Repricing Notebook Workflow    ${RELEASE_STATUS}
    Validate Window Title Status    ${LOAN_REPRICING}    ${RELEASED_STATUS}    
    
    ### @update: bernchua    07DEC2018    Scenario 8 integration: 1) Go back to original user. 2) Write new Loan Alias to Excel
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
