create table sta_role_privilege
(
    id     number generated by default on null as identity
        constraint sta_rle_pve_pk
            primary key,
    rle_id number not null
        constraint sta_rle_pve_rle_fk
            references sta_role,
    pve_id number not null
        constraint sta_rle_pve_pve_fk
            references sta_privilege,
    constraint sta_rle_pve_uk1
        unique (rle_id, pve_id)
)
/

