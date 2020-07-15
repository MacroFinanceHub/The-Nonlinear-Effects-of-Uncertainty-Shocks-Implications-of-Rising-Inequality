*Creates annual uncertainty shocks from JLN 2003 data for years 1962-2016
*Author: Nisha Chikhale
*Date:11.24.2019
*Modified: 12.08.2019
*******************************************************************************
* FIND ANNUAL UNCERTAINTY SHOCKS AND CREATE DATASET
*******************************************************************************
clear
* set directories
global uncertainty "/Users/nishachikhale/Documents/Stata/Ludvigsondownload"
global output "/Users/nishachikhale/Documents/Stata/718proposal/output"

import excel using "$uncertainty/MacroFinanceUncertainty_201908_update/MacroUncertaintyToCirculate.xlsx", sh("Macro Uncertainty") firstrow case(lower) clear


gen year = year(date)
gen month = month(date)

*create measure of uncertianty for h=12 months ahead in decemeber of each year
gen u_dec_h12= h12 if month == 12

*calculate mean level of uncertainty over the year for each measure
foreach h of varlist h1 h3 h12{
bysort year : egen u_`h' = mean(`h')

}
keep year u_h1 u_h3 u_h12 u_dec_h12
duplicates drop
drop if u_dec_h12 == . 

save "$output/annualu_60-19.dta", replace
