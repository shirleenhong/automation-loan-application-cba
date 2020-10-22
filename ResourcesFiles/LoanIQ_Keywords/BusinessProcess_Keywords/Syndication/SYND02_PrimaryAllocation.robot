*** Settings ***
Resource     ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Setup a Primary Notebook
    [Arguments]    ${ExcelPath}
    ###Deal Notebook - Facilites Tab###
    Open Existing Deal    &{ExcelPath}[Deal_Name] 
    Add Lender and Location    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Primary_Lender1]    &{ExcelPath}[Primary_LenderLoc1]    &{ExcelPath}[Primary_RiskBook]    &{ExcelPath}[Primaries_TransactionType]
    Set Sell Amount and Percent of Deal    &{ExcelPath}[Primary_PctOfDeal1]
    Add Pro Rate    &{ExcelPath}[Primary_BuySellPrice]
    Add Pricing Comment    &{ExcelPath}[Primary_Comment]
    
    ###Circle Notebook - Contacts Tab### 
    Add Contact in Primary    &{ExcelPath}[Primary_Contact1]
    Delete Contact in Primary    &{ExcelPath}[Primary_Contact1]
    Add Contact in Primary    &{ExcelPath}[Primary_Contact1]
    Select Servicing Group on Primaries    &{ExcelPath}[servicingGroupMember]    &{ExcelPath}[AdminAgent_SGAlias]
    Validate Delete Error on Servicing Group    &{ExcelPath}[FundReceiverDetailCustomer]
    
    ##Circle Notebook - Workflow Tab###
    ${Primary_PortfolioExpiryDate}    Read Data From Excel    SYND02_PrimaryAllocation    Primary_PortfolioExpiryDate    ${rowid}        
    Complete Portfolio Allocations Workflow    &{ExcelPath}[Primary_Portfolio]    &{ExcelPath}[Primary_PortfolioBranch]    &{ExcelPath}[Primary_PortfolioAllocation]    ${Primary_PortfolioExpiryDate}    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Primary_RiskBook]    
    Circling for Primary Workflow    &{ExcelPath}[Primary_CircledDate]
    Mx LoanIQ Close    ${LIQ_OrigPrimaries_Window}
    Mx LoanIQ Close    ${LIQ_PrimariesList_Window}
    
    ###Deal Notebook - Workflow Tab###
    Send Deal to Approval    
    Mx LoanIQ Close    ${LIQ_DealNotebook_Window}
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}   
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Approve the Deal    &{ExcelPath}[ApproveDate]
    Mx LoanIQ Close    ${LIQ_DealNotebook_Window}
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ   ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Close the Deal    &{ExcelPath}[CloseDate]    
    Verify Status on Circle and Facility and Deal    &{ExcelPath}[FundReceiverDetailCustomer]    &{ExcelPath}[Facility_Name]
    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

