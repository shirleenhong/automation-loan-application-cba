*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Add Facility Change Transaction
    [Documentation]    This keyword adds Facility Change Transaction to the Faciliy
    ...    @author: jdelacruz
    ...    @update: amansuet    22JUN2020    - updated to align with automation standards and added take screenshot

    Mx LoanIQ Activate    ${LIQ_FacilityNotebook_Window}
    ${Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_FacilityNotebook_InquiryMode_Button}    VerificationData="Yes"
    Run Keyword If    '${Status}'=='True'  mx LoanIQ select    ${LIQ_FacilityNotebook_Options_Update}    
    Mx LoanIQ Select    ${LIQ_FacilityNotebook_Options_FacilityChangeTransaction}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/FacilityChangeTransactionNotebook_GeneralTab
    Mx LoanIQ Click Element If Present    ${LIQ_Question_Yes_Button}
    
Modify Maturity Date in Facility Change Transaction
    [Documentation]    This keyword extends the Maturity Date of the Facility by entering future date
    ...    @autor: jdelacruz
    ...    @update: ritragel     20MAY2019    Removed writing in the low-level keywords
    ...    @update: amansuet    22JUN2020    - updated to align with automation standards, added take screenshot and added keyword post-processing
    [Arguments]    ${sRunTimeVar_MaturityTemp}=None

    Mx LoanIQ Activate    ${LIQ_FacilityChangeTransaction_Window}    
    Mx LoanIQ DoubleClick    ${LIQ_FacilityChangeTransaction_FieldName_List}    Maturity Date
    Mx LoanIQ Activate    ${LIQ_EnterMaturityDate_Window}
    ${MaturityTemp}    Mx LoanIQ Get Data    ${LIQ_EnterMaturityDate_MaturityDate_Textfield}    maturityDate
    ${MaturityTemp}    Convert Date    ${MaturityTemp}     date_format=%d-%b-%Y
    ${MaturityTemp}    Subtract Time From Date    ${MaturityTemp}    -365 days    result_format=%d-%b-%Y
    Mx LoanIQ Enter    ${LIQ_EnterMaturityDate_MaturityDate_Textfield}    ${MaturityTemp}
    Mx LoanIQ Click    ${LIQ_EnterMaturityDate_Ok_Button}        
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_MessageBox}            VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Yes_Button}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_No_Button}    VerificationData="Yes"
    :FOR    ${i}    IN RANGE    3
     \    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
     \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}     VerificationData="Yes"
     \    Exit For Loop If    ${Warning_Status}==False
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/FacilityChangeTransactionWindow_GeneralTab

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_MaturityTemp}    ${MaturityTemp}

    [Return]    ${MaturityTemp}
    
Update Facility Details
    [Documentation]    This keyword is created for the dynamic changing of Facility Details using Facility Change Transaction
    ...    @author: ritragel    20SEP2019
    [Arguments]    ${sFieldName}    ${sNewValue}
    mx LoanIQ activate window    ${LIQ_FacilityChangeTransaction_Window}    
    Mx LoanIQ DoubleClick    ${LIQ_FacilityChangeTransaction_FieldName_List}    ${sFieldName}
    mx LoanIQ activate window    JavaWindow("title:=.*${sFieldName}")
    mx LoanIQ enter    JavaWindow("title:=.*${sFieldName}").JavaEdit("tagname:=text")    ${sNewValue}
    mx LoanIQ click    JavaWindow("title:=.*${sFieldName}").JavaButton("attached text:=OK")
    :FOR    ${i}    IN RANGE    3
     \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
     \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}     VerificationData="Yes"
     \    Exit For Loop If    ${Warning_Status}==False

Add Facility Schedule Item
    [Documentation]    This keyword is used for Adding an Schedule Item in Facility Details
    ...    @author: ritragel    20SEP2019
    [Arguments]    ${sChangeType}    ${sAmount}    ${sDate}
    mx LoanIQ activate window    ${LIQ_FacilityChangeTransaction_AmortizationSchedule_Window}
    mx LoanIQ click    ${LIQ_FacilityChangeTransaction_AmortizationSchedule_AddButton}
    mx LoanIQ activate window    ${LIQ_AddSchedItem_Window}
    mx LoanIQ enter    JavaWindow("title:=Add Schedule Item").JavaRadiobutton("attached text:=${sChangeType}")    ON
    mx LoanIQ enter    ${LIQ_AddSchedItem_Amount_Field}    ${sAmount}
    mx LoanIQ enter    ${LIQ_AddSchedItem_ScheduleDate_Field}    ${sDate}
    mx LoanIQ click    ${LIQ_AddSchedItem_OK_Button}
    mx LoanIQ activate window    ${LIQ_FacilityChangeTransaction_AmortizationSchedule_Window}
    mx LoanIQ click    ${LIQ_AMD_AmortSched_Save_Button}
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click    ${LIQ_AMD_AmortSched_Exit_Button}

Navigate to Facility Increase/Decrease Schedule
    [Documentation]    This keyword is used for the navigation to Facility Increase/Decrease in Facility Change Transaction
    ...    @author: ritragel    20SEP2019
    mx LoanIQ activate window    ${LIQ_FacilityChangeTransaction_Window}  
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityChangeTransaction_Tab}    Inc/Dec Schedule
    mx LoanIQ click    ${LIQ_FacilityChangeTransaction_CreateModifySchedule_Button}
    :FOR    ${i}    IN RANGE    3
     \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
     \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}     VerificationData="Yes"
     \    Exit For Loop If    ${Warning_Status}==False
    
