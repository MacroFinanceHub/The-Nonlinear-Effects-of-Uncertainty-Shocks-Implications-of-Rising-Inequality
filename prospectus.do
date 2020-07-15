*Prospectus tables and figures
*Author: Nisha Chikhale
*Date:02.27.2020
*Modified: 
*******************************************************************************
* 
*******************************************************************************
clear
* set directories
*global dina "/Users/nishachikhale/Documents/Stata/DistributionalNationalAccountsData"
global output "/Users/nishachikhale/Documents/Stata/718proposal/output"

*load in data
use "$output/prelim_1913-2016.dta", replace
*merge in DINA moments post 1962 
merge 1:1 year using "$output/dinamoments62-16.dta"
drop _merge
*generate interaction variables
gen int_depum2post = epu_dec*m2post
gen int_duh12m2post = u_dec_h12*m2post
gen int_duh12t10 = u_dec_h12*top10
gen int_duh12m3post = u_dec_h12*m3post

save "$output/prospectus.dta", replace


*Table 1: Moments of the Post-Tax Income Distribution
summarize m2post m3post m4post, detail
*Table 2: Shares of Income held by percentiles of the distribution
summarize bottom90 top10 top1, detail
*Table 3: Compare uncertainty measures
summarize epu_dec u_dec_h12, detail
*Table 4: Real Aggregate Consumption growth
summarize cons_growth if year<=2016, detail
summarize cons_growth if 1962<=year<=2016, detail
