*** Settings ***
Resource     ../../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Set Up Facility - ComSee
    [Documentation]    This keyword is used to create a facility.
    ...    @author: rtarayao    14AUG2019    Initial Create
    [Arguments]    ${ExcelPath}
    ###Log In to LIQ###
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ##Search Deal###
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ###Data Generation###
    ${Facility_Name}    Generate Name Test Data    &{ExcelPath}[Facility_NamePrefix]
    Write Data To Excel    ComSee_SC1_Deal    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC1_FacSetup    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC1_FacFeeSetup    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}
    
    ###New Facility Screen###
    New Facility Select    &{ExcelPath}[Deal_Name]    ${FacilityName}    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Facility_ProposedCmtAmt]    &{ExcelPath}[Facility_Currency]
    
    ###Facility Notebook - Summary Tab###
    ${Facility_AgreementDate}    Get System Date
    ${Facility_EffectiveDate}    Get System Date
    
    ${Facility_ExpiryDate}    Add Days to Date    ${Facility_EffectiveDate}    365
    ${Facility_MaturityDate}    Add Days to Date    ${Facility_EffectiveDate}    395
    
    Write Data To Excel    ComSee_SC1_Deal    Primary_PortfolioExpiryDate    ${rowid}     ${Facility_ExpiryDate}    ${ComSeeDataSet}
    
    Enter Dates on Facility Summary    ${Facility_AgreementDate}    ${Facility_EffectiveDate}    ${Facility_ExpiryDate}    ${Facility_MaturityDate}
    Verify Main SG Details    &{ExcelPath}[Facility_ServicingGroup]    &{ExcelPath}[Facility_Customer]    &{ExcelPath}[Facility_SGLocation]
    ${FacilityControlNumber}    Get Facility Control Number
    ${MulitCCYStatus}    Get Facility Multi CCY Status
    Write Data To Excel    ComSee_SC1_FacSetup    Facility_MultiCCY    ${rowid}    ${MulitCCYStatus}    ${ComSeeDataSet} 
    Write Data To Excel    ComSee_SC1_Deal    COM_ID    ${rowid}    ${FacilityControlNumber}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC1_FacSetup    Facility_ControlNumber    ${rowid}    ${FacilityControlNumber}    ${ComSeeDataSet}   
    
    ###Facility Notebook - Codes Tab###
    ${FundingDeskDesc}    Get Facility Funding Desk Description
    Write Data To Excel    ComSee_SC1_FacSetup    Facility_FundingDeskDescription    ${rowid}    ${FundingDeskDesc}    ${ComSeeDataSet}
    
    ###Facility Notebook - Types/Purpose Tab###
    Add Risk Type    &{ExcelPath}[Facility_RiskType]    &{ExcelPath}[Facility_RiskTypeLimit]   &{ExcelPath}[Facility_Currency]
    Add Loan Purpose Type    &{ExcelPath}[Facility_LoanPurposeType]
    
    ##Facility Notebook - Restrictions Tab###
    Add Currency Limit    &{ExcelPath}[Facility_Currency]    &{ExcelPath}[Facility_GlobalLimit]   &{ExcelPath}[Facility_CustomerServicingGroup]    &{ExcelPath}[Facility_SGLocation]
    
    ###Facility Notebook - Sublimit/Cust Tab###
    Add Borrower    &{ExcelPath}[Facility_Currency]    &{ExcelPath}[Facility_BorrowerSGName]    &{ExcelPath}[Facility_BorrowerPercent]    &{ExcelPath}[Facility_Borrower]
    ...    &{ExcelPath}[Facility_GlobalLimit]    &{ExcelPath}[Facility_BorrowerMaturity]    ${Facility_EffectiveDate}
    
    ${Facility_EffectiveDate}    Convert LIQ Date to Year-Month-Day Format    ${Facility_EffectiveDate}
    ${Facility_ExpiryDate}    Convert LIQ Date to Year-Month-Day Format    ${Facility_ExpiryDate}
    ${Facility_MaturityDate}    Convert LIQ Date to Year-Month-Day Format    ${Facility_MaturityDate}
    
    Write Data To Excel    ComSee_SC1_FacSetup    Facility_EffectiveDate    ${rowid}    ${Facility_EffectiveDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC1_FacSetup    Facility_ExpiryDate    ${rowid}    ${Facility_ExpiryDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC1_FacSetup    Facility_FinalMaturityDate    ${rowid}    ${Facility_MaturityDate}    ${ComSeeDataSet}
    
Setup Multi-Currency SBLC Facility - ComSee
    [Documentation]    Sets up a multi-currency SBLC Facility.
    ...    @author: rtarayao    20AUG2019    Initial Create
    [Arguments]    ${ExcelPath}
    ###Test Data Name Generation
    ${FacilityName}    Generate Name Test Data    &{ExcelPath}[Facility_NamePrefix]
    Write Data To Excel    ComSee_SC3_FacSetup    Facility_Name    ${rowid}    ${FacilityName}    ${ComSeeDataSet}
	Write Data To Excel    ComSee_SC3_Issuance    Facility_Name    ${rowid}    ${FacilityName}    ${ComSeeDataSet}    
	Write Data To Excel    ComSee_SC3_IssuanceFeePayment    Facility_Name    ${rowid}    ${FacilityName}    ${ComSeeDataSet}
	${FacilityName}    Read Data From Excel    ComSee_SC3_FacSetup    Facility_Name    ${rowid}    ${ComSeeDataSet}
    
    ###Date Generation
    ${Facility_AgreementDate}    Get System Date
    ${Facility_EffectiveDate}    Get System Date
    ${Facility_ExpiryDate}    Add Days to Date    ${Facility_EffectiveDate}    365
    ${Facility_MaturityDate}    Add Days to Date    ${Facility_EffectiveDate}    395 
    Write Data To Excel    ComSee_SC3_Deal    Primary_PortfolioExpiryDate    ${rowid}    ${Facility_ExpiryDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC3_Issuance    SBLC_ExpiryDate    ${rowid}    ${Facility_ExpiryDate}    ${ComSeeDataSet}
    
    ###Facility Notebook
    Close All Windows on LIQ
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Add New Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Deal_Currency]
    ...    ${FacilityName}    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Facility_ProposedCmtAmt]    &{ExcelPath}[Facility_Currency]
    Set Facility Dates    ${Facility_AgreementDate}    ${Facility_EffectiveDate}    ${Facility_ExpiryDate}    ${Facility_MaturityDate}     
    Set Facility Risk Type    &{ExcelPath}[Facility_RiskType1]
    Set Facility Loan Purpose Type    &{ExcelPath}[Facility_LoanPurposeType]
    Add Facility Currency    &{ExcelPath}[Facility_CurrencyCode1]
    Add Facility Currency    &{ExcelPath}[Facility_CurrencyCode2]
    Add Facility Borrower - Add All
    Validate Risk Type in Borrower Select    &{ExcelPath}[Facility_RiskType1]
    Validate Currency Limit in Borrower Select    &{ExcelPath}[Facility_Currency1]
    Validate Currency Limit in Borrower Select    &{ExcelPath}[Facility_Currency2]
    Complete Facility Borrower Setup
    Validate Multi CCY Facility
    
    ###Get FCN Number
    ${FacilityControlNumber}    Get Facility Control Number
    Write Data To Excel    ComSee_SC3_Issuance    COM_ID    ${rowid}    ${FacilityControlNumber}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC3_IssuanceFeePayment    COM_ID    ${rowid}    ${FacilityControlNumber}    ${ComSeeDataSet}
    
Setup Facility - Scenario 7 ComSee
    [Documentation]    This keyword is used to create a facility.
    ...    @author: rtarayao    11SEP2019    Initial Create
    [Arguments]    ${ExcelPath}
    ###Log In to LIQ###
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ##Search Deal###
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ###Data Generation###
    ${Facility_Name}    Generate Name Test Data    &{ExcelPath}[Facility_NamePrefix]
    Write Data To Excel    ComSee_SC7_Deal    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_FacFeeSetup    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_Loan    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}
    # Write Data To Excel    ComSee_SC7_Loan    Loan_FacilityName    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_PrincipalLoanPayment    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_LoanInterestPayment    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}
    # Write Data To Excel    ComSee_SC7_LoanInterestPayment    Loan_FacilityName    ${rowid}    ${Facility_Name}    ${ComSeeDataSet} 
    Write Data To Excel    ComSee_SC7_OngoingFeePayment    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}
    
    ###New Facility Screen###
    New Facility Select    &{ExcelPath}[Deal_Name]    ${FacilityName}    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Facility_ProposedCmtAmt]    &{ExcelPath}[Facility_Currency]
    
    ###Facility Notebook - Summary Tab###
    ${Facility_AgreementDate}    Get System Date
    ${Facility_EffectiveDate}    Get System Date
    
    ${Facility_ExpiryDate}    Add Days to Date    ${Facility_EffectiveDate}    365
    ${Facility_MaturityDate}    Add Days to Date    ${Facility_EffectiveDate}    395
    
    Write Data To Excel    ComSee_SC7_Deal    Primary_PortfolioExpiryDate    ${rowid}     ${Facility_ExpiryDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_Loan    Loan_MaturityDate    ${rowid}     ${Facility_MaturityDate}    ${ComSeeDataSet}
    
    Enter Dates on Facility Summary    ${Facility_AgreementDate}    ${Facility_EffectiveDate}    ${Facility_ExpiryDate}    ${Facility_MaturityDate}
    Verify Main SG Details    &{ExcelPath}[Facility_ServicingGroup]    &{ExcelPath}[Facility_Customer]    &{ExcelPath}[Facility_SGLocation]
    ${FacilityControlNumber}    Get Facility Control Number
    ${MulitCCYStatus}    Get Facility Multi CCY Status
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_MultiCCY    ${rowid}    ${MulitCCYStatus}    ${ComSeeDataSet} 
    Write Data To Excel    ComSee_SC7_Deal    COM_ID    ${rowid}    ${FacilityControlNumber}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_ControlNumber    ${rowid}    ${FacilityControlNumber}    ${ComSeeDataSet}  
    Write Data To Excel    ComSee_SC7_FacFeeSetup    COM_ID    ${rowid}    ${FacilityControlNumber}    ${ComSeeDataSet} 
    
    # ###Facility Notebook - Codes Tab###
    ${FundingDeskDesc}    Get Facility Funding Desk Description
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_FundingDeskDescription    ${rowid}    ${FundingDeskDesc}    ${ComSeeDataSet}
        
    
    # ###Facility Notebook - Types/Purpose Tab###
    Add Risk Type    &{ExcelPath}[Facility_RiskType]    &{ExcelPath}[Facility_RiskTypeLimit]   &{ExcelPath}[Facility_Currency]
    Add Loan Purpose Type    &{ExcelPath}[Facility_LoanPurposeType]
    
    ##Facility Notebook - Restrictions Tab###
    Add Currency Limit    &{ExcelPath}[Facility_Currency]    &{ExcelPath}[Facility_GlobalLimit]   &{ExcelPath}[Facility_CustomerServicingGroup]    &{ExcelPath}[Facility_SGLocation]
    
    ###Facility Notebook - Sublimit/Cust Tab###
    Add Borrower    &{ExcelPath}[Facility_Currency]    &{ExcelPath}[Facility_BorrowerSGName]    &{ExcelPath}[Facility_BorrowerPercent]    &{ExcelPath}[Facility_Borrower]
    ...    &{ExcelPath}[Facility_GlobalLimit]    &{ExcelPath}[Facility_BorrowerMaturity]    ${Facility_EffectiveDate}
    
    ${Facility_EffectiveDate}    Convert LIQ Date to Year-Month-Day Format    ${Facility_EffectiveDate}
    ${Facility_ExpiryDate}    Convert LIQ Date to Year-Month-Day Format    ${Facility_ExpiryDate}
    ${Facility_MaturityDate}    Convert LIQ Date to Year-Month-Day Format    ${Facility_MaturityDate}
    
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_EffectiveDate    ${rowid}    ${Facility_EffectiveDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_ExpiryDate    ${rowid}    ${Facility_ExpiryDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_FinalMaturityDate    ${rowid}    ${Facility_MaturityDate}    ${ComSeeDataSet}