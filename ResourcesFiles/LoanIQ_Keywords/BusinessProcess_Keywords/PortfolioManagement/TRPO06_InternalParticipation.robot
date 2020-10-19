*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${facility_count}    3 

***Keyword***
Complete Internal Participation
    [Documentation]    This keyword is used to Complete Internal Participation For A Closed Deal
    ...    @author:    mcastro    14OCT2020    initial create 
    [Arguments]    ${ExcelPath}
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Create New Internal Participation    &{ExcelPath}[LenderShare_Type]    &{ExcelPath}[Buyer_LegalEntity]    &{ExcelPath}[Seller_LegalEntity]    &{ExcelPath}[Buyer_RiskBook]    &{ExcelPath}[Seller_RiskBook]
    
    ## Complete Pending Participation Sell Window ###
    Populate Pending Participation Sell    &{ExcelPath}[Pct_of_Deal]    &{ExcelPath}[Int_Fee]    &{ExcelPath}[Buy_Sell_Price]
    Validate Displayed Sell Amount From Participation Sell      
    Validate Buy/Sell Price For Facilities On Participation Sell    &{ExcelPath}[Buy_Sell_Price]
    
    ### Complete Amts/Debts tab ###
    Populate Pending Participation Amts/Debts    &{ExcelPath}[Expected_CloseDate]    &{ExcelPath}[Buy_Sell_Amount]       
    
    ### Complete Contacts Tab ###
    Add Contacts For Participation Sell    &{ExcelPath}[Buyer_LegalEntity]    &{ExcelPath}[Seller_LegalEntity]    &{ExcelPath}[Buyer_Contact]    &{ExcelPath}[Seller_Contact]    
    
    ### Complete Fee Decisions ###
    Complete Circle Fee Decisions
    
    ### Pending Participation Sell Workflow ###
    Complete Circling for Pending Participation Sell    &{ExcelPath}[Expected_CloseDate]
    
    Complete Portfolio Allocations Workflow for Pending Participation Sell    #Incomplete#    
    Send to Approval Internal Participation Sell
    
    ### Participation Buy Window ###
    Validate Pending Participation Buy    &{ExcelPath}[Buyer_LegalEntity]    &{ExcelPath}[Buy_Sell_Amount]    &{ExcelPath}[Expected_CloseDate]
    
    ### Pending Participation Buy Workflow ###
    Complete Portfolio Allocations Workflow for Pending Participation Buy    #Incomplete#
    Send to Approval Internal Participation Buy
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ##Transaction in Process###
    Approval For Internal Participation Buy    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Buyer_LegalEntity]
    Approval For Internal Participation Sell    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Buyer_LegalEntity]
   
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Release Transaction###
    #For completion#
   

