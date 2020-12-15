*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Create Facility for DNR
    [Documentation]    This keyword is used to create a Facility.
    ...    @author: clanding     24NOV2020    - initial create
    ...    @update: fluberio    15DEC2020    - added SC1_ComprehensiveRepricing Writting in Excel
    [Arguments]    ${ExcelPath}
    
    Open Existing Deal    &{ExcelPath}[Deal_Name]

    ###Data Generation###
    ${Facility_Name}    Auto Generate Name Test Data    &{ExcelPath}[Facility_NamePrefix]
    Run Keyword If    '${rowid}'=='1'    Write Data To Excel    SC1_DealSetup    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}
    Write Data To Excel    SC1_FacilitySetup    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}
    Write Data To Excel    SC1_OngoingFeeSetup    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}
    Write Data To Excel    SC1_PaymentFees    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}    ${DNR_DATASET}
    Write Data To Excel    SC1_UnscheduledPayments    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}    ${DNR_DATASET}
    Write Data To Excel    SC1_UnscheduledPayments    Facility_Name    3    ${Facility_Name}    ${DNR_DATASET}    ${DNR_DATASET}
    Write Data To Excel    SC1_ComprehensiveRepricing    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}    ${DNR_DATASET}

    ###New Facility Screen###
    ${Facility_ProposedCmtAmt}    New Facility Select    &{ExcelPath}[Deal_Name]    ${FacilityName}    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Facility_ProposedCmtAmt]    &{ExcelPath}[Facility_Currency]    

    ###Facility Notebook - Summary Tab###
    ${Facility_AgreementDate}    Get System Date
    ${Facility_EffectiveDate}    Get System Date
    ${Facility_ExpiryDate}    Add Time from From Date and Returns Weekday    ${Facility_EffectiveDate}    &{ExcelPath}[Add_To_Facility_Expiry_Date]
    ${Facility_MaturityDate}    Add Time from From Date and Returns Weekday    ${Facility_EffectiveDate}    &{ExcelPath}[Add_To_Final_Maturity_Date]
    Enter Dates on Facility Summary    ${Facility_AgreementDate}    ${Facility_EffectiveDate}    ${Facility_ExpiryDate}    ${Facility_MaturityDate}
    Verify Main SG Details    &{ExcelPath}[Facility_ServicingGroup]    &{ExcelPath}[Facility_Customer]    &{ExcelPath}[Facility_SGLocation]
    
    ###Facility Notebook - Types/Purpose Tab###
    Add Risk Type    &{ExcelPath}[Facility_RiskType1]    &{ExcelPath}[Facility_RiskTypeLimit]   &{ExcelPath}[Facility_Currency1]
    Add Loan Purpose Type    &{ExcelPath}[Facility_LoanPurposeType]
   
    ##Facility Notebook - Restrictions Tab###
    Add Currency Limit    &{ExcelPath}[Facility_Currency1]    &{ExcelPath}[Facility_GlobalLimit]   &{ExcelPath}[Facility_CustomerServicingGroup]    &{ExcelPath}[Facility_SGLocation]
    
    ###Facility Notebook - Sublimit/Cust Tab###
    Add Borrower    &{ExcelPath}[Facility_Currency1]    &{ExcelPath}[Facility_BorrowerSGName]    &{ExcelPath}[Facility_BorrowerPercent]    &{ExcelPath}[Facility_Borrower]
    ...    &{ExcelPath}[Facility_GlobalLimit]    &{ExcelPath}[Facility_BorrowerMaturity]    ${Facility_EffectiveDate}

    ### Add Alert in Facility Level ###
    ${Alerts_Details}    ${Date_Added}    Add Alerts in Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Alerts_ShortDescription]    &{ExcelPath}[Alerts_DetailsPrefix]
    Write Data To Excel    SC1_FacilitySetup    Alerts_Details    ${rowid}    ${Alerts_Details}    ${DNR_DATASET}
    Write Data To Excel    SC1_FacilitySetup    Alerts_DateAddedAmended    ${rowid}    ${Date_Added}    ${DNR_DATASET}
    Write Data To Excel    SC1_FacilitySetup    User_ID    ${rowid}    ${INPUTTER_USERNAME}    ${DNR_DATASET}

    Write Data To Excel    SC1_FacilitySetup    Facility_AgreementDate    ${rowid}    ${Facility_EffectiveDate}    ${DNR_DATASET}
    Write Data To Excel    SC1_FacilitySetup    Facility_EffectiveDate    ${rowid}    ${Facility_EffectiveDate}    ${DNR_DATASET}
    Write Data To Excel    SC1_FacilitySetup    Facility_MaturityDate    ${rowid}    ${Facility_MaturityDate}    ${DNR_DATASET}
    Write Data To Excel    SC1_FacilitySetup    Facility_ExpiryDate    ${rowid}    ${Facility_ExpiryDate}    ${DNR_DATASET}

    ${row_previous}    Run Keyword If    '${rowid}'=='1' or '${rowid}'=='4'    Set Variable    ${rowid}
    ...    ELSE    Evaluate    ${rowid}-1
    ${row_previous}    Convert To String    ${row_previous}
    ${Facility_Name_Primary}    Read Data From Excel    SC1_PrimaryAllocation    Facility_Name    ${row_previous}    ${DNR_DATASET}
    ${Facility_Name_Primary}    Run Keyword If    '${rowid}'=='1' or '${rowid}'=='4'    Set Variable    ${Facility_Name}
    ...    ELSE    Set Variable    ${Facility_Name_Primary}|${Facility_Name}
    Write Data To Excel    SC1_PrimaryAllocation    Facility_Name    Expanded_Scenario1_ActiveFac1_Repayment    ${Facility_Name_Primary}    ${DNR_DATASET}

    ${row_previous}    Run Keyword If    '${rowid}'=='1' or '${rowid}'=='4'    Set Variable    ${rowid}
    ...    ELSE    Evaluate    ${rowid}-1
    ${row_previous}    Convert To String    ${row_previous}
    ${Facility_ExpiryDate_Primary}    Read Data From Excel    SC1_PrimaryAllocation    Primary_PortfolioExpiryDate    ${row_previous}    ${DNR_DATASET}
    ${Facility_ExpiryDate_Primary}    Run Keyword If    '${rowid}'=='1' or '${rowid}'=='4'    Set Variable    ${Facility_ExpiryDate}
    ...    ELSE    Set Variable    ${Facility_ExpiryDate_Primary}|${Facility_ExpiryDate}
    Write Data To Excel    SC1_PrimaryAllocation    Primary_PortfolioExpiryDate    Expanded_Scenario1_ActiveFac1_Repayment    ${Facility_ExpiryDate_Primary}    ${DNR_DATASET}
    