Send to Approval Facility Change Transaction
    [Documentation]    This keyword sends the Facility Change Transaction for approval
    ...    @author: jdelacruz
    ...    <update> @ghabal - added Mx Click Element If Present ${LIQ_Warning_Yes_Button} for matured facility
    ...    <update> @ghabal - removed "Run Keyword And Continue On Failure Mx LoanIQ Verify Object Exist" that makes this keyword to fail as discussed with Carlo. This will be handled by the
    ...    "Mx Click Element If Present" scripts instead
    ...    @update: amansuet    22JUN2020    - updated to align with automation standards and added take screenshot

    Mx LoanIQ Activate    ${LIQ_FacilityChangeTransaction_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityChangeTransaction_Tab}    Workflow
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/FacilityChangeTransactionWindow_WorkflowTab
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FacilityChangeTransaction_Worflow_Tab}    Send to Approval%d
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Click Element If Present     ${LIQ_Warning_Yes_Button}
    :FOR    ${i}    IN RANGE    3
     \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
     \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}     VerificationData="Yes"
     \    Exit For Loop If    ${Warning_Status}==False

Approve Facility Change Transaction
    [Documentation]    This keyword approves the Facility Change Transaction in work in process
    ...    @author: jdelacruz
    ...    <update> @ghabal - added Mx Click Element If Present ${LIQ_Warning_Yes_Button} for matured facility
     ...    <update> @ghabal - removed "Run Keyword And Continue On Failure Mx LoanIQ Verify Object Exist" that makes this keyword to fail as discussed with Carlo. This will be handled by the
    ...    "Mx Click Element If Present" scripts instead
    ...    @update:    fmamaril    24APR2019    Added handling for Question message box             
    ...    @update: amansuet    22JUN2020    - updated to align with automation standards, added take screenshot and added keyword pre-processing
    [Arguments]    ${sDeal_Name}

    ### Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}

    Mx LoanIQ Activate Window   ${LIQ_Window}
    Select Actions    [Actions];Work In Process
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Transactions_List}    Facilities    
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Outstanding_List}    Awaiting Approval
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Outstanding_List}    Facility Change Transaction
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Outstanding_List}    ${Deal_Name}
    Mx LoanIQ Activate Window    ${LIQ_FacilityChangeTransaction_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityChangeTransaction_Tab}    Workflow
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/FacilityChangeTransactionWindow_WorkflowTab
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FacilityChangeTransaction_Worflow_Tab}    Approval%d
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_Question_Yes_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_Question_Yes_Button}
    :FOR    ${i}    IN RANGE    3
     \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
     \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}     VerificationData="Yes"
     \    Exit For Loop If    ${Warning_Status}==False
     
Release Facility Change Transaction 
    [Documentation]    This keyword releases the approved Facility Change Transaction in work in process
    ...    @author: jdelacruz/ghabal
    ...    <update> @ghabal - added Mx Click Element If Present ${LIQ_Warning_Yes_Button} for matured facility      
    ...    <update> @ghabal - removed "Run Keyword And Continue On Failure Mx LoanIQ Verify Object Exist" that makes this keyword to fail as discussed with Carlo. This will be handled by the
    ...    "Mx Click Element If Present" scripts instead
    ...    @update: amansuet    22JUN2020    - updated to align with automation standards, added take screenshot and added keyword pre-processing
    [Arguments]    ${sDeal_Name}

    ### Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    
    Mx LoanIQ Activate Window   ${LIQ_Window}
    Select Actions    [Actions];Work In Process
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Transactions_List}    Facilities    
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Outstanding_List}    Awaiting Release
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Outstanding_List}    Facility Change Transaction
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Outstanding_List}    ${Deal_Name}
    Mx LoanIQ Activate    ${LIQ_FacilityChangeTransaction_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityChangeTransaction_Tab}    Workflow
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/FacilityChangeTransactionWindow_WorkflowTab
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FacilityChangeTransaction_Worflow_Tab}    Release%d
    Mx LoanIQ Click Element If Present    ${LIQ_Question_Yes_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Click Element If Present     ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Verify Object Exist    ${LIQ_FacilityChangeTransaction_WorkflowNoItems_Tab}    VerificationData="Yes"
    Mx LoanIQ Select    ${LIQ_FacilityChangeTransaction_File_Exit}
    Mx LoanIQ Click Element If Present     ${LIQ_Reminder_OK_Button}
    Mx LoanIQ Activate Window    ${LIQ_TransactionInProcess_Window}
    Mx LoanIQ Select    ${LIQ_TransactionsInProcess_FileExit_Menu}    
    
Validate Facility Change Transaction
    [Documentation]    This keyword validates that the changes in Facility Maturity Date is correct
    ...    @author: jdelacruz  
    ...    @update: ritragel    20MAY2019    Updated as per our scripting standards
    ...    @update: amansuet    22JUN2020    - updated to align with automation standards, added take screenshot and added keyword pre-processing
    [Arguments]    ${sMaturity_Date}    ${sDeal_Name}    ${sFacility_Name}

    ### Keyword Pre-processing ###
    ${Maturity_Date}    Acquire Argument Value    ${sMaturity_Date}
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}

    Select Actions    [Actions];Facility
    Mx LoanIQ Enter    ${LIQ_FacilitySelect_DealName_Textfield}    ${Deal_Name}
    Mx LoanIQ Select List    ${LIQ_FacilitySelect_IdentifyBy_List}    Name
    Mx LoanIQ Enter    ${LIQ_FacilitySelect_FacilityName_Textfield}    ${Facility_Name}
    Mx LoanIQ Click    ${LIQ_FacilitySelect_OK_Button}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/FacilityWindow_SummaryTab
    Validate Loan IQ Details    ${Maturity_Date}    ${LIQ_FacilitySummary_FinalMaturityDate_Datefield}
    Mx LoanIQ Select    ${LIQ_FacilityNotebook_File_Exit}

