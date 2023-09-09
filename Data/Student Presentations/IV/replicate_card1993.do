*Replicate Card 1993 - Geographic Variation
*Samuel Rowe 
*Econ 645
*August 15, 2023

clear 
set more off

*Set working directory
cd "/Users/Sam/Desktop/Econ 645/Data/proximity"

use "proximity.dta", clear

*Generate experience
gen age66 = age76-10
gen exp=age76-ed76-6
replace exp = 0 if exp < 0
sum exp
gen expsq = exp*exp

*Natural log of wages
sum lwage76
sum wage76
gen ln_wage76 = ln(wage76)
sum ln_wage76
sum lwage78

*Married
gen married = 0
replace married = 1 if marsta76==1

*Education
sum ed76

sum exp
sum expsq
tab black
tab married
 
*Table 2
reg lwage76 ed76 exp expsq i.black i.south66 i.married  i.smsa76r
reg lwage76 ed76 exp expsq i.black i.south66 i.married i.smsa76r i.reg66* i.smsa66r
reg lwage76 ed76 exp expsq i.black i.south66 i.married i.smsa76r i.reg66* i.smsa66r ///
            momed daded i.nodaded i.nomomed

*Fist-stage
reg ed76 nearc4 exp expsq black south66 married smsa76r 
test nearc4

*Table 4.1
ivregress 2sls lwage76 (ed76=nearc4) exp expsq black south66 married smsa76r, robust
ivregress 2sls ln_wage76 (ed76=nearc4) exp expsq black south66 married smsa76r, robust
