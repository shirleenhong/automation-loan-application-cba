*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
   
*** Keywords ***
SBLC Guarantee Drawdown
    [Documentation]    This high level keyword will be used to drawdown the avaialable Guarantee
    ...    @author: Archana
    [Arguments]    ${ExcelPath}
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Outstanding  Notebook###
    Launch Existing Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    ${OustandingAmount}    ${AvailToDraw}    Get UIValue On FacilityNotebook
    Open Existing Guarantee    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]      

    ###Existing Standby Letters of Credit###
    
     Select Standby Letters of Credit    &{ExcelPath}[Alias]
     ${SBLC_Available_To_Draw}    Guaratee Draw     
     ${DrawnAmount}    Draw Against Bank Guarantee    &{ExcelPath}[Customer]    &{ExcelPath}[IssingBank]
     
     Write Data To Excel    SERV07_GuaranteeDrawdown    SBLC_Available_To_Draw    ${rowid}    ${SBLC_Available_To_Draw}
     Write Data To Excel    SERV07_GuaranteeDrawdown    Drawn_Amount    ${rowid}    ${DrawnAmount}
    
    ###Cashflow Approvals###
    Navigate Notebook Workflow_GuaranteeDrawdown    ${LIQ_BankGuarantee_Payment_Window}    ${LIQ_BankGuarantee_PaymentTab}    ${LIQ_BankGuarantee_Workflow_JavaTree}    Create Cashflows
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Borrower1_RemittanceDescription]    &{ExcelPath}[Borrower1_RemittanceInstruction]  
    Verify if Status is set to Do It    &{ExcelPath}[Borrower1_ShortName]    
    Close Cashflows Window
    Complete Workflow Items_GuaranteeDrawdown    &{ExcelPath}[Customer_Legal_Name]    &{ExcelPath}[SBLC_Status]
        
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Transaction in Process###
    Navigate Transaction in WIP    &{ExcelPath}[Transaction_Type]    &{ExcelPath}[Transaction_Status_Awaiting_Approval]    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Deal_Name]   
    
    Approve SBLC Guarantee Drawdown
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ###Transaction In Process###
    Navigate Transaction in WIP    &{ExcelPath}[Transaction_Type]    &{ExcelPath}[Transaction_Status_Awaiting_Release]    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Deal_Name]
    
    ###SBLC Notebook###
    Release SLBC GuaranteeDrawdown in Workflow
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    Launch Existing Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    ${Post_OustandingAmount}    ${Post_AvailToDraw}    Get UIValue on FacilityNotebook_PostDrawdown
    
    Validation on Facility Notebook    ${OustandingAmount}    ${AvailToDraw}    ${Post_OustandingAmount}    ${Post_AvailToDraw}    &{ExcelPath}[Drawn_Amount]
    
    
        