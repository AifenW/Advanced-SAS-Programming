*1. Creating an accumulating column;

*Producing a Running Total;

data totalTraffic;
	set pg2.np_yearlytraffic;
	retain totTraffic 0;
	totTraffic=totTraffic+Count;
	keep ParkName Location Count totTraffic;
	format totTraffic comma12.;
run;

/*OR*/
data totalTraffic;
	set pg2.np_yearlytraffic;
	totTraffic+Count;
	keep ParkName Location Count totTraffic;
	format totTraffic comma12.;
run;

*Producing Multiple Totals;

Data parkTypeTraffic;
	set pg2.np_yearlytraffic;
	where ParkType in ("National Monument", "National Park");
	if ParkType="National Monument" then
		MonumentTraffic+Count;
	else
		ParkTraffic+Count;
	format MonumentTraffic comma12.;
	format ParkTraffic comma12.;
Run;

Title "Accumulating Traffic Totals for Park Types";

Proc print data=parkTypeTraffic;
	Var ParkType ParkName Location Count MonumentTraffic ParkTraffic;
Run;

*2. Processing data in groups;

* Generating an Accumulating Column within Groups;

proc sort data=pg2.np_yearlyTraffic   
          out=sortedTraffic(keep=ParkType ParkName 
                                      Location Count);
        by ParkType ParkName;
run;

data TypeTraffic;
    set sortedTraffic;
    by ParkType;
    if first.ParkType=1 then TypeCount=0;
    TypeCount+count;
    Format TypeCount comma12.;
    keep ParkType TypeCount;
run;


data TypeTraffic;
    set sortedTraffic;
    by ParkType;
    if first.ParkType=1 then TypeCount=0;
    TypeCount+count;
    Format TypeCount comma12.;
    keep ParkType TypeCount;
    if last.ParkType=1 then output;
run;

*Generating an Accumulating Column within Multiple Groups;

Proc sort data=SASHELP.SHOES out=sorted_shoes;
   by Region Product;
Run;

Data profitssummary;
   set sorted_shoes;
   by Region Product;
   Profit=Sales-Returns;
   if first.Product then 
   TotalProfit=0;
   TotalProfit+Profit;
   if last.Product then 
   output;
   keep Region Product TotalProfit;
   format TotalProfit dollar12.;
Run;
Run;