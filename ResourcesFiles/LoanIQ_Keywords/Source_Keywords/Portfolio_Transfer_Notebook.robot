*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Add Portfolio Transfer
    [Documentation]    This keyword will add portfolio transfer in a Deal
    ...    @author: mnanquilada
    ...    09/25/2018
    ...    @update: dahijara    13JUL2020    - Added pre & post processing keyword; Added optional argument for runtime variables; and added screenshot; Removed commented codes.
    [Arguments]    ${sDealName}    ${sEffectiveDate}    ${sPortfolioExpenseCode}    ${sExpiryDate}    ${sTransferAmount}    ${sFacilityName}    ${sCurrency}    ${sFacilityTotalAmount}    ${sRunVar_Amount}=None
    ### GetRuntime Keyword Pre-processing ###
    ${DealName}    Acquire Argument Value    ${sDealName}
    ${EffectiveDate}    Acquire Argument Value    ${sEffectiveDate}
    ${PortfolioExpenseCode}    Acquire Argument Value    ${sPortfolioExpenseCode}
    ${ExpiryDate}    Acquire Argument Value    ${sExpiryDate}
    ${TransferAmount}    Acquire Argument Value    ${sTransferAmount}
    ${FacilityName}    Acquire Argument Value    ${sFacilityName}
    ${Currency}    Acquire Argument Value    ${sCurrency}
    ${facilityTotalAmount}    Acquire Argument Value    ${sFacilityTotalAmount}

    mx LoanIQ click element if present    ${LIQ_DealNotebook_InquiryMode_Button}
    mx LoanIQ select    ${LIQ_Portfolio_Positions}
    mx LoanIQ activate window    ${LIQ_Portfolio_Positions_Window}
    Log    ${FacilityName}\t${Currency}\t${facilityTotalAmount}    
    Mx LoanIQ Select String   ${LIQ_Portfolio_Positions_JavaTree}    ${FacilityName}\t${Currency}\t${facilityTotalAmount}
    Mx LoanIQ Select String   ${LIQ_Portfolio_Positions_JavaTree}    ${FacilityName}\t${Currency}\t${facilityTotalAmount}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Portfolio_AddPortfolioTransfer
    mx LoanIQ click    ${LIQ_Portfolio_Positions_Adjustment_Button}              
    mx LoanIQ activate window    ${LIQ_Make_Selections_Window}
    Mx LoanIQ Set    ${LIQ_Make_Selections_Portfolio_Transfer_RadioButton}    ON
    Mx LoanIQ Set    ${LIQ_Make_Selections_SettledDiscountChage_RadioButton}    OFF
    Mx LoanIQ Set    ${LIQ_Make_Selections_TradeDateDiscountChange_RadioButton}    OFF
    Mx LoanIQ Set    ${LIQ_Make_Selections_AssignableChange_RadioButton}    OFF
    Mx LoanIQ Set    ${LIQ_Make_Selections_DefferedPLChange_RadioButton}    OFF
    Mx LoanIQ Set    ${LIQ_Make_Selections_DefferedPLIndicatorChange_RadioButton}    OFF            
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Portfolio_AddPortfolioTransfer
    mx LoanIQ click    ${LIQ_Make_Selections_OK_Button}
    mx LoanIQ activate window    ${LIQ_Portfolio_Transfer_Window}
    mx LoanIQ enter    ${LIQ_Portfolio_Transfer_Effective_Date}    ${EffectiveDate}
    Mx Press Combination    KEY.TAB
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    mx LoanIQ click    ${LIQ_Portfolio_Transfer_To_Portfolio_Button}
    mx LoanIQ activate window    ${LIQ_Portfolio_Selections_For_Window}
	Mx LoanIQ Select String    ${LIQ_Portfolio_Selections_For_PortfolioExpense}    ${PortfolioExpenseCode}
    mx LoanIQ click    ${LIQ_Portfolio_Selections_OK_Button}
    mx LoanIQ activate window    ${LIQ_Portfolio_Transfer_Window}
	${ExpenseCde}    Fetch From Left    ${PortfolioExpenseCode}    (
	${message}    Mx LoanIQ Get Data    JavaWindow("title:=Portfolio Transfer.*").JavaStaticText("labeled_containers_path:=Tab:General;Group:To;.*","attached text:=${ExpenseCde}.*")    Message                       
	Run keyword and Continue on Failure    Should Contain    ${message}    ${PortfolioExpenseCode}
    mx LoanIQ enter    ${LIQ_Portfolio_Transfer_Amount}    ${TransferAmount}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Portfolio_Transfer
    mx LoanIQ select    ${LIQ_Portfolio_Transfer_Save_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
	${amount}    Mx LoanIQ Get Data    ${LIQ_Portfolio_Transfer_Amount}    Amount
    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_Amount}    ${amount}    
	[Return]    ${amount}   

Send Portfolio Transfer to Approval
    [Documentation]    This keyword will send the portflio transfer to approval
    ...    @author: mnanquilada
    ...    09/25/2018
    ...    <update> bernchua 11/19/2018: Used 'Verify If Warning Is Displayed' keyword for warning messages.
    ...    @Update: dahijara    13JUL2020    - Added keyword for screenshot
    Mx LoanIQ Select Window Tab    ${LIQ_Portfolio_Transfer_Tab_Button}    Workflow
	Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Portfolio_Transfer_Workflow_Java_Tree}    Send to Approval%d
    Verify If Warning Is Displayed
	Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Portfolio_Transfer_Workflow_Java_Tree}    Approval%s
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PortfolioTransfer_Workflow

