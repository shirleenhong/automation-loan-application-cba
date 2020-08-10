*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

***Keyword***

Portfolio Trade Date Discount Change
    [Documentation]    This keyword is used to Change Portfolio Trade Date Discount
    ...    @ author:Archana
    [Arguments]    ${Excelpath}
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Deal Notebook###
    ${Effective_date}    Get System Date    
    Open Existing Deal    &{ExcelPath}[Deal_Name]        
    Navigate to Portfolio Positions Notebook
    Select Portfolio Position and Make Adjustment    &{ExcelPath}[Portfolio_Position]
    ${CurrentAmount}    Portfolio Trade Date Discount Change Details    ${Effective_date}    &{ExcelPath}[Adjustment_Amount]
    
    ###Send Transaction to approval###
    Send to Approval Portfolio Trade Date Discount Change
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Transaction in Process###    
    Navigate Transaction in WIP    &{ExcelPath}[Transaction_Type]    &{ExcelPath}[Transaction_Status_Awaiting_Approval]    &{ExcelPath}[Type]    &{ExcelPath}[Deal_Name]
    
    ###Upfront Fee Payment Notebook###
    Approve Portfolio Trade Date Discount Change
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Release Transaction###
    Open Existing Deal    &{ExcelPath}[Deal_Name]    
    Open Facility From Deal Notebook    &{ExcelPath}[Facility_Name]
    Navigate to Pending Portfolio Trade Date Discount Change
    ${New_Amount}    Release Portfolio Trade Date Discount Change
    Validate Events Tab for Portfolio Trade Date Discount Change
    
    ${Adjustment_Amount}    Read Data From Excel    TRPO13_PortfolioTradeDiscChange    Adjustment_Amount    ${rowid}   
    Validation of Adjusted Amount    ${CurrentAmount}    ${New_Amount}    ${Adjustment_Amount}
    Close All Windows on LIQ 