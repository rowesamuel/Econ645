*Week 2
*Wooldridge Chp 15
*Mitchell Chp 2, 3, 4
*Instrumental Variables, IVReg, and 2SLS
*Samuel Rowe - Adapted from Wooldridge and Mitchell
*August 2, 2023

set more off
clear all

*Set Working Directory
cd "/Users/Sam/Desktop/Econ 645/Data/Wooldridge"

********************************************************************************
*Wooldridge
********************************************************************************
******************
*Estimating Returns to Education for Married Women
******************
*MROZ dataset contains
use "mroz.dta", clear

*We'll use the data on married working women to estimate the return to education
*using a simple OLS model.
*Biased OLS
reg lwage educ

*Our estimate implies that the returns to education is exp(.109)-1*100 about 11.5%
display (exp(_b[educ])-1)*100

*Use Fathers Education as an instrument for the observation's level of education
*if the women is in the labor force
reg educ fathedu if inlf==1
predict edu_hat
*Get F-Statistic
test fathedu
*Our F-test shows that the instrument is greater than F-stat > 15, so it seem
*like a good candidate for an instrument

*Father's Education as an instrument
reg lwage edu_hat

*One additional year of education increases wages by (exp(0.059)-1)*100%=6.1%
display (exp(_b[edu_hat])-1)*100
*Question? 
*The F-test passed the instrument relevance (F-stat > 15), but what
*about instrument exogeneity?

*******************
*Estimating Returns to Education for Men
*******************
*Let's estimate the return
**********
*Exercise
**********
*Use number of siblings as an instrument to predict an observation's level of
*education. We'll keep it simple and have no other covariates.
use "wage2.dta", clear

*1) Estimate the potentially biased OLS

*2) Estimate your first stage

*3) Test your first stage

*4) Run your 2SLS



*Biased OLS
reg lwage educ
*We have a estimated return of education of (exp(.0598392)-1)*100
display (exp(_b[educ])-1)*100
*Use Number of siblings as an instrument
reg educ sibs
predict edu_hat
*Get F-statistic
test sibs

*Number of siblings as an instrument
reg lwage edu_hat

*One additional year of education increases wages by (exp(0.1224)-1)*100%=13.0%
display (exp(_b[edu_hat])-1)*100 
*Another thing that is interesting here is the the OLS estimate is biased 
*downward, which is not what we would expect.
*Possible reasons:
*1) Siblings could be correlated with ability - more siblings, less partental 
*   attention which could result in lower ability
*2) The OLS estimator is downward biased due to measurement error in educ, but
*   this is less likely to satisfy the classic error-in-variables (CEM) assumption

********************
*Smoking on Birthweight
********************
*It is important to see an example of a poor instrument.
use "bwght.dta", clear

*Biased OLS looks at the natural log of birth weight and cigarette packs smoked
*per day by the mother.
*We would expect that smoking is correlated with unobserved health and parental
*decisions, so it is like biased due to unobserved confounders.

reg lbwght packs

*An additional package smoked per day decreases birthweight by exp(-.08981)-1~-8.6%
display (exp(-.08981)-1)*100

*We'll use cigarette prices as an instrument for cigarette packs smoked per day.
*We assume that cigarette prices and the error term u are uncorrelated 
*(instrument exogeneity). Note that some states fund health care with cigarette
*tax revenue. 
*We will use cigarette price and quantity of packs smoked should be negatively
*correlated.
reg packs cigprice
*Our instrument is not associated with quantity consumed. 
predict packs_hat
*Instrument Revelance: 
test cigprice
*Our instrumennt fails the F-test - weak instrument

*Cigarette price as an instrument for packs smoked is a poor instrument and 
*our use of predicted packs smoked is in the wrong direction
reg lbwght packs_hat

*We can and should always test Instrument Relevance. If we have a poor 
*instrument, we should go back to the drawing board.

*Another issue here is that price is a poor instrument, since price and quantity
*are simultaneously determined. We would need a second set of instruments on
*price to estimate our first-stage.

********************
*Card Returns to Education
********************
*Save for presentation
use "card.dta", clear

*OLS
reg lwage educ exper expersq i.black i.smsa i.south i.smsa66 reg662-reg669
*A one year increase in education is associated with an increase of
*(exp(0.075)-1)*100%=7.8%

*Instrument - Near in a 4-year college (or college in county)
reg educ nearc4 exper expersq i.black i.smsa i.south i.smsa66 reg662-reg669
predict educ_hat
test nearc4

*Instrument
reg lwage educ_hat exper expersq i.black i.smsa i.south i.smsa66 reg662-reg669
*A one year increase in education is associated with an increase of
*(exp(0.132)-1)*100%=14.1%

*Using 2SLS
*We can use the ivregress command
*ivregress 2sls <dependent variable> (<biased var>=<iv>) x1 x2 x3...xk
ivregress 2sls lwage (educ=nearc4) exper expersq i.black i.smsa i.south ///
                                   i.smsa66 reg662-reg669, first

******************
*Estimating Returns to Education for Married Women Part 2
******************
use "mroz.dta", clear

*We'll use both parent's education as instruments to identify the effect of 
*education on wages for working women. We overidentify the endogenous variable 
*with 2 instruments: father's education and mother's education.

