*Econ 645: Week 9
*Limited Variables Part 2: Poisson, NBRM, Censored, Truncated, and Sample Selection
*Samuel Rowe adapted from Wooldridge

set more off
clear

********************************************************************************
*Wooldridge
********************************************************************************
*Set Working Directory
cd "/Users/Sam/Desktop/Econ 645/Data/Wooldridge"

*Poisson
*Lesson: We should use a count model when we have a Poisson distribution for
*the outcome of interest. Our coefficients are expected log counts so we
*need to transform our coefficients for interpretation.
use "crime1.dta", clear

*We want to look at arrest data to see the number of times a man was arrested
*in 1986. There are 1,970 zeros out of 2,725 men in the sample and only eight
*observations are greater than 5. An OLS will not account for a count model
*but a Poisson distribution will.
*We have pcnv - proportion of prior arrest that lead to a conviction 
*avgsen - the average sentence served from prior convictions (in months)
*tottime - months spent in prison since age 18 prior to 1986
*ptime86 - months spent in prison in 1986
*qemp86 - number of quarters that the person was legally employed in 1986
*inc86 - income in 1986
*Hispanic - Hispanic/Latino binary
*Black - Black binary
*ptime86 

*OLS
reg narr86 pcnv avgsen tottime ptime86 qemp86 inc86 black hispan born60 

*Poisson
*Our coefficients are the change in expected log counts
poisson narr86 pcnv avgsen tottime ptime86 qemp86 inc86 black hispan born60 
*Test E(y|x)=Var(y|x)
estat gof

*Factor Change
*Delta pcnv = .1 so 
display (exp(-.402*.01)-1)*100
*A 1 percentage point increase in prior arrest decreases expected number of arrests by 0.4%
*A discrete change in a binary - the coefficient on Black
display (exp(0.6608)-1)*100 
*This means that the number of expected number arrests for a Black person is 93.7% 
*higher than the expected number of arrests for a White person.

*We can use the command listcoef as well, where e^B or e^B-1*100 depending upon 
*the option called percent.
listcoef, help
listcoef, percent help

*Marginal Effects
*Interpretation
*The marginal change in a continuous variable depends on the expected value of y
*given x, so we have to specify x with atmeans or average marginal effects

*Note: be careful with the change in percentage points for pcnv, we want a 
*1 percentage or 10 percentage point change not a change of 1.
margins, dydx(*) atmeans




*Negative Binomial Regression Model
*Lesson: When overdispersion occurs, we could estimate a Negative Binomial 
*Regression model. We'll see that our standard errors might be too large if 
*our main Poisson assumption mean=variance fails.

est clear
*Poisson
eststo PRM: poisson narr86 pcnv avgsen tottime ptime86 qemp86 inc86 black hispan born60 

*Negative Binomial
eststo NBRM: nbreg narr86 pcnv avgsen tottime ptime86 qemp86 inc86 black hispan born60 
*Our coefficients are the change in expected log counts
*We can use listcoef in ssc to for a different interpretation with 
listcoef, percent help
listcoef, help
*pcnv
display exp(-.4771*.1)-1
*A 10 percentage point increase in proportion of prior arrests that lead to conviction
*decrease the expected number of arrests by 4.7% hold all others constant
*avgsen - 
*a 1 month increase in total time served in prision from prior convictions before
*1986 increases the expected number of arrests by 
display (exp(0.01974)-1)

esttab, mtitle
*estimates table PRM NBRM, b(%9.3f) se varwidth(32) drop(lnalpha:_cons) stats(alpha N) star(0.05 0.01 0.001)

*Marginal Effects
*Interpretation is similar to Poisson
*The marginal change in a continuous variable depends on the expected value of y
*given x, so we have to specify x with atmeans or average marginal effects

margins, dydx(*) atmeans

*Censored Regressional Model - Right-Censored
use jan24pub.dta, clear
bysort ptwk: sum pternwa

