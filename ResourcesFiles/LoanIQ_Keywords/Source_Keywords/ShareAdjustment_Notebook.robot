*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
View/Update Lender Shares From Adjustment Window
    [Documentation]    This keyword selects Option > View/Update Lender Shares from the Share Adjustment Notebook.
    ...    @author: bernchua
    mx LoanIQ activate    ${LIQ_ShareAdjustment_Window}
    mx LoanIQ select    ${LIQ_ShareAdjustment_Options_ViewUpdateLenderShares}
    mx LoanIQ activate    ${LIQ_SharesFor_Window} 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LenderShare_Adjustment_window          

Set Share Adjusment General Tab Details
    [Documentation]    This keywords sets all the details under the General Tab of the Shares Adjustment Notebook.
    ...    @author: bernchua
    ...    <update> @ghabal - added note - | no changes in script for Scenario 2, effective date to be the same with Facility Effective Date
    ...    @update: sahalder    01JUL2020    Added keyword pre-processing steps
    [Arguments]    ${sDeal_Name}    ${sFacility_Name}    ${sCurrency}    ${sEffective_Date}    ${sBuySellPrice}    ${sComment}
    
    ######Pre-Processing keywords####
    
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}    
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
    ${Currency}    Acquire Argument Value    ${sCurrency}
    ${Effective_Date}    Acquire Argument Value    ${sEffective_Date}
    ${BuySellPrice}    Acquire Argument Value    ${sBuySellPrice}
    ${Comment}    Acquire Argument Value    ${sComment}

    mx LoanIQ activate    ${LIQ_ShareAdjustment_Window}
    Verify If Text Value Exist as Static Text on Page    Share Adjustment    ${Deal_Name}
    ${Obejct_Exist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Share Adjustment.*").JavaStaticText("text:=${Facility_Name}")    VerificationData="Yes"
    Run Keyword If    ${Obejct_Exist}==True    Log    ${Facility_Name} is displayed in Share Adjustment window.
    Verify If Text Value Exist as Static Text on Page    Share Adjustment    ${Currency}  
    mx LoanIQ enter    ${LIQ_ShareAdjustment_Effective_Datefield}    ${Effective_Date}   
    mx LoanIQ enter    ${LIQ_ShareAdjustment_BuySellPrice_Textfield}    ${BuySellPrice}
    mx LoanIQ enter    ${LIQ_ShareAdjustment_Comment_Textfield}    ${Comment}
    mx LoanIQ select    ${LIQ_ShareAdjustment_File_Save}
    Validate Loan IQ Details    ${Effective_Date}    ${LIQ_ShareAdjustment_Effective_Datefield}
    ${UI_BuySellPrice}    Mx LoanIQ Get Data    ${LIQ_ShareAdjustment_BuySellPrice_Textfield}    value%value
    ${UI_BuySellPrice}    Remove String    ${UI_BuySellPrice}    %
    ${UI_BuySellPrice}    Convert To Number    ${UI_BuySellPrice}
    ${BuySellPrice}    Convert To Number    ${BuySellPrice}
    ${UI_Comment}    Mx LoanIQ Get Data    ${LIQ_ShareAdjustment_Comment_Textfield}    value%text
    ${UI_Comment}    Strip String    ${UI_Comment}
    Run Keyword If    '${BuySellPrice}'=='${UI_BuySellPrice}'    Log    Buy Sell Price verified.
    Run Keyword If    '${Comment}'=='${UI_Comment}'    Log    Comment verified.
    Validate Window Title Status    Share Adjustment    Awaiting Send To Approval
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Share_Adjustment_General
    
Update Facility Lender Shares
    [Documentation]    This keyword updates the Facility Lender Shares.
    ...    Returns an amount based from the computation of the Loan Drawdown and the Lender Share Adjustment, to be used in validating the 'Tran Amount' in the Cashflows. 
    ...    @author: bernchua
    ...    @update: archana   - Added Keyword Pre-processing: Acquire Argument Value
    ...                                    - Added Keyword Post-processing: Runtime Value Save
    ...                                    - Added ${sRuntimeVar_TranAmount} AND   ${sRuntimeVar_LenderShare}  Argument
    ...   @update: hstone     17JUN2020    - All AND statements entered on a new line
    ...                                    - Added default argument: ${sPrimariesTreeBalanceColumn}=New Balance
    ...                                    - Added Object Exist Conditions to avoid errors on existing scripts using this keyword. SERV03 uses different locators but same process.
    ...                                    - Getting Balance from Primaries tree using a default variable ${PrimariesTreeBalanceColumn}
    ...                                    - Added Take Screenshot
    [Arguments]    ${sLender_Name}    ${sAdjustment}    ${sLenderShare}    ${sProposed_Cmt}    ${sOutstandings_Amount}    ${sPrimariesTreeBalanceColumn}=New Balance
    ...    ${sRuntimeVar_TranAmount}=None    ${sRuntimeVar_LenderShare}=None
    
    ######Pre-Processing keywords####

     ${Lender_Name}    Acquire Argument Value    ${sLender_Name}    
     ${Adjustment}    Acquire Argument Value    ${sAdjustment}
     ${LenderShare}    Acquire Argument Value    ${sLenderShare}
     ${Proposed_Cmt}    Acquire Argument Value    ${sProposed_Cmt}
     ${Outstandings_Amount}    Acquire Argument Value    ${sOutstandings_Amount}
     ${PrimariesTreeBalanceColumn}    Acquire Argument Value    ${sPrimariesTreeBalanceColumn}

    mx LoanIQ activate    ${LIQ_SharesFor_Window}
    ${Lender_HostBank}    Validate Lender If Host Bank In Facility Share Adjustment    ${Lender_Name}
    ${Negative_Adjustment}    Strip String    ${Adjustment}    characters=0123456789,.
    ${NewBalance}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_SharesFor_Primaries_Tree}    ${Lender_Name}%${PrimariesTreeBalanceColumn}%balance
    Run Keyword If    '${LenderShare}'=='${NewBalance}'    Log    Lender Share amount verified.
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_SharesFor_Primaries_Tree}    ${Lender_Name}%d

    ${New_Balance_Exist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_ServicingGroupShare_NewBalance_Text}    VerificationData="Yes"
    ${Actual_Amount_Exist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_ServicingGroupShare_ActualAmount_Field}    VerificationData="Yes"
    ${Adjustment_Exist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_ServicingGroupShare_Adjustment_Textfield}    VerificationData="Yes"

    ${SGShare_NewBalance}    Run Keyword If    '${New_Balance_Exist}'=='True'    Mx LoanIQ Get Data    ${LIQ_ServicingGroupShare_NewBalance_Text}    value%amount
    ...    ELSE IF    '${Actual_Amount_Exist}'=='True'    Mx LoanIQ Get Data    ${LIQ_ServicingGroupShare_ActualAmount_Field}    value%amount

    Run Keyword If    '${New_Balance_Exist}'=='True' and '${LenderShare}'=='${SGShare_NewBalance}'     Log    Servicing Group Share New Balance for ${Lender_Name} verified. 
    Run Keyword If    '${Actual_Amount_Exist}'=='True' and '${LenderShare}'=='${SGShare_NewBalance}'     Log    Servicing Group Share New Balance for ${Lender_Name} verified.

    ${LenderShareAdjusmentField_Locator}    Run Keyword If    '${Adjustment_Exist}'=='True'    Set Variable    ${LIQ_ServicingGroupShare_Adjustment_Textfield}
    ...    ELSE IF    '${Actual_Amount_Exist}'=='True'    Set Variable    ${LIQ_ServicingGroupShare_ActualAmount_Field}

    Run Keyword If    '${Negative_Adjustment}'=='-'    Run Keywords    Mx LoanIQ Click    ${LenderShareAdjusmentField_Locator}
    ...    AND    Mx LoanIQ Send Keys    {RIGHT 1}
    ...    AND    mx LoanIQ send keys    ${Adjustment}
    ...    AND    mx LoanIQ send keys   -
    ...    ELSE    mx LoanIQ enter    ${LenderShareAdjusmentField_Locator}    ${Adjustment}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ViewOrUpdateLenderShares
    mx LoanIQ click    ${LIQ_ServicingGroupShare_OK_Button}
    Run Keyword If    '${Adjustment}'!='0.0'    Validate Lender New Balance After Adjustment    ${Lender_Name}    ${NewBalance}    ${Adjustment}    ${PrimariesTreeBalanceColumn}
    ${Adjustment}    Remove String    ${Adjustment}    -
    ${TranAmount}    Run Keyword If    '${Lender_HostBank}'=='False' and '${Adjustment}'!='0.0'
    ...    Compute Transaction Amount After Facility Lender Share Adjustment    ${Proposed_Cmt}    ${Outstandings_Amount}    ${Adjustment}
    ${NewBalance_AfterAdjust}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_SharesFor_Primaries_Tree}    ${Lender_Name}%${PrimariesTreeBalanceColumn}%balance
    ${New_LenderShare}    Compute New Lender Share Percentage    ${Proposed_Cmt}    ${NewBalance_AfterAdjust}
    
    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRuntimeVar_TranAmount}    ${TranAmount}
    Save Values of Runtime Execution on Excel File    ${sRuntimeVar_LenderShare}   ${New_LenderShare}        
   
    [Return]    ${TranAmount}    ${New_LenderShare}

