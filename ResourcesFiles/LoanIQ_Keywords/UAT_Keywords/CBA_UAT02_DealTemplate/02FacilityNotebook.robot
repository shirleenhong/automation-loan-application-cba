*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot
    
*** Keywords ***
Setup Facility Template D00001053
    [Documentation]    High Level Keyword for Facility Template Creation
    ...    author: ritragel
    [Arguments]    ${ExcelPath}
    
    ###Name Generation###
	${FacilityName}    Auto Generate Name Test Data    &{ExcelPath}[Facility_NamePrefix]
	Write Data To Excel    CRED02_FacilitySetup    Facility_Name    &{ExcelPath}[rowid]    ${FacilityName}    ${CBAUAT_ExcelPath}
	Write Data To Excel    CRED08_FacilityFeeSetup    Facility_Name    &{ExcelPath}[rowid]   ${FacilityName}    ${CBAUAT_ExcelPath}
    Write Data To Excel    CRED01_DealSetup    Facility_Name    &{ExcelPath}[rowid]    ${FacilityName}    ${CBAUAT_ExcelPath}
    Write Data To Excel    SERV01_LoanDrawdown    Facility_Name    &{ExcelPath}[rowid]    ${FacilityName}    ${CBAUAT_ExcelPath}
    Write Data To Excel    UAT02_Runbook    Facility_Name    &{ExcelPath}[rowid]    ${FacilityName}    ${CBAUAT_ExcelPath}
    ${FacilityName}    Read Data From Excel    CRED02_FacilitySetup    Facility_Name   &{ExcelPath}[rowid]    ${CBAUAT_ExcelPath}
    ${Deal_Name}    Read Data From Excel    CRED02_FacilitySetup    Deal_Name   &{ExcelPath}[rowid]    ${CBAUAT_ExcelPath}
    
    ###Facility Creation###
    Add New Facility    ${Deal_Name}    &{ExcelPath}[Deal_Currency]    ${FacilityName}
    ...    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Facility_ProposedCmtAmt]    &{ExcelPath}[Facility_Currency]
    Verify Main SG Details    &{ExcelPath}[Facility_ServicingGroup]    &{ExcelPath}[Facility_Customer]    &{ExcelPath}[Facility_SGLocation]
    
    ###Set Facility Dates###
    Write Data To Excel    SERV01_LoanDrawdown    Loan_MaturityDate    &{ExcelPath}[rowid]    &{ExcelPath}[Facility_MaturityDate]    ${CBAUAT_ExcelPath}
    Set Facility Dates    &{ExcelPath}[Facility_AgreementDate]    &{ExcelPath}[Facility_EffectiveDate]    &{ExcelPath}[Facility_ExpiryDate]    &{ExcelPath}[Facility_MaturityDate]
    
    ###Enter Multiple Risk Types###
    Set Facility Risk Type    &{ExcelPath}[Facility_RiskType]
    
    ###Enter Loan Purpose Type###
    Set Facility Loan Purpose Type    &{ExcelPath}[Facility_LoanPurposeType]
    
    ### Add Facility Currency
    Add Facility Currency    &{ExcelPath}[CurrencyLimit]
        
    ### Add Facility Borrower
    Add Borrower    &{ExcelPath}[Borrower_Currency]    &{ExcelPath}[Facility_BorrowerSGName]    &{ExcelPath}[Facility_BorrowerPercent]    &{ExcelPath}[Facility_Borrower]
    ...    &{ExcelPath}[Facility_GlobalLimit]    &{ExcelPath}[Facility_BorrowerMaturity]    &{ExcelPath}[Facility_EffectiveDate]
    
    Validate Multi CCY Facility

Setup Facility Fees D00001053
    [Documentation]    High-level keyword for Facility Pricing set up.
    ...                @author: ritragel
    ...                @update: bernchua    25JUL2019    Removed conditions since in every conditions it just runs the same script, just a difference in data depending on the rowid.
    ...                                                  Also updated the variables names and removed the numbers.
    [Arguments]    ${ExcelPath}
    
    ### Interest Pricing
    Modify Interest Pricing - Insert Add    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName]    &{ExcelPath}[Interest_RateBasis]    &{ExcelPath}[Interest_SpreadValue]    &{ExcelPath}[Interest_BaseRateCode]
    
    Write Data To Excel    SERV01_LoanDrawdown    Pricing_Option    &{ExcelPath}[rowid]    &{ExcelPath}[Interest_OptionName]    ${CBAUAT_ExcelPath}
    Write Data To Excel    SERV01_LoanDrawdown    Loan_AllInRate    &{ExcelPath}[rowid]    &{ExcelPath}[Interest_SpreadValue]    ${CBAUAT_ExcelPath}
    Write Data To Excel    UAT02_Runbook    Pricing_Option    &{ExcelPath}[rowid]    &{ExcelPath}[Interest_OptionName]    ${CBAUAT_ExcelPath}
    
    Set Facility Pricing Penalty Spread    &{ExcelPath}[Penalty_Spread]    &{ExcelPath}[Penalty_Status]
    
    ###Facility Notebook - Pricing Rules Tab###
    Validate Facility
    mx LoanIQ close window    ${LIQ_FacilityNavigator_Window}
