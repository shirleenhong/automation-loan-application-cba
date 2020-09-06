*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot
    
*** Keywords ***
Setup Facility Template D00000476
    [Documentation]    High Level Keyword for Facility Template Creation
    ...    author: ritragel
    [Arguments]    ${ExcelPath}
    
    ###Name Generation###
	${FacilityName}    Auto Generate Name Test Data    &{ExcelPath}[Facility_NamePrefix]
	Write Data To Excel    CRED02_FacilitySetup    Facility_Name    &{ExcelPath}[rowid]    ${FacilityName}    ${CBAUAT_ExcelPath}
	Write Data To Excel    CRED08_FacilityFeeSetup    Facility_Name    &{ExcelPath}[rowid]   ${FacilityName}    ${CBAUAT_ExcelPath}
    Write Data To Excel    CRED01_Primaries    Facility_Name&{ExcelPath}[rowid]    ${rowid}    ${FacilityName}    ${CBAUAT_ExcelPath}
    Write Data To Excel    CRED08_OngoingFeeSetup    Facility_Name    &{ExcelPath}[rowid]   ${FacilityName}    ${CBAUAT_ExcelPath}
    Write Data To Excel    SERV29_CommitmentFeePayment    Facility_Name    &{ExcelPath}[rowid]   ${FacilityName}    ${CBAUAT_ExcelPath}
    Write Data To Excel    SERV01A_LoanDrawdown    Facility_Name    &{ExcelPath}[rowid]    ${FacilityName}    ${CBAUAT_ExcelPath}
    Write Data To Excel    AMCH05_ExtendFacility    Facility_Name    &{ExcelPath}[rowid]    ${FacilityName}    ${CBAUAT_ExcelPath}
    Write Data To Excel    CRED01_UpfrontFee    Facility_Name    &{ExcelPath}[rowid]    ${FacilityName}    ${CBAUAT_ExcelPath}
    Run Keyword If    '&{ExcelPath}[rowid]' == '4'    Write Data To Excel    SERV01A_LoanDrawdown    Facility_Name    4    ${FacilityName}    ${CBAUAT_ExcelPath}
    Run Keyword If    '&{ExcelPath}[rowid]' == '4'    Write Data To Excel    SERV23_Paperclip    Facility_Name    1    ${FacilityName}    ${CBAUAT_ExcelPath}
    Run Keyword If    '&{ExcelPath}[rowid]' == '4'    Write Data To Excel    SERV23_Paperclip    Facility_Name    3    ${FacilityName}    ${CBAUAT_ExcelPath}
    Run Keyword If    '&{ExcelPath}[rowid]' == '3'    Write Data To Excel    SERV23_Paperclip    Facility_Name    2    ${FacilityName}    ${CBAUAT_ExcelPath}
    Run Keyword If    '&{ExcelPath}[rowid]' == '3'    Write Data To Excel    SERV40_BreakFunding    Facility_Name    2    ${FacilityName}    ${CBAUAT_ExcelPath}    
    Run Keyword If    '&{ExcelPath}[rowid]' == '4'    Write Data To Excel    SERV01A_LoanDrawdown    Facility_Name    5    ${FacilityName}    ${CBAUAT_ExcelPath}
    Run Keyword If    '&{ExcelPath}[rowid]' == '4'    Write Data To Excel    SERV01A_LoanDrawdown    Facility_Name    6    ${FacilityName}    ${CBAUAT_ExcelPath}
    Run Keyword If    '&{ExcelPath}[rowid]' == '4'    Write Data To Excel    SERV01A_LoanDrawdown    Facility_Name    7    ${FacilityName}    ${CBAUAT_ExcelPath}
    Run Keyword If    '&{ExcelPath}[rowid]' == '4'    Write Data To Excel    SERV01A_LoanDrawdown    Facility_Name    8    ${FacilityName}    ${CBAUAT_ExcelPath}
    Run Keyword If    '&{ExcelPath}[rowid]' == '4'    Write Data To Excel    SERV01A_LoanDrawdown    Facility_Name    9    ${FacilityName}    ${CBAUAT_ExcelPath}
    Run Keyword If    '&{ExcelPath}[rowid]' == '4'    Write Data To Excel    SERV01A_LoanDrawdown    Facility_Name    1    ${FacilityName}    ${CBAUAT_ExcelPath}
    Run Keyword If    '&{ExcelPath}[rowid]' == '4'    Write Data To Excel    SERV29_Payments    Facility_Name    1    ${FacilityName}    ${CBAUAT_ExcelPath}
    Run Keyword If    '&{ExcelPath}[rowid]' == '1'    Write Data To Excel    SERV05_SBLCIssuance    Facility_Name    1    ${FacilityName}    ${CBAUAT_ExcelPath}
    Run Keyword If    '&{ExcelPath}[rowid]' == '1'    Write Data To Excel    SERV05_SBLCIssuance    Facility_Name    2    ${FacilityName}    ${CBAUAT_ExcelPath}   
    Run Keyword If    '&{ExcelPath}[rowid]' == '1'    Write Data To Excel    SERV18_FeeOnLenderSharesPayment    Facility_Name    1    ${FacilityName}    ${CBAUAT_ExcelPath}
    Run Keyword If    '&{ExcelPath}[rowid]' == '1'    Write Data To Excel    SERV18_FeeOnLenderSharesPayment    Facility_Name    2    ${FacilityName}    ${CBAUAT_ExcelPath}
    Run Keyword If    '&{ExcelPath}[rowid]' == '1'    Write Data To Excel    SERV18_FeeOnLenderSharesPayment    Facility_Name    3    ${FacilityName}    ${CBAUAT_ExcelPath}
    Run Keyword If    '&{ExcelPath}[rowid]' == '4'    Write Data To Excel    COM06_LoanMerge    Facility_Name    1    ${FacilityName}    ${CBAUAT_ExcelPath}
    ${FacilityName}    Read Data From Excel    CRED02_FacilitySetup    Facility_Name   &{ExcelPath}[rowid]    ${CBAUAT_ExcelPath} 
    
    ###Facility Creation###
    Add New Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Deal_Currency]    ${FacilityName}
    ...    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Facility_ProposedCmtAmt]    &{ExcelPath}[Facility_Currency]
    Verify Main SG Details    &{ExcelPath}[Facility_ServicingGroup]    &{ExcelPath}[Facility_Customer]    &{ExcelPath}[Facility_SGLocation]
    
    ###Set Facility Dates###   		     
    Set Facility Dates    &{ExcelPath}[Facility_AgreementDate]    &{ExcelPath}[Facility_EffectiveDate]    &{ExcelPath}[Facility_ExpiryDate]    &{ExcelPath}[Facility_MaturityDate]     
    
    ###Enter Multiple Risk Types###
    Set Facility Risk Type    &{ExcelPath}[Facility_RiskType1]
    Run Keyword If    &{ExcelPath}[rowid] == 1    Set Facility Risk Type    &{ExcelPath}[Facility_RiskType2]    
    ###Enter Loan Purpose Type###
    Set Facility Loan Purpose Type    &{ExcelPath}[Facility_LoanPurposeType1]

    ### Add Facility Currency
    Run Keyword If    &{ExcelPath}[rowid] == 1    Add Facility Currency    &{ExcelPath}[CurrencyLimit1]
    Run Keyword If    &{ExcelPath}[rowid] == 2    Add Facility Currency    &{ExcelPath}[CurrencyLimit1]   
    Run Keyword If    &{ExcelPath}[rowid] == 3    Add Facility Currency    &{ExcelPath}[CurrencyLimit1]
    Run Keyword If    &{ExcelPath}[rowid] == 4    Add Facility Currency    &{ExcelPath}[CurrencyLimit1]  
    Run Keyword If    &{ExcelPath}[rowid] == 4    Add Facility Currency    &{ExcelPath}[CurrencyLimit2]
    Run Keyword If    &{ExcelPath}[rowid] == 4    Add Facility Currency    &{ExcelPath}[CurrencyLimit3]
         
    ### Add Facility Borrower
    Run Keyword If    &{ExcelPath}[rowid] == 1    Add Borrower    &{ExcelPath}[Borrower_Currency1]    &{ExcelPath}[Facility_BorrowerSGName1]    &{ExcelPath}[Facility_BorrowerPercent1]    &{ExcelPath}[Facility_Borrower1]
    ...    &{ExcelPath}[Facility_GlobalLimit1]    &{ExcelPath}[Facility_BorrowerMaturity1]    &{ExcelPath}[Facility_EffectiveDate]    
    Run Keyword If    &{ExcelPath}[rowid] == 2    Add Borrower    &{ExcelPath}[Borrower_Currency1]    &{ExcelPath}[Facility_BorrowerSGName1]    &{ExcelPath}[Facility_BorrowerPercent1]    &{ExcelPath}[Facility_Borrower1]
    ...    &{ExcelPath}[Facility_GlobalLimit1]    &{ExcelPath}[Facility_BorrowerMaturity1]    &{ExcelPath}[Facility_EffectiveDate]             
    Run Keyword If    &{ExcelPath}[rowid] == 3    Add Borrower    &{ExcelPath}[Borrower_Currency1]    &{ExcelPath}[Facility_BorrowerSGName1]    &{ExcelPath}[Facility_BorrowerPercent1]    &{ExcelPath}[Facility_Borrower1]
    ...    &{ExcelPath}[Facility_GlobalLimit1]    &{ExcelPath}[Facility_BorrowerMaturity1]    &{ExcelPath}[Facility_EffectiveDate]     
    Run Keyword If    &{ExcelPath}[rowid] == 4    Add Borrower    &{ExcelPath}[Borrower_Currency1]    &{ExcelPath}[Facility_BorrowerSGName1]    &{ExcelPath}[Facility_BorrowerPercent1]    &{ExcelPath}[Facility_Borrower1]
    ...    &{ExcelPath}[Facility_GlobalLimit1]    &{ExcelPath}[Facility_BorrowerMaturity1]    &{ExcelPath}[Facility_EffectiveDate]        
    
    Run Keyword If    &{ExcelPath}[rowid] == 4    Validate Multi CCY Facility