Approve Portfolio Transfer
    [Documentation]    This keyword will approve the portfolio transfer created
    ...    @author: mnanquilada
    ...    09/25/2018
    ...    <udpate> bernchua 11/19/2018: Used 'Validate if Question or Warning Message is Displayed' keyword for warning/question messages.
    Mx LoanIQ Select Window Tab    ${LIQ_Portfolio_Transfer_Tab_Button}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Portfolio_Transfer_Workflow_Java_Tree}    Approval%d
    Validate if Question or Warning Message is Displayed
	Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Portfolio_Transfer_Workflow_Java_Tree}    Release%s

Release Portfolio Transfer
    [Documentation]    This keyword will release the portfolio created
    ...    @author: mnanquilada
    ...    @author: rtarayao - added warning message validation to handle released commitment for the deal.
    ...    09/25/2018
    ...    @update: bernchua    19NOV2018    Used 'Verify If Warning Is Displayed' keyword for warning messages
    ...    @update: bernchua    28FEB2019    Updated keyword for validation of question/warning message after clicking Workflow transaction
    ...    @update:dahijaqra    13JUL2020    - added screenshot
    ...    @update: dahijara    29JUL2020    - Added 'mx LoanIQ close window    ${LIQ_Portfolio_Transfer_Window}'
    Mx LoanIQ Select Window Tab    ${LIQ_Portfolio_Transfer_Tab_Button}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Portfolio_Transfer_Workflow_Java_Tree}    Release%d
    Validate if Question or Warning Message is Displayed
    mx LoanIQ activate window    ${LIQ_Portfolio_Transfer_Released_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PortfolioTransfer_Workflow
    mx LoanIQ close window    ${LIQ_Portfolio_Transfer_Window}    

Get Facility Amount
    [Documentation]    This keyword will get the facility amount on lender share
    ...    @author: mnanquilada
    ...    09/26/2018
    [Arguments]    ${FacilityName}    ${Currency}   
    mx LoanIQ select    ${LIQ_Portfolio_Positions}
    mx LoanIQ activate window    ${LIQ_Portfolio_Positions_Window}
    Mx LoanIQ Select String   ${LIQ_Portfolio_Positions_JavaTree}    ${FacilityName}\t${Currency}
    Mx Native Type    {ENTER}
    mx LoanIQ activate window    ${LIQ_DealNotebook_PortfolioAllocations_Window}
    ${facilityAmount}    Mx LoanIQ Get Data    ${LIQ_DealNotebook_PortfolioAllocations_Net}    FacilityAmount 
    [Return]    ${facilityAmount}

Get Facility Percentage Amount
    [Documentation]    This keyword will compute the percentage of the facility amount.
    ...    @author: mnanquilada
    ...    <update> bernchua 11/13/2018: converted the returned value to string
    ...    09/26/2018
    [Arguments]    ${FacilityAmount}    ${PercentageToMultiply}
    ${facilityAmount}    Remove String    ${FacilityAmount}    ,
    ${facilityAmount}    Convert To Number    ${facilityAmount}   
    ${facilityAmount}    Evaluate    ${facilityAmount}*${PercentageToMultiply}
    ${facilityAmount}    Convert To String    ${facilityAmount}
    [Return]    ${facilityAmount}
    
Get Remaining Facility Value
    [Documentation]    This keyword will compute the remaining facility amount before performing portfolio transfer.
    ...    @author: mnanquilada
    ...    09/26/2018
    ...    <update> bernchua 11/13/2018: added condition on what value to return.
    [Arguments]    ${originalAmount}    ${amountToTransfer}
    ${remainingAmount}    Evaluate    ${originalAmount}-${amountToTransfer}
    ${remainingAmount}    Convert To String    ${remainingAmount}
    Return From Keyword If    ${remainingAmount}==0.00    ${originalAmount}
    Return From Keyword If    ${remainingAmount}!=0.00    ${remainingAmount}    

Validate Portfolio Transfer in Lender Share
    [Documentation]    This keyword will validate the facility amount in lender share
    ...    @author: mnanquilada
    ...    09/26/2018
    ...    @update: dahijara    13JUL2020    - Added pre processing keyword; and added screenshot
    [Arguments]    ${sHostBank}    ${sExpenseCode}    ${sFacilityAmount}
    ### GetRuntime Keyword Pre-processing ###
    ${HostBank}    Acquire Argument Value    ${sHostBank}
    ${ExpenseCode}    Acquire Argument Value    ${sExpenseCode}
    ${FacilityAmount}    Acquire Argument Value    ${sFacilityAmount}

    mx LoanIQ select    ${LIQ_DealNotebook_LenderShare}
    mx LoanIQ activate window    ${LIQ_DealNotebook_Shares_Window}
    Mx LoanIQ Select String    ${LIQ_DealNotebook_Shares_JavaTree}   ${HostBank} 
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_DealNotebook_Shares_JavaTree}    ${HostBank}%d     
    mx LoanIQ activate window    ${LIQ_DealNotebook_Hostbank_Window}
    Mx LoanIQ Select String    ${LIQ_DealNotebook_Hostbank_Javatree}    ${ExpenseCode}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_DealNotebook_Hostbank_Javatree}     ${ExpenseCode}%d          
    mx LoanIQ activate window    JavaWindow("title:=Portfolio Allocations for.* ${ExpenseCode}.*")
    ${netAmount}    Mx LoanIQ Get Data    ${LIQ_DealNotebook_PortfolioAllocations_Net}    NetAmount          
	Run keyword and Continue on Failure    Should Be Equal    ${netAmount}    ${FacilityAmount}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_PortfolioAllocations
    mx LoanIQ close window    ${LIQ_DealNotebook_PortfolioAllocations_Window}
    mx LoanIQ close window    ${LIQ_DealNotebook_Hostbank_Window}
    mx LoanIQ close window    ${LIQ_DealNotebook_Shares_Window}    

