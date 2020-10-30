*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Add Lender and Location
    [Documentation]    This keyword adds a Primary Lender to the Deal Notebook via Distribution > Primaries
    ...                @update: bernchua : Added condition to select a Lender Location if combox box is blank.
    ...                @update: bernchua : Removed the setting of transaction type from the conditions.
    ...                                    Removed 1 line of writing to Excel with an undeclared variable ${rowid}
    ...                @update: mgaling  : Updated ${LIQ_DealNoteBook_Window} (does not exist in Deal Locators) into ${LIQ_DealNotebook_Window}
    ...                @update: ritragel    30APR2019    Removed verification. Verification is not really necessary
    ...                @update: bernchua    21AUG2019    Created new keyword for setting Risk Book, that returns a Expense Code Description
    ...                                                  Added returning of ExpCode Description to be used in Portfolio Allocation
    ...                                                  Updated RiskBook variable name
    ...    @update: amansuet    23APR2020    Updated to align with automation standards and added keyword pre processing
    ...    @update: dahijara    01JUL2020    - added keyword processing.
    ...    @update: dahijara    08JUL2020    - Added optional argument for runtime variable
    [Arguments]    ${sDeal_Name}    ${sLender_Name}    ${sLenderLocation}    ${sRiskBook_ExpenseCode}    ${sPrimaries_TransactionType}    ${sRunTimeVar_ExpCodeDescription}=None

    ### GetRuntime Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    ${Lender_Name}    Acquire Argument Value    ${sLender_Name}
    ${LenderLocation}    Acquire Argument Value    ${sLenderLocation}
    ${RiskBook_ExpenseCode}    Acquire Argument Value    ${sRiskBook_ExpenseCode}
    ${Primaries_TransactionType}    Acquire Argument Value    ${sPrimaries_TransactionType}

    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    mx LoanIQ click element if present    ${LIQ_InquiryMode_Button}
    mx LoanIQ select    ${LIQ_DealNotebook_DistributionPrimaries_Menu}
    mx LoanIQ activate window    ${LIQ_PrimariesList_Window}
    mx LoanIQ click    ${LIQ_PrimariesList_AddButton}
    Validate if Element is Checked    ${LIQ_CreatePrimary_Sell_Checkbox}    Sell
    Validate if Element is Unchecked    ${LIQ_CreatePrimary_TicketModeOnly_Checkbox}    Ticket Mode Only
    mx LoanIQ click    ${LIQ_CreatePrimary_Lender_Button}
    Log    ${sLender_Name}
    mx LoanIQ enter    ${LIQ_LenderSelect_Textfield}    ${sLender_Name}
    mx LoanIQ click    ${LIQ_LenderSelect_Search_Button}
    mx LoanIQ click    ${LIQ_LenderList_OK_Button}
    mx LoanIQ activate window    ${LIQ_CreatePrimary_Window}
    ${Primary_Location}    Mx LoanIQ Get Data    ${LIQ_CreatePrimary_Location_ComboBox}    value%test
    Run Keyword If    '${Primary_Location}'=='${EMPTY}'    Mx LoanIQ Select Combo Box Value    ${LIQ_CreatePrimary_Location_ComboBox}    ${sLenderLocation}
    Validate Loan IQ Details    ${sLenderLocation}    ${LIQ_CreatePrimary_Location_ComboBox}
    Mx LoanIQ Select Combo Box Value    ${LIQ_CreatePrimary_Location_ComboBox}    ${sLenderLocation}
    ${riskBookButton_exist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_CreatePrimary_Riskbook_Button}    VerificationData="Yes"
    ${ExpCode_Description}    Run Keyword If    ${riskBookButton_exist}==True    Add Risk Book for Host Bank    ${sRiskBook_ExpenseCode}
    ...    ELSE IF    ${riskBookButton_exist}==False    Log    No Risk Book for Non Host Bank
    Mx LoanIQ Select Combo Box Value    ${LIQ_CreatePrimary_TransactionType_SelectBox}    ${sPrimaries_TransactionType}        
    mx LoanIQ click    ${LIQ_CreatePrimary_OK_Button}
    mx LoanIQ activate window    ${LIQ_OrigPrimaries_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_OrigPrimaries_Window}    VerificationData="Yes"
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Primaries_Window

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_ExpCodeDescription}    ${ExpCode_Description}

    [Return]    ${ExpCode_Description}
    
Add Risk Book for Host Bank
    [Documentation]    This keyword will select an Expense Code - Risk Book for the Primary
    ...                This will also return the exp code description
    ...                @author: bernchua    21AUG2019    Initial create
    [Arguments]    ${sRiskBook_ExpenseCode}
    mx LoanIQ click    ${LIQ_CreatePrimary_Riskbook_Button}
    ${ExpenseCode_Description}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CreatePrimary_Riskbook_JavaTree}    ${sRiskBook_ExpenseCode}%Exp code description%description     
    Mx LoanIQ Select String    ${LIQ_CreatePrimary_Riskbook_JavaTree}    ${sRiskBook_ExpenseCode}
    mx LoanIQ click    ${LIQ_CreatePrimary_Riskbook_OK_Button}
    [Return]    ${ExpenseCode_Description}
    
Set Sell Amount and Percent of Deal
    [Documentation]    This keyword adds a Percent of Deal and Sell Amount.
    ...                @author: fmamaril
    ...                @update: bernchua : Computes, validates and returns the Sell Amount
    ...                @update: mgaling: Activate Window and Convert To Number function for Sell_Amount 
    ...    @update: ehugo    30JUN2020    - added keywords pre-processing and post-processing; added screenshot
    [Arguments]    ${sPercentOfDeal}    ${sRunTimeVar_SellAmount}=None

    ### GetRuntime Keyword Pre-processing ###
    ${PercentOfDeal}    Acquire Argument Value    ${sPercentOfDeal}

    Log    percent of deal is ${PercentOfDeal}
    Mx LoanIQ Select Window Tab    ${LIQ_OrigPrimaries_Tab}    Facilities
    mx LoanIQ activate window    ${LIQ_OrigPrimaries_Window}    
    mx LoanIQ enter    ${LIQ_OrigPrimaries_PctOfDeal_Textfield}    ${PercentOfDeal}
    Mx Press Combination    Key.Tab    

    ${CurrentDealAmount}    Mx LoanIQ Get Data    ${LIQ_OrigPrimaries_CurrentDealAmount_Textfield}    value%amount
    ${CurrentDealAmount}    Remove String    ${CurrentDealAmount}    ,
    ${CurrentDealAmount}    Convert To Number    ${CurrentDealAmount}
    ${SellAmountUI}    Mx LoanIQ Get Data    ${LIQ_OrigPrimaries_SellAmount_Textfield}    value%amount
    
    ${PercentOfDeal}    Remove Comma and Convert to Number    ${PercentOfDeal}
    ${PercentOfDeal}    Evaluate    ${PercentOfDeal}/100
    Log    percent of deal after evaluation ${PercentOfDeal}
    
    Log    percent of deal after conversion ${PercentOfDeal}
    ${Sell_Amount}    Evaluate    ${CurrentDealAmount}*${PercentOfDeal}
    ${Sell_Amount}    Convert To Number    ${Sell_Amount}    2
    ${Sell_Amount}    Convert To String    ${Sell_Amount}
    ${Sell_Amount}    Convert Number With Comma Separators    ${Sell_Amount}
    Run Keyword If    '${SellAmountUI}'=='${Sell_Amount}'    Log    Sell Amount is verified.
    ...    ELSE    Fail    Sell Amount not verified.

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PrimariesWindow_SetSellAmountAndPercentOfDeal

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_SellAmount}    ${Sell_Amount}

    [Return]    ${Sell_Amount}
    
Add Pro Rate
    [Documentation]    This keyword adds a Pro Rate.
    ...    @author: fmamaril
    ...    @update: dahijara    01JUL2020    - added keyword pre-processing and take screenshot
    [Arguments]    ${sBuySellPrice}

    ### GetRuntime Keyword Pre-processing ###
    ${BuySellPrice}    Acquire Argument Value    ${sBuySellPrice}

    Mx LoanIQ Select Window Tab    ${LIQ_OrigPrimaries_Tab}    Facilities
    Run Keyword And Ignore Error    mx LoanIQ click    ${LIQ_OrigPrimaries_ProRate_Button}                        
    mx LoanIQ enter    ${LIQ_ProRate_BuySellPrice_Textfield}     ${BuySellPrice}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CircleNotebook_AddProRate
    mx LoanIQ click    ${LIQ_ProRate_BuySellPrice_Ok_Button}
    
Add Pricing Comment
    [Documentation]    This keyword adds a Pricing Comment.
    ...    @author: fmamaril
    ...    @update: clanding    16JUL2020    - added keyword pre-processing; refactor argument
    [Arguments]    ${sComment}
    
    ### GetRuntime Keyword Pre-processing ###
    ${Comment}    Acquire Argument Value    ${sComment}

    mx LoanIQ click    ${LIQ_OrigPrimaries_PricingComment_Button}
    mx LoanIQ activate window   ${LIQ_PricingComment_CommentEdit_Window}
    mx LoanIQ enter    ${LIQ_PricingComment_CommentEdit_Subject_Textfield}    ${Comment}
    mx LoanIQ enter    ${LIQ_PricingComment_CommentEdit_Comment_Textfield}    ${Comment}
	Mx Native Type    {BACKSPACE}
    mx LoanIQ click   ${LIQ_PricingComment_CommentEdit_Ok_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Primaries_Facility
    
Add Contact in Primary
    [Documentation]    This keyword adds a Contact in Orig Primaries.
    ...    @author: fmamaril
    ...    @update: mnanquil
    ...    Instead of clicking select all contacts replaced the keyword to mx loaniq select string
    ...    and Click the specific contact name.
    ...    Reason: Deleting of contact is failing due to the issue of selecting all contacts.
    [Arguments]    ${sContactName}

    ### GetRuntime Keyword Pre-processing ###
    ${ContactName}    Acquire Argument Value    ${sContactName}  

    Mx LoanIQ Select Window Tab    ${LIQ_OrigPrimaries_Tab}    Contacts
    mx LoanIQ click    ${LIQ_Contact_AddContacts_Button}
    Mx LoanIQ Select String    ${LIQ_CircleContacts_Available_JavaTree}    ${ContactName}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CircleNotebook_Contacts      
    mx LoanIQ click    ${LIQ_CircleContacts_OK_Button} 
    mx LoanIQ click    ${LIQ_ContactSelection_Exit_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Pending Orig Primary:.*").JavaTree("developer name:=.*${ContactName}.*","labeled_containers_path:=.*Contacts.*")     VerificationData="Yes"
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CircleNotebook_Contacts

Create Assignment Sell
    [Documentation]    This keyword creates an Assignment Sell
    ...    @author: ghabal
    ...    @update: amansuet    19JUN2020    - updated to align with automation standards, added take screenshot and added keyword pre-processing
    ...    @update: clanding    14AUG2020    - updated hard coded values to global variables; replaced 'Mx Native Type' to 'Mx Press Combination'
    [Arguments]    ${sLenderShare_Type}    ${sLenderCustomer_Shortname}    ${sAssignmentSell_PercentofDeal}    ${sSeller_Riskbook}    ${sAssignmentSell_IntFeeType}    ${sBuyandSellPrice_Percentage}

    ### Keyword Pre-processing ###
    ${LenderShare_Type}    Acquire Argument Value    ${sLenderShare_Type}
    ${LenderCustomer_Shortname}    Acquire Argument Value    ${sLenderCustomer_Shortname}
    ${AssignmentSell_PercentofDeal}    Acquire Argument Value    ${sAssignmentSell_PercentofDeal}
    ${Seller_Riskbook}    Acquire Argument Value    ${sSeller_Riskbook}
    ${AssignmentSell_IntFeeType}    Acquire Argument Value    ${sAssignmentSell_IntFeeType}
    ${BuyandSellPrice_Percentage}    Acquire Argument Value    ${sBuyandSellPrice_Percentage}

    Mx LoanIQ Select    ${LIQ_DealNotebook_Options_CircleSelect}
    Mx LoanIQ Set    ${LIQ_CircleSelection_NewExternaloption}    ${ON}
    Mx LoanIQ Set    ${LIQ_CircleSelection_Selloption}    ${ON}
    Mx LoanIQ Select Combo Box Value    ${LIQ_CircleSelection_LenderShareType}    ${LenderShare_Type}
    mx LoanIQ click    ${LIQ_CircleSelection_LenderButton}
    Mx LoanIQ Select Combo Box Value    ${LIQ_LenderSelect_Search_Filter}      ${SHORT_NAME}
    Mx LoanIQ Activate    ${LIQ_LenderSelect_SearchWindow}    
    Mx LoanIQ Enter    ${LIQ_LenderSelect_Search_Inputfield}    ${LenderCustomer_Shortname}
    
    mx LoanIQ click    ${LIQ_LenderSelect_OK_Button}
    
    mx LoanIQ click    ${LIQ_CircleSelection_RiskBook_Button}
    Mx LoanIQ Select String    ${LIQ_CreatePrimary_Riskbook_JavaTree}    ${Seller_Riskbook}
    mx LoanIQ click    ${LIQ_CreatePrimary_Riskbook_OK_Button}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/CircleSelectionWindow
    mx LoanIQ click    ${LIQ_CircleSelection_OKButton}
    Mx LoanIQ Activate    ${LIQ_PendingAssignmentSell_Window}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PendingAssignmentSellWindow_FacilityTab
    
    Mx LoanIQ Activate    ${LIQ_PendingAssignmentSell_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_PendingAssignmentSell_Tab}    ${FACILITIES_TAB}
    Mx LoanIQ Enter    ${LIQ_PendingAssignmentSell_PctofDeal_InputField}    ${AssignmentSell_PercentofDeal}
    Mx Press Combination    Key.TAB
    Mx LoanIQ Select    ${LIQ_PendingAssignmentSell_IntFeeDropdownList}    ${AssignmentSell_IntFeeType}
    mx LoanIQ click    ${LIQ_PendingAssignmentSell_ProRate_Button}
    Mx LoanIQ Enter    ${LIQ_ProRate_BuySellPrice_Textfield}    ${BuyandSellPrice_Percentage}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/CircleSelectionWindow
    mx LoanIQ click    ${LIQ_ProRate_BuySellPrice_Ok_Button}
    Mx LoanIQ Activate    ${LIQ_PendingAssignmentSell_Window}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PendingAssignmentSellWindow_FacilityTab
    
Validate Displayed Sell Amount and Return Value
    [Documentation]    This keyword validates if displayed 'Sell Amount' matches the Computed 'Sell Amount'
    ...    @author: ghabal
    ...    @update: amansuet    19JUN2020    - updated to align with automation standards, added take screenshot and keyword post-processing
    ...                                      - removed rowid argument
    ...                                      - moved Selection of Int/Fee dropdown to 'Create Assignment' Sell keyword as this keyword will be mainly for validation
    [Arguments]    ${sRunTimeVar_DisplayedSellAmount}=None

    ${Current_DealAmount}    Mx LoanIQ Get Data    ${LIQ_PendingAssignmentSell_CurrentDealAmount}    currentdealamount
    ${Current_DealAmount}    Remove String    ${Current_DealAmount}    ,
    ${Current_DealAmount}    Convert To Number    ${Current_DealAmount}    
    log    ${Current_DealAmount}
    
    ${PctofDeal}    Mx LoanIQ Get Data    ${LIQ_PendingAssignmentSell_PctofDeal_InputField}    percentofdeal
    ${PctofDeal}    Remove String    ${PctofDeal}    %
    ${PctofDeal}    Evaluate    ${PctofDeal}/100
    ${PctofDeal}    Convert To Number    ${PctofDeal}
    log    ${PctofDeal}
    
    ${ComputedSellAmount}    Evaluate    ${Current_DealAmount}*${PctofDeal}    
    log    ${ComputedSellAmount}

    ${Actual_DisplayedSellAmount}    Mx LoanIQ Get Data    ${LIQ_PendingAssignmentSell_SellAmount}    displayedsellamount
    ${iDisplayedSellAmount}    Remove String     ${Actual_DisplayedSellAmount}    ,
    ${iDisplayedSellAmount}    Convert To Number     ${iDisplayedSellAmount}    
    log     ${iDisplayedSellAmount}
    
    ###Validate Displayed and Computed Sell Amount###
    Run Keyword And Continue On Failure    Should Be Equal As Numbers    ${ComputedSellAmount}    ${iDisplayedSellAmount}     
    ${result}    Run Keyword And Return Status    Run Keyword And Continue On Failure    Should Be Equal As Numbers    ${ComputedSellAmount}    ${iDisplayedSellAmount}
    Run Keyword If   '${result}'=='True'    Log    Displayed 'Sell Amount' matches the Computed 'Sell Amount'
    ...     ELSE    Log    Displayed 'Sell Amount' does not matched the Computed 'Sell Amount'
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/AssignmentSellWindow_FacilitiesTab

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_DisplayedSellAmount}    ${Actual_DisplayedSellAmount}

    [Return]    ${Actual_DisplayedSellAmount}

Access Facilities Section
    [Documentation]    This keyword access Facilities section under Facilities tab
    ...    @author: ghabal
    [Arguments]    ${Facility_Name}    ${BuyandSellPrice_Percentage}    ${FacilityAmount}    
    Mx LoanIQ DoubleClick    ${LIQ_PendingAssignmentSell_FacilityList}    ${Facility_Name}    
    Sleep    4s
    mx LoanIQ enter    ${LIQ_PendingAssignmentSell_Facility_Amount}    ${FacilityAmount}
    Sleep    4s       
    mx LoanIQ enter    ${LIQ_PendingAssignmentSell_Facility_Pricing_BuyandSellPrice_Percentage}    ${BuyandSellPrice_Percentage}
    Sleep    4s    
    Mx Native Type    {TAB}
       
Validate Displayed Percent of Global value
    [Documentation]    This keyword validates if displayed 'Percent of Global' in the Facility screen matches the displayed 'Percent of Deal' in the Main Circle Notebook Facilities tab
    ...    @author: ghabal
    [Arguments]    ${PctofDeal}
    
    ${PctofGlobal}    Mx LoanIQ Get Data    ${LIQ_PendingAssignmentSell_Facility_PercentofGlobal_Percentage}    percentofglobal
    log    ${PctofGlobal}
    ${PctofGlobal}    Remove String    ${PctofGlobal}    %            
    log    ${PctofGlobal}
    ${PctofGlobal}    Evaluate    ${PctofGlobal}/100    
    log    ${PctofGlobal}
    ${PctofGlobal}    Convert To Number    ${PctofGlobal}    
    log    ${PctofGlobal}
    
    Run Keyword And Continue On Failure    Should Be Equal As Numbers    ${PctofDeal}    ${PctofGlobal}     
    ${result}    Run Keyword And Return Status    Run Keyword And Continue On Failure    Should Be Equal As Numbers    ${PctofDeal}    ${PctofGlobal}
    Run Keyword If   '${result}'=='True'    Log    Displayed 'Percent of Global' in the Facility screen matches the displayed 'Percent of Deal' in the Main Circle Notebook Facilities tab
    ...     ELSE    Log    Displayed 'Percent of Global' in the Facility screen does not matched the displayed 'Percent of Deal' in the Main Circle Notebook Facilities tab

Validate Displayed Amount in the Facility Screen
    [Documentation]    This keyword validates if displayed 'Amount' in the Facility screen matches the displayed 'Sell Amount' in the Main Circle Notebook Facilities tab
    ...    @author: ghabal
    [Arguments]    ${DisplayedSellAmount}
    
    ${DisplayedAmount}    Mx LoanIQ Get Data    ${LIQ_PendingAssignmentSell_Facility_Amount}    displayedamount
    log    ${DisplayedAmount} 
    ${DisplayedAmount}    Remove String     ${DisplayedAmount}    ,            
    log     ${DisplayedAmount}
    ${DisplayedAmount}    Convert To Number     ${DisplayedAmount}    
    log     ${DisplayedAmount}
    
    Run Keyword And Continue On Failure    Should Be Equal As Numbers    ${DisplayedAmount}    ${DisplayedSellAmount}     
    ${result}    Run Keyword And Return Status    Run Keyword And Continue On Failure    Should Be Equal As Numbers    ${DisplayedAmount}    ${DisplayedSellAmount}
    Run Keyword If   '${result}'=='True'    Log    Displayed 'Amount' in the Facility screen matches the displayed 'Sell Amount' in the Main Circle Notebook Facilities tab
    ...     ELSE    Log    Displayed 'Amount' in the Facility screen does not matched the displayed 'Sell Amount' in the Main Circle Notebook Facilities tab     
    
    mx LoanIQ click    ${LIQ_PendingAssignmentSell_OKButton}
        
Validate Displayed 'Sell Amount' in the Amts/Dates tab
    [Documentation]    This keyword validates if displayed 'Sell Amount' in the Facilities tab matches the displayed 'Current Amount' in the Amts/Dates tab
    ...    @author: ghabal
    ...    @update: amansuet    19JUN2020    - updated to align with automation standards, added take screenshot and added keyword pre-processing
    [Arguments]    ${sDisplayedSellAmount}    ${sAssignmentSell_CircledDate}
    
    ### Keyword Pre-processing ###
    ${DisplayedSellAmount}    Acquire Argument Value    ${sDisplayedSellAmount}
    ${AssignmentSell_CircledDate}    Acquire Argument Value    ${sAssignmentSell_CircledDate}

    Mx LoanIQ Select Window Tab    ${LIQ_PendingAssignmentSell_Tab}    Amts/Dates
        
    ${AmtsDates_CurrentAmount}    Mx LoanIQ Get Data    ${LIQ_PendingAssignmentSell_AmtsDates_CurrentAmount}    currentamount
    ${AmtsDates_CurrentAmount}    Remove String     ${AmtsDates_CurrentAmount}    ,      
    ${AmtsDates_CurrentAmount}    Convert To Number    ${AmtsDates_CurrentAmount}
    log     ${AmtsDates_CurrentAmount}

    ${DisplayedSellAmount}    Remove String    ${DisplayedSellAmount}    ,
    ${DisplayedSellAmount}    Convert To Number    ${DisplayedSellAmount}

    Run Keyword And Continue On Failure    Should Be Equal As Numbers    ${AmtsDates_CurrentAmount}    ${DisplayedSellAmount}     
    ${result}    Run Keyword And Return Status    Run Keyword And Continue On Failure    Should Be Equal As Numbers    ${AmtsDates_CurrentAmount}    ${DisplayedSellAmount}
    Run Keyword If   '${result}'=='True'    Log    Displayed 'Sell Amount' in the Facilities tab matches the displayed 'Current Amount' in the Amts/Dates tab
    ...     ELSE    Log    Displayed 'Sell Amount' in the Facilities tab does not matched the displayed 'Current Amount' in the Amts/Dates tab
    
    Mx LoanIQ Enter    ${LIQ_PendingAssignmentSell_AmtsDates_ExpectedCloseDate}    ${AssignmentSell_CircledDate}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/AssignmentSellWindow_AmtsDatesTab

Add Contact in Pending Assignment Sell
    [Documentation]    This keyword adds a Contact in Pending Assignment Sell
    ...    @author: ghabal
    ...    @update: amansuet    19JUN2020    - updated to align with automation standards, added take screenshot and added keyword pre-processing
    ...                                      - updated flow to handle selection of lender
    ...                                      - replaced hardcoded locator
    ...    @update: clanding    14AUG2020    - updated hard coded values to global variables; updated loaniq keywords; added multiple retry for clicking Add Contacts button
    [Arguments]    ${sContactName}    ${sBuyer_Lender}

    ### Keyword Pre-processing ###
    ${ContactName}    Acquire Argument Value    ${sContactName}
    ${Buyer_Lender}    Acquire Argument Value    ${sBuyer_Lender}

    Mx LoanIQ Select Window Tab    ${LIQ_PendingAssignmentSell_Tab}    ${CONTACTS_TAB}
    :FOR    ${Index}    IN RANGE    10
    \    mx LoanIQ click    ${LIQ_PendingAssignmentSell_ContactTab_AddContacts_Button}
    \    ${IsDisplayed}    Run Keyword And Return Status    mx LoanIQ activate    ${LIQ_AssignmentSell_ContactSelection}
    \    Exit For Loop If    ${IsDisplayed}==${True}
    Mx LoanIQ Select List    ${LIQ_AssignmentSell_ContactSelection_LenderList}    ${Buyer_Lender}
    mx LoanIQ click    ${LIQ_ContactSelection_Contacts_Button}
    Mx LoanIQ Select String    ${LIQ_CircleContacts_Available_JavaTree}    ${ContactName}      
    mx LoanIQ click    ${LIQ_CircleContacts_OK_Button}
    mx LoanIQ click    ${LIQ_ContactSelection_Exit_Button}

    ${ContactName}    Replace Variables    ${ContactName}
    ${LIQ_PendingAssignmentSell_ContactTab_ContactName_JavaTree}    Replace Variables    ${LIQ_PendingAssignmentSell_ContactTab_ContactName_JavaTree}
    Run Keyword And Continue On Failure     Mx LoanIQ Verify Object Exist    ${LIQ_PendingAssignmentSell_ContactTab_ContactName_JavaTree}      VerificationData="Yes"
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/AssignmentSellWindow_ContactsTab

Add Servicing Group in Pending Assignment Sell
    [Documentation]    This keyword will add a servicing group in pending assignment sell
    ...    @author: amansuet    25JUN2020    - initial create
    ...    @author: clanding    17AUG2020    - updated loaniq keywords
    [Arguments]    ${sBuyer_Lender}    ${sBuyer_SGAlias}

    ### Keyword Pre-processing ###
    ${Buyer_Lender}    Acquire Argument Value    ${sBuyer_Lender}
    ${Buyer_SGAlias}    Acquire Argument Value    ${sBuyer_SGAlias}

    Mx LoanIQ Activate Window    ${LIQ_PendingAssignmentSell_Window}
    mx LoanIQ click    ${LIQ_AssignmentSell_ServicingGroups_Button}
    Mx LoanIQ Activate Window    ${LIQ_AssignmentSell_ServicingGroupsSelection_Window}
    Mx LoanIQ Select Combo Box Value    ${LIQ_AssignmentSell_ServicingGroupsSelection_LenderList}    ${Buyer_Lender}
    mx LoanIQ click    ${LIQ_AssignmentSell_ServicingGroupsSelection_SG_Button} 
    Mx LoanIQ Activate Window    ${LIQ_AssignmentSell_ServicingGroupsSelectionFor_Window}
    Mx LoanIQ Select String    ${LIQ_ServicingGroups_JavaTree}   ${Buyer_SGAlias}
    mx LoanIQ click    ${LIQ_AssignmentSell_ServicingGroupsSelectionFor_Ok_Button}
    Mx LoanIQ Activate Window    ${LIQ_Warning_Window}
    mx LoanIQ click    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}  
    Mx LoanIQ Close Window     ${LIQ_AssignmentSell_ServicingGroupsSelection_Window}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/AssignmentSellWindow_ContactsTab          

