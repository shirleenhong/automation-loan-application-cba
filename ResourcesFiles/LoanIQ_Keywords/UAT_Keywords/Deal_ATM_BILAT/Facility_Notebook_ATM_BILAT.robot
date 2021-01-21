*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Keywords ***
Create Facility for ATM BILAT
    [Documentation]    This keyword is used to create a Facility for ATM BILAT deal
    ...    @author: ccarriedo    20JAN2021    Initial Create
    [Arguments]    ${ExcelPath}
    
    ### Login to LoanIQ ###
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
	${Facility_Name1}    Read Data From Excel    CRED02_FacilitySetup    Facility_Name1    &{ExcelPath}[rowid]
	${Facility_Name2}    Read Data From Excel    CRED02_FacilitySetup    Facility_Name2    &{ExcelPath}[rowid]
	${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    &{ExcelPath}[rowid]
    Write Data To Excel    CRED01_DealSetup    Facility_Name1    ${rowid}    ${Facility_Name1}
    Write Data To Excel    CRED08_OngoingFeeSetup    Facility_Name1    ${rowid}    ${Facility_Name1}
    Write Data To Excel    SERV15_SchComittmentDecrease    Facility_Name1    ${rowid}    ${Facility_Name1}
    Write Data To Excel    CRED01_DealSetup    Facility_Name2    ${rowid}    ${Facility_Name2}
    Write Data To Excel    CRED08_OngoingFeeSetup    Facility_Name2    ${rowid}    ${Facility_Name2}
    Write Data To Excel    SERV15_SchComittmentDecrease    Facility_Name2    ${rowid}    ${Facility_Name2}
    
    ###Open Deal Notebook If Not present###
    Open Deal Notebook If Not Present    ${Deal_Name}
         
    ###New Facility Screen###
    ${Facility_ProposedCmtAmt}    New Facility Select    &{ExcelPath}[Deal_Name]    ${Facility_Name1}    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Facility_ProposedCmtAmt]    &{ExcelPath}[Facility_Currency]
    
    ###Facility Notebook - Summary Tab###
    Enter Dates on Facility Summary    &{ExcelPath}[Facility_AgreementDate]    &{ExcelPath}[Facility_EffectiveDate]    &{ExcelPath}[Facility_ExpiryDate]    &{ExcelPath}[Facility_MaturityDate]
    Verify Main SG Details    &{ExcelPath}[Facility_ServicingGroup]    &{ExcelPath}[Facility_Customer]    &{ExcelPath}[Facility_SGLocation]
    Write Data To Excel    SERV01_LoanDrawdown   Loan_MaturityDate    ${rowid}     &{ExcelPath}[Facility_MaturityDate]

    ###Facility Notebook - Types/Purpose Tab###
    Add Risk Type    &{ExcelPath}[Facility_RiskType]    &{ExcelPath}[Facility_RiskTypeLimit]   &{ExcelPath}[Facility_Currency]
    Add Loan Purpose Type    &{ExcelPath}[Facility_LoanPurposeType]
   
    ###Facility Notebook - Restrictions Tab###
    Add Currency Limit    &{ExcelPath}[Facility_Currency]    &{ExcelPath}[Facility_GlobalLimit]   &{ExcelPath}[Facility_CustomerServicingGroup]    &{ExcelPath}[Facility_ServicingGroup]
    
    ###Facility Notebook - Sublimit/Cust Tab###
    Add Borrower    &{ExcelPath}[Facility_Currency]    &{ExcelPath}[Facility_BorrowerSGName]    &{ExcelPath}[Facility_BorrowerPercent]    &{ExcelPath}[Facility_Borrower1]
    ...    &{ExcelPath}[Facility_GlobalLimit]    &{ExcelPath}[Facility_BorrowerMaturity]    &{ExcelPath}[Facility_EffectiveDate]

    Setup Interest Pricing for ATM Bilateral Deal    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName]    &{ExcelPath}[Interest_RateBasis]    &{ExcelPath}[Interest_SpreadAmt]

Set Multiple Amortization Schedule for Facility
    [Documentation]    This high-level keyword sets up Amortization Schedule for Facility.
    ...    @author: ccarriedo    19JAN2021    - Initial create
    [Arguments]    ${ExcelPath}

    ${Facility_LimitChangeDecreaseAmount_List}    ${Facility_LimitChangeDecreaseAmount_Count}    Split String with Delimiter and Get Length of the List    &{ExcelPath}[Facility1_LimitChangeDecreaseAmount]    &{ExcelPath}[Delimiter]        
    ${Facility_LimitChangeDecreaseAmtSched_List}    ${Facility_LimitChangeDecreaseAmtSched_Count}    Split String with Delimiter and Get Length of the List    &{ExcelPath}[Facility1_LimitChangeDecreaseAmtSched]    &{ExcelPath}[Delimiter]
    
    ### Set amortization schedule ammounts ###
    Navigate to Amortization Schedule for Facility
    Select Amortization Schedule Status for Facility    &{ExcelPath}[Facility_AmortizationScheduleStatus]
    Delete Current Amortization Schedule for Facility
    Add Multiple Amortization Schedule for Facility    ${Facility_LimitChangeDecreaseAmount_Count}    ${Facility_LimitChangeDecreaseAmount_List}    ${Facility_LimitChangeDecreaseAmtSched_List}
    Save Amortization Schedule for Facility
        
    ###Facility Validation and close###
    Validate Facility
