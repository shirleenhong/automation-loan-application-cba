*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables *** 

***Keyword***
Complete Internal Participation
    [Documentation]    This keyword is used to Complete Internal Participation For A Closed Deal with 3 facilities
    ...    @author:    mcastro    14OCT2020    initial create 
    ...    @update:    mcastro    10NOV2020    Updated steps to read and write data from this business process keyword, deleted unecessary validation
    [Arguments]    ${ExcelPath}
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    ### Read Data from Excel ###
    ${Facility1}    Read Data From Excel    TRPO06_InternalParticipation    Facility_Name    ${rowid}
    ${Facility2}    Read Data From Excel    TRPO06_InternalParticipation    Facility_Name    2
    ${Facility3}    Read Data From Excel    TRPO06_InternalParticipation    Facility_Name    3

    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Create New Internal Participation    &{ExcelPath}[LenderShare_Type]    &{ExcelPath}[Buyer_LegalEntity]    &{ExcelPath}[Seller_LegalEntity]    &{ExcelPath}[Buyer_RiskBook]    &{ExcelPath}[Seller_RiskBook]
    
    ### Complete Pending Participation Sell Window ###
    Populate Pending Participation Sell    &{ExcelPath}[Pct_of_Deal]    &{ExcelPath}[Int_Fee]    &{ExcelPath}[Buy_Sell_Price]
    ${Buy_Sell_Amount}    Validate Displayed Sell Amount From Participation Sell      
    Write Data To Excel    TRPO06_InternalParticipation    Buy_Sell_Amount    ${rowid}    ${Buy_Sell_Amount}
    Validate Buy/Sell Price For Facilities On Participation Sell    &{ExcelPath}[Buy_Sell_Price]    ${Facility1}|${Facility2}|${Facility3}
    
    ### Complete Amts/Debts tab ###
    Populate Pending Participation Amts/Debts    &{ExcelPath}[Expected_CloseDate]    &{ExcelPath}[Buy_Sell_Amount]       
    
    ### Complete Contacts Tab ###
    Add Contacts For Participation Sell    &{ExcelPath}[Buyer_LegalEntity]    &{ExcelPath}[Seller_LegalEntity]    
    
    ### Complete Fee Decisions ###
    Complete Circle Fee Decisions    ${Facility1}|${Facility2}|${Facility3}
    
    ### Pending Participation Sell Workflow ###
    Complete Circling for Pending Participation Sell    &{ExcelPath}[Expected_CloseDate]  
    Complete Portfolio Allocations Workflow for Pending Participation Sell    ${Facility1}|${Facility2}|${Facility3}    
       
    ### Participation Buy Window ###
    Navigate To Participation Buy
    Validate Pending Participation Buy    &{ExcelPath}[Buyer_LegalEntity]    &{ExcelPath}[Buy_Sell_Amount]    &{ExcelPath}[Expected_CloseDate]
    
    ### Pending Participation Buy Workflow ###
    Complete Portfolio Allocations Workflow for Pending Participation Buy    &{ExcelPath}[Buyer_Portfolio]    &{ExcelPath}[Buyer_ExpenseCode]    &{ExcelPath}[Buyer_Branch]    ${Facility1}|${Facility2}|${Facility3}
    Validate Fee Decisions For All Facilities
    
    ### Send To Approval ###
    Send to Approval Internal Participation Buy
    Close All Windows on LIQ    
    
    ### Internal Participation Buy Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Approval For Internal Participation Buy    &{ExcelPath}[Deal_Name]
    
    ### Internal Participation Sell Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Approval For Internal Participation Sell    &{ExcelPath}[Deal_Name]
    Close All Windows on LIQ

    ### Send to Settlement Approval For Participation ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Funding Memo for Pending Participation    &{ExcelPath}[Deal_Name]
    Send to Settlement Approval For Pending Participation    ${ExcelPath}[Deal_Name]  
   
    ### Settlement Approval Participation Buy ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Settlement Approval For Internal Participation Buy    &{ExcelPath}[Deal_Name]
    
    ### Settlement Approval For Participation Sell ###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Settlement Approval For Internal Participation Sell    ${ExcelPath}[Deal_Name]
    
    ### Close Transaction ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Close For Internal Participation    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Expected_CloseDate] 
    Validate GL Entries For Internal Participation    &{ExcelPath}[Buyer_LegalEntity]    &{ExcelPath}[Seller_LegalEntity]
   