Compute New Lender Share Percentage
    [Documentation]    This keyword computes for the Lender's new share percentage based from the overall Proposed Cmt and Lender's New Balandce.
    ...                @author: bernchua
    [Arguments]    ${Proposed_Cmt}    ${Lender_NewBalance}
    ${Proposed_Cmt}    Remove String    ${Proposed_Cmt}    , 
    ${Lender_NewBalance}    Remove String    ${Lender_NewBalance}    ,
    ${Proposed_Cmt}    Convert To Number    ${Proposed_Cmt}
    ${Lender_NewBalance}    Convert To Number    ${Lender_NewBalance}
    ${New_LenderShare}    Evaluate    (${Lender_NewBalance}/${Proposed_Cmt})*100
    ${New_LenderShare}    Convert To Integer    ${New_LenderShare}
    ${New_LenderShare}    Catenate    SEPARATOR=    ${New_LenderShare}    %
    [Return]    ${New_LenderShare} 

Validate Lender If Host Bank In Facility Share Adjustment
    [Documentation]    This keyword validates the Lender if it's a Host Bank or not.
    ...    Returns 'True' if Lender is a Host Bank, else 'False'.
    ...    @author: bernchua
    [Arguments]    ${Lender_Name}
    mx LoanIQ activate    ${LIQ_SharesFor_Window}
    ${HostBank_FromUI}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_SharesFor_HostBankShares_Tree}    ${EMPTY}%Legal Entity%name    
    ${Lender_Status}    Run Keyword And Return Status    Should Be Equal As Strings    ${Lender_Name}    ${HostBank_FromUI}
    [Return]    ${Lender_Status}
    
