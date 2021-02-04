*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Setup Line Fee in Advance for ATM BILAT
    [Documentation]    This keyword collects the line fee payment of the facility.
    ...    @author: ccarriedo    02FEB2021    - Intial Create
    [Arguments]    ${ExcelPath}
    
    ${Deal_Name}    Read Data From Excel    CRED08_OngoingFeeSetup    Deal_Name    &{ExcelPath}[rowid]
    ${Facility_Name2}    Read Data From Excel    CRED08_OngoingFeeSetup    Facility_Name2    &{ExcelPath}[rowid]
    ${OngoingFee_Type1}    Read Data From Excel    CRED08_OngoingFeeSetup    OngoingFee_Type1    &{ExcelPath}[rowid]
    ${OngoingFee_AccrualRule}    Read Data From Excel    CRED08_OngoingFeeSetup    OngoingFee_AccrualRule    &{ExcelPath}[rowid]
    
    ### Open Deal Notebook If Not present ###
    Open Deal Notebook If Not Present    ${Deal_Name}
        
    ### Launch Facility ###
    Launch Existing Facility    ${Deal_Name}    ${Facility_Name2}
    
    ### Ongoing Fee - Update Details ###
    Navigate to Existing Ongoing Fee Notebook    ${OngoingFee_Type1}

    Update Ongoing Fee General Information    &{ExcelPath}[OngoingFee_EffectiveDate]    &{ExcelPath}[OngoingFee_ActualDate]    &{ExcelPath}[OngoingFee_AdjustedDueDate]    &{ExcelPath}[OngoingFee_Accrue]    &{ExcelPath}[OngoingFee_AccrualEndDate]
    Select Pay In Advance/Arrears    ${OngoingFee_AccrualRule}
    
    ${OngoingFee_EffectiveDate}    ${OngoingFee_AccrualEndDate}    ${OngoingFee_DueDate}    Navigate and Verify Line Fee Accrual Tab    &{ExcelPath}[OngoingFee_CycleNo]    &{ExcelPath}[OngoingFee_EffectiveDate]    &{ExcelPath}[OngoingFee_AccrualEndDate]    &{ExcelPath}[OngoingFee_DueDate]
 
    Save and Close Ongoing Fee Window
    Close All Windows on LIQ
    Logout from Loan IQ

Release Ongoing Fee for ATM BILAT
    [Documentation]    This keyword will release the existing ongoing fee in the created deal
    ...    @author: ccarriedo    02FEB2021    - Initial Create
    [Arguments]    ${ExcelPath}
    
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    &{ExcelPath}[rowid]
    ${Facility_Name}    Read Data From Excel    CRED02_FacilitySetup    Facility_Name2    &{ExcelPath}[rowid]
    ${LineFee_Release_Status}    Read Data From Excel    CRED08_OngoingFeeSetup    LineFee_Release_Status    &{ExcelPath}[rowid]

    ### Login to LIQ ###
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    Navigate to Facility Notebook    ${Deal_Name}    ${Facility_Name}
    Navigate to Commitment Fee Notebook    &{ExcelPath}[OngoingFee_Type1]

    ### Ongoing Fee Notebook ###
    Release Ongoing Fee

    Validate Line Fee Events Tab    ${LineFee_Release_Status}
    
    Save Facility Notebook Transaction
    Close All Windows on LIQ
    Logout from Loan IQ