Complete External Participation
    [Documentation]    This keyword is used to Complete External Participation For A Closed Deal with 3 facilities
    ...    @author:    mcastro    05NOV2020    initial create 
    [Arguments]    ${ExcelPath}
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    ### Read Data from Excel ###
    ${Facility1}    Read Data From Excel    TRPO06_ExternalParticipation    Facility_Name    ${rowid}
    ${Facility2}    Read Data From Excel    TRPO06_ExternalParticipation    Facility_Name    2
    ${Facility3}    Read Data From Excel    TRPO06_ExternalParticipation    Facility_Name    3

    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Create New External Participation    &{ExcelPath}[LenderShare_Type]    &{ExcelPath}[Buyer_LegalEntity]    &{ExcelPath}[Seller_LegalEntity]    &{ExcelPath}[Seller_RiskBook]
    
    ### Complete Pending Participation Sell Window ###
    Populate Pending Participation Sell    &{ExcelPath}[Pct_of_Deal]    &{ExcelPath}[Int_Fee]    &{ExcelPath}[Buy_Sell_Price]
    ${Buy_Sell_Amount}    Validate Displayed Sell Amount From Participation Sell  
    Write Data To Excel    TRPO06_ExternalParticipation    Buy_Sell_Amount    ${rowid}    ${Buy_Sell_Amount}   
    Validate Buy/Sell Price For Facilities On Participation Sell    &{ExcelPath}[Buy_Sell_Price]    ${Facility1}|${Facility2}|${Facility3}
    
    ### Complete Amts/Debts tab ###
    Populate Pending Participation Amts/Debts    &{ExcelPath}[Expected_CloseDate]    &{ExcelPath}[Buy_Sell_Amount]       
    
    ### Complete Contacts Tab ###
    Add Contacts For Participation Sell    &{ExcelPath}[Buyer_LegalEntity]    &{ExcelPath}[Seller_LegalEntity]    
    
    ### Complete Fee Decisions ### 
    Complete Circle Fee Decisions    ${Facility1}|${Facility2}|${Facility3}
    
    ### Pending Participation Sell Workflow ###
    Complete Circling for Pending Participation Sell    &{ExcelPath}[Expected_CloseDate]  
    Complete Portfolio Allocations Workflow for Pending Participation Sell    ${Facility1}|${Facility2}|${Facility3} 
    Send to Approval Internal Participation Sell

    ## External Participation Sell Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Approval For Internal Participation Sell    &{ExcelPath}[Deal_Name]
    Close All Windows on LIQ

    ### Send to Settlement Approval For Participation ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Funding Memo for Pending Participation    &{ExcelPath}[Deal_Name]
    Send to Settlement Approval For Pending Participation    ${ExcelPath}[Deal_Name]  

    ### Settlement Approval For Participation Sell ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Settlement Approval For Internal Participation Sell    ${ExcelPath}[Deal_Name]

    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Release Cashflow For Participation    ${ExcelPath}[Deal_Name]
    
    ### Close Transaction ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Close For Internal Participation    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Expected_CloseDate] 
    Validate GL Entries For External Participation    &{ExcelPath}[Buyer_LegalEntity]
   
