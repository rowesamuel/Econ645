*Econ 645: Week 10 and 11
*Time Series

********************************************************************************
*Wooldridge
********************************************************************************
*Set Working Directory
cd "/Users/Sam/Desktop/Econ 645/Data/Wooldridge"

*Topics:
*Static Model
*Finite Distributed Lag Model
*AR(1) Model
*Serial Correlation
*Forecasting

**************
*Static Models
**************

*Lesson: Problematic analysis with a static model between inflation and 
*unemployment

*Static Philips Curve
use phillips.dta, clear

*Set the Time Series
tsset year

reg inf unem if year < 1997

twoway line inf year
twoway line unem year

*Our result do not suggest a trade off between inflation and unemployment, and
*potentially suggest a positive relationship. This is likely a misspecified 
*model and does not best describe the short-run trade-off between inflation
*and unemployment. We'll look at an augmeneted Phillips curve that better 
*describes the relationship.


*Inflation and Deficits on Interest Rates
*Lesson: some static models explain time-series better than the prior model
use intdef.dta, clear

*Looking inflation and deficits on interest rates. i3 is the 3-month T-bill rate,
*and inf is the annual inflation rate from CPI, and def is the federal budget
*deficit as a percentage of GDP.

*Set the Time Series
tsset year

reg i3 inf def if year < 2004

*This static model better explain interest rates based on basic macroeconomics.
*Both contemporaneous variables explain current interest rates.


*Puerto Rican Employment and Minimum Wage
use prminwge, clear

*We'll look at the association between employment and minimum wage in Puerto Rico.
*ln(prepop) is the natural log of the employment to population ratio in PR, 
*ln(mincov) is the importance of minimum wage relative to average wages or
*mincov=average minimum wage/average wages)*average coverage rate or people 
*actually covered by the minimum wage law

*Set Time Series
tsset year

reg lprepop lmincov lusgnp if year < 1988

*Our results show that there is a tradeoff between the employment ratio and 
*the importance of minimum wage. A one percent increase in importance of 
*minimum wage the employment-population ratio declines 1.54 percent.


*Antidumping Filings and Chemical Imports
*The barium industry in the U.S. complained to the International Trade Commission
*that China was dumping (or selling imports at lower prices to undercut domestic producers).
*First, are imports unusually high before the complaint? Second, do imports
*change after the dumping complaint?

use barium.dta, clear

*Set Time Series Monthly
tsset t, monthly

*Our model is the natural log of volume of imports of barium chloride as the dependent variable.
*affile6 is an indicator for 6 months after filing the complaint, while befile6 is and indicator
*for 6 month prior to the filing. The variable afdec6 denotes 6 months after the a positive
*decision. 
*Other variables are gas - another demand variable and rtwex - strength of the dollar against
*other currencies

reg lchnimp lchempi lgas lrtwex befile6 affile6 afdec6

*We see that imports are not higher 6 months before a complaint, and imports
*are not lower 6 months after a complaint. However, imports are lower 6 months
*after a positive decision in a complaint by the ITC. The impact is fairly large
*and imports of barium chloride fall about 43.2% after a positive decision.

*Also notice that rtwex is positive, and we would expect that a stronger dollar
*increase demand for imports, which is about uni-elastic.

display (exp(-.565)-1)*100

*Election Outcomes and Performance
use fair.dta, clear

*Set Time Series
tsset year, delta(4) yearly

reg demvote partyWH incum pWHgnews pWHinf if year < 1996

*******************************
*Finite Distributed Lags Models
*******************************
*Lesson: using lags in the explanatory variables
*Personal Exemption on Fertility Rates
use fertil3.dta, clear

*Our interest the general fertility rate, which is the number of children born
*to every 1,000 women of childbearing age. PE is the average real dollar value
*of the personal tax exemption and two binary variables for World War II and 
*the introduction of the birth control pill in 1963.
*Set Time Series

tsset year, yearly

reg gfr pe i.ww2 i.pill if year < 1985

