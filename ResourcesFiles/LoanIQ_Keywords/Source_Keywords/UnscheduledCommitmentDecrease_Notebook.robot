*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords *** 
Increase Or Decrease Schedule 
    [Documentation]    This keyword is used to navigate to Uncheduled commitment decrease notebook
    ...    @author: Archana 07Jul2020
    Mx LoanIQ Activate    ${LIQ_FacilityNotebook_Window}
    Select Menu Item    ${LIQ_FacilityNotebook_Window}    Options    Update  
    Select Menu Item    ${LIQ_FacilityNotebook_Window}    Options    Increase/Decrease Schedule...
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    
Amortization Schedule for Facility
    [Documentation]    This keyword is used to add Amoetization Schedule for Facility
    ...    @author: Archana 07Jul2020
    Mx LoanIQ Activate    ${LIQ_AmortizationScheduleforFacility_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Amortization Schedule
    Mx LoanIQ Click    ${LIQ_AmortizationScheduleforFacility_AddUnsch_Button}
    
Add Schedule Item
    [Documentation]    This keyword is used to add Schedule Item
    ...    @author: Archana 07Jul2020
    [Arguments]    ${sScheduleItem_Amount}    ${sScheduleItem_PercentofCurrent}    ${sSchedule}
    ###Pre-Processing Keyword###
    ${ScheduleItem_Amount}    Acquire Argument Value    ${sScheduleItem_Amount}
    ${ScheduleItem_PercentofCurrent}    Acquire Argument Value    ${sScheduleItem_PercentofCurrent}
    ${Schedule}    Acquire Argument Value    ${sSchedule}
       
    Mx LoanIQ Activate Window    ${LIQ_ScheduleItem_Window}
    Mx LoanIQ Enter    ${LIQ_ScheduleItem_Decrease_RadioButton}    ON
    Mx LoanIQ Enter    ${LIQ_ScheduleItem_Amount}    ${ScheduleItem_Amount}   
    Mx LoanIQ Enter    ${LIQ_ScheduleItem_Schedule}    ${Schedule}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ScheduleItem
    Mx LoanIQ Click    ${LIQ_ScheduleItem_Ok_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_ScheduleItem_Ok_Button}    
    
Add Amortization Schedule Status
    [Documentation]    This keyword is used to add amortization status
    ...    @author: Archana 07Jul2020
    [Arguments]    ${sAmortizationScheduleStatus}    ${sSchedule_Type}
    ###Pre-processing Keyword###
    ${AmortizationScheduleStatus}    Acquire Argument Value    ${sAmortizationScheduleStatus}
    ${Schedule_Type}    Acquire Argument Value    ${sSchedule_Type} 
         
    Mx LoanIQ Activate Window    ${LIQ_AmortizationScheduleforFacility_Window}    
    Mx LoanIQ Select Combo Box Value    ${LIQ_AmortizationScheduleforFacility_AmortizationStatus_List}    ${AmortizationScheduleStatus}
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_AmortizationScheduleforFacility_Schedule_List}    ${Schedule_Type}%s
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ScheduleStatus
    Mx LoanIQ Click    ${LIQ_AmortizationScheduleforFacility_Modify_Button}
    
Modify Schedule
    [Documentation]    This keyword is used to Modify Schedule
    ...    @author: Archana 07Jul2020
    Mx LoanIQ Activate Window    ${LIQ_ModifyTransaction_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ModifySchedule 
    Mx LoanIQ Click    ${LIQ_ModifyTransaction_Ok_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_ModifyTransaction_Ok_Button}    
    
Create Pending Transaction
    [Documentation]    This keyword is used to create Pending Transaction
    ...    @author:Archana 07Jul2020
    [Arguments]    ${sSchedule_Type}
    ###Pre-processing Keyword###
    ${Schedule_Type}    Acquire Argument Value    ${sSchedule_Type}    
    Mx LoanIQ Activate Window    ${LIQ_AmortizationScheduleforFacility_Window}   
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_AmortizationScheduleforFacility_Schedule_List}    ${Schedule_Type}%s
    Mx LoanIQ Click    ${LIQ_AmortizationScheduleforFacility_CreatePending_Button}
     Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PendingTransaction
    Mx LoanIQ Click Element If Present    ${LIQ_Error_OK_Button}
    
