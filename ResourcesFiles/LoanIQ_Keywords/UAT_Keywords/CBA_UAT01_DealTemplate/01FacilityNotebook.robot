*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot
    
*** Keywords ***
Setup Facility Template D00000454
    [Documentation]    High Level Keyword for Facility Template Creation
    ...    author: ritragel
    ...    @update: fmamaril    12SEP2019    Update writing of facility name
    [Arguments]    ${ExcelPath}
    
    ###Name Generation###
	${FacilityName}    Auto Generate Name Test Data    &{ExcelPath}[Facility_NamePrefix]
	Write Data To Excel    CRED02_FacilitySetup    Facility_Name    &{ExcelPath}[rowid]    ${FacilityName}    ${CBAUAT_ExcelPath}
	Write Data To Excel    CRED08_FacilityFeeSetup    Facility_Name    &{ExcelPath}[rowid]   ${FacilityName}    ${CBAUAT_ExcelPath}
	Write Data To Excel    SERV01_LoanDrawdown    Facility_Name    &{ExcelPath}[rowid]   ${FacilityName}    ${CBAUAT_ExcelPath}
    Write Data To Excel    SERV29_CommitmentFeePayment    Facility_Name    &{ExcelPath}[rowid]    ${FacilityName}    ${CBAUAT_ExcelPath}	
    Run Keyword If    &{ExcelPath}[rowid] == 1    Run Keywords    Write Data To Excel    CRED01_Primaries    Facility_Name1    &{ExcelPath}[rowid]    ${FacilityName}
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Facility_Name    3   ${FacilityName}    ${CBAUAT_ExcelPath}    
    ...    AND    Write Data To Excel    UAT01_Runbook    Facility_Name    1   ${FacilityName}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    SERV23_Paperclip    Facility_Name    1   ${FacilityName}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    UAT01_Runbook    Facility_Name    2   ${FacilityName}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    SERV40_BreakFunding    Facility_Name    1   ${FacilityName}    ${CBAUAT_ExcelPath
    Run Keyword If    &{ExcelPath}[rowid] == 2    Run Keywords    Write Data To Excel    CRED01_Primaries    Facility_Name2    &{ExcelPath}[rowid]    ${FacilityName}    
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Facility_Name    4   ${FacilityName}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    UAT01_Runbook    Facility_Name    3   ${FacilityName}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    SERV23_Paperclip    Facility_Name    2   ${FacilityName}    ${CBAUAT_ExcelPath}
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Remittance_Description]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender2_ShortName]    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Remittance_Description]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]  
    Verify if Status is set to Do It    &{ExcelPath}[Lender1_ShortName]
    Verify if Status is set to Do It    &{ExcelPath}[Lender2_ShortName]    ${FacilityName}
    ${FacilityName}    Read Data From Excel    CRED02_FacilitySetup    Facility_Name   &{ExcelPath}[rowid]    ${CBAUAT_ExcelPath} 
    
    ###Facility Creation###
    Add New Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Deal_Currency]    ${FacilityName}
    ...    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Facility_ProposedCmtAmt]    &{ExcelPath}[Facility_Currency]
    Verify Main SG Details    &{ExcelPath}[Facility_ServicingGroup]    &{ExcelPath}[Facility_Customer]    &{ExcelPath}[Facility_SGLocation]
    
    ###Set Facility Dates###   		     
    Set Facility Dates    &{ExcelPath}[Facility_AgreementDate]    &{ExcelPath}[Facility_EffectiveDate]    &{ExcelPath}[Facility_ExpiryDate]    &{ExcelPath}[Facility_MaturityDate]     
    
    ###Enter Multiple Risk Types###
    Set Facility Risk Type    &{ExcelPath}[Facility_RiskType1]  
    ###Enter Loan Purpose Type###
    Set Facility Loan Purpose Type    &{ExcelPath}[Facility_LoanPurposeType1]

    ### Add Facility Currency
    Run Keyword If    &{ExcelPath}[rowid] == 1    Add Facility Currency    &{ExcelPath}[CurrencyLimit1]
    Run Keyword If    &{ExcelPath}[rowid] == 2    Add Facility Currency    &{ExcelPath}[CurrencyLimit1]
        
    ### Add Facility Borrower
    Run Keyword If    &{ExcelPath}[rowid] == 1    Add Borrower    &{ExcelPath}[Borrower_Currency1]    &{ExcelPath}[Facility_BorrowerSGName1]    &{ExcelPath}[Facility_BorrowerPercent1]    &{ExcelPath}[Facility_Borrower1]
    ...    &{ExcelPath}[Facility_GlobalLimit1]    &{ExcelPath}[Facility_BorrowerMaturity1]    &{ExcelPath}[Facility_EffectiveDate]    
    Run Keyword If    &{ExcelPath}[rowid] == 2    Add Borrower    &{ExcelPath}[Borrower_Currency1]    &{ExcelPath}[Facility_BorrowerSGName1]    &{ExcelPath}[Facility_BorrowerPercent1]    &{ExcelPath}[Facility_Borrower1]
    ...    &{ExcelPath}[Facility_GlobalLimit1]    &{ExcelPath}[Facility_BorrowerMaturity1]    &{ExcelPath}[Facility_EffectiveDate]
    Validate Multi CCY Facility