Delete Contact in Primary
    [Documentation]    This keyword deletes a Contact in Orig Primaries.
    ...    @author: fmamaril
    ...    @update: clanding    16JUL2020    - added keyword pre-processing; refactor argument; added Take Screenshot
    [Arguments]    ${sContactName}
    
    ### GetRuntime Keyword Pre-processing ###
    ${ContactName}    Acquire Argument Value    ${sContactName}
    
    Mx LoanIQ Select Window Tab    ${LIQ_OrigPrimaries_Tab}    Contacts
    mx LoanIQ click    ${LIQ_Contact_DeleteContact_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Runtime Property    ${LIQ_Question_MessageBox}    value%Do you really want to delete ${ContactName}?
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/AssignmentSellWindow_DeleteContact
    
Select Servicing Group on Primaries
    [Documentation]    This keyword deletes a Contact in Orig Primaries.
    ...    @author: fmamaril
    ...    @update: added optional argument to select servicing group member
    ...    @update: bernchua : Added argument 'PrimaryLender_ServGroupAlias' with default value ${EMPTY}
    ...    @update: clanding    16JUL2020    - added keyword pre-processing; refactor argument; added Take Screenshot
    ...    @update: clanding    30JUL2020    - added screenshot
    [Arguments]    ${sServicingGroupMember}=None    ${sPrimaryLender_ServGroupAlias}=${EMPTY}
    
    ### GetRuntime Keyword Pre-processing ###
    ${ServicingGroupMember}    Acquire Argument Value    ${sServicingGroupMember}
    ${PrimaryLender_ServGroupAlias}    Acquire Argument Value    ${sPrimaryLender_ServGroupAlias}
    
    Mx LoanIQ Select Window Tab    ${LIQ_OrigPrimaries_Tab}    Contacts
    mx LoanIQ click    ${LIQ_Contact_ServicingGroups_Button}
    mx LoanIQ click    ${LIQ_ServicingGroupSelection_ServicingGroups_Button}
    Run Keyword If    '${PrimaryLender_ServGroupAlias}'!='${EMPTY}'    Mx LoanIQ Select String    ${LIQ_ServicingGroups_JavaTree}    ${PrimaryLender_ServGroupAlias}
    Run Keyword If    '${ServicingGroupMember}'!='None'    Mx LoanIQ Select String    ${LIQ_ServicingGroups_GroupMembers_JavaTree}    ${ServicingGroupMember}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PrimariesWindow_Contacts
    mx LoanIQ click    ${LIQ_ServicingGroupFor_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PrimariesWindow_Warning
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PrimariesWindow
    mx LoanIQ click    ${LIQ_ServicingGroupSelection_Exit_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PrimariesWindow

Open Primary Servicing Groups
    [Documentation]    This keyword opens the Servicing Groups from the Circle Notebook.
    ...    @author: bernchua
    ...    @update: ehugo    30JUN2020    - added screenshot

    Mx LoanIQ Select Window Tab    ${LIQ_OrigPrimaries_Tab}    Contacts
    mx LoanIQ click    ${LIQ_Contact_ServicingGroups_Button}
    mx LoanIQ click    ${LIQ_ServicingGroupSelection_ServicingGroups_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PrimariesWindow_PrimaryServicingGroups
    
Validate Primary SG Remittance Instructions
    [Documentation]    This keyword validates the details in the Primary's Servicing Group window.
    ...    @author: bernchua
    ...    @update: ehugo    30JUN2020    - added keyword pre-processing; added screenshot
    [Arguments]    ${sPrimary_RIMethod}

    ### GetRuntime Keyword Pre-processing ###
    ${Primary_RIMethod}    Acquire Argument Value    ${sPrimary_RIMethod}

    mx LoanIQ activate    ${LIQ_ServicingGroup_Window}
    ${STATUS}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_ServicingGroups_RemittanceInctructions_JavaTree}    ${Primary_RIMethod}            
    Run Keyword If    ${STATUS}==False    Select Primary SG Remittance Instructions    ${Primary_RIMethod}
    ...    ELSE    Log    Primary Servicing Group Remittance Instructions verified.

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ServicingGroupWindow_ValidatePrimarySGRI

Select Primary SG Remittance Instructions
    [Documentation]    This keyword selects a Remittance Instruction Method for the Primary.
    ...    @author: bernchua
    [Arguments]    ${RI_Method}
    mx LoanIQ click    ${LIQ_ServicingGroup_RemittanceInstructions_Button}
    mx LoanIQ activate    ${LIQ_RISelectionList_Window}
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_PreferredRemittanceInstructions_Javatree}   ${RI_Method}%s
    Mx Native Type    {SPACE}
    mx LoanIQ click    ${LIQ_RISelectionList_OK_Button}

Complete Primary Servicing Group Setup
    [Documentation]    This keyword closes the Primary Servicing Group Details.
    ...    @author: bernchua
    ...    @update: ehugo    30JUN2020    - added screenshot

    mx LoanIQ activate    ${LIQ_ServicingGroup_Window}    
    mx LoanIQ click    ${LIQ_ServicingGroup_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    mx LoanIQ click    ${LIQ_ServicingGroupSelection_Exit_Button}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ServicingGroupWindow_CompletePrimarySGSetup

Circle Notebook Save And Exit
    [Documentation]    This keyword saves and exit the circle notebook.
    ...    @author: bernchua
    ...    @update: ehugo    30JUN2020    - added screenshot

    mx LoanIQ activate    ${LIQ_OrigPrimaries_Window}    
    mx LoanIQ select    ${LIQ_CircleNotebook_File_Save}
    mx LoanIQ click element if present    ${LIQ_Warning_OK_Button}    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CircleNotebook_Save
    mx LoanIQ select    ${LIQ_CircleNotebook_File_Exit}        
        
Validate Delete Error on Servicing Group
    [Documentation]    This keyword verifies if error message is displayed when Servicing Group is deleted.
    ...    @author: fmamaril
    ...    @update: clanding    16JUL2020    - added keyword pre-processing; refactor argument; added screenshot
    [Tags]    Validation
    [Arguments]    ${sFundReceiverDetailCustomer}
    
    ### GetRuntime Keyword Pre-processing ###
    ${FundReceiverDetailCustomer}    Acquire Argument Value    ${sFundReceiverDetailCustomer}

    Mx LoanIQ Select Window Tab    ${LIQ_OrigPrimaries_Tab}    Contacts
    Mx Press Combination    KEY.TAB
    Mx Press Combination    KEY.TAB
    Mx Press Combination    KEY.TAB 
    Mx Press Combination    KEY.TAB      
    mx LoanIQ click    ${LIQ_Contact_DeleteServicingGroup_Button}    
    Mx LoanIQ Verify Runtime Property    ${LIQ_Error_MessageBox}    value%Ongoing servicing group for ${FundReceiverDetailCustomer} is required and may not be deleted. Change the servicing group via the Servicing Groups button.
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Primaries_Contacts
    mx LoanIQ click    ${LIQ_Error_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Primaries_Contacts
    
Circling for Primary Workflow
    [Documentation]    This keyword completes the Circling Workflow Item.
    ...    @author: fmamaril
    ...    @update: fmamaril    28AUG2019    Add Mx Activate window for primaries
    ...    @update: dahijara    01JUL2020    Add keyword pre-processing and take screenshot
    [Arguments]    ${sPrimary_CircledDate}

    ### GetRuntime Keyword Pre-processing ###
    ${Primary_CircledDate}    Acquire Argument Value    ${sPrimary_CircledDate}

    mx LoanIQ activate window    ${LIQ_OrigPrimaries_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_OrigPrimaries_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PrimaryCircle_Workflow_JavaTree}    Circling%d
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}      
    mx LoanIQ enter    ${LIQ_PrimaryCircles_TradeDate_TextField}    ${Primary_CircledDate}   
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CircleNotebook_PrimaryWorkflow 
    mx LoanIQ click    ${LIQ_PrimaryCircles_TradeDate_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
Circling for Pending Assignment Sell
    [Documentation]    This keyword completes the Circling Workflow Item.
    ...    @author: ghabal
    ...    @update: amansuet    19JUN2020    - updated to align with automation standards, added take screenshot and added keyword pre-processing
    ...    @update: clanding    14AUG2020    - updated hard coded values to global variables; updated loaniq keywords
    [Arguments]    ${sAssignmentSell_CircledDate}

    ### Keyword Pre-processing ###
    ${AssignmentSell_CircledDate}    Acquire Argument Value    ${sAssignmentSell_CircledDate}

    Mx LoanIQ Select Window Tab    ${LIQ_PendingAssignmentSell_Tab}    ${WORKFLOW_TAB}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${AssignmentSell_Workflow_JavaTree}    ${CIRCLING_WORKFLOW}%d  
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Enter    ${LIQ_PrimaryCircles_TradeDate_TextField}    ${AssignmentSell_CircledDate}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/SelectCircledLegalTradeDateWindow
    mx LoanIQ click    ${LIQ_PrimaryCircles_TradeDate_OK_Button}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PendingAssignmentSell
    
Complete Portfolio Allocations Worflow - Bel
    [Documentation]    This keyword completes the Portfolio Allocation Workflow Item.
    ...    @author: fmamaril
    ...    @author: mgaling, added value evaluation for Portfolio Allocation
    [Arguments]    ${Primary_Portfolio}    ${Primary_PortfolioBranch}    ${Deal_Amount}    ${PercentOfDeal}   
    Mx LoanIQ Select Window Tab    ${LIQ_OrigPrimaries_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PrimaryCircle_Workflow_JavaTree}    Complete Portfolio Allocations%d
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}        
    mx LoanIQ click    ${LIQ_PortfolioAllocations_AddPortfolio_Button}
    Mx LoanIQ Select String    ${LIQ_Portfolio_JavaTree}    ${Primary_Portfolio}
    Mx LoanIQ Select Combo Box Value    ${LIQ_Portfolio_BranchDropdown}    ${Primary_PortfolioBranch}
    ${PortfolioAllocation}    Evaluate    ${Deal_Amount}*(${PercentOfDeal}/100) 
    ${PortfolioAllocation}    Convert To Number    ${PortfolioAllocation}       
    mx LoanIQ enter    ${LIQ_PortfolioAllocation_Allocation_TextField}    ${PortfolioAllocation}
    # Mx Enter    ${LIQ_PortfolioAllocation_ExpirationDate_TextField}    ${Expiry_Date}
    mx LoanIQ click    ${LIQ_PortfolioAllocation_OK_Button}
    mx LoanIQ click    ${LIQ_Portfolio_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}

Click Portfolio Allocations from Circle Notebook
    [Documentation]    This keyword clicks the "Portfolio Allocations" button from the Circle Notebook's Summary Tab.
    ...    @author: bernchua
    ...    @update: ehugo    30JUN2020    - added screenshot

    mx LoanIQ activate    ${LIQ_OrigPrimaries_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_OrigPrimaries_Tab}    Summary        
    mx LoanIQ click    ${LIQ_Circle_PortfolioAllocations_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PrimariesWindow_SummaryTab_PortfolioAllocation
    
Circle Notebook Portfolio Allocation Per Facility
    [Documentation]    This keyword will select the Portfolio Allocation for the Facility
    ...                @author: bernchua
    ...                @update: bernchua    21AUG2019    Added arguments for selecting the specific Portfolio Allocation of Facility
    ...                                                  Renamed SellAmount variable name to Allocation
    ...    @update: ehugo    30JUN2020    - added keyword pre-processing; added screenshot
    [Arguments]    ${sFacility_Name}    ${sPortfolio}    ${sBranch}    ${sAllocation}    ${sExpirationDate}    ${sExpense_Code}    ${sExpCode_Description}

    ### GetRuntime Keyword Pre-processing ###
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
    ${Portfolio}    Acquire Argument Value    ${sPortfolio}
    ${Branch}    Acquire Argument Value    ${sBranch}
    ${Allocation}    Acquire Argument Value    ${sAllocation}
    ${ExpirationDate}    Acquire Argument Value    ${sExpirationDate}
    ${Expense_Code}    Acquire Argument Value    ${sExpense_Code}
    ${ExpCode_Description}    Acquire Argument Value    ${sExpCode_Description}

    mx LoanIQ activate    ${LIQ_PortfolioAllocationsFor_Window}    
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PortfolioAllocations_Facility_JavaTree}    ${Facility_Name}%s
    mx LoanIQ click    ${LIQ_PortfolioAllocations_AddPortfolio_Button}
    Set Portfolio Allocation Details    ${Portfolio}    ${Branch}    ${Allocation}    ${ExpirationDate}    ${Expense_Code}    ${ExpCode_Description}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PortfolioAllocationWindow_SelectPortfolioAllocation
    
Complete Circle Notebook Portfolio Allocation
    [Documentation]    This keyword completed the Portfolio Allocation per Facility in the Circle Notebook.
    ...    @author: bernchua
    ...    @update: ehugo    30JUN2020    - added screenshot

    mx LoanIQ activate    ${LIQ_PortfolioAllocationsFor_Window}
    mx LoanIQ click    ${LIQ_Portfolio_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PortfolioAllocationWindow_CompletePortfolioAllocation
    
Set Portfolio Allocation Details
    [Documentation]    This keyword sets the details in the Portoflio Allocation window.
    ...                @author: bernchua
    ...                @author: bernchua    21AUG2019    Added arguments for selecting the specific Portfolio Allocation of Facility
    ...                                                  Updated keyword to select the specific Portfolio Allocation
    ...                                                  Renamed SellAmount variable name to Allocation
    [Arguments]    ${Portfolio}    ${Branch}    ${Allocation}    ${ExpirationDate}    ${Expense_Code}    ${ExpCode_Description}
    mx LoanIQ activate    ${LIQ_PortfolioAllocation_Window}
    Mx LoanIQ Select String    ${LIQ_Portfolio_JavaTree}    ${Portfolio}\t${Expense_Code}\t${ExpCode_Description}
    Mx LoanIQ Select Combo Box Value    ${LIQ_Portfolio_BranchDropdown}    ${Branch}
    mx LoanIQ enter    ${LIQ_PortfolioAllocation_Allocation_TextField}    ${Allocation}
    mx LoanIQ enter    ${LIQ_PortfolioAllocation_ExpirationDate_TextField}    ${ExpirationDate}            
    mx LoanIQ click    ${LIQ_PortfolioAllocation_OK_Button}  
    
Complete Portfolio Allocations for Non-Agent And Host Bank Syndicated Deal
    [Documentation]    This keyword completes the Portfolio Allocation Workflow Item.
    ...    @author: fmamaril
    ...    <update>mgaling: added value evaluation for Portfolio Allocation
    ...    @update: clanding    28JUL2020    - added pre-processing keywords; refactor arguments
    [Arguments]    ${sPrimary_Portfolio}    ${sPrimary_PortfolioBranch}    ${sDeal_Amount}    ${sPercentOfDeal}    ${sExpiry_Date}
    
    ### GetRuntime Keyword Pre-processing ###
    ${Primary_Portfolio}    Acquire Argument Value    ${sPrimary_Portfolio}
    ${Primary_PortfolioBranch}    Acquire Argument Value    ${sPrimary_PortfolioBranch}
    ${Deal_Amount}    Acquire Argument Value    ${sDeal_Amount}
    ${PercentOfDeal}    Acquire Argument Value    ${sPercentOfDeal}
    ${Expiry_Date}    Acquire Argument Value    ${sExpiry_Date}

    Mx LoanIQ Select Window Tab    ${LIQ_OrigPrimaries_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PrimaryCircle_Workflow_JavaTree}    Complete Portfolio Allocations%d
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}        
    mx LoanIQ click    ${LIQ_PortfolioAllocations_AddPortfolio_Button}
    Mx LoanIQ Select String    ${LIQ_Portfolio_JavaTree}    ${Primary_Portfolio}
    Mx LoanIQ Select Combo Box Value    ${LIQ_Portfolio_BranchDropdown}    ${Primary_PortfolioBranch}
    
    ${Deal_Amount}    Remove Comma and Convert to Number    ${Deal_Amount}
    ${PercentOfDeal}    Remove Comma and Convert to Number    ${PercentOfDeal}
    
    ${PortfolioAllocation}    Evaluate    (${Deal_Amount})*((${PercentOfDeal})/(100)) 
    ${PortfolioAllocation}    Convert To Number    ${PortfolioAllocation}       
    mx LoanIQ enter    ${LIQ_PortfolioAllocation_Allocation_TextField}    ${PortfolioAllocation}
    mx LoanIQ enter    ${LIQ_PortfolioAllocation_ExpirationDate_TextField}    ${Expiry_Date}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CircleNotebook_OrigPrimaries_WorkflowTab
    mx LoanIQ click    ${LIQ_PortfolioAllocation_OK_Button} 
    mx LoanIQ click    ${LIQ_Portfolio_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CircleNotebook
    
Complete Portfolio Allocations Workflow
    [Documentation]    This keyword completes the Portfolio Allocation Workflow Item.
    ...    @author: fmamaril
    ...    @update: mnanquil
    ...    Made portfolio allocation and facility name an array type to handle
    ...    multiple data.
    ...    @update: rtarayao    27Feb2019    Made Expiry_Date as an array argument to handle different Facilities with different dates.
    ...    @update: fmamaril    05MAR2019    Included Index as criteria on Expiration Date
    ...    @update: rtarayao    13MAR2019    Fixed the Run keyword if condition for Expense code and Primary Portfolio.
    ...    @update: amansuet    24APR2020    Updated to align with automation standards and added keyword pre-processing
    ...    @update: clanding    17JUL2020    Refactor arguments based on standard and add other arguments in pre-processing; added screenshot
    [Arguments]    ${sPrimary_Portfolio}    ${sPrimary_PortfolioBranch}    ${sPortfolioAllocation}    ${sExpiry_Date}=None    ${sFacilityName}=None    ${sExpense_Code}=None

    ### GetRuntime Keyword Pre-processing ###
    ${Primary_Portfolio}    Acquire Argument Value    ${sPrimary_Portfolio}
    ${Primary_PortfolioBranch}    Acquire Argument Value    ${sPrimary_PortfolioBranch}
	${PortfolioAllocation}    Acquire Argument Value    ${sPortfolioAllocation}
	${Expiry_Date}    Acquire Argument Value    ${sExpiry_Date}
	${FacilityName}    Acquire Argument Value    ${sFacilityName}
	${Expense_Code}    Acquire Argument Value    ${sExpense_Code}

    Mx LoanIQ Select Window Tab    ${LIQ_OrigPrimaries_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PrimaryCircle_Workflow_JavaTree}    Complete Portfolio Allocations%d
    @{Facility}    Split String    ${FacilityName}    |
    ${TotalFacility}    Get Length    ${Facility}
    @{PortfolioAllocation}    Split String    ${PortfolioAllocation}    |
    @{Expiry_Date}    Split String    ${Expiry_Date}    |  
    @{Primary_Portfolio}    Split String    ${Primary_Portfolio}    |  
    :FOR    ${INDEX}    IN RANGE    ${TotalFacility} 
    \    Log    Current Counter: ${INDEX}
    \    ${FacilityName}    Strip String    ${SPACE}@{Facility}[${INDEX}]${SPACE}   
    \    Run Keyword If    ${TotalFacility} > 1    Mx LoanIQ Select String    ${LIQ_PortfolioAllocations_Facility_JavaTree}    ${FacilityName}
    \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    mx LoanIQ click    ${LIQ_PortfolioAllocations_AddPortfolio_Button}
    \    Run Keyword If    '${Expense_Code}' != 'None'    Mx LoanIQ Select String    ${LIQ_Portfolio_JavaTree}    @{Primary_Portfolio}[${INDEX}]\t${Expense_Code}
         ...    ELSE    Mx LoanIQ Select String    ${LIQ_Portfolio_JavaTree}    @{Primary_Portfolio}[${INDEX}]    
    \    Mx LoanIQ Select Combo Box Value    ${LIQ_Portfolio_BranchDropdown}    ${Primary_PortfolioBranch}
    \    mx LoanIQ enter    ${LIQ_PortfolioAllocation_Allocation_TextField}    @{PortfolioAllocation}[${INDEX}]
    \    Run Keyword If    '@{Expiry_Date}[${INDEX}]' != 'None'    mx LoanIQ enter    ${LIQ_PortfolioAllocation_ExpirationDate_TextField}    @{Expiry_Date}[${INDEX}]
    \    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PrimariesWindow_PortfolioAllocation
    \    mx LoanIQ click    ${LIQ_PortfolioAllocation_OK_Button}
    \    mx LoanIQ click    ${LIQ_Portfolio_OK_Button}
    \    mx LoanIQ click element if present    ${LIQ_Error_OK_Button}          
    \    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    mx LoanIQ click element if present     ${LIQ_Portfolio_OK_Button}

Complete Portfolio Allocations Worflow for Pending Assignment Sell
    [Documentation]    This keyword completes the Portfolio Allocation Workflow Item.
    ...    @author: fmamaril
    [Arguments]    ${AssignmentSell_AllocatedAmount}    ${rowid}    ${Facility_Name}    ${Facility_Name2}    
    Mx LoanIQ Select Window Tab    ${LIQ_PendingAssignmentSell_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${AssignmentSell_Workflow_JavaTree}    Complete Portfolio Allocations%d       
    
    # ${AssignmentSell_AllocatedAmount}    Read Data From Excel    AMCH02_LenderShareAdjustoment    AssignmentSell_AllocatedAmount    ${rowid}
    
    Mx LoanIQ Select String    JavaWindow("title:=Portfolio allocations for.*","displayed:=1").JavaTree("tagname:=Tree","items count:=2")    ${Facility_Name}
    Mx LoanIQ DoubleClick    ${AssignmentSell_PortfolioAllocations_List}    0.00
    mx LoanIQ enter    ${AssignmentSell_PortfolioAllocations_AllocatedAmount}    ${AssignmentSell_AllocatedAmount}
    mx LoanIQ click    ${AssignmentSell_PortfolioAllocations_OKButton}
     
    Mx LoanIQ Select String    JavaWindow("title:=Portfolio allocations for.*","displayed:=1").JavaTree("tagname:=Tree","items count:=2")    ${Facility_Name2}
    Mx LoanIQ DoubleClick    ${AssignmentSell_PortfolioAllocations_List}    0.00
    mx LoanIQ enter    ${AssignmentSell_PortfolioAllocations_AllocatedAmount}    ${AssignmentSell_AllocatedAmount}
    mx LoanIQ click    ${AssignmentSell_PortfolioAllocations_OKButton}
        
    mx LoanIQ click    ${LIQ_Portfolio_OK_Button}
    # Mx Click Element If Present    ${LIQ_Information_OK_Button}    

Complete Portfolio Allocations Workflow for Pending Assignment Sell for Agency Deal
    [Documentation]    This keyword completes the Portfolio Allocation Workflow Item.
    ...    @author: fmamaril
    ...    @update: ghabal                   - updated locators to confirm with Scenario 4
    ...    @update: amansuet    19JUN2020    - updated to align with automation standards, added take screenshot and added keyword pre-processing
    ...                                      - removed unused keywords and argument
    ...                                      - replaced hardcoded locators
    ...    @update: clanding    14AUG2020    - updated hard coded values to global variables; updated loaniq keywords
    [Arguments]    ${sFacility_Name}    ${sFacility_Name2}

    ### Keyword Pre-processing ###
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
    ${Facility_Name2}    Acquire Argument Value    ${sFacility_Name2}

    Mx LoanIQ Select Window Tab    ${LIQ_PendingAssignmentSell_Tab}    ${WORKFLOW_TAB}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${AssignmentSell_Workflow_JavaTree}    ${COMPLETE_PORTFOLIO_ALLOCATIONS_WORKFLOW}%d       

    mx LoanIQ activate    ${LIQ_PortfolioAllocationsFor_Window}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PorfolioAllocationsWindow
    Mx LoanIQ Select String    ${LIQ_AssignmentSell_PortfolioAllocations_Facilities_List}    ${Facility_Name}
    Mx LoanIQ DoubleClick    ${LIQ_PortfolioAllocations_PortfolioExpense_JavaTree}    0.00
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PorfolioAllocationsWindow
    mx LoanIQ click    ${AssignmentSell_Allocations_OKButton}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PorfolioAllocationsWindow

    Mx LoanIQ Select String    ${LIQ_AssignmentSell_PortfolioAllocations_Facilities_List}    ${Facility_Name2}
    Mx LoanIQ DoubleClick    ${LIQ_PortfolioAllocations_PortfolioExpense_JavaTree}    0.00
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PorfolioAllocationsWindow
    mx LoanIQ click    ${AssignmentSell_Allocations_OKButton}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PorfolioAllocationsWindow
    
    mx LoanIQ click    ${AssignmentSell_PortfolioAllocations_OKButton}
    mx LoanIQ activate    ${LIQ_PendingAssignmentSell_Window}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PendingAssignment

Add Portfolio and Expense Code for Pending Assigment Sell
    [Documentation]    This keyword is used to add Portfolio/Expense Code for Pending Assignment Sell.
    ...    @author: clanding    17AUG2020    - initial create
    [Arguments]    ${sExpense_Code}    ${sBranch}    ${sShort_Amount}

    ### Keyword Pre-processing ###
    ${Expense_Code}    Acquire Argument Value    ${sExpense_Code}
    ${Branch}    Acquire Argument Value    ${sBranch}
    ${Short_Amount}    Acquire Argument Value    ${sShort_Amount}
    
    mx LoanIQ click    ${LIQ_AssignmentSell_PortfolioAllocations_AddPortfolioExpenseCode_Button}
    mx LoanIQ activate    ${LIQ_AssignmentSell_PortfolioAllocations_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_AssignmentSell_PortfolioAllocations_PortfolioExpenseCodes_JavaTree}    ${Expense_Code}%s
    mx LoanIQ select list    ${LIQ_AssignmentSell_PortfolioAllocations_Branch_List}    ${Branch}
    mx LoanIQ enter    ${LIQ_AssignmentSell_PortfolioAllocations_Short_Textbox}    ${Short_Amount}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PendingAssignmentWindow_FacilitiesTree
    mx LoanIQ click    ${LIQ_AssignmentSell_PortfolioAllocations_OK_Button}

Send to Settlement Approval
    [Documentation]    This keyword completes the Send to Settlement Approval Workflow Item.
    ...    @author: fmamaril
    ...    @update: clanding    28JUL2020    - removed commented codes 'Mx Click Element If Present    ${LIQ_SendToSettelement_No_Button}'
    ...                                      - added screenshot
    Mx LoanIQ Select Window Tab    ${LIQ_OrigPrimaries_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PrimaryCircle_Workflow_JavaTree}    Send to Settlement Approval%d 
    mx LoanIQ close window    ${LIQ_PrimaryWorkflow_OpenAwaitingSettlement_Window} 
    mx LoanIQ close window    ${LIQ_PrimariesList_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CircleNotebook_OrigPrimaries_WorkflowTab

Funding Memo for Open Assignment Sell
    [Documentation]    This keyword completes do the Funding Memo action
    ...    @author: ghabal
    Mx LoanIQ Select Window Tab    ${LIQ_OpenAssignmentSell_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_OpenAssignmentSell_Workflow_JavaTree}     Funding Memo%d 
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Open.*")    VerificationData="Yes"
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
    mx LoanIQ click    JavaWindow("title:=Outstandings.*").JavaButton("attached text:=Freeze All")    
    mx LoanIQ click    JavaWindow("title:=Outstandings.*").JavaButton("attached text:=OK")
   
Send to Settlement Approval for Open Assignment Sell
    [Documentation]    This keyword completes the Send to Settlement Approval Workflow Item.
    ...    @author: ghabal
    ...    @update: amansuet    22JUN2020    - updated to align with automation standards and added take screenshot
    ...                                      - replaced hardcoded locator
    ...    @update: clanding    14AUG2020    - replaced hard coded values to global variables; added screenshot

    Mx LoanIQ Select Window Tab    ${LIQ_OpenAssignmentSell_Tab}    ${WORKFLOW_TAB}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/OpenAssignmentSellWindow_WorkflowTab
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_OpenAssignmentSell_Workflow_JavaTree}     ${SEND_TO_SETTLEMENT_APPROVAL_WORKFLOW}%d
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/OpenAssignmentSellWindow_WorkflowTab
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AssignmentSell_SendToSettlementApproval}    VerificationData="Yes"
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/OpenAssignmentSellWindow_WorkflowTab

Settlement Approval for Open/Awaiting Settlement Approval Assignment Sell
    [Documentation]    This keyword completes the Send to Settlement Approval Workflow Item.
    ...    @author: ghabal
    ...    @update: amansuet    22JUN2020    - updated to align with automation standards, added take screenshot and added keyword pre-processing
    ...                                      - replaced hardcoded locator
    ...    @update: clanding    14AUG2020    - replaced hard coded values to global variables
    [Arguments]    ${sDeal_Name}

    ### Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}

    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Transactions_List}    ${CIRCLES_TRANSACTION}
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionDetails_List}    ${AWAITING_SETTLEMENT_APPROVAL_STATUS}
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionDetails_List}    ${HOST_BANK}
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionDetails_List}    ${ASSIGNMENT}
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionDetails_List}    ${Deal_Name}
    Mx LoanIQ Select Window Tab    ${LIQ_OpenAwaitingSettlementApprovalAssignmentSell_Tab}    ${WORKFLOW_TAB}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/OpenAwaitingSettlementApprovalAssignmentSellWindow_WorkflowTab
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_OpenAwatingAssignmentSell_Workflow_JavaTree}     ${SETTLEMENT_APPROVAL_STATUS}%d
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/OpenAwaitingSettlementApprovalAssignmentSellWindow_WorkflowTab
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_OpenSettlementApprovedAssignmentSell_JavaWindow}    VerificationData="Yes"
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/OpenAwaitingSettlementApprovalAssignmentSellWindow_WorkflowTab

