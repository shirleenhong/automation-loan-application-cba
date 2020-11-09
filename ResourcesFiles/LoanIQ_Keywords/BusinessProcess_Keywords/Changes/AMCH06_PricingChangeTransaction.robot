*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
   
Create Pricing Change Transaction
    [Documentation]    The keyword will Create Pricing Change Transaction.
    ...    @author: 
    ...    @update: amansuet    26MAY2020    - updated keywords and reused existing keyword
    [Arguments]    ${ExcelPath}

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
     
Create Interest Pricing Change via Facility Notebook
    [Documentation]    Create Interest Pricing Change Transaction via Facility Notebook.
    ...    @author: mgaling
    ...    @update: clanding    11AUG2020    - removed Mx keywords, added Clearing of Interest Pricing current values before adding to matrix
    ...    @update: fluberio    09NOV2020    - added condition to add 2 more pricing options if the Scenario is 4 and Entity is in EU
    [Arguments]    ${ExcelPath}
    
    ${TransactionNo}    Auto Generate Only 4 Numeric Test Data    &{ExcelPath}[TransactionNo_Prefix]
    ${CurrentDate}    Get System Date
    Write Data To Excel    AMCH06_PricingChangeTransaction    PricingChange_TransactionNo    ${rowid}    ${TransactionNo}
    Write Data To Excel    AMCH06_PricingChangeTransaction    PricingChange_EffectiveDate    ${rowid}    ${CurrentDate}
       
    ###Launch Pricing Change Transasction Notebook###  
    Search Existing Deal    &{ExcelPath}[Deal_Name]
    Open Facility Notebook  &{ExcelPath}[Facility_Name]
    Navigate to Pricing Change Transaction Menu        
    
    ####Pricing Change Transaction Notebook- General Tab###
    Populate Pricing Change Notebook General Tab    ${TransactionNo}    ${CurrentDate}    &{ExcelPath}[PricingChange_Desc]    
    
    ###Pricing Change Transaction Notebook- Pricing Tab###
    Navigate to Pricing Tab - Modify Interest Pricing        
    
    ###First Item
    Clear Interest Pricing Current Values
    Add Matrix Item    &{ExcelPath}[PCT_InterestPricing_MatrixItem]    &{ExcelPath}[PCT_InterestPricing_FRType]    &{ExcelPath}[PCT_FinancialRatioType]    &{ExcelPath}[MinimumValue_1]    &{ExcelPath}[MaximumValue_1]
    Add After Option Item - First    &{ExcelPath}[PCT_InterestPricing_OptionItem]    &{ExcelPath}[OptionName1]    &{ExcelPath}[OptionName1]    &{ExcelPath}[RateBasisInterestPricing]    &{ExcelPath}[Spread1]
	Add After Option Item - Second    &{ExcelPath}[OptionName2]    &{ExcelPath}[RateBasisInterestPricing]    &{ExcelPath}[Spread1]
	Run Keyword If   '${SCENARIO}'=='4' and '&{ExcelPath}[Entity]' == 'EU'    Run Keywords    Add After Option Item - Third    &{ExcelPath}[OptionName3]    &{ExcelPath}[RateBasisInterestPricing]    &{ExcelPath}[Spread1]
	...    AND    Add After Option Item - Third    &{ExcelPath}[OptionName4]    &{ExcelPath}[RateBasisInterestPricing]    &{ExcelPath}[Spread1]
	###Second Item
	Select Financial Ratio in Interest Pricing List    &{ExcelPath}[PCT_FinancialRatioType]
	Add Matrix Item    &{ExcelPath}[PCT_InterestPricing_MatrixItem]    &{ExcelPath}[PCT_InterestPricing_FRType]    &{ExcelPath}[PCT_FinancialRatioType]    &{ExcelPath}[MinimumValue_2]    &{ExcelPath}[MaximumValue_2]
    Add After Option Item - First    &{ExcelPath}[PCT_InterestPricing_OptionItem]    &{ExcelPath}[OptionName1]    &{ExcelPath}[OptionName1]    &{ExcelPath}[RateBasisInterestPricing]    &{ExcelPath}[Spread2]
	Add After Option Item - Second    &{ExcelPath}[OptionName2]    &{ExcelPath}[RateBasisInterestPricing]    &{ExcelPath}[Spread2]	
	Run Keyword If   '${SCENARIO}'=='4' and '&{ExcelPath}[Entity]' == 'EU'    Run Keywords    Add After Option Item - Third    &{ExcelPath}[OptionName3]    &{ExcelPath}[RateBasisInterestPricing]    &{ExcelPath}[Spread2]
	...    AND    Add After Option Item - Third    &{ExcelPath}[OptionName4]    &{ExcelPath}[RateBasisInterestPricing]    &{ExcelPath}[Spread2]
	###Third Item
	Select Financial Ratio in Interest Pricing List    &{ExcelPath}[PCT_FinancialRatioType]
	Add Matrix Item    &{ExcelPath}[PCT_InterestPricing_MatrixItem]    &{ExcelPath}[PCT_InterestPricing_FRType]    &{ExcelPath}[PCT_FinancialRatioType]    &{ExcelPath}[MinimumValue_3]    &{ExcelPath}[MaximumValue_3]
    Add After Option Item - First    &{ExcelPath}[PCT_InterestPricing_OptionItem]    &{ExcelPath}[OptionName1]    &{ExcelPath}[OptionName1]    &{ExcelPath}[RateBasisInterestPricing]    &{ExcelPath}[Spread3]
	Add After Option Item - Second    &{ExcelPath}[OptionName2]    &{ExcelPath}[RateBasisInterestPricing]    &{ExcelPath}[Spread3]
	Run Keyword If   '${SCENARIO}'=='4' and '&{ExcelPath}[Entity]' == 'EU'    Run Keywords    Add After Option Item - Third    &{ExcelPath}[OptionName3]    &{ExcelPath}[RateBasisInterestPricing]    &{ExcelPath}[Spread3]
	...    AND    Add After Option Item - Third    &{ExcelPath}[OptionName4]    &{ExcelPath}[RateBasisInterestPricing]    &{ExcelPath}[Spread3]
	###Fourth Item
	Select Financial Ratio in Interest Pricing List    &{ExcelPath}[PCT_FinancialRatioType]
	Run Keyword If   '${SCENARIO}'=='4' and '&{ExcelPath}[Entity]' == 'EU'    Run Keywords    Interest Pricing Window Press Up Key Until Add Button is Enabled
	Add Matrix Item - Mnemonic    &{ExcelPath}[PCT_InterestPricing_MatrixItem]    &{ExcelPath}[PCT_InterestPricing_FRType]    &{ExcelPath}[PCT_FinancialRatioType]    &{ExcelPath}[MaximumValue_3]    &{ExcelPath}[Mnemonic_Value]    
	Add After Option Item - First    &{ExcelPath}[PCT_InterestPricing_OptionItem]    &{ExcelPath}[OptionName1]    &{ExcelPath}[OptionName1]    &{ExcelPath}[RateBasisInterestPricing]    &{ExcelPath}[Spread4]
	Add After Option Item - Second    &{ExcelPath}[OptionName2]    &{ExcelPath}[RateBasisInterestPricing]    &{ExcelPath}[Spread4]
	Run Keyword If   '${SCENARIO}'=='4' and '&{ExcelPath}[Entity]' == 'EU'    Run Keywords    Add After Option Item - Third    &{ExcelPath}[OptionName3]    &{ExcelPath}[RateBasisInterestPricing]    &{ExcelPath}[Spread4]
	...    AND    Add After Option Item - Third    &{ExcelPath}[OptionName4]    &{ExcelPath}[RateBasisInterestPricing]    &{ExcelPath}[Spread4]
	
	Validate the Interest Pricing Values with Matrix Item
	        
	###Pricing Change Transaction Notebook- Workflow Tab###
    Pricing Change Transaction Send to Approval
	
	###Pricing Change Transaction Notebook- Workflow Tab###
	Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
	Pricing Change Transaction Approval   &{ExcelPath}[WIPTransaction_Type]    &{ExcelPath}[Transaction_Status_AwaitingApproval]    &{ExcelPath}[FacilityTransaction_Type]    &{ExcelPath}[Deal_Name]
	
	###Pricing Change Transaction Notebook- Workflow Tab###
	Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD} 
	Pricing Change Transaction Release    &{ExcelPath}[WIPTransaction_Type]    &{ExcelPath}[Transaction_Status_AwaitingRelease]    &{ExcelPath}[FacilityTransaction_Type]    &{ExcelPath}[Deal_Name] 
    
    Close All Windows on LIQ

