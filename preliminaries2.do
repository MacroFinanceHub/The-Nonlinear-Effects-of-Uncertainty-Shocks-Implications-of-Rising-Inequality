*Creates timeseries dataset to test preliminaries with extended data from 1929-2013
*Author: Nisha Chikhale
*Date:02.06.2020
*Modified: 02.10.2020
*******************************************************************************
* Merge DINA shares, EPU Uncertainty series, and BEA Consumption data
*******************************************************************************
clear
* set directories
global output "/Users/nishachikhale/Documents/Stata/718proposal/output"
global bea "/Users/nishachikhale/Documents/Stata/718proposal/BEA"
global bls "/Users/nishachikhale/Documents/Stata/718proposal/BLS"
global frb "/Users/nishachikhale/Documents/Stata/718proposal/FRB"
*merge datasets
import excel using "$bea/PCECCA.xls", sh("FRED Graph") cellrange(A11:B102) firstrow case(lower) clear
gen year = year(observation_date)
merge 1:1 year using "$output/annualepu_2000-2014.dta"
drop _merge
merge 1:1 year using "$output/dinashares_1913-2016.dta"
drop _merge
merge 1:1 year using "$output/annualu_60-19.dta" 
drop _merge

*generate consumption variables
gen logpce = log(pcecca)
gen lag_logpce = logpce[_n-1]
gen fd_logpce = logpce - lag_logpce
gen cons_growth = fd_logpce*100
gen forward = cons_growth[_n+1] 
*cons_growth = percent change in real consumption this year
*forward = percent change in real consumption next year

save "$output/prelim_1913-2016.dta", replace

drop if pcecca == . | avg_epu == .
*generate interaction variables
gen int_aepu1090 = avg_epu*top10bot90
gen int_aepu105 = avg_epu*top10to5
gen int_aepu101 = avg_epu*top10to1

gen int_depu1090 = epu_dec*top10bot90
gen int_depu105 = epu_dec*top10to5
gen int_depu101 = epu_dec*top10to1
gen int_depu10 = epu_dec*top10


save "$output/prelim_1929-2013.dta", replace

*merge more data on TFP and generate TFP growth
import excel using "$frb/quarterly_tfp.xlsx", sh("annual") cellrange(A1:L74) firstrow case(lower) clear
gen year = date
merge 1:1 year using "$output/prelim_1929-2013.dta"
drop _merge

gen tfp_pc = ((dtfp - dtfp[_n-1])/dtfp[_n-1])*100
gen tfp_pcf = tfp_pc[_n+1]


********************************************************************************
*SCATTER PLOTS--FULL SAMPLE

*relate log consumption to uncertainty in december
scatter fd_logpce epu_dec, mlabel(year) || lfit fd_logpce epu_dec, xtitle("Economic Policy Uncertainty (as of december)") ytitle("Percent change in real consumption") legend(off)
graph export $output/plots/scatter_pce_epu12.png, replace

scatter forward epu_dec, mlabel(year) || lfit forward epu_dec, xtitle("Economic Policy Uncertainty (as of december)") ytitle("Percent change in real consumption next year") legend(off) xscale(range(35 260))
graph export $output/plots/scatter_pceforward_epu12.png, replace

scatter forward u_dec_h12, mlabel(year) || lfit forward u_dec_h12, xtitle("JLN Macroeconomic Uncertainty h=12") ytitle("Percent change in real consumption next year") legend(off) 
graph export $output/plots/scatter_pceforward_udech12.png, replace

*relate log consumption to average annual uncertainty
scatter fd_logpce avg_epu, mlabel(year) || lfit fd_logpce avg_epu, xtitle("Average Macroeconomic Uncertainty") ytitle("Percent change in real consumption") legend(off)
graph export $output/plots/scatter_pce_avgepu.png, replace

scatter forward avg_epu, mlabel(year) || lfit forward avg_epu, xtitle("Average Macroeconomic Uncertainty") ytitle("Percent change in real consumption next year") legend(off)

graph export $output/plots/scatter_pceforward_avgepu.png, replace