Validate Remaining Amount in Portfolio Position
    [Documentation]    This keyword wil validate the remaining facility amount in the portfolio position
    ...    @author: mnanquilada
    ...    09/26/2018
    ...    <update> bernchua 11/13/2018: commented out some lines for integrated scenario
    ...    @update: dahijara    13JUL2020    - Added pre processing keyword; and added screenshot; Removed commented out lines.
   [Arguments]    ${FacilityName}    ${Currency}    ${remainingFacilityAmount}    ${percentageFacilityAmount}    ${newExpenseCode}   
    mx LoanIQ select    ${LIQ_Portfolio_Positions}
    mx LoanIQ activate window    ${LIQ_Portfolio_Positions_Window}
    Mx LoanIQ Select String   ${LIQ_Portfolio_Positions_JavaTree}    ${FacilityName}\t${Currency}\t${remainingFacilityAmount}
    Log    Successfully clicked Remaining amount of ${remainingFacilityAmount}
    Mx LoanIQ Select String   ${LIQ_Portfolio_Positions_JavaTree}    ${FacilityName}\t${Currency}\t${percentageFacilityAmount}
    Log    Successfully clicked percentage amount of ${percentageFacilityAmount}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Portfolio_Positions

Get Remaining Facility Amount
    [Documentation]    This keyword will get the remaining facility amount and compute the percentage 
    ...    amount and remaining amount
    ...    @author: mnanquilada
    ...    09/27/2018
    ...    @update: dahijara    13JUL2020    - Added pre & post processing keyword; Added optional argument for runtime variables; and added screenshot; Replaced mx Native Type with Mx Press Combination.
    [Arguments]    ${sFacilityName}    ${sCurrency}    ${sPercentageMultiply}    ${sRunVar_facilityTotalAmount}=None    ${sRunVar_remainingAmount}=None    ${sRunVar_percentageAmount}=None    ${sRunVar_facilityAmountPercentage}=None
    ### GetRuntime Keyword Pre-processing ###
    ${facilityName}    Acquire Argument Value    ${sFacilityName}
    ${currency}    Acquire Argument Value    ${sCurrency}
    ${percentageMultiply}    Acquire Argument Value    ${sPercentageMultiply}

    ${facilityTotalAmount}    Get Facility Amount   ${facilityName}    ${currency}
    ${facilityAmount}    Remove String    ${facilityTotalAmount}    ,
    ${facilityAmount}    Convert To Number    ${facilityAmount}   
    ${facilityAmountPercentage}    Get Facility Percentage Amount     ${facilityTotalAmount}    ${percentageMultiply}    
    ${remainingFacilityAmount}    Get Remaining Facility Value     ${facilityAmount}    ${facilityAmountPercentage}
    
    ${remainingAmount}    Convert To Number    ${remainingFacilityAmount}    2
    ${remainingAmount}    Evaluate    "%.2f" % ${remainingAmount}
    ${remainingAmount}    Convert Number With Comma Separators    ${remainingAmount}
    
    ${percentageAmount}    Convert To Number    ${facilityAmountPercentage}    2
    ${percentageAmount}    Evaluate    "%.2f" % ${percentageAmount}
    ${percentageAmount}    Convert Number With Comma Separators    ${percentageAmount}   
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ProtfolioAllocation_FacilityAmount
    mx LoanIQ close window    ${LIQ_DealNotebook_PortfolioAllocations_Window}
    Mx Press Combination    KEY.ESC
    
    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_facilityTotalAmount}    ${facilityTotalAmount}
    Save Values of Runtime Execution on Excel File    ${sRunVar_remainingAmount}    ${remainingAmount}
    Save Values of Runtime Execution on Excel File    ${sRunVar_percentageAmount}    ${percentageAmount}
    Save Values of Runtime Execution on Excel File    ${sRunVar_facilityAmountPercentage}    ${facilityAmountPercentage}
	    
    [Return]     ${facilityTotalAmount}    ${remainingAmount}    ${percentageAmount}    ${facilityAmountPercentage}