Get Active Facility Details for Active Outstanding and Write in DNR Dataset
    [Documentation]    This keyword is used to get details for each report and write in dataset.
    ...    @author: clanding    25NOV2020    - initial create
    ...    @update: ccarriedo    09DEC2020    - added get facility status is active, get facility outstandings amount in LIQ and write to data excel Outstandings_Amount
    [Arguments]    ${ExcelPath}

    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    ${FacilityControlNumber}    Get Facility Control Number
    ### Get Facility Status Active ###
    ${Facility_Status}    Read Data From Excel    FACPF    Facility_Status    ${rowid}    ${DNR_DATASET}
    Run Keyword And Continue On Failure    Validate Facility Status    &{ExcelPath}[Facility_Name]    ${Facility_Status}
    ### Get Facility Outstanding amount in LIQ ###
    ${Facility_Outstandings_Amount}    Get Outstandings Amount from Facility Notebook
    ${FName_UI}    ${LName_UI}    Get First Name of a User    &{ExcelPath}[User_ID]

    ### Writing for Alerts Report ###
    Write Data To Excel    ALERT    Facility_Name    ALERT_007    &{ExcelPath}[Facility_Name]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    Facility_FCN    ALERT_007    ${FacilityControlNumber}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    Alert_Heading    ALERT_007    &{ExcelPath}[Alerts_ShortDescription]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    Alert_Content    ALERT_007    &{ExcelPath}[Alerts_Details]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    User_Name    ALERT_007    ${FName_UI}${SPACE}${LName_UI}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    Date_Added_Amended    ALERT_007    &{ExcelPath}[Alerts_DateAddedAmended]    ${DNR_DATASET}    bTestCaseColumn=True

    ### Writing for Facility Performance Report ###
    Write Data To Excel    FACPF    Facility_Name    FACPF_002    &{ExcelPath}[Facility_Name]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    FACPF    Facility_FCN    FACPF_002    ${FacilityControlNumber}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    FACPF    Deal_Name    FACPF_002    &{ExcelPath}[Deal_Name]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    FACPF    Facility_Outstandings    FACPF_002    ${Facility_Outstandings_Amount}    ${DNR_DATASET}    bTestCaseColumn=True

    Write Data To Excel    FACPF    Facility_Name    FACPF_003    &{ExcelPath}[Facility_Name]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    FACPF    Facility_FCN    FACPF_003    ${FacilityControlNumber}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    FACPF    Deal_Name    FACPF_003    &{ExcelPath}[Deal_Name]    ${DNR_DATASET}    bTestCaseColumn=True

    Write Data To Excel    FACPF    Facility_Name    FACPF_005    &{ExcelPath}[Facility_Name]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    FACPF    Facility_FCN    FACPF_005    ${FacilityControlNumber}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    FACPF    Deal_Name    FACPF_005    &{ExcelPath}[Deal_Name]    ${DNR_DATASET}    bTestCaseColumn=True

    ### Writing for Loan & Accrual Report ###
    Write Data To Excel    LOACC    FCN    LOACC_007    ${FacilityControlNumber}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    LOACC    FCN    LOACC_008    ${FacilityControlNumber}    ${DNR_DATASET}    bTestCaseColumn=True

    Close All Windows on LIQ