*Potentially Biased OLS
reg lwage educ c.exper##c.exper
*Our result is (exp(.1074896)-1)*100~11.3%
display (exp(_b[educ])-1)*100

*We'll use to instruments for one endogenous variable
*Use Parent's Education as an instrument for women in the labor force
reg educ c.exper##c.exper fathedu mothedu if inlf==1
predict edu_hat
*Get F-Statistic
*Passes the First Stage Test for good instrument F>15
test fathedu mothedu

*Father's Education as an instrument
reg lwage edu_hat c.exper##c.exper

*One additional year of education increases wages by (exp(0.061)-1)*100%=6.3%

*This can be more easily done with our ivregress 2sls command
ivregress 2sls lwage (educ=fathedu mothedu) c.exper##c.exper
display (exp(_b[educ])-1)*100

********************
*Testing for Endogeneity - Returns to Education for Working Women
********************
use "mroz.dta", clear

*************
*Exercise
*************
*Use father's and mother's education as an instrument to estimate education

*First estimate OLS 

*Second estimate the 2SLS with ivregress 2sls command





*OLS
reg lwage educ c.exper##c.exper

*2SLS
ivregress 2sls lwage (educ=fatheduc motheduc) c.exper##c.exper

**
*Two ways to test endogeneity
**
*If want to see if our explanatory variable of interest is potentially 
*endogenous with the error term. We can conduct an endogeneity test. 
*1) Manually
*Estimate the reduced form for y_2 by regressing all exogenous variables 
*includes those in the structural model and the additional IVs
reg educ c.exper##c.exper fathedu mothedu if inlf==1

*Obtains residuals v-hat_2
predict r, residual

*Add v-hat_2 to the structural equation
reg lwage educ c.exper##c.exper r

*There is possible evidence of endogeneity since p < .1 but p > .05
*You should report IV and OLS 

eststo m1: reg lwage educ c.exper##c.exper
eststo m2: ivregress 2sls lwage (educ=fatheduc motheduc) c.exper##c.exper
esttab m1 m2, mtitle(OLS IV)

*2) With estat
*We can also use a postestimation command estat endogenous
ivregress 2sls lwage (educ=fathedu mothedu) c.exper##c.exper
estat endogenous

*********************
*Testing Overidentifying Restrictions - Returns to Education for Working Women
*********************

*When we have one IV for one endogenous explanatory variable, we have a just
*identified equation. When we have two instruments and one endogenous 
*explanatory variable we have overidentification.

*When we have multiple IVs, we can test to see some of our instruments are 
*correlated with the structural error term.

*We can estimate two 2sls models (one for each IV) and then compare them. 
*They should only differ by the sampling error. If our two beta coefficients
*on our fitted explanatory variable of interest are different then, we conclude 
*that at least one instrument or maybe both is/are correlated with the 
*structural error term

*When we add too many instrumental variables (or overidentification), we
*can increase the efficiency of the 2SLS estimator. However, we may run the
*risk of violating the instrument exogeneity assumption.

* When we use motheredu and fatheredu as IVS for education, we have a single
* overidentification restriction. We have two IVs and 1 endogenous explanatory
* variable
use "mroz.dta", clear

ivregress 2sls lwage (educ=motheduc fatheduc) c.exper##c.exper
*Get our residuals
predict r, resid

*Regress the residual on all exogenous variables
reg r mothedu fathedu c.exper##c.exper

*Obtain R-squared and N
ereturn list
local N=`e(N)'
display "`N'"
local rsq=`e(r2)'
display "`rsq'"
local nR=`N'*`rsq'
display "`nR'"

* Under the null hypothesis that all IVs are uncorrelated with u_1
* nR2~X^2_q, where q is the number of instruments from outside the model 
* minus the total number of endogenous explanatory variables. If nR2 exceeds
* the 5% critical value in X^2_q, then we reject the null hypothesis and 
* conclude that at least some of the IVs are not exogenous

* Here we have q=2-1=1 df for the chi-squared test and we fail to reject the
* null hypothesis since nR2=.37807 and X^2_1 at the 5% critical value is 3.841.

* We can also use the postestimation command of estat overid
ivregress 2sls lwage (educ=motheduc fatheduc) c.exper##c.exper
estat overid
* We get our nR2 with this postestimation command

* Let's add husband's education, so we have 2 overidentification restrictions.
* We 
ivregress 2sls lwage (educ=motheduc fatheduc huseduc) c.exper##c.exper
estat overid

* Notice that we still fail reject the null hypothesis, so we might consider
* adding it as an IV. Also, notice that the coefficient and standard error
* around education has changed as well.

* It is a good idea to report both in a sensitivity analysis

est clear
eststo m1: quietly ivregress 2sls lwage (educ=motheduc fatheduc) c.exper##c.exper
eststo m2: quietly ivregress 2sls lwage (educ=motheduc fatheduc huseduc) c.exper##c.exper
esttab m1 m2, mtitle(2IVs 3IVs)

********************************************************************************
*Mitchell
********************************************************************************
*We won't spend too much time looking into Chapter 2 and 3, since they should 
*be a review from ECON 644.  Chapter 4 will be a review, but we'll look into
*some CPS data

