*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***  
Set up Secondary Sale for Agency
    [Documentation]    This keyword is for setting up Secondary Sale for Agency for Syndicated Deal
    ...    @author: mgaling
    ...    @update: sahalder    19JUN2020    Updated keywords for new framework
    [Arguments]    ${ExcelPath}    
    ###Loan IQ Desktop###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Launch Deal Notebook###
    Search Existing Deal    &{ExcelPath}[Deal_Name]
    Check Deal Closing Commitment Amount    &{ExcelPath}[Deal_ClosingCmt]
    Check Host Bank Lender Share    &{ExcelPath}[HostBank_LegalEntity]    &{ExcelPath}[HostBank_AvailableShare]    
    
    ###Circle Selection Window###
    Launch Circle Select    &{ExcelPath}[CircleSelection_Transaction]
    Populate Circle Selection    &{ExcelPath}[Buy_Sell]    &{ExcelPath}[LenderShare_Type]    &{ExcelPath}[Buyer_Lender]    &{ExcelPath}[Buyer_Location]    &{ExcelPath}[Seller_LegalEntity]    &{ExcelPath}[Seller_Location]    
    ...    &{ExcelPath}[Seller_Riskbook]    &{ExcelPath}[Transaction_Type]    &{ExcelPath}[AssigFeeDecision] 
    
    ###Populate Circle Notebook###
    ${Sell_Amount}    Populate Facilities Tab    &{ExcelPath}[PctofDeal]    &{ExcelPath}[Deal_ClosingCmt]    &{ExcelPath}[Sell_Amount]    &{ExcelPath}[HostBank_AvailableShare]    &{ExcelPath}[Int_Fee]    &{ExcelPath}[PaidBy]    &{ExcelPath}[BuySell_Price]
    Write Data To Excel    TRP002_SecondarySale    Sell_Amount    ${rowid}    ${Sell_Amount}
    Populate Amts or Dates Tab    &{ExcelPath}[ExpectedCloseDate]
    Add Contacts    &{ExcelPath}[Buyer_Lender]    &{ExcelPath}[Buyer_Location]    &{ExcelPath}[Buyer_ContactName] 
    Add Servicing Groups    &{ExcelPath}[Buyer_Lender]    &{ExcelPath}[Seller_LegalEntity]
    
    
    
    ###Circle Notebook - Workflow Tab###
    Complete Assignment Fee Sell on Event Fees
    ###### Circling for Assignment Sell    &{ExcelPath}[Assignment_CircledDate]    
    Complete Portfolio Allocations for Assignment Sell    &{ExcelPath}[Seller_Riskbook]    &{ExcelPath}[Sell_Amount]        
    Assignment Send to Approval
    
    ###Circle Notebook - Workflow Tab###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Assignment Approval    &{ExcelPath}[WIPTransaction_Type]    &{ExcelPath}[Lender_Host]    &{ExcelPath}[CircleTransaction_Type]    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Assignment_CircledDate]    &{ExcelPath}[QualifiedBuyerCheckbox_Label]    
    
    ###Circle Notebook - Workflow Tab###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Process Funding Memo    &{ExcelPath}[WIPTransaction_Type]    &{ExcelPath}[Lender_Host]    &{ExcelPath}[CircleTransaction_Type]    &{ExcelPath}[Deal_Name]   
    Complete Funding Memo for Lender Share Adjustment    &{ExcelPath}[New_Loan_Alias]
    Assignment Send to Settlement Approval
    
    ###Circle Notebook - Workflow Tab###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Assignment Settlement Approval    &{ExcelPath}[WIPTransaction_Type]    &{ExcelPath}[Lender_Host]    &{ExcelPath}[CircleTransaction_Type]    &{ExcelPath}[Deal_Name] 
    Close Assignment Transaction    &{ExcelPath}[WIPTransaction_Type]    &{ExcelPath}[Lender_Host]    &{ExcelPath}[CircleTransaction_Type]    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Assignment_CircledDate] 
    #####Complete Cashflow in Assignment Transaction    &{ExcelPath}[Buyer_Lender]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Remittance_Status]
    
    ###Check the remaing lender share###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Search Existing Deal    &{ExcelPath}[Deal_Name]
    Check Host Bank Remaining Share    ${rowid}    &{ExcelPath}[HostBank_AvailableShare]    &{ExcelPath}[Sell_Amount]    &{ExcelPath}[HB_RemainingShare]    &{ExcelPath}[Contr_Gross]

