*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${SCENARIO}

*** Keywords ***
Deal Change Transaction on Financial Ratio for D00000454
    [Documentation]    This keyword will perform deal change transaction on financial ratio
    ...    @author: fmamaril    10SEP2019    Initial Create
    [Arguments]    ${ExcelPath}
    ###Loan IQ Desktop###
    ${Current_Date}    Get System Date
    Search for Deal    &{ExcelPath}[Deal_Name]
    
    ###Deal Notebook - General Tab###               
    Validate Status of Deal and Navigate to Deal Change Transaction
    Verify If Warning Is Displayed
    
    ###Deal Change Transaction - General Tab###      
    Modify Financial Ratio via Deal Change Transaction    &{ExcelPath}[Financial_Ratio]    &{ExcelPath}[Financial_Ratio_Type]             
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}    
    Set Test Variable    ${SCREENSHOT_FILENAME}    UATDEAL1-DealChangeTransaction
    Take Screenshot    ${SCREENSHOT_FILENAME}
    
    ###Deal Change Transaction - Workflow Tab###
    Send Approval Deal Change Transaction    ${Current_Date}

    ###Loan IQ Desktop###  
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Search for Deal    &{ExcelPath}[Deal_Name]
     
    ###Deal Notebook - General Tab###               
    Validate Status of Deal and Navigate to Deal Change Transaction
    
    ###Deal Change Transaction - Workflow Tab###  
    Approve Deal Change Transaction
    
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    Search for Deal    &{ExcelPath}[Deal_Name]
    ###Deal Notebook - General Tab###          
    Validate Status of Deal and Navigate to Deal Change Transaction
    Release Deal Change Transaction
    
    ###Deal Notebook - Ratio/Conds###  
    Validate added financial ratio on the deal    &{ExcelPath}[Financial_Ratio]
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
