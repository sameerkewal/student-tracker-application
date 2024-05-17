begin
    sta_crse.p_upsert_course(pi_id          => null
                            ,pi_name        => 'Engels'
                            ,pi_description => 'null'
                            ,pi_grades      => '1:2');
end;
/
commit;

select  *
FROM    STA_GRADE
;

        select * 
        from table(apex_string.split_numbers('202;90;1002', ';'));



        select  *
        from    STA_COURSE_GRADE
        ;
        
        select  *
        from    STA_COURSE
        ;
        select  *
        from    STA_COURSE_GRADE
        ;

        delete from    STA_COURSE
        ;
        delete from    STA_COURSE_GRADE
        ;
        
commit;

select apex_util.get_preference('FSP_LANGUAGE_PREFERENCE')
;


begin
        sta_crse.p_delete_course(pi_id=>:)
end;
/



with w_grades as (
    select  crse_grde.crse_id                                             as crse_id,
            listagg(grde.name, ', ') within group (order by grde.id)      as grades_agg
    from    sta_grade grde
    join    sta_course_grade crse_grde on crse_grde.grde_id = grde.id
    group by crse_grde.crse_id
)
select crse.id
,      crse.name           as naam
,      crse.description    as beschrijving
,      w_grades.grades_agg as beschikbaar_in_leerjaar
from   sta_course crse
join w_grades on w_grades.crse_id = crse.id
;

select      listagg(grde.id, ':') within group (order by grde.id)    as grades_agg
from        sta_grade grde
join        sta_course_grade crse_grde on crse_grde.grde_id = grde.id
where       crse_grde.crse_id = :P5_ID
group by    crse_grde.crse_id;



    select  grde.NAME
    ,       crse_grde.CRSE_ID
    ,       crse_grde.grde_id
    from    sta_grade grde
    join    sta_course_grade crse_grde on crse_grde.grde_id = grde.id;



    select  *
from    all_tab_columns
where   table_name = 'STA_ANNOUNCEMENT'
;

/



select  id as r
,       name as d
from    sta_course
;
/
DECLARE
BEGIN
    FOR r IN (
        SELECT table_name AS tab_name
        FROM all_tables
        WHERE owner = 'STA'
    )
    LOOP
        BEGIN
            EXECUTE IMMEDIATE 'ALTER TABLE ' || r.tab_name || ' ADD created_by VARCHAR2(255)';
            EXECUTE IMMEDIATE 'ALTER TABLE ' || r.tab_name || ' ADD created_at DATE';
            EXECUTE IMMEDIATE 'ALTER TABLE ' || r.tab_name || ' ADD updated_by VARCHAR2(255)';
            EXECUTE IMMEDIATE 'ALTER TABLE ' || r.tab_name || ' ADD updated_on DATE';
        EXCEPTION
            WHEN OTHERS THEN
                dbms_output.put_line('Failed to alter ' || r.tab_name || ': ' || SQLERRM);
        END;
    END LOOP;
END;
/
DECLARE
BEGIN
FOR r IN (
        SELECT table_name AS tab_name
        FROM all_tables at
        WHERE owner = 'STA'
       and exists (
           select 1 from all_tab_columns atc
                    where atc.table_name = at.table_name
                    and   lower(atc.column_name) = lower('created_by')
        )
    )
    LOOP
    dbms_output.PUT_LINE(r.tab_name);
BEGIN
EXECUTE IMMEDIATE 'ALTER TABLE ' || r.tab_name || ' drop column created_by';
EXECUTE IMMEDIATE 'ALTER TABLE ' || r.tab_name || ' drop column created_at';
EXECUTE IMMEDIATE 'ALTER TABLE ' || r.tab_name || ' drop column updated_by';
EXECUTE IMMEDIATE 'ALTER TABLE ' || r.tab_name || ' drop column updated_on';
EXCEPTION
            WHEN OTHERS THEN
                dbms_output.put_line('Failed to alter ' || r.tab_name || ': ' || SQLERRM);
END;
END LOOP;
END;

/
select  *
from    all_tab_columns
;


/
alter table sta_announcement add updated_at date;
alter table sta_caretaker drop tst varchar2(255);

alter table STA_TEACHER add created_by varchar2(255);
alter table STA_TEACHER DROP COLUMN created_by;
