*Creating and using custom formats;

proc format library=pg2.formats;
    value $gender 'F'='Female'
                  'M'='Male'
                  other='Miscoded';
    value hght low-<58  = 'Below Average'
                58-60   = 'Average'
               60<-high = 'Above Average';
run;

Options fmtsearch=(pg2.formats);

proc print data=pg2.class_birthdate noobs;
    where Age=12;
    var Name Gender Height;
    format Gender $gender. Height hght.;
run;

*Creating a custom format from a table;

data type_lookup;
    retain FmtName '$TypeFmt';
    set pg2.np_codeLookup (rename=(ParkCode=Start Type=Label));
    keep Start Label FmtName;
run;

proc format CNTLIN=type_lookup;
run;

title 'Traffic Statistics';
proc means data=pg2.np_monthlyTraffic maxdec=0 mean sum nonobs;
    var Count;
    class ParkCode Month;
    label ParkCode='Name';
    format ParkCode $TypeFmt.;
run;
title;