Secondary Sale for Comprehensive Deal
    [Documentation]    This keyword is for setting up Secondary Sale for Scenario 8
    ...    @author: mnanquilada
    ...    @update: dahijara    27JUL2020    - Moved Percentage amount computation in a new keyword. Updated field names related to Lender 2
    [Arguments]    ${ExcelPath}

    ${percentageAmount1}    ${percentageAmount2}    ${percentageAmount3}    ${percentageAmount4}    ${totalRemainingAmount}    ${TotalpercentageAmount1}    ${TotalpercentageAmount2}    Compute Percentage Amounts for Secondary Sale for Comprehensive Deal    &{ExcelPath}[Term_Facility_2]    &{ExcelPath}[Currency]    &{ExcelPath}[Percentage_Multiplier_1]    &{ExcelPath}[rowid]
    ...    &{ExcelPath}[Term_Facility_1]    &{ExcelPath}[Percentage_Multiplier_2]

    ${Current_Date}    Get System Date
    Search for Deal    &{ExcelPath}[Deal_Name]
    
    ### Lender 1
    ###Open Circle Select in Deal Window
    Launch Circle Select    &{ExcelPath}[CircleSelection_Transaction]
    ###This will populate the circle notebok 
    Populate Circle Selection    &{ExcelPath}[Buy_Sell]    &{ExcelPath}[LenderShare_Type]    &{ExcelPath}[Buyer_Lender]    &{ExcelPath}[Buyer_Location]    &{ExcelPath}[Seller_LegalEntity]    &{ExcelPath}[Seller_Location]    
    ...    &{ExcelPath}[Seller_Riskbook]    &{ExcelPath}[Transaction_Type]    &{ExcelPath}[AssigFeeDecision]
    ###Populate Circle Notebook###
    Populate Facilities Lender Tab    &{ExcelPath}[rowid]    &{ExcelPath}[PctofDeal]    &{ExcelPath}[Deal_ClosingCmt]    &{ExcelPath}[HostBank_AvailableShare]    &{ExcelPath}[Int_Fee]    &{ExcelPath}[PaidBy]    &{ExcelPath}[BuySell_Price]
    Populate Amts or Dates Tab    ${Current_Date}
    Add Contacts    &{ExcelPath}[Buyer_Lender]    &{ExcelPath}[Buyer_Location]    &{ExcelPath}[Buyer_ContactName] 
    Add Servicing Group    &{ExcelPath}[Buyer_Lender]    
    ###Circle Notebook - Workflow Tab###
    Circling for Assignment Sell    ${Current_Date}
    Complete Portfolio Allocations for Pending Assignment Sell    &{ExcelPath}[Seller_Riskbook]    &{ExcelPath}[Term_Facility_1]    ${percentageAmount1}    &{ExcelPath}[Term_Facility_2]    ${percentageAmount2}
    Assignment Send to Approval
    
    ### Lender 2
    Launch Circle Select    &{ExcelPath}[CircleSelection_Transaction]
    ###This will populate the circle notebok 
    Populate Circle Selection    &{ExcelPath}[Buy_Sell]    &{ExcelPath}[LenderShare_Type]    &{ExcelPath}[Buyer_Lender_2]    &{ExcelPath}[Buyer_Location_2]    &{ExcelPath}[Seller_LegalEntity]    &{ExcelPath}[Seller_Location]    
    ...    &{ExcelPath}[Seller_Riskbook]    &{ExcelPath}[Transaction_Type]    &{ExcelPath}[AssigFeeDecision] 
    ###Populate Circle Notebook###
    Populate Facilities Lender Tab    &{ExcelPath}[rowid]    &{ExcelPath}[PctofDeal2]    &{ExcelPath}[Deal_ClosingCmt]    &{ExcelPath}[HostBank_AvailableShare]    &{ExcelPath}[Int_Fee]    &{ExcelPath}[PaidBy]    &{ExcelPath}[BuySell_Price]
    Populate Amts or Dates Tab    ${Current_Date}
    Add Contacts    &{ExcelPath}[Buyer_Lender_2]    &{ExcelPath}[Buyer_Location_2]    &{ExcelPath}[Buyer_ContactName_2] 
    Add Servicing Group    &{ExcelPath}[Buyer_Lender_2]    
    ###Circle Notebook - Workflow Tab###
    Circling for Assignment Sell    ${Current_Date}
    Complete Portfolio Allocations for Pending Assignment Sell    &{ExcelPath}[Seller_Riskbook]    &{ExcelPath}[Term_Facility_1]    ${percentageAmount3}    &{ExcelPath}[Term_Facility_2]    ${percentageAmount4}
    Assignment Send to Approval
    
    
    ### Approval / Send to Settlement Approval
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    ### Lender 1
    Navigate to Payment Notebook via WIP    &{ExcelPath}[WIPTransaction_Type]    Awaiting Approval   &{ExcelPath}[Lender_Host]    &{ExcelPath}[CircleTransaction_Type]    &{ExcelPath}[Buyer_Lender]
    Approve Assignment    ${Current_Date}    &{ExcelPath}[QualifiedBuyerCheckbox_Label]
    Assignment Send to Settlement Approval
    ### Lender 2
    Navigate to Payment Notebook via WIP    &{ExcelPath}[WIPTransaction_Type]    Awaiting Approval   &{ExcelPath}[Lender_Host]    &{ExcelPath}[CircleTransaction_Type]    &{ExcelPath}[Buyer_Lender_2]
    Approve Assignment    ${Current_Date}    &{ExcelPath}[QualifiedBuyerCheckbox_Label]                      
    Assignment Send to Settlement Approval
    
    
    ### Settlement Approval
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    ### Lender 1
    Navigate to Payment Notebook via WIP    &{ExcelPath}[WIPTransaction_Type]    Awaiting Settlement Approval   &{ExcelPath}[Lender_Host]    &{ExcelPath}[CircleTransaction_Type]    &{ExcelPath}[Deal_Name]
    Settlement Approval   
    Close Assignment Transaction    &{ExcelPath}[WIPTransaction_Type]    &{ExcelPath}[Lender_Host]    &{ExcelPath}[CircleTransaction_Type]    &{ExcelPath}[Deal_Name]    ${Current_Date}
    Validate Cash Flow
    ### Lender 2
    Navigate to Payment Notebook via WIP    &{ExcelPath}[WIPTransaction_Type]    Awaiting Settlement Approval   &{ExcelPath}[Lender_Host]    &{ExcelPath}[CircleTransaction_Type]    &{ExcelPath}[Deal_Name]
    Settlement Approval   
    Close Assignment Transaction    &{ExcelPath}[WIPTransaction_Type]    &{ExcelPath}[Lender_Host]    &{ExcelPath}[CircleTransaction_Type]    &{ExcelPath}[Deal_Name]    ${Current_Date}
    Validate Cash Flow
    
    
    ### Validate
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Search for Deal    &{ExcelPath}[Deal_Name]
    Validate Lender Query Amount    &{ExcelPath}[Buyer_Lender]    &{ExcelPath}[Currency]    &{ExcelPath}[Term_Facility_1]    ${percentageAmount1}    ${percentageAmount2}    &{ExcelPath}[Buyer_Lender_2]    &{ExcelPath}[Term_Facility_2]    ${percentageAmount3}    ${percentageAmount4}                   
    Validate Primaries Lender Share    &{ExcelPath}[Seller_LegalEntity]    &{ExcelPath}[Buyer_Lender]    &{ExcelPath}[Buyer_Lender_2]    ${totalRemainingAmount}    ${TotalpercentageAmount1}    ${TotalpercentageAmount2}
    Close All Windows on LIQ