*Recommended resources
*UCLA OARC Stata resources: https://stats.oarc.ucla.edu/stata/modules/
*I have used this source on numerous times. Even when you become proficient with
*Stata, UCLA's OARC Stata resources have been very helpful.
*If you just type "UCLA oarc Stata <enter your topic>" in a search engine, then
*it will usually pop up.

*Statalist if usually another good resource when trying to figure out what
*went wrong.  If you ask as question on the listserve, you will likely be 
*scolded by Nick Cox, or you will be told to "read the manual".  However, if
*you just read what others have asked, you will often find useful information.


**********
*Getting our data
**********
*This will download the data to your working directory.
*So check your working directory.
pwd
*Set your working directory
cd "/Users/Sam/Desktop/Econ 645/Data/Mitchell"

net from https://www.stata-press.com/data/dmus2
net get dmus1
net get dmus2

*All commands
net install dmus1

**************************************
*Chapter 2: Reading and Importing Data
**************************************
*Note when your working directory, I recommend using "/" instead of "\"
*Stata will use both, and the backslash "\" often runs into string issues.

********
*2.2 Reading Stata data
********
*We'll add the clear option to clear our memory to provide an error
use "dentists.dta", clear
list 

*From Stata Press website
use "https://www.stata-press.com/data/dmus2/dentists.dta", clear
*From NBER website
use "https://data.nber.org/morg/annual/morg20.dta", clear

********
*Reading Stata data with subsets
********
*Sometimes we do not want the entire dataset, so we can ingest a subset.
*For example, we have 
cd "/Users/Sam/Desktop/Econ 645/Data/CPS/"
use "jan24pub.dta", clear
*Number of Rows
display _N
*Columns
ds

*If we use the list command, it would be to wieldly to use

*Subsetting by columns
*Reading a subset of the Stata data - if you know the variable names
*use name years using "dentists.dta", clear
use pemlr gestfips using "jan24pub.dta", clear
*list the data - which I don't recommend with large data sets
list in 1/50

*Subsetting by rows (observations)
*use "dentists.dta" if years >= 10, clear
*list
*Read in only observations from Maryland - but hard to read
use "jan24pub.dta" if gestfips == 24, clear
list in 1/50

*Subsetting by row and columns
*use name year using "dentists.dta" if years >= 10, clear
use pemlr gestfips using "jan24pub.dta" if gestfips == 24, clear
list in 1/50

*My recommendation:
*Reading the data dictionary beforehand will help, especially with larger files
*such as the PUMS ACS or CPS

*******
*System data
*******
*I'm not going to focus on these, but they are avaiable
*There are data sets that are included in Stata and use the sysuse command
sysuse auto, clear

*You can use Stata files that are available, but didn't ship with Stata and
*they use the webuse command
webuse fullauto, clear

***********
*2.3 Importing Excel files
***********
*Many times you will need to grab data from a website and these data may be in
*an Excel format such as ".xls" or ".xlsx".
*Our main command is import excel.
*We need to specify the firstrow option if we want the headers as variable names
*Be careful if the headers are numerics, such as years, in the firstrow.
*This will throw an error and we'll need to rename them in Excel before importing
*these files.  For example, 2015 becomes y2015
cd "/Users/Sam/Desktop/Econ 645/Data/BLS/"
*import excel using "dentists.xls", firstrow clear
*list
import excel using "tfp_major_sector_long.xlsx", firstrow clear
list in 1/5

*We need to take caution of the sheet names of the excel files we are importing
*If you don't pay attention you may not get the correct rows
import excel using "tfp_major_sector_wide.xlsx", firstrow clear
list in 1/2
import excel using "tfp_major_sector_wide.xlsx", firstrow cellrange("A2") clear
list in 1/2

*If you don't pay attention you may import the wrong sheet.
import excel using "tfp_major_sector_wide.xlsx", firstrow sheet("MachineReadable") clear
list in 1/2

*import excel using "dentists2.xls", firstrow clear
*list

*import excel using "dentists2.xls", firstrow clear sheet("dentists")
*list

**************
*2.4 Importing SAS files
**************
*Note: importing files from other statistical packages is a pain. If you are
*using another statistical software packages like R, SAS, Python, or heaven-
*forbin SPSS, then export the data from those software package as CSV files.
*CSV files are fairly universal. There maybe some labeling issues, but if labels
*are not a concern then use CSV file formats

*Luckily, SAS data files are becoming less common. Even the Census Bureau has
*seen the light and provides their data in a csv format

*********
*Importing .sas7bdat
*********
*For me, it is unavailable in Stata 14, but if you have Stata 16 or higher 
*you can use this command.

*Import sas is our main command to import SAS from version 7 or higher
import sas "dentists.sas7bdat", clear
list

*********
*Importing SAS XPORT Version 5
*********
import sasxport5 "dentists.xpt", clear
list

*********
*Importing SAS XPORT Version 8
*********
import sasxport8 "dentists.xpt", clear

***************
*2.5 Importing SPSS files
***************
*For me, it is unavailable in Stata 14, but if you have Stata 16 or higher 
*you can use this command.
import spss "dentlab.sav", clear
list

