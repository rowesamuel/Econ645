*Fulton Fish Market
*Samuel Rowe
*August 10, 2023

clear
set more off
cd "/Users/Sam/Desktop/Econ 645/Student Presentations/SEM"
import delimited using "fulton_fish.out.txt", clear

*cd "/Users/Sam/Desktop/Econ 645/Data/Fulton"
*import excel using "Fulton.xlsx", clear firstrow

label variable day1 "Monday"
label variable day2 "Tuesday"
label variable day3 "Wednesday"
label variable day4 "Thursday"
label variable date "YYMMDD"
label variable stormy "Stormy Weather at Sea: Wave Height > 4.5 ft; Wind Speed > 18knots"
label variable mixed "Weather at Sea Mixed"
label variable price "natural log of price of whiting fish"
label variable qty "natural log of quantity of whiting fish"
label variable rainy "Rain on shore"
label variable cold "Weather on shore"
label variable windspd "Windspeed at Sea"
label variable windspd2 "Windspeed at Sea Squared"
label variable pricelevel "price of whiting per pounds"
label variable totr "total quantity that dealer received that day"
label variable tots "total quantity that deal sold that day"

save "fulton_fish_mkt.dta", replace

****************************
*Recreate
****************************
*Table 2
*OLS
reg qty price, robust
reg qty price i.day* i.cold i.rainy, robust

*2SLS - Windspeed
ivregress 2sls qty (price=windspd windspd2), robust
ivregress 2sls qty (price=windspd windspd2) i.day* i.cold i.rainy, robust

ivregress 2sls qty (price=stormy), robust
ivregress 2sls qty (price=stormy) i.day* i.cold i.rainy, robust

/*
reg LogQuantity LogPrice Monday Tuesday Wednesday Thursday time_period, robust

reg LogPrice Windspeed i.Monday i.Tuesday i.Wednesday i.Thursday time_period, robust

reg LogPrice Windspeed2 i.Monday i.Tuesday i.Wednesday i.Thursday time_period, robust

reg LogPrice Mixed Stormy i.Monday i.Tuesday i.Wednesday i.Thursday time_period, robust

*2SLS


ivreg LogQuantity (LogPrice=Windspeed) Monday Tuesday Wednesday Thursday time_period, robust first
ivreg LogQuantity (LogPrice=Stormy) Mixed Monday Tuesday Wednesday Thursday time_period, robust first
