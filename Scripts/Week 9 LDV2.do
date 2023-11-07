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


*Censored Regressional Model - Duration analysis
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

