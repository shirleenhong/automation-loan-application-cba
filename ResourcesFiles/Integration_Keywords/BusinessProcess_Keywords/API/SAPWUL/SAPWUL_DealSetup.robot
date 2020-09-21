*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Deal Create
    [Documentation]    This keyword is the template for creating a new deal
    ...                @author: hstone    03SEP2019    Initial create
    [Arguments]    ${DealDataSet}
    ### New Deal Name Generation ###
    ${Deal_Name}    ${Deal_Alias}    Generate Deal Name and Alias    &{DealDataSet}[Deal_NamePrefix]    &{DealDataSet}[Deal_AliasPrefix]
    
    ### Save Test Data ###
    Write Data To Excel    DealData    Deal_Name    &{DealDataSet}[rowid]    ${Deal_Name}    ${SAPWUL_DATASET}
    Write Data To Excel    DealData    Deal_Alias    &{DealDataSet}[rowid]    ${Deal_Alias}    ${SAPWUL_DATASET}
    
    ### Fetch Test Data ###
    ${Deal_Name}    Read Data From Excel    DealData    Deal_Name   &{DealDataSet}[rowid]    ${SAPWUL_DATASET}
    ${Deal_Alias}    Read Data From Excel    DealData    Deal_Alias   &{DealDataSet}[rowid]    ${SAPWUL_DATASET}
    
    ### New Deal Create ###
    Select Actions    [Actions];Deal
    Create New Deal    ${Deal_Name}    ${Deal_Alias}    &{DealDataSet}[Deal_Currency]    &{DealDataSet}[Deal_Department]    &{DealDataSet}[Deal_SalesGroup]
    Unrestrict Deal

    ### Summary Tab ###
    ### Borrower 1 
    Set Deal Borrower    &{DealDataSet}[Borrower_ShortName1]    &{DealDataSet}[Borrower_Location1]
    Set Deal Borrower Servicing Group    &{DealDataSet}[Borrower_SG_Alias1]    &{DealDataSet}[Borrower_SG_Name1]    &{DealDataSet}[Borrower_ContactName1]    &{DealDataSet}[Borrower_PreferredRIMthd1]
    Go To Deal Borrower Preferred RI Window
    Mark All Preferred Remittance Instruction
    Complete Deal Borrower Setup
    ### Borrower 2
    Set Deal Borrower    &{DealDataSet}[Borrower_ShortName2]    &{DealDataSet}[Borrower_Location2]
    Set Deal Borrower Servicing Group    &{DealDataSet}[Borrower_SG_Alias2]    &{DealDataSet}[Borrower_SG_Name2]    &{DealDataSet}[Borrower_ContactName2]    &{DealDataSet}[Borrower_PreferredRIMthd2]
    Go To Deal Borrower Preferred RI Window
    Mark All Preferred Remittance Instruction
    Complete Deal Borrower Setup
    ### Borrower 3
    Set Deal Borrower    &{DealDataSet}[Borrower_ShortName3]    &{DealDataSet}[Borrower_Location3]
    Set Deal Borrower Servicing Group    &{DealDataSet}[Borrower_SG_Alias3]    &{DealDataSet}[Borrower_SG_Name3]    &{DealDataSet}[Borrower_ContactName3]    &{DealDataSet}[Borrower_PreferredRIMthd3]
    Go To Deal Borrower Preferred RI Window
    Mark All Preferred Remittance Instruction
    Complete Deal Borrower Setup
    Select Admin Agent    &{DealDataSet}[Deal_AdminAgent]    &{DealDataSet}[AdminAgent_Location]
    Set Deal Admin Agent Servicing Group    &{DealDataSet}[AdminAgent_SGAlias]    &{DealDataSet}[AdminAgent_SGName]    &{DealDataSet}[AdminAgent_ContactName]    &{DealDataSet}[AdminAgent_RIMethod]
    Go To Admin Agent Preferred RI Window
    Mark All Preferred Remittance Instruction
    Complete Deal Admin Agent Setup
    Select Deal Classification    &{DealDataSet}[Deal_ClassificationCode]    &{DealDataSet}[Deal_ClassificationDesc]
    Enter Agreement Date and Proposed Commitment Amount    &{DealDataSet}[Deal_AgreementDate]    &{DealDataSet}[Deal_ProposedCmt]
    Save Changes on Deal Notebook
    
    ### Personnel Tab ###
    Enter Department on Personel Tab    &{DealDataSet}[Deal_DepartmentCode]    &{DealDataSet}[Deal_Department]
    Enter Expense Code    &{DealDataSet}[Deal_ExpenseCode]
    
    ### Calendars Tab ###    
    Set Deal Calendar    &{DealDataSet}[Deal_Calendar]
    
    ### Pricing Rules Tab ###
    Click Add Option In Pricing Rules
    Set Pricing Option    &{DealDataSet}[Deal_PricingOption]    &{DealDataSet}[InitialFractionRate_Round]    &{DealDataSet}[RoundingDecimal_Round]
    Set Rounding Application Method    &{DealDataSet}[RoundingApplicationMethod]
    Set Percent Of Rate Formula Usage    &{DealDataSet}[PercentOfRateFormulaUsage]
    Set Non Business Day Rule    &{DealDataSet}[NonBusinessDayRule]    &{DealDataSet}[RepricingNonBusinessDayRule]
    Set Change Application Method    &{DealDataSet}[PricingOption_MatrixChangeAppMthd]    &{DealDataSet}[PricingOption_RateChangeAppMthd]
    Tick Interest Due Upon Principal Payment Checkbox 
    Click OK In Interest Pricing Option Details Window
    Validate Added Deal Pricing Option    &{DealDataSet}[Deal_PricingOption]
    
