*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot
*** Variables ***
${rowid}    1

*** Test Cases ***
### Sample ###
Load Base Rate 
    Mx Execute Template With Multiple Data    Send a Valid GS File for Base Rates    ${NEWUAT_TL_DATASET}    1   BaseRate_Fields
    # Mx LoanIQ DoubleClick    ${LIQ_OptionNameBaseRateAssoc_Tree}    	BBSY\tBBSW    15
    # Mx LoanIQ DoubleClick    ${LIQ_OptionNameBaseRateAssoc_Tree}    	BBSY\tBBSW
    # Mx LoanIQ Select String    ${LIQ_OptionNameBaseRateAssoc_Tree}    	BBSY\tBBSW
    # Mx Press Combination    Key.Enter