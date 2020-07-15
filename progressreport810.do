*Progress report regression tables and figures
*Author: Nisha Chikhale
*Date:04.07.2020
*Modified: 
*******************************************************************************
* ECON 810 Progress report 
*******************************************************************************
clear
* set directories
global output "/Users/nishachikhale/Documents/Stata/718proposal/output"

*load in data
set fredkey a4506230a2e8f2297c8f506214fef630
import fred FEDFUNDS GDPC1 PCE PAYEMS, aggregate(quarterly)

gen year = substr(datestr,1,4)
gen mo = substr(datestr,6,2)
destring year, float replace

gen quarter = .
replace quarter = 1 if mo == "01" 
replace quarter = 2 if mo == "04" 
replace quarter = 3 if mo == "07" 
replace quarter = 4 if mo == "10" 
drop if quarter == .

merge 1:1 year quarter using "$output/quarterly_u_60-19.dta"
drop _merge
merge 1:1 year quarter using "$output/dfa-9050ratio-clean.dta", force
drop _merge
merge 1:1 year quarter using "$output/quarterly_epu_since85.dta"
*save working dataset
save "$output/progressreport.dta", replace


*take logs of real variables
gen logy = log(GDPC1)
gen logy_l = logy[_n-1]

gen logpce = log(PCE)
gen logpce_l = logpce[_n-1]

gen logemp = log(PAYEMS)
gen logemp_l = logemp[_n-1]

* LHS vars
gen y1 = logy - logy_l
gen y2 = logpce - logpce_l
gen y3 = logemp - logemp_l
egen sdy1 = sd(y1)
egen sdy2 = sd(y2)
egen sdy3 = sd(y3)
*normalize the variables by their standard deviation so that the regression coefficients shows the effect of a one standard deviation increase in the independent variables on agg variables next quarter.
gen Y1 = y1/sdy1
gen Y2 = y2/sdy2
gen Y3 = y3/sdy3

*RHS vars 
gen um_l = h3[_n-1]
gen epu_l = epu_q[_n-1]
gen ratio_l = ratio[_n-1]
gen ffr_l = FEDFUNDS[_n-1]
egen sdum = sd(um_l)
egen sdepu = sd(epu_l)
egen sdr = sd(ratio_l)
egen sdf = sd(ffr_l)

gen UM_l = um_l/sdum
gen EPU_l = epu_l/sdepu
gen R_l = ratio_l/sdr
gen Y1_l = Y1[_n-1]
gen Y2_l = Y2[_n-1]
gen Y3_l = Y3[_n-1]
gen FFR_l = ffr_l/sdf
gen intu_l = UM_l*R_l
gen inte_l = EPU_l*R_l


*regression in (1) using JLN uncertainty
regress Y1 UM_l intu_l R_l Y2_l Y3_l 
eststo: regress Y1 UM_l intu_l R_l Y2_l Y3_l FFR_l 

*regression in (1) using EPU uncertainty
regress Y1 EPU_l inte_l R_l Y2_l Y3_l 
eststo: regress Y1 EPU_l inte_l R_l Y2_l Y3_l FFR_l
esttab using "$output/latex/progressreport_1.tex",se label nostar title(Regression table\label{tab1}) replace
eststo clear

* other variables on LHS
eststo: regress Y2 UM_l intu_l R_l Y1_l Y3_l FFR_l
eststo: regress Y3 UM_l intu_l R_l Y1_l Y2_l FFR_l
esttab using "$output/latex/progressreport_2.tex",se label nostar title(Regression table\label{tab1}) replace
eststo clear