Create Transaction Notice
    [Documentation]    This keyword is used to create Transaction Notice
    ...    @author: Archana 07Jul2020
    [Arguments]    ${sLender}=ON 
    ###Pre-processing keyword###
    ${Lender}    Acquire Argument Value    ${sLender}          
    Mx LoanIQ Activate Window    ${LIQ_AmortizationScheduleforFacility_Window}
    Mx LoanIQ Click    ${LIQ_AmortizationScheduleforFacility_TranNB_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Activate Window    ${LIQ_UnscheduledCommitmentDecrease_Window}
    Select Menu Item    ${LIQ_UnscheduledCommitmentDecrease_Window}    Options    Generate Intent Notices
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
     Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/TransactionNotice
    Mx LoanIQ Activate Window    ${LIQ_UnscheduledCommitmentDecrease_Notices_Window}    
    Mx LoanIQ Select Java Checkbox In JavaTable    ${LIQ_UnscheduledCommitmentDecrease_Notices_Lender_List}    ${Lender}            
    Mx LoanIQ Click    ${LIQ_UnscheduledCommitmentDecrease_Ok_Button}   
    
Update Lender Shares
    [Documentation]    This keyword is used to update Lender Shares
    ...    @author:Archana 07Jul2020
    [Arguments]    ${sHostBankShare}    ${sPortfolio}    ${sActual_Amount}    ${sNegative_Adjustment}=-    ${sSymbol}=-
    ###Pre-processing keyword###
    ${HostBankShare}    Acquire Argument Value    ${sHostBankShare}
    ${Portfolio}    Acquire Argument Value    ${sPortfolio}
    ${Actual_Amount}    Acquire Argument Value    ${sActual_Amount}
    ${Negative_Adjustment}    Acquire Argument Value    ${sNegative_Adjustment}
    ${Symbol}    Acquire Argument Value    ${sSymbol}    
            
    Mx LoanIQ Activate Window    ${LIQ_UnscheduledCommitmentDecrease_Window}
    Select Menu Item    ${LIQ_UnscheduledCommitmentDecrease_Window}    Options    View/Update Lender Shares
     Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LenderShares
    Mx LoanIQ Activate Window    ${LIQ_SharesForUnscheduledCommitmentDecrease_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_HostBankShares_List}    ${HostBankShare}%d
    Mx LoanIQ Activate Window    ${LIQ_HostBankShare_Window}
    Mx LoanIQ Click    ${LIQ_HostBankShare_AddPortfolio_Button}
    Mx LoanIQ Activate    ${LIQ_PortfolioSelection_window}    
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PortfolioSelection_List}    ${Portfolio}%d
    Mx LoanIQ Activate    ${LIQ_PortfolioShare_Window}
    Mx LoanIQ Click    ${LIQ_PortfolioShare_ActualAmount}
    Run Keyword If    '${Negative_Adjustment}'=='-'    Run Keywords    Mx LoanIQ Send Keys    ${Symbol}    AND    Run Keyword    Mx LoanIQ Send Keys    ${Actual_Amount}  
    Mx LoanIQ Click    ${LIQ_PortfolioShare_Ok_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PortfolioShare    
    Mx LoanIQ Activate Window    ${LIQ_HostBankShare_Window}
    Mx LoanIQ Click    ${LIQ_HostBankPortfolioSelection_Ok_Button}       
    Mx LoanIQ Activate    ${LIQ_SharesForUnscheduledCommitmentDecrease_Window}   
    Mx LoanIQ Click    ${LIQ_SharesForUnscheduledCommitmentDecrease_OK_Button}
   
Send to Approval Unscheduled Commitment Decrease
    [Documentation]    This keyword sends the Unscheduled Commitment Decrease Transaction for approval
    ...    @author: Archana 07Jul2020    
    Mx LoanIQ Activate    ${LIQ_UnscheduledCommitmentDecrease_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_UnscheduledCommitmentDecrease_Workflow_Tab}    Workflow    
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_UnscheduledCommitmentDecrease_Workflow_List}    Send to Approval%d
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Click Element If Present     ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Click Element If Present     ${LIQ_Question_Yes_Button}
    
