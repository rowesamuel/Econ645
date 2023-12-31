*Week 3 and 4: Pooled Cross-Sections and Panel Data
*Samuel Rowe Adapted from Wooldridge
*August 2, 2023

clear
set more off


********************************************************************************
*Wooldridge
********************************************************************************
*Set Working Directory
cd "/Users/Sam/Desktop/Econ 645/Data/Wooldridge"

*************************
*Fertility over time
*************************
*Lesson: Time binaries can capture secular trends over time or trends that
*affect all people during the time period.

*Sander (1992) uses the National Opinion Research Center's General Social Survey
*for the veven users from 1972 to 1984. We'll use these data to explain the
*total number of kids born to a women.

use "fertil1.dta", clear

*One question of interest:
*What happens to ferlity rates over time after controlling for observable factors?
*We'll control for education, age, race, region at 16 years old, and living
*environment at 16.

*We'll use 1972 as our base year (which we will exclude and be captured in the
*intercept).

*No Time Trends
est clear
eststo OLS: reg kids educ c.age##c.age i.black i.east i.northcen i.west i.farm i.othrural ///
         i.town i.smcity 
		 
*Time Trends Time Fixed Effects
eststo Pooled_OLS: reg kids educ c.age##c.age i.black i.east i.northcen i.west i.farm i.othrural ///
         i.town i.smcity i.y74 i.y76 i.y78 i.y80 i.y82 i.y84
*Exclusion Restriction Test
test 1.y74 1.y76 1.y78 1.y80 1.y82 1.y84

*We reject the null hypothesis that our combined time binaries are 0 with an
*F-stat (1,111 degrees of freedom) equal to 5.87.

*Display
esttab OLS Pooled_OLS, mtitles se scalars(F r2) ///
									drop(0.black 0.east 0.northcen 0.west 0.farm ///
                                    0.othrural 0.town 0.smcity 0.y74 0.y76 0.y78 ///
									0.y80 0.y82 0.y84) 
*We can see most our time coefficient are not statistically significant but
*we do reject the null hypothesis that they are all equal to 0.
*If we compare 1982 and 1984 to 1972, women estimated to have about 0.52 fewer
*and 0.55 fewer children, respectively. This means that in 1982 100 women are
*expected to have 52 fewer children than 100 women in 1972.

*Note: since we are controlling for education, this decline in fertility cannot
*be attributed to increases in education. The difference is a secular trend or 
*a general trend that transcends across all women.

*Note: that we have age and age-squared, which means that the number of children
*increases with age, but at a diminishing rate. At one point age will become 0.

estat hettest

*Note that we reject the null hypothesis of homoskedasticity with a Breusch-Pagan
*Test, so we should use our heteroskedastic-robust standard errors
est clear
eststo Without_Robust: reg kids educ c.age##c.age i.black i.east i.northcen i.west i.farm i.othrural ///
         i.town i.smcity i.y74 i.y76 i.y78 i.y80 i.y82 i.y84
eststo With_Robust: reg kids educ c.age##c.age i.black i.east i.northcen i.west i.farm i.othrural ///
         i.town i.smcity i.y74 i.y76 i.y78 i.y80 i.y82 i.y84, robust
		 
esttab Without_Robust With_Robust, mtitles se scalars(F r2) ///
									drop(0.black 0.east 0.northcen 0.west 0.farm ///
                                    0.othrural 0.town 0.smcity 0.y74 0.y76 0.y78 ///
									0.y80 0.y82 0.y84) 

*Question: do you think the number of kids is distributed normally? 

**************************
*Changes in the Returns to Education and the Sex Wage Gap
**************************
*Lesson: Interactions matter. We can manually create interactions, but that
*can be cumbersome. Using the # operator, we can generate interactions within
*our regression command.

*Stata interactions: i.var1##i.var2, i.var1##c.var3, c.var3##c.var4

*We can estimate to see how the wage gap and returns to schooling have compared
*for women. We pool data from 1978 and 1985 from the Current Population Survey.

use "cps78_85.dta", clear