Deal Facility Create
    [Documentation]    This keyword creates a facility for a specific deal.
    ...                @author: hstone    09SEP2019    Initial create
    ...                @update: mcastro   10SEP2020    Updated screenshot path
    [Arguments]    ${FacilityDataSet}
    ### New Facility Name Generation ###
	${FacilityName}    Generate Facility Name    &{FacilityDataSet}[Facility_NamePrefix]
	
	### Excel Data Read ###
	${DealName}    Read Data From Excel    DealData    Deal_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
	${sSapwulEvent}    Read Data From Excel    DealData    Sapwul_Event   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
	${sFacilityExistsAtPayload}    Set Variable    &{FacilityDataSet}[Facility_ExistsAtPayload]    
	
    ### Save Test Data ###
	Write Data To Excel    FacilityData    Deal_Name    &{FacilityDataSet}[rowid]    ${DealName}    ${SAPWUL_DATASET}
	Write Data To Excel    FacilityData    Facility_Name    &{FacilityDataSet}[rowid]    ${FacilityName}    ${SAPWUL_DATASET}
	Write Data To Excel    FacilityFeeData    Facility_Name    &{FacilityDataSet}[FacilityFee_RowId]    ${FacilityName}    ${SAPWUL_DATASET}

	### Fetch Facility Name ###
    ${FacilityName}    Read Data From Excel    FacilityData    Facility_Name   &{FacilityDataSet}[rowid]    ${SAPWUL_DATASET}
    
    ### Get Customer ID ###
    ${CustomerID}    Get Customer ID from Active Customer Notebook Via Deal Notebook    &{FacilityDataSet}[Facility_Borrower]
    
    ### Facility Creation ###
    Add New Facility    ${DealName}    &{FacilityDataSet}[Deal_Currency]    ${FacilityName}
    ...    &{FacilityDataSet}[Facility_Type]    &{FacilityDataSet}[Facility_ProposedCmtAmt]    &{FacilityDataSet}[Facility_Currency]
    Verify Main SG Details    &{FacilityDataSet}[Facility_ServicingGroup]    &{FacilityDataSet}[Facility_Customer]    &{FacilityDataSet}[Facility_SGLocation]
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_Add New Facility
    
    ### Summary Tab: Set Facility Dates ###
    ${FacilityControlNumber}    Get Facility Control Number
    Set Facility Dates    &{FacilityDataSet}[Facility_AgreementDate]    &{FacilityDataSet}[Facility_EffectiveDate]    &{FacilityDataSet}[Facility_ExpiryDate]    &{FacilityDataSet}[Facility_MaturityDate]
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_Summary Tab
    
    ### Types/Purpose Tab: Enter Multiple Risk Types ###
    Set Facility Risk Type    &{FacilityDataSet}[Facility_RiskType]
    
    ### Types/Purpose Tab: Enter Loan Purpose Type ###
    Set Facility Loan Purpose Type    &{FacilityDataSet}[Facility_LoanPurposeType]
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_Types and Purpose Tab
    
    ### Sublimit/Cust Tab: Add Facility Borrower ###
    Add Borrower    &{FacilityDataSet}[Borrower_Currency]    &{FacilityDataSet}[Facility_BorrowerSGName]    &{FacilityDataSet}[Facility_BorrowerPercent]    &{FacilityDataSet}[Facility_Borrower]
    ...    &{FacilityDataSet}[Facility_GlobalLimit]    &{FacilityDataSet}[Facility_BorrowerMaturity]    &{FacilityDataSet}[Facility_EffectiveDate]
    ${sCustomerProfileType}    ${bPrimaryBorrower}    Get Borrower Details From Facility Notebook    &{FacilityDataSet}[Facility_Borrower]
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_Sublimit and Cust Tab
    
    ### Events Tab: Get Facility ID ###
    Navigate to Facility Business Event    Created
    ${FacilityID}    Get Business Event ID
    
    ### Set Other Facility Updates ###
    ${sEffectiveDate}    Convert LIQ Date to Payload Date    &{FacilityDataSet}[Facility_EffectiveDate]    y-m-d
    ${sKey_List}    Create List    Payload_effectiveDate
    ${sVal_List}    Create List    ${sEffectiveDate}
    
    ### Create Customer External ID Item and Customer External ID List ###
    ${sCustomerExternalIdItem}    Create List    ${sCustomerProfileType}    ${bPrimaryBorrower}    ${CustomerID}    
    ${sCustomerExternalIdItem_List}    Create Customer External ID List    ${sCustomerExternalIdItem}
       
    ### SAPWUL Data Save ###
    Run Keyword If    '${sFacilityExistsAtPayload}'=='Y'    Set SAPWUL Test Data    ${sSapwulEvent}    &{FacilityDataSet}[Sapwul_RowId]    ${FacilityName}    ${FacilityID}    
    ...    ${FacilityControlNumber}    ${MANAGER_USERNAME}    ${sCustomerExternalIdItem_List}    ${sKey_List}    ${sVal_List} 

