CREATE OR REPLACE PACKAGE complement# IS
   FUNCTION of_dna(input VARCHAR2)
   RETURN VARCHAR2;
   FUNCTION of_rna(input VARCHAR2)
   RETURN VARCHAR2;
END complement#;
/

CREATE OR REPLACE PACKAGE BODY complement# IS
   FUNCTION of_dna(input VARCHAR2) RETURN VARCHAR2 IS
   variable1 char(1);
   variablesalida1  varchar2(255);
   
   BEGIN
      FOR i IN 1.. LENGTH(input) LOOP
         variable1 := SUBSTR(input, i, 1);
         CASE
            WHEN variable1 = 'G' THEN variablesalida1 := variablesalida1 || 'C';
            WHEN variable1 = 'C' THEN variablesalida1 := variablesalida1 || 'G';
            WHEN variable1 = 'T' THEN variablesalida1 := variablesalida1 || 'A';
            WHEN variable1 = 'A' THEN variablesalida1 := variablesalida1 || 'U';
         END CASE;   
      END LOOP; 
      RETURN variablesalida1;
   END;
   
   FUNCTION of_rna(input VARCHAR2) RETURN VARCHAR2 IS
   variable1 char(1);
   variablesalida2  varchar2(255);
   
   BEGIN
      FOR j IN 1.. LENGTH(input) LOOP
         variable1 := SUBSTR(input, j, 1);
         CASE
            WHEN variable1 = 'C' THEN variablesalida2 := variablesalida2 || 'G';
            WHEN variable1 = 'G' THEN variablesalida2 := variablesalida2 || 'C';
            WHEN variable1 = 'A' THEN variablesalida2 := variablesalida2 || 'T';
            WHEN variable1 = 'U' THEN variablesalida2 := variablesalida2 || 'A';
         END CASE;   
      END LOOP; 
      RETURN variablesalida2;
   END;
   
END complement#;
/

create or replace package ut_complement#
is
  procedure run;
end ut_complement#;
/
 
create or replace package body ut_complement#
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
    test(i_descn => 'test_rna_complement_of_cytosine_is_guanine', i_exp => 'G'            , i_act => complement#.of_dna('C'            ));
    test(i_descn => 'test_rna_complement_of_guanine_is_cytosine', i_exp => 'C'            , i_act => complement#.of_dna('G'            ));
    test(i_descn => 'test_rna_complement_of_thymine_is_adenine' , i_exp => 'A'            , i_act => complement#.of_dna('T'            ));
    test(i_descn => 'test_rna_complement_of_adenine_is_uracil'  , i_exp => 'U'            , i_act => complement#.of_dna('A'            ));
    test(i_descn => 'test_rna_complement'                       , i_exp => 'UGCACCAGAAUU' , i_act => complement#.of_dna('ACGTGGTCTTAA' ));
    test(i_descn => 'test_dna_complement_of_cytosine_is_guanine', i_exp => 'G'            , i_act => complement#.of_rna('C'            ));
    test(i_descn => 'test_dna_complement_of_guanine_is_cytosine', i_exp => 'C'            , i_act => complement#.of_rna('G'            ));
    test(i_descn => 'test_dna_complement_of_uracil_is_adenine'  , i_exp => 'A'            , i_act => complement#.of_rna('U'            ));
    test(i_descn => 'test_dna_complement_of_adenine_is_thymine' , i_exp => 'T'            , i_act => complement#.of_rna('A'            ));
    test(i_descn => 'test_dna_complement'                       , i_exp => 'ACTTGGGCTGTAC', i_act => complement#.of_rna('UGAACCCGACAUG'));
  end run;
end ut_complement#;
/
 
begin
  ut_complement#.run;
end;
/