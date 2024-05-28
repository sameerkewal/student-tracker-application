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

    procedure p_upsert_sdnt_tst( pi_sdnt_tst_id sta_student_test.id%type
                               , pi_usr_id      sta_student_test.usr_id%type
                               , pi_rslt        sta_student_test.result%type
                               )
    is
    begin
        if pi_sdnt_tst_id is null then
            insert into sta_student_test (usr_id, result)
            values (pi_usr_id, pi_rslt);
        else
            update sta_student_test
            set usr_id = pi_usr_id
              , result = pi_rslt
            where id = pi_sdnt_tst_id;
        end if;
    end p_upsert_sdnt_tst;

    procedure p_delete_sdnt_tst( pi_sdnt_tst_id sta_student_test.id%type )
    is  
    begin
        delete from sta_student_test
        where id = pi_sdnt_tst_id;  
    end p_delete_sdnt_tst;

    procedure p_process_sdnt_tst( pi_sdnt_tst_id sta_student_test.id%type
                                , pi_usr_id      sta_student_test.usr_id%type
                                , pi_rslt        sta_student_test.result%type
                                , pi_action      varchar2
                                )
    is
    begin
        case pi_action
            when 'C' then
                p_upsert_sdnt_tst( pi_sdnt_tst_id => pi_sdnt_tst_id
                                 , pi_usr_id      => pi_usr_id
                                 , pi_rslt        => pi_rslt         
                                 );

            when 'I' then
                p_upsert_sdnt_tst( pi_sdnt_tst_id => pi_sdnt_tst_id
                                 , pi_usr_id      => pi_usr_id
                                 , pi_rslt        => pi_rslt         
                                 );

            when 'D' then
                p_delete_sdnt_tst(pi_sdnt_tst_id => pi_sdnt_tst_id);
        end case;
    end p_process_sdnt_tst;
end sta_sdnt_tst;