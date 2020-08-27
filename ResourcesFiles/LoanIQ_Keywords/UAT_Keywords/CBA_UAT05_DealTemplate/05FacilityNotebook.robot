*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot
    
*** Keywords ***
Setup Facility Template D00001151
    [Documentation]    High Level Keyword for Facility Template Creation
    ...    author: henstone    13AUG2019    Initial create
    ...    update: mcastro    27Aug2020    Deleted screenshot; delete duplicate step
    [Arguments]    ${ExcelPath}
   
    ### New Facility Name Generation ###
	${FacilityName}    Auto Generate Name Test Data    &{ExcelPath}[Facility_NamePrefix]
	
	### Save Test Data ###
    Write Data To Excel    CRED01_DealSetup    Facility_Name    &{ExcelPath}[rowid]    ${FacilityName}    ${CBAUAT_ExcelPath}
    Write Data To Excel    CRED02_FacilitySetup    Facility_Name    &{ExcelPath}[rowid]    ${FacilityName}    ${CBAUAT_ExcelPath}
    Write Data To Excel    CRED08_FacilityFeeSetup    Facility_Name    &{ExcelPath}[rowid]    ${FacilityName}    ${CBAUAT_ExcelPath}
 
    ${FacilityName}    Read Data From Excel    CRED02_FacilitySetup    Facility_Name   &{ExcelPath}[rowid]    ${CBAUAT_ExcelPath}
    ${Deal_Name}    Read Data From Excel    CRED02_FacilitySetup    Deal_Name   &{ExcelPath}[rowid]    ${CBAUAT_ExcelPath}
    
    ### Facility Creation ###
    Add New Facility    ${Deal_Name}    &{ExcelPath}[Deal_Currency]    ${FacilityName}
    ...    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Facility_ProposedCmtAmt]    &{ExcelPath}[Facility_Currency]
    Verify Main SG Details    &{ExcelPath}[Facility_ServicingGroup]    &{ExcelPath}[Facility_Customer]    &{ExcelPath}[Facility_SGLocation]
    
    ### Summary Tab: Set Facility Dates ###
    Set Facility Dates    &{ExcelPath}[Facility_AgreementDate]    &{ExcelPath}[Facility_EffectiveDate]    &{ExcelPath}[Facility_ExpiryDate]    &{ExcelPath}[Facility_MaturityDate]
    
    ### Types/Purpose Tab: Enter Multiple Risk Types ###
    Set Facility Risk Type    &{ExcelPath}[Facility_RiskType]
    
    ### Types/Purpose Tab: Enter Loan Purpose Type ###
    Set Facility Loan Purpose Type    &{ExcelPath}[Facility_LoanPurposeType]
    
    ### Sublimit/Cust Tab: Add Facility Borrower ###
    Add Borrower    &{ExcelPath}[Borrower_Currency]    &{ExcelPath}[Facility_BorrowerSGName]    &{ExcelPath}[Facility_BorrowerPercent]    &{ExcelPath}[Facility_Borrower]
    ...    &{ExcelPath}[Facility_GlobalLimit]    &{ExcelPath}[Facility_BorrowerMaturity]    &{ExcelPath}[Facility_EffectiveDate]
    
    ### Codes Tab: General Information ###
    Validate General Information Details    &{ExcelPath}[Facility_SIC]    &{ExcelPath}[Facility_OwningBranch]    &{ExcelPath}[Facility_FundingDesk]    &{ExcelPath}[Facility_ProcessingArea]
    
Setup Facility Fees D00001151   
    [Documentation]    High-level keyword for Facility Pricing set up.
    ...    author: henstone    13AUG2019    Initial create
    ...    @update: mcastro    27Aug2020    Removed screenshot    
    [Arguments]    ${ExcelPath}
    
    ### BBSW - Mid Base Rate Code Formula and Locator Preparation ###
    ${BaseRateCode}    Get Interest Base Rate Code    ${ExcelPath}[Interest_BaseRateCode_Formula]    ${ExcelPath}[Interest_SpreadValue]    ${ExcelPath}[Interest_BaseRateCode_SpreadVar]
    Write Data To Excel    CRED08_FacilityFeeSetup    Interest_BaseRateCode    &{ExcelPath}[rowid]    ${BaseRateCode}    ${CBAUAT_ExcelPath}
    ${BaseRateCode}    Convert to Formula with Escape Sequence    ${BaseRateCode} 
    ${BBSW_MID_BasRateCode}     Catenate        SEPARATOR=.*    ${ExcelPath}[Interest_OptionName]    ${BaseRateCode}
 
    ### Pricing Tab: Add Interest Pricing ###
    Modify Interest Pricing - Insert Add    ${ExcelPath}[Interest_AddItem]    ${ExcelPath}[Interest_OptionName]    
    ...    ${ExcelPath}[Interest_RateBasis]    ${ExcelPath}[Interest_SpreadValue]    ${BBSW_MID_BasRateCode} 

    Set Facility Pricing Penalty Spread    &{ExcelPath}[Penalty_Spread]    &{ExcelPath}[Penalty_Status]
    
    Validate Facility 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    mx LoanIQ click element if present    ${LIQ_Warning_OK_Button} 
    mx LoanIQ close window    ${LIQ_FacilityNavigator_Window}
    
