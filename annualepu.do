*Creates annual uncertainty shocks from EPU data for years 1900-2014
*Author: Nisha Chikhale
*Date:02.10.2020
*Modified: 
*******************************************************************************
* FIND ANNUAL UNCERTAINTY SHOCKS AND CREATE DATASET
*******************************************************************************
clear
* set directories
global epu "/Users/nishachikhale/Documents/Stata/718proposal/EPU"
global output "/Users/nishachikhale/Documents/Stata/718proposal/output"

import excel using "$epu/US_Historical_EPU_data.xlsx" , sh("Historical EPU") firstrow case(lower) clear

rename newsbasedhistoricaleconomicp epu

*create measure of uncertianty in decemeber of each year
gen epu_dec= epu if month == 12

*create measure of average uncertainty over each year
bysort year: egen avg_epu = mean(epu)

destring year, generate (newyear) force
drop year
gen year = newyear
drop if epu_dec == .
save "$output/annualepu_2000-2014.dta", replace

