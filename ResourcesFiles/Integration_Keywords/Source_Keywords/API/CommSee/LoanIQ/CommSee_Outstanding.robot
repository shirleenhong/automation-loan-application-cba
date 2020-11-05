*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
   
*** Keywords ***
Create SBLC Guarantee Issuance - ComSee
    [Documentation]    This high-level keyword will cater the creation of Bank Guarantee.
    ...    @author: rtarayao    22AUG2019    Initial Create
    [Arguments]    ${ExcelPath}
    ###LIQ Window###
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Deal Notebook###
    ${Effective_Date}    Get System Date
    Open Existing Deal    &{ExcelPath}[Deal_Name]

    ###Outstanding Select Window###
    ${Alias}    Create New Outstanding Select - SBLC    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Amount_Requested]    
    ...    ${Effective_Date}   &{ExcelPath}[Pricing_Option]    &{ExcelPath}[SBLC_ExpiryDate]    &{ExcelPath}[Deal_Name]
    Write Data To Excel    ComSee_SC3_Issuance    Fee_Name    ${rowid}    ${Alias}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC3_IssuanceFeePayment    Fee_Name    ${rowid}    ${Alias}    ${ComSeeDataSet} 
    Write Data To Excel    ComSee_SC3_IssuanceFeePayment    Outstanding_Alias    ${rowid}    ${Alias}    ${ComSeeDataSet} 
    ${Alias}    Read Data From Excel    ComSee_SC3_Issuance    Fee_Name    ${rowid}    ${ComSeeDataSet}    
        
    ###SBLC Notebook###
    Verify Pricing Formula    &{ExcelPath}[Issuance_Fee]    &{ExcelPath}[Cycle_Frequency]    &{ExcelPath}[AccrualRule_PayInAdvance]
    Add Banks    &{ExcelPath}[Outstanding_Favouree]   
    Complete Workflow Items    &{ExcelPath}[Outstanding_Favouree]    &{ExcelPath}[SBLC_Status]   
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Transaction in Process###
    Navigate Transaction in WIP    &{ExcelPath}[Transaction_Type]    &{ExcelPath}[Transaction_Status_Awaiting_Approval]    &{ExcelPath}[Outstanding_Type]    ${Alias}    
    
    ###SBLC Notebook###
    Approve SBLC Issuance
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ###Transaction In Process###
    Navigate Transaction in WIP    &{ExcelPath}[Transaction_Type]    &{ExcelPath}[Transaction_Status_Awaiting_Release]    &{ExcelPath}[Outstanding_Type]    ${Alias}
    
    ##SBLC Notebook###
    Release SLBC Issuance in Workflow        
    Verify SBLC Issuance Status        &{ExcelPath}[Deal_Name]    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]    ${Alias}    &{ExcelPath}[Cycle_Number]   

    ###LIQ Window###
    Close All Windows on LIQ
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Outstanding Navigation###
    Navigate to Existing SBLC Guarantee    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    ${Alias}
    
    ###Get and Write Rates Tab Details for Comsee
    ${IssuanceRiskType}    Get Issuance Risk Type 
    Write Data To Excel    ComSee_SC3_Issuance    Outstanding_RiskType    ${rowid}    ${IssuanceRiskType}    ${ComSeeDataSet}
    
    ${IssuanceCCY}    Get Issuance Currency
    Write Data To Excel    ComSee_SC3_Issuance    Outstanding_Currency    ${rowid}    ${IssuanceCCY}    ${ComSeeDataSet}
    
    ${IssuanceEffectiveDate}    ${IssuanceAdjustedExpiryDate}    Get Issuance Effective and Maturity Expiry Dates
    ${IssuanceEffectiveDate}    Convert LIQ Date to Year-Month-Day Format    ${IssuanceEffectiveDate}
    ${IssuanceAdjustedExpiryDate}    Convert LIQ Date to Year-Month-Day Format    ${IssuanceAdjustedExpiryDate}
    Write Data To Excel    ComSee_SC3_Issuance    Outstanding_EffectiveDate    ${rowid}    ${IssuanceEffectiveDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC3_Issuance    Outstanding_MaturityExpiryDate    ${rowid}    ${IssuanceAdjustedExpiryDate}    ${ComSeeDataSet}
    
    ${HBGrossAmount}    ${HBNetAmount}    Get Issuance Host Bank Net and Gross Amount
    ${HBGrossAmount}    Remove Comma and Convert to Number    ${HBGrossAmount}
    ${HBNetAmount}    Remove Comma and Convert to Number    ${HBNetAmount}
    Write Data To Excel    ComSee_SC3_Issuance    Outstanding_HBGrossAmount    ${rowid}    ${HBGrossAmount}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC3_Issuance    Outstanding_HBNetAmount    ${rowid}    ${HBNetAmount}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC3_Issuance    Outstanding_HBNetFacCCYAmount    ${rowid}    ${HBNetAmount}    ${ComSeeDataSet}
    
    ${GlobalOriginalAmount}    ${GlobalCurrentAmount}    Get Issuance Global Original and Current Amount
    ${GlobalOriginalAmount}    Remove Comma and Convert to Number    ${GlobalOriginalAmount}
    ${GlobalCurrentAmount}    Remove Comma and Convert to Number    ${GlobalCurrentAmount}
    Write Data To Excel    ComSee_SC3_Issuance    Outstanding_GlobalOriginalAmount    ${rowid}    ${GlobalOriginalAmount}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC3_Issuance    Outstanding_GlobalCurrentAmount    ${rowid}    ${GlobalCurrentAmount}    ${ComSeeDataSet}
     
    ${Fee_Type}    Get Issuance Fee Type
    Write Data To Excel    ComSee_SC3_Issuance    Fee_Type    ${rowid}    ${Fee_Type}    ${ComSeeDataSet} 
    
    ${Fee_Currency}    Get SBLC Accrual CCY
    Write Data To Excel    ComSee_SC3_Issuance    Fee_Currency    ${rowid}    ${Fee_Currency}    ${ComSeeDataSet}
    
    ${Fee_CurrentRate}    Get Issuance Rate
    Write Data To Excel    ComSee_SC3_Issuance    Fee_CurrentRate    ${rowid}    ${Fee_CurrentRate}    ${ComSeeDataSet}
    
    ${Fee_EffectiveDate}    ${Fee_ExpiryDate}    ${Fee_DueDate}    Get Issuance Accrual Dates
    ${Fee_EffectiveDate}    Convert LIQ Date to Year-Month-Day Format    ${Fee_EffectiveDate}
    ${Fee_ExpiryDate}    Convert LIQ Date to Year-Month-Day Format    ${Fee_ExpiryDate}
    ${Fee_DueDate}    Convert LIQ Date to Year-Month-Day Format    ${Fee_DueDate}
    Write Data To Excel    ComSee_SC3_Issuance    Fee_EffectiveDate    ${rowid}    ${Fee_EffectiveDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC3_Issuance    Fee_ExpiryDate    ${rowid}    ${Fee_ExpiryDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC3_Issuance    Fee_DueDate    ${rowid}    ${Fee_DueDate}    ${ComSeeDataSet}
    
    ###Accrual Tab - Get Total Accrued to Date
    ${IssuanceFee_AccruedToDate}    Get Issuance Accrued to Date Amount
    ${IssuanceFee_AccruedToDate}    Remove Comma and Convert to Number    ${IssuanceFee_AccruedToDate}
    # ${TotalRowCount}    Get Accrual Row Count    ${LIQ_BankGuarantee_Window}    ${LIQ_BankGuarantee_Accrual_JavaTree}
    # ${AccruedtoDateAmt}    Compute Total Accruals for Fee    ${TotalRowCount}    ${LIQ_SBLCGuarantee_Window_Tab}    ${LIQ_BankGuarantee_Accrual_JavaTree}
    # ${AccruedtoDateAmt}    Remove Comma and Convert to Number    ${AccruedtoDateAmt}
    # Validate Accrued to Date Amount    ${AccruedtoDateAmt}    ${IssuanceFee_AccruedToDate}
    Write Data To Excel    ComSee_SC3_Issuance    Fee_AccruedToDate    ${rowid}    ${IssuanceFee_AccruedToDate}    ${ComSeeDataSet}
    
    Close All Windows on LIQ
    Logout from Loan IQ
    
Update SBLC Guarantee Issuance - ComSee
    [Documentation]    This high-level keyword will cater the update of Bank Guarantee.
    ...    @author: cfrancis    15SEP2020    Initial Create
    ...    @update: clanding    02NOV2020    Added getting of ${OngoingFee_CycleDue} and writing to excel
    [Arguments]    ${ExcelPath}
    ###LIQ Window###
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Deal Notebook###
    ${Effective_Date}    Get System Date
    Open Existing Deal    &{ExcelPath}[Deal_Name]

    ###Outstanding Navigation###
    Navigate to Existing SBLC Guarantee    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    ${Alias}
    
    ${Fee_EffectiveDate}    ${Fee_ExpiryDate}    ${Fee_DueDate}    Get Issuance Accrual Dates
    ${Fee_EffectiveDate}    Convert LIQ Date to Year-Month-Day Format    ${Fee_EffectiveDate}
    ${Fee_ExpiryDate}    Convert LIQ Date to Year-Month-Day Format    ${Fee_ExpiryDate}
    ${Fee_DueDate}    Convert LIQ Date to Year-Month-Day Format    ${Fee_DueDate}
    Write Data To Excel    ComSee_SC3_Issuance    Fee_EffectiveDate    ${rowid}    ${Fee_EffectiveDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC3_Issuance    Fee_ExpiryDate    ${rowid}    ${Fee_ExpiryDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC3_Issuance    Fee_DueDate    ${rowid}    ${Fee_DueDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC3_Issuance    Fee_CycleStartDate    ${rowid}    ${Fee_EffectiveDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC3_Issuance    Fee_AccrualEndDate    ${rowid}    ${Fee_ExpiryDate}    ${ComSeeDataSet}
    
    ###Accrual Tab - Get Total Accrued to Date
    ${IssuanceFee_AccruedToDate}    Get Issuance Accrued to Date Amount
    ${IssuanceFee_AccruedToDate}    Remove Comma and Convert to Number    ${IssuanceFee_AccruedToDate}
    Write Data To Excel    ComSee_SC3_Issuance    Fee_AccruedToDate    ${rowid}    ${IssuanceFee_AccruedToDate}    ${ComSeeDataSet}
    
    ${IssuanceFee_PaidToDate}    Get Issuance Paid to Date Amount
    ${IssuanceFee_PaidToDate}    Remove Comma and Convert to Number    ${IssuanceFee_PaidToDate}
    Write Data To Excel    ComSee_SC3_Issuance    Fee_PaidToDate    ${rowid}    ${IssuanceFee_PaidToDate}    ${ComSeeDataSet}
    
    ${OngoingFee_CycleDue}    Get Fee Cycle Due Amount    ${LIQ_SBLCGuarantee_Window_Tab}    ${LIQ_SBLCGuarantee_Window_Tab}    ${LIQ_BankGuarantee_Accrual_JavaTree}
    Write Data To Excel    ComSee_SC3_Issuance    Fee_CycleDue    ${rowid}    ${OngoingFee_CycleDue}    ${ComSeeDataSet}
    
    Close All Windows on LIQ
    Logout from Loan IQ