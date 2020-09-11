*** Settings ***

Resource    ../../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***

Verify the Response 404 CBA not Lender
    [Documentation]    This keyword is used to validate the GET response is returned when all active facilities are terminated . 
    ...    @author: sacuisia 14AUG2019
    [Arguments]    ${ComSeeDataSet}  

   Verify Response of Deal Facility 404 Response    &{ComSeeDataSet}[COM_ID]    &{ComSeeDataSet}[Headers]    &{ComSeeDataSet}[Version]    &{ComSeeDataSet}[InputFilePath]    &{ComSeeDataSet}[ResponseJson] 
   
Get Response for Deal Single Facility - Scenario1
    [Documentation]    This keyword is used to GET Response for SINGLE FACILITY, SINGLE LENDER, and SINGLE BORROWER DEAL. 
    ...    This test case validates that the Get Response Payload is the same as the details seen in LIQ.
    ...    @author: rtarayao    16AUG2019    Duplicate this high level to be specific on Comsee Scenario 1.
    [Arguments]    ${ExcelPath}  
    
   ###PRE-REQUISITE - READ FACILITY DATA
   ${CurrentDate}    Get Current Date of Local Machine
   Write Data To Excel    ComSee_SC1_Deal    DateExtracted    ${rowid}    ${CurrentDate}    ${ComSeeDataSet}
   ${ExtractDate}    Read Data From Excel    ComSee_SC1_Deal    DateExtracted    ${rowid}    ${ComSeeDataSet}
   
   ${Facility_ControlNumber}    Read Data From Excel    ComSee_SC1_FacSetup    Facility_ControlNumber    ${rowid}    ${ComSeeDataSet}    
   ${Facility_EffectiveDate}    Read Data From Excel    ComSee_SC1_FacSetup    Facility_EffectiveDate    ${rowid}    ${ComSeeDataSet}
   ${Facility_FinalMaturityDate}    Read Data From Excel    ComSee_SC1_FacSetup    Facility_FinalMaturityDate    ${rowid}    ${ComSeeDataSet}
   ${Facility_Currency}    Read Data From Excel    ComSee_SC1_FacSetup    Facility_Currency    ${rowid}    ${ComSeeDataSet}
   ${Facility_MultiCCY}    Read Data From Excel    ComSee_SC1_FacSetup    Facility_MultiCCY    ${rowid}    ${ComSeeDataSet}
   ${Facility_MultiCCY}    Convert To Boolean    ${Facility_MultiCCY}
   ${Facility_MultiCCY}    Convert To String    ${Facility_MultiCCY}
   ${Facility_Type}    Read Data From Excel    ComSee_SC1_FacSetup    Facility_Type    ${rowid}    ${ComSeeDataSet}
   ${Facility_HostBankNetCommitment}    Read Data From Excel    ComSee_SC1_FacSetup    Facility_HostBankNetCommitment    ${rowid}    ${ComSeeDataSet}
   ${Facility_HostBankNetOutstandings}    Read Data From Excel    ComSee_SC1_FacSetup    Facility_HostBankNetOutstandings    ${rowid}    ${ComSeeDataSet}
   ${Facility_HostBankNetAvailableToDraw}    Read Data From Excel    ComSee_SC1_FacSetup    Facility_HostBankNetAvailableToDraw    ${rowid}    ${ComSeeDataSet}
   ${Facility_ExpenseCode}    Read Data From Excel    ComSee_SC1_FacSetup    Facility_ExpenseCode    ${rowid}    ${ComSeeDataSet}
   ${Facility_Processing_Code}    Read Data From Excel    ComSee_SC1_FacSetup    Facility_Processing_Code    ${rowid}    ${ComSeeDataSet}
   ${Facility_Processing_Desc}    Read Data From Excel    ComSee_SC1_FacSetup    Facility_Processing_Desc    ${rowid}    ${ComSeeDataSet}
   ${Facility_NoOfLenders}    Read Data From Excel    ComSee_SC1_FacSetup    Facility_NoOfLenders    ${rowid}    ${ComSeeDataSet}
   ${Facility_NoOfBorrowers}    Read Data From Excel    ComSee_SC1_FacSetup    Facility_NoOfBorrowers    ${rowid}    ${ComSeeDataSet}
   ${Facility_NoOfOutstanding}    Read Data From Excel    ComSee_SC1_FacSetup    Facility_NoOfOutstanding    ${rowid}    ${ComSeeDataSet}
   ${Facility_HostBankFundableCommitment}    Read Data From Excel    ComSee_SC1_FacSetup    Facility_HostBankFundableCommitment    ${rowid}    ${ComSeeDataSet}
   ${Facility_GlobalClosingCommitment}    Read Data From Excel    ComSee_SC1_FacSetup    Facility_GlobalClosingCommitment    ${rowid}    ${ComSeeDataSet}
   ${Facility_GlobalCurrentCommitment}    Read Data From Excel    ComSee_SC1_FacSetup    Facility_GlobalCurrentCommitment    ${rowid}    ${ComSeeDataSet}
   ${Facility_GlobalOutstandings}    Read Data From Excel    ComSee_SC1_FacSetup    Facility_GlobalOutstandings    ${rowid}    ${ComSeeDataSet}
   ${Facility_GlobalAvailableToDraw}    Read Data From Excel    ComSee_SC1_FacSetup    Facility_GlobalAvailableToDraw    ${rowid}    ${ComSeeDataSet}
   ${Facility_PortfolioCode}    Read Data From Excel    ComSee_SC1_FacSetup    Facility_PortfolioCode    ${rowid}    ${ComSeeDataSet}
   ${Facility_PortfolioDescription}    Read Data From Excel    ComSee_SC1_FacSetup    Facility_PortfolioDescription    ${rowid}    ${ComSeeDataSet}
   ${Facility_BranchCode}    Read Data From Excel    ComSee_SC1_FacSetup    Facility_BranchCode    ${rowid}    ${ComSeeDataSet}
   ${Facility_BranchDescription}    Read Data From Excel    ComSee_SC1_FacSetup    Facility_BranchDescription    ${rowid}    ${ComSeeDataSet}
   ${Facility_FundingDeskCode}    Read Data From Excel    ComSee_SC1_FacSetup    Facility_FundingDeskCode    ${rowid}    ${ComSeeDataSet}
   ${Facility_FundingDeskDescription}    Read Data From Excel    ComSee_SC1_FacSetup    Facility_FundingDeskDescription    ${rowid}    ${ComSeeDataSet}
   ${Facility_ExpiryDate}    Read Data From Excel    ComSee_SC1_FacSetup    Facility_ExpiryDate    ${rowid}    ${ComSeeDataSet}
   
   Validation for CommSee   &{ExcelPath}[COM_ID]    &{ExcelPath}[Headers]    &{ExcelPath}[Version]    &{ExcelPath}[InputFilePath]    &{ExcelPath}[ResponseJson]    ${ExtractDate}    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Deal_TrackingNumber]    
   ...    &{ExcelPath}[Deal_ClosedDate]    &{ExcelPath}[Deal_Currency]    &{ExcelPath}[Deal_HostBankNetCommitment]    &{ExcelPath}[Deal_ProcessingAreaCode]    &{ExcelPath}[Deal_ProcessingAreaDescription]    
   ...    &{ExcelPath}[Deal_ExpenseCode]    &{ExcelPath}[Deal_ExpenseDescription]    
   ...    &{ExcelPath}[Deal_NoOfFacitlities]    &{ExcelPath}[Deal_NoOfLenders]    &{ExcelPath}[Deal_NoOfBorrowers]    &{ExcelPath}[Deal_HostBankClosingCommitment]    &{ExcelPath}[Deal_GlobalDealClosingCommitment]
   ...    &{ExcelPath}[Deal_GlobalDealCurrentCommitment]    &{ExcelPath}[Deal_DepartmentCode]    &{ExcelPath}[Deal_DepartmentDescription]    &{ExcelPath}[Facility_Name]    ${Facility_ControlNumber}
   ...    ${Facility_EffectiveDate}    ${Facility_FinalMaturityDate}    ${Facility_Currency}    ${Facility_MultiCCY}    ${Facility_Type}
   ...    ${Facility_HostBankNetCommitment}    ${Facility_HostBankNetOutstandings}    ${Facility_HostBankNetAvailableToDraw}    ${Facility_ExpenseCode} 
   ...    ${Facility_Processing_Code}    ${Facility_Processing_Desc}    ${Facility_NoOfLenders}    ${Facility_NoOfBorrowers}    
   ...    ${Facility_NoOfOutstanding}    ${Facility_HostBankFundableCommitment}    ${Facility_GlobalClosingCommitment}
   ...    ${Facility_GlobalCurrentCommitment}    ${Facility_GlobalOutstandings}    ${Facility_GlobalAvailableToDraw}    ${Facility_PortfolioCode}   
   ...    ${Facility_PortfolioDescription}    ${Facility_BranchCode}    ${Facility_BranchDescription}    ${Facility_FundingDeskCode}
   ...    ${Facility_FundingDeskDescription}     ${Facility_ExpiryDate}   