*Right-censoring at 288461
replace pternwa = 288461 if pternwa >= 288461 & pternwa != .

gen inlf=. 
replace inlf=0 if pemlr >=5 & pemlr <=8
replace inlf=1 if pemlr >=1 & pemlr <=4
label variable inlf "In the labor force"
label define inlf1 0 "NILF" 1 "In the Labor Force"
label values inlf infl1
tab pemlr inlf

*Employed

*Education
gen edu=.
replace edu=1 if peeduca >= 31 & peeduca <= 38
replace edu=2 if peeduca == 39 | peeduca == 40
replace edu=3 if peeduca == 41 | peeduca == 42
replace edu=4 if peeduca == 43
replace edu=5 if peeduca == 44 | peeduca == 45 | peeduca == 46
label variable edu "Highest level of education completed"
label define edu1 1 "Less Than HS" 2 "HS/GED" 3 "AA" 4 "BS/BA" 5 "AdDegree"
label values edu edu1
tab peeduca edu

*Education binaries
gen edu_lt_hsd = .
replace edu_lt_hsd = 1 if edu==1
replace edu_lt_hsd = 0 if edu >= 2 & edu <= 5
label variable edu_lt_hsd "Education: Less Than High School degree"
label define edu_lt_hsd1 0 "High School or Higher" 1 "Less Than High School Degree"
label values edu_lt_hsd edu_lt_hsd1

gen edu_hsd = .
replace edu_hsd = 1 if edu==2
replace edu_hsd = 0 if edu==1 | (edu >= 3 & edu <= 5)
label variable edu_hsd "Education: High School Degree"
label define edu_hsd1 0 "Other than HSD" 1 "High School Degree"
label values edu_hsd edu_hsd1

gen edu_aa = .
replace edu_aa = 1 if edu== 3
replace edu_aa = 0 if (edu == 1 | edu == 2 | edu == 4 | edu == 5)
label variable edu_aa "Education: Associates Degree or Vocational Degree"
label define edu_aa1 0 "Other than AA" 1 "Associates or Vocational Degree"
label values edu_aa edu_aa1

gen edu_bs = .
replace edu_bs = 1 if edu == 4
replace edu_bs = 0 if (edu >= 1 & edu <= 3) | edu==5
label variable edu_bs "Bachelor's Degree"
label define edu_bs1 0 "Other than BS/BA" 1 "Bachelor's Degree"
label values edu_bs edu_bs1

gen edu_gd = .
replace edu_gd = 1 if edu == 5
replace edu_gd = 0 if edu >= 1 & edu <= 4
label variable edu_gd "Master's, Doctoral, or Professional Degree"
label define edu_gd1 0 "Other than Graduate Degree" 1 "Graduate Degree (MS/PHD,JD,MD,DO)"
label values edu_gd edu_gd1

tab peeduca edu_lt_hsd
tab peeduca edu_hsd
tab peeduca edu_aa
tab peeduca edu_bs
tab peeduca edu_gd

*Experience
gen exp=prtage-16
gen expsq = exp*exp
label variable exp "Potential Experience"
label variable expsq "Potential Experience Squared"

*Marital status
gen marital = .
replace marital = 1 if pemaritl==1 | pemaritl==2
replace marital = 2 if pemaritl==3 | pemaritl==4 | pemaritl==5
replace marital = 3 if pemaritl==6
label variable marital "Marital Status"
label define marital_1 1 "Married" 2 "Divorced/Separated/Widowed" 3 "Never Married"
label values marital marital_1
tab pemaritl marital

gen married = .
replace married = 1 if pemaritl == 1 | pemaritl == 2
replace married = 0 if pemaritl >= 3 & pemaritl <= 6
label variable married "Married"
label define married1 0 "Not Married" 1 "Married"
label values married married1
tab pemaritl married

gen divorced = .
replace divorced = 1 if pemaritl >= 3 & pemaritl <= 5
replace divorced = 0 if pemaritl == 1 | pemaritl == 2 | pemaritl == 6
label variable divorced "Divorced, widow, or separated"
label define divorced1 0 "Not Divorced" 1 "Divorced"
label values divorced divorced1
tab pemaritl divorced