Deal Facility Save 
    [Documentation]    High-level keyword for Deal Facility Pricing set up.
    ...    author: henstone    03SEP2019    Initial create
    [Arguments]    ${FacilityFeeDataSet}
    Validate Facility
    Run Keyword If     '${FacilityFeeDataSet}[Facility_LeavePending]'=='Y'    Close All Windows on LIQ
    ...    ELSE    Close Facility Navigator Window  
    
Deal Facility Fee Setup 
    [Documentation]    High-level keyword for Deal Facility Pricing set up.
    ...    author: henstone    03SEP2019    Initial create
    ...    @update: mcastro    10SEP2020    Updated screenshot path
    [Arguments]    ${FacilityFeeDataSet}
    ### Pricing Tab: Add Interest Pricing ###
    Modify Interest Pricing - Insert Add    &{FacilityFeeDataSet}[Interest_AddItem]    &{FacilityFeeDataSet}[Interest_OptionName]    
    ...    &{FacilityFeeDataSet}[Interest_RateBasis]    &{FacilityFeeDataSet}[Interest_SpreadValue]    &{FacilityFeeDataSet}[Interest_BaseRateCode]

    Set Facility Pricing Penalty Spread    &{FacilityFeeDataSet}[Penalty_Spread]    &{FacilityFeeDataSet}[Penalty_Status]
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_Pricing Tab
    