Setup Primaries for Syndicated Deal
    [Documentation]    This keyword adds Lenders in a Syndicated Deal. Specifically, 1 Host Bank and 2 Non-Host Banks.
    ...    @author: bernchua
    [Arguments]    ${ExcelPath}
    
    ###Primary Lender - Host Bank###
    Add Lender and Location    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Primary_Lender1]    &{ExcelPath}[Primary_LenderLoc1]    &{ExcelPath}[Primary_RiskBook]    &{ExcelPath}[Primary_TransactionType]
    Set Sell Amount and Percent of Deal    &{ExcelPath}[Primary_PctOfDeal1]
    Add Pro Rate    &{ExcelPath}[Primary_BuySellPrice]
    Verify Buy/Sell Price in Circle Notebook
    Add Contact in Primary    &{ExcelPath}[Primary_Contact1]
    Select Servicing Group on Primaries    None    &{ExcelPath}[AdminAgent_SGAlias]
    ${SellAmount}    Get Circle Notebook Sell Amount
    Write Data To Excel    CRED01_DealSetup    Primary_PortfolioAllocation    &{ExcelPath}[rowid]    ${SellAmount}
    mx LoanIQ close window    ${LIQ_OrigPrimaries_Window}
    
    ###Secondary Lender - Non Host Bank###
    Add Non-Host Bank Lenders for a Syndicated Deal    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Primary_Lender2]    &{ExcelPath}[Primary_LenderLoc2]    &{ExcelPath}[Primary_TransactionType]
    Set Sell Amount and Percent of Deal    &{ExcelPath}[Primary_PctOfDeal2]
    Add Pro Rate    &{ExcelPath}[Primary_BuySellPrice]
    Verify Buy/Sell Price in Circle Notebook
    Add Contact in Primary    &{ExcelPath}[Primary_Contact2]
    Select Servicing Group on Primaries    None    &{ExcelPath}[AdminAgent_SGAlias_Secondary]
    mx LoanIQ close window    ${LIQ_OrigPrimaries_Window}
    
    ###Secondary Lender - Non Host Bank###
    Add Non-Host Bank Lenders for a Syndicated Deal    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Primary_Lender3]    &{ExcelPath}[Primary_LenderLoc3]    &{ExcelPath}[Primary_TransactionType]
    Set Sell Amount and Percent of Deal    &{ExcelPath}[Primary_PctOfDeal3]
    Add Pro Rate    &{ExcelPath}[Primary_BuySellPrice]
    Verify Buy/Sell Price in Circle Notebook
    Add Contact in Primary    &{ExcelPath}[Primary_Contact3]
    Select Servicing Group on Primaries    None    &{ExcelPath}[AdminAgent_SGAlias_Third]
    mx LoanIQ close window    ${LIQ_OrigPrimaries_Window}
    
    
    ##Circle Notebook Complete Portfolio Allocation, Circling, and Sending to Settlement Approval###
    ${CircleDate}    Get System Date
    ${PortfolioExpiry}    Add Days to Date    ${CircleDate}    365
    Write Data To Excel    SYND02_PrimaryAllocation    Primary_PortfolioExpiryDate    ${rowid}    ${PortfolioExpiry}
    Write Data To Excel    SYND02_PrimaryAllocation    Primary_CircledDate    ${rowid}    ${CircleDate}
    ${HostBank_ShareAmount}    Circle Notebook Workflow Navigation    &{ExcelPath}[Primary_Lender1]    ${CircleDate}
    ...    Yes    &{ExcelPath}[Primary_Portfolio]    &{ExcelPath}[Primary_PortfolioBranch]    &{ExcelPath}[Primary_PortfolioAllocation]    ${PortfolioExpiry}    &{ExcelPath}[Deal_ExpenseCode]
    ${Lender_ShareAmount1}    Circle Notebook Workflow Navigation    &{ExcelPath}[Primary_Lender2]    ${CircleDate}
    ${Lender_ShareAmount2}    Circle Notebook Workflow Navigation    &{ExcelPath}[Primary_Lender3]    ${CircleDate}
    
    ##Write Lenders Share Amount to Excel for Share Adjustment###
    Write Data To Excel    MTAM07_FacilityShareAdjustment    HostBank_ShareAmount    ${rowid}   ${HostBank_ShareAmount}
    Write Data To Excel    MTAM07_FacilityShareAdjustment    Lender_ShareAmount1    ${rowid}    ${Lender_ShareAmount1}
    Write Data To Excel    MTAM07_FacilityShareAdjustment    Lender_ShareAmount2    ${rowid}    ${Lender_ShareAmount2}
    
    ##Approval using a different user###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Actions    [Actions];Work In Process
    Circle Notebook Settlement Approval    &{ExcelPath}[Primary_Lender1]    Host Bank
    Close All Windows on LIQ
    Select Actions    [Actions];Work In Process
    Circle Notebook Settlement Approval    &{ExcelPath}[Primary_Lender2]    Non-Host Bank
    Close All Windows on LIQ
    Select Actions    [Actions];Work In Process
    Circle Notebook Settlement Approval    &{ExcelPath}[Primary_Lender3]    Non-Host Bank
        
