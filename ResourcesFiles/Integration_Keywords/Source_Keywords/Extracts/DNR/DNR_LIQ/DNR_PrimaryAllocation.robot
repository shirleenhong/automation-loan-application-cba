*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Setup Primaries for Syndicated Deal for DNR
    [Documentation]    This keyword adds Lenders in a Syndicated Deal. Specifically, 1 Host Bank and 2 Non-Host Banks.
    ...    @author: fluberio    25NOV2020    initial create
    [Arguments]    ${ExcelPath}
    
    ###Primary Lender - Host Bank###
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
    
    ##Write Lenders Share Amount to Excel for Share Adjustment###
    
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