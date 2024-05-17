create table sta_authorization
(
    id                  number generated by default on null as identity
        constraint sta_auth_pk
            primary key,
    name                varchar2(100) not null,
    apex_component_name varchar2(200),
    apex_page           number,
    constraint sta_auth_uk1
        unique (apex_component_name, apex_page)
)
/