Update Expiry Date in Facility Change Transaction
    [Documentation]    This keyword updates the Expiry Date of the Facility
    ...    @author: ghabal
    [Arguments]    ${New_ExpiryDate}        
    mx LoanIQ activate    ${LIQ_FacilityChangeTransaction_Window}    
    Mx LoanIQ DoubleClick    ${LIQ_FacilityChangeTransaction_FieldName_List}    Expiry Date
    mx LoanIQ activate    ${LIQ_EnterExpiryDate_Window}
    mx LoanIQ enter    ${LIQ_EnterExpiryDate_ExpiryDate_Textfield}    ${New_ExpiryDate}
    mx LoanIQ click    ${LIQ_EnterExpiryDate_Ok_Button}        
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
        
Update Maturity Date in Facility Change Transaction
    [Documentation]    This keyword updates the Maturity Date of the Facility
    ...    @author: ghabal
    [Arguments]    ${New_MaturityDate}        
    mx LoanIQ activate    ${LIQ_FacilityChangeTransaction_Window}    
    Mx LoanIQ DoubleClick    ${LIQ_FacilityChangeTransaction_FieldName_List}    Maturity Date
    mx LoanIQ activate    ${LIQ_EnterMaturityDate_Window}
    mx LoanIQ enter    ${LIQ_EnterMaturityDate_MaturityDate_Textfield}    ${New_MaturityDate}
    mx LoanIQ click    ${LIQ_EnterMaturityDate_Ok_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}        
    
Update Expiry and Maturity Date in Facility Change Transaction
    [Documentation]    This keyword updates the Expiry and Maturity Date of the Facility
    ...    @author: ghabal
    ...    @update: fmamaril    24APR2019    Remove writing and read on low level keyword; Added return for the business date  
    ...    @update: dfajardo    22JUL2020    - Added Screenshot and Post Processing Keywords
    [Arguments]    ${sRuntime_Variable_NewBusinessDateAfterEODBatchRun}=None      
    ${NewBusinessDateAfterEODBatchRun}    Get System Date
    Update Expiry Date in Facility Change Transaction    ${NewBusinessDateAfterEODBatchRun}
    Update Maturity Date in Facility Change Transaction    ${NewBusinessDateAfterEODBatchRun}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityChangeTransactionNotebook_GeneralTab
    
    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRuntime_Variable_NewBusinessDateAfterEODBatchRun}    ${NewBusinessDateAfterEODBatchRun}
    [RETURN]    ${NewBusinessDateAfterEODBatchRun}
            
Update Terminate Date in Facility Change Transaction
    [Documentation]    This keyword updates the Terminate Date of the Facility
    ...    @author: ghabal
    ...    @update: fmamaril    24APR2019    Remove writing on low level keyword; Return Terminate Date
    ...    @update: dfajardo    22JUL2020    - Added Screenshot and Post Processing Keywords
    [Arguments]    ${sRuntime_Variable_Terminate_Date}=None    
    ${Terminate_Date}    Get System Date
    Mx LoanIQ DoubleClick    ${LIQ_FacilityChangeTransaction_FieldName_List}    Termination
    mx LoanIQ activate    ${LIQ_TerminateFacility_Window}
    Mx LoanIQ Set    ${LIQ_TerminateFacility_TerminationDate_YesRadioButton}    ON 
    mx LoanIQ enter    ${LIQ_TerminateFacility_TerminationDate_Textfield}    ${Terminate_Date}
    mx LoanIQ click    ${LIQ_TerminateFacility_Ok_Button}         
    ${result}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Error_OK_Button}    VerificationData="Yes"
    Run Keyword If   '${result}'=='True'    Log    "Termination Halted. There are still pending dues. Please settle them."    
    ...     ELSE    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityChangeTransactionNotebook_TerminateFacility  

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRuntime_Variable_Terminate_Date}    ${Terminate_Date}
    [RETURN]    ${Terminate_Date}  
 
Modify Facility Processing Area   
    [Documentation]    This keyword updates the Facility Processing area.
    ...    @author: rtarayao    24SEP2019    - Initial Create
    [Arguments]    ${sProcessingAreaDescription}        
    mx LoanIQ activate    ${LIQ_FacilityChangeTransaction_Window} 
    Mx LoanIQ Select String    ${LIQ_FacilityChangeTransaction_FieldName_List}    Branch/Processing Area 
    Mx Native Type    {ENTER}   
    Mx LoanIQ Select Combo Box Value    ${LIQ_FacilityChangeTransaction_ChangeBranchProcArea_List}    ${sProcessingAreaDescription} 
    mx LoanIQ click    ${LIQ_FacilityChangeTransaction_ChangeBranchProcArea_OK_Button}       

Modify Facility Effective Date   
    [Documentation]    This keyword updates the Facility Effective Date.
    ...    @author: rtarayao    24SEP2019    - Initial Create
    [Arguments]    ${sEffectiveDate}
    mx LoanIQ activate    ${LIQ_FacilityChangeTransaction_Window} 
    Mx LoanIQ Select String    ${LIQ_FacilityChangeTransaction_FieldName_List}    Effective Date
    Mx Native Type    {ENTER}
    mx LoanIQ enter    ${LIQ_FacilityChangeTransaction_EnterEffectiveDate_Datefield}    ${sEffectiveDate}
    mx LoanIQ click    ${LIQ_FacilityChangeTransaction_EnterEffectiveDate_OK_Button}
    
