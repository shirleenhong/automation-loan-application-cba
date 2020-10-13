*** Settings ***
Resource     ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Setup Deal Administrative Fees
    [Documentation]    This keyword is for adding Administrative Fees from the Deal Notebook's Admin/Event Fees tab.
    ...    @author: bernchua
    [Arguments]    ${ExcelPath}
        
    ###Deal Notebook###
    ${AdminFee_EffectiveDate}    Get System Date
    Write Data To Excel    CRED09_AdminFee    AdminFee_EffectiveDate    ${rowid}    ${AdminFee_EffectiveDate}
    Run Keyword If    "${SCENARIO}"=="2"    Write Data To Excel    AMCH10_ChangeAgencyFee    AdminFeeChange_EffectiveDate    ${rowid}    ${AdminFee_EffectiveDate}
    
    Search Existing Deal    &{ExcelPath}[Deal_Name]
    Add Admin Fee in Deal Notebook    &{ExcelPath}[AdminFee_IncomeMethod]
    Set General Tab Details in Admin Fee Notebook    &{ExcelPath}[AdminFee_FlatAmount]    ${AdminFee_EffectiveDate}    &{ExcelPath}[AdminFee_PeriodFrequency]
    ...    &{ExcelPath}[AdminFee_ActualDueDate]    &{ExcelPath}[AdminFee_BillNoOfDays]
    Set Distribution Details in Admin Fee Notebook    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[AdminFee_CustomerLocation]    &{ExcelPath}[AdminFee_ExpenseCode]    &{ExcelPath}[AdminFee_PercentOfFee]
    
    ${AdminFee_Alias}    Copy Alias To Clipboard and Get Data    ${LIQ_AdminFeeNotebook_Window}
    ${AdminFee_DueDate}    Get Admin Fee Due Date
    Write Data To Excel    CRED09_AdminFee    AdminFee_Alias    ${rowid}    ${AdminFee_Alias}
    Write Data To Excel    SERV30_AdminFeePayment    AdminFee_Alias    ${rowid}    ${AdminFee_Alias}
    Run Keyword If    "${SCENARIO}"=="2"    Write Data To Excel    AMCH10_ChangeAgencyFee    AdminFee_Alias    ${rowid}    ${AdminFee_Alias}
    Write Data To Excel    SERV30_AdminFeePayment    AdminFee_DueDate    ${rowid}    ${AdminFee_DueDate}
    Run Keyword If    "${SCENARIO}"=="2"    Write Data To Excel    AMCH10_ChangeAgencyFee    AdminFee_Alias    ${rowid}    ${AdminFee_Alias}
    
    ###Send to Approval###
    Navigate Notebook Workflow    ${LIQ_AdminFeeNotebook_Window}    ${LIQ_AdminFeeNotebook_JavaTab}    ${LIQ_AdminFeeNotebook_Workflow_JavaTree}    Send to Approval
    mx LoanIQ close window    ${LIQ_AdminFeeNotebook_Window}
    Save Notebook Transaction    ${LIQ_DealNotebook_Window}    ${LIQ_DealNotebook_File_Save}
       
    ###Approve Admin Fee###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate Transaction in WIP    Deals    Awaiting Approval    Amortizing Admin Fee    &{ExcelPath}[Deal_Name]
    Navigate Notebook Workflow    ${LIQ_AdminFeeNotebook_Window}    ${LIQ_AdminFeeNotebook_JavaTab}    ${LIQ_AdminFeeNotebook_Workflow_JavaTree}    Approval
    
    ###Verify Admin Fee if successfully Added###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    ${AdminFee_Alias}    Read Data From Excel    CRED09_AdminFee    AdminFee_Alias    &{ExcelPath}[rowid]
    Validate Admin Fee If Added    ${AdminFee_Alias}
    Save Notebook Transaction    ${LIQ_DealNotebook_Window}    ${LIQ_DealNotebook_File_Save}

