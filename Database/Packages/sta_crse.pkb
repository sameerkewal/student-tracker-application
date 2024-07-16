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

    procedure p_log_action( pi_id           sta_course.id%type
                          , pi_name         sta_course.name%type
                          , pi_description  sta_course.description%type
                          , pi_actie        varchar2
                          , pi_grades       varchar2
    )
    is
        cursor c_get_grde_names
        is
            select listagg(name, ', ') within group (order by name asc)
            from   sta_grade grde
            where id in (select column_value from table(apex_string.split(pi_grades, ':')));
        l_grade_names varchar2(4000);

        cursor c_get_grde_names_from_crse
        is
            select    listagg(name, ', ') within group (order by name asc)
            from      sta_course_grade crse_grde
            left join sta_grade grde on grde.id = crse_grde.grde_id
            where crse_grde.crse_id = pi_id;
        l_name        sta_course.name%type;
        l_description sta_course.description%type;

    begin
        open  c_get_grde_names;
        fetch c_get_grde_names into l_grade_names;
        close c_get_grde_names;

        if pi_actie != 'Verwijderd' then
            insert into sta_course_audit
                ( naam
                , omschrijving
                , actie
                , leerjaren
                , actie_datum
                , gedaan_door)
            values ( pi_name
                   , pi_description
                   , pi_actie
                   , l_grade_names
                   , sysdate
                   , coalesce(regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), user)
                   );
        else
            l_name        := read_row(pi_id).name;
            l_description := read_row(pi_id).description;
            open  c_get_grde_names_from_crse;
            fetch c_get_grde_names_from_crse into l_grade_names;
            close c_get_grde_names_from_crse;
            insert into sta_course_audit
                ( naam
                , omschrijving
                , actie
                , leerjaren
                , actie_datum
                , gedaan_door)
            values ( l_name
                   , l_description
                   , pi_actie
                   , l_grade_names
                   , sysdate
                   , coalesce(regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), user)
                   );
        end if;
    end p_log_action;
        
        
    

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

            p_log_action(pi_id => pi_id, pi_name => pi_name, pi_description => pi_description, pi_actie => 'Toegevoegd', pi_grades => pi_grades);
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

            p_log_action(pi_id => pi_id, pi_name => pi_name, pi_description => pi_description, pi_actie => 'Gewijzigd', pi_grades => pi_grades);


        end if;
    end p_upsert_course;

    procedure p_delete_course( pi_id sta_course.id%type )
    is
    begin

        p_log_action(pi_id => pi_id, pi_name => null, pi_description => null, pi_actie => 'Verwijderd', pi_grades => null);

        delete from sta_course_grade
        where crse_id = pi_id;

        delete from sta_course
        where id = pi_id;


    end p_delete_course;


    end sta_crse;