Setup Facility Fees D00000454
    [Documentation]    This keyword setsup facility fees with matrix.
    ...    @author: fmamaril    27AUG2019    Initial Create
    [Arguments]    ${ExcelPath}

    ###Facility Notebook - Pricing Tab###  
    Set Facility Pricing Penalty Spread    &{ExcelPath}[Penalty_Spread]    &{ExcelPath}[Penalty_Status]
    
    ###Facility Notebook - Pricing Rules Tab###
    Validate Facility
    mx LoanIQ close window    ${LIQ_FacilityNavigator_Window}       

Setup Ongoing Fees for Facility D00000454
    [Documentation]    This keyword set ups the Ongoing Fees and Interest Pricing for a Syndicated Deal with no Lenders.
    ...    @author: fmamaril
    [Arguments]    ${ExcelPath}
    Add Facility Ongoing Fees with Matrix    &{ExcelPath}[OngoingFee_Category]    &{ExcelPath}[OngoingFee_Type]    &{ExcelPath}[OngoingFee_RateBasis]
    ...    &{ExcelPath}[OngoingFee_AfterItem]    &{ExcelPath}[OngoingFee_AfterItemType]
    ...    &{ExcelPath}[FormulaCategory_Type]    &{ExcelPath}[OngoingFee_SpreadType]    &{ExcelPath}[OngoingFee_SpreadAmount]
    ...    &{ExcelPath}[Interest_FinancialRatioType]    &{ExcelPath}[Mnemonic_Status]    &{ExcelPath}[Greater_Than]    &{ExcelPath}[Less_Than]
    ...    &{ExcelPath}[FinancialRatio_Minimum]    &{ExcelPath}[FinancialRatio_Maximum]    &{ExcelPath}[SetFeeSelectionDetails]

Add Interest Pricing Matrix Facility D00000454
    [Documentation]    This keyword set ups the Ongoing Fees and Interest Pricing for a Syndicated Deal with no Lenders.
    ...    @author: fmamaril    26AUG2019    Initial Create
    [Arguments]    ${ExcelPath}    
    ### Interest Pricing
    Add Interest Pricing Financial Ratio
    Set Financial Ratio    &{ExcelPath}[Interest_FinancialRatioType]    &{ExcelPath}[Mnemonic_Status]    &{ExcelPath}[Greater_Than]    &{ExcelPath}[Less_Than]    &{ExcelPath}[FinancialRatio_Minimum]    &{ExcelPath}[FinancialRatio_Maximum]
    Add Facility Interest    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName]    &{ExcelPath}[Interest_RateBasis]
    ...    &{ExcelPath}[Interest_SpreadType]    &{ExcelPath}[Interest_SpreadValue]    &{ExcelPath}[Interest_BaseRateCode]

