*Convert NLS Data
*Samuel Rowe
*ECON 645
*August 16, 2023

clear
set more off

*Set Working Directory
cd "/Users/Sam/Desktop/Econ 645/Student Presentations/Panel Data/nlsym_august_15_pull/"
import delimited using "nlsym_august_15_pull.csv"

*Variables names to upper
rename *, upper

label define vlR0002200 0 "0 TO 13"  14 "14"  15 "15"  16 "16"  17 "17"  18 "18"  19 "19"  20 "20"  21 "21"  22 "22"  23 "23"  24 "24"  25 "25"  26 "26"  27 "27"  28 "28"  29 "29 TO 99" 
label values R0002200 vlR0002200

label define vlR0303051 1 "LIVES IN SOUTH"  0 "LIVES IN NON-SOUTH" 
label values R0303051 vlR0303051

label define vlR0305800 1 "MARRIED, SPOUSE PRESENT"  2 "MARRIED, SPOUSE ABSENT"  3 "WIDOWED"  4 "DIVORCED"  5 "SEPARATED"  6 "NEVER MARRIED" 
label values R0305800 vlR0305800

label define vlR0319200 0 "0 TO 59: 1959 OR EARLIER"  60 "60: 1960"  61 "61: 1961"  62 "62: 1962"  63 "63: 1963"  64 "64: 1964"  65 "65: 1965"  66 "66: 1966"  67 "67: 1967"  68 "68: 1968"  69 "69: 1969"  70 "70: 1970"  71 "71: 1971"  72 "72: 1972"  73 "73: 1973"  74 "74: 1974"  75 "75: 1975"  76 "76: 1976" 
label values R0319200 vlR0319200

label define vlR0319400 -999999 "-999999 TO -6"  0 "0"  1 "1 TO 999"  1000 "1000 TO 1999"  2000 "2000 TO 2999"  3000 "3000 TO 3999"  4000 "4000 TO 4999"  5000 "5000 TO 5999"  6000 "6000 TO 6999"  7000 "7000 TO 7999"  8000 "8000 TO 8999"  9000 "9000 TO 9999"  10000 "10000 TO 14999"  15000 "15000 TO 19999"  20000 "20000 TO 24999"  25000 "25000 TO 49999"  50000 "50000 TO 999999" 
label values R0319400 vlR0319400

label define vlR0320400 1 "YES"  0 "NO" 
label values R0320400 vlR0320400

label define vlR0366800 0 "0 TO 8: ACTUAL NUMBER"  9 "9: 9 OR MORE"  99 "99: RESPONDENT LIVES WITH PARENTS" 
label values R0366800 vlR0366800

label define vlR0383200 0 "NONE"  1 "FIRST GRADE"  2 "SECOND GRADE"  3 "THIRD GRADE"  4 "FOURTH GRADE"  5 "FIFTH GRADE"  6 "SIXTH GRADE"  7 "SEVENTH GRADE"  8 "EIGHTH GRADE"  9 "NINTH GRADE"  10 "TENTH GRADE"  11 "ELEVENTH GRADE"  12 "TWELFTH GRADE"  13 "FIRST YEAR COLLEGE"  14 "SECOND YEAR COLLEGE"  15 "THIRD YEAR COLLEGE"  16 "FOURTH YEAR COLLEGE"  17 "FIFTH YEAR COLLEGE"  18 "SIXTH+ YEARS COLLEGE" 
label values R0383200 vlR0383200

label define vlR0437510 1 "INITIAL YEAR(1966)"  2 "MOVER"  3 "NONMOVER"  4 "NONINTERVIEW" 
label values R0437510 vlR0437510

label define vlR0437511 1 "LIVES IN SOUTH"  0 "LIVES IN NON-SOUTH" 
label values R0437511 vlR0437511

label define vlR0453000 0 "0 TO 59: 1959 OR EARLIER"  60 "60: 1960"  61 "61: 1961"  62 "62: 1962"  63 "63: 1963"  64 "64: 1964"  65 "65: 1965"  66 "66: 1966"  67 "67: 1967"  68 "68: 1968"  69 "69: 1969"  70 "70: 1970"  71 "71: 1971"  72 "72: 1972"  73 "73: 1973"  74 "74: 1974"  75 "75: 1975"  76 "76: 1976" 
label values R0453000 vlR0453000