*World War II reduced the fertility rate by 24.24 births per 1,000 women of
*child bearing age, while the introduction of the birth control pill reduced
*the number of birth by 31.59 births per 1,000 women of childbearing age.
*The personal tax exemption. A one dollar increase in the average real value of
*the personal tax exemption increases 0.083 births per 1,000 women of child
*bearing age or a 12 dollar increase in the average real personal
*tax exemption increases 1 child per 1,000 women of child bearing ago

*Next lets add lags in the average real value of the personal tax exemption.

reg gfr pe pe_1 pe_2 i.ww2 i.pill if year < 1985

*Our personal exemption variables are no longer statistically significiant, but
*let's test the joint significance. We might have multicollinearity that bias
*our standard errors for our PE variables.
test pe pe_1 pe_2
test pe_1 pe_2
*Our PE variables are jointly significant, but our lags are jointly insignificiant
*so we'll use our static model.

*For the estimated LRP: .073-.0058+0.034~.101, but we lack a standard error.
*We'll need to estimate the standard error.
*Let $$ \theta_0=\delta_0+\delta_1+\delta_2 $$ denote the LRP and write $$ \delta_0 $$
*in terms of $$ \theta_0 , \delta_1 , and \delta_2 $$ where
*$$ \delta_0 = \theta_0 - \delta_1 - \delta_2 $$ 
*Next substitute for $$ \delta_0 $$ 
*$$ gfr_t = \alpha_0 + \delta_0 pe_t + \delta_1 pe_(t-1) + \delta_2 pe_(t-2) + ... $$
*to get 
*$$ gfr_t = \alpha_0 + (\theta_0 - \delta_1 - \delta_2)pe_t + \delta_1 pe_(t-1) + \delta_2 pe_(t-2) + ... $$
*$$ gfr_t = \alpha_0 + \theta_0 pe_t + \delta_1 (pe_(t-1) - pe_t) + \delta_2 (pe_(t-2) - pe_t) + $$

*$$ We can estimate \, \hat{\theta_0} \, and its standard error $$.
*We can regress gfr_t onto pe_t, (pe_(t-1) - pe_t), and (pe_t-2 - pe_t), ww2, and pill

	gen pe_1_1 = pe_1 - pe
	gen pe_2_1 = pe_2 - pe
	
	reg gfr pe pe_1_1 pe_2_1 i.ww2 i.pill
	
*Our theta-hat is about .101 and significant, so our LRP has an effect on general fertility rates.


**************
*Linear Trends
**************
*Lesson: Importance of time trends
use hseinv.dta, clear

*We look at annual housing investement and a housing price index from 1947 to 1988.

*Set Time Series
tsset year, yearly

*Our model is the natural log of invpc or real per capita housing investment ($1,000)
*and price be the housing price index where 1982 = 1 (or 100). We'll assume 
*constant elasticity with our log-log model. 

reg linvpc lprice

*Our output shows that a 1 percent increase in the pricing index increases
*the investment per capita by 1.24 percent (or elastic response).
*Note: both investment and price have upward trends that we need to account for.

reg linvpc lprice t

*After accounting for the upward linear trend for both investment per capita and
*the housing price index, an increase in price is coefficient is now negative, but
*it is not statistically significant. We probably have serial correlation which
*will bias our standard errors
predict u
reg u l.u, noconst
drop u

*Personal Exemption on Fertility Rates
*Lesson: Importance of non-linear time trends
use fertil3.dta, clear

*We'll look at fertility again, but we'll account for a quadratic time trend.
*First, we'll estimate a linear time trend, and then we'll try a quadratic time trend.

*Set Time Series
tsset year

*Linear Trend
reg gfr pe i.ww2 i.pill t if year < 1985