***************
*2.6 Importing dBase files
***************
*For me, it is unavailable in Stata 14, but if you have Stata 16 or higher 
*you can use this command.
import dbase "dentlab.dbf", clear
list

***************
*2.7 Importing Raw Data files
***************
************
*Import Delimited
************
*Importing csv files will likely be more common than other types of files 
*so far with the exception of Stata and Excel files.
*Note: there are other types of delimited files, but comman-delimited are the
*most common. Other types of delimiters include "tab", "space", or "|" delimited.
*CSV file
*If you read the manual you'll noticed that "," and "\t" are the default 
*delimiters
*Using "," delimter
*import delimited using "dentists.csv", clear
cd "/Users/Sam/Desktop/Econ 645/Data/CPS/"
import delimited using "jan24pub.csv", clear
list in 1/2

*CSV files may come in .txt files or .csv files using "," delimiter
cd "/Users/Sam/Desktop/Econ 645/Data/Mitchell"
import delimited using "dentists1.txt", clear
list

*There may be "tab"-delimited files that use "\t" delimiter
import delimited using "dentists2.txt", clear
list
*This will produce the same results as above since "\t" is a default
import delimited using "dentists2.txt", clear delimiters("\t")
list

*This will use a ":"-delimited file
import delimited using "dentists4.txt", clear delimiters(":") 

*We can subset columns and rows with import delimited, which can be helpful
*for large files. Variable names will be defaulted for the first few rows, so
*when we use rowrange(1:3) this will only include 2 rows of data.
import delimited using "dentists2.txt", clear rowrange(1:3)
list

*Import delimited from the web
import delimited using "https://www2.census.gov/programs-surveys/cps/datasets/2024/basic/jan24pub.csv", clear
list in 1/2
*pwd
*save "jun23pub.dta", replace

***********
*Import space-separated files
***********
*Sometimes files have space-delimited files (which is a bad idea when strings
*are involved). Dentists5.txt is an example of such a file.
*We can use the infile command to import these data, but we need to specify
*that the name variable is a string at least 17 characters wide.
infile str17 name years full rec using "dentists5.txt", clear
list
*Infile does not read in variable names in the first row

*We can also use import delimited with delimiters(" ")
import delimited using "dentists6.txt", delimiters(" ") clear
list

***********
*Importing fixed-column files
***********
*This is key to know when the data are not in a user-friendly format!
*Unfortunately, fixed-column files are more common than I prefer.  They are a 
*pain, since you need to specify each column length. I have found this with
*files with a ".dat" file extension.

*We can use the infix command to read in fixed-column files
*Let's look at our fixed-column width files
type "dentists7.txt"

*Our name variable is between 1 and 17, years are between 18 and 22,
*Our fulltime and recommend binaries are only length of 1 with 23 and 24
infix str name 1-17 years 18-22 fulltime 23 recom 24 using "dentists7.txt", clear
list

*This is a real pain, but luckily Stata has dictionary files to help
*if one of these files are available. They have a .dct file extension.
*We already have a fixed-column dictionary with dentists1.dct and we can use it
*to open a fixed-column width file dentists7.txt

*Let's look at our dictionary file
type "dentists1.dct"
*Let's look at our fixed-column width file
type "dentists7.txt"
*Let's use the two together to import the data file
infix using "dentists1.dct", using(dentists7.txt) clear
list

*We can combine infile command with a dictionary file
type "dentists3.dct"
*Notice that the first line of the dictionary file is 
*infile dictionary using dentists7.txt and then the column widths
infile using "dentists3.dct", clear
list

*Dictionary .dct files are very helpful when they are available with 
*fixed-column width files

********
*Subsetting fixed-column width files
********
*We can use the "in" qualifier to subset the number of rows to import
*with either infix or infile
infix str name 1-17 years 18-22 fulltime 23 recom 24 using "dentists7.txt" in 1/3, clear
list

infix using "dentists1.dct" in 1/3, using(dentists7.txt) clear
list

*********
*Importing with multiple lines of fixed-column width
*********
*I won't go into this, but if you do run into these types of files
*please see pages 39-41

*************
*2.8 Common errors when reading and importing files
*************
*Tip: Don't forget to clear your data.
*Either the line before or add it as an option , clear

*Error 1:
*If you do not clear your data with the use command, then you will get the message
*"No; dataset in memory has changed since last saved" - Use clear

*Error 2:
*If you do not clear your data with the import, infix, or infile commands,
*then you will get the message:
*"You must start with an empty dataset" 

*************
*2.9 Entering data directly into Stata Data Editor
*************
*My opinion: If you neeed to manually enter data,I don't recommend manually 
*entering data into STATA.  I recommend using a spreadsheet, then import the
*spreadsheet.

*If for some reason you don't have access to Excel or a spreadsheet application
*like OSX Numbers or Google Sheets, then read pages 43-50.

**************************************
*Chapter 3: Saving and Exporting Data
**************************************

*********
*3.2 Saving Stata files
*********
*It can be helpful to convert a csv, excel, or other type of file to a 
*Stata dta file.  It is also good to consider older types of Stata files
*Older versions of Stata help with sharing data.  (One of my beefs with Stata
*is that newer data files are not compatible with older versions of Stata).
*Let's import a comma-delimited file
import delimited using "dentists1.txt", clear

