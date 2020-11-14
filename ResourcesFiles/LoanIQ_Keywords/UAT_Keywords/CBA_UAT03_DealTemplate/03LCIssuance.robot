*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot
    
*** Keywords ***
Issue LC D00000476
    [Documentation]    This high-level keyword will cater the creation of Bank Guarantee
    ...    @author: ritragel    29JUL2019
    [Arguments]    ${ExcelPath}
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Deal Notebook###
    Open Existing Deal    &{ExcelPath}[Deal_Name]

    ###Outstanding Select Window###
    ${Alias}    Create New Outstanding Select - SBLC    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Amount_Requested]
    ...    &{ExcelPath}[Effective_Date]   &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Expiry_Date]    &{ExcelPath}[Deal_Name]
    Write Data To Excel    SERV05_SBLCIssuance    SBLC_Alias    &{ExcelPath}[rowid]    ${Alias}    ${CBAUAT_ExcelPath}
    Write Data To Excel    SERV18_FeeOnLenderSharesPayment    SBLC_Alias    &{ExcelPath}[rowid]    ${Alias}    ${CBAUAT_ExcelPath}
    Run Keyword If    '&{ExcelPath}[rowid]'=='1'    Write Data To Excel    SERV18_FeeOnLenderSharesPayment    SBLC_Alias    3    ${Alias}    ${CBAUAT_ExcelPath}
    ${Alias}    Read Data From Excel    SERV05_SBLCIssuance    SBLC_Alias    &{ExcelPath}[rowid]    ${CBAUAT_ExcelPath}
    
    # ###SBLC Notebook###
    Verify Pricing Formula    &{ExcelPath}[Issuance_Fee]    &{ExcelPath}[Cycle_Frequency]    &{ExcelPath}[AccrualRule_PayInAdvance]
    Add Banks    &{ExcelPath}[Beneficiary_ShortName]
    Complete Workflow Items    &{ExcelPath}[Customer_Legal_Name]    &{ExcelPath}[SBLC_Status]   
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Transaction in Process###
    Navigate Transaction in WIP    &{ExcelPath}[Transaction_Type]    &{ExcelPath}[Transaction_Status_Awaiting_Approval]    &{ExcelPath}[Outstanding_Type]    ${Alias}    
    
    ###SBLC Notebook###
    Approve SBLC Issuance
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ###Transaction In Process###
    Navigate Transaction in WIP    &{ExcelPath}[Transaction_Type]    &{ExcelPath}[Transaction_Status_Awaiting_Release]    &{ExcelPath}[Outstanding_Type]    ${Alias}
    
    ###SBLC Notebook###
    Navigate Notebook Workflow    ${LIQ_SBLCIssuance_Window}    ${LIQ_SBLCIssuance_Workflow_Tab}    ${LIQ_SBLCIssuance_Release_ListItem}    Release   
    Verify SBLC Issuance Status        &{ExcelPath}[Deal_Name]    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]    ${Alias}    &{ExcelPath}[Cycle_Number]   

    ###LIQ Window###
    Close All Windows on LIQ
    
