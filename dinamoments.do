*Creates moments of the pre and post tax national income distributions from 
*1962-2016 using microfiles from PSZ2017 (downloaded from http://gabriel-zucman.eu/usdina/ on 11.18.2019)
*Author: Nisha Chikhale
*Date:11.20.2019
*Modified: 11.23.2019
*******************************************************************************
* FIND FIRST 4 MOMENTS AND CREATE DATASET
*******************************************************************************
clear
* set directories
global dina "/Users/nishachikhale/Documents/Stata/DistributionalNationalAccountsData"
global dtafiles "$dina/PSZ2017Dinafiles"
global output "/Users/nishachikhale/Documents/Stata/718proposal/output"


global dinayears  "1962	1964	1966	1967	1968	1969	1970	1971	1972	1973	1974	1975	1976	1977	1978	1979	1980	1981	1982	1983	1984	1985	1986	1987	1988	1989	1990	1991	1992	1993	1994	1995	1996	1997	1998	1999	2000	2001	2002	2003	2004	2005	2006	2007	2008	2009	2010	2011	2012	2013	2014	2015	2016"

foreach year of numlist $dinayears {

*infile data
use "$dtafiles/usdina`year'.dta", clear
	gen year=`year'
	sum peinc [fw=dweght], detail
	gen m1pre = r(mean)
	gen m2pre = r(Var)
	gen m3pre = r(skewness)
	gen m4pre = r(kurtosis)
	sum poinc [fw=dweght], detail
	gen m1post = r(mean)
	gen m2post = r(Var)
	gen m3post = r(skewness)
	gen m4post = r(kurtosis)

	collapse (mean) year m1pre m2pre m3pre m4pre m1post m2post m3post m4post 
	save "$output/dinamoments`year'.dta", replace
	append using "$output/dinamoments62-16.dta",
	duplicates drop
	save "$output/dinamoments62-16.dta", replace
	
	
}
outsheet year m2post using dinavar62-16.csv , comma 
