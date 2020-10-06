*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Create Loan Split
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
    
    ${Lender1_ShortName}    Read Data From Excel    TRP002_SecondarySale    Buyer_Lender    &{ExcelPath}[rowid]
    ${Lender2_ShortName}    Read Data From Excel    TRP002_SecondarySale    Buyer_Lender_2    &{ExcelPath}[rowid]
    
    ${Lender1_Share}    Read Data From Excel    TRP002_SecondarySale    PctofDeal    1
    ${Lender2_Share}    Read Data From Excel    TRP002_SecondarySale    PctofDeal2    1
    ${HostBankLender_Share}    Evaluate    100-(${Lender1_Share}+${Lender2_Share})
    
    ${BaseRatePercentage}    Get Base Rate from Funding Rate Details    LIBOR    &{ExcelPath}[Repricing_Frequency]    &{ExcelPath}[Currency1]
    ${ExchangeRate}    Get Currency Exchange Rate from Treasury Navigation    ${AUD_TO_USD}        
	${baseRateCode}    Read Data From Excel    CRED01_DealSetup    Deal_PricingOption3    1        
               
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
    
    Write Data To Excel    CAP02_InterestCapitalRule    Loan_Alias    &{ExcelPath}[rowid]    ${Loan_Alias}
    Write Data To Excel    CAP03_InterestPayment    Loan_Alias    &{ExcelPath}[rowid]    ${Loan_Alias}
    
    ${rate}    Set Currency FX Rate    &{ExcelPath}[Currency1]    &{ExcelPath}[Currency2]    ${USE_SPOT_AUD_TO_USD_RATE}    ${ExchangeRate}
    
    ${totalFacilityAmount1}    ${totalPercentageFacility}    Compute F/X Rate and Percentage of Loan    &{ExcelPath}[LoanAmount_1]   ${rate}    ${HostBankLender_Share}
    
    Validate Amounts in Facility Currency    ${totalFacilityAmount1}    ${totalPercentageFacility}
    
    ${hostBankAmount1}    Convert Number With Comma Separators    &{ExcelPath}[LoanAmount_1]
    
    Validate Loan Amounts in General Tab    ${hostBankAmount1}    &{ExcelPath}[Facility_Name]
            
    ### Setup for Repricing for 5MM ###
    Setup Repricing    &{ExcelPath}[Repricing_Add_Option_Setup]    ${BaseRatePercentage}    ${baseRateCode}    &{ExcelPath}[LoanAmount_2]    &{ExcelPath}[Repricing_Frequency]    ${Y}    ${ADD_LOAN_REPRICING}
        
    ${rate}    Set Currency FX Rate    &{ExcelPath}[Currency1]    &{ExcelPath}[Currency2]    ${USE_SPOT_AUD_TO_USD_RATE}    ${ExchangeRate}
    
    ${totalFacilityAmount2}    ${totalPercentageFacility}    Compute F/X Rate and Percentage of Loan    &{ExcelPath}[LoanAmount_2]    ${rate}    ${HostBankLender_Share}
    
    Validate Amounts in Facility Currency    ${totalFacilityAmount2}    ${totalPercentageFacility}
    
    ${hostBankAmount2}    Convert Number With Comma Separators    &{ExcelPath}[LoanAmount_2]
    
    Validate Loan Amounts in General Tab     ${hostBankAmount2}     &{ExcelPath}[Facility_Name]
    
    Change Effective Date for Loan Repricing    ${CurrentDate}
    
    ###Sending the transaction to approval###
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${SEND_TO_APPROVAL_STATUS}

    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ###Approve the transaction###
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
    
    ###Generate Intent Notices###
    ${Customer_LegalName}    Read Data From Excel    ORIG03_Customer    LIQCustomer_LegalName    1
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${GENERATE_RATE_SETTING_NOTICES_TRANSACTION}
    Click OK In Notices Window
    Verify Customer Notice Method    ${Customer_LegalName}    &{ExcelPath}[Notice_BorrowerContactPerson]    ${AWAITING_RELEASE_NOTICE_STATUS}    ${MANAGER_USERNAME}    &{ExcelPath}[Notice_BorrowerMethod]    &{ExcelPath}[BorrowerContact_Email]
    Verify Customer Notice Method    ${Lender1_LegalName}    &{ExcelPath}[Notice_Lender1ContactPerson]    ${AWAITING_RELEASE_NOTICE_STATUS}    ${MANAGER_USERNAME}    &{ExcelPath}[Notice_Lender1Method]    &{ExcelPath}[Lender1Contact_Email]
    Verify Customer Notice Method    ${Lender2_LegalName}    &{ExcelPath}[Notice_Lender2ContactPerson]    ${AWAITING_RELEASE_NOTICE_STATUS}    ${MANAGER_USERNAME}    &{ExcelPath}[Notice_Lender2Method]    &{ExcelPath}[Lender2Contact_Email]
    Close Notice Group Window
    
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}     
    
    ###Release Loan repricing###
    Navigate Transaction in WIP    Outstandings    Awaiting Release    Loan Repricing    &{ExcelPath}[Deal_Name]   
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${RELEASE_STATUS}
    
    
    ###Validate cashflow to encounter an error message###
    Open Cashflow Window from Loan Repricing Menu
    
    ###Compute the percentage amount of host bank###
    ${loanAmount1}    Compute for Percentage of an Amount and Return with Comma Separator    &{ExcelPath}[LoanAmount_1]    &{ExcelPath}[HostBank_Share]
    ${loanAmount2}    Compute for Percentage of an Amount and Return with Comma Separator    &{ExcelPath}[LoanAmount_2]    &{ExcelPath}[HostBank_Share]
    ${totalLoanAmount}    Compute for Percentage of an Amount and Return with Comma Separator    &{ExcelPath}[Total_LoanAmount]    &{ExcelPath}[HostBank_Share]
    
    
    ###Validate GL Entries###
    Validate GL Entries After Release    ${loanAmount2}    ${loanAmount1}    ${totalLoanAmount}
    
    ###Validate status in events tab if already Released###
    Validate Events Tab    &{ExcelPath}[Status]
    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    Search Existing Deal    &{ExcelPath}[Deal_Name]
    
    Search Loan   &{ExcelPath}[OutstandingSelect_Type]    ${DEAL_FACILITY_OPTION}    &{ExcelPath}[Facility_Name]    ${OFF}
    
    ###Validate loan current amount
    Validate Loan Current Amount    &{ExcelPath}[Remaining_LoanAmount]    ${hostBankAmount1}    ${hostBankAmount2}
    
    Close All Windows on LIQ
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    
    ###Validate Global Facility Balanced###
    ${totalOutstanding}    Add Two Values and Convert to Comma Separators    ${totalFacilityAmount1}    ${totalFacilityAmount2}
    Validate Global Facility Amounts - Loan Split     ${totalOutstanding}  
    
    Close All Windows on LIQ