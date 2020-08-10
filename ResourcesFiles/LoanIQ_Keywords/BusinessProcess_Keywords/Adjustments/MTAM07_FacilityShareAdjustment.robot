*** Settings ***
Resource     ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Adjust Facility Lender Shares For Syndicated Deal
    [Documentation]    This high-level keyword is for adjusting the Facility Lender Shares in a Syndicated Deal.
    ...    @author: bernchua
    ...    @update: ritragel    06MAR19    Updated based on the set Automation Standards
    ...    @update: sahalder    01JUL2020    updated as per new BNS standards
    ...    @update: dfajardo    07AUG2020    Added create cashflows and release cashflows keywords
    [Arguments]    ${ExcelPath}

    ###Login to Inputter###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ###Deal Notebook###
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ###Facility###
    Open Facility From Deal Notebook    &{ExcelPath}[Facility_Name]
    
    ###Get necessary data from UI, store to excel, and read from excel###
    ${Currency}    Get Currency From Facility Notebook
    ${ProposedCmt}    Get Data From LoanIQ    ${LIQ_FacilityNotebook_Window}    ${LIQ_FacilityNotebook_Tab}    Summary    ${LIQ_FacilitySummary_ProposedCmt_Textfield}
    ${Outstandings}    Get Data From LoanIQ    ${LIQ_FacilityNotebook_Window}    ${LIQ_FacilityNotebook_Tab}    Summary    ${LIQ_FacilitySummary_GlobalFacilityAmount_Outstandings}
    Write Data To Excel    MTAM07_FacilityShareAdjustment    Currency    ${rowid}    ${Currency}
    Write Data To Excel    MTAM07_FacilityShareAdjustment    Facility_ProposedCmt    ${rowid}    ${ProposedCmt}
    Write Data To Excel    MTAM07_FacilityShareAdjustment    Outstandings_Amount    ${rowid}    ${Outstandings}
    ${Currency}    Read Data From Excel    MTAM07_FacilityShareAdjustment    Currency    ${rowid}
    ${ProposedCmt}    Read Data From Excel    MTAM07_FacilityShareAdjustment    Facility_ProposedCmt    ${rowid}
    ${Outstandings}    Read Data From Excel    MTAM07_FacilityShareAdjustment    Outstandings_Amount    ${rowid}
    
    ###Initiate facility lender share adjustment###
    View/Update Lender Shares Make Selection    ${LENDER_SHARES_ADJUSTMENT_LABEL}
    
    ##Create Facility Lender Share Adjustment###
    ###Set details in the General tab of the Share Adjustment Notebook###
    ${EffectiveDate}    Get System Date
    Write Data To Excel    MTAM07_FacilityShareAdjustment    Effective_Date    ${rowid}    ${EffectiveDate}    
    Set Share Adjusment General Tab Details    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    ${Currency}    ${EffectiveDate}    &{ExcelPath}[BuySellPrice]    &{ExcelPath}[Comment]
    
    ###Go to Options > View/Update Lender Shares from the Share Adjustment Notebook###
    View/Update Lender Shares From Adjustment Window
    
    ###Update each of the listed lenders' shares###
    ${TranAmount1}    ${New_HostbankShare}    Update Facility Lender Shares    &{ExcelPath}[Host_Bank]    &{ExcelPath}[HostBank_Adjustment]    &{ExcelPath}[HostBank_ShareAmount]    ${ProposedCmt}    ${Outstandings}
    ${TranAmount2}    ${New_LenderShare1}    Update Facility Lender Shares    &{ExcelPath}[Lender_Name1]    &{ExcelPath}[Lender_Adjustment1]    &{ExcelPath}[Lender_ShareAmount1]    ${ProposedCmt}    ${Outstandings}
    ${TranAmount3}    ${New_LenderShare2}    Update Facility Lender Shares    &{ExcelPath}[Lender_Name2]    &{ExcelPath}[Lender_Adjustment2]    &{ExcelPath}[Lender_ShareAmount2]    ${ProposedCmt}    ${Outstandings}
    
    Log    ${New_HostbankShare}, ${New_LenderShare1}, ${New_LenderShare2}

    ###Update the Host Bank's share###
    Adjust Host Bank Portfolio Shares    &{ExcelPath}[Host_Bank]    &{ExcelPath}[HostBank_ExpenseCode]    &{ExcelPath}[HostBank_Branch]    &{ExcelPath}[HostBank_Portfolio]    &{ExcelPath}[HostBank_Adjustment]
          
    ###Create Cashflow###
    Navigate to Shared Adjustment Notebook Workflow    ${CREATE_CASHFLOWS_TYPE}
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender_Name2]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Lender_Name2]     
    Click OK In Cashflows
  
    ###Sending the transaction to Approval###
    Navigate to Shared Adjustment Notebook Workflow    ${SEND_TO_APPROVAL_STATUS}
    Validate Window Title Status    ${SHARE_ADJUSTMENT_TYPE}    ${AWAITING_APPROVAL_STATUS}
    
    ###Login to a different approver user###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ###Approval of the Transaction###
    Navigate Transaction in WIP    ${FACILITIES_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${SHARE_ADJUSTMENT_TYPE}    &{ExcelPath}[Deal_Name]
    Navigate to Shared Adjustment Notebook Workflow    ${APPROVAL_STATUS}
    Validate Window Title Status    ${SHARE_ADJUSTMENT_TYPE}   ${AWAITING_APPROVAL_STATUS}
    
    ###Release Cashflow####
    Navigate to Shared Adjustment Notebook Workflow    ${RELEASE_CASHFLOWS_TYPE}
    Release Cashflow    &{ExcelPath}[Lender_Name2]
    
    ###Release of the Transaction###
    Navigate to Shared Adjustment Notebook Workflow    ${RELEASE_STATUS}
    Validate Window Title Status    ${SHARE_ADJUSTMENT_TYPE}    ${RELEASE_STATUS}
    
    ###Close all windows###
    Close All Windows on LIQ
