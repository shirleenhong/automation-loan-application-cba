*** Settings ***
Resource     ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Add New Facility via Amendment Notebook
    [Documentation]    Add a New Facility via Amendment Notebook.
    ...    @author: mgaling
    ...    @update: clanding    30JUL2020    - updated hard coded values to dataset input; added writing of data and setting to dictionary
    ...										 - added new argument for Add a Schedule Item
    [Arguments]    ${ExcelPath}
        
    ###Close all windows and Login as original user###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
        
    ###Generate dates###
    ${Facility_AgreementDate}    Get System Date
    ${Facility_EffectiveDate}    Get System Date
    ${AmendmentDate}    Get System Date
    ${CurrentSchedDate}    Add Days to Date    ${AmendmentDate}    &{ExcelPath}[Add_To_Amendment_Date]
    ${Facility_ExpiryDate}    Add Days to Date    ${Facility_EffectiveDate}    &{ExcelPath}[Add_To_Facility_Expiry_Date]
    ${Final_Maturity_Date}    Add Days to Date    ${Facility_EffectiveDate}    &{ExcelPath}[Add_To_Final_Maturity_Date]
    
    Write Data To Excel    AMCH11_AddFacility    Facility_AgreementDate    ${rowid}    ${Facility_AgreementDate}
    Write Data To Excel    AMCH11_AddFacility    Facility_EffectiveDate    ${rowid}    ${Facility_EffectiveDate}
    Write Data To Excel    AMCH11_AddFacility    Expiry_Date    ${rowid}    ${Facility_ExpiryDate}
    Write Data To Excel    AMCH11_AddFacility    Final_Maturity_Date    ${rowid}    ${Final_Maturity_Date}
    
    Set To Dictionary    ${ExcelPath}    Facility_AgreementDate=${Facility_AgreementDate}
    Set To Dictionary    ${ExcelPath}    Facility_EffectiveDate=${Facility_EffectiveDate}
    Set To Dictionary    ${ExcelPath}    Expiry_Date=${Facility_ExpiryDate}
    Set To Dictionary    ${ExcelPath}    Final_Maturity_Date=${Final_Maturity_Date}
    
    ###Loan IQ Desktop - Amendment Notebook###  
    Populate Amendment Notebook    &{ExcelPath}[Deal_Name]    ${AmendmentDate}    &{ExcelPath}[AmendmentNumber_Prefix]    &{ExcelPath}[Comment]  
    Validate the Entered Values in Amendment Notebook - General Tab    ${AmendmentDate}    &{ExcelPath}[Comment]         
    
    ${NewFacilityName}    Auto Generate Name Test Data    &{ExcelPath}[FacilityName_Prefix]
    Write Data To Excel    AMCH11_AddFacility    NewFacility_Name    ${rowid}    ${NewFacilityName}
    Write Data To Excel    AMCH02_LenderShareAdjustment    Facility_Name2    ${rowid}    ${NewFacilityName}
    Set To Dictionary    ${ExcelPath}    NewFacility_Name=${NewFacilityName}
    
    ###Facility Select Window###
    Populate Facility Select Window - Amendment Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[NewFacility_Name]    &{Excelpath}[Facility_Type]    &{Excelpath}[Currency]        
    Validate the Entered Values in Facility Select Window - Amendment Notebook    &{ExcelPath}[NewFacility_Name]    &{Excelpath}[Facility_Type]    &{Excelpath}[Currency] 
    
    ###Facility Notebook- Summary Tab###
    Populate the Fields in Facility Notebook - Summary Tab    &{Excelpath}[MSG_Customer]    ${Facility_AgreementDate}    &{ExcelPath}[Expiry_Date]    &{ExcelPath}[Final_Maturity_Date]    
    Validate the Entered Values in Facility Notebook - Summary Tab    &{ExcelPath}[Facility_AgreementDate]    &{ExcelPath}[Expiry_Date]    &{ExcelPath}[Final_Maturity_Date]
     
    ###Facility Notebook- Types/Purpose Tab###      
    Set Facility Risk Type    &{ExcelPath}[RiskType]
    Set Facility Loan Purpose    &{ExcelPath}[LoanPurposeType]
    
    ###Facility Notebook- Restriction Tab###
    Add Currency in Facility Notebook - Restriction Tab    &{ExcelPath}[Currency]    &{Excelpath}[SG_Customer]        
    
    ###Facility Notebook- Sublimit/Cust###
    Add Borrower in Facility Notebook - SublimitCust Tab
     
    ###Facility Notebook- Pricing Tab###
    Modify Ongoing Fee Pricing - Insert Add    &{ExcelPath}[FacilityItem]    &{ExcelPath}[FeeType]    &{ExcelPath}[RateBasisOngoingFeePricing]
    Modify Ongoing Fee - Insert After    &{ExcelPath}[FacilityItemAfter]    &{ExcelPath}[FacilityItemTypeAfter]    &{ExcelPath}[Percent]
    Validate Ongoing Fee Values
    
    Modify Interest Pricing - Insert Add (Options Item)    &{ExcelPath}[InterestPricingItem]    &{ExcelPath}[OptionName1]    &{ExcelPath}[RateBasisInterestPricing]    &{ExcelPath}[Spread1]    &{ExcelPath}[OptionName2]    &{ExcelPath}[Spread2]
    Validate Interest Pricing Values
    
    ###Facility Notebook- Pricing Rules Tab###
    Verify Pricing Rules    &{Excelpath}[Facility_PricingRuleOption]
      
    ###Amendment Notebook- General Tab###
    Add Facility in Amendment Transaction    &{ExcelPath}[NewFacility_Name]    &{ExcelPath}[Transaction_Type]     
    Populate Add Transaction Window    &{ExcelPath}[NewTran_Amount]    &{ExcelPath}[NewTran_PercentofCurrentBal]
    
    ###Amortization Schedule For Facility Window###
    Add a Schedule Item    &{ExcelPath}[NewTran_Amount]    &{ExcelPath}[NewTran_PercentofCurrentBal]    ${CurrentSchedDate}    &{ExcelPath}[Current_Schedule]    &{ExcelPath}[Deal_Name]
    ...    &{ExcelPath}[MSG_Customer]    &{ExcelPath}[Portfolio_Expense]    &{ExcelPath}[PercentOfDeal_HB]    &{ExcelPath}[Portfolio]

    ###Amendment Notebook- Workflow Tab###
    Amendment Send to Approval 
	Logout from Loan IQ
	
	###Logout and Relogin in Manager Level###
	Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    	
	###Amendment Notebook- Workflow Tab###
	Amendment Approval    &{ExcelPath}[WIPTransaction_Type]    &{ExcelPath}[Transaction_Status_AwaitingApproval]    &{ExcelPath}[DealTransaction_Type]    &{ExcelPath}[Deal_Name]
	Logout from Loan IQ
	
	###Amendment Notebook- Workflow Tab###
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD} 
	Amendment Release    &{ExcelPath}[WIPTransaction_Type]    &{ExcelPath}[Transaction_Status_AwaitingRelease]    &{ExcelPath}[DealTransaction_Type]    &{ExcelPath}[Deal_Name] 
    Logout from Loan IQ
    
    ###Verify if Facility is Added###
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Search the Newly Added Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[NewFacility_Name]