Setup a Primary Notebook - SBLC
    [Documentation]    This keyword is used to setup primary notebook for SBLC.
    ...    @update: clanding    20JUL2020    - added argument 'sExpense_Code' to Complete Portfolio Allocations Workflow
    [Arguments]    ${ExcelPath}
    ###Circle Notebook - Facilites Tab### 
    Add Lender and Location    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Primary_Lender1]    &{ExcelPath}[Primary_LenderLoc1]    &{ExcelPath}[Primary_RiskBook]    &{ExcelPath}[Primaries_TransactionType]
    Set Sell Amount and Percent of Deal    &{ExcelPath}[Primary_PctOfDeal1]
    Add Pro Rate    &{ExcelPath}[Primary_BuySellPrice]
    Add Pricing Comment    &{ExcelPath}[Primary_Comment]
    
    ###Circle Notebook - Contacts Tab### 
    Add Contact in Primary    &{ExcelPath}[Primary_Contact1]
    Delete Contact in Primary    &{ExcelPath}[Primary_Contact1]
    Add Contact in Primary    &{ExcelPath}[Primary_Contact1]
    Select Servicing Group on Primaries    &{ExcelPath}[Primary_Contact1]    &{ExcelPath}[AdminAgent_SGAlias]
    Validate Delete Error on Servicing Group    &{ExcelPath}[FundReceiverDetailCustomer]
    
    ###Circle Notebook - Workflow Tab###    
    Complete Portfolio Allocations Workflow    &{ExcelPath}[Primary_Portfolio]    &{ExcelPath}[Primary_PortfolioBranch]    &{ExcelPath}[Primary_PortfolioAllocation]    &{ExcelPath}[Primary_PortfolioExpiryDate]
    ...    sExpense_Code=&{ExcelPath}[BankRole_ExpenseCode]
    Circling for Primary Workflow    &{ExcelPath}[Primary_CircledDate]
    Mx LoanIQ Close    ${LIQ_OrigPrimaries_Window}
    Mx LoanIQ Close    ${LIQ_PrimariesList_Window}
    
    ###Deal Notebook - Workflow Tab###
    Send Deal to Approval
    Mx LoanIQ Close    ${LIQ_DealNotebook_Window}
    Logout from Loan IQ
    
    ###Approval - Supervisor###
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}   
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Approve the Deal    &{ExcelPath}[ApproveDate]
    Mx LoanIQ Close    ${LIQ_DealNotebook_Window}
    Logout from Loan IQ
    
    ### Manager ###
    Login to Loan IQ   ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Close the Deal    &{ExcelPath}[CloseDate]
    Verify Status on Circle and Facility and Deal    &{ExcelPath}[FundReceiverDetailCustomer]    &{ExcelPath}[Facility_Name]
    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