Facility Interest Pricing Change for Comprehensive Deal
    [Documentation]    Create Interest Pricing Change Transaction via Facility Notebook.
    ...    @author: mnanquilada
    ...    @update: dahijara    22SEP2020    - removed Mx keywords
    ...                                      - updated selection of Financial Ratio in Interest Pricing List
    ...                                      - added Clearing of Interest Pricing current values before adding to matrix
    ...                                      - removed duplicated getting of current date.
    ...                                      - Updated navigation for Pricing Change Transaction
    [Arguments]    ${ExcelPath}

    ${TransactionNo}    Auto Generate Only 4 Numeric Test Data    &{ExcelPath}[TransactionNo_Prefix]
    ${CurrentDate}    Get System Date
    Write Data To Excel    AMCH06_PricingChangeTransaction    PricingChange_TransactionNo    ${rowid}    ${TransactionNo}
    Write Data To Excel    AMCH06_PricingChangeTransaction    PricingChange_EffectiveDate    ${rowid}    ${CurrentDate}
    
    ### Launch Pricing Change Transasction Notebook ###  
    Search Existing Deal    &{ExcelPath}[Deal_Name]
    Open Facility Notebook  &{ExcelPath}[Facility_Name]
    Navigate to Pricing Change Transaction Menu
    
    #### Pricing Change Transaction Notebook- General Tab ###
    Populate Pricing Change Notebook General Tab    ${TransactionNo}    ${CurrentDate}    &{ExcelPath}[PricingChange_Desc]    
    
    ### Pricing Change Transaction Notebook- Pricing Tab ###
    Navigate to Pricing Tab - Modify Interest Pricing        

    ### First Item ###
    Clear Interest Pricing Current Values
    Add Matrix Item    &{ExcelPath}[PCT_InterestPricing_MatrixItem]    &{ExcelPath}[PCT_InterestPricing_FRType]    &{ExcelPath}[PCT_FinancialRatioType]    &{ExcelPath}[MinimumValue_1]    &{ExcelPath}[MaximumValue_1]
    Add After Option Item - First    &{ExcelPath}[PCT_InterestPricing_OptionItem]    &{ExcelPath}[OptionName1]    &{ExcelPath}[OptionName1]    &{ExcelPath}[RateBasisInterestPricing]    &{ExcelPath}[Spread1]
	Add After Option Item - Second    &{ExcelPath}[OptionName2]    &{ExcelPath}[RateBasisInterestPricing]    &{ExcelPath}[Spread1]
	Add After Option Item - Third    &{ExcelPath}[OptionName3]    &{ExcelPath}[RateBasisInterestPricing]    &{ExcelPath}[Spread1]		

	### Second Item ###
    Select Financial Ratio in Interest Pricing List    &{ExcelPath}[PCT_FinancialRatioType]
	Add Matrix Item    &{ExcelPath}[PCT_InterestPricing_MatrixItem]    &{ExcelPath}[PCT_InterestPricing_FRType]    &{ExcelPath}[PCT_FinancialRatioType]    &{ExcelPath}[MinimumValue_2]    &{ExcelPath}[MaximumValue_2]
    Add After Option Item - First    &{ExcelPath}[PCT_InterestPricing_OptionItem]    &{ExcelPath}[OptionName1]    &{ExcelPath}[OptionName1]    &{ExcelPath}[RateBasisInterestPricing]    &{ExcelPath}[Spread2]
	Add After Option Item - Second    &{ExcelPath}[OptionName2]    &{ExcelPath}[RateBasisInterestPricing]    &{ExcelPath}[Spread2]
	Add After Option Item - Third    &{ExcelPath}[OptionName3]    &{ExcelPath}[RateBasisInterestPricing]    &{ExcelPath}[Spread2]		
	### Third Item ###
    Select Financial Ratio in Interest Pricing List    &{ExcelPath}[PCT_FinancialRatioType]
	Add Matrix Item    &{ExcelPath}[PCT_InterestPricing_MatrixItem]    &{ExcelPath}[PCT_InterestPricing_FRType]    &{ExcelPath}[PCT_FinancialRatioType]    &{ExcelPath}[MinimumValue_3]    &{ExcelPath}[MaximumValue_3]
    Add After Option Item - First    &{ExcelPath}[PCT_InterestPricing_OptionItem]    &{ExcelPath}[OptionName1]    &{ExcelPath}[OptionName1]    &{ExcelPath}[RateBasisInterestPricing]    &{ExcelPath}[Spread3]
	Add After Option Item - Second    &{ExcelPath}[OptionName2]    &{ExcelPath}[RateBasisInterestPricing]    &{ExcelPath}[Spread3]
	Add After Option Item - Third    &{ExcelPath}[OptionName3]    &{ExcelPath}[RateBasisInterestPricing]    &{ExcelPath}[Spread3]		
	### Fourth Item ###
    Select Financial Ratio in Interest Pricing List    &{ExcelPath}[PCT_FinancialRatioType]
	Add Matrix Item - Mnemonic    &{ExcelPath}[PCT_InterestPricing_MatrixItem]    &{ExcelPath}[PCT_InterestPricing_FRType]    &{ExcelPath}[PCT_FinancialRatioType]    &{ExcelPath}[MaximumValue_3]    &{ExcelPath}[Mnemonic_Value]    
	Add After Option Item - First    &{ExcelPath}[PCT_InterestPricing_OptionItem]    &{ExcelPath}[OptionName1]    &{ExcelPath}[OptionName1]    &{ExcelPath}[RateBasisInterestPricing]    &{ExcelPath}[Spread4]
	Add After Option Item - Second    &{ExcelPath}[OptionName2]    &{ExcelPath}[RateBasisInterestPricing]    &{ExcelPath}[Spread4]
	Add After Option Item - Third    &{ExcelPath}[OptionName3]    &{ExcelPath}[RateBasisInterestPricing]    &{ExcelPath}[Spread4]		
	
	Validate the Interest Pricing Values with Matrix Item
	
	### Pricing Change Transaction Notebook- Workflow Tab ###
    Pricing Change Transaction Send to Approval
	
	### Pricing Change Transaction Notebook- Workflow Tab ###
	Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
	Pricing Change Transaction Approval   &{ExcelPath}[WIPTransaction_Type]    &{ExcelPath}[Transaction_Status_AwaitingApproval]    &{ExcelPath}[FacilityTransaction_Type]    &{ExcelPath}[Deal_Name]
	
	### Pricing Change Transaction Notebook- Workflow Tab ###
	Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD} 
	Pricing Change Transaction Release    &{ExcelPath}[WIPTransaction_Type]    &{ExcelPath}[Transaction_Status_AwaitingRelease]    &{ExcelPath}[FacilityTransaction_Type]    &{ExcelPath}[Deal_Name] 

    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