Setup Facility Template D00000454-1
    [Documentation]    High Level Keyword for Facility Template Creation
    ...    @author: fmamaril    26AUG2019    Initial Create
    [Arguments]    ${ExcelPath}
    
    ###Name Generation###
	${FacilityName}    Generate Facility Name    &{ExcelPath}[Facility_NamePrefix]
	Write Data To Excel    CRED02_FacilitySetup    Facility_Name    &{ExcelPath}[rowid]    ${FacilityName}    ${CBAUAT_ExcelPath}
	Write Data To Excel    CRED01_DealSetup    Facility_Name    ${rowid}    ${Facility_Name}    ${CBAUAT_ExcelPath}    
    Run Keyword If    &{ExcelPath}[rowid] == 1    Run Keywords    Write Data To Excel    CRED01_Primaries    Facility_Name1    ${rowid}    ${FacilityName}    ${CBAUAT_ExcelPath}    Y
    ...    AND    Write Data To Excel    SERV29_CommitmentFeePayment    Facility_Name    1    ${FacilityName}    ${CBAUAT_ExcelPath}    
    ...    AND    Write Data To Excel    SERV29_CommitmentFeePayment    Facility_Name    3    ${FacilityName}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    SERV29_CommitmentFeePayment    Facility_Name    5    ${FacilityName}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Facility_Name    1    ${FacilityName}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Facility_Name    2    ${FacilityName}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    SERV23_Paperclip    Facility_Name    1    ${FacilityName}    ${CBAUAT_ExcelPath} 
    ...    AND    Write Data To Excel    SERV08C_ComprehensiveRepricing    Facility_Name    1    ${FacilityName}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    SERV08C_ComprehensiveRepricing    Facility_Name    2    ${FacilityName}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    SERV40_BreakFunding    Facility_Name    1    ${FacilityName}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    COMPR06_LoanMerge    Facility_Name    1    ${FacilityName}    ${CBAUAT_ExcelPath}
    Run Keyword If    &{ExcelPath}[rowid] == 2    Run Keywords    Write Data To Excel    CRED01_Primaries    Facility_Name2    ${rowid}    ${FacilityName}    ${CBAUAT_ExcelPath}    Y
    ...    AND    Write Data To Excel    SERV29_CommitmentFeePayment    Facility_Name    2    ${FacilityName}    ${CBAUAT_ExcelPath}    
    ...    AND    Write Data To Excel    SERV29_CommitmentFeePayment    Facility_Name    4    ${FacilityName}    ${CBAUAT_ExcelPath} 	
    ...    AND    Write Data To Excel    SERV29_CommitmentFeePayment    Facility_Name    6    ${FacilityName}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Facility_Name    3    ${FacilityName}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Facility_Name    4    ${FacilityName}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    SERV08C_ComprehensiveRepricing    Facility_Name    3    ${FacilityName}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    SERV08C_ComprehensiveRepricing    Facility_Name    4    ${FacilityName}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    SERV23_Paperclip    Facility_Name    2    ${FacilityName}    ${CBAUAT_ExcelPath}
	Write Data To Excel    CRED08_FacilityFeeSetup    Facility_Name    &{ExcelPath}[rowid]   ${FacilityName}    ${CBAUAT_ExcelPath}
    ${FacilityName}    Read Data From Excel    CRED02_FacilitySetup    Facility_Name   &{ExcelPath}[rowid]    ${CBAUAT_ExcelPath} 
    
    ###Facility Creation###
    Add New Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Deal_Currency]    ${FacilityName}
    ...    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Facility_ProposedCmtAmt]    &{ExcelPath}[Facility_Currency]
    Verify Main SG Details    &{ExcelPath}[Facility_ServicingGroup]    &{ExcelPath}[Facility_Customer]    &{ExcelPath}[Facility_SGLocation]
    
    ###Set Facility Dates###   		     
    Set Facility Dates    &{ExcelPath}[Facility_AgreementDate]    &{ExcelPath}[Facility_EffectiveDate]    &{ExcelPath}[Facility_ExpiryDate]    &{ExcelPath}[Facility_MaturityDate]     
    
    ###Enter Multiple Risk Types###
    Set Facility Risk Type    &{ExcelPath}[Facility_RiskType1]  
    ###Enter Loan Purpose Type###
    Set Facility Loan Purpose Type    &{ExcelPath}[Facility_LoanPurposeType1]

    ### Add Facility Currency
    Run Keyword If    &{ExcelPath}[rowid] == 1    Add Facility Currency    &{ExcelPath}[CurrencyLimit1]
    Run Keyword If    &{ExcelPath}[rowid] == 2    Add Facility Currency    &{ExcelPath}[CurrencyLimit1]
        
    ### Add Facility Borrower
    Run Keyword If    &{ExcelPath}[rowid] == 1    Add Borrower    &{ExcelPath}[Borrower_Currency1]    &{ExcelPath}[Facility_BorrowerSGName1]    &{ExcelPath}[Facility_BorrowerPercent1]    &{ExcelPath}[Facility_Borrower1]
    ...    &{ExcelPath}[Facility_GlobalLimit1]    &{ExcelPath}[Facility_BorrowerMaturity1]    &{ExcelPath}[Facility_EffectiveDate]    
    Run Keyword If    &{ExcelPath}[rowid] == 2    Add Borrower    &{ExcelPath}[Borrower_Currency1]    &{ExcelPath}[Facility_BorrowerSGName1]    &{ExcelPath}[Facility_BorrowerPercent1]    &{ExcelPath}[Facility_Borrower1]
    ...    &{ExcelPath}[Facility_GlobalLimit1]    &{ExcelPath}[Facility_BorrowerMaturity1]    &{ExcelPath}[Facility_EffectiveDate]
    Validate Multi CCY Facility