Set up a Non-Host and Host Bank Primaries for Syndicated Deal
    [Documentation]    This keyword is used to set up a non-hose and host bank primaries for syndicated deal.
    ...    @update: clanding    28JUL2020    - removed commented keyword 'Complete Portfolio Allocations for Non-Agent And Host Bank Syndicated Deal' after Circling for Primary Workflow
    ...                                      - updated selecting &{ExcelPath}[Lender_NHB] to &{ExcelPath}[Lender_Name] before Complete Portfolio
    ...                                      - updated &{ExcelPath}[PercentOfDeal_NHB] to &{ExcelPath}[PercentOfDeal_HB] in Complete Portfolio
    ...    @update: frluberio    15OCT2020    - updated the Select Servicing Group Primaries for EU
    [Arguments]    ${ExcelPath}  
    
    ###Steps for Adding a Non-Host Bank Primary###
    ###Circle Notebook - Facilites Tab
    Add Lender and Location    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Lender_NHB]    &{ExcelPath}[LenderLocation_NHB]    &{ExcelPath}[RiskBook]    &{ExcelPath}[Primaries_TransactionType]    
    Set Sell Amount and Percent of Deal    &{ExcelPath}[PercentOfDeal_NHB]
    Add Pro Rate    &{ExcelPath}[BuySellPrice]
    Add Pricing Comment    &{ExcelPath}[Comment]
    
    ###Circle Notebook - Contacts Tab###
    Add Contact in Primary   &{ExcelPath}[ContactName_NHB]
    Delete Contact in Primary    &{ExcelPath}[ContactName_NHB]
    Add Contact in Primary    &{ExcelPath}[ContactName_NHB]
    
    Run Keyword If    '&{ExcelPath}[Entity]' == 'EU'    Select Servicing Group on Primaries    sPrimaryLender_ServGroupAlias=&{ExcelPath}[AdminAgent_SGAlias_Secondary]
    ...    ELSE IF    '&{ExcelPath}[Entity]' == 'AU'    Select Servicing Group on Primaries    &{ExcelPath}[AdminAgent_SGAlias_Secondary]
    
    ###Circle Notebook - Workflow Tab###   
    
    Circling for Primary Workflow    &{ExcelPath}[TradeDate]

    ${LenderName}    Get Lender Name from Primaries Window
    Write Data To Excel    CRED01_DealSetup    Primary_Lender1    &{ExcelPath}[rowid]    ${LenderName}
    
    ###Steps for Adding a Host Bank Primary### 
     
    ###Circle Notebook - Facilites Tab###
    Add Lender and Location    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Lender_Name]    &{ExcelPath}[LenderLocation]    &{ExcelPath}[RiskBook]    &{ExcelPath}[Primaries_TransactionType]    
    Set Sell Amount and Percent of Deal    &{ExcelPath}[PercentOfDeal_HB]
    Add Pro Rate    &{ExcelPath}[BuySellPrice]
    Add Pricing Comment    &{ExcelPath}[Comment]
    
    ###Circle Notebook - Contacts Tab###
    Add Contact in Primary   &{ExcelPath}[ContactName]
    Delete Contact in Primary    &{ExcelPath}[ContactName]
    Add Contact in Primary    &{ExcelPath}[ContactName]
    
    Run Keyword If    '&{ExcelPath}[Entity]' == 'EU'    Select Servicing Group on Primaries    sPrimaryLender_ServGroupAlias=&{ExcelPath}[AdminAgent_SGAlias]
    ...    ELSE IF    '&{ExcelPath}[Entity]' == 'AU'    Select Servicing Group on Primaries    &{ExcelPath}[AdminAgent_SGAlias]
    
    ###Circle Notebook - Workflow Tab###   
    Circling for Primary Workflow    &{ExcelPath}[TradeDate]
    
    ${LenderName}    Get Lender Name from Primaries Window
    Write Data To Excel    CRED01_DealSetup    Primary_Lender2    &{ExcelPath}[rowid]    ${LenderName}
    
    Go to Lender    &{ExcelPath}[Lender_Name]
    Complete Portfolio Allocations for Non-Agent And Host Bank Syndicated Deal    &{ExcelPath}[RiskBook]    &{ExcelPath}[PortfolioBranch]    &{ExcelPath}[Deal_Amount]    &{ExcelPath}[PercentOfDeal_HB]    &{ExcelPath}[Expiry_Date] 
    
    Send to Settlement Approval
    
    ###Circle Notebook - Workflow Tab###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Circles Settlement Approval    &{ExcelPath}[WIPTransaction_Type]    &{ExcelPath}[Transaction_Status_Awaiting Approval]    &{ExcelPath}[Lender_Host]    &{ExcelPath}[Lender_Type]    &{ExcelPath}[Deal_Name]
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Search Existing Deal    &{ExcelPath}[Deal_Name]
    
Setup Primaries For Syndicated Deal With Secondary Sale
    [Documentation]    This keyword adds Lenders in a Syndicated Deal ofr Secondary Sale. Specifically, 1 Host Bank and 1 Non-Host Bank.
    ...    @author: bernchua
    ...    @update: dahijara    24JUL2020    - Removed commented codes
    [Arguments]    ${ExcelPath}
    # Primary Lender - Host Bank
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    mx LoanIQ click element if present    ${LIQ_InquiryMode_Button}    
    Add Lender and Location    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Primary_Lender1]    &{ExcelPath}[Primary_LenderLoc1]    &{ExcelPath}[Primary_RiskBook]    &{ExcelPath}[Primary_TransactionType]
    Set Sell Amount and Percent of Deal    &{ExcelPath}[Primary_PctOfDeal1]
    Add Pro Rate    &{ExcelPath}[Primary_BuySellPrice]
    Verify Buy/Sell Price in Circle Notebook
    Add Contact in Primary    &{ExcelPath}[Primary_Contact1]
    Select Servicing Group on Primaries    &{ExcelPath}[BankRole_SGGroupMember]    &{ExcelPath}[AdminAgent_SGAlias]
    ${SellAmount}    Get Circle Notebook Sell Amount
    Write Data To Excel    CRED01_DealSetup    Primary_PortfolioAllocation    &{ExcelPath}[rowid]    ${SellAmount}
    mx LoanIQ close window    ${LIQ_OrigPrimaries_Window}
    
    # Secondary Lender - Non Host Bank
    Add Non-Host Bank Lenders for a Syndicated Deal    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Primary_Lender2]    &{ExcelPath}[Primary_LenderLoc2]    &{ExcelPath}[Primary_TransactionType]
    Set Sell Amount and Percent of Deal    &{ExcelPath}[Primary_PctOfDeal2]
    Add Pro Rate    &{ExcelPath}[Primary_BuySellPrice]
    Verify Buy/Sell Price in Circle Notebook
    Add Contact in Primary    &{ExcelPath}[Primary_Contact2]
    Select Servicing Group on Primaries    &{ExcelPath}[BankRole_SGGroupMember]    &{ExcelPath}[AdminAgent_SGAlias_Secondary]
    mx LoanIQ close window    ${LIQ_OrigPrimaries_Window}
    
    # Circle Notebook Complete Portfolio Allocation, Circling, and Sending to Settlement Approval
    Circle Notebook Workflow Navigation    &{ExcelPath}[Primary_Lender1]    &{ExcelPath}[Primary_CircledDate]
    ...    Yes    &{ExcelPath}[Primary_Portfolio]    &{ExcelPath}[Primary_PortfolioBranch]    &{ExcelPath}[Primary_PortfolioAllocation]    &{ExcelPath}[Primary_PortfolioExpiryDate]    &{ExcelPath}[PortfolioExpense]
    Circle Notebook Workflow Navigation    &{ExcelPath}[Primary_Lender2]    &{ExcelPath}[Primary_CircledDate]
    
    #Approval using a different user.
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Actions    [Actions];Work In Process
    Circle Notebook Settlement Approval    &{ExcelPath}[Primary_Lender1]    Host Bank
    Circle Notebook Settlement Approval    &{ExcelPath}[Primary_Lender2]    Non-Host Bank
    
    # Re-login to original user, and opening the created Deal.
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    mx LoanIQ click element if present    ${LIQ_DealNotebook_InquiryMode_Button} 
    
