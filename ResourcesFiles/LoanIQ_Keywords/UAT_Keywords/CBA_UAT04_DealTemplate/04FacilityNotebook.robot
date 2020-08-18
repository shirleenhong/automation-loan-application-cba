*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Setup Facility for Deal D00000963
    [Documentation]    This high-level keyword is used for setting up the Facilities in UAT 4
    ...                @author: bernchua    20AUG2019    Initial create
    ...                @update: bernchua    21AUG2019    Added setting of SIC & MIS Codes, Taking of screenshots
    ...                @update: bernchua    26AUG2019    Added Write to Excel of Facility_Name for Runbook test cases
    ...                @update: allanramos  17AUG2019    Commented Out Add MIS Codes
    [Arguments]    ${ExcelPath}
    
    ${Facility_Name}    Generate Name Test Data    &{ExcelPath}[Facility_NamePrefix]
    
	Write Data To Excel    CRED02_FacilitySetup    Facility_Name    &{ExcelPath}[rowid]    ${FacilityName}    ${CBAUAT_ExcelPath}
    Write Data To Excel    CRED01_DealSetup    Facility_Name    &{ExcelPath}[rowid]    ${FacilityName}    ${CBAUAT_ExcelPath}
    Write Data To Excel    UAT04_Fees    Facility_Name    &{ExcelPath}[rowid]    ${FacilityName}    ${CBAUAT_ExcelPath}
    
    Run Keyword If    '&{ExcelPath}[rowid]'=='1'    Run Keywords
    ...    Write Data To Excel    SERV01_LoanDrawdown    Facility_Name    1    ${FacilityName}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    UAT04_Runbook    Facility_Name    1    ${FacilityName}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    UAT04_Runbook    Facility_Name    2    ${FacilityName}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    UAT04_Runbook    Facility_Name    3    ${FacilityName}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    UAT04_Runbook    Facility_Name    4    ${FacilityName}    ${CBAUAT_ExcelPath}
    
    ...    ELSE IF    '&{ExcelPath}[rowid]'=='2'    Run Keywords
    ...    Write Data To Excel    SERV01_LoanDrawdown    Facility_Name    2    ${FacilityName}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Facility_Name    3    ${FacilityName}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Facility_Name    4    ${FacilityName}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    UAT04_Runbook    Facility_Name    5    ${FacilityName}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    UAT04_Runbook    Facility_Name    6    ${FacilityName}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    UAT04_Runbook    Facility_Name    7    ${FacilityName}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    UAT04_Runbook    Facility_Name    8    ${FacilityName}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    UAT04_Runbook    Facility_Name    9    ${FacilityName}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    UAT04_Runbook    Facility_Name    10    ${FacilityName}    ${CBAUAT_ExcelPath}
    
    Add New Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Deal_Currency]    ${Facility_Name}    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Facility_ProposedCmtAmt]    &{ExcelPath}[Facility_Currency]
    
    Set Facility Dates    &{ExcelPath}[Facility_AgreementDate]    &{ExcelPath}[Facility_EffectiveDate]    &{ExcelPath}[Facility_ExpiryDate]    &{ExcelPath}[Facility_MaturityDate]
    Take Screenshot    FacilityNotebook-Summary
    
    Set Facility Risk Type    &{ExcelPath}[Facility_RiskType]
    Set Facility Loan Purpose Type    &{ExcelPath}[Facility_LoanPurposeType]
    Take Screenshot    FacilityNotebook-TypesPurpose
        
    Add Facility Currency    &{ExcelPath}[CurrencyLimit]
    
    Add Borrower    &{ExcelPath}[Borrower_Currency]    &{ExcelPath}[Facility_BorrowerSGName]    &{ExcelPath}[Facility_BorrowerPercent]    &{ExcelPath}[Facility_Borrower]
    ...    &{ExcelPath}[Facility_GlobalLimit]    &{ExcelPath}[Facility_BorrowerMaturity]    &{ExcelPath}[Facility_EffectiveDate]
    Take Screenshot    FacilityNotebook-SublimitCust
    
    Go to Facility Pricing Tab
    Click Modify Ongoing Fees In Facility Pricing
    Add Facility Ongoing Fees    &{ExcelPath}[OngoingFee_Category]    &{ExcelPath}[OngoingFee_Type]    &{ExcelPath}[OngoingFee_RateBasis]    &{ExcelPath}[OngoingFee_AfterItem]
    ...    &{ExcelPath}[OngoingFee_AfterItemType]    &{ExcelPath}[FormulaCategory_Type]    &{ExcelPath}[OngoingFee_SpreadType]    &{ExcelPath}[OngoingFee_SpreadAmount]
    Take Screenshot    FacilityNotebook-OngoingFee
    Validate Ongoing Fee or Interest
    
    Click Modify Interest Pricing In Facility
    Add Facility Interest    &{ExcelPath}[Interest_Category]    &{ExcelPath}[Interest_OptionName]    &{ExcelPath}[Interest_RateBasis]
    ...    &{ExcelPath}[Interest_SpreadType]    &{ExcelPath}[Interest_SpreadValue]    &{ExcelPath}[Interest_BaseRateCode]    
    Take Screenshot    FacilityNotebook-Interest
    Validate Ongoing Fee or Interest
    
    Validate Multi CCY Facility
    
    Set Facility SIC Details    &{ExcelPath}[FacilitySIC_Country]    &{ExcelPath}[FacilitySIC_SearchBy]    &{ExcelPath}[FacilitySIC_Code]
    Take Screenshot    FacilityNotebook-Codes
    # Add MIS Code    &{ExcelPath}[FacilityMIS_Code]    &{ExcelPath}[FacilityMIS_Value]
    # Take Screenshot    FacilityNotebook-MISCodes
    
    Validate Facility
    Take Screenshot    FacilityNavigator-Window
    mx LoanIQ close window    ${LIQ_FacilityNavigator_Window}