Close for Open/Settlement Approved Assignment Sell
    [Documentation]    This keyword completes the Send to Settlement Approval Workflow Item.
    ...    @author: ghabal
    ...    @update: amansuet    22JUN2020    - updated to align with automation standards and added take screenshot
    ...                                      - replaced hardcoded locator
    ...    @update: clanding    14AUG2020    - updated hard coded values to global variables

    Mx LoanIQ Select Window Tab    ${LIQ_OpenSettlementApprovedAssignmentSell_Tab}    ${WORKFLOW_TAB}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/OpenSettlementApprovalAssignmentSellWindow_WorkflowTab
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_OpenSettlementApprovedAssignmentSell_Workflow_JavaTree}    ${CLOSE_WORKFLOW}%d
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/OpenSettlementApprovalAssignmentSellWindow_WorkflowTab
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click    ${LIQ_ClosedApprovedAssignmentSell_OKButton}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_ClosedApprovedAssignmentSell_Window}    VerificationData="Yes"
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/OpenSettlementApprovalAssignmentSellWindow_WorkflowTab
    
    mx LoanIQ click element if present    ${LIQ_NotificationInformation_OK_Button}
    Mx LoanIQ Close Window    ${LIQ_ClosedApprovedAssignmentSell_Window}
    
Send to Approval for Pending Assignment Sell
    [Documentation]    This keyword completes the Send to Approval Workflow Item
    ...    @author: ghabal
    ...    @update: amansuet    19JUN2020    - updated to align with automation standards and added take screenshot
    ...    @update: clanding    14AUG2020    - updated hard coded values to global variables; updated loaniq keywords

    Mx LoanIQ Select Window Tab    ${LIQ_PendingAssignmentSell_Tab}    ${WORKFLOW_TAB}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/AssignmentSellWindow_WorkflowTab
    Mx LoanIQ Select Or DoubleClick In Javatree    ${AssignmentSell_Workflow_JavaTree}    ${SEND_TO_APPROVAL_STATUS}%d
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Awaiting Approval.*")    VerificationData="Yes"
    mx LoanIQ click element if present    ${LIQ_NotificationInformation_OK_Button}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/AssignmentSellWindow_WorkflowTab
    Close All Windows on LIQ
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    
Approval for Pending Assignment Sell
    [Documentation]    This keyword completes the Send to Approval Workflow Item
    ...    @author: ghabal
    ...    @update: amansuet    19JUN2020    - updated to align with automation standards, added take screenshot and added keyword pre-processing
    ...                                      - replaced hardcoded locators
    ...                                      - added 'Mx LoanIQ Click Element If Present' for Question
    ...    @update: clanding    14AUG2020    - updated hard coded values to global variables; updated loaniq keywords
    [Arguments]    ${sDeal_Name}

    ### Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}

    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Transactions_List}    ${CIRCLES_TRANSACTION}
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionDetails_List}    ${AWAITING_APPROVAL_STATUS}
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionDetails_List}    ${HOST_BANK}
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionDetails_List}    ${ASSIGNMENT}
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionDetails_List}    ${Deal_Name}
    Mx LoanIQ Select Window Tab    ${LIQ_AwaitingApprovalAssignmentSell_Tab}    ${WORKFLOW_TAB}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/AssignmentSellWindow_WorkflowTab
    Mx LoanIQ Select Or DoubleClick In Javatree    ${AwatingApprovalAssignmentSell_Workflow_JavaTree}    ${APPROVAL_STATUS}%d
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click    ${LIQ_AwaitingApprovalAssignmentSell_OKButton}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_OpenAssignmentSell_JavaWindow}    VerificationData="Yes"
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/AssignmentSellWindow_WorkflowTab  
    mx LoanIQ click element if present    ${LIQ_NotificationInformation_OK_Button}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/AssignmentSellWindow_WorkflowTab
         
Verify Buy/Sell Price in Circle Notebook
    [Documentation]    This validates the Buy/Sell Price of the Circle Notebook.
    ...    @author: bernchua
    ...    @update: ehugo    30JUN2020    - added screenshot

    mx LoanIQ activate    ${LIQ_OrigPrimaries_Window}    
    mx LoanIQ select    ${LIQ_CircleNotebook_Options_Verify}
    ${InfoMessage_Displayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Information_MessageBox}    VerificationData="Yes"
    ${VerifyMessage}    Run Keyword If    ${InfoMessage_Displayed}==True    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_Information_MessageBox}    text%Discount is valid.        
    Run Keyword If    ${VerifyMessage}==True	Run Keywords
    ...    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    ...    AND    Log    Discount is valid.

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PrimariesWindow_VerifyBuySellPrice
    
Add Non-Host Bank Lenders for a Syndicated Deal
    [Documentation]    This adds secondary lenders to a Deal. This keyword is initiated in the "Primaries List" window.
    ...    @author: bernchua
    ...    @update: fmamaril    10MAY2020    - added argument for keyword pre processing
    [Arguments]    ${sDeal_Name}    ${Lender_Name}    ${Lender_Location}    ${Lender_TransactionType}
	### GetRuntime Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}

    mx LoanIQ activate window    ${LIQ_PrimariesList_Window}
    mx LoanIQ click    ${LIQ_PrimariesList_AddButton}
    Validate if Element is Checked    ${LIQ_CreatePrimary_Sell_Checkbox}    Sell
    Validate if Element is Unchecked    ${LIQ_CreatePrimary_TicketModeOnly_Checkbox}    Ticket Mode Only
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Create Primary").JavaEdit("attached text:=Amendment Number:","text:=${Deal_Name}")    VerificationData="Yes"
    mx LoanIQ click    ${LIQ_CreatePrimary_Lender_Button}      
    mx LoanIQ enter    ${LIQ_LenderSelect_Textfield}    ${Lender_Name}
    mx LoanIQ click    ${LIQ_LenderSelect_Search_Button}
    mx LoanIQ click    ${LIQ_LenderList_OK_Button}
    mx LoanIQ activate window    ${LIQ_CreatePrimary_Window}
    Validate Loan IQ Details    ${Lender_Location}    ${LIQ_CreatePrimary_Location_ComboBox}
    Validate Loan IQ Details    ${LenderLocation}    ${LIQ_CreatePrimary_Location_ComboBox}        
    Mx LoanIQ Select Combo Box Value    ${LIQ_CreatePrimary_Location_ComboBox}    ${Lender_Location}
    Validate Loan IQ Details    ${Lender_TransactionType}    ${LIQ_CreatePrimary_TransactionType_SelectBox}  
    Mx LoanIQ Select Combo Box Value    ${LIQ_CreatePrimary_TransactionType_SelectBox}    ${Lender_TransactionType}
    mx LoanIQ click    ${LIQ_CreatePrimary_OK_Button}
    mx LoanIQ activate window    ${LIQ_OrigPrimaries_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_OrigPrimaries_Window}    VerificationData="Yes"
    
Get Circle Notebook Sell Amount
    [Documentation]    This keyword gets the Sell Amount from the Circle Notebook UI.
    ...    @author: bernchua
    mx LoanIQ activate    ${LIQ_OrigPrimaries_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_OrigPrimaries_Tab}    Facilities
    ${SellAmount}    Mx LoanIQ Get Data    ${LIQ_OrigPrimaries_SellAmount_Textfield}    value%amount
    [Return]	${SellAmount}
    
Circle Notebook Workflow Navigation
    [Documentation]    This navigates the Workflow tab of the Lender's Circle Notebook, to Complete Portfolio Allocations, Circling and Send to Settlement Approval.
    ...    This is initiated in the "Primaries List" window for selecting a Lender.
    ...    This keyword returns the "Sell Amount" of the Lender to be used in later transactions.
    ...    
    ...    | Arguments |
    ...    'IsLenderAHostBank' = Accepts 'Yes' for conditional statement. If Yes, this keyword will execute "Complete Portfolio Allocations Worflow" keyword,
    ...                          and will require the Arguments needed for the said keyword.
    ...    
    ...    @author: bernchua
    ...    @update: ritragel    13MAR2019    Added ExpenseCode in Argument to conform with the update in Complete Portfolio Allocations Workflow
    ...    @update: fmamaril    10MAY2020    - added argument for keyword pre processing
    [Arguments]    ${Lender_Name}    ${CircledDate}    ${IsLenderAHostBank}=null    ${Primary_Portfolio}=null    ${Primary_PortfolioBranch}=null
    ...    ${Primary_PortfolioAllocation}=null    ${Primary_PortfolioExpDate}=null    ${ExpenseCode}=null    ${sRuntime_Variable}=None
    
    mx LoanIQ activate    ${LIQ_PrimariesList_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PrimariesList_JavaTree}    ${Lender_Name}%d
    Validate Circle Notebook Lender Name and Sell Amount    ${Lender_Name}
    ${ShareAmount}    Mx LoanIQ Get Data    ${LIQ_OrigPrimaries_SellAmount_Textfield}    value%amount
    Run Keyword If    '${IsLenderAHostBank}'=='Yes'
    ...    Complete Portfolio Allocations Workflow    ${Primary_Portfolio}    ${Primary_PortfolioBranch}    ${Primary_PortfolioAllocation}    ${Primary_PortfolioExpDate}    None    ${ExpenseCode}
    Circling for Primary Workflow    ${CircledDate}
    Navigate Notebook Workflow    ${LIQ_OrigPrimaries_Window}    ${LIQ_OrigPrimaries_Tab}    ${LIQ_PrimaryCircle_Workflow_JavaTree}    Send to Settlement Approval
    Validate Window Title Status    Orig Primary    Awaiting Settlement Approval
    Save Values of Runtime Execution on Excel File    ${sRuntime_Variable}    ${ShareAmount}
    [Return]    ${ShareAmount}
    
Circle Notebook Settlement Approval
    [Documentation]    This keyword Navigates the WIP for Circles transaction for Settlement Approval.
    ...    @author: bernchua
    [Arguments]    ${sDeal_Name}    ${sLender_Type}

    ### GetRuntime Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    ${Lender_Type}    Acquire Argument Value    ${sLender_Type}

    Navigate Transaction in WIP for Circles    Awaiting Settlement Approval    ${Lender_Type}    ${Deal_Name}
    Navigate Notebook Workflow    ${LIQ_OrigPrimaries_Window}    ${LIQ_OrigPrimaries_Tab}    ${LIQ_PrimaryCircle_Workflow_JavaTree}    Settlement Approval
    ${OrigPrimary_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_PrimaryCircle_OrigPrimary_Window}    VerificationData="Yes"
    ${OrigPrimary_Status}    Set Variable If    ${OrigPrimary_Status}==True    Settlement Approved
    Run Keyword If    '${OrigPrimary_Status}'=='Settlement Approved'    Log    Lender Status is ${OrigPrimary_Status}.
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PrimariesWindow_Approval
    mx LoanIQ close window    ${LIQ_OrigPrimaries_Window}
    
Validate Circle Notebook Lender Name and Sell Amount
    [Documentation]    This keyword validates the Bank Names and Sell Amounts of the added Lenders in the Circle Notebook.
    ...    This initially starts in the Primaries List window.
    ...    @author: bernchua
    [Arguments]    ${LenderName}
    Mx LoanIQ Select Window Tab    ${LIQ_OrigPrimaries_Tab}    Summary
    Verify If Text Value Exist in Textfield on Page    Orig Primary    ${LenderName}
    Mx LoanIQ Select Window Tab    ${LIQ_OrigPrimaries_Tab}    Facilities
    ${DealAmount}    Mx LoanIQ Get Data    ${LIQ_OrigPrimaries_CurrentDealAmount_Textfield}    value%test
    ${DealAmount}    Fetch From Left    ${DealAmount}    .
    ${DealAmount}    Remove String    ${DealAmount}    ,
    ${DealAmount}    Convert To Number    ${DealAmount}        
    ${PctOfDeal}    Mx LoanIQ Get Data    ${LIQ_OrigPrimaries_PctOfDeal_Textfield}    value%test
    ${PctOfDeal}    Fetch From Left    ${PctOfDeal}    .
    ${PctOfDeal}    Convert To Number    ${PctOfDeal}
    ${PctOfDeal}    Evaluate    ${PctOfDeal}/100
    ${SellAmount_UI}    Mx LoanIQ Get Data    ${LIQ_OrigPrimaries_SellAmount_Textfield}    value%test
    ${SellAmount_UI}    Fetch From Left    ${SellAmount_UI}    .
    ${SellAmount_UI}   Remove String    ${SellAmount_UI}    ,
    ${SellAmount_UI}    Convert To Number    ${SellAmount_UI}            
    ${SellAmount_Computed}    Compute Circle Notebook Sell Amount    ${DealAmount}    ${PctOfDeal}
    Run Keyword If    '${SellAmount_UI}'=='${SellAmount_Computed}'    Log    Sell Amount is validated.
    
Compute Circle Notebook Sell Amount
    [Documentation]    This keyword will compute for the Sell Amount based from the Pct of Deal and the Deal's Amount.
    ...    @author: bernchua
    [Arguments]    ${DealAmount}    ${PctOfDeal}
    ${SellAmount}    Evaluate    ${DealAmount}*${PctOfDeal} 
    [Return]    ${SellAmount}