Setup a Primary Notebook for Multiple Risk Types Deal
    [Documentation]    This high-level keyword setting up Primary Notebook with 2 Facilities
    ...    @author: bernchua
    ...    @update: rtarayao    28FEB2019    changed keywords used to complete the portfolio allocations
    [Arguments]    ${ExcelPath}
    
    ###Search Deal### 
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ###Circle Notebook - Facilites Tab###
    ${sSystemDate}    Get System Date
    Add Lender and Location    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Primary_Lender]    &{ExcelPath}[Primary_LenderLoc]    &{ExcelPath}[Primary_RiskBook]    &{ExcelPath}[Primaries_TransactionType]
    Set Sell Amount and Percent of Deal    &{ExcelPath}[Primary_PctOfDeal]
    Add Pro Rate    &{ExcelPath}[Primary_BuySellPrice]
    Add Pricing Comment    &{ExcelPath}[Primary_Comment]
   
    ###Circle Notebook - Contacts Tab### 
    Add Contact in Primary    &{ExcelPath}[Primary_Contact]
    Delete Contact in Primary    &{ExcelPath}[Primary_Contact]
    Add Contact in Primary    &{ExcelPath}[Primary_Contact]
    Select Servicing Group on Primaries    None    &{ExcelPath}[AdminAgent_SGAlias]
    Validate Delete Error on Servicing Group    &{ExcelPath}[FundReceiverDetailCustomer]
    
    ###Circle Notebook - Workflow Tab (Read Test Data Needed)### 
    ${sFacility_ExpiryDate}    Read Data From Excel    CRED02_FacilitySetup    Facility_ExpiryDate    ${rowid}  
    ${sFacility2_ExpiryDate}    Read Data From Excel    CRED02_FacilitySetup    Facility2_ExpiryDate    ${rowid} 
    ${iFacility_ProposedCmtAmt}    Read Data From Excel    CRED02_FacilitySetup    Facility_ProposedCmtAmt    ${rowid}   
    ${iFacility2_ProposedCmtAmt}    Read Data From Excel    CRED02_FacilitySetup    Facility2_ProposedCmtAmt    ${rowid}
    ${aFacility_CombinedProposedCmtAmt}    Create List for Multiple Data    |    ${iFacility_ProposedCmtAmt}    ${iFacility2_ProposedCmtAmt}
    ${aFacility_ExpiryDates}    Create List for Multiple Data    |    ${sFacility_ExpiryDate}    ${sFacility2_ExpiryDate}
    ${sFacility_Names}    Create List for Multiple Data    |    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Facility2_Name]
    Complete Portfolio Allocations Workflow    &{ExcelPath}[Primary_Portfolio]    &{ExcelPath}[Primary_PortfolioBranch]    ${aFacility_CombinedProposedCmtAmt}    ${aFacility_ExpiryDates}    ${sFacility_Names}    &{ExcelPath}[Primary_PortfolioExpenseCode]    
    
    Circling for Primary Workflow    ${sSystemDate}
    Close Primaries Windows
    
    ###Deal Notebook - Workflow Tab>>Send Deal to Approval###
    Send Deal to Approval    
    
    ###LIQ Desktop###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}   
    
    ##Deal Notebook>>Approve Deal###
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Approve the Deal    ${sSystemDate}
    
    ###LIQ Desktop###
    Logout from Loan IQ
    Login to Loan IQ   ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ###Deal Notebook>>Close Deal###
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Close the Deal    ${sSystemDate}
    
    ###Deal and Facility Validations###
    Navigate to Facility Increase Decrease Schedule    &{ExcelPath}[Facility2_Name]
    Validate Commitment Amount    &{ExcelPath}[Commitment_Amount]
    Verify Status on Circle and Facility and Deal    &{ExcelPath}[FundReceiverDetailCustomer]    &{ExcelPath}[Facility_Name]
    
