*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Ongoing Fee Setup for DNR
    [Documentation]    This high-level keyword sets up Ongoing Fee from the Deal Notebook.
    ...    @author: clanding    25NOV2020    - initial create
    [Arguments]    ${ExcelPath}
    
    ###Facility Notebook - Pricing Tab###
    Modify Ongoing Fee Pricing - Insert Add    &{ExcelPath}[OngoingFee_Category1]    &{ExcelPath}[OngoingFee_Type1]    &{ExcelPath}[OngoingFee_RateBasis1]
    Modify Ongoing Fee Pricing - Insert After   &{ExcelPath}[OngoingFee_AfterItem]    &{ExcelPath}[Facility_PercentWhole]    &{ExcelPath}[OngoingFee_Category1]    &{ExcelPath}[Facility_Percent] 
    Modify Interest Pricing - Insert Add    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName1]    &{ExcelPath}[Interest_RateBasis]    &{ExcelPath}[Interest_SpreadAmt1]    &{ExcelPath}[Interest_BaseRateCode1]
    
    ###Facility Notebook - Pricing Rules Tab###
    Verify Pricing Rules    &{ExcelPath}[Interest_OptionName1]
    Validate Facility
    mx LoanIQ close window    ${LIQ_FacilityNavigator_Window}
    Close All Windows on LIQ