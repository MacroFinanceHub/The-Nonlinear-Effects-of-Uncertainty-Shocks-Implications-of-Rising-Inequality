*Creates timeseries dataset for 718 preliminiary proposal
*Author: Nisha Chikhale
*Date:12.08.2019
*Modified: 
*******************************************************************************
* Merge DINA and Uncertainty series
*******************************************************************************
clear
* set directories
global output "/Users/nishachikhale/Documents/Stata/718proposal/output"
global bea "/Users/nishachikhale/Documents/Stata/718proposal/BEA"

*merge datasets
import excel using "$bea/BEA_T2.4.3U.xls", sh("infile") firstrow case(lower) clear
destring year, float replace
merge 1:1 year using "$output/annualu_60-19.dta" 
drop _merge
merge 1:1 year using "$output/dinamoments62-16.dta"
drop if m1pre == .
save "$output/prelim62-16.dta", replace

*create sum of uncertainty at three horizons
*gen sum_u = u_h1 + u_h3 + u_h12

*create growth rate of variance variable
gen lag_m2post = m2post[_n-1] 
gen g_m2post = (m2post - lag_m2post)/ lag_m2post 


*scatter plots 
*relate post-tax distributions moments to u_h1
scatter u_h1 m2post, mlabel(year) || lfit u_h1 m2post, xtitle("Variance of Post-tax Income Distribution") ytitle("Macroeconomic Uncertainty h=1") legend(off)

graph export $output/scatter_h1_var.png, replace

scatter u_h1 m3post, mlabel(year) || lfit u_h1 m3post, xtitle("Skewness of Post-tax Income Distribution") ytitle("Macroeconomic Uncertainty h=1") legend(off)

graph export $output/scatter_h1_skew.png, replace

scatter u_h1 m4post, mlabel(year) || lfit u_h1 m4post, xtitle("Kurtosis of Post-tax Income Distribution") ytitle("Macroeconomic Uncertainty h=1") legend(off)

graph export $output/scatter_h1_kurt.png, replace

*relate post-tax distributions moments to u_h3
scatter u_h3 m2post, mlabel(year) || lfit u_h3 m2post, xtitle("Variance of Post-tax Income Distribution") ytitle("Macroeconomic Uncertainty h=3") legend(off)

graph export $output/scatter_h3_var.png, replace

scatter u_h3 m3post, mlabel(year) || lfit u_h3 m3post, xtitle("Skewness of Post-tax Income Distribution") ytitle("Macroeconomic Uncertainty h=3") legend(off)

graph export $output/scatter_h3_skew.png, replace

scatter u_h3 m4post, mlabel(year) || lfit u_h3 m4post, xtitle("Kurtosis of Post-tax Income Distribution") ytitle("Macroeconomic Uncertainty h=3") legend(off)

graph export $output/scatter_h3_kurt.png, replace

*relate post-tax distributions moments to u_h12
scatter u_h12 m2post, mlabel(year) || lfit u_h12 m2post, xtitle("Variance of Post-tax Income Distribution") ytitle("Macroeconomic Uncertainty h=12") legend(off)

graph export $output/scatter_h12_var.png, replace

scatter u_h12 m3post, mlabel(year) || lfit u_h12 m3post, xtitle("Skewness of Post-tax Income Distribution") ytitle("Macroeconomic Uncertainty h=12") legend(off)

graph export $output/scatter_h12_skew.png, replace

scatter u_h12 m4post, mlabel(year) || lfit u_h12 m4post, xtitle("Kurtosis of Post-tax Income Distribution") ytitle("Macroeconomic Uncertainty h=12") legend(off)

graph export $output/scatter_h12_kurt.png, replace

*generate consumption variables
gen logpce = log(table243urealpersonalcons)
gen lag_logpce = logpce[_n-1]
gen fd_logpce = logpce - lag_logpce
gen cons_growth = fd_logpce*100
gen forward = cons_growth[_n+1]

*generate interaction variables
gen int_uh1m2post = u_h1*m2post
gen int_uh1m3post = u_h1*m3post
gen int_uh1m4post = u_h1*m4post

gen int_uh3m2post = u_h3*m2post
gen int_uh3m3post = u_h3*m3post
gen int_uh3m4post = u_h3*m4post

gen int_uh12m2post = u_h12*m2post
gen int_uh12m3post = u_h12*m3post
gen int_uh12m4post = u_h12*m4post

*relate pce to uncertainty
scatter fd_logpce u_h3, mlabel(year) || lfit fd_logpce u_h3, xtitle("Macroeconomic Uncertainty h=3") ytitle("Percent change in real consumption") legend(off)

graph export $output/scatter_pce_h3.png, replace

scatter fd_logpce u_h12, mlabel(year) || lfit fd_logpce u_h12, xtitle("Macroeconomic Uncertainty h=12") ytitle("Percent change in real consumption") legend(off)

graph export $output/scatter_pce_h12.png, replace

