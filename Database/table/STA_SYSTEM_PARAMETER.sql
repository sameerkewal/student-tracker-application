create table sta_system_parameter
(
    id        number  default "STA"."ISEQ$$_92613".nextval generated by default on null as identity
        constraint STA_SYPA_PK
        primary key,
    parameter varchar2(80)         not null,
    value     varchar2(100)        not null,
    show_ind  boolean default true not null
)
/