label define vlR0454800 1 "HOURLY"  2 "DAILY"  3 "WEEKLY"  4 "BIWEEKLY"  5 "MONTHLY"  6 "YEARLY"  7 "OTHER" 
label values R0454800 vlR0454800

label define vlR0456000 1 "YES"  0 "NO" 
label values R0456000 vlR0456000

label define vlR0507300 1 "MARRIED, SPOUSE PRESENT"  2 "MARRIED, SPOUSE ABSENT"  3 "WIDOWED"  4 "DIVORCED"  5 "SEPARATED"  6 "NEVER MARRIED" 
label values R0507300 vlR0507300

label define vlR0534800 0 "0 TO 59: 1959 OR EARLIER"  60 "60: 1960"  61 "61: 1961"  62 "62: 1962"  63 "63: 1963"  64 "64: 1964"  65 "65: 1965"  66 "66: 1966"  67 "67: 1967"  68 "68: 1968"  69 "69: 1969"  70 "70: 1970"  71 "71: 1971"  72 "72: 1972"  73 "73: 1973"  74 "74: 1974"  75 "75: 1975"  76 "76: 1976" 
label values R0534800 vlR0534800

label define vlR0535900 0 "0 TO 59: 1959 OR EARLIER"  60 "60: 1960"  61 "61: 1961"  62 "62: 1962"  63 "63: 1963"  64 "64: 1964"  65 "65: 1965"  66 "66: 1966"  67 "67: 1967"  68 "68: 1968"  69 "69: 1969"  70 "70: 1970"  71 "71: 1971"  72 "72: 1972"  73 "73: 1973"  74 "74: 1974"  75 "75: 1975"  76 "76: 1976" 
label values R0535900 vlR0535900

label define vlR0536400 0 "0 TO 8: ACTUAL NUMBER"  9 "9: 9 OR MORE"  99 "99: RESPONDENT LIVES WITH PARENTS" 
label values R0536400 vlR0536400

label define vlR0543940 0 "NONE"  1 "FIRST GRADE"  2 "SECOND GRADE"  3 "THIRD GRADE"  4 "FOURTH GRADE"  5 "FIFTH GRADE"  6 "SIXTH GRADE"  7 "SEVENTH GRADE"  8 "EIGHTH GRADE"  9 "NINTH GRADE"  10 "TENTH GRADE"  11 "ELEVENTH GRADE"  12 "TWELFTH GRADE"  13 "FIRST YEAR COLLEGE"  14 "SECOND YEAR COLLEGE"  15 "THIRD YEAR COLLEGE"  16 "FOURTH YEAR COLLEGE"  17 "FIFTH YEAR COLLEGE"  18 "SIXTH+ YEARS COLLEGE" 
label values R0543940 vlR0543940

label define vlR0547525 1 "CENTRAL CITY OF THE SMSA"  2 "BALANCE (NOT CENTRAL CITY) OF THE SMSA"  3 "NOT IN SMSA" 
label values R0547525 vlR0547525

label define vlR0547530 1 "SOUTH"  0 "NON-SOUTH" 
label values R0547530 vlR0547530

label define vlR0548100 1 "MARRIED, SPOUSE PRESENT"  2 "MARRIED, SPOUSE ABSENT"  3 "WIDOWED"  4 "DIVORCED"  5 "SEPARATED"  6 "NEVER MARRIED" 
label values R0548100 vlR0548100

label define vlR0549800 0 "NONE"  1 "FIRST GRADE"  2 "SECOND GRADE"  3 "THIRD GRADE"  4 "FOURTH GRADE"  5 "FIFTH GRADE"  6 "SIXTH GRADE"  7 "SEVENTH GRADE"  8 "EIGHTH GRADE"  9 "NINTH GRADE"  10 "TENTH GRADE"  11 "ELEVENTH GRADE"  12 "TWELFTH GRADE"  13 "FIRST YEAR COLLEGE"  14 "SECOND YEAR COLLEGE"  15 "THIRD YEAR COLLEGE"  16 "FOURTH YEAR COLLEGE"  17 "FIFTH YEAR COLLEGE"  18 "SIXTH+ YEARS COLLEGE" 
label values R0549800 vlR0549800

