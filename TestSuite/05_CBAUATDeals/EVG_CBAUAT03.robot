*** Settings ***
Resource    ../../Configurations/LoanIQ_Import_File.robot
Resource    ../../Configurations/Party_Import_File.robot

*** Variables ***
${rowid}    1
${SCENARIO}    3

*** Test Case ***
# Create Customer within Loan IQ - ORIG03
    # [Tags]    01 Create Customer within Loan IQ - ORIG03
    # Mx Execute Template With Multiple Data    Create Customer within Loan IQ    ${CBAUAT_ExcelPath}    ${rowid}    ORIG03_Customer
   
Create Quick Party Onboarding for CBA UAT Deal 3 - PTY001
    [Tags]    01 Create Party within Essence - PTY001
    Mx Execute Template With Multiple Data    Create Deal Borrower initial details in Quick Party Onboarding    ${CBAUAT_ExcelPath}    1    PTY001_QuickPartyOnboarding
    Mx Execute Template With Multiple Data    Populate Quick Enterprise Party with Approval    ${CBAUAT_ExcelPath}    1    PTY001_QuickPartyOnboarding   

# Complete Customer Profile - ORIG03
    # [Tags]    02 Complete Borrower's Profile - 0RIG03
    # Mx Execute Template With Multiple Data    Search Customer and Complete its Borrower Profile Creation with default values for Deal Template Three    ${CBAUAT_ExcelPath}    1    ORIG03_Customer
    # Mx Execute Template With Multiple Data    Add Remittance Instruction    ${CBAUAT_ExcelPath}    1    ORIG03_Customer
    # Mx Execute Template With Multiple Data    Add IMT message code for UAT Deal    ${CBAUAT_ExcelPath}    1    ORIG03_Customer    
    # Mx Execute Template With Multiple Data    Add Swift Role in IMT message for UAT Deal    ${CBAUAT_ExcelPath}    1    ORIG03_Customer
    # Mx Execute Template With Multiple Data    Update Swift Role in IMT message for UAT Deal    ${CBAUAT_ExcelPath}    2-3    ORIG03_Customer         
    # Mx Execute Template With Multiple Data    Populate Details on IMT for UAT Deal    ${CBAUAT_ExcelPath}    1    ORIG03_Customer
    # Send Remittance Instruction to Approval and Close RI Notebook        
    # Mx Execute Template With Multiple Data    Add Remittance Instruction    ${CBAUAT_ExcelPath}    4    ORIG03_Customer
    # Mx Execute Template With Multiple Data    Add IMT message code for UAT Deal    ${CBAUAT_ExcelPath}    4    ORIG03_Customer    
    # Mx Execute Template With Multiple Data    Add Swift Role in IMT message for UAT Deal    ${CBAUAT_ExcelPath}    4    ORIG03_Customer
    # Mx Execute Template With Multiple Data    Update Swift Role in IMT message for UAT Deal    ${CBAUAT_ExcelPath}    5-6    ORIG03_Customer         
    # Mx Execute Template With Multiple Data    Populate Details on IMT for UAT Deal    ${CBAUAT_ExcelPath}    4    ORIG03_Customer
    # Send Remittance Instruction to Approval and Close RI Notebook
    # Mx Execute Template With Multiple Data    Add Remittance Instruction    ${CBAUAT_ExcelPath}    7    ORIG03_Customer
    # Mx Execute Template With Multiple Data    Add IMT message code for UAT Deal    ${CBAUAT_ExcelPath}    7    ORIG03_Customer    
    # Mx Execute Template With Multiple Data    Add Swift Role in IMT message for UAT Deal    ${CBAUAT_ExcelPath}    7    ORIG03_Customer
    # Mx Execute Template With Multiple Data    Update Swift Role in IMT message for UAT Deal    ${CBAUAT_ExcelPath}    8-9    ORIG03_Customer         
    # Mx Execute Template With Multiple Data    Populate Details on IMT for UAT Deal    ${CBAUAT_ExcelPath}    7    ORIG03_Customer
    # Send Remittance Instruction to Approval and Close RI Notebook
    # Mx Execute Template With Multiple Data    Add Remittance Instruction    ${CBAUAT_ExcelPath}    10    ORIG03_Customer
    # Mx Execute Template With Multiple Data    Add IMT message code for UAT Deal    ${CBAUAT_ExcelPath}    10    ORIG03_Customer    
    # Mx Execute Template With Multiple Data    Add Swift Role in IMT message for UAT Deal    ${CBAUAT_ExcelPath}    10    ORIG03_Customer
    # Mx Execute Template With Multiple Data    Update Swift Role in IMT message for UAT Deal    ${CBAUAT_ExcelPath}    11-12    ORIG03_Customer         
    # Mx Execute Template With Multiple Data    Populate Details on IMT for UAT Deal    ${CBAUAT_ExcelPath}    10    ORIG03_Customer
    # Send Remittance Instruction to Approval and Close RI Notebook
    # Mx Execute Template With Multiple Data    Add Remittance Instruction    ${CBAUAT_ExcelPath}    13    ORIG03_Customer
    # Mx Execute Template With Multiple Data    Add IMT message code for UAT Deal    ${CBAUAT_ExcelPath}    13    ORIG03_Customer    
    # Mx Execute Template With Multiple Data    Add Swift Role in IMT message for UAT Deal    ${CBAUAT_ExcelPath}    13-15    ORIG03_Customer      
    # Mx Execute Template With Multiple Data    Update Swift Role in IMT message for UAT Deal    ${CBAUAT_ExcelPath}    16    ORIG03_Customer         
    # Mx Execute Template With Multiple Data    Populate Details on IMT for UAT Deal    ${CBAUAT_ExcelPath}    13    ORIG03_Customer
    # Mx Execute Template With Multiple Data    Add IMT message code for UAT Deal    ${CBAUAT_ExcelPath}    17    ORIG03_Customer    
    # Mx Execute Template With Multiple Data    Add Swift Role in IMT message for UAT Deal    ${CBAUAT_ExcelPath}    18    ORIG03_Customer      
    # Mx Execute Template With Multiple Data    Update Swift Role in IMT message for UAT Deal    ${CBAUAT_ExcelPath}    20-21    ORIG03_Customer         
    # Mx Execute Template With Multiple Data    Populate Details on IMT for UAT Deal    ${CBAUAT_ExcelPath}    17    ORIG03_Customer
    # Send Remittance Instruction to Approval and Close RI Notebook
    # Mx Execute Template With Multiple Data    Add Remittance Instruction    ${CBAUAT_ExcelPath}    22    ORIG03_Customer
    # Mx Execute Template With Multiple Data    Add IMT message code for UAT Deal    ${CBAUAT_ExcelPath}    22    ORIG03_Customer 
    # Mx Execute Template With Multiple Data    Add Swift Role in IMT message for UAT Deal    ${CBAUAT_ExcelPath}    22-24    ORIG03_Customer 
    # Mx Execute Template With Multiple Data    Populate Details on IMT for UAT Deal    ${CBAUAT_ExcelPath}    22    ORIG03_Customer
    # Mx Execute Template With Multiple Data    Add IMT message code for UAT Deal    ${CBAUAT_ExcelPath}    25    ORIG03_Customer    
    # Mx Execute Template With Multiple Data    Populate Details on IMT for UAT Deal    ${CBAUAT_ExcelPath}    25    ORIG03_Customer
    # Send Remittance Instruction to Approval and Close RI Notebook
    # Mx Execute Template With Multiple Data    Complete Servicing Group Details    ${CBAUAT_ExcelPath}    1    ORIG03_Customer    
    # Mx Execute Template With Multiple Data    Add Remittance Instruction to Servicing Group in UAT    ${CBAUAT_ExcelPath}    1,4,7,10,13,22    ORIG03_Customer    
    # Mx Execute Template With Multiple Data    Logout and Search Customer in UAT - 1st Approver    ${CBAUAT_ExcelPath}    1    ORIG03_Customer
    # Mx Execute Template With Multiple Data    Approve Remittance Instruction in UAT    ${CBAUAT_ExcelPath}    1,4,7,10,13,22    ORIG03_Customer
    # Mx Execute Template With Multiple Data    Logout and Search Customer in UAT - 2nd Approver    ${CBAUAT_ExcelPath}    1    ORIG03_Customer
    # Mx Execute Template With Multiple Data    Approve Remittance Instruction in UAT    ${CBAUAT_ExcelPath}    1,4,7,10,13,22    ORIG03_Customer
    # Mx Execute Template With Multiple Data    Logout and Search Customer in UAT - Inputter    ${CBAUAT_ExcelPath}    1    ORIG03_Customer 