Circles Settlement Approval
    [Documentation]    This keyword is for approval of Amendment Notebook.
    ...    @author: mgaling
    ...    @update: hstone    21MAY2020    - Replaced '%s' with '%d' at 'Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_TransactionsInProcess_Circles_List}'
    ...    @update: clanding    28JUL2020    - added pre-processing keywords; added screenshot
    [Arguments]    ${sWIPTransaction_Type}    ${sTransaction_Status_AwaitingApproval}    ${sLender_Host}    ${sLender_Type}    ${sDeal_Name}
    
    ### GetRuntime Keyword Pre-processing ###
    ${WIPTransaction_Type}    Acquire Argument Value    ${sWIPTransaction_Type}
    ${Transaction_Status_AwaitingApproval}    Acquire Argument Value    ${sTransaction_Status_AwaitingApproval}
	${Lender_Host}    Acquire Argument Value    ${sLender_Host}
	${Lender_Type}    Acquire Argument Value    ${sLender_Type}
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    
    ###Open Amendment Notebook thru WIP - Awaiting Approval###     
    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    mx LoanIQ activate window    ${LIQ_WorkInProgress_Window}   
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}     VerificationData="Yes"
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionList}    ${WIPTransaction_Type}
    
    
    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Circles_List}    ${Transaction_Status_AwaitingApproval}    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Circles_List}    ${Transaction_Status_AwaitingApproval}         
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Circles_List}    ${Transaction_Status_AwaitingApproval}   
    Run Keyword If    ${status}==False    Log    'Awaiting Approval is not available     

    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Circles_List}    ${Lender_Host}    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Circles_List}    ${Lender_Host}
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Circles_List}    ${Lender_Host}  
    Run Keyword If    ${status}==False    Log    Lender Host is not availables    
    
    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Circles_List}    ${Lender_Type}    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Circles_List}    ${Lender_Type}
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Circles_List}    ${Lender_Type}  
    Run Keyword If    ${status}==False    Log    Lender Type is not available    
    
    mx LoanIQ maximize    ${LIQ_WorkInProgress_Window}   
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_TransactionsInProcess_Circles_List}    ${Deal_Name}%d
    mx LoanIQ activate window    ${LIQ_OrigPrimaries_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CircleNotebook_TransactionsInProcess_CirclesList
	
	Mx LoanIQ Select Window Tab    ${LIQ_OrigPrimaries_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PrimaryCircle_Workflow_JavaTree}    Approval%d
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_PrimaryCircle_Workflow_JavaTree_NoItems}      VerificationData="Yes"
    mx LoanIQ close window    ${LIQ_OrigPrimaries_Window}
    mx LoanIQ close window    ${LIQ_WorkInProgress_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CircleNotebook_WorkInProgressWindow

Get Circle Notebook Sell Amount Per Facility
    [Documentation]    This keyword gets the Sell Amount in the Circle Notebook per Facility.
    ...    @author: bernchua
    ...    @update: ehugo    30JUN2020    - added keywords pre-processing and post-processing; added screenshot
    [Arguments]    ${sFacility_Name}    ${sRunTimeVar_SellAmount}=None

    ### GetRuntime Keyword Pre-processing ###
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}

    mx LoanIQ activate    ${LIQ_OrigPrimaries_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_OrigPrimaries_Tab}    Facilities
    ${SellAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Circle_Facilities_Tree}    ${Facility_Name}%Sell Amount%amount  

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PrimariesWindow_GetSellAmount

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_SellAmount}    ${SellAmount}

    [Return]    ${SellAmount}
    
Open Lender Circle Notebook From Primaries List
    [Documentation]    This keyword opens the Lender's Circle Notebook fromt the Primaries List.
    ...    @author: bernchua
    ...    @update: ehugo    30JUN2020    - added keywords pre-processing; added screenshot
    [Arguments]    ${sLender_Name}

    ### GetRuntime Keyword Pre-processing ###
    ${Lender_Name}    Acquire Argument Value    ${sLender_Name}

    mx LoanIQ activate    ${LIQ_PrimariesList_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PrimariesList_JavaTree}    ${Lender_Name}%d 

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PrimariesListWindow_OpenLenderCircleNotebook 
    
Exit Primaries List Window
    [Documentation]    This keyword exits the Circle Notebook and Primaries List Window to return to the Deal Notebook.
    ...    @author: bernchua
    ...    @update: ehugo    30JUN2020    - added screenshot

    mx LoanIQ activate    ${LIQ_PrimariesList_Window}
    mx LoanIQ click    ${LIQ_PrimariesList_Exit_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PrimariesListWindow_Exit

Check Deal Closing Commitment Amount
    [Documentation]    This keyword is for checking the Closing Cmt under Summary Tab of Deal Notebook used for the computation validation.
    ...    @author: mgaling
    ...    @update: dahijara    10AUG2020    - Refactored codes. Remove required arguments and added return value.
    ...                                      - Removed writing inside the keyword and pre-processing keyword.
    ...                                      - And added screenshot and pre processing keywords. Added optional argunment for data runtime varname.
    [Arguments]    ${sRunVar_Deal_ClosingCmt}=None
    
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Summary
    ${Deal_ClosingCmt}    Mx LoanIQ Get Data    ${LIQ_ClosedDeal__DealNB_CurrentCmt_StaticText}    text%Deal_ClosingCmt
    ${Deal_ClosingCmt}    Remove String    ${Deal_ClosingCmt}    ,  
    ${Deal_ClosingCmt}    Convert To Number    ${Deal_ClosingCmt}    2    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_Summary

    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_Deal_ClosingCmt}    ${Deal_ClosingCmt}
    [Return]    ${Deal_ClosingCmt}

Check Host Bank Lender Share
    [Documentation]    This keyword checks the Actual Amount or share of Host Bank.
    ...    @author: mgaling
    ...    @update: dahijara    10AUG2020    - Refactored codes. Remove required arguments and added return value.
    ...                                      - Removed writing inside the keyword and updtaed pre-processing keyword.
    ...                                      - And added screenshot and pre processing keywords. Added optional argunment for data runtime varname.
    ...                                      - Replaced sleep with 'Wait Until Keyword Succeeds'
    [Arguments]    ${sHostBank_LegalEntity}    ${sRunVar_LenShare_Amount}=None
    
    ### GetRuntime Keyword Pre-processing ###
    ${HostBank_LegalEntity}    Acquire Argument Value    ${sHostBank_LegalEntity}
      
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}      
    mx LoanIQ select    ${LIQ_DealNotebook_Queries_LenderShares}
    mx LoanIQ activate window    ${LIQ_LenderShares_Window}
    
    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_LenderShares_PrimariesAssignees_List}    ${HostBank_LegalEntity} 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LenderShares   
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_LenderShares_PrimariesAssignees_List}    ${HostBank_LegalEntity}          
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_LenderShares_PrimariesAssignees_List}    ${HostBank_LegalEntity} 
    Run Keyword If    ${status}==False    Log    Host Bank is not available       
    
    mx LoanIQ activate window    ${LIQ_ServicingGroupShare_Window} 
    ${LenShare_Amount}    Mx LoanIQ Get Data    ${LIQ_ServicingGroupShare_ActualAmount}    text%LenShare_Amount
    ${LenShare_Amount}    Remove String    ${LenShare_Amount}    ,  
    ${LenShare_Amount}    Convert To Number    ${LenShare_Amount}    2
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ServicingGroupShare
    mx LoanIQ click    ${LIQ_ServicingGroupShare_Exit_Button}
    
    mx LoanIQ activate window    ${LIQ_LenderShares_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_LenderShares_HostBankShares_List}    ${HostBank_LegalEntity}%d
   
    ${HostBank_Amount}    Wait Until Keyword Succeeds    10x    2s    Mx LoanIQ Get Data    ${LIQ_HostBankShare_ActualAmount}    text%HostBank_Amount
    ${HostBank_Amount}    Remove String    ${HostBank_Amount}    ,  
    ${HostBank_Amount}    Convert To Number    ${HostBank_Amount}    2
    
    Should Be Equal    ${LenShare_Amount}    ${HostBank_Amount}    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LenderShares
    mx LoanIQ click    ${LIQ_HostBankShare_Cancel_Button}    
    
    mx LoanIQ close window    ${LIQ_LenderShares_Window}

    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_LenShare_Amount}    ${LenShare_Amount}
    [Return]    ${LenShare_Amount}
         
Launch Circle Select
    [Documentation]    This keyword is for navigating to Circle Notebook.
    ...    @author: mgaling
    ...    @update: dahijara    27JUL2020    - Added screenshot
    [Arguments]    ${sCircleSelection_Transaction}  
    
    ### GetRuntime Keyword Pre-processing ###
    ${CircleSelection_Transaction}    Acquire Argument Value    ${sCircleSelection_Transaction}  
  
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    mx LoanIQ select    ${LIQ_DealNotebook_Options_CircleSelect}
    mx LoanIQ activate window    ${LIQ_CircleSelection_Window}    
    Mx LoanIQ Set    ${LIQ_CircleSelection_Window}.JavaRadioButton("attached text:=${CircleSelection_Transaction}")     ON    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CircleSelection

Populate Circle Selection
    [Documentation]    This keyword is for populating the fields in Circle Selection for New External.
    ...    @author: mgaling 
    ...    @update: dahijara    27JUL2020    - Added screenshot. Adjusted keyword indention.
    [Arguments]    ${sBuy_Sell}    ${sLenderShare_Type}    ${sBuyer_Lender}    ${sBuyer_Location}    ${sSeller_LegalEntity}    ${sSeller_Location}    ${sSeller_Riskbook}
    ...    ${sTransaction_Type}    ${sAssigFeeDecision} 
   
    ### GetRuntime Keyword Pre-processing ###
    ${Buy_Sell}    Acquire Argument Value    ${sBuy_Sell}
    ${LenderShare_Type}    Acquire Argument Value    ${sLenderShare_Type}
    ${Buyer_Lender}    Acquire Argument Value    ${sBuyer_Lender}
    ${Buyer_Location}    Acquire Argument Value    ${sBuyer_Location}
    ${Seller_LegalEntity}    Acquire Argument Value    ${sSeller_LegalEntity}
    ${Seller_Location}    Acquire Argument Value    ${sSeller_Location}
    ${Seller_Riskbook}    Acquire Argument Value    ${sSeller_Riskbook}
    ${Transaction_Type}    Acquire Argument Value    ${sTransaction_Type}
    ${AssigFeeDecision}    Acquire Argument Value    ${sAssigFeeDecision}
   
    mx LoanIQ activate window    ${LIQ_CircleSelection_Window} 
    Mx LoanIQ Check Or Uncheck   ${LIQ_CircleSelection_Window}.JavaCheckBox("attached text:=${Buy_Sell}")    ON        
    mx LoanIQ select list    ${LIQ_CircleSelection_LenderShareType}    ${LenderShare_Type}
   
    ###Input Data in Buyer Section###
    mx LoanIQ click    ${LIQ_CircleSelection_LenderButton}
    mx LoanIQ activate window    ${LIQ_LenderSelect_SearchWindow}
    mx LoanIQ enter    ${LIQ_LenderSelect_Search_Inputfield}    ${Buyer_Lender}
    mx LoanIQ click   ${LIQ_LenderSelect_OK_Button}
    mx LoanIQ select list    ${LIQ_CircleSelection_BuyerLocation}    ${Buyer_Location}
   
    ###Input Data in Seller Section### 
    mx LoanIQ select list    ${LIQ_CircleSelection_SellerLegalEntity}    ${Seller_LegalEntity} 
    mx LoanIQ select list    ${LIQ_CircleSelection_SellerLocation}    ${Seller_Location}
    mx LoanIQ click    ${LIQ_CircleSelection_RiskBook_Button}
    Mx LoanIQ Select String    ${LIQ_CreatePrimary_Riskbook_JavaTree}    ${Seller_Riskbook}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CircleSelection
    mx LoanIQ click    ${LIQ_CreatePrimary_Riskbook_OK_Button}  
   
    mx LoanIQ select list    ${LIQ_CircleSelection_TransactionTypeDropdownList}    ${Transaction_Type}
    mx LoanIQ select list   ${LIQ_CircleSelection_AssignFeeDecisionDropdownList}    ${AssigFeeDecision}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CircleSelection
    mx LoanIQ click    ${LIQ_CircleSelection_OKButton}      

Populate Facilities Tab
    [Documentation]    This keyword is for populating the fields under Circle Notebook - Facilities Tab.
    ...    @author: mgaling
    ...    @update: jdelacru    21MAR2019    - Moved writing to High Level
    ...    @update: dahijara    10AUG2020    - Added screenshot and post processing keyword. Removed Sleep
    [Arguments]    ${sPctofDeal}    ${sDeal_ClosingCmt}    ${sSell_Amount}    ${sHostBank_AvailableShare}    ${sInt_Fee}    ${sPaidBy}    ${sBuySell_Price}    ${sRunVar_Sell_Amount}=None
    
    ### GetRuntime Keyword Pre-processing ###
   ${PctofDeal}    Acquire Argument Value    ${sPctofDeal}
   ${Deal_ClosingCmt}    Acquire Argument Value    ${sDeal_ClosingCmt}
   ${Sell_Amount}    Acquire Argument Value    ${sSell_Amount}
   ${HostBank_AvailableShare}    Acquire Argument Value    ${sHostBank_AvailableShare}
   ${Int_Fee}    Acquire Argument Value    ${sInt_Fee}
   ${PaidBy}    Acquire Argument Value    ${sPaidBy}
   ${BuySell_Price}    Acquire Argument Value    ${sBuySell_Price}

    mx LoanIQ activate window    ${LIQ_PendingAssignmentSell_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_AssignmentSell_Tab}    Facilities
    
    ###Input data in Aggregate Amounts Section###
    mx LoanIQ enter    ${LIQ_PendingAssignmentSell_PctofDeal_InputField}    ${PctofDeal}
    Mx Press Combination    Key.TAB
    ${PctofDeal}    Remove Comma and Convert to Number    ${PctofDeal}
    ${Sell_Amount}    Evaluate    ${PctofDeal}/100
    Log    Sell 1 is ${Sell_Amount}
    ${Sell_Amount}    Evaluate    ${Deal_ClosingCmt}*${Sell_Amount}
    Log    Sell 2 is ${Sell_Amount}
    ${Sell_Amount}    Remove Comma and Convert to Number    ${Sell_Amount}
    ${LIQ_SellAmount}    Mx LoanIQ Get Data    ${LIQ_PendingAssignmentSell_SellAmount}    text%LIQ_SellAmount
    ${LIQ_SellAmount}    Remove String    ${LIQ_SellAmount}    ,
    ${LIQ_SellAmount}    Convert To Number    ${LIQ_SellAmount}    2    
    Should Be Equal As Numbers    ${Sell_Amount}    ${LIQ_SellAmount}
    
    ###Verify if the Sell amount is not greater than the available Lender Share###
    ${status}    Evaluate    (${HostBank_AvailableShare}) > (${Sell_Amount})    
    Log    ${status}== True Host Bank Available Share is greater than Sell amount         
    Log    ${status}== False Host Bank has Insufficient Available Shares                  
         
    mx LoanIQ select list    ${LIQ_PendingAssignmentSell_IntFeeDropdownList}    ${Int_Fee}
    mx LoanIQ select list    ${LIQ_PendingAssignmentSell_PaidByDropdownList}    ${PaidBy}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PendingAssignmentSell
    mx LoanIQ click    ${LIQ_PendingAssignmentSell_ProRate_Button}
    mx LoanIQ enter    ${LIQ_ProRate_BuySellPrice_Textfield}    ${BuySell_Price}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ProRate
    mx LoanIQ click    ${LIQ_ProRate_BuySellPrice_Ok_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ProRate

    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_Sell_Amount}    ${Sell_Amount}
    [Return]    ${Sell_Amount}
    
Populate Facilities Lender Tab
    [Documentation]    This keyword is for populating the fields under Circle Notebook - Facilities Tab.
    ...    @author: mgaling
    ...    @update: dahijara    27JUL2020    - Added screenshot. Removed commented codes.
    [Arguments]    ${rowid}    ${PctofDeal}    ${Deal_ClosingCmt}    ${HostBank_AvailableShare}    ${Int_Fee}    ${PaidBy}    ${BuySell_Price}
     ${Deal_ClosingCmt}    Read Data From Excel    TRP002_SecondarySale    Deal_ClosingCmt    ${rowid}
    
    Sleep    5s       
    mx LoanIQ activate window    ${LIQ_PendingAssignmentSell_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_AssignmentSell_Tab}    Facilities
    
    ###Input data in Aggregate Amounts Section###
    mx LoanIQ enter    ${LIQ_PendingAssignmentSell_PctofDeal_InputField}    ${PctofDeal}
         
    mx LoanIQ select list    ${LIQ_PendingAssignmentSell_IntFeeDropdownList}    ${Int_Fee}
    mx LoanIQ select list    ${LIQ_PendingAssignmentSell_PaidByDropdownList}    ${PaidBy}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PendingAssignmentSell
    mx LoanIQ click    ${LIQ_PendingAssignmentSell_ProRate_Button}
    mx LoanIQ enter    ${LIQ_ProRate_BuySellPrice_Textfield}    ${BuySell_Price}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ProRate
    mx LoanIQ click    ${LIQ_ProRate_BuySellPrice_Ok_Button}
                 
Populate Amts or Dates Tab
    [Documentation]    This keyword is for populating the fields under Circle Notebook - Amts/Dates Tab.
    ...    @author: mgaling
    ...    @update: dahijara    10AUG2020    - Removed writing and moved it to business/testcase keyword level
    ...                                      - Added screenshot.
    ...    @update: dahijara    15SEP2020    - Removed Reading of expected close date since it is being passed on the argument.
    [Arguments]    ${sExpectedCloseDate}   
    
    ### GetRuntime Keyword Pre-processing ###
    ${ExpectedCloseDate}    Acquire Argument Value    ${sExpectedCloseDate}
    
    Mx LoanIQ Select Window Tab    ${LIQ_AssignmentSell_Tab}    Amts/Dates
    
    ###Input data in Dates Section###    
    mx LoanIQ enter    ${LIQ_PendingAssignmentSell_AmtsDates_ExpectedCloseDate}    ${ExpectedCloseDate}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PendingAssignmentSell
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PendingAssignmentSell

Add Contacts 
    [Documentation]    This keyword is for adding Buyer's contact under Contacts Tab.
    ...    @author: mgaling
    ...    @update: dahijara    27JUL2020    - Added screenshot. Removed extra parameter for clicking button.
    [Arguments]    ${sBuyer_Lender}    ${sBuyer_Location}    ${sBuyer_ContactName}
    
    ### GetRuntime Keyword Pre-processing ###
    ${Buyer_Lender}    Acquire Argument Value    ${sBuyer_Lender}
    ${Buyer_Location}    Acquire Argument Value    ${sBuyer_Location}
    ${Buyer_ContactName}    Acquire Argument Value    ${sBuyer_ContactName}

    Mx LoanIQ Select Window Tab    ${LIQ_AssignmentSell_Tab}    Contacts
       
    ###Add Buyer's Contact###
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Mx LoanIQ Click    ${LIQ_PendingAssignmentSell_ContactTab_AddContacts_Button}
    ${IsExisting}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_AssignmentSell_ContactSelection}
    Run Keyword If    ${IsExisting}==${False}    Mx LoanIQ Click    ${LIQ_PendingAssignmentSell_ContactTab_AddContacts_Button}
    mx LoanIQ activate window    ${LIQ_AssignmentSell_ContactSelection}
    mx LoanIQ select list    ${LIQ_AssignmentSell_ContactSelection_LenderList}    ${Buyer_Lender}
    mx LoanIQ select list    ${LIQ_AssignmentSell_ContactSelection_LocationList}    ${Buyer_Location}
    mx LoanIQ click    ${LIQ_AssignmentSell_Contacts_Button}
    mx LoanIQ click    ${LIQ_CircleContacts_SelectAll_Button}  
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CircleContacts
    mx LoanIQ click    ${LIQ_CircleContacts_OK_Button} 
    mx LoanIQ click    ${LIQ_ContactSelection_Exit_Button} 
    ###Verify if the Contacts are Added###
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_PendingAssignmentSell_Window}.JavaTree("developer name:=.*${Buyer_ContactName}.*","labeled_containers_path:=.*Contacts.*")                   VerificationData="Yes"
    

Add Servicing Groups
    [Documentation]    This keyword is for adding Servicing Groups under Contacts Tab. 
    ...    @author:mgaling
    ...    Commented scripts are for reserved scripts for Adding Servicing Groups if not auto-added. Currently, by design, Servicing Groups already exists. Thus, scripts are not applicable for now. 
    [Arguments]    ${sBuyer_Lender}    ${sSeller_LegalEntity}    
    
    ### GetRuntime Keyword Pre-processing ###
    ${Buyer_Lender}    Acquire Argument Value    ${sBuyer_Lender}
    ${Seller_LegalEntity}    Acquire Argument Value    ${sSeller_LegalEntity}
    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Text In Javatree    ${LIQ_AssignmentSell_ServicingGroups_JavaTree}    ${Buyer_Lender}%yes    
    ${LIQ_AssignmentSell_ServicingGroups_BuyerExist}    Run Keyword And Return Status    Mx LoanIQ Verify Text In Javatree    ${LIQ_AssignmentSell_ServicingGroups_JavaTree}    ${Buyer_Lender}%yes
    Run Keyword If    ${LIQ_AssignmentSell_ServicingGroups_BuyerExist}==False    Log    Buyer is not available            
    Run Keyword And Continue On Failure    Run Keyword And Return Status    Mx LoanIQ Verify Text In Javatree    ${LIQ_AssignmentSell_ServicingGroups_JavaTree}    ${Seller_LegalEntity}%yes       
    ${LIQ_AssignmentSell_ServicingGroups_SellerExist}    Run Keyword And Return Status    Mx LoanIQ Verify Text In Javatree    ${LIQ_AssignmentSell_ServicingGroups_JavaTree}    ${Seller_LegalEntity}%yes    
    Run Keyword If    ${LIQ_AssignmentSell_ServicingGroups_SellerExist}==False    Log    Legal Entity of the Seller is not available        
    mx LoanIQ select    ${LIQ_AssignmentSell_FileSave}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
 
Add Servicing Group
    [Documentation]    This keyword will add a servicing group
    ...    @author: mnanquil
    ...    10/02/2018
    ...    @update: dahijara    27JUL2020    - Added screenshot and pre processing keywords.
    [Arguments]    ${sBuyer_Lender}
    ### GetRuntime Keyword Pre-processing ###
    ${Buyer_Lender}    Acquire Argument Value    ${sBuyer_Lender}

    mx LoanIQ activate window    ${LIQ_PendingAssignmentSell_Window}
    mx LoanIQ click    ${LIQ_AssignmentSell_ServicingGroups_Button}
    mx LoanIQ activate window    ${LIQ_AssignmentSell_ServicingGroupsSelection_Window}
    Mx LoanIQ Select Combo Box Value    ${LIQ_AssignmentSell_ServicingGroupsSelection_LenderList}    ${Buyer_Lender}
    mx LoanIQ click    ${LIQ_AssignmentSell_ServicingGroupsSelection_SG_Button} 
    mx LoanIQ activate window    ${LIQ_AssignmentSell_ServicingGroupsSelectionFor_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ServicingGroupsSelection
    mx LoanIQ click    ${LIQ_AssignmentSell_ServicingGroupsSelectionFor_Ok_Button}
    mx LoanIQ activate window    ${LIQ_Warning_Window}
    mx LoanIQ click    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}  
    mx LoanIQ close window     ${LIQ_AssignmentSell_ServicingGroupsSelection_Window}            

