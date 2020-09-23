*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Facility Fee Setup - ComSee
    [Documentation]    This high-level keyword sets up Ongoing Fee and Interest Fee for Facility.
    ...    @author: rtarayao    16AUG2019    Initial Create
    [Arguments]    ${ComSeeDataSet}
    ###Facility Notebook - Pricing Tab###
    Modify Ongoing Fee Pricing - Insert Add    &{ComSeeDataSet}[OngoingFee_Category1]    &{ComSeeDataSet}[OngoingFee_Type1]    &{ComSeeDataSet}[OngoingFee_RateBasis1]
    Modify Ongoing Fee Pricing - Insert After   &{ComSeeDataSet}[OngoingFee_AfterItem]    &{ComSeeDataSet}[Facility_PercentWhole]    &{ComSeeDataSet}[OngoingFee_Category1]    &{ComSeeDataSet}[Facility_Percent] 
    Modify Interest Pricing - Insert Add    &{ComSeeDataSet}[Interest_AddItem]    &{ComSeeDataSet}[Interest_OptionName1]    &{ComSeeDataSet}[Interest_RateBasis]    &{ComSeeDataSet}[Interest_SpreadAmt1]    &{ComSeeDataSet}[Interest_BaseRateCode1]
    
    ###Facility Notebook - Pricing Rules Tab###
    Verify Pricing Rules    &{ComSeeDataSet}[Interest_OptionName1]
    
    ###Facility and Fee Validations
    Validate Facility
    Close Facility Navigator Window
    Navigate to Facility Notebook from Deal Notebook    &{ComSeeDataSet}[Facility_Name]
    Validate Window Title Status    Facility    Pending
    Navigate to Commitment Fee Notebook    &{ComSeeDataSet}[OngoingFee_Type1]
    Validate Window Title Status    Commitment    Status
    Close Commitment Fee and Fee List Windows
    Close Facility Notebook and Navigator Windows
    
Setup Issuance Fee for Facility - ComSee
    [Documentation]    This high-level keyword sets up Issuance Fee for Facility.
    ...    @author: rtarayao    20AUG2019    Initial Create
    [Arguments]    ${ComSeeDataSet}
    ###Facility Notebook - Pricing Tab###
    Modify Ongoing Fee Pricing - Insert Add    &{ComSeeDataSet}[OngoingFee_Category1]    &{ComSeeDataSet}[OngoingFee_Type1]    &{ComSeeDataSet}[OngoingFee_RateBasis1]
    Modify Ongoing Fee Pricing - Insert After   &{ComSeeDataSet}[OngoingFee_AfterItem]    &{ComSeeDataSet}[Facility_PercentWhole]    &{ComSeeDataSet}[OngoingFee_Category1]    &{ComSeeDataSet}[Facility_Percent] 
    Modify Interest Pricing - Insert Add    &{ComSeeDataSet}[Interest_AddItem]    &{ComSeeDataSet}[Interest_OptionName1]    &{ComSeeDataSet}[Interest_RateBasis]    &{ComSeeDataSet}[Interest_SpreadAmt1]    &{ComSeeDataSet}[Interest_BaseRateCode1]
    
    ###Facility Notebook - Pricing Rules Tab###
    Verify Pricing Rules    &{ComSeeDataSet}[Interest_OptionName1]
    
    ###Facility and Fee Validations
    Validate Facility
    Close Facility Navigator Window
    