# ### November 23
# Setup TL API - Prerequisite
    # Mx Execute Template With Multiple Data    Load Base Rate D00000476    ${CBAUAT_ExcelPath}    1    BaseRate_Fields
    # Mx Execute Template With Multiple Data    Load FX Rate D00000476     ${CBAUAT_ExcelPath}    1    FXRates_Fields

# ### November 28
# Setup BaseRate for Nov 28
    # Mx Execute Template With Multiple Data    Load Base Rate D00000476    ${CBAUAT_ExcelPath}    1    BaseRate_Fields
    
# Deal Template
    # Mx Execute Template With Multiple Data    Setup Deal D00000476    ${CBAUAT_ExcelPath}    1    CRED01_DealSetup
    # Mx Execute Template With Multiple Data    Setup Deal Bank Role    ${CBAUAT_ExcelPath}    1    CRED01_DealSetup
    # Mx Execute Template With Multiple Data    Setup Deal Admin Fee    ${CBAUAT_ExcelPath}    1    CRED01_DealSetup
    # Mx Execute Template With Multiple Data    Setup Deal Calendar    ${CBAUAT_ExcelPath}    1-2    CRED01_DealSetup
    # Mx Execute Template With Multiple Data    Setup Deal Interest Pricing Options    ${CBAUAT_ExcelPath}    1-5    CRED01_DealSetup
    # Mx Execute Template With Multiple Data    Setup Deal Fee Pricing Rules    ${CBAUAT_ExcelPath}    1    CRED01_DealSetup
    # Mx Execute Template With Multiple Data    Setup Facility Template D00000476    ${CBAUAT_ExcelPath}    1    CRED02_FacilitySetup
    # Mx Execute Template With Multiple Data    Setup Facility Fees D00000476    ${CBAUAT_ExcelPath}    1    CRED08_FacilityFeeSetup
    # Mx Execute Template With Multiple Data    Setup Facility Template D00000476    ${CBAUAT_ExcelPath}    2    CRED02_FacilitySetup
    # Mx Execute Template With Multiple Data    Setup Facility Fees D00000476    ${CBAUAT_ExcelPath}    2    CRED08_FacilityFeeSetup
    # Mx Execute Template With Multiple Data    Setup Facility Template D00000476    ${CBAUAT_ExcelPath}    3    CRED02_FacilitySetup
    # Mx Execute Template With Multiple Data    Setup Facility Fees D00000476    ${CBAUAT_ExcelPath}    3    CRED08_FacilityFeeSetup
    # Mx Execute Template With Multiple Data    Setup Facility Template D00000476    ${CBAUAT_ExcelPath}    4    CRED02_FacilitySetup
    # Mx Execute Template With Multiple Data    Setup Facility Fees D00000476    ${CBAUAT_ExcelPath}    4    CRED08_FacilityFeeSetup
    # Mx Execute Template With Multiple Data    Setup Primaries D00000476    ${CBAUAT_ExcelPath}    1    CRED01_Primaries
    # Mx Execute Template With Multiple Data    Setup Commitment Fee Effective Date    ${CBAUAT_ExcelPath}    1-3   CommitmentFee
    # Mx Execute Template With Multiple Data    Approve and Close UAT Deal    ${CBAUAT_ExcelPath}    1    CRED01_DealSetup
    # Mx Execute Template With Multiple Data    Commitment Fee Release    ${CBAUAT_ExcelPath}    1-3    SERV29_CommitmentFeePayment