*What we will do to estimate the wage gap and the returns to education between
*1978 and 1985. We can do this by interacting our binary variable y85 with
*our continuous variable of education. Our coefficient on edu will be the 
*returns to education in 1978 and the return to education in 1985 will be captured
*in the coefficient for edu#1.y85 plus the coefficient for edu in 1978. 
*The coefficient for edu#1.y85 will be relative to the coefficient on edu, so
*We can add the two coefficients to find the returns to education in 1985.

*We also interact our binary variable y85
*with another binary variable female to see the wage gap in 1978 and 1985.
*1.female will be the wage gap in 1978 and 1.female#1.y85 plus the 1.female 
*will be our wage gap for females in 1985.

*Wages will have changed between 1978 and 1985 due to inflation, since wages
*in the CPS are in nominal dollars. We can deflate our wages with a price 
*deflator, or we can use natural log of wages with time binaries to capture
*inflation that is associated with the year binaries.

*Natural Log and accounting for inflation with time variables. Let's say our
*deflator for 1985 is 1.65, so we need to divide wages by the deflator to get 
*real wages in 1978 dollars. But if we take the natural log transformed wages
*using real or nominal wages does not matter since the inflation factor will
*be absorbed in the time binary y1985:

*ln(wage_i/P85)=ln(wages_i)-ln(p85). 

*While wages may differ across individuals in 1985, all individuals in 1985 are
*affected by the secular trend of inflation relevant to 1985.  (Note: if the 
*price trends varied by region, then we would need to account for this since
*prices would not be a secular trend affecting all people).

*We need both ln(wages) and time binaries, otherwise our estimates would be biased.
*Note: that this remains true whether the nominal value is in the dependent
*or independent variables as long as it is natural log transformed and has 
*time binaries.

reg lwage i.y85##c.edu c.exper##c.exper i.union i.female##i.y85

*Our results
*Wage gap in 1978 is exp(-.317)-1*100 = -27.2%
*Wage gap in 1985 is exp(-.317+.085)-1*100 = -20.7%
display (exp(-.317)-1)*100
display (exp(-.317+0.085)-1)*100

*Difference in returns to education
display (exp(0.0747)-1)*100
display (exp(0.0747+0.0185)-1)*100

*Declines in wage gap since 1978
display (exp(0.085)-1)*100
*Increases in returns to education since 1978
display (exp(0.0185)-1)*100

*Chow Test/F-Test for structural changes across time (nested-model)
*Test whether or not to include time binaries
test 1.y85 0.y85 1.y85#edu 1.y85#1.female
*Test slopes
test 1.y85#edu 1.y85#1.female
*Test intercepts
test 1.y85 0.y85

*Should we keep our time binaries? Our F-tests show that we should and we'll 
*need them for to account for inflation.
 
*****************
*Sleep vs Working
*****************
*Lesson: The way you set up panel data matters. We need to use the long-format.

*I think this is a good example of a poorly set up panel data. We'll use the
*file called slp75_81.dta to took at a two year panel data from Biddle and
*Hamermesh (1990) to estimate the tradeoff between sleeping and working.
*We have data for 239 people between 1975 and 1981 for the same person in
*both periods.

use "slp75_81.dta", clear

*We'll get to reshape in Mitchell soon, but here is a preview.
*We will reshape the data so that each cross-sectional unit of observation
*has 2 rows: one for 1975 and one for 1985.

*Reshape
gen id=_n
gen age81=age75+6
reshape long age educ gdhlth marr slpnap totwrk yngkid, i(id) j(year)
replace year=year+1900

*We'll generate our time binaries
*Gen time binaries
gen d75 = .
replace d75=0 if year==1981
replace d75=1 if year==1975

gen d81=.
replace d81=0 if year==1975
replace d81=1 if year==1981

*And we'll want to check that we don't have any overlapping periods
*Check
tab year d75
tab year d81
tab d81 d75

*Now we can work with the panel
*Let xtset know that there is a 6 year gap in the data
*If not, it will try to take a 1 year change and 1976 does not exist
xtset id year, delta(6)

*slpnap - total minutes of sleep per week
*totwrk - total minutes of work per week
*educ - total years of education
*marr - married dummy variable
*yngkid - presence of a young child dummy variable
*gdhlth - "good health" dummy variable