Get Expired Facility Details for Active Outstanding and Write in DNR Dataset
    [Documentation]    This keyword is used to get details for each report and write in dataset.
    ...    @author: clanding    25NOV2020    - initial create
    ...    @update: clanding    11DEC2020    - added validation of status and getting amount
    [Arguments]    ${ExcelPath}

    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    ${FacilityControlNumber}    Get Facility Control Number
    
    ${Facility_Status}    Read Data From Excel    FACPF    Facility_Status    ${TestCase_Name}    ${DNR_DATASET}    bTestCaseColumn=True    sTestCaseColReference=TestCase_Name
	Validate Facility Status    &{ExcelPath}[Facility_Name]    ${Facility_Status}
    
    ${Facility_Outstandings_Amount}    Get Outstandings Amount from Facility Notebook  

    ### Writing for Facility Performance Report ###
    Write Data To Excel    FACPF    Facility_Name    FACPF_004    &{ExcelPath}[Facility_Name]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    FACPF    Facility_FCN    FACPF_004    ${FacilityControlNumber}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    FACPF    Deal_Name    FACPF_004    &{ExcelPath}[Deal_Name]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    FACPF    Facility_Outstandings    FACPF_004    ${Facility_Outstandings_Amount}    ${DNR_DATASET}    bTestCaseColumn=True

    Close All Windows on LIQ

