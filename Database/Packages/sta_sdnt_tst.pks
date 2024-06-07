create or replace package sta_sdnt_tst
is
  --global variables
  function f_get_rslt( pi_sdnt_tst_id sta_student_test.id%type)return sta_student_test.result%type;


  procedure p_process_sdnt_tst( pi_sdnt_tst_id sta_student_test.id%type
                              , pi_usr_id   sta_student_test.usr_id%type
                              , pi_tst_id   sta_student_test.tst_id%type
                              , pi_rslt     sta_student_test.result%type
                              , pi_action   varchar2
                              );

  -- Function used on page 22 to determine page header since the page headers for the "Jaaroverzicht"
  -- are dynamic we need a way to determine based on the column position, what header it gets
  function f_get_smsr_header( pi_usr_id    sta_user.id%type
                            , pi_grde_id   sta_grade.id%type
                            , pi_column_id number
                            , pi_smsr_ids varchar2
                            )return sta_semester.name%type;

  function f_get_smsr_header(pi_usr_id sta_user.id%type
                            , pi_grde_id   sta_grade.id%type
                            , pi_smsr_ids  varchar2
                            )return varchar2;
end sta_sdnt_tst;