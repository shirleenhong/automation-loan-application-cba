*** Settings ***
Resource    ../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1
${SCENARIO}    6

*** Test Cases ***
Create Quick Party Onboarding - PTY001
    [Tags]    01 Create Party within Essence - PTY001                  
    Mx Execute Template With Multiple Data    Create Party in Quick Party Onboarding    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding

# Create Customer within Loan IQ - ORIG03
    # [Documentation]    This keyword creates Customer within LoanIQ
    # ...    @author: ghabal
    # [Tags]    01 Create Customer within Loan IQ - ORIG03
    # Mx Execute Template With Multiple Data    Create Customer within Loan IQ    ${ExcelPath}    ${rowid}    ORIG03_Customer
    
Search Customer and Complete its Borrower Profile Creation - ORIG03
    [Documentation]    This keyword searches a customer and complete its Borrower Profile creation
    ...    @author: ghabal
    [Tags]    02 Complete Borrower's Profile - 0RIG03
    Mx Execute Template With Multiple Data    Search Customer and Complete its Borrower Profile Creation with default values    ${ExcelPath}    ${rowid}    ORIG03_Customer
       
Bilateral Deal with Multiple Risk Type        
    [Documentation]    This keyword will be used to create Bilateral deal for Scenario 6
    ...    @author: ritragel  
    [Tags]    03 Create Bilateral Deal with Multiple Risk Type - CRE06
    Mx Execute Template With Multiple Data    Setup Bilateral Deal with Multiple Risk Type    ${ExcelPath}    ${rowid}    CRED01_DealSetup
    Mx Execute Template With Multiple Data    Add Pricing Option for Bilateral Deal with MultiRisk Types    ${ExcelPath}    101-105    CRED01_PricingOption
    Mx Execute Template With Multiple Data    Setup Multi-Currency and Multi-Risk Revolver Facility    ${ExcelPath}    ${rowid}    CRED02_FacilitySetup
    Mx Execute Template With Multiple Data    Setup Interest Pricing Fees for Multi-Currency and Multi-Risk Revolver Facility    ${ExcelPath}    101-104    CRED08_RevFacilityInterestFee
    Mx Execute Template With Multiple Data    Setup Ongoing Fees for Multi-Currency and Multi-Risk Revolver Facility    ${ExcelPath}    ${rowid}    CRED08_RevFacilityOngoingFee
    Mx Execute Template With Multiple Data    Setup Multi-Currency and Multi-Risk Term Facility   ${ExcelPath}    ${rowid}    CRED02_FacilitySetup
    Mx Execute Template With Multiple Data    Setup Interest Pricing Fees for Multi-Currency and Multi-Risk Term Facility   ${ExcelPath}    101-104    CRED08_TermFacilityInterestFee
    Mx Execute Template With Multiple Data    Setup Ongoing Fees for Multi-Currency and Multi-Risk Term Facility    ${ExcelPath}    ${rowid}    CRED08_TermFacilityOngoingFee
    Mx Execute Template With Multiple Data    Create Commitment Schedule in Facility    ${ExcelPath}    ${rowid}    CRED02_FacilitySetup
    Mx Execute Template With Multiple Data    Setup a Primary Notebook for Multiple Risk Types Deal    ${ExcelPath}    ${rowid}    CRED01_DealSetup 
       
Loan Drawdown with Flex Schedule for Fixed P&I Repayment
    [Tags]    04 Create Loan Drawdown with Flex Schedule - DRAW_CRE06
    Mx Execute Template With Multiple Data    Create Loan Drawdown with Flex Schedule for Fixed P&I Repayment    ${ExcelPath}   ${rowid}    SERV_47_FlexPISchedule   
     
SBLC Guarantee Issuance with Multiple Risk Types for Bilateral Deal
    [Tags]    05 Create SBLC Guarantee - DRAW_CRE01
    Mx Execute Template With Multiple Data    SBLC Guarantee Issuance for Bilateral Deal with Multiple Risk Types    ${ExcelPath}   ${rowid}    SERV05_SBLCIssuance

Run First EOD 
    [Documentation]    Need to Run EOD here
    Log    Execution is paused. Need to run EoD (At least 1 Day for Payments).
    Pause Execution
    
EVGLIQ_PAY_CRE01_Loan Paper Clip Repayment_SERV23
    [Documentation]    This keyword is used to do paper clip payment for fixed loan.
    ...    @author: rtarayao
    [Tags]    07 Perform Loan Repayment Paper Clip - PAY_CRE01
    Mx Execute Template With Multiple Data    Initiate Repayment Paper Clip for Bilateral Deal    ${ExcelPath}    ${rowid}    SERV23_LoanPaperClip

EVGLIQ_PAY_CRE04_OngoingFeePayment_SERV29 - Bilateral Deal with Multiple Risk Types
    [Documentation]    This testcase will perform Ongoing Fee Payment on Bilateral Deal with Multiple Risk Types.
    ...    @author: fmamaril  
    [Tags]    08 Perform Ongoing Fee Payment - PAY_CRE04
    Mx Execute Template With Multiple Data    Update Commitment Fee Cycle    ${ExcelPath}    1-2    SERV29_PaymentFees
    Log    Execution is paused. Need to run EoD.    
    Pause Execution
    Mx Execute Template With Multiple Data    Pay Commitment Fee Amount    ${ExcelPath}    1-2    SERV29_PaymentFees   
   
    
EVGLIQ_PAY_CRE02_ManualSchedulePrincipalPayment_SERV18 - Deal with Multiple Risk Type
    [Documentation]    This testcase will perform Manual Scheduled Principal Payment on Bilateral Deal.
    ...    @author: fmamaril
    [Tags]    09 Perform Loan Repayment Paper Clip - PAY_CRE02     
    Mx Execute Template With Multiple Data    Manual Schedule Principal Payment -Bilateral Deal with Multiple Risk    ${ExcelPath}    ${rowid}    SERV18_Payments 
    
EVGLIQ_PTRF_CRE01 - User is able to create a PORTFOLIO TRANSFER
    [Documentation]    This test suite will create a portfolio transfer for Scenario 6
    ...    @author: mnanquilada
    [Tags]    10 Perform Portfolio Transfer - PTRF_CRE01
    Mx Execute Template With Multiple Data    Portfolio Transfer    ${ExcelPath}    ${rowID}    PTRF_CRE01_PortfolioTransfer
    
Cycle Share Adjustment for Fee Accrual - Commitment Fee
    [Documentation]    This keyword is used to do a cycle share adjustment for fee accrual in Commitment Fee Notebook.
    [Tags]    11 Perform Fee Accrual for Commitment Fee - ADJ_ACC01
    Mx Execute Template With Multiple Data    Create Cycle Share Adjustment for Fee Accrual    ${ExcelPath}    ${rowid}    MTAM06B_CycleShareAdjustment
        
Cycle Share Adjustment for Fee Accrual
    [Documentation]    This keyword is used to do a cycle share adjustment for fee accrual-Payment Reversal. 
    [Tags]    12 Perform Reversal of Ongoing Fee Payment - ADJ_REV01  
    Mx Execute Template With Multiple Data    Create Cycle Share Adjustment for Fee Accrual- Payment Reversal    ${ExcelPath}    ${rowid}    MTAM05B_CycleShareAdjustment