Add Two Values and Convert to Comma Separators
    [Documentation]    This will compute two values and return it with comma separator
    ...    @author: mnanquilada
    [Arguments]    ${value1}    ${value2}
    ${value1}    Remove String    ${value1}    ,
    ${value1}    Convert To Number    ${value1}
    ${value2}    Remove String    ${value2}    ,
    ${value2}    Convert To Number    ${value2}
    ${totalRemainingAmount}    Evaluate    ${value1}+${value2}
    ${totalRemainingAmount}    Convert To String    ${totalRemainingAmount}
    ${totalRemainingAmount}    Convert Number With Comma Separators    ${totalRemainingAmount}
    [Return]    ${totalRemainingAmount}


Get Facilities Amount
    [Documentation]    This keyword will get the remaining facility amount and compute the percentage 
    ...    amount and remaining amount
    ...    @author: mnanquilada
    ...    09/27/2018
    [Arguments]    ${facilityName}    ${currency}    ${percentageMultiply}    ${sheetName}    ${columnName}    ${rowid}
    ${facilityTotalAmount}   Read Data From Excel    ${sheetName}    ${columnName}    ${rowid}
    ${facilityTotalAmount}    Convert Number With Comma Separators    ${facilityTotalAmount}
    ${facilityAmount}    Remove String    ${facilityTotalAmount}    ,
    ${facilityAmount}    Convert To Number    ${facilityAmount}   
    ${facilityAmountPercentage}    Get Facility Percentage Amount     ${facilityTotalAmount}    ${percentageMultiply}    
    ${remainingFacilityAmount}    Get Remaining Facility Value     ${facilityAmount}    ${facilityAmountPercentage}
    ${remainingAmount}    Convert Number With Comma Separators    ${remainingFacilityAmount}
    ${percentageAmount}    Convert Number With Comma Separators    ${facilityAmountPercentage}
    [Return]     ${facilityTotalAmount}    ${remainingAmount}    ${percentageAmount}    ${facilityAmountPercentage}      

Validate Portfolio Transfer Using Expense Code
    [Documentation]    This keyword will validate portfolio transfer during approval.
    ...    @author: dahijara    13JUL2020    - Moved codes from test case file to a new keyword.
    [Arguments]    ${sExpenseCode}
    ### GetRuntime Keyword Pre-processing ###
    ${ExpenseCode}    Acquire Argument Value    ${sExpenseCode}
    mx LoanIQ activate window    ${LIQ_Portfolio_Transfer_Window}
	${ExpenseCde}    Fetch From Left    ${sExpenseCode}    (
	${message}    Mx LoanIQ Get Data    JavaWindow("title:=Portfolio Transfer.*").JavaStaticText("labeled_containers_path:=Tab:General;Group:To;.*","attached text:=${ExpenseCde}.*")    Message                       
	Run keyword and Continue on Failure    Should Contain    ${message}    ${sExpenseCode}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Portfolio_Transfer