Setup Facility Fee - Scenario 7 ComSee
    [Documentation]    This high-level keyword sets up Ongoing Fee and Interest Fee for Facility.
    ...    @author: rtarayao    10SEP2019    Initial Create
    [Arguments]    ${ComSeeDataSet}
    ###Facility Notebook - Pricing Tab###
    Modify Ongoing Fee Pricing - Insert Add    &{ComSeeDataSet}[OngoingFee_Category1]    &{ComSeeDataSet}[OngoingFee_Type1]    &{ComSeeDataSet}[OngoingFee_RateBasis1]
    Modify Ongoing Fee Pricing - Insert After   &{ComSeeDataSet}[OngoingFee_AfterItem]    &{ComSeeDataSet}[Facility_PercentWhole]    &{ComSeeDataSet}[OngoingFee_Category1]    &{ComSeeDataSet}[Facility_Percent] 
    Modify Interest Pricing - Insert Add    &{ComSeeDataSet}[Interest_AddItem]    &{ComSeeDataSet}[Interest_OptionName1]    &{ComSeeDataSet}[Interest_RateBasis]    &{ComSeeDataSet}[Interest_SpreadAmt1]    &{ComSeeDataSet}[Interest_BaseRateCode1]
    
    ###Facility Notebook - Pricing Rules Tab###
    Verify Pricing Rules    &{ComSeeDataSet}[Interest_OptionName1]
    
    ###Facility and Fee Validations
    Validate Facility
    Close Facility Navigator Window
    Navigate to Facility Notebook from Deal Notebook    &{ComSeeDataSet}[Facility_Name]
    Validate Window Title Status    Facility    Pending
    Navigate to Commitment Fee Notebook    &{ComSeeDataSet}[OngoingFee_Type1]
    Validate Window Title Status    Commitment    Status
    Close Line Fee and Fee List Windows
    Close Facility Notebook and Navigator Windows
    
