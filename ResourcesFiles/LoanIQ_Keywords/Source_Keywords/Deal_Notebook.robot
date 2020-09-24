*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Validate Fields on Deal Select Screen
    [Documentation]    This keywod validates the availability of objects in Deal Select Screen.
    ...    @author: fmamaril
    [Tags]    Validation
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_DelectSelect_NewDeal_RadioButton}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_DelectSelect_Existing_RadioButton}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_DelectSelect_UseWizards_RadioButton}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_DelectSelect_MassSale_RadioButton}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_DelectSelect_Active_RadioButton}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_DelectSelect_Inactive_RadioButton}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_DelectSelect_Both_RadioButton}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_DealSelect_Ok_Button}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_DealSelect_Search_Button}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_DealSelect_Cancel_Button}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_DealSelect_IdentifyBy_Text}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_DealSelect_IdentifyBy_List}    VerificationData="Yes"
    
Validate Fields on Deal Select Screen for New Deal
    [Documentation]    This keywod validates the availability of objects after selecting New Radio button in Deal Select Screen.
    ...    @author: fmamaril
    [Tags]    Validation
    [Arguments]    ${ExcelPath}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_DelectSelect_NewDeal_RadioButton}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_DelectSelect_Existing_RadioButton}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_DelectSelect_UseWizards_RadioButton}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_DelectSelect_MassSale_RadioButton}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_DealSelect_DropInFolder_Checkbox}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_DealSelect_TicketMode_Checkbox}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_DealSelect_Name_TextField}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_DealSelect_Alias_TextField}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_DealSelect_Department_SelectBox}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_DealSelect_Tracking_TextField}    VerificationData="Yes"
    ${IDvalue}    Mx LoanIQ Get Data    ${LIQ_DealSelect_Tracking_TextField}    value%IDvalue    
    Run Keyword And Continue On Failure    Should Not Be Equal    ${IDvalue}    ${null}    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_DealSelect_AlternateID_TextField}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_DealSelect_ANSIID_TextField}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_DealSelect_Ok_Button}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_DealSelect_Search_Button}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_DealSelect_Cancel_Button}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_DealSelect_SalesGroups_Button}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Validate if Element is Disabled    ${LIQ_DealSelect_Search_Button}    Search
                  
Create New Deal
    [Documentation]    This keywod selects New radio button and popuate fields for Deal Select Window.
    ...    @author: fmamari
    ...    @update: mnanquil
    ...    Updated the keyword for Mx LoanIQ Verify text in JavaTree to Mx LoanIQ Select String
    ...    Added a for loop for line 72 to not wait if yes warning button if not existing.
    ...    @update: bernchua    28JUN2019    Deleted commented lines
    ...                                      Removed unused ${rowid} Argument
    ...    @update: bernchua    31JUL2019    Used generic keyword for clikcing warning message
    ...    @update: bernchua    21AUG2019    Added Take Screnshot keyword
    ...    @update: amansuet    02APR2020    Updated to align with automation standards and added keyword pre and post processing
    ...    @update: ehugo    28MAY2020    - added keyword pre-processing for non-unique arguments
    [Arguments]    ${sDeal_Name}    ${sDeal_Alias}    ${sDeal_Currency}    ${sDeal_Department}    ${sDeal_SalesGroup}

    ### Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}    ${ARG_TYPE_UNIQUE_NAME_VALUE}
    ${Deal_Alias}    Acquire Argument Value    ${sDeal_Alias}    ${ARG_TYPE_UNIQUE_NAME_VALUE}
    ${Deal_Currency}    Acquire Argument Value    ${sDeal_Currency}
    ${Deal_Department}    Acquire Argument Value    ${sDeal_Department}
    ${Deal_SalesGroup}    Acquire Argument Value    ${sDeal_SalesGroup}

    ### Keyword Process ###
    Select Actions    [Actions];Deal
    Validate Fields on Deal Select Screen
    Mx LoanIQ Set    ${LIQ_DelectSelect_NewDeal_RadioButton}    ON
    Run Keyword And Continue On Failure    Validate Fields on Deal Select Screen for New Deal    ${Deal_Currency}     
    mx LoanIQ enter    ${LIQ_DealSelect_Name_TextField}    ${Deal_Name}
    mx LoanIQ enter    ${LIQ_DealSelect_Alias_TextField}    ${Deal_Alias}  
    Mx LoanIQ select combo box value    ${LIQ_DealSelect_Currenrcy_SelectBox}    ${Deal_Currency}
    Mx LoanIQ select combo box value    ${LIQ_DealSelect_Department_SelectBox}    ${Deal_Department}
    Run Keyword And Continue On Failure    Validate Input on Create New Deal    ${Deal_Name}    ${Deal_Department}    ${Deal_Currency}   ${Deal_Alias} 
    mx LoanIQ click    ${LIQ_DealSelect_SalesGroups_Button}
    Mx LoanIQ Select String    ${LIQ_SalesGroup_Available_JavaTree}    ${Deal_SalesGroup}
    mx LoanIQ click    ${LIQ_SalesGroup_OK_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_DealSelect_SalesGroups_JavaTree}    ${Deal_SalesGroup}
    Run Keyword And Continue On Failure    Mx LoanIQ Select String   ${LIQ_DealSelect_SalesGroups_JavaTree}    Yes
    ${Status}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_DealSelect_DropInFolder_Checkbox}    value%1
    Run Keyword If    ${Status}==False    Mx LoanIQ Set    ${LIQ_DealSelect_DropInFolder_Checkbox}    ON                
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Deal_Select
    mx LoanIQ click    ${LIQ_DealSelect_Ok_Button}
    Verify If Warning Is Displayed        
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    Run Keyword And Continue On Failure    Validate Deal Window after creation    ${Deal_Name}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Deal_Window
      
    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sDeal_Name}    ${Deal_Name}
    Save Values of Runtime Execution on Excel File    ${sDeal_Alias}    ${Deal_Alias}
    
Validate Deal Window after creation
    [Tags]    Validation
    [Arguments]    ${Deal_Name}
    [Documentation]    This keywod selects New radio button and popuate fields for Deal Select Window.
    ...    @author: fmamaril   
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Deal Notebook - Pending Deal - ${Deal_Name}")    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_DealNotebook_Restrict_Label}    VerificationData="Yes"
    
Validate Input on Create New Deal
    [Tags]    Validation
    [Arguments]    ${Deal_Name}    ${Deal_Department}    ${Deal_Currency}    ${Deal_Alias}    
    [Documentation]    This keywod selects New radio button and popuate fields for Deal Select Window.
    ...    @author: fmamaril
    Validate Loan IQ Details    ${Deal_Name}    ${LIQ_DealSelect_Name_TextField}
    Validate Loan IQ Details    ${Deal_Department}    ${LIQ_DealSelect_Department_SelectBox}
    Validate Loan IQ Details    ${Deal_Currency}    ${LIQ_DealSelect_Currenrcy_SelectBox}                  
    Validate Loan IQ Details    ${Deal_Alias}    ${LIQ_DealSelect_Alias_TextField}
          
Unrestrict Deal
    [Documentation]    This keyword unrestricts a deal.
    ...    @author: fmamaril

    Mx LoanIQ Activate Window    ${LIQ_DealNotebook_Window}
    Mx LoanIQ Select    ${LIQ_DealNotebook_DistributionRestrict_Menu}
    Mx LoanIQ Verify Runtime Property    ${LIQ_Warning_MessageBox}    value%Once the deal is unrestricted, it cannot be restricted again. Are you sure you want to unrestrict this deal?
    Run Keyword And Continue On Failure    Wait Until Keyword Succeeds    30s    3s    Validate if Element is Enabled    ${LIQ_Warning_Yes_Button}    Warning Yes
    Run Keyword And Continue On Failure    Wait Until Keyword Succeeds    30s    3s    Validate if Element is Enabled    ${LIQ_Warning_No_Button}    Warning No   
    Run Keyword And Continue On Failure    Wait Until Keyword Succeeds    30s    3s    mx LoanIQ click    ${LIQ_Warning_Yes_Button}
    ${Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_DealNotebook_Restrict_Label}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Should Not Be True   ${Status}==True
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealWindow_Summary
    
Add Deal Borrower
    [Documentation]    It adds the borrower name in a deal
    ...    @author: fmamaril
    ...    @update: amansuet    23APR2020    - Updated to align with automation standards and added keyword pre-processing
    ...    @update: ehugo    28MAY2020    - added screenshot
    [Arguments]    ${sDeal_Borrower}

    ### GetRuntime Keyword Pre-processing ###
    ${Deal_Borrower}    Acquire Argument Value    ${sDeal_Borrower}

    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Summary   
    Run Keyword And Continue On Failure    mx LoanIQ click element if present    ${LIQ_InquiryMode_Button}
    mx LoanIQ click    ${LIQ_DealSummary_Add_Button}
    Validate Add Deal Borrower Select
    mx LoanIQ enter    ${LIQ_DealBorrowerSelect_ShortName_TextField}    ${Deal_Borrower}
    mx LoanIQ click    ${LIQ_DealBorrowerSelect_Search_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_DealBorrowerListByShortName_Tree}    ${Deal_Borrower}
    mx LoanIQ click    ${LIQ_DealBorrowerListByShortName_OK_Button}
    mx LoanIQ activate window    ${LIQ_DealBorrower_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Deal Borrower.*").JavaStaticText("text:=${Deal_Borrower}")    VerificationData="Yes"

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_Borrower

Set Deal Borrower
    [Documentation]    This keyword add a Borrower to a Deal
    ...    @author: bernchua
    ...    @update: ehugo    23JUN2020    - added keyword pre-processing; added screenshot
    [Arguments]    ${sBorrower_Name}    ${sBorrower_Location}

    ### GetRuntime Keyword Pre-processing ###
    ${Borrower_Name}    Acquire Argument Value    ${sBorrower_Name}
    ${Borrower_Location}    Acquire Argument Value    ${sBorrower_Location}

    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Summary  
    mx LoanIQ click element if present    ${LIQ_InquiryMode_Button}
    mx LoanIQ click    ${LIQ_DealSummary_Add_Button}
    Validate Add Deal Borrower Select
    mx LoanIQ enter    ${LIQ_DealBorrowerSelect_ShortName_TextField}    ${Borrower_Name}
    mx LoanIQ click    ${LIQ_DealBorrowerSelect_Ok_Button}    
    ${Location}    Mx LoanIQ Get Data    ${LIQ_DealBorrower_Location_List}    value%location
    Run Keyword If    '${Location}'=='${EMPTY}'    Mx LoanIQ Select Combo Box Value    ${LIQ_DealBorrower_Location_List}    ${Borrower_Location}
    mx LoanIQ activate    ${LIQ_DealBorrower_Window}    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Deal Borrower.*").JavaStaticText("text:=${Borrower_Name}")    VerificationData="Yes"

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_Borrower
    
Validate Add Deal Borrower Select
    [Documentation]    This keyword validates add deal borrower window
    ...    @author: fmamaril
    [Tags]    Validation
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_DealBorrowerSelect_Window}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Validate if Element is Enabled    ${LIQ_DealBorrowerSelect_Search_Button}    Search
    Run Keyword And Continue On Failure    Validate if Element is Enabled    ${LIQ_DealBorrowerSelect_Ok_Button}    OK     
    Run Keyword And Continue On Failure    Validate if Element is Enabled    ${LIQ_DealBorrowerSelect_Cancel_Button}    Cancel
              
Select Deal Borrower Location and Servicing Group
    [Documentation]    This keyword selects a borrower location and servicing group.
    ...    @author: fmamaril
    ...    @update: amansuet    02APR2020    Updated to align with automation standards and added keyword pre-processing
    ...    @update: ehugo    28MAY2020    - added keyword pre-processing for other arguments; added screenshot
    [Arguments]    ${sBorrower_Location}    ${sBorrower_SGAlias}    ${sBorrower_SG_GroupMembers}    ${sBorrower_SG_Method}    ${sDeal_Borrower}    ${sBorrower_SG_Name}   

    ### GetRuntime Keyword Pre-processing ###
    ${Borrower_Location}    Acquire Argument Value    ${sBorrower_Location}
    ${Borrower_SGAlias}    Acquire Argument Value    ${sBorrower_SGAlias}
    ${Borrower_SG_GroupMembers}    Acquire Argument Value    ${sBorrower_SG_GroupMembers}
    ${Borrower_SG_Method}    Acquire Argument Value    ${sBorrower_SG_Method}
    ${Deal_Borrower}    Acquire Argument Value    ${sDeal_Borrower}
    ${Borrower_SG_Name}    Acquire Argument Value    ${sBorrower_SG_Name}

    Mx LoanIQ select combo box value    ${LIQ_DealBorrower_Location_List}    ${Borrower_Location}
    Validate Loan IQ Details    ${Borrower_Location}    ${LIQ_DealBorrower_Location_List}
    mx LoanIQ click    ${LIQ_DealBorrower_ServicingGroup_Button}    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_ServicingGroup_Window}    VerificationData="Yes"
    mx LoanIQ activate window    ${LIQ_ServicingGroup_Window}
    Mx LoanIQ Select String    ${LIQ_ServicingGroups_JavaTree}   ${Borrower_SGAlias}
    Mx LoanIQ Select String    ${LIQ_ServicingGroups_GroupMembers_JavaTree}   ${Borrower_SG_GroupMembers}
    Mx LoanIQ Select String    ${LIQ_ServicingGroups_RemittanceInctructions_JavaTree}   ${Borrower_SG_Method}
    mx LoanIQ click    ${LIQ_ServicingGroup_OK_Button}
    mx LoanIQ activate window    ${LIQ_DealBorrower_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.*${Deal_Borrower}.*").JavaStaticText("label:=${Borrower_SG_Name}")    VerificationData="Yes"

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_BorrowerLocation
    
Select Deal Borrower Remmitance Instruction
    [Documentation]    This keyword selects a remitance instruction.
    ...    @author: fmamaril
    ...    @update: amansuet    02APR2020    Updated to align with automation standards and added keyword pre-processing
    ...    @update: ehugo    28MAY2020    - added keyword pre-processing for other arguments; added screenshot
    [Arguments]    ${sDeal_Borrower}    ${sDeal_Name}    ${sBorrower_Location}
    
    ### GetRuntime Keyword Pre-processing ###
    ${Deal_Borrower}    Acquire Argument Value    ${sDeal_Borrower}
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    ${Borrower_Location}    Acquire Argument Value    ${sBorrower_Location}

    ### Keyword Process ###
    mx LoanIQ click    ${LIQ_DealBorrower_PreferredRemittanceInstructions_Button}
    Validate Warning Message Box 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    Deal Borrower.*;Warning;Yes    strProcessingObj="JavaWindow(\"title:=Processing.*\")"    WaitForProcessing=500
    Validate Deal Servicing Group    ${Deal_Borrower}    ${Deal_Name}    ${Borrower_Location}
    mx LoanIQ click    ${LIQ_ServicingGroupDetails_Add_Button}
    Mx LoanIQ Set    ${LIQ_PreferredRemittanceInstructions_All_Checkbox}    ON
    mx LoanIQ click    ${LIQ_PreferredRemittanceInstructions_Ok_Button}
    mx LoanIQ click    ${LIQ_ServicingGroupDetails_Ok_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_DealBorrower_Window}    VerificationData="Yes"
    Mx LoanIQ Set    ${LIQ_DealBorrower_DepositorIndicator_Checkbox}    ON
    Run Keyword And Continue On Failure    Validate if Element is Checked    ${LIQ_DealBorrower_DepositorIndicator_Checkbox}    Deal Borrower Indicator
    Run Keyword And Continue On Failure    Validate if Element is Checked    ${LIQ_DealBorrower_BorrowerIndicator_Checkbox}    Deal Borrower Indicator
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_BorrowerRemittanceInstruction
    mx LoanIQ click    ${LIQ_DealBorrower_Ok_Button}
    Sleep    3
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}    

Validate Deal Servicing Group
    [Documentation]    This keyword validates deal servicing group
    ...    @author: fmamaril
    [Tags]    Validation
    [Arguments]    ${Deal_Borrower}    ${Deal_Name}    ${Borrower_Location}
    Run Keyword And Continue On Failure    Verify If Text Value Exist as Static Text on Page    Deal Servicing Group    ${Deal_Borrower}
    Run Keyword And Continue On Failure    Verify If Text Value Exist as Static Text on Page    Deal Servicing Group    ${Deal_Name}
    Run Keyword And Continue On Failure    Verify If Text Value Exist as Static Text on Page    Deal Servicing Group    ${Borrower_Location}         
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_ServicingGroupDetails_Add_Button}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_ServicingGroupDetails_Delete_Button}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Validate if Element is Enabled    ${LIQ_ServicingGroupDetails_Ok_Button}    OK
    Run Keyword And Continue On Failure    Validate if Element is Enabled    ${LIQ_ServicingGroupDetails_Cancel_Button}    Cancel
           
Set Deal as Sole Lender
    [Documentation]    This keyword clicks the Sole Lender Checkbox and verifies it.
    ...    @author: fmamaril
    ...    @update: ehugo    28MAY2020    - added screenshot

    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Summary
    Mx LoanIQ Set    ${LIQ_DealSummary_SoleLender_Checkbox}    ON
    Run Keyword And Continue On Failure    Validate if Element is Checked    ${LIQ_DealSummary_SoleLender_Checkbox}    Deal Summary Sole Lender
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_SoleLender
     
Select Deal Classification
    [Documentation]    This keyword selects a Deal Classification.
    ...    @author: fmamaril
    ...    @update: ehugo    28MAY2020    - added keyword pre-processing; added screenshot
    [Arguments]    ${sDeal_ClassificationCode}    ${sDeal_ClassificationDesc}

    ### GetRuntime Keyword Pre-processing ###
    ${Deal_ClassificationCode}    Acquire Argument Value    ${sDeal_ClassificationCode}
    ${Deal_ClassificationDesc}    Acquire Argument Value    ${sDeal_ClassificationDesc}

    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Summary
    mx LoanIQ click    ${LIQ_DealSummary_DealClassification_Button}
    Validate Deal Classification elements   
    mx LoanIQ enter    ${LIQ_DealClassification_SearchByCode_Textfield}    ${Deal_ClassificationCode}    
    mx LoanIQ click    ${LIQ_DealClassification_OK_Button}
    Run Keyword And Continue On Failure    Verify If Text Value Exist in Textfield on Page    Deal Notebook    ${Deal_ClassificationDesc}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_DealClassification

Validate Deal Classification elements
    [Documentation]    This keyword validates deal classification
    ...    @author: fmamaril
    [Tags]    Validation
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_DealClassification_Javatree}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Validate if Element is Enabled    ${LIQ_DealClassification_OK_Button}    OK
    Run Keyword And Continue On Failure    Validate if Element is Enabled    ${LIQ_DealClassification_Cancel_Button}    Cancel  
        
Select Admin Agent
    [Documentation]    This keyword selects Admin Agent and it's location.
    ...    @author: fmamaril
    ...    @update: ehugo    28MAY2020    - added keyword pre-processing; added screenshot
    [Arguments]    ${sDeal_AdminAgent}    ${sAdminAgent_Location}

    ### GetRuntime Keyword Pre-processing ###
    ${Deal_AdminAgent}    Acquire Argument Value    ${sDeal_AdminAgent}
    ${AdminAgent_Location}    Acquire Argument Value    ${sAdminAgent_Location}

    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Summary
    mx LoanIQ click    ${LIQ_DealSummary_AdminAgent_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    Validate admin agent elements     
    mx LoanIQ click    ${LIQ_AdminAgentCustomer_Button}   
    mx LoanIQ enter    ${LIQ_LenderSelect_ShortName_Textfield}    ${Deal_AdminAgent}
    mx LoanIQ click    ${LIQ_LenderSelect_ShortNameSearch_Button}
    mx LoanIQ click    ${LIQ_LenderListShortName_OK_Button}  
    Mx LoanIQ select combo box value    ${LIQ_AdminAgent_Location_SelectBox }  ${AdminAgent_Location}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_DealAdminAgent

Validate admin agent elements
    [Documentation]    This keyword validates admin agent elements
    ...    @author: fmamaril
    [Tags]    Validation
    Run Keyword And Continue On Failure    Validate if Element is Enabled    ${LIQ_AdminAgentCustomer_Button}    Customer
    Run Keyword And Continue On Failure    Validate if Element is Enabled    ${LIQ_AdminAgent_ServicingGroup_Button}    Servicing Group       
    Run Keyword And Continue On Failure    Validate if Element is Enabled    ${LIQ_PreferredRemittanceInstructions_Button}    Preferred Remittance Instructions
    Run Keyword And Continue On Failure    Validate if Element is Enabled    ${LIQ_AdminAgent_OK_Button}    OK
    Run Keyword And Continue On Failure    Validate if Element is Enabled    ${LIQ_AdminAgent_Cancel_Button}    Cancel  
     
Select Servicing group and Remittance Instrucion for Admin Agent
    [Documentation]    Its selects the servicing group and remittance instructions for Admin Agent.
    ...    @author: fmamaril
    ...    @update: ehugo    28MAY2020    - added keyword pre-processing; added screenshot
    [Arguments]    ${sAdminAgent_SGAlias}    ${sAdminAgentServicingGroup_Method}    ${sAdminAgent_ServicingGroup}

    ### GetRuntime Keyword Pre-processing ###
    ${AdminAgent_SGAlias}    Acquire Argument Value    ${sAdminAgent_SGAlias}
    ${AdminAgentServicingGroup_Method}    Acquire Argument Value    ${sAdminAgentServicingGroup_Method}
    ${AdminAgent_ServicingGroup}    Acquire Argument Value    ${sAdminAgent_ServicingGroup}

    mx LoanIQ click    ${LIQ_AdminAgent_ServicingGroup_Button}
    Mx LoanIQ Select String    ${LIQ_ServicingGroups_JavaTree}   ${AdminAgent_SGAlias}
    Mx LoanIQ Select String    ${LIQ_ServicingGroups_RemittanceInctructions_JavaTree}   ${AdminAgentServicingGroup_Method}
    mx LoanIQ click    ${LIQ_ServicingGroup_OK_Button}
    Run Keyword And Continue On Failure    Verify If Text Value Exist in Textfield on Page    Deal Admin Agent    ${AdminAgent_ServicingGroup}   
    mx LoanIQ click    ${LIQ_PreferredRemittanceInstructions_Button}
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    Deal Admin Agent.*;Warning;Yes    strProcessingObj="JavaWindow(\"title:=Processing.*\")"    WaitForProcessing=500
    mx LoanIQ click    ${PrefferedRemittanceInstructions_AddButton}
    mx LoanIQ activate window    ${LIQ_PreferredRemittanceInstructions_Window}
    Mx LoanIQ Set    ${LIQ_PreferredRemittanceInstructions_All_Checkbox}    ON      
    mx LoanIQ click    ${LIQ_PreferredRemittanceInstructions_Ok_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_DealAdminAgent_ServicingGroup
    mx LoanIQ click    ${LIQ_ServicingGroupDetails_Ok_Button}
    mx LoanIQ click    ${LIQ_AdminAgent_OK_Button}
    
Enter Agreement Date and Proposed Commitment Amount
    [Documentation]    This keyword populates the Agreement Date and Proposed Commitment Amount.
    ...    @author: fmamaril
    ...    @update: ehugo    28MAY2020    - added keyword pre-processing; added screenshot
    [Arguments]    ${sDeal_AgreementDate}    ${sDeal_ProposedCmt}

    ### GetRuntime Keyword Pre-processing ###
    ${Deal_AgreementDate}    Acquire Argument Value    ${sDeal_AgreementDate}
    ${Deal_ProposedCmt}    Acquire Argument Value    ${sDeal_ProposedCmt}

    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Summary
    mx LoanIQ enter    ${LIQ_DealSummaryAgreementDate_Textfield}    ${Deal_AgreementDate}    
    mx LoanIQ enter    ${LIQ_ProposedCmt_TextField}    ${Deal_ProposedCmt}
    Validate Agreement and Proposed Commitment    ${Deal_AgreementDate}    ${Deal_ProposedCmt}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_AgreementDate_ProposedCmtAmt

Validate Agreement and Proposed Commitment
    [Documentation]    This keyword validates Agreement and Proposed Commitment input
    ...    @author: fmamaril
    ...    @author: ghabal: added write scripts for suceeeding scripts for Scenario 4 (@)
    ...    @author: bernchua    20AUG2019    Delete writing of data to Excel
    [Tags]    Validation
    [Arguments]    ${Deal_AgreementDate}    ${Deal_ProposedCmt}
    Validate Loan IQ Details    ${Deal_AgreementDate}    ${LIQ_DealSummaryAgreementDate_Textfield}
    Validate Loan IQ Details    ${Deal_ProposedCmt}    ${LIQ_ProposedCmt_TextField}
        
Uncheck Early Discussion Deal Checkbox
    [Documentation]    This keyword unticks the Early Discussion Deal Checkbox.
    ...    @author: fmamaril
    ...    @update: ehugo    28MAY2020    - added screenshot

    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Personnel
    Mx LoanIQ Set    ${LIQ_DealNotebook_EarlyDiscussionDeal_Checkbox}    OFF
    Run Keyword And Continue On Failure    Validate if Element is Unchecked    ${LIQ_DealNotebook_EarlyDiscussionDeal_Checkbox}    Early Discussion Deal
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_PersonnelTab_EarlyDiscussionDeal

Enter Department on Personel Tab
    [Documentation]    This keyword enters the Department on Personeel Tab.
    ...    @author: fmamaril
    ...    @update: ehugo    28MAY2020    - added keyword pre-processing; added screenshot
    [Arguments]    ${sDepartmentCode}    ${sDepartment}

    ### GetRuntime Keyword Pre-processing ###
    ${DepartmentCode}    Acquire Argument Value    ${sDepartmentCode}
    ${Department}    Acquire Argument Value    ${sDepartment}

    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Personnel
    mx LoanIQ click    ${LIQ_DealPersonnel_Department_Button}
    Mx LoanIQ Select String    ${LIQ_DepartmentSelector_Javatree}   ${DepartmentCode}
    mx LoanIQ click    ${LIQ_DepartmentSelector_OK_Button}
    Run Keyword And Continue On Failure    Verify If Text Value Exist in Textfield on Page    Deal Notebook    ${Department}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_PersonnelTab_Department
         
Enter Expense Code
    [Documentation]    This keyword selects expense code.
    ...    @author: fmamaril
    ...    @update: ehugo    28MAY2020    - added keyword pre-processing
    [Arguments]    ${sDeal_ExpenseCode}

    ### GetRuntime Keyword Pre-processing ###
    ${Deal_ExpenseCode}    Acquire Argument Value    ${sDeal_ExpenseCode}

    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Personnel
    mx LoanIQ click    ${LIQ_DealPersonnelExpenseCode_Button}
    Run Keyword And Continue On Failure    Validate if Element is Enabled    ${LIQ_SelectExpenseCode_All_Button}    All    
    Run Keyword And Continue On Failure    Validate if Element is Enabled    ${LIQ_SelectExpenseCode_Borrower_Button}    Borrower     
    mx LoanIQ click    ${LIQ_SelectExpenseCode_All_Button}
    Validate Expense Code Window            
    mx LoanIQ enter    ${LIQ_SelectExpenseCode_Search_TextField}    ${Deal_ExpenseCode}
    mx LoanIQ click    ${LIQ_SelectExpenseCode_OK_Button}
    Run Keyword And Continue On Failure    Verify If Text Value Exist in Textfield on Page    Deal Notebook    ${Deal_ExpenseCode}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_Personnel

Validate Expense Code Window
    [Documentation]    This keyword validates Expense Code elements
    ...    @author: fmamaril
    [Tags]    Validation
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_SelectExpenseCode_Cancel_Button}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_SelectExpenseCode_Code_RadioButton}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_SelectExpenseCode_Description_RadioButton}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_SelectExpenseCode_JavaTree}    VerificationData="Yes"

