create table sta_user_role
(
    id     number generated by default on null as identity
        constraint sta_usr_rle_pk
            primary key,
    usr_id number not null
        constraint sta_usr_rle_usr_fk
            references sta_user,
    rle_id number not null
        constraint sta_usr_rle_rle_fk
            references sta_role
)
/

alter table sta_user_role add constraint sta_usr_rle_uk1 unique (usr_id, rle_id);