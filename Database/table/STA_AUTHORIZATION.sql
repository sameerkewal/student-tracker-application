create table sta.sta_authorization
(
    id                  number      default "STA"."ISEQ$$_76819".nextval generated by default on null as identity
		constraint STA_AUTH_PK
			primary key,
    name                varchar2(100) not null,
    apex_component_name varchar2(200),
    apex_page           number,
    apex_component_type varchar2(200) not null,
    row_operation       varchar2(1),
    read_only           varchar2(1) default 'N',
    constraint sta_auth_uk1
        unique (apex_component_name, apex_page, read_only, row_operation)
)
/

alter table sta_authorization add constraint sta_auth_chk1 check (read_only in ('Y', 'N'));

