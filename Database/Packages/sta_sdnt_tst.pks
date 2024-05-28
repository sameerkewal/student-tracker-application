create or replace package sta_sdnt_tst
is
  --global variables
  function f_get_rslt( pi_sdnt_tst_id sta_student_test.id%type)return sta_student_test.result%type;


  procedure p_process_sdnt_tst( pi_sdnt_tst_id sta_student_test.id%type
                              , pi_usr_id   sta_student_test.usr_id%type
                              , pi_rslt     sta_student_test.result%type
                              , pi_action   varchar2
                              );
end sta_sdnt_tst;