Write Facility Ongoing Fee Details - Scenario 7 ComSee
    [Documentation]    This test case writes the test ongoing fee details for NonAgent Host Bank Deal.
    ...    Fee details are written for ComSee use.
    ...    @author: rtarayao    02SEP2019    - Initial create
    [Arguments]    ${ExcelPath}
    
    ###LIQ Login
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Read Facility Name and Deal Name
    ${FacilityName}    Read Data From Excel    ComSee_SC7_FacFeeSetup    Facility_Name    ${rowid}    ${ComSeeDataSet}
    ${DealName}    Read Data From Excel    ComSee_SC7_Deal    Deal_Name    ${rowid}    ${ComSeeDataSet} 
    Write Data To Excel    ComSee_SC7_FacFeeSetup    Fee_Name    ${rowid}    ${FacilityName}    ${ComSeeDataSet}  
    
    ###Search Deal and Write Facility Name for ComSee
    Open Existing Deal    ${DealName}
    
    ###Ongoing Fee Details
    Navigate to Facility Notebook from Deal Notebook    ${FacilityName}
    Navigate to Commitment Fee List
    
    ###Get and Write Fronting Commitment Fee (SFBG) Details
    ${LineFee}    Read Data From Excel    ComSee_SC7_FacFeeSetup    OngoingFee_Type1    ${rowid}    ${ComSeeDataSet}
    ${LineFee_Status}    ${LineFee_Alias}    Get Ongoing Fee Alias and Status    ${LineFee}
    
    Write Data To Excel    ComSee_SC7_FacFeeSetup    Fee_Type    ${rowid}    ${LineFee}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_FacFeeSetup    Fee_Status    ${rowid}    ${LineFee_Status}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_FacFeeSetup    Fee_FeeAlias    ${rowid}    ${LineFee_Alias}    ${ComSeeDataSet}
    
    ###Close Fee List Window
    Close Facility Fee List Window
    
    ###Navigate to Commitment Fee Notebook
    Navigate to Commitment Fee Notebook    ${LineFee}
    
    ###Write Fee Details for Comsee
    ${LineFeeRate}    Get Fee Current Rate    ${LIQ_LineFee_Window}    ${LIQ_LineFee_CurrentRate_Field}
    Write Data To Excel    ComSee_SC7_FacFeeSetup    Fee_CurrentRate    ${rowid}    ${LineFeeRate}    ${ComSeeDataSet}
    
    ${LineFeeCurrency}    Get Fee Currency    ${LIQ_LineFee_Window}    ${LIQ_LineFee_Currency_Text}
    Write Data To Excel    ComSee_SC7_FacFeeSetup    Fee_Currency    ${rowid}    ${LineFeeCurrency}    ${ComSeeDataSet}

    ${LineFeeEffectiveDate}    ${LineFeeActualExpiryDate}    Get Fee Effective and Actual Expiry Date    ${LIQ_LineFee_Window}    ${LIQ_LineFee_Effective_Date}    ${LIQ_LineFee_ActualExpiryDate_Text}
    ${LineFeeEffectiveDate}    Convert LIQ Date to Year-Month-Day Format    ${LineFeeEffectiveDate}
    ${LineFeeActualExpiryDate}    Convert LIQ Date to Year-Month-Day Format    ${LineFeeActualExpiryDate}
    Write Data To Excel    ComSee_SC7_FacFeeSetup    Fee_EffectiveDate    ${rowid}    ${LineFeeEffectiveDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_FacFeeSetup    Fee_ExpiryDate    ${rowid}    ${LineFeeActualExpiryDate}    ${ComSeeDataSet}
    
    ${LineFeeCycleStartDate}    ${LineFeeAccrualEndDate}    Get Fee Accrual Cycle Start and End Date    ${LIQ_LineFee_Window}    ${LIQ_LineFee_CycleStartDate_Text}    ${LIQ_LineFee_AccrualEnd_Date}
    ${LineFeeCycleStartDate}    Convert LIQ Date to Year-Month-Day Format    ${LineFeeCycleStartDate}
    ${LineFeeAccrualEndDate}    Convert LIQ Date to Year-Month-Day Format    ${LineFeeAccrualEndDate}
    Write Data To Excel    ComSee_SC7_FacFeeSetup    Fee_CycleStartDate    ${rowid}    ${LineFeeCycleStartDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_FacFeeSetup    Fee_AccrualEndDate    ${rowid}    ${LineFeeAccrualEndDate}    ${ComSeeDataSet}
    
    ${LineFeeAdjustedDueDate}    Get Fee Adjusted Due Date    ${LIQ_LineFee_Window}    ${LIQ_LineFee_AdjustedDue_Date}
    ${LineFeeAdjustedDueDate}    Convert LIQ Date to Year-Month-Day Format    ${LineFeeAdjustedDueDate}
    Write Data To Excel    ComSee_SC7_FacFeeSetup    Fee_DueDate    ${rowid}    ${LineFeeAdjustedDueDate}    ${ComSeeDataSet}
    
    ${LineAccruedtodateAmount}    Get Fee Accrued to Date Amount    ${LIQ_LineFee_Window}    ${LIQ_LineFee_Tab}    ${LIQ_LineFee_Accrual_Cycles_JavaTree}
    ${LineAccruedtodateAmount}    Remove Comma and Convert to Number    ${LineAccruedtodateAmount}
    Write Data To Excel    ComSee_SC7_FacFeeSetup    Fee_AccruedToDate    ${rowid}    ${LineAccruedtodateAmount}    ${ComSeeDataSet}
    
    ${OngoingFee_PaidToDate}    Get Fee Paid to Date Amount    ${LIQ_LineFee_Window}    ${LIQ_LineFee_Tab}    ${LIQ_LineFee_Accrual_Cycles_JavaTree}
    ${OngoingFee_PaidToDate}    Remove Comma and Convert to Number    ${OngoingFee_PaidToDate}
    Write Data To Excel    ComSee_SC3_Issuance    Fee_PaidToDate    ${rowid}    ${OngoingFee_PaidToDate}    ${ComSeeDataSet}
    
    Close All Windows on LIQ  
# Setup Term Facility for Syndicated Deal - ComSee 
    # [Documentation]    This keyword is used to create a Term Facility with multiple ongoing fees for syndicated deal.
    # ...    @author: rtarayao    02SEP2019    - initial create
    # ...    @update: jloretiz    07NOV2019....- add writing of details for facility in issuance tab
    # [Arguments]    ${ExcelPath}
    
    # ###Data Generation###
    # ${Facility_Name}    Auto Generate Name Test Data    &{ExcelPath}[Facility_NamePrefix]
    # Write Data To Excel    ComSee_SC2_Deal    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}
    # Write Data To Excel    ComSee_SC2_FacSetup    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}
    # Write Data To Excel    ComSee_SC2_FacFeeSetup    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}
    # Write Data To Excel    ComSee_SC2_Loan    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}
    # Write Data To Excel    ComSee_SC2_Issuance    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet} 
    # Write Data To Excel    ComSee_SC2_LoanRepricing    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}

    # ${FacilityName}    Read Data From Excel    ComSee_SC2_FacSetup    Facility_Name    ${rowid}    ${ComSeeDataSet}
    
    # ###Facility Creation###
    # Add New Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Deal_Currency]    ${FacilityName}
    # ...    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Facility_ProposedCmtAmt]    &{ExcelPath}[Facility_Currency]
    
    # ${Facility_AgreementDate}    Get System Date
    # ${Facility_EffectiveDate}    Get System Date
    # ${Facility_ExpiryDate}    Add Days to Date    ${Facility_EffectiveDate}    365
    # ${Facility_MaturityDate}    Add Days to Date    ${Facility_EffectiveDate}    395
    
    # Set Facility Dates    ${Facility_AgreementDate}    ${Facility_EffectiveDate}    ${Facility_ExpiryDate}    ${Facility_MaturityDate}
    # Set Facility Risk Type    &{ExcelPath}[Facility_RiskType1]
    # Set Facility Risk Type    &{ExcelPath}[Facility_RiskType2]
    # Set Facility Loan Purpose Type    &{ExcelPath}[Facility_LoanPurposeType]
    # Add Facility Currency    &{ExcelPath}[Facility_Currency1]
    # Add Facility Currency    &{ExcelPath}[Facility_Currency2]
    # Add Facility Borrower - Add All    &{ExcelPath}[Facility_Borrower]
    # Validate Risk Type in Borrower Select    &{ExcelPath}[Facility_RiskType1]
    # Validate Risk Type in Borrower Select    &{ExcelPath}[Facility_RiskType2]
    # Validate Currency Limit in Borrower Select    &{ExcelPath}[Facility_Currency1]
    # Validate Currency Limit in Borrower Select    &{ExcelPath}[Facility_Currency2]
    # Complete Facility Borrower Setup
    
    # ###Get necessary data from created Facility and store to Excel to be used in other transactions###
    # ${ExpiryDate}    Get Data From LoanIQ    ${LIQ_FacilityNotebook_Window}    ${LIQ_FacilityNotebook_Tab}    Summary    ${LIQ_FacilitySummary_ExpiryDate_Datefield}
    # Write Data To Excel    ComSee_SC2_Deal    Primary_PortfolioExpiryDate    ${rowid}    ${ExpiryDate}    ${ComSeeDataSet}
    # Write Data To Excel    ComSee_SC2_Issuance    SBLC_ExpiryDate    ${rowid}    ${ExpiryDate}    ${ComSeeDataSet}
    
    # ${FacilityControlNumber}    Get Facility Control Number
    # ${MulitCCYStatus}    Get Facility Multi CCY Status
    # Write Data To Excel    ComSee_SC2_FacSetup    Facility_MultiCCY    ${rowid}    ${MulitCCYStatus}    ${ComSeeDataSet}
    # Write Data To Excel    ComSee_SC2_Deal    COM_ID    ${rowid}    ${FacilityControlNumber}    ${ComSeeDataSet}
    # Write Data To Excel    ComSee_SC2_FacSetup    Facility_ControlNumber    ${rowid}    ${FacilityControlNumber}    ${ComSeeDataSet}
    # Write Data To Excel    ComSee_SC2_Loan    COM_ID    ${rowid}    ${FacilityControlNumber}    ${ComSeeDataSet}
    # Write Data To Excel    ComSee_SC2_Issuance    COM_ID    ${rowid}    ${FacilityControlNumber}    ${ComSeeDataSet}
    
    # ${Facility_EffectiveDate}    Convert LIQ Date to Year-Month-Day Format    ${Facility_EffectiveDate}
    # ${Facility_ExpiryDate}    Convert LIQ Date to Year-Month-Day Format    ${Facility_ExpiryDate}
    # ${Facility_MaturityDate}    Convert LIQ Date to Year-Month-Day Format    ${Facility_MaturityDate}
    
    # Write Data To Excel    ComSee_SC2_FacSetup    Facility_EffectiveDate    ${rowid}    ${Facility_EffectiveDate}    ${ComSeeDataSet}
    # Write Data To Excel    ComSee_SC2_FacSetup    Facility_ExpiryDate    ${rowid}    ${Facility_ExpiryDate}    ${ComSeeDataSet}
    # Write Data To Excel    ComSee_SC2_FacSetup    Facility_FinalMaturityDate    ${rowid}    ${Facility_MaturityDate}    ${ComSeeDataSet}
    # Write Data To Excel    ComSee_SC2_Loan    Loan_MaturityDate    ${rowid}    ${Facility_MaturityDate}    ${ComSeeDataSet}
    
    # ###Facility Notebook - Codes Tab###
    # ${FundingDeskDesc}    Get Facility Funding Desk Description
    # Write Data To Excel    ComSee_SC2_FacSetup    Facility_FundingDeskDescription    ${rowid}    ${FundingDeskDesc}    ${ComSeeDataSet}