*** Settings ***
Resource     ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
NonAgent-HostBank Syndicated Deal - Setup Upfront Fees, Bank Role and Ratio
    [Documentation]    This keyword set ups the Upfront Fee, Bank Role, and Ratio for the Non-Agent Syndicated Deal.
    ...    @author: bernchua
    ...    @update: ritragel    30APR2019    Used systemDate for Financial Ratio StartDate
    ...    @update: clanding    29JUL2020    Updated hardcoded values to global variables; removed mx keywords; updated Set Bank Role to Add Bank Role
    [Arguments]    ${ExcelPath}
    
    ###Get System Date###
    ${FinancialRatioStartDate}    Get System Date
    Set Deal Upfront Fees    &{ExcelPath}[UpfrontFee_Category]    &{ExcelPath}[UpfrontFee_Type]    &{ExcelPath}[UpfrontFee_RateBasis]    ${FLAT_AMOUNT_CATEGORY_TYPE}    &{ExcelPath}[UpfrontFee_Amount]
    Validate Upfront Fee Pricing    &{ExcelPath}[UpfrontFee_Category]
    Validate Upfront Fee Pricing    &{ExcelPath}[UpfrontFee_Type]
    Validate Upfront Fee Pricing    &{ExcelPath}[UpfrontFee_Amount]
    Add Bank Role    ${REFERENCE_BANK_ROLE}    &{ExcelPath}[BankRole_Lender]    &{ExcelPath}[BankRole_SGAlias]    &{ExcelPath}[BankRole_SGName]    &{ExcelPath}[BankRole_SGGroupMember]    &{ExcelPath}[BankRole_RIMthd]
    
    Add Financial Ratio    &{ExcelPath}[RatioType1]    &{ExcelPath}[FinancialRatio]    ${FinancialRatioStartDate}
    Add Financial Ratio    &{ExcelPath}[RatioType2]    &{ExcelPath}[FinancialRatio]    ${FinancialRatioStartDate}
    
    ${EffectiveDate}    Get Financial Ratio Type Effective Date and Return    &{ExcelPath}[RatioType1]
    Write Data To Excel    CRED02_FacilitySetup    Facility_AgreementDate    &{ExcelPath}[rowid]    ${EffectiveDate}
    Write Data To Excel    CRED02_FacilitySetup    Facility_EffectiveDate    &{ExcelPath}[rowid]    ${EffectiveDate}

Setup Deal Upfront Fees and Bank Role
    [Documentation]    This keyword adds 1 Upfront Fee and set ups the Bank Role in the Deal Notebook.
    ...    @author: bernchua
    ...    @author: bernchua    10JUL2019    Updated passed argument for Add Bank Role keyword
    [Arguments]    ${ExcelPath}
    Set Deal Upfront Fees    &{ExcelPath}[UpfrontFee_Category]    &{ExcelPath}[UpfrontFee_Type]    &{ExcelPath}[UpfrontFee_RateBasis]    Flat Amount    &{ExcelPath}[UpfrontFee_Amount]
    Validate Upfront Fee Pricing    &{ExcelPath}[UpfrontFee_Category]
    Validate Upfront Fee Pricing    &{ExcelPath}[UpfrontFee_Type]
    Validate Upfront Fee Pricing    &{ExcelPath}[UpfrontFee_Amount]
    Add Bank Role    SBLC/Guarantee Issuer    &{ExcelPath}[BankRole_Lender]    &{ExcelPath}[BankRole_SGAlias]    &{ExcelPath}[BankRole_SGName]    &{ExcelPath}[BankRole_SGGroupMember]
    ...    &{ExcelPath}[BankRole_RIMthd]    &{ExcelPath}[BankRole_Portfolio]    &{ExcelPath}[BankRole_ExpenseCode]    &{ExcelPath}[BankRole_ExpenseCodeDesc]