Validate Lender New Balance After Adjustment
    [Documentation]    This keyword validates the Lender's New Balance after entering an Adjustment.
    ...    This keyword returns the difference between the previous and preceding 'New Balance' after adjustmnet, to verify if the Lender has an adjustment or none.
    ...    @author: bernchua
    ...    @update: hstone      18JUN2020     - Added default Argument: ${sPrimariesTreeBalanceColumn}=New Balance
    ...                                       - Getting Balance from Primaries tree using a default variable ${sPrimariesTreeBalanceColumn}
    [Arguments]    ${Lender_Name}    ${NewBalance}    ${Adjustment}    ${sPrimariesTreeBalanceColumn}=New Balance
    ${Adjustment}    Remove String    ${Adjustment}    ,
    ${NewBalance}    Remove String    ${NewBalance}    ,
    ${Adjustment}    Convert To Number    ${Adjustment}
    ${NewBalance}    Convert To Number    ${NewBalance}
    ${NewBalance_Computed}    Evaluate    ${NewBalance}+${Adjustment}
    ${NewBalance_AfterAdj}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_SharesFor_Primaries_Tree}    ${Lender_Name}%${sPrimariesTreeBalanceColumn}%balance
    ${NewBalance_AfterAdj}    Remove String    ${NewBalance_AfterAdj}    ,
    ${NewBalance_AfterAdj}    Convert To Number    ${NewBalance_AfterAdj}
    Run Keyword If    '${NewBalance_Computed}'=='${NewBalance_AfterAdj}'    Log    ${Lender_Name} New Balance after Adustment verified.
    
