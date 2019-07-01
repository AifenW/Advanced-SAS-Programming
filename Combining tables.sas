*Concatenating tables;

data work.np_combine;
    set PG2.NP_2014 (rename=(Park=ParkCode Type=ParkType)) PG2.NP_2015 PG2.NP_2016;
    where Month in (6,7,8) and ParkType="National Park";
    CampTotal=sum (of Camping:);
    format CampTotal comma15.;
    drop Camping:;
run;

prov sort data=work.np_combine;
 by ParkType ParkCode Year Month;
run;

*Merge tables;

proc sort data=pg2.storm_final out=storm_final_sort;
	by Season Name;
run;

data storm_damage;
	set pg2.storm_damage;
	Season=Year(date);
	Name=upcase(scan(Event, -1));
	format Date date9. Cost dollar16. deaths comma5.;
	drop event;
run;

proc sort data=storm_damage;
	by Season Name;
run;

data damage_detail storm_other (drop=Cost Deaths);
	merge storm_final_sort(in=inFinal) storm_damage(in=inDamage);
	keep Season Name BasinName MaxWindMPH MinPressure Cost Deaths;
	by Season Name;
	if inDamage=1 and inFinal=1 then output damage_detail;
	else output storm_other;
run;

* One-to-many merge;

proc sort data=pg2.np_codelookup out=work.codesort;
	by ParkCode;
run;

proc sort data=pg2.np_2016traffic (rename=(Code=ParkCode)) out=work.traf2016Sort;
	by ParkCode month;
run;

Data work.trafficstats;
  merge work.traf2016Sort work.codesort;
   by ParkCode;
   drop Name_Code;
Run;