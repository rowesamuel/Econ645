*Replicate Card and Krueger
*Samuel Rowe
*Econ 645
*August 16, 2023

clear
set more off

*Set Working Directory
cd "/Users/Sam/Desktop/Econ 645/Data/njmin"

use njmin.dta, clear

*
sort SHEET

*Rename for reshape
rename (NCALLS EMPFT EMPPT NMGRS WAGE_ST INCTIME FIRSTINC MEALS OPEN HRSOPEN PSODA PFRY PENTREE NREGS NREGS11) ///
       (NCALLS1 EMPFT1 EMPPT1 NMGRS1 WAGE_ST1 INCTIME1 FIRSTINC1 MEALS1 OPEN1 HRSOPEN1 PSODA1 PFRY1 PENTREE1 NREGS1 NREGS111)

*Fix id error
duplicates list SHEET
replace SHEET=408 if SHEET==407 & CHAIN==4 & STATE==1

*Card and Kreuger account for PT workers as .5 Fulltime
gen emp1=EMPFT1+(.5*EMPPT1)+NMGRS1
gen emp2=EMPFT2+(.5*EMPPT2)+NMGRS2
sum emp1 emp2

*Reshape for panel
reshape long NCALLS EMPFT EMPPT NMGRS emp WAGE_ST INCTIME FIRSTINC MEALS OPEN HRSOPEN PSODA PFRY PENTREE NREGS NREGS11, i(SHEET) j(MONTH)

*Set Panel
xtset SHEET MONTH

*Sum the outcome
sum emp
tabstat emp, by(MONTH) statistics(n mean sd p25 p50 p75)


*Starting Wage
sum WAGE_ST
histogram WAGE_ST, by(MONTH)
bysort MONTH: tabulate WAGE_ST

*Gen wage bins
gen wagebins = 0
replace wagebins = 1 if WAGE_ST >= 4.25 & WAGE_ST < 4.35
replace wagebins = 2 if WAGE_ST >= 4.35 & WAGE_ST < 4.45
replace wagebins = 3 if WAGE_ST >= 4.45 & WAGE_ST < 4.55
replace wagebins = 4 if WAGE_ST >= 4.55 & WAGE_ST < 4.65
replace wagebins = 5 if WAGE_ST >= 4.65 & WAGE_ST < 4.75
replace wagebins = 6 if WAGE_ST >= 4.75 & WAGE_ST < 4.85
replace wagebins = 7 if WAGE_ST >= 4.85 & WAGE_ST < 4.95
replace wagebins = 8 if WAGE_ST >= 4.95 & WAGE_ST < 5.05
replace wagebins = 9 if WAGE_ST >= 5.05 & WAGE_ST < 5.15
replace wagebins = 10 if WAGE_ST >= 5.15 & WAGE_ST < 5.25
replace wagebins = 11 if WAGE_ST >= 5.25 & WAGE_ST < 5.35
replace wagebins = 12 if WAGE_ST >= 5.35 & WAGE_ST < 5.45
replace wagebins = 13 if WAGE_ST >= 5.45 & WAGE_ST < 5.55
replace wagebins = 14 if WAGE_ST >= 5.55 & WAGE_ST < 999
label variable wagebins "Wage Bins"
label define wagebins1 1 "4.25" 2 "4.35" 3 "4.45" 4 "4.55" 5 "4.65" ///
                       6 "4.75" 7 "4.85" 8 "4.95" 9 "5.05" 10 " 5.15" ///
					   11 "5.25" 12 "5.35" 13 "5.45" 14 "5.55"
label values wagebins wagebins1

*Get Starting Wage 4.25
tab WAGE_ST 
gen wage_nj1=.
replace wage_nj1 = 1 if WAGE_ST == 4.25 & MONTH==1
replace wage_nj1 = 2 if (WAGE_ST >= 4.26 & WAGE_ST < 5) & MONTH==1
replace wage_nj1 = 3 if (WAGE_ST >= 5 & WAGE_ST < 999) & MONTH==1
tab wage_nj1 STATE if MONTH ==1

*Get Store count
gen idcount = 1
graph bar EMPFT if MONTH==1, over(STATE) over(wagebins)

sort SHEET MONTH


gen emp = .
replace emp=EMPFT+(0.5*EMPPT)+NMGRS
sum emp if STATE==1 & MONTH==1
sum emp if STATE==1 & MONTH==2
sum emp if STATE==0 & MONTH==1
sum emp if STATE==0 & MONTH==2

*Test two-sample differences
ttest emp if MONTH==1, by(STATE)
ttest emp if MONTH==2, by(STATE)
ttest emp if STATE==1, by(MONTH)
ttest emp if STATE==0, by(MONTH)

*Simple 2-way DD
reg emp i.STATE##i.MONTH 
*Account for Serial Correlation
reg emp i.STATE##i.MONTH, cluster(STATE)
*Use Within Estimator
xtreg emp i.STATE##i.MONTH, fe

*Find stores with missing emp
gen empcount = 0
replace empcount = 1 if !missing(EMPFT) & !missing(EMPPT) & !missing(NMGRS)

bysort SHEET: egen idcount = sum(empcount)
tab idcount