Setup Facility Fees D00000476
    [Arguments]    ${ExcelPath}

    ###Facility Notebook - Pricing Tab###
    Run Keyword If    &{ExcelPath}[rowid] != 4    Modify Ongoing Fee Pricing - Insert Add    &{ExcelPath}[OngoingFee_Category]    &{ExcelPath}[OngoingFee_Type]    &{ExcelPath}[OngoingFee_RateBasis]
    Run Keyword If    &{ExcelPath}[rowid] != 4    Modify Ongoing Fee Pricing - Insert After   &{ExcelPath}[OngoingFee_AfterItem]    &{ExcelPath}[Facility_PercentWhole]    &{ExcelPath}[OngoingFee_Category]    &{ExcelPath}[Facility_Percent] 
    Run Keyword If    &{ExcelPath}[rowid] == 1    Modify Ongoing Fee Pricing - Insert Add    &{ExcelPath}[OngoingFee2_Category]    &{ExcelPath}[OngoingFee2_Type]    &{ExcelPath}[OngoingFee2_RateBasis]
    Run Keyword If    &{ExcelPath}[rowid] == 1    Modify Ongoing Fee Pricing - Insert After   &{ExcelPath}[OngoingFee2_AfterItem]    &{ExcelPath}[Facility2_PercentWhole]    &{ExcelPath}[OngoingFee2_Category]    &{ExcelPath}[Facility2_Percent] 
    Run Keyword If    &{ExcelPath}[rowid] == 4    Modify Ongoing Fee Pricing - Insert Add    &{ExcelPath}[OngoingFee3_Category]    &{ExcelPath}[OngoingFee3_Type]    &{ExcelPath}[OngoingFee3_RateBasis]
    Run Keyword If    &{ExcelPath}[rowid] == 4    Modify Ongoing Fee Pricing - Insert After   &{ExcelPath}[OngoingFee3_AfterItem]    &{ExcelPath}[Facility3_PercentWhole]    &{ExcelPath}[OngoingFee3_Category]    &{ExcelPath}[Facility3_Percent] 
    
    ### Interest Pricing
    Run Keyword If    &{ExcelPath}[rowid] == 1    Modify Interest Pricing - Insert Add    &{ExcelPath}[Interest_AddItem1]    &{ExcelPath}[Interest_OptionName1]    &{ExcelPath}[Interest_RateBasis1]    &{ExcelPath}[Interest_SpreadValue1]    &{ExcelPath}[Interest_BaseRateCode1]
    Run Keyword If    &{ExcelPath}[rowid] == 2    Modify Interest Pricing - Insert Add    &{ExcelPath}[Interest_AddItem1]    &{ExcelPath}[Interest_OptionName1]    &{ExcelPath}[Interest_RateBasis1]    &{ExcelPath}[Interest_SpreadValue1]    &{ExcelPath}[Interest_BaseRateCode1]
    Run Keyword If    &{ExcelPath}[rowid] == 3    Modify Interest Pricing - Insert Add    &{ExcelPath}[Interest_AddItem1]    &{ExcelPath}[Interest_OptionName1]    &{ExcelPath}[Interest_RateBasis1]    &{ExcelPath}[Interest_SpreadValue1]    &{ExcelPath}[Interest_BaseRateCode1]    
    Run Keyword If    &{ExcelPath}[rowid] == 4    Modify Interest Pricing - Insert Add    &{ExcelPath}[Interest_AddItem1]    &{ExcelPath}[Interest_OptionName1]    &{ExcelPath}[Interest_RateBasis1]    &{ExcelPath}[Interest_SpreadValue1]    &{ExcelPath}[Interest_BaseRateCode1]    
    Run Keyword If    &{ExcelPath}[rowid] == 4    Modify Interest Pricing - Insert Add    &{ExcelPath}[Interest_AddItem2]    &{ExcelPath}[Interest_OptionName2]    &{ExcelPath}[Interest_RateBasis2]    &{ExcelPath}[Interest_SpreadValue2]    &{ExcelPath}[Interest_BaseRateCode2] 
    Run Keyword If    &{ExcelPath}[rowid] == 4    Modify Interest Pricing - Insert Add    &{ExcelPath}[Interest_AddItem3]    &{ExcelPath}[Interest_OptionName3]    &{ExcelPath}[Interest_RateBasis3]    &{ExcelPath}[Interest_SpreadValue3]    &{ExcelPath}[Interest_BaseRateCode3] 
    Run Keyword If    &{ExcelPath}[rowid] == 4    Modify Interest Pricing - Insert Add    &{ExcelPath}[Interest_AddItem4]    &{ExcelPath}[Interest_OptionName4]    &{ExcelPath}[Interest_RateBasis4]    &{ExcelPath}[Interest_SpreadValue4]    &{ExcelPath}[Interest_BaseRateCode4] 
        
    Set Facility Pricing Penalty Spread    &{ExcelPath}[Penalty_Spread]    &{ExcelPath}[Penalty_Status]
    
    ###Facility Notebook - Pricing Rules Tab###
    Validate Facility
    mx LoanIQ close window    ${LIQ_FacilityNavigator_Window}       
    