Setup Term Facility for Syndicated Deal for DNR
    [Documentation]    This keyword is used to create a Term Facility for DNR.
    ...    @author: shirhong    04DEC2020    - initial create
    ...    @author: makcamps    10DEC2020    - updated sheet name for repricing
    [Arguments]    ${ExcelPath}
    
    ###Data Generation###
    ${Facility_Name}    Auto Generate Name Test Data    &{ExcelPath}[Facility_NamePrefix]
    Write Data To Excel    SC2_DealSetup    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}
    Write Data To Excel    SC2_FacilitySetup    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}
    Write Data To Excel    SC2_OngoingFeeSetup    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}
    Write Data To Excel    SC2_EventFee    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}
    Write Data To Excel    SC2_PrimaryAllocation    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}    
    Write Data To Excel    SC2_LoanDrawdown    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}
    Write Data To Excel    SC2_LoanDrawdownNonAgent    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}  
    Write Data To Excel    SC2_ComprehensiveRepricing    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}
    Write Data To Excel    SC2_FacilityShareAdjustment    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}
    Write Data To Excel    SC2_CycleShareAdjustment    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}
    Write Data To Excel    SC2_PaymentFees    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}
    
    ${FacilityName}    Read Data From Excel    SC2_FacilitySetup    Facility_Name    ${rowid}    ${DNR_DATASET}

    ###Facility Creation###
    Add New Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Deal_Currency]    ${FacilityName}
    ...    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Facility_ProposedCmtAmt]    &{ExcelPath}[Facility_Currency]
    
    ${Facility_AgreementDate}    Get System Date
    ${Facility_EffectiveDate}    Get System Date
    ${Facility_ExpiryDate}    Add Days to Date    ${Facility_EffectiveDate}    &{ExcelPath}[Add_To_Facility_ExpiryDate]
    ${Facility_MaturityDate}    Add Days to Date    ${Facility_EffectiveDate}    &{ExcelPath}[Add_To_Facility_MaturityDate]

    Write Data To Excel    SC2_LoanDrawdown    Loan_MaturityDate    ${rowid}    ${Facility_MaturityDate}    ${DNR_DATASET}
    Write Data To Excel    SC2_LoanDrawdownNonAgent    Loan_MaturityDate    ${rowid}    ${Facility_MaturityDate}    ${DNR_DATASET}
 
    Set Facility Dates    ${Facility_AgreementDate}    ${Facility_EffectiveDate}    ${Facility_ExpiryDate}    ${Facility_MaturityDate}
    Set Facility Risk Type    &{ExcelPath}[Facility_RiskType1]
    Set Facility Risk Type    &{ExcelPath}[Facility_RiskType2]
    Set Facility Loan Purpose Type    &{ExcelPath}[Facility_LoanPurposeType]
    Add Facility Currency    &{ExcelPath}[Facility_Currency1]
    Add Facility Currency    &{ExcelPath}[Facility_Currency2]
    Add Facility Borrower - Add All    &{ExcelPath}[Facility_Borrower]
    Validate Risk Type in Borrower Select    &{ExcelPath}[Facility_RiskType1]
    Validate Risk Type in Borrower Select    &{ExcelPath}[Facility_RiskType2]
    Validate Currency Limit in Borrower Select    &{ExcelPath}[Facility_Currency1]
    Validate Currency Limit in Borrower Select    &{ExcelPath}[Facility_Currency2]
    Complete Facility Borrower Setup
    
    ###Get necessary data from created Facility and store to Excel to be used in other transactions###
    ${EffectiveDate}    Get Data From LoanIQ    ${LIQ_FacilityNotebook_Window}    ${LIQ_FacilityNotebook_Tab}    Summary    ${LIQ_FacilitySummary_EffectiveDate_Datefield}
    ${ExpiryDate}    Get Data From LoanIQ    ${LIQ_FacilityNotebook_Window}    ${LIQ_FacilityNotebook_Tab}    Summary    ${LIQ_FacilitySummary_ExpiryDate_Datefield}
    Write Data To Excel    SC2_DealSetup    ApproveDate    ${rowid}    ${EffectiveDate}    ${DNR_DATASET}
    Write Data To Excel    SC2_DealSetup    CloseDate    ${rowid}    ${EffectiveDate}    ${DNR_DATASET}
    Write Data To Excel    SC2_PrimaryAllocation    ApproveDate    ${rowid}    ${EffectiveDate}    ${DNR_DATASET}
    Write Data To Excel    SC2_PrimaryAllocation    CloseDate    ${rowid}    ${EffectiveDate}    ${DNR_DATASET}
    Write Data To Excel    SC2_DealSetup    Primary_CircledDate    ${rowid}    ${EffectiveDate}    ${DNR_DATASET}
    Write Data To Excel    SC2_DealSetup    Primary_PortfolioExpiryDate    ${rowid}    ${ExpiryDate}    ${DNR_DATASET}
    Write Data To Excel    SC2_EventFee    EventFee_EffectiveDate    ${rowid}    ${EffectiveDate}    ${DNR_DATASET}

    ${EventFee_NoRecurrencesAfterDate}    Get Back Dated Current Date    -&{ExcelPath}[Backdated_Days]
    Write Data To Excel    SC2_EventFee    EventFee_NoRecurrencesAfterDate    ${rowid}    ${EventFee_NoRecurrencesAfterDate}    ${DNR_DATASET}

Add Pending Facility for DNR
    [Documentation]    This keyword is used to create a Facility and not complete it.
    ...    @author: clanding     09DEC2020    - initial create
    [Arguments]    ${ExcelPath}
    
    ${Deal_Name}    Read Data From Excel    SC1_DealSetup    Deal_Name    1    ${DNR_DATASET}
    Open Existing Deal    ${Deal_Name}

    ###Data Generation###
    ${Facility_Name}    Auto Generate Name Test Data    &{ExcelPath}[Facility_NamePrefix]
    Write Data To Excel    SC1_FacilitySetup    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}

    ###New Facility Screen###
    New Facility Select for Pending Status    ${Deal_Name}    ${FacilityName}    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Facility_Currency]    
    Close All Windows on LIQ
    Navigate to Facility Notebook    ${Deal_Name}    ${Facility_Name}
    ${FacilityControlNumber}    Get Facility Control Number
    Validate Facility Status    ${Facility_Name}    Pending

    Write Data To Excel    LOACC    FCN    LOACC_007    ${FacilityControlNumber}    ${DNR_DATASET}    bTestCaseColumn=True
    Close All Windows on LIQ