Add Holiday on Calendar
    [Documentation]    This keyword adds a Holiday on Calendar.
    ...    @author: fmamaril
    ...    @update: mnanquil
    ...    Added condition to add multiple holiday calendar.
    ...    Ex Multiple Input: Calendar 1 | Calendar 2 | Calendar 3 and so on..
    ...    Ex Single Input: Calendar 1
    ...    @update: ehugo    28MAY2020    - added keyword pre-processing; updated screenshot filename
    [Arguments]    ${sHolidayCalendar}

    ### GetRuntime Keyword Pre-processing ###
    ${HolidayCalendar}    Acquire Argument Value    ${sHolidayCalendar}

    @{HolidayCalendarArray}    Split String    ${HolidayCalendar}    |
    ${CalendarCount}    Get Length    ${HolidayCalendarArray}      
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Calendars
    Run Keyword And Continue On Failure    Validate if Element is Enabled    ${LIQ_DealCalendars_AddButton}    Add
    Run Keyword And Continue On Failure    Validate if Element is Enabled    ${LIQ_DealCalendars_DeleteButton}    Delete
    :FOR    ${INDEX}    IN RANGE    ${CalendarCount}
    \    ${HolidayCalendar}    Strip String    ${SPACE}@{HolidayCalendarArray}[${INDEX}]${SPACE}
    \    mx LoanIQ click    ${LIQ_DealCalendars_AddButton}
    \    Validation on Add Holiday Calendar
    \    Mx LoanIQ select combo box value    ${LIQ_HolidayCalendar_ComboBox}    ${HolidayCalendar}
    \    mx LoanIQ click    ${LIQ_HolidayCalendar_Ok_Button}
    \    Run Keyword and Continue on Failure    Mx LoanIQ Select String    ${LIQ_DealCalendars_Javatree}   ${HolidayCalendar}
    \    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_DealCalendars_AllItems_X_Javatree}    VerificationData="Yes"
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_Calendar_AddHoliday
    
Validation on Add Holiday Calendar
    [Documentation]    This keyword validates Holiday Calendar setup.
    ...    @author: fmamaril
    [Tags]    Validation 
    Run Keyword And Continue On Failure    Validate if Element is Enabled    ${LIQ_HolidayCalendar_ComboBox}    Holiday Calendar    
    Run Keyword And Continue On Failure    Validate if Element is Checked    ${LIQ_HolidayCalendar_BorrowerIntentNotice_Checkbox}    Borrower Intent Notice    
    Run Keyword And Continue On Failure    Validate if Element is Checked    ${LIQ_HolidayCalendar_FXRate_Checkbox}    FX Rate
    Run Keyword And Continue On Failure    Validate if Element is Checked    ${LIQ_HolidayCalendar_InterestRate_Checkbox}    Interest Rate
    Run Keyword And Continue On Failure    Validate if Element is Checked    ${LIQ_HolidayCalendar_EffectiveDate_Checkbox}    Effective Date
    Run Keyword And Continue On Failure    Validate if Element is Checked    ${LIQ_HolidayCalendar_PaymentAdvice_Checkbox}    Payment Advice
    Run Keyword And Continue On Failure    Validate if Element is Enabled    ${LIQ_HolidayCalendar_Ok_Button}    OK    
    Run Keyword And Continue On Failure    Validate if Element is Enabled    ${LIQ_HolidayCalendar_Cancel_Button}    Cancel   
    
Delete Holiday on Calendar
    [Documentation]    This keyword deletes a Holiday on Calendar.
    ...    @author: fmamaril
    ...    @update: ehugo    28MAY2020    - added keyword pre-processing; added screenshot
    [Arguments]    ${sHolidayCalendar}

    ### GetRuntime Keyword Pre-processing ###
    ${HolidayCalendar}    Acquire Argument Value    ${sHolidayCalendar}

    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Calendars
    Sleep    3s    
    Mx LoanIQ Select String    ${LIQ_DealCalendars_Javatree}   ${HolidayCalendar}
    mx LoanIQ click    ${LIQ_DealCalendars_DeleteButton}
    mx LoanIQ click    ${LIQ_Question_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_Calendar_DeleteHoliday
    
Validate Admin fees elements
    [Documentation]    This keyword validates Add admin fees elements
    ...    @author: fmamaril
    [Tags]    Validation
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AdminFees_IncomeMethod_Amortize_RadioButton}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AdminFees_IncomeMethod_Accrue_RadioButton}    VerificationData="Yes"

Validate Administrative Fees in a Deal
    [Documentation]    This keyword validates administrative Fees in a Deal.
    ...    @author: fmamaril
    [Tags]    Validation
    [Arguments]    ${UpfrontFee_FlatAmt}    ${Deal_EffectiveDate}    ${AdminFeeCurrency}    ${PeriodFrequency}    ${ActualDueDate}    ${BillingNumberOfDays} 
    Validate Loan IQ Details    ${UpfrontFee_FlatAmt}    ${LIQ_AmortizingAdmin_FlatAmount_Textfield}
    Validate Loan IQ Details    ${Deal_EffectiveDate}    ${LIQ_AmortizingAdmin_EffectiveDate_Field}
    Validate Loan IQ Details    ${AdminFeeCurrency}    ${LIQ_AmortizingAdmin_Currency_List}
    Validate Loan IQ Details    ${PeriodFrequency}    ${LIQ_AmortizingAdmin_PeriodFrequency_List}
    Validate Loan IQ Details    ${ActualDueDate}    ${LIQ_AmortizingAdmin_ActualDueDate_Field}
    Validate Loan IQ Details    ${BillingNumberOfDays}    ${LIQ_AmortizingAdmin_BillingNumberOfDays_Field}
    
Record Fee Distribution
    [Documentation]    This keyword adds a Record Fee Distribution
    ...    @author: fmamaril
    [Arguments]    ${Customer_Name}    ${FundReceiverDetailCustomer}
    Mx LoanIQ Select Window Tab    ${LIQ_AmortizingAdmin_JavaTab}    Distribution
    Run Keyword And Continue On Failure    Validate if Element is Enabled    ${LIQ_AmortizingAdmin_Distribution_Add_Button}    Add
    Run Keyword And Continue On Failure    Validate if Element is Enabled    ${LIQ_AmortizingAdmin_Distribution_Remove_Button}    Remove    
    mx LoanIQ click    ${LIQ_AmortizingAdmin_Distribution_Add_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_CustomerSelect_StatusFilter_Button}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Validate if Element is Enabled    ${LIQ_CustomerSelect_OK_Button}    OK
    Run Keyword And Continue On Failure    Validate if Element is Enabled    ${LIQ_CustomerSelect_Search_Button}    Search    
    Run Keyword And Continue On Failure    Validate if Element is Enabled    ${LIQ_CustomerSelect_Cancel_Button}    Cancel     
    mx LoanIQ enter    ${LIQ_CustomerSelect_ShortName_Field}    ${Customer_Name}
    mx LoanIQ click    ${LIQ_CustomerSelect_Search_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Text In Javatree    ${LIQ_CustomerListByShortName_Tree}    ${Customer_Name}%yes
    mx LoanIQ click    ${LIQ_CustomerListByShortName_OK_Button}
    Sleep    5   
    Run Keyword And Continue On Failure    Verify If Text Value Exist as Static Text on Page    Funds Receiver Details    ${FundReceiverDetailCustomer}

Populate Fund Receiver Details
    [Documentation]    This keyword selects a Servicing Group for Fund receiver
    ...    @author: fmamaril
    [Arguments]    ${CustomerLocation}    ${ExpenseCode}    ${FundReceiverPercentageFees}    ${FeeDistributionName}
    mx LoanIQ click    ${LIQ_FundReceiverDetails_ServicingGroup_Button}
    Validate Fields on Fund Receiver details
    Mx LoanIQ Select String    ${LIQ_FundReceiverDetails_Location_JavaTree}    ${CustomerLocation}
    mx LoanIQ click    ${LIQ_Locations_OK_Button}
    mx LoanIQ click    ${LIQ_ServicingGroup_OK_Button}
    mx LoanIQ click    ${LIQ_FundReceiverDetails_ExpenseCode_Button}
    Mx LoanIQ Select String    ${LIQ_DealNotebook_ExpenseCode_JavaTree}    ${ExpenseCode}
    mx LoanIQ click    ${LIQ_DealNotebook_ExpenseCode_OK_Button}        
    mx LoanIQ enter    ${LIQ_FundReceiverDetails_PercentageFees_Textfield}    ${FundReceiverPercentageFees}
    mx LoanIQ click    ${LIQ_FundReceiverDetails_OK_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.*Amortizing Admin.*").JavaTree("developer name:=.*${FeeDistributionName}.*")    VerificationData="Yes"

Validate Fields on Fund Receiver details
    [Documentation]    This keyword validates fields on Fund receiver details
    ...    @author: fmamaril
    [Tags]    Validation
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FundReceiverDetails_Location_JavaTree}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Locations_OK_Button}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Locations_Cancel_Button}    VerificationData="Yes"
        
Save Changes on Amortizing Admin Fee
    [Documentation]    This keyword saves the changes on Amortizing Admin Fee Window.
    ...    @author: fmamaril
    ...    @update: mnanquil
    ...    Changed mx click to mx click element if present and remove unnecessary mx wait.
    mx LoanIQ activate window     ${LIQ_AmortizingAdmin_Window}
    mx LoanIQ select    ${LIQ_AmortizingAdmin_Exit_Menu}
    mx LoanIQ click element if present    ${LIQ_Exiting_SaveExit_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}       

Add Financial Ratio
    [Documentation]    This keyword adds a financial ratio in a deal.
    ...    @author: fmamaril
    ...    @update: mnanquil                 - Updated mx loaniq verify text in javatree to mx loaniq select string
    ...    @update: hstone     10JUN2020     - Added Keyword Pre-processing
    [Arguments]    ${sRatioType}    ${sFinancialRatio}    ${sFinancialRatioStartDate}=None

    ### Keyword Pre-processing ###
    ${RatioType}    Acquire Argument Value    ${sRatioType}
    ${FinancialRatio}    Acquire Argument Value    ${sFinancialRatio}
    ${FinancialRatioStartDate}    Acquire Argument Value    ${sFinancialRatioStartDate}

    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Ratios/Conds
    Run Keyword And Continue On Failure    Validate if Element is Enabled    ${LIQ_FinancialRatio_Add_Button}    Add
    Run Keyword And Continue On Failure    Validate if Element is Enabled    ${LIQ_FinancialRatio_Delete_Button}    Delete
    Run Keyword And Continue On Failure    Validate if Element is Enabled    ${LIQ_FinancialRatio_History_Button}    History           
    mx LoanIQ click    ${LIQ_FinancialRatio_Add_Button}
    mx LoanIQ click element if present   ${LIQ_Warning_Yes_Button}
    Mx LoanIQ select combo box value    ${LIQ_FinantialRatio_RatioType_List}    ${RatioType}
    mx LoanIQ enter    ${LIQ_FinantialRatio_Field}    ${FinancialRatio}
    Run Keyword If    '${FinancialRatioStartDate}' != 'None'    mx LoanIQ enter    ${LIQ_FinantialRatio_Date}    ${FinancialRatioStartDate}
    mx LoanIQ click    ${LIQ_FinantialRatio_Ok_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Select String   ${LIQ_FinantialRatio_JavaTree}    ${RatioType}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealWindow_RatiosConditions

Modify Upfront Fees
    [Documentation]    This keyword adds a financial ratio in a deal.
    ...    @author: fmamaril
    [Arguments]    ${UpfrontFee_Type}    ${UpfrontFee_RateBasis}    ${UpfrontFee_Percent}    ${FlatAmount_RadioButton}=OFF    ${FlatAmount}=0    
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Fees
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Fees_Tab}    VerificationData="Yes"
    mx LoanIQ click    ${LIQ_Fees_ModifyUpfrontFees_Button}
    mx LoanIQ click element if present   ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present   ${LIQ_Information_OK_Button}
    mx LoanIQ click    ${LIQ_ModifyUpfrontFees_AddButton}
    mx LoanIQ select    ${LIQ_ModifyUpfrontFees_AddItem_Tree}    ${UpfrontFee_Type}
    mx LoanIQ click    ${LIQ_ModifyUpfrontFees_AddItem_Ok_Button}
    mx LoanIQ select    ${LIQ_FeeSelection_List}    ${UpfrontFee_RateBasis} 
    mx LoanIQ click    ${LIQ_FeeSelection_Ok_Button}
    Run Keyword If    '${FlatAmount_RadioButton}'!='OFF'    mx LoanIQ enter    ${LIQ_FormulaCategory_FlatAmount_RadioButton}    ${FlatAmount_RadioButton}
    Run Keyword If    '${FlatAmount_RadioButton}'!='OFF'    mx LoanIQ enter    ${LIQ_FormulaCategory_FlatAmount_JavaEdit}    ${FlatAmount}                
    Run Keyword If    '${FlatAmount_RadioButton}'=='OFF'    mx LoanIQ enter    ${LIQ_FormulaCategory_Formula_RadioButton}    ON
    Run Keyword If    '${FlatAmount_RadioButton}'=='OFF'    mx LoanIQ enter    ${LIQ_FormulaCategory_Percent_RadioButton}    ON        
    Run Keyword If    '${FlatAmount_RadioButton}'=='OFF'    mx LoanIQ enter    ${LIQ_FormulaCategory_Percent_Field}    ${UpfrontFee_Percent}   
    mx LoanIQ click    ${LIQ_FormulaCategory_Ok_Button}
    mx LoanIQ click    ${LIQ_ModifyUpfrontFees_Validate_Button}
    Run Keyword And Continue On Failure      Mx LoanIQ Verify Runtime Property    ${LIQ_Congratulations_MessageBox}    value%Validation completed successfully.
    mx LoanIQ click    ${LIQ_Congratulations_OK_Button}
    mx LoanIQ click    ${LIQ_UpfrontFees_Ok_Button}
                      
