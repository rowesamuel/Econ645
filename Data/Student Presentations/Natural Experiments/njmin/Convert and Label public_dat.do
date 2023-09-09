*Convert Card Data
*Samuel Rowe
*Econ 645
*August 15, 2023

clear
set more off

*Set Workding Directory
cd "/Users/Sam/Desktop/Econ 645/Data/njmin"

*Use infix to import public.dat
#delimit;

infix 
SHEET           1-3     
CHAIN           5-5     
CO_OWNED        7-7     
STATE           9-9                        
SOUTHJ         11-11     
CENTRALJ       13-13 
NORTHJ         15-15
PA1            17-17
PA2            19-19
SHORE          21-21
NCALLS         23-24 
EMPFT          26-30
EMPPT          32-36
NMGRS          38-42
WAGE_ST        44-48
INCTIME        50-54
FIRSTINC       56-60
BONUS          62-62
PCTAFF         64-68
MEALS          70-70
OPEN           72-76
HRSOPEN        78-82
PSODA          84-88
PFRY           90-94
PENTREE        96-100
NREGS         102-103
NREGS11       105-106
TYPE2         108-108
STATUS2       110-110
DATE2         112-117
NCALLS2       119-120
EMPFT2        122-126
EMPPT2        128-132
NMGRS2        134-138
WAGE_ST2      140-144
INCTIME2      146-150
FIRSTIN2      152-156
SPECIAL2      158-158
MEALS2        160-160
OPEN2R        162-166
HRSOPEN2      168-172 
PSODA2        174-178
PFRY2         180-184
PENTREE2      186-190
NREGS2        192-193
NREGS112      195-196

using "public.dat", clear
;
#delimit cr

*Label the data
label variable SHEET "sheet number (unique store id)"         
label variable CHAIN "chain 1=bk; 2=kfc; 3=roys; 4=wendys"       
label variable CO_OWNED "1 if company owned"        
label variable STATE "1 if NJ, 0 if Pa"      
label variable SOUTHJ "1 if in southern NJ"          
label variable CENTRALJ "1 if in central NJ"    
label variable NORTHJ "1 if in northern NJ"
label variable PA1 "1 if in PA, northeast suburbs of Phila"
label variable PA2 "1 if in PA, Easton etc"          
label variable SHORE "1 if on NJ shore"        
label variable NCALLS "number of call-backs*"      
label variable EMPFT "# full-time employees"       
label variable EMPPT "# part-time employees"         
label variable NMGRS "# managers/ass't managers"     
label variable WAGE_ST "starting wage ($/hr)"     
label variable INCTIME "months to usual first raise"     
label variable FIRSTINC "usual amount of first raise ($/hr)"      
label variable BONUS "1 if cash bounty for new workers"
label variable PCTAFF "% employees affected by new minimum"
label variable MEALS "free/reduced price code (See below)"
label variable OPEN "hour of opening"
label variable HRSOPEN "number hrs open per day"
label variable PSODA "price of medium soda, including tax"
label variable PFRY "price of small fries, including tax"        
label variable PENTREE "price of entree, including tax"
label variable NREGS "number of cash registers in store"
label variable NREGS11 "number of registers open at 11:00 am"
label variable TYPE2 "type 2nd interview 1=phone; 2=personal"
label variable STATUS2 "status of second interview: see below"
label variable DATE2 "date of second interview MMDDYY format"   
label variable NCALLS2 "number of call-backs*"
label variable EMPFT2 "# full-time employees"
label variable EMPPT2 "# part-time employees"
label variable NMGRS2 "# managers/ass't managers"
label variable WAGE_ST2 "starting wage ($/hr)"
label variable INCTIME2 "months to usual first raise"
label variable FIRSTIN2 "usual amount of first raise ($/hr)"
label variable SPECIAL2 "1 if special program for new workers"
label variable MEALS2 "free/reduced price code"
label variable OPEN2R "hour of opening"    
label variable HRSOPEN2 "number hrs open per day"
label variable PSODA2 "price of medium soda, including tax"   
label variable PFRY2 "price of small fries, including tax"
label variable PENTREE2 "price of entree, including tax"
label variable NREGS2 "number of cash registers in store"
label variable NREGS112 "number of registers open at 11:00 am"

*Add variable labels
label define chain1 1 "BK" 2 "KFC" 3 "Roys" 4 "Wendys"
label values CHAIN chain1

label define coowned1 0 "Not Company Owned" 1 "Company Owned"
label values CO_OWNED coowned1

label define state1 0 "PA" 1 "NJ"
label values STATE state1

label define southj1 0 "Not Southern NJ" 1 "Southern NJ"
label values SOUTHJ southj1

label define centralj1 0 "Not Central NJ" 1 "Central NJ"
label values CENTRALJ centralj1

label define northj1 0 "Not Northern NJ" 1 "Northern NJ"
label values NORTHJ northj1

label define pa11 0 "Not PA northeast Philly Suburbs" 1 "PA northest Philly Suburbs"
label values PA1 pa11

label define pa21 0 "Not PA Easton, etc." 1 "PA Easton, etc."
label value PA2 pa21

label define shore1 0 "Not NJ Shore" 1 "NJ Shore"
label values SHORE shore1

label define bonus1 0 "No cash bonus for new emps" 1 "Cash bonus for new emps"
label values BONUS bonus1

label define meals1 0 "None" 1 "Free Meals" 2 "Reduced Price Meals" ///
                    3 "Both Free and Reduced Price Meals"
label values MEALS meals1
label values MEALS2 meals1

label define type21 0 "Refused second interview" ///
                    1 "Answered 2nd interview" ///
					2 "Closed for renovations" ///
					3 "Closed Permanently" ///
					4 "Closed for highway construction" ///
					5 "Closed due to mall fire"
label values TYPE2 type21

label define special21 0 "No special program" 1 "Special program for new workers"
label values SPECIAL2 special21

save njmin
