*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Variables ***
${rowid}    1
${SCENARIO}    0

*** Keywords ***
Create Party in Quick Party Onboarding
    [Documentation]    This keyword is used to create party via quick party Onboarding screen.
    ...    @author: 
    ...    @update: fmamaril    17APR2019    - Update column for writing of Borrower in relation to Ongoing Fee payment
    ...    @update: fmamaril    22APR2019    - Add handling for logout when SSO is not enabled
    ...    @update: fmamaril    29APR2019    - Add saving of Borrower for Baseline SBLC
    ...    @update: jdelacru    16OCT2019    - Corrected writing for SERV29_PaymentFees
    ...    @update: fmamaril    28OCT2019    - Add saving of Borrower for SERV13_InterestCapitalization
    ...    @update: jdelacru    10DEC2019    - removed ${Business_Focus}, ${Business_Type}, ${Date_Formed}, ${State_Province}, 
    ...                                        ${Email_Contact_Type}, ${Email}, ${Confirm_Email}, ${Mobile_Contact_Type}, ${Country_Code},  
    ...                                        and ${Number} as arguments in Populate Quick Enterprise Party
    ...                                      - corrected user login and arguments for approving party
    ...    @update: amansuet    18MAR2020    - updated based on automation standard guidelines and moved keyword to the correct robot file.
    ...    @update: dahijara    27APR2020    - refactored entire script.
    ...    @update: dahijara    09JUN2020    - Added code to update Zone and Branch
    [Arguments]    ${ExcelPath}
    
    ### INPUTTER ###

    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL} 

    Configure Zone and Branch    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]

    Search Process in Party    &{ExcelPath}[Selected_Module]

    ${Entity}    ${Assigned_Branch}    Populate Party Onboarding    &{ExcelPath}[Locality]    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]    &{ExcelPath}[Branch_Code]
    
    Validate Pre-Existence Check Page Values and Field State    &{ExcelPath}[Locality]    ${Entity}    ${Assigned_Branch}    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]
    ${Enterprise_Name}    ${Party_ID}    Populate Pre-Existence Check    &{ExcelPath}[Enterprise_Prefix]
    ${Short_Name}    Get Short Name Value and Return    &{ExcelPath}[Short_Name_Prefix]    ${Party_ID}
    Run Keyword If    '${SCENARIO}'=='0'    Write Data To Excel    Party_Dataset    Party_ID    ${rowid}    ${Party_ID}

    Populate Quick Enterprise Party    ${Party_ID}    &{ExcelPath}[Country_of_Tax_Domicile]    &{ExcelPath}[Country_of_Registration]
    ...    &{ExcelPath}[Address_Type]    &{ExcelPath}[Country_Region]    &{ExcelPath}[Post_Code]    &{ExcelPath}[Document_Collection_Status]
    ...    &{ExcelPath}[Industry_Sector]    &{ExcelPath}[Business_Activity]    &{ExcelPath}[Is_Main_Activity]
    ...    &{ExcelPath}[GST_Number]    &{ExcelPath}[Address_Line_1]    &{ExcelPath}[Address_Line_2]    &{ExcelPath}[Town_City]    
    ...    &{ExcelPath}[State_Province]    &{ExcelPath}[Business_Country]    &{ExcelPath}[Is_Primary_Activity]    &{ExcelPath}[Registered_Number]    ${Short_Name}    
    ...    &{ExcelPath}[Address_Line_3]    &{ExcelPath}[Address_Line_4]

    Run Keyword If    '${SSO_ENABLED}'=='NO'    Logout User on Party
    Close Browser
    
    ### SUPERVISOR ###
    ${Task_ID_From_Supervisor}    Approve Party via Supervisor Account    ${Party_ID}    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]
    
    ### INPUTTER ###
    Accept Approved Party and Validate Details in Enterprise Summary Details Screen    ${Task_ID_From_Supervisor}    ${Party_ID}    &{ExcelPath}[Locality]    ${Entity}    ${Assigned_Branch}    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]
    ...    &{ExcelPath}[Party_Category]    ${Enterprise_Name}    &{ExcelPath}[Registered_Number]    &{ExcelPath}[Country_of_Registration]    &{ExcelPath}[Country_of_Tax_Domicile]    ${Short_Name}    
    ...    &{ExcelPath}[Business_Country]    &{ExcelPath}[Industry_Sector]    &{ExcelPath}[Business_Activity]    &{ExcelPath}[Is_Main_Activity]    &{ExcelPath}[Is_Primary_Activity]    &{ExcelPath}[GST_Number]
    ...    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]

    Validate Party Details in Loan IQ    ${Party_ID}    ${Short_Name}    ${Enterprise_Name}    &{ExcelPath}[GST_Number]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Business_Activity]    &{ExcelPath}[Business_Country]
    ...    &{ExcelPath}[Address_Type]    &{ExcelPath}[Address_Line_1]    &{ExcelPath}[Address_Line_2]    &{ExcelPath}[Town_City]    &{ExcelPath}[Country_of_Registration]
    ...    &{ExcelPath}[Country_of_Tax_Domicile]    &{ExcelPath}[Post_Code]