*relate log consumption to DINA shares
scatter fd_logpce top10bot90, mlabel(year) || lfit fd_logpce top10bot90, xtitle("10/90 percentiles of the Post-tax Income Distribution") ytitle("Percent change in real consumption")legend(off)

scatter fd_logpce top10to5, mlabel(year) || lfit fd_logpce top10to5, xtitle("10/5 percentiles of the Post-tax Income Distribution") ytitle("Percent change in real consumption")legend(off)

scatter fd_logpce top10to1, mlabel(year) || lfit fd_logpce top10to1, xtitle("10/1 percentiles of the Post-tax Income Distribution") ytitle("Percent change in real consumption")legend(off)

scatter forward top10bot90, mlabel(year) || lfit forward top10bot90, xtitle("10/90 percentiles of the Post-tax Income Distribution") ytitle("Percent change in real consumption next year")legend(off) xscale(range(0.4 0.85))
graph export $output/plots/scatter_pceforward_t10b90.png, replace

scatter forward top10to5, mlabel(year) || lfit forward top10to5, xtitle("10/5 percentiles of the Post-tax Income Distribution") ytitle("Percent change in real consumption next year")legend(off)
graph export $output/plots/scatter_pceforward_t10t5.png, replace

scatter forward top10to1, mlabel(year) || lfit forward top10to1, xtitle("10/1 percentiles of the Post-tax Income Distribution") ytitle("Percent change in real consumption next year")legend(off)
graph export $output/plots/scatter_pceforward_t10t1.png, replace

scatter forward top10, mlabel(year) || lfit forward top10, xtitle("Top 10% of the Post-tax Income Distribution") ytitle("Percent change in real consumption next year")legend(off) xscale(range(0.3 0.46))
graph export $output/plots/scatter_pceforward_t10.png, replace

*relate log consumption to interactions
scatter fd_logpce int_aepu1090, mlabel(year) || lfit fd_logpce int_aepu1090, xtitle("Average Macroeconomic Uncertainty x 10/90 percentiles") ytitle("Percent change in real consumption") legend(off)

scatter fd_logpce int_aepu105, mlabel(year) || lfit fd_logpce int_aepu105, xtitle("Average Macroeconomic Uncertainty x 10/5 percentiles") ytitle("Percent change in real consumption") legend(off)

scatter fd_logpce int_aepu101, mlabel(year) || lfit fd_logpce int_aepu101, xtitle("Average Macroeconomic Uncertainty x 10/1 percentiles") ytitle("Percent change in real consumption") legend(off)

scatter fd_logpce int_depu1090, mlabel(year) || lfit fd_logpce int_depu1090, xtitle(" Macroeconomic Uncertainty in decemeber x 10/90 percentiles") ytitle("Percent change in real consumption") legend(off)

scatter fd_logpce int_depu105, mlabel(year) || lfit fd_logpce int_depu105, xtitle("Macroeconomic Uncertainty in december x 10/5 percentiles") ytitle("Percent change in real consumption") legend(off)

scatter fd_logpce int_depu101, mlabel(year) || lfit fd_logpce int_depu101, xtitle("Macroeconomic Uncertainty in december x 10/1 percentiles") ytitle("Percent change in real consumption") legend(off)

*

scatter forward int_aepu1090, mlabel(year) || lfit forward int_aepu1090, xtitle("Average Macroeconomic Uncertainty x 10/90 percentiles") ytitle("Percent change in real consumption next year") legend(off) 
graph export $output/plots/scatter_pceforward_aepu1090.png, replace

scatter forward int_aepu105, mlabel(year) || lfit forward int_aepu105, xtitle("Average Macroeconomic Uncertainty x 10/5 percentiles") ytitle("Percent change in real consumption next year") legend(off)
graph export $output/plots/scatter_pceforward_aepu105.png, replace

scatter forward int_aepu101, mlabel(year) || lfit forward int_aepu101, xtitle("Average Macroeconomic Uncertainty x 10/1 percentiles") ytitle("Percent change in real consumption next year") legend(off)
graph export $output/plots/scatter_pceforward_aepu101.png, replace

