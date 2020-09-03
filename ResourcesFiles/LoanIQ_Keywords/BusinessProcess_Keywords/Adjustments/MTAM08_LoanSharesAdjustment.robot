*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Loan Share Adjustment 
    [Documentation]    This keyword is for loan share adjustment for Syndicated Deal.
    ...    @author: mgaling
    ...    @update: sahalder    30JUN2020    Modified keyword as per new BNS framework
    ...    @update: dahijara    20AUG2020    Refactored keywords.
    ...                                      Moved writing in test case level. And modified keywords to return needed values.
    ...                                      Updated hard coded values with global variables.
    [Arguments]    ${ExcelPath}    
    ###Manual Share Adjustment Notebook###
    Launch Loan Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Loan_Alias]
    Launch Manual Share Adjustment Notebook    &{ExcelPath}[Loan_PricingOption]
    ${CurrentBusinessDate}    Get System Date
    Write Data To Excel    MTAM08_LoanShareAdjustment    ManualSharedAdj_EffectiveDate    ${rowid}    ${CurrentBusinessDate} 
    Populate General Tab in Manual Share Adjustment    &{ExcelPath}[ManualSharedAdj_Reason]    ${CurrentBusinessDate}
    ${Balance}    Update Host Bank Lender Share    &{ExcelPath}[Lender_HostBank]    &{ExcelPath}[Adjustment]
    Write Data To Excel    MTAM08_LoanShareAdjustment    Balance    ${rowid}    ${Balance}
    ${NewBalance}    Verify the New Balance in Servicing Group Share Window    &{ExcelPath}[Lender_HostBank]    &{ExcelPath}[Adjustment]    ${Balance}
    Write Data To Excel    MTAM08_LoanShareAdjustment    NewBalance    ${rowid}    ${NewBalance}

    Update Host Bank Share Value - Host bank shares section    &{ExcelPath}[Lender_HostBank]    &{ExcelPath}[Host_Bank]    &{ExcelPath}[Adjustment]        
    Verify the New Balance for Host Bank Share Value - Host bank shares section    ${NewBalance}    &{ExcelPath}[Host_Bank]    &{ExcelPath}[Adjustment]
    ${NHB_Balance}    Update NonHost Bank Lender Share    &{ExcelPath}[Lender_NonHostBank]    &{ExcelPath}[NHB_Adjustment]
    Write Data To Excel    MTAM08_LoanShareAdjustment    NHB_Balance    ${rowid}    ${NHB_Balance}
    ${NHB_NewBalance}    Verify the New Balance for NonHost Bank Share    &{ExcelPath}[Lender_NonHostBank]    &{ExcelPath}[NHB_Adjustment]    ${NHB_Balance}
    Write Data To Excel    MTAM08_LoanShareAdjustment    NHB_NewBalance    ${rowid}    ${NHB_NewBalance}
    
    ###Cashflows###  
    Navigate to Manual Share Adjustment Notebook Workflow    ${CREATE_CASHFLOWS_TYPE}
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender_NonHostBank]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Lender_NonHostBank]
    
    ###GL Entries###
    Navigate to GL Entries
    ${HostBank_Debit}    Get GL Entries Amount    &{ExcelPath}[GL_HostBank]    ${CREDIT_AMT_LABEL}
    ${Lender1_Debit}    Get GL Entries Amount    &{ExcelPath}[Lender_NonHostBank]    ${DEBIT_AMT_LABEL}
    ${UITotalCreditAmt}    Get GL Entries Amount    Total For:    ${CREDIT_AMT_LABEL}
    ${UITotalDebitAmt}    Get GL Entries Amount    Total For:    ${DEBIT_AMT_LABEL}
    
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Debit}    ${Lender1_Debit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalDebitAmt}    &{ExcelPath}[NHB_Adjustment]
    
    Adjustment Send to Approval
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Manual Share Adjustment - Workflow###
    Adjustment Approval    &{ExcelPath}[WIPTransaction_Type]    &{ExcelPath}[OustandingsTransaction_Type]    &{ExcelPath}[Deal_Name]    
    
    ###LIQ Window###
    Logout from Loan IQ
    login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ##Manual Share Adjustment Workflow Items###
    Adjustment Release    &{ExcelPath}[WIPTransaction_Type]    &{ExcelPath}[OustandingsTransaction_Type]    &{ExcelPath}[Deal_Name]    
    