Circling for Assignment Sell
    [Documentation]    This keyword completes the Circling Workflow Item.
    ...    @author: mgaling
    ...    @update: dahijara    27JUL2020    - Added screenshot and pre processing keywords.
    [Arguments]    ${sAssignment_CircledDate}
    ### GetRuntime Keyword Pre-processing ###
    ${Assignment_CircledDate}    Acquire Argument Value    ${sAssignment_CircledDate}
    Mx LoanIQ Select Window Tab    ${LIQ_AssignmentSell_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${AssignmentSell_Workflow_JavaTree}    Circling%d  
   
    mx LoanIQ enter    ${LIQ_PrimaryCircles_TradeDate_TextField}    ${Assignment_CircledDate}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PrimaryCircles
    mx LoanIQ click    ${LIQ_PrimaryCircles_TradeDate_OK_Buton}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}

Complete Portfolio Allocations for Assignment Sell
    [Documentation]    This keyword completes the Portfolio Allocations Workflow Item.
    ...    @author: mgaling
    ...    @update: jdelacru    21MAR2019    - Used the generic number conversion
    ...    @update: dahijara    10AUG2020    - Added screenshot
    [Arguments]    ${sSeller_Riskbook}    ${sSell_Amount}
    
    ### GetRuntime Keyword Pre-processing ###
    ${Seller_Riskbook}    Acquire Argument Value    ${sSeller_Riskbook}
    ${Sell_Amount}    Acquire Argument Value    ${sSell_Amount}

    Mx LoanIQ Select Window Tab    ${LIQ_AssignmentSell_Tab}    Workflow
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AssignmentSell_Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${AssignmentSell_Workflow_JavaTree}    Complete Portfolio Allocations%d
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AssignmentSell_Workflow
    mx LoanIQ activate window    ${LIQ_PortfolioAllocation_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PortfolioAllocation
    Mx LoanIQ Select Or DoubleClick In Javatree    ${AssignmentSell_PortfolioAllocations_List}    ${Seller_Riskbook}%d
    
    ${LIQ_AllocatedAmount}    Mx LoanIQ Get Data    ${AssignmentSell_PortfolioAllocations_AllocatedAmount}    text%LIQ_AllocatedAmount
    ${LIQ_AllocatedAmount}    Remove Comma and Convert to Number    ${LIQ_AllocatedAmount} 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PortfolioAllocation
    Should Be Equal    ${Sell_Amount}    ${LIQ_AllocatedAmount} 
          
    mx LoanIQ click    ${AssignmentSell_Allocations_OKButton}
    mx LoanIQ click    ${AssignmentSell_PortfolioAllocations_OKButton}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PortfolioAllocation
    
Complete Portfolio Allocations for Pending Assignment Sell 
   [Documentation]    This keyword completes the Portfolio Allocations Workflow Item.
    ...    @author: mnanquilada
    ...    <update> bernchua 10/31/2018: added condition if select or double click by string keyword failed, will do double click instead.
    ...    @update: dahijara    27JUL2020    - Added screenshot and pre processing keywords.
    [Arguments]    ${sSeller_Riskbook}    ${sFacility_1}    ${sSell_Amount}    ${sFacility_2}    ${sSell_Amount2}
    ### GetRuntime Keyword Pre-processing ###
    ${Seller_Riskbook}    Acquire Argument Value    ${sSeller_Riskbook}
    ${Facility_1}    Acquire Argument Value    ${sFacility_1}
    ${Sell_Amount}    Acquire Argument Value    ${sSell_Amount}
    ${Facility_2}    Acquire Argument Value    ${sFacility_2}
    ${Sell_Amount2}    Acquire Argument Value    ${sSell_Amount2}

    Mx LoanIQ Select Window Tab    ${LIQ_AssignmentSell_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${AssignmentSell_Workflow_JavaTree}    Complete Portfolio Allocations%d
    mx LoanIQ activate window    ${LIQ_PortfolioAllocation_Window}
    Mx LoanIQ Select String    ${LIQ_PendingAssignmentSell_Facilities_JavaTree}    ${Facility_1}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PendingAssignmentSell
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PendingAssignmentSell_Facilities_JavaTree}    ${Facility_1}%s
    ${selectSuccessful}    Run Keyword And Return Status    Mx LoanIQ Select Or DoubleClick In Javatree    ${AssignmentSell_PortfolioAllocations_List}    ${Seller_Riskbook}%d
    Run Keyword If    ${selectSuccessful}==False    Mx LoanIQ DoubleClick    ${AssignmentSell_PortfolioAllocations_List}    ${Seller_Riskbook}
    ${LIQ_AllocatedAmount}    Mx LoanIQ Get Data    ${AssignmentSell_PortfolioAllocations_AllocatedAmount}    text%LIQ_AllocatedAmount
    Should Be Equal    ${Sell_Amount}    ${LIQ_AllocatedAmount}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AssignmentSell               
    mx LoanIQ click    ${AssignmentSell_Allocations_OKButton}
    mx LoanIQ activate window    ${LIQ_PortfolioAllocation_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PendingAssignmentSell_Facilities_JavaTree}    ${Facility_2}%s
    Mx LoanIQ Select Or DoubleClick In Javatree    ${AssignmentSell_PortfolioAllocations_List}    ${Seller_Riskbook}%d 
    ${LIQ_AllocatedAmount}    Mx LoanIQ Get Data    ${AssignmentSell_PortfolioAllocations_AllocatedAmount}    text%LIQ_AllocatedAmount
    Should Be Equal    ${Sell_Amount2}    ${LIQ_AllocatedAmount}               
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AssignmentSell
    mx LoanIQ click    ${AssignmentSell_Allocations_OKButton}    
    mx LoanIQ click    ${AssignmentSell_PortfolioAllocations_OKButton}
    
    
Assignment Send to Approval
      [Documentation]    This keyword is for Send to Approval of the Assignment Window/Circle Notebook.
    ...    @author: mgaling
    ...    update: @mnanquilada
    ...    Added validation on the status of the window after performing action in workflow
	Mx LoanIQ Select Or DoubleClick In Javatree    ${AssignmentSell_Workflow_JavaTree}    Send to Approval%d
    mx LoanIQ close window    ${LIQ_AssignmentSell_Window}  
    mx LoanIQ click element if present     ${LIQ_Information_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ activate window    ${LIQ_AssignmentSell_AwaitingApproval}     
	
Assignment Approval
    [Documentation]    This keyword is for approving the Assignment/Circle Notebook
    ...    @author: mgaling
    ...    @update: dahijara    10AUG2020    - Added screenshots.
    [Arguments]    ${sWIPTransaction_Type}    ${sLender_Host}    ${sCircleTransaction_Type}    ${sDeal_Name}    ${sAssignment_CircledDate}    ${sQualifiedBuyerCheckbox_Label}
    
    ### GetRuntime Keyword Pre-processing ###
    ${WIPTransaction_Type}    Acquire Argument Value    ${sWIPTransaction_Type}
    ${Lender_Host}    Acquire Argument Value    ${sLender_Host}
    ${CircleTransaction_Type}    Acquire Argument Value    ${sCircleTransaction_Type}
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    ${Assignment_CircledDate}    Acquire Argument Value    ${sAssignment_CircledDate}
    ${QualifiedBuyerCheckbox_Label}    Acquire Argument Value    ${sQualifiedBuyerCheckbox_Label}

    ##Open Amendment Notebook thru WIP - Awaiting Approval     
    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    mx LoanIQ activate window    ${LIQ_WorkInProgress_Window}   
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}     VerificationData="Yes"
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/WorkInProgress_Window
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionList}    ${WIPTransaction_Type}
    
    
    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Circles_List}    Awaiting Approval    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Circles_List}    Awaiting Approval         
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/TransactionsInProcess_Circles
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Circles_List}    Awaiting Approval   
    Run Keyword If    ${status}==False    Log    'Awaiting Approval' status is not available    
    
    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Circles_List}    ${Lender_Host}    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Circles_List}    ${Lender_Host}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/TransactionsInProcess_Circles
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Circles_List}    ${Lender_Host}  
    Run Keyword If    ${status}==False    Log    Lender Host is not available    
    
    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Circles_List}    ${CircleTransaction_Type}    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Circles_List}    ${CircleTransaction_Type}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/TransactionsInProcess_Circles
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Circles_List}    ${CircleTransaction_Type}  
    Run Keyword If    ${status}==False    Log    Circle Transaction Type is not available    
    
    mx LoanIQ maximize    ${LIQ_WorkInProgress_Window}   
    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Circles_List}    ${Deal_Name}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/TransactionsInProcess_Circles
    Wait Until Keyword Succeeds    3x    5 sec    Mx Press Combination    Key.ENTER
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    mx LoanIQ activate window    ${LIQ_AssignmentSell_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_AssignmentSell_Tab}    Workflow
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AssignmentSell_Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${AwatingApprovalAssignmentSell_Workflow_JavaTree}    Approval%d
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AssignmentSell_Workflow
    mx LoanIQ activate window    ${LIQ_ApprovingAssignment_Window}
    Validate Loan IQ Details    ${Assignment_CircledDate}    ${LIQ_ApprovingAssignment_CircledTradeDate}
    Validate if Element is Checked    ${LIQ_ApprovingAssignment_QualifiedBuyerforCircle_Checkbox}    ${QualifiedBuyerCheckbox_Label}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ApprovingAssignment
    mx LoanIQ click    ${LIQ_ApprovingAssignment_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ApprovingAssignment
    mx LoanIQ close window    ${LIQ_AssignmentSell_Window}  
    mx LoanIQ click element if present     ${LIQ_Information_OK_Button}        
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AssignmentSell

Process Funding Memo
    [Documentation]    This keyword is for processing Funding Memo using Original User.
    ...    @author:mgaling
    ...    <update> @ghabal - created a separate keyword for the other half(Outstandings window ) of this keyword to make this reusable
    ...    <update> @ghabal - Mx Click Element If Present    ${LIQ_Warning_Yes_Button} for Matured facilities in case
    ...    @update: amansuet    22JUN2020    - updated to align with automation standards, added take screenshot and added keyword pre-processing
    ...    @update: clanding    14AUG2020    - updated hard coded values to global variables; updated loaniq keywords
    [Arguments]    ${sWIPTransaction_Type}    ${sLender_Host}    ${sCircleTransaction_Type}    ${sDeal_Name}
    
    ### Keyword Pre-processing ###
    ${WIPTransaction_Type}    Acquire Argument Value    ${sWIPTransaction_Type}
    ${Lender_Host}    Acquire Argument Value    ${sLender_Host}
    ${CircleTransaction_Type}    Acquire Argument Value    ${sCircleTransaction_Type}
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}

    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    mx LoanIQ activate window    ${LIQ_WorkInProgress_Window}  
    Run Keyword And Continue On Failure     Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}     VerificationData="Yes"
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionList}    ${WIPTransaction_Type}
    
    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Circles_List}    ${AWAITING_FUNDING_MEMO_STATUS}    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Circles_List}    ${AWAITING_FUNDING_MEMO_STATUS}         
    Run Keyword If    ${status}==${True}    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Circles_List}    ${AWAITING_FUNDING_MEMO_STATUS}
    ...    ELSE    Log    '${AWAITING_FUNDING_MEMO_STATUS}' status is not available
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}   

    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Circles_List}    ${Lender_Host}    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Circles_List}    ${Lender_Host}
    Run Keyword If    ${status}==${True}    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Circles_List}    ${Lender_Host}  
    ...    ELSE    Log    Lender Host is not available    
    
    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Circles_List}    ${CircleTransaction_Type}    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Circles_List}    ${CircleTransaction_Type}
    Run Keyword If    ${status}==${True}    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Circles_List}    ${CircleTransaction_Type}  
    ...    ELSE    Log    Circle Transaction Type is not available  
    
    Mx LoanIQ Maximize    ${LIQ_WorkInProgress_Window}
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_TransactionsInProcess_Circles_List}    ${Deal_Name}%d
	
    mx LoanIQ activate window    ${LIQ_AssignmentSell_Window}
	Mx LoanIQ Select Window Tab    ${LIQ_AssignmentSell_Tab}    Workflow
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/AssignmentSellWindow_WorkflowTab
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_OpenAssignmentSell_Workflow_JavaTree}    ${FUNDING_MEMO_WORKFLOW}%d
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
Complete Funding Memo for Secondary Sale    
    [Documentation]    This keyword is for completes the Funding Memo using Original User for Secondary Sale
    ...    @author:mgaling
    ...    <update> @ghabal - created separate keyword from 'Process Funding Memo' keyword     
    [Arguments]    ${Loan_Alias}
    mx LoanIQ activate window   ${LIQ_FundingMemo_Outstanding_Window}    
    mx LoanIQ click    ${LIQ_FundingMemo_FreezeAll_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Text In Javatree    ${LIQ_FundingMemo_JavaTree}    float%no                               
    
    ${ProrateValue}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_FundingMemo_JavaTree}    ${Loan_Alias}%Proration%value
    ${DecisionValue}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_FundingMemo_JavaTree}    ${Loan_Alias}%Decision%value  
    
    Should Be Equal    ${ProrateValue}    ${DecisionValue}    
    
    mx LoanIQ select    ${LIQ_FundingMemo_Create}
    Sleep    3s    
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    
    mx LoanIQ activate window    ${LIQ_FundingMemo_Window}
    Take Screenshot
    mx LoanIQ click    ${LIQ_FundingMemo_OK_Button}
    
    mx LoanIQ activate window    ${LIQ_FundingMemo_Outstanding_Window}
    mx LoanIQ click    ${LIQ_FundingMemo_Outstanding_OK_Button}
    
Complete Funding Memo for Lender Share Adjustment
    [Documentation]    This keyword is for completes the Funding Memo using Original User for Secondary Sale
    ...    @author: mgaling
    ...    @update: ghabal - created separate keyword from 'Process Funding Memo' keyword     
    ...    @update: jdelacru    26MAR2019    - Remove completing funding memo for first loan since it is in inactive status
    ...    @update: amansuet    22JUN2020    - updated to align with automation standards, added take screenshot and added keyword pre-processing
    ...    @update: clanding    14AUG2020    - replaced 'Mx Native Type' to 'Mx Press Combination'
    [Arguments]    ${sNew_Loan_Alias}

    ### Keyword Pre-processing ###
    ${New_Loan_Alias}    Acquire Argument Value    ${sNew_Loan_Alias}

    Mx LoanIQ Activate Window   ${LIQ_FundingMemo_Outstanding_Window}   
    Mx LoanIQ Click Javatree Cell    ${LIQ_FundingMemo_JavaTree}    ${New_Loan_Alias}%${New_Loan_Alias}%Alias  
    Mx Press Combination    Key.ENTER
    Mx LoanIQ Activate Window    ${LIQ_FundingMemo_NewAmount_Window}
    Mx LoanIQ Enter    ${LIQ_FundingMemo_NewAmount_Window_AmountField}    0.00
    Mx LoanIQ Click    ${LIQ_FundingMemo_NewAmount_Window_OKButton}
        
    Mx LoanIQ Click    ${LIQ_FundingMemo_FreezeAll_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Text In Javatree    ${LIQ_FundingMemo_JavaTree}    float%no                               
    
    ${DecisionValue}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_FundingMemo_JavaTree}    ${New_Loan_Alias}%Decision%value  
    
    Should Be Equal    ${DecisionValue}    0.00    
    
    Mx LoanIQ Select    ${LIQ_FundingMemo_Create}
 
    Mx LoanIQ Click Element If Present    ${LIQ_Question_Yes_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}    
    
    Mx LoanIQ Activate Window    ${LIQ_FundingMemo_Window}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/FundingMemoOutstandingWindow
    Mx LoanIQ Click    ${LIQ_FundingMemo_OK_Button}
    
    Mx LoanIQ Activate Window    ${LIQ_FundingMemo_Outstanding_Window}
    Mx LoanIQ Click    ${LIQ_FundingMemo_Outstanding_OK_Button}                          
   
Assignment Send to Settlement Approval
    [Documentation]    This keyword is for processing Send to Settlement Approval using Original User.
    ...    @author:mgaling
    ...     update: @mnanquilada
    ...    Added validation on the status of the window after performing action in workflow
    mx LoanIQ activate window    ${LIQ_AssignmentSell_Window}    
	Mx LoanIQ Select Window Tab    ${LIQ_AssignmentSell_Tab}    Workflow
	Validate if Question or Warning Message is Displayed
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_OpenAssignmentSell_Workflow_JavaTree}    Send to Settlement Approval%d  
    Validate if Question or Warning Message is Displayed
    mx LoanIQ close window    ${LIQ_AssignmentSell_Window}  
    mx LoanIQ click element if present     ${LIQ_Information_OK_Button}
		

Assignment Settlement Approval       
     [Documentation]    This keyword is for processing Settlement Approval using Approver User.
    ...    @author:mgaling
    ...    @update: dahijara    19AUG2020    Removed extra arg for mx LoanIQ activate window
    [Arguments]    ${sWIPTransaction_Type}    ${sLender_Host}    ${sCircleTransaction_Type}    ${sDeal_Name}
    
    ### GetRuntime Keyword Pre-processing ###
    ${WIPTransaction_Type}    Acquire Argument Value    ${sWIPTransaction_Type}
    ${Lender_Host}    Acquire Argument Value    ${sLender_Host}
    ${CircleTransaction_Type}    Acquire Argument Value    ${sCircleTransaction_Type}
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}

    ###Open Amendment Notebook thru WIP - Awaiting Settlement Approval###
    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    mx LoanIQ activate window    ${LIQ_WorkInProgress_Window}
    Run Keyword And Continue On Failure     Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}     VerificationData="Yes"
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionList}    ${WIPTransaction_Type}
    
    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Circles_List}    Awaiting Settlement Approval    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Circles_List}    Awaiting Settlement Approval         
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Circles_List}    Awaiting Settlement Approval   
    Run Keyword If    ${status}==False    Log    'Awaiting Settlement Approval' status is not available    

    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Circles_List}    ${Lender_Host}    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Circles_List}    ${Lender_Host}
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Circles_List}    ${Lender_Host}  
    Run Keyword If    ${status}==False    Log    Lender Host is not available        
    
    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Circles_List}    ${CircleTransaction_Type}    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Circles_List}    ${CircleTransaction_Type}
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Circles_List}    ${CircleTransaction_Type}  
    Run Keyword If    ${status}==False    Log    Circle Transaction Type is not available    
    
    mx LoanIQ maximize    ${LIQ_WorkInProgress_Window}   
    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Circles_List}    ${Deal_Name}
    Wait Until Keyword Succeeds    3x    5 sec    Mx Press Combination    Key.ENTER
    
    mx LoanIQ activate window   ${LIQ_AssignmentSell_Window}    
	Mx LoanIQ Select Window Tab    ${LIQ_AssignmentSell_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_OpenAwatingAssignmentSell_Workflow_JavaTree}    Settlement Approval%d
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
          

Settlement Approval
    [Documentation]    This keyword will settle the approval
    ...    @author: mnanquilada
    ...    10/3/2018
    ...    update: @mnanquilada
    ...    Added validation on the status of the window after performing action in workflow
    ...    @update: bernchua    27FEB2019    Updated validation for question/warning message after clicking Workflow transaction
    mx LoanIQ activate window   ${LIQ_AssignmentSell_Window}    
	Mx LoanIQ Select Window Tab    ${LIQ_AssignmentSell_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_OpenAwatingAssignmentSell_Workflow_JavaTree}    Settlement Approval%d
    Validate if Question or Warning Message is Displayed
    mx LoanIQ activate window    ${LIQ_AssignmentSell_SettlementApproval}        
    
Close Assignment Transaction       
     [Documentation]    This keyword is for closing the Assignment Transaction using Original User.
    ...    @author:mgaling
    ...     update: @mnanquilada
    ...    Added validation on the status of the window after performing action in workflow
    ...    @update: bernchua    27FEB2019    Added validation if warning/question message shows after clicking Workflow transaction.
    ...    @update: dahijara    27JUL2020    Added screenshot. Removed extra parameter for Loan IQ Activate Window.
    [Arguments]    ${sWIPTransaction_Type}    ${sLender_Host}    ${sCircleTransaction_Type}    ${sDeal_Name}    ${sAssignment_CircledDate}
    
    ### GetRuntime Keyword Pre-processing ###
    ${WIPTransaction_Type}    Acquire Argument Value    ${sWIPTransaction_Type}
    ${Lender_Host}    Acquire Argument Value    ${sLender_Host}
    ${CircleTransaction_Type}    Acquire Argument Value    ${sCircleTransaction_Type}
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    ${Assignment_CircledDate}    Acquire Argument Value    ${sAssignment_CircledDate}  
    	
    mx LoanIQ activate window    ${LIQ_AssignmentSell_Window}    
	Mx LoanIQ Select Window Tab    ${LIQ_AssignmentSell_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_OpenSettlementApprovedAssignmentSell_Workflow_JavaTree}    Close%d 
    Validate if Question or Warning Message is Displayed    
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    mx LoanIQ activate window    ${LIQ_Closing_Window}
    Run Keyword And Continue On Failure    Wait Until Keyword Succeeds    3x    5s    Validate Loan IQ Details    ${Assignment_CircledDate}    ${LIQ_ClosingAssignment_EffectiveDate}
    Run Keyword And Continue On Failure    Wait Until Keyword Succeeds    3x    5s    Validate Loan IQ Details    ${Assignment_CircledDate}    ${LIQ_ClosingAssignment_CircledTradeDate}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AssignmentSell
    mx LoanIQ click    ${LIQ_ClosedApprovedAssignmentSell_OKButton}  
    mx LoanIQ activate window    ${LIQ_AssignmentSell_Close} 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AssignmentSell

Complete Cashflow in Assignment Transaction 
    [Documentation]    This keyword is for completing Cashflow.
    ...     @author:mgaling  
    [Arguments]    ${Buyer_Lender}    ${Remittance_Description}    ${Remittance_Instruction}    ${Remittance_Status}       
    
    Run Keyword And Continue On Failure     Mx LoanIQ Verify Object Exist    ${AssignmentSell_Workflow_NoItems}       VerificationData="Yes"
    
    mx LoanIQ close window    ${LIQ_AssignmentSell_Window}  
    mx LoanIQ close window    ${LIQ_WorkInProgress_Window}  
    
Check Host Bank Remaining Share
    [Documentation]    This keyword is to check the remaining Host Bank Share.
    ...    @author: mgaling
    [Arguments]    ${srowid}    ${sHostBank_AvailableShare}    ${sSell_Amount}    ${sHB_RemainingShare}    ${sContr_Gross}
    
    ### GetRuntime Keyword Pre-processing ###
    ${rowid}    Acquire Argument Value    ${srowid}
    ${HostBank_AvailableShare}    Acquire Argument Value    ${sHostBank_AvailableShare}
    ${Sell_Amount}    Acquire Argument Value    ${sSell_Amount}
    ${HB_RemainingShare}    Acquire Argument Value    ${sHB_RemainingShare}
    ${Contr_Gross}    Acquire Argument Value    ${sContr_Gross} 
 
    
    ${HostBank_AvailableShare}    Read Data From Excel    TRP002_SecondarySale    HostBank_AvailableShare    ${rowid}
    ${Sell_Amount}    Read Data From Excel    TRP002_SecondarySale    Sell_Amount    ${rowid}
    
    ###Computation for the expected Remaining Share###
    ${HB_RemainingShare} =    Evaluate    ${HostBank_AvailableShare} - ${Sell_Amount}  
    Write Data To Excel    TRP002_SecondarySale    HB_RemainingShare    ${rowid}    ${HB_RemainingShare}
    ${HB_RemainingShare}    Read Data From Excel    TRP002_SecondarySale    HB_RemainingShare    ${rowid}
    
    ###Getting the Contr Gross Amount under Deal Notebook Sumarry Tab###
    ${Contr_Gross}    Mx LoanIQ Get Data    ${ContrGross_Value}    text
    ${Contr_Gross}    Remove String    ${Contr_Gross}    ,    
    ${Contr_Gross}    Convert To Number    ${Contr_Gross}    2 
    
    Should Be Equal    ${HB_RemainingShare}    ${Contr_Gross}
    mx LoanIQ close window    ${LIQ_DealNotebook_Window}