Approve Unscheduled Commitment Decrease
    [Documentation]    This keyword will approve the Awaiting Approval - Unscheduled Commitment Decrease
    ...    @author: Archana 07Jul2020   
    mx LoanIQ activate window    ${LIQ_UnscheduledCommitmentDecrease_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_UnscheduledCommitmentDecrease_Workflow_Tab}    Workflow 
    Mx LoanIQ DoubleClick    ${LIQ_UnscheduledCommitmentDecrease_Workflow_List}    Approval
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}  
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}       
    Log    Unscheduled Commitment Decrease is now approved
    
Release Pending Unscheduled Commitment Decrease in Workflow
    [Documentation]    This keyword will approve the Awaiting Release - Unscheduled Commitment Decrease
    ...    @author: Archana 07Jul2020
    Mx LoanIQ Activate    ${LIQ_FacilityNotebook_Window}
    Select Menu Item    ${LIQ_FacilityNotebook_Window}    Options    Update
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Pending_Tab}    Pending
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PendingUnscheduledCommitment 
    Mx LoanIQ DoubleClick    ${LIQ_FacilityNotebook_PendingListItem}    Awaiting Release

Release Unscheduled Commitment Decrease in Workflow
    [Documentation]    This keyword will release the Unscheduled Commitment Decrease in Workflow Tab
    ...    @author:Archana 07Jul2020 
    [Arguments]    ${RuntimeVar_CommitmentType}=None    ${RuntimeVar_Decrease_Amount}=None    
   
    mx LoanIQ activate window    ${LIQ_UnscheduledCommitmentDecrease_Window}
    ${UnscheduledCommitmentType}    Mx LoanIQ Get Data    ${LIQ_UnscheduledCommitmentDecrease_Type}    input= value
    ${Decrease_Amount}    Mx LoanIQ Get Data    ${LIQ_UnscheduledCommitmentDecrease_ChangeAmount}    input=value
    ${Decrease_Amount}    Remove Comma, Negative Character and Convert to Number    ${Decrease_Amount}     
    Mx LoanIQ Select Window Tab    ${LIQ_UnscheduledCommitmentDecrease_Workflow_Tab}    Workflow 
    Mx LoanIQ DoubleClick    ${LIQ_UnscheduledCommitmentDecrease_Workflow_List}    Release
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}     
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Log    Unscheduled Commitment Decrease is complete
    ###Post processing keyword###
    Save Values of Runtime Execution on Excel File    ${RuntimeVar_CommitmentType}    ${UnscheduledCommitmentType}
    Save Values of Runtime Execution on Excel File    ${RuntimeVar_Decrease_Amount}    ${Decrease_Amount}
    [Return]    ${UnscheduledCommitmentType}    ${Decrease_Amount}
        
Validation on Commitment Decrease Schedule
    [Documentation]    This keyword is used to validate the Commitment decrease Schedule
    ...    @author:Archana 07Jul2020
    [Arguments]    ${sUnscheduledCommitmentType}    ${sDecrease_Amount}    ${sType}    ${sScheduleItem_Amount}
    ###Pre-processing Keyword###
    ${UnscheduledCommitmentType}    Acquire Argument Value    ${sUnscheduledCommitmentType}
    ${Decrease_Amount}    Acquire Argument Value    ${sDecrease_Amount}
    ${Type}    Acquire Argument Value    ${sType}
    ${ScheduleItem_Amount}    Acquire Argument Value    ${sScheduleItem_Amount}
        
    Should Be Equal    ${UnscheduledCommitmentType}    ${Type}
    Should Be Equal    ${Decrease_Amount}    ${ScheduleItem_Amount}                   