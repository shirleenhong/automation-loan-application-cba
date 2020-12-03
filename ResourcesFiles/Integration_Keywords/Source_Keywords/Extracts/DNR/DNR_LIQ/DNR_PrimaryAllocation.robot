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