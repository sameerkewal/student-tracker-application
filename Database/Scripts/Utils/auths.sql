select true;
select 1 from dual;
/
begin
if STA_APP_SECURITY.F_IS_COMPONENT_AUTHORIZED( pi_application_id      => null
                                                 , pi_email               => 'sameerkewal1@gmail.com'
                                                 , pi_apex_page_id        => null
                                                 , p_component_type       => null
                                                 , pi_component_id        => null
                                                 , pi_apex_component_name => 'Announcements'
                                                ) then
    dbms_output.put_line('Authorized');
else
    dbms_output.put_line('Not Authorized');
end if;
end;

/


select  *
from    APEX_APPLICATION_ALL_AUTH
where   AUTHORIZATION_SCHEME = 'Component Authorization'
and page_id = 7;



select  *
from    sta_privilege;

select page_id, page_name, region_name
from apex_appl_page_igs;


select  page_id || ': ' || region_name as d
             ,       region_name
             from    apex_appl_page_igs;



select  *
from    STA_VW_USER_AUTHENTICATION
;

commit;


      select 1
      from   sta_vw_user_authentication usr_auth
      where  lower(usr_auth.usr_email)                        = lower('LEERKRACHTE@GMAIL.COM')
      and    coalesce(usr_auth.auth_apex_page, 0)             = coalesce(null, usr_auth.auth_apex_page, 0)
      and    coalesce(usr_auth.auth_apex_component_name, 'x') = coalesce('Administratie', usr_auth.auth_apex_component_name, 'x')
      and    coalesce(null, true)                            = true
      and    coalesce(null, true)                            = true
      ;



begin'Page 25: Role Privilege Overview'
    return sta_app_security.f_is_component_authorized( pi_application_id      => :APP_ID
                                                 , pi_email               => :APP_USER
                                                 , pi_apex_page_id        => null
                                                 , p_component_type       => :APP_COMPONENT_TYPE
                                                 , pi_component_id        => :APP_COMPONENT_ID
                                                 , pi_apex_component_name => :APP_COMPONENT_NAME
);
end;
/

LeerkrachtE1!

select * from APEX_APPLICATION_LIST_ENTRIES;
select  *
from    STA_AUTHORIZATION
;



select name as d
     , id as r
from   sta_authorization
where  lower(name) like '%' || lower(nvl(:P27_SEARCH_AUTH, '')) || '%'
   or  :P27_SEARCH_AUTH is null;



select name as d
     , id as r
from   sta_authorization



--Find duplicate rows

SELECT apex_component_name, apex_page, read_only, row_operation, COUNT(*)
FROM sta_authorization
GROUP BY apex_component_name, apex_page, read_only, row_operation
HAVING COUNT(*) > 1;


delete from sta_authorization
where  id = 135;

commit;

update sta_authorization
set read_only = false
;
/
BEGIN
 if sta_app_security.f_is_component_authorized ( pi_application_id      => 101
                                           , pi_email               => 'LEERKRACHTE@GMAIL.COM'
                                           , pi_apex_page_id        => 14 
                                           , p_component_type       => null
                                           , pi_component_id        => null
                                           , pi_apex_component_name => null
                                           , pi_read_only           => false 
                                            )then 
    dbms_output.put_line('Authorized');

else
    dbms_output.put_line('Not Authorized');
end if;
end;                                                
/


      select 1
      from   sta_vw_user_authentication usr_auth
      where  lower(usr_auth.usr_email)                        = lower('LEERKRACHTE@GMAIL.COM')
      and    coalesce(usr_auth.auth_apex_page, 0)             = coalesce(14, usr_auth.auth_apex_page, 0)
      and    coalesce(usr_auth.auth_apex_component_name, 'x') = coalesce(null, usr_auth.auth_apex_component_name, 'x')
      and    coalesce(usr_auth.auth_read_only, false)         = coalesce(true, usr_auth.auth_read_only, false);


      select 1
      from   sta_vw_user_authentication usr_auth
      where  lower(usr_auth.usr_email)                        = lower('ADMIN@GMAIL.COM')
      and    coalesce(usr_auth.auth_apex_page, 0)             = coalesce(14, usr_auth.auth_apex_page, 0)
      and    coalesce(usr_auth.auth_apex_component_name, 'x') = coalesce(null, usr_auth.auth_apex_component_name, 'x')
      and    coalesce(usr_auth.auth_read_only, false)         = coalesce(true, usr_auth.auth_read_only, false);


           select *
      from   sta_vw_user_authentication usr_auth
      where  lower(usr_auth.usr_email)                        = lower('LEERKRACHTE@GMAIL.COM')
      and    coalesce(usr_auth.auth_apex_page, 0)             = coalesce(14, usr_auth.auth_apex_page, 0)
      and    coalesce(usr_auth.auth_apex_component_name, 'x') = coalesce(null, usr_auth.auth_apex_component_name, 'x')
      ;


      
select  *
from    sta_authorization
where   apex_page = 14
;


select sta_rle.f_get_rle_id(pi_name => 'admin');




select  *
from    sta_user_role
where   id = 281;