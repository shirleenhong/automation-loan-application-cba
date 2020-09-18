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
    ${LineFeeRate}    Get Line Fee Current Rate
    Write Data To Excel    ComSee_SC7_FacFeeSetup    Fee_CurrentRate    ${rowid}    ${LineFeeRate}    ${ComSeeDataSet}
    
    ${LineFeeCurrency}    Get Line Fee Currency
    Write Data To Excel    ComSee_SC7_FacFeeSetup    Fee_Currency    ${rowid}    ${LineFeeCurrency}    ${ComSeeDataSet}

    ${LineFeeEffectiveDate}    ${LineFeeActualExpiryDate}    Get Line Fee Effective and Actual Expiry Date
    ${LineFeeEffectiveDate}    Convert LIQ Date to Year-Month-Day Format    ${LineFeeEffectiveDate}
    ${LineFeeActualExpiryDate}    Convert LIQ Date to Year-Month-Day Format    ${LineFeeActualExpiryDate}
    Write Data To Excel    ComSee_SC7_FacFeeSetup    Fee_EffectiveDate    ${rowid}    ${LineFeeEffectiveDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_FacFeeSetup    Fee_ExpiryDate    ${rowid}    ${LineFeeActualExpiryDate}    ${ComSeeDataSet}
    
    ${LineFeeAdjustedDueDate}    Get Line Fee Adjusted Due Date
    ${LineFeeAdjustedDueDate}    Convert LIQ Date to Year-Month-Day Format    ${LineFeeAdjustedDueDate}
    Write Data To Excel    ComSee_SC7_FacFeeSetup    Fee_DueDate    ${rowid}    ${LineFeeAdjustedDueDate}    ${ComSeeDataSet}
    
    ${LineAccruedtodateAmount}    Get Line Fee Accrued to Date Amount
    ${LineAccruedtodateAmount}    Remove Comma and Convert to Number    ${LineAccruedtodateAmount}
    # ${TotalRowCount}    Get Accrual Row Count    ${LIQ_LineFee_Window}    ${LIQ_LineFee_Accrual_Cycles_JavaTree}
    # ${AccruedtoDateAmt}    Compute Total Accruals for Fee    ${TotalRowCount}    ${LIQ_LineFee_Tab}    ${LIQ_LineFee_Accrual_Cycles_JavaTree}
    # ${AccruedtoDateAmt}    Remove Comma and Convert to Number    ${AccruedtoDateAmt}
    # Validate Accrued to Date Amount    ${AccruedtoDateAmt}    ${LineAccruedtodateAmount}
    Write Data To Excel    ComSee_SC7_FacFeeSetup    Fee_AccruedToDate    ${rowid}    ${LineAccruedtodateAmount}    ${ComSeeDataSet}
    
    ${OngoingFee_PaidToDate}    Get Line Fee Paid to Date Amount
    ${OngoingFee_PaidToDate}    Remove Comma and Convert to Number    ${OngoingFee_PaidToDate}
    Write Data To Excel    ComSee_SC3_Issuance    Fee_PaidToDate    ${rowid}    ${OngoingFee_PaidToDate}    ${ComSeeDataSet}
    
    Close All Windows on LIQ  