*Demographics
gen female=.
replace female = 1 if pesex==2
replace female = 0 if pesex==1
label variable female "Female (0=Male, 1=Female)"
label define female1 0 "Male" 1 "Female"
label values female female1
tab female pesex

gen race_ethnicity = .
replace race_ethnicity = 1 if ptdtrace == 3 & pehspnon == 2 //AIAN
replace race_ethnicity = 2 if ptdtrace == 4 & pehspnon == 2 //Asian
replace race_ethnicity = 3 if ptdtrace == 2 & pehspnon == 2 //Black
replace race_ethnicity = 4 if ptdtrace == 5 & pehspnon == 2 //Hawaiian or Pacific Islander
replace race_ethnicity = 5 if pehspnon == 1 //Latino/a or Hispanic
replace race_ethnicity = 6 if (ptdtrace >= 6 & ptdtrace <= 26) & pehspnon == 2 //Multiracial
replace race_ethnicity = 7 if ptdtrace == 1 & pehspnon == 2 //White
label variable race_ethnicity "Race or Ethnicity"
label define race_ethnicity1 1 "NH AIAN" 2 "NH Asian" 3 "NH Black" ///
                             4 "NH Native Hawaiian or Pacific Islander" ///
							 5 "Latino/a or Hispanic" 6 "NH Multiracial" ///
							 7 "NH White"
label values race_ethnicity race_ethnicity1
tab ptdtrace race_ethnicity
tab race_ethnicity pehspnon
tab race_ethnicity

*Veteran Status
gen veteran = .
replace veteran = 1 if peafever==1
replace veteran = 0 if peafever==2
label variable veteran "Veteran Status"
label define veteran1 0 "Not a Veteran" 1 "Veteran"
label values veteran veteran1

*Disability Status
gen disability = .
replace disability = 1 if prdisflg==1
replace disability = 0 if prdisflg==2
label variable disability "Has a difficulty/disability"
label define dis1 0 "No disability" 1 "Disability"
label values disability dis1
tab disability
tab pudis disability

*Union
gen union = .
replace union = 1 if peernlab == 1
replace union = 0 if peernlab == 2
label variable union "Union member"
label define union1 0 "Non-union" 1 "Union"
label values union union1
tab union peernlab

*Class of worker
gen class_of_worker = .
replace class_of_worker = 1 if peio1cow == 1
replace class_of_worker = 2 if peio1cow == 2 | peio1cow == 3
replace class_of_worker = 3 if peio1cow == 4 | peio1cow == 5
replace class_of_worker = 4 if peio1cow >= 6 & peio1cow <= 8
label variable class_of_worker "Type of Worker"
label define cow1 1 "Federal" 2 "State/Local" 3 "Private Sector" 4 "Self-Employed"
label values class_of_worker cow1

*Labor Force Status
gen laborforce = .
replace laborforce = 1 if pemlr >= 1 & pemlr <= 4
replace laborforce = 0 if pemlr >= 5 & pemlr <= 7
label variable laborforce "In laborforce"
label define laborforce1 0 "NILF" 1 "In Laborforce"
tab pemlr laborforce

*Employed
gen employed = .
replace employed = 1 if pemlr >= 1 & pemlr <= 2
replace employed = 0 if pemlr >= 3 & pemlr <= 7
label variable employed "Employed"
label define employed1 0 "Not Employed" 1 "Employed"
label values employed employed1
tab pemlr employed

*Wages
gen earnings = pternwa/100
gen lnearnings = ln(earnings)
label variable earnings "Weekly Earnings: pternwa"
label variable lnearnings "Natural Log of Weekly Earnings"
histogram earnings
histogram lnearnings if employed==1