scatter forward int_depu1090, mlabel(year) || lfit forward int_depu1090, xtitle("Macroeconomic Uncertainty in decemeber x 10/90 percentiles") ytitle("Percent change in real consumption next year") legend(off) 
graph export $output/plots/scatter_pceforward_depu1090.png, replace

scatter forward int_depu105, mlabel(year) || lfit forward int_depu105, xtitle("Macroeconomic Uncertainty in december x 10/5 percentiles") ytitle("Percent change in real consumption next year") legend(off)
graph export $output/plots/scatter_pceforward_depu105.png, replace

scatter forward int_depu101, mlabel(year) || lfit forward int_depu101, xtitle("Macroeconomic Uncertainty in december x 10/1 percentiles") ytitle("Percent change in real consumption next year") legend(off)
graph export $output/plots/scatter_pceforward_depu101.png, replace

scatter forward int_depu10, mlabel(year) || lfit forward int_depu10, xtitle("Economic Policy Uncertainty (as of decmeber) x Top 10% share of income") ytitle("Percent change in real consumption next year") legend(off) xscale(range(20 110))
graph export $output/plots/scatter_pceforward_depu10.png, replace
********************************************************************************
*SCATTER PLOTS--1962,1964-2013
*merge in DINA moments post 1962 
merge 1:1 year using "$output/dinamoments62-16.dta"
drop _merge
*generate interaction variables
gen int_depum2post = epu_dec*m2post
gen int_uh12m2post = u_h12*m2post
gen int_uh12t10 = u_h12*top10
gen int_uh12m3post = u_h12*m3post
gen int_duh12m2post = u_dec_h12*m2post
gen int_duh12t10 = u_dec_h12*top10
gen int_duh12m3post = u_dec_h12*m3post
*BE CAREFUL ABOUT WHIC INTERACTION TERM YOU USE!

save "$output/prelim_1929-2016.dta", replace

********************************************************************************
*COMPARISON OF PLOTS W/DINA MOMENTS VS. SHARES USING SAME REAL CONSUMPTION MEASURE AND EPU INDEX

scatter forward int_depu10, mlabel(year) || lfit forward int_depu10, xtitle("Economic Policy Uncertainty (as of decmeber) x Top 10% share of income") ytitle("Percent change in real consumption next year") legend(off) xscale(range(20 110))
graph export $output/plots/scatter_pceforward_depu10.png, replace

scatter forward int_depum2post, mlabel(year) || lfit forward int_depum2post, xtitle("Economic Policy Uncertainty (as of decmeber) x Variance") ytitle("Percent change in real consumption next year") legend(off) 
graph export $output/plots/scatter_pceforward_depum2post_post62.png, replace

*
scatter forward m2post, mlabel(year) || lfit forward m2post, xtitle("Variance of post-tax income") ytitle("Percent change in real consumption next year") legend(off) xscale(range(4.5e11))
graph export $output/plots/scatter_pceforward_m2post.png, replace

********************************************************************************
*COMPARISON OF PLOTS W/DINA MOMENTS VS. SHARES USING SAME REAL CONSUMPTION MEASURE AND JLN UNCERTAINTY INDEX

scatter forward int_uh12t10, mlabel(year) || lfit forward int_uh12t10, xtitle("JLN Macroeconomic Uncertainty h=12 x Top 10% share of income") ytitle("Percent change in real consumption next year") legend(off) 
graph export $output/plots/scatter_pceforward_udec12t10_post60.png, replace

scatter forward int_uh12m2post, mlabel(year) || lfit forward int_uh12m2post, xtitle("JLN Macroeconomic Uncertainty h=12 x Variance") ytitle("Percent change in real consumption next year") legend(off)  xscale(range(0 4.5e11))
graph export $output/plots/scatter_pceforward_udec12m2post_post62.png, replace
********************************************************************************
*FOR THE COMPARISON OF EPU TO JLN 
drop if m1post == .

