create or replace package body sta_crse_clss_tchr
is
    gc_package constant varchar2(128) := $$plsql_unit || '.';

    procedure upsert_crse_clss_tchr( pi_usr_id             in sta_user.id%type
                                   , pi_crse_clss_tchr_tab in t_crse_clss_tchr_tab
    )
    is
        lc_scope constant varchar2(128) := gc_package || 'upsert_crse_clss_tchr';
    begin
        apex_debug.message(lc_scope);

        -- Nothing to Process
        if pi_crse_clss_tchr_tab is null then
            return;
        end if;

        for i in 1 .. pi_crse_clss_tchr_tab.count loop
            case pi_crse_clss_tchr_tab(i).action
                when 'C' then
                    for r in (select column_value as clss_id from table(apex_string.split(pi_crse_clss_tchr_tab(i).classes_ids, ':'))) loop
                        insert into sta_course_class_teacher
                            (
                            clss_id,
                            crse_id,
                            usr_id
                        ) values (
                            r.clss_id,
                            pi_crse_clss_tchr_tab(i).crse_id,
                            pi_usr_id
                        );
                    end loop;
                when 'U' then
                    -- Clear existing one first
                    delete from sta_course_class_teacher
                    where  crse_id = pi_crse_clss_tchr_tab(i).crse_id
                    and    usr_id = pi_usr_id
                    ;
                    for r in (select column_value as clss_id from table(apex_string.split(pi_crse_clss_tchr_tab(i).classes_ids, ':'))) loop
                        insert into sta_course_class_teacher
                        (
                            clss_id,
                            crse_id,
                            usr_id
                        ) values (
                                     r.clss_id,
                                     pi_crse_clss_tchr_tab(i).crse_id,
                                     pi_usr_id
                                 );
                    end loop;
                when 'D' then
                    for r in (select column_value as clss_id from table(apex_string.split(pi_crse_clss_tchr_tab(i).classes_ids, ':'))) loop
                        delete from sta_course_class_teacher
                        where  usr_id = pi_usr_id
                        and    crse_id = pi_crse_clss_tchr_tab(i).crse_id
                        and    clss_id = r.clss_id;
                    end loop;
            end case;
        end loop;
    end upsert_crse_clss_tchr;
    
    function f_tchr_subj_cnt(pi_id in sta_user.id%type) return number
    is
        cursor c_cnt_tchr_subjects(b_usr_id sta_user.id%type)
        is
            select count(distinct crse_id)
            from   sta_course_class_teacher
            where  usr_id = b_usr_id
            ;
        l_cnt_tchr_subjects_rslt number;
    begin
        open  c_cnt_tchr_subjects(b_usr_id => pi_id);
        fetch c_cnt_tchr_subjects into l_cnt_tchr_subjects_rslt;
        close c_cnt_tchr_subjects;
        return l_cnt_tchr_subjects_rslt;
    end f_tchr_subj_cnt;
end sta_crse_clss_tchr;
/
