create or replace package sta_auth
is
    -- procedure used to upsert privileges
    -- And couple the authorizations to the privileges
    procedure upsert_pve( pi_id          sta_privilege.id%type
                        , pi_name        sta_privilege.name%type
                        , pi_description sta_privilege.description%type
                        , pi_auths       varchar2
                        );

    -- procedure used to upsert authorizations
    procedure upsert_auths( pi_id               sta_authorization.id%type
                          , pi_name             sta_authorization.name%type
                          , apex_component_name sta_authorization.apex_component_name%type
                          , apex_page           sta_authorization.apex_page%type
                          );
    
end sta_auth;