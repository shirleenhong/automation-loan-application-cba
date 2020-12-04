*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Create Facility for DNR
    [Documentation]    This keyword is used to create a Facility.
    ...    @author: clanding     24NOV2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Open Existing Deal    &{ExcelPath}[Deal_Name]

    ###Data Generation###
    ${Facility_Name}    Auto Generate Name Test Data    &{ExcelPath}[Facility_NamePrefix]
    Run Keyword If    '${rowid}'=='1'    Write Data To Excel    SC1_DealSetup    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}
    Write Data To Excel    SC1_FacilitySetup    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}
    Write Data To Excel    SC1_OngoingFeeSetup    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}
    Write Data To Excel    SC1_PaymentFees    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    SC1_UnscheduledPayments    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}    ${DNR_DATASET}    bTestCaseColumn=True

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

    ${row_previous}    Run Keyword If    '${rowid}'=='1'    Set Variable    ${rowid}
    ...    ELSE    Evaluate    ${rowid}-1
    ${row_previous}    Convert To String    ${row_previous}
    ${Facility_Name_Primary}    Read Data From Excel    SC1_PrimaryAllocation    Facility_Name    ${row_previous}    ${DNR_DATASET}
    ${Facility_Name_Primary}    Run Keyword If    '${rowid}'=='1'    Set Variable    ${Facility_Name}
    ...    ELSE    Set Variable    ${Facility_Name_Primary}|${Facility_Name}
    Write Data To Excel    SC1_PrimaryAllocation    Facility_Name    Expanded_Scenario1_ActiveFac1_Repayment    ${Facility_Name_Primary}    ${DNR_DATASET}    bTestCaseColumn=True

    ${row_previous}    Run Keyword If    '${rowid}'=='1'    Set Variable    ${rowid}
    ...    ELSE    Evaluate    ${rowid}-1
    ${row_previous}    Convert To String    ${row_previous}
    ${Facility_ExpiryDate_Primary}    Read Data From Excel    SC1_PrimaryAllocation    Primary_PortfolioExpiryDate    ${row_previous}    ${DNR_DATASET}
    ${Facility_ExpiryDate_Primary}    Run Keyword If    '${rowid}'=='1'    Set Variable    ${Facility_ExpiryDate}
    ...    ELSE    Set Variable    ${Facility_ExpiryDate_Primary}|${Facility_ExpiryDate}
    Write Data To Excel    SC1_PrimaryAllocation    Primary_PortfolioExpiryDate    Expanded_Scenario1_ActiveFac1_Repayment    ${Facility_ExpiryDate_Primary}    ${DNR_DATASET}    bTestCaseColumn=True
    
Get Active Facility Details for Active Outstanding and Write in DNR Dataset
    [Documentation]    This keyword is used to get details for each report and write in dataset.
    ...    @author: clanding    25NOV2020    - initial create
    [Arguments]    ${ExcelPath}

    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    ${FacilityControlNumber}    Get Facility Control Number
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

    Write Data To Excel    FACPF    Facility_Name    FACPF_003    &{ExcelPath}[Facility_Name]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    FACPF    Facility_FCN    FACPF_003    ${FacilityControlNumber}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    FACPF    Deal_Name    FACPF_003    &{ExcelPath}[Deal_Name]    ${DNR_DATASET}    bTestCaseColumn=True

    Write Data To Excel    FACPF    Facility_Name    FACPF_005    &{ExcelPath}[Facility_Name]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    FACPF    Facility_FCN    FACPF_005    ${FacilityControlNumber}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    FACPF    Deal_Name    FACPF_005    &{ExcelPath}[Deal_Name]    ${DNR_DATASET}    bTestCaseColumn=True

    Close All Windows on LIQ

Get Expired Facility Details for Active Outstanding and Write in DNR Dataset
    [Documentation]    This keyword is used to get details for each report and write in dataset.
    ...    @author: clanding    25NOV2020    - initial create
    [Arguments]    ${ExcelPath}

    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    ${FacilityControlNumber}    Get Facility Control Number

    ### Writing for Facility Performance Report ###
    Write Data To Excel    FACPF    Facility_Name    FACPF_004    &{ExcelPath}[Facility_Name]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    FACPF    Facility_FCN    FACPF_004    ${FacilityControlNumber}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    FACPF    Deal_Name    FACPF_004    &{ExcelPath}[Deal_Name]    ${DNR_DATASET}    bTestCaseColumn=True

    Close All Windows on LIQ