create table sta_class
(
    id      number generated by default on null as identity
        constraint sta_clss_pk
            primary key,
    name    varchar2(20) not null,
    grde_id number       not null
        constraint sta_clss_grde_fk
            references sta_grade,
    usr_id  number       not null
        constraint sta_clss_tchr_fk
            references sta_user
)
/

comment on table sta_class is 'This table is used to store class information'
/

comment on column sta_class.usr_id is 'class gaurdian refers to the users table where the user is a teacher'
/
