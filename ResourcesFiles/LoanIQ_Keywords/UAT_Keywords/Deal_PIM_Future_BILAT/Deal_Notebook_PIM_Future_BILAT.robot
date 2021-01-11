*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Setup Deal for PIM Future BILAT
    [Documentation]    This keyword is for setting up Deal for PIM Future Bilateral Deal
    ...    @author: mcastro    26NOV2020    - Initial create 
    ...    @update: mcastro    09DEC2020    - Added writing of Borrower_Shortname and Deal_Name on SERV01_LoanDrawdown and Correspondence
    ...    @update: mcastro    10DEC2020    - Added writing of Borrower_Shortname on SERV29_CommitmentFeePayment
    ...    @update: mcastro    11DEC2020    - Added writing of Borrower_Shortname and Deal_Name on Correspondence for row 3
    ...    @update: mcastro    14DEC2020    - Added checking of sole lender
    ...    @update: mcastro    15DEC2020    - Added writing of Borrower_Shortname and Deal_Name on Correspondence for row 4 and 5
    ...    @update: mcastro    06JAN2021    - Added writing of Borrower_Shortname and Deal_Name on Correspondence for row 6 and 7
    ...    @update: mcastro    08JAN2021    - Added writing of Borrower_Shortname and Deal_Name on SERV01_LoanDrawdown for 2nd Loan
    [Arguments]    ${ExcelPath}
    
    ${Deal_Name}    ${Deal_Alias}    Generate Deal Name and Alias with 5 Numeric Test Data    &{ExcelPath}[Deal_NamePrefix]    &{ExcelPath}[Deal_AliasPrefix]
    ${Borrower_ShortName}    Read Data From Excel    ORIG03_Customer    LIQCustomer_ShortName    ${rowid}  
    ${Borrower_Location}    Read Data From Excel    ORIG03_Customer    Customer_Location    ${rowid} 
    Write Data To Excel    CRED01_DealSetup    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    CRED01_DealSetup    Deal_Alias    ${rowid}    ${Deal_Alias}
    Write Data To Excel    CRED01_DealSetup    Borrower_ShortName    ${rowid}    ${Borrower_ShortName}
    Write Data To Excel    CRED01_DealSetup    Borrower_Location    ${rowid}    ${Borrower_Location}
    Write Data To Excel    CRED02_FacilitySetup    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    CRED02_FacilitySetup    Facility_Borrower    ${rowid}    ${Borrower_ShortName}
    Write Data To Excel    SERV29_CommitmentFeePayment    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    SERV29_CommitmentFeePayment    Borrower_ShortName    ${rowid}    ${Borrower_ShortName}
    Write Data To Excel    SYND02_PrimaryAllocation    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    SERV01_LoanDrawdown    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    SERV01_LoanDrawdown    Borrower_Name    ${rowid}    ${Borrower_ShortName}
    Write Data To Excel    SERV01_LoanDrawdown    Deal_Name    2    ${Deal_Name}
    Write Data To Excel    SERV01_LoanDrawdown    Borrower_Name    2    ${Borrower_ShortName}
    Write Data To Excel    Correspondence    Notice_Customer_LegalName    ${rowid}    ${Borrower_ShortName}
    Write Data To Excel    Correspondence    Notice_Customer_LegalName    2    ${Borrower_ShortName}
    Write Data To Excel    Correspondence    Notice_Customer_LegalName    3    ${Borrower_ShortName}
    Write Data To Excel    Correspondence    Notice_Customer_LegalName    4    ${Borrower_ShortName}
    Write Data To Excel    Correspondence    Notice_Customer_LegalName    5    ${Borrower_ShortName}
    Write Data To Excel    Correspondence    Notice_Customer_LegalName    6    ${Borrower_ShortName}
    Write Data To Excel    Correspondence    Notice_Customer_LegalName    7    ${Borrower_ShortName}
    Write Data To Excel    Correspondence    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    Correspondence    Deal_Name    2    ${Deal_Name}
    Write Data To Excel    Correspondence    Deal_Name    3    ${Deal_Name}
    Write Data To Excel    Correspondence    Deal_Name    4   ${Deal_Name}
    Write Data To Excel    Correspondence    Deal_Name    5    ${Deal_Name}
    Write Data To Excel    Correspondence    Deal_Name    6    ${Deal_Name}
    Write Data To Excel    Correspondence    Deal_Name    7    ${Deal_Name}
    Write Data To Excel    SERV08_ComprehensiveRepricing    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    SERV08_ComprehensiveRepricing    Borrower_Name    ${rowid}    ${Borrower_ShortName}
    
    Create New Deal    ${Deal_Name}    ${Deal_Alias}    &{ExcelPath}[Deal_Currency]    &{ExcelPath}[Deal_Department]

    ### Summary Tab ###   
    Add Deal Borrower    &{ExcelPath}[Borrower_ShortName]  
    Select Deal Borrower Location and Servicing Group    &{ExcelPath}[Borrower_Location]    &{ExcelPath}[Borrower_SGAlias]    &{ExcelPath}[Borrower_SG_GroupMembers]    &{ExcelPath}[Borrower_PreferredRIMthd]    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Borrower_SG_Name]
    Select Deal Borrower Remmitance Instruction    &{ExcelPath}[Borrower_ShortName]    ${Deal_Name}    &{ExcelPath}[Borrower_Location]    &{ExcelPath}[Borrower_Depositor_Indicator]   
    Select Deal Classification    &{ExcelPath}[Deal_ClassificationCode]    &{ExcelPath}[Deal_ClassificationDesc]
    Set Deal as Sole Lender
    Select Admin Agent    &{ExcelPath}[Deal_AdminAgent]    &{ExcelPath}[AdminAgent_Location]
    Select Servicing group and Remittance Instrucion for Admin Agent    &{ExcelPath}[AdminAgent_SGAlias]    &{ExcelPath}[AdminAgent_RIMethod]    &{ExcelPath}[AdminAgent_SGName]
    Enter Agreement Date    &{ExcelPath}[Deal_AgreementDate]
    Unrestrict Deal

    ### Personnel Tab ###
    Enter Department on Personel Tab    &{ExcelPath}[Deal_DepartmentCode]    &{ExcelPath}[Deal_Department]
    Enter Expense Code    &{ExcelPath}[Deal_ExpenseCode]
    
    ### Calendars Tab ###
    Delete Existing Holiday on Calendar Table
    Add Holiday on Calendar    &{ExcelPath}[HolidayCalendar]
    
    ### Pricing Rules Tab ###
    Add Pricing Option    &{ExcelPath}[Deal_PricingOption]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[PricingOption_BillNoOfDays]    
    ...    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]    &{ExcelPath}[PricingOption_InitialFractionRate]    &{ExcelPath}[PricingOption_RoundingDecimalPrecision]    &{ExcelPath}[PricingOption_RoundingApplicationMethod]      
    ...    &{ExcelPath}[PricingOption_PercentOfRateFormulaUsage]    &{ExcelPath}[PricingOption_RepricingNonBusinessDayRule]    None    &{ExcelPath}[PricingOption_InterestDueUponPrincipalPayment]    &{ExcelPath}[PricingOption_InterestDueUponRepricing]
    ...    None    None    None    None    None    None    None    None    None    &{ExcelPath}[PricingOption_BillBorrower]     

    Add Fee Pricing Rules    &{ExcelPath}[PricingRule_Fee]    &{ExcelPath}[PricingRule_MatrixChangeAppMthd]    &{ExcelPath}[PricingRule_NonBussDayRule]

