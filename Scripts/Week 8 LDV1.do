*Econ 645: Week 8
*Wooldridge Chapter 17.1-17.4
*Mitchell: Chapter 9
*Samuel Rowe - Adapted from Wooldridge and Mitchell
*August 31, 2023

clear
set more off

********************************************************************************
*Wooldridge
********************************************************************************
*Set Working Directory
cd "/Users/Sam/Desktop/Econ 645/Data/Wooldridge"


********
*Married Women's Labor Force Participation
********
use mroz.dta, clear

*Summarize in the labor force
tabulate inlf
*325 Women are not in the labor force and 428 Participating
*Our explanatory variables are non-wife income, education, experience, 
*experience-squared, age, kids less than 6, kids greater than 6

est clear
*Logit
eststo Logit: logit inlf nwifeinc educ exper expersq kidslt6 kidsge6
*Probit
eststo Probit: probit inlf nwifeinc educ exper expersq kidslt6 kidsge6

esttab Logit Probit, mtitle

*Average Marginal Effects (AME)
est clear
*LPM
quietly reg inlf nwifeinc educ exper expersq age kidslt6 kidsge6
eststo LPM: margins, dydx(*)
*Logit
quietly logit inlf nwifeinc educ exper expersq age kidslt6 kidsge6
eststo Logit: margins, dydx(*)
*Probit
quietly probit inlf nwifeinc educ exper expersq age kidslt6 kidsge6
eststo Probit: margins, dydx(*)

esttab LPM Logit Probit, mtitle 

*Marginal Effects at the Average (MEA)
est clear
*LPM
quietly reg inlf nwifeinc educ exper expersq age kidslt6 kidsge6
eststo LPM: margins, dydx(*) atmeans
*Logit
quietly logit inlf nwifeinc educ exper expersq age kidslt6 kidsge6
eststo Logit: margins, dydx(*) atmeans
*Probit
quietly probit inlf nwifeinc educ exper expersq age kidslt6 kidsge6
eststo Probit: margins, dydx(*) atmeans

esttab LPM Logit Probit, mtitle 


*Graph
*LPM
est clear
quietly reg inlf nwifeinc educ exper expersq age kidslt6 kidsge6
eststo lpm: margins, at(educ=(0(2)20)) post
marginsplot, yline(0)

*Logit
quietly logit inlf nwifeinc educ exper expersq kidslt6 kidsge6
eststo logit1: margins, at(educ=(0(2)20)) post
marginsplot, yline(0)

*Probit
quietly probit inlf nwifeinc educ exper expersq age kidslt6 kidsge6
eststo probit1: margins, at(educ=(0(2)20)) post
marginsplot, yline(0)

coefplot lpm logit1, at recast(line) ciopts(recast(rline) lpattern(dash))
coefplot lpm probit1, at recast(line) ciopts(recast(rline) lpattern(dash))
coefplot logit1 probit1, at recast(line) ciopts(recast(rline) lpattern(dash))

*Marginal Effects
quietly reg inlf nwifeinc educ exper expersq age kidslt6 kidsge6
margins, dydx(kidslt6) at(educ=(0(2)20))
marginsplot, yline(0)

*Logit
quietly logit inlf nwifeinc educ exper expersq kidslt6 kidsge6
test kidslt6 kidsge6

margins, dydx(kidslt6) at(educ=(0(2)20))
marginsplot, yline(0)

*Probit
quietly probit inlf nwifeinc educ exper expersq age kidslt6 kidsge6
margins, dydx(kidslt6) at(educ=(0(2)20))
marginsplot, yline(0)

********
*Married Women's Annual Labor Supply
********
*Lesson: 1) Tobit and OLS have the same sign; 2) Tobit and OLS magnitudes are
*not directly comparable. We need an adjustment factor

*We have data on married women' annual labor supply with hours of work for
*wage in the labor force. There are 428 women employed with hours, and 325
*women have no hours. Since we have a sizable about of 0 (corner soluation), we
*can use a Tobit model.

use mroz.dta, clear

*Summarize hours
sum hours
tab hours if hours == 0
tab hours inlf
tabstat hours, by(inlf) stat(mean median sd)
*We have 325 women who had 0 hours 

histogram hours
*We have corner solution for women have 0 hours of labor

*The range for women who do have working hours - ranges from 12 to 4950 hours
sum hours if hours > 0

*OLS Model
est clear
eststo OLS: reg hours nwifeinc educ exper expersq age kidslt6 kidsge6
margins