# Issue LC1 - D00000476
    # Mx Execute Template With Multiple Data    Issue LC D00000476    ${CBAUAT_ExcelPath}    1    SERV05_SBLCIssuance
    
# Create Drawdown A B C D00000476
    # Mx Execute Template With Multiple Data    Create Drawdown D00000476    ${CBAUAT_ExcelPath}    1-3    SERV01A_LoanDrawdown

# #### November 30 
# Collect LC1 - D00000476
    # Mx Execute Template With Multiple Data    Initiate LC Collection D00000476    ${CBAUAT_ExcelPath}    1    SERV18_FeeOnLenderSharesPayment
   
# Collect LFIA1 - D00000476
    # Mx Execute Template With Multiple Data    Collect LFIA Payment D00000476    ${CBAUAT_ExcelPath}    1    SERV29_Payments

# ###December 19
# Issue LC2 - D00000476
    # Mx Execute Template With Multiple Data    Issue LC D00000476    ${CBAUAT_ExcelPath}    2    SERV05_SBLCIssuance

# ###December 28
# Setup BaseRate and FX Rate for Dec 28
    # Mx Execute Template With Multiple Data    Load Base Rate D00000476    ${CBAUAT_ExcelPath}    2    BaseRate_Fields
    # Mx Execute Template With Multiple Data    Load FX Rate D00000476     ${CBAUAT_ExcelPath}    1    FXRates_Fields

