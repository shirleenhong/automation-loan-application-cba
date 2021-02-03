*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
Facility Extension
    Mx Execute Template With Multiple Data    Update Facility Expiry and Maturity Date Through FCT    ${ExcelPath}    ${rowid}    CRED02_FacilitySetup
    Mx Execute Template With Multiple Data    Update Borrowers External Credit Rating History    ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup
    Mx Execute Template With Multiple Data    Create PCT for Pricing Matrix    ${ExcelPath}    ${rowid}    AMCH06_PricingChangeTransaction