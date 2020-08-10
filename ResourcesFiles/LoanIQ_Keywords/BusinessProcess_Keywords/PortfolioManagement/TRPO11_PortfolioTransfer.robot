*** Settings ***
Resource     ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Portfolio Transfer
    [Documentation]    This keyword is used for Portfolio Transfer
    ...    Primarily entering data in multiple tabs of the Deal Notebook and Portfolio transfer.
    ...    @author: mnanquilada
    ...    09/25/2018
    ...    @update: dahijara    14JUL2020    - Updated keyword for Validate Portfolio Transfer
	...    @update: dahijara    27JUL2020    - Added IF condition in getting expiry date for scenario 8
	...    @update: dahijara    29JUL2020    - Moved 'mx LoanIQ close window    ${LIQ_Portfolio_Transfer_Window}' under release portforlio transfer
    [Arguments]    ${ExcelPath}
    
    ####Search Deal in LIQ
    Search for Deal    &{ExcelPath}[Deal_Name]
    
    
    ###Get FAcility Amount   
    ${facilityTotalAmount}    ${remainingAmount}    ${percentageAmount}    ${facilityAmountPercentage}    Get Remaining Facility Amount    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Currency]    &{ExcelPath}[Percentage_Multiplier]
    
    
    ####Add Portfolio Transfer in a Deal
    ${Effective_Date}    Get System Date
    ${Expiry_Date}    Run Keyword If   '${SCENARIO}'=='8'    Read Data From Excel    CRED02_FacilitySetup    Facility_ExpiryDate    2
	...    ELSE    Read Data From Excel    CRED02_FacilitySetup    Facility2_ExpiryDate    ${rowid}
	
	${amount}    Add Portfolio Transfer    &{ExcelPath}[Deal_Name]    ${Effective_Date}    &{ExcelPath}[Expense_Code]    ${Expiry_Date}    ${facilityAmountPercentage}    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Currency]    ${facilityTotalAmount}  
	
	###Send Portfolio transfer for approval  
	Send Portfolio Transfer to Approval
    
	###Login to LIQ as an approver
	Logout from Loan IQ
	Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
	
	####Search for the awaiting approval portfolio transfer
	Navigate to Payment Notebook via WIP    &{ExcelPath}[Transaction_Type]    &{ExcelPath}[Status_1]    &{ExcelPath}[Type]    &{ExcelPath}[Deal_Name]
	
	####Validate the portfolio transfer
    Validate Portfolio Transfer Using Expense Code    &{ExcelPath}[Expense_Code]
	
	####Approve Portfolio Transfer
	Approve Portfolio Transfer
	
	####Login as a Release user in LIQ
	Logout from Loan IQ
	Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
	
	####Search for the awaiting approval portfolio transfer
	Navigate to Payment Notebook via WIP    &{ExcelPath}[Transaction_Type]    &{ExcelPath}[Status_2]    &{ExcelPath}[Type]    &{ExcelPath}[Deal_Name]
	
	####Validate the portfolio transfer
    Validate Portfolio Transfer Using Expense Code    &{ExcelPath}[Expense_Code]
	
	###Release portfolio transfer
	Release Portfolio Transfer
	
	##Validate Portfolio Transfer in Lender Share
    Search for Deal    &{ExcelPath}[Deal_Name]
    Validate Portfolio Transfer in Lender Share    &{ExcelPath}[Host_Bank]    &{ExcelPath}[Portfolio]    ${amount}
    
    ###ValidateRemainingAmount
    Validate Remaining Amount in Portfolio Position    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Currency]    ${remainingAmount}    ${percentageAmount}    &{ExcelPath}[Portfolio]
	
	# Added for integrated scenario
	Close All Windows on LIQ
	Logout from Loan IQ
	Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
	
	
    
    
   
