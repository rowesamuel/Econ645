*Econ 645
*Week 4: Fixed Effects (Within)
*Samuel Rowe Adapted from Wooldridge 
*August 6, 2023

clear 
set more off

*Set Working Directory
cd "/Users/Sam/Desktop/Econ 645/Data/Wooldridge"

********************************************************************************
*Wooldridge
********************************************************************************
****************************
*Union Wage Premium
****************************
*Lesson: we can control for ability and preference for unionization to control
*for unobserved time-invariant confounders.
use "wagepan.dta", clear

*Set the Panel
xtset nr year

*Pooled OLS
eststo OLS: reg lwage c.edu exper expersq i.black i.south i.married i.union i.d8*

*If we use FE or FD, we cannot assess race, education, or experience 
*since they remain constant
eststo Within: xtreg lwage c.edu i.black i.south i.married i.union i.d8*, fe

*These are changes in the returns to education compared to the base year of 1980
*And only 1987xeducation and 1986xeducation appear to be insignificant

esttab OLS Within, mtitles se scalars(F r2) drop(0.d* 0.union 0.married)

*After controlling for time-invariant individual fixed effects the Pooled
*OLS is seen to be upward biased.
*Pooled OLS
display (exp(.180)-1)*100
*FE Within
display (exp(.0844)-1)*100

*Plot the Coefficients of Interest
*Store the models
*Credit: John Kane: https://medium.com/the-stata-gallery/making-regression-coefficient-plots-in-stata-7b100feac0cb
quietly reg lwage c.edu exper expersq i.black i.south i.married i.union i.d8*
estimates store pooled
quietly xtreg lwage c.edu i.black i.south i.married i.union i.d8*, fe
estimates store fe
coefplot (pooled, label("{bf:Pooled OLS}") mcolor(midblue) mlcolor(cyan) ///
                  ciopts(lcolor(magenta midblue))) /// options for first group
	     (fe, label("{bf: Within}") mcolor(green) mlcolor(lime) ///
		      ciopts(lcolor(lime green))), /// options for second gropu
	     title(Union and Marriage Wage Premiums) ///
		 drop(_cons 1.d* 0.black 0.south) ///
		 xline(0, lcolor(red) lwidth(medium)) scheme(jet_white) ///
		 xtitle("{bf: Effect of Union}") ///
		 graphregion(margin(small)) ///
		 coeflabels(educ="Education" exper="Experience" expersq="Experience Squared" ///
		            1.black="Black" 1.south="South" 1.married="Married" ///
					1.union="Union") ///
		 msize(large) mcolor(%85) mlwidth(medium) msymbol(circle) /// marker options
		 levels(95 90) ciopts(lwidth(medthick thick) recast(rspike rcap)) ///ci options for all groups
		 legend(ring(1) col(1) pos(3) size(medsmall))
graph export "/Users/Sam/Desktop/Econ 645/Stata/week4_union_wage_premium.png", replace
  

****************************
*Has returns to education changed over time
****************************
*Lesson: We can interact time binaries with continuous time-invariant data to
*see if returns to education have changed over time.

*With fixed effects or first differencing, we cannot assess time-invariant
*variables. Variables that do not vary over time, such as sex, race, or 
*education (assuming) education is static. But, if we interact education with
*time binaries, we can assess whether returns to education have increased 
*over time.

*We can test to see if returns to education are constant
*over time, by in

use "wagepan.dta", clear

* Vella and Verbeek (1998) estimate to see if the returns to education have
* change over time. We have some variables that are not time-invariant, such
* as union status and marital status. Experience does growth but it grows at
* a constant rate. We have a few variable that do not (or we would expect 
* not to change), such as race and education (for older workers). 

* We use the natural log of wages, which have nice properties, such as 
* being are more normally distributed and providing elasticities. It also 
* can take care of inflation when we add time period binaries.

xtset nr year

*Pooled OLS
eststo OLS: reg lwage c.edu##i.d8* exper expersq i.married i.union

*If we use FE or FD, we cannot assess race, education, or experience 
*since they remain constant, but we can include dummy interactions
eststo Within: xtreg lwage c.edu##i.d8* i.married i.union, fe

*These are changes in the returns to education compared to the base year of 1980
*And only 1987xeducation and 1986xeducation appear to be insignificant

esttab OLS Within, mtitles se scalars(F r2) drop(0.d* 0.union 0.married)

*Returns to education have increased by about 3.1% between 1987 and 1980.
display (exp(0.0304)-1)*100

