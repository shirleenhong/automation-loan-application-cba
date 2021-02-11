*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Charge Upfront Fee for LBT Bilateral Deal
    [Documentation]    This keyword is used to Initiate Upfront Fee Payment for LBT Bilateral Deal.
    ...    @author: javinzon    09FEB2021    - Initial create
    [Arguments]    ${ExcelPath}

    ### Read Excel Data ###
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    ${rowid}
    ${Borrower_Name}    Read Data From Excel    PTY001_QuickPartyOnboarding    LIQCustomer_ShortName    ${rowid}

    Search Existing Deal    ${Deal_Name}
	
	### Upfront Fee Payment-General Tab ###
    Populate Upfront Fee Payment Notebook    &{Excelpath}[UpfrontFee_Amount]    &{Excelpath}[UpfrontFee_EffectiveDate]
    Populate Fee Details Window    &{ExcelPath}[Fee_Type]    &{ExcelPath}[UpfrontFeePayment_Comment]    
	
	## Create Cashflow ###
    Navigate to Upfront Fee Payment Workflow and Proceed With Transaction    ${CREATE_CASHFLOWS_TYPE}
	Set All Items to Do It
	
	### Generate Intent Notice ###
    Navigate to Upfront Fee Payment Workflow and Proceed With Transaction    ${GENERATE_INTENT_NOTICES}
	Exit Notice Window
	
	### Send to Approval ###
    Send to Approval Upfront Fee Payment    
	
	### Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}   ${SUPERVISOR_PASSWORD}
    Navigate to Payment Notebook via WIP    ${PAYMENTS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${FEE_PAYMENT_FROM_BORROWER_TYPE}    ${Deal_Name}
    Approve Upfront Fee Payment
    
    ### Release ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate to Payment Notebook via WIP    ${PAYMENTS_TRANSACTION}    ${AWAITING_RELEASE_STATUS}    ${FEE_PAYMENT_FROM_BORROWER_TYPE}    ${Deal_Name}
    Navigate to Upfront Fee Payment Workflow and Proceed With Transaction    ${RELEASE_STATUS}

    ### Validate Released Event ###
    Close All Windows on LIQ
    Search Existing Deal    ${Deal_Name}
	Validate an Event in Events Tab of Deal Notebook    ${UPFRONTFEE_PAYMENT_FROM_BORROWER_AGENT_RELEASED}    
	Close All Windows on LIQ