Deal Primaries Setup - Single Facility
    [Documentation]    This high-level keyword sets up the Lender for the deal with a single facility
    ...                @author: hstone    03SEP2019    Initial create
    [Arguments]    ${DealDataSet}   
    ### Get Needed Test Data ###
    ${Facility_Name1}    Read Data From Excel    FacilityData    Facility_Name    &{DealDataSet}[Deal_FacilityRowID1]    ${SAPWUL_DATASET} 
    ${Facility_Expiry1}    Read Data From Excel    FacilityData    Facility_ExpiryDate    &{DealDataSet}[Deal_FacilityRowID1]    ${SAPWUL_DATASET}
    ${Deal_Name}    Read Data From Excel    DealData    Deal_Name    &{DealDataSet}[rowid]    ${SAPWUL_DATASET}
    
    ### Add Host Bank Primary Lender
    ${ExpCode_Description}    Add Lender and Location    &{DealDataSet}[Deal_Name]    &{DealDataSet}[Primary_Lender]    &{DealDataSet}[Primary_LenderLoc]    &{DealDataSet}[Primary_RiskBookExpCode]    &{DealDataSet}[Primary_TransactionType]
    Set Sell Amount and Percent of Deal    &{DealDataSet}[Primary_PctOfDeal]
    Add Pro Rate    &{DealDataSet}[Primary_BuySellPrice]
    Verify Buy/Sell Price in Circle Notebook
    Add Contact in Primary    &{DealDataSet}[Primary_Contact]
    
    ### Primary Servicing Group Remittance Instruction validation.
    Open Primary Servicing Groups
    Validate Primary SG Remittance Instructions    &{DealDataSet}[Primary_SGRIMethod]
    Complete Primary Servicing Group Setup
    
    ### Get Sell Amount Data and store to Excel for Portfolio Allocation    
    ${SellAmount1}    Get Circle Notebook Sell Amount Per Facility    ${Facility_Name1}
    
    ### Save and Exit
    Circle Notebook Save And Exit
    
    ### Circle Notebook Portfolio Allocation
    Open Lender Circle Notebook From Primaries List    &{DealDataSet}[Primary_Lender]
    Click Portfolio Allocations from Circle Notebook
    Circle Notebook Portfolio Allocation Per Facility    ${Facility_Name1}    &{DealDataSet}[Primary_Portfolio]    &{DealDataSet}[Primary_PortfolioBranch]    ${SellAmount1}    ${Facility_Expiry1}    &{DealDataSet}[Primary_RiskBookExpCode]    ${ExpCode_Description}
    Complete Circle Notebook Portfolio Allocation
    
    ### Workflow Tab - Circling and Sending to Settlement Approval
    Circling for Primary Workflow    &{DealDataSet}[Primary_CircledDate]
    Navigate Notebook Workflow    ${LIQ_OrigPrimaries_Window}    ${LIQ_OrigPrimaries_Tab}    ${LIQ_PrimaryCircle_Workflow_JavaTree}    Send to Settlement Approval
    Validate Window Title Status    Orig Primary    Awaiting Settlement Approval
    
    ### Save and Exit
    Circle Notebook Save And Exit
    Exit Primaries List Window
    
    ### Work In Process - Settlment Approval
    Logout From Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Select Actions    [Actions];Work In Process
    Circle Notebook Settlement Approval    ${Deal_Name}    Host Bank
    
    Logout From Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Open Existing Deal    ${Deal_Name}

