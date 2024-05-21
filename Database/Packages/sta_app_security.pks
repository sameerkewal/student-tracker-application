create or replace package sta_app_security is
    function f_generate_salt return varchar2;
    function f_hash_password    ( pi_password sta_user.password%type, pi_salt sta_user.salt%type) return varchar2;
    function f_validate_password( pi_password sta_user.password%type, pi_salt sta_user.salt%type, pi_hashed_password varchar2) return boolean;
    function f_is_usr_authenticated( p_username sta_user.email%type, p_password sta_user.password%type) return boolean;

    -- Check if the password satisfies the following conditions:
    -- minimum of 8 characters long and max of 128 characters
    -- minimum 1 capital letter
    -- minimum 1 normal sized letter
    -- minimum 1 special character
    -- minimum 1 number(0-9)
    function f_password_chk( pi_password sta_user.password%type )return boolean;


    function f_generate_authorization_name( pi_apex_component_type varchar2
                                          , pi_apex_component_name sta_authorization.apex_component_name%type
                                          , pi_apex_page           sta_authorization.apex_page%type
                                          )return sta_authorization.name%type;



    --Authorisation function
    function f_is_component_authorized ( p_application_id in number
                                       , pi_apex_page_id        in number
                                       , p_component_type in varchar2
                                       , p_component_id   in number
                                       , pi_apex_component_name in sta_authorization.apex_component_name%type
                                       ) return boolean;



end sta_app_security;
/