*After we set up our panel, we can control for the unobserved cross-sectional
*unit effect a_i, or unobserved individual effect that do not vary over time.
*This is all characteristics of the cross-sectional unit of observation that
*is constant over time or time-invariant.

*We are interested in the tradeoff between work and sleep. Our dependent 
*variable of interest is total minutes sleeping per week. Our explanatory
*variable of interest is the total working hours during the year.
histogram totwrk
histogram slpnap

*When we run OLS, we do not control for unobserved individual time-invariant
*effects

*Pooled OLS
est clear
eststo OLS: reg slpnap i.d81 totwrk educ marr yngkid gdhlth 
*FD Model
eststo FD: reg d.slpnap d.totwrk d.educ d.marr d.yngkid d.gdhlth
*FE Model
eststo Within: xtreg slpnap i.d81 totwrk educ marr yngkid gdhlth, fe
*Similar except time dummy and base intercepts
*look at the difference between educ in Pooled and FE models
*There is likely a confounder between ability sleep and education

esttab OLS FD Within, mtitles se scalars(F r2) drop(0.d81)

*Let's look at elasticities
gen lnslpnap=ln(slpnap)
gen lntotwrk=ln(totwrk)
gen lneduc=ln(educ)

*FD Model
reg d.lnslpnap d.lntotwrk d.lneduc d.marr d.yngkid d.gdhlth
**********************************
*Distributed Lag of Crime Rates on Clear-up Rate
**********************************
*Lesson: Lagged variables can be important explanatory variables
*Note: We'll get into this a bit more in Chapter 10-12.

*We will get into time series later in the course, but we will have a preview.
*With panel data, we are able to see the same observation over time. Given this
*We can see if lagged values affect current values for the cross-sectional unit
*of observation.

*Eide(1994) wants to assess if prior clear-up rates for crime have a relationship
*with crime rates in the current time period. The dependent variable of interest
*is the current period crime rate. The variable of interest is the clear-up
*percentage which is the rate of crimes that have lead to conviction.

use crime3.dta, clear

*We will use a log-log model and use a first-difference
reg clcrime cclrprc1 cclrprc2

*Our model tells us that 1 percent increase in getting crimes to conviction
*leads to a reduction in the current period crime rate of about 1.32 percent.
*Assuming this model is specified well, crime rates are sensitive to clear-up
*rates from the prior 2 years.


**********************************
*Enterprise Zones and Unemployment
**********************************
*Lesson: We need to be aware of heteroskedasticity and serial correlation

*We should test for heteroskedasticity and serial correlation when running
*our First-Difference Estimator.

*Serial correlation means that the differences in the idiosyncractic errors 
*between time periods are correlated, which is a violation of our assumption 
*that there is no serial correlation for our first-difference estimator

*We'll use data from Papke (1994) who studied the effect of Indiana's enterprise
*zone program on unemployment claims. Do enterprise zones increase employment
*and reduce unemployment claims?

*She analyzes 22 cities in Indiana from 1980 to 1988, since 6 enterprise zones
*were established in 1984. Twelve cities did not receive the enterprise zones,
*while 10 cities did get enterprise zones.
 
use "ezunem.dta", clear

*We'll use a simple analysis that the change in natural log of unemployment
*claims is a function of time period binaries, change in enterprise zones, and
*the idiosyncractic error.

*One way to do it is to use the data already created.
*Pooled OLS
reg luclms i.d82 i.d83 i.d84 i.d85 i.d86 i.d87 i.d88 cez

*Let's say we didn't have the data already created. What we'll need to do
*is to set the panel data with xtset unit timeperiod
*Set the Panel Data
xtset city year

*We can use the d. operator to use a first difference 
*First Difference
reg d.luclms i.d82 i.d83 i.d84 i.d85 i.d86 i.d87 i.d88 d.ez

*Test for Heteroskedasticity
*Bruesch-Pagan/Cameron-Trivedi Test
estat imtest
*White Test
estat imtest, white
*We fail to reject the null hypothesis of homoskedastic standard errors.

*Test for autocorrelation
*We can use the command xtserial to test for serial correlation, since we already
*set up our panel above.
help xtserial
xtserial luclms d83 d84 d85 d86 d87 d88 cez, output