Complete Portfolio Allocations for 2 Facilities
     [Documentation]    *DEPRECATED* This keyword completes the Portfolio Allocation with 2 Facilities in the Circle Notebook.
    ...    @author: ritragel
    ...    @update: rtarayao    27Feb2019    Deprecated the keyword as this is specific only to a Deal with two Facilities; Use the Complete Portfolio Allocations Workflow keyword instead.    
    [Arguments]    ${Facility1_Name}    ${Facility2_Name}    ${Primary_Portfolio}    ${Primary_PortfolioBranch}    ${Primary_PortfolioAllocation}    ${Primary_PortfolioExpDate}    ${PortfolioExpense}
    Mx LoanIQ Select Window Tab    ${LIQ_OrigPrimaries_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PrimaryCircle_Workflow_JavaTree}    Complete Portfolio Allocations%d
    Mx LoanIQ Select String    ${LIQ_PortfolioAllocations_Facility_JavaTree}    ${Facility1_Name}    
    mx LoanIQ click    ${LIQ_PortfolioAllocations_AddPortfolio_Button}
    Mx LoanIQ Select String    ${LIQ_Portfolio_JavaTree}    ${Primary_Portfolio}
    Mx LoanIQ Select Combo Box Value    ${LIQ_Portfolio_BranchDropdown}    ${Primary_PortfolioBranch}
    mx LoanIQ enter    ${LIQ_PortfolioAllocation_Allocation_TextField}    ${Primary_PortfolioAllocation}
    mx LoanIQ enter    ${LIQ_PortfolioAllocation_ExpirationDate_TextField}    ${Primary_PortfolioExpDate}
    mx LoanIQ click    ${LIQ_PortfolioAllocation_OK_Button}
    
    # Verify Portfolio Allocations
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Text In Javatree    ${LIQ_PortfolioAllocations_PortfolioAllocations_JavaTree}    ${PortfolioExpense}        
    Run Keyword If    '${status}'=='True'    Log    Portfolio/Expense Added successfully    level=INFO
    Run Keyword If    '${status}'=='False'    Log    Portfolio/Expense not added    level=ERROR

    Mx LoanIQ Select String    ${LIQ_PortfolioAllocations_Facility_JavaTree}    ${Facility2_Name}    
    mx LoanIQ click    ${LIQ_PortfolioAllocations_AddPortfolio_Button}
    Mx LoanIQ Select String    ${LIQ_Portfolio_JavaTree}    ${Primary_Portfolio}
    Mx LoanIQ Select Combo Box Value    ${LIQ_Portfolio_BranchDropdown}    ${Primary_PortfolioBranch}
    mx LoanIQ enter    ${LIQ_PortfolioAllocation_Allocation_TextField}    ${Primary_PortfolioAllocation}
    mx LoanIQ enter    ${LIQ_PortfolioAllocation_ExpirationDate_TextField}    ${Primary_PortfolioExpDate}
    mx LoanIQ click    ${LIQ_PortfolioAllocation_OK_Button}
    
    # Verify Portfolio Allocations
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Text In Javatree    ${LIQ_PortfolioAllocations_PortfolioAllocations_JavaTree}    ${PortfolioExpense}        
    Run Keyword If    '${status}'=='True'    Log    Portfolio/Expense Added successfully    level=INFO
    Run Keyword If    '${status}'=='False'    Log    Portfolio/Expense not added    level=ERROR
    
    mx LoanIQ click    ${LIQ_Portfolio_OK_Button}         

Approve Assignment
    [Documentation]    This keyword is for approving the Assignment/Circle Notebook
    ...    @author: mnanquilada
    ...    10/02/2018
    ...    @update: bernchua    27FEB2019    - Added validation if warning/question message is showing after clicking workflow transaction
    ...    @update: dahijara    27JUL2020    - Added screenshot and pre processing keywords.
    [Arguments]    ${sAssignment_CircledDate}    ${sQualifiedBuyerCheckbox_Label}
    ### GetRuntime Keyword Pre-processing ###
    ${Assignment_CircledDate}    Acquire Argument Value    ${sAssignment_CircledDate}
    ${QualifiedBuyerCheckbox_Label}    Acquire Argument Value    ${sQualifiedBuyerCheckbox_Label}

    mx LoanIQ activate window    ${LIQ_AssignmentSell_Window}    
	Mx LoanIQ Select Window Tab    ${LIQ_AssignmentSell_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${AwatingApprovalAssignmentSell_Workflow_JavaTree}    Approval%d
    Validate if Question or Warning Message is Displayed
    mx LoanIQ activate window    ${LIQ_ApprovingAssignment_Window}
    Validate Loan IQ Details    ${Assignment_CircledDate}    ${LIQ_ApprovingAssignment_CircledTradeDate}
    Validate if Element is Checked    ${LIQ_ApprovingAssignment_QualifiedBuyerforCircle_Checkbox}    ${QualifiedBuyerCheckbox_Label}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ApprovingAssignment
    mx LoanIQ click    ${LIQ_ApprovingAssignment_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    
Verify Portfolio Allocation
    [Documentation]    This will validate the Portfolio Allocation JavaTree
    ...    @author: ritragel
    [Arguments]    ${PortfolioExpense}
    # Verify Portfolio Allocations
    ${status}    Run Keyword And Return Status    Mx LoanIQ Click Javatree Cell    ${LIQ_PortfolioAllocations_PortfolioAllocations_JavaTree}    ${PortfolioExpense}%Allocation        
    Run Keyword If    '${status}'=='True'    Log    Portfolio/Expense Added successfully    level=INFO
    Run Keyword If    '${status}'=='False'    Log    Portfolio/Expense not added    level=ERROR

Create Funding Memo
    [Documentation]    This keyword will create funding memo
    ...    @author: mnanquilada
    ...    10/02/2018
    mx LoanIQ activate window    ${LIQ_AssignmentSell_Window}    
	Mx LoanIQ Select Window Tab    ${LIQ_AssignmentSell_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${OpenAssignmentSell_Workflow_JavaTree}    Funding Memo%d
    # Mx Activate Window    ${LIQ_Warning_Window}
    # Mx Click    ${LIQ_Warning_Yes_Button}
    mx LoanIQ activate window    ${LIQ_AssignmentSell_Outstanding_Window}
    mx LoanIQ select    ${LIQ_AssignmentSell_Outstanding_Create}
    mx LoanIQ activate window    ${LIQ_Question_Window}
    mx LoanIQ click    ${LIQ_Question_Yes_Button}
    mx LoanIQ activate window    ${LIQ_Warning_Window}
    mx LoanIQ click    ${LIQ_Warning_Yes_Button}
    mx LoanIQ activate window    ${LIQ_AssignmentSell_Funding_Window}
    mx LoanIQ click    ${LIQ_AssignmentSell_Funding_Ok_Button}
    mx LoanIQ activate window    ${LIQ_AssignmentSell_Outstandings_Window}
    mx LoanIQ click    ${LIQ_AssignmentSell_Outstandings_OkButton}

Validate Lender Query Amount
    [Documentation]    This will validate the amount inside lender query
    ...    @author: mnanquilada
    ...    10/03/2018
    ...    @update: dahijara    27JUL2020    - added screenshot and preprocessing keywords. Added deal notebook activate window. And click exit button.
    [Arguments]    ${sLender_Name}    ${sCurrency}    ${sFacility1}    ${sTermAmount1}    ${sTermAmount2}    ${sLender_Name2}    ${sFacility2}    ${sTermAmount3}    ${sTermAmount4}
    ### GetRuntime Keyword Pre-processing ###
    ${Lender_Name}    Acquire Argument Value    ${sLender_Name}
    ${Currency}    Acquire Argument Value    ${sCurrency}
    ${Facility1}    Acquire Argument Value    ${sFacility1}
    ${TermAmount1}    Acquire Argument Value    ${sTermAmount1}
    ${TermAmount2}    Acquire Argument Value    ${sTermAmount2}
    ${Lender_Name2}    Acquire Argument Value    ${sLender_Name2}
    ${Facility2}    Acquire Argument Value    ${sFacility2}
    ${TermAmount3}    Acquire Argument Value    ${sTermAmount3}
    ${TermAmount4}    Acquire Argument Value    ${sTermAmount4}

    Mx LoanIQ Activate Window    ${LIQ_DealNotebook_Window}
    mx LoanIQ select    ${LIQ_DealNotebook_LenderQuery}
    mx LoanIQ activate window    ${LIQ_DealNotebook_LenderQuery_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_DealNotebook_LenderQuery_JavaTree}    ${Lender_Name}%d  
    Mx LoanIQ Select String    ${LIQ_DealNotebook_LenderQuery_JavaTree}    Facility: ${Facility1}\t${Currency}\t\t${TermAmount1}
    Mx LoanIQ Select String   ${LIQ_DealNotebook_LenderQuery_JavaTree}    Facility: ${Facility2}\t${Currency}\t\t${TermAmount2}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_DealNotebook_LenderQuery_JavaTree}    ${Lender_Name2}%d  
    Mx LoanIQ Select String    ${LIQ_DealNotebook_LenderQuery_JavaTree}    Facility: ${Facility1}\t${Currency}\t\t${TermAmount3} 
    Mx LoanIQ Select String   ${LIQ_DealNotebook_LenderQuery_JavaTree}    Facility: ${Facility2}\t${Currency}\t\t${TermAmount4} 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_LenderQuery
    mx LoanIQ click    ${LIQ_DealNotebook_LenderQuery_Exit_Button}

Validate Primaries Lender Share
    [Documentation]    This keyword will validate the primaries inside lender Share
    ...    @author: mnanquilada
    ...    10/03/2018
    ...    @update: dahijara    27JUL2020    - added screenshot and preprocessing keywords. Added Deal Notebook Activate window. Replaced MX native Type with Mx Press Combination.
    [Arguments]    ${sHostBank}    ${sLender_1}    ${sLender_2}    ${sAmount_1}    ${sAmount_2}    ${sAmount_3}
    ### GetRuntime Keyword Pre-processing ###
    ${HostBank}    Acquire Argument Value    ${sHostBank}
    ${Lender_1}    Acquire Argument Value    ${sLender_1}
    ${Lender_2}    Acquire Argument Value    ${sLender_2}
    ${Amount_1}    Acquire Argument Value    ${sAmount_1}
    ${Amount_2}    Acquire Argument Value    ${sAmount_2}
    ${Amount_3}    Acquire Argument Value    ${sAmount_3}

    Mx LoanIQ Activate Window    ${LIQ_DealNotebook_Window}
    mx LoanIQ select    ${LIQ_DealNotebook_LenderShare}
    mx LoanIQ activate window    ${LIQ_DealNotebook_Shares_Window}
    Mx LoanIQ Select String    ${LIQ_LenderShares_PrimariesAssignees_List}    ${HostBank}\t\t${Amount_1}
    Mx LoanIQ Select String    ${LIQ_LenderShares_PrimariesAssignees_List}    ${Lender_1}\t\t${Amount_2}
    Mx LoanIQ Select String    ${LIQ_LenderShares_PrimariesAssignees_List}    ${Lender_2}\t\t${Amount_3}
    Mx LoanIQ Select String    ${LIQ_DealNotebook_Shares_JavaTree}   ${HostBank}\t\t${Amount_1}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LenderShares_PrimariesAssignees
    Mx Press Combination    KEY.ESC
    
Validate Cash Flow
    [Documentation]    This keyword will validate the cashfow on assignment sell [no drawdown]
    ...    @author: mnanquilada
    ...    10/04/2018
    mx LoanIQ activate window    ${LIQ_AssignmentSell_Window}
    mx LoanIQ select    ${LIQ_DealNotebook_Queries_GLEntries}
    mx LoanIQ activate window    ${LIQ_Error_Window}
    mx LoanIQ click    ${LIQ_Error_OK_Button}
    Mx Native Type    {ESC}

Set Percent of Deal
    [Documentation]    This keyword adds a Percent of Deal on Primary Notebook.
    ...                @author: fmamaril
    [Arguments]    ${PercentOfDeal}
    Mx LoanIQ Select Window Tab    ${LIQ_OrigPrimaries_Tab}    Facilities
    mx LoanIQ enter    ${LIQ_OrigPrimaries_PctOfDeal_Textfield}    ${PercentOfDeal}  

Validate Sell Amounts in Amt/Dates Tab
    [Documentation]    This validates the Current Amount of the Circle Notebook.
    ...    @author: rtarayao
    mx LoanIQ activate window    ${LIQ_OrigPrimaries_Window} 
    Mx LoanIQ Select Window Tab    ${LIQ_OrigPrimaries_Tab}    Facilities
    ${FacilitiesTab_SellAmt}    Mx LoanIQ Get Data    ${LIQ_OrigPrimaries_SellAmount_Textfield}    value%test
    Mx LoanIQ Select Window Tab    ${LIQ_OrigPrimaries_Tab}    Amts/Dates           
    ${AmtsDatesTab_CurrentAmt}    Mx LoanIQ Get Data    ${LIQ_Circle_Amounts_CurrentAmount}    value%test  
    ${status}    Run Keyword And Return Status    Should Be Equal As Numbers    ${FacilitiesTab_SellAmt}    ${AmtsDatesTab_CurrentAmt}
    Run Keyword If    ${status}==True    Log    Current Sell Amount in the Facilities Tab is consistent with the Current amount displayed in the Amts/Dates Tab.
    ...    ELSE    Run Keyword    Log    Current Sell Amount in the Facilities Tab is not consistent with the Current amount displayed in the Amts/Dates Tab.
    Validate if Element is Checked    ${LIQ_Circle_Amounts_Net_RadioButton}    Net
   
Navigate to Primaries List Window
    [Documentation]    This keyword is used to navigate to Primaries List window from Deal Notebook.
    ...    author: rtarayao  
    mx LoanIQ activate window    ${LIQ_DealNoteBook_Window}
    mx LoanIQ click element if present    ${LIQ_InquiryMode_Button}
    mx LoanIQ select    ${LIQ_DealNotebook_DistributionPrimaries_Menu}

Complete Assignment Fee Sell on Event Fees
    [Documentation]    This keywords circles the cirle by completing the Assignment Fee in Event Fees from Circle Notebook
    ...    @author: jdelacru
    ...    @update: dahijara    10AUG2020    - Added screenshot
    mx LoanIQ activate window    ${LIQ_AssignmentSell_Window}
    mx LoanIQ select    ${LIQ_AssignmentSell_MaintenanceEventFees_Menu}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AssignmentSell
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}   
    mx LoanIQ activate window      ${LIQ_AssignmentSell_EventFees_Window}
    mx LoanIQ click    ${LIQ_AssignmentSell_EventFees_FlowDownFeeFromDeal_Button}
    mx LoanIQ click    ${LIQ_AssignmentSell_EventFees_OK_Button}    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AssignmentSell
    
Close Primaries Windows
    [Documentation]    This keyword closes the Primaries windows.
    ...    @author: rtarayao    02APR2019    Initial Create       
    Mx LoanIQ Close    ${LIQ_OrigPrimaries_Window}
    Mx LoanIQ Close    ${LIQ_PrimariesList_Window}

Navigate to Portfolio Allocations from Circle Notebook
    [Documentation]    This keyword clicks the "Portfolio Allocations" button from the Circle Notebook's Summary Tab.
    ...    @author: fmamaril    28AUG2019    Initial Create
    mx LoanIQ activate    ${LIQ_OrigPrimaries_Window}       
    mx LoanIQ select    ${LIQ_OrigPrimary_PortfolioAllocation}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    

Close Primary Notebook Window
    [Documentation]    This keyword closes the Primaries windows.
    ...    @author: rtarayao    20SEP2019    Initial Create       
    mx LoanIQ activate window    ${LIQ_OrigPrimaries_Window}    
    Mx LoanIQ Close    ${LIQ_OrigPrimaries_Window}

Update Lender at Primaries List
    [Documentation]    This keyword updates the Lender thru the Primaries List.
    ...    @author: hstone    10JAN2020    - Initial Create
    [Arguments]    ${sHostBank_Lender}    ${sThirdParty_Lender}    ${sLender_Type}
    Open Lender Circle Notebook From Primaries List    ${sHostBank_Lender}
    
    mx LoanIQ activate window    ${LIQ_OrigPrimaries_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_OrigPrimaries_Tab}    Summary
    mx LoanIQ click    ${LIQ_Circle_CounterParty_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
    mx LoanIQ activate window    ${LIQ_Circle_ChangeLenderLocation_Window}
    mx LoanIQ select list    ${LIQ_Circle_ChangeLenderLocation_Change_DropdownList}    ${sLender_Type}
    mx LoanIQ click    ${LIQ_Circle_ChangeLenderLocation_Lender_Button}
    
    mx LoanIQ activate window    ${LIQ_LenderSelect_SearchWindow}
    mx LoanIQ enter    ${LIQ_LenderSelect_Search_Inputfield}    ${sThirdParty_Lender}
    mx LoanIQ click   ${LIQ_LenderSelect_OK_Button}
    
    mx LoanIQ activate window    ${LIQ_Circle_ChangeLenderLocation_Window}
    mx LoanIQ click    ${LIQ_Circle_ChangeLenderLocation_OK_Button}

Navigate to Lender Circle Notebook Business Events
    [Documentation]    This keyword opens the Lender Circle Notebook's Business Events thru the Primaries List.
    ...    @author: hstone    10JAN2020    - Initial Create
    [Arguments]    ${sDealName}     ${sHostBank_Lender}     ${sEvent}
    Open Existing Deal    ${sDealName}
    Navigate to Deal Notebook's Primaries
    Open Lender Circle Notebook From Primaries List    ${sHostBank_Lender}
    
    mx LoanIQ activate window    ${LIQ_OrigPrimaries_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_OrigPrimaries_Tab}    Events
    
    ${sFetchedEvent}    Run Keyword If    '${sEvent}'!='None'    Select Java Tree Cell Value First Match    ${LIQ_Circle_Events_Tree}    ${sEvent}    Event
    ...    ELSE    Set Variable    None           
    
    Take Screenshot    Circle_Business_Event
    
    ${IsMatched}    Run Keyword And Return Status    Should Be Equal As Strings    ${sFetchedEvent}    ${sEvent}
    Run Keyword If    ${IsMatched}==${True}    Log    Event Verification Passed
    ...    ELSE    Fail    Event Verification Failed. ${sFetchedEvent} != ${sEvent}
    
    mx LoanIQ click    ${LIQ_Circle_EventsQueue_Button}    
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}

Navigate to Orig Primaries Workflow and Proceed With Transaction
    [Documentation]    This keyword is used in select an item in workflow for Orig Primaries Notebook.
    ...    @author: ehugo    30JUN2020    - initial create
    [Arguments]    ${sTransaction}
 
    ### Keyword Pre-processing ###
    ${Transaction}    Acquire Argument Value    ${sTransaction}

    Navigate Notebook Workflow    ${LIQ_OrigPrimaries_Window}    ${LIQ_OrigPrimaries_Tab}    ${LIQ_PrimaryCircle_Workflow_JavaTree}    ${Transaction}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/OrigPrimariesWindow_WorkflowTab    

Compute Percentage Amounts for Secondary Sale for Comprehensive Deal
    [Documentation]    This keyword is for computation for TotalRemainingAmount, TotalPercentageAmount1 and TotalPercentageAmount2 for Secondary Sale for Comprehensive Deal Scenario 8.
    ...    @author: dahijara    27JUL2020    - Initial Create
    [Arguments]    ${sTerm_Facility_2}    ${sCurrency}    ${sPercentage_Multiplier_1}    ${sRowid}    ${sTerm_Facility_1}    ${sPercentage_Multiplier_2}
    ...    ${sRunVar_percentageAmount1}=None    ${sRunVar_percentageAmount2}=None    ${sRunVar_percentageAmount3}=None    ${sRunVar_percentageAmount4}=None    ${sRunVar_totalRemainingAmount}=None    ${sRunVar_TotalpercentageAmount1}=None    ${sRunVar_TotalpercentageAmount2}=None

    ### GetRuntime Keyword Pre-processing ###
    ${Term_Facility_2}    Acquire Argument Value    ${sTerm_Facility_2}
    ${Currency}    Acquire Argument Value    ${sCurrency}
    ${Percentage_Multiplier_1}    Acquire Argument Value    ${sPercentage_Multiplier_1}
    ${Rowid}    Acquire Argument Value    ${sRowid}
    ${Term_Facility_1}    Acquire Argument Value    ${sTerm_Facility_1}
    ${Percentage_Multiplier_2}    Acquire Argument Value    ${sPercentage_Multiplier_2}

    ${facilityTotalAmount1}    ${remainingAmount1}    ${percentageAmount1}    ${facilityAmountPercentage1}    Get Facilities Amount    ${sTerm_Facility_2}    ${sCurrency}    ${sPercentage_Multiplier_1}    TRP002_SecondarySale    Facility_Amount_1    ${sRowid}
    ${facilityTotalAmount2}    ${remainingAmount2}    ${percentageAmount2}    ${facilityAmountPercentage2}    Get Facilities Amount    ${sTerm_Facility_2}    ${sCurrency}    ${sPercentage_Multiplier_1}    TRP002_SecondarySale    Facility_Amount_2    ${sRowid}
    ${facilityTotalAmount3}    ${remainingAmount3}    ${percentageAmount3}    ${facilityAmountPercentage3}    Get Facilities Amount    ${sTerm_Facility_1}    ${sCurrency}    ${sPercentage_Multiplier_2}    TRP002_SecondarySale    Facility_Amount_1    ${sRowid}
    ${facilityTotalAmount4}    ${remainingAmount4}    ${percentageAmount4}    ${facilityAmountPercentage4}    Get Facilities Amount    ${sTerm_Facility_2}    ${sCurrency}    ${sPercentage_Multiplier_2}    TRP002_SecondarySale    Facility_Amount_2    ${sRowid}

    ${totalPercentage}    Evaluate    ${sPercentage_Multiplier_1}+${sPercentage_Multiplier_2}

    ${facilityTotalAmount5}    ${remainingAmount5}    ${percentageAmount5}    ${facilityAmountPercentage5}    Get Facilities Amount   ${sTerm_Facility_1}    ${sCurrency}    ${totalPercentage}    TRP002_SecondarySale    Facility_Amount_1    ${sRowid}
    ${facilityTotalAmount6}    ${remainingAmount6}    ${percentageAmount6}    ${facilityAmountPercentage6}    Get Facilities Amount   ${sTerm_Facility_2}    ${sCurrency}    ${totalPercentage}    TRP002_SecondarySale    Facility_Amount_2   ${sRowid}

    ${totalRemainingAmount}    Add Two Values and Convert to Comma Separators    ${remainingAmount5}    ${remainingAmount6}
    ${TotalpercentageAmount1}    Add Two Values and Convert to Comma Separators    ${percentageAmount1}    ${percentageAmount2}
    ${TotalpercentageAmount2}    Add Two Values and Convert to Comma Separators    ${percentageAmount3}    ${percentageAmount4}
    
    Log    <font size=10><b>Percentage Amount 1: ${percentageAmount1}</b></font>    INFO    html=True
    Log    <font size=10><b>Percentage Amount 2: ${percentageAmount2}</b></font>    INFO    html=True
    Log    <font size=10><b>Percentage Amount 3: ${percentageAmount3}</b></font>    INFO    html=True
    Log    <font size=10><b>Percentage Amount 4: ${percentageAmount4}</b></font>    INFO    html=True
    Log    <font size=10><b>Total Percentage Amount 1 & 2: ${TotalpercentageAmount1}</b></font>    INFO    html=True
    Log    <font size=10><b>Total Percentage Amount 3 & 4: ${TotalpercentageAmount2}</b></font>    INFO    html=True
    Log    <font size=10><b>Total Remaining Amount: ${totalRemainingAmount}</b></font>    INFO    html=True
	
    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_percentageAmount1}    ${percentageAmount1}
    Save Values of Runtime Execution on Excel File    ${sRunVar_percentageAmount2}    ${percentageAmount2}
    Save Values of Runtime Execution on Excel File    ${sRunVar_percentageAmount3}    ${percentageAmount3}
    Save Values of Runtime Execution on Excel File    ${sRunVar_percentageAmount4}    ${percentageAmount4}
    Save Values of Runtime Execution on Excel File    ${sRunVar_totalRemainingAmount}    ${totalRemainingAmount}
    Save Values of Runtime Execution on Excel File    ${sRunVar_TotalpercentageAmount1}    ${TotalpercentageAmount1}
    Save Values of Runtime Execution on Excel File    ${sRunVar_TotalpercentageAmount2}    ${TotalpercentageAmount2}

    [Return]    ${percentageAmount1}    ${percentageAmount2}    ${percentageAmount3}    ${percentageAmount4}    ${totalRemainingAmount}    ${TotalpercentageAmount1}    ${TotalpercentageAmount2}