Add Pricing Option
    [Documentation]    This keyword adds a pricing option.
    ...    @author: fmamaril
    ...    @update: mnanquil
    ...    @update: rtarayao
    ...    Changed verify text in java tree on line 540 to mx loaniq select string.
    ...    Added an optional argument to handle pricing options that does not tick on Bill Borrower checkbox.
    ...    @update: ehugo    28MAY2020    - added keyword Pre-processing; added screenshot
    [Arguments]    ${sPricingRule_Option}    ${sInitialFractionRate_Round}    ${sRoundingDecimal_Round}    ${sNonBusinessDayRule}    ${iPricingOption_BillNoOfDays}    ${sMatrixChangeAppMethod}    ${sRateChangeAppMethod}    ${PricingOption_InitialFractionRate}=None
    ...    ${PricingOption_RoundingDecimalPrecision}=None    ${PricingOption_RoundingApplicationMethod}=None    ${PricingOption_PercentOfRateFormulaUsage}=None    ${PricingOption_RepricingNonBusinessDayRule}=None    ${PricingOption_FeeOnLenderShareFunding}=None
    ...    ${PricingOption_InterestDueUponPrincipalPayment}=None    ${PricingOption_InterestDueUponRepricing}=None    ${PricingOption_ReferenceBanksApply}=None    ${PricingOption_IntentNoticeDaysInAdvance}=None    ${PricingOption_IntentNoticeTime}=None
    ...    ${PricingOption_12HrPeriodOption}=None    ${PricingOption_MaximumDrawdownAmount}=None    ${PricingOption_MinimumDrawdownAmount}=None    ${PricingOption_MinimumPaymentAmount}=None    ${PricingOption_MinimumAmountMultiples}=None    ${PricingOption_CCY}=None
    ...    ${PricingOption_BillBorrower}=Y

    ### GetRuntime Keyword Pre-processing ###
    ${PricingRule_Option}    Acquire Argument Value    ${sPricingRule_Option}
    ${InitialFractionRate_Round}    Acquire Argument Value    ${sInitialFractionRate_Round}
    ${RoundingDecimal_Round}    Acquire Argument Value    ${sRoundingDecimal_Round}
    ${NonBusinessDayRule}    Acquire Argument Value    ${sNonBusinessDayRule}
    ${PricingOption_BillNoOfDays}    Acquire Argument Value    ${iPricingOption_BillNoOfDays}
    ${MatrixChangeAppMethod}    Acquire Argument Value    ${sMatrixChangeAppMethod}
    ${RateChangeAppMethod}    Acquire Argument Value    ${sRateChangeAppMethod}

    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Pricing Rules
    mx LoanIQ click    ${LIQ_PricingRules_AddOption_Button}
    mx LoanIQ activate window    ${LIQ_InterestPricingOption_Window}
    Run Keyword If    '${PricingOption_CCY}' != 'None'    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_CCY_List}    ${PricingOption_CCY}
    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_Dropdown}    ${PricingRule_Option}
    Run Keyword If    '${PricingOption_InitialFractionRate}' != 'None'    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_InitialFractionRate_List}    ${PricingOption_InitialFractionRate}
    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_InitialFractionRate_Dropdown}    ${InitialFractionRate_Round}
    Run Keyword If    '${PricingOption_RoundingDecimalPrecision}' != 'None'    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_RoundingDecimalPrecision_List}    ${PricingOption_RoundingDecimalPrecision}
    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_RoundingDecimalRound_Dropdown}    ${RoundingDecimal_Round} 
    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_NonBusinessDayRule_Dropdown}    ${NonBusinessDayRule}    
    Run Keyword If    '${PricingOption_BillBorrower}' == 'Y'    Mx LoanIQ Set    ${LIQ_InterestPricingOption_BillBorrower_Checkbox}    ON
    Run Keyword If    '${PricingOption_RoundingApplicationMethod}' != 'None'    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_RoundingApplicationMethod_List}    ${PricingOption_RoundingApplicationMethod}
    Run Keyword If    '${PricingOption_PercentOfRateFormulaUsage}' != 'None'    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_PercentOfRateFormulaUsage_List}    ${PricingOption_PercentOfRateFormulaUsage}
    Run Keyword If    '${PricingOption_RepricingNonBusinessDayRule}' != 'None'    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_RepricingNonBusinessDayRule_Dropdown}    ${PricingOption_RepricingNonBusinessDayRule}
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_InterestPricingOption_InterestDueUponRepricing_Checkbox}      VerificationData="Yes"
    Run Keyword If    ${status}==True    Check or Uncheck Interest Due Upon Repricing
    ...    ELSE    Log    Unable to find field

    mx LoanIQ enter    ${LIQ_InterestPricingOption_BillingNumberDays_Field}    ${PricingOption_BillNoOfDays} 
    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_MatrixChangeAppMthd_Combobox}    ${MatrixChangeAppMethod}
    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_RateChangeAppMthd_Combobox}    ${RateChangeAppMethod}
    Run Keyword If    '${PricingOption_InterestDueUponPrincipalPayment}' != 'None'    Mx LoanIQ Check Or Uncheck    ${LIQ_InterestPricingOption_InterestDueUponPrincipalPayment_Checkbox}    ${PricingOption_InterestDueUponPrincipalPayment}    
    Run Keyword If    '${PricingOption_InterestDueUponRepricing}' != 'None'    Mx LoanIQ Check Or Uncheck    ${LIQ_InterestPricingOption_InterestDueUponRepricing_Checkbox}    ${PricingOption_InterestDueUponRepricing}        
    Run Keyword If    '${PricingOption_ReferenceBanksApply}' != 'None'    Mx LoanIQ Check Or Uncheck    ${LIQ_InterestPricingOption_ReferenceBanksApply_Checkbox}    ${PricingOption_ReferenceBanksApply}    
    Run Keyword If    '${PricingOption_IntentNoticeDaysInAdvance}' != 'None'    mx LoanIQ enter    ${LIQ_InterestPricingOption_IntentNoticeDaysInAdvance_Textfield}    ${PricingOption_IntentNoticeDaysInAdvance}
    Run Keyword If    '${PricingOption_IntentNoticeTime}' != 'None'    mx LoanIQ enter    ${LIQ_InterestPricingOption_IntentNoticeTimeInAdvance_Textfield}    ${PricingOption_IntentNoticeTime}        
    Run Keyword If    '${PricingOption_12HrPeriodOption}' != 'None'    mx LoanIQ enter    JavaWindow("title:=Interest Pricing Option.*").JavaRadioButton("labeled_containers_path:=.*Intent Notice.*","attached text:=${PricingOption_12HrPeriodOption}")    ON
    Run Keyword If    '${PricingOption_MaximumDrawdownAmount}' != 'None'    mx LoanIQ enter    ${LIQ_InterestPricingOption_MaximumDrawdownAmount_Textfield}    ${PricingOption_MaximumDrawdownAmount}    
    Run Keyword If    '${PricingOption_MinimumDrawdownAmount}' != 'None'    mx LoanIQ enter    ${LIQ_InterestPricingOption_MinimumDrawdownAmount_Textfield}    ${PricingOption_MinimumDrawdownAmount}
    Run Keyword If    '${PricingOption_MinimumPaymentAmount}' != 'None'    mx LoanIQ enter    ${LIQ_InterestPricingOption_MinimumPaymentAmount_Textfield}    ${PricingOption_MinimumPaymentAmount}    
    Run Keyword If    '${PricingOption_MinimumAmountMultiples}' != 'None'    mx LoanIQ enter    ${LIQ_InterestPricingOption_MinimumAmountMultiples_Textfield}    ${PricingOption_MinimumAmountMultiples}
    mx LoanIQ click    ${LIQ_InterestPricingOption_Ok_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Select String   ${LIQ_PricingRules_AllowedPricingOption_JavaTree}    ${PricingRule_Option}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_PricingRulesTab_PricingOption

Check or Uncheck Interest Due Upon Repricing
    [Documentation]    This will check and uncheck the Interest Due Upon Repricing
    ...    @author: rtarayao
    ${status}    Run Keyword And Return Status    Validate if Element is Checked    ${LIQ_InterestPricingOption_InterestDueUponRepricing_Checkbox}    Interest Due Upon Repricing 
    Run Keyword If    ${status}==True    Mx LoanIQ Check Or Uncheck    ${LIQ_InterestPricingOption_InterestDueUponRepricing_Checkbox}    OFF
    ...    ELSE IF    ${status}==False   Mx LoanIQ Check Or Uncheck    ${LIQ_InterestPricingOption_InterestDueUponPrincipalPayment_Checkbox}    ON

Add Pricing Option for SBLC
    [Documentation]    This keyword adds a pricing option.
    ...    @author: jcdelacruz
    ...    @update: ehugo    28MAY2020    - added keyword Pre-processing; added screenshot
    [Arguments]    ${sPricingRule_Option}    ${sInitialFractionRate_Round}    ${sRoundingDecimal_Round}    ${sNonBusinessDayRule}    ${iPricingOption_BillNoOfDays}    ${sMatrixChangeAppMethod}    ${sRateChangeAppMethod}

    ### GetRuntime Keyword Pre-processing ###
    ${PricingRule_Option}    Acquire Argument Value    ${sPricingRule_Option}
    ${InitialFractionRate_Round}    Acquire Argument Value    ${sInitialFractionRate_Round}
    ${RoundingDecimal_Round}    Acquire Argument Value    ${sRoundingDecimal_Round}
    ${NonBusinessDayRule}    Acquire Argument Value    ${sNonBusinessDayRule}
    ${PricingOption_BillNoOfDays}    Acquire Argument Value    ${iPricingOption_BillNoOfDays}
    ${MatrixChangeAppMethod}    Acquire Argument Value    ${sMatrixChangeAppMethod}
    ${RateChangeAppMethod}    Acquire Argument Value    ${sRateChangeAppMethod}

    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Pricing Rules
    mx LoanIQ click    ${LIQ_PricingRules_AddOption_Button}
    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_Dropdown}    ${PricingRule_Option}
    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_InitialFractionRate_Dropdown}    ${InitialFractionRate_Round}
    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_RoundingDecimalRound_Dropdown}    ${RoundingDecimal_Round}
    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_NonBusinessDayRule_Dropdown}    ${NonBusinessDayRule}    
    Mx LoanIQ Set    ${LIQ_InterestPricingOption_BillBorrower_Checkbox}    ON
    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_MatrixChangeAppMthd_Combobox}    ${MatrixChangeAppMethod}    
    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_RateChangeAppMthd_Combobox}    ${RateChangeAppMethod}   
   
    mx LoanIQ enter    ${LIQ_InterestPricingOption_BillingNumberDays_Field}    ${PricingOption_BillNoOfDays}    
    mx LoanIQ click    ${LIQ_InterestPricingOption_Ok_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Text In Javatree    ${LIQ_PricingRules_AllowedPricingOption_JavaTree}    ${PricingRule_Option}%yes

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_PricingRulesTab_PricingOptionSBLC
    
Add Fee Pricing Rules
    [Documentation]    This keyword adds a fee pricing rule.
    ...    @author: fmamaril
    ...    @update: fmamaril    02APR2019    Add run keyword and ignore error for facility radio button
    ...    @update: ehugo    28MAY2020    - added keyword Pre-processing
    [Arguments]    ${sPricingRule_Fee}    ${sPricingRule_MatrixChangeAppMthd}    ${sPricingRule_NonBussDayRule}    ${PricingRule_BillBorrowerStatus}=None    ${PricingRule_BillNoOfDays}=None

    ### GetRuntime Keyword Pre-processing ###
    ${PricingRule_Fee}    Acquire Argument Value    ${sPricingRule_Fee}
    ${PricingRule_MatrixChangeAppMthd}    Acquire Argument Value    ${sPricingRule_MatrixChangeAppMthd}
    ${PricingRule_NonBussDayRule}    Acquire Argument Value    ${sPricingRule_NonBussDayRule}

    Mx Activate Window    ${LIQ_DealNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Pricing Rules
    :FOR    ${i}    IN RANGE    5
    \    mx LoanIQ click    ${LIQ_PricingRules_AddFee_Button}
    \    ${LIQ_FeePricingRule_WindowExist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_FeePricingRule_Window}        VerificationData="Yes"
    \    Exit For Loop If    ${LIQ_FeePricingRule_WindowExist}==True
    Run Keyword And Ignore Error    Mx LoanIQ Enter    ${LIQ_FeePricingRule_FacilityOngoingFee_RadioButton}    ON
    Mx LoanIQ select combo box value    ${LIQ_FeePricingRule_Fee_ComboBox}    ${PricingRule_Fee}
    Mx LoanIQ select combo box value    ${LIQ_FeePricingRule_MatrixChange_List}    ${PricingRule_MatrixChangeAppMthd}
    Mx LoanIQ select combo box value    ${LIQ_FeePricingRule_NonBusinessDayRule_List}    ${PricingRule_NonBussDayRule}
    Run Keyword If    '${PricingRule_BillBorrowerStatus}' != 'None'    Mx LoanIQ Set    ${LIQ_FeePricingRule_BillBorrower_Checkbox}    ${PricingRule_BillBorrowerStatus}
    Run Keyword If    '${PricingRule_BillNoOfDays}' != 'None'    mx LoanIQ enter    ${LIQ_FeePricingRule_BillingNumberOfDays_Field}    ${PricingRule_BillNoOfDays}
    mx LoanIQ click    ${LIQ_FeePricingRule_OK_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Text In Javatree    ${LIQ_PricingRules_FeePricingRules_JavaTree}    ${PricingRule_Fee}%yes 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_PricingRulesTab

Verify Details on Events Tab
    [Documentation]    This keyword verifies details on Events Tab
    ...    @author: fmamaril
    ...    @update: rtarayao - udpated the script to accommodate deals that didn't change Financial Ratio.
    ...    @update: jdelacru    11APR19    Deleted Validation for Financial Ratio
    ...    @update: ehugo    28MAY2020    - added keyword Pre-processing
    [Tags]    Validation
    [Arguments]    ${sCreatedUser}    ${sUnrestrictedUser}    ${FRCUser}=None

    ### GetRuntime Keyword Pre-processing ###
    ${CreatedUser}    Acquire Argument Value    ${sCreatedUser}
    ${UnrestrictedUser}    Acquire Argument Value    ${sUnrestrictedUser}

    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Events
    Validate Loan IQ Details    ${CreatedUser}    ${LIQ_Events_User_Field} 
    Mx LoanIQ Select String    ${LIQ_Events_Javatree}   Unrestricted            
    Validate Loan IQ Details   ${UnrestrictedUser}    ${LIQ_Events_User_Field}     
    Mx LoanIQ Select String    ${LIQ_Events_Javatree}   Created            
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_EventsTab

Send Deal to Approval
    [Documentation]    This keyword completes the Send Deal to Approval Workflow Item.
    ...    @author: fmamaril 
    ...    @mgaling: Added item for clicking the warning message
    mx LoanIQ activate window    ${LIQ_DealNoteBook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_DealNotebook_Workflow_JavaTree}    Send to Approval%d
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_MessageBox}      VerificationData="Yes"
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Deal Notebook - Awaiting Approval.*")    VerificationData="Yes"
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Deal_SendToApproval
    
Close the Deal
    [Documentation]    This keyword completes the Close the Deal Workflow Item.
    ...    @author: fmamaril
    ...    <update> bernchua: Added continuous checking of Information/Warning/Error messages, and clicks Yes/OK button if present.
    ...    @update: mnanquil
    ...    Added a conditional statement to handle writing of data in excel
    ...    @update: bernchua    26FEB2019    Removed Writing of data to Excel
    ...    @update: bernchua    29MAY2019    updated to use generic keyword for warning messages
    ...    @update: hstone      05JUN2020    - Added Take Screenshot
    ...    @update: clanding    17JUL2020    - added screenshot before clicking OK button
    [Arguments]    ${sCloseDate}

    ### GetRuntime Keyword Pre-processing ###
    ${CloseDate}    Acquire Argument Value    ${sCloseDate}

    mx LoanIQ activate window    ${LIQ_DealNoteBook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_JavaTab}    Workflow
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_Workflow
    Run Keyword And Continue On Failure    mx LoanIQ click element if present    ${LIQ_InquiryMode_Button}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_DealNotebook_Workflow_JavaTree}    Close%d
    Verify If Warning Is Displayed
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    mx LoanIQ enter    ${LIQ_DealNotebook_CloseDate}    ${CloseDate}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_Workflow
    mx LoanIQ click    ${LIQ_CloseDeal_OKButton}
    Verify If Warning Is Displayed
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_Workflow
    
Verify Status on Circle and Facility and Deal
    [Documentation]    This keyword verifies the status of Circle, Facility and Deal notebook.
    ...    @author: fmamaril
    ...    @update: mnanquil
    ...    Added a for loop and array to handle multiple facility validation.
    ...    @update: amansuet    24APR2020    - updated keyword name for New Framework , added keyword pre-processing and replaced ${FacilityName} to ${Facility_Name}
    ...    @update: clanding    17JUL2020    - refactor arguments and updated condition in validating if Deal is closed
    [Tags]    Validation
    [Arguments]    ${sFundReceiverDetailCustomer}    ${sFacility_Name}

    ### GetRuntime Keyword Pre-processing ###
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
    ${FundReceiverDetailCustomer}    Acquire Argument Value    ${sFundReceiverDetailCustomer}

    mx LoanIQ activate window    ${LIQ_DealNotebook_Window} 
    mx LoanIQ select    ${LIQ_DealNotebook_DistributionPrimaries_Menu}
    mx LoanIQ activate window     ${LIQ_PrimariesList_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PrimariesList_JavaTree}    ${FundReceiverDetailCustomer}%d
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Closed Orig Primary:.*")     VerificationData="Yes"
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Deal_Primaries
    Mx LoanIQ Close    JavaWindow("title:=Closed Orig Primary:.*") 
    Mx LoanIQ Close    ${LIQ_PrimariesList_Window}     
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window} 
    mx LoanIQ select   ${LIQ_DealNotebook_Options_Facilities}
    @{FacilityArray}    Split String    ${Facility_Name}    |
    ${FacilityCount}    Get Length    ${FacilityArray}
    :FOR    ${INDEX}    IN RANGE    ${FacilityCount}
    \    ${Facility_Name}    Strip String    ${SPACE}@{FacilityArray}[${INDEX}]${SPACE}
    \    mx LoanIQ activate window     ${LIQ_FacilityNavigator_Window}
    \    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FacilityNavigator_Tree }    ${Facility_Name}%d
    \    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Facility - .*In Closed Deal.*")    VerificationData="Yes"
    \    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Facility_Window
    \    Mx LoanIQ Close    ${LIQ_FacilityNotebook_Window} 
    Mx LoanIQ Close    ${LIQ_FacilityNavigator_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Deal Notebook - Closed Deal.*")    VerificationData="Yes"
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealClose_Window
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Events    
    ### Verify Deal is closed
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Text In Javatree    ${LIQ_Events_Javatree}    Closed        
    Run Keyword If    '${status}'=='True'    Log    Deal is now closed!    level=INFO
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Unable to confirm if deal is closed
    Mx LoanIQ Close    ${LIQ_DealNotebook_Window}
    
Approve the Deal
    [Documentation]    This keyword approves the deal from LIQ.
    ...    @author: fmamaril
    ...    @update: fmamaril - added loop for Warning message 
    ...    @update: ehugo    30JUN2020    - added keyword pre-processing
    ...    @update: clanding    17JUL2020    - added screenshot before clicking OK button
    [Arguments]    ${sApproveDate}

    ### GetRuntime Keyword Pre-processing ###
    ${ApproveDate}    Acquire Argument Value    ${sApproveDate}

    mx LoanIQ activate window    ${LIQ_DealNoteBook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_JavaTab}    Workflow
    Run Keyword And Continue On Failure    mx LoanIQ click element if present    ${LIQ_InquiryMode_Button}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_DealNotebook_Workflow_JavaTree}    Approval%d 
        :FOR    ${i}    IN RANGE    3
    \    ${Info_Displayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Information_OK_Button}    VerificationData="Yes"
    \    Run Keyword If    ${Info_Displayed}==True    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    \    ${Warning_Displayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Yes_Button}    VerificationData="Yes"
    \    Run Keyword If    ${Warning_Displayed}==True    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    Exit For Loop If    ${Info_Displayed}==False and ${Warning_Displayed}==False
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    mx LoanIQ activate window    ${LIQ_ApproveDeal_Window}
    mx LoanIQ enter    ${LIQ_DealNotebook_ApproveDate}    ${ApproveDate}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Deal_Approval
    mx LoanIQ click    ${LIQ_ApproveDeal_OKButton}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Deal_Approval
    
Add Pricing Option for Letter of Credit
    [Documentation]    This keyword adds a pricing option.
    ...    @author: fmamaril
    [Arguments]    ${PricingRule_LOC}    ${InitialFractionRate_Round_LOC}    ${RoundingDecimal_Round_LOC}    ${NonBusinessDayRule_LOC}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Pricing Rules
    mx LoanIQ click    ${LIQ_PricingRules_AddOption_Button}     
    Mx LoanIQ select combo box value    ${LIQ_InterestPricingOption_Dropdown}    ${PricingRule_LOC}          
    Mx LoanIQ select combo box value    ${LIQ_InterestPricingOption_InitialFractionRate_Dropdown}    ${InitialFractionRate_Round_LOC} 
    Mx LoanIQ select combo box value    ${LIQ_InterestPricingOption_RoundingDecimalRound_Dropdown}    ${RoundingDecimal_Round_LOC}
    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_NonBusinessDayRule_Dropdown}    ${NonBusinessDayRule_LOC}    
    Mx LoanIQ Set    ${LIQ_InterestPricingOption_BillBorrower_Checkbox}    ON
    # Mx LoanIQ select combo box value    ${LIQ_InterestPricingOption_CCY_List}    &{ExcelPath}[CCY_LOC] --- Disabled when AUD is selected
    mx LoanIQ enter    ${LIQ_InterestPricingOption_BillingNumberDays_Field}    &{ExcelPath}[BillingNumberOfDays_LOC]    
    mx LoanIQ click    ${LIQ_InterestPricingOption_Ok_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Text In Javatree    ${LIQ_PricingRules_AllowedPricingOption_JavaTree}    ${PricingRule_LOC}%yes
       
Add Bank Role
    [Documentation]    This keyword sets the Bank Role in the Deal Notebook.
    ...    @author: fmamaril
    ...    @update: fmamaril    Added option to tick checkbox for different bank roles
    ...    @update: bernchua    02JUL2019    Updated keyword documentation
    ...    @update: bernchua    10JUL2019    Revamped the keyword:
    ...                                      - Removed search for the Bank Name and used 'OK' button instead.
    ...                                      - Renamed most of the variables used for the Servicing Group
    ...                                      - Used 1 arguments variable for the Bank Role types.
    ...    @update: ehugo    28MAY2020    - added keyword Pre-processing; added screenshot
    ...    @update: clanding    04AUG2020    - updated arguments sBankRole_Portfolio, sBankRole_ExpenseCode and sBankRole_ExpenseCodeDesc to be optional
    [Arguments]    ${sBankRole_Type}    ${sBankRole_BankName}    ${sBankRole_SGAlias}    ${sBankRole_SGName}    ${sBankRole_SGContactName}    ${sBankRole_RIMethod}
    ...    ${sBankRole_Portfolio}=None    ${sBankRole_ExpenseCode}=None    ${sBankRole_ExpenseCodeDesc}=None

    ### GetRuntime Keyword Pre-processing ###
    ${BankRole_Type}    Acquire Argument Value    ${sBankRole_Type}
    ${BankRole_BankName}    Acquire Argument Value    ${sBankRole_BankName}
    ${BankRole_SGAlias}    Acquire Argument Value    ${sBankRole_SGAlias}
    ${BankRole_SGName}    Acquire Argument Value    ${sBankRole_SGName}
    ${BankRole_SGContactName}    Acquire Argument Value    ${sBankRole_SGContactName}
    ${BankRole_RIMethod}    Acquire Argument Value    ${sBankRole_RIMethod}
    ${BankRole_Portfolio}    Acquire Argument Value    ${sBankRole_Portfolio}
    ${BankRole_ExpenseCode}    Acquire Argument Value    ${sBankRole_ExpenseCode}
    ${BankRole_ExpenseCodeDesc}    Acquire Argument Value    ${sBankRole_ExpenseCodeDesc}

    mx LoanIQ activate window    ${LIQ_DealNoteBook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_JavaTab}    Bank Roles
    mx LoanIQ click    ${LIQ_BankRoles_AddBank_Button}
    mx LoanIQ enter    ${LIQ_DealLenderSelect_ShortName_TextField}    ${BankRole_BankName}
    mx LoanIQ click    ${LIQ_DealLenderSelect_Ok_Button}
    mx LoanIQ activate window      ${LIQ_BankRoleDetails_Window}
    Mx LoanIQ Set    JavaWindow("title:=Bank Role Details").JavaCheckBox("label:=${BankRole_Type}")    ON
    mx LoanIQ click    ${LIQ_BankRoles_ServicingGroup_Button}
    Select Bank Role Servicing Group    ${BankRole_SGAlias}    ${BankRole_SGContactName}    ${BankRole_RIMethod}    ${BankRole_SGName}
    Run Keyword If    '${sBankRole_Portfolio}'!='None'    Add Bank Role Portfolio Information    ${BankRole_Portfolio}    ${BankRole_ExpenseCode}    ${BankRole_ExpenseCodeDesc}
    ...    ELSE    mx LoanIQ click    ${LIQ_BankRoles_OK_Button}
    ${STATUS}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_BankRoles_JavaTree}   ${BankRole_BankName}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_BankRoles

    Run Keyword If    ${STATUS}==True    Log    Bank Role successfully added.
    ...    ELSE    Fail    Bank Role not added successfully.
    
Select Bank Role Servicing Group
    [Documentation]    This keyword selects a borrower location and servicing group.
    ...    @author: fmamaril
    [Arguments]    ${BankRole_SG_Alias}    ${BankRole_SG_GroupMembers}    ${BankRole_SG_Method}    ${BankRole_SG}      
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_ServicingGroup_Window}        VerificationData="Yes"
    mx LoanIQ activate window    ${LIQ_ServicingGroup_Window}
    Mx LoanIQ Select String    ${LIQ_ServicingGroups_Location_JavaTree}   ${BankRole_SG_Alias}
    Mx LoanIQ Select String    ${LIQ_ServicingGroups_BankGroupMembers_JavaTree}   ${BankRole_SG_GroupMembers}
    Mx LoanIQ Select String    ${LIQ_ServicingGroups_BankMethod_JavaTree}   ${BankRole_SG_Method}
    mx LoanIQ click    ${LIQ_ServicingGroup_OK_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_BankRoleDetails_Window}    VerificationData="Yes"
    mx LoanIQ activate window      ${LIQ_BankRoleDetails_Window}
    Run Keyword And Continue On Failure    Verify If Text Value Exist in Textfield on Page    Bank Role Details    ${BankRole_SG}        
    
Add Bank Role Portfolio Information
    [Documentation]    This keyword adds a bank role portfolio information.
    ...    @author: fmamaril
    ...    @update: bernchua    10JUL2019    Renamed argument variables
    ...    @update: ritragel    29JUL2019    Updated keyword used for validation
    [Arguments]    ${sBankRole_Portfolio}    ${sBankRole_ExpenseCode}    ${sBankRole_ExpenseCodeDesc}
    ${BankRole_ExpenseCode}    Set Variable    ${sBankRole_ExpenseCode}-${sBankRole_ExpenseCodeDesc}
    mx LoanIQ click    ${LIQ_BankRoles_PortfolioInformation_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_PortfolioInformation_Window}    VerificationData="Yes"
    mx LoanIQ activate window    ${LIQ_PortfolioInformation_Window}
    Mx LoanIQ Select Combo Box Value    ${LIQ_PortfolioInformation_Portfolio_List}    ${sBankRole_Portfolio}
    Log    ${BankRole_ExpenseCode}
    Mx LoanIQ Select Combo Box Value    ${LIQ_PortfolioInformation_ExpenseCode_List}    ${BankRole_ExpenseCode}
    mx LoanIQ click    ${LIQ_PortfolioInformation_OK_Button}
        ${BankRole_ExpenseCode}    Set Variable    ${sBankRole_ExpenseCode} - ${sBankRole_ExpenseCodeDesc}
    Validate String Data In LIQ Object    ${LIQ_BankRoleDetails_Window}    ${LIQ_BankRoleDetails_Portfolio_Field}    ${sBankRole_Portfolio}
    Validate String Data In LIQ Object    ${LIQ_BankRoleDetails_Window}    ${LIQ_BankRoleDetails_ExpenseCode_Field}    ${BankRole_ExpenseCode}
    mx LoanIQ click    ${LIQ_BankRoles_OK_Button}
    
Save Changes on Deal Notebook
    [Documentation]    This keyword saves the deal notebook.
    ...    @author: fmamaril
    ...    @update: bernchua    31JUL2019    Used generic keyword for clicking warning message
    ...    @update: ehugo    23JUN2020    - added screenshot

    mx LoanIQ activate window    ${LIQ_DealNoteBook_Window}
    mx LoanIQ select    ${LIQ_DealNotebook_File_Save}
    Verify If Warning Is Displayed
    Repeat Keyword    2 times    Mx Click Element If Present    ${LIQ_Warning_OK_Button}        

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_SaveChanges
    
Set Deal Calendar
     [Documentation]    Sets the Holiday Calendar in the Deal Notebook.
     ...    @author: bernchua
     ...    @update: bernchua    10APR2019    updated keyword to not check items in the JavaTree object
     ...                                      deleted commented lines
     ...    @update: bernchua    09AUG2019    Updated clicking of JavaTree item to 'Mx LoanIQ DoubleClick'
     ...    @update: ehugo    23JUN2020    - added keyword pre-processing; added screenshot
     ...                                   - used 'Mx LoanIQ Select String' to check if calendar item exist
     ...    @update: dahijara    24JUL2020    - removed '%s' when using Mx LoanIQ Select String for ${Calendar_Name}
     [Arguments]    ${sCalendar_Name}

    ### GetRuntime Keyword Pre-processing ###
    ${Calendar_Name}    Acquire Argument Value    ${sCalendar_Name}

     Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Calendars
     ${ButtonStatus_Add}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_DealCalendars_AddButton}    enabled%1        
     ${ButtonStatus_Delete}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_DealCalendars_DeleteButton}    enabled%1
     Run Keyword If    ${ButtonStatus_Add}==True and ${ButtonStatus_Add}==True    Log    Holiday Calendars 'Add' and 'Delete' buttons are enabled.
     
     ${CalendarItem_Exist}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_DealCalendars_Javatree}    ${Calendar_Name}
     
     Run Keyword If    ${CalendarItem_Exist}==True    Run Keywords    Mx LoanIQ DoubleClick    ${LIQ_DealCalendars_Javatree}    ${Calendar_Name}
     ...    AND    Validate Deal Holiday Calendar Items
     ...    AND    mx LoanIQ click    ${LIQ_HolidayCalendar_Cancel_Button}
     ...    ELSE IF    ${CalendarItem_Exist}==False    Run Keywords    mx LoanIQ click    ${LIQ_DealCalendars_AddButton}
     ...    AND    Mx LoanIQ Select Combo Box Value    ${LIQ_HolidayCalendar_ComboBox}    ${Calendar_Name}
     ...    AND    Validate Deal Holiday Calendar Items
     ...    AND    mx LoanIQ click    ${LIQ_HolidayCalendar_OK_Button}

     Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_CalendarsTab_SetCalendar

Delete Calendar from Deal Notebook
    [Documentation]    This keyword delets an added Calendar from a Notebook.
    ...                @author: bernchua    11APR2019    - initial create
    ...    @update: ehugo    23JUN2020    - added keyword pre-processing; added screenshot
    [Arguments]        ${sCalendar_Name}

    ### GetRuntime Keyword Pre-processing ###
    ${Calendar_Name}    Acquire Argument Value    ${sCalendar_Name}

    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Calendars
    ${CalendarItem_Exist}    Run Keyword And Return Status    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_DealCalendars_Javatree}    ${Calendar_Name}%s
    Run Keyword If    ${CalendarItem_Exist}==True    Run Keywords
    ...    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_DealCalendars_Javatree}    ${Calendar_Name}%s
    ...    AND    mx LoanIQ click    ${LIQ_DealCalendars_DeleteButton}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_CalendarsTab_DeleteCalendar
    
Validate Deal Holiday Calendar Items
    [Documentation]    This keyword validates if all items are ticked in the Deal's Holiday Calendar.
    ...    @author: bernchua
	${Status_BorrowerIntentNotice}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_HolidayCalendar_BorrowerIntentNotice_Checkbox}    value%1
	${Status_FXRate}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_HolidayCalendar_FXRate_Checkbox}    value%1
	${Status_InterestRate}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_HolidayCalendar_InterestRate_Checkbox}    value%1
	${Status_EffectiveDate}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_HolidayCalendar_EffectiveDate_Checkbox}    value%1
	${Status_PaymentAdvice}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_HolidayCalendar_PaymentAdvice_Checkbox}    value%1
	${Status_Billing}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_HolidayCalendar_Billing_Checkbox}    value%1
	Run Keyword If    ${Status_BorrowerIntentNotice}==True and ${Status_FXRate}==True and ${Status_InterestRate}==True and ${Status_EffectiveDate}==True and ${Status_PaymentAdvice}==True and ${Status_Billing}==True
	...    Log    All Calendar items are ticked.