Modify Facility Type   
    [Documentation]    This keyword updates the Facility Type.
    ...    @author: rtarayao    24SEP2019    - Initial Create
    [Arguments]    ${sFacilityType}
    mx LoanIQ activate    ${LIQ_FacilityChangeTransaction_Window} 
    Mx LoanIQ Select String    ${LIQ_FacilityChangeTransaction_FieldName_List}    Facility Type/Subtype
    Mx Native Type    {ENTER}
    Mx LoanIQ Select Combo Box Value    ${LIQ_FacilityChangeTransaction_ChangeFacilityType_Type_List}    ${sFacilityType}
    mx LoanIQ click    ${LIQ_FacilityChangeTransaction_ChangeFacilityType_OK_Button}

Update Facility Type in Facility Change Transaction
    [Documentation]    This keyword updates the Facility Type of the Facility
    ...    @author: ehugo    16SEP2019    Initial create
    ...    @update: amansuet    02OCT2019    Added screenshot
    [Arguments]    ${sNew_FacilityType}        
    mx LoanIQ activate    ${LIQ_FacilityChangeTransaction_Window}    
    Mx LoanIQ DoubleClick    ${LIQ_FacilityChangeTransaction_FieldName_List}    Facility Type/Subtype
    mx LoanIQ activate    ${LIQ_FacilityChangeTransaction_ChangeFacilityType_Window}
    Mx LoanIQ Optional Select    ${LIQ_FacilityChangeTransaction_ChangeFacilityType_Type_Field}    ${sNew_FacilityType}    
    mx LoanIQ click    ${LIQ_FacilityChangeTransaction_ChangeFacilityType_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}        
    Take Screenshot    Updated_FacilityType_FacilityChangeTransaction
    
Update Facility Owning Branch in Facility Change Transaction
    [Documentation]    This keyword updates the Facility Owning Branch of the Facility
    ...    @author: ehugo    23SEP2019    Initial create
    ...    @update: amansuet    02OCT2019    Added screenshot
    [Arguments]    ${sNew_Branch}    
        
    mx LoanIQ activate    ${LIQ_FacilityChangeTransaction_Window}    
    Mx LoanIQ DoubleClick    ${LIQ_FacilityChangeTransaction_FieldName_List}    Branch/Processing Area
    mx LoanIQ activate    ${LIQ_FacilityNotebook_ChangeBranchProcArea_Window}
    Mx LoanIQ Optional Select    ${LIQ_FacilityNotebook_ChangeBranchProcArea_Branch_Field}    ${sNew_Branch}
    mx LoanIQ click    ${LIQ_FacilityNotebook_ChangeBranchProcArea_OK_Button}
    Take Screenshot    Updated_FacilityOwningBranch_FacilityChangeTransaction

Update Facility Processing Area in Facility Change Transaction
    [Documentation]    This keyword updates the Facility Processing Area of the Facility
    ...    @author: ehugo    23SEP2019    Initial create
    ...    @update: amansuet    02OCT2019    Added screenshot
    [Arguments]    ${sNew_ProcessingArea}    
        
    mx LoanIQ activate    ${LIQ_FacilityChangeTransaction_Window}    
    Mx LoanIQ DoubleClick    ${LIQ_FacilityChangeTransaction_FieldName_List}    Branch/Processing Area
    mx LoanIQ activate    ${LIQ_FacilityNotebook_ChangeBranchProcArea_Window}
    Mx LoanIQ Optional Select    ${LIQ_FacilityNotebook_ChangeBranchProcArea_ProcessingArea_Field}    ${sNew_ProcessingArea}
    mx LoanIQ click    ${LIQ_FacilityNotebook_ChangeBranchProcArea_OK_Button}
    Take Screenshot    Updated_FacilityProcessingArea_FacilityChangeTransaction
    
Update Facility Effective Date in Facility Change Transaction
    [Documentation]    This keyword updates the Facility Effective Date (in %d-%b-%Y format, e.g. 01-Jan-2019) of the Facility
    ...    @author: ehugo    23SEP2019    Initial create
    ...    @update: amansuet    02OCT2019    Added screenshot
    [Arguments]    ${sNew_EffectiveDate}    
        
    mx LoanIQ activate    ${LIQ_FacilityChangeTransaction_Window}    
    Mx LoanIQ DoubleClick    ${LIQ_FacilityChangeTransaction_FieldName_List}    Effective Date
    mx LoanIQ activate    ${LIQ_EnterEffectiveDate_Window}
    mx LoanIQ enter    ${LIQ_EnterEffectiveDate_Datefield}    ${sNew_EffectiveDate}    
    mx LoanIQ click    ${LIQ_EnterEffectiveDate_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}     
    Take Screenshot    Updated_FacilityEffectiveDate_FacilityChangeTransaction
    
Update Multiple Fields of Facility in Facility Change Transaction
    [Documentation]    This keyword updates multiple fields (Facility Type, Owning Branch, Processing Area) of the Facility
    ...    @author: ehugo    23SEP2019    Initial create
    ...    @update: hstone    25SEP2019   Removed update of Effective Date
    [Arguments]    ${sNew_FacilityType}    ${sNew_Branch}    ${sNew_ProcessingArea}
    
    Update Facility Type in Facility Change Transaction    ${sNew_FacilityType}
    Update Facility Owning Branch in Facility Change Transaction    ${sNew_Branch}
    Update Facility Processing Area in Facility Change Transaction    ${sNew_ProcessingArea}
    