*We can use the save and saveold commands to convert this comma-delimited file
*into a Stata dta file. Don't forget to replace or else you will run into an
*error when trying to replicate the code.
*Save will save it in Stata 14 (for me) and whatever version of Stata you run
save mydentists, replace
*Saveold and specify version 12
saveold mydentists_v12, version(12) replace

*We can subset as well
keep if recom==1
save mydentists, replace
saveold mydentists_v12, version(12) replace

*There is a compress command, but harddrive are large enough today that it 
*should not be a problem

**********
*3.3 Exporting Excel Files
**********
*Let's say we want to collaborate with someone that doesn't have Stata or 
*wants to make graphs in Excel. We can export to excel either ".xls" or 
*".xlsx" from Stata with the export excel command

*Let's use our main file again
use dentlab, clear

*We can use the export excel command
*Don't forget to use replace option and set the firstrow as variable names
export excel using "dentlab.xlsx", replace firstrow(variables)

*Notice that the labels are exported into the binary 0/1 for parttime and recommend
*We can use the nolabel option
export excel using "dentlab.xlsx", replace firstrow(variables) nolabel

*But what we want a "labeled" and an "unlabeled" sheet in the same excel file?
*This replace option will completely replace the entire Excel file
export excel using "dentlab.xlsx", sheet("Labeled") firstrow(variables) replace

*Let's add another sheet called "Unlabeled", but we don't want to replace the
*entire excel file. We use the replace option in the sheet subcommand option
export excel using "dentlab.xlsx", sheet("Unlabeled", replace) firstrow(variables) nolabel


**********
*3.4 and 3.6 Exporting SAS and dBase files
**********
*My recommendation is to use csv files instead of SAS files
*Please review pages 59-62

**********
*3.7 Exporting comma and tab delimited files
**********
*Exporting CSV Files
*I recommend when collaborating with others, especially if they are using 
*different software like SAS, R, Python, etc. to use csv. They are universally
*read, which makes collaboration easier. You may lose labels (or values), but
*If everyone is not using Stata, then export csv (or excel) is a good idea.
*The default is comma-delimited

use dentlab
list

*Our simpliest export is:
export delimited using "dentists_comma.csv", replace
*This will export the labels instead of the values
*If you want to export the values instead of the labels, use the nolabels option
export delimited using "dentists_comma.csv", nolabel replace

type "dentists_comma.csv"

*You also have the option of putting quotes around strings, which can be a good
*idea if you strings have "," in them. Otherwise, the csv will think the "," 
*is a place to delimit and your dataset will be incorrectly exported.
*The option is simply quote.
export delimited using "dentists_comma.csv", nolabel quote replace

*If for some reason you do not want to export the variables names, you can use
*the novarnames option. 
export delimited using "dentists_comma.csv", nolabel quote novarnames replace
type "dentists_comma.csv"

*Sometimes we may need to format our data for exporting.
replace years = 8.93 if name == "Mike Avity"
export delimited using "dentists_comma.csv", nolabel quote replace
type "dentists_comma.csv"

*Note that the years for Mike Avity we just replace exported as 8.9300003.
*To fix this, we can use the format command to set the total width to 5 and the
*decimal places to 2 with %5.2f
format years %5.2f
export delimited using "dentists_comma.csv", nolabel quote replace
type "dentists_comma.csv"

*For more options see:
help export delimited

**********
*3.8 Exporting space-separated files
**********
*Exporting other files
*I recommend exporting CSV files instead of specialty statistical software
*file extensions (not including STATA).  Why?  Because CSV files are universally
*read across programs, such as R, Python, SAS, SPSS, etc.

*Let's use our dentist file
use "dentlab.dta", clear
list
list, nolabel

*We use the export delimited command to export ","-delimited files
*This will export a .csv file not a .txt file
export delimited using dentists_comma, replace
*or
export delimited using "dentists_comma.csv", replace

*If we don't want labels, which is a good idea, since it's easier to work with
*numerics then strings.  We can use the nolabel option
export delimited using "dentists_comma.csv", replace nolabel

*It's also a good idea to use quotes around the string variables. When there is
*a lack of quotes around the string, problems can occur when importing the csv
*file into different statistical software packages.  W
*We can use the quote option to get quotes around the strings.
export delimited using "dentists_comma.csv", replace nolabel quote
type "dentists_comma.csv"

*Note: The export delimited command exports the variable names in the firstrow
*as the default. If there is a need to exclude the variable names, then we can 
*use the option novarnames
export delimited using "dentists_comma.csv", replace nolabel quote novarnames
type "dentists_comma.csv"

*Let's say we need to replace the value of for years of experience for an 
*observation, and then re-export the file
replace years=8.93 if name=="Mike Avity"
list
export delimited using "dentists_comma.csv", replace nolabel quote

*Let's look at the file we just exported, and notice that the replace value 
*is not 8.93, but 8.9300003
type "dentists_comma.csv"

*We can fix this format command by setting the total width of the numeric to
*5 spaces width and with 2 decimal points
format years %5.2f
*We can use the datafmt option to export the data in the format specified by Stata
export delimited using "dentists_comma.csv", replace nolabel quote datafmt
type "dentists_comma.csv"