*Quadratic Trend
*Fertility is declining but at a decreasing rate (eventually t^2 takes over t
reg gfr pe i.ww2 i.pill c.t##c.t if year < 1985

*The fertility rate exhibits upward and downward trends between 1913 and 1984.
*Interestingly, pe remains fairly robust after adding time trends. The linear
*time trend shows that general fertility rates are falling by 1.15 childs per 1,000
*women of childbearing age for each additional year. However, the quadratic shows
*that the trend is negative but decreasing rate and will eventually become positive.

*Puerto Rican Employment
*The last linear trend is for employment-population ratio and the importance of minimum wage 
*coverage. We'll add a time trend along with mincov and usgnp.
use prminwge, clear

*Set the Time Series
tsset year, yearly

*Add linear trend
reg lprepop lmincov lusgnp t

*The employment-population ratio does not have much of a downward or upward trend, 
*but usgnp does. Тhe linear trend of usgnp is about 3% per year, so an estimate
*of 1.06 in our model mean that when usgnp increases by 1% above its long-term 
*trend, employment-population ratio increases by about 1.06%

*Seasonality
*We'll add monthly variables to account for the fact that imports are not
*seasonlly adjusted. 
use barium.dta, clear

*Set Time Series Monthly
tsset t, monthly

reg lchnimp lchempi lgas lrtwex befile6 affile6 afdec6 feb mar apr may ///
                                                       jun jul aug sep ///
													   oct nov dec
*We compare all months to January as the base period, but let's test their
*joint significance.
test feb mar apr may jun jul aug sep oct nov dec
*We find that they are jointly insignificant and seasonality does not seem
*to be an issue with barium chloride imports.

********************************************
*Weakly Dependent and Stationary Time Series AR(1) Models
********************************************
*We'll test the a version of the efficient market hypothesis (EMH) by looking
*at weekly stock return from 1976 to 1989.

use nyse, clear

*Set Time Series
tsset t

*Our dependent variable is the weekly percentage return on the New York Stock Exchange.
*A strict form of the EMH states that information observable to the market prior to 
*week t should not help to predict the return during week t.
*$$ E(y_t|y_{t-1},y_{t-2},...)=E(y_t) $$

*We will test EMH by specifying an AR(1) model and our hypothesis states that
*beta for y_(t-1) will be equal to 0. We'll assume that stock returns are 
*serially uncorrelated, so we can safetly assume that they are weakly dependent

reg return l.return
*Or
reg return return_1
predict u
reg u l.u, noconst
drop u
*We cannot reject the null hypothesis under our model, but we do have some
*evidence of positive serial correlation.

*Expected Augmented Phillips Curve
*We'll revisit the Phillips curve
use phillips.dta, clear

*Set Time Series
tsset year

*A linear version of the expections augmented Phillips curve can be written as
*$$ inf_t - inf^e_t=\beta_1(unemp_t-\mu_0) + e_t $$

*Where mu_0 is the natural rate of unemployment and inf^e is the expected rate 
*of inflation formed in year t-1. 
*The difference between actual unemployment and the natural rate is called 
*cyclical unemployment, while the difference between inflation and expected 
*inflation is called unanticipated inflation
*Our e_t is called our supply shock.
*If there is a trade-off between inflation and unemployment our beta-hat_1
*will be negative.

*An assumption is made about inflationary expectations and unders adaptive expectations,
*the expected value of current inflation depends on recently observed inflation.
*The expected inflation will be assumed to be equal to last years inflation
*$$ inf_t - int_{t-1}=\beta_0 + \beta_1 unemp_t + e_t $$
*$$ \Delta inf_t =\beta_0 + \beta_1 unemp_t + e_t $$

*Where
* $$ \Delta inf_t=inf_t - inf_{t-1} $$
* $$ \beta_0 = -\beta_1 \mu_0 $$
*Since beta_1 is expected to be negative and beta_0 is expected to be positive

*Therefore, under adaptive expectations, the augmented Phillips curve relates the
*change in inflation to the level of unemployment and a supply shock e_t.
*We'll assume TSC.1-TSC.5 hold

*First Difference in the dependent variable or adaptive expectations of inflation
reg cinf unem if year < 1997
*or
reg d.inf unem if year < 1997

*The trade-off between unanticipated inflation and cyclical unemployment is
*seen in beta-hat_1. A 1-point increase in unemployment decreases unanticipated
*inflation by about .54 points.

*We can estimate the natural rate of unemployment by dividing beta-hat_0 by
*negative of beta-hat-1
* $$ \mu_0 = \frac{\hat{\beta_0}}{-\hat{beta_1}} $$
display 3.03/.5425

**
*Unit Roots
**

*Fertility 
use fertil3.dta, clear

*Set Time Series
tsset year

*First Difference both dependent and independent
reg d.gfr d.pe if year < 1985
*First differnce with more than 1 lag
reg d.gfr d.pe d.pe_1 d.pe_2 if year < 1985

*Wages and Productivity
use earns.dta, clear

*Set Time Series
tsset year, yearly

reg lhrwage loutphr t

**
*Dynamically Complete
**
use fertil3.dta

*Set Time Series
tsset year, yearly

*Is this dynamically complete?
reg d.gfr d.pe d.pe_1 d.pe_2 if year < 1985
*Add lag ofr d.gfr and see it wasn't dynamically complete
reg d.gfr d.gfr_1 d.pe d.pe_1 d.pe_2 if year < 1985

*******************
*Serial Correlation
*******************
use phillips.dta, clear

*Set Time Series
tsset year, yearly

*Test for serial correlation in Static Model
*Noticable serial correlation
reg inf unem if year < 1997
predict u, resid

reg u l.u, noconst

*Test for serial correlation in First-Differenced Model
*Serial correlation is removed
reg cinf unem if year < 1997
predict u2, resid

reg u2 l.u2, noconst

*Test change in error terms for FD assumption on serial correlation
gen u2_1=l.u2

reg d.u2 d.u2_1, noconst
drop u u2

*Puerto Rican Employment and Minimum Wage
*Durban's alternative statistic
use prminwge, clear

*Set Time Series
tsset year

reg lprepop lmincov lprgnp lusgnp t if year < 1988
predict u
*Test Serial Correlation with Durbin's alternative statistic
*It works when we don't have strictly exogenous regressorss
reg u l.u lmincov lprgnp lusgnp, noconst 
drop u

*Test AR(3) serial correlation
use barium.dta, clear

*Set Time Series
tsset t, monthly

reg lchnimp lchempi lgas lrtwex befile6 affile6 afdec6
predict u

*Test for p1=0 p2=0 p3=0 jointly
reg u l.u l2.u l3.u, noconst
test l.u l2.u l3.u
drop u

**
*Prais-Winsten Estimation in the Event Study
**
*OLS
reg lchnimp lchempi lgas lrtwex befile6 affile6 afdec6
*Prais-Winsten
prais lchnimp lchempi lgas lrtwex befile6 affile6 afdec6

*Inflation and Prais
use phillips.dta, clear

*Set the Time Series
tsset year

est clear
*OLS
eststo OLS: reg inf unem if year < 1997
*Prais-Winsten
eststo PRAIS: prais inf unem if year < 1997

esttab, mtitle stat(N rho)

**
*Differencing and Serial Correlation
**
*Inflation and Deficits on Interest Rates
use intdef.dta, clear

*Set the Time Series
tsset year

reg d.i3 d.inf d.def if year < 2004

**
*Serial Correlation Robust Standard Errors
**
use prminwge.dta, clear

*Set Time Series

*OLS
reg lprepop lmincov lprgnp lusgnp t if year < 1988
predict u
*SC-Robust - FIX THIS

**
*Heteroskedasticity 
**
use nyse.dta, clear

*Set TIME Series
tsset t, weekly

reg return l.return
estat hettest

*Expected value does not depend on past returns, but the variance of returns does

**
*Forecasting
**
use phillips.dta, clear

*Set Time Series
tsset year

*Compare models
*OLS AR(1)
reg unem l.unem if year < 1997

*Next Add Inflation
reg unem l.unem l.inf if year < 1997

*Forecast with 1997-2003

*Forecast 2 Years Ahead