Complete External Participation without Premiun/Discount
    [Documentation]    This keyword is used to Complete an external participation with no premium or discount for a closed deal
    ...    This keyword completes 2 external participations
    ...    @author: dahijara    09NOV2020    initial create 
    ...    @update: dahijara    17NOV2020    updated keyword name for Navigate Portfolio Allocations Workflow for Pending Participation
    [Arguments]    ${ExcelPath}

    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Search for Deal    &{ExcelPath}[Deal_Name]
    
    ### External Lender 1 ###
    ### Complete Participation ###
    Launch Circle Select    &{ExcelPath}[CircleSelection_Transaction]
    Populate Circle Selection    &{ExcelPath}[Buy_Sell]    &{ExcelPath}[LenderShare_Type]    &{ExcelPath}[Buyer_Lender]    &{ExcelPath}[Buyer_Location]    &{ExcelPath}[Seller_LegalEntity]    &{ExcelPath}[Seller_Location]    
    ...    &{ExcelPath}[Seller_Riskbook]    &{ExcelPath}[Transaction_Type]    &{ExcelPath}[AssigFeeDecision]
    Populate Pending Participation Sell    &{ExcelPath}[Pct_of_Deal]    &{ExcelPath}[Int_Fee]    &{ExcelPath}[Buy_Sell_Price]
    ${Buy_Sell_Amount}    Validate Displayed Sell Amount From Participation Sell
    Write Data To Excel    TRPO06_ExternalParticipation    Buy_Sell_Amount    ${rowid}    ${Buy_Sell_Amount}
    Validate Buy/Sell Price For a Facility    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Buy_Sell_Price]

    ### Complete Amts/Debts tab ###
    Populate Pending Participation Amts/Debts    &{ExcelPath}[Expected_CloseDate]    ${Buy_Sell_Amount}       
    
    ### Complete Contacts Tab ###
    Add Contacts For Participation Sell    &{ExcelPath}[Buyer_Lender]    &{ExcelPath}[Seller_LegalEntity]    

    ### Circle Notebook - Workflow Tab ###
    Complete Circling for Pending Participation Sell    &{ExcelPath}[Expected_CloseDate]  
    Navigate Portfolio Allocations Workflow for Pending Participation
    Populate Portfolio Allocations For A Facility    &{ExcelPath}[Facility_Name]
    Close Portfolio Allocation Notebook
    Send to Approval Internal Participation Sell
    Close Participation Window

    ### External Lender 2 ###
    ### Complete Participation ###
    Launch Circle Select    &{ExcelPath}[CircleSelection_Transaction]
    Populate Circle Selection    &{ExcelPath}[Buy_Sell]    &{ExcelPath}[LenderShare_Type]    &{ExcelPath}[Buyer_Lender2]    &{ExcelPath}[Buyer_Location2]    &{ExcelPath}[Seller_LegalEntity]    &{ExcelPath}[Seller_Location]    
    ...    &{ExcelPath}[Seller_Riskbook]    &{ExcelPath}[Transaction_Type]    &{ExcelPath}[AssigFeeDecision]
    Populate Pending Participation Sell    &{ExcelPath}[Pct_of_Deal2]    &{ExcelPath}[Int_Fee2]    &{ExcelPath}[Buy_Sell_Price2]
    ${Buy_Sell_Amount2}    Validate Displayed Sell Amount From Participation Sell
    Write Data To Excel    TRPO06_ExternalParticipation    Buy_Sell_Amount2    ${rowid}    ${Buy_Sell_Amount2}
    Validate Buy/Sell Price For a Facility    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Buy_Sell_Price2]

    ### Complete Amts/Debts tab ###
    Populate Pending Participation Amts/Debts    &{ExcelPath}[Expected_CloseDate]    ${Buy_Sell_Amount2}       
    
    ### Complete Contacts Tab ###
    Add Contacts For Participation Sell    &{ExcelPath}[Buyer_Lender2]    &{ExcelPath}[Seller_LegalEntity]    

    ### Circle Notebook - Workflow Tab ###
    Complete Circling for Pending Participation Sell    &{ExcelPath}[Expected_CloseDate]  
    Navigate Portfolio Allocations Workflow for Pending Participation
    Populate Portfolio Allocations For A Facility    &{ExcelPath}[Facility_Name]
    Close Portfolio Allocation Notebook
    Send to Approval Internal Participation Sell
    Close Participation Window
    
    ### Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    ### Lender 1 ###
    Navigate to Participation Workflow and Proceed With Transaction    ${AWAITING_APPROVAL_STATUS}    &{ExcelPath}[Buyer_Lender]    ${APPROVAL_STATUS}
    ### Lender 2 ###
    Navigate to Participation Workflow and Proceed With Transaction    ${AWAITING_APPROVAL_STATUS}    &{ExcelPath}[Buyer_Lender2]    ${APPROVAL_STATUS}

    ### Send to Settlement Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    ### Lender 1 ###
    Navigate to Participation Workflow and Proceed With Transaction    ${AWAITING_SEND_TO_SETTLEMENT_APPROVAL_TRANSACTION}    &{ExcelPath}[Buyer_Lender]    ${SEND_TO_SETTLEMENT_APPROVAL_WORKFLOW}
    ### Lender 2 ###
    Navigate to Participation Workflow and Proceed With Transaction    ${AWAITING_SEND_TO_SETTLEMENT_APPROVAL_TRANSACTION}    &{ExcelPath}[Buyer_Lender2]    ${SEND_TO_SETTLEMENT_APPROVAL_WORKFLOW}

    ### Settlement Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    ### Lender 1 ###
    Navigate to Participation Workflow and Proceed With Transaction    ${AWAITING_SETTLEMENT_APPROVAL_STATUS}    &{ExcelPath}[Buyer_Lender]    ${SETTLEMENT_APPROVAL_STATUS}
    ### Lender 2 ###
    Navigate to Participation Workflow and Proceed With Transaction    ${AWAITING_SETTLEMENT_APPROVAL_STATUS}    &{ExcelPath}[Buyer_Lender2]    ${SETTLEMENT_APPROVAL_STATUS}
    
    ### Close Transaction ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    ### Lender 1 ###
    Navigate to Participation Workflow and Proceed With Transaction    ${AWAITING_CLOSE_TRANSACTION}    &{ExcelPath}[Buyer_Lender]    ${CLOSE_WORKFLOW}    &{ExcelPath}[Expected_CloseDate]    &{ExcelPath}[Cust_Portfolio]
    ### Lender 2 ###
    Navigate to Participation Workflow and Proceed With Transaction    ${AWAITING_CLOSE_TRANSACTION}    &{ExcelPath}[Buyer_Lender2]    ${CLOSE_WORKFLOW}    &{ExcelPath}[Expected_CloseDate]    &{ExcelPath}[Cust_Portfolio]