Adjust Host Bank Portfolio Shares
    [Documentation]    This keyword adjusts the Host Bank's Portfolio Shares.
    ...    @author: bernchua
    ...    @update: ritragel    07MAR19    Removed Branch portfolio verification, no longer needed to verify
    ...    @update: sahalder    01JUL2020    Added keyword pre-processing steps
    ...    @update: dfajardo    07AUG2020    Removed sleep and updated script for editing portfolia share adjustment
    [Arguments]    ${sHostBank_Name}    ${sHostBank_ExpenseCode}    ${sHostBank_Branch}    ${sHostBank_Portfolio}    ${sHostBank_PortfolioShareAdjustment}
    
    ######Pre-Processing keywords####

    ${HostBank_Name}    Acquire Argument Value    ${sHostBank_Name}    
    ${HostBank_ExpenseCode}    Acquire Argument Value    ${sHostBank_ExpenseCode}
    ${HostBank_Branch}    Acquire Argument Value    ${sHostBank_Branch}
    ${HostBank_Portfolio}    Acquire Argument Value    ${sHostBank_Portfolio}
    ${HostBank_PortfolioShareAdjustment}    Acquire Argument Value    ${sHostBank_PortfolioShareAdjustment}

    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_SharesFor_HostBankShares_Tree}    ${HostBank_Name}%d
    
    ${HostBankShare_TreeIsEmpty}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_HostBankShare_BranchPortfolioExpenseCode_EmptyTree}    VerificationData="Yes"
    Run Keyword If    ${HostBankShare_TreeIsEmpty}==True    Run Keywords
    ...    mx LoanIQ click    ${LIQ_HostBankShare_AddPortfolio_Button}
    ...    AND    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PortfolioSelection_Tree}    ${HostBank_ExpenseCode}%s
    ...    AND    mx LoanIQ click    ${LIQ_PortfolioSelection_OK_Button}
    ...    ELSE    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_HostBankShare_BranchPortfolioExpenseCode_Tree}    ${HostBank_ExpenseCode}%d

    Verify If Text Value Exist as Static Text on Page    Portfolio Share Edit    ${HostBank_Branch}
    Verify If Text Value Exist as Static Text on Page    Portfolio Share Edit    ${HostBank_ExpenseCode}
    
    ${Negative_Adjustment}    Strip String    ${HostBank_PortfolioShareAdjustment}    characters=0123456789,.
    Run Keyword If    '${Negative_Adjustment}'=='-'    Run Keywords    Mx LoanIQ Click    ${LIQ_PortfolioShareEdit_Adjustment_Textfield}
    ...    AND    Mx LoanIQ Send Keys    {RIGHT 1}
    ...    AND    mx LoanIQ send keys    ${HostBank_PortfolioShareAdjustment}
    ...    AND    mx LoanIQ send keys   -
    ...    ELSE    mx LoanIQ enter    ${LIQ_PortfolioShareEdit_Adjustment_Textfield}   ${HostBank_PortfolioShareAdjustment}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ViewOrUpdatePorfolioShare
    mx LoanIQ click    ${LIQ_PortfolioShareEdit_OK_Button}
    
    ${HostBankShareAdjustment_Successful}    Verify If Portfolio Share Adjustment Is Successful    ${HostBank_PortfolioShareAdjustment}
    Run Keyword If    ${HostBankShareAdjustment_Successful}==False
    ...    Adjust Host Bank Portfolio Shares    ${HostBank_Name}    ${HostBank_ExpenseCode}    ${HostBank_Branch}    ${HostBank_Portfolio}    ${HostBank_PortfolioShareAdjustment}
    
    :FOR    ${i}    IN RANGE    3
    \    ${HostBankShare_WindowExist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_HostBankShare_Window}    VerificationData="Yes"
    \    Run Keyword If    ${HostBankShare_WindowExist}==True    mx LoanIQ click    ${LIQ_HostBankShare_OK_Button}
    \    Exit For Loop If    ${HostBankShare_WindowExist}==False
    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Host_Bank_Shares_Adjustments
    ${PortfolioShares_UI}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_SharesFor_HostBankShares_Tree}    ${HostBank_Name}%Portfolio Shares%shares
    Run Keyword If    '${PortfolioShares_UI}'=='${HostBank_PortfolioShareAdjustment}'    Log    Portfolio Shares ${HostBank_PortfolioShareAdjustment} displayed for ${HostBank_Name} verified.
    mx LoanIQ click    ${LIQ_SharesFor_OK_Button}
    