Update Facility Primary Borrower in Facility Change Transaction
    [Documentation]    This keyword updates the Facility Primary Borrower of the Facility
    ...    @author: ehugo    24SEP2019    Initial create
    ...    @update: amansuet    02OCT2019    Added screenshot
    [Arguments]    ${sNew_PrimaryBorrower}    
        
    mx LoanIQ activate    ${LIQ_FacilityChangeTransaction_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityChangeTransaction_Tab}    Borrowers
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FacilityChangeTransaction_BorrowersTab_NewBorrowers_JavaTree}    ${sNew_PrimaryBorrower}%s
    mx LoanIQ click    ${LIQ_FacilityChangeTransaction_BorrowersTab_MakePrimary_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    Updated_FacilityPrimaryBorrower_FacilityChangeTransaction
    
Delete Borrower in Facility Change Transaction
    [Documentation]    This keyword deletes a borrower in Facility Change Transaction
    ...    @author: ehugo    24SEP2019    Initial create
    ...    @update: amansuet    02OCT2019    Added screenshot
    [Arguments]    ${sBorrower}    
        
    mx LoanIQ activate    ${LIQ_FacilityChangeTransaction_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityChangeTransaction_Tab}    Borrowers
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FacilityChangeTransaction_BorrowersTab_NewBorrowers_JavaTree}    ${sBorrower}%s
    mx LoanIQ click    ${LIQ_FacilityChangeTransaction_BorrowersTab_DeleteBorrower_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    Take Screenshot    Deleted_Borrower_FacilityChangeTransaction

Add Borrower in Facility Change Transaction
    [Documentation]    This keyword adds a borrower in Facility Change Transaction
    ...    @author: amansuet    24SEP2019    - initial create
    ...    @update: amansuet    02OCT2019    Added screenshot
    [Arguments]    ${sBorrower}    
        
    mx LoanIQ activate    ${LIQ_FacilityChangeTransaction_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityChangeTransaction_Tab}    Borrowers
    mx LoanIQ click    ${LIQ_FacilityChangeTransaction_BorrowersTab_AddBorrower_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ activate    ${LIQ_BorrowerDepositorSelect_Window}
    Mx LoanIQ Select Combo Box Value    ${LIQ_BorrowerDepositorSelect_AddBorrower_Name_Field}    ${sBorrower}
    mx LoanIQ click    ${LIQ_BorrowerDepositorSelect_AddBorrower_AddAll_Button}
    mx LoanIQ click    ${LIQ_BorrowerDepositorSelect_AddBorrower_OK_Button}  
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    Added_Borrower_FacilityChangeTransaction
    
Add Guarantor in Facility Change Transaction
    [Documentation]    This keyword adds a Guarantor in Facility Change Transaction
    ...    @author: amansuet    24SEP2019    - initial create
    ...    @update: amansuet    01OCT2019    - added screenshot and validation
    [Arguments]    ${sGuarantor}    ${sGuaranteeType}    ${sEffectiveDate}    ${sExpiryDate}    ${sGlobalValue}
        
    mx LoanIQ activate    ${LIQ_FacilityChangeTransaction_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityChangeTransaction_Tab}    Guarantees
    mx LoanIQ click element if present    ${LIQ_FacilityChangeTransaction_InquiryMode_Button}
    mx LoanIQ click    ${LIQ_FacilityChangeTransaction_GuaranteesTab_AddGuarantee_Button}
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    mx LoanIQ activate    ${LIQ_FacilityChangeTransaction_GuaranteesTab_GuarantorSelect_Window}
    mx LoanIQ enter    ${LIQ_FacilityChangeTransaction_GuaranteesTab_GuarantorSelect_Textfield}    ${sGuarantor}
    mx LoanIQ click    ${LIQ_FacilityChangeTransaction_GuaranteesTab_GuarantorSelect_OKButton}
    mx LoanIQ activate    ${LIQ_FacilityGuarantorDetails_Window}
    Mx LoanIQ Select Combo Box Value    ${LIQ_FacilityGuarantorDetails_GuaranteeType_List}    ${sGuaranteeType}
    mx LoanIQ enter    ${LIQ_FacilityGuarantorDetails_CommercialRisk_EffectiveDate_Datefield}    ${sEffectiveDate}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ enter    ${LIQ_FacilityGuarantorDetails_CommercialRisk_ExpiryDate_Datefield}    ${sExpiryDate}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ enter    ${LIQ_FacilityGuarantorDetails_CommercialRisk_Global_Textfield}    ${sGlobalValue}
    mx LoanIQ enter    ${LIQ_FacilityGuarantorDetails_PoliticalRisk_EffectiveDate_Datefield}    ${sEffectiveDate}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ enter    ${LIQ_FacilityGuarantorDetails_PoliticalRisk_ExpiryDate_Datefield}    ${sExpiryDate}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ enter    ${LIQ_FacilityGuarantorDetails_PoliticalRisk_Global_Textfield}    ${sGlobalValue}
    mx LoanIQ click    ${LIQ_FacilityGuarantorDetails_OKButton}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    Added_Guarantor_FacilityChangeTransaction
    
    ## Validation ##
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_FacilityChangeTransaction_GuaranteesTab_NewGuarantees_JavaTree}    ${sGuarantor}
    Run Keyword If    '${status}'=='${True}'    Log    Guarantor '${sGuarantor}' is added successfully in Facility.
    ...    ELSE IF    '${status}'=='${False}'    Log    Guarantor '${sGuarantor}' is NOT added successfully in Facility.    level=ERROR

Delete Guarantor in Facility Change Transaction
    [Documentation]    This keyword adds a Guarantor in Facility Change Transaction
    ...    @author: amansuet    25SEP2019    - initial create
    ...    @update: amansuet    01OCT2019    - added screenshot and validation
    [Arguments]    ${sGuarantor}    

    mx LoanIQ activate    ${LIQ_FacilityChangeTransaction_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityChangeTransaction_Tab}    Guarantees
    mx LoanIQ click element if present    ${LIQ_FacilityChangeTransaction_InquiryMode_Button}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FacilityChangeTransaction_GuaranteesTab_NewGuarantees_JavaTree}    ${sGuarantor}%s
    mx LoanIQ click    ${LIQ_FacilityChangeTransaction_GuaranteesTab_DeleteGuarantee_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    Take Screenshot    Deleted_Guarantor_FacilityChangeTransaction
    
    Select Menu Item    ${LIQ_FacilityChangeTransaction_Window}    File    Save
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
    ## Validation ##
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_FacilityChangeTransaction_GuaranteesTab_NewGuarantees_JavaTree}    ${sGuarantor}
    Run Keyword If    '${status}'=='${False}'    Log    Guarantor '${sGuarantor}' is deleted successfully in Facility.
    ...    ELSE IF    '${status}'=='${True}'    Log    Guarantor '${sGuarantor}' is NOT deleted successfully in Facility.    level=ERROR

