*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Facility Fee Setup - ComSee
    [Documentation]    This high-level keyword sets up Ongoing Fee and Interest Fee for Facility.
    ...    @author: rtarayao    16AUG2019    Initial Create
    [Arguments]    ${ComSeeDataSet}
    ###Facility Notebook - Pricing Tab###
    Modify Ongoing Fee Pricing - Insert Add    &{ComSeeDataSet}[OngoingFee_Category1]    &{ComSeeDataSet}[OngoingFee_Type1]    &{ComSeeDataSet}[OngoingFee_RateBasis1]
    Modify Ongoing Fee Pricing - Insert After   &{ComSeeDataSet}[OngoingFee_AfterItem]    &{ComSeeDataSet}[Facility_PercentWhole]    &{ComSeeDataSet}[OngoingFee_Category1]    &{ComSeeDataSet}[Facility_Percent] 
    Modify Interest Pricing - Insert Add    &{ComSeeDataSet}[Interest_AddItem]    &{ComSeeDataSet}[Interest_OptionName1]    &{ComSeeDataSet}[Interest_RateBasis]    &{ComSeeDataSet}[Interest_SpreadAmt1]    &{ComSeeDataSet}[Interest_BaseRateCode1]
    
    ###Facility Notebook - Pricing Rules Tab###
    Verify Pricing Rules    &{ComSeeDataSet}[Interest_OptionName1]
    
    ###Facility and Fee Validations
    Validate Facility
    Close Facility Navigator Window
    Navigate to Facility Notebook from Deal Notebook    &{ComSeeDataSet}[Facility_Name]
    Validate Window Title Status    Facility    Pending
    Navigate to Commitment Fee Notebook    &{ComSeeDataSet}[OngoingFee_Type1]
    Validate Window Title Status    Commitment    Status
    Close Commitment Fee and Fee List Windows
    Close Facility Notebook and Navigator Windows
    
    
    
  
    
    
    
    
    
    
