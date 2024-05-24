create or replace view sta_vw_user_authentication
as
    select usr.id                   as usr_id
    ,      usr.email                as usr_email
    ,      rle.id                   as rle_id
    ,      rle.name                 as rle_name
    ,      pve.id                   as pve_id 
    ,      pve.name                 as pve_name
    ,      auth.id                  as auth_id
    ,      auth.name                as auth_name
    ,      auth.apex_component_type as auth_apex_component_type
    ,      auth.apex_page           as auth_apex_page
    ,      auth.apex_component_name as auth_apex_component_name
    ,      auth.row_operation       as auth_row_operation
    ,      auth.read_only           as auth_read_only
    from   sta_user                     usr
    join   sta_user_role                usr_rle  on usr_rle.usr_id  = usr.id
    join   sta_role                     rle      on rle.id          = usr_rle.rle_id
    join   sta_role_privilege           rle_pve  on rle_pve.rle_id  = rle.id
    join   sta_privilege                pve      on rle_pve.pve_id  = pve.id
    join   sta_authorization_privilege  auth_pve on auth_pve.pve_id = pve.id
    join   sta_authorization            auth     on auth.id         = auth_pve.auth_id
    where  usr.deleted_flg = false
;


