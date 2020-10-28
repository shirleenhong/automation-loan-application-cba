*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
   
*** Keywords ***
SBLC Guarantee Issuance
    [Documentation]    This high-level keyword will cater the creation of Bank Guarantee
    ...    @author: ritragel
    ...    @update: clanding    20JUL202    - removed duplicate writing of SBLC_Alias in SERV05_SBLCIssuance
    ...                                     - added setting to dictionary the written values that are used within the keyword
    [Arguments]    ${ExcelPath}
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Deal Notebook###
	

    ###Outstanding Select Window###
    ${Effective_Date}    Get System Date
    ${Alias}    Create New Outstanding Select - SBLC    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Amount_Requested]
    ...    ${Effective_Date}   &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Expiry_Date]    &{ExcelPath}[Deal_Name]
    Write Data To Excel    SERV05_SBLCIssuance    SBLC_Alias    ${rowid}    ${Alias}  
    ${Alias}    Read Data From Excel    SERV05_SBLCIssuance    SBLC_Alias    ${rowid}
    Set To Dictionary    ${ExcelPath}    SBLC_Alias=${Alias}
    Run Keyword If     '${SCENARIO}'=='3'    Run Keywords    Write Data To Excel    SERV18_FeeOnLenderSharesPayment    SBLC_Alias    ${rowid}    ${Alias}
    ...    AND    Write Data To Excel    MTAM05A_CycleShareAdjustment    SBLC_Alias    ${rowid}    ${Alias}
    ...    AND    Write Data To Excel    SERV05_SBLCIssuance    Existing_Standby_Letters_of_Credit_Alias    ${rowid}    ${Alias}
    ...    AND    Write Data To Excel    SERV05_SBLCDecrease    Existing_Standby_Letters_of_Credit_Alias    ${rowid}    ${Alias}
        
    Run Keyword If    '${SCENARIO}'=='2'     Run Keywords    Write Data To Excel    SERV23_PaperclipTransaction    SBLC_Alias    ${rowid}    ${Alias}
    ...    AND    Write Data To Excel    SERV05_SBLCIssuance    SBLC_Alias    ${rowid}    ${Alias}
        
    ###SBLC Notebook###
    Verify Pricing Formula    &{ExcelPath}[Issuance_Fee]    &{ExcelPath}[Cycle_Frequency]    &{ExcelPath}[AccrualRule_PayInAdvance]
    Add Banks    &{ExcelPath}[Borrower_ShortName]    

    Complete Workflow Items    &{ExcelPath}[Customer_Legal_Name]    &{ExcelPath}[SBLC_Status]   
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Transaction in Process###
    Navigate Transaction in WIP    &{ExcelPath}[Transaction_Type]    &{ExcelPath}[Transaction_Status_Awaiting_Approval]    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[SBLC_Alias]
    
    ###SBLC Notebook###
    Approve SBLC Issuance
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ###Transaction In Process###
    Navigate Transaction in WIP    &{ExcelPath}[Transaction_Type]    &{ExcelPath}[Transaction_Status_Awaiting_Release]    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[SBLC_Alias]
    
    ###SBLC Notebook###
    Release SLBC Issuance in Workflow        
    Verify SBLC Issuance Status        &{ExcelPath}[Deal_Name]    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[SBLC_Alias]    &{ExcelPath}[Cycle_Number]   

    ###LIQ Window###
    Close All Windows on LIQ
    