*Tobit Model
eststo TOBIT: tobit hours nwifeinc educ exper expersq age kidslt6 kidsge6, ll(0)
quietly sum exper
local exp2=r(mean)^2
*margins, dydx(*) predict(e(0,.)) at(expersq=`exp2')
*Using ystar tells Stata to act like there is no censoring even though the 
*model allows for it 
*https://www.statalist.org/forums/forum/general-stata-discussion/general/1531196-tobit-marginal-effects
*Average Marginal Effects
margins, dydx(*) predict(ystar(0,.)) at(expersq=`exp2')
*Marginal Effects at the Average
margins, dydx(*) predict(ystar(0,.)) at(expersq=`exp2') atmeans


*Compare our results
esttab OLS TOBIT, mtitle

*Compare Graphs
est clear
*OLS Model
quietly reg hours nwifeinc educ exper expersq age kidslt6 kidsge6
eststo OLS: margins, at(educ=(0(2)20)) post

*Tobit Model
quietly tobit hours nwifeinc educ exper expersq age kidslt6 kidsge6, ll(0)
eststo Tobit: margins, at(educ=(0(2)20)) predict(e(0,6000)) post

coefplot (OLS, ciopts(recast(rline) lpattern(solid))) (Tobit, ciopts(recast(rline) lpattern(dash))), at recast(line)

********************************************************************************
*Mitchell
********************************************************************************
**********
*Chapter 8: Processing observations across subgroups
**********

*Set Working Directory
cd "/Users/Sam/Desktop/Econ 645/Data/Mitchell"

*One thing Stata easily provides are commands and options for subgroup
*analysis. We can use the by prefix command to create and analyze subgroups
*or cross-sectional units in a panel data set.

**********
*8.2 Obtaining separate results for subgroups
**********
*Tabulate is a very helpful command to analyze categorical variables, or 
*occassionally look through continuous variables (as long as there aren't
*too many values). 
*The tabulate command has an option to summarize a continuous variable when
*tabulating categorical variables. 
use wws2, clear
tabulate married, summarize(wage)

*Another option is using the bysort prefix command
bysort married: summarize wage

*We can also correlate data within groups instead of using qualifiers and
*additional statements
*With qualifiers
correlate wage age if married == 0
correlate wage age if married == 1

*Using bysort accomplishes this in one command
bysort married: correlate wage age

*Using bysort accomplishes even faster if we have a categorical variable with
*many categories
bysort race: correlate wage age

**********
*8.3 Computing values separately by subgroups
**********
*The by prefix command and the egen command is a powerful combination that
*makes aggregating group statistics much easier than other statistical 
*software packages
*Bysort and egen makes aggregating by groups much easier than other software.
*R has aggregate which is flexible and powerful, but requires more coding.

*I'm not the biggest fan of Mitchell's examples with bysort var: egen, but 
*they get the job done. I would like us to use some CPS examples with bysort 
*and egen.

*With bysort var: egen we can calculate subgroup statistics, counts, summations
*with one easy line of code
use tv1, clear
list, sepby(kidid)

*If we want to calculate the average tv time for each kid we first sort by
*the child id and then use egen. We may have multiple levels and we can use 
*bysort to find the multiple level identifiers such as id, year, and month of year
bysort kidid: egen avgtv = mean(tv)
sort kidid
list kidid tv avgtv, sepby(kidid)

*If we want the standard deviation of the child's tv watching 
bysort kidid: egen sdtv = sd(tv)
*Let's generate some z-scores
generate ztv = (tv-avgtv)/sdtv
*Let's look at our statistics
list 

*Let's generate some subgroup statistics for a binary variable vac
*Where vac=0 if the kid was not on vacation and vac=1 if the kid was on vacation
bysort kidid: egen vac_total = total(vac)
bysort kidid: egen vac_sd = sd(vac)
bysort kidid: egen vac_min = min(vac)
bysort kidid: egen vac_max = max(vac)
list kidid vac*, sepby(kidid) abb(10)

*Let's see if some kids watch less than 4 hours of tv per day.
*We'll generate a binary/dummy variable to be 1 if equal to or less than 4 hours
*a day and 0 if it is greater than 4 hours a day.
generate tvlo = (tv < 4) if !missing(tv)

*We can generate individual level subgroup analysis with bysort and egen on
*binary variables
bysort kidid: egen tvlocnt = count(tvlo)
bysort kidid: egen tvlototal = total(tvlo)
bysort kidid: egen tvlosum = sum(tvlo)
bysort kidid: gen tvlosum2 = sum(tvlo)
bysort kidid: egen tvlosame = sd(tvlo)
bysort kidid: egen tvloall = min(tvlo)
bysort kidid: egen tvloever = max(tvlo)
list kidid tv tvlo*, sepby(kidid) abb(20)

*Notice how count() provides the number of observations for each kid, while
*total() returns a constant for the sum of all values, but so does egen sum().
*The problem is that there is a gen var = sum(var2) function that returns 
*a running sum that we see in tvsum2. I usually use egen sum, but I think 
*egen total is the more appropriate function to use when returning a constant.

*We have our central tendencies functions with mean(), median(), and mode().
*We can find percentiles with pctile(var), p(#).
*We have other egen functions that may be of help, such as iqr(), Median 
*Absolute Deviation mad(), Mean Absolute Deviation mdev(), kurt(), skew(), etc.
help egen

*Mitchell has a good note here
*Egen mean() takes an arguement, not a varlist, so if you put 
*bysort idvar: egen meanvars1_5=mean(var1-var5), mean() will return not the
*means of vars 1 through 5, but var1 minus var5

**********
*8.4 Computing values within subgroups: Subscripting or Indexing
**********
*Unsolicated Opinion Alert:
*Subscripting (or I may accidently call it indexing) is a very powerful tool
*that I personally think puts Stata as the top paid statistical software 
*(I do think that R is more powerful and more flexible, but Stata balances
*power, flexibility, and ease of learning). 

use tv1, clear
*Each variable is a vector x1=x[x11, x12, x13,...,x1N] for i=1,...,N observations
*We can use a subscript or index to call which part of the vector we want to
*return.
list, sepby(kidid)

*If we want the first observation in our tv vector we can call it with [1]
display tv[1]
*We can look at the first kid id and date and time
display "kid: " kidid[1] ", Date: " dt[1] ", Sex: " female[1] ", TV Hours: " tv[1]
*We can see the second observation
display tv[2]
*We can see the difference between the two observations
display tv[2]-tv[1]

*Note: we have some very useful system variables of _N and _n
*_N is total number of observations and when used in the subscript/index
*it will return the last observation

*_n is current number of observations or observation number and when used in
*the subscript/index it will return the current observation (almost like i=i+1)
help system variables

*Subscripting is very helpful when working Panel Data. You can index within
*cross-sectional units over time with ease. The subscript (or index) will 
*return the nth observation given
use tv1, clear
*If we want the first observation to be compared to all observations
bysort kidid: gen tv_1ob = tv[1]
list kidid tv tv_1ob, sepby(kidid)
*If we want to compare the last observation to all observations
bysort kidid: gen tv_lastob = tv[_N]
list kidid tv tv_lastob, sepby(kidid)
*If we want the second to last observation
bysort kidid: gen tv_2tolastob = tv[_N-1]
list kidid tv tv_2tolastob, sepby(kidid)
*If we want the prior observation (lag of 1)
bysort kidid: gen tv_lagob = tv[_n-1]
list kidid tv tv_lagob, sepby(kidid)
*If we want the next observation (lead of 1)
bysort kidid: gen tv_leadob = tv[_n+1]
list kidid tv tv_leadob, sepby(kidid)

*You can use bysort kidid (dt) to tell Stata to order by kid id and date,
*but NOT INCLUDE dt in the grouping.
*If we use kidid AND tv bysort kidid tv: egen, then we will look for observation
*Within kid id AND the date. Since there is only 1 observation per kid
*per date, we will only have 1 observation for each grouping.
use tv1, clear
*If we want the first observation to be compared to all observations
bysort kidid (dt): gen tv_1ob1 = tv[1]
bysort kidid dt: gen tv_1ob2 = tv[1]
*Compare
list kidid tv tv_1ob*, sepby(kidid)

*If we want to compare the last observation to all observations
bysort kidid (dt): gen tv_lastob1 = tv[_N]
bysort kidid dt: gen tv_lastob2 = tv[_N]
*Compare
list kidid tv tv_lastob*, sepby(kidid)

*If we want the prior observation (lag of 1)
bysort kidid (dt): gen tv_lagob1 = tv[_n-1]
bysort kidid dt: gen tv_lagob2 = tv[_n-1]
*Compare
list kidid tv tv_lagob*, sepby(kidid)

**********
*8.5 Computing values within subgroups: Computations across observations
**********
*Another powerful combination with subscripting/indexing is that we can the 
*generate command to create new variables that perform mathematical operators 
*on different observations WITHIN the vector
use tv1, clear
*Difference in tv time between current period and prior period
bysort kidid (dt): generate tvdfp = tv - tv[_n-1]
*Difference in tv time between current period and next period 
bysort kidid (dt): generate tvdfs = tv - tv[_n+1]
*Difference in tv time between current period and first period
bysort kidid (dt): generate tvdff = tv - tv[1]
*Difference in tv time between current period and last period
bysort kidid (dt): generate tvdfl = tv - tv[_N]
*Difference between current period and 3-year moving average over time
bysort kidid (dt): generate tv3avg = (tv[_n-1] + tv[_n] + tv[_n+1])/3

list kidid dt tvd* tv3avg

*We can also rebase our vector. For example, we can rebase a deflator for the
*period dollars we want.
import excel using "cpi_1993_2023.xlsx", cellrange(A12:P42) firstrow clear
keep Year Annual
*Rebase in 1993 Dollars
gen rebase93 = Annual/Annual[1]*100
*Rebase in 2022 Dollars
gen rebase22 = Annual/Annual[_N]*100
*Rebase to 2012
gen rebase12 = Annual/Annual[_N-10]*100
list

graph twoway line Annual Year || line rebase93 Year || ///
             line rebase22 Year, yline(100) ///
			 legend(order(1 "100=1982" 2 "100=1993" 3 "100=2022"))

**********
*8.6 Computing values within subgroups: Running sums
**********
*As we mentioned earlier, when we use egen sum vs gen sum, we get different 
*results. Egen sum() is similar to egen total() but it can be confusing.
*When we use gen with sum(), we generate a RUNNING sum not a constant of total.
use tv1, clear
*We can generate the tv running sum across all individuals over time
generate tvrunsum = sum(tv)
*We can generate the tv running sum within an individuals time period
bysort kidid (dt): generate bytvrunsum=sum(tv)
*We can generate the total sum with an individuals time period
bysort kidid (dt): egen bytvsum=total(tv)
*We can generate the total sum for all individuals over time
egen tvsum = total(tv)
*We can also calculate a running average
bysort kidid (dt): generate bytvrunavg=sum(tv)/_n
*We can compute the individual's average average
bysort kidid (dt): egen bytvavg = mean(tv)

list kidid tv tv* by*, sepby(kidid)


**********
*8.7 Computing values within subgroups: More examples
**********
*There are other useful calculations we can do with subscripting/indexing.
*Some do overlap with egen, but it is helpful to know the differences.

**
*Counting
**
*Count the number of observations: this can be done with subscripting or egen
*depending upon what we want
use tv1, clear
*Generate total observation count per individual missing or not missing:
bysort kidid (dt): generate idcount=_N
*Generate the total observation without missing
bysort kidid (dt): egen idcount_nomiss = count(tv)
*Generate a running count of an observation
bysort kidid (dt): gen idruncount = _n
list, sepby(kidid)

**
*Generate Binaries 
**
*We can generate binary variables to find first and last observations or nth
*observation. This differences from id counts, we are generating binaries for
*when the qualifier is true.

use tv1, clear
*Find individuals with only one observation
bysort kidid (dt): generate singleob = (_N==1)
*Find the first observation of an individual
bysort kidid (dt): generate firstob = (_n==1)
*Find the last observation of an individual 
bysort kidid (dt): generate lastob = (_n==_N)
list, sepby(kidid)

use tv1, clear
*We can create binaries depending upon leads and lags too.
*look for a change in vac
bysort kidid (dt): generate vacstart=(vac==1) & (vac[_n-1]==0)
bysort kidid (dt): generate vacend=(vac==1) & (vac[_n+1]==0)
list kidid dt vac*, sepby(kidid)

**
*Fill in Missing
**
*Another useful tool that we should use with caution is filling in missings.
*This should only really be applied when we have a constant variable that 
*does not change over time.
use tv2, clear
sort kidid dt
list, sepby(kidid)

*We can backfill the observation with the last nonmissing observation.
*First generate a copy of the variable with missing values.
generate tvimp1 = tv
bysort kidid (dt): replace tvimp1 = tv[_n-1] if missing(tv)

list kidid dt tv tvimp1, sepby(kidid)

*Notice that we are still missing the 3rd observation for the 3rd kid.
*It cannot backfill the 3rd observation from the second observation, since
*the second observation is missing. There are a couple of strategies to use
*We can generate a new variable like Mitchell
generate tvimp2 = tvimp1
bysort kidid (dt): replace tvimp2 = tvimp2[_n-1] if missing(tvimp2)
list kidid tv tvimp*, sepby(kidid)

*You can just replace tvimp1 twice instead of generating a new variable, but
*that is up to the user. You would use tv[_n-1] for the first replace and 
*tvimp1[_n-1] for the second replace.

**
*Interpolation
**
*We may need to interpolate between 2 known values and assume a linear trend.
generate tvimp3=tv
*Interpolate for 1 missing value between two known values
bysort kidid (dt): replace tvimp3 = (tv[_n-1]+tv[_n+1])/2 if missing(tv)
list kidid tv tvimp3, sepby(kidid)
*This is a bit of hard coding, but you can interpolate with more than 1 missing
bysort kidid (dt): replace tvimp3 = ((tvimp3[4]-tvimp3[1])/3)+tvimp3[_n-1] if missing(tvimp3) & kidid==3
list kidid tv tvimp3, sepby(kidid)

**
*Indicators 
**
*What is we want to find outliers in time-varying differences? We can generate
*indicators variables to find when a variable changes more than a set limit.
*For example we want to know if the tv viewing habits drop more than 2 hours 
use tv1, clear
bysort kidid (dt): generate tvchange = tv[_n]-tv[_n-1]
bysort kidid (dt): generate tvchangerate = ((tv[_n]-tv[_n-1])/tv[_n-1])
list, sepby(kidid)
*Generate an indicator variable to see if tvchange is less than -2. This is not
*very helpful with small datasets, but with larger datasets such as the CPS
*It is important
gen tvchangeid=(tvchange <= -2) if !missing(tvchange)
list, sepby(kidid)

**********
*8.8 Comparing the by, tsset, xtset commands
**********
*Another way to find differences within vectors, we can use the tsset or xtset
*command to establish the times series (tsset) or panel data (xtset).
*We can use our bysort with subscripting/indexing.
use tv1, clear
bysort kidid (dt): generate ltv = tv[_n-1]
list, sepby(kidid)

*Or, we can establish a time series (tsset) 
use tv1, clear
sort kidid dt
*We'll need to specify that our cross-sectional groups is kidid
*We'll need to specify our date variable with dt
*We'll need to use the option, daily, to specify that time period is daily
*as opposed to weeks, months, years. Or we can specify delta(1) for one day
tsset kidid dt, daily delta(1)
*We can use the operator L.var to specify that we want to a lag of 1 day
generate lagtv = L.tv

*We can use the operator F.var to specify that we want a lead of 1 day
generate leadtv = F.tv
list, sepby(kidid)

*Or, we can establish a panel series (xtset)
use tv1, clear
sort kidid dt
*We'll need to specify that our cross-sectional group is kidid
*We'll need to specify our time period is dt
*We'll use a delta of 1 to specify that the differnce is 1 day.
*Or, we can use daily as well
xtset kidid dt, daily delta(1)

*Generate a lag with the l.var operator
generate lagtv = l.tv

*Generate a lead with the 
generate leadtv = f.tv

*What do you notice? You can see that there are some leads and lags missing.
*Why? Because there is an unbalance panel and the daily differences cannot be
*computed if we are missing days. In this case, we can use the bysort with 
*subscripting indexing
list, sepby(kidid)

bysort kidid (dt): gen bylagtv=tv[_n-1]
bysort kidid (dt): gen byleadtv=tv[_n+1]
list, sepby(kidid)

*What is the difference
*From Nick Cox:
*xtset allows a panel identifier only. tsset allows a time identifier only. 
*Where they overlap is when two variables are supplied in which case the first 
*is treated as a panel identifier and the second as a time variable. 


****************
*Exercises
****************

*Let's grab the CPS and generate subgroup analysis
*We will be using unweighted data for simplicity
*What are the average wages by sex?
*Whage are average wages by state
*Median wages by sex
*Median wages by state
*What is the 75th percentile of wages by race?
*What is the 25th percentile of wages by marital status?

*Using our short-term panels with the CPS, what is the difference in wages
*between period1 and period2? Create an indicator variable to see if wages
*fell by more than 50%.

*
use "/Users/Sam/Desktop/Econ 645/Data/CPS/jun23pub.dta",replace



*Generate labor force
gen inlf = .
replace inlf = 0 if pemlr >= 5 & pemlr <= 7
replace inlf = 1 if pemlr >= 1 & pemlr <= 4
label define inlf1 0 "Not in Labor Force" 1 "In Labor Force"
label values inlf inlf1
tab pemlr inlf

*Years of schooling
replace peeduc = . if peeduc == -1

*Compare
logit inlf peeduc c.prtage##c.prtage
margins, dydx(peeduca) at(peeduca=(31(1)46))
marginsplot

logit inlf peeduc c.prtage##c.prtage
margins, dydx(peeduca) at(peeduca=(31(1)46)) atmeans
marginsplot


probit inlf peeduca c.prtage##c.prtage
margins, dydx(peeduca) at(peeduca=(31(1)46))
marginsplot

*Years of School
logit inlf 