Get Lender Name from Primaries Window
    [Documentation]    This keyword is used to get Lender Name from Primaries window.
    ...    @author: clanding    04AUG2020    - initial create
    [Arguments]    ${sRunTimeVar_LenderName}=None

    ${LenderName}    Mx LoanIQ Get Data    ${LIQ_OrigPrimaries_Window}    title%name
    ${LenderName}    Fetch From Right    ${LenderName}    /
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/OrigPrimariesWindow
    mx LoanIQ close window    ${LIQ_OrigPrimaries_Window}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/OrigPrimariesWindow
    
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_LenderName}    ${LenderName}
    [Return]    ${LenderName}

Go to Lender
    [Documentation]    This keyword is used to double click on Primaries List and doubleclick on Lender.
    ...    @author: clanding    04AUG2020    - initial create
    [Arguments]    ${sLender_Name}

    ### Keyword Pre-processing ###
    ${Lender_Name}    Acquire Argument Value    ${sLender_Name}

    mx LoanIQ activate window    ${LIQ_PrimariesList_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PrimariesList_JavaTree}    ${Lender_Name}%d
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/OrigPrimariesWindow_Lender

Get Sell Amount from Pending Assignment Sell
    [Documentation]    This keyword is used to get sell amount from Pending Assignment Sell.
    ...    @author: clanding    17AUG2020    - initial create
    [Arguments]    ${sFacility_Name}

    ### Keyword Pre-processing ###
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
    
    ${Sell_Amount}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_AssignmentSell_Facilities_JavaTree}    ${Facility_Name}%Sell Amount%Sell_Amount
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PendingAssignmentWindow_FacilitiesTree
    [Return]    ${Sell_Amount}
    
Create New Internal Participation
    [Documentation]    This keyword is used to create circle selection for New Internal Participation
    ...    @author:    mcastro    14OCT2020    initial create 
    [Arguments]    ${sLenderShare_Type}    ${sBuyer_LegalEntity}   ${sSeller_LegalEntity}    ${sBuyer_RiskBook}    ${sSeller_RiskBook}
    
    ###Pre-processing keywords###
    ${LenderShare_Type}    Acquire Argument Value    ${sLenderShare_Type}
    ${Buyer_LegalEntity}    Acquire Argument Value    ${sBuyer_LegalEntity}
    ${Buyer_RiskBook}    Acquire Argument Value    ${sBuyer_RiskBook}
    ${Seller_LegalEntity}    Acquire Argument Value    ${sSeller_LegalEntity}
    ${Seller_RiskBook}    Acquire Argument Value    ${sSeller_RiskBook}
    
    Mx LoanIQ Select    ${LIQ_DealNotebook_Options_CircleSelect}
    Mx LoanIQ Set    ${LIQ_CircleSelection_NewInternalOption}   ${ON}
    Mx LoanIQ Set    ${LIQ_CircleSelection_Selloption}    ${ON}
    Mx LoanIQ Select Combo Box Value    ${LIQ_CircleSelection_LenderShareType}    ${LenderShare_Type}
    
    Mx LoanIQ Select Combo Box Value    ${LIQ_CircleSelection_BuyerLegalEntity}    ${Buyer_LegalEntity}
    Mx LoanIQ Select Combo Box Value    ${LIQ_CircleSelection_BuyerRiskBookDropdownList}    ${Buyer_RiskBook}
    
    Mx LoanIQ Select Combo Box Value    ${LIQ_CircleSelection_SellerLegalEntity}    ${Seller_LegalEntity}
    Mx LoanIQ Select Combo Box Value    ${LIQ_CircleSelection_SellerRiskBookDropdownList}    ${Seller_RiskBook}
    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CircleSelect  
    Mx LoanIQ Click    ${LIQ_CircleSelection_OKButton}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CircleSelect
       
Populate Pending Participation Sell
    [Documentation]    This Keyword Populates And Validates Pending Participation Sell Facilities
    ...    @author:    mcastro    14OCT2020    initial create 
    [Arguments]    ${sPct_of_Deal}    ${sInt_Fee}    ${sBuy_Sell_Price}
    
    ###Pre-processing keywords###
    ${Pct_of_Deal}    Acquire Argument Value    ${sPct_of_Deal}
    ${Int_Fee}    Acquire Argument Value    ${sInt_Fee}
    ${Buy_Sell_Price}    Acquire Argument Value    ${sBuy_Sell_Price}
    
    Mx LoanIQ Activate    ${LIQ_PendingParticipationSell_Window}
    
    Mx LoanIQ Enter    ${LIQ_PendingParticipationSell_PctofDeal_InputField}     ${Pct_of_Deal}     
    Mx LoanIQ Click    ${LIQ_PendingParticipationSell_IntFeeDropdownList} 
    Mx LoanIQ Select Combo Box Value    ${LIQ_PendingParticipationSell_IntFeeDropdownList}    ${Int_Fee}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PendingParticipationSell_Facility
   
    Mx LoanIQ Click    ${LIQ_PendingParticipationSell_ProRate_Button}
    Mx LoanIQ Enter    ${LIQ_ProRate_BuySellPrice_Textfield}    ${Buy_Sell_Price}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ProRate
    Mx LoanIQ Click    ${LIQ_ProRate_BuySellPrice_Ok_Button} 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PendingParticipationSell_Facility
   
Populate Pending Participation Amts/Debts
    [Documentation]    This keyword is used to populate and validates Amts/Debts tab for New Internal Participation
    ...    @author:    mcastro    14OCT2020    initial create 
    [Arguments]    ${sExpected_CloseDate}    ${sBuy_Sell_Amount}
    
    ### Pre-processing keywords ###
    ${Expected_CloseDate}    Acquire Argument Value    ${sExpected_CloseDate}
    ${Buy_Sell_Amount}    Acquire Argument Value    ${sBuy_Sell_Amount}
    
    ### Populate Amts/Dates Tab ###
    Mx LoanIQ Select Window Tab    ${LIQ_PendingParticipationSell_Tab}    Amts/Dates
    
    ${Buy_Sell_Amount}    Convert To Number    ${Buy_Sell_Amount}    
   
    ${Actual_Current_Amount}    Mx LoanIQ Get Data    ${LIQ_PendingParticipationSell_AmtsTab_CurrentAmount}    value
    ${Actual_Current_Amount}    Remove String    ${Actual_Current_Amount}    ,
    ${Actual_Current_Amount}    Convert To Number    ${Actual_Current_Amount}
    ${Status}    Run Keyword And Return Status    Should Be Equal As Numbers   ${Actual_Current_Amount}    ${Buy_Sell_Amount}
    Run Keyword If    ${Status}==${True}    Log    ${Actual_Current_Amount} and ${Buy_Sell_Amount} are equal
    ...    ELSE    Run Keyword And Continue On Failure    FAIL   ${Actual_Current_Amount} is incorrect. Expected amount is ${Buy_Sell_Amount}
    
    Mx LoanIQ Enter    ${LIQ_PendingParticipationSell_AmtsTab_ExpectedClose}    ${Expected_CloseDate} 
    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ParticipationSellAmtsTab  
     
Add Contacts For Participation Sell
    [Documentation]    This keyword is used to Add contacts for New Internal Participation
    ...    @author:    mcastro    14OCT2020    initial create 
    [Arguments]    ${sBuyer_LegalEntity}    ${sSeller_LegalEntity} 
    
    ### Pre-processing keywords ###
    ${Buyer_LegalEntity}    Acquire Argument Value    ${sBuyer_LegalEntity}
    ${Seller_LegalEntity}    Acquire Argument Value    ${sSeller_LegalEntity}

    Mx LoanIQ Select Window Tab    ${LIQ_PendingParticipationSell_Tab}    Contacts   
       
    ### Add Buyer's Contact ###
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Mx LoanIQ Click    ${LIQ_PendingAssignmentSell_ContactTab_AddContacts_Button}
    ${IsExisting}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_AssignmentSell_ContactSelection}
    Run Keyword If    ${IsExisting}==${False}    Mx LoanIQ Click    ${LIQ_PendingAssignmentSell_ContactTab_AddContacts_Button}
    ...    ELSE    Log    Contact Selection Window Is Displayed
    
    Mx LoanIQ activate window    ${LIQ_AssignmentSell_ContactSelection}
    Mx LoanIQ select list    ${LIQ_AssignmentSell_ContactSelection_LenderList}    ${Buyer_LegalEntity}
    Mx LoanIQ click    ${LIQ_AssignmentSell_Contacts_Button}
    Mx LoanIQ click    ${LIQ_CircleContacts_SelectAll_Button}  
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CircleContacts
    Mx LoanIQ click    ${LIQ_CircleContacts_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CircleContacts 
 
    ### Add Lender's Contact ###   
    Mx LoanIQ activate window    ${LIQ_AssignmentSell_ContactSelection}
    Mx LoanIQ select list    ${LIQ_AssignmentSell_ContactSelection_LenderList}    ${Seller_LegalEntity}
    Mx LoanIQ click    ${LIQ_AssignmentSell_Contacts_Button}
    Mx LoanIQ click    ${LIQ_CircleContacts_SelectAll_Button}  
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CircleContacts
    Mx LoanIQ click    ${LIQ_CircleContacts_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CircleContacts
    Mx LoanIQ click    ${LIQ_ContactSelection_Exit_Button} 
    
Complete Circle Fee Decisions
    [Documentation]    This keyword completes circle fee decision of all Facilities for New Internal Participation
    ...    @author:    mcastro    15OCT2020    initial create 
    
    Mx LoanIQ Activate    ${LIQ_PendingParticipationSell_Window}
    Mx LoanIQ Select    ${LIQ_PendingParticipationSell_Maintenance_FeeDecisions}
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Activate    ${LIQ_CircleFeeDecisions_Window}
     
    :FOR    ${rowid}    IN RANGE    ${FACILITY_COUNT}
    \    Log    ${rowid}  
    \    ${rowid}    Evaluate    ${rowid}+1  
    \    ${rowid}    Convert to String    ${rowid}
    \    ${FacilityName}    Read Data From Excel    TRPO06_InternalParticipation    Facility_Name    ${rowid}   
    \    
    \    Populate Circle Fee Decisions    ${FacilityName}    ${rowid}
    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CircleFeeDecisions
    Mx LoanIQ Click    ${LIQ_CircleFeeDecisions_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CircleFeeDecisions
               
Populate Circle Fee Decisions
    [Documentation]    This keyword is Completed circle fee decision of ONE Facilities for New Internal Participation
    ...    @author:    mcastro    15OCT2020    initial create 
    [Arguments]    ${sFacility_Name}    ${rowid} 

    ### Pre-processing keywords ###
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}

    mx LoanIQ activate window    ${LIQ_CircleFeeDecisions_Window}
    
    ${FacilityAmt_String}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CircleFeeDecisions_Facilities_JavaTreeIndex}    ${Facility_Name}%Amount%value
    Mx LoanIQ Select String    ${LIQ_CircleFeeDecisions_Facilities_JavaTreeIndex}    ${Facility_Name}
    ${BuySellCalculated_Percent_String}    Mx LoanIQ Get Data    ${LIQ_CircleFeeDecisions_BuySellCalculated_Textfield}    Value
    ${BuySell_Percent_String}    Mx LoanIQ Get Data    ${LIQ_CircleFeeDecisions_BuySell_Textfield}    Value
    ${FacilityAmt}    Remove Comma and Convert to Number    ${FacilityAmt_String}
    ${BuySellCalculated_Percent}    Convert Percentage to Decimal Value    ${BuySellCalculated_Percent_String}
    ${BuySell_Percent}    Convert Percentage to Decimal Value    ${BuySell_Percent_String}
    ${BuySellCalculated_Percent}    Convert To Number   ${BuySellCalculated_Percent}
    ${BuySell_Percent}    Convert To Number   ${BuySell_Percent}
    ${BuySell_PercentDiff}    Run Keyword If    ${BuySellCalculated_Percent}>${BuySell_Percent}    Evaluate    ${BuySellCalculated_Percent}-${BuySell_Percent}
    ...    ELSE    Evaluate    ${BuySell_Percent}-${BuySell_Percent}
    ${BuySell_PercentDiff_Decimal}    Evaluate    "%.2f" % ${BuySell_PercentDiff}
    ${Calculated_Discount_Amt}    Evaluate    ${FacilityAmt}*${BuySell_PercentDiff_Decimal}
       
    mx LoanIQ click    ${LIQ_CircleFeeDecisions_Discount_Textfield}
    mx LoanIQ enter    ${LIQ_CircleFeeDecisions_Discount_Textfield}    ${Calculated_Discount_Amt}
    mx LoanIQ click    ${LIQ_CircleFeeDecisions_BuySellCalculated_Textfield}
    
    Write Data To Excel    TRPO06_InternalParticipation    Participation_Discount    ${rowid}    ${Calculated_Discount_Amt}    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CircleFeeDecision
    
    
Complete Circling for Pending Participation Sell
    [Documentation]    This keyword completes the Circling Workflow Item.
    ...    @author: mcastro    15OCT2020    initial create
    [Arguments]    ${sParticipationSell_CircledDate}
    ### Pre-processing keywords ###
    ${ParticipationSell_CircledDate}    Acquire Argument Value    ${sParticipationSell_CircledDate}
    
    Mx LoanIQ Activate    ${LIQ_PendingParticipationSell_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_PendingParticipationSell_Tab}    ${WORKFLOW_TAB}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PendingParticipationSell_Workflow_JavaTree}    ${CIRCLING_WORKFLOW}%d
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Enter    ${LIQ_PrimaryCircles_TradeDate_TextField}    ${ParticipationSell_CircledDate}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/SelectCircledLegalTradeDateWindow
    mx LoanIQ click    ${LIQ_PrimaryCircles_TradeDate_OK_Button}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PendingParticipationSell
    
Complete Portfolio Allocations Workflow for Pending Participation Sell
    [Documentation]    This keyword completes the Portfolio Allocation Workflow Item of all facilities for pending participation sell.
    ...    @author: mcastro    15OCT2020    initial create
    Mx LoanIQ Activate    ${LIQ_PendingParticipationSell_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_PendingParticipationSell_Tab}    ${WORKFLOW_TAB}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PendingParticipationSell_Workflow_JavaTree}    ${COMPLETE_PORTFOLIO_ALLOCATIONS_WORKFLOW}%d       
    mx LoanIQ activate    ${LIQ_PortfolioAllocationsFor_Window}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PorfolioAllocationsWindow
    
    :FOR    ${rowid}    IN RANGE    ${FACILITY_COUNT}
    \    Log    ${rowid}   
    \    ${rowid}    Evaluate    ${rowid}+1  
    \    ${rowid}    Convert to String    ${rowid} 
    \    ${FacilityName}    Read Data From Excel    TRPO06_InternalParticipation    Facility_Name    ${rowid}   
    \
    \    Populate Portfolio Allocations For A Facility    ${FacilityName}
    
    mx LoanIQ click    ${AssignmentSell_PortfolioAllocations_OKButton}
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Activate    ${LIQ_PendingParticipationSell_Window}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PendingParticipationSell 
     
Populate Portfolio Allocations For a Facility
    [Documentation]    This keyword completes the Portfolio Allocation Workflow Item of one facility
    ...    @author: mcastro    15OCT202    0initial create
    [Arguments]    ${sFacility_Name}

    ### Pre-processing keywords ###
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
    
    Mx LoanIQ Select String    ${LIQ_AssignmentSell_PortfolioAllocations_Facilities_List}    ${Facility_Name}
    Mx LoanIQ DoubleClick    ${LIQ_PortfolioAllocations_PortfolioExpense_JavaTree}    0.00
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PorfolioAllocationsWindow
    
    mx LoanIQ click    ${AssignmentSell_Allocations_OKButton}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PorfolioAllocationsWindow
    
Send to Approval Internal Participation Sell
    [Documentation]    This keyword sends the Pending Participation to Approval for Internal participation Sell. 
    ...    @author: mcastro    16OCT2020    initial create        
    mx LoanIQ activate    ${LIQ_PendingParticipationSell_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_PendingParticipationSell_Tab}    ${WORKFLOW_TAB}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PendingParticipationSell_Workflow_JavaTree}    ${SEND_TO_APPROVAL_STATUS}%d
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PendingParticipationSendToApproval
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PendingParticipationApproval   
    
Send to Approval Internal Participation Buy
    [Documentation]    This keyword sends the Pending Participation to Approval. 
    ...    @author: mcastro    16OCT2020    initial create        
    mx LoanIQ activate    ${LIQ_PendingParticipationBuy_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_PendingParticipationBuy_Tab}    ${WORKFLOW_TAB}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PendingParticipationBuyWorkflow_JavaTree}    ${SEND_TO_APPROVAL_STATUS}%d
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PendingParticipationSendToApproval
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PendingParticipationApproval 
    
Validate Pending Participation Buy
    [Documentation]    This keyword validates details of pending participation Buy. 
    ...    @author: mcastro    16OCT2020    initial create
    [Arguments]    ${sBuyer_LegalEntity}    ${sBuy_Sell_Amount}    ${sExpected_CloseDate}
    
    ### Keyword Pre-processing ###
    ${Buyer_LegalEntity}    Acquire Argument Value    ${sBuyer_LegalEntity}
    ${Buy_Sell_Amount}    Acquire Argument Value    ${sBuy_Sell_Amount}
    ${Expected_CloseDate}    Acquire Argument Value    ${sExpected_CloseDate}    
    
    ### Validate Buy Amount on Facilities tab###      
    ${Actual_Buy_Amount}    Mx LoanIQ Get Data    ${LIQ_PendingParticipationBuy_BuyAmount_Textfield}    Value
    ${Actual_Buy_Amount}    Remove String    ${Actual_Buy_Amount}    ,
    ${Actual_Buy_Amount}    Convert To Number    ${Actual_Buy_Amount}
    ${Status}    Run Keyword And Return Status    Should Be Equal As Numbers    ${Actual_Buy_Amount}    ${Buy_Sell_Amount}
    Run Keyword If    ${Status}==${True}    Log    ${Actual_Buy_Amount} and ${Buy_Sell_Amount} are equal
    ...    ELSE    Run Keyword And Continue On Failure    FAIL   ${Actual_Buy_Amount} is incorrect. Expected amount is ${Buy_Sell_Amount}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PendingParticipationBuy_FacilitiesTab
                  
    ### Validate Amts/Dates Tab Details ###
    Mx LoanIQ Select Window Tab    ${LIQ_PendingParticipationBuy_Tab}    Amts/Dates
    ${Actual_Circled_Amount}    Mx LoanIQ Get Data    ${LIQ_PendingParticipationBuy_AmtsTab_CircledAmount_Textfield}    Value
    ${Actual_Circled_Amount}    Remove String    ${Actual_Circled_Amount}    ,
    ${Actual_Circled_Amount}    Convert To Number    ${Actual_Circled_Amount}
    ${Status}    Run Keyword And Return Status    Should Be Equal As Numbers    ${Actual_Circled_Amount}	${Buy_Sell_Amount}
    Run Keyword If    ${Status}==${True}    Log    ${Actual_Circled_Amount} and ${Buy_Sell_Amount} are equal
    ...    ELSE    Run Keyword And Continue On Failure    FAIL   ${Actual_Circled_Amount} is incorrect. Expected amount is ${Buy_Sell_Amount}

    ${Actual_Current_Amount}    Mx LoanIQ Get Data    ${LIQ_PendingParticipationBuy_AmtsTab_CurrentAmount_Textfield}    Value
    ${Actual_Current_Amount}    Remove String    ${Actual_Current_Amount}    ,
    ${Actual_Current_Amount}    Convert To Number    ${Actual_Current_Amount}
    ${Status}    Run Keyword And Return Status    Should Be Equal As Numbers    ${Actual_Current_Amount}    ${Buy_Sell_Amount}
    Run Keyword If    ${Status}==${True}    Log    ${Actual_Current_Amount} and ${Buy_Sell_Amount} are equal
    ...    ELSE    Run Keyword And Continue On Failure    FAIL   ${Actual_Current_Amount} is incorrect. Expected amount is ${Buy_Sell_Amount}
    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PendingParticipationBuy_AmtsTab

Validate Displayed Sell Amount From Participation Sell
    [Documentation]    This keyword validates if displayed 'Sell Amount' matches the Computed 'Sell Amount'
    ...    @author: mcastro    16OCT2020    -initial create

    ${Current_DealAmount}    Mx LoanIQ Get Data    ${LIQ_PendingParticipationSell_DealAmount_Textfield}    displayeddealamount
    ${Current_DealAmount}    Remove String    ${Current_DealAmount}    ,
    ${Current_DealAmount}    Convert To Number    ${Current_DealAmount}    
    Log    ${Current_DealAmount}
    
    ${PctofDeal}    Mx LoanIQ Get Data    ${LIQ_PendingParticipationSell_PctofDeal_InputField}    percentofdeal
    ${PctofDeal}    Remove String    ${PctofDeal}    %
    ${PctofDeal}    Evaluate    ${PctofDeal}/100
    ${PctofDeal}    Convert To Number    ${PctofDeal}
    Log    ${PctofDeal}
    
    ${ComputedSellAmount}    Evaluate    ${Current_DealAmount}*${PctofDeal}    
    Log    ${ComputedSellAmount}
    ${Actual_DisplayedSellAmount}    Mx LoanIQ Get Data    ${LIQ_PendingParticipationSell_SellAmount_Textfield}    displayedsellamount
    ${iDisplayedSellAmount}    Remove String     ${Actual_DisplayedSellAmount}    ,
    ${iDisplayedSellAmount}    Convert To Number     ${iDisplayedSellAmount}    
    Log     ${iDisplayedSellAmount}
    
    ###Validate Displayed and Computed Sell Amount###
    Run Keyword And Continue On Failure    Should Be Equal As Numbers    ${ComputedSellAmount}    ${iDisplayedSellAmount}     
    ${result}    Run Keyword And Return Status    Run Keyword And Continue On Failure    Should Be Equal As Numbers    ${ComputedSellAmount}    ${iDisplayedSellAmount}
    Run Keyword If   ${result}==${True}    Log    Displayed 'Sell Amount' matches the Computed 'Sell Amount'
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Displayed 'Sell Amount' does not matched the Computed 'Sell Amount'
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ParticipationSellWindow_FacilitiesTab
    Write Data To Excel    TRPO06_InternalParticipation    Buy_Sell_Amount    ${rowid}    ${iDisplayedSellAmount}  
    