##################################################################################################################
####################################### DATA WRITING FOR SCENARIO SCRIPTS ########################################
##################################################################################################################

    Run Keyword If    '${SCENARIO}'=='1'    Run Keywords    Write Data To Excel    CRED01_DealSetup    Borrower1_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    CRED02_FacilitySetup    Facility_Borrower    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    ORIG03_Customer    LIQCustomer_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    ORIG03_Customer    LIQCustomer_LegalName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    PTY001_QuickPartyOnboarding    Enterprise_Name    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Borrower1_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    LIQCustomer_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV18_Payments    Borrower1_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV18_Payments    Borrower1_LegalName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV21_InterestPayments    Loan_Borrower    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV21_InterestPayments    LIQCustomer_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV21_InterestPayments    Borrower1_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Borrower1_ShortName    ${rowid}    ${Enterprise_Name}
  
    Run Keyword If    '${SCENARIO}'=='2'    Run Keywords    Write Data To Excel    SERV08_ComprehensiveRepricing    Borrower_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV08_ComprehensiveRepricing    Customer_Legal_Name    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Borrower_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV01A_LoanDrawdown    SERV01A_LoanDrawdown    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV01A_LoanDrawdown    Customer_Legal_Name    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    CRED01_DealSetup    Deal_Borrower    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    CRED10_EventFee    Borrower_Name    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    CRED02_FacilitySetup    Facility_Borrower    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV21_InterestPayments    Borrower_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV30_AdminFeePayment    Borrower_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV21_InterestPayments    Borrower_LegalName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV30_AdminFeePayment    Customer_LegalName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV33_RecurringFee    Borrower_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV20_UnschedPrincipalPayments    Borrower_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV20_UnschedPrincipalPayments    Customer_LegalName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV30_AdminFeePayment    Borrower_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV05_SBLCIssuance    Borrower_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV40_BreakFunding    Borrower_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV23_PaperclipTransaction    Borrower_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV05_SBLCIssuance    Customer_Legal_Name    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV23_PaperclipTransaction    Customer_Legal_Name    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV33_RecurringFee    Borrower_ShortName    ${rowid}    ${Enterprise_Name}    

    Run Keyword If    '${SCENARIO}'=='3'    Run Keywords    Write Data To Excel    CRED01_DealSetup    Deal_Borrower    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    CRED02_FacilitySetup    Facility_Borrower    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    ORIG03_Customer    LIQCustomer_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    ORIG03_Customer    LIQCustomer_LegalName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    PTY001_QuickPartyOnboarding    Enterprise_Name    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV05_SBLCIssuance    Borrower_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV18_FeeOnLenderSharesPayment    Borrower1_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV24_CreateCashflow    Borrower1_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    MTAM05A_CycleShareAdjustment    Borrower1_ShortName    ${rowid}    ${Enterprise_Name}

   Run Keyword If    '${SCENARIO}'=='4'    Run Keywords    Write Data To Excel    CRED01_DealSetup    Borrower_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    ORIG03_Customer    LIQCustomer_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    ORIG03_Customer    LIQCustomer_LegalName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    PTY001_QuickPartyOnboarding    Enterprise_Name    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    CRED01_DealSetup    Borrower_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    CRED10_EventFee    Borrower_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    CRED02_FacilitySetup    Borrower_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV30_AdminFeePayment    Borrower_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SYND05_UpfrontFee_Payment    Borrower_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    CRED09_AdminFee    Borrower_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Borrower_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV22_InterestPayments    Borrower_ShortName    ${rowid}    ${Enterprise_Name}

    Run Keyword If    '${SCENARIO}'=='5'    Run Keywords    Write Data To Excel    CRED01_DealSetup    Deal_Borrower    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    CRED02_FacilitySetup    Facility_Borrower    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    CRED10_EventFee    Borrower_Name    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    ORIG03_Customer    LIQCustomer_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    ORIG03_Customer    LIQCustomer_LegalName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    PTY001_QuickPartyOnboarding    Enterprise_Name    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV01A_TermAndSBLC    Loan_Borrower    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV01A_TermAndSBLC    LIQCustomer_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV01A_TermAndSBLC    Borrower_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV01A_TermAndSBLC    Customer_Legal_Name    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV01_TermLoanDrawdowninUSD    Borrower1_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV08C_ComprehensiveRepricing    Borrower_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV08C_ComprehensiveRepricing    Customer_Legal_Name    ${rowid}    ${Enterprise_Name}

    ...    AND    Write Data To Excel    SERV13_InterestCapitalization    Borrower1_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV21_InterestPayments    Loan_Borrower    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV21_InterestPayments    Borrower_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV21_InterestPayments    Borrower_LegalName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV29_PaymentFees    LIQ_Borrower    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV30_AdminFeePayment    Borrower_Name    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV30_AdminFeePayment    Customer_LegalName    ${rowid}    ${Enterprise_Name}
    
    Run Keyword If    '${SCENARIO}'=='6'    Run Keywords    Write Data To Excel    CRED01_DealSetup    Deal_Borrower    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    ORIG03_Customer    LIQCustomer_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    ORIG03_Customer    LIQCustomer_LegalName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    CRED02_FacilitySetup    Facility_Borrower    ${rowid}    ${Enterprise_Name} 
    ...    AND    Write Data To Excel    PTY001_QuickPartyOnboarding    Enterprise_Name    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV01_47_FlexPISchedule    Borrower1_ShortName    ${rowid}    ${Enterprise_Name} 
    ...    AND    Write Data To Excel    SERV05_SBLCIssuance    Borrower1_ShortName    ${rowid}    ${Enterprise_Name} 
    ...    AND    Write Data To Excel    SERV23_LoanPaperClip    Borrower1_ShortName    ${rowid}    ${Enterprise_Name}  
    ...    AND    Write Data To Excel    SERV01_47_FlexPISchedule    Borrower1_LegalName    ${rowid}    ${Enterprise_Name} 
    ...    AND    Write Data To Excel    SERV05_SBLCIssuance    Borrower1_LegalName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV23_LoanPaperClip    Borrower1_LegalName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Borrower1_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Borrower1_ShortName    2    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV18_Payments    Borrower1_ShortName    ${rowid}    ${Enterprise_Name}
    
    Run Keyword If    '${SCENARIO}'=='7'    Run Keywords    Write Data To Excel    CRED01_DealSetup    Borrower1_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    CRED02_FacilitySetup    Facility_Borrower    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    ORIG03_Customer    LIQCustomer_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    ORIG03_Customer    LIQCustomer_LegalName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    PTY001_QuickPartyOnboarding    Enterprise_Name    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Borrower1_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    LIQCustomer_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV18_Payments    Borrower1_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV18_Payments    Borrower1_LegalName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV21_InterestPayments    Loan_Borrower    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV21_InterestPayments    LIQCustomer_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV21_InterestPayments    Borrower1_ShortName    ${rowid}    ${Enterprise_Name}
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Borrower1_ShortName    ${rowid}    ${Enterprise_Name}