*We reject the null hypothesis that the differences in idiosyncratic errors is 0.

*What can we do for this serial correlation? We can cluster our standard errors
*to account for the serial correlation within units.

*Robust for serial correlation within unit of analysis clusters
reg d.luclms i.d82 i.d83 i.d84 i.d85 i.d86 i.d87 i.d88 d.cez, robust cluster(city)

*Once we account for the serial correlation in the idiosyncratic error, our
*coefficient on the change in enterprise zone becomes statistically insignificant.

*Testing for serial correlation, and Clustering your standard error at the 
*treatment level is an important test and step with FD estimators.

*When we get to Fixed Effects (Within) estimator, the assumption is slightly
*different. For First-Difference Estimator, the DIFFERENCE in idiosyncratic
*errors cannot be correlated, but for Fixed-Effects (Within) Estimator the
*assumption states that only the idiosyncratic errors cannot be correlated.

********************************
*County Crimes in North Carolina
********************************
*Lesson: First-Difference Estimator (and Fixed Effects Estimator) cannot fix
*simultaneity bias. We need an valid instrument to deal with simultaneity bias.

*Cornwell and Trumbull (1994) analyzed data on 90 counties in North Carolina
*from 1981 to 1987 to using panel data to account for time-invariant effects.
*Their cross-sectional unit of observation is the county (not individuals within
*a county). They want to know what the is the effect of police per capita on
*crime rates.

*For our model the dependent variable is the change in the natural log of 
*crimes per person (lcrimrte). They are interested in estimating the sensitivity
*of police per capita (polpc) on crime rate, so they use the difference in 
*natural log of police per capita. This will get you elasticities, which provide
*useful interpretations of percentage increases.

*They also control for the difference in natural log of probability of arrest 
*(prbarr), the probability of conviction (prbconv), the probability of serving 
*time in prison given a conviction (prbpris), and the average sentence length.

use "crime4.dta", clear
*Pooled OLS
reg lcrmrte i.d82 i.d83 i.d84 i.d85 i.d86 i.d87 lprbarr lprbconv lprbpris lavgsen lpolpc

*First Difference
xtset county year
*With xtset, we can use the d. for our explanatory variables
*We don't include 
*With OLS Standard Errors
reg d.lcrmrte i.d83 i.d84 i.d85 i.d86 i.d87 d.lprbarr d.lprbconv d.lprbpris ///
              d.lavgsen d.lpolpc
			  
*So our model is estimating that a 1% increase in police per capita increases
*the crime rate by about 0.4%. We would expect that increases in police per 
*capita would reduce crime rates. This is likely shows that there are problems 
*in our model. 

*What is happening? Likely simultaneity bias is occurring. Areas with high
*crime rates have more police per capita, which more police per capita is 
*associated with higher crime rates. It's a circular/endogenous reference, so
*we will need an valid instrument to deal with this simultaneity bias/endogeneity.

*We can test for heteroskedasticity and serial correlation, but this only affects
*our standard errors, not our coefficients.

*Test for autocorrelation with one lag AR(1)
*We can see that serial correlation is a problem, which means we should cluster
*our standard errors at the county level.
predict r, residual
gen lag_r =l.r
reg r lag_r i.d83 i.d84 i.d85 i.d86 i.d87 d.lprbarr d.lprbconv d.lprbpris ///
              d.lavgsen d.lpolpc

*We can always use our xtserial command to test for AR(1) serial correlation.
reg d.lcrmrte i.d83 i.d84 i.d85 i.d86 i.d87 d.lprbarr d.lprbconv d.lprbpris ///
              d.lavgsen d.lpolpc

xtserial lcrmrte d83 d84 d85 d86 d87 lprbarr lprbconv lprbpris ///
              lavgsen lpolpc, output
			 
*We can also test for heteroskedasticity
reg d.lcrmrte i.d83 i.d84 i.d85 i.d86 i.d87 d.lprbarr d.lprbconv d.lprbpris ///
              d.lavgsen d.lpolpc
rvfplot,yline(0)
*We can use the White Test and Breusch-Pagan, which yield different results
estat imtest, white
estat hettest