**********
*3.8 Exporting space-separated files
**********
*Don't do this. Use comma-delimited files
*If you are really interested in this, please review pages 65-66

**********
*3.9 Creating Reports
**********
*I liked this addition to the exporting data section.
*A lot of time, senior leadership may need a report, and with export excel
*(or putexcel) we can generate automated reports. The key here is automated,
*where the pipeline from raw data to reports is done completely through a 
*.do file. 

*A lot of times it is a pain to get the data analysis to your write-ups, and
*Export excel and put excel are great tools to make it easy. We'll cover estout 
*to get regression outputs into Word or LaTex a bit later. *I have used 
*putexcel in the past, but we'll cover two ways to fill out Excel reports

*We are going to create a Full-time Part-time Report in Excel
use "dentlab.dta", clear
keep name years fulltime
export excel using "dentrpt1.xlsx", cell(A4) replace

*Notice this is just exporting our data into an excel file without a shell, but
*we do place our data starting on line A4 and we do not export variable names.

*We'll use the shell report called "dentrpt1-skeleton.xlsx", and we'll fill it
*out using Stata. This is just an example, but it can be easily applicable in
*many office settings. It is preferable to fill out the report this way, since
*if there is a mistake, then it is is easy to fix without generating a new 
*report from scratch.

*First we'll use the copy command to copy the Report Shell over our newly 
*created file called "dentrpt1.xlsx"
copy "dentrpt1-skeleton.xlsx" "dentrpt1.xlsx", replace

*Now we will use the "modify" option to modify our report shell to fill out
*the report with data.
export excel "dentrpt1.xlsx", sheet("dentists", modify) cell(A4)

*Notice that there are two sheets in the report shell: "dentists" and "Sheet2"
*We modified the sheet called "dentists" and pasted our data in this sheet
*starting at cell A4.

*We can format our formats, too. We have our report shell in 
*"dentrpt2-skeleton.xlsx". We will do is similar to the first report, but we will
*add the keepcellfmt option.
copy "dentrpt2-skeleton.xlsx" "dentrpt2.xlsx", replace
export excel "dentrpt2.xlsx", sheet("dentists", modify) cell(A4) //keepcellfmt

*Note: this keepcellfmt is unavailable in Stata 14, but you should have it in 
*your newer version.

*We'll do something similar, but we will include averages for years and 
*full-time vs part time.
copy "dentrpt3-skeleton.xlsx" "dentrpt3.xlsx", replace
export excel "dentrpt3.xlsx", sheet("dentists", modify) cell(A6) 

*You have two options for the percentages: 1) add average formula in Excel or 
*2) use put excel. It is easy to add formulas in excel, but what if the number
*of observation changes over time? Then, you would need to modify the Excel 
*sheet. Using put excel you can update the averages without messing with 
*formulas in excel

*It is poor practice to run the summarize command and manually entering
*it into your report. Use local macros and do it dynamically!

*We will set our dentists report to be modified by Stata, and then run the 
*summarize command and take the average stored after the command and put
*it into excel.
putexcel set "dentrpt3.xlsx", sheet("dentists") modify

*After setting the sheet to be modified, we can write expression, returned 
*results, formulas, graphs, scalars, matrices, etc.

*Let's look at what the summarize command stores after being run. 
summarize years
return list
*There are several scalars that are stored, such as number of observations r(N),
*mean r(mean), standard deviation r(sd), etc.
*If we use the detail option, we'll see more scalars