Setup Primary for Comprehensive Deal
    [Documentation]    This keyword sets up the Primary in a Syndicated Deal for Secondary Sale.
    ...    @author: bernchua
    ...    @update: bernchua    21AUG2019    Updates made on keywords 'Add Lender and Location' and 'Circle Notebook Portfolio Allocation Per Facility'
    ...    @update: ehugo    30JUN2020    - updated 'Navigate Notebook Workflow' to 'Navigate to Orig Primaries Workflow and Proceed With Transaction'
    ...                                   - updated SG Remittance Instructions from IMT to DDA
    ...    @update: dahijara    06JUL2020 - replaced hard coded value for Primary SG RI with excel variable.
    [Arguments]    ${ExcelPath}

    ### Add Host Bank Primary Lender
    ${ExpCode_Description}    Add Lender and Location    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Primary_Lender1]    &{ExcelPath}[Primary_LenderLoc1]    &{ExcelPath}[Primary_RiskBook]    &{ExcelPath}[Primary_TransactionType]
    Set Sell Amount and Percent of Deal    &{ExcelPath}[Primary_PctOfDeal1]
    Add Pro Rate    &{ExcelPath}[Primary_BuySellPrice]
    Verify Buy/Sell Price in Circle Notebook
    Add Contact in Primary    &{ExcelPath}[Primary_Contact1]
    
    ### Primary Servicing Group Remittance Instruction validation.
    Open Primary Servicing Groups
    Validate Primary SG Remittance Instructions    &{ExcelPath}[AdminAgent_PreferredRIMthd1]
    Validate Primary SG Remittance Instructions    &{ExcelPath}[AdminAgent_PreferredRIMthd2]
    Complete Primary Servicing Group Setup
    
    ### Get Sell Amount Data and store to Excel for Portfolio Allocation    
    ${SellAmount1}    Get Circle Notebook Sell Amount Per Facility    &{ExcelPath}[Facility_Name]
    ${SellAmount2}    Get Circle Notebook Sell Amount Per Facility    &{ExcelPath}[Facility2_Name]
    Write Data To Excel    CRED01_DealSetup    PrimaryFacility1_Allocation    &{ExcelPath}[rowid]    ${SellAmount1}
    Write Data To Excel    CRED01_DealSetup    PrimaryFacility2_Allocation    &{ExcelPath}[rowid]    ${SellAmount2}
    
    ### Save and Exit
    Circle Notebook Save And Exit
    
    ### Get data for Portfolio Allocation
    ${SellAmount1}    Read Data From Excel    CRED01_DealSetup    PrimaryFacility1_Allocation    &{ExcelPath}[rowid]
    ${SellAmount2}    Read Data From Excel    CRED01_DealSetup    PrimaryFacility2_Allocation    &{ExcelPath}[rowid]
    ${Current_Date}    Get System Date
    ${ExpiryDate}    Get Future Date    ${Current_Date}    730
    
    ### Circle Notebook Portfolio Allocation
    Open Lender Circle Notebook From Primaries List    &{ExcelPath}[Primary_Lender1]
    Click Portfolio Allocations from Circle Notebook
    Circle Notebook Portfolio Allocation Per Facility    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Primary_Portfolio]    &{ExcelPath}[Primary_PortfolioBranch]    ${SellAmount1}    ${ExpiryDate}    &{ExcelPath}[Primary_RiskBook]    ${ExpCode_Description}
    Circle Notebook Portfolio Allocation Per Facility    &{ExcelPath}[Facility2_Name]    &{ExcelPath}[Primary_Portfolio]    &{ExcelPath}[Primary_PortfolioBranch]    ${SellAmount2}    ${ExpiryDate}    &{ExcelPath}[Primary_RiskBook]    ${ExpCode_Description}
    Complete Circle Notebook Portfolio Allocation
    
    ### Workflow Tab - Circling and Sending to Settlement Approval
    Circling for Primary Workflow    ${Current_Date}
    Navigate to Orig Primaries Workflow and Proceed With Transaction    Send to Settlement Approval
    Validate Window Title Status    Orig Primary    Awaiting Settlement Approval
    
    ### Save and Exit
    Circle Notebook Save And Exit
    Exit Primaries List Window
    
    ### Work In Process - Settlment Approval
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Select Actions    [Actions];Work In Process
    Circle Notebook Settlement Approval    &{ExcelPath}[Deal_Name]    Host Bank
    
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Open Existing Deal    &{ExcelPath}[Deal_Name]   

