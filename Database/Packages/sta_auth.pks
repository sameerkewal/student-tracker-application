create or replace package sta_auth is
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
    function f_password_chk(pi_password sta_user.password%type)return boolean;
end sta_auth;
/