Add Deal Pricing Options
    [Documentation]    This keyword adds Pricing Options in the Deal Notebook.
    ...                @author: bernchua
    ...    @update: ehugo    29JUN2020    - added keyword pre-processing; added screenshot
    [Arguments]    ${sPricingOption}    ${sInitialFraction_Round}    ${sRoundingDecimal_Round}    ${sNonBusinessDayRule}
    ...    ${sBillingNumberOfDays}    ${sMatrixChangeAppMethod}    ${sRateChangeAppMethod}    ${sPercentOfRateFormulaUsage}=${EMPTY}
    ...    ${sPricingOption_CCY}=${EMPTY}    ${sRepricing_NonBusinessDayRule}=${EMPTY}
    ...    ${sIntentNotice_DaysInAdvance}=${EMPTY}    ${sIntentNotice_Time}=${EMPTY}    ${sIntentNotice_AMPM}=${EMPTY}

    ### GetRuntime Keyword Pre-processing ###
    ${PricingOption}    Acquire Argument Value    ${sPricingOption}
    ${InitialFraction_Round}    Acquire Argument Value    ${sInitialFraction_Round}
    ${RoundingDecimal_Round}    Acquire Argument Value    ${sRoundingDecimal_Round}
    ${NonBusinessDayRule}    Acquire Argument Value    ${sNonBusinessDayRule}
    ${BillingNumberOfDays}    Acquire Argument Value    ${sBillingNumberOfDays}
    ${MatrixChangeAppMethod}    Acquire Argument Value    ${sMatrixChangeAppMethod}
    ${RateChangeAppMethod}    Acquire Argument Value    ${sRateChangeAppMethod}
    ${PercentOfRateFormulaUsage}    Acquire Argument Value    ${sPercentOfRateFormulaUsage}
    ${PricingOption_CCY}    Acquire Argument Value    ${sPricingOption_CCY}
    ${Repricing_NonBusinessDayRule}    Acquire Argument Value    ${sRepricing_NonBusinessDayRule}
    ${IntentNotice_DaysInAdvance}    Acquire Argument Value    ${sIntentNotice_DaysInAdvance}
    ${IntentNotice_Time}    Acquire Argument Value    ${sIntentNotice_Time}
    ${IntentNotice_AMPM}    Acquire Argument Value    ${sIntentNotice_AMPM}

    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Pricing Rules
    mx LoanIQ click    ${LIQ_PricingRules_AddOption_Button}
    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_Dropdown}    ${PricingOption}
    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_InitialFractionRate_Dropdown}    ${InitialFraction_Round}        
    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_RoundingDecimalRound_Dropdown}    ${RoundingDecimal_Round}
    Run Keyword If    '${PercentOfRateFormulaUsage}'!='${EMPTY}'    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_PercentOfRateFormulaUsage_List}    ${PercentOfRateFormulaUsage}
    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_NonBusinessDayRule_Dropdown}    ${NonBusinessDayRule}
    mx LoanIQ enter    ${LIQ_InterestPricingOption_BillingNumberDays_Field}    ${BillingNumberOfDays}
    Mx LoanIQ Set    ${LIQ_InterestPricingOption_BillBorrower_Checkbox}    ON
    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_MatrixChangeAppMthd_Combobox}    ${MatrixChangeAppMethod}    
    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_RateChangeAppMthd_Combobox}    ${RateChangeAppMethod}
    ${InterestDue_CheckboxVisible}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_InterestPricingOption_InterestDueUponRepricing_Checkbox}    VerificationData="Yes"
    Run Keyword If    ${InterestDue_CheckboxVisible}==True    Mx LoanIQ Set    ${LIQ_InterestPricingOption_InterestDueUponRepricing_Checkbox}    ON
    Run Keyword If    '${PricingOption}'=='Fixed Rate Option'    Mx LoanIQ Set    ${LIQ_InterestPricingOption_InterestDueUponPrincipalPayment_Checkbox}    ON
    Run Keyword If    '${IntentNotice_DaysInAdvance}'!='${EMPTY}'    Run Keywords
    ...    mx LoanIQ enter    ${LIQ_InterestPricingOption_IntentNoticeDaysInAdvance_Textfield}    ${IntentNotice_DaysInAdvance}
    ...    AND    mx LoanIQ enter    ${LIQ_InterestPricingOption_IntentNoticeTimeInAdvance_Textfield}    ${IntentNotice_Time}
    ...    AND    Mx LoanIQ Set    JavaWindow("title:=Interest Pricing Option.*").JavaRadioButton("labeled_containers_path:=.*Intent Notice.*","attached text:=${IntentNotice_AMPM}")    ON
    mx LoanIQ click    ${LIQ_InterestPricingOption_Ok_Button}
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PricingRules_AllowedPricingOption_JavaTree}    ${PricingOption}%s
    Run Keyword If    ${status}==True    Log    ${PricingOption} has been added successfully.
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_PricingRulesTab_PricingOption

Click Add Option In Pricing Rules
    [Documentation]    This keyword just clicks the 'Add Option' button to initialize adding of Deal Pricing Options
    ...                @author: bernchua    02JUL2019    Initial create
    mx LoanIQ activate    ${LIQ_DealNotebook_Window}    
	Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Pricing Rules
    mx LoanIQ click    ${LIQ_PricingRules_AddOption_Button}

Set Pricing Option
    [Documentation]    This keyword selects what Pricing Option to be added and sets the 'Round'
    ...                @author: bernchua    02JUL2019    Initial create
    ...                @update: bernchua    09JUL2019    Added new arguments for Initial Fraction Rate & Roudning Decimal Precision data
    [Arguments]    ${sPricingOption}    ${sInitialFractionRound}    ${sRoundingDecimalRound}    ${sInitialFractionRate}=None    ${sRoundingDecimalPrecision}=None
    mx LoanIQ activate    ${LIQ_InterestPricingOption_Window}
    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_Dropdown}    ${sPricingOption}
    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_InitialFractionRate_Dropdown}    ${sInitialFractionRound}
    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_RoundingDecimalRound_Dropdown}    ${sRoundingDecimalRound}
    Run Keyword If    '${sInitialFractionRound}'!='Actual'    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_InitialFractionRate_List}    ${sInitialFractionRate}
    Run Keyword If    '${sRoundingDecimalRound}'!='Actual'    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_RoundingDecimalPrecision_List}    ${sRoundingDecimalPrecision}

Tick Interest Due Upon Repciring Checkbox
    [Documentation]    This keyword ticks the Interest Due Upon Repricing checkbox in the Interst Pricing Option Details window.
    ...                @author: bernchua    09JUL2019    Initial create
    mx LoanIQ activate    ${LIQ_InterestPricingOption_Window}
    Mx LoanIQ Set    ${LIQ_InterestPricingOption_InterestDueUponRepricing_Checkbox}    ON
    Validate if Element is Checked    ${LIQ_InterestPricingOption_InterestDueUponRepricing_Checkbox}    Interest Due Upon Repricing
    
Tick Interest Due Upon Principal Payment Checkbox
    [Documentation]    This keyword ticks the Interest Due Upon Principal Payment checkbox in the Interst Pricing Option Details window.
    ...                @author: bernchua    09JUL2019    Initial create
    mx LoanIQ activate    ${LIQ_InterestPricingOption_Window}
    Mx LoanIQ Set    ${LIQ_InterestPricingOption_InterestDueUponPrincipalPayment_Checkbox}    ON
    Validate if Element is Checked    ${LIQ_InterestPricingOption_InterestDueUponPrincipalPayment_Checkbox}    Interest Due Upon Principal Payment
    
Set Pricing Option Currency
    [Documentation]    This keyword sets the Currency in the Interest Pricing Option Details window
    ...                @author: bernchua    02JUL2019    Initial create
    [Arguments]    ${sPricingOption_CCY}
    mx LoanIQ activate    ${LIQ_InterestPricingOption_Window}
    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_CCY_List}    ${sPricingOption_CCY}
    
Set Rounding Application Method
    [Documentation]    This keyword sets the Rounding Application Method in the Interest Pricing Option Details window
    ...                @author: bernchua    02JUL2019    Initial create
    [Arguments]    ${sRoundingApplicationMethod}
    mx LoanIQ activate    ${LIQ_InterestPricingOption_Window}
    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_RoundingApplicationMethod_List}    ${sRoundingApplicationMethod}
    
Set Percent Of Rate Formula Usage
    [Documentation]    This keyword sets the Percent of Rate Formula Usage in the Interest Pricing Option Details window
    ...                @author: bernchua    02JUL2019    Initial create
    ...                @update: bernchua    29AUG2019    Added condition to handle locator error.
    [Arguments]    ${sRateFormulaUsage}
    mx LoanIQ activate    ${LIQ_InterestPricingOption_Window}
    ${STATUS1}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_InterestPricingOption_PercentOfRateFormulaUsage_List}    VerificationData="Yes"
    ${STATUS2}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_InterestPricingOption_PercentOfRateFormulaUsage_Dropdown}    VerificationData="Yes"
    Run Keyword If    ${STATUS1}==True    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_PercentOfRateFormulaUsage_List}    ${sRateFormulaUsage}
    ...    ELSE IF    ${STATUS2}==True    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_PercentOfRateFormulaUsage_Dropdown}    ${sRateFormulaUsage}
    
Set Non Business Day Rule
    [Documentation]    This keyword sets the Non Business Day Rule in the Interest Pricing Option Details window
    ...                @author: bernchua    02JUL2019    Initial create
    [Arguments]    ${sNonBusinessDayRule}    ${sRepricingNonBusinessDayRule}
    mx LoanIQ activate    ${LIQ_InterestPricingOption_Window}
    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_NonBusinessDayRule_Dropdown}    ${sNonBusinessDayRule}
    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_RepricingNonBusinessDayRule_Dropdown}    ${sRepricingNonBusinessDayRule}
    
Set Change Application Method
    [Documentation]    This keyword sets the Matrix & Rate Change Application Method in the Interest Pricing Option Details window
    ...                @author: bernchua    02JUL2019    Initial create
    [Arguments]    ${sMatrixChangeMethod}    ${sRateChangeMethod}
    mx LoanIQ activate    ${LIQ_InterestPricingOption_Window}
    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_MatrixChangeAppMthd_Combobox}    ${sMatrixChangeMethod}
    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_RateChangeAppMthd_Combobox}    ${sRateChangeMethod}
    
Set Pricing Option Billing Days
    [Documentation]    This keyword sets the Billing Number of Days in the Interest Pricing Option Details window
    ...                @author: bernchua    02JUL2019    Initial create
    [Arguments]    ${sBillingNumberDays}
    mx LoanIQ activate    ${LIQ_InterestPricingOption_Window}
    mx LoanIQ enter    ${LIQ_InterestPricingOption_BillingNumberDays_Field}    ${sBillingNumberDays}
    
Set Pricing Option Intent Notice Details
    [Documentation]    This keyword sets the Intent Notice data in the Interest Pricing Option Details window
    ...                @author: bernchua    02JUL2019    Initial create
    [Arguments]    ${sIntentNotice_DaysInAdvance}    ${sIntentNotice_Time}    ${sIntentNotice_AMPM}
    mx LoanIQ activate    ${LIQ_InterestPricingOption_Window}
    mx LoanIQ enter    ${LIQ_InterestPricingOption_IntentNoticeDaysInAdvance_Textfield}    ${sIntentNotice_DaysInAdvance}
    mx LoanIQ enter    ${LIQ_InterestPricingOption_IntentNoticeTimeInAdvance_Textfield}    ${sIntentNotice_Time}
    Mx LoanIQ Set    JavaWindow("title:=Interest Pricing Option.*").JavaRadioButton("labeled_containers_path:=.*Intent Notice.*","attached text:=${sIntentNotice_AMPM}")    ON
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_NoticeDetails
    
Set Interest Pricing Option Amounts And Multiples
    [Documentation]    This keyword adds data to the 'Amounts' and 'Multiples' fields in the Interest Pricing Option Details window.
    ...                @author: bernchua    04JUL2019    Initial create
    [Arguments]    ${sMaxDrawAmount}=None    ${sMinDrawAmount}=None    ${sMinPayAmount}=None    ${sMinAmountMultiples}=None    ${sLenderShareMultiples}=None    
    mx LoanIQ activate    ${LIQ_InterestPricingOption_Window}
    Run Keyword If    '${sMaxDrawAmount}'!='None'    mx LoanIQ enter    ${LIQ_InterestPricingOption_MaximumDrawdownAmount_Textfield}    ${sMaxDrawAmount}
    Run Keyword If    '${sMinDrawAmount}'!='None'    mx LoanIQ enter    ${LIQ_InterestPricingOption_MinimumDrawdownAmount_Textfield}    ${sMinDrawAmount}
    Run Keyword If    '${sMinPayAmount}'!='None'    mx LoanIQ enter    ${LIQ_InterestPricingOption_MinimumPaymentAmount_Textfield}    ${sMinPayAmount}
    Run Keyword If    '${sMinAmountMultiples}'!='None'    mx LoanIQ enter    ${LIQ_InterestPricingOption_MinimumAmountMultiples_Textfield}    ${sMinAmountMultiples}
    Run Keyword If    '${sLenderShareMultiples}'!='None'    mx LoanIQ enter    ${LIQ_InterestPricingOption_MinimumLenderShareMultiples_Textfield}    ${sLenderShareMultiples}
    
Click OK In Interest Pricing Option Details Window
    [Documentation]    This keyword finishes up the setting up of Deal Pricing Option by clicking the OK button
    ...                @author: bernchua    02JUL2019    Initial create
    mx LoanIQ activate    ${LIQ_InterestPricingOption_Window}
    mx LoanIQ click    ${LIQ_InterestPricingOption_Ok_Button}

Validate Added Deal Pricing Option
    [Documentation]    This keyword validates if the added Pricing Option is visible in the object under the Pricing Rules Tab
    ...                @author: bernchua    02JUL2019    Initial create
    [Arguments]    ${sPricingOption}
    mx LoanIQ activate    ${LIQ_DealNotebook_Window}
    ${STATUS}    Run Keyword And Return Status    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PricingRules_AllowedPricingOption_JavaTree}    ${sPricingOption}%s
    Run Keyword If    ${STATUS}==True    Log    ${sPricingOption} has been added successfully.
    
Add Deal Pricing Options (BBSW-Mid)
    [Documentation]    This keyword adds Pricing Options in the Deal Notebook.
    ...    @author: bernchua
    ...    <update> @ghabal - dedication
    ...    @update: clanding    28JUL2020    - added pre-processing keywords; refactor argument; added screenshot
    [Arguments]    ${sPricingOption}    ${sInitialFraction_Round}    ${sRoundingDecimal_Round}    ${sNonBusinessDayRule}
    ...    ${iBillingNumberOfDays}    ${sMatrixChangeAppMethod}    ${sRateChangeAppMethod}
    
    ### GetRuntime Keyword Pre-processing ###
    ${PricingOption}    Acquire Argument Value    ${sPricingOption}
    ${InitialFraction_Round}    Acquire Argument Value    ${sInitialFraction_Round}
    ${RoundingDecimal_Round}    Acquire Argument Value    ${sRoundingDecimal_Round}
    ${NonBusinessDayRule}    Acquire Argument Value    ${sNonBusinessDayRule}
    ${BillingNumberOfDays}    Acquire Argument Value    ${iBillingNumberOfDays}
    ${MatrixChangeAppMethod}    Acquire Argument Value    ${sMatrixChangeAppMethod}
    ${RateChangeAppMethod}    Acquire Argument Value    ${sRateChangeAppMethod}

    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Pricing Rules
    mx LoanIQ click    ${LIQ_PricingRules_AddOption_Button}
    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_Dropdown}    ${PricingOption}
    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_InitialFractionRate_Dropdown}    ${InitialFraction_Round}        
    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_RoundingDecimalRound_Dropdown}    ${RoundingDecimal_Round}    
    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_NonBusinessDayRule_Dropdown}    ${NonBusinessDayRule}
    mx LoanIQ enter    ${LIQ_InterestPricingOption_BillingNumberDays_Field}    ${BillingNumberOfDays}
    Mx LoanIQ Set    ${LIQ_InterestPricingOption_BillBorrower_Checkbox}    ON    
    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_MatrixChangeAppMthd_Combobox}    ${MatrixChangeAppMethod}    
    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_RateChangeAppMthd_Combobox}    ${RateChangeAppMethod}
    
    ###Added the few steps to cater the Cycle Frequency of Interest Payment for BBSW Pricing Option - rtarayao###
    ${status}    Run Keyword And Return Status    Validate if Element is Checked    ${LIQ_InterestPricingOption_InterestDueUponRepricing_Checkbox}    Interest Due Upon Repricing 
    Run Keyword If    ${status}==True    Mx LoanIQ Check Or Uncheck    ${LIQ_InterestPricingOption_InterestDueUponRepricing_Checkbox}    OFF
    ...    ELSE IF    ${status}==False   Mx LoanIQ Set    ${LIQ_InterestPricingOption_InterestDueUponPrincipalPayment_Checkbox}    ON
    
    ${InterestDue_CheckboxVisible}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_InterestPricingOption_InterestDueUponPrincipalPayment_Checkbox}    VerificationData="Yes"
    Run Keyword If    ${InterestDue_CheckboxVisible}==True    Mx LoanIQ Set    ${LIQ_InterestPricingOption_InterestDueUponPrincipalPayment_Checkbox}    ON        
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_PricingRulesTab_PricingOption
    
    mx LoanIQ click    ${LIQ_InterestPricingOption_Ok_Button}
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PricingRules_AllowedPricingOption_JavaTree}    ${PricingOption}%s
    Run Keyword If    ${status}==True    Log    ${PricingOption} has been added successfully.
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_PricingRulesTab_PricingOption

Validate Interest Pricing Frequency Addded From Base Rate API
    [Documentation]    This keyword verifies each added Pricing Option's Frequency if the sent API "Repricing Frequency" value is reflected. 
    ...    @author: bernchua
    ...    @update: ehugo    29JUN2020    - added keyword pre-processing
    [Arguments]    ${sInterestPricingOption}    ${sRepricingFrequency}

    ### GetRuntime Keyword Pre-processing ###
    ${InterestPricingOption}    Acquire Argument Value    ${sInterestPricingOption}
    ${RepricingFrequency}    Acquire Argument Value    ${sRepricingFrequency}

    mx LoanIQ activate    ${LIQ_DealNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Pricing Rules    
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PricingRules_AllowedPricingOption_JavaTree}    ${InterestPricingOption}%d
    mx LoanIQ activate    ${LIQ_InterestPricingOption_Window}    
    mx LoanIQ click    ${LIQ_InterestPricingOption_Frequency_Button}
    mx LoanIQ activate    ${LIQ_FrequencySelectionList_Window} 
    ${RepricingFrequency_Selected}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_FrequencySelectionList_Available_JavaTree}    ${RepricingFrequency}        
    Run Keyword If    ${RepricingFrequency_Selected}==True    Log    ${InterestPricingOption}'s Repricing Frequency of ${RepricingFrequency} is listed.
    ...    ELSE    Fail    ${RepricingFrequency} is not listed as an Available Repricing Frequency for ${InterestPricingOption}.
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_PricingRulesTab_ValidatePricingFrequency
    
Deal Pricing Option Select All Frequency
    [Documentation]    This keyword selects all Available Frequencies in the "Frequency Selection List" window.
    ...    @author: bernchua
    ...    @update: ehugo    29JUN2020    - added screenshot

    mx LoanIQ activate    ${LIQ_FrequencySelectionList_Window}
    ${Available_Count}    Mx LoanIQ Get Data    ${LIQ_FrequencySelectionList_Available_JavaTree}    items count%count    
    mx LoanIQ click    ${LIQ_FrequencySelectionList_SelectAll_Button}    
    ${Selected_Count}    Mx LoanIQ Get Data    ${LIQ_FrequencySelectionList_Selected_JavaTree}    items count%count     
    Run Keyword If    '${Available_Count}'=='${Selected_Count}'    Run Keywords
    ...    Log    All Available Frequency successfully added.
    ...    AND    mx LoanIQ click    ${LIQ_FrequencySelectionList_OK_Button}    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_PricingOption_SelectAllFrequency

Close Interest Pricing Option Details Window
    [Documentation]    This keyword closes the said window.
    ...    @author: bernchua
    ...    @update: ehugo    29JUN2020    - added screenshot

    mx LoanIQ activate    ${LIQ_InterestPricingOption_Window}
    mx LoanIQ click    ${LIQ_InterestPricingOption_Ok_Button}    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_ClosePricingOptionWindow
        
Add Admin Fee in Deal Notebook
    [Documentation]    This keyword adds Admin Fees from the Admin/Event Fees tab of the Deal Notebook.
    ...    This also validates the name of the Admin Fee Notebook window title based on what Income Method is selected.
    ...    @author: bernchua
    ...    @update: fmamaril    26AUG2019    Add handler for holiday
    ...    @update: fmamaril    15MAY2020    - added argument for keyword pre processing
    [Arguments]    ${sIncomeMethod}
    
    ### GetRuntime Keyword Pre-processing ###
    ${IncomeMethod}    Acquire Argument Value    ${sIncomeMethod}

    mx LoanIQ activate    ${LIQ_DealNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Admin/Event Fees
    mx LoanIQ click    ${LIQ_Deal_AdminFees_Add_Button}
    Mx LoanIQ Set    JavaWindow("title:=Select an Income Method.*").JavaRadioButton("label:=${IncomeMethod}")    ON
    mx LoanIQ click    ${LIQ_AdminFees_IncomeMethod_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    ${STATUS}    Run Keyword If    '${IncomeMethod}'=='Amortize'    Mx LoanIQ Verify Object Exist    ${LIQ_AmortizingAdmin_Window}    VerificationData="Yes"
    ...    ELSE IF    '${IncomeMethod}'=='Accrue'    Mx LoanIQ Verify Object Exist    ${LIQ_AccruingAdmin_Window}      VerificationData="Yes"
    Run Keyword If    ${STATUS}==True    Log    ${IncomeMethod} Admin Fee Notebook is displayed.
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_No_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AdminFee_Window    
    
Add Event Fees in Deal Notebook
    [Documentation]    This keyword adds an Event Fee in the Deal Notebook
    ...                @author: bernchua
    ...    
    ...    | Arguments |
    ...    'EventFee' = The name of the Event Fee to be added.
    ...    'EventFee_Amount' = The amount or percentage of the Event Fee
    ...    'EventFee_Type' = The type of amount of the Event Fee. Either "Flat Amount" or "Formula"
    ...    @update: clanding    28JUL2020    - refactor arguments; add ELSE in reporting
    [Arguments]    ${sEventFee_Name}    ${sEventFee_Amount}    ${sEventFee_Type}    ${sDistributeToAllLenders}=ON    ${sEventFee_CCY}=${EMPTY}
    
    ### GetRuntime Keyword Pre-processing ###
    ${EventFee_Name}    Acquire Argument Value    ${sEventFee_Name}
    ${EventFee_Amount}    Acquire Argument Value    ${sEventFee_Amount}
    ${EventFee_Type}    Acquire Argument Value    ${sEventFee_Type}
    ${DistributeToAllLenders}    Acquire Argument Value    ${sDistributeToAllLenders}
    ${EventFee_CCY}    Acquire Argument Value    ${sEventFee_CCY}
    
    mx LoanIQ activate    ${LIQ_DealNotebook_Window}
    mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Admin/Event Fees
    mx LoanIQ click    ${LIQ_Deal_EventFees_Add_Button}
    Mx LoanIQ Select Combo Box Value    ${LIQ_EventFeeDetails_Fee_Combobox}    ${EventFee_Name}
    Mx LoanIQ Set    ${LIQ_EventFeeDetails_DistributeToAll_Checkbox}    ${DistributeToAllLenders}
    Mx LoanIQ Set    JavaWindow("title:=.*Fee Details").JavaRadioButton("label:=${EventFee_Type}")    ON
    mx LoanIQ enter    ${LIQ_EventFeeDetails_Textfield}    ${EventFee_Amount}
    ${verifyCCY}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_EventFeeDetails_CCY_List}    value%${EventFee_CCY}
    Run Keyword If    ${verifyCCY}==True    Log    Event Fee Currency is verified with ${EventFee_CCY}
    mx LoanIQ click    ${LIQ_EventFeeDetails_OK_Button}
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_Deal_EventFees_JavaTree}    ${EventFee_Name}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealWindow_EventFee
    Run Keyword If    ${status}==True    Log    ${EventFee_Name} successfully added.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    ${EventFee_Name} NOT successfully added.
    
