
CREATE OR REPLACE PACKAGE gigasecond# IS
   FUNCTION since(fechainicial DATE)
      RETURN DATE;
END gigasecond#;
/

CREATE OR REPLACE PACKAGE BODY gigasecond# IS
   FUNCTION since(fechainicial DATE) RETURN DATE IS
   lafecha DATE;
   fecha_sin_horas_minutos_segundos DATE;
   fecha_formateada VARCHAR2(10);
   fechafinal DATE;
   BEGIN
      lafecha := fechainicial + NUMTODSINTERVAL(1000000000, 'SECOND');
      fecha_sin_horas_minutos_segundos := TRUNC(lafecha);
      fecha_formateada := TO_CHAR(fecha_sin_horas_minutos_segundos, 'YYYY-MM-DD');
      fechafinal := TO_DATE(fecha_formateada, 'YYYY-MM-DD');
      return fechafinal;
   END since;
END gigasecond#;
/


create or replace package ut_gigasecond#
is
  procedure run;
end ut_gigasecond#;
/
 
create or replace package body ut_gigasecond#
is
  procedure test (
    i_descn                                       varchar2
   ,i_exp                                         date
   ,i_act                                         date
  )
  is
  begin
    if i_exp = i_act then
      dbms_output.put_line('SUCCESS: ' || i_descn);
    else
      dbms_output.put_line('FAILURE: ' || i_descn || ' - expected ' || nvl('' || i_exp, 'null') || ', but received ' || nvl('' || i_act, 'null'));
    end if;
  end test;
 
  procedure run
  is
  begin
    test(i_descn => 'test_1', i_exp => to_date('2043-01-01', 'YYYY-MM-DD'), i_act => gigasecond#.since(to_date('2011-04-25', 'YYYY-MM-DD')));
    test(i_descn => 'test_2', i_exp => to_date('2009-02-19', 'YYYY-MM-DD'), i_act => gigasecond#.since(to_date('1977-06-13', 'YYYY-MM-DD')));
    test(i_descn => 'test_3', i_exp => to_date('1991-03-27', 'YYYY-MM-DD'), i_act => gigasecond#.since(to_date('1959-07-19', 'YYYY-MM-DD')));
    test(i_descn => 'test_time_with_seconds', i_exp => to_date('1991-03-28', 'YYYY-MM-DD'), i_act => gigasecond#.since(to_date('1959-07-19 23:59:59', 'YYYY-MM-DD HH24:Mi:SS')));
    ---- modify the test to test your 1 Gs anniversary
    test(i_descn => 'test_yourself', i_exp => to_date('2022-07-31', 'YYYY-MM-DD'), i_act => gigasecond#.since(to_date('1990-11-22', 'YYYY-MM-DD')));
  end run;
end ut_gigasecond#;
/
 
begin
  ut_gigasecond#.run;
end;
/
