
declare
begin
    for r in (
        select table_name as tab_name
        from all_tables
        where owner = 'sta'
    )
    loop
        begin
            execute immediate 'alter table ' || r.tab_name || ' add created_by varchar2(255)';
            execute immediate 'alter table ' || r.tab_name || ' add created_at date';
            execute immediate 'alter table ' || r.tab_name || ' add updated_by varchar2(255)';
            execute immediate 'alter table ' || r.tab_name || ' add updated_on date';
        exception
            when others then
                dbms_output.put_line('failed to alter ' || r.tab_name || ': ' || sqlerrm);
        end;
    end loop;
end;
/
declare
begin
for r in (
        select table_name as tab_name
        from all_tables at
        where owner = 'sta'
       and exists (
           select 1 from all_tab_columns atc
                    where atc.table_name = at.table_name
                    and   lower(atc.column_name) = lower('created_by')
        )
    )
    loop
    dbms_output.put_line(r.tab_name);
begin
execute immediate 'alter table ' || r.tab_name || ' drop column created_by';
execute immediate 'alter table ' || r.tab_name || ' drop column created_at';
execute immediate 'alter table ' || r.tab_name || ' drop column updated_by';
execute immediate 'alter table ' || r.tab_name || ' drop column updated_on';
exception
            when others then
                dbms_output.put_line('failed to alter ' || r.tab_name || ': ' || sqlerrm);
end;
end loop;
end;

/