# Collect LFIA2 - D00000476
    # Mx Execute Template With Multiple Data    Collect LFIA Payment D00000476    ${CBAUAT_ExcelPath}    2    SERV29_Payments

# Create Drawdown D1 and D2 D00000476
    # Mx Execute Template With Multiple Data    Create Drawdown D00000476    ${CBAUAT_ExcelPath}    5    SERV01A_LoanDrawdown
    
# ### December 31
# Collect Commitment Fee - D00000476
    # Mx Execute Template With Multiple Data    Commitment Fee Payment    ${CBAUAT_ExcelPath}   1-3    SERV29_CommitmentFeePayment     

# Collect LC2 - D00000476
    # Mx Execute Template With Multiple Data    Initiate LC Collection D00000476    ${CBAUAT_ExcelPath}    2    SERV18_FeeOnLenderSharesPayment
    
# Collect LC1 Advance - D00000476
    # Mx Execute Template With Multiple Data    Initiate LC Collection D00000476    ${CBAUAT_ExcelPath}    3    SERV18_FeeOnLenderSharesPayment

# ### January 4
# Setup BaseRate for Jan 4
    # Mx Execute Template With Multiple Data    Load Base Rate D00000476    ${CBAUAT_ExcelPath}    3    BaseRate_Fields
    
# Collect Early Prepayment for D1 - D00000476
    # Mx Execute Template With Multiple Data    Collect Early Prepayment via Paper Clip D00000476    ${CBAUAT_ExcelPath}    1    SERV23_Paperclip
    
# Charge Breakcost Fee for D1 - D00000476
    # Mx Execute Template With Multiple Data    Collect Break Cost Fee for Early Prepayment D00000476    ${CBAUAT_ExcelPath}    1    SERV40_BreakFunding

# Initiate First Rollover for Drawdown A B C - D00000476
    # Mx Execute Template With Multiple Data    Initiate Comprehensive Repricing - D00000476    ${CBAUAT_ExcelPath}   1-3    SERV08C_ComprehensiveRepricing

# ### January 21
# Setup BaseRate and FX Rate for Jan 21    
    # Mx Execute Template With Multiple Data    Load Base Rate D00000476    ${CBAUAT_ExcelPath}    4    BaseRate_Fields
    # Mx Execute Template With Multiple Data    Load FX Rate D00000476     ${CBAUAT_ExcelPath}    2    FXRates_Fields
    
