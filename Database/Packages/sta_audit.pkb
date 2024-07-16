create or replace package body sta_audit
is
    function f_generate_audit_table(pi_table_name in varchar2) return clob
    is
        lv_stmnt clob := '';
        max_col_length number;
        procedure w(pi_txt varchar2)
        is
        begin
            lv_stmnt := lv_stmnt || ' ' || pi_txt;
        end w;

    begin
        -- Determine the maximum column name length
        select max(length(lower(column_name)))
        into max_col_length
        from user_tab_columns
        where table_name = upper(pi_table_name);

        w('create table ' || lower(pi_table_name) || '_audit');
        w('( ' || chr(13) || ' ');

        for x in (select lower(column_name) as col
                 ,      case when data_type = 'VARCHAR2' then 'varchar2(4000)' else lower(data_type) end as data_type
                 from   user_tab_columns
                 where  table_name = upper(pi_table_name) and lower(column_name) != 'id' order by column_id asc)
        loop
            w(x.col || lpad(' ', max_col_length - length(x.col)) || ' ' || x.data_type || chr(13) || ',');
        end loop;
        w('actie'       || lpad(' ', max_col_length - length('action'))       || ' varchar2(20)'    || chr(13) || ',');
        w('actie_datum'  || lpad(' ', max_col_length - length('action_date'))  || ' date'            || chr(13) || ',');
        w('gedaan_door' || lpad(' ', max_col_length - length('action_taker')) || ' varchar2(4000)'  || chr(13));
        w(');');

        return lv_stmnt;

    end f_generate_audit_table;
        
    function f_generate_audit_trigger(pi_table_name in varchar2) return clob
    is
        lv_stmnt clob := '';
        l_column_list clob;
        max_col_length number;
        procedure w(pi_txt varchar2)
        is
        begin
            lv_stmnt := lv_stmnt ||  pi_txt;
        end w;
    begin
        -- Determine the maximum column name length
        select max(length(lower(column_name)))
        into max_col_length
        from user_tab_columns
        where table_name = upper(pi_table_name);

        w('create or replace trigger ' || lower(pi_table_name) || '_audit' || chr(13));
        w('  after insert or update or delete on ' || lower(pi_table_name) || chr(13));
        w('  for each row' || chr(13));
        w('  begin' || chr(13));
        w('      if inserting then' || chr(13));
        w('      insert into ' || lower(pi_table_name || '_audit') || chr(13) || '(' || chr(13));

        for x in (select lower(column_name) as col
                 from user_tab_columns
                 where table_name = upper(pi_table_name || '_audit')
                 order by column_id asc)
        loop
            w('      ' || x.col || lpad(' ', max_col_length - length(x.col)) || ',' || chr(13));
        end loop;

        -- Add additional columns for the audit table
        w('      ) values (' || chr(13));

        for x in (select lower(column_name) as col
                 from user_tab_columns
                 where table_name = upper(pi_table_name) and column_name !=  'ID'
                 order by column_id asc)
        loop
            w('      :new.' || x.col || lpad(' ', max_col_length - length(x.col)) || ',' || chr(13));
        end loop;

        -- Add values for the additional columns
        w('      ''Toegevoegd'',' || chr(13));
        w('      sysdate,' || chr(13));
        w('      coalesce(regexp_substr(sys_context(''userenv'', ''client_identifier''), ''^[^:]*''), user)' ||chr(13));
        w('      );' || chr(13));

        w('      elsif updating then' || chr(13));
        w('      insert into ' || lower(pi_table_name || '_audit') || chr(13) || '(' || chr(13));

        for x in (select lower(column_name) as col
                 from user_tab_columns
                 where table_name = upper(pi_table_name||'_audit')
                 order by column_id asc)
        loop
            w('      ' || x.col || lpad(' ', max_col_length - length(x.col)) || ',' || chr(13));
        end loop;

        -- Add additional columns for the audit table
        w('      ) values (' || chr(13));

        for x in (select lower(column_name) as col
                 from user_tab_columns
                 where table_name = upper(pi_table_name) and column_name !=  'ID'
                 order by column_id asc)
        loop
            w('      :new.' || x.col || lpad(' ', max_col_length - length(x.col)) || ',' || chr(13));
        end loop;

        -- Add values for the additional columns
        w('      ''Gewijzigd'',' || chr(13));
        w('      sysdate,' || chr(13));
        w('      coalesce(regexp_substr(sys_context(''userenv'', ''client_identifier''), ''^[^:]*''), user)' ||chr(13));
        w('      );' || chr(13));

        w('      elsif deleting then' || chr(13));
        w('      insert into ' || lower(pi_table_name || '_audit') || chr(13) || '(' || chr(13));

        for x in (select lower(column_name) as col
                 from user_tab_columns
                 where table_name = upper(pi_table_name||'_audit')
                 order by column_id asc)
        loop
            w('      ' || x.col || lpad(' ', max_col_length - length(x.col)) || ',' || chr(13));
        end loop;

        -- Add additional columns for the audit table
        w('      ) values (' || chr(13));

        for x in (select lower(column_name) as col
                 from user_tab_columns
                 where table_name = upper(pi_table_name) and column_name !=  'ID'
                 order by column_id asc)
        loop
            w('      :old.' || x.col || lpad(' ', max_col_length - length(x.col)) || ',' || chr(13));
        end loop;

        -- Add values for the additional columns
        w('      ''Verwijderd'',' || chr(13));
        w('      sysdate,' || chr(13));
        w('      coalesce(regexp_substr(sys_context(''userenv'', ''client_identifier''), ''^[^:]*''), user)' ||chr(13));
        w('      );' || chr(13));
        w('      end if;' || chr(13));
        w('  end;' || chr(13));

        return lv_stmnt;
    end f_generate_audit_trigger;
    

end sta_audit;