Validate Buy/Sell Price For Facilities On Participation Sell
    [Documentation]    This keyword validates the displayed Buy/Sell of all facilities.
    ...    @author: mcastro    16OCT2020    -initial create
    [Arguments]    ${sBuy_Sell_Price} 

    ### Keyword Pre-processing ###
    ${Buy_Sell_Price}    Acquire Argument Value    ${sBuy_Sell_Price}
	    
    :FOR    ${rowid}    IN RANGE    ${FACILITY_COUNT}
    \    Log    ${rowid}   
    \    ${rowid}    Evaluate    ${rowid}+1 
    \    ${rowid}    Convert to String    ${rowid}
    \    ${FacilityName}    Read Data From Excel    TRPO06_InternalParticipation    Facility_Name    ${rowid}   
    \     
    \    Validate Buy/Sell Price For a Facility    ${FacilityName}    ${Buy_Sell_Price}      
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ParticipationSellWindow_FacilitiesTab
    
Validate Buy/Sell Price For a Facility
    [Documentation]    This keyword validates the displayed Buy/Sell of One facility.
    ...    @author: mcastro    16OCT2020    -initial create
    [Arguments]    ${sFacility_Name}    ${sBuy_Sell_Price}
    
    ### Keyword Pre-processing ###
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
    ${Buy_Sell_Price}    Acquire Argument Value    ${sBuy_Sell_Price}
    
    Mx LoanIQ activate window    ${LIQ_PendingParticipationSell_Window} 
    ${Displayed_Buy_Sell_Price}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_PendingParticipationSell_FacilityList}    ${Facility_Name}%Buy/Sell Price%value    
    ${Status}    Run Keyword and Return Status    Should Be Equal As Strings    ${Buy_Sell_Price}    ${Displayed_Buy_Sell_Price}
    Run Keyword If    ${Status}==${True}    Log    ${Buy_Sell_Price} and ${Displayed_Buy_Sell_Price} are equal
    ...    ELSE    Run Keyword And Continue On Failure    FAIL   ${Displayed_Buy_Sell_Price} is incorrect. Expected amount is ${Buy_Sell_Price}
    
Complete Portfolio Allocations Workflow for Pending Participation Buy
    [Documentation]    This keyword completes the Portfolio Allocation Workflow for Pending Participation Buy
    ...    @author: mcastro    16OCT2020    -Initial create
    [Arguments]    ${sPortfolio}    ${sExpense_Code}    ${sBranch}
    
    ### Keyword Pre-processing ###    
    ${Portfolio}    Acquire Argument Value    ${sPortfolio}
    ${Expense_Code}    Acquire Argument Value    ${sExpense_Code}
    ${Branch}    Acquire Argument Value    ${sBranch}
    
    ### Portfolio Allocation Buy Window ###
    Mx LoanIQ Select Window Tab    ${LIQ_PendingParticipationBuy_Tab}    ${WORKFLOW_TAB}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PorfolioAllocationsWindow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PendingParticipationBuyWorkflow_JavaTree}    ${COMPLETE_PORTFOLIO_ALLOCATIONS_WORKFLOW}%d       
    mx LoanIQ activate    ${LIQ_PortfolioAllocationsFor_Window}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PorfolioAllocationsWindow
    
    :FOR    ${rowid}    IN RANGE    ${FACILITY_COUNT}
    \    Log    ${rowid} 
    \    ${rowid}    Evaluate    ${rowid}+1   
    \    ${rowid}    Convert to String    ${rowid}
    \    ${FacilityName}    Read Data From Excel    TRPO06_InternalParticipation    Facility_Name    ${rowid}   
    \    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Participation_PortfolioAllocations_Facilities_List}    ${FacilityName}%s
    \    Add Portfolio and Expense Code for Pending Participation    ${Portfolio}   ${Expense_Code}    ${Branch}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PortfolioAllocations_Window
    mx LoanIQ click    ${LIQ_Participation_PortfolioAllocationsFor_OK_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Activate    ${LIQ_PendingParticipationBuy_Window}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PortfolioAllocations_Window
 
Add Portfolio and Expense Code for Pending Participation
    [Documentation]    This keyword is used to add Portfolio/Expense Code for one facility.
    ...    @author: mcastro    21OCT2020    - initial create
    [Arguments]    ${sPortfolio}    ${sExpense_Code}    ${sBranch}
    ### Keyword Pre-processing ###
    ${Portfolio}    Acquire Argument Value    ${sPortfolio}
    ${Expense_Code}    Acquire Argument Value    ${sExpense_Code}
    ${Branch}    Acquire Argument Value    ${sBranch}
    
    mx LoanIQ click    ${LIQ_Participation_PortfolioAllocations_AddPortfolioExpenseCode_Button}
    mx LoanIQ activate    ${LIQ_Participation_PortfolioAllocations_Window}    
    Mx LoanIQ Select String    ${LIQ_Participation_PortfolioAllocations_PortfolioExpenseCodes_JavaTree}    ${Portfolio}\t${Expense_Code}
    mx LoanIQ select list    ${LIQ_Participation_PortfolioAllocations_Branch_List}    ${Branch}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PortfolioAllocations_Window
    mx LoanIQ click    ${LIQ_Participation_PortfolioAllocations_OK_Button}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PortfolioAllocations_Window
      
Approval For Internal Participation Buy
    [Documentation]    This keyword Approves Internal Participation Buy
    ...    @author: mcastro    19OCT2020    -initial created
    [Arguments]    ${sDeal_Name}  
    ### Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    Mx LoanIQ Click    ${LIQ_WorkInProgress_Button}
    Mx LoanIQ Maximize    ${LIQ_TransactionsInProcess_Window}
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Transactions_List}    ${CIRCLES_TRANSACTION}
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionDetails_List}    ${AWAITING_APPROVAL_STATUS}
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionDetails_List}    ${HOST_BANK}
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionDetails_List}    Participation   
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/WorkInProcess_Window   
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionDetails_List}    ${Deal_Name}
    Wait Until Keyword Succeeds    3x    5 sec    Mx Press Combination    Key.ENTER      
    Mx LoanIQ Select Window Tab    ${LIQ_AwaitingApprovalParticipation_Tab}    ${WORKFLOW_TAB}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ParticipationBuyWindow_WorkflowTab
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_AwaitingApprovalParticipationWorkflow_JavaTree}    ${APPROVAL_STATUS}%d
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ParticipationBuyWindow_WorkflowTab
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_Question_Yes_Button}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ParticipationBuyWindow_WorkflowTab
    Mx LoanIQ Click    ${LIQ_AwaitingApprovalParticipation_OKButton}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_OpenParticipation_JavaWindow}    VerificationData="Yes"  
    Mx LoanIQ Click Element If Present    ${LIQ_NotificationInformation_OK_Button}  
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ParticipationBuyWindow_WorkflowTab
    Close All Windows on LIQ
    
Approval For Internal Participation Sell
    [Documentation]    This keyword Approves Internal Participation Sell
    ...    @author: mcastro    19OCT2020    -initial created
    [Arguments]    ${sDeal_Name}
    ### Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}

    Mx LoanIQ Click    ${LIQ_WorkInProgress_Button}
    Mx LoanIQ Maximize    ${LIQ_TransactionsInProcess_Window}
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Transactions_List}    ${CIRCLES_TRANSACTION}
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionDetails_List}    ${AWAITING_APPROVAL_STATUS}
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionDetails_List}    ${HOST_BANK}
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionDetails_List}    Participation  
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/WorkInProcess_Window 
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionDetails_List}    ${Deal_Name}
    Wait Until Keyword Succeeds    3x    5 sec    Mx Press Combination    Key.ENTER 
    Mx LoanIQ Select Window Tab    ${LIQ_AwaitingApprovalParticipation_Tab}    ${WORKFLOW_TAB}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ParticipationBuyWindow_WorkflowTab
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_AwaitingApprovalParticipationWorkflow_JavaTree}    ${APPROVAL_STATUS}%d
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ParticipationBuyWindow_WorkflowTab
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_Question_Yes_Button}
    Mx LoanIQ Click    ${LIQ_AwaitingApprovalParticipation_OKButton}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ParticipationBuyWindow_WorkflowTab
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_OpenParticipation_JavaWindow}    VerificationData="Yes"  
    Mx LoanIQ Click Element If Present    ${LIQ_NotificationInformation_OK_Button}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ParticipationBuyWindow_WorkflowTab
    Close All Windows on LIQ
    
Funding Memo For Pending Participation
    [Documentation]    This keyword completes Funding Memo for Pending participation
    ...    @author: mcastro    22OCT2020    Initial Create
    [Arguments]    ${sDeal_Name}
    ### Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    
    Mx LoanIQ Click    ${LIQ_WorkInProgress_Button}
    Mx LoanIQ Maximize    ${LIQ_TransactionsInProcess_Window}
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Transactions_List}    ${CIRCLES_TRANSACTION}
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionDetails_List}    ${AWAITING_FUNDING_MEMO_STATUS}
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionDetails_List}    ${HOST_BANK}
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionDetails_List}    Participation
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/WorkInProcess_Window   
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionDetails_List}    ${Deal_Name}
    Wait Until Keyword Succeeds    3x    5 sec    Mx Press Combination    Key.ENTER 
    Mx LoanIQ Select    ${LIQ_OpenParticipation_File_OpenContraCircle}
    Mx LoanIQ Select Window Tab    ${LIQ_OpenParticipation_JavaWindow_Tab}    ${WORKFLOW_TAB}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ParticipationBuyWindow_WorkflowTab

    ### Funding Memo Window ###
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_OpenParticipation_Workflow_Javatree}    ${FUNDING_MEMO_WORKFLOW}%d
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_Question_Yes_Button}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/FundingMemoWindow
    Mx LoanIQ activate window    ${LIQ_Participation_Outstanding_Window}
    Mx LoanIQ select    ${LIQ_Participation_Outstanding_FundingMemo_Create}
    Mx LoanIQ activate window    ${LIQ_Participation_Funding_Window}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/FundingMemoWindow
    Mx LoanIQ Click    ${LIQ_Participation_Funding_Ok_Button}
    Mx LoanIQ Click    ${LIQ_Participation_Outstanding_OKButton}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ParticipationBuyWindow_WorkflowTab
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_Question_Yes_Button}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ParticipationBuyWindow_WorkflowTab
    Close All Windows on LIQ
    
Send to Settlement Approval For Pending Participation
    [Documentation]    This keyword completes the Send to Settlement Approval Workflow Item.
    ...    @author: mcastro    22OCT2020    Initial Create
    [Arguments]    ${sDeal_Name}
    ### Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    
    Mx LoanIQ Click    ${LIQ_WorkInProgress_Button}
    Mx LoanIQ Maximize    ${LIQ_TransactionsInProcess_Window}
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Transactions_List}    ${CIRCLES_TRANSACTION}
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionDetails_List}    Awaiting Send To Settlement Approval
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionDetails_List}    ${HOST_BANK}
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionDetails_List}    Participation 
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/WorkInProcess_Window 
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionDetails_List}    ${Deal_Name}
    Wait Until Keyword Succeeds    3x    5 sec    Mx Press Combination    Key.ENTER 
    Mx LoanIQ Select Window Tab    ${LIQ_OpenParticipation_JavaWindow_Tab}    ${WORKFLOW_TAB}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ParticipationBuyWindow_WorkflowTab
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_OpenParticipation_Workflow_Javatree}
    Mx LoanIQ Select Window Tab    ${LIQ_OpenParticipation_JavaWindow_Tab}    ${WORKFLOW_TAB}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PendingParticipationWindow_WorkflowTab
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_OpenParticipation_Workflow_Javatree}     ${SEND_TO_SETTLEMENT_APPROVAL_WORKFLOW}%d
    Validate if Question or Warning Message is Displayed
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PendingParticipationWindow_WorkflowTab
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Participation_SendToSettlementApproval_Window}    VerificationData="Yes"
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PendingParticipationWindow_WorkflowTab
    Close All Windows on LIQ

Navigate To Participation Buy  
    [Documentation]    This keyword Navigates to participation buy window from Participation Sell
    ...    @author: mcastro    26OCT2020    Initial Create
    
    Mx LoanIQ activate    ${LIQ_PendingParticipationSell_Window}
    Mx LoanIQ Select    ${LIQ_PendingParticipation_File_OpenContraCircle}  
    Mx LoanIQ Activate    ${LIQ_PendingParticipationBuy_Window} 

Settlement Approval For Internal Participation Buy   
    [Documentation]    This keyword is for approving settlement approval for internal participation buy.
    ...    @author: mcastro    26OCT2020    Initial Create
    [Arguments]    ${sDeal_Name}
    ### Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    
    Mx LoanIQ Click    ${LIQ_WorkInProgress_Button}
    Mx LoanIQ Maximize    ${LIQ_TransactionsInProcess_Window}
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Transactions_List}    ${CIRCLES_TRANSACTION}
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionDetails_List}    ${AWAITING_SETTLEMENT_APPROVAL_STATUS}
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionDetails_List}    ${HOST_BANK}
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionDetails_List}    Participation  
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/WorkInProcess_Window
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionDetails_List}    ${Deal_Name}
    Wait Until Keyword Succeeds    3x    5 sec    Mx Press Combination    Key.ENTER
    mx LoanIQ activate window    ${LIQ_Participation_SendToSettlementApproval_Window}   
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PendingParticipationWindow_WorkflowTab 
	Mx LoanIQ Select Window Tab    ${LIQ_Participation_SendToSettlementApproval_Tab}    ${WORKFLOW_TAB}
	Validate if Question or Warning Message is Displayed
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PendingParticipationWindow_WorkflowTab
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Participation_SendToSettlementApproval_Workflow_JavaTree}    ${SETTLEMENT_APPROVAL_STATUS}%d 
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PendingParticipationWindow_WorkflowTab 
    Validate if Question or Warning Message is Displayed
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ApprovedParticipationWindow_WorkflowTab
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Participation_SettlementApproved_Window}    VerificationData="Yes"
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ApprovedParticipationWindow_WorkflowTab
    mx LoanIQ close window    ${LIQ_Participation_SettlementApproved_Window}  
    mx LoanIQ click element if present     ${LIQ_Information_OK_Button}
    Close All Windows on LIQ

Settlement Approval For Internal Participation Sell  
    [Documentation]    This keyword is for Approving settlement approval for internal participation sell.
    ...    @author: mcastro    26OCT2020    Initial Create
    [Arguments]    ${sDeal_Name}
    ### Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    
    Mx LoanIQ Click    ${LIQ_WorkInProgress_Button}
    Mx LoanIQ Maximize    ${LIQ_TransactionsInProcess_Window}
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Transactions_List}    ${CIRCLES_TRANSACTION}
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionDetails_List}    ${AWAITING_SETTLEMENT_APPROVAL_STATUS}
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionDetails_List}    ${HOST_BANK}
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionDetails_List}    Participation 
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/WorkInProcess_Window 
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionDetails_List}    ${Deal_Name}
    Wait Until Keyword Succeeds    3x    5 sec    Mx Press Combination    Key.ENTER
    mx LoanIQ activate window    ${LIQ_Participation_SendToSettlementApproval_Window}    
	Mx LoanIQ Select Window Tab    ${LIQ_Participation_SendToSettlementApproval_Tab}    ${WORKFLOW_TAB}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PendingParticipationWindow_WorkflowTab
	Validate if Question or Warning Message is Displayed
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PendingParticipationWindow_WorkflowTab
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Participation_SendToSettlementApproval_Workflow_JavaTree}    ${SETTLEMENT_APPROVAL_STATUS}%d  
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PendingParticipationWindow_WorkflowTab
    Validate if Question or Warning Message is Displayed
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Participation_SettlementApproved_Window}    VerificationData="Yes"
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ApprovedParticipationWindow_WorkflowTab
    mx LoanIQ close window    ${LIQ_Participation_SettlementApproved_Window}  
    mx LoanIQ click element if present     ${LIQ_Information_OK_Button}
    Close All Windows on LIQ

Close For Internal Participation
    [Documentation]    This keyword is for Closing Internal Participation Buy Transaction.
    ...    @author: mcastro    26OCT2020
    [Arguments]    ${sDeal_Name}    ${sCloseDate}
    ### Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    ${CloseDate}    Acquire Argument Value    ${sCloseDate}
    
    Mx LoanIQ Click    ${LIQ_WorkInProgress_Button}
    Mx LoanIQ Maximize    ${LIQ_TransactionsInProcess_Window}
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Transactions_List}    ${CIRCLES_TRANSACTION}
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionDetails_List}    Awaiting Close
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionDetails_List}    ${HOST_BANK}
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionDetails_List}    Participation  
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/WorkInProcess_Window
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionDetails_List}    ${Deal_Name}
    Wait Until Keyword Succeeds    3x    5 sec    Mx Press Combination    Key.ENTER
    mx LoanIQ activate window    ${LIQ_Participation_SettlementApproved_Window}    
	Mx LoanIQ Select Window Tab    ${LIQ_Participation_SettlementApproved_Tab}    ${WORKFLOW_TAB}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ApprovedParticipationWindow_WorkflowTab
	Validate if Question or Warning Message is Displayed
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ApprovedParticipationWindow_WorkflowTab
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Participation_SettlementApproved_Workflow_Javatree}    ${CLOSE_WORKFLOW}%d
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ApprovedParticipationWindow_WorkflowTab  
    Validate if Question or Warning Message is Displayed
  
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    mx LoanIQ activate window    ${LIQ_Participation_Closing_Window}
    Run Keyword And Continue On Failure    Wait Until Keyword Succeeds    3x    5s    Validate Loan IQ Details    ${CloseDate}    ${LIQ_Participation_Closing_EffectiveDate}
    Run Keyword And Continue On Failure    Wait Until Keyword Succeeds    3x    5s    Validate Loan IQ Details    ${CloseDate}    ${LIQ_Participation_Closing_CircledTradeDate}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ParticipationClosing
    mx LoanIQ click    ${LIQ_Participation_Closing_OKButton}  
    mx LoanIQ activate window    ${LIQ_Participation_ClosedApproved_Window} 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ParticipationClosed
    
Validate Fee Decisions For All Facilities
    [Documentation]    This keyword is used to validate fee decision amounts on Participation Buy.
    ...    @author: mcastro    21OCT2020    - initial create
    
    Mx LoanIQ Activate    ${LIQ_PendingParticipationBuy_Window}
    Mx LoanIQ Select    ${LIQ_PendingParticipation_Maintenance_FeeDecisions}
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Activate    ${LIQ_CircleFeeDecisions_Window}
     
    :FOR    ${rowid}    IN RANGE    ${FACILITY_COUNT}
    \    Log    ${rowid}  
    \    ${rowid}    Evaluate    ${rowid}+1  
    \    ${rowid}    Convert to String    ${rowid}
    \    ${FacilityName}    Read Data From Excel    TRPO06_InternalParticipation    Facility_Name    ${rowid}  
    \    ${Participation_Discount}    Read Data From Excel    TRPO06_InternalParticipation    Participation_Discount    ${rowid} 
    \    
    \    Validate Fee Decision In A Facility    ${FacilityName}    ${Participation_Discount}
    
    Mx LoanIQ Click    ${LIQ_CircleFeeDecisions_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CircleFeeDecisions
    
    
Validate Fee Decision In A Facility
    [Documentation]    This keyword is Completed circle fee decision of ONE Facilities for New Internal Participation
    ...    @author:    mcastro    15OCT2020    -initial create 
    [Arguments]    ${sFacility_Name}    ${sParticipation_Discount}  
    
    ###Pre-processing keywords###
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
    ${Participation_Discount}    Acquire Argument Value    ${sParticipation_Discount}
    
    ${Participation_Discount}    Convert To Number    ${Participation_Discount}

    mx LoanIQ activate window    ${LIQ_CircleFeeDecisions_Window}
    Mx LoanIQ Select String    ${LIQ_CircleFeeDecisions_Facilities_JavaTreeIndex}    ${Facility_Name}
    
    ${Actual_Discount_Amt}    Mx LoanIQ Get Data    ${LIQ_CircleFeeDecisions_Discount_Textfield}    Value 
    ${Actual_Discount_Amt}    Remove String    ${Actual_Discount_Amt}    ,
    ${Actual_Discount_Amt}    Convert To Number    ${Actual_Discount_Amt} 
           
    ${Status}    Run Keyword And Return Status    Should Be Equal As Numbers    ${Actual_Discount_Amt}    ${Participation_Discount}
    Run Keyword If    ${Status}==${True}    Log    ${Actual_Discount_Amt} and ${Participation_Discount} are equal
    ...    ELSE    Run Keyword And Continue On Failure    FAIL   ${Actual_Discount_Amt} is incorrect. Expected amount is ${Participation_Discount}    
       
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CircleFeeDecisions

Validate GL Entries For Internal Participation
    [Documentation]    This keyword is to Validate GL Entries for Closed Participation.
    ...    @author: mcastro    30OCT2020
    [Arguments]    ${sBuyer_LegalEntity}    ${sSeller_LegalEntity} 
    
    ### Pre-processing keywords ###
    ${Buyer_LegalEntity}    Acquire Argument Value    ${sBuyer_LegalEntity}
    ${Seller_LegalEntity}    Acquire Argument Value    ${sSeller_LegalEntity}

    mx LoanIQ activate window    ${LIQ_Participation_ClosedApproved_Window}
    mx LoanIQ select    ${LIQ_Participation_Closed_Queries_GLEntries}
    mx LoanIQ activate window  ${LIQ_GL_Entries_Window}   
    mx LoanIQ maximize    ${LIQ_GL_Entries_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ParticipationGLEntries
    ${Status}   Run Keyword And Return Status    Mx LoanIQ Verify Text In Javatree    ${LIQ_GL_Entries_JavaTree}    ${Buyer_LegalEntity}%yes
    Run Keyword If    ${Status}==${True}    Log     GL Entries Are correct
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    GL Entries is incorrect
    ${Status}   Run Keyword And Return Status    Mx LoanIQ Verify Text In Javatree    ${LIQ_GL_Entries_JavaTree}    ${Seller_LegalEntity}%yes 
    Run Keyword If    ${Status}==${True}    Log     GL Entries Are correct
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    GL Entries is incorrect 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ParticipationGLEntries  
    mx LoanIQ click element if present    ${LIQ_GL_Entries_Exit_Button}
    Close All Windows on LIQ