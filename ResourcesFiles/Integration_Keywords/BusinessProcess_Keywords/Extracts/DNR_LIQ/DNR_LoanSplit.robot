*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Create Loan Split For DNR
    [Documentation]    This keyword will perform loan split
    ...                @author: mnanquil
    ...                @update: bernchua    08MAR2019    Delete old API scripts to be updated with new Transformation Layer automated scripts
    ...                @update: bernchua    12MAR2019    Updated keyword for changing the Effective Date of the Loan Repricing
    ...                @update: bernchua    12MAR2019    Updated keywords used for Workflow & WIP navigation with "Navigate Notebook Workflow" & "Navigate Transaction in WIP".
    ...                @update: dahijara    23SEP2020    Removed wait keywords when getting BaseRatePercentage & ExchangeRate
    ...                                                  Added keywords to get Lender legal names via Lender shares for intent notice validation
    ...                                                  Replaced hard coded values with global variables
    ...                                                  Replaced navigation to Loan Repricing workflow window
    ...                                                  Updated data being passed for Verify Customer Notice Method (Borrower, lender1 and Lender2 information)
    ...                                                  Updated navigation for Open Cashflow Window from Loan Repricing Menu
    [Arguments]    ${ExcelPath}
	
	${CurrentDate}    Get System Date
    
    ${Lender1_ShortName}    Read Data From Excel    SC2_SecondarySale    Buyer_Lender    &{ExcelPath}[rowid]    ${DNR_DATASET}
    ${Lender2_ShortName}    Read Data From Excel    SC2_SecondarySale    Buyer_Lender_2    &{ExcelPath}[rowid]    ${DNR_DATASET}
    
    ${Lender1_Share}    Read Data From Excel    SC2_SecondarySale    PctofDeal    &{ExcelPath}[rowid]    ${DNR_DATASET}
    ${Lender2_Share}    Read Data From Excel    SC2_SecondarySale    PctofDeal2    &{ExcelPath}[rowid]    ${DNR_DATASET}
    ${Borrower_ShortName}    Read Data From Excel    SC2_DealSetup    Borrower_ShortName    &{ExcelPath}[rowid]    ${DNR_DATASET}
    ${HostBankLender_Share}    Evaluate    &{ExcelPath}[Total_Share]-(${Lender1_Share}+${Lender2_Share})
    
    ${BaseRatePercentage}    Get Base Rate from Funding Rate Details    &{ExcelPath}[FundingRate_Alias]    &{ExcelPath}[Repricing_Frequency]    &{ExcelPath}[Currency1]
    ${ExchangeRate}    Get Currency Exchange Rate from Treasury Navigation    ${AUD_TO_USD}        
	${baseRateCode}    Read Data From Excel    SC2_DealSetup    Deal_PricingOption3    &{ExcelPath}[rowid]    ${DNR_DATASET}        
               
    ###LIQ Window
    Search Existing Deal    &{ExcelPath}[Deal_Name]
    
	### GET CUSTOMER LENDER LEGAL NAME TO BE USED IN INTENT NOTICE VALIDATION ###
    ${Lender1_LegalName}    Get Customer Lender Legal Name Via Lender Shares In Deal Notebook    ${Lender1_ShortName}
    ${Lender2_LegalName}    Get Customer Lender Legal Name Via Lender Shares In Deal Notebook    ${Lender2_ShortName}
    
    ###Deal Notebook
    Search Loan   &{ExcelPath}[OutstandingSelect_Type]    ${DEAL_FACILITY_OPTION}    &{ExcelPath}[Facility_Name]    ${OFF}
    
    ###Selection of loan to reprice###
    Select Loan to Reprice    &{ExcelPath}[Loan_Alias]
    Select Repricing Type    ${COMPREHENSIVE_REPRICING}  
    Select Loan Repricing for Deal    &{ExcelPath}[Loan_Alias]
    
    
    ### Setup for Repricing for 10MM ###  
    ${Loan_Alias}    Setup Repricing    &{ExcelPath}[Repricing_Add_Option_Setup]    ${BaseRatePercentage}    ${baseRateCode}    &{ExcelPath}[LoanAmount_1]    &{ExcelPath}[Repricing_Frequency]    ${Y}    ${ADD_LOAN_REPRICING}        
           
    ### Setup for Repricing for 5MM ###
    Setup Repricing    &{ExcelPath}[Repricing_Add_Option_Setup]    ${BaseRatePercentage}    ${baseRateCode}    &{ExcelPath}[LoanAmount_2]    &{ExcelPath}[Repricing_Frequency]    ${Y}    ${ADD_LOAN_REPRICING}
     
    Mx LoanIQ Close    ${LIQ_PendingRollover_Window}
    Setup Repricing    &{ExcelPath}[Repricing_Add_Option_Setup_2]    ${BaseRatePercentage}    ${baseRateCode}    &{ExcelPath}[LoanAmount_2]    &{ExcelPath}[Repricing_Frequency]    ${Y}    ${ADD_LOAN_REPRICING}        
    
    ### Cashflows Notebook - Create Cashflows ###
    Navigate to Create Cashflow for Loan Repricing
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    Verify if Method has Remittance Instruction    ${Borrower_ShortName}    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Method has Remittance Instruction    ${Lender1_ShortName}    &{ExcelPath}[Remittance2_Description]    &{ExcelPath}[Remittance2_Instruction]
    Verify if Method has Remittance Instruction    ${Lender2_ShortName}    &{ExcelPath}[Remittance3_Description]    &{ExcelPath}[Remittance3_Instruction]
    
    Create Cashflow    &{ExcelPath}[Lender1_ShortName]    ${RELEASE_TRANSACTION}
    ###Sending the transaction to approval###
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${SEND_TO_APPROVAL_STATUS}
    
    Write Data To Excel    SC2_LoanSplit    Effective_Date    &{ExcelPath}[rowid]    ${CurrentDate}    ${DNR_DATASET}
    Write Data To Excel    SC2_LoanSplit    Borrower_Name    &{ExcelPath}[rowid]    ${Borrower_ShortName}    ${DNR_DATASET}
    Write Data To Excel    SC2_LoanSplit    HostBank_Share    &{ExcelPath}[rowid]    ${HostBankShare}    ${DNR_DATASET}
    
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ##Approve the transaction###
    Navigate Transaction in WIP    Outstandings    Awaiting Approval    Loan Repricing    &{ExcelPath}[Deal_Name]
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${APPROVAL_STATUS}
    
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Sending loan to rates approval###
    Navigate Transaction in WIP    Outstandings    Awaiting Send to Rate Approval    Loan Repricing    &{ExcelPath}[Deal_Name]
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${SEND_TO_RATE_APPROVAL_STATUS}
    
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ###Approve Rates###
    Navigate Transaction in WIP    Outstandings    Awaiting Rate Approval    Loan Repricing    &{ExcelPath}[Deal_Name]
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${RATE_APPROVAL_STATUS}
    
    
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}     
    
    ###Release Loan repricing###
    Navigate Transaction in WIP    Outstandings    Awaiting Release    Loan Repricing    &{ExcelPath}[Deal_Name]   
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${RELEASE_STATUS}
    
    Close All Windows on LIQ
    
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}