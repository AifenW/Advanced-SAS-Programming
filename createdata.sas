
/**********************************************/
/* You must run LIBNAME.SAS before you run    */
/* this code to create your data for EPG294   */
/*                                            */
/* DO NOT EDIT THE CODE BELOW                 */
/**********************************************/

%include "&path/_1createdata_pg2.sas";
%include "&path/_2createdata_pg2.sas";
%include "&path/_3createdata_pg2.sas";

proc contents data=pg2._all_ nods;
run;
