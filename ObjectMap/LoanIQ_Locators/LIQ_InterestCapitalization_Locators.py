###Circle Notebook - Checkbox###
LIQ_InterestCapitalization_Window = 'JavaWindow("title:=Loan Capitalization Editor.*","displayed:=1")'
LIQ_InterestCapitalization_ActiveInterestCapitalization_Checkbox = 'JavaWindow("title:=Loan Capitalization Editor.*","displayed:=1").JavaCheckBox("attached text:=Activate Interest Capitalization")'
LIQ_InterestCapitalization_AllowCapitalizationOverFacilityLimit_Checkbox = 'JavaWindow("title:=Loan Capitalization Editor.*","displayed:=1").JavaCheckBox("attached text:=Allow Capitalization Over Facility Limit")'
LIQ_InterestCapitalization_CapitalizationFrequencyApplies_Checkbox = 'JavaWindow("title:=Loan Capitalization Editor.*","displayed:=1").JavaCheckBox("attached text:=Capitalization Frequency Applies")'

###Circle Notebook - Date/TextFields###
LIQ_InterestCapitalization_FromDate_DateField = 'JavaWindow("title:=Loan Capitalization Editor.*","displayed:=1").JavaEdit("attached text:=From Date")'
LIQ_InterestCapitalization_ToDate_DateField = 'JavaWindow("title:=Loan Capitalization Editor.*").JavaEdit("index:=1","tagname:=To Date")'
LIQ_InterestCapitalization_PercentofPayment_InputField = 'JavaWindow("title:=Loan Capitalization Editor.*").JavaEdit("index:=4","tagname:=To Date")'
LIQ_InterestCapitalization_CapitalizeFrom_TextField = 'JavaWindow("title:=Loan Capitalization Editor.*","displayed:=1").JavaEdit("attached text:=Capitalize From")'


###Circle Notebook - Dropdown###
LIQ_InterestCapitalization_CapitalizationFrequency_DropdownList = 'JavaWindow("title:=Loan Capitalization Editor.*","displayed:=1").JavaList("attached text:=Capitalization Frequency:")'
LIQ_InterestCapitalization_ToLoan_DropdownList = 'JavaWindow("title:=Loan Capitalization Editor.*","displayed:=1").JavaList("attached text:=To Loan")'
LIQ_InterestCapitalization_ToFacility_DropdownList = 'JavaWindow("title:=Loan Capitalization Editor.*","displayed:=1").JavaList("attached text:=To Facility")'

###Circle Notebook - Button###
LIQ_InterestCapitalization_OKButton = 'JavaWindow("title:=Loan Capitalization Editor.*","displayed:=1").JavaButton("label:=OK")'