Verify If Portfolio Share Adjustment Is Successful
    [Documentation]    This keyword verifies if the Portfolio Shares adjustment is successful and reflected in the Sum of Portfolio Shares.
    ...    Returns 'True' if successful, else 'False'.
    ...    @author: bernchua
    [Arguments]    ${HostBank_PortfolioShareAdjustment}
    ${SumOfPortfolioShares}    Mx LoanIQ Get Data    ${LIQ_HostBankShare_SumOfPortfolioShares_Text}    value%amount
    ${SumOfPortfolioShares}    Remove String    ${SumOfPortfolioShares}    ,
    ${HostBank_PortfolioShareAdjustment}    Remove String    ${HostBank_PortfolioShareAdjustment}    ,
    ${SumOfPortfolioShares}    Convert To Number    ${SumOfPortfolioShares}
    ${HostBank_PortfolioShareAdjustment}    Convert To Number    ${HostBank_PortfolioShareAdjustment}
    ${Adjustment_Status}    Run Keyword And Return Status    Should Be Equal As Numbers    ${SumOfPortfolioShares}    ${HostBank_PortfolioShareAdjustment}            
    [Return]    ${Adjustment_Status}
    
Compute Transaction Amount After Facility Lender Share Adjustment
    [Documentation]    This keyword computes for the Transaction Amount of a Lender based from the Facility Loan Amount after an Adjustment.
    ...    @author: bernchua
    [Arguments]    ${Propost_Cmt}    ${Outstandings_Amount}    ${Adjustment_Amount}
    ${LenderShare_Percent}    Compute Lender Share Percentage After Adjustment    ${Propost_Cmt}    ${Adjustment_Amount}
    ${Outstandings_Amount}    Remove String    ${Outstandings_Amount}    ,
    ${Outstandings_Amount}    Convert To Number    ${Outstandings_Amount}
    ${LenderShare_Percent}    Convert To Number    ${LenderShare_Percent}
    ${LenderShare_Percent}    Evaluate    ${LenderShare_Percent}/100
    ${TransactionAmount}    Evaluate    ${Outstandings_Amount}*${LenderShare_Percent}
    [Return]    ${TransactionAmount}
    
Compute Lender Share Percentage After Adjustment
    [Documentation]    This keyword computes for the Lender's share percentage after adjustment.
    ...    @author: bernchua
    [Arguments]    ${Propost_Cmt}    ${Adjustment_Amount}
    ${Propost_Cmt}    Remove String    ${Propost_Cmt}    ,
    ${Adjustment_Amount}    Remove String    ${Adjustment_Amount}    ,
    ${Propost_Cmt}    Convert To Number    ${Propost_Cmt}    
    ${Adjustment_Amount}    Convert To Number    ${Adjustment_Amount}    
    ${Percentage}    Evaluate    (${Adjustment_Amount}/${Propost_Cmt})*100
    [Return]    ${Percentage}
    
View Lender Shares From Payment Window
    [Documentation]    This keyword selects Option > View/Update Lender Shares from Payment Notebook
    ...    @author: ghabal
    mx LoanIQ activate window    ${LIQ_Payment_Window}
    Sleep    10s    
    mx LoanIQ select    ${LIQ_Payment_Options_ViewUpdateLenderShares}
    mx LoanIQ activate    ${LIQ_SharesFor_Window}     