scatter forward u_h12, mlabel(year) || lfit forward u_h12, xtitle("Macroeconomic Uncertainty h=12") ytitle("Percent change in real consumption next year") legend(off)

graph export $output/scatter_pceforward_h12.png, replace

*relate pce to moments
scatter fd_logpce m2post, mlabel(year) || lfit fd_logpce m2post, xtitle("Variance of Post-tax Income Distribution") ytitle("Percent change in real consumption") legend(off)

graph export $output/scatter_pce_var.png, replace

scatter fd_logpce m3post, mlabel(year) || lfit fd_logpce m3post, xtitle("Skewness of Post-tax Income Distribution") ytitle("Percent change in real consumption") legend(off)

scatter fd_logpce m4post, mlabel(year) || lfit fd_logpce m4post, xtitle("Kurtosis of Post-tax Income Distribution") ytitle("Percent change in real consumption") legend(off)

scatter forward m2post, mlabel(year) || lfit forward m2post, xtitle("Variance of Post-tax Income Distribution") ytitle("Percent change in real consumption next year") legend(off)  xscale(range(0 4.5e+11))

graph export $output/scatter_pceforward_var.png, replace

scatter forward m3post, mlabel(year) || lfit forward m3post, xtitle("Skewness of Post-tax Income Distribution") ytitle("Percent change in real consumption next year") legend(off)  xscale(range(0 2900))

graph export $output/scatter_pceforward_skew.png, replace

scatter forward m4post, mlabel(year) || lfit forward m4post, xtitle("Kurtosis of Post-tax Income Distribution") ytitle("Percent change in real consumption next year") legend(off) xscale(range(0 9000000))

graph export $output/scatter_pceforward_kurt.png, replace


*relate pce to interaction
scatter fd_logpce int_uh1m2post, mlabel(year) || lfit fd_logpce int_uh1m2post, xtitle("Macroeconomic Uncertainty h=1 x Variance") ytitle("Percent change in real consumption") legend(off)

graph export $output/scatter_pce_h1var.png, replace

scatter fd_logpce int_uh1m3post, mlabel(year) || lfit fd_logpce int_uh1m3post, xtitle("Macroeconomic Uncertainty h=1 x Skewness") ytitle("Percent change in real consumption") legend(off)

graph export $output/scatter_pce_h1skew.png, replace

*

scatter fd_logpce int_uh3m2post, mlabel(year) || lfit fd_logpce int_uh3m2post, xtitle("Macroeconomic Uncertainty h=3 x Variance") ytitle("Percent change in real consumption") legend(off)

graph export $output/scatter_pce_h3var.png, replace


scatter fd_logpce int_uh3m3post, mlabel(year) || lfit fd_logpce int_uh3m3post, xtitle("Macroeconomic Uncertainty h=3 x Skewness") ytitle("Percent change in real consumption") legend(off)

graph export $output/scatter_pce_h3skew.png, replace

*

scatter fd_logpce int_uh12m2post, mlabel(year) || lfit fd_logpce int_uh12m2post, xtitle("Macroeconomic Uncertainty h=12 x Variance") ytitle("Percent change in real consumption") legend(off)

graph export $output/scatter_pce_h12var.png, replace


scatter fd_logpce int_uh12m3post, mlabel(year) || lfit fd_logpce int_uh12m3post, xtitle("Macroeconomic Uncertainty h=12 x Skewness") ytitle("Percent change in real consumption") legend(off)

graph export $output/scatter_pce_h12skew.png, replace

scatter forward int_uh12m2post, mlabel(year) || lfit forward int_uh12m2post, xtitle("Macroeconomic Uncertainty h=12 x Variance") ytitle("Percent change in real consumption next year") legend(off) xscale(range(0 4.5e+11))

graph export $output/scatter_pceforward_h12var.png, replace


scatter forward int_uh12m3post, mlabel(year) || lfit forward int_uh12m3post, xtitle("Macroeconomic Uncertainty h=12 x Skewness") ytitle("Percent change in real consumption next year") legend(off)

graph export $output/scatter_pceforward_h12skew.png, replace

scatter forward int_uh12m4post, mlabel(year) || lfit forward int_uh12m4post, xtitle("Macroeconomic Uncertainty h=12 x Kurtosis") ytitle("Percent change in real consumption next year") legend(off) xscale(range(0 9000000))

graph export $output/scatter_pceforward_h12kurt.png, replace

*basic regressions with no controls
*u_h3
regress forward u_h3 int_uh3m2post m2post
regress forward u_h3 int_uh3m2post int_uh3m3post m2post m3post
regress forward u_h3 int_uh3m2post int_uh3m3post  int_uh3m4post m2post m3post m4post
*u_h12
regress forward u_h12 int_uh12m2post m2post
regress forward u_h12 int_uh12m2post int_uh12m3post m2post m3post
regress forward u_h12 int_uh12m2post int_uh12m3post  int_uh12m4post m2post m3post m4post

