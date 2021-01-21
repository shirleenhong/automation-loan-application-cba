*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Setup Syndicated Deal for LLA Syndicated
    [Documentation]    This keyword is used to create a Syndicated Deal.
    ...    Primarily entering data in multiple tabs of the Deal Notebook and adding Pricing Options.
    ...    @author: makcamps    18DEC2020    - initial create
    ...    @update: makcamps    07JAN2021    - added write methods for new sheets created
    ...    @update: makcamps    11JAN2021    - added write methods for new sheets created
    ...    @update: makcamps    20JAN2021    - added write methods for notice
    [Arguments]    ${ExcelPath}

    ###Data Generation###
    ${Deal_Name}    ${Deal_Alias}    Generate Deal Name and Alias with Numeric Test Data    &{ExcelPath}[Deal_NamePrefix]    &{ExcelPath}[Deal_AliasPrefix]    5
      
    ${Borrower_ShortName}    Read Data From Excel    PTY001_QuickPartyOnboarding    LIQCustomer_ShortName    &{ExcelPath}[rowid]  
    ${Borrower_Location}    Read Data From Excel    PTY001_QuickPartyOnboarding    Customer_Location    &{ExcelPath}[rowid] 
    ${Borrower_SGAlias}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_SGAlias    &{ExcelPath}[rowid] 
    ${Borrower_SG_GroupMembers}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_SG_GroupMembers    &{ExcelPath}[rowid] 
    ${Borrower_PreferredRIMthd}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_PreferredRIMthd    &{ExcelPath}[rowid] 
    ${Borrower_SG_Name}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_SG_Name    &{ExcelPath}[rowid] 
    ${Borrower_Depositor_Indicator}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_Depositor_Indicator    &{ExcelPath}[rowid]  
    ${Lender_ShortName}    Read Data From Excel    CRED08_OngoingFeeSetup    Lender_ShortName    &{ExcelPath}[rowid] 

    Write Data To Excel    CRED01_DealSetup    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}
    Write Data To Excel    CRED01_DealSetup    Deal_Alias    &{ExcelPath}[rowid]    ${Deal_Alias}
    Write Data To Excel    CRED02_FacilitySetup    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}
    Write Data To Excel    CRED02_FacilitySetup    Borrower_ShortName    &{ExcelPath}[rowid]    ${Borrower_ShortName}
    Write Data To Excel    CRED02_FacilitySetup    Facility_Borrower    &{ExcelPath}[rowid]    ${Borrower_ShortName}
    Write Data To Excel    CRED02_FacilitySetup    Facility_BorrowerSGName    &{ExcelPath}[rowid]    ${Borrower_SG_Name}
    Write Data To Excel    CRED08_OngoingFeeSetup    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}
    Write Data To Excel    CRED08_OngoingFeeSetup    Borrower_ShortName    &{ExcelPath}[rowid]    ${Borrower_ShortName}
    Write Data To Excel    SYND02_PrimaryAllocation    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}
    Write Data To Excel    Correspondence    Deal_Name    ${rowid}    ${Deal_Name}    ${ExcelPath}    N    True    rowid
    Write Data To Excel    Correspondence    Notice_Customer_LegalName    1    ${Lender_ShortName}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Notice_Customer_LegalName    2    ${Borrower_ShortName}    bTestCaseColumn=True    sColumnReference=rowid
    
    ###Deal Select Window###
    Create New Deal    ${Deal_Name}    ${Deal_Alias}    &{ExcelPath}[Deal_Currency]    &{ExcelPath}[Deal_Department]
    
    ###Summary Tab###
    Unrestrict Deal
        
    ###Deal Borrower Setup###
    Add Deal Borrower    ${Borrower_ShortName}
    Select Deal Borrower Location and Servicing Group    ${Borrower_Location}    ${Borrower_SGAlias}    ${Borrower_SG_GroupMembers}    ${Borrower_PreferredRIMthd}    ${Borrower_ShortName}    ${Borrower_SG_Name}
    Select Deal Borrower Remmitance Instruction    ${Borrower_ShortName}    ${Deal_Name}    ${Borrower_Location}    ${Borrower_Depositor_Indicator}
    
    Select Deal Classification    &{ExcelPath}[Deal_ClassificationCode]    &{ExcelPath}[Deal_ClassificationDesc]
    
    ###Deal Admin Agent Setup###
    Select Admin Agent    &{ExcelPath}[Deal_AdminAgent]    &{ExcelPath}[AdminAgent_Location]
    Select Servicing group and Remittance Instrucion for Admin Agent    &{ExcelPath}[AdminAgent_SGAlias]    &{ExcelPath}[AdminAgent_PreferredRIMthd1]    &{ExcelPath}[Deal_AdminAgent]  
    Enter Agreement Date and Proposed Commitment Amount    &{ExcelPath}[Deal_AgreementDate]    &{ExcelPath}[Deal_ProposedCmt]
    
    ###Personnel Tab###
    Enter Department on Personel Tab    &{ExcelPath}[Deal_DepartmentCode]    &{ExcelPath}[Deal_Department]
    Enter Expense Code    &{ExcelPath}[Deal_ExpenseCode]
    
    ###Calendars Tab###
    Set Deal Calendar    &{ExcelPath}[HolidayCalendar]
    
    ###Pricing Rules Tab - Pricing Options###
    Add Deal Pricing Options    &{ExcelPath}[Deal_PricingOption]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    
    ...    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[PricingOption_BillNoOfDays]    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]
    ...    &{ExcelPath}[PricingOption_RateChangeAppMthd]    sBillBorrower=OFF    sInterestDueUponPrincipalPayment=ON
    
    ###Pricing Rules###
    Add Fee Pricing Rules    &{ExcelPath}[PricingRule_Fee1]    &{ExcelPath}[PricingRule_MatrixChangeAppMthd1]    &{ExcelPath}[PricingRule_NonBussDayRule1]
    ...    OFF    &{ExcelPath}[PricingRule_BillNoOfDays1]
    
    Save Changes on Deal Notebook
    