Set Deal Upfront Fees
    [Documentation]    Adds an Upfront Fee in the Deal Notebook's Fees tab.
    ...    author: bernchua
    ...    @update: clanding    28JUL2020    - refactor arguments; add screenshot
    [Arguments]    ${sUpfrontFee_Category}    ${sUpfrontFee_Type}    ${sUpfrontFee_RateBasis}    ${sFormulaCategoryType}    ${sUpfrontFee_Amount}    ${sSpreadType}=null
	
	### GetRuntime Keyword Pre-processing ###
    ${UpfrontFee_Category}    Acquire Argument Value    ${sUpfrontFee_Category}
    ${UpfrontFee_Type}    Acquire Argument Value    ${sUpfrontFee_Type}
    ${UpfrontFee_RateBasis}    Acquire Argument Value    ${sUpfrontFee_RateBasis}
    ${FormulaCategoryType}    Acquire Argument Value    ${sFormulaCategoryType}
    ${UpfrontFee_Amount}    Acquire Argument Value    ${sUpfrontFee_Amount}
    ${SpreadType}    Acquire Argument Value    ${sSpreadType}
	
    mx LoanIQ activate    ${LIQ_DealNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Fees
    mx LoanIQ click    ${LIQ_DealFees_ModifyUpfrontFees_Button}
    mx LoanIQ click element if present     ${LIQ_Warning_Yes_Button}
    mx LoanIQ click    ${LIQ_UpfrontFeePricing_Add_Button}
    Mx LoanIQ Optional Select    ${LIQ_AddItem_List}    ${UpfrontFee_Category}
    Mx LoanIQ Optional Select    ${LIQ_AddItemType_List}    ${UpfrontFee_Type}
    mx LoanIQ click    ${LIQ_AddItem_OK_Button}
    Set Fee Selection Details    ${UpfrontFee_Category}    ${UpfrontFee_Type}    ${UpfrontFee_RateBasis}
    Set Formula Category For Fees    ${FormulaCategoryType}    ${UpfrontFee_Amount}    ${SpreadType}
    Validate Upfront Fee Pricing    ${UpfrontFee_Category}
    Validate Upfront Fee Pricing    ${UpfrontFee_Type}
    Validate Upfront Fee Pricing    ${UpfrontFee_Amount}
    Click Validate For Upfront Fee    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_ModifyUpfrontFee
    mx LoanIQ click    ${LIQ_UpfrontFeePricing_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook
    
Validate Upfront Fee Pricing
    [Documentation]    This keyword validates the added Upfront Fee Pricing items in the Deal Notebook.
    ...    
    ...    ItemToBeValidated
    ...    -    The name of the Upfront Fee.
    ...    -    The Upfront Fee Category and Type is concatenated as 1 item in the UI, but are validated individually in this keyword.
    ...    -    If to be used to validate the spread, this would be the actual spread amount.
    ...    
    ...    SpreadType = This is required if to be used to validate the spread type, either 'Basis Points' or 'Percent'.
    ...    
    ...    @author: bernchua
    ...    @update: clanding    28JUL2020    - refactor arguments; add screenshot; changed ELSE IF to ELSE
    [Arguments]    ${sItemToBeValidated}    ${sSpreadType}=null
	
	### GetRuntime Keyword Pre-processing ###
    ${ItemToBeValidated}    Acquire Argument Value    ${sItemToBeValidated}
    ${SpreadType}    Acquire Argument Value    ${sSpreadType}
	
    ${ValidateForSpread}    Run Keyword And Return Status    Should Not Be Equal    ${SpreadType}    null
    Run Keyword If    ${ValidateForSpread}==False    Run Keyword    Validate Upfront Fee Pricing Items    ${ItemToBeValidated}    
    ...    ELSE    Run Keyword    Validate Upfront Fee Pricing Spread    ${ItemToBeValidated}    ${SpreadType}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_SpreadType
    
Validate Upfront Fee Pricing Items
    [Documentation]    This validates the actual name of the Upfront Fee.
    ...    @author: bernchua
    ...    @update: clanding    28JUL2020    - added ELSE in the logging report
    [Arguments]    ${ItemToBeValidated}
    ${ValidatedItem}    Regexp Escape    ${ItemToBeValidated}
    ${UpfrontFeePricing_WindowExist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_UpfrontFeePricing_Window}        VerificationData="Yes"
    ${ItemExist}    Run Keyword If    ${UpfrontFeePricing_WindowExist}==True    Run Keyword And Return Status
    ...    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.*Upfront Fee Pricing").JavaTree("developer name:=.*${ValidatedItem}.*")    VerificationData="Yes"
    ...    ELSE    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Deal Notebook -.*").JavaTree("developer name:=.*${ValidatedItem}.*")    VerificationData="Yes"
    Run Keyword If    ${ItemExist}==True    Log    ${ItemToBeValidated} is listed.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    ${ItemToBeValidated} is NOT listed.
    
Validate Upfront Fee Pricing Spread
    [Documentation]    This validates the actual Upfront Fee spread amount.
    ...    @author: bernchua
    ...    @update: clanding    28JUL2020    - added ELSE in the logging report
    [Arguments]    ${SpreadValue}    ${SpreadType}
    ${BasisPoints}    Run Keyword And Return Status    Should Be Equal    ${SpreadType}    Basis Points
    ${Percent}    Run Keyword And Return Status    Should Be Equal    ${SpreadType}    Percent
    ${SpreadType}    Set Variable If    ${BasisPoints}==True    BP
    ...    ${Percent}==True    %
    ${UpfrontFeePricing_WindowExist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_UpfrontFeePricing_Window}    VerificationData="Yes"
    ${ItemExist}    Run Keyword If    ${UpfrontFeePricing_WindowExist}==True    Run Keyword And Return Status
    ...    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.*Upfront Fee Pricing").JavaTree("developer name:=.*${SpreadValue}${SpreadType}.*")    VerificationData="Yes"
    ...    ELSE      Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Deal Notebook -.*").JavaTree("developer name:=.*${SpreadValue}${SpreadType}.*")    VerificationData="Yes"
    Run Keyword If    ${ItemExist}==True    Log    Global Current X Rate (${SpreadValue}${SpreadType}) is listed.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Global Current X Rate (${SpreadValue}${SpreadType}) is NOT listed.

Click Validate For Upfront Fee
    [Documentation]    This keyword validates the added Upfront Fee by clicking the "Validate" button.
    ...    @author: bernchua
    mx LoanIQ activate    ${LIQ_UpfrontFeePricing_Window}
    mx LoanIQ click    ${LIQ_ModifyUpfrontFees_Validate_Button}        
    ${RESULT}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_Congratulations_MessageBox}    value%Validation completed successfully.        
    Run Keyword If    ${RESULT}==True    Run Keywords
    ...    Log    Upfront Fee Pricing validation Passed.
    ...    AND    mx LoanIQ click    ${LIQ_Congratulations_OK_Button}
    
Navigate to Facility Notebook from Deal Notebook
    [Documentation]    This keyword navigates the LIQ User from the Deal Notebook to the Facility Notebook .
    ...    @author: rtarayao
    ...    @update: fmamaril    12MAR2019    Change Mx Active to Mx Activate Window
    ...    @update: hstone      09JUN2020    - Added Keyword Pre-processing
    ...    @update: dfajardo    22JUL2020    - Added Screenshot
    ...    @update: cfrancis    10SEP2020    - Added Clicking an object on deal notebook summary for deal window to be placed as primary window on multiple LIQ screens
    [Arguments]    ${sFacility_Name}

    ### Keyword Pre-processing ###
    Mx LoanIQ Click    ${LIQ_DealSummary_AdminAgent_Textfield}
    
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}

    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_DealNotebook_InquiryMode_Button}    VerificationData="Yes"
    Run Keyword If    ${status}==True    mx LoanIQ click    ${LIQ_DealNotebook_InquiryMode_Button}
    ...    ELSE    Run Keyword    Mx LoanIQ Verify Object Exist    ${LIQ_DealNotebook_UpdateMode_Button}    VerificationData="Yes"
    mx LoanIQ select    ${LIQ_DealNotebook_Options_Facilities}
    Mx LoanIQ DoubleClick    ${LIQ_FacilityNavigator_FacilitySelection}    ${Facility_Name}
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}  
    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_Options
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Cashflow_FacilityChangeTransaction_ModifyScheduleItem

Navigate to Facility Notebook from Deal Notebook in Inquiry Mode
    [Documentation]    This keyword navigates the LIQ User from the Deal Notebook to the Facility Notebook .
    ...    @author: rtarayao
    ...    <update> ghabal 10/30/18 removed related script for notebook to be in inquiry mode
    ...    @update: fmamaril    12MAR2019    Change Mx Active to Mx Activate Window
    [Arguments]    ${Facility_Name}                      
    mx LoanIQ select    ${LIQ_DealNotebook_Options_Facilities}
    Mx LoanIQ DoubleClick    ${LIQ_FacilityNavigator_FacilitySelection}    ${Facility_Name}
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    mx LoanIQ click element if present    ${LIQ_FacilityNotebook_UpdateMode_Button} 

Verify Current Commitment Amount if Zero
    [Documentation]    This keyword is used to verify if current commitment amount is zero
    ...    @author: ghabal
    ${DisplayedCurrentCommitment}    Mx LoanIQ Get Data    ${LIQ_ClosedDeal__CurrentCommitment_Field}    testdata
    Run Keyword And Continue On Failure    Should Be Equal As Numbers    ${DisplayedCurrentCommitment}    0.00        
    ${result}    Run Keyword And Return Status    Should Be Equal As Numbers    ${DisplayedCurrentCommitment}    0.00
    Run Keyword If   '${result}'=='True'    Log    "Current Commitment Amount is confirmed zero amount"    
    ...     ELSE    Log    "Termination Halted. Current Commitment Amount is not in zero amount"
    
Check Pending Transaction in Deal
    [Documentation]    This keyword is used to check the pending transaction in a deal
    ...    @author: ghabal
    ...    @update: dfajardo    22JUL2020 - Added screenshot
    [Arguments]    ${sDeal_Name}
    
    ### GetRuntime Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    
    mx LoanIQ click element if present    ${LIQ_DealNotebook_InquiryMode_Button}            
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Pending
    Run Keyword And Continue On Failure    mx LoanIQ activate window    JavaWindow("title:=.*${Deal_Name}.*").JavaTree("attached text:=Pending Transactions.*","items count:=0")
    ${result}    Run Keyword And Return Status    mx LoanIQ activate window    JavaWindow("title:=.*${Deal_Name}.*").JavaTree("attached text:=Pending Transactions.*","items count:=0")    
    Run Keyword If   '${result}'=='True'    Log    "Confirmed. There is no pending transaction in the Deal"
    ...     ELSE    Log    "Termination Halted. There is/are pending transaction in the Deal. Please settle these transactions first."

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_Pending

Terminate a Deal
    [Documentation]    This keyword is used to terminate a deal
    ...    @author: ghabal
    ...    @update: dfajardo    22JUL2020 - Added screenshot
    [Arguments]    ${sTerminate_Date}
    
    ### GetRuntime Keyword Pre-processing ###
    ${Terminate_Date}    Acquire Argument Value    ${sTerminate_Date}
    

    mx LoanIQ select    ${LIQ_DealNotebook_StatusTerminate_Menu}
    mx LoanIQ activate    ${LIQ_TerminateDeal_Window}
    mx LoanIQ enter    ${LIQ_TerminateDeal_TerminationDate_Textfield}    ${Terminate_Date}
    mx LoanIQ click    ${LIQ_TerminateDeal_Ok_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ activate window    ${LIQ_TerminatedDeal_Window}
    mx LoanIQ close window    ${LIQ_TerminatedDeal_Window}
    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_StatusTerminate

Mark All Preferred Remittance Instruction
    [Documentation]    This keyword set ups the Deal Admin Agent's Preferred Remittance Instructions and selects all Methods.
    ...    @author: bernchua
    ...    @update: ehugo    23JUN2020    - added screenshot

    mx LoanIQ activate    ${LIQ_ServicingGroupDetails_Window}
    mx LoanIQ click    ${LIQ_ServicingGroupDetails_Add_Button}    
    mx LoanIQ activate    ${LIQ_PreferredRemittanceInstructions_Window}
    Mx LoanIQ Set    ${LIQ_PreferredRemittanceInstructions_All_Checkbox}    ON
    mx LoanIQ click    ${LIQ_PreferredRemittanceInstructions_Ok_Button}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealBorrower_MarkAllPreferredRI

Go To Admin Agent Preferred RI Window
    [Documentation]    This keyword clicks the "Preferred Remittance Instructions" button from the Deal Admin Agent window.
    ...    @author: bernchua
    ...    @update: ehugo    23JUN2020    - added screenshot

    mx LoanIQ activate    ${LIQ_DealAdminAgent_Window}
    mx LoanIQ click    ${LIQ_PreferredRemittanceInstructions_Button}
    mx LoanIQ click element if present     ${LIQ_Warning_Yes_Button}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealAdminAgentWindow_PreferredRI
    
Go To Deal Borrower Preferred RI Window
    [Documentation]    This keyword clicks the "Preferred Remittance Instructions" button from the Deal Borrower window.
    ...    @author: bernchua
    ...    @update: ehugo    23JUN2020    - added screenshot

    mx LoanIQ activate    ${LIQ_DealBorrower_Window}
    mx LoanIQ click    ${LIQ_DealBorrower_PreferredRemittanceInstructions_Button}
    mx LoanIQ click element if present     ${LIQ_Warning_Yes_Button}
    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealBorrowerWindow_PreferredRI
    
Add Preferred Remittance Instruction
    [Documentation]    This keyword clicks the Add button in the Servicing Group Details window to add a Preferred Remittance Instruction.
    ...    @author: bernchua
    ...    @update: fmamaril    10MAY2020    - added optional argument for keyword pre processing
    [Arguments]    ${sDeal_Name}    ${sDeal_Borrower}    ${RI_Method}   
    ### GetRuntime Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    ${Deal_Borrower}    Acquire Argument Value    ${sDeal_Borrower}
    mx LoanIQ activate    ${LIQ_ServicingGroupDetails_Window}    
    Verify If Text Value Exist as Static Text on Page    Deal Servicing Group Details    ${Deal_Name}
    Verify If Text Value Exist as Static Text on Page    Deal Servicing Group Details    ${Deal_Borrower}
    Choose Preferred Remittance Instruction    ${RI_Method}
    
Choose Preferred Remittance Instruction
    [Documentation]    This keyword unmarks all the remittance instruction and selects a specific RI Method.
    ...    @author: bernchua
    [Arguments]    ${RI_Method}         
    mx LoanIQ click    ${LIQ_ServicingGroupDetails_Add_Button}
    # Mx LoanIQ Set    ${LIQ_PreferredRemittanceInstructions_MarkAll_Checkbox}    OFF
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_PreferredRemittanceInstructions_Javatree}   ${RI_Method}%s
    Mx Native Type    {SPACE}
    mx LoanIQ click    ${LIQ_PreferredRemittanceInstructions_Ok_Button}
    # ${STATUS}    Run Keyword And Return Status    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_ServicingGroupDetails_Javatree}    ${RI_Method}%s
    # Run Keyword If    ${STATUS}==True    Log    Admin Agent Preferred Remittance Instruction ${RI_Method} successfully added.
    
Complete Deal Admin Agent Setup
    [Documentation]    This keyword closes the Deal Servicing Group Details and Admin Agent windows to complete the Deal Admin Agent setup.
    ...    @author: bernchua
    ...    @update: ehugo    23JUN2020    - added screenshot

    mx LoanIQ activate    ${LIQ_ServicingGroupDetails_Window}    
    mx LoanIQ click    ${LIQ_ServicingGroupDetails_Ok_Button}
    mx LoanIQ click    ${LIQ_AdminAgent_OK_Button}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ServicingGroupDetailsWindow_CompleteAdminAgentSetup

Complete Deal Borrower Setup
    [Documentation]    This keyword closes the Deal Servicing Group Details and Admin Agent windows to complete the Deal Admin Agent setup.
    ...    @author: bernchua
    ...    @update: ehugo    23JUN2020    - added screenshot

    mx LoanIQ activate    ${LIQ_ServicingGroupDetails_Window}    
    mx LoanIQ click    ${LIQ_ServicingGroupDetails_Ok_Button}
    mx LoanIQ click    ${LIQ_DealBorrower_Ok_Button}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealBorrowerWindow_CompleteSetup
    
Set Bank Role
    [Documentation]    This keyword sets the Bank Role in a Deal.
    ...    @author: bernchua
    ...    @update: ritragel    3JUNE2019    Removed Writing
    ...    @update: clanding    28JUL2020    Added pre-processing keywords; add screenshot; refactor arguments
    [Arguments]    ${sBank_Role}    ${sBank_Name}    ${sBankRole_SG_Alias}    ${sBankRole_SG_GroupMembers}    ${sBankRole_SG_Method}    ${sBankRole_SG}
    
    ### GetRuntime Keyword Pre-processing ###
    ${Bank_Role}    Acquire Argument Value    ${sBank_Role}
    ${Bank_Name}    Acquire Argument Value    ${sBank_Name}
    ${BankRole_SG_Alias}    Acquire Argument Value    ${sBankRole_SG_Alias}
    ${BankRole_SG_GroupMembers}    Acquire Argument Value    ${sBankRole_SG_GroupMembers}
    ${BankRole_SG_Method}    Acquire Argument Value    ${sBankRole_SG_Method}
    ${BankRole_SG}    Acquire Argument Value    ${sBankRole_SG}

    mx LoanIQ activate window    ${LIQ_DealNoteBook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_JavaTab}    Bank Roles
    mx LoanIQ click    ${LIQ_BankRoles_AddBank_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_LenderSelect_Window}    VerificationData="Yes"
    mx LoanIQ activate window      ${LIQ_LenderSelect_Window}
    mx LoanIQ enter    ${LIQ_DealLenderSelect_ShortName_TextField}    ${Bank_Name}
        
    mx LoanIQ click    ${LIQ_DealLenderSelect_Ok_Button}
    mx LoanIQ activate window      ${LIQ_BankRoleDetails_Window}
    Mx LoanIQ Set    JavaWindow("title:=Bank Role Details").JavaCheckbox("attached text:=${Bank_Role}")    ON
    mx LoanIQ click    ${LIQ_BankRoles_ServicingGroup_Button}
    Select Bank Role Servicing Group    ${BankRole_SG_Alias}    ${BankRole_SG_GroupMembers}    ${BankRole_SG_Method}    ${BankRole_SG}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_BankRoles
    mx LoanIQ click    ${LIQ_BankRoles_OK_Button}
    Run Keyword and Continue on Failure    Mx LoanIQ Select String    ${LIQ_BankRoles_JavaTree}   ${Bank_Name}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_BankRoles

Open Facility From Deal Notebook
    [Documentation]    This keyword opens a Facility from the Deal Notebook.
    ...    @author: bernchua
    ...    @update: Archana 19June2020 - Added Pre-processing keyword
    [Arguments]    ${sFacility_Name}
    
    ###Pre-processing Keyword###
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}  
         
    mx LoanIQ click element if present    ${LIQ_DealNotebook_InquiryMode_Button}
    mx LoanIQ activate    ${LIQ_DealNotebook_Window}
    mx LoanIQ click element if present    ${LIQ_DealNotebook_InquiryMode_Button}
    mx LoanIQ select    ${LIQ_DealNotebook_Options_Facilities}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FacilityNavigator_Tree}    ${Facility_Name}%d
        
Verify Circle Notebook Status After Deal Close
    [Documentation]    This keyword verifies the status of the Circle Notebooks after Deal Close.
    ...    @author: bernchua
    ...    @uppdate: ehugo    30JUN2020    - added keyword pre-processing; added screenshot
    ...    @update: clanding    04AUG2020    - updated hard coded values to global variables
    [Arguments]    ${sLenderName}

    ###Pre-processing Keyword###
    ${LenderName}    Acquire Argument Value    ${sLenderName}    

    mx LoanIQ activate    ${LIQ_DealNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    ${SUMMARY_TAB}
    mx LoanIQ select    ${LIQ_DealNotebook_DistributionPrimaries_Menu}
    mx LoanIQ activate window     ${LIQ_PrimariesList_Window}
    ${Primaries_Status}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_PrimariesList_JavaTree}    ${LenderName}%Type/Status%status
    Log To Console    ${Primaries_Status}
    Run Keyword If    '${Primaries_Status}'=='Orig/Closed'    Log    Lender Status is Closed.
    mx LoanIQ close window    ${LIQ_PrimariesList_Window}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_VerifyCircleNotebook
    
Verify Facility Status After Deal Close
    [Documentation]    This keyword verifies the status of the Facility and Deal Notebooks after Deal close.
    ...    @author: bernchua
    ...    @update: fmamaril    10MAY2020    - added argument for keyword pre processing
    ...    @update: ehugo    30JUN2020    - added screenshot
    [Arguments]    ${sFacility_Name}
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}    
    mx LoanIQ activate    ${LIQ_DealNotebook_Window}
    mx LoanIQ select    ${LIQ_DealNotebook_Options_Facilities}
    mx LoanIQ activate window    ${LIQ_FacilityNavigator_Window}    
    ${Facility_Status}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_FacilityNavigator_Tree}    ${Facility_Name}%Status%status
    Run Keyword If    '${Facility_Status}'=='Active'    Log    Facility ${Facility_Name} Status is Active.
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_VerifyFacilityStatus
    mx LoanIQ close window    ${LIQ_FacilityNavigator_Window}

Verify Deal Status After Deal Close
    [Documentation]    This keyword verifies the status of the Deal after Close.
    ...    @author: bernchua
    ...    @update: ehugo    30JUN2020    - added screenshot
    mx LoanIQ activate    ${LIQ_DealNotebook_Window}
    ${Deal_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Deal Notebook - Closed Deal.*")     VerificationData="Yes"
    Run Keyword If    ${Deal_Status}==True    Log    Deal Status is Closed.
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_VerifyDealStatus
    
Validate Deal Closing Cmt With Facility Total Global Current Cmt
    [Documentation]    This keyword validates the Deal's Closing Cmt with the Facility's Total Global Current Cmt after Deal Close.
    ...    @author: bernchua
    ...    @update: ehugo    30JUN2020    - added screenshot
    mx LoanIQ activate    ${LIQ_DealNotebook_Window}
    mx LoanIQ select    ${LIQ_DealNotebook_Options_Facilities}
    mx LoanIQ activate    ${LIQ_FacilityNavigator_Window}
    ${Facility_GlobalCurrentCmt}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_FacilityNavigator_Tree}    TOTAL: %Global Current Cmt%amount
    mx LoanIQ close window    ${LIQ_FacilityNavigator_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Summary    
    ${Deal_ClosingCmt}    Mx LoanIQ Get Data    ${LIQ_ProposedCmt_TextField}    value%amount
    ${Validate_ClosingCmt}    Run Keyword And Return Status    Should Be Equal As Strings    ${Facility_GlobalCurrentCmt}    ${Deal_ClosingCmt}
    Run Keyword If    ${Validate_ClosingCmt}==True    Log    Facility Global Current Cmt ${Facility_GlobalCurrentCmt} is equal to the Deal's Closing Cmt ${Deal_ClosingCmt}.
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_ValidateDealClosingCmt

Get Deal Closing Cmt
    [Documentation]    This keyword gets the Deal's Closing Cmt Amount.
    ...    @author: bernchua
    ...    @update: clanding    28JUL2020    - added post-processing keywords
    [Arguments]    ${sRunTimeVar_ClosingCmt}=None
    mx LoanIQ activate    ${LIQ_DealNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Summary
    ${ClosingCmt}    Mx LoanIQ Get Data    ${LIQ_DealSummary_ClosingCmt_Text}    value%amount
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_ClosingCmt}    ${ClosingCmt}  
    [Return]    ${ClosingCmt}
    
Open Admin Fee From Deal Notebook
    [Documentation]    This keyword opens the Admin Fee from the Deal Notebook.
    ...    @author: bernchua
    ...    @update: hstone      11JUN2020      - Added Keyword Pre-processing
    ...                                        - Added Take Screenshot
    [Arguments]    ${sAdminFee_Alias}

    ### Keyword Pre-processing ###
    ${AdminFee_Alias}    Acquire Argument Value    ${sAdminFee_Alias}

    mx LoanIQ activate    ${LIQ_DealNotebook_Window}
    mx LoanIQ click element if present    ${LIQ_DealNotebook_InquiryMode_Button}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Admin/Event Fees
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_AdminAndEventFees
    Mx LoanIQ DoubleClick    ${LIQ_Deal_AdminFees_JavaTree}    ${AdminFee_Alias}
    
Create Admin Fee Change Transaction
    [Documentation]    This keyword creates an Admin Fee Change Transaction from the Admin Fee Notebook.
    ...    @author: bernchua
    ...    @update: hstone     11JUN2020      - Added Take Screenshot
    mx LoanIQ activate    ${LIQ_AdminFeeNotebook_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AdminFeeNotebook
    mx LoanIQ select    ${LIQ_AdminFeeNotebook_Options_AdminFeeChange}
    ${InfoMessage_AdminFeeChange}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Information_MessageBox}    VerificationData="Yes"
    Run Keyword If    ${InfoMessage_AdminFeeChange}==True    Run Keywords
    ...    Mx LoanIQ Verify Runtime Property    ${LIQ_Information_MessageBox}    text%A new admin fee change transaction will be created and saved for this admin fee.
    ...    AND    mx LoanIQ click    ${LIQ_Information_OK_Button}  

Validate Admin Fee New Data
    [Documentation]    This keyword validates if the new info is reflected in the Admin Fee Notebook after an Admin Fee Change Transaction.
    ...    
    ...    | Arguments |
    ...    'ChangeField' = "Effective Date", "Expiry Date", or "Amortization Period Original Amount Due"
    ...    'NewValue' = The new value in the Admin Fee Notebook.
    ...    
    ...    @author: bernchua
    ...    @update: hstone     11JUN2020     - Added Keyword Pre-processing
    ...                                      - Added Take Screenshot
    [Arguments]    ${sAdminFee_Alias}    ${sChangeField}    ${sNewValue}

    ### Keyword Pre-processing ###
    ${AdminFee_Alias}    Acquire Argument Value    ${sAdminFee_Alias}
    ${ChangeField}    Acquire Argument Value    ${sChangeField}
    ${NewValue}    Acquire Argument Value    ${sNewValue}

    mx LoanIQ activate    ${LIQ_DealNotebook_Window}    
    mx LoanIQ click element if present    ${LIQ_DealNotebook_InquiryMode_Button}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Admin/Event Fees
    ${NewData}    Run Keyword If    '${ChangeField}'=='Expiry Date'    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Deal_AdminFees_JavaTree}    ${AdminFee_Alias}%Expiry Date%data
    ...    ELSE IF    '${ChangeField}'=='Effective Date'    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Deal_AdminFees_JavaTree}    ${AdminFee_Alias}%Effective Date%data
    ...    ELSE IF    '${ChangeField}'=='Amortization Period Original Amount Due'    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Deal_AdminFees_JavaTree}    ${AdminFee_Alias}%Rate/Amount%data
    Run Keyword If    '${NewData}'=='${NewValue}'    Log    New data is reflected in the Admin Fee.
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_AdminAndEventFees

Validate Admin Fee If Added
    [Documentation]    This keyword checks the Administrative Fees JavaTree in the Deal Notebook's Admin/Event Fees if an Admin Fee is successfully added.
    ...    @author: bernchua
    ...    <update @ghabal> - changed "Mx Click ${LIQ_DealNotebook_InquiryMode_Button}" to "Mx Click Element If Present ${LIQ_DealNotebook_InquiryMode_Button}" during Scenario 2 integration testing
    [Arguments]    ${AdminFee_Alias}
    mx LoanIQ activate    ${LIQ_DealNotebook_Window}
    mx LoanIQ click element if present    ${LIQ_DealNotebook_InquiryMode_Button}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Admin/Event Fees
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Deal_AdminFees_JavaTree}    ${AdminFee_Alias}%s
    Run Keyword If    ${status}==True    Log    Admin Fee successfully added.

