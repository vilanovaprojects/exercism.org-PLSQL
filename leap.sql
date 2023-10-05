CREATE OR REPLACE PACKAGE year# IS
   FUNCTION is_leap(theyear PLS_INTEGER)
   RETURN VARCHAR2;
END year#;


CREATE OR REPLACE PACKAGE BODY year# IS
   FUNCTION is_leap(theyear PLS_INTEGER) RETURN VARCHAR2 IS
      respuestaSi varchar2(255) := 'Yes, ' || theyear ||' is a leap year';
      respuestaNo varchar2(255) := 'No, ' || theyear || ' is not a leap year';   
       BEGIN     
          IF theyear MOD 4 = 0 THEN
            IF theyear MOD 100 = 0 THEN
               IF theyear MOD 400 = 0 THEN
                  RETURN respuestaSi;
               ELSE
                  RETURN respuestaNo;
               END IF;
            ELSE 
              RETURN respuestaSi;
            END IF;  
          ELSE
            RETURN respuestaNo;
          END IF;
       END is_leap;
END year#;







create or replace package ut_year#
is
  procedure run;
end ut_year#;
/
 
create or replace package body ut_year#
is
  procedure test (
    i_descn                                       varchar2
   ,i_exp                                         varchar2
   ,i_act                                         varchar2
  )
  is
  begin
    if i_exp = i_act then
      dbms_output.put_line('SUCCESS: ' || i_descn);
    else
      dbms_output.put_line('FAILURE: ' || i_descn || ' - expected ' || nvl(i_exp, 'null') || ', but received ' || nvl(i_act, 'null'));
    end if;
  end test;
 
  procedure run
  is
  begin
    test(i_descn => 'test_leap_year'         , i_exp => 'Yes, 1996 is a leap year'   , i_act => year#.is_leap(1996));
    test(i_descn => 'test_non_leap_year'     , i_exp => 'No, 1997 is not a leap year', i_act => year#.is_leap(1997));
    test(i_descn => 'test_non_leap_even_year', i_exp => 'No, 1998 is not a leap year', i_act => year#.is_leap(1998));
    test(i_descn => 'test_century'           , i_exp => 'No, 1900 is not a leap year', i_act => year#.is_leap(1900));
    test(i_descn => 'test_fourth_century'    , i_exp => 'Yes, 2400 is a leap year'   , i_act => year#.is_leap(2400));
  end run;
end ut_year#;
/
 
begin
  ut_year#.run;
end;
/