label define vlR0552700 51 "51 TO 65: 1951-1965"  66 "66: 1966"  67 "67: 1967"  68 "68: 1968"  69 "69: 1969"  70 "70: 1970"  71 "71: 1971"  72 "72: 1972"  73 "73: 1973"  74 "74: 1974"  75 "75: 1975"  76 "76: 1976"  77 "77: 1977"  78 "78: 1978"  79 "79: 1979"  80 "80: 1980"  81 "81: 1981"  82 "82: 1982" 
label values R0552700 vlR0552700

label define vlR0553100 -999999 "-999999 TO -6"  0 "0"  1 "1 TO 99"  100 "100 TO 199"  200 "200 TO 299"  300 "300 TO 399"  400 "400 TO 499"  500 "500 TO 599"  600 "600 TO 699"  700 "700 TO 799"  800 "800 TO 899"  900 "900 TO 999"  1000 "1000 TO 999997" 
label values R0553100 vlR0553100

label define vlR0555000 1 "YES"  0 "NO" 
label values R0555000 vlR0555000

label define vlR0562400 51 "51 TO 65: 1951-1965"  66 "66: 1966"  67 "67: 1967"  68 "68: 1968"  69 "69: 1969"  70 "70: 1970"  71 "71: 1971"  72 "72: 1972"  73 "73: 1973"  74 "74: 1974"  75 "75: 1975"  76 "76: 1976"  77 "77: 1977"  78 "78: 1978"  79 "79: 1979"  80 "80: 1980"  81 "81: 1981"  82 "82: 1982" 
label values R0562400 vlR0562400

label define vlR0562800 51 "51 TO 65: 1951-1965"  66 "66: 1966"  67 "67: 1967"  68 "68: 1968"  69 "69: 1969"  70 "70: 1970"  71 "71: 1971"  72 "72: 1972"  73 "73: 1973"  74 "74: 1974"  75 "75: 1975"  76 "76: 1976"  77 "77: 1977"  78 "78: 1978"  79 "79: 1979"  80 "80: 1980"  81 "81: 1981"  82 "82: 1982" 
label values R0562800 vlR0562800

label define vlR0563200 0 "0 TO 8: ACTUAL NUMBER"  9 "9: 9 OR MORE"  99 "99: RESPONDENT LIVES WITH PARENTS" 
label values R0563200 vlR0563200

label define vlR0596800 1 "MARRIED, SPOUSE PRESENT"  2 "MARRIED, SPOUSE ABSENT"  3 "WIDOWED"  4 "DIVORCED"  5 "SEPARATED"  6 "NEVER MARRIED" 
label values R0596800 vlR0596800

label define vlR0601000 51 "51 TO 65: 1951-1965"  66 "66: 1966"  67 "67: 1967"  68 "68: 1968"  69 "69: 1969"  70 "70: 1970"  71 "71: 1971"  72 "72: 1972"  73 "73: 1973"  74 "74: 1974"  75 "75: 1975"  76 "76: 1976"  77 "77: 1977"  78 "78: 1978"  79 "79: 1979"  80 "80: 1980"  81 "81: 1981"  82 "82: 1982" 
label values R0601000 vlR0601000

label define vlR0601500 -999999 "-999999 TO -6"  0 "0"  1 "1 TO 99"  100 "100 TO 199"  200 "200 TO 299"  300 "300 TO 399"  400 "400 TO 499"  500 "500 TO 599"  600 "600 TO 699"  700 "700 TO 799"  800 "800 TO 899"  900 "900 TO 999"  1000 "1000 TO 999997" 
label values R0601500 vlR0601500

label define vlR0602100 1 "YES"  0 "NO" 
label values R0602100 vlR0602100

label define vlR0610200 51 "51 TO 65: 1951-1965"  66 "66: 1966"  67 "67: 1967"  68 "68: 1968"  69 "69: 1969"  70 "70: 1970"  71 "71: 1971"  72 "72: 1972"  73 "73: 1973"  74 "74: 1974"  75 "75: 1975"  76 "76: 1976"  77 "77: 1977"  78 "78: 1978"  79 "79: 1979"  80 "80: 1980"  81 "81: 1981"  82 "82: 1982" 
label values R0610200 vlR0610200

