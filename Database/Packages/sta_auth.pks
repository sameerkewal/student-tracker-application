create or replace package sta_auth
is
    -- procedure used to upsert privileges
    -- And couple the authorizations to the privileges
    procedure upsert_pve( pi_id          sta_privilege.id%type
                        , pi_name        sta_privilege.name%type
                        , pi_description sta_privilege.description%type
                        , pi_auths       varchar2
                        );

    procedure delete_pve( pi_id sta_privilege.id%type);

    -- procedure used to upsert authorizations
    -- Not used(but keeping just in case)
    procedure upsert_auth( pi_id                   sta_authorization.id%type
                       , pi_apex_component_type    sta_authorization.apex_component_type%type 
                       , pi_name                   sta_authorization.name%type
                       , pi_apex_component_name    sta_authorization.apex_component_name%type
                       , pi_apex_page              sta_authorization.apex_page%type
                    --    , pi_row_operation          sta_authorization.apex_page%type
                       );

    procedure delete_auth( pi_id sta_authorization.id%type);


    -- function used on page 28 to generate the name based on the chosen type, page, component name, row operation(if IG) and read only 
    function f_generate_authorization_name( pi_apex_component_type varchar2
                                          , pi_apex_component_name sta_authorization.apex_component_name%type
                                          , pi_apex_page           sta_authorization.apex_page%type
                                          , pi_row_operation       sta_authorization.row_operation%type
                                          , pi_read_only           sta_authorization.read_only%type
                                          )return sta_authorization.name%type;
  
    
    
end sta_auth;