Setup Upfront Fee for Syndicated Deal With Secondary Sale
    [Documentation]    This keyword sets up the Upfront Fee in a Syndicated Deal for Secondary Sale.
    ...    @author: bernchua
    [Arguments]    ${ExcelPath}
    
    Set Deal Upfront Fees    &{ExcelPath}[UpfrontFee_Category]    &{ExcelPath}[UpfrontFee_Type]    &{ExcelPath}[UpfrontFee_RateBasis]    Formula    &{ExcelPath}[UpfrontFee_Amount]    &{ExcelPath}[UpfrontFee_SpreadType]
    Validate Upfront Fee Pricing    &{ExcelPath}[UpfrontFee_Category]
    Validate Upfront Fee Pricing    &{ExcelPath}[UpfrontFee_Type]
    Validate Upfront Fee Pricing    &{ExcelPath}[UpfrontFee_Amount]    Percent
    Add Lender and Location    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Primary_Lender1]    &{ExcelPath}[Primary_LenderLoc1]    &{ExcelPath}[Primary_RiskBook]    &{ExcelPath}[Primary_TransactionType]
    Set Sell Amount and Percent of Deal    &{ExcelPath}[Primary_PctOfDeal1]
    Add Pro Rate    &{ExcelPath}[Primary_BuySellPrice]
    Verify Buy/Sell Price in Circle Notebook
    Add Contact in Primary    &{ExcelPath}[Primary_Contact1]
    Select Servicing Group on Primaries    &{ExcelPath}[BankRole_SGGroupMember]    &{ExcelPath}[AdminAgent_SGAlias]
    ${SellAmount}    Get Circle Notebook Sell Amount
    Validate Upfront Fee Decisions in Maintenance    &{ExcelPath}[UpfrontFee_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[FeeDecision_Type]    &{ExcelPath}[Distribute_Percent]

Setup Deal Upfront Fees
    [Documentation]    This keyword adds 1 Upfront Fee in the Deal Notebook.
    ...    @author: fmamaril
    ...    @update: dahijara    21OCT2020    - Added writing for scenario 4 - CRED07_UpfrontFee_Payment
    ...    @update: mcastro     23OCT2020    - Added Computation and writing of new upfront fee amount for Scenario 1
    ...    @update: mcastro     28OCT2020    - Added Computation and writing of new upfront fee amount for Scenario 2
    ...    @update: dahijara    04NOV2020    - Added writing for scenario 5 - CRED07_UpfrontFee_Payment
    [Arguments]    ${ExcelPath}
    Set Deal Upfront Fees    &{ExcelPath}[UpfrontFee_Category]    &{ExcelPath}[UpfrontFee_Type]    &{ExcelPath}[UpfrontFee_RateBasis]    &{ExcelPath}[UpfrontFee_CategoryType]    &{ExcelPath}[UpfrontFee_Amount]    &{ExcelPath}[UpfrontFee_SpreadType]
    Validate Upfront Fee Pricing    &{ExcelPath}[UpfrontFee_Category]
    Validate Upfront Fee Pricing    &{ExcelPath}[UpfrontFee_Type]
    Validate Upfront Fee Pricing    &{ExcelPath}[UpfrontFee_Amount]    
    Run Keyword If    '${SCENARIO}'=='4' or '${SCENARIO}'=='5' or '${SCENARIO}'=='3'    Write Data To Excel    CRED07_UpfrontFee_Payment    UpfrontFee_Amount    ${rowid}    &{ExcelPath}[UpfrontFee_Amount]
    
    ${New_Upfrontfee_Amount}    Run Keyword If    '${SCENARIO}'=='1' and '${ExcelPath}[UpfrontFee_CategoryType]'=='Formula'    Compute Upfront Fee Amount Based On Percentage    &{ExcelPath}[UpfrontFee_Amount]
    Run Keyword If    '${SCENARIO}'=='1' and '${ExcelPath}[UpfrontFee_CategoryType]'=='Formula'    Write Data To Excel    CRED07_UpfrontFee_Payment    UpfrontFee_Amount    ${rowid}    ${New_Upfrontfee_Amount}

    ${New_Upfrontfee_Amount}    Run Keyword If    '${SCENARIO}'=='2' and '${ExcelPath}[UpfrontFee_CategoryType]'=='Formula'    Compute Upfront Fee Amount Based On Percentage    &{ExcelPath}[UpfrontFee_Amount]
    Run Keyword If    '${SCENARIO}'=='1' and '${ExcelPath}[UpfrontFee_CategoryType]'=='Formula'    Write Data To Excel    CRED07_UpfrontFee_Payment    UpfrontFee_Amount    ${rowid}    ${New_Upfrontfee_Amount}
    
   
    
    