Setup Primaries for LLA Syndicated Deal
    [Documentation]    This keyword adds Lenders in a LLA Syndicated Deal. Specifically, 1 Host Bank and 1 Non-Host Banks.
    ...    @author: makcamps    07JAN2021    - initial create
    [Arguments]    ${ExcelPath}
    
    ###Primary Lender - Host Bank###
    Add Lender and Location    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Primary_Lender1]    &{ExcelPath}[Primary_LenderLoc1]    &{ExcelPath}[Primary_RiskBook]    &{ExcelPath}[Primary_TransactionType]
    ${SellAmount1}    Set Sell Amount and Percent of Deal    &{ExcelPath}[Primary_PctOfDeal1]
    Add Pro Rate    &{ExcelPath}[Primary_BuySellPrice]
    Verify Buy/Sell Price in Circle Notebook 
    Populate Amts or Dates Tab in Pending Orig Primary    ${SellAmount1}    &{ExcelPath}[Expected_CloseDate]
    Add Contact in Primary    &{ExcelPath}[Primary_Contact1]
    Select Servicing Group on Primaries    &{ExcelPath}[ServicingGroupMember]    &{ExcelPath}[AdminAgent_SGAlias1]
    Close Orig Primaries Window
    
    ###Secondary Lender - Non Host Bank###
    Add Non-Host Bank Lenders for a Syndicated Deal    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Primary_Lender2]    &{ExcelPath}[Primary_LenderLoc2]    &{ExcelPath}[Primary_TransactionType]
    ${SellAmount2}    Set Sell Amount and Percent of Deal    &{ExcelPath}[Primary_PctOfDeal2]
    Add Pro Rate    &{ExcelPath}[Primary_BuySellPrice]
    Verify Buy/Sell Price in Circle Notebook 
    Populate Amts or Dates Tab in Pending Orig Primary    ${SellAmount2}    &{ExcelPath}[Expected_CloseDate]
    Add Contact in Primary    &{ExcelPath}[Primary_Contact2]
    Select Servicing Group on Primaries    &{ExcelPath}[ServicingGroupMember]    &{ExcelPath}[AdminAgent_SGAlias2]
    Close Orig Primaries Window
    
    ###Circle Notebook Complete Portfolio Allocation, Circling, and Sending to Settlement Approval###
     ${HostBank_ShareAmount}    Circle Notebook Workflow Navigation for LLA Syndicated Deal    &{ExcelPath}[Primary_Lender1]    &{ExcelPath}[Primary_CircledDate]
    ...    &{ExcelPath}[IsLenderAHostBank]    &{ExcelPath}[Primary_Portfolio]    &{ExcelPath}[Primary_PortfolioBranch]    &{ExcelPath}[Primary_PortfolioAllocation]
    ...    &{ExcelPath}[Primary_PortfolioExpiryDate]    &{ExcelPath}[Deal_ExpenseCode]
    ${Lender_ShareAmount1}    Circle Notebook Workflow Navigation for LLA Syndicated Deal    &{ExcelPath}[Primary_Lender2]    &{ExcelPath}[Primary_CircledDate]
    
    ###Approval using a different user###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Actions    [Actions];Work In Process
    Circle Notebook Settlement Approval    &{ExcelPath}[Primary_Lender1]    &{ExcelPath}[LenderType1]
    Close All Windows on LIQ
    Select Actions    [Actions];Work In Process
    Circle Notebook Settlement Approval    &{ExcelPath}[Primary_Lender2]    &{ExcelPath}[LenderType2]
    
LLA Syndicated Deal Approval and Close
    [Documentation]    This keywords Approves and Closes the created LLA Syndicated Deal.
    ...    @author: makcamps    07JAN2021    - initial create
    ...    @update: makcamps    20JAN2021    - added update of line fee details
    [Arguments]    ${ExcelPath}
    
    ###Close all windows and Login as original user###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Deal Notebook###
    Search Existing Deal    &{ExcelPath}[Deal_Name]
    Navigate Notebook Workflow    ${LIQ_DealNotebook_Window}    ${LIQ_DealNotebook_Tab}    ${LIQ_DealNotebook_Workflow_JavaTree}    ${SEND_TO_APPROVAL_STATUS}
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Approve the Deal    &{ExcelPath}[ApproveDate]
    Close the Deal    &{ExcelPath}[CloseDate]

    ###Validate Deal, Facility and Circle Notebooks status after Deal Close.
    Verify Circle Notebook Status After Deal Close    &{ExcelPath}[Primary_Lender1]
    Verify Facility Status After Deal Close    &{ExcelPath}[Facility_Name]
    Verify Deal Status After Deal Close
    Validate Deal Closing Cmt With Facility Total Global Current Cmt
    ${Deal_ClosingCmt}    Get Deal Closing Cmt
    
    ###Line Fee Notebook###
    ${OngoingFee_Type}    Read Data From Excel    CRED08_OngoingFeeSetup    OngoingFee_Type    &{ExcelPath}[rowid]  
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Navigate to Commitment Fee Notebook    ${OngoingFee_Type}
    Release Line Fee
    Save Notebook Transaction    ${LIQ_FacilityNavigator_Window}    ${LIQ_FacilityNotebook_File_Save}
    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
   