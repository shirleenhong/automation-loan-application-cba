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

Setup Interest Pricing for ATM Bilateral Deal
    [Documentation]    This high-level keyword sets up Interest Pricing for ATM Bilateral Deal.
    ...    @author: ccarriedo    20JAN2021    - Initial create
    [Arguments]    ${ExcelPath}
    
    ### GetRuntime Keyword Pre-processing ###
    ${InterestPricingItem}    Acquire Argument Value    &{ExcelPath}[Interest_AddItem]
    ${OptionName}    Acquire Argument Value    &{ExcelPath}[Interest_OptionName]
    ${RateBasisInterestPricing}    Acquire Argument Value    &{ExcelPath}[Interest_RateBasis]
    ${Spread}    Acquire Argument Value    &{ExcelPath}[Interest_SpreadAmt]
    ${InterestPricingCode}    Acquire Argument Value    &{ExcelPath}[Interest_BaseRateCode]

    mx LoanIQ activate window     ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab     ${LIQ_FacilityNotebook_Tab}    Pricing     
    mx LoanIQ click    ${LIQ_FacilityPricing_ModifyInterestPricing_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    mx LoanIQ activate window     ${LIQ_Facility_InterestPricing_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Facility_InterestPricing_Window}        VerificationData="Yes"
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_Add_Button}
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Facility_InterestPricing_AddItem_List}      VerificationData="Yes"
    Run Keyword If    '${status}' == 'True'    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_AddItem_List}    ${InterestPricingItem}
    Run Keyword If    '${status}' == 'True'    mx LoanIQ click    ${LIQ_Facility_InterestPricing_AddItem_OK_Button}
    Mx LoanIQ Select Combo Box Value    ${LIQ_OptionCondition_OptionName_List}    ${OptionName}
    Mx LoanIQ Select Combo Box Value    ${LIQ_OptionCondition_RateBasis_List}    ${RateBasisInterestPricing}
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_OptionCondition_OK_Button}
    mx LoanIQ enter    ${LIQ_Facility_InterestPricing_FormulaCategory_Percent_Radiobutton}    ON
    mx LoanIQ enter    ${LIQ_Facility_InterestPricing_FormulaCategory_Percent_Textfield}    ${Spread} 
    # Run Keyword If    '${PercentOfRateFormulaUsage}' != 'None'    Mx LoanIQ Select Combo Box Value    ${LIQ_FormulaCategory_PercentOfRateFormulaUsage_List}    ${PercentOfRateFormulaUsage}
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_FormulaCategory_OK_Button}
    
    ###Validate Interest Pricing###
    Validate and Confirm Interest Pricing
