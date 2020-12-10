*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Setup a Primary Notebook for DNR
    [Documentation]    This keyword is used to setup primaries for deal.
    ...    @author: clanding    25NOV2020    - initial create
    [Arguments]    ${ExcelPath}
    
    ###Deal Notebook - Facilites Tab###
    Refresh Tables in LIQ
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

    Complete Portfolio Allocations Workflow    &{ExcelPath}[Primary_Portfolio]    &{ExcelPath}[Primary_PortfolioBranch]    &{ExcelPath}[Primary_PortfolioAllocation]    &{ExcelPath}[Primary_PortfolioExpiryDate]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Primary_RiskBook]
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
    
    ### Add Alert ###
    ${Alerts_Details}    ${Date_Added}    Add Alerts in Deal Notebook    &{ExcelPath}[Alerts_ShortDescription]    &{ExcelPath}[Alerts_DetailsPrefix]
    Write Data To Excel    SC1_PrimaryAllocation    Alerts_Details    ${rowid}    ${Alerts_Details}    ${DNR_DATASET}
    Write Data To Excel    SC1_PrimaryAllocation    Alerts_DateAddedAmended    ${rowid}    ${Date_Added}    ${DNR_DATASET}

    ### Add Comments ###
    ${Comment_Author}    ${Comment_Date}    ${Comment_Details}    ${Comment_DateWithTime}    Add Details in Comments Tab in Deal Notebook    &{ExcelPath}[Comments_Subject]    &{ExcelPath}[Comments_Prefix]
    Write Data To Excel    SC1_PrimaryAllocation    User_ID    ${rowid}    ${Comment_Author}    ${DNR_DATASET}
    Write Data To Excel    SC1_PrimaryAllocation    Comments_DateAddedAmended    ${rowid}    ${Comment_DateWithTime}    ${DNR_DATASET}
    Write Data To Excel    SC1_PrimaryAllocation    Comments_Details    ${rowid}    ${Comment_Details}    ${DNR_DATASET}

Close Deal for DNR
    [Documentation]    This keyword is used to close Deal.
    ...    @author: clanding    25NOV2020    - initial create
    [Arguments]    ${ExcelPath}

    Close the Deal    &{ExcelPath}[CloseDate]
    Verify Status on Circle and Facility and Deal    &{ExcelPath}[FundReceiverDetailCustomer]    &{ExcelPath}[Facility_Name]

    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

Get Deal Details and Write in DNR Dataset
    [Documentation]    This keyword is used to get details for each report and write in dataset.
    ...    @author: clanding    25NOV2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    ${TrackingNumber}    Get Deal Tracking Number
    ${FName_UI}    ${LName_UI}    Get First Name of a User    &{ExcelPath}[User_ID]
    
    ### Writing for Comments Report ###
    Write Data To Excel    CMMNT    Deal_Name    CMMNT_006    &{ExcelPath}[Deal_Name]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    CMMNT    Deal_Tracking_Number    CMMNT_006    ${TrackingNumber}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    CMMNT    Comment_Heading    CMMNT_006    &{ExcelPath}[Comments_Subject]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    CMMNT    Comment_Detail    CMMNT_006    &{ExcelPath}[Comments_Details]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    CMMNT    User_ID    CMMNT_006    &{ExcelPath}[User_ID]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    CMMNT    Date_Added_Amended    CMMNT_006    &{ExcelPath}[Comments_DateAddedAmended]    ${DNR_DATASET}    bTestCaseColumn=True

    Write Data To Excel    ALERT    Deal_Name    ALERT_007    &{ExcelPath}[Deal_Name]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    Deal_Tracking_Number    ALERT_007    ${TrackingNumber}    ${DNR_DATASET}    bTestCaseColumn=True

    ### Writing for Alerts Report ###
    Write Data To Excel    ALERT    Deal_Name    ALERT_006    &{ExcelPath}[Deal_Name]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    Deal_Tracking_Number    ALERT_006    ${TrackingNumber}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    Alert_Heading    ALERT_006    &{ExcelPath}[Alerts_ShortDescription]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    Alert_Content    ALERT_006    &{ExcelPath}[Alerts_Details]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    User_Name    ALERT_006    ${FName_UI}${SPACE}${LName_UI}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    Date_Added_Amended    ALERT_006    &{ExcelPath}[Comments_DateAddedAmended]    ${DNR_DATASET}    bTestCaseColumn=True

    ### Writing for Facility Performance Report ###
    Write Data To Excel    FACPF    Deal_Tracking_Number    FACPF_002    ${TrackingNumber}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    FACPF    Deal_Tracking_Number    FACPF_003    ${TrackingNumber}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    FACPF    Deal_Tracking_Number    FACPF_005    ${TrackingNumber}    ${DNR_DATASET}    bTestCaseColumn=True

    ### Writing for Loans & Accrual Report ###
    Write Data To Excel    FACPF    Deal_Tracking_Number    FACPF_002    ${TrackingNumber}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    FACPF    Deal_Tracking_Number    FACPF_003    ${TrackingNumber}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    FACPF    Deal_Tracking_Number    FACPF_005    ${TrackingNumber}    ${DNR_DATASET}    bTestCaseColumn=True

    Close All Windows on LIQ