SBLC Guarantee Issuance for Bilateral Deal with Multiple Risk Types
    [Documentation]    This keyword is for SBLC Guarantee Issuance for Bilateral Deal with Multiple Risk Types.
    ...    @author: ghabal  
    ...    @update: rtarayao    12MAR2019    Updated the Read Data, Write Data, and low level keywords used.
    ...    @update: fmamaril    12OCT2019    Replace variables and update spacing   
    [Arguments]    ${ExcelPath}
    
    ###Current Date Fetching###
    ${sSystemDate}    Get System Date
    Write Data To Excel    SERV05_SBLCIssuance    Effective_Date    ${rowid}    ${sSystemDate}    
    
    ###Search for the Exisitng Deal###
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ###Deal Notebook >> SBLC Creation###
    ${SBLC_Alias}    Create New Outstanding Select    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Amount_Requested]    &{ExcelPath}[Pricing_Option]    ${sSystemDate}    &{ExcelPath}[Expiry_Date]
    Write Data To Excel    SERV05_SBLCIssuance    SBLC_Alias    ${rowid}    ${SBLC_Alias}
    ${SBLC_Alias}   Read Data From Excel    SERV05_SBLCIssuance    SBLC_Alias    ${rowid}
        
    ###SBLC Issuance Window >> Rates Tab >> Validation of Pricing Fees###
    Verify Pricing Formula    &{ExcelPath}[Issuance_Fee]    &{ExcelPath}[Cycle_Frequency]

    ###SBLC Issuance Window >> Banks Tab >> Adding of Beneficiary###
    Add Banks for Bilateral Deal with Multiple Risk Types    &{ExcelPath}[Borrower1_ShortName]   
     
    ###SBLC Issuance Window >> Codes Tab###
    Add Purpose    &{ExcelPath}[Purpose]
    
    ###SBLC Issuance Window >> Workflow (Send to Approval)###   
    Navigate Notebook Workflow_SBLCIssuance   Send to Approval
    
    ###Loan IQ Desktop###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Deal Notebook###
    Search for Deal    &{ExcelPath}[Deal_Name]
    
    ###SBLC Issuance Window >> Workflow (Send Notices)###
    Navigate to SBLC Guarantee Notebook with Pending Status    &{ExcelPath}[Facility_Name]    ${SBLC_Alias}    &{ExcelPath}[OutstandingSelect_Type]
    Navigate Notebook Workflow_SBLCIssuance    Approval
    Close All Windows on LIQ
    
    ###Work in Process window >> Deal Validation###
    Verify SBLC in Work in Process    &{ExcelPath}[Deal_Name]   
    Close All Windows on LIQ
    
    ###Loan IQ Desktop###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ###Deal Notebook###
    Search for Deal   &{ExcelPath}[Deal_Name]
    
    ###SBLC Issuance Window >> Workflow Tab (Transaction Release)###
    Search SBLC Guarantee Issuance    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]    ${SBLC_Alias}    
    Release SLBC Issuance in Workflow        
    Close All Windows on LIQ
    
    ###Loan IQ Desktop###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###SBLC Issuance Window >> Rates Tab/Events Tab/Accrual Tab (Released Transaction Validation)###
    Verify SBLC Issuance Status for Bilateral Deal with Multiple Risk Types    &{ExcelPath}[Deal_Name]    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]    ${SBLC_Alias}    &{ExcelPath}[Cycle_Number]
    Close All Windows on LIQ

Set Up SLBC Decrease
    [Documentation]    This keyword will setup SBLC decrease in a deal
    ...    @author: jdelacru
    ...    @update: fmamaril    30APR2019    Apply standards on the keyword
    ...    @update: clanding    27JUL2020    Updataed hard coded values to global variable
    [Arguments]    ${ExcelPath}
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Existing Standby Letters of Credit###
    Verify if Standby Letters of Credit Exist    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Type]    &{ExcelPath}[Search_By]    &{ExcelPath}[Facility_Name]
      
    ###Existing Standby Letters of Credit for Deal###
    Set Up Existing Letters of Credit Settings for SBLC Decrease    &{ExcelPath}[Existing_Standby_Letters_of_Credit_Alias]
    
    ###Bank Guarantee/Letter of Credit/Synd Fronted Bank###
    Populate Bank Guarantee/Letter of Credit/Synd Fronted Bank Decrease Fields    &{ExcelPath}[Requested_Amount]    &{ExcelPath}[Reason]
    
    ###SBLC Decrease###
    Validate View/Update Lender Shares Details    &{ExcelPath}[Currency]    &{ExcelPath}[Existing_Standby_Letters_of_Credit_Alias]    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Legal_Entity]    &{ExcelPath}[Requested_Amount]    &{ExcelPath}[Non_Loan_Amount]
    Validate View/Update Issuing Bank Shares Details    &{ExcelPath}[Currency]    &{ExcelPath}[Existing_Standby_Letters_of_Credit_Alias]    &{ExcelPath}[Legal_Entity]    &{ExcelPath}[Requested_Amount]    &{ExcelPath}[Non_Loan_Amount]
    
    Send SBLC Decrease for Approval

    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}

    ###Work In Process Window###
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${SBLC_GUARANTEE_DECREASE_TYPE}     &{ExcelPath}[Facility_Name]
    
    ###Ongoing Fee Payment Notebook - Workflow Tab### 
    Approve SBLC Decrease
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}

    ###Transactions in Process###
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_RELEASE_STATUS}    ${SBLC_GUARANTEE_DECREASE_TYPE}     &{ExcelPath}[Facility_Name]             
    Release SBLC Decrease

    ###Loan IQ Desktop###    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
