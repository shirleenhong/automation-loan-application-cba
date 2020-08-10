*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***


Validate the Facility Add/Unscheduled Commitment Increase/Awaiting Approval Window - General Tab 
      [Documentation]    This keyword validates the data in Facility Add/Unscheduled Commitment Increase/Awaiting Approval Window - General Tab are matched with the data in Test Data sheet.
    ...    @author: MGaling
    [Tags]    Validation 

    [Arguments]    ${Deal_Name}
    Mx LoanIQ Select Window Tab    ${LIQ_FacAddUnsched_CommitmentInc_Tab}    General     
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacAddUnsched_CommitmentInc_Window}    VerificationData="Yes"
    Validate Loan IQ Details    ${Deal_Name}    ${LIQ_FacAddUnsched_CommitmentInc_Window}.JavaStaticText("attached text:=${Deal_Name}")
    mx LoanIQ select    ${LIQ_FacAddUnsched_Option_ViewUpdateLenderShares_Menu}               
   

        

    


        

        
    
