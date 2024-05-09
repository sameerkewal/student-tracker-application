create or replace package sta_journal_api
is
--global variables

    function f_get_journal_table_script(pi_table_name in varchar2) return clob;
    

end sta_journal_api;