Replace Guarantor in Facility Change Transaction
    [Documentation]    This keyword adds a new Guarantor and removes the existing Guarantor in Facility Change Transaction
    ...    @author: amansuet    25SEP2019    - initial create
    ...    @update: amansuet    01OCT2019    - added screenshot and validation
    [Arguments]    ${sGuarantor_Old}    ${sGuarantor_New}    ${sGuaranteeType}    ${sEffectiveDate}    ${sExpiryDate}    ${sGlobalValue}
        
    Add Guarantor in Facility Change Transaction    ${sGuarantor_New}    ${sGuaranteeType}    ${sEffectiveDate}    ${sExpiryDate}    ${sGlobalValue}
    Delete Guarantor in Facility Change Transaction    ${sGuarantor_Old}
    Take Screenshot    Replaced_Guarantor_FacilityChangeTransaction
    
    ## Validation ##
    ${status_add}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_FacilityChangeTransaction_GuaranteesTab_NewGuarantees_JavaTree}    ${sGuarantor_New}
    ${status_del}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_FacilityChangeTransaction_GuaranteesTab_NewGuarantees_JavaTree}    ${sGuarantor_Old}
    Run Keyword If    '${status_add}'=='${True}' and '${status_del}'=='${False}'    Log    Guarantor '${sGuarantor_Old}' is replaced with '${sGuarantor_New}' successfully in Facility.
    ...    ELSE IF    '${status_add}'=='${False}' and '${status_del}'=='${True}'    Log    Guarantor '${sGuarantor_Old}' is NOT replaced with '${sGuarantor_New}' successfully in Facility.    level=ERROR

Replace Borrower in Facility Change Transaction
    [Documentation]    This keyword removes an existing borrower and adds a new borrower in Facility Change Transaction
    ...    @author: amansuet    21OCT2019    - initial create
    [Arguments]    ${sBorrowerOld}    ${sBorrowerNew}
        
    Delete Borrower in Facility Change Transaction    ${sBorrowerOld}
    Add Borrower in Facility Change Transaction    ${sBorrowerNew}
    Take Screenshot    Replaced_Borrower_FacilityChangeTransaction
    
    ## Validation ##
    mx LoanIQ activate    ${LIQ_FacilityChangeTransaction_Window}
    ${status_add}    Run Keyword And Return Status    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FacilityChangeTransaction_BorrowersTab_NewBorrowers_JavaTree}    ${sBorrowerNew}%s
    ${status_del}    Run Keyword And Return Status    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FacilityChangeTransaction_BorrowersTab_NewBorrowers_JavaTree}    ${sBorrowerOld}%s
    Run Keyword If    '${status_add}'=='${True}' and '${status_del}'=='${False}'    Log    Guarantor '${sBorrowerOld}' is replaced with '${sBorrowerNew}' successfully in Facility.
    ...    ELSE IF    '${status_add}'=='${False}' and '${status_del}'=='${True}'    Fail    Guarantor '${sBorrowerOld}' is NOT replaced with '${sBorrowerNew}' successfully in Facility

Input Future Termination Effective Date in Facility Change Transaction
    [Documentation]    This keyword inputs future termination effective date in FCT
    ...    @author: fmamaril    30OCT2019    Initial Create
    ${Terminate_Date}    Get System Date
    Mx LoanIQ DoubleClick    ${LIQ_FacilityChangeTransaction_FieldName_List}    Termination
    mx LoanIQ activate    ${LIQ_TerminateFacility_Window}
    Mx LoanIQ Set    ${LIQ_TerminateFacility_TerminationDate_YesRadioButton}    ON
    ${Terminate_Date}    Convert Date    ${Terminate_Date}     date_format=%d-%b-%Y
    ${Terminate_Date}    Add Time To Date    ${Terminate_Date}    365 days         
    mx LoanIQ enter    ${LIQ_TerminateFacility_TerminationDate_Textfield}    ${Terminate_Date}
    mx LoanIQ click    ${LIQ_TerminateFacility_Ok_Button}
    ${result}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_Error_MessageBox}    value%Termination date cannot be greater than change transaction effective date.
    Run Keyword If   '${result}'=='True'    Log    "Termination date cannot be greater than change transaction effective date."    
    ...     ELSE    Fail    "Future date should not be accepted as Termination date."
    mx LoanIQ click element if present    ${LIQ_Error_OK_Button}    
    Close All Windows on LIQ