*Re-estimate with Robust Standard Errors clustered at the county level
*and cluster by county (deal with error correlations within counties)
reg d.lcrmrte i.d83 i.d84 i.d85 i.d86 i.d87 d.lprbarr d.lprbconv d.lprbpris ///
              d.lavgsen d.lpolpc, robust cluster(county)
			  
*Even accounting for heteroskedasticity and serial correlation, our model is
*likely biased by simultaneity bias.
			  
********************************************************************************
*Mitchell
********************************************************************************

*Honestly, this chapter has a bunch of useful information, but the most 
*important parts are label define and its two options of add and modify, along
*with label values. Everything else is interesting, but not essential. Section
*5.8 on formatting is also fairly important for down the road.
cd "/Users/Sam/Desktop/Econ 645/Data/Mitchell"

************
*5.2 Describing datasets
************
*Let's get some data on the survey of graduate students
use "survey7.dta", clear

*We have seen the describe command before, but it is a very useful command 
*to being working with data. It provides the varible name, storage type, 
*display format, value label, and variable lable
describe

*We also have a short option, but it just contain general information
describe, short

*We can subset the variables we want to describe if we want
describe id gender race

*Finally, the command codebook provides a deep dive into your dataset. This is
*very useful for looking at the value labels. We only see the value label name 
*in the describe command, but the codebook command provides more information, 
*such as type of variable, label name, range of values, unique values, 
*missing, value labels, missing value labels (if any)
codebook

*We can go by variables 
codebook race

*We can go by variables and notes
codebook havechild, notes

*We can look at the variable and missing value labels with the option mv.
*I recommend that you don't label the missing values unless it is absolutely
*necessary. Different types of missing values besides "." cause problems down
*the road, especially with the marginsplot command.
codebook ksex, mv

*If you are interested in the different languages labels it is on page 112

*The lookfor command will return all variables with the search word. This is a
*bit redundent, since this is available in the variable window. But, it provides
*more space to look.
lookfor birth

*We can also search for the notes by the search word
notes search birth

*We can see the formats of the variables as well
list income bday
describe income bday
*We can see that the format for income is %11.1fc and the format for bday is %td

************
*5.3 Labeling variables
************
*Labeling the variables is a very helpful shortcut to describe what the variable
*contain without having to go back to the data dicionary. Sometimes we want
*a short and concise label if we are exporting labels to regression tables, or
*sometimes we want longer variable labels to give us context of the variable.

*Let's get some data on graduate students
use "survey1.dta", clear
*and describe
describe 

*We have no variable labels, so we will need to provide some so future users
*have an understand what the data are.
label variable id "Identification variable"
label variable gender "Gender of the student"
label variable race "Race of the student"
label variable havechild "Given birth to a child"
label variable ksex "Sex of child"
label variable bday "Birthday of student"
label variable income "Income of student"
label variable kbdays "Birthday of child"
label variable kidname "Name of child"
describe

*We can simply change the variable label with running the command again with
*the new variable label.
label variable id "Unique identification variable"
describe

save survey2, replace

************
*5.4 Labeling values
************
*Labeling values is a very practice way of analyzing data without having to 
*go back to the data dictionary.

*Labeling values is a bit different than labeling variables, since we need to
*modify or replace after a label has been defined.

use survey2, clear

*Let's look at our codebook
codebook 

*We have our variable labels from 5.3, but now we need to label the values so
*replicators can know what the data are without having to reference the data
*dictionary for every variable

*First we need to define a label with label define
label define racelabel 1 "White" 2 "Asian" 3 "Hispanic" 4 "Black"

*Next we need to label the values of the variable with label values
label values race racelabel

*Let's look at our codebook again
codebook race

*We are still missing a value label for 5, which is Other, so we need to modify
*our defined label race1. If we do not modify our label, we will get an error
*if we try to label values again.  We can use the add option in label define.
label define racelabel 5 "Other", add

*If we want to modify an existing label, we can use the modify option in label
*define
label define racelabel 4 "African American", modify

*Let's look at our codebook again
codebook race

*Labeling missing is something that I don't recommend, but we'll show an
*example here
label define mfkid 1 "Male" 2 "Female" .u "Unknown" .n "NA"
label values ksex mfkid
codebook ksex

