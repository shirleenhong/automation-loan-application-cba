*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Create Customer within Loan IQ_TDP
    [Documentation]    This keyword creates Customer within LoanIQ as part of test data preparation (excluded in the main scenarios)
    ...    @author: ghabal
    [Arguments]    ${ExcelPath}          
    
    ${LIQCustomer_ShortName}    ${LIQCustomer_LegalName}    Generate LIQ Customer ShortName and Legal Name and Save it to Excel     &{ExcelPath}[LIQCustomerShortName_Prefix]    &{ExcelPath}[LIQCustomerLegalName_Prefix]    ${rowid}   
    Write Data To Excel    TDP_ORIG03Customer    LIQCustomer_ShortName    ${rowid}    ${LIQCustomer_ShortName}
    Write Data To Excel    TDP_ORIG03Customer    LIQCustomer_LegalName    ${rowid}    ${LIQCustomer_LegalName}
     
    Create New Customer   
    
    ${LIQCustomer_ID}    Get Customer ID and Save it to Excel
    Write Data To Excel    PTY001_QuickPartyOnboarding    Party_ID    ${rowid}    ${LIQCustomer_ID}
    Write Data To Excel    TDP_ORIG03Customer    LIQCustomer_ID    ${rowid}    ${LIQCustomer_ID}
    Write Data To Excel    PTY001_PartyUpdate    Party_ID    ${rowid}    ${LIQCustomer_ID}
    
    Run Keyword If    '${SCENARIO}'=='4'    Run Keywords    Write Data To Excel    SYND05_UpfrontFee_Payment    LIQCustomer_ID    ${rowid}    ${LIQCustomer_ID}    ${ExcelPath}
    ...    AND    Write Data To Excel    SERV22_InterestPayments    LIQCustomer_ID    ${rowid}    ${LIQCustomer_ID}    ${ExcelPath}
    
    ${LIQCustomer_ShortName}    Read Data From Excel    TDP_ORIG03Customer    LIQCustomer_ShortName    ${rowid}      
    ${LIQCustomer_LegalName}    Read Data From Excel    TDP_ORIG03Customer    LIQCustomer_LegalName    ${rowid}          
    Create Customer and Enter Customer ShortName and Legal Name    ${LIQCustomer_ShortName}    ${LIQCustomer_LegalName}    
    Sleep    5s
    
    Add Customer Legal Address Details    &{ExcelPath}[Address_Line1]    &{ExcelPath}[Address_Line2]    &{ExcelPath}[Address_City]    &{ExcelPath}[Address_Country]    &{ExcelPath}[Address_TRA]    &{ExcelPath}[Address_State]    &{ExcelPath}[Address_ZipPostalCode]
    Assign Primary SIC Code    &{ExcelPath}[Primary_SICCode]
    Save Customer Details
    mx LoanIQ close window    ${LIQ_ActiveCustomer_Window}   
    