*Plot the Coefficients of Interest
*Store the models
*Credit: John Kane: https://medium.com/the-stata-gallery/making-regression-coefficient-plots-in-stata-7b100feac0cb
quietly reg lwage c.edu##i.d8* exper expersq i.married i.union
estimates store pooled
quietly xtreg lwage c.edu##i.d8* i.married i.union, fe
estimates store fe
coefplot (pooled, label("{bf:Pooled OLS}") mcolor(midblue) mlcolor(cyan) ///
                  ciopts(lcolor(magenta midblue))) /// options for first group
	     (fe, label("{bf: Within}") mcolor(green) mlcolor(lime) ///
		      ciopts(lcolor(lime green))), /// options for second gropu
	     title("Change in Return to Education") ///
		 keep(educ 1.d81#c.educ 1.d82#c.educ 1.d83#c.educ 1.d84#c.educ ///
		           1.d85#c.educ 1.d86#c.educ 1.d87#c.educ) ///
		 xline(0, lcolor(red) lwidth(medium)) scheme(jet_white) ///
		 xtitle("{bf: Coefficients}") ///
		 graphregion(margin(small)) ///
		 coeflabels(educ="Education" 1.d81#c.educ="1981 Returns" ///
		            1.d82#c.educ="1982 Returns" 1.d83#c.educ="1983 Returns" ///
					1.d84#c.educ="1984 Returns" 1.d85#c.educ="1985 Returns" ///
					1.d86#c.educ="1986 Returns" 1.d87#c.educ="1987 Returns") ///
		 msize(large) mcolor(%85) mlwidth(medium) msymbol(circle) /// marker options
		 levels(95 90) ciopts(lwidth(medthick thick) recast(rspike rcap)) ///ci options for all groups
		 legend(ring(1) col(1) pos(3) size(medsmall))
graph export "/Users/Sam/Desktop/Econ 645/Stata/week4_edu_returns.png", replace


*Test for Serial Correlation
xtreg lwage c.edu##i.d8* i.married i.union, fe
*predict u residuals
predict u, resid
*regress u on lag of u AR(1) model without a constant
reg u l.u, noconst
*Our null hypothesis is that there is no serial correlation or the coefficient
*on our lagged residuals is zero. 
*We can see that we have positive serial correlation since the coefficient on
*our lagged residual is positive and statistically significant.
*We will need to cluster our standard errors to account for the positive 
*serial correlation

***
*Wage Gap
***

*If we use FE or FD, we cannot assess race, education, or experience 
*since they remain constant, but we can include dummy interactions

*Let's test this for a wage gap between Black workers and non-Black workers.
*With Fixed Effects (Within) estimator we cannot estimate the wage gap, so
*we'll use Pooled OLS 
est clear
eststo OLS: reg lwage c.edu##i.d8* i.black##i.d8* exper expersq i.married i.union

eststo Within: xtreg lwage c.edu##i.d8* i.black##i.d8* i.married i.union, fe

esttab OLS Within, mtitles se scalars(F r2) drop(0.d* 0.b* 1.black#0.d* 0.union 0.married)

*Test for Serial Correlation
xtreg lwage c.edu##i.d8* i.black##i.d8* i.married i.union, fe
*predict u residuals
predict u1, resid
*regress u on lag of u AR(1) model without a constant
reg u1 l.u1, noconst
*Our null hypothesis is that there is no serial correlation or the coefficient
*on our lagged residuals is zero. 
*We can see that we have positive serial correlation since the coefficient on
*our lagged residual is positive and statistically significant.
*We will need to cluster our standard errors to account for the positive 
*serial correlation

****************************
*Returns to Marriage for Men
****************************
*Lesson: We can test to see if random effects is an appropriate assumption.

*We'll use three methods to estimate the returns to marriage for men: Pooled OLS,
*Fixed Effects (Within), and Random Effects. We cannot estimate the coefficients
*for Black and Latino/Latina. 

use "wagepan.dta", clear

* We can use the wagepan data again to estimate the returns to marriage for
* men. We will compare the Pooled OLS, FE (Within), and Random Effects estimates

*Set Panel
xtset nr year

*Pooled OLS
reg lwage educ i.black i.hisp exper expersq married union i.d8*
eststo m1: quietly reg lwage educ i.black i.hisp exper expersq married union i.d8*

*The Pooled OLS data are likley upward biased - self-selection into marriage
*and we will have positive serial correlation so we really should cluster 
*our standard errors by the group id. 

* Our FE (Within)
xtreg lwage educ i.black i.hisp exper expersq married union i.d8*, fe
* We use estimates store to store our FE (Within) estimates to compare
estimates store femodel
eststo m2: quietly xtreg lwage educ i.black i.hisp exper expersq married union i.d8*, fe

* Random Effects
* We can use the theta option to find the lambda-hat GLS transformaton
* https://www.stata.com/manuals/xtxtreg.pdf
xtreg lwage educ i.black i.hisp exper expersq married union i.d8*, re theta
eststo m3: quietly xtreg lwage educ i.black i.hisp exper expersq married union i.d8*, re

*Our lambda-hat is 0.643, which means it is closer to the FE estimator than
*the Pooled OLS estimator. 

*Hausman Test
hausman femodel ., sigmamore
* We reject the null hypothesis and a_i is correlated with the explanatory 
* variables - We reject the Random Effects Model

esttab m1 m2 m3, drop(0.black 0.hisp 0.d8*) ///
                 mtitles("Pooled OLS" "Within Model" "RE Model")

display (exp(.108)-1)*100
display (exp(.0467)-1)*100
display (exp(.064)-1)*100

*We can see that the marriage premium falls from 11.4% in Pooled OLS to 4.8%
*in Fixed Effects. If we didn't reject our RE model, it would have been 6.6%.

*The difference between the 11.4% Pooled OLS and the 4.8% in the Within Model
*might comes from self-selection in marriage (they would have made more money
*even if they weren't married), and employers paying married men more if 
*marriage is a sign of stability. But, we cannot distinguish these two 
*hypothesis with this research design.

*Plot the Coefficients
quietly reg lwage educ i.black i.hisp exper expersq married union i.d8*
estimates store pooled
quietly xtreg lwage educ i.black i.hisp exper expersq married union i.d8*, fe
estimates store fe
quietly xtreg lwage educ i.black i.hisp exper expersq married union i.d8*, re theta
estimates store re
coefplot (pooled, label("{bf:Pooled OLS}") mcolor(midblue) mlcolor(cyan) ///
                  ciopts(lcolor(magenta midblue))) /// options for first group
	     (fe, label("{bf: Within}") mcolor(green) mlcolor(lime) ///
		      ciopts(lcolor(lime green))) /// options for second group
		 (re, label("{bf: Random Effects}") mcolor(yellow) mlcolor(gold) ///
		      ciopts(lcolor(gold yellow))), /// options for third group
	     title("Returns to Marriage for Men") ///
		 keep(married) ///
		 xline(0, lcolor(red) lpattern(dash) lwidth(medium)) scheme(jet_white) ///
		 xtitle("{bf: Coefficients}") ///
		 graphregion(margin(small)) ///
		 coeflabels(married="Married") ///
		 msize(large) mcolor(%85) mlwidth(medium) msymbol(circle) /// marker options
		 levels(95 90) ciopts(lwidth(medthick thick) recast(rspike rcap)) ///ci options for all groups
		 legend(ring(1) col(1) pos(3) size(medsmall))
graph export "/Users/Sam/Desktop/Econ 645/Stata/week4_married_returns.png", replace

				 
***********
*Exercises
***********
* 1)
use "rental.dta", clear

* The data on rentla prices and other variables in college towns from 1980 to
* 1990. Do more students affect the prices? The general model with unobserved
* fixed effects is 
*   ln(rent)=b0+d0*y90+b1*ln(pop)+b2*ln(avginc)+b3*pctstu+a_i+u_i
* Where pop is city population
*       avginc is average income
*       pctstu is the student percent of the population
*       rent is the nominal rental prices

* Estimate a Pooled OLS. What does the estimate on y90 tell you?
* Are there concerns with the standard errors in the Pooled OLS?
* Use a First difference model. Does the coefficient on b3 change?
* Use a FE Within model. Are the results the same as the FD model?

reg lrent i.y90 lpop lavginc pctstu, robust
*Set the Panel
xtset city year, delta(10)
*FD
reg d.lrent i.y90 d.lpop d.lavginc d.pctstu
*FE
xtreg lrent i.y90 lpop lavginc pctstu, fe

* 2)
use "airfare.dta", clear

* We will assess concentration of airline on airfare.
* Our model
*     ln(fare) = b0 + b1*concen + b2*ln(dist) + b3*(ln(dist))^2 + a_i + u_i

* Estimate the Pooled OLS with time binaries
reg lfare concen ldist ldistsq i.y99 i.y00
* What does a change in concen of 10 for airfare?
sum concen
* What does the quadratic on distance mean 
* Decreasing at a increasing rate - use quadratic formula for when distance on
* airfare is 0
* Estimate a RE model
xtset id year
xtreg lfare concen ldist ldistsq i.y99 i.y00, re theta
* Estimate a FE model
xtreg lfare concen ldist ldistsq i.y99 i.y00, fe

********************************************************************************
*Mitchell
********************************************************************************
*Chapter 6: Creating variables
*Generate and replace will be the workhorses of creating and modifying variables
*We'll deal with generating binary variables
*We'll look into missing data and how to handle it
*Note: Please do not label your missing data, it just is a pain to deal with later
*Egen is also a very practical and useful command (I wish other software 
*packages had this feature that is so easy to implement
*We'll deal with strings and converting between numerics and strings
*We'll also work with rename


************
*Creating and changing variables
************
* One of the most basic tasks is to create, replace, and modify variables.
* Stata provides some nice and easy commands to work with variable 
* generation and modification relative to other statistical software
* packages.

* The generate command and replace command will be important, but 
* Stata has a very helpful command called egen. It can be used to
* create new variables from old variables, especially when working
* with groups of observations. Egen becomes even more helpful when
* it is combined with bysort. We can sort our group and find the 
* max, min, sum, etc. of a group of observations, which can come in
* handy when we are working with panel data

* Futhermore, using indexes can make our generation commands more 
* useful for creating lags or rebasing our data.

*****************
* 6.2 Creating and changing variables
*****************
* Set our working directory
cd "/Users/Sam/Desktop/Econ 645/Data/Mitchell"

* Let's get our data
use wws, clear

**
*Generate command
**
* The generate command is one that you have plenty of experience with
* already, but there are some helpful tips when working with generate.
* What we'll do first is to create a new variable called weekly wages.
* This will be based off of hourly wages and hours at work by women.

* Let's look at hourly wages for women
summarize wage
* Look for outliers
list id wage if wage > 1000
* A histogram is helpful too
histogram wage if wage < 1000

* Let's look at hours
summarize hours

* Let's look at histogram of hours
histogram hours

* Let's create our weekly wages
gen weekwage = wage*hours

* We'll summarize our new variable
summarize weekwage, detail
* We need to find our oultiers
list id weekwage if weekwage > 80000
* Notice!  Our missing values were captured in our outlier check!
* Why? Because missing values are considered very large values. 
* This is important because when creating binary or categorical 
* variables through qualifiers, make sure you top code your qualifiers
* For example, if we are creating a binary on part-time vs full-time
* We need to top code so we don't count missing hours as full-time
* workers, such as hours > 35 & hours < 999999, 
* or, hours > 35 & !missing(hours), оr else you may categorize 
* missing hours as full-time.

* Let's plot our weekly wages
histogram weekwage if weekwage < 80000 

* Another helpful trick is the before and after options
* It might be helpful to have the newly created variable next
* to a similar variable, so let's drop our variable and generate it
* again with the after option
drop weekwage

gen weekwage = wage*hours, after(wage)

**
*Replace
**
* We use our replace command to modify a variable that has already
* been created. Similar to generate, you probably already have experience
* with replace, but we'll go over some useful tips.

**
*Replace using categorical variable(s) in the qualifier
**

* Let's look at married and nevermarried variables
tabulate married nevermarried

* We'll create a categorical variable called maritalstatus.
gen maritalstatus = .
* I recommend generating a new categorical variable as missing instead of
* zero, because this prevents missing variables from being categorized 
* as 0.

* We generally use qualifers "=, >, <, >=, <=, !" when working with replace
* Let's replace the marital status variable with married and nevermarried
* as qualifiers
replace maritalstatus = 1 if married==0 & nevermarried==1
replace maritalstatus = 2 if married==1 & nevermarried==0
replace maritalstatus = 3 if married==0 & nevermarried==0

* It's always a good idea to double check the varilabes against
* the variables they were created from to make sure your categories
* are what they are supposed to be
tabulate maritalstatus
table maritalstatus married nevermarried

* Let's label our values similar to last week
* Labeling is a good practice for your future self or for others replicating
label define maritalstatus1 1 "Single" 2 "Married" 3 "Divorced or Widowed"
label values maritalstatus maritalstatus1
label variable maritalstatus "Marital Status"
tabulate maritalstatus

**
*Replace using continuous variables in the qualifier
**
* Let's create a new varible called over40hours which will be categorized
* as 1 if it is over 40 hours, and 0 if it is 40 or under.

generate over40hours = .
replace over40hours = 0 if hours <= 40
* We need to make sure we don't include missing values so we
* need an additional qualifier besides hours > 40. We need to 
* add !missing(hours)
replace over40hours = 1 if hours > 40 & hours < 99999

*****************
* 6.3 Numeric expressions and functions
*****************

* Our standard numeric expressions
* addition +, subtraction -, multiplication *, 
* division /, exponentiation ^, and parantheses () for changing
* order of operation.

* We also have some very useful numeric functions built into Stata
* int() function - removes any decimals
* round() function - rounds a number to the desired decimal place
*                    ***Please note that this is different from Excel!!!
*                    round(x,y) where x is your numeric and 
*                    y is the nearest value you wish to round to.
*                    For example, if y = 1, round(-5.2,1)=-5
*                                           round(4.5)=1
*                    For example, if y=.1, round(10.16,.1)=10.2
*                                          round(34.1345,.1)=34.1
*                    For example, if y=10, round(313.34,10)=310
*                                          round(4.52,10)=0
*                    Note: if y is missing, then it will round to 
*                    the nearest integer.  round(10.16)=10
*                    
* ln() function - is our natural log function which we use a lot for 
*                 transforming variables for elasticity estimates
* log10() function - is our logarithm base-10 function
* sqrt() function - is our square root function

display int(10.65)
display round(10.65,1)
*Please not int(10.65) returns 10, while round(10.65,1) returns 11
display ln(10.65)
display log10(10.65)
display sqrt(10.65)

**
*Random Numbers and setting seeds
**

* There are several random number generating functions in Stata
* runiform() is a random uniform distribution number generator
*            has a distribution between 0 and 1
* rnormal(m,sd) is a random normal distribution number generator
*           without arguments it will assume mean = 0 and sd = 1
* rchi2(df) is a random chi-squared distribution number generator
*           where df is the degrees of freedom that need to be specified

* Let's look at some examples

* Setting seeds is important if you want someone to replicate your results
* since a set seed will generate the same random number each time it is run.
set seed 12345

*Random uniform distribution 
gen runiformtest = runiform()
summarize runiformtest

*Random normal distribution
gen rnormaltest = rnormal()
gen rnormaltest2 = rnormal(100,15)
summarize rnormaltest rnormaltest2

*Random chi-squared distribution
gen rchi2test = rchi2(5)
summarize rchi2test

*****************
*6.4 String Expressions and functions
*****************
* Working with string can be a pain, but there are some very helpful 
* functions that will get your task completed. 
help string functions

*Let's get some new data to work with strings and their functions
use "authors.dta", clear

*We'll format the names with left-justification 17 characters long
format name %-17s

list name 

* Notice white space(s) in front of some names and some names are not
* in the proper format (lowercase for initial letter instead of upper).

* To fix these, we have a three string functions to work with
* ustrtitle() is the Unicode function to convert strings to title cases,
*             which means that the first letter is always upper and 
*             all others are lower case for each word.
* ustrlower() is the Unicode function to convert strings to lower case
* ustrupper() is the Unicode function to convert strings to upper case

* Please note that there are string function that do something similar
* but in ASCII. Our names are not in ASCII currently, so please note
* that not all string characters come in ASCII, but may come in Unicode.
*             strproper(), strlower(), strupper()

generate name2 = ustrtitle(name)
generate lowname = ustrlower(name)
generate upname = ustrupper(name)
*Format our strings to 23 length and left-justified
format name2 lowname upname %-23s
list name2 lowname upname

* We still need to get rid of leading white spaces in front of the
* names
* ustrltrim() will get reid of leading blanks
generate name3 = ustrltrim(name2)
format name2 name3 %-17s
list name name2 name3

* Let's work with the initials to identify the initial. In small
* datasets this is easy enough, but for large datasets we'll need to
* use some functions.

**
*substr functions
**
* One of the more practical string functions is the substr functions
* usubstr(s,n1,n2) is our Unicode substring 
* substr(s,n1,n2) is our ASCII substring
*     Where s is the string 
*     n1 is the starting position, 
*     n2 is the length 
display substr("abcdef",2,3)

* Let's find names that start with the initial with substr
* We'll start at the 2nd position and move 1 character
* Let's use ASCII and compare it to Unicode
gen secondchar = substr(name3,2,1)
gen firstinit = (secondchar == " " | secondchar == ".") if !missing(secondchar)
list name3 secondchar firstinit

* We might want to break up a string as well. This is helpful for names
* addresses, etc.
* We can use the strwordcount function
* ustrwordcount(s) - counts the number of words using word-boundary
*                    rules of Unicode strings
*                    Where s is the string input
generate namecount = ustrwordcount(name3)
list name3 namecount

* Notice that there are three authors have a word count of 4 instead of 3
* when it should be three.

* To extract the words after word count, we can use ustrword()
* ustrword(s,n) - returns the word in the string depending upon n
*                 Note: a positive n returns the nth word from the
*                       left, while a -n returns the nth word from
*                       the right
generate uname1=ustrword(name3,1)
generate uname2=ustrword(name3,2)
generate uname3=ustrword(name3,3)
generate uname4=ustrword(name3,4)

list name3 uname1 uname2 uname3 uname4 namecount

* It seems that ustrwordcount counts "." as separate words

* so let's use another very helpful string function called substr
* which comes in Unicode usubstr() and ASCII substr()
* usubinstr(s1,s2,s3,n) - replaces the nth occurance of s2 in s1 with s3
* subinstr(s1,s2,s3,n) - same thing but for ASCII 
* Where s1 is our string
*       s2 is the string we want to replace
*       s3 is the string we want instead
*       n is the nth occurance of s2.
*       If n is missing or implied, then all occurances of s2 will be replaced
generate name4 = usubinstr(name3,".","",.)
replace namecount = ustrwordcount(name4)
list name4 namecount

* Let's split the names 
gen fname = ustrword(name4,1)
gen mname = ustrword(name4,2) if namecount==3
gen lname = ustrword(name4,namecount)
format fname mname lname %-15s
list name4 fname mname lname

* Some names have the middle initial first, so let's rearrange
* The middle initial will only have a string length of one, so 
* we need our string length functions
* ustrlen(s) - returns the length of the string
* strlen(s) - same as above but for ASCII

* Let's add the period back to the middle initial if the string length is 1
replace fname=fname + "." if ustrlen(fname)==1
replace mname=mname + "." if ustrlen(mname)==1
list fname mname

* Let's make a new variable that correctly arranges the parts of the name
gen mlen = ustrlen(mname)
gen flen = ustrlen(fname)
gen fullname = fname + " " + lname if namecount == 2
replace fullname = fname + " " + mname + " " + lname if namecount==3 & mlen > 2
replace fullname = fname + " " + mname + " " + lname if namecount==3 & mlen==2
replace fullname = mname + " " + fname + " " + lname if namecount==3 & flen==2
list fullname fname mname lname

* If you are brave enough, learning regular express can pay off in 
* the long run. Stata has string functions with regular express, such
* as finding particular sets of strings with regexm(). Regular
* expressions are a pain to work with, but they are very powerful.

*****************
*6.5 Recoding
*****************
* We can use Stata commands to create new variables from old variables

* Let's get some data on working women 
use "wws2lab.dta", clear
codebook occupation, tabulate(25)

* Let's say we want aggregated groups of occupation
* We could use a categorical variable strategy to create a with
* gen and replace with qualifers.
* We can also use the recode command for faster groupings
* 
recode occupation (1/3=1) (5/8=2) (4 9/13=3), generate(occ3)
tab occupation occ3
table occupation occ3

* We condense 3 or 4 lines of code down to 1

* We can also label are variables in the recode command 
* This can add to your consolidation of code
drop occ3
recode occupation (1/3= 1 "White Collar") (5/8=2 "Blue Collar") ///
                  (4 9/12=3 "Other"), generate(occ3)
tab occupation occ3, missing
table occupation occ3, missing

* In Stata #n1/#n2 means all values between #n1 and #n2
*          #n1 #n2 means only values #n1 #n2
*          For example 1/10 means 1 2 3 4 5 6 7 8 9 10
*                      1 10 means 1 10

* Occupation is a categorical variable, but we can use recode
* with continuous variables such as wages, hours, etc.
* There is recode(), irecode(), and autocode(), but I recommand 
* using gen and replace with qualifiers instead. You don't want 
* overlapping groups and with qualifers you can ensure they don't overlap

* Egen is powerful that has many useful command. One is egen cut
summarize wage, detail
* You can use breakpoints with at or equal lengths with group
* Make sure your first breakpoint is at the minimum so you don't cut
* off data.
egen wage3 = cut(wage), at(0,4,6,9,12)
egen wage4 = cut(wage), group(3)
tabstat wage, by(wage3)
tabstat wage, by(wage4)

* Still recommend using gen, replace, and qualifers for generating
* categorical variables from continuous variables

*****************
*6.6 Coding missing values
*****************

* If you are interested, you can review different ways to code 
* missing values. I generally just use ".", but when survey data
* comes back, there may be different reasons for missing. 
* N/A vs Did not respond may have different meanings and you may
* want to account for that.

* We will take a brief look at mvdecode() to recode all missing values
* coded as -1 and -2 to .
* It can be a bit faster than using replace for every variable of interest
infile id age pl1-pl5 bp1-bp5 using "cardio2miss.txt", clear
list

* Recode -1 and -2 as .
mvdecode bp* pl*, mv(-1 -2)
list

*****************
*6.7 Dummy variables
*****************
* Creation of dummy variables is a common and vital process
* in econometric analysis. Making mutually exclusive groups is essential
* for preventing multicollinearity and perfect multicollinearity.

* Stata has a easy way to incorporate binary/categorical/dummy variables
* Factors variables for dummy variables start with "i." in our regressions.
* We have seen d. and l. last week for differences and lags
* If we don't use i. for categorical variables, then we need to generate
* multiple binary (0/1) variables from our categorical group.
* If we don't use factor variables or mutually exclusive binary variables
* from our categorical, then Stata will think our categorical variable
* is a continuous variable, which does not have any interpretation.

use "wws2lab.dta", clear

* Let's look at our highest grade completed categorical
codebook grade4

* Let's use it in a regression with grade4 as a factor variable
regress wage i.grade4
* Stata knows to create 4 groups "NHS" "HS" "SC" and "CD", and 
* by default, Stata excludes the first category to prevent perfect
* multicollinearity. So, there will always be k-1 groups in the regress
* and the kth group is in the intercept.

* A nice feature with factor variables is that we can change the 
* base group, which is 1 by default. ib2.var means to use the variable
* as a factor variable and use the 2nd category as the base group.
regress wage ib2.grade4

* We can use list to see how Stata treats i.grade4 vs grade4
list wage grade4 i.grade4 in 1/10, nolabel

* Interactions are an important part of Stata
* Interactions # can interact categoricals-categorical, 
* categorical-continuous, or continuous-continuous

* Categorical-Categorical Interaction - Changes Intercepts
* Let's interact married and high grade completed
reg wage i.grade4##i.married
*This is the same as
reg wage i.grade4 i.married i.grade4#i.married

* A single # interacts only the two categoricals, while ## between
* two categorical will create all groups (except the base group)
* No High School and unmarried is the base group (intercept)
* All grade4 coefficients are returns to education for unmarried
* All grade4#married coefficients are returns to education for married
* Remember: This changes the intercepts for all groups and the base
*           group is the intercept.

* Categorical-continuous - changes intercepts and slopes
* Interacting categorical and continuous variables allows for different
* slopes and different intercepts. We define a continuous variable as
* "c.var" and a categorical as "i.var"
reg wage i.grade4##c.age

* We can see different intercepts for education:
*    Don't forget the intercept is the intercept for the base group (No High School)
* We can see the basegroup slope
*    The coefficient for age is the slope of the base group (No High School)
* We can see the different slopes for the different groups
*    There are three different slopes for our three comparison groups

* Continuous-Continuous Interaction - add n polynomials
* p = 2
reg wage c.age##c.age
* p = 3
reg wage c.age##c.age##c.age
* p = 4
reg wage c.age##c.age##c.age##c.age


*****************
*6.8 Date Variables
*****************
* Dates can be a pain to work with, but Mitchell and UCLA's OARC STATA
* resources: https://stats.oarc.ucla.edu/stata/modules/using-dates-in-stata/
* can be very helpful.

* Dates and times can be very helpful when working with time series data
* or panel data.

* Sometimes dates are separated in columns and we need to append them and
* set the date format
type momkid1.csv
import delimited using "momkid1.csv", clear
list

* Create Dates from numerical variables: mdy()
* We can create the mother's birthday with the mdy() function
generate mombdate=mdy(momm, momd, momy), after(momy)

* Create Dates from string variables: date()
generate kidbdate=date(kidbday,"MDY")

list 

* Notice that the dates are not in a format that we can work with
* easily. They are the days from Jan 1, 1960. You can see the 
* Mom's birthday on Jan 5, 1960 is 4. We can difference the dates
* so Jan 5, 1960 is 4 and Jan 1, 1960 is 0.

* We saw this a couple week ago, but our format %td is what we need
* and remember that are a lot of variations on %td, but ultimately 
* Stata still sees Jan 5, 1960 is 4 and Jan 1, 1960 is 0, etc.
format mombdate kidbdate %td
list
*For a MM/DD/YYYY format add NN/DD/ccYY at after %td
format mombdate kidbdate %tdNN/DD/ccYY
list

* nn is for 1-12 months; NN is for 01-12 months
* dd is for 1-31 days; DD is for 01-31 days
* YY is for 2-digit year (regardless of first two digits)
* cc is for first 2-digits of year
* ccYY is for 4-digit year
* Dayname will return Sunday-Saturday
* Mon will return month name
* We can use ",", "-", "/" and "_" where "_" is for a blank space

format mombdate kidbdate %tdDayname_Mon_DD,_ccYY
list kidbday kidbdate

* Remember that we can difference between dates as mentioned above, since
* Stata keeps dates as numerical days from Jan 1, 1960.
generate momagediff=kidbdate-mombdate
list mombdate kidbdate momagediff

*We can find years by dividing by 365.25
generate momagediffyr = (kidbdate-mombdate)/365.25
list mombdate kidbdate momagediffyr

* You can always insert a static date in the mdy() function or
* date() function
display (mdy(4,5,2005)-mdy(5,6,2000))/365.25

* We can always use a qualifier to find people born before, after, not on,  
* or on a certain date 
list momid mombdate if (mombdate >= mdy(1,20,1970)) & !missing(mombdate)

* Let's say we want just the day, month, or year from a date variable
* Then we have a few functions:
* day(date) returns a numeric of the day
* month(date) returns a numeric of the month
* year(date) returns a numeric of the year
* week(date) returns a numeric of the week out of (1-52)
* quarter(date) returns a numeric of the quarter (1-4)
* dow(date) returns day of the week as a numeric (0=Sunday,...,6=Saturday)
* doy(date) returns a numeric of the day of the year (1-365) or (1-366)

* This can be helpful when trying to compare time for a panel data set
* and we don't need day - just month and year - 
* I use this quite a bit with CPS data.
* If we have the month year we can use ym(Y,M) for month and year and 
* use that in our xtset - it can compare the number of months since Jan 1960
gen monyear = ym(momy,momm)
* We use the %tm format for months and year
format monyear %tmMon_ccYY
list monyear

* You can use cut off when there are only 2-digit YY on page 177-179, but
* you can review this if you like.

* Don't forget to look for help on Stata
help dates and times
* Or, on UCLA's OARC Stata resources

*****************
* 6.9 Date and Time Variables
*****************

* Section 6.8 provides helpful information using dates AND times.
* You may run across time formats, and I'll refer you to pages 179-186
* for future reference. For some reason you had birth date and time,
* you can use the mdyhms() function and the format %tc
gen testdt = mdyhms(momm,momd,momy,runiform(1,12),runiform(0,59), runiform(0,59))
format testdt %tc
list mombdate testdt

*****************
*6.10 Computations across variables
*****************
* The egen command is something that I miss in other statistical packages
* since it is so useful. We can do computation across columns or
* we can do computation across observations with egen

* For computations across columns/variables, we can look at row means
* or row min, row max, row missing, row nonmissing

* Let's get our data
use "cardio2miss.dta", clear

* Let's find the mean across pl1-pl5 instead of gen avgpl=(pl1+...+pl5)/5
egen avgpl=rowmean(pl1-pl5)
list id pl1-pl5 avgpl

* rowmeans will ignore the missing values
egen avgbp=rowmean(bp1-bp5)
list id bp1-bp5 avgbp

* rowmin() returns the row minimum
* rowmax() returns the row maximum
egen maxbp=rowmax(bp1-bp5)
egen minbp=rowmin(bp1-bp5)
list id bp1-bp5 avgbp maxbp minbp

* We can find missing or not missing with the rowmiss() and rownonmiss()
egen missbp = rowmiss(bp?)

* Note: the ? operator differs from the wildcard * operator
* The ? operator is a wildcard for 1 character in between
*       so bp? will pick up bp1, bp2, bp3, bp4, and bp5, and
*       bp? will exlude bpavg, bpmin, bpmax
*    my*var                 variables starting with my & ending with var with any number of other characters between
*    my~var                 one variable starting with my & ending with var with any number of other characters between
*    my?var                 variables starting with my & ending with var with one other character between
*    myvar                  just one variable
*    myvar thisvar thatvar  three variables
*    myvar*                 variables starting with myvar
*    *var                   variables ending with var
*    myvar1-myvar6          myvar1, myvar2, ..., myvar6 (probably)
*    this-that              variables this through that, inclusive

*****************
*6.11 Computation across observations
*****************
* EGEN and bysort are a powerful combination for working across groups
* of observations. This can be very helpful when working with panel 
* data or time series by groups.  We will sort by id and then time and
* perform our egen commands
* We have our egen sum, egen max, egen min, egen mean which will be the
* main egen commands.
*
use "gasctrysmall.dta", clear

* Find the average for groups.
* Egen without a bysort will return the mean for the entire column,
* which may or may not be helpful
* With groups, we want to sort by groups first and then perform the
* egen mean
egen avggas = mean(gas)
bysort ctry: egen avggas_ctry = mean(gas)
list ctry year gas avggas avggas_ctry, sepby(ctry)
 
* Let's get the max and min for each country
bysort ctry: egen mingas_ctry = min(gas)
bysort ctry: egen maxgas_ctry = max(gas)
* We can count our observations
bysort ctry: egen count_ctry=count(gas)
list, sepby(ctry)

* We also have egen count()
*              egen iqr()
*              egen median()
*              egen pctile(#,p(#))
* See more egen commands:
help egen

**
*Subscripting (Head start to Mitchell 8.4)
**
* Bysort can be combined with indexes to find the first, last, or #
* observaration within a group
sort ctry year

* Find first year
bysort ctry: gen firstyr = year[1]
* Find last year
bysort ctry: gen lastyr = year[_N]
* Take a difference between periods (same as l.var)
bysort ctry: gen diffgas = gas-gas[_n-1]
* Create Indexes for Rate of change to base year
bysort ctry: gen gasindex = gas/gas[1]*100

*****************
*6.12 More Egen
*****************
* This section has more interesting egen commands that you can review
* ifyou would like. The workhorse egen commands are above.

*****************
*Converting Strings to numerics
*****************
* These next two section have a lot of practical implications that 
* you find when working with survey and especially administrative data.
* First we will cover converting numerical characters in strings 
* to numerical data to analyze.
use "cardio1str.dta", clear

* Let's summarize our data, but it comes back blank
sum wt bp1 bp2 bp3
* All of our numerical data are in string formats
describe

**
*Destring
**
* Destring is our main command to convert numerical characters to numerics.
* With destring, we have to choose an option of generating a new variable
* or replace the current variable
destring age, gen(agen)
sum age agen
drop agen

* We can destring all of our numerics
destring id-income, replace

* Notice that the replace failed for income and pl3.
* pl3 has a letter, so all of the data are not all digits.
* income has $ and , so it can not convert the data.

* We can use the force option with pl3 to convert the X to missing
list pl3
destring pl3, replace force
list pl3

* We cannot use the force option with income, since it contains 
* important information. We need to get rid of the two non-numerical
* characters of $ and ,

* We have two options: eliminate the "$" and "," or use the 
* ignore option in destring. The latter option is easier.
destring income, replace ignore("$,")
list

**
*Encode
**
* Sometimes we have categorical variables that come in as strings.
* We need to code them as categorical, but strings can be tricky with
* leading or lagging zeros or misspellings.

* One option is to use the encode command, which will generate a 
* new variable that codifies the string variable. This can be very helpful
* when our id variable in panel data are in string format.
list id gender
* Just in case, trim any white space around the string
* strtrim() - remove leading and lagging white space
* strrtrim() - removes lagging white spaces
* strltrim() - removes leading white spaces
* stritrim() - removes leading, lagging, and consecutive white spaces
replace gender = stritrim(gender)
encode gender, generate(gendercode)
list gender gendercode
* They look the same, but let's use tabulation
tab gender gendercode, nolabel
* The encode creates label values around the new variable
codebook gendercode

*****************
*6.14 Converting numerics to strings
*****************
* In my experience, it is more common to destring, but there are 
* situtations where you need to convert a numeric to a string.
* The most common examples from me are zip codes and FIPS codes.
* As a side note, whenever working with or merging with state-level
* data, always, always, always use FIPS codes and not states or
* state abbreviations. 

use "cardio3.dta", clear
list zipcode

* This zip code list is a problem and likely will not merge properly
* especially for zipcodes that have a leading 0. 
tostring zipcode, generate(zips)
replace zips = "0" + zips if strlen(zips) == 4
replace zips = "00" + zips if strlen(zips) == 3
list zipcode zips

* I don't recommend just formatting the data to 5 digits.
* The data should be exact for matching and merging datasets.

* I recommend using tostring, but there is decode which is the 
* opposite of encode. If we want to use the variable labels 
* instead of the numeric for some reason, the decode command 
* can be used

decode famhist, gen(famhists)
list famhist famhists, nolabel
codebook famhist famhists

*****************
*Renaming and reordering
*****************
* Reordering and renaming seems straightforward enough, but there
* are some useful tips that will help consolidate your scripts.
* For example, you don't need to a new rename command for every 
* single variable to be renamed. We can use group renaming.

use "cardio2.dta", clear
describe

**
*Rename
**
* The rename command is straightfoward, and allows us to rename
* our variable(s) of interest.
rename age age_yrs

* We also can do bulk renames if the group of variables have common
* characters in the variable name. We can rename our pl group to pulse
rename pl? pulse? 
* Where ? is an operator for just one character to be different
describe
* An alternate way is to rename by grouping and it prevents any
* unintended renaming with the ? or * operators
rename (bp1 bp2 bp3 bp4 bp5) (bpress1 bpress2 bpress3 bpress4 bpress5)
describe

**
*Order
**
* We can move our variables around, which can be especially helpful
* with panel data, since we want the unit id and the time period to be
* next to one another.

* Our variables are out of order and pl and bp alternate, but
* we may want to keep our pl variables and bp variables next to
* one another

* Reorder blood pressure and pulse
order id age_yrs bp* pul*
* Or,
order pul* bp*, after(age_yrs) 
* Or,
order bp*, before(pulse1)

* If you generate a new variable, it will default to the end, but
* we may want it somewhere else. Let's say we want age-squared, but
* we want age-squared to be next to age. We can use the after (or before)
* option in the generate command.
gen age2=age_yrs*age_yrs, after(age_yrs)

* If you wanted to reorder the whole dataset alphabetically, then
order _all, alphabetic
describe

* There is a sequential option as well if your var1, ..., vark are out
* of order
order bpress5 bpress1-bpress4, after(age2)
order bp*, sequential