Setup Primaries for Syndicated Deal for DNR
    [Documentation]    This keyword adds Lenders in a Syndicated Deal. Specifically, 1 Host Bank and 2 Non-Host Banks.
    ...    @author: shirhong    04DEC2020    - initial create
    [Arguments]    ${ExcelPath}
    
    ###Primary Lender - Host Bank###
    Search Existing Deal    &{ExcelPath}[Deal_Name]
    Add Lender and Location    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Primary_Lender1]    &{ExcelPath}[Primary_LenderLoc1]    &{ExcelPath}[Primary_RiskBook]    &{ExcelPath}[Primary_TransactionType]
    Set Sell Amount and Percent of Deal    &{ExcelPath}[Primary_PctOfDeal1]
    Add Pro Rate    &{ExcelPath}[Primary_BuySellPrice]
    Verify Buy/Sell Price in Circle Notebook
    Add Contact in Primary    &{ExcelPath}[Primary_Contact1]

    Select Servicing Group on Primaries    &{ExcelPath}[servicingGroupMember]    &{ExcelPath}[AdminAgent_SGAlias]
    ${SellAmount}    Get Circle Notebook Sell Amount
    Write Data To Excel    SC2_DealSetup    Primary_PortfolioAllocation    &{ExcelPath}[rowid]    ${SellAmount}    ${DNR_DATASET}
    mx LoanIQ close window    ${LIQ_OrigPrimaries_Window}
    
    ###Secondary Lender - Non Host Bank###
    Add Non-Host Bank Lenders for a Syndicated Deal    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Primary_Lender2]    &{ExcelPath}[Primary_LenderLoc2]    &{ExcelPath}[Primary_TransactionType]
    Set Sell Amount and Percent of Deal    &{ExcelPath}[Primary_PctOfDeal2]
    Add Pro Rate    &{ExcelPath}[Primary_BuySellPrice]
    Verify Buy/Sell Price in Circle Notebook
    Add Contact in Primary    &{ExcelPath}[Primary_Contact2]
    Select Servicing Group on Primaries    &{ExcelPath}[servicingGroupMember]    &{ExcelPath}[AdminAgent_SGAlias_Secondary]
    mx LoanIQ close window    ${LIQ_OrigPrimaries_Window}
    
    ###Secondary Lender - Non Host Bank###
    Add Non-Host Bank Lenders for a Syndicated Deal    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Primary_Lender3]    &{ExcelPath}[Primary_LenderLoc3]    &{ExcelPath}[Primary_TransactionType]
    Set Sell Amount and Percent of Deal    &{ExcelPath}[Primary_PctOfDeal3]
    Add Pro Rate    &{ExcelPath}[Primary_BuySellPrice]
    Verify Buy/Sell Price in Circle Notebook
    Add Contact in Primary    &{ExcelPath}[Primary_Contact3]
    Select Servicing Group on Primaries    &{ExcelPath}[servicingGroupMember]    &{ExcelPath}[AdminAgent_SGAlias_Third]
    mx LoanIQ close window    ${LIQ_OrigPrimaries_Window} 
    
    ##Circle Notebook Complete Portfolio Allocation, Circling, and Sending to Settlement Approval###
    ${CircleDate}    Get System Date
    ${PortfolioExpiry}    Add Days to Date    ${CircleDate}    &{ExcelPath}[NumberOfDaysToAdd]
    Write Data To Excel    SC2_PrimaryAllocation    Primary_PortfolioExpiryDate    ${rowid}    ${PortfolioExpiry}    ${DNR_DATASET}
    Write Data To Excel    SC2_PrimaryAllocation    Primary_CircledDate    ${rowid}    ${CircleDate}    ${DNR_DATASET}

    ${HostBank_ShareAmount}    Circle Notebook Workflow Navigation    &{ExcelPath}[Primary_Lender1]    ${CircleDate}
    ...    Yes    &{ExcelPath}[Primary_Portfolio]    &{ExcelPath}[Primary_PortfolioBranch]    &{ExcelPath}[Primary_PortfolioAllocation]    ${PortfolioExpiry}    &{ExcelPath}[Deal_ExpenseCode]
    ${Lender_ShareAmount1}    Circle Notebook Workflow Navigation    &{ExcelPath}[Primary_Lender2]    ${CircleDate}
    ${Lender_ShareAmount2}    Circle Notebook Workflow Navigation    &{ExcelPath}[Primary_Lender3]    ${CircleDate}

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
