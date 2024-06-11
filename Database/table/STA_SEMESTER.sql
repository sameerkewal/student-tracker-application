create table sta.sta_semester
(
    id         number      default "STA"."ISEQ$$_76854".nextval generated by default on null as identity
		constraint STA_SMSR_PK
			primary key,
    name       varchar2(40)            not null,
    schoolyear varchar2(9)             not null,
    start_date date                    not null
        constraint sta_smsr_uk2
            unique,
    end_date   date                    not null
        constraint sta_smsr_uk3
            unique,
    active_ind varchar2(1) default 'N' not null
        constraint sta_smsr_chk2
            check (active_ind in ('Y', 'N')),
    constraint sta_smsr_uk1
        unique (start_date, end_date),
    constraint sta_smsr_chk1
        check (start_date < end_date)
)
/



