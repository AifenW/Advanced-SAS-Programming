*Restructuring a Table Using the DATA Step: Narrow to Wide;

data class_wide;
	set pg2.class_test_narrow;
	by Name;
	retain Name Math Reading;
	keep Name Math Reading;
	if TestSubject="Math" then Math=TestScore;
	else if TestSubject="Reading" then Reading=TestScore;
	if last.Name=1 then output;
run;

*Restructuring a Table Using the DATA Step: Wide to Narrow;

proc print data=pg2.np_2017camping(obs=10);
run;

data work.camping_narrow(drop=Tent RV Backcountry);
	set pg2.np_2017Camping;
	format CampCount comma12.;
	length CampType $11.;
	CampType='Tent';
	CampCount=Tent;
	output;
	CampType='RV';
	CampCount=RV;
	output;
	CampType='Backcountry';
	CampCount=Backcountry;
	output;
Run;

*Restructuring a Table Using the DATA Step: Narrow to Wide;

data work.camping_wide;
    set pg2.np_2016Camping;
    by ParkName;
    keep ParkName Tent RV Backcountry;
    format Tent RV Backcountry comma12.;
    retain ParkName Tent RV Backcountry;
    if CampType='Tent' then Tent=CampCount;
    else if CampType='RV' then RV=CampCount;
    else if CampType='Backcountry' then Backcountry=CampCount;
    if last.ParkName;
run;


*Restructuring a Table Using PROC TRANSPOSE: Wide to Narrow;
proc transpose data=pg2.np_2017camping
               out=work.camping2017_t (rename=(COL1=Count)) name=Location;
    by ParkName;
    var Tent RV;
run;
*Restructuring a Table Using PROC TRANSPOSE:  Narrow to Wide;
proc transpose data=pg2.np_2016camping 
               out=work.camping2016_transposed(drop=_name_);
    by ParkName;
    id CampType;
    var CampCount;
run;