gen topcoded = .
replace topcoded = 1 if ptwk == 1
replace topcoded = 0 if ptwk == 0
label variable topcoded "Wages Topcoded"
label define topcoded1 0 "Not Topcoded" 1 "Topcoded"
label values topcoded topcoded1
tab topcoded

*Hours
gen hours = pehract1
label variable hours "Hours Worked"
gen lnhours = ln(hours)
label variable lnhours "Natural Log of Hours Worked"
histogram lnhours

sum peernhro
gen usual_hours1 = .
replace usual_hours1 = peernhro if peernhro != -1
histogram usual_hours1
gen ln_usual_hours1 = ln(peernhro)

*NAICS Major Sector
gen naics = prmjind1
replace naics = . if naics == -1
tab naics
label variable naics "NAICS 2-digit sector"
label define naics1 1 "NAICS 11 Agriculture" 2 "NAICS 21 Mining" 3 "NAICS 23 Construction" ///
                    4 "NAICS 31-33 Manufacturing" 5 "42-44 Retail/Wholesale Trade" ///
					6 "NAICS 48-49, 22 Transportation and utilities" 7 "NAICS 51 Information" ///
					8 "NAICS 52 Finance/Insurance" 9 "NAICS 56 Prof/Business Services" ///
					10 "NAICS 61-62 Education and Health" 11 "71-72 Leisure and Hospitality" ///
					12 "NAICS 81 Other Services" 13 "NAICS 92 Public Admin" 14 "Armed Forces"
label values naics naics1
tab naics prmjind1
			
*Major Occupation"
gen mocc = prmjocc1
replace mocc = . if prmjocc1 == -1
tab mocc
label variable mocc "Major SOC codes"
label define mocc1 1 "Management" 2 "Professional" 3 "Service" 4 "Sales" ///
                  5 "Office Support" 6 "Farming" 7 "Construction/Extraction" ///
				  8 "Installation/Repair" 9 "Production" 10 "Transportation/Moving" ///
				  11 "Armed Forces"
label value mocc mocc1
tab mocc prmjocc1

*Geographic
gen metro = .
replace metro = 1 if gtmetsta==1
replace metro = 2 if gtmetsta==2
replace metro = 3 if gtmetsta==3
label variable metro "Urban/Rural"
label define metro1 1 "Metro Area" 2 "Nonmetro Area" 3 "Not Identified"

rename gestfips state
label variable state "State"
label define state1 1 "Alabama" 2 "Alaska" 4 "Arizona" 5 "Arkansas" 6 "California" ///
                    8 "Colorado" 9 "Connecticut" 10 "Delaware" 11 "District of Columbia" 12 "Florida" ///
					13 "Georgia" 15 "Hawaii" 16 "Idaho" 17 "Illinois" 18 "Indiana" ///
					19 "Iowa" 20 "Kansas" 21 "Kentucky" 22 "Louisiana" 23 "Maine" ///
					24 "Maryland" 25 "Massachusetts" 26 "Michigan" 27 "Minnesota" 28 "Mississippi" ///
					29 "Missouri" 30 "Montana" 31 "Nebraska" 32 "Nevada" 33 "New Hampshire" ///
					34 "New Jersey" 35 "New Mexico" 36 "New York" 37 "North Carolina" 38 "North Dakota" ///
					39 "Ohio" 40 "Oklahoma" 41 "Oregon" 42 "Pennsylvania" 44 "Rhode Island" ///
					45 "South Carolina" 46 "South Dakota" 47 "Tennessee" 48 "Texas" 49 "Utah" ///
					50 "Vermont" 51 "Virginia" 53 "Washington" 54 "West Virginia" 55 "Wisconsin" ///
					56 "Wyoming"
label values state state1
tab state
tab state topcoded, row

rename gediv region
label variable region "Census Regions"
label define region1 1 "New England" 2 "Mid-Atlantic" 3 "East North Central" 4 "West North Central" ///
                     5 "South Atlantic" 6 "East South Central" 7 "West South Central" 8 "Mountain" ///
					 9 "Pacific"