View Lender Shares From Interest Payment Window
    [Documentation]    This keyword selects Option > View/Update Lender Shares from Payment Notebook
    ...    @author: ghabal
    ...    @update: dahijara    12OCT2020    - Removed hardcoded sleep. Added screenshot
    mx LoanIQ activate window    ${LIQ_Payment_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PaymentWindow
    mx LoanIQ select    ${LIQ_Interest_Options_ViewUpdateLenderShares}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PaymentWindow
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ activate    ${LIQ_SharesFor_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PaymentWindow
    
Validate Lender Shares
    [Documentation]    This keyword validates Lender Shares.
    ...    @author: ghabal
    ...    @update: hstone     20JUN2020     - Added Keyword Pre-processing
    ...                                      - Converted ${sColumnName} to an optional argument for keyword reusability purposes
    ...                                      - Added 'Run Keyword If    '${ColumnName}'!='None' condition before writing to excel
    ...                                      - Added Code Callibrations for handling string inputs and proper decimal conversions:
    ...                                          > ${Computed_LoanIntProjectedCycleDue}    Remove Comma and Convert to Number    ${Computed_LoanIntProjectedCycleDue}
    ...                                          > ${LenderShare}    Evaluate  "%.2f" % ${LenderShare}
    [Arguments]    ${sLender_Name}    ${sLenderSharePercentage}    ${sComputed_LoanIntProjectedCycleDue}    ${sColumnName}=None

    ### Keyword Pre-processing ###
    ${Lender_Name}    Acquire Argument Value    ${sLender_Name}
    ${LenderSharePercentage}    Acquire Argument Value    ${sLenderSharePercentage}
    ${Computed_LoanIntProjectedCycleDue}    Acquire Argument Value    ${sComputed_LoanIntProjectedCycleDue}
    ${ColumnName}    Acquire Argument Value    ${sColumnName}

    mx LoanIQ activate    ${LIQ_SharesFor_Window}
       
    ${Lender_HostBank}    Validate Lender If Host Bank In Facility Share Adjustment    ${Lender_Name}
    ${NewBalance}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_SharesFor_Primaries_Tree}    ${Lender_Name}%Actual Amount%balance
    Log    ${NewBalance}    
    ${NewBalance}    Remove comma and convert to number    ${NewBalance}
    
    ${Computed_LoanIntProjectedCycleDue}    Remove Comma and Convert to Number    ${Computed_LoanIntProjectedCycleDue}
    ${LenderSharePercentage}    Remove Percent sign and Convert to Number    ${LenderSharePercentage}
    ${LenderSharePercentage}    Evaluate    ${LenderSharePercentage}/100            
    ${LenderShare}    Evaluate    ${Computed_LoanIntProjectedCycleDue}*${LenderSharePercentage}
    Log    ${LenderShare}
    ${LenderShare}    Evaluate  "%.2f" % ${LenderShare}
    Run Keyword If    '${ColumnName}'!='None'    Write Data To Excel    CAP03_InterestPayment    ${ColumnName}    ${rowid}    ${LenderShare}
    ${LenderShare}    Convert To String    ${LenderShare}
    Run Keyword And Continue On Failure    Should Be Equal    ${LenderShare}    ${NewBalance}        
    ${result}    Run Keyword And Return Status    Run Keyword And Continue On Failure    Should Be Equal    ${LenderShare}    ${NewBalance}    
    Run Keyword If   '${result}'=='True'    Log    Lender Share amount is verified based on the assigned percentage
    ...     ELSE    Log    Lender Share amount is not verified based on the assigned percentage
    
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_SharesFor_Primaries_Tree}    ${Lender_Name}%d
    ${SGShare_NewBalance}    Mx LoanIQ Get Data    ${LIQ_ServicingGroupShare_ActualAmount_Field}    value%amount
    Log    ${SGShare_NewBalance}
    ${SGShare_NewBalance}    Remove comma and convert to number    ${SGShare_NewBalance}
    Run Keyword And Continue On Failure    Should Be Equal    ${LenderShare}    ${SGShare_NewBalance}        
    ${result}    Run Keyword And Return Status    Run Keyword And Continue On Failure    Should Be Equal    ${LenderShare}    ${SGShare_NewBalance}    
    Run Keyword If   '${result}'=='True'    Log    Lender Share amount is verified based on the assigned percentage
    ...     ELSE    Log    Lender Share amount is not verified based on the assigned percentage

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ViewOrUpdateLenderShares

    ${OKButton_Status}    Run Keyword And Return Status    Element Should Be Enabled    ${LIQ_ServicingGroupShare_OK_Button}         
    Run Keyword If    ${OKButton_Status}==True    Run Keyword    mx LoanIQ click    ${LIQ_ServicingGroupShare_OK_Button}
    Run Keyword If    ${OKButton_Status}==False    Run Keyword    mx LoanIQ click    ${LIQ_ServicingGroupShare_Cancel_Button}