Deal Primaries Setup - Multiple Facilities
    [Documentation]    This high-level keyword sets up the Lender for the deal with multiple facility
    ...                @author: hstone    15AUG2019    Initial create
    [Arguments]    ${DealDataSet}
    ### Get Needed Test Data ###
    ${Facility_Name1}    Read Data From Excel    FacilityData    Facility_Name    &{DealDataSet}[Deal_FacilityRowID1]    ${SAPWUL_DATASET}    
    ${Facility_Name2}    Read Data From Excel    FacilityData    Facility_Name    &{DealDataSet}[Deal_FacilityRowID2]    ${SAPWUL_DATASET}
    ${Facility_Name3}    Read Data From Excel    FacilityData    Facility_Name    &{DealDataSet}[Deal_FacilityRowID3]    ${SAPWUL_DATASET}
    ${SellAmount1}    Read Data From Excel    FacilityData    Facility_ProposedCmtAmt    &{DealDataSet}[Deal_FacilityRowID1]    ${SAPWUL_DATASET}    
    ${SellAmount2}    Read Data From Excel    FacilityData    Facility_ProposedCmtAmt    &{DealDataSet}[Deal_FacilityRowID2]    ${SAPWUL_DATASET}
    ${SellAmount3}    Read Data From Excel    FacilityData    Facility_ProposedCmtAmt    &{DealDataSet}[Deal_FacilityRowID3]    ${SAPWUL_DATASET}
    ${Facility_Expiry1}    Read Data From Excel    FacilityData    Facility_ExpiryDate    &{DealDataSet}[Deal_FacilityRowID1]    ${SAPWUL_DATASET}
    ${Facility_Expiry2}    Read Data From Excel    FacilityData    Facility_ExpiryDate    &{DealDataSet}[Deal_FacilityRowID2]    ${SAPWUL_DATASET}
    ${Facility_Expiry3}    Read Data From Excel    FacilityData    Facility_ExpiryDate    &{DealDataSet}[Deal_FacilityRowID3]    ${SAPWUL_DATASET}
    ${Deal_Name}    Read Data From Excel    DealData    Deal_Name    &{DealDataSet}[rowid]    ${SAPWUL_DATASET}
    
    ### Add Host Bank Primary Lender
    ${ExpCode_Description}    Add Lender and Location    &{DealDataSet}[Deal_Name]    &{DealDataSet}[Primary_Lender]    &{DealDataSet}[Primary_LenderLoc]    &{DealDataSet}[Primary_RiskBookExpCode]    &{DealDataSet}[Primary_TransactionType]
    Set Sell Amount and Percent of Deal    &{DealDataSet}[Primary_PctOfDeal]
    Add Pro Rate    &{DealDataSet}[Primary_BuySellPrice]
    Verify Buy/Sell Price in Circle Notebook
    Add Contact in Primary    &{DealDataSet}[Primary_Contact]
    
    ### Primary Servicing Group Remittance Instruction validation.
    Open Primary Servicing Groups
    Validate Primary SG Remittance Instructions    &{DealDataSet}[Primary_SGRIMethod]
    Complete Primary Servicing Group Setup
    
    ### Save and Exit
    Circle Notebook Save And Exit
    
    ### Circle Notebook Portfolio Allocation
    Open Lender Circle Notebook From Primaries List    &{DealDataSet}[Primary_Lender]
    Click Portfolio Allocations from Circle Notebook
    Circle Notebook Portfolio Allocation Per Facility    ${Facility_Name1}    &{DealDataSet}[Primary_Portfolio]    &{DealDataSet}[Primary_PortfolioBranch]    ${SellAmount1}    ${Facility_Expiry1}    &{DealDataSet}[Primary_RiskBookExpCode]    ${ExpCode_Description}
    Circle Notebook Portfolio Allocation Per Facility    ${Facility_Name2}    &{DealDataSet}[Primary_Portfolio]    &{DealDataSet}[Primary_PortfolioBranch]    ${SellAmount2}    ${Facility_Expiry2}    &{DealDataSet}[Primary_RiskBookExpCode]    ${ExpCode_Description}
    Circle Notebook Portfolio Allocation Per Facility    ${Facility_Name3}    &{DealDataSet}[Primary_Portfolio]    &{DealDataSet}[Primary_PortfolioBranch]    ${SellAmount3}    ${Facility_Expiry3}    &{DealDataSet}[Primary_RiskBookExpCode]    ${ExpCode_Description}
    Complete Circle Notebook Portfolio Allocation
    
    ### Workflow Tab - Circling and Sending to Settlement Approval
    Circling for Primary Workflow    &{DealDataSet}[Primary_CircledDate]
    Navigate Notebook Workflow    ${LIQ_OrigPrimaries_Window}    ${LIQ_OrigPrimaries_Tab}    ${LIQ_PrimaryCircle_Workflow_JavaTree}    Send to Settlement Approval
    Validate Window Title Status    Orig Primary    Awaiting Settlement Approval
    
    ### Save and Exit
    Circle Notebook Save And Exit
    Exit Primaries List Window
    
    ### Work In Process - Settlment Approval
    Logout From Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Select Actions    [Actions];Work In Process
    Circle Notebook Settlement Approval    ${Deal_Name}    Host Bank
    
    Logout From Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Open Existing Deal    ${Deal_Name}
    
