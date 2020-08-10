*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***

   
*** Keywords ***
Terminate Deal
    [Documentation]    This keyword terminates a deal
    ...    @author: ghabal
    # ##... Mx Launch UFT    Visibility=True    UFTAddins=Java    Processtimeout=200
    # ##... Mx LoanIQ Launch    Processtimeout=300
         
    [Arguments]    ${ExcelPath}       

    # ##...Searching a deal
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    # ##...Prerequisites -check pending transaction in a Deal 
    Check Pending Transaction in Deal    &{ExcelPath}[Deal_Name]
    
    # ##...Terminating a Deal
    Terminate a Deal    &{ExcelPath}[Terminate_Date]
   
Terminate Facility - Commitment Decrease
    [Documentation]    This keyword terminates a facility
    ...    @author: ghabal   
    [Arguments]    ${ExcelPath} 
               
    ${CurrentBusinessDate}    Get System Date
    ###LOANIQ Desktop###
    Open Existing Deal    &{ExcelPath}[Deal_Name]  
    Search Loan    &{ExcelPath}[Type]    &{ExcelPath}[Search_By]    &{ExcelPath}[Facility_Name]
    
    ###Facility Window###   
    Open Existing Inactive Loan from a Facility    &{ExcelPath}[Loan_Alias]
    
    ###Loan Window###  
    Verify Global Current Amount       
    Verify Cycle Due Amount    &{ExcelPath}[Payment_NumberOfCycles] 
    Check Loan Status If Inactive

    ###Facility Window###   
    Check Pending Transaction in Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    
    ###Ongoing Fee List Window###
    Validate Ongoing Fee List    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Fee_Type]    &{ExcelPath}[ProjectedCycleDue]    &{ExcelPath}[CycleNumber]
   
    ###LOANIQ Desktop###      
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Navigate to Facility Notebook from Deal Notebook    &{ExcelPath}[Facility_Name]
    
    ###Facility Window### 
    Add Facility Change Transaction
    
    # ##...Modify the current amortization schedule in Inc/Dec Schedule tab 
    Modify Current Amortization Schedule    ${rowid}
    
    # ##...Sending to Approval the Facility Change Transaction    
    Send to Approval Facility Change Transaction
    
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD} 
    
    # ##...Approving the Facility Change Transaction    
    Approve Facility Change Transaction    &{ExcelPath}[Deal_Name]
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}    
    
    # ##...Releasing the Facility Change Transaction
    Release Facility Change Transaction    &{ExcelPath}[Deal_Name]
    
    # ##...Searching a deal
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    # ##...Navigating a Facility
    Navigate to Facility Notebook from Deal Notebook    &{ExcelPath}[Facility_Name]
    
    # ##...Create pending transaction from Schedule Item
    Create Pending Transaction from Schedule item    ${CurrentBusinessDate}
    
    # ##...Sending to Approval the Scheduled Commitment Decrease Transaction        
    Send to Approval Scheduled Commitment Decrease Transaction
    Close All Windows on LIQ    
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}        
    
    ##...Approving the Scheduled Commitment Decrease Transaction
    Approval Scheduled Commitment Decrease Transaction    &{ExcelPath}[Deal_Name]
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}    
    
    ##...Releasing the Scheduled Commitment Decrease Transaction
    Release Scheduled Commitment Decrease Transaction    &{ExcelPath}[Deal_Name]
    
    # ##...Searching a deal 
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    # ##...Navigating a Facility
    Navigate to Facility Notebook from Deal Notebook    &{ExcelPath}[Facility_Name]
    
    # ##...Verify if current commitment amount is zero in a Facility
    Verify Current Commitment Amount if Zero
    
    # ##...Close all existing open windows in Loan IQ 
    Close All Windows on LIQ 
    
Terminate Facility - Change Expiry and Maturity Date
    [Documentation]    This keyword terminates a facility with changing Expiry and Maturity date
    ...    @author: ghabal
    [Arguments]    ${ExcelPath}
        
    ##...Searching a deal      
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    # ##...Navigating a Facility
    Navigate to Facility Notebook from Deal Notebook    &{ExcelPath}[Facility_Name]
    
    # ##...Adding Facility Change from Facility Notebook
    Add Facility Change Transaction
    
    # ##...Updating Expiry and Maturity Date via Facility Change Transaction
    ${NewBusinessDateAfterEODBatchRun}    Update Expiry and Maturity Date in Facility Change Transaction
    Write Data To Excel    SERV35_Terminate_FacilityDeal    New_ExpiryDate    ${rowid}    ${NewBusinessDateAfterEODBatchRun}
    Write Data To Excel    SERV35_Terminate_FacilityDeal    New_MaturityDate    ${rowid}    ${NewBusinessDateAfterEODBatchRun}
    Write Data To Excel    SERV35_Terminate_FacilityDeal    Terminate_Date    ${rowid}    ${NewBusinessDateAfterEODBatchRun}
    
    # ##...Sending to Approval the Facility Change Transaction      
    Send to Approval Facility Change Transaction
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}        
    
    ##...Approving the Facility Change Transaction
    Approve Facility Change Transaction    &{ExcelPath}[Deal_Name]
    
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}    
    
    # ##...Releasing the Facility Change Transaction
    Release Facility Change Transaction    &{ExcelPath}[Deal_Name]
    
    ##...Searching a deal  
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    # ##...Navigating a Facility
    Navigate to Facility Notebook from Deal Notebook    &{ExcelPath}[Facility_Name]
    
    # ##...Adding Facility Change from Facility Notebook      
    Add Facility Change Transaction    
    
    # ##...Terminating a Facility via Facility Change Transaction
    ${Terminate_Date}    Update Terminate Date in Facility Change Transaction     
    Write Data To Excel    SERV35_Terminate_FacilityDeal    Terminate_Date    ${rowid}    ${Terminate_Date}
    
    # ##...Sending to Approval the Facility Change Transaction     
    Send to Approval Facility Change Transaction
    
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}        
    
    ##...Approving the Facility Change Transaction
    Approve Facility Change Transaction    &{ExcelPath}[Deal_Name]
    
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}    
    
    ##...Releasing the Facility Change Transaction
    Release Facility Change Transaction    &{ExcelPath}[Deal_Name]
    
    # ##...Verifying if a Facility is Terminated from a Deal
    Verify if Facility is Terminated    &{ExcelPath}[Deal_Name]    &{ExcelPath}[TerminatedFacility_Status]
    Close All Windows on LIQ      
     
     
