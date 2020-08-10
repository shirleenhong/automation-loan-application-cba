*** Settings ***
Resource   ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***

Deal Change Transaction on Financial Ratio
    [Documentation]    This keyword will perform deal change transaction on financial ratio
    ...    @author: mnanquilada
    [Arguments]    ${ExcelPath}
    
    ###Loan IQ Desktop###
    ${Current_Date}    Get System Date
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ###Deal Notebook - General Tab###               
    Validate Status of Deal and Navigate to Deal Change Transaction
    Verify If Warning Is Displayed
    
    ###Deal Change Transaction - General Tab###      
    Add Financial Ratio Deal Change Transaction    &{ExcelPath}[Financial_Ratio_Type]    &{ExcelPath}[Financial_Ratio]    ${Current_Date}    &{ExcelPath}[Financial_Ratio_Type]             
    
    ###Deal Change Transaction - Workflow Tab###
    Send Approval Deal Change Transaction    ${Current_Date}

    ###Loan IQ Desktop###  
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Open Existing Deal    &{ExcelPath}[Deal_Name]
     
    ###Deal Notebook - General Tab###               
    Validate Status of Deal and Navigate to Deal Change Transaction
    
    ###Deal Change Transaction - Workflow Tab###  
    Approve Deal Change Transaction
    
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}    
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ###Deal Notebook - General Tab###          
    Validate Status of Deal and Navigate to Deal Change Transaction
    Release Deal Change Transaction
    
    ###Deal Notebook - Ratio/Conds###  
    Validate added financial ratio on the deal    &{ExcelPath}[Financial_Ratio_Type]
    
    ### @update    bernchua    04DEC2018    Scnenario 8 integration. Go back to original user.
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
