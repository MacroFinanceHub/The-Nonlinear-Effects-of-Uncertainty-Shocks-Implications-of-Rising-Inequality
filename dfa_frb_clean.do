*Clean the Distributional Financial Accounts FRB data for VAR exercise
*Author: Nisha Chikhale
*Date: 03.20.20
*Modified: 05.05.20
*******************************************************************************
* 
*******************************************************************************
clear
* set directories
global data "/Users/nishachikhale/Documents/MATLAB/ECON718/StateDependenceofAggUncertainty/RawData/DFA_FRB"
global plots "/Users/nishachikhale/Documents/MATLAB/ECON718/StateDependenceofAggUncertainty/code/plots"
global output "/Users/nishachikhale/Documents/Stata/718proposal/output"

*import data
import delimited using "$data/dfa-networth-shares.csv", clear
gen year = substr(date,1,4)
gen quarter = substr(date,6,7)
destring year, float replace

 gen Q = . 
 replace Q = 1 if quarter == "Q1"
 replace Q = 2 if quarter == "Q2"
 replace Q = 3 if quarter == "Q3"
 replace Q = 4 if quarter == "Q4"
 

*create 90/50 ratio for each quarter
sort date
by date: gen a = networth if category == "Top1" 
by date: gen b = networth if category == "Next9"
by date: gen c = networth if category == "Next40"
by date: gen bottom = networth if category == "Bottom50"

collapse (mean) a b c bottom year Q, by(date)
sort date
by date: gen top1 = a
by date: gen top10 = a+b
by date: gen top50 = a+b+c

by date: gen ratio = top10/bottom
by date: gen ratio2 = top1/bottom
by date: gen ratio3 = top50/bottom
by date: gen ratio4 = top1/top10
by date: gen ratio5 = top1/top50


sort year Q
gen quarter = Q

*export data to excel file
save "$output/dfa-9050ratio-clean.dta", replace
export excel using "$data/dfa-9050ratio-clean.xlsx", firstrow(variables) replace


summarize ratio, detail
encode date, generate(date1)
format date1 %tq
replace date1 = date1 + 117
twoway line ratio date1, ytitle("90/50 ratio of networth") xtitle("Time in quarters") title("90/50 Wealth inequality measure from 1989 to 2019")
graph export "$plots/DFAratio_timeseries.png", replace

summarize ratio2, detail
twoway line ratio2 date1, ytitle("1 to bottom 50 ratio of networth") xtitle("Time in quarters") title("1 to bottom 50 Wealth inequality measure from 1989 to 2019")
graph export "$plots/DFAratio2_timeseries.png", replace

summarize ratio3, detail
twoway line ratio3 date1, ytitle("50/50 ratio of networth") xtitle("Time in quarters") title("50/50 Wealth inequality measure from 1989 to 2019")
graph export "$plots/DFAratio3_timeseries.png", replace

summarize ratio4, detail
twoway line ratio4 date1, ytitle("1/90 ratio of networth") xtitle("Time in quarters") title("1/90 Wealth inequality measure from 1989 to 2019")
graph export "$plots/DFAratio4_timeseries.png", replace

summarize ratio5, detail
twoway line ratio5 date1, ytitle("1 to top 50 ratio of networth") xtitle("Time in quarters") title("1 to top 50 Wealth inequality measure from 1989 to 2019")
graph export "$plots/DFAratio5_timeseries.png", replace



*double check
// gen id = _n + 117
// twoway line ratio id, ytitle("90/50 ratio of networth") xtitle("Time in quarters") title("Wealth inequality measure from 1989 to 2019")