label define vlR0610600 51 "51 TO 65: 1951-1965"  66 "66: 1966"  67 "67: 1967"  68 "68: 1968"  69 "69: 1969"  70 "70: 1970"  71 "71: 1971"  72 "72: 1972"  73 "73: 1973"  74 "74: 1974"  75 "75: 1975"  76 "76: 1976"  77 "77: 1977"  78 "78: 1978"  79 "79: 1979"  80 "80: 1980"  81 "81: 1981"  82 "82: 1982" 
label values R0610600 vlR0610600

label define vlR0611000 0 "0 TO 8: ACTUAL NUMBER"  9 "9: 9 OR MORE"  99 "99: RESPONDENT LIVES WITH PARENTS" 
label values R0611000 vlR0611000

label define vlR0638600 0 "NONE"  1 "FIRST GRADE"  2 "SECOND GRADE"  3 "THIRD GRADE"  4 "FOURTH GRADE"  5 "FIFTH GRADE"  6 "SIXTH GRADE"  7 "SEVENTH GRADE"  8 "EIGHTH GRADE"  9 "NINTH GRADE"  10 "TENTH GRADE"  11 "ELEVENTH GRADE"  12 "TWELFTH GRADE"  13 "FIRST YEAR COLLEGE"  14 "SECOND YEAR COLLEGE"  15 "THIRD YEAR COLLEGE"  16 "FOURTH YEAR COLLEGE"  17 "FIFTH YEAR COLLEGE"  18 "SIXTH+ YEARS COLLEGE" 
label values R0638600 vlR0638600

label define vlR0640300 1 "CENTRAL CITY OF THE SMSA"  2 "BALANCE (NOT CENTRAL CITY) OF THE SMSA"  3 "NOT IN SMSA" 
label values R0640300 vlR0640300

label define vlR0640400 1 "SOUTH"  0 "NON-SOUTH" 
label values R0640400 vlR0640400

label define vlR0692000 -999999 "-999999 TO -6"  0 "0"  1 "1 TO 99"  100 "100 TO 199"  200 "200 TO 299"  300 "300 TO 399"  400 "400 TO 499"  500 "500 TO 599"  600 "600 TO 699"  700 "700 TO 799"  800 "800 TO 899"  900 "900 TO 999"  1000 "1000 TO 999997" 
label values R0692000 vlR0692000

label define vlR0693400 1 "YES"  0 "NO" 
label values R0693400 vlR0693400

label define vlR0767600 0 "0 TO 8: ACTUAL NUMBER"  9 "9: 9 OR MORE"  99 "99: RESPONDENT LIVES WITH PARENTS" 
label values R0767600 vlR0767600

label variable  R0000100 "ID_CODE, 66"
label variable  R0002200 "AGE, 66"
label variable  R0303051 "REGION OF RES IN 71 REV"
label variable  R0305800 "MAR_STAT, 71"
label variable  R0319200 "YR STRT WRK CURR_JOB_71"
label variable  R0319400 "ROP CURR_JOB_71"
label variable  R0320400 "MEM UNION/EMP_ASSN CURR_JOB_71?"
label variable  R0366800 "#DPNDNTS EXCLUDING WIF, 71"
label variable  R0383200 "HGC AS OF 71 REV"
label variable  R0437510 "RES STAT IN 76 REV"
label variable  R0437511 "REGION OF RES IN 76 REV"
label variable  R0453000 "YR STRT WRK CURR_JOB_76"
label variable  R0454800 "TM UN ROP CURR_JOB_76"
label variable  R0456000 "MEM UNION/EMP_ASSN CURR_JOB_76?"
label variable  R0507300 "MAR_STAT, 76"
label variable  R0534800 "MAR_STAT,BKGRND-YR 1ST MRG, 76"
label variable  R0535900 "MAR_STAT,BKGRND 76-YR DIVORCED"
label variable  R0536400 "#DPNDNTS EXCLUDING WIF, 76"
label variable  R0543940 "HGC AS OF 76 REV"
label variable  R0547525 "CUR RES IN SMSA, 78? REV"
label variable  R0547530 "REGION OF RES IN 78 REV"
label variable  R0548100 "MAR_STAT, 78"
label variable  R0549800 "HGC BTW 76 AND 78"
label variable  R0552700 "YR STRT WRK CUR/L_JOB_78"
label variable  R0553100 "ROP CUR/L_JOB_78"
label variable  R0555000 "MEM UNION/EMP_ASSN CURR_JOB_78?"
label variable  R0562400 "MAR_STAT,BKGRND 78-YR PRSNT MRG"
label variable  R0562800 "MAR_STAT,BKGRND 78-YR DIVORCED"
label variable  R0563200 "#DPNDNTS EXCLUDING WIF, 78"
label variable  R0596800 "MAR_STAT, 80"
label variable  R0601000 "YR STRT WRK CUR/L_JOB_80"
label variable  R0601500 "ROP CUR/L_JOB_80"
label variable  R0602100 "MEM UNION/EMP_ASSN CUR/L_JOB_80?"
label variable  R0610200 "MAR_STAT,BKGRND 80-YR PRSNT MRG"
label variable  R0610600 "MAR_STAT,BKGRND 80-YR DIVORCED"
label variable  R0611000 "#DPNDNTS EXCLUDING WIF, 80"
label variable  R0638600 "HGC BTW 78 AND 80"
label variable  R0640300 "SMSA STAT IN 80 REV"
label variable  R0640400 "REGION OF RES IN 80 REV"
label variable  R0692000 "ROP CUR/L_JOB_81"
label variable  R0693400 "MEM UNION/EMP_ASSN CUR/L_JOB_81?"
label variable  R0767600 "#DPNDNTS EXCLUDING WIF/P, 81"

