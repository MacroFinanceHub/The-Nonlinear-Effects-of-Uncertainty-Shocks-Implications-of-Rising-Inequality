*Author: Nisha Chikhale
*Date:02.19.2020
*Modified: 
*******************************************************************************
* Explore Kalman filtering
*******************************************************************************
clear
* set directories
global output "/Users/nishachikhale/Documents/Stata/718proposal/output"
global bls "/Users/nishachikhale/Documents/Stata/718proposal/BLS"
global census "/Users/nishachikhale/Documents/Stata/718proposal/Census"

import excel using "$bls/AnnualLS_PRS85006173.xls", sh("FRED Graph") cellrange(A11:B84) firstrow case(lower) clear
gen year = year(observation_date)
rename prs85006173 ann_ls
merge 1:1 year using "$output/dinamoments62-16.dta"
drop _merge
save "$output/kalman.dta", replace

import excel using "$census/GINIALLRF.xls", sh("FRED Graph") cellrange(A11:B83) firstrow case(lower) clear
gen year = year(observation_date)
rename giniallrf gini
merge 1:1 year using "$output/kalman.dta"

********************************************************************************
*Correlation between moments and the labor share/gini ratio
corr ann_ls m2post
corr ann_ls m3post
corr ann_ls m4post

corr gini m2post
corr gini m3post
corr gini m4post

********************************************************************************
*Scatter plots
scatter ann_ls m2post || lfit ann_ls m2post , xtitle("Variance of the Income Distribution") ytitle("Labor share of income") legend(off)

scatter gini m2post || lfit gini m2post , xtitle("Variance of the Income Distribution") ytitle("Gini Ratio") legend(off)