scatter forward epu_dec, mlabel(year) || lfit forward epu_dec, xtitle("Economic Policy Uncertainty (as of december)") ytitle("Percent change in real consumption next year") legend(off) xscale(range(50 260))
graph export $output/plots/scatter_pceforward_epu12_post62.png, replace
********************************************************************************
*RELATE UNCERTAINTY TO INEQUALITY
scatter epu_dec top10, mlabel(year) || lfit epu_dec top10, xtitle("Top 10% share of income") ytitle("Economic Policy Uncertainty (as of december)") legend(off) 

scatter u_dec_h12 top10, mlabel(year) || lfit u_dec_h12 top10, xtitle("Top 10% share of income") ytitle("JLN Macroeconomic Uncertainty h=12") legend(off) 

scatter u_dec_h12 m2post, mlabel(year) || lfit u_dec_h12 m2post, xtitle("Variance of post-tax income") ytitle("JLN Macroeconomic Uncertainty h=12") legend(off)


********************************************************************************
*generate dummy for pre and post 1990 to split the sample
gen d = 0 
replace d = 1 if year >= 1990

use "$output/prelim_1929-2016.dta", replace
drop if year>=1990

scatter forward int_uh12m2post, mlabel(year) || lfit forward int_uh12m2post, xtitle("JLN Macroeconomic Uncertainty h=12 x Variance") ytitle("Percent change in real consumption next year") legend(off)
graph export $output/plots/scatter_pceforward_udec12m2post_62-90.png, replace

scatter forward int_uh12t10, mlabel(year) || lfit forward int_uh12t10, xtitle("JLN Macroeconomic Uncertainty h=12 x Top 10% share of income") ytitle("Percent change in real consumption next year") legend(off) 
graph export $output/plots/scatter_pceforward_udec12t10_60-90.png, replace

use "$output/prelim_1929-2016.dta", replace
drop if year<1990

scatter forward int_uh12m2post, mlabel(year) || lfit forward int_uh12m2post, xtitle("JLN Macroeconomic Uncertainty h=12 x Variance") ytitle("Percent change in real consumption next year") legend(off)
graph export $output/plots/scatter_pceforward_udec12m2post_90-13.png, replace

scatter forward int_uh12t10, mlabel(year) || lfit forward int_uh12t10, xtitle("JLN Macroeconomic Uncertainty h=12 x Top 10% share of income") ytitle("Percent change in real consumption next year") legend(off) 
graph export $output/plots/scatter_pceforward_udec12t10_90-13.png, replace
*THIS DOESN'T TELL US MUCH
********************************************************************************
*(from discussions with Jack) Perhaps LHS variable should be the change in the consumption growth rate from one period ot the next  >>>>> gen rate = forward - cons_growth.
*I don't think this makes sense.

********************************************************************************
*USE TFP growth to explore if this should be RHS var
use "$output/prelim_1929-2016.dta", replace

scatter tfp_pc u_dec_h12, mlabel(year) || lfit tfp_pc u_dec_h12, xtitle("JLN Macroeconomic Uncertainty h=12") ytitle("Percent change in TFP") legend(off)  yscale(range(-6000 1000))
*graph export $output/plots/scatter_.png, replace
scatter tfp_pcf u_dec_h12, mlabel(year) || lfit tfp_pcf u_dec_h12, xtitle("JLN Macroeconomic Uncertainty h=12") ytitle("Percent change in TFP next year") legend(off)  


scatter tfp_pcf int_uh12m2post, mlabel(year) || lfit tfp_pcf int_uh12m2post, xtitle("JLN Macroeconomic Uncertainty h=12 x Variance") ytitle("Percent change in TFP next year") legend(off) 

scatter tfp_pcf int_uh12t10, mlabel(year) || lfit tfp_pcf int_uh12t10, xtitle("JLN Macroeconomic Uncertainty h=12 x Top 10% share of income") ytitle("Percent change in TFP next year") legend(off) 

scatter tfp_pcf int_depum2post, mlabel(year) || lfit tfp_pcf int_depum2post, xtitle("EPU as of decemeber x Variance") ytitle("Percent change in TFP next year") legend(off) 
