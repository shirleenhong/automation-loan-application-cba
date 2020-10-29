*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Create Pricing Change Transaction SCAF
    [Documentation]    The keyword will Create Pricing Change Transaction.
    ...    @author: 
    ...    @update: amansuet    26MAY2020    - updated keywords and reused existing keyword
    [Arguments]    ${ExcelPath}

    ###Loan IQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Update Ongoing Fee and Interest Pricing###
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    ${Facility_OngoingFeeRatePercentage}    Save Ongoing Fee Rate in Facility Notebook
    Write Data To Excel    AMCH06_PricingChangeTransaction    OngoingFeeRate_SaveOriginal    ${rowid}    ${Facility_OngoingFeeRatePercentage}
    Navigate to Pricing Change Transaction Menu
    Input Pricing Change Transaction General Information    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[PricingChange_TransactionNo]    &{ExcelPath}[PricingChange_EffectiveDate]    &{ExcelPath}[PricingChange_Desc]
    Modify Ongoing Fees    &{ExcelPath}[PricingChange_OngoingFeeStr]    &{ExcelPath}[OngoingFeePercent]    &{ExcelPath}[UnutilizedRate]
    ${PriceChange_OngoingFee_RateStr}    Save Ongoing Fees in Pricing Change Transaction Window    &{ExcelPath}[PricingChange_OngoingFeeRate]
    Write Data To Excel    AMCH06_PricingChangeTransaction    PricingChange_OngoingFeeRate_SavedStr    ${rowid}    ${PriceChange_OngoingFee_RateStr}
    Update Interest Pricing via Pricing Change Transaction    &{ExcelPath}[Interest_OptionName1]    &{ExcelPath}[Interest_SpreadAmt1]    &{ExcelPath}[Interest_BaseRateCode1]    
    
    ##Send to Approval##
    Select Pricing Change Transaction Send to Approval
    Logout from Loan IQ

    ##Approver Supervisor##
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Navigate to Pricing Change Transaction Menu
    Approve Price Change Transaction
    Logout from Loan IQ

    ##Approver Manager##
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Select Item in Work in Process    Facilities    Awaiting Release    Pricing Change Transaction     &{ExcelPath}[Facility_Name]
    Select Pricing Change Transaction Release
    
    ##Verify Events##
    Select Events Tab then Verify the Events    &{ExcelPath}[Created_Event]    &{ExcelPath}[OngoingFeePricingChanged_Event]
    Close the Pricing Change Transaction Window
    
    ##Final Validation##
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Validate Updated Ongoing Fees in Facility Notebook    ${PriceChange_OngoingFee_RateStr}
    Compare Previous and Current Ongoing Fee Values of the Facility Notebook    ${Facility_OngoingFeeRatePercentage}
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}