Share Adjustment in Facility
    [Documentation]    This keyword validates Lender Shares.
    ...    @author: Archana
    mx LoanIQ activate    ${LIQ_ShareAdjustmentInFacility}
    mx LoanIQ select    ${LIQ_ShareAdjustment_Options_FacilityNotebook}
    mx LoanIQ activate    ${LIQ_ShareAdjustment_Facility_Window}
    
Close Facility Window
    [Documentation]    This keyword is used to Close facility Window
    ...    @author:Archana
    Mx LoanIQ Close Window    ${LIQ_ShareAdjustment_Facility_Window}    
    
Submit Share Adjustment
    [Documentation]    This keyword is used to submit share adjustment
    ...    @Author:Archana
    ...    @update: hstone     18JUN2020     - Moved from Amendment_Notebook.robot to ShareAdjustment_Notebook.robot
    ...                                      - Added warning confirmation
    ...                                      - Added 'mx LoanIQ activate    ${LIQ_SharesFor_Window}'
    mx LoanIQ activate    ${LIQ_SharesFor_Window}
    Mx LoanIQ Click    ${LIQ_ShareAdjustment_Ok_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}

Add Share Adjustment Comment
    [Documentation]    This keyword is used to add share adjustment comment.
    ...    @author: hstone
    [Arguments]    ${sComment}

    ### Keyword Pre-processing ###
    ${Comment}    Acquire Argument Value    ${sComment}

    mx LoanIQ activate    ${LIQ_SharesFor_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ViewOrUpdateLenderShares
    Mx LoanIQ Click    ${LIQ_SharesFor_Comment_Button}
    mx LoanIQ activate    ${LIQ_CommentEdit_Window}
    mx LoanIQ enter    ${LIQ_CommentEdit_Comment_Text}    ${Comment}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CommentEdit
    Mx LoanIQ Click    ${LIQ_CommentEdit_OK_Button}
    
Navigate to Shared Adjustment Notebook Workflow
    [Documentation]    This keyword navigates the Workflow tab of a Notebook, and does a specific transaction.
    ...    
    ...    | Arguments |
    ...    
    ...    'Transaction' = The type of transaction listed under Workflow. Ex. Send to Approval, Approve, Release
    ...    
    ...    @author: sahalder    01JUL2020    initial create

    [Arguments]    ${sTransaction}    

    ###Pre-processing Keyword##
    
    ${Transaction}    Acquire Argument Value    ${sTransaction} 

    mx LoanIQ activate window    ${LIQ_ShareAdjustment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_ShareAdjustment_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_ShareAdjustment_Workflow_Tree}    ${Transaction}%d
    Validate if Question or Warning Message is Displayed
    Run Keyword If    '${Transaction}'=='Release'    Run Keywords
    ...    Repeat Keyword    2 times    mx LoanIQ click element if present    ${LIQ_BreakFunding_No_Button}
    ...    AND    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    ...    ELSE IF    '${Transaction}'=='Close'    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SharedAdjustment_Notebook_Workflow

Get Host Bank and Lender Shares
    [Documentation]    This keyword navigates from deal notbook to Lender shares and Get the shares percentage for Host bank and Lender.
    ...    @author: dahijara    25AUG2020    initial create
    [Arguments]    ${sHostBank_LegalName}    ${sLender_LegalName}    ${sRunVar_HostBankSharePct}=None    ${sRunVar_LenderSharePct}=None
    ###Pre-processing Keyword##
    ${HostBank_LegalName}    Acquire Argument Value    ${sHostBank_LegalName}
    ${Lender_LegalName}    Acquire Argument Value    ${sLender_LegalName}

    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_DealNotebook_InquiryMode_Button}    VerificationData="Yes"
    Run Keyword If    ${status}==True    mx LoanIQ click    ${LIQ_DealNotebook_InquiryMode_Button}
    ...    ELSE    Run Keyword    Mx LoanIQ Verify Object Exist    ${LIQ_DealNotebook_UpdateMode_Button}    VerificationData="Yes"

    Mx LoanIQ Activate Window    ${LIQ_DealNotebook_Window}      
    Mx LoanIQ Select    ${LIQ_DealNotebook_Queries_LenderShares}
    Mx LoanIQ Activate Window    ${LIQ_LenderShares_Window}
    ${ColumnName}    Set Variable    <PERCENTAGE> of Global
    ${HostBankSharePct_Value}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_LenderShares_PrimariesAssignees_List}    ${HostBank_LegalName}%${ColumnName}%var    Processtimeout=180
    ${LenderSharePct_Value}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_LenderShares_PrimariesAssignees_List}    ${Lender_LegalName}%${ColumnName}%var    Processtimeout=180
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SharedAdjustment
    ### Convert Percentage to Whole Number ###
    ${HostBankSharePct_Value}    Evaluate    ${HostBankSharePct_Value}*100
    ${LenderSharePct_Value}    Evaluate    ${LenderSharePct_Value}*100
	Mx LoanIQ Close Window    ${LIQ_LenderShares_Window}
    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_HostBankSharePct}    ${HostBankSharePct_Value}
    Save Values of Runtime Execution on Excel File    ${sRunVar_LenderSharePct}    ${LenderSharePct_Value}
    [Return]    ${HostBankSharePct_Value}    ${LenderSharePct_Value}