Get Borrower Name From Deal Notebook
    [Documentation]    This keyword gets the Borrower Name from the Deal Notebook's summary Tab.
    ...    @author: bernchua
    mx LoanIQ activate    ${LIQ_DealNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Summary
    ${Borrower}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_DealSummary_BorrowersDepositors_Tree}    *%Name%name
    [Return]    ${Borrower}

Get Customer Legal Name From Customer Notebook Via Deal Notebook
    [Documentation]    This keyword gets the Borrower Legal Name from the Customer Notebook through the Deal Notebook.
    ...    @author: bernchua
    mx LoanIQ activate    ${LIQ_DealNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Summary
    ${Borrower}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_DealSummary_BorrowersDepositors_Tree}    *%Name%name
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_DealSummary_BorrowersDepositors_Tree}    ${Borrower}%d
    mx LoanIQ click    ${LIQ_DealBorrower_BorrowerNotebook_Button}
    ${Borrower}    Mx LoanIQ Get Data    ${LIQ_ActiveCustomer_Window_LegalName}    value%name
    mx LoanIQ close window    ${LIQ_ActiveCustomer_Window}
    mx LoanIQ close window    ${LIQ_DealBorrower_Window}                    
    [Return]    ${Borrower}

Set Deal Admin Agent Servicing Group
    [Documentation]    This keyword sets and verifies the Deal's Admin Agent Servicing Group.
    ...    @author: bernchua
    ...    @update: ehugo    23JUN2020    - added keyword pre-processing; added screenshot
    [Arguments]    ${sAdminAgent_SGAlias}    ${sAdminAgent_SGName}    ${sAdminAgent_ContactName}    ${sAdminAgent_RIMethod}

    ### Keyword Pre-processing ###
    ${AdminAgent_SGAlias}    Acquire Argument Value    ${sAdminAgent_SGAlias}
    ${AdminAgent_SGName}    Acquire Argument Value    ${sAdminAgent_SGName}
    ${AdminAgent_ContactName}    Acquire Argument Value    ${sAdminAgent_ContactName}
    ${AdminAgent_RIMethod}    Acquire Argument Value    ${sAdminAgent_RIMethod}

    mx LoanIQ activate    ${LIQ_DealAdminAgent_Window}    
    mx LoanIQ click    ${LIQ_AdminAgent_ServicingGroup_Button}
    Set Servicing Group Details    ${AdminAgent_SGAlias}    ${AdminAgent_SGName}    ${AdminAgent_ContactName}    ${AdminAgent_RIMethod}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealAdminAgentWindow_ServicingGroup
    
Set Deal Borrower Servicing Group
    [Documentation]    This keyword clicks the "Servicing Group" button in the Deal Borrower window.
    ...    @author: bernchua
    ...    @update: ehugo    23JUN2020    - added keyword pre-processing; added screenshot
    [Arguments]    ${sBorrower_SGAlias}    ${sBorrower_SGName}    ${sBorrower_ContactName}    ${sBorrower_RIMethod}

    ### Keyword Pre-processing ###
    ${Borrower_SGAlias}    Acquire Argument Value    ${sBorrower_SGAlias}
    ${Borrower_SGName}    Acquire Argument Value    ${sBorrower_SGName}
    ${Borrower_ContactName}    Acquire Argument Value    ${sBorrower_ContactName}
    ${Borrower_RIMethod}    Acquire Argument Value    ${sBorrower_RIMethod}

    mx LoanIQ activate window    ${LIQ_DealBorrower_Window}
    mx LoanIQ click    ${LIQ_DealBorrower_ServicingGroup_Button}
    Set Servicing Group Details    ${Borrower_SGAlias}    ${Borrower_SGName}    ${Borrower_ContactName}    ${Borrower_RIMethod}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealBorrowerWindow_ServicingGroup
    
Set Servicing Group Details
    [Documentation]    This keyword sets and verifies the details in the Servicing Group of the Deal Borrower.
    ...    @author: bernchua
    [Arguments]    ${SG_Alias}    ${SG_Name}    ${SG_ContactName}    ${RI_Method}
    mx LoanIQ activate window    ${LIQ_ServicingGroup_Window}
    
    ${ServGroup_Empty}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_ServicingGroups_JavaTree_Empty}    VerificationData="Yes"
    Run Keyword If    ${ServGroup_Empty}==True    Run Keywords
    ...    mx LoanIQ click    ${LIQ_ServicingGroups_Add_Button}
    ...    AND    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    ...    AND    Mx LoanIQ Select String    ${ContactsSelectionList_Window_Available_List}    ${SG_ContactName}
    ...    AND    mx LoanIQ click    ${ContactsSelectionList_Window_OkButton}
    
    ${Validate_SGAlias}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_ServicingGroups_JavaTree}    ${SG_Alias}
    ${Validate_SGName}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_ServicingGroups_JavaTree}    ${SG_Name}        
    ${Validate_BorrowerContactName}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_ServicingGroups_GroupMembers_JavaTree}    ${SG_ContactName}        
    Run Keyword If    ${Validate_SGAlias}==True and ${Validate_SGName}==True and ${Validate_BorrowerContactName}==True    Log    Servicing Group Details verified.
    Set Servicing Group Remittance Instructions    ${RI_Method}
    mx LoanIQ click    ${LIQ_ServicingGroup_OK_Button}
    
Set Servicing Group Remittance Instructions
    [Documentation]    This keyword sets the Remittance Instructions in the Servicing Group, and selects all Method to be able to select a specific
    ...    method in the Preferred Remittance Instruction.
    ...    @author: bernchua
    [Arguments]    ${RI_Method}
    mx LoanIQ activate window    ${LIQ_ServicingGroup_Window}
    ${Validate_RIMethod}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_ServicingGroups_RemittanceInctructions_JavaTree}    ${RI_Method}            
    Run Keyword If    ${Validate_RIMethod}==False    Validate Remittance Instruction Selection List If Marked All
    Log    Servicing Group Remittance Instructions verified.
    
Validate Remittance Instruction Selection List If Marked All
    [Documentation]    This keyword checks the Remittance Instruction Selection List if all Methods are selected.
    ...    @author: bernchua
    ...    @author: mcastro    26Aug2020    -added screenshot
    mx LoanIQ click    ${LIQ_ServicingGroup_RemittanceInstructions_Button}
    mx LoanIQ activate    ${LIQ_RISelectionList_Window}
    ${MarkAll_Enabled}    Mx LoanIQ Get Data    ${LIQ_RISelectionList_MarkAll_Checkbox}    enabled%value
    Run Keyword If    '${MarkAll_Enabled}'=='0'    Mx LoanIQ Set    ${LIQ_RISelectionList_MarkAll_Checkbox}    ON
    mx LoanIQ click    ${LIQ_RISelectionList_OK_Button}
    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealAdminAgentWindow_ServicingGroup
    
Validate Deal As Not Sole Lender
    [Documentation]    This keyword verifies the Deal if it's not a Sole Lender, and unticks the checkbox if it's enabled.
    ...    @author: bernchua
    ...    @update: ehugo    23JUN2020    - added screenshot

    mx LoanIQ activate    ${LIQ_DealNotebook_Window}
    ${enabled}    Mx LoanIQ Get Data    ${LIQ_DealSummary_SoleLender_Checkbox}    enabled%value
    Run Keyword If    '${enabled}'=='1'    Run Keywords
    ...    Mx LoanIQ Set    ${LIQ_DealSummary_SoleLender_Checkbox}    OFF
    ...    AND    Log    Deal is verified as not a Sole Lender.

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_ValidateSoleLender
    
Enter Deal Projected Close Date
    [Documentation]    This keyword enters the Projected Close Date in the Deal Notebook's Summary Tab.
    ...    @author: bernchua
    ...    @update: ehugo    23JUN2020    - added keyword pre-processing; added screenshot
    [Arguments]    ${sDeal_ProjectedCloseDate}

    ### GetRuntime Keyword Pre-processing ###
    ${Deal_ProjectedCloseDate}    Acquire Argument Value    ${sDeal_ProjectedCloseDate}

    mx LoanIQ activate    ${LIQ_DealNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Summary
    mx LoanIQ click    ${LIQ_DealNotebook_ProjectedCloseDate_Button}
    mx LoanIQ enter    ${LIQ_EnterProjectedCloseDate_Datefield}    ${Deal_ProjectedCloseDate}    
    mx LoanIQ click    ${LIQ_EnterProjectedCloseDate_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}           
    ${ProjectedCloseDate_UI}    Mx LoanIQ Get Data    ${LIQ_DealNotebook_ProjectedCloseDate_Textfield}    value%date
    Run Keyword If    '${Deal_ProjectedCloseDate}'=='${ProjectedCloseDate_UI}'    Log    Deal Projected Close Date verified.    

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_ProjectedCloseDate
    
Check if Admin Fee is Added
    [Documentation]    This validates if the admin fee is added.
    ...    @author: mgaling
    ...    <update> 14Dec18 - bernchua : Added condition to look for the specific admin fee alias if it exists in the object.
    ...    @update: hstone     20JUL2020      - Added Keyword Pre-processing
    [Arguments]    ${sAdminFee_Alias}=${EMPTY}

    ### Keyword Pre-processing ####
    ${AdminFee_Alias}    Acquire Argument Value    ${sAdminFee_Alias}

    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    mx LoanIQ click element if present    ${LIQ_DealNotebook_InquiryMode_Button}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Admin/Event Fees
    ${status}    Run Keyword If    '${AdminFee_Alias}'=='${EMPTY}'    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Deal_AdminFee_Added}    VerificationData="Yes"
    ...    ELSE    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_Deal_AdminFees_JavaTree}    ${AdminFee_Alias}
    Run Keyword If    ${status}==True    Log    Admin Fee successfully added.
    Run Keyword If    ${status}==False    Log    Admin Fee is not successfully added.

Get the Original Amount on Summary Tab of Deal Notebook  
    [Documentation]    This keyword validates the status of Deal Notebook and gets the needed data.
    ...    @author:mgaling
    ...    @update: sahalder    06AUG2020    Added screenshots steps
    
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    mx LoanIQ select    ${LIQ_DealNotebook_Tab}    Summary
    ${Current_Cmt}    Mx LoanIQ Get Data    ${LIQ_ClosedDeal__DealNB_CurrentCmt_StaticText}    text%value
    ${Current_Cmt}    Remove String    ${Current_Cmt}    \ 
   
    ${Contr_Gross}    Mx LoanIQ Get Data    ${LIQ_ClosedDeal__DealNB_ContrGross_StaticText}    text%value
    ${Contr_Gross}    Remove String    ${Contr_Gross}    \   
  
    ${Net_Cmt}    Mx LoanIQ Get Data    ${LIQ_ClosedDeal__DealNB_NetCmt_StaticText}    text%value
    ${Net_Cmt}    Remove String    ${Net_Cmt}    \              
    
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Events
    Mx LoanIQ Select String    ${LIQ_Events_Javatree}    Closed  
    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Deal_Summary
    [Return]    ${Current_Cmt}    ${Contr_Gross}    ${Net_Cmt}

Create Amendment via Deal Notebook
    [Documentation]    This creates amendment via Deal Notebook.
    ...    @author: mgaling
    
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    mx LoanIQ select    ${LIQ_DealNotebook_Options_CreateAmendment} 
    mx LoanIQ activate window    ${LIQ_AmendmentNotebookPending_Window}   
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AmendmentNotebookPending_Window}       VerificationData="Yes"

Verify Admin Fee Status
    [Documentation]    This keyword will verify the Admin Fee Status in Deal Notebook > Admin/Event Fees
    ...    @author: ritragel
    ...    <update> 14Dec18 - bernchua :  Updated the keyword to use a loop logic to check the status of the admin fee,
    ...                                   and added conditions to execute the needed keywords depending on the status.
    ...    @update: hstone     20JUL2020     - Added Keyword Pre-processing
    [Arguments]    ${sDeal_Name}    ${sFeeAlias}    ${sOriginal_Username}    ${sOriginal_Password}    ${sApprover_Username}    ${sApprover_Password}

    ### Keyword Pre-processing ####
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    ${FeeAlias}    Acquire Argument Value    ${sFeeAlias}
    ${original_username}    Acquire Argument Value    ${sOriginal_Username}
    ${original_password}    Acquire Argument Value    ${sOriginal_Password}
    ${approver_username}    Acquire Argument Value    ${sApprover_Username}
    ${approver_password}    Acquire Argument Value    ${sApprover_Password}

    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    :FOR    ${i}    IN RANGE    5
    \    ${FeeStatus}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Deal_AdminFees_JavaTree}    ${FeeAlias}%Status%FeeStatus
    \    Run Keyword If    '${FeeStatus}'=='Awaiting Send To Approval'    Send Admin Fee to Approval    ${FeeAlias}
         ...    ELSE IF    '${FeeStatus}'=='Awaiting Approval'    Approve Admin Fee    ${Deal_Name}    ${FeeAlias}    ${approver_username}    ${approver_password}
         ...    ELSE IF    '${FeeStatus}'=='Awaiting Release'    Release Admin Fee    ${Deal_Name}    ${FeeAlias}
         ...    ELSE IF    '${FeeStatus}'=='Released'    Log    Admin Fee Released
         ...    ELSE    Log    Unable to identify status    level=ERROR
    \    Exit For Loop If    '${FeeStatus}'=='Released'

Get Original Amount on Deal Lender Shares
    [Documentation]    This keyword is for getting the original value on Deal Lender Shares.
    ...    @author:mgaling
    ...    @update    sahalder    06AUG2020    Added keyword pre-processing steps and screenshots
    [Arguments]    ${sHostBank_Lender}    ${sLender1}    ${sLender2}
    
    ### GetRuntime Keyword Pre-processing ###
	${HostBank_Lender}    Acquire Argument Value    ${sHostBank_Lender}
	${Lender1}    Acquire Argument Value    ${sLender1}
    ${Lender2}    Acquire Argument Value    ${sLender2}   
    
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    mx LoanIQ select    ${LIQ_DealNotebook_Queries_LenderShares}
    
    mx LoanIQ activate window    ${LIQ_LenderShares_Window}
    
    ###Get the Orginal Actual Amount under Primaries/Assignees Section###
    ${Original_UIHBActualAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LenderShares_PrimariesAssignees_List}    ${HostBank_Lender}%Actual Amount%Original_UIHBActualAmount
    ${Original_UIHBActualAmount}    Remove String    ${Original_UIHBActualAmount}    ,
    ${Original_UIHBActualAmount}    Convert To Number    ${Original_UIHBActualAmount}            
    
    ${Original_UILender1ActualAmount}     Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LenderShares_PrimariesAssignees_List}    ${Lender1}%Actual Amount%Original_UILender1ActualAmount
    ${Original_UILender1ActualAmount}    Remove String    ${Original_UILender1ActualAmount}    ,
    ${Original_UILender1ActualAmount}    Convert To Number    ${Original_UILender1ActualAmount}  
    
    ${Original_UILender2ActualAmount}     Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LenderShares_PrimariesAssignees_List}    ${Lender2}%Actual Amount%Original_UILender2ActualAmount 
    ${Original_UILender2ActualAmount}    Remove String    ${Original_UILender2ActualAmount}    ,
    ${Original_UILender2ActualAmount}    Convert To Number    ${Original_UILender2ActualAmount} 
    
    ###Get the Original value of Actual Total under Primaries/Assignees Section###
    ${Orig_PrimariesAssignees_ActualTotal}    Mx LoanIQ Get Data    ${LIQ_LenderShares_PrimariesAssignees_ActualTotal}    value%Total 
    ${Orig_PrimariesAssignees_ActualTotal}    Remove String    ${Orig_PrimariesAssignees_ActualTotal}    \
    ${Orig_PrimariesAssignees_ActualTotal}    Remove String    ${Orig_PrimariesAssignees_ActualTotal}    ,
    ${Orig_PrimariesAssignees_ActualTotal}    Convert To Number    ${Orig_PrimariesAssignees_ActualTotal}  
    
    ###Get the Original Actual Amount of Host Bank under Host Bank Shares Section###
    ${Original_UIHBSharesActualAmount}     Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LenderShares_HostBankShares_List}    ${HostBank_Lender}%Actual Amount%Original_UIHBSharesActualAmount
    ${Original_UIHBSharesActualAmount}    Remove String    ${Original_UIHBSharesActualAmount}    ,
    ${Original_UIHBSharesActualAmount}    Convert To Number    ${Original_UIHBSharesActualAmount} 
     
    ###Get the Orginal value of Actual Net All Total under Host Bank Shares Section###
    ${Orig_HostBankShares_ActualNetAllTotal}    Mx LoanIQ Get Data    ${LIQ_LenderShares_HostBankShares_ActualNetAllTotal}    value%Total 
    ${Orig_HostBankShares_ActualNetAllTotal}    Remove String    ${Orig_HostBankShares_ActualNetAllTotal}    \
    ${Orig_HostBankShares_ActualNetAllTotal}    Remove String    ${Orig_HostBankShares_ActualNetAllTotal}    ,
    ${Orig_HostBankShares_ActualNetAllTotal}    Convert To Number    ${Orig_HostBankShares_ActualNetAllTotal}   
    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Primaries_Details
    
    [Return]    ${Original_UIHBActualAmount}    ${Original_UILender1ActualAmount}    ${Original_UILender2ActualAmount}    ${Orig_PrimariesAssignees_ActualTotal}    ${Original_UIHBSharesActualAmount}    ${Orig_HostBankShares_ActualNetAllTotal} 
    
    mx LoanIQ close window    ${LIQ_LenderShares_Window}    
        
Validate the Updates on Deal Notebook
    [Documentation]    This keyword is for validating the Deal Notebook after the Facility Commitment Increase Transaction.
    ...    @author:mgaling
    ...    @update: sahalder    06AUG2020    Added keyword pre-processing steps and Screenshot steps
    [Arguments]    ${sIncrease_Amount}    ${sCurrent_Cmt}    ${sContr_Gross}    ${sComputed_HBActualAmount}    ${sNet_Cmt}    ${sAmendmentNo}    ${sFacility_Name}
    
    ### GetRuntime Keyword Pre-processing ###
    ${Increase_Amount}    Acquire Argument Value    ${sIncrease_Amount}
    ${Current_Cmt}    Acquire Argument Value    ${sCurrent_Cmt}
    ${Contr_Gross}    Acquire Argument Value    ${sContr_Gross} 
    ${Computed_HBActualAmount}    Acquire Argument Value    ${sComputed_HBActualAmount}
    ${Net_Cmt}    Acquire Argument Value    ${sNet_Cmt}
    ${AmendmentNo}    Acquire Argument Value    ${sAmendmentNo}
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}  
    
    ###Validation on Summary Tab###
    
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    
    ${Updated_CurrentCmt}    Mx LoanIQ Get Data    ${LIQ_ClosedDeal__DealNB_CurrentCmt_StaticText}    text%value
    ${Updated_CurrentCmt}    Remove String    ${Updated_CurrentCmt}    \ 
    ${Updated_CurrentCmt}    Remove String    ${Updated_CurrentCmt}    ,
    ${Updated_CurrentCmt}    Convert To Number    ${Updated_CurrentCmt}    2
   
    ${Updated_ContrGross}    Mx LoanIQ Get Data    ${LIQ_ClosedDeal__DealNB_ContrGross_StaticText}    text%value
    ${Updated_ContrGross}    Remove String    ${Updated_ContrGross}    \
    ${Updated_ContrGross}    Remove String    ${Updated_ContrGross}    ,
    ${Updated_ContrGross}    Convert To Number    ${Updated_ContrGross}    2   
  
    ${Updated_NetCmt}    Mx LoanIQ Get Data    ${LIQ_ClosedDeal__DealNB_NetCmt_StaticText}    text%value
    ${Updated_NetCmt}    Remove String    ${Updated_NetCmt}    \  
    ${Updated_NetCmt}    Remove String    ${Updated_NetCmt}    ,
    ${Updated_NetCmt}    Convert To Number    ${Updated_NetCmt}    2            
    
    ###New Current Cmt Validation###
    ${Current_Cmt}    Remove String    ${Current_Cmt}    ,
    ${Current_Cmt}    Convert To Number    ${Current_Cmt}    2  
    
    ${Increase_Amount}    Remove String    ${Increase_Amount}    ,
    ${Increase_Amount}    Convert To Number    ${Increase_Amount}    2  
    
    ${Computed_NewCurrentCmt}    Evaluate    ${Current_Cmt}+${Increase_Amount}
    Log    ${Computed_NewCurrentCmt}
    
    ###New Contr Gross Validation### 
    ${Contr_Gross}    Remove String    ${Contr_Gross}    ,
    ${Contr_Gross}    Convert To Number    ${Contr_Gross}    2   
    
    ${Computed_ContrGross}    Evaluate    ${Contr_Gross}+${Computed_HBActualAmount}
    Log    ${Computed_ContrGross}
    
    ###New Net Cmt Validation###
    ${Net_Cmt}    Remove String    ${Net_Cmt}    ,
    ${Net_Cmt}    Convert To Number    ${Net_Cmt}    2   
    
    ${Computed_NetCmt}      Evaluate    ${Net_Cmt}+${Computed_HBActualAmount}
    Log    ${Computed_NetCmt}
    
    Should Be Equal    ${Updated_CurrentCmt}    ${Computed_NewCurrentCmt}
    Log    ${Updated_CurrentCmt}=${Computed_NewCurrentCmt}          
    
    Should Be Equal    ${Updated_ContrGross}    ${Computed_ContrGross}
    Log    ${Updated_ContrGross}=${Computed_ContrGross}   
    
    Should Be Equal    ${Updated_NetCmt}    ${Computed_NetCmt}
    Log    ${Updated_NetCmt}=${Computed_NetCmt}     
    
    ###Validation on Pending Tab###
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Pending
    Mx LoanIQ Verify Runtime Property    ${LIQ_DeaNotebook_PendingTab_JavaTree}    items count%0    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_PendingTab
     
    ###Validation on Events Tab###
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Events
    Mx LoanIQ Select String    ${LIQ_Events_Javatree}    Amendment Released No. ${AmendmentNo}
    Mx LoanIQ Select String    ${LIQ_Events_Javatree}    Commitment Increase Released
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_EventsTab
       
    ${UIComment}    Mx LoanIQ Get Data    ${LIQ_Events_Comment_Field}    value%Comment
    
    Should Be Equal As Strings    ${UIComment}    Unscheduled increase of ${Increase_Amount} under amendment number ${AmendmentNo} for facility named ${Facility_Name}.       
    
