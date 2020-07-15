*Creates quarterly uncertainty shocks from JLN 2003 data for years 1962-2016
*Author: Nisha Chikhale
*Date:04.08.20
*Modified: 
*******************************************************************************
* FIND QUARTERLY UNCERTAINTY SHOCKS AND CREATE DATASET
*******************************************************************************
clear
* set directories
global uncertainty "/Users/nishachikhale/Documents/Stata/Ludvigsondownload"
global output "/Users/nishachikhale/Documents/Stata/718proposal/output"
global plots "/Users/nishachikhale/Documents/MATLAB/ECON718/StateDependenceofAggUncertainty/code/plots"

import excel using "$uncertainty/MacroFinanceUncertainty_201908_update/MacroUncertaintyToCirculate.xlsx", sh("Macro Uncertainty") firstrow case(lower) clear


gen year = year(date)
gen month = month(date)

gen quarter = .
replace quarter = 1 if month == 1 
replace quarter = 2 if month == 4 
replace quarter = 3 if month == 7 
replace quarter = 4 if month == 10 
drop if quarter == .



gen um_q = h3

gen um1_q = h1
summarize um1_q, detail


drop if date <  date("01oct1989", "DMY")
twoway line um1_q date, ytitle("Aggregate Uncertainty") xtitle("Time in quarters")  title("Uncertainty one month ahead from 1989 to 2019") tscale(range(01oct1989 01oct2021))
graph export "$plots/um1_timeseries.png", replace


save "$output/quarterly_u_60-19.dta", replace