label define havechildlabel 0 "Don't have a child" 1 "Have a child" .u "Unknown" .n "NA"
label values havechild havechildlabel
codebook havechild

*We can look at our label list to see what we have define so far
label list

*The numlabel command is an interesting command. It takes the guess work out of
*knowing the numeric value of the category by appending the numeric value with
*the label value
numlabel racelabel, add
label list racelabel
tabulate race

*And, if we don't like it or don't need it any more, we can remove the numeric
*values
numlabel racelabel, remove
tabulate race

*We can add additional characters with numlabel as well, such as "#=" or "#) "
*with the mask option
numlabel racelabel, add mask("#) ")
tabulate race
*We can remove the mask with remove plus the mask option
numlabel racelabel, remove mask("#) ")
tabulate race

save survey3, replace

************
*5.5 Labeling utilities
************
*Stata has label utilities to manage the labels defined. The first one is
*label dir to see the labels names available in a quick and more concise way 
*than using the codebook command

*For me, I think that label list will be your most useful command here.

*Quick check of your label directory
label dir
*Label list gives a more comprehensive view of your labels that includes the
*value labels associated with the value label name
label list

*Label save command will save your labels into a do file for future use.
*Our do file name is stated after the using statement.
label save havechildlabel racelabel using surveylabs
type surveylabs.do

*Labelbook is command that provides information similar to codebook but only 
*for the labels that are defined
labelbook
labelbook racelabel

*The labelbook problem option provides information to alert the users of 
*any problems
labelbook, problem

*We can have a more detailed look with the detail and problem options
labelbook racelabel, problem detail

************
*5.6 Labeling variables and values in different languages
************
*We will not be covering this, but if you are interested, please review 
*pages 127-132

************
*5.7 Using Notes
************
*Notes can be helpful for future users or for replicators. 
*If you use the note command without specifying the variable, then it is a 
*general note that will show up under the _dta note.  If you add a variable 
*in front of the note command, like note var1:, then you will add a note to
*the variable

*Let's add some general notes
note: This was based on the dataset called survey1.txt
*Adding TS to the end adds a timestamp, which is a nice feature
note: The missing values for havechild and childage were coded using -1 and ///
      -2 but were converted to .n and .u TS
	  
*Let's call our notes with the notes command
notes

*Let's add some notes to our variables and check
note race: The other category includes people who specified multiple races
note race: This is another note
note race: This is a third note
notes
*Or we can just call a particular variable for notes
notes race

*Let say we added an unhelpful note, then we can drop it with notes drop and
*we want to drop the second note.
notes drop race in 2
notes race

*Notice that we have a gap in the sequence of numbering. We can fix that with
*the notes renumber command
notes renumber race
notes race

*We can also search notes with the notes search "string" command
notes search .u

************
*5.8 Formatting the display of variables
************
* Formatting data will be more common than you expect. It can be a pain when
* dealing with numbers in the millions or billions and you lack commas.

**
*Format numerics
**

* Let's get our survey data
use survey5, clear

* Let's list the first 5 observations for id and income
list id income in 1/5

*Let's look at the format of income.
describe income
* The format is %9.0g. We always have % in front of our format and g is a general 
* way of displaying incomes using a width of nine digits and decides for us the 
* best way to display the values. g means general here.

*%w.dg means general - find the best way to show the decimals
*Note: %#.#g will change the format to exponent if necessary
* %w.df means fixed - w is the width, d is the decimals, and f means fixed
* %w.dfc means fixed with commas - w is the width, d is the decimals, f means 
*                                 fixed, and c means comma
* %w.dgc means general with commas - w is the width, decimals will be decided,
*                                   g means general, and c means comma
* The manual is helpful for formatting: https://www.stata.com/manuals/dformat.pdf
*
* Examples fromat v1 %10.0g - Width of 10 digits and decimals will be decided
* Examples format v2 %4.1f - Show 3 digits in v3 and 1 decimal
* Examples format v3 %6.1fc - Show 4 digits plus the comma plus 1 digit

* Let's get more control over the income format and use the %w.df format. We want
* a total of 12 digits with 2 decimals places, which means we have 10 digits on
* the left side of the .
format income %12.2f
list income in 1/5
*Notice that we now can see observation #3's decimal places