Set New Value of Dates under General Tab in Facility Change Transaction
    [Documentation]    This keyword set a new value of dates in Facility Change Transaction
    ...    @author: amansuet    25OCT2019    - initial create
    ...    @update: amansuet    05NOV2019    - updated keyword for reusability
    [Arguments]    ${sDate_Type}    ${sDate_NewValue}    

    mx LoanIQ activate    ${LIQ_FacilityChangeTransaction_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityChangeTransaction_Tab}    General
    mx LoanIQ click element if present    ${LIQ_FacilityChangeTransaction_InquiryMode_Button}
    Mx LoanIQ DoubleClick    ${LIQ_FacilityChangeTransaction_GeneralTab_JavaTree}    ${sDate_Type}
    
    ${Date_Field}    Run Keyword If    '${sDate_Type}'=='Expiry Date'    Set Variable    ${LIQ_EnterExpiryDate_Datefield}
    ...    ELSE IF    '${sDate_Type}'=='Maturity Date'    Set Variable    ${LIQ_EnterMaturityDate_MaturityDate_Datefield}

    ${OK_Button}    Run Keyword If    '${sDate_Type}'=='Expiry Date'    Set Variable    ${LIQ_EnterExpiryDate_OK_Button}
    ...    ELSE IF    '${sDate_Type}'=='Maturity Date'    Set Variable    ${LIQ_EnterMaturityDate_OK_Button}
    
    ${Cancel_Button}    Run Keyword If    '${sDate_Type}'=='Expiry Date'    Set Variable    ${LIQ_EnterExpiryDate_Cancel_Button}
    ...    ELSE IF    '${sDate_Type}'=='Maturity Date'    Set Variable    ${LIQ_EnterMaturityDate_Cancel_Button}

    mx LoanIQ enter    ${Date_Field}    ${sDate_NewValue}
    mx LoanIQ click    ${OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    SetNewValue_${sDate_Type}_FacilityChangeTransaction
    
    Select Menu Item    ${LIQ_FacilityChangeTransaction_Window}    File    Save
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
    Mx LoanIQ DoubleClick    ${LIQ_FacilityChangeTransaction_GeneralTab_JavaTree}    ${sDate_Type}
    
    ## Validation ##
    ${Date_ActualValue}    Mx LoanIQ Get Data    ${Date_Field}    input=Actual_Value
    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${sDate_NewValue}    ${Date_ActualValue}
    ${Validate_Date}    Run Keyword And Return Status    Should Be Equal As Strings    ${sDate_NewValue}    ${Date_ActualValue}
    Run Keyword If    ${Validate_Date}==True    Log    The new value '${sDate_NewValue}' for ${sDate_Type} is set successfully in Facility Change Transaction.
    ...    ELSE    Log    The new value '${sDate_NewValue}' for ${sDate_Type} is NOT set successfully in Facility Change Transaction.    level=ERROR
    
    mx LoanIQ click    ${Cancel_Button}

Validate Facility Change Transaction Guarantor Primary Indicator Does Not Exist
    [Documentation]    This keyword is used to validate if the facility change transaction guarantor primary indicator does not exist.
    ...    @author: hstone    08JAN2020    - Initial Create 
    [Arguments]    ${sPrimaryIndicatorHeaders_List}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityChangeTransaction_Tab}    Guarantees
    ${result}    Set Variable    ${FALSE}
    
    :FOR    ${sPrimaryIndicatorHeader}    IN    @{sPrimaryIndicatorHeaders_List}
    \    ${sCurrentPrimaryIndicatorHeader}    Set Variable    ${sPrimaryIndicatorHeader}
    \    ${result}    Verify if String Exists as Java Tree Header    ${LIQ_FacilityChangeTransaction_GuaranteesTab_OldGuarantees_JavaTree}    ${sPrimaryIndicatorHeader}
    \    Exit For Loop If    ${result}==${TRUE}
    \    ${result}    Verify if String Exists as Java Tree Header    ${LIQ_FacilityChangeTransaction_GuaranteesTab_NewGuarantees_JavaTree}    ${sPrimaryIndicatorHeader}
    \    Exit For Loop If    ${result}==${TRUE}
    Take Screenshot    Guarantor_PrimaryIndicator_Validation_DealNotebook
    
    Run Keyword If    ${result}==${FALSE}    Log    Guarantor Primary Indicator Does Not Exist.
    ...    ELSE    Fail    Guarantor Primary Indicator Exists. '${sCurrentPrimaryIndicatorHeader}' Primary Guarantor Indicator Header is Found!!!

Validate Facility Change Transaction Guarantor Make Primary Button Does Not Exist
    [Documentation]    This keyword is used to validate if the guarantor make primary button does not exist.
    ...    @author: hstone    08JAN2020    - Initial Create 
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityChangeTransaction_Tab}    Guarantees
    
    ${Status}    Run Keyword And Return Status    Mx LoanIQ Click    ${LIQ_FacilityChangeTransaction_GuaranteesTab_MakePrimary_Button}       
    Run Keyword If    ${Status}==True    Fail    'Make Primary Button' exists !!!
    ...    ELSE    Log    'Make Primary' Button is not found at Facility Change Transaction; Guarantees Tab.
   
Add Facility Borrower Base in Facility Change Transaction
    [Documentation]    This keyword updates the  Borrowing base of the Facility
    ...    @author: Archana 18Jun2020 
    mx LoanIQ activate    ${LIQ_FacilityChangeTransaction_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityChangeTransaction_Tab}    Borrowing Base
    Mx LoanIQ Click    ${LIQ_FacilityAddBorrowerBase_Button}
    
Add Borrowing Base Deatils
    [Documentation]    This keyword is used to add Borrowing base details
    ...    @author:Archana 18Jun2020
    ...           - Added Pre-processing keywords
    [Arguments]    ${sBorrowing}    ${sEffectiveDate}    ${sExpirationDate}    ${sGracePeriod}    ${sCollateral}    ${sIneligibleValue}    ${sCapFlat}    ${sAdvance}
    