Validate the Updates on Lender Shares
    [Documentation]    This keyword is for validating the Lender Shares after the Facility Commitment Increase Transaction.
    ...    @author:mgaling
    ...    @update: sahalder    06AUG2020    Added keyword pre-processing steps and Screenshot steps
    [Arguments]    ${sHostBank_Lender}    ${sLender1}    ${sLender2}    ${sOriginal_UIHBActualAmount}    ${sComputed_HBActualAmount}    ${sOriginal_UILender1ActualAmount}    ${sComputed_Lender1ActualAmount}
    ...    ${sOriginal_UILender2ActualAmount}    ${sComputed_Lender2ActualAmount}        
    
    ### GetRuntime Keyword Pre-processing ###
    ${HostBank_Lender}    Acquire Argument Value    ${sHostBank_Lender}
    ${Lender1}    Acquire Argument Value    ${sLender1}
    ${Lender2}    Acquire Argument Value    ${sLender2}
    ${Original_UIHBActualAmount}    Acquire Argument Value    ${sOriginal_UIHBActualAmount}
    ${Computed_HBActualAmount}    Acquire Argument Value    ${sComputed_HBActualAmount}
    ${Original_UILender1ActualAmount}    Acquire Argument Value    ${sOriginal_UILender1ActualAmount}
    ${Computed_Lender1ActualAmount}    Acquire Argument Value    ${sComputed_Lender1ActualAmount}
    ${Original_UILender2ActualAmount}    Acquire Argument Value    ${sOriginal_UILender2ActualAmount}
    ${Computed_Lender2ActualAmount}    Acquire Argument Value    ${sComputed_Lender2ActualAmount}

    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    mx LoanIQ select    ${LIQ_DealNotebook_Queries_LenderShares}
    
    mx LoanIQ activate window    ${LIQ_LenderShares_Window}
    
    ###Get the updated Actual Amount under Primaries/Assignees Section###
    ${Updated_UIHBActualAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LenderShares_PrimariesAssignees_List}    ${HostBank_Lender}%Actual Amount%Updated_UIHBActualAmount
    ${Updated_UIHBActualAmount}    Remove String    ${Updated_UIHBActualAmount}    ,
    ${Updated_UIHBActualAmount}    Convert To Number    ${Updated_UIHBActualAmount}            
    
    ${Updated_UILender1ActualAmount}     Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LenderShares_PrimariesAssignees_List}    ${Lender1}%Actual Amount%Updated_UILender1ActualAmount
    ${Updated_UILender1ActualAmount}    Remove String    ${Updated_UILender1ActualAmount}    ,
    ${Updated_UILender1ActualAmount}    Convert To Number    ${Updated_UILender1ActualAmount}  
    
    ${Updated_UILender2ActualAmount}     Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LenderShares_PrimariesAssignees_List}    ${Lender2}%Actual Amount%Updated_UILender2ActualAmount 
    ${Updated_UILender2ActualAmount}    Remove String    ${Updated_UILender2ActualAmount}    ,
    ${Updated_UILender2ActualAmount}    Convert To Number    ${Updated_UILender2ActualAmount} 
    
    ###Get the updated Actual Amount of Host Bank under Host Bank Shares Section###
    ${Updated_UIHBSharesActualAmount}     Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LenderShares_HostBankShares_List}    ${HostBank_Lender}%Actual Amount%Updated_UIHBSharesActualAmount
    ${Updated_UIHBSharesActualAmount}    Remove String    ${Updated_UIHBSharesActualAmount}    ,
    ${Updated_UIHBSharesActualAmount}    Convert To Number    ${Updated_UIHBSharesActualAmount} 
    
    ###Get the updated value of Actual Total under Primaries/Assignees Section###
    ${Updated_PrimariesAssignees_ActualTotal}    Mx LoanIQ Get Data    ${LIQ_LenderShares_PrimariesAssignees_ActualTotal}    text%Actual Total 
    ${Updated_PrimariesAssignees_ActualTotal}    Remove String    ${Updated_PrimariesAssignees_ActualTotal}    \
    ${Updated_PrimariesAssignees_ActualTotal}    Remove String    ${Updated_PrimariesAssignees_ActualTotal}    ,
    ${Updated_PrimariesAssignees_ActualTotal}    Convert To Number    ${Updated_PrimariesAssignees_ActualTotal}  
    
    ###Get the updated value of Actual Net All Total under Host Bank Shares Section###
    ${Updated_HostBankShares_ActualNetAllTotal}    Mx LoanIQ Get Data    ${LIQ_LenderShares_HostBankShares_ActualNetAllTotal}    text%Net All Total
    ${Updated_HostBankShares_ActualNetAllTotal}    Remove String    ${Updated_HostBankShares_ActualNetAllTotal}    \
    ${Updated_HostBankShares_ActualNetAllTotal}    Remove String    ${Updated_HostBankShares_ActualNetAllTotal}    ,
    ${Updated_HostBankShares_ActualNetAllTotal}    Convert To Number    ${Updated_HostBankShares_ActualNetAllTotal}
    
    ###Compare the data between Updated Data (UI) and Calculated Actual Amount for the Lenders###
    ${Calculated_UpdatedHBActualAmt}    Evaluate    ${Original_UIHBActualAmount}+${Computed_HBActualAmount}
    ${Calculated_UpdatedLender1ActualAmt}    Evaluate    ${Original_UILender1ActualAmount}+${Computed_Lender1ActualAmount}
    ${Calculated_UpdatedLender2ActualAmt}    Evaluate    ${Original_UILender2ActualAmount}+${Computed_Lender2ActualAmount}
    
    Should Be Equal    ${Updated_UIHBActualAmount}    ${Calculated_UpdatedHBActualAmt} 
    Log    message       
    Should Be Equal    ${Updated_UILender1ActualAmount}    ${Calculated_UpdatedLender1ActualAmt} 
    Log    message     
    Should Be Equal    ${Updated_UILender2ActualAmount}    ${Calculated_UpdatedLender2ActualAmt} 
    Log    message  
    
    Should Be Equal    ${Updated_UIHBActualAmount}    ${Updated_UIHBSharesActualAmount} 
    Log    ${Updated_UIHBActualAmount}=${Updated_UIHBSharesActualAmount}
    
    ###Validation of Actual Total of Primaries/Assignees###
    ${Sum_PrimariesActualAmt}    Evaluate    ${Updated_UIHBActualAmount}+${Updated_UILender1ActualAmount}+${Updated_UILender2ActualAmount}
    
    Should Be Equal    ${Sum_PrimariesActualAmt}    ${Updated_PrimariesAssignees_ActualTotal}
    Log    ${Sum_PrimariesActualAmt}=${Updated_PrimariesAssignees_ActualTotal}          
    
    ###Validation of Actual Net All Total Validation###
    Should Be Equal    ${Updated_UIHBSharesActualAmount}    ${Updated_HostBankShares_ActualNetAllTotal} 
    Log    ${Updated_UIHBSharesActualAmount}=${Updated_HostBankShares_ActualNetAllTotal}    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LenderShares_Update
    mx LoanIQ close window    ${LIQ_LenderShares_Window} 
    
Validate the Updates on Primaries
    [Documentation]    This keyword is for getting the original amount on Primaries.
    ...    @author:mgaling
    ...    @update: sahalder    06AUG2020    Added keyword pre-processing steps and Screenshot steps
    [Arguments]    ${sHostBank_Lender}    ${sFacility_Name}    ${sUpdated_UIFaciltyCurrentCmt}
    
    ### GetRuntime Keyword Pre-processing ###
    ${HostBank_Lender}    Acquire Argument Value    ${sHostBank_Lender}
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
    ${Updated_UIFaciltyCurrentCmt}    Acquire Argument Value    ${sUpdated_UIFaciltyCurrentCmt}
    
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    mx LoanIQ select    ${LIQ_DealNotebook_DistributionPrimaries_Menu}  
    
    mx LoanIQ activate window    ${LIQ_PrimariesList_Window} 
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_PrimariesList_JavaTree}    ${HostBank_Lender}%d    
    
    mx LoanIQ activate window    ${LIQ_CircleNotebook_Window}  
    Mx LoanIQ Select Window Tab    ${LIQ_CircleNotebook_Tab}    Summary
    
    ${Primaries_TermGlobalCmt}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Circle_Amounts_JavaTree}    ${Facility_Name}%Global Commitment%Global Amt
    ${Primaries_TermGlobalCmt}    Remove String    ${Primaries_TermGlobalCmt}    ,
    ${Primaries_TermGlobalCmt}    Convert To Number    ${Primaries_TermGlobalCmt}    2
    
    Should Be Equal    ${Primaries_TermGlobalCmt}    ${Updated_UIFaciltyCurrentCmt}
    Log    ${Primaries_TermGlobalCmt}=${Updated_UIFaciltyCurrentCmt}
    
    mx LoanIQ click    ${LIQ_Circle_PortfolioAllocations_Button}
    mx LoanIQ activate window    ${LIQ_Cirlce_PortfolioAllocation_Window}
    
    ${PortfolioAlloc_TermGlobalCmt}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_PortfolioAllocation_Facilities_JavaTree}    ${Facility_Name}%Global Commitment%Global Amt
    ${PortfolioAlloc_TermGlobalCmt}    Remove String    ${PortfolioAlloc_TermGlobalCmt}    ,
    ${PortfolioAlloc_TermGlobalCmt}    Convert To Number    ${PortfolioAlloc_TermGlobalCmt}    2
    
    Should Be Equal    ${PortfolioAlloc_TermGlobalCmt}    ${Updated_UIFaciltyCurrentCmt}
    Log    ${PortfolioAlloc_TermGlobalCmt}=${Updated_UIFaciltyCurrentCmt}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Primaries_Updates
    
    mx LoanIQ click    ${LIQ_PortfolioAllocation_Exit_Button} 
    mx LoanIQ close window    ${LIQ_CircleNotebook_Window}
    
    mx LoanIQ activate window    ${LIQ_PrimariesList_Window}
    mx LoanIQ close window    ${LIQ_PrimariesList_Window}
    mx LoanIQ close window    ${LIQ_DealNotebook_Window}
    
Get Customer Lender Legal Name Via Lender Shares In Deal Notebook
    [Documentation]    This keyword gets the Customer Lender Legal Name from the Customer Notebook via Deal Notebook - Lender Shares menu.
    ...                @author: bernchua
    ...    @update: dahijara    29JUL2020    - Added pre & post processing and screenshot 
    [Arguments]    ${sCustomerLender_Name}    ${sRunVar_CustomerLender_LegalName}=None
    ### GetRuntime Keyword Pre-processing ###
    ${CustomerLender_Name}    Acquire Argument Value    ${sCustomerLender_Name}
    mx LoanIQ activate    ${LIQ_DealNotebook_Window}    
    mx LoanIQ select    ${LIQ_DealNotebook_LenderShare}    
    Mx LoanIQ Select String    ${LIQ_SharesFor_Primaries_Tree}    ${CustomerLender_Name}    
    mx LoanIQ click    ${LIQ_SharesFor_LenderNotebook_Button}
    ${CustomerLender_LegalName}    Mx LoanIQ Get Data    ${LIQ_ActiveCustomer_Window_LegalName}    value%name
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SharesFor_LenderNotebook
    mx LoanIQ close window    ${LIQ_ActiveCustomer_Window}
    mx LoanIQ close window    ${LIQ_SharesFor_Window}    
    
    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_CustomerLender_LegalName}
    [Return]    ${CustomerLender_LegalName}
    
Get Customer Lender Remittance Instruction Desc Via Lender Shares In Deal Notebook
    [Documentation]    This keyword gets the customer lender's remittance instruction description via Deal Notebook - Lender Shares menu.
    ...                @author: bernchua
    ...    @update: ehugo    01JUN2020    - added keyword pre-processing and post-processing; added optional runtime variables; added screenshot
    [Arguments]    ${sCustomerLender_Name}    ${sRI_Method}    ${sRunTimeVar_RIDescription}=None

    ### GetRuntime Keyword Pre-processing ###
    ${CustomerLender_Name}    Acquire Argument Value    ${sCustomerLender_Name}
    ${RI_Method}    Acquire Argument Value    ${sRI_Method}

    mx LoanIQ activate    ${LIQ_DealNotebook_Window}    
    mx LoanIQ select    ${LIQ_DealNotebook_LenderShare}    
    Mx LoanIQ Select String    ${LIQ_SharesFor_Primaries_Tree}    ${CustomerLender_Name}    
    mx LoanIQ click    ${LIQ_SharesFor_LenderNotebook_Button}
    mx LoanIQ click element if present    ${LIQ_ActiveCustomer_InquiryMode_Button}
    Mx LoanIQ Select Window Tab    ${LIQ_ActiveCustomer_Tab}    Profiles
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Active_Customer_Profiles_Borrower}    ... Complete%s
    mx LoanIQ click    ${RemittanceInstructions_Button}
    ${RI_Description}    Mx LoanIQ Store TableCell To Clipboard    ${RemittanceList_Window_RemittanceList}    ${RI_Method}%Description%desc
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_CustomerLenderRemittanceInstructionDesc
    mx LoanIQ click    ${RemittanceList_Window_ExitButton}
    mx LoanIQ close window    ${LIQ_ActiveCustomer_Window}
    mx LoanIQ close window    ${LIQ_SharesFor_Window}

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_RIDescription}    ${RI_Description}

    [Return]    ${RI_Description}
    
Get Deal Borrower Remittance Instruction Description
    [Documentation]    This keyword gets the Borrower's Remittance Instruction Description in the Deal Notebook
    ...                @author: bernchua
    ...    @update: ehugo    01JUN2020    - added keyword pre-processing and post-processing; added optional runtime variables; added screenshot
    [Arguments]    ${sBorrower_Name}    ${sRI_Method}    ${sRunTimeVar_RIDescription}=None

    ### GetRuntime Keyword Pre-processing ###
    ${Borrower_Name}    Acquire Argument Value    ${sBorrower_Name}
    ${RI_Method}    Acquire Argument Value    ${sRI_Method}

    mx LoanIQ activate    ${LIQ_DealNotebook_Window}
    Mx LoanIQ DoubleClick    ${LIQ_DealSummary_BorrowersDepositors_Tree}    ${Borrower_Name}
    mx LoanIQ click    ${LIQ_DealBorrower_PreferredRemittanceInstructions_Button}
    ${RI_Description}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_ServicingGroupDetails_Javatree}    ${RI_Method}%Description%desc
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_DealBorrowerRemittanceInstruction
    mx LoanIQ click    ${LIQ_ServicingGroupDetails_Cancel_Button}
    mx LoanIQ click    ${LIQ_DealBorrower_Cancel_Button}

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_RIDescription}    ${RI_Description}

    [Return]    ${RI_Description}
    
Add Relationship Manager on Personnel Tab
    [Documentation]    This keyword adds a relationship manager under Personnel tab on a Deal.
    ...    @author: fmamaril
    ...    @update: mnanquil
    ...    changed validate loaniq details to verify object exist and add the manager's full name in the locator
    [Arguments]    ${RelationshipManagerID}    ${RelationshipManagerFullName}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Personnel          
    mx LoanIQ enter    ${LIQ_DealPersonnel_RelationshipManagerID_Textfield}    ${RelationshipManagerID}
    Mx Native Type    {TAB}
    # Validate Loan IQ Details    ${RelationshipManagerFullName}    ${LIQ_DealPersonnel_RelationshipManagerFullName_Textfield}
    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Deal Notebook.*").JavaEdit("text:=${RelationshipManagerFullName}.*")        VerificationData="Yes"
           
Add Event Fees in Deal Notebook for Agency One Deal
    [Documentation]    This keyword adds an Event Fee in the Deal Notebook; Added option for Distribute to all lenders checkbox for CBA UAT Deal
    ...    @author: fmamaril
    [Arguments]    ${EventFee}    ${EventFee_Amount}    ${EventFee_Type}    ${EventFee_DistributeToAllLenders}=None
    mx LoanIQ activate    ${LIQ_DealNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Admin/Event Fees
    mx LoanIQ click    ${LIQ_Deal_EventFees_Add_Button}
    Mx LoanIQ Select Combo Box Value    ${LIQ_EventFeeDetails_Fee_Combobox}    ${EventFee}
    Run Keyword If    '${EventFee_DistributeToAllLenders}' != 'None'    Mx LoanIQ Check Or Uncheck    ${LIQ_EventFeeDetails_DistributeToAll_Checkbox}    ${EventFee_DistributeToAllLenders}    
    Mx LoanIQ Set    JavaWindow("title:=.*Fee Details").JavaRadioButton("label:=${EventFee_Type}")    ON
    Run Keyword If    '${EventFee_Type}'=='Flat Amount'    mx LoanIQ enter    ${LIQ_EventFeeDetails_FlatAmount_Textfield}    ${EventFee_Amount}
    ...    ELSE IF    '${EventFee_Type}'=='Formula'    Run Keywords
    ...    Run Keyword And Ignore Error    mx LoanIQ enter    ${LIQ_EventFeeDetails_GlobalCurrent_Textfield}    ${EventFee_Amount}
    ...    AND    Run Keyword And Ignore Error    mx LoanIQ enter    ${LIQ_EventFeeDetails_CircleAmount_Textfield}    ${EventFee_Amount}
    mx LoanIQ click    ${LIQ_EventFeeDetails_OK_Button}
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Deal_EventFees_JavaTree}    ${EventFee}%s
    Run Keyword If    ${status}==True    Log    ${EventFee} successfully added.       
    
Add Deal Administrator on Personnel Tab
    [Documentation]    This keyword adds a Deal Administrator under Personnel tab on a Deal.
    ...    @author: mgaling
    [Arguments]    ${DealAdministratorID}    ${DealAdministratorFullName}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Personnel          
    mx LoanIQ enter    ${LIQ_DealPersonnel_DealAdministratorID_Textfield}    ${DealAdministratorID}
    Mx Native Type    {TAB}
    Validate Loan IQ Details    ${DealAdministratorFullName}    ${LIQ_DealPersonnel_DealAdministratorFullName_Textfield} 

Enter Deal Approved Date
    [Documentation]    This keyword enters the Approved Date of the Deal.
    ...                @author: bernchua    17JUL2019    Initial create
    [Arguments]    ${sApproved_Date}
    mx LoanIQ enter    ${LIQ_DealNotebook_ApproveDate}    ${sApproved_Date}
    mx LoanIQ click    ${LIQ_ApproveDeal_OKButton}
    Verify If Warning Is Displayed
    
Enter Deal Close Date
    [Documentation]    This keyword enters the Close Date of the Deal.
    ...                @author: bernchua    17JUL2019    Initial create
    [Arguments]    ${sClose_Date}
    mx LoanIQ enter    ${LIQ_DealNotebook_CloseDate}    ${sClose_Date}
    mx LoanIQ click    ${LIQ_CloseDeal_OKButton}
    Verify If Warning Is Displayed

Add Multiple Bank Roles
    [Documentation]    This keyword handles multiple Bank Roles.
    ...                @author: fmamaril    22AUG2019    Initial create
    [Arguments]    ${sBankRole_BankName}    ${sBankRole_SGAlias}    ${sBankRole_SGName}    ${sBankRole_SGContactName}    ${sBankRole_RIMethod}
    ...    ${sBankRole_Portfolio}    ${sBankRole_ExpenseCode}    ${sBankRole_ExpenseCodeDesc}
    ...    ${sReference_Bank}    ${sBid_Bank}    ${sSBLC_Issuer}    ${sSwingline_Bank}    ${sBA_Issuing_Bank}
    ...    ${sBA_Reference_Bank}    ${sBA_Owner_Bank}    ${sRAC_Reference_Bank}    ${iBankRole_Percent}=${EMPTY}
    mx LoanIQ activate window    ${LIQ_DealNoteBook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_JavaTab}    Bank Roles
    mx LoanIQ click    ${LIQ_BankRoles_AddBank_Button}
    mx LoanIQ enter    ${LIQ_DealLenderSelect_ShortName_TextField}    ${sBankRole_BankName}
    mx LoanIQ click    ${LIQ_DealLenderSelect_Ok_Button}
    mx LoanIQ activate window      ${LIQ_BankRoleDetails_Window}
    Mx LoanIQ Check Or Uncheck    ${LIQ_BankRoleDetails_ReferenceBank_Checkbox}    ${sReference_Bank}    
    Mx LoanIQ Check Or Uncheck    ${LIQ_BankRoleDetails_BidBank_Checkbox}    ${sBid_Bank}
    Mx LoanIQ Check Or Uncheck    ${LIQ_BankRoleDetails_SBLCGuarantee_Checkbox}    ${sSBLC_Issuer}
    Mx LoanIQ Check Or Uncheck    ${LIQ_BankRoleDetails_Swingline_Checkbox}    ${sSwingline_Bank}
    Mx LoanIQ Check Or Uncheck    ${LIQ_BankRoleDetails_BAIssuingBank_Checkbox}    ${sBA_Issuing_Bank}
    Mx LoanIQ Check Or Uncheck    ${LIQ_BankRoleDetails_BAReferenceBank_Checkbox}    ${sBA_Reference_Bank}
    Mx LoanIQ Check Or Uncheck    ${LIQ_BankRoleDetails_RACReferenceBank_Checkbox}    ${sRAC_Reference_Bank}
    Run Keyword If    '${iBankRole_Percent}'!='${EMPTY}'    mx LoanIQ enter    ${LIQ_BankRoleDetails_Percent_Field}    ${iBankRole_Percent}     
    mx LoanIQ click    ${LIQ_BankRoles_ServicingGroup_Button}
    Select Bank Role Servicing Group    ${sBankRole_SGAlias}    ${sBankRole_SGContactName}    ${sBankRole_RIMethod}    ${sBankRole_SGName}
    Add Bank Role Portfolio Information    ${sBankRole_Portfolio}    ${sBankRole_ExpenseCode}    ${sBankRole_ExpenseCodeDesc}
    ${STATUS}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_BankRoles_JavaTree}   ${sBankRole_BankName}
    Run Keyword If    ${STATUS}==True    Log    Bank Role successfully added.
    ...    ELSE    Fail    Bank Role not added successfully.   

Get Deal Tracking Number
    [Documentation]    This keyword returns the Deal's tracking number.
    ...    @author: rtarayao    14AUG2019    Initial Create
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    MIS Codes
    ${TrackingNumber}    Mx LoanIQ Get Data    ${LIQ_MISCodes_TrackingNumber_Textfield}    TrackingNumber    
    Log    ${TrackingNumber}
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    Facility Ctrl Number
    Take Screenshot    ${SCREENSHOT_FILENAME}
    [Return]    ${TrackingNumber}  
    