# Create Drawdown D4 D5 D6 - D00000476
    # Mx Execute Template With Multiple Data    Create Drawdown D00000476    ${CBAUAT_ExcelPath}    7-9    SERV01A_LoanDrawdown

# ### January 29
# Collect LFIA3 - D00000476
    # Mx Execute Template With Multiple Data    Collect LFIA Payment D00000476    ${CBAUAT_ExcelPath}    1    SERV29_Payments

# ###January 31
# Setup BaseRate for Jan 31    
    # Mx Execute Template With Multiple Data    Load Base Rate D00000476    ${CBAUAT_ExcelPath}    5    BaseRate_Fields
    
# Initiate Second Rollover for Drawdown A B C - D00000476
    # Mx Execute Template With Multiple Data    Initiate Comprehensive Repricing - D00000476    ${CBAUAT_ExcelPath}    4-6    SERV08C_ComprehensiveRepricing  

# ### February 1
# Extend Facility MOF - D00000476
    # Mx Execute Template With Multiple Data    Extend Maturity and Limit for MOD    ${CBAUAT_ExcelPath}    1    AMCH05_ExtendFacility

# Extend Facility FCAF and SCAF - D00000476
    # Mx Execute Template With Multiple Data    Extend Maturity and Limit for FCAF    ${CBAUAT_ExcelPath}    1-3    AMCH05_ExtendFacility

# Collect Extenstion Fee for MOF
    # Mx Execute Template With Multiple Data    Collect Extension Fee for D00000476     ${CBAUAT_ExcelPath}    1-3    CRED01_UpfrontFee

# ###February 21
# Setup BaseRate and FX Rate Feb 21
    # Mx Execute Template With Multiple Data    Load Base Rate D00000476    ${CBAUAT_ExcelPath}    5    BaseRate_Fields
    
# Collect Early Prepayment for C - D00000476
    # Mx Execute Template With Multiple Data    Collect Early Prepayment via Paper Clip D00000476    ${CBAUAT_ExcelPath}    2    SERV23_Paperclip
    
# Charge Breakcost Fee for C - D00000476
    # Mx Execute Template With Multiple Data    Collect Break Cost Fee for Early Prepayment D00000476    ${CBAUAT_ExcelPath}    2    SERV40_BreakFunding
    
# Initiate Loan Merge D1 and D2 - D00000476    
    # Mx Execute Template With Multiple Data    Initiate Loan Merge and Conversion - D00000454    ${CBAUAT_ExcelPath}    1    COM06_LoanMerge

# ###February 22    
# Setup BaseRate and FX Rate for Feb 22
    # Mx Execute Template With Multiple Data    Load Base Rate D00000476    ${CBAUAT_ExcelPath}    4    BaseRate_Fields
    # Mx Execute Template With Multiple Data    Load FX Rate D00000476     ${CBAUAT_ExcelPath}    2    FXRates_Fields
    
# Initiate Rollover for D4
    # Mx Execute Template With Multiple Data    Initiate Comprehensive Repricing - D00000476    ${CBAUAT_ExcelPath}    8    SERV08C_ComprehensiveRepricing

# Initiate Rollover for D5
    # Mx Execute Template With Multiple Data    Initiate Comprehensive Repricing - D00000476    ${CBAUAT_ExcelPath}    9    SERV08C_ComprehensiveRepricing 

# Collect Full Prepayment for D6 - D00000476
    # Mx Execute Template With Multiple Data    Collect Early Prepayment via Paper Clip D00000476    ${CBAUAT_ExcelPath}    3    SERV23_Paperclip

# ### February 28        
# Collect LFIA4 - D00000476
    # Mx Execute Template With Multiple Data    Collect LFIA Payment D00000476    ${CBAUAT_ExcelPath}    2    SERV29_Payments