Set Facility Sell Amounts
    [Documentation]    This keyword sets up the Sell Amounts in Primaries.
    ...    @author: fmamaril    27AUG2019    Initial Create
    [Arguments]    ${ExcelPath}
    Set Facility Sell Amounts in Primaries    &{ExcelPath}[Facility_Name]    &{ExcelPath}[SellAmount]    &{ExcelPath}[BuySellPrice]
    
Setup Initial Primary Details
    [Documentation]    This keyword sets up the Initial Primary Details.
    ...    @author: fmamaril    27AUG2019    Initial Create
    ...    @update: mcastro     20OCT2020    Added conditon to open Deal notebook if not displayed
    [Arguments]    ${ExcelPath}
    ###Open Deal Notebook If Not present###
    ${Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_DealNotebook_Window}    VerificationData="Yes"
    Run Keyword If    ${Status}!=${True}    Open Existing Deal    &{ExcelPath}[Deal_Name]
    ...    ELSE    Log    Deal Notebook Is Already Displayed

    Add Lender and Location    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Primary_Lender]    &{ExcelPath}[Primary_LenderLoc]    &{ExcelPath}[Primary_RiskBook]    &{ExcelPath}[Primaries_TransactionType]
    Set Sell Amount and Percent of Deal    &{ExcelPath}[Primary_PctOfDeal]
    
Add Contact in Primaries
    [Documentation]    This keyword sets up the Contact in Primaries.
    ...    @author: fmamaril    27AUG2019    Initial Create
    [Arguments]    ${ExcelPath}
    Add Contact in Primary    &{ExcelPath}[Primary_Contact]
    Navigate to Portfolio Allocations from Circle Notebook

Setup Circle Notebook Allocation
    [Documentation]    This keyword sets up the Circle Notebook Allocation.
    ...    @author: fmamaril    27AUG2019    Initial Create
    [Arguments]    ${ExcelPath}    
    Circle Notebook Portfolio Allocation Per Facility    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Primary_Portfolio]    &{ExcelPath}[Primary_PortfolioBranch]    
    ...    &{ExcelPath}[SellAmount]    &{ExcelPath}[Primary_PortfolioExpiryDate]    &{ExcelPath}[Primary_RiskBook]    &{ExcelPath}[ExpenseCode_Description]
    
Complete Circle Notebook Portfolio
    [Documentation]    This keyword sets up the Circle Notebook Allocation.
    ...    @author: fmamaril    27AUG2019    Initial Create
    [Arguments]    ${ExcelPath}
    Complete Circle Notebook Portfolio Allocation
    
    ###Workflow Tab - Circling and Sending to Settlement Approval###
    Circling for Primary Workflow    &{ExcelPath}[Primary_CircledDate]
    Navigate to Orig Primaries Workflow and Proceed With Transaction    Send to Settlement Approval
    Validate Window Title Status    Orig Primary    Awaiting Settlement Approval
    
    ###Save and Exit###
    Circle Notebook Save And Exit
    Exit Primaries List Window
    
