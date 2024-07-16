create or replace PACKAGE "AIT67_ONE_REPORT_MACRO" as
-- SQL Macro
--
-- updated to allow different schemas
function user_tab_col_macro(p_table_name    in  varchar2,
                            p_schema_name   in  varchar2 default sys_context('USERENV', 'CURRENT_USER')) return varchar2 SQL_MACRO;

end ait67_one_report_macro;
/