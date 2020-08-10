*** Settings ***
Resource     ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Deal Amendment    
    [Documentation]    Add a New Facility via Amendment Notebook.
    ...    @author: Archana
    ...    @update: clanding    04AUG2020    - refactor keyword name 'Validate the entered values in Amendment Notebook - General Tab'
    [Arguments]    ${ExcelPath}    ${INPUTTER_USERNAME}=ARCUSR01    ${INPUTTER_PASSWORD}=7ULLA3B1    ${SUPERVISOR_USERNAME}=ARCSUP01    ${SUPERVISOR_PASSWORD}=6MB6CPD4    ${MANAGER_USERNAME}=ARCMGR01    ${MANAGER_PASSWORD}=BU1ZAN89     
  
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}    
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ###Step 1: Amendment Notebook- General Tab###  
    Create Amendment via Deal Notebook
    
    ${SystemDate}    Get System Date
    Write Data To Excel    AMCH01_DealAmendment    AMD_EffectiveDate    &{ExcelPath}[rowid]    ${SystemDate}
    ${AMD_EffectiveDate}    Read Data From Excel    AMCH01_DealAmendment    AMD_EffectiveDate    &{ExcelPath}[rowid]
    
    ${AmendmentNo}    Populate General Tab in Amendment Notebook    &{ExcelPath}[AmendmentNumber_Prefix]    ${AMD_EffectiveDate}    &{ExcelPath}[AMD_Comment]
    Write Data To Excel    AMCH01_DealAmendment    AmendmentNo    &{ExcelPath}[rowid]    ${AmendmentNo}  
    
    Validate the Entered Values in Amendment Notebook - General Tab    ${AMD_EffectiveDate}    &{ExcelPath}[AMD_Comment]
  
 ##Step 2: Amendment Notebook- General Tab### 
    Add Facility in Amendment Transaction    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Transaction_Type]
      
 ###Step 3 : Share Adjustment in Facility Notebook ###
    
    ${Deal_Name}    Read Data From Excel    AMCH01_DealAmendment    Deal_Name    &{ExcelPath}[rowid]
    ${Facility_Name}    Read Data From Excel    AMCH01_DealAmendment    Facility_Name    &{ExcelPath}[rowid]     
    ${Amendment_Number}    Read Data From Excel    AMCH01_DealAmendment    AmendmentNo    &{ExcelPath}[rowid]    
    Share Adjustment in Facility Notebook    &{ExcelPath}[BuySellPrice]    &{ExcelPath}[CommentTextField]    ${Deal_Name}    ${Facility_Name}    ${Amendment_Number}  
    
  ###Go to Options > View/Update Lender Shares from the Share Adjustment Notebook###
    View/Update Lender Shares From Adjustment Window
    
###Get necessary data from UI, store to excel, and read from excel###

    Share Adjustment in Facility
    
    ${ProposedCmt}    Get Data From LoanIQ    ${LIQ_FacilityNotebook_Window}    ${LIQ_FacilityNotebook_Tab}    Summary    ${LIQ_FacilitySummary_ProposedCmt_Textfield}
    ${Outstandings}    Get Data From LoanIQ    ${LIQ_FacilityNotebook_Window}    ${LIQ_FacilityNotebook_Tab}    Summary    ${LIQ_FacilitySummary_GlobalFacilityAmount_Outstandings}
    
    Write Data To Excel    AMCH01_DealAmendment    Facility_ProposedCmt    ${rowid}    ${ProposedCmt}
    Write Data To Excel    AMCH01_DealAmendment    Outstandings_Amount    ${rowid}    ${Outstandings}
    
    ${ProposedCmt}    Read Data From Excel    AMCH01_DealAmendment    Facility_ProposedCmt    ${rowid}
    ${Outstandings}    Read Data From Excel    AMCH01_DealAmendment    Outstandings_Amount    ${rowid}
    Close Facility Window
    
    ###Update each of the listed lenders' shares###
 
    ${TranAmount2}    ${New_LenderShare1}    Update Facility Lender Shares    &{ExcelPath}[Lender_Name1]    &{ExcelPath}[Lender_Adjustment1]    &{ExcelPath}[Lender_ShareAmount1]    ${ProposedCmt}    ${Outstandings}
    ${TranAmount3}    ${New_LenderShare2}    Update Facility Lender Shares    &{ExcelPath}[Lender_Name2]    &{ExcelPath}[Lender_Adjustment2]    &{ExcelPath}[Lender_ShareAmount2]    ${ProposedCmt}    ${Outstandings}
    
    Log    ${New_LenderShare1}, ${New_LenderShare2}
    
    Submit Share Adjustment    
    Close Share Adjustment in Facility Notebook

###Step 4 : Covenant Change in Facility Notebook ###

    Add Facility in Amendment Transaction    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Transaction_Type_Covenant]    
         
    ${Amendment_Number}    Read Data From Excel    AMCH01_DealAmendment    AmendmentNo    &{ExcelPath}[rowid]    
    Covenant Change in Facility Notebook    &{ExcelPath}[CovenantCommentText]    ${Amendment_Number}
    
 ##Step 5 :Amendment Notebook- Workflow Tab - (INPPUTER)###
    Navigate Notebook Workflow    ${LIQ_AmendmentNotebook}    ${LIQ_AMD_Tab}    ${LIQ_AMD_Workflow_JavaTree}    Send to Approval
    Logout from Loan IQ
	
 ##Step 6:Amendment Notebook- Workflow Tab (SUPERVISOR)###

	Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
	Amendment Approval    Deals    Awaiting Approval    Deal Amendment    &{ExcelPath}[Deal_Name]
	Logout from Loan IQ
	
 ##Step 7:Amendment Notebook- Workflow Tab (MANAGER)###
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD} 
	Amendment Release    Deals    Awaiting Release    Deal Amendment    &{ExcelPath}[Deal_Name] 
    Logout from Loan IQ