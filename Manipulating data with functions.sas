* Manipulating data with functions;

* Mean;
data quiz_summary;
	set pg2.class_quiz;
	Name=upcase(Name);
	Mean1=mean(Quiz1, Quiz2, Quiz3, Quiz4, Quiz5);
	/* Numbered Range: col1-coln where n is a sequential number */ 
	Mean2=mean(of Quiz1-Quiz5);
	/* Name Prefix: all columns that begin with the specified character string */ 
	Mean3=mean(of Q:);
	format Quiz1--Mean3 3.1;
	/*OR*/
	format _numeric_ 3.1;
run;

*Call missing ;

data quiz_report;
    set pg2.class_quiz;
	if Name in("Barbara", "James") then do;
		Quiz1=.;
		Quiz2=.;
		Quiz3=.;
		Quiz4=.;
		Quiz5=.;
	end;
run;

data quiz_report;
    set pg2.class_quiz;
	if Name in("Barbara", "James") then call missing(of Q:);
run;

*largest and round function;

proc print data=pg2.np_lodging(obs=10);
	where CL2010>0;
run;

data stays;
	set pg2.np_lodging;
	Stay1=largest(1, of CL:);
	Stay2=largest(2, of CL:);
	Stay3=largest(3, of CL:);
	format Stay: comma11.;
	StayAvg=round(mean(of CL:));
	if StayAvg>0;
	format Stay: comma11.;
	keep Park Stay:;
run;

*Working with Date/Time values;

*create the following new columns:                   *;
*     1) Date - the date portion of the DateTime column   *;
*     2) MonthEnd - the last day of the month *;

data rainsummary;
	set pg2.np_hourlyrain;
	by Month;
	if first.Month=1 then MonthlyRainTotal=0;
	MonthlyRainTotal+Rain;
	if last.Month=1;
	Date=Datepart(DateTime);
	MonthEnd=INTNX('month',Date,0,'end');
	format Date MonthEnd date9.;
	Keep StationName MonthlyRainTotal Date MonthEnd;
run;

*Using special functions to convert column type;

data stocks2;
   set pg2.stocks2(rename=(Volume=CharVolume Date=CharDate));
   Volume=input(CharVolume,comma12.);
   Date=input(CharDate, date9.);
   drop CharVolume CharDate;
run;