Validate Interest Pricing
    [Documentation]    High Level Keyword for Validating Interest Pricing
    ...    @author: fmamaril    26AUG2019    Initial Create
    [Arguments]    ${ExcelPath}    
    Validate Ongoing Fee or Interest 
    Validate Facility Pricing Rule Items    &{ExcelPath}[Interest_FinancialRatioType]
    
Add Multiple Ratio for Facility D00000454
    [Documentation]    This keyword adds multiple ratio for pricing with matrix.
    ...    @author: fmamaril    27AUG2019    Initial Create
    [Arguments]    ${ExcelPath}
    Add Multiple Ratio    &{ExcelPath}[OngoingFee_AfterItem]    &{ExcelPath}[OngoingFee_AfterItemType]    &{ExcelPath}[OngoingFee_RateBasis]    
    ...    &{ExcelPath}[OngoingFee_SpreadType]    &{ExcelPath}[OngoingFee_SpreadAmount]    &{ExcelPath}[Interest_FinancialRatioType]    &{ExcelPath}[Mnemonic_Status]
    ...    &{ExcelPath}[Greater_Than]    &{ExcelPath}[Less_Than]    &{ExcelPath}[FinancialRatio_Minimum]    &{ExcelPath}[FinancialRatio_Maximum]

Setup Additional Ongoing Fee
    [Documentation]    This keyword setsup additional ongoing Fee 
    ...    @author: fmamaril    27AUG2019    Initial Create
    [Arguments]    ${ExcelPath}
    Run keyword and Ignore Error    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFees_OK_Button}
    Modify Ongoing Fee Pricing - Insert Add    &{ExcelPath}[OngoingFee_Category]    &{ExcelPath}[OngoingFee_Type]    &{ExcelPath}[OngoingFee_RateBasis]
    Modify Ongoing Fee Pricing - Insert After   &{ExcelPath}[OngoingFee_AfterItem]    &{ExcelPath}[Facility_PercentWhole]    &{ExcelPath}[OngoingFee_Category]    &{ExcelPath}[Facility_Percent]          
