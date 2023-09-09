clear
set more off

*Set Working Directory
cd "/Users/Sam/Desktop/Econ 645/Student Presentations/Panel Data/nlsym_august_15_pull/nlsym_add_pull_8_18_23"
import delimited using "nlsym_add_pull_8_18_23.csv"

*Variables names to upper
rename *, upper

label variables R0002300 "Race 1966"
label variables R0385200 "Employment Status 71"
label variables R0543950 "Employment Status 76"
label variables R0682100 "Employment Status 81"

label define vlR0002300 1 "WHITE"  2 "BLACK"  3 "OTHER" 
label values R0002300 vlR0002300

label define vlR0385200 1 "IN LABOR FORCE: WORKING"  2 "IN LABOR FORCE: WITH JOB, NOT AT WORK"  3 "IN LABOR FORCE: UNEMPLOYED"  4 "OUT OF LABOR FORCE: GOING TO SCHOOL"  5 "OUT OF LABOR FORCE: CODE 5 IS NOT USED"  6 "OUT OF LABOR FORCE: UNABLE TO WORK"  7 "OUT OF LABOR FORCE: CODE 7 IS NOT USED"  8 "OUT OF LABOR FORCE: OTHER"  0 "OUT OF LABOR FORCE: NEVER WORKED" 
label values R0385200 vlR0385200

label define vlR0543950 1 "IN LABOR FORCE: WORKING"  2 "IN LABOR FORCE: WITH JOB, NOT AT WORK"  3 "IN LABOR FORCE: UNEMPLOYED"  4 "OUT OF LABOR FORCE: GOING TO SCHOOL"  5 "OUT OF LABOR FORCE: CODE 5 IS NOT USED"  6 "OUT OF LABOR FORCE: UNABLE TO WORK"  7 "OUT OF LABOR FORCE: CODE 7 IS NOT USED"  8 "OUT OF LABOR FORCE: OTHER"  0 "OUT OF LABOR FORCE: NEVER WORKED" 
label values R0543950 vlR0543950

label define vlR0682100 1 "IN LABOR FORCE: WORKING"  2 "IN LABOR FORCE: WITH JOB, NOT AT WORK"  3 "IN LABOR FORCE: UNEMPLOYED"  4 "OUT OF LABOR FORCE: GOING TO SCHOOL"  5 "OUT OF LABOR FORCE: CODE 5 IS NOT USED"  6 "OUT OF LABOR FORCE: UNABLE TO WORK"  7 "OUT OF LABOR FORCE: CODE 7 IS NOT USED"  8 "OUT OF LABOR FORCE: OTHER"  0 "OUT OF LABOR FORCE: NEVER WORKED" 
label values R0682100 vlR0682100

rename R0000100 id
rename R0002300 race66
rename (R0385200 R0543950 R0682100) (empstat71 empstat76 empstat81)

save "nlsym_add.dta", replace

/* Crosswalk for Reference number & Question name
 * Uncomment and edit this RENAME statement to rename variables for ease of use.
 * This command does not guarantee uniqueness
 */
  /* *start* */
/*
  rename R0000100 R0000100_1966 
  rename R0002300 R0002300_1966 
  rename R0385200 R0385200_1971 
  rename R0543950 R0543950_1976 
  rename R0682100 R0682100_1981 

*/
  /* *end* */  
/* To convert variable names to lower case use the TOLOWER command 
 *      (type findit tolower and follow the links to install).
 * TOLOWER VARLIST will change listed variables to lower case; 
 *  TOLOWER without a specified variable list will convert all variables in the dataset to lower case
 */
/* tolower */
