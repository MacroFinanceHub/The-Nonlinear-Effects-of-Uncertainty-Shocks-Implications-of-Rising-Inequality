*Begin VAR analysis
*Author: Nisha Chikhale
*Date:02.18.2020
*Modified: 03.09.2020
*******************************************************************************
* 
*******************************************************************************
clear
* set directories
global output "/Users/nishachikhale/Documents/Stata/718proposal/output"
global bls "/Users/nishachikhale/Documents/Stata/718proposal/BLS"
global frb "/Users/nishachikhale/Documents/Stata/718proposal/FRB"
global bea "/Users/nishachikhale/Documents/Stata/718proposal/BEA"

*load and merge datasets
import excel using "$bls/SeriesReport-CPSepop.xlsx", sh("BLS Data Series") cellrange(A12:N84) firstrow case(lower) clear
keep year annual
rename annual epop
merge 1:1 year using "$output/prelim_1913-2016.dta"
drop _merge newyear month
merge 1:1 year using "$output/dinamoments62-16.dta"
drop _merge 
save "$output/varanalysis.dta", replace
import excel using "$frb/FEDFUNDS.xls", sh("FRED Graph") cellrange(A11:B75) firstrow case(lower) clear
gen year = year(observation_date)
merge 1:1 year using "$output/varanalysis.dta"
drop _merge
save "$output/varanalysis.dta", replace
import excel using "$frb/INDPRO_ann.xls", sh("FRED Graph") cellrange(A11:B112) firstrow case(lower) clear
gen year = year(observation_date)
merge 1:1 year using "$output/varanalysis.dta"
drop _merge
gen int_depu10 = epu_dec*top10
gen int_duh12t10 = u_dec_h12*top10
gen int_duh12m2post = u_dec_h12*m2post
gen int_duh12m3post = u_dec_h12*m3post
gen int_duh12m4post = u_dec_h12*m4post
save "$output/varanalysis.dta", replace
import excel using "$bea/GDPCA.xls", sh("FRED Graph") cellrange(A11:B102) firstrow case(lower)clear
gen year = year(observation_date)
merge 1:1 year using "$output/varanalysis.dta"
save "$output/varanalysis.dta", replace


*first 2 regressions are v. imprecise
regress forward epu_dec top10 int_depu10  
eststo: regress forward u_dec_h12 top10 int_duh12t10 

*this one is the only one with something but also uses only 50 obs.
eststo: regress forward u_dec_h12 m2post int_duh12m2post 
esttab using "$output/latex/varanalysis1.tex",se label nostar title(Regression table\label{tab1}) replace
eststo clear
*if you add the skewness then the regression becomes less precise
regress forward u_dec_h12 m2post m3post int_duh12m2post int_duh12m3post

* add control for epop
regress forward u_dec_h12 m2post int_duh12m2post epop

* add control for % change in fed funds 
regress forward u_dec_h12 m2post int_duh12m2post epop fedfunds_pc1
regress forward u_dec_h12  int_duh12m2post epop fedfunds_pc1

*initial specification (drop m1post)
eststo: regress forward u_dec_h12 m2post int_duh12m2post
eststo: regress forward u_dec_h12 m2post int_duh12m2post m3post int_duh12m3post
eststo: regress forward u_dec_h12 m2post int_duh12m2post m3post int_duh12m3post m4post int_duh12m4post
esttab using "$output/latex/varanalysis2.tex",se label nostar title(Regression table\label{tab1}) replace
eststo clear

*include controls in initial specification
regress forward u_dec_h12 m2post int_duh12m2post m3post int_duh12m3post m4post int_duh12m4post epop fedfunds_pc1
********************************************************************************
*1) Need to redo the initial specification so that the units of var(income dist.) make sense to interpret
*ie. If I double the variance what will the effect on y consumption growth be?
*option 1: divide by sd of var(income dist.) to normalize:
egen sd_var = sd(m2post)
egen sd_sk = sd(m3post)
egen sd_ku = sd(m4post)
egen sd_udec = sd(u_dec_h12)

gen M2 = m2post/sd_var
gen M3 = m3post/sd_sk
gen M4 = m4post/sd_ku
gen Udec = u_dec_h12/sd_udec
gen Int1 = M2*Udec
gen Int2 = M3*Udec
gen Int3 = M4*Udec

*option 2: divide by the range of var(income dist.) to normalize

*Redo the regressions and compare:
eststo: regress forward Udec M2 Int1
eststo: regress forward Udec M2 Int1 M3 Int2
eststo: regress forward Udec M2 Int1 M3 Int2 M4 Int3
esttab using "$output/latex/varanalysis3.tex",se label nostar title(Regression table\label{tab1}) replace
eststo clear

*2) Then do this regression with a) log(ip) and b) output growth as the dependent variable
*a)generate ip variables
gen logip = log(indpro)
gen lag_logip = logip[_n-1]
gen fd_logip = logip - lag_logpce
gen ip_growth = fd_logip*100
gen forward_ip = ip_growth[_n+1] 

regress forward_ip Udec M2 Int1
regress fd_logip Udec M2 Int1

*b)generate output growth variables
gen loggdp = log(gdpca)
gen lag_loggdp = loggdp[_n-1]
gen fd_loggdp = loggdp - lag_loggdp
gen out_growth = fd_loggdp*100
gen forward_out = out_growth[_n+1]

regress forward_out Udec M2 Int1