*Marriage Status
order R0507300 R0548100 R0596800, after(R0305800)
rename (R0305800 R0507300 R0548100 R0596800) (mar_stat71 mar_stat76 mar_stat78 mar_stat80)
*Region
order R0437511 R0547530 R0640400, after(R0303051)
rename (R0303051 R0437511 R0547530 R0640400) (region71 region76 region78 region80)
*Union
order R0456000 R0555000 R0602100 R0693400, after(R0320400)
rename (R0320400 R0456000 R0555000 R0602100 R0693400) (union71 union76 union78 union80 union81)
*Dependents
order R0536400 R0563200 R0611000 R0767600, after(R0366800)
rename (R0366800 R0536400 R0563200 R0611000 R0767600) (depend71 depend76 depend78 depend80 depend81)
*SMSA
order R0640300, after(R0547525)
rename (R0547525 R0640300) (smsa78 smsa80)
*Rate of Pay
order R0454800 R0553100 R0601500 R0692000, after(R0319400)
rename (R0319400 R0454800 R0553100 R0601500 R0692000) (wage71 wage76 wage78 wage80 wage81)

*Highest Grade completed
order R0543940 R0549800 R0638600, after (R0383200)
rename (R0383200 R0543940 R0549800 R0638600) (edu71 edu76 edu78 edu80)
*Year start work
order R0453000 R0552700 R0601000, after(R0319200)
rename (R0319200 R0453000 R0552700 R0601000) (startwrk71 startwrk76 startwrk78 startwrk80)
*Divorce
order R0562800 R0610600, after(R0535900)
rename (R0535900 R0562800 R0610600) (divorceyr76 divorceyr78 divorceyr80)

*Marriage Background
order R0562400 R0610200, after(R0534800)
rename (R0534800 R0562400 R0610200) (marbkg76 marbkg78 marbkg80)

*Panel
rename (R0000100 R0002200 R0437510) (id age66 status76)

*Age
gen age71 = age66+5
gen age76 = age66+10
gen age78 = age66+12
gen age80 = age66+14

*Merge
merge 1:1 id using "nlsym_wages.dta" 

gen race71=race66
gen race76=race66
gen race78=race66
gen race80=race66

drop _merge
*Reshape
reshape long region mar_stat race startwrk wage income empstat union depend edu age marbkg divorceyr smsa, i(id) j(year)

*Delete 1981
drop if year == 81
drop if year == 66
*Fix problem of wage
drop wage
rename income wage

*Fix year
replace year = year+1900
tab year

*Set Panel
xtset id year

*Keep only if education doesn't change in 1976
bysort id: gen educheck = 1 if edu[3] == -4 & edu[4]==-4 & edu[1] > 0 & edu[2] > 0
bysort id: replace educheck = 1 if edu[3] == -5 & edu[4]==-5 & edu[1] > 0 & edu[2] > 0
bysort id: replace educheck = 1 if edu[3] == -5 & edu[4]==-5 & edu[1] > 0 & (edu[2] == -4 | edu[2] == -5)
egen educheck2 = sum(educheck)
*Wage check 
bysort id: gen wagecheck = 1 if wage[1] >= 0 & wage[2] >= 0 & wage[3] >=0 & wage[4] >= 0 

