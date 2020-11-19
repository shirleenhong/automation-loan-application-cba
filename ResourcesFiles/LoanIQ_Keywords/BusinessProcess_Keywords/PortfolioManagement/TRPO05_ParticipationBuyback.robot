*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables *** 

***Keyword***

Complete External Participation Buyback without Premiun/Discount
    [Documentation]    This keyword is used to Complete an external participation buyback with no premium or discount for a closed deal
    ...    @author:    dahijara    16NOV2020    initial create 
    [Arguments]    ${ExcelPath}

    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    ${CurrentDate}    Get System Date
    Search for Deal    &{ExcelPath}[Deal_Name]
    ### External Lender 1 ###
    ### Complete Participation ###
    Launch Circle Select    &{ExcelPath}[CircleSelection_Transaction]
    Populate Circle Selection    &{ExcelPath}[Buy_Sell]    &{ExcelPath}[LenderShare_Type]    &{ExcelPath}[Seller_Lender]    &{ExcelPath}[Buyer_Location]    &{ExcelPath}[Buyer_Lender]    &{ExcelPath}[Seller_Location]    
    ...    &{ExcelPath}[Buyer_Riskbook]    &{ExcelPath}[Transaction_Type]    &{ExcelPath}[AssigFeeDecision]
    Populate Participation Details    &{ExcelPath}[Pct_of_Deal]    &{ExcelPath}[Int_Fee]    &{ExcelPath}[Buy_Sell_Price]
    ${Buy_Sell_Amount}    Validate Displayed Buy Amount for Participation
    Write Data To Excel    TRPO05_ExtParticipationBuyBack    Buy_Sell_Amount    ${rowid}    ${Buy_Sell_Amount}
    Validate Buy/Sell Price of Facility for Participation    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Buy_Sell_Price]

    ### Complete Amts/Debts tab ###
    Populate Participation Amts/Debts    ${CurrentDate}    ${Buy_Sell_Amount}
    
    ### Complete Contacts Tab ###
    Add Contacts for Participation    &{ExcelPath}[Seller_Lender]    &{ExcelPath}[Buyer_Lender]    

    ### Circle Notebook - Workflow Tab ###
    Complete Circling for Participation    ${CurrentDate}
    Navigate Portfolio Allocations Workflow for Pending Participation
    Complete Portfolio Allocations Workflow for Participation Buy    &{ExcelPath}[Buyer_Portfolio]    &{ExcelPath}[Buyer_ExpenseCode]    &{ExcelPath}[Buyer_Branch]    &{ExcelPath}[Facility_Name]
    Send Participation for Approval
    
    ### Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    ### Lender 1 ###
    Navigate to Participation Workflow and Proceed With Transaction    ${AWAITING_APPROVAL_STATUS}    &{ExcelPath}[Deal_Name]    ${APPROVAL_STATUS}

    ### Send to Settlement Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    ### Lender 1 ###
    Navigate to Participation Workflow and Proceed With Transaction    ${AWAITING_FUNDING_MEMO_STATUS}    &{ExcelPath}[Deal_Name]    ${FUNDING_MEMO_WORKFLOW}
    Navigate to Participation Workflow and Proceed With Transaction    ${AWAITING_SEND_TO_SETTLEMENT_APPROVAL_TRANSACTION}    &{ExcelPath}[Deal_Name]    ${SEND_TO_SETTLEMENT_APPROVAL_WORKFLOW}

    ### Settlement Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    ### Lender 1 ###
    Navigate to Participation Workflow and Proceed With Transaction    ${AWAITING_SETTLEMENT_APPROVAL_STATUS}    &{ExcelPath}[Deal_Name]    ${SETTLEMENT_APPROVAL_STATUS}
    
    ### Close Transaction ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    ### Lender 1 ###
    Navigate to Participation Workflow and Proceed With Transaction    ${AWAITING_CLOSE_TRANSACTION}    &{ExcelPath}[Deal_Name]    ${RELEASE_CASHFLOWS_TYPE}
    Navigate to Participation Workflow and Proceed With Transaction    ${AWAITING_CLOSE_TRANSACTION}    &{ExcelPath}[Deal_Name]    ${CLOSE_WORKFLOW}    ${CurrentDate}    &{ExcelPath}[Cust_Portfolio]