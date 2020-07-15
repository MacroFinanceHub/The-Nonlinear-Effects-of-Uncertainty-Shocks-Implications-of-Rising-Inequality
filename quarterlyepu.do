*Creates quarterly uncertainty shocks from EPU data for years 1985-PRESENT
*Author: Nisha Chikhale
*Date:03.24.2020
*Modified: 
*******************************************************************************
* FIND QUARTERLY UNCERTAINTY SHOCKS AND CREATE DATASET
*******************************************************************************
clear
* set directories
global epu "/Users/nishachikhale/Documents/Stata/718proposal/EPU"
global output "/Users/nishachikhale/Documents/Stata/718proposal/output"
global data "/Users/nishachikhale/Documents/MATLAB/ECON718/StateDependenceofAggUncertainty/RawData/EPU"

import excel using "$epu/US_Policy_Uncertainty_Data.xlsx" , sh("Main Index") firstrow case(lower) clear

rename news_based_policy_uncert_index epu


gen quarter = .
replace quarter = 1 if month == 1 
replace quarter = 2 if month == 4 
replace quarter = 3 if month == 7 
replace quarter = 4 if month == 10 
drop if quarter == .

*save "$output/quarterly_u_since85.dta", replace

