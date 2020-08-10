*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***

   
*** Keywords ***
Create Unscheduled Facility Increase
    [Documentation]    Create Unscheduled Facility Increase via Facility Notebook.
    ...    @author    mgaling
    ...    @update: clanding    04AUG2020    - refactor keyword 'Validate the entered values in Amendment Notebook - General Tab'
    ...    @update    sahalder    05AUG2020    added screenshots and modified as per the BNS framework
    [Arguments]    ${ExcelPath}
    
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    ###Validation under Deal Notebook and Lendershares (INPUTTER)###
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    ${Current_Cmt}    ${Contr_Gross}    ${Net_Cmt}    Get the Original Amount on Summary Tab of Deal Notebook
    Write Data To Excel    AMCH03_UnschedFacilityIncrease    Current_Cmt    &{ExcelPath}[rowid]    ${Current_Cmt} 
    Write Data To Excel    AMCH03_UnschedFacilityIncrease    Contr_Gross    &{ExcelPath}[rowid]    ${Contr_Gross}
    Write Data To Excel    AMCH03_UnschedFacilityIncrease    Net_Cmt    &{ExcelPath}[rowid]    ${Net_Cmt}
    
    ## @update: bernchua    05DEC2018    Get Lender names and share percentage from Secondary Sale Excel data
    ${HostBank_Lender}    Read Data From Excel    AMCH03_UnschedFacilityIncrease    HostBank_Lender    &{ExcelPath}[rowid]
    ${Lender1}    Read Data From Excel    AMCH03_UnschedFacilityIncrease    Lender1    &{ExcelPath}[rowid]
    ${Lender2}    Read Data From Excel    AMCH03_UnschedFacilityIncrease    Lender2    &{ExcelPath}[rowid]
    ${HostBank_Lender}    Read Data From Excel    TRP002_SecondarySale    Seller_LegalEntity    &{ExcelPath}[rowid]
    ${Lender1}    Read Data From Excel    TRP002_SecondarySale    Buyer_Lender    &{ExcelPath}[rowid]
    ${Lender2}    Read Data From Excel    TRP002_SecondarySale    Buyer_Lender_2    &{ExcelPath}[rowid]
    
    ${Lender1_Percentage}    Read Data From Excel    TRP002_SecondarySale    PctofDeal    &{ExcelPath}[rowid]
    ${Lender2_Percentage}    Read Data From Excel    TRP002_SecondarySale    PctofDeal2    &{ExcelPath}[rowid]
    ${HostBankLender_Percentage}    Evaluate    100-(${Lender1_Percentage}+${Lender2_Percentage})    
    
    
    ${Original_UIHBActualAmount}    ${Original_UILender1ActualAmount}    ${Original_UILender2ActualAmount}    ${Orig_PrimariesAssignees_ActualTotal}    ${Original_UIHBSharesActualAmount}    ${Orig_HostBankShares_ActualNetAllTotal}    Get Original Amount on Deal Lender Shares    ${HostBank_Lender}
    ...    ${Lender1}    ${Lender2} 
    Write Data To Excel    AMCH03_UnschedFacilityIncrease    Original_UIHBActualAmount    &{ExcelPath}[rowid]    ${Original_UIHBActualAmount} 
    Write Data To Excel    AMCH03_UnschedFacilityIncrease    Original_UILender1ActualAmount    &{ExcelPath}[rowid]    ${Original_UILender1ActualAmount} 
    Write Data To Excel    AMCH03_UnschedFacilityIncrease    Original_UILender2ActualAmount    &{ExcelPath}[rowid]    ${Original_UILender2ActualAmount} 
    Write Data To Excel    AMCH03_UnschedFacilityIncrease    Orig_PrimariesAssignees_ActualTotal    &{ExcelPath}[rowid]    ${Orig_PrimariesAssignees_ActualTotal} 
    Write Data To Excel    AMCH03_UnschedFacilityIncrease    Original_UIHBSharesActualAmount    &{ExcelPath}[rowid]    ${Original_UIHBSharesActualAmount} 
    Write Data To Excel    AMCH03_UnschedFacilityIncrease    Orig_HostBankShares_ActualNetAllTotal    &{ExcelPath}[rowid]    ${Orig_HostBankShares_ActualNetAllTotal}  
    
    ###Validation under Facility Notebook and Lendershares (INPUTTER)### 
    Open Facility Notebook    &{ExcelPath}[Facility_Name]
    ${Orig_FacilityCurrentCmt}    ${Orig_FacilityAvailableToDraw}    ${Orig_FacilityHBContrGross}    ${Orig_FacilityHBOutstandings}    ${Orig_FacilityHBAvailToDraw}    ${Orig_FacilityNetCmt}    ${Orig_FacilityHBNetFundableCmt}    ${Orig_FacilityHBNetOutstandings_Funded}    ${Orig_FacilityHBNetAvailToDraw_Fundable}    ${Orig_FacilityHBNetAvailToDraw}    Get Original Amount on Summary Tab of Facility Notebook
    Write Data To Excel    AMCH03_UnschedFacilityIncrease    Orig_FacilityCurrentCmt    &{ExcelPath}[rowid]    ${Orig_FacilityCurrentCmt}
    Write Data To Excel    AMCH03_UnschedFacilityIncrease    Orig_FacilityAvailableToDraw    &{ExcelPath}[rowid]    ${Orig_FacilityAvailableToDraw}
    Write Data To Excel    AMCH03_UnschedFacilityIncrease    Orig_FacilityHBContrGross    &{ExcelPath}[rowid]    ${Orig_FacilityHBContrGross}
    Write Data To Excel    AMCH03_UnschedFacilityIncrease    Orig_FacilityHBOutstandings    &{ExcelPath}[rowid]    ${Orig_FacilityHBOutstandings}
    Write Data To Excel    AMCH03_UnschedFacilityIncrease    Orig_FacilityHBAvailToDraw    &{ExcelPath}[rowid]    ${Orig_FacilityHBAvailToDraw}
    Write Data To Excel    AMCH03_UnschedFacilityIncrease    Orig_FacilityNetCmt    &{ExcelPath}[rowid]    ${Orig_FacilityNetCmt}
    Write Data To Excel    AMCH03_UnschedFacilityIncrease    Orig_FacilityHBNetFundableCmt    &{ExcelPath}[rowid]    ${Orig_FacilityHBNetFundableCmt}
    Write Data To Excel    AMCH03_UnschedFacilityIncrease    Orig_FacilityHBNetOutstandings_Funded    &{ExcelPath}[rowid]    ${Orig_FacilityHBNetOutstandings_Funded}
    Write Data To Excel    AMCH03_UnschedFacilityIncrease    Orig_FacilityHBNetAvailToDraw_Fundable    &{ExcelPath}[rowid]    ${Orig_FacilityHBNetAvailToDraw_Fundable}
    Write Data To Excel    AMCH03_UnschedFacilityIncrease    Orig_FacilityHBNetAvailToDraw    &{ExcelPath}[rowid]    ${Orig_FacilityHBNetAvailToDraw}
    
    ${Original_UIFacHBActualAmount}    ${Original_UIFacLender1ActualAmount}    ${Original_UIFacLender2ActualAmount}    ${Orig_FacPrimariesAssignees_ActualTotal}    ${Original_UIFacHBSharesActualAmount}    ${Orig_FacHostBankShares_ActualNetAllTotal}    Get Original Amount on Facility Lender Shares    ${HostBank_Lender}
    ...    ${Lender1}    ${Lender2} 
    Write Data To Excel    AMCH03_UnschedFacilityIncrease    Original_UIFacHBActualAmount    &{ExcelPath}[rowid]    ${Original_UIFacHBActualAmount} 
    Write Data To Excel    AMCH03_UnschedFacilityIncrease    Original_UIFacLender1ActualAmount    &{ExcelPath}[rowid]    ${Original_UIFacLender1ActualAmount} 
    Write Data To Excel    AMCH03_UnschedFacilityIncrease    Original_UIFacLender2ActualAmount    &{ExcelPath}[rowid]    ${Original_UIFacLender2ActualAmount} 
    Write Data To Excel    AMCH03_UnschedFacilityIncrease    Orig_FacPrimariesAssignees_ActualTotal    &{ExcelPath}[rowid]    ${Orig_FacPrimariesAssignees_ActualTotal} 
    Write Data To Excel    AMCH03_UnschedFacilityIncrease    Original_UIFacHBSharesActualAmount    &{ExcelPath}[rowid]    ${Original_UIFacHBSharesActualAmount} 
    Write Data To Excel    AMCH03_UnschedFacilityIncrease    Orig_FacHostBankShares_ActualNetAllTotal    &{ExcelPath}[rowid]    ${Orig_FacHostBankShares_ActualNetAllTotal} 
    
    ###Step 1: Amendment Notebook- General Tab###  
    Create Amendment via Deal Notebook
    
    ${SystemDate}    Get System Date
    Write Data To Excel    AMCH03_UnschedFacilityIncrease    AMD_EffectiveDate    &{ExcelPath}[rowid]    ${SystemDate}
    ${AMD_EffectiveDate}    Read Data From Excel    AMCH03_UnschedFacilityIncrease    AMD_EffectiveDate    &{ExcelPath}[rowid]
    
    ${AmendmentNo}    Populate General Tab in Amendment Notebook    &{ExcelPath}[AmendmentNumber_Prefix]    ${AMD_EffectiveDate}    &{ExcelPath}[AMD_Comment]
    Write Data To Excel    AMCH03_UnschedFacilityIncrease    AmendmentNo    &{ExcelPath}[rowid]    ${AmendmentNo}  
    
    Validate the Entered Values in Amendment Notebook - General Tab    ${AMD_EffectiveDate}    &{ExcelPath}[AMD_Comment] 
    
    ###Step 2: Amendment Notebook- General Tab### 
    Add Facility in Amendment Transaction    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Transaction_Type]     
    
    ###Step 3:Amortization Schedule For Facility Window###
    Populate Add Transaction Window for the Facility Increase   &{ExcelPath}[Increase_Amount]    ${AMD_EffectiveDate}
    
    ###Step 4:Amortization Schedule For Facility Window###
    Populate Amortization Schedule Window    &{ExcelPath}[AmortSched_Status]   
    
    ###Step 5:Unscheduled Commitment Increase Notebook###
  
    Navigate to Unscheduled Commitment Increase Notebook 
    Navigate to View/Update Lender Share via Unscheduled Commitment Increase Notebook 
    ${Computed_HBActualAmount}    ${Computed_Lender1ActualAmount}    ${Computed_Lender2ActualAmount}    Validate PrimariesAssginees Section    ${HostBank_Lender}    ${Lender1}    ${Lender2}    &{ExcelPath}[Increase_Amount]
    ...    ${HostBankLender_Percentage}    ${Lender1_Percentage}    ${Lender2_Percentage}
    Write Data To Excel    AMCH03_UnschedFacilityIncrease    Computed_HBActualAmount    &{ExcelPath}[rowid]    ${Computed_HBActualAmount}
    Write Data To Excel    AMCH03_UnschedFacilityIncrease    Computed_Lender1ActualAmount    &{ExcelPath}[rowid]    ${Computed_Lender1ActualAmount}
    Write Data To Excel    AMCH03_UnschedFacilityIncrease    Computed_Lender2ActualAmount    &{ExcelPath}[rowid]    ${Computed_Lender2ActualAmount}
    Validate Actual Total Amount under PrimariesAssginees Section    &{ExcelPath}[Increase_Amount]    ${Computed_HBActualAmount}    ${Computed_Lender1ActualAmount}    ${Computed_Lender2ActualAmount}     
    ${HBShares_UIActualAmount}    Validate Host Bank Shares Section    ${Computed_HBActualAmount}    ${HostBank_Lender} 
    Write Data To Excel    AMCH03_UnschedFacilityIncrease    HBShares_UIActualAmount    &{ExcelPath}[rowid]    ${HBShares_UIActualAmount}
    Validate Actual Net All Total Amount under Host Bank Shares Section    ${HBShares_UIActualAmount}      
    Generate Intent Notices in Unscheduled Commitment Increase Notebook
    
    ###Step 6-7:Unscheduled Commitment Increase Notebook###
    Create Notices for Unscheduled Item
    
    ###Step 8-9:Unscheduled Commitment Increase Notebook###
    Equalize Amounts under Current Schedule Section
    
    ###Step 10-11:Amendment Notebook- Workflow Tab - (INPPUTER)###
    Navigate To Amendment Notebook Workflow    Send to Approval
	Logout from Loan IQ
	
	###Step 12:Amendment Notebook- Workflow Tab (SUPERVISOR)###
	Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
	Amendment Approval    Deals    Awaiting Approval    Deal Amendment    &{ExcelPath}[Deal_Name]
	Logout from Loan IQ
	
	###Step 13:Amendment Notebook- Workflow Tab (MANAGER)###
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD} 
	Amendment Release    Deals    Awaiting Release    Deal Amendment    &{ExcelPath}[Deal_Name] 
    Logout from Loan IQ
    
    ##Step 14-15:Validation under Deal Notebook and Lendershares after Facility Commitment Increase (INPUTTER)###
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    Validate the Updates on Deal Notebook    &{ExcelPath}[Increase_Amount]    ${Current_Cmt}     ${Contr_Gross}     ${Computed_HBActualAmount}    ${Net_Cmt}    ${AmendmentNo}   &{ExcelPath}[Facility_Name]
    
    Validate the Updates on Lender Shares    ${HostBank_Lender}    ${Lender1}    ${Lender2}    ${Original_UIHBActualAmount}    ${Computed_HBActualAmount}    ${Original_UILender1ActualAmount}    ${Computed_Lender1ActualAmount}
    ...    ${Original_UILender2ActualAmount}    ${Computed_Lender2ActualAmount}                     
   
    ###Step 17-18:Validation under Facility Notebook and Lendershares after Facility Commitment Increase (INPUTTER)###
    Open Facility Notebook    &{ExcelPath}[Facility_Name]
    ${Updated_UIFaciltyCurrentCmt}    Validate the Updates on Facility Notebook Summary Tab    &{ExcelPath}[Increase_Amount]    ${Orig_FacilityCurrentCmt}    ${Orig_FacilityAvailableToDraw}    ${Orig_FacilityHBContrGross}    ${Computed_HBActualAmount}    ${Orig_FacilityHBOutstandings}    ${Orig_FacilityHBAvailToDraw}     
    ...    ${Orig_FacilityHBNetOutstandings_Funded}    ${Orig_FacilityHBNetAvailToDraw_Fundable}    ${Orig_FacilityHBNetAvailToDraw}    
    Write Data To Excel    AMCH03_UnschedFacilityIncrease    Updated_UIFaciltyCurrentCmt    &{ExcelPath}[rowid]    ${Updated_UIFaciltyCurrentCmt}
        
    Validate Restrictions and Events Tab    ${Updated_UIFaciltyCurrentCmt}
    
    Validate the Updates on Facility Lender Shares    ${HostBank_Lender}    ${Lender1}    ${Lender2}    ${Computed_HBActualAmount}    ${Original_UIFacHBActualAmount}    ${Computed_Lender1ActualAmount}    ${Original_UIFacLender1ActualAmount}
    ...    ${Computed_Lender2ActualAmount}    ${Original_UIFacLender2ActualAmount} 
    
    ###Step 16: Validation on Cicle Notebook###
    Validate the Updates on Primaries    ${HostBank_Lender}     &{ExcelPath}[Facility_Name]    ${Updated_UIFaciltyCurrentCmt}
    
    Close All Windows on LIQ