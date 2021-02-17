*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Add Increase Schedule via Facility Change Transaction for CH EDu Bilateral Deal
    [Documentation]    This keyword is used to peform facility change transaction for adding Increase Schedule forfacility 
    ...    @author:    dahijara    10FEB2021    initial create
    [Arguments]    ${ExcelPath}

    ### Read Excel Data ###
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    1
    ${FacilityName}    Read Data From Excel    CRED02_FacilitySetup_B    Facility_Name    1

    ### LIQ Window ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ###Facility Notebook###
    Navigate to Facility Notebook    ${Deal_Name}    ${FacilityName}

    ### Facility Change Transaction Notebook ###
    Add Facility Change Transaction

    ### Inc/Dec Schedule Tab ###
    Navigate to Facility Change Transaction Tab    ${INC_DEC_SCHEDULE_TAB}
    Create Facility Increase/Decrease Schedule
    Add Amortization Schedule    &{ExcelPath}[ItemChangeType]    &{ExcelPath}[ChangeAmount]    &{ExcelPath}[ScheduleDate]
    Verify Amortization Schedule Details    &{ExcelPath}[ScheduleItemNumber]    &{ExcelPath}[ChangeAmount]    &{ExcelPath}[ScheduleDate]
    Select Schedule Frequency    &{ExcelPath}[ScheduleFrequency]
    Save and Exit Amortization Schedule

    ### Send to Approval ###
    Navigate to Facility Change Transaction Workflow and Proceed with Transaction    ${SEND_TO_APPROVAL_STATUS}

    ### Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    ${FACILITIES}    ${AWAITING_APPROVAL_STATUS}    ${FACILITY_CHANGE_TRANSACTION}    ${Deal_Name}
    Navigate to Facility Change Transaction Workflow and Proceed with Transaction    ${APPROVAL_STATUS}

    ### Release ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate Transaction in WIP    ${FACILITIES}    ${AWAITING_RELEASE_STATUS}    ${FACILITY_CHANGE_TRANSACTION}    ${Deal_Name}
    Navigate to Facility Change Transaction Workflow and Proceed with Transaction    ${RELEASE_STATUS}
    Validate Window Title Status    ${FACILITY_CHANGE_TRANSACTION}    ${RELEASED_STATUS}
    Close All Windows on LIQ

    ### Validation ###
    Navigate to Facility Notebook    ${Deal_Name}    ${FacilityName}
    Validate an Event in Events Tab of Facility Notebook    ${FACILITY_CHANGE_TRANSACTION_RELEASED}

Increase Commitment for Revolver Facility for CH EDU Bilateral Deal
    [Documentation]    This keyword is used to peform increase commitment for revolver facility for CH Edu Bilateral Deal
    ...    @author:    dahijara    11FEB2021    initial create
    [Arguments]    ${ExcelPath}

    ### Read Excel Data ###
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    1
    ${FacilityName}    Read Data From Excel    CRED02_FacilitySetup_B    Facility_Name    1

    ### LIQ Window ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ### Facility Notebook ###
    Navigate to Facility Notebook    ${Deal_Name}    ${FacilityName}
    Go to Facility Notebook Update Mode
    Create Pending Transaction in Facility Schedule    &{ExcelPath}[ScheduleItemNumber]    &{ExcelPath}[ScheduleDate]
    Enter Facility Schedule Commitment Details    &{ExcelPath}[Comment]
    Navigate to Scheduled Commitment Workflow and Proceed with Transaction    ${GENERATE_INTENT_NOTICES}
    Select Notices Recipients
    Close Commitment Change Group Window
    Navigate to Scheduled Commitment Workflow and Proceed with Transaction    ${SEND_TO_APPROVAL_STATUS}

    ### Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    ${FACILITIES}    ${AWAITING_APPROVAL_STATUS}    ${SCHEDULED_COMMITMENT_INCREASE_TRANSACTION}    ${FacilityName}
    Navigate to Scheduled Commitment Workflow and Proceed with Transaction    ${APPROVAL_STATUS}

    ### Release ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate Transaction in WIP    ${FACILITIES}    ${AWAITING_RELEASE_STATUS}    ${SCHEDULED_COMMITMENT_INCREASE_TRANSACTION}    ${FacilityName}
    Navigate to Scheduled Commitment Workflow and Proceed with Transaction    ${RELEASE_STATUS}
    Validate Window Title Status    ${SCHEDULED_COMMITMENT_INCREASE_TRANSACTION}    ${RELEASED_STATUS}
    Close All Windows on LIQ

    ### Refresh All Code Tables ###
    Refresh Tables in LIQ

    ### Validation ###
    Navigate to Facility Notebook    ${Deal_Name}    ${FacilityName}
    Validate Current Commitment Amount for Facility    &{ExcelPath}[Expct_CurrentCmtAmt]
    Validate an Event in Events Tab of Facility Notebook    ${COMMITMENT_INCREASE_RELEASED}
    Close All Windows on LIQ