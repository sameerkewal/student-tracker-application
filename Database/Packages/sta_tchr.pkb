create or replace package body sta_tchr
is
--global variables

function f_get_tchr(p_id sta_teacher.id%type) return sta_teacher%rowtype
is
    v_row sta_teacher%rowtype;
    cursor cur_row is
      select * from sta_teacher
      where
        id = p_id;
begin
    open cur_row;
    fetch cur_row into v_row;
    close cur_row;
    return v_row;
end f_get_tchr;


    procedure p_add_tchr         ( pi_id           sta_teacher.id%type
                                 , pi_first_name   sta_teacher.first_name%type
                                 , pi_last_name    sta_teacher.last_name%type
                                 , pi_middle_name  sta_teacher.middle_name%type
                                 , pi_phone_number1 sta_teacher.phone_number1%type
                                 , pi_phone_number2 sta_teacher.phone_number2%type
                                 , pi_address1     sta_teacher.address1%type
                                 , pi_address2     sta_teacher.address2%type
                                 , pi_remarks      sta_teacher.remarks%type
                                 , pi_courses       varchar2
                                 )
    is
        l_tchr_id sta_teacher.id%type;
        l_courses apex_t_varchar2;
    begin

        l_courses := apex_string.split(pi_courses, ':');
        if pi_id is null then
            insert into sta_teacher
            ( id
            , first_name
            , last_name
            , middle_name
            , phone_number1
            , phone_number2
            , address1
            , address2
            , remarks
            )
            values
            ( pi_id
            , pi_first_name
            , pi_last_name
            , pi_middle_name
            , pi_phone_number1
            , pi_phone_number2
            , pi_address1
            , pi_address2
            , pi_remarks
            );

            for i in 1..l_courses.count loop
                insert into sta_course_teacher (crse_id, tchr_id)
                values (l_courses(i), l_tchr_id);
            end loop;
        else
            update sta_teacher
            set first_name = pi_first_name
            , last_name = pi_last_name
            , middle_name = pi_middle_name
            , phone_number1 = pi_phone_number1
            , phone_number2 = pi_phone_number2
            , address1 = pi_address1
            , address2 = pi_address2
            , remarks = pi_remarks
            where id = pi_id;

            delete from sta_course_teacher
            where tchr_id = pi_id;

            for i in 1..l_courses.count loop
                insert into sta_course_teacher (crse_id, tchr_id)
                values (l_courses(i), l_tchr_id);
            end loop;

        end if;
    end p_add_tchr;

    procedure p_delete_tchr(pi_id sta_teacher.id%type)
    is
    begin
        delete from sta_course_teacher
        where   tchr_id = pi_id;
        
        delete from sta_teacher
        where id = pi_id;
    end;

end sta_tchr;