create or replace package body sta_journal_api
is
--global variables

    function f_get_journal_table_script(pi_table_name in varchar2) return clob
    is
    begin
        ;
    end f_get_journal_table_script;


end sta_journal_api;

/


select  *
from    all_columns
where   table_name = 'STA_ANNOUNCEMENT'
;

declare
begin
    dbms_output.put_line(sta_journal_api.f_get_journal_table_script('STA_ANNOUNCEMENT'));
end;