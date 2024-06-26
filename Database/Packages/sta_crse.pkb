create or replace package body sta_crse
is
    --global variables
    function read_row (p_id in sta_course.id%type /*pk*/ ) return sta_course%rowtype
    is
        v_row sta_course%rowtype;
        cursor cur_row is
          select * from sta_course
          where
            id = p_id;
  begin
        open cur_row;
        fetch cur_row into v_row;
        close cur_row;
        return v_row;
  end read_row;

    procedure p_upsert_course( pi_id           sta_course.id%type
                             , pi_name         sta_course.name%type
                             , pi_description  sta_course.description%type
                             , pi_grades       varchar2
                             )
    is
        l_crse_id sta_course.id%type;
        l_grades  apex_t_varchar2;
    begin
    
        l_grades := apex_string.split(pi_grades, ':');
        
        if pi_id is null then
            insert into sta_course (name, description)
            values (pi_name, pi_description)
            returning id into l_crse_id;

            for i in 1..l_grades.count loop
                insert into sta_course_grade (crse_id, grde_id)
                values (l_crse_id, l_grades(i));
            end loop;
        else
            update sta_course
            set name = pi_name
              , description = pi_description
            where id = pi_id;

            delete from sta_course_grade
            where crse_id = pi_id;

            for i in 1..l_grades.count loop
                insert into sta_course_grade (crse_id, grde_id)
                values (pi_id, l_grades(i));
            end loop;

        end if;
    end p_upsert_course;

    procedure p_delete_course( pi_id sta_course.id%type )
    is
    begin
        delete from sta_course_grade
        where crse_id = pi_id;

        delete from sta_course
        where id = pi_id;
    end p_delete_course;
    end sta_crse;

