*** Settings ***
Resource     ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Perform Lender Share Adjustment
    [Documentation]    This keyword performs lender share adjustment to a deal
    ...    @author: ghabal
    ...    @update: amansuet    26JUN2020    - added new keywords and update existing to handle correct flow
    [Arguments]    ${ExcelPath}
    
    ###Logout and Relogin in Inputter Level###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ${AssignmentSell_CircledDate}    Get System Date
    Write Data To Excel    AMCH02_LenderShareAdjustment    AssignmentSell_CircledDate    ${rowid}    ${SystemDate}
    
    ###Search Deal###
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ###Pending Sell Assignment notebook - Facilities tab###
    Create Assignment Sell    &{ExcelPath}[LenderShare_Type]    &{ExcelPath}[Lender_ShortName]   &{ExcelPath}[AssignmentSell_PercentofDeal]     &{ExcelPath}[Seller_Riskbook]    &{ExcelPath}[AssignmentSell_IntFeeType]    &{ExcelPath}[BuyandSellPrice_Percentage]
    ${Facility_SellAmount}    Get Sell Amount from Pending Assignment Sell    &{ExcelPath}[Facility_Name]
    ${Facility_SellAmount2}    Get Sell Amount from Pending Assignment Sell    &{ExcelPath}[Facility_Name2]
    Write Data To Excel    AMCH02_LenderShareAdjustment    Facility_SellAmount    ${rowid}    ${Facility_SellAmount}
    Write Data To Excel    AMCH02_LenderShareAdjustment    Facility_SellAmount2    ${rowid}    ${Facility_SellAmount2}
    Set To Dictionary    ${ExcelPath}    Facility_SellAmount=${Facility_SellAmount}
    Set To Dictionary    ${ExcelPath}    Facility_SellAmount2=${Facility_SellAmount2}
    ${Actual_DisplayedSellAmount}    Validate Displayed Sell Amount and Return Value
    
    ###Pending Sell Assignment notebook - Amts/Dates tab###
    Validate Displayed 'Sell Amount' in the Amts/Dates tab    ${Actual_DisplayedSellAmount}    ${AssignmentSell_CircledDate}
    
    ###Pending Sell Assignment notebook - Contacts tab###     
    Add Contact in Pending Assignment Sell    &{ExcelPath}[AssignmentSell_ContactName]    &{ExcelPath}[Lender_ShortName]
    Add Servicing Group in Pending Assignment Sell    &{ExcelPath}[AssignmentSell_SGLender]    &{ExcelPath}[AssignmentSell_SGAlias]

    ###Pending Sell Assignment notebook - Worfklow tab###       
    Write Data To Excel    AMCH02_LenderShareAdjustment    AssignmentSell_CircledDate    ${rowid}    ${AssignmentSell_CircledDate}
    Set To Dictionary    ${ExcelPath}    AssignmentSell_CircledDate=${AssignmentSell_CircledDate}
    Circling for Pending Assignment Sell    &{ExcelPath}[AssignmentSell_CircledDate]
    Complete Portfolio Allocations Workflow for Pending Assignment Sell for Agency Deal    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Facility_Name2]
    Send to Approval for Pending Assignment Sell

    ###Logout and Relogin in Supervisor Level###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD} 
    
    ###Pending Sell Assignment notebook - Worfklow tab###
    Approval for Pending Assignment Sell    &{ExcelPath}[Deal_Name]
    Close All Windows on LIQ

    ###Logout and Relogin in Inputter Level###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Open Sell Assignment notebook - Worfklow tab###
    Process Funding Memo    &{ExcelPath}[WIPTransaction_Type]    &{ExcelPath}[Lender_Host]    &{ExcelPath}[CircleTransaction_Type]    &{ExcelPath}[Deal_Name]  
    Complete Funding Memo for Lender Share Adjustment    &{ExcelPath}[New_Loan_Alias]
     
    ###Open Sell Assignment notebook - Worfklow tab###
    Send to Settlement Approval for Open Assignment Sell
        
    ###Logout and Relogin in Supervisor Level###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ###Open/Awaiting Settlement Approval Sell Assignment notebook - Worfklow tab###
    Settlement Approval for Open/Awaiting Settlement Approval Assignment Sell    &{ExcelPath}[Deal_Name]
    
    ###Open/Settlement Approved Sell Assignment notebook - Worfklow tab###
    Close for Open/Settlement Approved Assignment Sell
    
    ###Logout and Relogin in Inputter Level###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