Get Deal Global Current and Closing Cmt Amounts
    [Documentation]    This keyword returns the values for both the Global Current and Closing Commitment Amount.
    ...    @author: rtarayao    14AUG2019    Initial Create
    mx LoanIQ activate    ${LIQ_DealNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Summary
    ${GlobalClosingCmt}    Mx LoanIQ Get Data    ${LIQ_DealSummary_ClosingCmt_Text}    value%amount
    Log    The Global Closing Commitment Amount is ${GlobalClosingCmt}
    ${GlobalCurrentCmt}    Mx LoanIQ Get Data    ${LIQ_DealSummary_CurrentCmt_Text}    value%amount
    Log    The Global Current Commitment Amount is ${GlobalCurrentCmt}
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    Deal Amts
    Take Screenshot    ${SCREENSHOT_FILENAME}
    [Return]    ${GlobalClosingCmt}    ${GlobalCurrentCmt}      

Get Deal Host Bank Net and Closing Cmt Amounts
    [Documentation]    This keyword returns the values for both the Global Current and Closing Commitment Amount.
    ...    @author: rtarayao    14AUG2019    Initial Create
    mx LoanIQ activate    ${LIQ_DealNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Summary
    ${HBClosingCmt}    Mx LoanIQ Get Data    ${LIQ_DealSummary_HBClosingCmt_Text}    value%amount
    Log    The Global Closing Commitment Amount is ${HBClosingCmt}
    ${HBNetCmt}    Mx LoanIQ Get Data    ${LIQ_DealSummary_HBCurrentCmt_Text}    value%amount
    Log    The Global Current Commitment Amount is ${HBNetCmt}
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    Deal Amts
    Take Screenshot    ${SCREENSHOT_FILENAME}
    [Return]    ${HBClosingCmt}    ${HBNetCmt}  

Get Deal Expense Description
    [Documentation]    This keyword returns the deal expense description.
    ...    @author: rtarayao    14AUG2019    Initial Create
    mx LoanIQ activate    ${LIQ_DealNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Personnel
    ${ExpenseDesc}    Mx LoanIQ Get Data    ${LIQ_DealPersonnel_ExpenseCode_Description_Text}    expense description
    Log    The Deal Expense Description is ${ExpenseDesc}
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    Deal Expense
    Take Screenshot    ${SCREENSHOT_FILENAME} 
    [Return]    ${ExpenseDesc}

Get Deal Department Code on Personnel Tab
    [Documentation]    This keyword returns the deal department code.
    ...    @author: rtarayao    14AUG2019    Initial Create
    [Arguments]    ${sDepartment}
    mx LoanIQ activate    ${LIQ_DealNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Personnel
    mx LoanIQ click    ${LIQ_DealPersonnel_Department_Button}
    ${DeptCode}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_DepartmentSelector_Javatree}    ${sDepartment}%Code%DeptCode
    Log    The Deal Department Code is ${DeptCode}
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    Dept Code
    Take Screenshot    ${SCREENSHOT_FILENAME}
    mx LoanIQ click    ${LIQ_DepartmentSelector_OK_Button}
    [Return]    ${DeptCode}     
    
Get Borrower Count
    [Documentation]    This keyword returns the number of Borrower used for the Deal and/or Facility.
    ...    Example: sBorrower=Borrower1|Borrower2|Borrower3 . . . 
    ...             sDelimiter=|
    ...    @author: rtarayao    15AUG2019    Initial Create
    [Arguments]    ${sBorrower}    ${sDelimiter}
    @{BorrowerList}    Split String    ${sBorrower}    ${sDelimiter}    
    Log    ${BorrowerList}    
    ${BorrowerCount}    Get Length    ${BorrowerList}
    Log    The number of Borrower is ${BorrowerCount}        
    [Return]    ${BorrowerCount} 

Get Lender Count
    [Documentation]    This keyword returns the number of Lender used for the Deal.
    ...    Example: sLender=Lender1|Lender2|Lender3 . . . 
    ...             sDelimiter=|
    ...    @author: rtarayao    15AUG2019    Initial Create
    [Arguments]    ${sLender}    ${sDelimiter}
    @{LenderList}    Split String    ${sLender}    ${sDelimiter}
    Log    ${LenderList}    
    ${LenderCount}    Get Length    ${LenderList}
    Log    The number of Borrower is ${LenderCount}        
    [Return]    ${LenderCount}

Get Facility Count
    [Documentation]    This keyword returns the number of Facility used for the Deal.
    ...    Example: sLender=Facility1|Facility2|Facility3 . . . 
    ...             sDelimiter=|
    ...    @author: rtarayao    15AUG2019    Initial Create
    [Arguments]    ${sFacility}    ${sDelimiter}
    @{FacilityList}    Split String    ${sFacility}    ${sDelimiter}
    Log    ${FacilityList}    
    ${FacilityCount}    Get Length    ${FacilityList}
    Log    The number of Borrower is ${FacilityCount}        
    [Return]    ${FacilityCount}

Set Facility Sell Amounts in Primaries
    [Documentation]    This keyword sets the Facility Sell Amounts in Primaries
    ...                @author: fmamaril    28AUG2019    Initial create
    ...                @update: fmamaril    17JUL2020    Add pre-processing and screenshot 
    [Arguments]    ${sFacility_Name}    ${iSellAMount}    ${iBuySellPrice}
    ###Keyword Pre-processing###
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
    ${SellAMount}    Acquire Argument Value    ${iSellAMount}    
    ${BuySellPrice}    Acquire Argument Value    ${iBuySellPrice}
    mx LoanIQ activate window    ${LIQ_OrigPrimaries_Window}
    Mx LoanIQ Select String    ${LIQ_OrigPrimariesy_Facilities_JavaTree}    ${Facility_Name}
    Mx Native Type    {ENTER}
    mx LoanIQ activate window    ${LIQ_PrimariesFacility_Window}
    mx LoanIQ enter    ${LIQ_PrimariesFacility_Amount_Textfield}    ${SellAMount}
    mx LoanIQ enter    ${LIQ_PrimariesFacility_Price_Textfield}    ${BuySellPrice}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Primaries_FacilitySellAmount    
    mx LoanIQ click    ${LIQ_PrimariesFacility_OK_Button}
    
Navigate to Portfolio Settled Discount Change
    [Documentation]    This keyword navigates the user to Portfolio Settled Discount Change
    ...                @create: fmamaril    04SEP2019    Initial create
    [Arguments]    ${sFacility_Name}    ${iSellAMount}    ${EffectiveDate}
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    mx LoanIQ click element if present    ${LIQ_DealNotebook_InquiryMode_Button}
    mx LoanIQ select    ${LIQ_DealNotebook_PortfolioPositions_Menu}
    mx LoanIQ activate window    ${LIQ_Portfolio_Positions_Window}  
    Mx LoanIQ Select String   ${LIQ_Portfolio_Positions_JavaTree}    ${sFacility_Name}
    mx LoanIQ click    ${LIQ_Portfolio_Positions_Adjustment_Button}              
    mx LoanIQ activate window    ${LIQ_Make_Selections_Window}
    Mx LoanIQ Set    ${LIQ_Make_Selections_SettledDiscountChage_RadioButton}    ON           
    mx LoanIQ click    ${LIQ_Make_Selections_OK_Button}
    mx LoanIQ activate window    ${LIQ_Portfolio_Transfer_Window}
    mx LoanIQ enter    ${LIQ_Portfolio_Transfer_Effective_Date}    ${EffectiveDate}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    mx LoanIQ click    ${LIQ_Portfolio_Transfer_To_Portfolio_Button}           

Navigate to Deal Business Event   
    [Documentation]    This keyword navigates LoanIQ to the deal's business event window.
    ...    @create: hstone    05SEP2019    Initial create
    ...    @update: amansuet    02OCT2019    -added screenshot
    ...    @update: mcastro   10SEP2020    Updated screenshot path
    [Arguments]    ${sDealName}    ${sEvent}
    Open Existing Deal    ${sDealName}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Events
    
    ${sFetchedEvent}    Run Keyword If    '${sEvent}'!='None'    Select Java Tree Cell Value First Match    ${LIQ_Events_Javatree}    ${sEvent}    Event 
    ...    ELSE    Set Variable    None           
    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Deal_Business_Event
    
    ${IsMatched}    Run Keyword And Return Status    Should Be Equal As Strings    ${sFetchedEvent}    ${sEvent}        
    Run Keyword If    ${IsMatched}==${True}    Log    Event Verification Passed        
    ...    ELSE    Fail    Event Verification Failed. ${sFetchedEvent} != ${sEvent}  
    
    ${Event_isAmendmentReleased}    Run Keyword And Return Status    Should Contain    ${sEvent}    Amendment Released
    Run Keyword If    ${Event_isAmendmentReleased}==True    Validate Deal Amendment Event Start Date    ${sEvent}
    ...    ELSE    Run Keyword    Validate Deal Event Start Date    ${sEvent}
          

Get Customer ID from Active Customer Notebook Via Deal Notebook
    [Documentation]    This keyword gets the Customer ID from the Customer Notebook through the Deal Notebook.
    ...    @author: hstone
    ...    @update: hstone    23SEP2019    Updated Java Tree Selection Routine.
    [Arguments]    ${sBorrowerName}   
    mx LoanIQ activate    ${LIQ_DealNotebook_Window}
    mx LoanIQ click element if present    ${LIQ_InquiryMode_Button}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Summary
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_DealSummary_BorrowersDepositors_Tree}    ${sBorrowerName}%d  
    Mx LoanIQ Select Or DoubleClick In Javatree  ${LIQ_DealSummary_BorrowersDepositors_Tree}    ${sBorrowerName}%d  
    Log    (Get Customer ID from Active Customer Notebook Via Deal Notebook) sBorrowerName = ${sBorrowerName} 
    mx LoanIQ click    ${LIQ_DealBorrower_BorrowerNotebook_Button}   
    ${CustomerID}    Get Customer ID at Active Customer Window
    Log    (Get Customer ID from Active Customer Notebook Via Deal Notebook) CustomerID = ${CustomerID}
    mx LoanIQ close window    ${LIQ_DealBorrower_Window}  
    [Return]    ${CustomerID}
    
Open Facility Navigator from Deal Notebook
    [Documentation]    Keyword used to open the Facility Navigator from the Deal Notebook menu.
    ...                @author: bernchua    17SEP2019    Initial create
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    mx LoanIQ select    ${LIQ_DealNotebook_Options_Facilities}
    
Add Guarantor in Deal Notebook
    [Documentation]    This keyword adds a Guarantor in the Deal Notebook.
    ...    @author: amansuet    27SEP2019    - initial create
    ...    @update: amansuet    01OCT2019    - added screenshot
    [Arguments]    ${sGuarantor}    ${sGuaranteeType}    ${sEffectiveDate}    ${sExpiryDate}    ${sGlobalValue}

    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}  
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Risk/Regulatory
    mx LoanIQ click element if present    ${LIQ_DealNotebook_InquiryMode_Button}
    mx LoanIQ click    ${LIQ_RiskRegulatory_Guarantees_AddGuarantee_Button}
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    mx LoanIQ activate    ${LIQ_RiskRegulatory_Guarantees_GuarantorSelect_Window}
    mx LoanIQ enter    ${LIQ_RiskRegulatory_Guarantees_GuarantorSelect_Textfield}    ${sGuarantor}
    mx LoanIQ click    ${LIQ_RiskRegulatory_Guarantees_GuarantorSelect_OKButton}
    mx LoanIQ activate    ${LIQ_DealGuarantorDetails_Window}
    Mx LoanIQ Select Combo Box Value    ${LIQ_DealGuarantorDetails_GuaranteeType_List}    ${sGuaranteeType}
    mx LoanIQ enter    ${LIQ_DealGuarantorDetails_CommercialRisk_EffectiveDate_Datefield}    ${sEffectiveDate}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ enter    ${LIQ_DealGuarantorDetails_CommercialRisk_ExpiryDate_Datefield}    ${sExpiryDate}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ enter    ${LIQ_DealGuarantorDetails_CommercialRisk_Global_Textfield}    ${sGlobalValue}
    mx LoanIQ enter    ${LIQ_DealGuarantorDetails_PoliticalRisk_EffectiveDate_Datefield}    ${sEffectiveDate}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ enter    ${LIQ_DealGuarantorDetails_PoliticalRisk_ExpiryDate_Datefield}    ${sExpiryDate}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ enter    ${LIQ_DealGuarantorDetails_PoliticalRisk_Global_Textfield}    ${sGlobalValue}
    mx LoanIQ click    ${LIQ_DealGuarantorDetails_OKButton}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    Add_Guarantor_DealNotebook

Rename Deal
    [Documentation]    This keyword is used to modify the Deal's current name.
    ...    @author: rtarayao    24SEP2019    - Initial Create 
    [Arguments]    ${sDealName}
    mx LoanIQ select    ${LIQ_DealNotebook_RenameDeal_Menu}
    mx LoanIQ activate window    ${LIQ_DealNotebook_RenameDeal_Window}  
    mx LoanIQ enter    ${LIQ_DealNotebook_RenameDeal_NewDealName_Textbox}    ${sDealName}
    mx LoanIQ click    ${LIQ_DealNotebook_RenameDeal_OK_Button}  

Add Bank Role Non Host Bank
    [Documentation]    This keyword sets the Bank Role in the Deal Notebook for Non Host Bank.
    ...    @author: rtarayao    08OCT2019    - Initial Create
    [Arguments]    ${sBankRole_Type}    ${sBankRole_BankName}    ${sBankRole_SGAlias}    ${sBankRole_SGName}    ${sBankRole_SGContactName}    ${sBankRole_RIMethod}
    mx LoanIQ activate window    ${LIQ_DealNoteBook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_JavaTab}    Bank Roles
    mx LoanIQ click    ${LIQ_BankRoles_AddBank_Button}
    mx LoanIQ enter    ${LIQ_DealLenderSelect_ShortName_TextField}    ${sBankRole_BankName}
    mx LoanIQ click    ${LIQ_DealLenderSelect_Ok_Button}
    mx LoanIQ activate window      ${LIQ_BankRoleDetails_Window}
    Mx LoanIQ Set    JavaWindow("title:=Bank Role Details").JavaCheckBox("label:=${sBankRole_Type}")    ON
    mx LoanIQ click    ${LIQ_BankRoles_ServicingGroup_Button}
    Select Bank Role Servicing Group    ${sBankRole_SGAlias}    ${sBankRole_SGContactName}    ${sBankRole_RIMethod}    ${sBankRole_SGName}
    mx LoanIQ click    ${LIQ_BankRoles_OK_Button}
    ${STATUS}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_BankRoles_JavaTree}   ${sBankRole_BankName}
    Run Keyword If    ${STATUS}==True    Log    Bank Role successfully added.
    ...    ELSE    Fail    Bank Role not added successfully.        

Validate Deal Notebook Guarantor Primary Indicator Does Not Exist
    [Documentation]    This keyword is used to validate if the deal guarantor primary indicator does not exist.
    ...    @author: hstone    08JAN2020    - Initial Create 
    [Arguments]    ${sPrimaryIndicatorHeaders_List}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_JavaTab}    Risk/Regulatory
    ${result}    Set Variable    ${FALSE}
    
    :FOR    ${sPrimaryIndicatorHeader}    IN    @{sPrimaryIndicatorHeaders_List}
    \    Exit For Loop If    ${result}==${TRUE}
    \    ${sCurrentPrimaryIndicatorHeader}    Set Variable    ${sPrimaryIndicatorHeader}
    \    ${result}    Verify if String Exists as Java Tree Header    ${LIQ_RiskRegulatory_Guarantees_JavaTree}    ${sPrimaryIndicatorHeader}
    Take Screenshot    Guarantor_PrimaryIndicator_Validation_DealNotebook
    
    Run Keyword If    ${result}==${FALSE}    Log    Guarantor Primary Indicator Does Not Exist.
    ...    ELSE    Fail    Guarantor Primary Indicator Exists. '${sCurrentPrimaryIndicatorHeader}' Primary Guarantor Indicator Header is Found!!!

Validate Deal Notebook Guarantor Make Primary Button Does Not Exist
    [Documentation]    This keyword is used to validate if the deal guarantor make primary button does not exist.
    ...    @author: hstone    08JAN2020    - Initial Create 
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_JavaTab}    Risk/Regulatory
    
    ${Status}    Run Keyword And Return Status    Mx LoanIQ Click    ${LIQ_DealNotebook_MakePrimary_Button}       
    Run Keyword If    ${Status}==True    Fail    'Make Primary Button' exists !!!
    ...    ELSE    Log    'Make Primary' Button is not found at Deal Notebook; Risk/Regulatory Tab.

Navigate to Deal Notebook's Primaries
    [Documentation]    This keyword is used to update Lender at Primaries List
    ...    @author: hstone    13JAN2020    - Initial Create   
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    mx LoanIQ select    ${LIQ_DealNotebook_DistributionPrimaries_Menu}  

Update Lender thru Deal Notebook's Primaries
    [Documentation]    This keyword is used to update Lender at Primaries List
    ...    @author: hstone    10JAN2020    - Initial Create 
    [Arguments]    ${sHostBank_Lender}    ${sThirdParty_Lender}    ${sLender_Type}
    
    Navigate to Deal Notebook's Primaries  
    Update Lender at Primaries List    ${sHostBank_Lender}    ${sThirdParty_Lender}    ${sLender_Type}

Validate Deal Event Start Date
    [Documentation]    This keyword is used to validate whether the Deal's Business Event Queue Start date is greater than, less than, or equal to Business Event Queue End Date. 
    ...    @author: rtarayao    18FEB2020    - initial create
    [Arguments]    ${sEventName}
    ${sEffectiveDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Events_Javatree}    ${sEventName}%Effective%EffectiveDate
    ${sEffectiveDate}    Convert Date    ${sEffectiveDate}    date_format=%d-%b-%Y    result_format=%Y-%m-%d
    ${sEndDate}    Get Current Date    result_format=%Y-%m-%d                
    ${diff}    Subtract Date From Date    ${sEndDate}    ${sEffectiveDate}    result_format=verbose
    Log    ${diff}
    ${diff}    Remove String    ${diff}    ${SPACE}    day    s
    
    Mx LoanIQ click    ${LIQ_Events_EventsQueue_Button}
    Run Keyword If    ${diff} == 0 or ${diff} > 0    Mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    ...    ELSE     Run Keywords    Mx LoanIQ click element if present    ${LIQ_Error_OK_Button}
    ...    AND    Mx LoanIQ Enter    ${LIQ_BusinessEventOutput_StartDate_Field}    ${sEndDate}
    ...    AND    Mx LoanIQ Click    ${LIQ_BusinessEventOutput_Refresh_Button}
    ...    AND    Mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    
Validate Deal Amendment Event Start Date
    [Documentation]    This keyword is used to validate whether the Deal Amendment's Business Event Queue Start date is greater than, less than, or equal to Business Event Queue End Date. 
    ...    @author: rtarayao    18FEB2020    - initial create
    ...    @update: mcastro     17SEP2020    Fixed Enter key with correct value
    [Arguments]    ${sEventName}
    Mx Press Combination    Key.ENTER
    Mx LoanIQ activate    ${LIQ_AmendmentNotebookReleased_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_AmendmentNotebookReleased_Tab}    Events
    Mx LoanIQ Select String    ${LIQ_AMD_Events_JavaTree}    Released    
    
    ${sEffectiveDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_AMD_Events_JavaTree}    ${sEventName}%Effective%EffectiveDate
    ${sEffectiveDate}    Convert Date    ${sEffectiveDate}    date_format=%d-%b-%Y    result_format=%Y-%m-%d
    ${sEndDate}    Get Current Date    result_format=%Y-%m-%d                
    ${diff}    Subtract Date From Date    ${sEndDate}    ${sEffectiveDate}    result_format=verbose
    Log    ${diff}
    ${diff}    Remove String    ${diff}    ${SPACE}    day    s
    Mx LoanIQ click    ${LIQ_AMD_Events_EventQueue_Button}
    Run Keyword If    ${diff} == 0 or ${diff} > 0    Mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    ...    ELSE     Run Keywords    Mx LoanIQ click element if present    ${LIQ_Error_OK_Button}
    ...    AND    Mx LoanIQ Enter    ${LIQ_BusinessEventOutput_StartDate_Field}    ${sEndDate}
    ...    AND    Mx LoanIQ Click    ${LIQ_BusinessEventOutput_Refresh_Button}
    ...    AND    Mx LoanIQ click element if present    ${LIQ_Information_OK_Button}  

Navigate to Deal Notebook Workflow and Proceed With Transaction
    [Documentation]    This keyword navigates to the Loan Drawdown Workflow using the desired Transaction
    ...  @author: hstone    04JUN2020    Initial create
    [Arguments]    ${sTransaction}
    Navigate Notebook Workflow    ${LIQ_DealNotebook_Window}    ${LIQ_DealNotebook_Tab}    ${LIQ_DealNotebook_Workflow_JavaTree}    ${sTransaction}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_Workflow

Delete Existing Holiday on Calendar Table
    [Documentation]    This keyword deletes all existing Holiday on Calendar table.
    ...    @author: dahijara    28MAY2020    - initial create
  
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Calendars
    Sleep    3s    
    ${Calendar}    Mx LoanIQ Store Java Tree Items To Array    ${LIQ_DealCalendars_Javatree}    array
    Log    ${Calendar}
    ${CalendarList}    Split To Lines    ${Calendar}
    ${CalendarCount}    Get Length    ${CalendarList}
    :FOR    ${INDEX}    IN RANGE    ${CalendarCount}
    \    ${CalendarValue}    Run Keyword If    '\t' not in '@{CalendarList}[${INDEX}]'    Set Variable    @{CalendarList}[${INDEX}]
    \    ${CalendarValue}    Run Keyword If    '${CalendarValue}'!='None'    Remove String    ${CalendarValue}    ,
    \    Run Keyword If    '${CalendarValue}'!='None'    Run Keywords    Run Keyword and Continue on Failure    Mx LoanIQ Select String    ${LIQ_DealCalendars_Javatree}   ${CalendarValue}
    ...    AND    Mx LoanIQ click    ${LIQ_DealCalendars_DeleteButton}
    ...    AND    Mx LoanIQ click    ${LIQ_Question_Yes_Button}  
Validate Branch and Processing Area in MIS Codes Tab
    [Documentation]    This keyword validates Branch and Processing Area in MIS Codes tab.
    ...    @author: dahijara    02JUN2020    - initial create
    [Arguments]    ${sBranchName}    ${sProcessingArea}

    mx LoanIQ activate window     ${LIQ_DealNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    MIS Codes

    #Validate Branch Name
    ${BranchName_Locator}    Set Static Text to Locator Single Text    Deal Notebook    ${sBranchName}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${BranchName_Locator}    VerificationData="Yes"
    ${Branch_stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${BranchName_Locator}    VerificationData="Yes"
    Run Keyword If    ${Branch_stat}==True    Log    Location is correct!! Branch Name: '${sBranchName}' is found
    ...    ELSE    Log    Location is incorrect! Branch Name: '${sBranchName}' is not found    level=ERROR

    #Validate Processing Area
    ${ProcessingArea_Locator}    Set Static Text to Locator Single Text    Deal Notebook    ${sProcessingArea}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${ProcessingArea_Locator}    VerificationData="Yes"
    ${ProcessingArea_stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${ProcessingArea_Locator}    VerificationData="Yes"
    Run Keyword If    ${ProcessingArea_stat}==True    Log    Location is correct!! Processing Area: '${sProcessingArea}' is found
    ...    ELSE    Log    Location is incorrect! Processing Area: '${sProcessingArea}' is not found    level=ERROR

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNoteBoon_MISCodesTab_Window

Update Branch and Processing Area
    [Documentation]    This keyword updates Branch and Processing Area in Deal Notebook.
    ...    @author: dahijara    02JUN2020    - initial create
    [Arguments]    ${sBranchName}    ${sProcessingArea}

    mx LoanIQ activate window     ${LIQ_DealNotebook_Window}
    mx LoanIQ click element if present    ${LIQ_InquiryMode_Button}    
    mx LoanIQ select   ${LIQ_DealNotebook_Options_ChangeBranchProcArea}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ activate window     ${LIQ_ChangeBranchProcArea_Window}
    Mx LoanIQ select combo box value    ${LIQ_ChangeBranchProcArea_Branch_Combobox}    ${sBranchName}
    Mx LoanIQ select combo box value    ${LIQ_ChangeBranchProcArea_ProcessingArea_Combobox}    ${sProcessingArea}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ChangeBranchProcArea_Window
    mx LoanIQ click    ${LIQ_ChangeBranchProcArea_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}

Validate and Update Branch and Processing Area in MIS Codes Tab
    [Documentation]    This keyword validates and update Branch and Processing Area in MIS Codes tab if Branch and Processing Area does not match.
    ...    @author: dahijara    02JUN2020    - initial create
    [Arguments]    ${sBranchName}    ${sProcessingArea}

    ${Stat}    Run Keyword And Return Status    Validate Branch and Processing Area in MIS Codes Tab    ${sBranchName}    ${sProcessingArea}

    Run Keyword If    ${Stat}==${False}    Update Branch and Processing Area    ${sBranchName}    ${sProcessingArea}

    ${Stat}    Run Keyword And Return Status    Validate Branch and Processing Area in MIS Codes Tab    ${sBranchName}    ${sProcessingArea}
    Run Keyword If    ${Stat}==${False}    Fail    Branch and Processing Area are Incorrect! Branch:${sBranchName} and Processing Area:${sProcessingArea}
	
Validate Upfront Fee Decisions in Maintenance
    [Documentation]    This keyword is used to validate the Fee Decisions inside Upfront Fee Maintenance menu in the primaries window and also amend the Distribute Field as applicable. 
    ...    @author: sahalder    11JUN2020    - initial create
    [Arguments]    ${s_Fee_Type}    ${s_Facility_Name}    ${s_FeeDecision_Type}    ${s_Distribute_Percent}
    
    ### GetRuntime Keyword Pre-processing ###
    ${Fee_Type}    Acquire Argument Value    ${s_Fee_Type}
    ${Facility_Name}    Acquire Argument Value    ${s_Facility_Name}
    ${FeeDecision_Type}    Acquire Argument Value    ${s_FeeDecision_Type}
    ${Distribute_Percent}    Acquire Argument Value    ${s_Distribute_Percent}

    Mx LoanIQ activate    ${LIQ_OrigPrimaries_Window}
    Mx LoanIQ select    ${LIQ_OrigPrimary_Maintenance_FeeDecisions}
    Mx LoanIQ activate    ${LIQ_CircleFeeDecisions_Window}
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_CircleFeeDecisions_UpfrontFees_JavaTree}    ${Fee_Type}        
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_CircleFeeDecisions_UpfrontFees_JavaTree}    ${Fee_Type} 
    Mx LoanIQ activate    ${LIQ_FeeDecisionFor_Window}
    Run Keyword If    '${FeeDecision_Type}'=='Distribute'    mx LoanIQ enter    ${LIQ_FeeDecisionFor_Distribute_RadioButton}    ON
    Mx LoanIQ Enter    ${LIQ_FeeDecisionFor_Retain_Inputfield}    ${Distribute_Percent}
    Mx LoanIQ click    ${LIQ_FeeDecisionFor_OK_Button}
    Mx LoanIQ activate    ${LIQ_CircleFeeDecisions_Window}
    Run Keyword If    '${Fee_Type}'!='NULL'    Mx LoanIQ Select String    ${LIQ_CircleFeeDecisions_UpfrontFees_JavaTree}    ${Fee_Type}
    Mx LoanIQ click    ${LIQ_CircleFeeDecisions_OK_Button}
    mx LoanIQ close window    ${LIQ_OrigPrimaries_Window}
    
Validate Deal Financial Ratio Added
    [Documentation]    This keyword will validates if the financial ratio is added via deal change.
    ...    @author: hstone
    [Arguments]    ${sFinancial_Ratio_Type}
    ### GetRuntime Keyword Pre-processing ###
    ${Financial_Ratio_Type}    Acquire Argument Value    ${sFinancial_Ratio_Type}
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}  
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Ratios/Conds
    ${Status}    Run Keyword And Return Status    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FinantialRatio_JavaTree}    ${Financial_Ratio_Type}%s
    Run Keyword If    '${Status}'=='True'    Log    '${Financial_Ratio_Type}' is added at the Financial Ratio Table.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    '${Financial_Ratio_Type}' is NOT added at the Financial Ratio Table.
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_RatiosAndConds
    
Enable MassSale on DealNotebook
    [Documentation]    This keyword is used to Enable Mass Sale Checkbox on DealNotebook
    ...    @author:Archana 15Jul2020
    mx LoanIQ activate window     ${LIQ_DealNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    MIS Codes
    Mx LoanIQ Enter    ${LIQ_MISCodes_MassSale_Checkbox}    ON
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/MassSaleCheckbox    
    Select Menu Item    ${LIQ_DealNotebook_Window}    File    Save

Get Method Description from Borrower
    [Documentation]    This keyword is used to get Method Description from Remittance List in Borrower.
    ...    @author: clanding    21JUL2020    - initial create
    [Arguments]    ${sMethod}    ${sBorrower_Location}    ${sRuntime_Variable_UIMethod}=None    ${sRuntime_Variable_UIMethodType}=None

    ### GetRuntime Keyword Pre-processing ###
    ${Method}    Acquire Argument Value    ${sMethod}
    ${Borrower_Location}    Acquire Argument Value    ${sBorrower_Location}
    ${Borrower_Location_In_The_List}    Set Variable    ... ${Borrower_Location}
    
    mx LoanIQ click    ${LIQ_DealBorrower_BorrowerNotebook_Button}
    mx LoanIQ activate window    ${LIQ_ActiveCustomer_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_ActiveCustomer_Tab}    Profiles
    Run Keyword And Continue On Failure    mx LoanIQ click element if present    ${LIQ_InquiryMode_Button}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_ActiveCustomer_BorrowerDetails_List}    ${Borrower_Location_In_The_List}%s
    mx LoanIQ click    ${LIQ_ActiveCustomer_RemittanceInstructions_Button}
    mx LoanIQ activate window    ${LIQ_ActiveCustomer_RemittanceList_Window}
    ${UI_Method}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_ActiveCustomer_Remittance_List}    ${Method}%Description%UI_Method
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/RemittanceList
    
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_ActiveCustomer_Remittance_List}    ${Method}%d
    mx LoanIQ activate window    ${RemittanceList_Window_RemittanceInstructionsDetail_Window}
    ${UI_MethodType}    Mx LoanIQ Get Data    ${RemittanceList_Window_RemittanceInstructionsDetail_MethodType}    text%value
    Mx LoanIQ Close Window    ${RemittanceList_Window_RemittanceInstructionsDetail_Window}
    mx LoanIQ click    ${LIQ_ActiveCustomer_Remittance_List_Exit_Button}
    Mx LoanIQ Close Window    ${LIQ_ActiveCustomer_Window}
    
    Save Values of Runtime Execution on Excel File    ${sRuntime_Variable_UIMethod}    ${UI_Method}
    Save Values of Runtime Execution on Excel File    ${sRuntime_Variable_UIMethodType}    ${UI_MethodType}
    [Return]    ${UI_Method}    ${UI_MethodType}

Get Financial Ratio Type Effective Date and Return
    [Documentation]    This keyword is used to get Effective Date from Financial Ratio Type and return.
    ...    @author: clanding    04AUG2020    - initial create
    [Arguments]    ${sFinancial_Ratio_Type}    ${sRuntime_Variable_EffectiveDate}=None

    ### GetRuntime Keyword Pre-processing ###
    ${Financial_Ratio_Type}    Acquire Argument Value    ${sFinancial_Ratio_Type}
    
    ${EffectiveDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_FinantialRatio_JavaTree}    ${Financial_Ratio_Type}%Effective%date
    
    Save Values of Runtime Execution on Excel File    ${sRuntime_Variable_EffectiveDate}    ${EffectiveDate}
    [Return]    ${EffectiveDate} 
    