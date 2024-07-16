create or replace PACKAGE "AIT67_ONE_REPORT" as
-- Note: this package is dependent upon the package ait67_one_report_macro
-- Updated for multiple schemas
--
--
function get_query( p_table_name    in varchar2,
                    p_schema_name   in  varchar2 default sys_context('USERENV', 'CURRENT_USER')
                    ) return clob;
--
-- used for classic reports
function get_headers(p_table_name   in varchar2,
                     p_pretty_yn    in varchar2 default 'Y',
                     p_schema_name  in  varchar2 default sys_context('USERENV', 'CURRENT_USER')) return varchar2;
--
--
function show_column(   p_table_name        in varchar2,
                        p_column_number     in number,
                        p_schema_name   in  varchar2 default sys_context('USERENV', 'CURRENT_USER')) return boolean;
--
-- used for Interactive Reports
procedure set_IR_columns_headers(   p_table_name        in varchar2,
                                    p_base_item_name    in varchar2,
                                    p_pretty_yn         in varchar2 default 'Y',
                                    p_schema_name   in  varchar2 default sys_context('USERENV', 'CURRENT_USER')) ;
end ait67_one_report;
/