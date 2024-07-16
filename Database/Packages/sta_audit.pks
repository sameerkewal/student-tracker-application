create or replace package sta_audit
is
    function f_generate_audit_table(pi_table_name in varchar2) return clob;

    function f_generate_audit_trigger(pi_table_name in varchar2) return clob;

end sta_audit;