Setup MIS Code D00001151
    [Documentation]    High Level Keyword for Facility MIS Code Addition.
    ...    @author: hstone    13AUG2019    Initial create
    ...    @update: hstone    21AUG2019    Added Warning Window Confirmation
    ...    @update: mcastro    27Aug2020    Delete screenshot
    [Arguments]    ${ExcelPath}
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Navigate to Facility Notebook from Deal Notebook    &{ExcelPath}[Facility_Name]
    
    Add MIS Code    ${ExcelPath}[MIS_Code]    ${ExcelPath}[MIS_Value]
    Validate Facility 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    mx LoanIQ click element if present    ${LIQ_Warning_OK_Button} 
    mx LoanIQ close window    ${LIQ_FacilityNavigator_Window}
    
Facility Limit Change
    [Documentation]    High Level Keyword for Facility Limit Change.
    ...    author: hstone    19AUG2019    Initial create
    [Arguments]    ${ExcelPath}
    ${CurrentBusinessDate}    Get System Date
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Navigate to Facility Notebook from Deal Notebook    &{ExcelPath}[Facility_Name]
    
    ### Navigate to Facility Change Transaction ### 
    Add Facility Change Transaction
    Take Screenshot    FacilityChangeTransaction
    
    ### Set the  amortization schedule ammounts ###
    Navigate to Ammortization Schedule for Facility Change Transaction
    Modify Current Amortization Amount    Decrease    &{ExcelPath}[Facility_LimitChangeDecreaseAmount]    &{ExcelPath}[Facility_LimitChangeDecreaseAmtSched]     
    Add Scheduled Facility Limit Change    Decrease    &{ExcelPath}[Facility_LimitChangeRemainingAmount]    &{ExcelPath}[Facility_LimitChangeRemainingAmtSched]    
    Save Scheduled Facility Limit Change
    Take Screenshot    FacilityChangeTransaction_ModifyScheduleItem 
    
    ### Sending to Approval the Facility Change Transaction ###    
    Send to Approval Facility Change Transaction
    
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD} 
    
    ### Approving the Facility Change Transaction ###    
    Approve Facility Change Transaction    &{ExcelPath}[Deal_Name]
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}    
    
    ### Releasing the Facility Change Transaction ###
    Release Facility Change Transaction    &{ExcelPath}[Deal_Name]
    
    ###...Searching a deal
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ###...Navigating a Facility
    Navigate to Facility Notebook from Deal Notebook    &{ExcelPath}[Facility_Name]
    Take Screenshot    FacilityChangeTransaction_ModifyScheduleItem 
    
    ### Create pending transaction from Schedule Item  
    Create Pending Transaction from Schedule item    ${CurrentBusinessDate}
    
    ### Sending to Approval the Scheduled Commitment Decrease Transaction        
    Send to Approval Scheduled Commitment Decrease Transaction
    Close All Windows on LIQ    
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}       
    
    ### Approving the Scheduled Commitment Decrease Transaction
    Approval Scheduled Commitment Decrease Transaction    &{ExcelPath}[Deal_Name]
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}   
    
    ### Releasing the Scheduled Commitment Decrease Transaction
    Release Scheduled Commitment Decrease Transaction    &{ExcelPath}[Deal_Name]
    
    ### Searching a deal 
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ### Navigating a Facility
    Navigate to Facility Notebook from Deal Notebook    &{ExcelPath}[Facility_Name]
    
    ### Verify Facility current commitment amount
    Validate Facility Current Commitment Amount    &{ExcelPath}[Facility_LimitChangeRemainingAmount]
    
    ### Close all existing open windows in Loan IQ 
    Close All Windows on LIQ 