* If we don't care to see the decimal place (even though it is still there).
format income %7.0f
list income in 1/5

* We we want to see one decimal place
format income %9.1f
list income in 1/5

* Now let's add commas, but we need to add two additional digit widths for the
* commas and we'll add two decimal places
format income %12.2fc
list income in 1/5

**
*Format Strings
**
* Let's turn to formating 
describe kidname
* The format is %10s, which is a (s)tring of 10 characters wide that is right-
* justified
list kidname

* If we wanted to left-justify the string, we can add a '-' in between % and #s.
format kidname %-10s
list kidname

**
*Format dates
**
* Dates in Stata are a bit of a pain, so learning how to format the dates will
* be helpful in the future.
list bdays kbdays

* Our birthdays are in a MM/DD/YYYY format currently
* lets generate a new variable with the date function
* The date function will convert a string that is in a date format into a
* Stata date, but it still needs to be formatted. The option "MDY" tells Stata
* that the string is in the Month-Day-Year format and needs to be converted.
generate bday = date(bdays, "MDY")
generate kbday = date(kbdays, "MDY")
* Let's list the days.
list bdays bday kbdays kbday
* The Stata dates are actually stored as the number of days from Jan 1, 1960
* which is convenient for the computer storing and performing date computations,
* but is difficult for us to read.

* Let's use the %td format - for example 01Jan2000
format bday %td 
format kbday %td
list bdays bday kbdays kbday

* Let's use the %tdNN/DD/YY format...NN is used for 01-12 and nn is for 1-12
*                                    Mon is Jan and Month is January
format bday %tdNN/DD/YY
list bdays bday kbdays kbday
format bday %tdMonth/DD/YY 
list bdays bday kbdays kbday

* We can use a standard Month DD, YYYY with the format %tdMonth_DD,CCYY
* Where Month is the full name of the month, DD is our days in digits, and 
* CC is Century, such as 19- and 20- and YY is 2-digit year, such as -88, -97
format bday %tdMonth_DD,CCYY
list bdays bday kbdays kbday

* Let's use a standard format, but don't use YYYY - it just repeats the 2-digit
* year twice
format bday %tdNN/DD/YYYY
list bdays bday kbdays kbday
* Use %tdNN/DD/CCYY
format bday %tdNN/DD/CCYY
list bdays bday kbdays kbday

label variable bday "Date of birth of student"
label variable kbdays "Date of birth of child"
drop bdays kbdays
* bday and bdays are redundent and we'll only keep one
drop bdays kbdays

save survey6, replace

************
*5.9 Changing the order of variables in a dataset
************
* I personally find reordering the order of variables to be useful. This is 
* especially true when working with panel data. I like to order the panel data
* to have the cross-sectional unit first, such as personal id, firm id, etc.
* first and then have the time period second, so we have our N and T next 
* to one another.

* Let's pull our survey of graduate students
use survey6, clear

* Describe our dataset
describe

* We might want to group our variables with similar types of variables. This
* can be helpful when you have a large dataset with hundreds of variables, such
* as the CPS.
order id gender race bday income havechild
describe
* The variables that we leave off will remain in the same order as before after
* the new variables are moved to the left.

* With the before option, we can move variable(s) before a defined variable
* Let's move kidname before ksex
order kidname, before(ksex)
describe

* We can move newly created variables with the before and after options with 
* the generate command
generate STUDENTVARS = ., before(gender)
generate KIDSVARS = ., after(havechild)
describe

******************
*Practice*
******************
* Let's bring in the CPS

* Generate a new variable from pemlr called employed where employed = 1 if 
* the individual is employed (present or absent) and employed = 0 if the 
* individual is unemployed. The value should be missing if the individual
* is not in the labor force

* Label the variable "Currently employed"

* Label the values for 0 "Not employed" 1 "Employed" . "Not in the Labor Force"

* Move the variable after pemlr

* Generate a date that appends hrmonth (month of interview), the string "12", 
* and the hryear4 (year of interview). We use 12 because the week of the 12th
* is the reference period 

* Now format the date so it is like 06/12/2023