Close Lender Shares Window
    [Documentation]    This keyword closes lender shares Window. 
    ...    @author: dahijara    12OCT2020    - Initial create
    ${OKButton_Status}    Run Keyword And Return Status    Element Should Be Enabled    ${LIQ_SharesFor_OK_Button}         
    Run Keyword If    ${OKButton_Status}==True    Run Keyword    mx LoanIQ click    ${LIQ_SharesFor_OK_Button}
    Run Keyword If    ${OKButton_Status}==False    Run Keyword    mx LoanIQ click    ${LIQ_SharesFor_Cancel_Button}

Get Host Bank Percentage in Lender Shares Window From Loan Notebook
    [Documentation]    This keyword navigates from deal notbook to Lender shares and Get the shares percentage for Host bank and Lender.
    ...    @author: dahijara    25AUG2020    initial create
    [Arguments]    ${sHostBank_LegalName}    ${sRunVar_HostBankSharePct}=None
    ###Pre-processing Keyword##
    ${HostBank_LegalName}    Acquire Argument Value    ${sHostBank_LegalName}

    Mx LoanIQ Activate Window    ${LIQ_Loan_Window}      
    Mx LoanIQ Select    ${LIQ_LoanNotebook_Options_ViewLenderShares}
    Mx LoanIQ Activate Window    ${LIQ_LenderShares_Window}
    ${ColumnName}    Set Variable    <PERCENTAGE> of Global
    ${HostBankSharePct_Value}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_LenderShares_PrimariesAssignees_List}    ${HostBank_LegalName}%${ColumnName}%var    Processtimeout=180
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LenderShares
    ### Convert Percentage to Whole Number ###
    ${HostBankSharePct_Value}    Evaluate    ${HostBankSharePct_Value}*100
	Mx LoanIQ Close Window    ${LIQ_LenderShares_Window}
    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_HostBankSharePct}    ${HostBankSharePct_Value}
    [Return]    ${HostBankSharePct_Value}