Deal Close
    [Documentation]    This keyword Approves and Closes the Deal
    ...                @author: hstone    03SEP2019    Initial create
    [Arguments]    ${DealDataSet}
    mx LoanIQ activate    ${LIQ_DealNotebook_Window}
    Navigate Notebook Workflow    ${LIQ_DealNotebook_Window}    ${LIQ_DealNotebook_Tab}    ${LIQ_DealNotebook_Workflow_JavaTree}    Send to Approval
    Logout From Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Open Existing Deal    &{DealDataSet}[Deal_Name]
    Navigate Notebook Workflow    ${LIQ_DealNotebook_Window}    ${LIQ_DealNotebook_Tab}    ${LIQ_DealNotebook_Workflow_JavaTree}    Approval
    Enter Deal Approved Date    &{DealDataSet}[Deal_ApprovalDate]
    Navigate Notebook Workflow    ${LIQ_DealNotebook_Window}    ${LIQ_DealNotebook_Tab}    ${LIQ_DealNotebook_Workflow_JavaTree}    Close
    Enter Deal Close Date    &{DealDataSet}[Deal_CloseDate]
    
    Verify Deal Status After Deal Close
    Logout From Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

Update Deal Lender
    [Documentation]    This keyword updates the deal's lender at Closed Orig Primary window
    ...    @author: hstone    10JAN2020    Initial create
    [Arguments]    ${DealDataSet} 
    Open Existing Deal    &{DealDataSet}[Deal_Name]
    Update Lender thru Deal Notebook's Primaries    &{DealDataSet}[Primary_Lender]  &{DealDataSet}[ThirdParty_Lender]  &{DealDataSet}[Lender_Type]

Deal Primaries Setup - Non Host Bank
    [Documentation]    This high-level keyword sets up the Lender for the deal with a single facility
    ...                @author: hstone    03SEP2019    Initial create
    [Arguments]    ${DealDataSet}   
    ### Get Needed Test Data ###
    ${Facility_Name1}    Read Data From Excel    FacilityData    Facility_Name    &{DealDataSet}[Deal_FacilityRowID1]    ${SAPWUL_DATASET} 
    ${Facility_Expiry1}    Read Data From Excel    FacilityData    Facility_ExpiryDate    &{DealDataSet}[Deal_FacilityRowID1]    ${SAPWUL_DATASET}
    ${Deal_Name}    Read Data From Excel    DealData    Deal_Name    &{DealDataSet}[rowid]    ${SAPWUL_DATASET}
    
    ### Add Host Bank Primary Lender
    ${ExpCode_Description}    Add Lender and Location    &{DealDataSet}[Deal_Name]    &{DealDataSet}[Primary_Lender]    &{DealDataSet}[Primary_LenderLoc]    &{DealDataSet}[Primary_RiskBookExpCode]    &{DealDataSet}[Primary_TransactionType]
    Set Sell Amount and Percent of Deal    &{DealDataSet}[Primary_PctOfDeal]
    Add Pro Rate    &{DealDataSet}[Primary_BuySellPrice]
    Verify Buy/Sell Price in Circle Notebook
    Add Contact in Primary    &{DealDataSet}[Primary_Contact]
    
    ### Primary Servicing Group Remittance Instruction validation.
    Open Primary Servicing Groups
    Validate Primary SG Remittance Instructions    &{DealDataSet}[Primary_SGRIMethod]
    Complete Primary Servicing Group Setup
    
    ### Get Sell Amount Data and store to Excel for Portfolio Allocation    
    ${SellAmount1}    Get Circle Notebook Sell Amount Per Facility    ${Facility_Name1}
    
    ### Save and Exit
    Circle Notebook Save And Exit
    
    ### Circle Notebook Portfolio Allocation
    Open Lender Circle Notebook From Primaries List    &{DealDataSet}[Primary_Lender]
    
    ### Workflow Tab - Circling and Sending to Settlement Approval
    Circling for Primary Workflow    &{DealDataSet}[Primary_CircledDate]
    Navigate Notebook Workflow    ${LIQ_OrigPrimaries_Window}    ${LIQ_OrigPrimaries_Tab}    ${LIQ_PrimaryCircle_Workflow_JavaTree}    Send to Settlement Approval
    Validate Window Title Status    Orig Primary    Awaiting Settlement Approval
    
    ### Save and Exit
    Circle Notebook Save And Exit
    Exit Primaries List Window
    
    ### Work In Process - Settlment Approval
    Logout From Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Select Actions    [Actions];Work In Process
    Circle Notebook Settlement Approval    ${Deal_Name}    Non-Host Bank
    
    Logout From Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Open Existing Deal    ${Deal_Name}

