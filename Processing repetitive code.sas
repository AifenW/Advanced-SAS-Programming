*Using a Conditional DO Loop;

data IncreaseDayVisits;  
    set pg2.np_summary;
    where Reg='NE' and DayVisits<100000;
    IncrDayVisits=DayVisits;
    Year=0;
    do until (IncrDayVisits>100000);
       Year+1;
       IncrDayVisits=IncrDayVisits*1.06;
       output;
    end;
    format IncrDayVisits comma12.;
    keep ParkName DayVisits IncrDayVisits Year;
run;

*Using an Iterative and Conditional DO Loop;

data IncrExports;
    set pg2.eu_sports;
    where Year=2015 and Country='Belgium' 
          and Sport_Product in ('GOLF','RACKET');
    do Year=2016 to 2025 while (Amt_Export<=Amt_Import);
       Amt_Export=Amt_Export*1.07;
       output;
    end;
    format Amt_Import Amt_Export comma12.;
run; 