*Create other post-tax distributional measures that we can find pre-1962 to use instead of moments
*Author: Nisha Chikhale
*Date:02.06.2020
*Modified: 
*******************************************************************************
* FIND POST-TAX DISTRIBUTIONAL MOMENTS PRE-1962 AND CREATE DATASET
*******************************************************************************
clear
* set directories
global dina "/Users/nishachikhale/Documents/Stata/DistributionalNationalAccountsData"
global output "/Users/nishachikhale/Documents/Stata/718proposal/output"

import excel using "$dina/PSZ2017AppendixTablesII(Distrib).xlsx", sh("TC1") cellrange(A9:S117)firstrow case (lower) clear

gen year = a
gen top10bot90 = top10/bottom90

keep year bottom90 top10 top5 top1 top10bot90 top10to1 top10to5 top5to1 

save "$output/dinashares_1913-2016.dta", replace