*We can retreive those scalars with local macros, such as `r(mean)'.

summarize years
putexcel B2 = `r(mean)'
summarize fulltime
putexcel B3 = `r(mean)'
*putexcel save //Not in older version

*More on Putexcel
https://blog.stata.com/2017/01/10/creating-excel-tables-with-putexcel-part-1-introduction-and-formatting/

**********************************
*Chapter 4: Cleaning and Checking Data
**********************************
*Good note from Mitchell at the beginning
*Garbage In; Garbage Out

*Before doing analysis, you really need to check your data to look for data
*quality issues.

*******
*4.2 Double data entry
*******
*The duplicates command can be helpful, but it will only find duplicates that
*are exactly the same unless you specify which variables with duplicates list vars
*We'll cover this a bit later.

************
*4.3 Checking individual variables
************
*We start off with looking from problems in individual variables
use wws, clear

*The describe command is a useful command to see an overview of your data
*with variables labels, storage type, and value lables (if any)
describe

*You will noticed that we lack value labels and a data dictionary or what
*each value is coded as

**
*One way tabulation
**
*The tabulation or tab command is very useful to inspect categorical variables.
*Let's look at collgrad, which is a binary for college graduate status
*Let's include the missing option to make sure no observations are missing data
tabulate collgrad, missing

*Let's look at race
tabulate race, missing
*Race should only be coded between 1 and 3, so we have one miscoded observation.
*Let's find the observation's idcode
list idcode race if race==4

**
*Summarize
**
*The summarize or sum command is very useful to inspect continuous variables.
*Let's look at the amount of unemployment insurance in unempins.  The values 
*range between 0 and 300 dollars for unemployed insurance received last week.
summarize unempins

*Let's look at wages
summarize wage
*The data range between 0 and 380,000 dollars in hourly wage last week with a 
*mean of 288.29 dollars and a standard deviation of 9,595 dollars. The max seems
*a bit high. Let's add the detail option to get more information
summarize wage, detail

*Our mean appears to be skewed rightward with some outliers. Our median hourly
*wage is 6.7 dollars per hour and our 99% percentile hourly wage is 38.7 
*38.7 dollars per hour, so a mean of 288.29 dollar/hour is highly skewed. Our
*Kurtosis shows that the max outliers are heavily skewing the results. A 
*normal distributed variable should have a kurtosis of 3, and our kurtosis is 
*1297
*Let's look at the outliers
list idcode wage if wage > 1000

*Let's look at ages, which should range frm 21 to 50 years old. We can use both
*the summarize and tabulate commands. Tabulate can be very useful with 
*continuous variables if the range is not too large.
summarize age
tabulate age
*Let's look at the outliers
list idcode age if age > 50

*******
*4.4 Checking categorical by categorical variables
*******
use "wws.dta", clear

**
*Two-way tabulation
**
*The two-way tabulation through the tabulate command is a very useful way
*to look for data quality problems or to double check binaries created.
*Let's look at variables metro, which is a binary for whether or not the 
*observation lives in a metropolitian areas, and ccity, which is whether or not
*the observation lives in the center of the city.
tabulate metro ccity, missing

*An alternative is to count the number of observations that shouldn't be there
*So we'll count the number of observations not in a metro area but in a city
*center. I personally don't use it, but it has it's uses.
count if metro==0 & ccity==1

*Let's look at married and nevermarriaged. There should be no individuals that
*appear in both married and nevermarried.
tabulate married nevermarried, missing
*There may be observation that have been married, but not currently married.
*There should be no observations that are both married and never married, and
*there are 2
count if married == 1 & nevermarried == 1
list idcode married nevermarried if married == 1 & nevermarried == 1

*Let's look at college graduates and years of school completed.
*We can use tabulate or the table commands. I personally prefer tabulate, since
*we can look for missing
tabulate yrschool collgrad, missing
*Or
table yrschool collgrad
list idcode if yrschool < 16 & collgrad == 1

*******
*4.5 Checking categorical by continuous variables
*******
*It is also helpful to look at continuous variables by different categories.
*Let's look at the binary variable for union, if the observation is a union
*member or not by uniondues.
summarize uniondues, detail

*Let's use the bysort command, which will sort our data by the variable 
*specified.
bysort union: summarize uniondues

*The mean for not in a union is less than 1 dollar with 1,413 observations
*The mean for union is about 15 dollars with 461 observations
*The mean for missing is about 15 dollars with 368 observations
tabulate uniondues if union==0, missing
*We see about 4 observations have union dues, so let's recode them to 0
*It is possible that someone may be not be a union members, but still have
*to pay an agency fee. 

*The recode command can to create a new variable if a person pay union dues
recode uniondues (0=0) (1/max=1), generate(paysdues)
*Now let's compare union members to those who pay union dues
tabulate union paysdues, missing

*Let's list the non-union members paying union dues
*Note: we use the abb(#) option to abbreviate the observation to 20 characters
list idcode union uniondues if union==0 & (uniondues > 0) & !missing(uniondues), abb(20)

*Let's look at another great command for observing categorical and continuous
*variables together: tabstat

*We could use tab with a sum option
tab married, sum(marriedyrs)
*Or, we can use tabstat which gives us more options
tabstat marriedyrs, by(married) statistics(n mean sd min max p25 p50 p75) missing
*No observation that said they were never married reported years of marriage

*Let's look at current years of experience and everworked binary
tabstat currexp, by(everworked) statistics(n mean sd min max) missing

*Let's total years of experience, which is currexp plus prevexp
generate totexp=currexp+prevexp
tabstat totexp, by(everworked) statistics(n mean sd min max) missing
*Everyone with at least one year experience has experience working

*bysort x_cat: summarize x_con
*tab x_cat, sum(x_con)
*tabstat x_con, by(x_cat) statistics(...)


*******
*4.6 Checking continuous by continuous variables
*******
*We will compare two continuous variables to continuous variables
*Let's look at unemployment insuranced received last week if the 
*hours were greater than 30 and hours are not missing.
summarize unempins if hours > 30 & !missing(hours)
*The mean is around 1.3 and our range is between our expected 0 and 287
count if (hours>30) & !missing(hours) & (unempins>0) & !missing(unempins)
*Let's look at the hours count
tabulate hours if (hours>30) & !missing(hours) & (unempins>0) & !missing(unempins)

*Let's look at age and and years married to find any unusual observations
gen agewhenmarried = age - marriedyrs
summarize agewhenmarried 
tabulate agewhenmarried
*Let's look for anyone under 18. Some states allow under 18 marriages, but
*it still is suspicious 
tabulate agewhenmarried if agewhenmarried < 18

*Let's use the same strategy for years of experience deducted from age to 
*find the first age working
generate agewhenstartwork = age - (prevexp + currexp)
tabulate agewhenstartwork if agewhenstartwork < 16
*Some states allow work at the age of 15, but anything below looks suspicious

*We can also look for the number of age of children. We should expect that
*the age of the third child is never older than the second child
table kidage2 kidage3 if numkids==3
*Check the count
count if (kidage3 > kidage2) & (numkids==3) & !missing(kidage3)
count if (kidage2 > kidage1) & (numkids>=2) & !missing(kidage2)

*Now let's check the age of the observation when the first child was born
generate agewhenfirstkid = age - kidage1
tabulate agewhenfirstkid if agewhenfirstkid < 18
*There are some suspicious observations after this tabulation

*Scatter plots can be helpful as well
scatter hours wage if hours > 0 & wage >0 & wage < 1000

*******
*4.7 Correcting errors in data
*******
*Let go ahead and fix some of these errors that we have found. A word of caution
*is that you may need to talk to the data stewards about the best ways to 
*correct the data. You don't want to attempt to fix the measurement error and
*introduce additional problems. Institutional knowledge of the data is very
*helpful before correcting errors.

*Let's fix when race was equal to 4 when there are only 3 categories
list idcode race if race==4
replace race=1 if idcode == 543
tabulate race
*Let's add a note for future users, which is good practice for replication
note race: race changed to 1 (from 4) for idcode 543

*Let's fix college gradudate when there were only 8 years of education
list idcode collgrad if yrschool < 12 & collgrad == 1
replace collgrad = 0 if idcode == 107
tab yrschool collgrad
note collgrad: collgrad changed to 0 (from 1) for idcode 107

*Let's fix age which where the digits were switched.
list idcode age if age > 50
replace age = 38 if idcode == 51
replace age = 45 if idcode == 80
tab age
note age: the value of 83 was corrected to 38 for idcode 51
note age: the value of 54 was corrected to 45 for idcode 80

*Let's look at our notes
note

*******
*4.8 Identifying duplicates
*******
*We need to be careful with duplicate observations. When working with panel data
*we will want multiple observations of the same cross-sectional unit, but there
*should be multiple observations for different time units and not the same time
*unit.

use "dentists_dups.dta", clear

*We can start with our duplicates list command to find rows that are completely
*the same. This command will show all the duplicates.
*Note: for duplicate records to be found, all data needs to be the same.
duplicates list

*We'll have a more condensed version with duplicates examples. It will give an
*example of the duplicate records for each group of duplicate records.
duplicates examples 

*We can find the a consice list of duplicate records with duplicates report.
duplicates report

*The duplicates tag command can return the number of duplicates for each group
*of duplicates (note the separator option puts a line in the table after # rows.
duplicates tag, generate(dup)
list, separator(2)

*Let's sort our data for better legibility, and then we will add lines in our
*output table whenever there is a new group.
sort name years
list, sepby(name years)
*Notice! There are two observations for Mary Smith, but one has 3 years of 
*experience and the other one has 27 years, so it does not appear as a duplicate.

*If there were too many variables, which could use our data browser.
browse if dup > 0

*We will want to drop our duplicates, but not the first observation. The 
*duplicates drop command will drop the duplicate records but still keep one
*observation of the duplicate group.
duplicates drop

*Let's use a new dataset that is a bit more practical
use "wws.dta", replace

*Let's check for duplicate idcodes with the isid command. If there is a 
*duplicate idcode, the command will return an error
isid idcode
*Or just use duplicates list for the variable of interest
duplicates list idcode

*There are no duplicate idcodes, so we should expect that duplicates list will
*not return any duplicates, since every single values needs to be the same for
*there to be a dupicate record
duplicates list 

*Let's use a dataset that does have duplicates
use "wws_dups.dta", clear

*Let's check for duplicate idcodes
*isid idcode
*Or 
duplicates list idcode, sepby(idcode)
*I prefer duplicates list var1, since an error will break the do file

*Let's generate our dup variable for identifying the number of duplicates per 
*group of duplicates.
duplicates tag idcode, generate(iddup)

*Let's generate a different duplicate variable to find complete duplicate 
*records. Notice that we do not specify a variable after tag.
duplicates tag, generate(alldup)

*Let's list the data
list idcode age race yrschool occupation wage if iddup==1 & alldup==0
*It seems that idcode 3905 is a different person with a possible incorrect
*idcode. Let's fix that.
replace idcode=5160 if idcode==3905 & age==41
*Let's see if it is resolved, and it is.
list idcode age race yrschool occupation wage if iddup==1 & alldup==0

*Let's look observation that are complete duplicates
duplicates report
list idcode age race yrschool occupation wage if iddup==1 & alldup==1

*We need to keep 1 observation of the duplicates
duplicates drop
duplicates report

************************
*Practice
************************

*Let's work the Census CPS 
*Pull the Census CPS.
* a) You can download the file and import it, or
* b) You can use Stata to pull the file.

*Let's save a copy of the csv file in Stata

*Let's grab the data dictionary. Hint search: "Census CPS 2023 data dictionary"

*Let's check our data.
* a) What variable contains our laborforce status?
* b) What variable contains our weekly earnings?
* c) Does everyone employed have weekly earnings? Hint: Try summarize
* d) What flag with our weekly earning that provides information about available data?
* e) Try tabstat with the flag and weekly earnings. What do you find?
* f) Try tabstat with statistics(n mean sd p25 p50 p75)
* g) What are our identifier variable(s)? How many did you find?
* h) Are there any duplicate records?
