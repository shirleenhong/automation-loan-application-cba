*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Setup Term Facility for Syndicated Deal for DNR
    [Documentation]    This keyword is used to create a Term Facility.
    ...    @author:fluberio    25NOV2020    initial create
    [Arguments]    ${ExcelPath}
    
    ###Data Generation###
    ${Facility_Name}    Auto Generate Name Test Data    &{ExcelPath}[Facility_NamePrefix]
    Write Data To Excel    SC2_DealSetup    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}
    Write Data To Excel    SC2_FacilitySetup    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}
    Write Data To Excel    SC2_OngoingFeeSetup    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}
    Write Data To Excel    SC2_EventFee    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}
    Write Data To Excel    SC2_PrimaryAllocation    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}
    Write Data To Excel    SC2_LoanDrawdown    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}
    Write Data To Excel    SC2_LoanDrawdownNonAgent    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}  
    Write Data To Excel    SC2_LoanRepricing    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}
    Write Data To Excel    SC2_FacilityShareAdjustment    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}
    Write Data To Excel    SC2_CycleShareAdjustment    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}
    Write Data To Excel    SC2_PaymentFees    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}
    
    ${FacilityName}    Read Data From Excel    SC2_FacilitySetup    Facility_Name    ${rowid}    ${DNR_DATASET}
    
    Mx LoanIQ Maximize    ${LIQ_Window} 
    ###Facility Creation###
    Add New Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Deal_Currency]    ${FacilityName}
    ...    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Facility_ProposedCmtAmt]    &{ExcelPath}[Facility_Currency]
    
    ${Facility_AgreementDate}    Get System Date
    ${Facility_EffectiveDate}    Get System Date
    ${Facility_ExpiryDate}    Add Days to Date    ${Facility_EffectiveDate}    365
    ${Facility_MaturityDate}    Add Days to Date    ${Facility_EffectiveDate}    395
    
    Write Data To Excel    SC2_LoanDrawdown    Loan_MaturityDate    ${rowid}    ${Facility_MaturityDate}    ${DNR_DATASET}
    Write Data To Excel    SC2_LoanDrawdownNonAgent    Loan_MaturityDate    ${rowid}    ${Facility_MaturityDate}    ${DNR_DATASET}
    
    Set Facility Dates    ${Facility_AgreementDate}    ${Facility_EffectiveDate}    ${Facility_ExpiryDate}    ${Facility_MaturityDate}
    Set Facility Risk Type    &{ExcelPath}[Facility_RiskType1]
    Set Facility Risk Type    &{ExcelPath}[Facility_RiskType2]
    Set Facility Loan Purpose Type    &{ExcelPath}[Facility_LoanPurposeType]
    Add Facility Currency    &{ExcelPath}[Facility_Currency1]
    Add Facility Currency    &{ExcelPath}[Facility_Currency2]
    Add Facility Borrower - Add All    &{ExcelPath}[Facility_Borrower]
    Validate Risk Type in Borrower Select    &{ExcelPath}[Facility_RiskType1]
    Validate Risk Type in Borrower Select    &{ExcelPath}[Facility_RiskType2]
    Validate Currency Limit in Borrower Select    &{ExcelPath}[Facility_Currency1]
    Validate Currency Limit in Borrower Select    &{ExcelPath}[Facility_Currency2]
    Complete Facility Borrower Setup
    
    ###Get necessary data from created Facility and store to Excel to be used in other transactions###
    ${EffectiveDate}    Get Data From LoanIQ    ${LIQ_FacilityNotebook_Window}    ${LIQ_FacilityNotebook_Tab}    Summary    ${LIQ_FacilitySummary_EffectiveDate_Datefield}
    ${ExpiryDate}    Get Data From LoanIQ    ${LIQ_FacilityNotebook_Window}    ${LIQ_FacilityNotebook_Tab}    Summary    ${LIQ_FacilitySummary_ExpiryDate_Datefield}
    Write Data To Excel    SC2_DealSetup    ApproveDate    ${rowid}    ${EffectiveDate}    ${DNR_DATASET}
    Write Data To Excel    SC2_DealSetup    CloseDate    ${rowid}    ${EffectiveDate}    ${DNR_DATASET}
    Write Data To Excel    SC2_PrimaryAllocation    ApproveDate    ${rowid}    ${EffectiveDate}    ${DNR_DATASET}
    Write Data To Excel    SC2_PrimaryAllocation    CloseDate    ${rowid}    ${EffectiveDate}    ${DNR_DATASET}
    Write Data To Excel    SC2_DealSetup    Primary_CircledDate    ${rowid}    ${EffectiveDate}    ${DNR_DATASET}
    Write Data To Excel    SC2_DealSetup    Primary_PortfolioExpiryDate    ${rowid}    ${ExpiryDate}    ${DNR_DATASET}
    Write Data To Excel    SC2_EventFee    EventFee_EffectiveDate    ${rowid}    ${EffectiveDate}    ${DNR_DATASET}
    
    ${EventFee_NoRecurrencesAfterDate}    Get Back Dated Current Date    -365
    Write Data To Excel    SC2_EventFee    EventFee_NoRecurrencesAfterDate    ${rowid}    ${EventFee_NoRecurrencesAfterDate}    ${DNR_DATASET}