Create Customer within Loan IQ
    [Documentation]    This keyword creates Customer within LoanIQ
    ...    @author: ghabal
    ...    @update: hstone      04MAY2020    - Added Login/Logout to Loan IQ
    ...                                      - Added Scenario 1 Condition for Writing Test Data
    ...    @update: ehugo       28MAY2020    - updated Scenario 3 field names to Borrower_ShortName
    ...                                      - added writing of LIQCustomer_ShortName in ORIG03_Customer for Scenario 3
    ...    @update: ehugo       26JUN2020    - added Scenario 8 condition for writing test data
    ...    @update: jloretiz    15JUL2020    - Added writing of legal name to loan drawdown
    ...    @update: dahijara    08JUL2020    - updated Scenario 6 test data writing.
    ...    @update: dahijara    21JUL2020    - updated Scenario 8 test data writing.
    ...    @update: dahijara    29JUL2020    - Updatede writing for scenario 1, 4, 5 & 6 for SERV01_LoanDrawdown - Borrower1_LegalName
    [Arguments]    ${ExcelPath}          

    ### Login to LoanIQ###
	Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ${LIQCustomer_ShortName}    ${LIQCustomer_LegalName}    Generate LIQ Customer ShortName and Legal Name and Save it to Excel     &{ExcelPath}[LIQCustomerShortName_Prefix]    &{ExcelPath}[LIQCustomerLegalName_Prefix]    ${rowid}   
    Write Data To Excel    ORIG03_Customer    LIQCustomer_ShortName    ${rowid}    ${LIQCustomer_ShortName}
    Write Data To Excel    ORIG03_Customer    LIQCustomer_LegalName    ${rowid}    ${LIQCustomer_LegalName}
    
    Run Keyword If    '${SCENARIO}'=='1'    Run Keywords    Write Data To Excel    CRED01_DealSetup    Borrower1_ShortName    ${rowid}    ${LIQCustomer_ShortName}
    ...    AND    Write Data To Excel    CRED02_FacilitySetup    Facility_Borrower    ${rowid}    ${LIQCustomer_ShortName}
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Borrower1_ShortName    ${rowid}    ${LIQCustomer_ShortName}
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    LIQCustomer_ShortName    ${rowid}    ${LIQCustomer_ShortName}
    ...    AND    Write Data To Excel    SERV18_Payments    Borrower1_ShortName    ${rowid}    ${LIQCustomer_ShortName}
    ...    AND    Write Data To Excel    SERV18_Payments    Borrower1_LegalName    ${rowid}    ${LIQCustomer_LegalName}
    ...    AND    Write Data To Excel    SERV21_InterestPayments    Loan_Borrower    ${rowid}    ${LIQCustomer_ShortName}
    ...    AND    Write Data To Excel    SERV21_InterestPayments    LIQCustomer_ShortName    ${rowid}    ${LIQCustomer_ShortName}
    ...    AND    Write Data To Excel    SERV21_InterestPayments    Borrower1_ShortName    ${rowid}    ${LIQCustomer_ShortName}
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Borrower1_ShortName    ${rowid}    ${LIQCustomer_ShortName}
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Borrower1_LegalName    ${rowid}    ${LIQCustomer_LegalName}

    Run Keyword If    '${SCENARIO}'=='3'    Run Keywords    Write Data To Excel    SERV05_SBLCIssuance    Customer_Legal_Name    ${rowid}    ${LIQCustomer_LegalName}
    ...    AND    Write Data To Excel    ORIG03_Customer    LIQCustomer_ShortName    ${rowid}    ${LIQCustomer_ShortName}
    ...    AND    Write Data To Excel    SERV05_SBLCIssuance    Borrower_ShortName    ${rowid}    ${LIQCustomer_ShortName}
    ...    AND    Write Data To Excel    SERV05_SBLCIssuance    Customer    ${rowid}    ${LIQCustomer_ShortName}    
    ...    AND    Write Data To Excel    SERV18_FeeOnLenderSharesPayment    Borrower1_ShortName    ${rowid}    ${LIQCustomer_ShortName}
    ...    AND    Write Data To Excel    SERV24_CreateCashflow    Borrower1_ShortName    ${rowid}    ${LIQCustomer_ShortName}
    ...    AND    Write Data To Excel    MTAM05A_CycleShareAdjustment    Borrower1_ShortName    ${rowid}    ${LIQCustomer_ShortName}

    Run Keyword If    '${SCENARIO}'=='2'    Run Keywords    Write Data To Excel    SERV08_ComprehensiveRepricing    Borrower_ShortName    ${rowid}    ${LIQCustomer_ShortName}
    ...    AND    Write Data To Excel    SERV08_ComprehensiveRepricing    Customer_Legal_Name    ${rowid}    ${LIQCustomer_LegalName}
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Borrower_ShortName    ${rowid}    ${LIQCustomer_ShortName}
    ...    AND    Write Data To Excel    SERV01A_LoanDrawdown    Borrower_ShortName    ${rowid}    ${LIQCustomer_ShortName}
    ...    AND    Write Data To Excel    SERV01A_LoanDrawdown    Customer_Legal_Name    ${rowid}    ${LIQCustomer_LegalName}
    ...    AND    Write Data To Excel    CRED01_DealSetup    Deal_Borrower    ${rowid}    ${LIQCustomer_ShortName}
    ...    AND    Write Data To Excel    CRED10_EventFee    Borrower_Name    ${rowid}    ${LIQCustomer_ShortName}
    ...    AND    Write Data To Excel    CRED02_FacilitySetup    Facility_Borrower    ${rowid}    ${LIQCustomer_ShortName}
    ...    AND    Write Data To Excel    SERV21_InterestPayments    Borrower_ShortName    ${rowid}    ${LIQCustomer_ShortName}
    ...    AND    Write Data To Excel    SERV30_AdminFeePayment    SERV30_AdminFeePayment    ${rowid}    ${LIQCustomer_ShortName}
    ...    AND    Write Data To Excel    SERV21_InterestPayments    Borrower_LegalName    ${rowid}    ${LIQCustomer_LegalName}
    ...    AND    Write Data To Excel    SERV30_AdminFeePayment    Customer_LegalName    ${rowid}    ${LIQCustomer_LegalName}
    ...    AND    Write Data To Excel    SERV30_RecurringFee    Borrower_Shortname    ${rowid}    ${LIQCustomer_ShortName}
    ...    AND    Write Data To Excel    SERV20_UnschedPrincipalPayments    Borrower_ShortName    ${rowid}    ${LIQCustomer_ShortName}
    ...    AND    Write Data To Excel    SERV05_SBLCIssuance    Borrower_ShortName    ${rowid}    ${LIQCustomer_ShortName}
    ...    AND    Write Data To Excel    SERV40_BreakFunding    Borrower_ShortName    ${rowid}    ${LIQCustomer_ShortName}
    ...    AND    Write Data To Excel    SERV23_PaperclipTransaction    Borrower_ShortName    ${rowid}    ${LIQCustomer_ShortName}
    ...    AND    Write Data To Excel    SERV05_SBLCIssuance    Customer_Legal_Name    ${rowid}    ${LIQCustomer_LegalName}
    ...    AND    Write Data To Excel    SERV23_PaperclipTransaction    Customer_Legal_Name    ${rowid}    ${LIQCustomer_LegalName}

    Run Keyword If    '${SCENARIO}'=='6'    Run Keywords    Write Data To Excel    CRED01_DealSetup    Deal_Borrower    ${rowid}    ${LIQCustomer_ShortName}
    ...    AND    Write Data To Excel    CRED02_FacilitySetup    Facility_Borrower    ${rowid}    ${LIQCustomer_ShortName}  
    ...    AND    Write Data To Excel    SERV_47_FlexPISchedule    Borrower1_ShortName    ${rowid}    ${LIQCustomer_ShortName} 
    ...    AND    Write Data To Excel    SERV05_SBLCIssuance    Borrower1_ShortName    ${rowid}    ${LIQCustomer_ShortName} 
    ...    AND    Write Data To Excel    SERV23_LoanPaperClip    Borrower1_ShortName    ${rowid}    ${LIQCustomer_ShortName}  
    ...    AND    Write Data To Excel    SERV_47_FlexPISchedule    Borrower1_LegalName    ${rowid}    ${LIQCustomer_LegalName} 
    ...    AND    Write Data To Excel    SERV05_SBLCIssuance    Borrower1_LegalName    ${rowid}    ${LIQCustomer_LegalName}
    ...    AND    Write Data To Excel    SERV23_LoanPaperClip    Borrower1_LegalName    ${rowid}    ${LIQCustomer_LegalName}
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Borrower1_ShortName    ${rowid}    ${LIQCustomer_ShortName}
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Borrower1_ShortName    2    ${LIQCustomer_ShortName}
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Borrower1_LegalName    ${rowid}    ${LIQCustomer_LegalName}
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Borrower1_LegalName    2    ${LIQCustomer_LegalName}    
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Borrower1_LegalName    ${rowid}    ${LIQCustomer_LegalName}

   Run Keyword If    '${SCENARIO}'=='4'    Run Keywords    Write Data To Excel    CRED01_DealSetup    Borrower_ShortName    ${rowid}    ${LIQCustomer_ShortName}
    ...    AND    Write Data To Excel    ORIG03_Customer    LIQCustomer_ShortName    ${rowid}    ${LIQCustomer_ShortName}
    ...    AND    Write Data To Excel    ORIG03_Customer    LIQCustomer_LegalName    ${rowid}    ${LIQCustomer_LegalName}
    ...    AND    Write Data To Excel    PTY001_QuickPartyOnboarding    Enterprise_Name    ${rowid}    ${LIQCustomer_ShortName}
    ...    AND    Write Data To Excel    CRED01_DealSetup    Borrower_ShortName    ${rowid}    ${LIQCustomer_ShortName}
    ...    AND    Write Data To Excel    CRED10_EventFee    Borrower_ShortName    ${rowid}    ${LIQCustomer_ShortName}
    ...    AND    Write Data To Excel    CRED02_FacilitySetup    Borrower_ShortName    ${rowid}    ${LIQCustomer_ShortName}
    ...    AND    Write Data To Excel    SERV30_AdminFeePayment    Borrower_ShortName    ${rowid}    ${LIQCustomer_ShortName}
    ...    AND    Write Data To Excel    SYND05_UpfrontFee_Payment    Borrower_ShortName    ${rowid}    ${LIQCustomer_ShortName}
    ...    AND    Write Data To Excel    SERV02_LoanDrawdownNonAgent    Borrower1_LegalName    ${rowid}    ${LIQCustomer_LegalName}

    Run Keyword If    '${SCENARIO}'=='8'    Write Data To Excel    CRED09_AdminFee    AdminFee_Customer    ${rowid}    ${LIQCustomer_ShortName}

    Create New Customer   
    
    ${LIQCustomer_ID}    Get Customer ID and Save it to Excel
    Write Data To Excel    PTY001_QuickPartyOnboarding    Party_ID    ${rowid}    ${LIQCustomer_ID}
    Write Data To Excel    ORIG03_Customer    LIQCustomer_ID    ${rowid}    ${LIQCustomer_ID}
    # Write Data To Excel    PTY001_PartyUpdate    Party_ID    ${rowid}    ${LIQCustomer_ID}
    
    Run Keyword If    '${SCENARIO}'=='5'    Run Keywords    Write Data To Excel    SERV21_InterestPayments    LIQCustomer_ID    ${rowid}   ${LIQCustomer_ID}
    ...    AND    Write Data To Excel    SERV29_PaymentFees    LIQCustomer_ID    ${rowid}    ${LIQCustomer_ID}
    ...    AND    Write Data To Excel    SERV01_TermLoanDrawdowninUSD    LIQCustomer_ID    ${rowid}    ${LIQCustomer_ID}
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Borrower1_LegalName    ${rowid}    ${LIQCustomer_LegalName}

    Run Keyword If    '${SCENARIO}'=='2'    Write Data To Excel    SERV29_PaymentFees    LIQCustomer_ID    ${rowid}   ${LIQCustomer_ID}   
  
   
    ${LIQCustomer_ShortName}    Read Data From Excel    ORIG03_Customer    LIQCustomer_ShortName    ${rowid}      
    ${LIQCustomer_LegalName}    Read Data From Excel    ORIG03_Customer    LIQCustomer_LegalName    ${rowid}          
    Create Customer and Enter Customer ShortName and Legal Name    ${LIQCustomer_ShortName}    ${LIQCustomer_LegalName}    
    Sleep    5s
    
    Add Customer Legal Address Details    &{ExcelPath}[Address_Line1]    &{ExcelPath}[Address_Line2]    &{ExcelPath}[Address_City]    &{ExcelPath}[Address_Country]    &{ExcelPath}[Address_TRA]    &{ExcelPath}[Address_State]    &{ExcelPath}[Address_ZipPostalCode]
    Assign Primary SIC Code    &{ExcelPath}[Primary_SICCode]
    Save Customer Details
    mx LoanIQ close window    ${LIQ_ActiveCustomer_Window}

    Close All Windows on LIQ
    Logout from Loan IQ