####Pre-processing keyword###
    ${Borrowing}    Acquire Argument Value    ${sBorrowing}
    ${EffectiveDate}    Acquire Argument Value    ${sEffectiveDate}
    ${ExpirationDate}    Acquire Argument Value    ${sExpirationDate}
    ${GracePeriod}    Acquire Argument Value    ${sGracePeriod}
    ${Collateral}    Acquire Argument Value    ${sCollateral}
    ${IneligibleValue}    Acquire Argument Value    ${sIneligibleValue}
    ${CapFlat}    Acquire Argument Value    ${sCapFlat}
    ${Advance}    Acquire Argument Value    ${sAdvance}
    
    Mx LoanIQ Activate Window    ${LIQ_BorrowingBaseDetails_Window}
    Mx LoanIQ Select Combo Box Value    ${LIQ_BorrowingBaseDetails_Borrow_Combobox}     ${Borrowing}
    Mx LoanIQ Enter    ${LIQ_BorrowingBaseDetails_EffectiveDate}    ${EffectiveDate}
    Mx LoanIQ Enter    ${LIQ_BorrowingBaseDetails_Expiration}    ${ExpirationDate}
    Mx LoanIQ Enter    ${LIQ_BorrowingBaseDetails_GracePeriod}    ${GracePeriod}
    Mx LoanIQ Enter    ${LIQ_BorrowingBaseDetails_Collateral}    ${Collateral}
    Mx LoanIQ Enter    ${LIQ_BorrowingBaseDetails_IneligibleValue}    ${IneligibleValue} 
    Mx LoanIQ Enter    ${LIQ_BorrowingBaseDetails_CapFlat}    ${CapFlat}
    Mx LoanIQ Enter    ${LIQ_BorrowingBaseDetails_Advance}    ${Advance}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/BorrowingBaseDetails   
    Mx LoanIQ Click    ${LIQ_BorrowingBaseDetails_OK_Button}    
    
Approve Borrower BaseCreation 
    [Documentation]    This keyword will approve the Awaiting Approval - Borrower Base Creation
    ...    @author: Archana 18Jun2020
    mx LoanIQ activate    ${LIQ_FacilityChangeTransaction_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityChangeTransaction_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FacilityChangeTransaction_Worflow_Tab}    Approval%d
     mx LoanIQ click element if present    ${LIQ_Question_Yes_Button} 
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present     ${LIQ_Warning_Yes_Button}
    :FOR    ${i}    IN RANGE    3
     \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
     \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}     VerificationData="Yes"
     \    Exit For Loop If    ${Warning_Status}==False
     \    Log    Creation of Borrower Base is now approved          
     
Release Borrower BaseCreation in Workflow
    [Documentation]    This keyword is used to release a transaction-Borrower base Creation
    ...    @author:Archana 18Jun2020
    mx LoanIQ activate    ${LIQ_FacilityChangeTransaction_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityChangeTransaction_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FacilityChangeTransaction_Worflow_Tab}    Release%d
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present     ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Verify Object Exist    ${LIQ_FacilityChangeTransaction_WorkflowNoItems_Tab}        VerificationData="Yes"
    mx LoanIQ select    ${LIQ_FacilityChangeTransaction_File_Exit}
    mx LoanIQ click element if present     ${LIQ_Reminder_OK_Button}
    mx LoanIQ activate window    ${LIQ_TransactionInProcess_Window}
    mx LoanIQ select    ${LIQ_TransactionsInProcess_FileExit_Menu} 
    
Verification of Borrower Base Created in Facility Change Transaction
    [Documentation]    This keyword is used to verify the Borrower Base created
    ...  @author:Archana 18Jun2020
    ...         - Added Pre-processing Keyword and Post processing keyword
    [Arguments]    ${sBorrowing_Base}    ${RunTimeVar_BorrowerBase_Collateral}=None    ${RunTimeVar_BorrowerBase_Lendable}=None    ${RunTimeVar_BorrowerBase_Advance}=None    ${RunTimeVar_BorrowerBase_Value}=None
    
    ###Pre-processing Keyword###
    ${Borrowing_Base}    Acquire Argument Value    ${sBorrowing_Base}
       
    mx LoanIQ activate    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Risk 
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FacilityBorrowingBase_JavaTree}    ${Borrowing_Base}%d  
    ${BorrowerBase_Collateral}    Mx LoanIQ Get Data    ${LIQ_BorrowingBaseDetails_Collateral}    input= value    
    ${BorrowerBase_Lendable}    Mx LoanIQ Get Data    ${LIQ_BorrowingBaseDetails_Lendable}    input= value
    ${BorrowerBase_Advance}    Mx LoanIQ Get Data    ${LIQ_BorrowingBaseDetails_Advance}    input= value
    ${BorrowerBase_Value}    Mx LoanIQ Get Data    ${LIQ_BorrowingBaseDetails_BorrowerBase}    input= value
    
    ###Post-Processing keyword###
     Save Values of Runtime Execution on Excel File    ${RunTimeVar_BorrowerBase_Collateral}    ${BorrowerBase_Collateral}
     Save Values of Runtime Execution on Excel File    ${RunTimeVar_BorrowerBase_Lendable}    ${BorrowerBase_Lendable}
     Save Values of Runtime Execution on Excel File    ${RunTimeVar_BorrowerBase_Advance}    ${BorrowerBase_Advance}
     Save Values of Runtime Execution on Excel File    ${RunTimeVar_BorrowerBase_Value}    ${BorrowerBase_Value}

    [Return]    ${BorrowerBase_Collateral}    ${BorrowerBase_Lendable}    ${BorrowerBase_Advance}    ${BorrowerBase_Value}        