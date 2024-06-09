create table sta_user
(
    id                  number generated by default on null as identity
        constraint STA_USR_PK
        primary key,
    first_name          varchar2(80)          not null,
    last_name           varchar2(80)          not null,
    date_of_birth       date,
    address1            varchar2(100)         not null,
    address2            varchar2(100),
    phone_number1       varchar2(20),
    phone_number2       varchar2(20),
    remarks             varchar2(4000),
    email               varchar2(320),
    password            varchar2(64),
    salt                varchar2(64),
    deleted_flg         boolean default false not null,
    clss_id             number
        constraint sta_usr_clss_fk
            references sta_class,
    ctkr_id             number
        constraint sta_usr_usr_fk
            references sta_user,
    gender              varchar2(1)
        constraint sta_usr_chk1
            check (gender in ('M', 'F')),
    registration_year   varchar2(9),
    deregistration_year varchar2(9),
    origin_school       varchar2(80)
)
/
alter table sta_user add in_schoolyear varchar2(9);

