create table sta_test
(
    id      number generated by default on null as identity
        constraint sta_tst_pk
            primary key,
    name    varchar2(80) not null,
    smsr_id number       not null
        constraint sta_tst_smsr_fk
            references sta_semester,
    grde_id number       not null
        constraint sta_tst_grde_fk
            references sta_grade,
    crse_id number       not null
        constraint sta_tst_crse_fk
            references sta_course
)
/