Approve and Close Deal with Single Primary Lender 
    [Documentation]    This keyword Approves and Closes the Deal
    ...                @author: fmamaril    19JUL2020    Initial create
    [Arguments]    ${ExcelPath}
    ##Approval using a different user###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Actions    [Actions];Work In Process
    Circle Notebook Settlement Approval    &{ExcelPath}[Primary_Lender]    Host Bank
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Navigate to Deal Notebook Workflow and Proceed With Transaction    Send to Approval
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Navigate to Deal Notebook Workflow and Proceed With Transaction    Approval
    Enter Deal Approved Date    &{ExcelPath}[ApproveDate]
    Navigate to Deal Notebook Workflow and Proceed With Transaction    Close
    Enter Deal Close Date    &{ExcelPath}[CloseDate]
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}    

Setup 2 Host Bank Primaries for RPA Deal
    [Documentation]    This keyword adds Lenders in a RPA Deal. Specifically, 2 Host banks with protfolios in different branches.
    ...    @author: dahijara    20OCT2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Open Existing Deal    &{ExcelPath}[Deal_Name]

    ###Primary Lender - Host Bank 1###
    Add Lender and Location    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Primary_Lender1]    &{ExcelPath}[Primary_LenderLoc1]    &{ExcelPath}[Primary_RiskBook1]    &{ExcelPath}[Primaries_TransactionType]
    Set Sell Amount and Percent of Deal    &{ExcelPath}[Primary_PctOfDeal1]
    Add Pro Rate    &{ExcelPath}[Primary_BuySellPrice1]
    Verify Buy/Sell Price in Circle Notebook
    Add Contact in Primary    &{ExcelPath}[Primary_Contact1]
    Select Servicing Group on Primaries    None    &{ExcelPath}[Primary_SGAlias1]
    ${SellAmount1}    Get Circle Notebook Sell Amount
    Write Data To Excel    SYND02_PrimaryAllocation    SellAmount1    &{ExcelPath}[rowid]    ${SellAmount1}
    mx LoanIQ close window    ${LIQ_OrigPrimaries_Window}
    
    ###Primary Lender - Host Bank 2###
    Add Lender and Location    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Primary_Lender2]    &{ExcelPath}[Primary_LenderLoc2]    &{ExcelPath}[Primary_RiskBook2]    &{ExcelPath}[Primaries_TransactionType]
    Set Sell Amount and Percent of Deal    &{ExcelPath}[Primary_PctOfDeal2]
    Add Pro Rate    &{ExcelPath}[Primary_BuySellPrice2]
    Verify Buy/Sell Price in Circle Notebook
    Add Contact in Primary    &{ExcelPath}[Primary_Contact2]
    Select Servicing Group on Primaries    None    &{ExcelPath}[Primary_SGAlias2]
    ${SellAmount2}    Get Circle Notebook Sell Amount
    Write Data To Excel    SYND02_PrimaryAllocation    SellAmount2    &{ExcelPath}[rowid]    ${SellAmount2}
    mx LoanIQ close window    ${LIQ_OrigPrimaries_Window}
    
    ##Circle Notebook Complete Portfolio Allocation, Circling, and Sending to Settlement Approval###
    ${HostBank_ShareAmount1}    Circle Notebook Workflow Navigation    &{ExcelPath}[Primary_Lender1]    &{ExcelPath}[Primary_CircledDate]
    ...    Yes    &{ExcelPath}[Primary_Portfolio1]    &{ExcelPath}[Primary_PortfolioBranch1]    ${SellAmount1}    &{ExcelPath}[Primary_PortfolioExpiryDate]    &{ExcelPath}[Primary_RiskBook1]

    ${HostBank_ShareAmount2}    Circle Notebook Workflow Navigation    &{ExcelPath}[Primary_Lender2]    &{ExcelPath}[Primary_CircledDate]
    ...    Yes    &{ExcelPath}[Primary_Portfolio2]    &{ExcelPath}[Primary_PortfolioBranch2]    ${SellAmount2}    &{ExcelPath}[Primary_PortfolioExpiryDate]    &{ExcelPath}[Primary_RiskBook2]

    Close All Windows on LIQ
    
    ##Approval using a different user###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Actions    ${WORK_IN_PROCESS_ACTIONS}
    Circle Notebook Settlement Approval    &{ExcelPath}[Primary_Lender1]    Host Bank
    Close All Windows on LIQ
    Select Actions    ${WORK_IN_PROCESS_ACTIONS}
    Circle Notebook Settlement Approval    &{ExcelPath}[Primary_Lender2]    Host Bank
    Close All Windows on LIQ