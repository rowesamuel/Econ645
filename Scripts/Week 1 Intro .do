*Introduction
*Econ 645 
*Samuel Rowe Adapted from Mitchell
*August 14, 2023

clear
set more off

*Set Working Directory
cd "/Users/Sam/Desktop/Econ 645/Data/Mitchell"

********************************************************************************
*Mitchell Chapter 10
********************************************************************************
********
*10.3 Executing do-files and making log files
********
* When you work with Stata, you should always use a do file. I find log files 
* helpful, but do files are essential. It provides transparency to show your
* work, and it help provide replication. One key feature of do files are comments.
* Comments are an essential part for two reasons. It will help yourself when
* you go back to your own code to describe what is going one. Second, it helps
* with replication, since someone should be able to run your code top to bottom
* and get the same results that you have in your paper, report, or document.
*
* Never use point and click. It is available in Stata, but don't lower yourself
* to a SPSS standard. 
*
* In case you are new to do files. We'll start off with a simple example.
* We'll pull some data, summarize some data, and tabulate some data.
use wws.dta, clear
summarize age wage hours
tabulate married

*We can look at a similar file called example1.do
type example1.do

* We can actually run a do file within a do file
do example1.do

* You can use the doedit command if you want to open the Do-file Editor, but
* you can just click to open the Do-File (this is an exception from what I 
* said above). 

* Since we already have the Do-File Editor open, running the doedit will just
* open a new blank do file.
doedit 

* Note: you can write do files in Notepad or TextEdit, but you don't get any
* of the benefits, such as highlighted text.

* Let's look at a do file that uses the log command
type example2.do

* Let's run it. 
log using example2
use wws2, clear
summarize age wage hours
tabulate married
log close

* Note: It is important to note that when opening a log it must end 
* with a "log close" command. If your do files bombs out (fails to finish) 
* before reaching the log close command, your log will remain open. 

* Even if we close the log file, we'll get an error if we try to run the
* do file again. So we need to add the replace option.
log using example2, replace
use wws2, clear
summarize age wage hours
tabulate married
log close

