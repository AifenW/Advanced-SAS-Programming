*Conditionally Creating Multiple Output Tables;

data monument(drop=ParkType) park(drop=ParkType) other; 
    set pg2.np_yearlytraffic;
    if ParkType = 'National Monument' then output monument;
    else if ParkType = 'National Park' then output park;
    else output other;
    drop Region;
run;

*Conditionally Creating Columns and Output Tables;

data camping(keep=ParkName Month DayVisits CampTotal)
    lodging(keep=ParkName Month DayVisits LodgingOther);
    set pg2.np_2017;
    CampTotal=sum(of Camping:);
    if CampTotal > 0 then output camping;
    if LodgingOther > 0 then output lodging;
    format CampTotal comma15.;
run; 