*Keep only observation with wages
drop if wagecheck != 1
*Authors only look at White males
keep if race==1

*Fix education that doesn't change between 76-78 and 78-80

replace edu=. if edu==-4 & year==1976
replace edu=. if edu==-5 & year==1976
replace edu=. if edu==-4 & year==1978
replace edu=. if edu==-4 & year==1980
replace edu=. if edu==-5 & year==1978
replace edu=. if edu==-5 & year==1980

replace edu=edu[_n-1] if missing(edu)

replace edu = . if edu == -4 | edu == -5

tab edu year

*Wage
*replace wage = 1 if wage == -4 | wage == -5 | wage == -1
gen lnwage = ln(wage)
tabstat lnwage, by(year)

*Experience
gen exp = age - edu - 6
replace exp = age - 16
*replace exp = 0 if exp < 0
histogram exp

*region
tab region
replace region = . if region == -5

*Marriage Status
tab mar_stat
gen married = .
replace married = 1 if mar_stat==1 | mar_stat==2
replace married = 0 if mar_stat >= 3 & mar_stat <= 6
gen divorced = .
replace divorced = 1 if mar_stat == 4 
replace divorced = 0 if (mar_stat >= 1 & mar_stat <= 3) | (mar_stat >= 5 & mar_stat <= 6)
tab married divorced
tabstat lnwage, by(married)

*Union
replace union = 0 if union == -4
tab union

*Dependents 
replace depend = 0 if depend == -1 | depend == -4 | depend == -5

*Regression
reg lnwage edu c.exp##c.exp i.region i.union i.married i.divorced depend i.year 
reg lnwage edu c.exp##c.exp i.region i.union i.married##c.depend i.divorced##c.depend i. year

xtreg lnwage edu c.exp##c.exp i.region i.union i.year c.depend i.married i.divorced, fe robust
xtreg lnwage edu c.exp##c.exp i.region i.union i.year c.depend##i.married c.depend##i.divorced, fe robust


/* Crosswalk for Reference number & Question name
 * Uncomment and edit this RENAME statement to rename variables for ease of use.
 * This command does not guarantee uniqueness
 */
  /* *start* */
/*
  rename R0000100 R0000100_1966 
  rename R0002200 R0002200_1966 
  rename R0303051 R0303051_1971 
  rename R0305800 R0305800_1971 
  rename R0319200 R0319200_1971 
  rename R0319400 R0319400_1971 
  rename R0320400 R0320400_1971 
  rename R0366800 R0366800_1971 
  rename R0383200 R0383200_1971 
  rename R0437510 R0437510_1976 
  rename R0437511 R0437511_1976 
  rename R0453000 R0453000_1976 
  rename R0454800 R0454800_1976 
  rename R0456000 R0456000_1976 
  rename R0507300 R0507300_1976 
  rename R0534800 R0534800_1976 
  rename R0535900 R0535900_1976 
  rename R0536400 R0536400_1976 
  rename R0543940 R0543940_1976 
  rename R0547525 R0547525_1978 
  rename R0547530 R0547530_1978 
  rename R0548100 R0548100_1978 
  rename R0549800 R0549800_1978 
  rename R0552700 R0552700_1978 
  rename R0553100 R0553100_1978 
  rename R0555000 R0555000_1978 
  rename R0562400 R0562400_1978 
  rename R0562800 R0562800_1978 
  rename R0563200 R0563200_1978 
  rename R0596800 R0596800_1980 
  rename R0601000 R0601000_1980 
  rename R0601500 R0601500_1980 
  rename R0602100 R0602100_1980 
  rename R0610200 R0610200_1980 
  rename R0610600 R0610600_1980 
  rename R0611000 R0611000_1980 
  rename R0638600 R0638600_1980 
  rename R0640300 R0640300_1980 
  rename R0640400 R0640400_1980 
  rename R0692000 R0692000_1981 
  rename R0693400 R0693400_1981 
  rename R0767600 R0767600_1981 

*/
  /* *end* */  
/* To convert variable names to lower case use the TOLOWER command 
 *      (type findit tolower and follow the links to install).
 * TOLOWER VARLIST will change listed variables to lower case; 
 *  TOLOWER without a specified variable list will convert all variables in the dataset to lower case
 */
/* tolower */
