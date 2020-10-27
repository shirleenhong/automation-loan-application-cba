*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

***Keyword***

Portfolio Settled Discount Changes
    [Documentation]    This keyword is used to peform Portfolio Settled Discount Change/Adjustment to Balance of Discount/ 
    ...    Premium on settled Portfolio Position
    ...    @author:    sahalder    23JUL2020    initial create
    ...    @update:    mcastro     23OCT2020    - Added condition for RPA Scenario 1    
    [Arguments]    ${ExcelPath}
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Portfolio position Selection###
    ${Effective_date}    Get System Date
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Navigate to Portfolio Positions Notebook
    Select Portfolio Position    &{ExcelPath}[Portfolio_Position]
    Run Keyword If    '${Scenario}'=='1'    Run Keywords    Portfolio Settled Discount Change    &{ExcelPath}[Closed_Date]    &{ExcelPath}[Adjustment_Amount]
    ...    AND    GLOffset Details    &{ExcelPath}[GL_ShortName]    &{ExcelPath}[AwaitingDispose]    
    ...    ELSE    Run Keywords    Portfolio Settled Discount Change    ${Effective_date}    &{ExcelPath}[Adjustment_Amount]
    ...    AND    GLOffset Interest Income Details    &{ExcelPath}[GL_ShortName]
         

    ###Send transaction for approval###
    Send to Approval Portfolio Selection Discount Change  

    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Transaction in Process###
    Navigate Transaction in WIP    &{ExcelPath}[PFDC_Transaction_Type]    &{ExcelPath}[Transaction_Status_Awaiting_Approval]    &{ExcelPath}[PFDC_Payment_Type]    &{ExcelPath}[Deal_Name]    
    
    ###Portfolio Selection Discount Change Notebook###
    Approve Portfolio Selection Discount Change    
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Release Transaction###
    Launch Existing Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Navigate to Pending Portfolio Selection Discount Change
    
    ###Portfolio Selection Discount Change Notebook###
    Release Portfolio Selection Discount Change
    Verification of Portfolio Selection Discount Change Transaction
    Close All Windows on LIQ