label values region region1
tab region
tab region topcoded, row

save "/Users/Sam/Desktop/Econ 645/Data/CPS/jan2024.dta", replace

*Tobit Estimator - Right Censoring
use "/Users/Sam/Desktop/Econ 645/Data/CPS/jan2024.dta", clear
histogram earnings if prerelg==1, normal title(Histogram of Weekly Earnings) caption("Source: Current Population Survey")
histogram lnearnings if prerelg==1, normal title(Histogram of LN Weekly Earnings) caption("Source: Current Population Survey")

sum earnings if prerelg==1, detail
sum lnearnings if prerelg==1, detail
return list
local maxval `r(max)'

est clear
eststo OLS: reg lnearnings i.edu exp expsq i.marital i.veteran i.union i.female i.race
eststo Tobit: tobit lnearnings i.edu exp expsq i.marital i.veteran i.union i.female i.race, ul(`maxval')

esttab OLS Tobit, drop(0.* 1.race* 1.mar* 1.edu) mtitle("OLS" "Tobit")
x


*Censored Regression Model - Duration analysis
*Lesson: We can look at a censored data for duration analysis similar to 
*Wooldridge's example. This differs from a top-coded data, which we can
*use a Tobit analysis. For example, wages are top-coded at $2800 in the CPS,
*but instead of ll(0), we would use ul(2800).


use recid.dta, clear

*We can look at the duration of time in months between an arrests for inmates 
*in a North Carolina prison after being released from prison. We want to 
*evaluate a work program to see if it is effective in increasing duration 
*before recidivism occurs.

*Note: 893 inmates have not been arrested during the period they were followed
*These observations are censored. The censoring times differed among inmates
*ranging from 70 to 81 months.

*Our dependent variable duration (time in months) is transformed by natural
*logarithm. 

*We have a bunch of observations that recidivate between 70 and 81 months.
tab durat

*We have a bunch of observations that are censored after 69 months (but not all)
tab durat cens

*We'll use the stset command and set failure at cens==0
stset ldurat, failure(cens==0)

*We'll use the streg command and set the distribution
streg workprg priors tserved felon alcohol drugs black married educ age, dist(weibull) nohr

*Interpretation:
*Given the log-linear function form, we can easily determine the estimated 
*percent change in duration before criminal recidivism.
display (exp(.0780722)-1)*100
*Being a part of the work program increase the duration of time before recidivism,
*but it is not statistically significant.
display (exp(-.287139)-1)*100
*Being a felon reduces the duration of time before recidivism, where a felon has 
*as 24% decrease in duration of time before recidivism.

*Sample Selection Correction:
*Lesson: Similar to tobit, when we don't account for the truncation of the
*data, or why certain parts of the population are not sampled, we will commit
*a type of omitted variable bias without our lambda(zy)-hat. We can use a Heckit
*method for sample selection correction.

use mroz.dta, clear

*We want to see if there is sample selection bias due to unobservable wage offers
*for non-working women.

*First, we need to estimate a logit or probit to test and correct for sample
*selection bias due to unobserved wage offer for nonworking women. Spousal 
*income, education, experience, age, and number of kids less than 6. 

*Second, We use the Heckit command to implement a Heckman Method for sample
*selection correction.

*Notice: an assumption is used to exclude spousal income, age, kids less than 6, 
*and kids greater than 6 from our main regression
*

est clear
*OLS
eststo OLS: reg lwage educ exper expersq 

*We will use a subset of all exogenous variable
*First, what are the factors correlated with being in the labor force?
*Second, what is the impact of education and experience on wages 
eststo Heckman: heckman lwage educ exper expersq, select(inlf=nwifeinc educ exper expersq age kidslt6 kidsge6) twostep 

esttab, mtitle

*There is no real evidence of sample selection bias in the wage offer equation.
*Our lambda-hat is not statistically significant and we fail to reject
*H0: rho=0. Also, we notice very little difference between our OLS and Heckman Method.

