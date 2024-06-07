create or replace package body sta_sdnt_tst
is
  --global variables

    function f_get_rslt( pi_sdnt_tst_id sta_student_test.id%type)return sta_student_test.result%type
    is
        cursor c_get_rslt(b_sdnt_tst_id sta_student_test.id%type) 
        is
            select result
            from sta_student_test
            where id = b_sdnt_tst_id;
        l_rslt sta_student_test.result%type;
    begin
        open  c_get_rslt(pi_sdnt_tst_id);
        fetch c_get_rslt into l_rslt;
        close c_get_rslt;
        return l_rslt;
    end;

    procedure p_delete_sdnt_tst( pi_sdnt_tst_id sta_student_test.id%type )
    is
    begin
      delete from sta_student_test
      where id = pi_sdnt_tst_id;
    end p_delete_sdnt_tst;

    procedure p_upsert_sdnt_tst( pi_sdnt_tst_id sta_student_test.id%type
                               , pi_tst_id      sta_student_test.tst_id%type
                               , pi_usr_id      sta_student_test.usr_id%type
                               , pi_rslt        sta_student_test.result%type
                               )
    is
    begin
        if pi_sdnt_tst_id is null then

            -- If result is 0 or null we basically treat test result as not made
            -- For example if a student was sick and could not attend then a 0 will be entered as the result
            if pi_rslt is null or pi_rslt = 0 then
                return;
            end if;

            insert into sta_student_test (tst_id, usr_id, result)
            values (pi_tst_id, pi_usr_id, pi_rslt);
        else
            -- If result is 0 or null we basically treat test result as not made
            -- For example if a student was sick and could not attend then a 0 will be entered as the result
            -- In the case of an update the row was already added meaning we will delete it and then return
            if  pi_rslt is null or pi_rslt = 0 then
                p_delete_sdnt_tst(pi_sdnt_tst_id => pi_sdnt_tst_id);
                return;
            end if;

            update sta_student_test
            set usr_id = pi_usr_id
              , result = pi_rslt
              , tst_id = pi_tst_id
            where id = pi_sdnt_tst_id;
        end if;
    end p_upsert_sdnt_tst;



    procedure p_process_sdnt_tst( pi_sdnt_tst_id sta_student_test.id%type
                                , pi_usr_id      sta_student_test.usr_id%type
                                , pi_tst_id      sta_student_test.tst_id%type
                                , pi_rslt        sta_student_test.result%type
                                , pi_action      varchar2
                                )
    is
    begin
        case pi_action
            when 'C' then
                p_upsert_sdnt_tst( pi_sdnt_tst_id => pi_sdnt_tst_id
                                 , pi_usr_id      => pi_usr_id
                                 , pi_tst_id      => pi_tst_id
                                 , pi_rslt        => pi_rslt         
                                 );

            when 'U' then
                p_upsert_sdnt_tst( pi_sdnt_tst_id => pi_sdnt_tst_id
                                 , pi_usr_id      => pi_usr_id
                                 , pi_tst_id      => pi_tst_id
                                 , pi_rslt        => pi_rslt         
                                 );

            when 'D' then
                p_delete_sdnt_tst(pi_sdnt_tst_id => pi_sdnt_tst_id);
        end case;
    end p_process_sdnt_tst;

    function f_get_smsr_header( pi_usr_id    sta_user.id%type
                              , pi_grde_id   sta_grade.id%type
                              , pi_column_id number
                              , pi_smsr_ids  varchar2
                              )return sta_semester.name%type
    is
        cursor c_smsr_name(b_usr_id sta_user.id%type, b_grde_id sta_grade.id%type)
        is
            select listagg(name, ':') within group (order by name) as smsrs_name
            from sta_semester
            where   id in (
                           --select  distinct smsr.id
                           --from    sta_student_test sdnt_tst
                           --join    sta_test         tst      on sdnt_tst.tst_id = tst.id
                           --join    sta_semester     smsr     on smsr.id = tst.smsr_id
                           --and     tst.grde_id     = b_grde_id
                            select column_value from table(apex_string.split(pi_smsr_ids, ':'))
                          );
        l_smsr_name varchar2(4000);
        l_smsr_list apex_t_varchar2;

    begin
        open  c_smsr_name(b_usr_id => pi_usr_id, b_grde_id => pi_grde_id);
        fetch c_smsr_name into l_smsr_name;
        close c_smsr_name;

        l_smsr_list :=  apex_string.split(l_smsr_name, ':');

        if pi_column_id > l_smsr_list.count then
            return 'Eind Resultaat: ';
        end if;

        return l_smsr_list(pi_column_id);
    end f_get_smsr_header;

      function f_get_smsr_header(pi_usr_id sta_user.id%type
                            , pi_grde_id   sta_grade.id%type
                            , pi_smsr_ids  varchar2
                            )return varchar2
      is
          cursor c_smsr_name(b_usr_id sta_user.id%type, b_grde_id sta_grade.id%type)
          is
          select listagg(name, ':') within group (order by name) as smsrs_name
          from sta_semester
          where   id in (
                           --select  distinct smsr.id
                           --from    sta_student_test sdnt_tst
                           --join    sta_test         tst      on sdnt_tst.tst_id = tst.id
                           --join    sta_semester     smsr     on smsr.id = tst.smsr_id
                           --and     tst.grde_id     = b_grde_id
                            select column_value from table(apex_string.split(pi_smsr_ids, ':'))
                          );
        l_smsr_name varchar2(4000);
      begin
        open  c_smsr_name(b_usr_id => pi_usr_id, b_grde_id => pi_grde_id);
        fetch c_smsr_name into l_smsr_name;
        close c_smsr_name;

        return 'Vak' || ':' || l_smsr_name || ':'|| 'Eind Resultaat';
      end;
end sta_sdnt_tst;