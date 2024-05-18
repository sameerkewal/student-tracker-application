
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