Setup Admin Fees for Comprehensive Deal
    [Documentation]    This keyword is for adding Administrative Fees from the Deal Notebook's Admin/Event Fees tab.
    ...    @author: bernchua
    ...    @update: ehugo    29JUN2020    - used 'Navigate to Admin Fee Workflow and Proceed With Transaction' instead of 'Navigate Notebook Workflow'
    [Arguments]    ${ExcelPath}
    
    ${Admin_EffectiveDate}    Get System Date
    ${Admin_ActualDueDate}    Get System Date
    Add Admin Fee in Deal Notebook    &{ExcelPath}[AdminFee_IncomeMethod]
    Set General Tab Details in Admin Fee Notebook    &{ExcelPath}[AdminFee_FlatAmount]    ${Admin_EffectiveDate}    &{ExcelPath}[AdminFee_PeriodFrequency]    ${Admin_ActualDueDate}    &{ExcelPath}[AdminFee_BillNoOfDays]
    Set Distribution Details in Admin Fee Notebook    &{ExcelPath}[AdminFee_Customer]    &{ExcelPath}[AdminFee_CustomerLocation]    &{ExcelPath}[AdminFee_ExpenseCode]    &{ExcelPath}[AdminFee_PercentOfFee]
    Navigate to Admin Fee Workflow and Proceed With Transaction    Send to Approval
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate Transaction in WIP    Deals    Awaiting Approval    Amortizing Admin Fee    &{ExcelPath}[Deal_Name]
    Navigate to Admin Fee Workflow and Proceed With Transaction    Approval
    Logout from Loan IQ
    
Setup Deal Agency Fee
    [Documentation]    This keyword is for adding Agency Fee in Administrative Fees section under the Deal Notebook's Admin/Event Fees tab.
    ...    @author: mgaling
    [Arguments]    ${ExcelPath}
    ###Deal Notebook - Admin/Event Fees Tab###
    Add Admin Fee in Deal Notebook    &{ExcelPath}[AdminFee_IncomeMethod]
    Set General Tab Details in Admin Fee Notebook    &{ExcelPath}[AdminFee_FlatAmount]    &{ExcelPath}[AdminFee_EffectiveDate]    &{ExcelPath}[AdminFee_PeriodFrequency]
    ...    &{ExcelPath}[AdminFee_ActualDueDate]    &{ExcelPath}[AdminFee_AdjustedDueDate]
    Set Distribution Details in Admin Fee Notebook    &{ExcelPath}[AdminFee_Customer]    ${ExcelPath}[AdminFee_CustomerLocation]    &{ExcelPath}[AdminFee_ExpenseCode]    &{ExcelPath}[AdminFee_PercentOfFee]
    Navigate Notebook Workflow    ${LIQ_AdminFeeNotebook_Window}    ${LIQ_AdminFeeNotebook_JavaTab}    ${LIQ_AdminFeeNotebook_Workflow_JavaTree}    Send to Approval   
    Logout from Loan IQ
    
    ###Admin Fee Notebook - Workflow Tab###
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    Deals    Awaiting Approval    Amortizing Admin Fee    &{ExcelPath}[Deal_Name]
    Navigate Notebook Workflow    ${LIQ_AdminFeeNotebook_Window}    ${LIQ_AdminFeeNotebook_JavaTab}    ${LIQ_AdminFeeNotebook_Workflow_JavaTree}    Approval
     
    ###Deal Notebook - Admin/Event Fees Tab### 
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Search Existing Deal    &{ExcelPath}[Deal_Name]
    Check if Admin Fee is Added 

Setup Line Fee Capitalization
    [Documentation]    This keyword is used to setup Ongoing Fee Capitalization - Fee Level.
    ...    @author: rtarayao    
    ...    @update: dahijara    07OCT2020    Updated argument passed for Pricing option in 'Validate Capitalized Line Fee details'
    [Arguments]    ${ExcelPath}
    ###Test Data Prep - Set varible first the base rate code to BBSY - Bid (For update once TL scripts is completed)###
    ${BaseRate_Code}    Read Data From Excel    CRED08_OngoingFeeSetup    Interest_BaseRateCode1    2    
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Deal Notebook###
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ###Commitment Fee Notebook####
    Open Ongoing Fee from Deal Notebook    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Fee_Type]
    
    ###Ongoing Fee Capitalization Rule###
    ${Current_Date}    Get System Date
    ${Future_Date}    Get Future Date    ${Current_Date}    2
    Write Data To Excel    CAP03_OngoingFeeCapitalization    Capitalization_FromDate    ${rowid}    ${Current_Date}
    Write Data To Excel    CAP03_OngoingFeeCapitalization    Capitalization_ToDate    ${rowid}    ${Future_Date}
    Create Line Fee Capitalization Rule    &{ExcelPath}[Capitalization_PctofPayment]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[PricingOption]    &{ExcelPath}[Loan_Alias]    ${Current_Date}    ${Future_Date}
    Validate Capitalized Line Fee details    ${Current_Date}    ${Future_Date}    &{ExcelPath}[Capitalization_PctofPayment]    &{ExcelPath}[PricingOption]    &{ExcelPath}[Loan_Alias]
    
    ###Save and Exit Line Fee Notebook####        
    Save and Exit Line Fee Notebook
    Close All Windows on LIQ