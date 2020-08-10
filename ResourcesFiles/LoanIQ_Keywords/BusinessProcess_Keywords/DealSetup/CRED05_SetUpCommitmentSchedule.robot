*** Settings ***
Resource     ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***    
Create Commitment Schedule in Facility
    [Documentation]    This keyword will create a commitment Schedule in Facility
    ...    @author: ritragel
    [Arguments]    ${ExcelPath}
    
    ###Facility Notebook - Increase Decrease Facility###
    Navigate to Facility Increase Decrease Schedule    &{ExcelPath}[Facility2_Name]
    ${SystemDate}    Get System Date
    Reschedule Facility    &{ExcelPath}[Facility_NumberOfCycle]    &{ExcelPath}[Facility_ProposedCmtAmt]    &{ExcelPath}[Facility_CycleFrequency]    ${SystemDate}
    
    ${IncreaseDate}    Add Days to Date    ${SystemDate}    3
    Increase Facility Schedule    &{ExcelPath}[Increase_Amount]    &{ExcelPath}[Facility_ProposedCmtAmt]    ${IncreaseDate}
    
    ${DecreaseDate}    Add Days to Date    ${SystemDate}    4 
	Decrease Facility Schedule    &{ExcelPath}[Decrease_Amount]    &{ExcelPath}[Facility_ProposedCmtAmt]    ${DecreaseDate}  
	 
    Verify Remaining Amount after Increase    &{ExcelPath}[Increase_Amount]    1    ${IncreaseDate}
	Verify Remaining Amount after Decrease    &{ExcelPath}[Decrease_Amount]    ${IncreaseDate}    ${DecreaseDate}
	
	###Facility Notebook - Equalizing Amounts###
	Equalize Amounts and Verify that Remaining Amount is Zero    14
	
	###Facility Notebook - Workflow Tab###
	Create Notices    &{ExcelPath}[Borrower1_LegalName]
	
	###Facility Notebook - Set Schedule Status###
	Set Schedule Status to Final and Save   
	Close All Windows on LIQ 
